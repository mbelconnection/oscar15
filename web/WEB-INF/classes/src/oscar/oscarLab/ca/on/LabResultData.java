/**
 *  Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
 *  This software is published under the GPL GNU General Public License.
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version. *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details. * * You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *
 *
 *  Jason Gallagher
 *
 *  This software was written for the
 *  Department of Family Medicine
 *  McMaster University
 *  Hamilton
 *  Ontario, Canada   Creates a new instance of LabResultData
 *
 * LabResultData.java
 *
 * Created on April 21, 2005, 4:31 PM
 */

package oscar.oscarLab.ca.on;

import java.sql.ResultSet;
import java.util.Comparator;
import java.util.Date;

import org.apache.log4j.Logger;

import oscar.oscarDB.DBHandler;
import oscar.oscarLab.ca.bc.PathNet.PathnetResultsData;
import oscar.oscarLab.ca.on.CML.CMLLabTest;
import oscar.util.UtilDateUtilities;


/**
 *
 * @author Jay Gallagher
 */
public class LabResultData implements Comparable{
    
    Logger logger = Logger.getLogger(LabResultData.class );
    
    public static String CML = "CML";
    public static String MDS = "MDS";
    public static String EXCELLERIS = "BCP"; //EXCELLERIS
    public static String DOCUMENT = "DOC"; //INTERNAL DOCUMENT
    
    //HL7TEXT handles all messages types recieved as a hl7 formatted string
    public static String HL7TEXT = "HL7";
    
    public String segmentID;
    public String labPatientId;
    public String acknowledgedStatus;
    
    public String accessionNumber;
    public String healthNumber;
    public String patientName;
    public String sex;
    public String resultStatus;
    public int finalResultsCount = 0;
    public String dateTime;
    private Date dateTimeObr;
    public String priority;
    public String requestingClient;
    public String discipline;
    public String reportStatus;
    public boolean abn = false;
    public String labType; // ie CML or MDS
    public boolean finalRes = true;
    public boolean isMatchedToPatient = true;
    public String multiLabId;
    
    public LabResultData() {
    }
    
    public LabResultData(String labT) {
        if (CML.equals(labT)){
            labType = CML;
        }else if (MDS.equals(labT)){
            labType = MDS;
        }else if (EXCELLERIS.equals(labT)){
            labType = EXCELLERIS;
        }else if (HL7TEXT.equals(labT)){
            labType = HL7TEXT;
        }
        
    }
    
    
    public boolean isAbnormal(){
        if (EXCELLERIS.equals(this.labType)){
            PathnetResultsData prd = new PathnetResultsData();
            if (prd.findPathnetAdnormalResults(this.segmentID) > 0){
                this.abn= true;
            }
        }else if(CML.equals(this.labType)){
            CMLLabTest cml = new CMLLabTest();
            if (cml.findCMLAdnormalResults(this.segmentID) > 0){
                this.abn= true;
            }
        }
        
        return abn ;
        
        
    }
    
    
    public boolean isFinal(){ return finalRes ;}
    
    public boolean isMDS(){
        boolean ret = false;
        if (MDS.equals(labType)){ ret = true; }
        return ret;
    }
    
    public boolean isCML(){
        boolean ret = false;
        if (CML.equals(labType)){ ret = true; }
        return ret;
    }
    
    public boolean isHL7TEXT(){
        boolean ret = false;
        if (HL7TEXT.equals(labType)){ ret = true; }
        return ret;
    }
    
    public boolean isDocument(){
        boolean ret = false;
        if (DOCUMENT.equals(labType)){ ret = true; }
        return ret;
    }
    
    ////
    
    public static boolean isMDS(String type){
        boolean ret = false;
        if (MDS.equals(type)){ ret = true; }
        return ret;
    }
    
    public static boolean isCML(String type){
        boolean ret = false;
        if (CML.equals(type)){ ret = true; }
        return ret;
    }
    
    public static boolean isHL7TEXT(String type){
        boolean ret = false;
        if (HL7TEXT.equals(type)){ ret = true; }
        return ret;
    }
    
    public static boolean isDocument(String type){
        boolean ret = false;
        if (DOCUMENT.equals(type)){ ret = true; }
        return ret;
    }
    
    
    
    
    public String getDiscipline(){
        if (CML.equals(this.labType)){
            CMLLabTest cml = new CMLLabTest();
            this.discipline = cml.getDiscipline(this.segmentID);
        }else if (EXCELLERIS.equals(this.labType)){
            PathnetResultsData prd = new PathnetResultsData();
            this.discipline = prd.findPathnetDisipline(this.segmentID);
        }
        
        return this.discipline;
    }
    
    public String getPatientName(){
        return this.patientName;
    }
    
    public String getHealthNumber(){
        return this.healthNumber;
    }
    
    public String getSex(){
        return this.sex;
    }
    
    public boolean isMatchedToPatient(){
//       if (EXCELLERIS.equals(this.labType)){
//          PathnetResultsData prd = new PathnetResultsData();
//          this.isMatchedToPatient = prd.isLabLinkedWithPatient(this.segmentID);
//       }
        CommonLabResultData commonLabResultData = new CommonLabResultData();
        this.isMatchedToPatient = commonLabResultData.isLabLinkedWithPatient(this.segmentID,this.labType);
        return this.isMatchedToPatient;
    }
    
    
    public String getDateTime(){
       /* if (EXCELLERIS.equals(this.labType)){
            PathnetResultsData prd = new PathnetResultsData();
            this.dateTime = prd.findPathnetObservationDate(this.segmentID);
        }*/
        return this.dateTime;
    }
    
    public int getAckCount(){
        CommonLabResultData data = new CommonLabResultData();
        return data.getAckCount(this.segmentID, this.labType);
    }
    
    public int getMultipleAckCount(){
        //String[] multiId = this.multiLabId.split(",");
        CommonLabResultData data = new CommonLabResultData();
        String[] multiId = data.getMatchingLabs(this.segmentID, this.labType).split(",");
        int count = 0;
        if (multiId.length == 1){
            count = -1;
        }else{
            for (int i=0; i < multiId.length; i++){
                count = count + data.getAckCount(multiId[i], this.labType);
            }
        }
        return count;
    }
    
    
    public String getReportStatus(){
       /* if (EXCELLERIS.equals(this.labType)){
            PathnetResultsData prd = new PathnetResultsData();
            this.reportStatus = prd.findPathnetStatus(this.segmentID);
        }*/
        return this.reportStatus;
    }
    
    public String getPriority(){
        return this.priority;
    }
    
    
    
    public String getRequestingClient(){
        /*if (EXCELLERIS.equals(this.labType)){
            PathnetResultsData prd = new PathnetResultsData();
            this.requestingClient = prd.findPathnetOrderingProvider(this.segmentID);
        }*/
        return this.requestingClient;
    }
    
    public Date getDateObj(){
        if (EXCELLERIS.equals(this.labType)){
            this.dateTimeObr = UtilDateUtilities.getDateFromString(this.getDateTime(), "yyyy-MM-dd HH:mm:ss");
        }else if(HL7TEXT.equals(this.labType)){
            this.dateTimeObr = UtilDateUtilities.getDateFromString(this.getDateTime(), "yyyy-MM-dd HH:mm:ss");
        }else if(CML.equals(this.labType)){
            String date="";
            String sql = "select print_date, print_time from labReportInformation, labPatientPhysicianInfo where labPatientPhysicianInfo.id = '"+this.segmentID+"' and labReportInformation.id = labPatientPhysicianInfo.labReportInfo_id ";
            try{
                DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
                ResultSet rs = db.GetSQL(sql);
                if(rs.next()){
                    date=db.getString(rs,"print_date")+db.getString(rs,"print_time");
                }
                rs.close();
            }catch(Exception e){
                logger.error("Error in getDateObj (CML message)", e);
            }
            this.dateTimeObr = UtilDateUtilities.getDateFromString(date, "yyyyMMddHH:mm");
        }
        
        return this.dateTimeObr;
    }
    
    public void setDateObj(Date d){
        this.dateTimeObr = d;
    }
    
    public int compareTo(Object object) {
        //int ret = 1;
        int ret = 0;
        if (this.getDateObj() != null){
            if (this.dateTimeObr.after( ((LabResultData) object).getDateObj() )){
                ret = -1;
            }else if(this.dateTimeObr.before( ((LabResultData) object).getDateObj() )){
                ret = 1;
            }else if(this.finalResultsCount > ((LabResultData) object).finalResultsCount){
                ret = -1;
            }else if(this.finalResultsCount < ((LabResultData) object).finalResultsCount){
                ret = 1;
            }
        }
        return ret;
    }
    
    public CompareId getComparatorId() {
        return new CompareId();
    }
    
    
    public class CompareId implements Comparator {
        
        public int compare( Object o1, Object o2 ) {
            LabResultData lab1 = (LabResultData)o1;
            LabResultData lab2 = (LabResultData)o2;
            
            int labPatientId1 = Integer.parseInt(lab1.labPatientId);
            int labPatientId2 = Integer.parseInt(lab2.labPatientId);
            
            if( labPatientId1 < labPatientId2 )
                return -1;
            else if( labPatientId1 > labPatientId2 )
                return 1;
            else
                return 0;
        }
    }
    
    
}



