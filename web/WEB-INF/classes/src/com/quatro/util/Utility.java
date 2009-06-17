/*******************************************************************************
 * Copyright (c) 2005, 2009 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU General Public License
 * which accompanies this distribution, and is available at
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Contributors:
 *     <Quatro Group Software Systems inc.>  <OSCAR Team>
 *******************************************************************************/
package com.quatro.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.SimpleTimeZone;
import java.util.TimeZone;

import org.oscarehr.PMmodule.model.FieldDefinition;

import oscar.OscarProperties;


public class Utility {
    public static boolean IsEmpty(String pStr)
    {
        if (pStr == null || pStr.trim().equals(""))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public static boolean IsDate(String pStr)
    {
    	java.sql.Date date = oscar.MyDateFormat.getSysDate(pStr);
    	return date != null;
    }
    public static boolean IsNUmber(String pStr)
    {
    	boolean isDouble = true;
    	try 
    	{
    		Double d = Double.valueOf(pStr);
    	}
    	catch (Exception e)
    	{
    		isDouble = false;
    	}
    	return isDouble;
    }
    public static boolean IsInt(String pStr)
    {
    	boolean isInt = true;
    	try 
    	{
    		Integer i = Integer.valueOf(pStr);
    		isInt = (i != null);
    	}
    	catch (Exception e)
    	{
    		isInt = false;
    	}
    	return isInt;
    }
    public static boolean IsIntBiggerThanZero(String pStr)
    {
    	boolean isInt = true;
    	try 
    	{
    		Integer i = Integer.valueOf(pStr);
    		isInt = (i != null);
    		if(i.intValue()<=0) isInt=false;
    	}
    	catch (Exception e)
    	{
    		isInt = false;
    	}
    	return isInt;
    }
    public static boolean IsIntLessThanZero(String pStr)
    {
    	boolean isInt = true;
    	try 
    	{
    		Integer i = Integer.valueOf(pStr);
    		isInt = (i != null);
    		if(i.intValue()>=0) isInt=false;
    	}
    	catch (Exception e)
    	{
    		isInt = false;
    	}
    	return isInt;
    }
    // Convert display date to System format
    // date format 1 - yyyy/mm/dd
    //             2 - dd/mm/yyyy
    //             3 - mm/dd/yyyy
    
    public static Date GetSysDate(String pDate) throws Exception
    {
        Date date;
        String sTemp1, sTemp2;
        String format = "YYYY/MM/DD";
        int day = 31;
        int month = 12;
        int year = 2999;
        
        if (IsEmpty(pDate)){
          try{
           	  return SetDate(year, month, day);
          }catch(Exception ex){ return null;}    
        }
        
        String delim = "/";

        if ("TODAY".equals(pDate.toUpperCase()))
        {
            return new Date();
        }
        else
        {
            try
            {
                int idx = pDate.indexOf(delim);
                int dt1 = Integer.parseInt(pDate.substring(0, idx));
                sTemp1 = pDate.substring(idx + 1);
                idx = sTemp1.indexOf(delim);
                int dt2 = Integer.parseInt(sTemp1.substring(0, idx))-1;

                sTemp2 = sTemp1.substring(idx + 1);
                int dt3 = Integer.parseInt(sTemp2);

                switch(OscarProperties.getInstance().getDateFormat())
                {
                	case 1:
                		format = "YYYY/MM/DD";
                		day = dt3;
                		month = dt2;
                		year = dt1;
                		break;
                	case 2:
                		format = "DD/MM/YYYY";
                		day = dt1;
                		month = dt2;
                		year = dt3;
                		break;
                	case 3:
                		format="MM/DD/YYYYY";
                		day = dt2;
                		month = dt1;
                		year = dt3;
                		break;
                	default:
                		format = "YYYY/MM/DD";
                		day = dt3;
            			month = dt2;
            			year = dt1;
            			break;
                }
                date = SetDate(year, month, day);
                return date;
            }
            catch(Exception ex)
            {
                throw new Exception("Invalid Date (" + format + ")");
            }
        }
    }
    
    public static Date SetDate(int year, int month, int day) throws Exception
    {
	   Calendar c1 = Calendar.getInstance();
	   c1.set(year, month , day);
	   return c1.getTime();
    }
    // Convert dd/mm/yyyy to System format
    public static Date GetSysDateMin(String pDate) throws Exception
    {
        if (IsEmpty(pDate)){
			Calendar c1 = Calendar.getInstance();
			c1.set(1900, 1 , 1);
			return c1.getTime();
        }

        if ("TODAY".equals(pDate.toUpperCase())) return new Date();

        try
        {
            int day = Integer.parseInt(pDate.substring(0, 2));
            int month = Integer.parseInt(pDate.substring(3, 2))-1;
            int year = Integer.parseInt(pDate.substring(6, 4));

            Calendar c2 = Calendar.getInstance();
			c2.set(year, month, day);
			return c2.getTime();
        }
        catch(Exception ex)
        {
            throw(new Exception("Invalid Date - the input date is in wrong format or out of range"));
        }
    }
 
    public static Date GetSysDateMax(String pDate) throws Exception
    {
        if (IsEmpty(pDate)){
			return SetDate(2999, 12, 31);
        }
        
        if ("TODAY".equals(pDate.toUpperCase())) return new Date();
        
        try
        {
            int day = Integer.parseInt(pDate.substring(0, 2));
            int month = Integer.parseInt(pDate.substring(3, 2))-1;
            int year = Integer.parseInt(pDate.substring(6, 4));
			return SetDate(year, month, day);
        }
        catch(Exception ex)
        {
            throw(new Exception("Invalid Date - the input date is in wrong format or out of range"));
        }
    }
    
    // Convert a date to dd/mm/yyyy format
    public static String FormatDate(Date pDate) //throws Exception
    {
        try{
        	int dtFormat = OscarProperties.getInstance().getDateFormat();
        	String format = "yyyy/MM/dd";
        	if(dtFormat == 2) format = "dd/MM/yyyy";
        	else if(dtFormat==3) format = "MM/dd/yyyy";
        
    	if(pDate==null) return "";
//    	if (pDate.getYear() < 1) pDate = Utility.SetDate(1,1,1);
        if (pDate.equals(Utility.SetDate(1,1,1))) return "";
        else{
//            return pDate.ToString("dd/MM/yyyy", System.Globalization.DateTimeFormatInfo.InvariantInfo);
   		   SimpleDateFormat formatter = new SimpleDateFormat(format);
   		   return formatter.format(pDate);
        }
        }catch(Exception ex){
        	return "";
        }
    }
    public static String getMergedClientQueryString(String tableAlias,String colName ){
    	if(IsEmpty(colName)) return "";
    	String sql=" or ";
    	if(!IsEmpty(tableAlias))sql+=tableAlias+"."; 
        sql+=colName +" in (select cm.clientId from ClientMerge cm where cm.deleted=false and cm.mergedToClientId=?)" ;    	
    	return sql;    	
    }
    public static String getUserOrgQueryString(String providerNo,Integer shelterId){
    	String progSQL="";
    	if (shelterId  == null || shelterId.intValue() == 0) {
			progSQL = "(select p.id from Program p where 'P' || p.id in (select a.code from LstOrgcd a, Secuserrole b " +
		       " where a.codecsv like '%' || b.orgcd || ',%' and b.providerNo='" + providerNo + "'))";				
		}	else {
			progSQL = "(select p.id from Program p where p.shelterId =" + shelterId.toString() + " and 'P' || p.id in (select a.code from LstOrgcd a, Secuserrole b " +
		       " where a.codecsv like '%' || b.orgcd || ',%' and b.providerNo='" + providerNo + "'))";				
		}
    	return progSQL;
    }
    public static String getUserOrgSqlString(String providerNo,Integer shelterId){
    	String progSQL="";
    	if (shelterId == null || shelterId.intValue() == 0) {
			progSQL = "(select p.program_id from program p where 'P' || p.program_id in (select a.code from lst_orgcd a, secuserrole b " +
		       " where a.codecsv like '%' || b.orgcd || ',%' and b.provider_no='" + providerNo + "'))";				
		}	else {
			progSQL = "(select p.program_id from program p where p.shelter_id =" + shelterId.toString() + " and 'P' || p.program_id in (select a.code from lst_orgcd a, secuserrole b " +
		       " where a.codecsv like '%' || b.orgcd || ',%' and b.provider_no='" + providerNo + "'))";				
		}
    	return progSQL;
    }
    public static String getUserOrgSqlStringByFac(String providerNo,Integer shelterId){
    	String progSQL="";
    	if (shelterId == null || shelterId.intValue() == 0) {
			progSQL = "(select p.id from facility p where 'F' || p.id in (select a.code from lst_orgcd a, secuserrole b " +
		       " where a.codecsv like '%' || b.orgcd || ',%' and b.provider_no='" + providerNo + "'))";				
		}	else {
			progSQL = "(select p.id from facility p where p.org_id =" + shelterId.toString() + " and 'F' || p.id in (select a.code from lst_orgcd a, secuserrole b " +
		       " where a.codecsv like '%' || b.orgcd || ',%' and b.provider_no='" + providerNo + "'))";				
		}
    	return progSQL;
    }
    public static String getUserOrgStringByFac(String providerNo,Integer shelterId){
    	String progSQL="";
    	if (shelterId == null || shelterId.intValue() == 0) {
			progSQL = "(select p.id from Facility p where 'F' || p.id in (select a.code from LstOrgcd a, Secuserrole b " +
		       " where a.codecsv like '%' || b.orgcd || ',%' and b.providerNo='" + providerNo + "'))";				
		}	else {
			progSQL = "(select p.id from Facility p where p.orgId =" + shelterId + " and 'F' || p.id in (select a.code from LstOrgcd a, Secuserrole b " +
		       " where a.codecsv like '%' || b.orgcd || ',%' and b.providerNo='" + providerNo + "'))";				
		}
    	return progSQL;
    }
    public static String FormatDate(String pDate,Integer len){
    	String retVal="";
    	
    	if(pDate==null){
    		for(int i=0;i<len.intValue();i++){
    			retVal+=" ";
    		}
    		return retVal;
    	}
    	Long timeStam=new Long(pDate);
    	Calendar today=new GregorianCalendar();
    	today.setTimeInMillis(timeStam.longValue());
    	//yyyymmddHHMM
    	if(len.intValue()==12){
    		int yr=today.get(Calendar.YEAR);
    		int mon = today.get(Calendar.MONTH)+1;
    		int day=today.get(Calendar.DATE);
    		int hr = today.get(Calendar.HOUR);
    		int min=today.get(Calendar.MINUTE);
    		retVal =FormatIntNoWithZero(yr,4)+FormatIntNoWithZero(mon, 2)+FormatIntNoWithZero(day, 2)+FormatIntNoWithZero(hr, 2)+FormatIntNoWithZero(min, 2);
    	}
    	return retVal ;
    }
    public static String FormatString(String pStr,int tolLen){
    	
    	if(pStr==null) pStr="";
    	String retVal=pStr;
    	for(int i=0;i<tolLen-pStr.length();i++){
    		retVal=" "+retVal; 
    	}
    	return retVal;
    }
    public static String FormatNumber(String pNumber,int tolLen){
    	if(pNumber==null) pNumber="";
    	String retVal=pNumber;
    	for(int i=0;i<tolLen-pNumber.length();i++){
    		retVal=" "+retVal;
    	}
    	return retVal;
    }
    public static String FormatNumber(Integer pNumber,int tolLen){
    	if(pNumber==null) pNumber=new Integer(0);
    	String retVal=pNumber.toString();
    	for(int i=0;i<tolLen-pNumber.toString().length();i++){
    		retVal=" "+retVal;
    	}
    	return retVal;
    }
    public static String FormatIntNoWithZero(int pNumber,int tolLen){    	
    	Integer pNo =new Integer(pNumber);    	
    	String retVal=pNo.toString();
    	for(int i=0;i<tolLen-pNo.toString().length();i++){
    		retVal="0"+retVal;
    	}
    	return retVal;
    }
    public static String FormatDate(Date pDate, String fStr) //throws Exception
    {
        try{
    	if(pDate==null) return "";
//    	if (pDate.getYear() < 1) pDate = Utility.SetDate(1,1,1);
        if (pDate.equals(Utility.SetDate(1,1,1))) return "";
        else if(IsEmpty(fStr)==false){
           //yyyyMMdd
   		   SimpleDateFormat formatter = new SimpleDateFormat(fStr);
   		   return formatter.format(pDate);
        }
        else{
        	return FormatDate(pDate);
        }
        }catch(Exception ex){
        	return null;
        }
    }
    public static String getEscapedPattern(String str)
    {
    	StringBuffer sb = new StringBuffer();
    	for (int i=0; i< str.length(); i++)
    	{
    		String c  = str.substring(i,i+1); 
    		if (c.equals("["))
    		{
    			sb.append("\\[");
    		}
    		else
    		{
       			sb.append(c);
       		}
    	}
    	return sb.toString();
    }
    public static String replace(String str, String pattern, String replaceTo)
    {
    	String patternEsc = getEscapedPattern(pattern);
    	String[] buff = str.split(patternEsc);
    	StringBuffer sb = new StringBuffer();
    	sb.append(buff[0]);
    	for(int i=1; i<buff.length;i++)
    	{
    		sb.append(replaceTo);
    		sb.append(buff[i]);
    	}
    	return sb.toString();
    }
    public static String append(String str1, String str2, String sep)
    {
    	if (IsEmpty(str1)) return str2;
    	if(IsEmpty(str2)) return str1;
    	return str1 + sep + str2;
    }
    public static String merge(String[] str, String sep)
    {
    	if (str == null || str.length ==0) return "";
    	StringBuffer sb = new StringBuffer();
    	sb.append(str[0]);
    	for(int i=1; i<str.length;i++)
    	{
    		sb.append(sep);
    		sb.append(str[i]);
    	}
    	return sb.toString();
    }
    
    private static boolean checkIfNowAtDST(String iTimezoneName){ 
       	boolean isDST = false;
       	TimeZone iTimezone = TimeZone.getTimeZone(iTimezoneName);
        SimpleTimeZone stz = new SimpleTimeZone(iTimezone.getRawOffset(),
       		iTimezoneName, Calendar.MARCH, 8, -Calendar.SUNDAY,
            7200000, Calendar.NOVEMBER, 1, -Calendar.SUNDAY,
            7200000, 3600000); 
        if(stz.inDaylightTime(new Date())){
          	isDST = true;
        } 

        return isDST;
      } 
    public static ArrayList getTemplate(String pathLoc,String dir,String filename) {
		FieldDefinition fDev = null; // clientImageMgr.getClientImage(demoNo);
		ArrayList list = new ArrayList();
		String fileDir=pathLoc + "/" + dir + "/"+ filename;
		try {

			BufferedReader in = null;                    
			try {
				in = new BufferedReader(new FileReader(fileDir));
				String str;
				if(fileDir.indexOf("/in/")>-1){
					while ((str = in.readLine()) != null) {
						fDev = new FieldDefinition();
						fDev.setFieldName(str.substring(0, 30).trim());
						fDev.setFieldLength(new Integer(str.substring(30, 35).trim()));
						fDev.setFieldType(str.substring(35, 36));
						fDev.setFieldStartIndex(new Integer(str.substring(36, 41).trim()));
						if(str.length()>41)fDev.setDateFormatStr(str.substring(41,53).trim());
						list.add(fDev);
					}
				}else{
					while ((str = in.readLine()) != null) {
						fDev = new FieldDefinition();
						fDev.setFieldName(str.substring(0, 30).trim());
						fDev.setFieldLength(new Integer(str.substring(30, 35).trim()));
						fDev.setFieldType(str.substring(35, 36));
						if(str.length()>36)fDev.setDateFormatStr(str.substring(36,48).trim());
						list.add(fDev);
					}
				}
				in.close();

			} catch (IOException e) {
				// catch io errors from FileInputStream or readLine()
				System.out.println("Uh oh, got an IOException error!"
						+ e.getMessage());

			} 
			catch(Exception ex){
				System.out.println(" from read template!"
						+ ex.getMessage());
			}
			finally {
				if (in != null)
					in.close();
			}

		} catch (Exception e) {
			// log.warn(e);
		}

		return list;
	}
    

}
