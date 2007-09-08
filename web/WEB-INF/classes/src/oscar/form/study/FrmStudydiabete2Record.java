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
 * McMaster Unviersity 
 * Hamilton 
 * Ontario, Canada 
 */
package oscar.form.study;

import java.io.PrintStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Date;
import java.util.Properties;

import org.oscarehr.util.SpringUtils;

import oscar.oscarDB.DBHandler;
import oscar.util.*;

public class FrmStudydiabete2Record extends FrmStudyRecord {
    public Properties getFormRecord(int demographicNo, int existingID) throws SQLException {
        Connection c = SpringUtils.getDbConnection();
        try {
            Properties props = new Properties();
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            if (existingID <= 0) {
                String sql = "SELECT demographic_no, CONCAT(last_name, ', ', first_name) AS pName, year_of_birth, month_of_birth, date_of_birth FROM demographic WHERE demographic_no = " + demographicNo;
                ResultSet rs = db.GetSQL(c, sql);
                if (rs.next()) {
                    Date dob = UtilDateUtilities.calcDate(rs.getString("year_of_birth"), rs.getString("month_of_birth"), rs.getString("date_of_birth"));
                    props.setProperty("demographic_no", rs.getString("demographic_no"));
                    props.setProperty("formCreated", UtilDateUtilities.DateToString(UtilDateUtilities.Today(), "yyyy/MM/dd"));
                    props.setProperty("formEdited", UtilDateUtilities.DateToString(UtilDateUtilities.Today(), "yyyy/MM/dd"));
                    props.setProperty("birthDate", UtilDateUtilities.DateToString(dob, "yyyy/MM/dd"));
                    props.setProperty("pName", rs.getString("pName"));
                }
                rs.close();
            }
            else {
                String sql = "SELECT * FROM formType2Diabetes WHERE demographic_no = " + demographicNo + " AND ID = " + existingID;
                ResultSet rs = db.GetSQL(c, sql);
                if (rs.next()) {
                    ResultSetMetaData md = rs.getMetaData();
                    for (int i = 1; i <= md.getColumnCount(); i++) {
                        String name = md.getColumnName(i);
                        String value;
                        if (md.getColumnTypeName(i).equalsIgnoreCase("TINY") && md.getScale(i) == 1) {
                            if (rs.getInt(i) == 1) value = "checked='checked'";
                            else value = "";
                        }
                        else if (md.getColumnTypeName(i).equalsIgnoreCase("date")) value = UtilDateUtilities.DateToString(rs.getDate(i), "yyyy/MM/dd");
                        else value = rs.getString(i);
                        if (value != null) props.setProperty(name, value);
                    }

                }
                rs.close();
            }

            //props.list(System.out);
            return props;
        }
        finally {
            c.close();
        }
    }

    public int saveFormRecord(Properties props) throws SQLException {
        Connection c = SpringUtils.getDbConnection();
        try {
            String demographic_no = props.getProperty("demographic_no");
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String sql = "SELECT * FROM formType2Diabetes WHERE demographic_no=" + demographic_no + " AND ID=0";
            ResultSet rs = db.GetSQL(c, sql, true);
            rs.moveToInsertRow();
            ResultSetMetaData md = rs.getMetaData();
            for (int i = 1; i <= md.getColumnCount(); i++) {
                String name = md.getColumnName(i);
                if (name.equalsIgnoreCase("ID")) {
                    rs.updateNull(name);
                    continue;
                }
                String value = props.getProperty(name, null);
                if (md.getColumnTypeName(i).equalsIgnoreCase("TINY") && md.getScale(i) == 1) {
                    if (value != null) {
                        if (value.equalsIgnoreCase("on")) rs.updateInt(name, 1);
                        else rs.updateInt(name, 0);
                    }
                    else {
                        rs.updateInt(name, 0);
                    }
                    continue;
                }
                if (md.getColumnTypeName(i).equalsIgnoreCase("date")) {
                    Date d;
                    if (md.getColumnName(i).equalsIgnoreCase("formEdited")) {
                        d = UtilDateUtilities.Today();
                    }
                    else {
                        d = UtilDateUtilities.StringToDate(value, "yyyy/MM/dd");
                    }
                    if (d == null) rs.updateNull(name);
                    else rs.updateDate(name, new java.sql.Date(d.getTime()));
                    continue;
                }
                if (value == null) rs.updateNull(name);
                else rs.updateString(name, value);
            }

            rs.insertRow();
            rs.close();
            int ret = 0;
            sql = "SELECT LAST_INSERT_ID()";
            rs = db.GetSQL(c, sql);
            if (rs.next()) ret = rs.getInt(1);
            rs.close();

            return ret;
        }
        finally {
            c.close();
        }
    }

    public String findActionValue(String submit) throws SQLException {
        if (submit != null && submit.equalsIgnoreCase("print")) {
            return "print";
        }
        else if (submit != null && submit.equalsIgnoreCase("save")) {
            return "save";
        }
        else if (submit != null && submit.equalsIgnoreCase("exit")) {
            return "exit";
        }
        else {
            return "failure";
        }
    }

    public String createActionURL(String where, String action, String demoId, String formId, String studyId, String studyLink) throws SQLException {
        String temp = null;

        if (action.equalsIgnoreCase("print")) {
            temp = where + "?demoNo=" + demoId + "&formId=" + formId + "&study_no=" + studyId + "&study_link" + studyLink;
        }
        else if (action.equalsIgnoreCase("save")) {
            temp = where + "?demographic_no=" + demoId + "&study_no=" + studyId + "&study_link" + studyLink; //"&formId=" + formId +
        }
        else if (action.equalsIgnoreCase("exit")) {
            temp = where;
        }
        else {
            temp = where;
        }

        return temp;
    }

}
