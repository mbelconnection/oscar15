/*
 *
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. * 
 * This software is published under the GPL GNU General Public License.
 * This program is free software; you can redistribute it and/or 
 * modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version. *
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
 * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
 * along with this program; if not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
 * 
 * <OSCAR TEAM> 
 * 
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */

package oscar.oscarRx.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.LinkedList;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.oscarehr.util.MiscUtils;

import oscar.oscarDB.DBHandler;

public class RxPatientData {
   
	private RxPatientData()
	{
		// prevent instantitation
	}
	
   /* Patient Search */
   
   public static Patient[] PatientSearch(String surname, String firstName) {
      
      Patient[] arr = {};     
      ArrayList lst = new ArrayList();      
      try {         
                  
         ResultSet rs;         
         Patient p;         
         rs = DBHandler.GetSQL(
         "SELECT demographic_no, last_name, first_name, sex, year_of_birth, "         
         + "month_of_birth, date_of_birth, address, city, postal, phone "         
         + "FROM demographic WHERE last_name LIKE '"         
         + surname + "%' AND first_name LIKE '" + firstName + "%'");
         
         while (rs.next()) {            
            p = new Patient(rs.getInt("demographic_no"), oscar.Misc.getString(rs, "last_name"),            
            oscar.Misc.getString(rs, "first_name"), oscar.Misc.getString(rs, "sex"),            
            calcDate(oscar.Misc.getString(rs, "year_of_birth"),
            oscar.Misc.getString(rs, "month_of_birth"),            
            oscar.Misc.getString(rs, "date_of_birth")),            
            oscar.Misc.getString(rs, "address"), oscar.Misc.getString(rs, "city"),
            oscar.Misc.getString(rs, "postal"),            
            oscar.Misc.getString(rs, "phone"), oscar.Misc.getString(rs, "hin"));            
            lst.add(p);            
         }         
         rs.close();         
         arr = (Patient[]) lst.toArray(arr);         
      }
      catch (SQLException e) {         
         MiscUtils.getLogger().error("Error", e);         
      }      
      return arr;
      
   }
   
   /* Patient Information */
   
   public static Patient getPatient(int demographicNo) throws java.sql.SQLException {      
            
      ResultSet rs;      
      Patient p = null;      
      try {         
         rs = DBHandler.GetSQL(
         "SELECT demographic_no, last_name, first_name, sex, year_of_birth, "         
         + "month_of_birth, date_of_birth, address, city, postal, phone,hin "         
         + "FROM demographic WHERE demographic_no = " + demographicNo);
         
         if (rs.next()) {            
            p = new Patient(rs.getInt("demographic_no"), oscar.Misc.getString(rs, "last_name"),            
            oscar.Misc.getString(rs, "first_name"), oscar.Misc.getString(rs, "sex"),            
            calcDate(oscar.Misc.getString(rs, "year_of_birth"),
            oscar.Misc.getString(rs, "month_of_birth"),            
            oscar.Misc.getString(rs, "date_of_birth")),            
            oscar.Misc.getString(rs, "address"), oscar.Misc.getString(rs, "city"),
            oscar.Misc.getString(rs, "postal"),            
            oscar.Misc.getString(rs, "phone"), oscar.Misc.getString(rs, "hin"));            
            MiscUtils.getLogger().debug(oscar.Misc.getString(rs, "first_name"));
         }         
         rs.close();         
      }
      catch (SQLException e) {         
         MiscUtils.getLogger().error("Error", e);         
      }
      
      return p;      
   }
   
   
   public static Patient getPatient(String demographicNo) throws java.sql.SQLException {      
            
      ResultSet rs;      
      Patient p = null;      
      try {         
         rs = DBHandler.GetSQL(
         "SELECT demographic_no, last_name, first_name, sex, year_of_birth, "         
         + "month_of_birth, date_of_birth, address, city, postal, phone,hin "         
         + "FROM demographic WHERE demographic_no = " + demographicNo);
         
         if (rs.next()) {            
            p = new Patient(rs.getInt("demographic_no"), oscar.Misc.getString(rs, "last_name"),            
            oscar.Misc.getString(rs, "first_name"), oscar.Misc.getString(rs, "sex"),            
            calcDate(oscar.Misc.getString(rs, "year_of_birth"),
            oscar.Misc.getString(rs, "month_of_birth"),            
            oscar.Misc.getString(rs, "date_of_birth")),            
            oscar.Misc.getString(rs, "address"), oscar.Misc.getString(rs, "city"),
            oscar.Misc.getString(rs, "postal"),            
            oscar.Misc.getString(rs, "phone"), oscar.Misc.getString(rs, "hin"));            
         }         
         rs.close();         
      }
      catch (SQLException e) {         
         MiscUtils.getLogger().error("Error", e);         
      }
      
      return p;      
   }
   
   private static java.util.Date calcDate(String year, String month, String day) {   
	   if (year==null || month==null || day==null) return null;
           if (!NumberUtils.isDigits(year) || !NumberUtils.isDigits(month) || !NumberUtils.isDigits(day)) return null;
	   
      int iYear = Integer.parseInt(year);
      int iMonth = Integer.parseInt(month) - 1;      
      int iDay = Integer.parseInt(day);
      
      GregorianCalendar ret = new GregorianCalendar(iYear, iMonth, iDay);     
      return ret.getTime();      
   }
   
   private static int calcAge(java.util.Date DOB) {
       if (DOB==null) return 0;

      GregorianCalendar now = new GregorianCalendar();     
      int curYear = now.get(Calendar.YEAR);      
      int curMonth = (now.get(Calendar.MONTH) + 1);      
      int curDay = now.get(Calendar.DAY_OF_MONTH);
      
      Calendar cal = new GregorianCalendar();      
      cal.setTime(DOB);      
      int iYear = cal.get(Calendar.YEAR);      
      int iMonth = (cal.get(Calendar.MONTH) + 1);      
      int iDay = cal.get(Calendar.DAY_OF_MONTH);      
      int age = 0;
     
      if (curMonth > iMonth || (curMonth == iMonth && curDay >= iDay)) {         
         age = curYear - iYear;         
      }else {         
         age = curYear - iYear - 1;         
      }
      
      return age;      
   }
   
   public static class Patient {      
      int demographicNo;      
      String surname;      
      String firstName;      
      String sex;      
      java.util.Date DOB;      
      String address;      
      String city;      
      String postal;      
      String phone;
      String hin;
      
      public Patient(int demographicNo, String surname, String firstName,String sex, java.util.Date DOB,
                     String address, String city, String postal, String phone,String hin) {
         
         this.demographicNo = demographicNo;         
         this.surname = surname;         
         this.firstName = firstName;         
         this.sex = sex;         
         this.DOB = DOB;         
         this.address = address;         
         this.city = city;         
         this.postal = postal;        
         this.phone = phone;
         this.hin = hin;         
      }
      
      public int getDemographicNo() {         
         return this.demographicNo;         
      }
      
      public String getSurname() {               
         return this.surname;         
      }
      
      public String getFirstName() {           
         return this.firstName;         
      }
            
      public String getSex() {         
         return this.sex;         
      }
            
      public String getHin() {
         return this.hin;
      }
      
      public java.util.Date getDOB() {         
         return this.DOB;         
      }
      
      public int getAge() {         
         return calcAge(this.getDOB());         
      }
      
      public String getAddress() {         
         return this.address;        
      }
      
      public String getCity() {         
         return this.city;         
      }
      
      public String getPostal() {         
         return this.postal;         
      }
      
      public String getPhone() {         
         return this.phone;         
      }
      
      public Allergy getAllergy(int id) {
           Allergy allergy = null;
           try {            
                        
            ResultSet rs;                        
            
            rs = DBHandler.GetSQL("SELECT * FROM allergies WHERE allergyid  = " + String.valueOf(id));
            
            if(rs.next()) {               
               allergy = new Allergy(getDemographicNo(), rs.getInt("allergyid"), rs.getDate("entry_date"),               
               oscar.Misc.getString(rs, "DESCRIPTION"),
               rs.getInt("HICL_SEQNO"), rs.getInt("HIC_SEQNO"),               
               rs.getInt("AGCSP"), rs.getInt("AGCCS"),
               rs.getInt("TYPECODE"));
                              
               allergy.getAllergy().setReaction(oscar.Misc.getString(rs, "reaction"));
	       allergy.getAllergy().setStartDate(rs.getDate("start_date"));
               allergy.getAllergy().setAgeOfOnset(oscar.Misc.getString(rs, "age_of_onset"));
               allergy.getAllergy().setSeverityOfReaction(oscar.Misc.getString(rs, "severity_of_reaction"));
               allergy.getAllergy().setOnSetOfReaction(oscar.Misc.getString(rs, "onset_of_reaction"));
               allergy.getAllergy().setRegionalIdentifier(oscar.Misc.getString(rs, "regional_identifier"));
               allergy.getAllergy().setLifeStage(oscar.Misc.getString(rs,"life_stage"));                
            }            
            rs.close();            
            
         }
         catch (SQLException e) {            
            MiscUtils.getLogger().error("Error", e);            
         }  
           
         return allergy;
      }
      
      public Allergy[] getAllergies() {         
         Allergy[] arr = {};         
         LinkedList lst = new LinkedList();         
         try {            
                        
            ResultSet rs;            
            Allergy allergy;
            
            rs = DBHandler.GetSQL("SELECT * FROM allergies WHERE demographic_no = '" + getDemographicNo() + "' and archived = '0' ORDER BY position");
            
            while (rs.next()) {               
               allergy = new Allergy(getDemographicNo(), rs.getInt("allergyid"), rs.getDate("entry_date"),               
               oscar.Misc.getString(rs, "DESCRIPTION"),
               rs.getInt("HICL_SEQNO"), rs.getInt("HIC_SEQNO"),               
               rs.getInt("AGCSP"), rs.getInt("AGCCS"),
               rs.getInt("TYPECODE"));
                              
               allergy.getAllergy().setReaction(oscar.Misc.getString(rs, "reaction"));
               allergy.getAllergy().setStartDate(rs.getDate("start_date"));
               allergy.getAllergy().setAgeOfOnset(oscar.Misc.getString(rs, "age_of_onset"));
               allergy.getAllergy().setSeverityOfReaction(oscar.Misc.getString(rs, "severity_of_reaction"));
               allergy.getAllergy().setOnSetOfReaction(oscar.Misc.getString(rs, "onset_of_reaction"));
               allergy.getAllergy().setRegionalIdentifier(oscar.Misc.getString(rs, "regional_identifier"));
               allergy.getAllergy().setLifeStage(oscar.Misc.getString(rs,"life_stage"));
               allergy.getAllergy().setPickID(rs.getInt("drugref_id"));
               allergy.getAllergy().setPosition(rs.getInt("position"));
               lst.add(allergy);               
            }            
            rs.close();            
            arr = (Allergy[]) lst.toArray(arr);            
         }
         catch (SQLException e) {            
            MiscUtils.getLogger().error("Error", e);            
         }
         
         return arr;         
      }
      
      public Allergy addAllergy(java.util.Date entryDate,RxAllergyData.Allergy allergyCode) {         
         Allergy allergy = null;
         try {            
            allergy = new Allergy(this.demographicNo, entryDate, allergyCode);            
            allergy.Save();                               
         }catch (SQLException e) {            
            MiscUtils.getLogger().error("Error", e);                               
         }  
         return allergy;     
      }
      
      public boolean deleteAllergy(int allergyId) {         
         boolean b = false;
         try {            
                        
            String sql = "update allergies set archived = '1'  WHERE allergyid = '"+allergyId+"'";            
            b = DBHandler.RunSQL(sql);                                  
         }catch (SQLException e) {            
            MiscUtils.getLogger().error("Error", e);            
            b = false;            
         }
         return b;
      }
      
      public Disease[] getDiseases() {         
         Disease[] arr = {};         
         LinkedList lst = new LinkedList();         
         try {            
                        
            ResultSet rs;            
            Disease d;            
            rs = DBHandler.GetSQL("SELECT * FROM diseases WHERE demographic_no = '" + getDemographicNo()+"'");            
            while (rs.next()) {               
               d = new Disease(rs.getInt("diseaseid"), oscar.Misc.getString(rs, "ICD9_E"),rs.getDate("entry_date"));               
               lst.add(d);               
            }            
            rs.close();            
            arr = (Disease[]) lst.toArray(arr);            
         }catch (SQLException e) {            
            MiscUtils.getLogger().error("Error", e);            
         }         
         return arr;         
      }
      
      public Disease addDisease(String ICD9, java.util.Date entryDate) throws SQLException {         
         Disease disease = new Disease(0, ICD9, entryDate);         
         disease.Save();         
         return disease;         
      }
      
      //TODO should not delete
      public boolean deleteDisease(int diseaseId) throws SQLException {         
                  
         String sql = "DELETE FROM diseases WHERE diseaseid = " + diseaseId;         
         boolean b = DBHandler.RunSQL(sql);         
         return b;         
      }
      
      public RxPrescriptionData.Prescription[] getPrescribedDrugsUnique() {         
         return new RxPrescriptionData().getUniquePrescriptionsByPatient(this.getDemographicNo());         
      }
      
      public RxPrescriptionData.Prescription[] getPrescribedDrugs() {         
         return new RxPrescriptionData().getPrescriptionsByPatient(this.getDemographicNo());         
      }
      
      public RxPrescriptionData.Prescription[] getPrescribedDrugScripts() {
        return new RxPrescriptionData().getPrescriptionScriptsByPatient(this.getDemographicNo());
      }         
      
      public static class Allergy {         
         int allergyId;         
         java.util.Date entryDate;         
         RxAllergyData.Allergy allergy;
         int demographicId;
         
         public Allergy(int demographicId, int allergyId, java.util.Date entryDate,RxAllergyData.Allergy allergy) {            
            this.demographicId=demographicId;
        	this.allergyId = allergyId;            
            this.entryDate = entryDate;            
            this.allergy = allergy;            
         }
         
         public Allergy(int demographicId, java.util.Date entryDate, RxAllergyData.Allergy allergy) {            
            this.demographicId=demographicId;
            this.allergyId = 0;            
            this.entryDate = entryDate;            
            this.allergy = allergy;            
         }
         
         public Allergy(int demographicId, int allergyId, java.util.Date entryDate,String DESCRIPTION,int HICL_SEQNO, int HIC_SEQNO, int AGCSP, int AGCCS,int TYPECODE) {            
            this.demographicId=demographicId;
            this.allergyId = allergyId;            
            this.entryDate = entryDate;            
            this.allergy = new RxAllergyData().getAllergy(DESCRIPTION, HICL_SEQNO,HIC_SEQNO, AGCSP, AGCCS, TYPECODE);            
         }
         
         public int getAllergyId() {            
            return this.allergyId;            
         }
         
         public java.util.Date getEntryDate() {            
            return this.entryDate;            
         }
         
         public void setEntryDate(java.util.Date RHS) {            
            this.entryDate = RHS;            
         }
         
         public RxAllergyData.Allergy getAllergy() {            
            return this.allergy;            
         }
                  
         public int getNextPosition() throws SQLException {
        	 String sql = "SELECT Max(position) FROM allergies WHERE demographic_no=" + demographicId;               
             ResultSet rs = DBHandler.GetSQL(sql);
             
             int position = 0;
             if (rs.next()) {                  
                position = rs.getInt(1);                  
             }
        	 return (position+1);
         }
         
         public boolean Save() throws SQLException {            
            boolean b;            
            String sql;            
            if (this.getAllergyId() == 0) {       
            	//need to add to the bottom of list
            	allergy.setPosition(getNextPosition());
               sql = "INSERT INTO allergies (demographic_no, entry_date, "               
               + "DESCRIPTION, HICL_SEQNO, HIC_SEQNO, AGCSP, AGCCS, TYPECODE,reaction,drugref_id,start_date,age_of_onset,severity_of_reaction,onset_of_reaction,regional_identifier,life_stage,position) "               
               + "VALUES (" + demographicId + ", '"               
               + oscar.oscarRx.util.RxUtil.DateToString(this.getEntryDate()) + "', '"               
               + StringEscapeUtils.escapeSql(this.allergy.getDESCRIPTION()) + "', "               
               + this.allergy.getHICL_SEQNO() + ", "               
               + this.allergy.getHIC_SEQNO() + ", "               
               + this.allergy.getAGCSP() + ", "               
               + this.allergy.getAGCCS() + ", "               
               + this.allergy.getTYPECODE() + ", '"               
               + this.allergy.getReaction() + "', '"               
               + this.allergy.getPickID() + "', '" 
               + oscar.oscarRx.util.RxUtil.DateToString(this.allergy.getStartDate()) + "', '"
               + this.allergy.getAgeOfOnset() + "', '"
               + this.allergy.getSeverityOfReaction() + "', '"
               + this.allergy.getOnSetOfReaction()+"','"
               + this.allergy.getRegionalIdentifier()+"','"
               + this.allergy.getLifeStage()+"',"
               + this.allergy.getPosition()               
               +")";
               
               b = DBHandler.RunSQL(sql);
               
               sql = "SELECT Max(allergyid) FROM allergies";               
               ResultSet rs = DBHandler.GetSQL(sql);
               
               if (rs.next()) {                  
                  this.allergyId = rs.getInt(1);                  
               }
               
               rs.close();               
            } else {
               
               sql = "UPDATE allergies SET entry_date = '" + oscar.oscarRx.util.RxUtil.DateToString(this.getEntryDate()) + "', "
               + "DESCRIPTION = '" + StringEscapeUtils.escapeSql(allergy.getDESCRIPTION()) + "', "               
               + "HICL_SEQNO = " + allergy.getHICL_SEQNO() + ", "               
               + "HIC_SEQNO = " + allergy.getHIC_SEQNO() + ", "               
               + "AGCSP = " + allergy.getAGCSP() + ", "
               + "AGCCS = " + allergy.getAGCCS() + ", "
               + "TYPECODE = " + allergy.getTYPECODE() + ", "
               + "reaction = '" + allergy.getReaction() + "', "               
               + "drugref_id = '" + allergy.getPickID() + "', " 
	       + "start_date = '" + oscar.oscarRx.util.RxUtil.DateToString(allergy.getStartDate()) + "', "
               + "age_of_onset ='"+allergy.getAgeOfOnset() + "',"
               + "severity_of_reaction = '"+allergy.getSeverityOfReaction() + "',"
               + "onset_of_reaction = '"+allergy.getOnSetOfReaction() + "', "
               + "life_stage =  '"+allergy.getLifeStage() + "', "
               + "position = " + allergy.getPosition() + " "
               + "WHERE allergyid = " + this.getAllergyId();
               
               b = DBHandler.RunSQL(sql);               
            }
            
            return b;            
         }
         
      }
      
      public class Disease {         
         int diseaseId;         
         String ICD9;         
         java.util.Date entryDate;
         
         public Disease(int diseaseId, String ICD9, java.util.Date entryDate) {            
            this.diseaseId = diseaseId;            
            this.ICD9 = ICD9;            
            this.entryDate = entryDate;            
         }
         
         public int getDiseaseId() {            
            return this.diseaseId;            
         }
         
         public String getICD9() {            
            return this.ICD9;            
         }
         
         public void setICD9(String RHS) {            
            this.ICD9 = RHS;            
         }
         
         public RxCodesData.Disease getDisease() {            
            return new RxCodesData().getDisease(this.getICD9());            
         }
         
         public java.util.Date getEntryDate() {            
            return this.entryDate;            
         }
         
         public void setEntryDate(java.util.Date RHS) {            
            this.entryDate = RHS;            
         }
         
         public boolean Save() throws SQLException {            
            boolean b = false;            
                        
            b = this.Save();            
            return b;            
         }
         
         public boolean Save(DBHandler db) throws SQLException {            
            boolean b;            
            String sql;            
            if (this.getDiseaseId() == 0) {               
               sql = "INSERT INTO diseases (demographic_no, ICD9, entry_date) "               
               + "VALUES (" + Patient.this.getDemographicNo() + ", '"               
               + this.getICD9() + "', '" + this.getEntryDate() + "')";               
               b = DBHandler.RunSQL(sql);               
               
               sql = "SELECT Max(diseaseid) FROM diseases";               
               ResultSet rs = DBHandler.GetSQL(sql);
               
               if (rs.next()) {                  
                  this.diseaseId = rs.getInt(1);                  
               }
               
               rs.close();               
            } else {               
               sql = "UPDATE diseases SET ICD9 = '" + this.getICD9() + "', "               
               + "entry_date = '" + this.getEntryDate().toString() + "' "               
               + "WHERE diseaseid = " + this.getDiseaseId();               
               b = DBHandler.RunSQL(sql);               
            }
            
            return b;            
         }
         
      }
      
   }
   
}