/*
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
 * This software is published under the GPL GNU General Public License. This program is free
 * software; you can redistribute it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version. * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more details. * * You should have
 * received a copy of the GNU General Public License along with this program; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * <OSCAR
 * TEAM> This software was written for the Department of Family Medicine McMaster Unviersity
 * Hamilton Ontario, Canada
 */
package oscar.form;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.Properties;

import oscar.oscarDB.DBHandler;
import oscar.util.UtilDateUtilities;

public class FrmMentalHealthForm14Record extends FrmRecord {
		
	public Properties getFormRecord(int demographicNo, int existingID) throws SQLException {
        Properties props = new Properties();
        if (existingID <= 0) {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String demoProvider = "000000";
            String sql = "SELECT demographic_no, CONCAT(CONCAT(last_name, ', '), first_name) AS clientName, year_of_birth, month_of_birth, date_of_birth, provider_no FROM demographic WHERE demographic_no = "
                    + demographicNo;
            ResultSet rs = db.GetSQL(sql);
            if (rs.next()) {
                Date dob = UtilDateUtilities.calcDate(db.getString(rs,"year_of_birth"), db.getString(rs,"month_of_birth"),
                        db.getString(rs,"date_of_birth"));
                props.setProperty("demographic_no", db.getString(rs,"demographic_no"));
               props.setProperty("formCreated", UtilDateUtilities.DateToString(UtilDateUtilities.Today(),
                        "yyyy/MM/dd"));
                props.setProperty("formEdited",UtilDateUtilities.DateToString(UtilDateUtilities.Today(), "yyyy-MM-dd HH:mm:ss"));
                props.setProperty("clientDOB", UtilDateUtilities.DateToString(dob, "yyyy/MM/dd"));
                props.setProperty("clientName", db.getString(rs,"clientName"));
                props.setProperty("demoProvider", db.getString(rs,"provider_no"));
                
                demoProvider = db.getString(rs,"provider_no");
                
            }
            rs.close();
        } else {
            String sql = "SELECT * FROM formMentalHealthForm14 WHERE demographic_no = " + demographicNo + " AND ID = "
                    + existingID;
            props = (new FrmRecordHelp()).getFormRecord(sql);
        }
        
        return props;
    }

	
	public Properties getFormCustRecord(Properties props, String provNo) throws SQLException {
		String demoProvider = props.getProperty("demoProvider", "");
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        ResultSet rs = null;
        String sql = null;

        if (!demoProvider.equals("")) {

            if (demoProvider.equals(provNo) ) {
                // from provider table
                sql = "SELECT CONCAT(last_name, ', ', first_name) AS provName, ohip_no "
                        + "FROM provider WHERE provider_no = '" + provNo + "'";
                rs = db.GetSQL(sql);

                if (rs.next()) {
                    String num = db.getString(rs,"ohip_no");
                    props.setProperty("reqProvName", db.getString(rs,"provName"));
                    props.setProperty("provName", db.getString(rs,"provName"));
                    props.setProperty("practitionerNo", "0000-" + num + "-00");
                }
                rs.close();
            } else {
                // from provider table
                sql = "SELECT CONCAT(last_name, ', ', first_name) AS provName, ohip_no FROM provider WHERE provider_no = '"
                        + provNo + "'";
                rs = db.GetSQL(sql);
                
                String num = "";
                if (rs.next()) {
                    num = db.getString(rs,"ohip_no");
                    props.setProperty("reqProvName", db.getString(rs,"provName"));                    
                    props.setProperty("practitionerNo", "0000-" + num + "-00");
                }
                rs.close();

                // from provider table
                sql = "SELECT CONCAT(last_name, ', ', first_name) AS provName, ohip_no FROM provider WHERE provider_no = "
                        + demoProvider;
                rs = db.GetSQL(sql);

                if (rs.next()) {
                    if( num.equals("") ) {
                        num = db.getString(rs,"ohip_no");
                        props.setProperty("practitionerNo", "0000-"+num+"-00");
                    }
                    props.setProperty("provName", db.getString(rs,"provName"));
                    
                }
                rs.close();
            }
        }     
        

        return props;
    }
        
	public int saveFormRecord(Properties props) throws SQLException {
        String demographic_no = props.getProperty("demographic_no");
        String sql = "SELECT * FROM formMentalHealthForm14 WHERE demographic_no=" + demographic_no + " AND ID=0";
        return ((new FrmRecordHelp()).saveFormRecord(props, sql));
    }

    public Properties getPrintRecord(int demographicNo, int existingID) throws SQLException {
        String sql = "SELECT * FROM formMentalHealthForm14 WHERE demographic_no = " + demographicNo + " AND ID = 0";
        return ((new FrmRecordHelp()).getPrintRecord(sql));
    }

    public String findActionValue(String submit) throws SQLException {
        return ((new FrmRecordHelp()).findActionValue(submit));
    }

    public String createActionURL(String where, String action, String demoId, String formId) throws SQLException {
        return ((new FrmRecordHelp()).createActionURL(where, action, demoId, formId));
    }
	

 }