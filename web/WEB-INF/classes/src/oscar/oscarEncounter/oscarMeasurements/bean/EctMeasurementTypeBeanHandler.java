/*
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
 *  Ontario, Canada   
 *
 * EctMeasurementTypeBeanHandler.java
 *
 * Created on January 31, 2006, 12:18 AM
 *
 */

package oscar.oscarEncounter.oscarMeasurements.bean;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import oscar.oscarDB.DBHandler;
import oscar.oscarEncounter.oscarMeasurements.data.MeasurementTypes;

/**
 *
 * @author jay
 */
public class EctMeasurementTypeBeanHandler {
    private static Log log = LogFactory.getLog(EctMeasurementTypeBeanHandler.class);
    
    /** Creates a new instance of EctMeasurementTypeBeanHandler */
    public EctMeasurementTypeBeanHandler() {
    }
    
    public EctMeasurementTypesBean getMeasurementType(String mType){
        log.debug(" calling get MeasurementType");
        MeasurementTypes mt =  MeasurementTypes.getInstance();
        return mt.getByType(mType);
        
//        EctMeasurementTypesBean ret = null;
//        try {
//            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
//
//            String sql = "SELECT * FROM measurementType where type = '"+mType+"'";   
//            //System.out.println(sql);
//            ResultSet rs = db.GetSQL(sql);        
//            while(rs.next()){                
//               System.out.println("validation "+db.getString(rs,"validation"));  
//               ret = new EctMeasurementTypesBean(rs.getInt("id"), db.getString(rs,"type"), 
//                                                 db.getString(rs,"typeDisplayName"), 
//                                                 db.getString(rs,"typeDescription"), 
//                                                 db.getString(rs,"measuringInstruction"), 
//                                                 //getValidation(db.getString(rs,"validation"))); 
//                                                 db.getString(rs,"validation")); 
//               ret.setValidationName(getValidation(db.getString(rs,"validation")));
//            }
//            rs.close();            
//        }
//        catch(SQLException e) {
//            System.out.println(e.getMessage());
//        }
//        return ret;
    }
    
    public String getValidation(String val){
        String validation = null;
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String sqlValidation = "SELECT name FROM validations WHERE id='"+val+"'";
            ResultSet rs = db.GetSQL(sqlValidation);
            if (rs.next()){ 
                validation = db.getString(rs,"name");
                //System.out.println("setting validation to "+validation);
            }
            rs.close();
        }catch(SQLException e) {
            e.printStackTrace();
        }
        return validation;
    }
}