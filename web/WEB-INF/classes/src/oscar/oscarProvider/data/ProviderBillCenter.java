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
package oscar.oscarProvider.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import oscar.oscarDB.DBHandler;

/**
 *
 * @author Toby
 */
public class ProviderBillCenter {
    
    /** Creates a new instance of ProviderBillCenter */
    public ProviderBillCenter() {
    }
    
    public boolean hasBillCenter(String provider_no){
        boolean retval = false;
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String sql = "select billcenter_code from providerbillcenter where provider_no = '"+provider_no+"' ";
            ResultSet rs = db.GetSQL(sql);
            if(rs.next())
                retval = true;
            rs.close();
        } catch(SQLException e) {
            System.out.println("There has been an error while checking if a provider had a bill center");
            System.out.println(e.getMessage());
        }
        
        return retval;
    }

    public boolean hasProvider(String provider_no){
        boolean retval = false;
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String sql = "select provider_no from providerbillcenter where provider_no = '"+provider_no+"' ";
            ResultSet rs = db.GetSQL(sql);
            if(rs.next())
                retval = true;
            rs.close();
        } catch(SQLException e) {
            System.out.println("There has been an error while checking if a provider had a bill center");
            System.out.println(e.getMessage());
        }

        return retval;
    }
    
    public void addBillCenter(String provider_no, String billCenterCode){
        
        try{
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String sql = "insert into  providerbillcenter (provider_no,billcenter_code) values ('"+provider_no+"' ,'"+billCenterCode+"') ";
            db.RunSQL(sql);
        } catch(SQLException e){
            System.out.println("There has been an error while adding a provider's bill center");
            System.out.println(e.getMessage());
        }
    }
    
    public String getBillCenter(String provider_no){
        String billCenterCode = "";
        try{
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String sql = "select billcenter_code from providerbillcenter where provider_no = '"+provider_no+"' ";
            ResultSet rs = db.GetSQL(sql);
            if(rs.next())
                billCenterCode = db.getString(rs,"billcenter_code");
            rs.close();
        } catch(SQLException e){
            System.out.println("There has been an error while retrieving a provider's bill center");
            System.out.println(e.getMessage());
        }
        
        return billCenterCode;
    }
    
    public void updateBillCenter(String provider_no, String billCenterCode){
        if (!hasProvider(provider_no)) {
            addBillCenter(provider_no, billCenterCode);
        } else {
            try {
                DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
                String sql = "update providerbillcenter set billcenter_code = '" + billCenterCode + "' where provider_no = '" + provider_no + "' ";
                db.RunSQL(sql);
            } catch (SQLException e) {
                System.out.println("There has been an error while updating a provider's bill center");
                System.out.println(e.getMessage());
            }
        }    
    }
    
    public Properties getAllBillCenter(){
        Properties allBillCenter = new Properties();
        
        try{
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String sql = "select * from billcenter" ;
            ResultSet rs = db.GetSQL(sql);
            while(rs.next())
                allBillCenter.setProperty(db.getString(rs,"billcenter_code"),db.getString(rs,"billcenter_desc")) ;
            rs.close();
        } catch(SQLException e){
            System.out.println("There has been an error while retrieving info from table billcenter");
            System.out.println(e.getMessage());
        }
        
        return allBillCenter;
    }
    
}