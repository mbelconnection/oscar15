package oscar.form;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Vector;

import oscar.login.DBHelp;
import oscar.oscarDB.DBHandler;
import oscar.util.UtilDateUtilities;

public class FrmBCINRRecord extends FrmRecord {
	private String _dateFormat = "dd/MM/yyyy";

	public Properties getFormRecord(int demographicNo, int existingID) throws SQLException {
		Properties props = new Properties();

		if (existingID <= 0) {
			DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
			String sql = "SELECT demographic_no, last_name, first_name, sex, address, city, province, postal, phone, phone2, year_of_birth, month_of_birth, date_of_birth, hin, family_doctor FROM demographic WHERE demographic_no = "
					+ demographicNo;
			ResultSet rs = db.GetSQL(sql);
			if (rs.next()) {
				java.util.Date date = UtilDateUtilities.calcDate(db.getString(rs,"year_of_birth"), rs
						.getString("month_of_birth"), db.getString(rs,"date_of_birth"));
				props.setProperty("demographic_no", db.getString(rs,"demographic_no"));
				props
						.setProperty("formCreated", UtilDateUtilities.DateToString(UtilDateUtilities.Today(),
								_dateFormat));
				// props.setProperty("formEdited",
				// UtilDateUtilities.DateToString(UtilDateUtilities.Today(),_dateFormat));
				props.setProperty("c_surname", db.getString(rs,"last_name"));
				props.setProperty("c_givenName", db.getString(rs,"first_name"));
				props.setProperty("c_address", db.getString(rs,"address"));
				props.setProperty("c_city", db.getString(rs,"city"));
				props.setProperty("c_province", db.getString(rs,"province"));
				props.setProperty("c_postal", db.getString(rs,"postal"));
				props.setProperty("c_phn", db.getString(rs,"hin"));
				props.setProperty("c_dateOfBirth", UtilDateUtilities.DateToString(date, _dateFormat));
				props.setProperty("c_phone1", db.getString(rs,"phone"));
				props.setProperty("c_phone2", db.getString(rs,"phone2"));
			}
			rs.close();
		} else {
			String sql = "SELECT * FROM formBCINR WHERE demographic_no = " + demographicNo + " AND ID = " + existingID;
			FrmRecordHelp frh = new FrmRecordHelp();
			frh.setDateFormat(_dateFormat);
			props = (frh).getFormRecord(sql);

			sql = "SELECT last_name, first_name, address, city, province, postal, phone,phone2, hin FROM demographic WHERE demographic_no = "
					+ demographicNo;
			DBHelp db = new DBHelp();
			ResultSet rs = db.searchDBRecord(sql);
			if (rs.next()) {
				props.setProperty("c_surname_cur", db.getString(rs,"last_name"));
				props.setProperty("c_givenName_cur", db.getString(rs,"first_name"));
				props.setProperty("c_address_cur", db.getString(rs,"address"));
				props.setProperty("c_city_cur", db.getString(rs,"city"));
				props.setProperty("c_province_cur", db.getString(rs,"province"));
				props.setProperty("c_postal_cur", db.getString(rs,"postal"));
				props.setProperty("c_phn_cur", db.getString(rs,"hin"));
				props.setProperty("c_phone1_cur", db.getString(rs,"phone"));
				props.setProperty("c_phone2_cur", db.getString(rs,"phone2"));
			}
		}
		return props;
	}

	public String getLastLabDate(int demographicNo, int existingID) throws SQLException {
		String ret = "20/04/2002";
		Properties props = new Properties();
		int cId = 0;
		if(existingID == 0) {
			String sql = "SELECT ID FROM formBCINR WHERE demographic_no = " + demographicNo + " order by ID desc";
			ResultSet rs = (new DBHelp()).searchDBRecord(sql);
			if (rs.next()) {
				cId = rs.getInt("ID");
			}
		} else {
			cId = existingID;
		}
		
		if(cId != 0) {
			String sql = "SELECT * FROM formBCINR WHERE demographic_no = " + demographicNo + " AND ID = " + cId;
			FrmRecordHelp frh = new FrmRecordHelp();
			frh.setDateFormat(_dateFormat);
			props = (frh).getFormRecord(sql);
			
			for(int i=21; i>=1; i--) {
				String labDate = props.getProperty("date"+i, "");
				if(labDate.length()==10) {
					ret = labDate;
					break;
				}
			}			
		}
		return ret;
	}
	
	public Vector getINRLabData(int demographic_no) throws SQLException {
		Vector ret = new Vector();
		DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
		String sql = "select lab_no from patientLabRouting where lab_type = 'BCP' and demographic_no ="
				+ demographic_no + "  order by lab_no";
		ResultSet rs = db.GetSQL(sql);
		while (rs.next()) {
			int labNo = rs.getInt("lab_no");
			sql = "select obr_id from hl7_obr obr, hl7_pid pid where obr.pid_id = pid.pid_id and pid.message_id ="
					+ labNo;
			ResultSet rs1 = db.GetSQL(sql);
			if (rs1.next()) {
				int obrId = rs1.getInt("obr_id");
				sql = "select observation_identifier, observation_results, observation_date_time from hl7_obx where obr_id ="
						+ obrId + " and observation_result_status='F'";
				ResultSet rs2 = db.GetSQL(sql);
				while (rs2.next()) {
					String labTestName = rs2.getString("observation_identifier").substring(
							rs2.getString("observation_identifier").indexOf("^") + 1);
					if ("INR".equals(labTestName)) {
						String result = rs2.getString("observation_results");
						String lTimeStamp = rs2.getString("observation_date_time");
						lTimeStamp = lTimeStamp.length() > 12 ? lTimeStamp.substring(0, 10) : lTimeStamp;
						lTimeStamp = lTimeStamp.substring(8, 10) + "/" + lTimeStamp.substring(5, 7) + "/"
								+ lTimeStamp.substring(0, 4);
						ret.add(lTimeStamp);
						ret.add(result);
					}
				}
			}
		}

		rs.close();
		return ret;
	}

	public int saveFormRecord(Properties props) throws SQLException {
		String demographic_no = props.getProperty("demographic_no");
		String sql = "SELECT * FROM formBCINR WHERE demographic_no=" + demographic_no + " AND ID=0";

		FrmRecordHelp frh = new FrmRecordHelp();
		frh.setDateFormat(_dateFormat);
		return ((frh).saveFormRecord(props, sql));
	}

	public Properties getPrintRecord(int demographicNo, int existingID) throws SQLException {
		String sql = "SELECT * FROM formBCINR WHERE demographic_no = " + demographicNo + " AND ID = " + existingID;
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