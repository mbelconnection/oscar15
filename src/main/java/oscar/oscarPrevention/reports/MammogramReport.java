/*
 *  Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. 
 *  This software is published under the GPL GNU General Public License.
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version. 
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details. 
 * You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. 
 *
 *  Jason Gallagher
 *
 *  This software was written for the
 *  Department of Family Medicine
 *  McMaster University
 *  Hamilton
 *  Ontario, Canada   
 *
 * MammogramReport.java
 *
 * Created on September 11, 2006, 4:00 PM
 *
 */

package oscar.oscarPrevention.reports;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Hashtable;
import java.util.Map;

import org.apache.log4j.Logger;
import org.oscarehr.util.MiscUtils;

import oscar.oscarEncounter.oscarMeasurements.bean.EctMeasurementsDataBean;
import oscar.oscarEncounter.oscarMeasurements.bean.EctMeasurementsDataBeanHandler;
import oscar.oscarPrevention.PreventionData;
import oscar.oscarPrevention.pageUtil.PreventionReportDisplay;
import oscar.util.UtilDateUtilities;

/**
 *
 * @author jay
 */
public class MammogramReport implements PreventionReport{
    private static Logger log = MiscUtils.getLogger();
    /** Creates a new instance of MammogramReport */
    public MammogramReport() {
    }
    
    public Hashtable runReport(ArrayList list,Date asofDate){
        int inList = 0;
        double done= 0,doneWithGrace = 0;
        ArrayList returnReport = new ArrayList();
        
        for (int i = 0; i < list.size(); i ++){//for each  element in arraylist 
             ArrayList fieldList = (ArrayList) list.get(i);       
             String demo = (String) fieldList.get(0);  

             //search   prevention_date prevention_type  deleted   refused 
             ArrayList<Map<String,Object>>  prevs = PreventionData.getPreventionData("MAM",demo); 
             ArrayList<Map<String,Object>> noFutureItems =  removeFutureItems(prevs, asofDate);
             PreventionReportDisplay prd = new PreventionReportDisplay();
             prd.demographicNo = demo;
             prd.bonusStatus = "N";
             prd.billStatus = "N";
             Date prevDate = null;
             if(ineligible(prevs)){
                prd.rank = 5;
                prd.lastDate = "------"; 
                prd.state = "Ineligible"; 
                prd.numMonths = "------";
                prd.color = "grey";
                inList++;
             }else if (noFutureItems.size() == 0){// no info
                prd.rank = 1;
                prd.lastDate = "------";
                prd.state = "No Info";                
                prd.numMonths = "------";
                prd.color = "Magenta";
             } else{
            	 Map<String,Object> h =  noFutureItems.get(noFutureItems.size()-1);
                DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                String prevDateStr = (String) h.get("prevention_date");
                
                try{
                   prevDate = formatter.parse(prevDateStr);
                }catch (Exception e){}
                boolean refused = false;
                if ( h.get("refused") != null && ((String) h.get("refused")).equals("1")){
                   refused = true;
                }
                
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.YEAR, -2);
                Date dueDate = cal.getTime();                
                cal.add(Calendar.MONTH,-6);
                Date cutoffDate = cal.getTime();
                
                Calendar cal2 = GregorianCalendar.getInstance();
                cal2.add(Calendar.YEAR, -2);
                Date dueDate2 = cal.getTime();
                //cal2.roll(Calendar.YEAR, -1);
                cal2.add(Calendar.MONTH,-6);
                Date cutoffDate2 = cal2.getTime();
                
                log.debug("cut 1 "+cutoffDate.toString()+ " cut 2 "+cutoffDate2.toString());
               
                // if prevDate is less than as of date and greater than 2 years prior 
                Calendar bonusEl = Calendar.getInstance();
                bonusEl.setTime(asofDate);                
                //bonusEl.add(Calendar.YEAR,-2);
                bonusEl.add(Calendar.MONTH,-30);
                Date bonusStartDate = bonusEl.getTime();
                
                log.debug("\n\n\n prevDate "+prevDate);
                log.debug("bonusEl date "+bonusStartDate+ " "+bonusEl.after(prevDate));
                log.debug("asofDate date"+asofDate+" "+asofDate.after(prevDate));
                String result = PreventionData.getExtValue((String)h.get("id"), "result");

                if (!refused && bonusStartDate.before(prevDate) && asofDate.after(prevDate) && !result.equalsIgnoreCase("pending")){
                   prd.bonusStatus = "Y";
                   prd.billStatus = "Y";
                   done++;
                }
                
                //Calendar today = Calendar.getInstance(); 
                //change as of date to run the report for a different year
                String numMonths = "------";
                if ( prevDate != null){
                   int num = UtilDateUtilities.getNumMonths(prevDate,asofDate);
                   numMonths = ""+num+" months";
                }
                
                
                //outcomes        
                log.debug("due Date "+dueDate.toString()+" cutoffDate "+cutoffDate.toString()+" prevDate "+prevDate.toString());
                log.debug("due Date  ("+dueDate.toString()+" ) After Prev ("+prevDate.toString() +" ) "+dueDate.after(prevDate));
                log.debug("cutoff Date  ("+cutoffDate.toString()+" ) before Prev ("+prevDate.toString() +" ) "+cutoffDate.before(prevDate));
                if (!refused && dueDate.after(prevDate) && cutoffDate.before(prevDate)){ // overdue
                   prd.rank = 2;
                   prd.lastDate = prevDateStr;                
                   prd.state = "due";
                   prd.numMonths = numMonths;
                   prd.color = "yellow"; //FF00FF
                   if(!prd.bonusStatus.equals("Y")){
                       prd.billStatus = "Y";
                      doneWithGrace++;
                   }
                   
                } else if (!refused && cutoffDate.after(prevDate)){ // overdue
                   prd.rank = 2;
                   prd.lastDate = prevDateStr;                
                   prd.state = "Overdue";
                   prd.numMonths = numMonths;
                   prd.color = "red"; //FF00FF
                   
                } else if (refused){  // recorded and refused
                   prd.rank = 3;
                   prd.lastDate = "-----";
                   prd.state = "Refused";
                   prd.numMonths = numMonths;
                   prd.color = "orange"; //FF9933
                   
                } else if( dueDate.before(prevDate) && result.equalsIgnoreCase("pending") ) {
                    prd.rank = 4;
                    prd.lastDate = prevDateStr;
                    prd.state = "Pending";
                    prd.numMonths = numMonths;
                    prd.color = "pink";

                }else if (dueDate.before(prevDate)  ){  // recorded done
                   prd.rank = 4;
                   prd.lastDate = prevDateStr;                
                   prd.state = "Up to date";
                   prd.numMonths = numMonths;
                   prd.color = "green";
                   //done++;
                }
             }
             letterProcessing( prd,"MAMF",asofDate,prevDate);
             returnReport.add(prd);
             
          }
          String percentStr = "0";
          String percentWithGraceStr = "0";
          double eligible = list.size() - inList;
          log.debug("eligible "+eligible+" done "+done);
          if (eligible != 0){
             double percentage = ( done / eligible ) * 100;
             double percentageWithGrace =  (done+doneWithGrace) / eligible  * 100 ;
             log.debug("in percentage  "+percentage   +" "+( done / eligible));
             percentStr = ""+Math.round(percentage); 
             percentWithGraceStr = ""+Math.round(percentageWithGrace);
          }
          
          Collections.sort(returnReport);
          
          Hashtable h = new Hashtable();
          
          h.put("up2date",""+Math.round(done));
          h.put("percent",percentStr);
          h.put("percentWithGrace",percentWithGraceStr);
          h.put("returnReport",returnReport);
          h.put("inEligible", ""+inList);
          h.put("eformSearch","Mam");
          h.put("followUpType","MAMF");
          h.put("BillCode", "Q002A");
          log.debug("set returnReport "+returnReport);
          return h;
    }
          
    boolean ineligible(Map<String,Object> h){
       boolean ret =false;
       if ( h.get("refused") != null && ((String) h.get("refused")).equals("2")){
          ret = true;
       }
       return ret;
   }
    
    boolean ineligible(ArrayList<Map<String,Object>> list){
       for (int i =0; i < list.size(); i ++){
    	   Map<String,Object> h = list.get(i);
           if (ineligible(h)){
               return true;
           }
       }
       return false;
   } 
    
   private ArrayList<Map<String,Object>> removeFutureItems(ArrayList<Map<String,Object>> list,Date asOfDate){
       ArrayList<Map<String,Object>> noFutureItems = new ArrayList<Map<String,Object>>();
       DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
       for (int i =0; i < list.size(); i ++){
    	   Map<String,Object> h = list.get(i);       
            String prevDateStr = (String) h.get("prevention_date");
            Date prevDate = null;
            try{
                prevDate = formatter.parse(prevDateStr);
            }catch (Exception e){}

            if (prevDate != null && prevDate.before(asOfDate)){
               noFutureItems.add(h);
            }
       }
       return noFutureItems;
   }
    
   //TODO: THIS MAY NEED TO BE REFACTORED AT SOME POINT IF MAM and PAP are exactly the same  
   //If they don't have a MAM Test with guidelines
                //Get last contact method?
                    //NO contact
                        //Send letter
                    //Was it in longer than a year ago
                        //NO
                            //Send Letter 1
                        //YES
                              //Was it atleast 3months ago?
                                    //WAS is L1
                                        //SEnd L2
                                    //Was is L2
                                        //P1
    
   //Measurement Type will be 1 per Prevention report, with the dataField holding method ie L1, L2, P1 (letter 1 , letter 2, phone call 1) 
   String LETTER1 = "L1";
   String LETTER2 = "L2";
   String PHONE1 = "P1";
   String CALLFU = "Follow Up";
  
   private String letterProcessing(PreventionReportDisplay prd,String measurementType,Date asofDate,Date prevDate){
       if (prd != null){
          boolean inclUpToDate = false;
          if( prd.state.equals("Up to date") ) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(asofDate);
            cal.add(Calendar.YEAR, -2);
            Date dueDate = cal.getTime();
            cal.add(Calendar.MONTH,-6);
            Date cutoffDate = cal.getTime();

            if( (dueDate.after(prevDate) && cutoffDate.before(prevDate)) || cutoffDate.after(prevDate) ) {
                inclUpToDate = true;
            }
          }
          if (prd.state.equals("No Info") || prd.state.equals("due") || prd.state.equals("Overdue") || inclUpToDate){
              // Get LAST contact method
              EctMeasurementsDataBeanHandler measurementDataHandler = new EctMeasurementsDataBeanHandler(prd.demographicNo,measurementType);
              log.debug("getting followup data for "+prd.demographicNo);
              
              Collection followupData = measurementDataHandler.getMeasurementsDataVector();
              //NO Contact

              if ( followupData.size() == 0 ){
                  prd.nextSuggestedProcedure = this.LETTER1;
                  return this.LETTER1;
              }else{ //There has been contact
                  EctMeasurementsDataBean measurementData = (EctMeasurementsDataBean) followupData.iterator().next();
                  log.debug("fluData "+measurementData.getDataField());
                  log.debug("lastFollowup "+measurementData.getDateObservedAsDate()+ " last procedure "+measurementData.getDateObservedAsDate());     
                  log.debug("toString: "+measurementData.toString());
                  prd.lastFollowup = measurementData.getDateObservedAsDate();
                  prd.lastFollupProcedure = measurementData.getDataField();
                  
                  
                  Calendar oneyear = Calendar.getInstance();
                  oneyear.setTime(asofDate);                
                  oneyear.add(Calendar.YEAR,-1);
                  
                  if ( measurementData.getDateObservedAsDate().before(oneyear.getTime())){
                      prd.nextSuggestedProcedure = this.LETTER1;
                      return this.LETTER1;
                  }else{ //AFTER CUTOFF DATE
                      
                      Calendar threemonth = Calendar.getInstance();
                      threemonth.setTime(asofDate);                
                      threemonth.add(Calendar.MONTH,-1);
                          if ( measurementData.getDateObservedAsDate().before(threemonth.getTime())){
                              if (prd.lastFollupProcedure.equals(this.LETTER1)){
                                    prd.nextSuggestedProcedure = this.LETTER2;
                                    return this.LETTER2;
                              }else if(prd.lastFollupProcedure.equals(this.LETTER2)){
                                    prd.nextSuggestedProcedure = this.PHONE1;
                                    return this.PHONE1;
                              }else{
                                  prd.nextSuggestedProcedure = "----";
                                  return "----";
                              }
                          
                          }else if(prd.lastFollupProcedure.equals(this.LETTER2)){
                              prd.nextSuggestedProcedure = this.PHONE1;
                              return this.PHONE1;
                          }else{
                              prd.nextSuggestedProcedure = "----";
                              return "----";
                          }
                  }


                  
              }
          
          
          
          
          }else if (prd.state.equals("Refused")){  //Not sure what to do about refused
              EctMeasurementsDataBeanHandler measurementDataHandler = new EctMeasurementsDataBeanHandler(prd.demographicNo,measurementType);
              log.debug("getting followup data for "+prd.demographicNo);
              Collection followupData = measurementDataHandler.getMeasurementsDataVector();

              if ( followupData.size() > 0 ){
                  EctMeasurementsDataBean measurementData = (EctMeasurementsDataBean) followupData.iterator().next();
                  prd.lastFollowup = measurementData.getDateObservedAsDate();
                  prd.lastFollupProcedure = measurementData.getDataField();
              }
              prd.nextSuggestedProcedure = "----";
                //prd.numMonths ;
          }else if(prd.state.equals("Ineligible")){
                // Do nothing   
                prd.nextSuggestedProcedure = "----";
          }else if(prd.state.equals("Pending")){
                prd.nextSuggestedProcedure = this.CALLFU;
          }else if(prd.state.equals("Up to date")){
                //Do nothing
              EctMeasurementsDataBeanHandler measurementDataHandler = new EctMeasurementsDataBeanHandler(prd.demographicNo,measurementType);
              log.debug("getting followup data for "+prd.demographicNo);
              Collection followupData = measurementDataHandler.getMeasurementsDataVector();

              if ( followupData.size() > 0 ){
                  EctMeasurementsDataBean measurementData = (EctMeasurementsDataBean) followupData.iterator().next();
                  prd.lastFollowup = measurementData.getDateObservedAsDate();
                  prd.lastFollupProcedure = measurementData.getDataField();
              }
              prd.nextSuggestedProcedure = "----";
          }else{
               log.debug("NOT SURE WHAT HAPPEND IN THE LETTER PROCESSING");
          }
       }
       return null;         
   }
    
}





//                  Calendar today = Calendar.getInstance();
//                  today.setTime(asofDate); 
//                  int num = UtilDateUtilities.getNumMonths(measurementData.getDateObservedAsDate(),today.getTime());
//                  if (num > 12){
//                        prd.nextSuggestedProcedure = this.LETTER1;
//                        return this.LETTER1;
//                  }else{ //AFTER CUTOFF DATE    
//                      if ( num > 3 ){
//                          if (prd.lastFollupProcedure.equals(this.LETTER1)){
//                                prd.nextSuggestedProcedure = this.LETTER2;
//                                return this.LETTER2;
//                          }else if(prd.lastFollupProcedure.equals(this.LETTER1)){
//                                prd.nextSuggestedProcedure = this.PHONE1;
//                                return this.PHONE1;
//                          }else{
//                              prd.nextSuggestedProcedure = "----";
//                              return "----";
//                          }
//                          
//                        }
//                  }