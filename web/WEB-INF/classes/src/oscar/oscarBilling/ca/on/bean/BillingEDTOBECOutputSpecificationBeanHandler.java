// -----------------------------------------------------------------------------------------------------------------------
// *
// *
// * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
// * This software is published under the GPL GNU General Public License. 
// * This program is free software; you can redistribute it and/or 
// * modify it under the terms of the GNU General Public License 
// * as published by the Free Software Foundation; either version 2 
// * of the License, or (at your option) any later version. * 
// * This program is distributed in the hope that it will be useful, 
// * but WITHOUT ANY WARRANTY; without even the implied warranty of 
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
// * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
// * along with this program; if not, write to the Free Software 
// * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
// * 
// * <OSCAR TEAM>
// * This software was written for the 
// * Department of Family Medicine 
// * McMaster Unviersity 
// * Hamilton 
// * Ontario, Canada 
// *
// -----------------------------------------------------------------------------------------------------------------------
package oscar.oscarBilling.ca.on.bean;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import oscar.oscarDB.DBHandler;

public class BillingEDTOBECOutputSpecificationBeanHandler {
    
    Vector EDTOBECOutputSecifiationBeanVector = new Vector();
    public boolean verdict = true;
    
    public BillingEDTOBECOutputSpecificationBeanHandler(FileInputStream file) {
        init(file);
    }
    
    public boolean init(FileInputStream file) {
        
        
        InputStreamReader reader = new InputStreamReader(file);
        BufferedReader input = new BufferedReader(reader);
        String nextline;
        
        try{
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            while ((nextline=input.readLine()) != null){

                if (nextline.length() > 2){

                    String obecHIN=nextline.substring(0,10);
                    String obecVer=nextline.substring(10,12);
                    String obecResponse=nextline.substring(12,14); 
                    BillingEDTOBECOutputSpecificationBean osBean = new BillingEDTOBECOutputSpecificationBean(obecHIN,obecVer,obecResponse);
                    
                    String sql = "SELECT * FROM demographic WHERE hin='" + obecHIN + "'";
                    ResultSet rs = db.GetSQL(sql);
                    if (rs.next()){
                        osBean.setLastName(rs.getString("last_name"));               
                        osBean.setFirstName(rs.getString("first_name"));
                        osBean.setDOB(rs.getString("year_of_birth")+"-"+rs.getString("month_of_birth")+"-"+rs.getString("date_of_birth"));
                        osBean.setSex(rs.getString("sex"));
                        String sqlProvider = "SELECT * FROM provider where provider_no = '" + rs.getString("provider_no") + "'";
                        ResultSet rsProvider = db.GetSQL(sqlProvider);
                        if(rsProvider.next()){
                            osBean.setIdentifier(rsProvider.getString("last_name"));
                        }
                        rs.close();
                    }
                    sql = "SELECT * FROM batchEligibility where responseCode='" + obecResponse + "'";
                    rs = db.GetSQL(sql);
                    if(rs.next()){
                        osBean.setMOH(rs.getString("MOHResponse"));
                        rs.close();
                    }
                    
                    if (nextline.length() > 14){                
                        //osBean.setIdentifier(nextline.substring(14,18));                
                        //osBean.setSex(nextline.substring(18,19));                
                        //osBean.setDOB(nextline.substring(19,27));               
                        osBean.setExpiry(nextline.substring(27,35));                
                        //osBean.setLastName(nextline.substring(35,65));               
                        //osBean.setFirstName(nextline.substring(65,85));
                        osBean.setSecondName(nextline.substring(85,105));
                        //osBean.setMOH(nextline.substring(105,207));
                    }                                            
                    
                    EDTOBECOutputSecifiationBeanVector.add(osBean);
                }
            }
        }
        catch (IOException ioe) {
            ioe.printStackTrace();         
        }
        catch(SQLException e)
        {
            System.out.println(e.getMessage());
        } 
        catch (StringIndexOutOfBoundsException ioe) {
            verdict =  false;   
        }
        return verdict;
    }
        

    public Vector getEDTOBECOutputSecifiationBeanVector(){
        return EDTOBECOutputSecifiationBeanVector;
    }
        
}
