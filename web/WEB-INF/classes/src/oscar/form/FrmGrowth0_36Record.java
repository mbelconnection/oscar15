/*
 * Copyright (c) 2005-. OSCARservice. All Rights Reserved. *
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
 * Yi Li
 */
package oscar.form;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import oscar.oscarDB.DBHandler;
import oscar.util.UtilDateUtilities;

public class FrmGrowth0_36Record extends FrmRecord {
    private String _dateFormat = "yyyy/MM/dd";

    public Properties getFormRecord(int demographicNo, int existingID) throws SQLException {
        Properties props = new Properties();

        if (existingID <= 0) {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String sql = "SELECT demographic_no, last_name, first_name, sex, address, city, province, postal, phone, phone2, year_of_birth, month_of_birth, date_of_birth, hin FROM demographic WHERE demographic_no = "
                    + demographicNo;
            ResultSet rs = db.GetSQL(sql);
            if (rs.next()) {
                java.util.Date date = UtilDateUtilities.calcDate(db.getString(rs,"year_of_birth"), rs
                        .getString("month_of_birth"), db.getString(rs,"date_of_birth"));
                props.setProperty("demographic_no", db.getString(rs,"demographic_no"));
                props
                        .setProperty("formCreated", UtilDateUtilities.DateToString(UtilDateUtilities.Today(),
                                _dateFormat));
                props.setProperty("formEdited", UtilDateUtilities.DateToString(UtilDateUtilities.Today(), _dateFormat));
                props.setProperty("patientName", db.getString(rs,"first_name") + " " + db.getString(rs,"last_name"));
                props.setProperty("patientSex", db.getString(rs,"sex"));
                props.setProperty("dateOfBirth", UtilDateUtilities.DateToString(date, _dateFormat));
            }
            rs.close();
        } else {
            String sql = "SELECT * FROM formGrowth0_36 WHERE demographic_no = " + demographicNo + " AND ID = "
                    + existingID;
            FrmRecordHelp frh = new FrmRecordHelp();
            frh.setDateFormat(_dateFormat);
            props = (frh).getFormRecord(sql);
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            sql = "SELECT sex, year_of_birth, month_of_birth, date_of_birth FROM demographic WHERE demographic_no = "
                    + demographicNo;
            ResultSet rs = db.GetSQL(sql);
            if (rs.next()) {
                java.util.Date date = UtilDateUtilities.calcDate(db.getString(rs,"year_of_birth"), rs
                        .getString("month_of_birth"), db.getString(rs,"date_of_birth"));
                props.setProperty("patientSex", db.getString(rs,"sex"));
                props.setProperty("dateOfBirth", UtilDateUtilities.DateToString(date, _dateFormat));
            }
        }
        return props;
    }

    public int saveFormRecord(Properties props) throws SQLException {
        String demographic_no = props.getProperty("demographic_no");
        String sql = "SELECT * FROM formGrowth0_36 WHERE demographic_no=" + demographic_no + " AND ID=0";
        FrmRecordHelp frh = new FrmRecordHelp();
        frh.setDateFormat(_dateFormat);
        return ((frh).saveFormRecord(props, sql));
    }

    public Properties getPrintRecord(int demographicNo, int existingID) throws SQLException {
        String sql = "SELECT * FROM formGrowth0_36 WHERE demographic_no = " + demographicNo + " AND ID = " + existingID;
        FrmRecordHelp frh = new FrmRecordHelp();
        frh.setDateFormat(_dateFormat);
        return ((frh).getPrintRecord(sql));
    }

    public String findActionValue(String submit) throws SQLException {
        FrmRecordHelp frh = new FrmRecordHelp();
        frh.setDateFormat(_dateFormat);
        return ((frh).findActionValue(submit));
    }

    public String createActionURL(String where, String action, String demoId, String formId) throws SQLException {
        FrmRecordHelp frh = new FrmRecordHelp();
        frh.setDateFormat(_dateFormat);
        return ((frh).createActionURL(where, action, demoId, formId));
    }
}