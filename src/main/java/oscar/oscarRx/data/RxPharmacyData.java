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
 * Jason Gallagher
 * 
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */ 


/*
 * RxPharmacyData.java
 *
 * Created on September 29, 2004, 3:41 PM
 */

package oscar.oscarRx.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.oscarehr.util.MiscUtils;

import oscar.oscarDB.DBHandler;

/**
 *
 * @author  Jay Gallagher
 *
   create table pharmacyInfo (
   recordID int(10) auto_increment primary key,
   ID int(5),
   name varchar(255),
   address text,
   city varchar(255),
   province varchar(255),
   postalCode varchar(20),
   phone1 varchar(20),
   phone2 varchar(20),
   fax varchar(20),
   email varchar(100),
   notes text,
   addDate timestamp,
   status char (1)
   )
 *
   create table demographicPharmacy (
   pharmacyID int(10),
   demographic_no int(10),
   status char(1),
   addDate timestamp
   ) 
 *
 */
public class RxPharmacyData {
   
   /** Creates a new instance of RxPharmacyData */
   public RxPharmacyData() {
   }
   
   
   /**
    * Used to add a new pharmacy
    * @param name
    * @param address
    * @param city
    * @param province
    * @param postalCode
    * @param phone1
    * @param phone2
    * @param fax
    * @param email
    * @param notes
    */   
   synchronized public void addPharmacy(String name,String address,String city,String province,String postalCode, String phone1, String phone2, String fax, String email,String serviceLocationIdentifier, String notes){
      try {            
            
            ResultSet rs;
            String sql = "SELECT max(ID) FROM  pharmacyInfo";            
            rs = DBHandler.GetSQL(sql);
            int id=0;
            if ( rs.next()){
               id = rs.getInt(1);
            }
            id++;
            String ID = Integer.toString(id);
            
            updatePharmacy(ID,name,address,city,province,postalCode,phone1,phone2, fax,email, serviceLocationIdentifier, notes);
                                    
            rs.close();
        } catch (SQLException e) {
            MiscUtils.getLogger().error("Error", e);
            MiscUtils.getLogger().error("Error", e);
        }
   }
   
   
   /**
    * Used to update an new pharmacy.  Creates a new record for this pharmacy with the same pharmacyID
    * @param ID pharmacy ID
    * @param name
    * @param address
    * @param city
    * @param province
    * @param postalCode
    * @param phone1
    * @param phone2
    * @param fax
    * @param email
    * @param notes
    */   
   public void updatePharmacy(String ID,String name,String address,String city,String province,String postalCode, String phone1, String phone2, String fax, String email, String serviceLocationIdentifier, String notes){
      try {           
                        
            String sql = "Insert into  pharmacyInfo "
            +" (ID, name, address, city, province, postalCode, phone1, phone2, fax, email, serviceLocationIdentifier, notes, status, addDate) "
            +" values "
            +"( '"+ID+"',"
            +" '"+name+"',"
            +" '"+address+"',"
            +" '"+city+"', "
            +" '"+province+"', "
            +" '"+postalCode+"', "
            +" '"+phone1+"', "
            +" '"+phone2+"', "
            +" '"+fax+"',"
            +" '"+email+"', "
            +" '"+serviceLocationIdentifier+"', "       
            +" '"+notes+"', "
            +" '1', "
            +" now() )";
                                    
            DBHandler.RunSQL(sql);
        } catch (SQLException e) {
           MiscUtils.getLogger().error("Error", e);
            MiscUtils.getLogger().error("Error", e);
        }
   }
   
   
   /**
    * set the status of the pharmacy to 0, this will not be found in the getAllPharmacy queries
    * @param ID
    */   
   public void deletePharmacy(String ID){
      try {
                        
            String sql = "update pharmacyInfo set status = '0' where ID = '"+ID+"'";                                                
            DBHandler.RunSQL(sql);
        } catch (SQLException e) {
            MiscUtils.getLogger().error("Error", e);
        }
   }
   
   /**
    * Returns the latest data about a pharmacy.
    * @param ID pharmacy id
    * @return returns a pharmacy class corresponding latest data from the pharmacy ID
    */   
   public Pharmacy getPharmacy(String ID){
      Pharmacy pharmacy = null;
      try {
            
            ResultSet rs;
            String sql = "SELECT * FROM  pharmacyInfo where ID = '"+ID+"' order by recordID desc limit 1";            
            rs = DBHandler.GetSQL(sql);            
            if ( rs.next()){
               pharmacy = new Pharmacy(rs);
            }                                                
            rs.close();
        } catch (SQLException e) {
            MiscUtils.getLogger().error("Error", e);
        }
      
      return pharmacy;
   }

   /**
    * Returns the data about a pharmacy record.  This would be used to see prior addresses or phone numbers of a pharmacy.
    * @param recordID pharmacy Record ID
    * @return Pharmacy data class
    */   
   public Pharmacy getPharmacyByRecordID(String recordID){
      Pharmacy pharmacy = null;
      try {           
            
            ResultSet rs;
            String sql = "SELECT * FROM  pharmacyInfo where recordID = '"+recordID+"' ";
            rs = DBHandler.GetSQL(sql);            
            if ( rs.next()){
               pharmacy = new Pharmacy(rs);
            }                                                
            rs.close();
        } catch (SQLException e) {
            MiscUtils.getLogger().error("Error", e);
        }
      
      return pharmacy;
   }
   
   
   /**
    * Used to get a list of all the active pharmacies with their latest data
    * @return ArrayList of Pharmacy classes
    */   
   public ArrayList getAllPharmacies(){
      ArrayList  pharmacyList =  new ArrayList();
      try {           
            
            ResultSet rs;            
            String sql = "select max(recordID) as maxrec from pharmacyInfo where status = 1 group by ID order by name";            
            rs = DBHandler.GetSQL(sql);            
            while ( rs.next()){
               pharmacyList.add(getPharmacyByRecordID(oscar.Misc.getString(rs, "maxrec")));
            }                                                
            rs.close();
        } catch (SQLException e) {
            MiscUtils.getLogger().error("Error", e);
        }
      return pharmacyList;
   }
   
   /**
    * Used to link a patient with a pharmacy.
    * @param pharmacyId Id of the pharmacy
    * @param demographicNo Patient demographic number
    */   
   public void addPharmacyToDemographic(String pharmacyId,String demographicNo){
      try {            
                        
            String sql = "Insert into  demographicPharmacy "
            +" (pharmacyID,demographic_no,  status, addDate ) "
            +" values "
            +"( '"+pharmacyId+"',"
            + " '"+demographicNo+"',"
            +" '1', "
            +" now() )";
                                    
            DBHandler.RunSQL(sql);
        } catch (SQLException e) {
           MiscUtils.getLogger().error("Error", e);
            MiscUtils.getLogger().error("Error", e);
        }
   }
   
   /**
    * Used to get the most recent pharmacy associated with this patient.  Returns a Pharmacy object with the latest data about that pharmacy.
    * @param demographicNo patients demographic number
    *
    * @return Pharmacy data object
    */   
   public Pharmacy getPharmacyFromDemographic(String demographicNo){
      Pharmacy pharmacy = null;
      try {
            
            ResultSet rs;
            //String sql = "SELECT * FROM  pharmacyInfo group  by  ID order by recordID desc ";                        
            String sql = "select d.pharmacyID from demographicPharmacy d where  d.status = 1 and d.demographic_no = '"+demographicNo+"' order by addDate desc limit 1";
            
            rs = DBHandler.GetSQL(sql);            
            if ( rs.next()){
               pharmacy = getPharmacy(oscar.Misc.getString(rs, "pharmacyID"));
            }                                                
            rs.close();
        } catch (SQLException e) {
            MiscUtils.getLogger().error("Error", e);
        }
      
      return pharmacy;      
   }
   
   public class Pharmacy{
      
      public String    recordID = null;
      public String    ID             = null;
      public String    name = null;                                                              
      public String    address = null;                                                              
      public String    city = null;                                                              
      public String    province = null;                                                              
      public String    postalCode = null;                                                              
      public String    phone1 = null;                                                              
      public String    phone2 = null;                                                              
      public String    fax = null; 
      public String    email = null;
      public String    serviceLocationIdentifier = null;
      public String    notes = null;
      
      public Pharmacy(){
         
      }
      public Pharmacy(ResultSet rs) throws SQLException{
         recordID   = oscar.Misc.getString(rs,"recordID");
         ID         = oscar.Misc.getString(rs,"ID");
         name       = oscar.Misc.getString(rs,"name");                                                              
         address    = oscar.Misc.getString(rs,"address");                                                              
         city       = oscar.Misc.getString(rs,"city");                                                              
         province   = oscar.Misc.getString(rs,"province");                                                       
         postalCode = oscar.Misc.getString(rs,"postalCode");                                                 
         phone1     = oscar.Misc.getString(rs,"phone1");                                        
         phone2     = oscar.Misc.getString(rs,"phone2");                                                
         fax        = oscar.Misc.getString(rs,"fax");                                             
         email      = oscar.Misc.getString(rs,"email");
         serviceLocationIdentifier = oscar.Misc.getString(rs,"serviceLocationIdentifier");
         notes      = oscar.Misc.getString(rs,"notes");
         
      }
   }
}