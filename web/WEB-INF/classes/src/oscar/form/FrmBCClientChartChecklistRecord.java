package oscar.form;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import org.oscarehr.util.DbConnectionFilter;

import oscar.login.DBHelp;
import oscar.oscarDB.DBHandler;
import oscar.util.UtilDateUtilities;

//	 Referenced classes of package oscar.form:
//	            FrmRecord, FrmRecordHelp

public class FrmBCClientChartChecklistRecord extends FrmRecord {

    public FrmBCClientChartChecklistRecord() {
        _dateFormat = "dd/MM/yyyy";
    }

    public Properties getFormRecord(int demographicNo, int existingID) throws SQLException {
        Connection c = DbConnectionFilter.getThreadLocalDbConnection();
        try {

            Properties props = new Properties();
            if (existingID <= 0) {
                DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
                String sql = "SELECT demographic_no, last_name, first_name, sex, address, city, province, postal, phone, phone2, year_of_birth, month_of_birth, date_of_birth, hin FROM demographic WHERE demographic_no = " + demographicNo;
                ResultSet rs = db.GetSQL(sql);
                if (rs.next()) {
                    java.util.Date date = UtilDateUtilities.calcDate(rs.getString("year_of_birth"), rs.getString("month_of_birth"), rs.getString("date_of_birth"));
                    props.setProperty("demographic_no", rs.getString("demographic_no"));
                    props.setProperty("formCreated", UtilDateUtilities.DateToString(UtilDateUtilities.Today(), _dateFormat));
                    props.setProperty("formEdited", UtilDateUtilities.DateToString(UtilDateUtilities.Today(), _dateFormat));
                    props.setProperty("c_surname", rs.getString("last_name"));
                    props.setProperty("c_givenName", rs.getString("first_name"));
                    props.setProperty("c_address", rs.getString("address"));
                    props.setProperty("c_city", rs.getString("city"));
                    props.setProperty("c_province", rs.getString("province"));
                    props.setProperty("c_postal", rs.getString("postal"));
                    props.setProperty("c_phn", rs.getString("hin"));
                    props.setProperty("pg1_dateOfBirth", UtilDateUtilities.DateToString(date, _dateFormat));
                    props.setProperty("pg1_age", String.valueOf(UtilDateUtilities.calcAge(date)));
                    props.setProperty("c_phone", rs.getString("phone") + "  " + rs.getString("phone2"));
                    props.setProperty("pg1_formDate", UtilDateUtilities.DateToString(UtilDateUtilities.Today(), _dateFormat));
                }
                sql = "select clinic_name from clinic";
                rs = db.GetSQL(c, sql);
                if (rs.next()) {
                    props.setProperty("c_clinicName", rs.getString("clinic_name"));
                }
                rs.close();
            }
            else {
                String sql = "SELECT * FROM formBCClientChartChecklist WHERE demographic_no = " + demographicNo + " AND ID = " + existingID;
                FrmRecordHelp frh = new FrmRecordHelp();
                frh.setDateFormat(_dateFormat);
                props = frh.getFormRecord(sql);
                sql = "SELECT last_name, first_name, address, city, province, postal, phone,phone2, hin FROM demographic WHERE demographic_no = " + demographicNo;
                ResultSet rs = (new DBHelp()).searchDBRecord(c, sql);
                if (rs.next()) {
                    props.setProperty("c_surname_cur", rs.getString("last_name"));
                    props.setProperty("c_givenName_cur", rs.getString("first_name"));
                    props.setProperty("c_address_cur", rs.getString("address"));
                    props.setProperty("c_city_cur", rs.getString("city"));
                    props.setProperty("c_province_cur", rs.getString("province"));
                    props.setProperty("c_postal_cur", rs.getString("postal"));
                    props.setProperty("c_phn_cur", rs.getString("hin"));
                    props.setProperty("c_phone_cur", rs.getString("phone") + "  " + rs.getString("phone2"));
                }
            }
            return props;
        }
        finally {
            c.close();
        }
    }

    public int saveFormRecord(Properties props) throws SQLException {
        String demographic_no = props.getProperty("demographic_no");
        String sql = "SELECT * FROM formBCClientChartChecklist WHERE demographic_no=" + demographic_no + " AND ID=0";
        FrmRecordHelp frh = new FrmRecordHelp();
        frh.setDateFormat(_dateFormat);
        return frh.saveFormRecord(props, sql);
    }

    public Properties getPrintRecord(int demographicNo, int existingID) throws SQLException {
        String sql = "SELECT * FROM formBCClientChartChecklist WHERE demographic_no = " + demographicNo + " AND ID = " + existingID;
        FrmRecordHelp frh = new FrmRecordHelp();
        frh.setDateFormat(_dateFormat);
        return frh.getPrintRecord(sql);
    }

    public String findActionValue(String submit) throws SQLException {
        FrmRecordHelp frh = new FrmRecordHelp();
        frh.setDateFormat(_dateFormat);
        return frh.findActionValue(submit);
    }

    public String createActionURL(String where, String action, String demoId, String formId) throws SQLException {
        FrmRecordHelp frh = new FrmRecordHelp();
        frh.setDateFormat(_dateFormat);
        return frh.createActionURL(where, action, demoId, formId);
    }

    private String _dateFormat;
}
