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
package oscar.oscarDemographic.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import org.oscarehr.util.DbConnectionFilter;

import oscar.oscarDB.DBHandler;
import oscar.util.SqlUtils;
import oscar.util.UtilDateUtilities;

public class DemographicData {

    public Date getDemographicDOB(String demographicNo) {
        DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;

        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT year_of_birth,month_of_birth,date_of_birth FROM demographic WHERE demographic_no = '" + demographicNo + "'";
            rs = db.GetSQL(sql);
            if (rs.next()) {
                try {
                    date = (Date)formatter.parse(rs.getString("year_of_birth") + "-" + rs.getString("month_of_birth") + "-" + rs.getString("date_of_birth"));
                }
                catch (Exception eg) {
                }
            }

            rs.close();
            db.CloseConn();

        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return date;
    }

    public String getDemographicNoByIndivoId(String pin) {
        String demographicNo = "";

        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT demographic_no FROM demographic WHERE pin = '" + pin + "'";
            rs = db.GetSQL(sql);
            if (rs.next()) {
                demographicNo = rs.getString("demographic_no");
            }
            rs.close();
            db.CloseConn();
            return demographicNo;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return demographicNo;
    }

    ////
    public int numDemographicsWithHIN(String hin) {
        int num = 0;
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT count(*) as c FROM demographic WHERE hin = '" + hin + "'";
            rs = db.GetSQL(sql);
            if (rs.next()) {
                num = rs.getInt("c");
            }
            rs.close();
            db.CloseConn();
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return num;
    }

    public boolean isUniqueHin(String hin) {
        return numDemographicsWithHIN(hin) == 0;
    }

    public ArrayList getDemographicWithHIN(String hin) {
        ArrayList list = new ArrayList();
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT demographic_no FROM demographic WHERE hin = '" + hin + "'";
            //System.out.println("sql "+sql);
            rs = db.GetSQL(sql);
            while (rs.next()) {
                String demoNo = rs.getString("demographic_no");
                //System.out.println("same hin as "+demoNo);
                list.add(getDemographic(demoNo));
            }
            rs.close();
            db.CloseConn();
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public ArrayList getDemographicWithLastFirstDOB(String lastname, String firstname, String dob) {
        Date bDate = UtilDateUtilities.StringToDate(dob, "yyyy-MM-dd");
        String year_of_birth = UtilDateUtilities.DateToString(bDate, "yyyy");
        String month_of_birth = UtilDateUtilities.DateToString(bDate, "MM");
        String date_of_birth = UtilDateUtilities.DateToString(bDate, "dd");
        //System.out.println("lastname "+lastname+" firstname "+firstname+" year_of_birth "+year_of_birth+" month "+month_of_birth+" date "+date_of_birth);
        return getDemographicWithLastFirstDOB(lastname, firstname, year_of_birth, month_of_birth, date_of_birth);
    }

    public ArrayList getDemographicWithLastFirstDOB(String lastname, String firstname, String year_of_birth, String month_of_birth, String date_of_birth) {
        ArrayList list = new ArrayList();
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT demographic_no FROM demographic " + " WHERE last_name like '" + lastname + "%' and first_name like '" + lastname + "%'  and year_of_birth = '" + year_of_birth + "' and month_of_birth = '" + month_of_birth + "' and date_of_birth = '" + date_of_birth + "'";
            rs = db.GetSQL(sql);
            while (rs.next()) {
                String demoNo = rs.getString("demographic_no");
                //System.out.println("looks to be the same  as "+demoNo);
                list.add(getDemographic(demoNo));
            }
            rs.close();
            db.CloseConn();
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public String getNameAgeString(String demographicNo) {
        String nameage = "";
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT last_name, first_name, year_of_birth,sex,month_of_birth,date_of_birth FROM demographic WHERE demographic_no = '" + demographicNo + "'";
            rs = db.GetSQL(sql);
            if (rs.next()) {
                String age = UtilDateUtilities.calcAge(UtilDateUtilities.calcDate(rs.getString("year_of_birth"), rs.getString("month_of_birth"), rs.getString("date_of_birth")));
                if (age == null) {
                    age = "";
                }
                nameage = rs.getString("last_name") + ", " + rs.getString("first_name") + " " + rs.getString("sex") + " " + age;
            }

            rs.close();
            db.CloseConn();

        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return nameage;
    }

    public String[] getNameAgeSexArray(String demographicNo) {
        String[] nameage = null;
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT last_name, first_name, year_of_birth,sex,month_of_birth,date_of_birth FROM demographic WHERE demographic_no = '" + demographicNo + "'";
            rs = db.GetSQL(sql);
            if (rs.next()) {
                String age = UtilDateUtilities.calcAge(UtilDateUtilities.calcDate(rs.getString("year_of_birth"), rs.getString("month_of_birth"), rs.getString("date_of_birth")));
                if (age == null) {
                    age = "";
                }
                nameage = new String[] {rs.getString("last_name"), rs.getString("first_name"), rs.getString("sex"), age};
            }

            rs.close();
            db.CloseConn();

        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return nameage;
    }

    public String getDemographicSex(String demographicNo) {
        String retval = "";
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT sex FROM demographic WHERE demographic_no = '" + demographicNo + "'";
            rs = db.GetSQL(sql);
            if (rs.next()) {
                try {
                    retval = rs.getString("sex");
                }
                catch (Exception eg) {
                }
            }

            rs.close();
            db.CloseConn();

        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return retval;
    }

    public Demographic getSubstituteDecisionMaker(String DemographicNo) {
        Demographic demographic = null;
        DemographicRelationship dr = new DemographicRelationship();
        String demoNo = dr.getSDM(DemographicNo);
        if (demoNo != null) {
            demographic = getDemographic(demoNo);
        }
        return demographic;
    }

    public Demographic getDemographic(String DemographicNo) {
        Demographic demographic = null;

        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT * FROM demographic WHERE demographic_no = '" + DemographicNo + "'";

            rs = db.GetSQL(sql);

            if (rs.next()) {
                demographic = new Demographic(DemographicNo, rs.getString("last_name"), rs.getString("first_name"), rs.getString("address"), rs.getString("city"), rs.getString("province"), rs.getString("postal"), rs.getString("phone"), rs.getString("phone2"), rs.getString("email"), rs.getString("pin"), rs.getString("year_of_birth"), rs.getString("month_of_birth"), rs.getString("date_of_birth"), rs.getString("hin"), rs.getString("ver"), rs.getString("roster_status"), rs.getString("patient_status"), rs
                        .getString("date_joined"), rs.getString("chart_no"), rs.getString("provider_no"), rs.getString("sex"), rs.getString("end_date"), rs.getString("eff_date"), rs.getString("pcn_indicator"), rs.getString("hc_type"), rs.getString("hc_renew_date"), rs.getString("family_doctor"));
            }

            rs.close();
            db.CloseConn();

        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return demographic;
    }

    public String getDemographicNoByPIN(String pin) {
        String demographicNo = "";

        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT demographic_no FROM demographic WHERE pin = '" + pin + "'";
            rs = db.GetSQL(sql);
            if (rs.next()) {
                demographicNo = rs.getString("demographic_no");
            }
            rs.close();
            db.CloseConn();
            return demographicNo;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return demographicNo;
    }

    public String getDemographicDateJoined(String DemographicNo) {
        String date = null;
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "SELECT date_joined FROM demographic WHERE demographic_no = '" + DemographicNo + "'";

            rs = db.GetSQL(sql);

            if (rs.next()) {
                date = rs.getString("date_joined");//getString("date_joined");                
            }

            rs.close();
            db.CloseConn();

        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return date;
    }

    public class Demographic {

        protected String demographic_no;
        protected String last_name;
        protected String first_name;
        protected String address;
        protected String city;
        protected String province;
        protected String postal;
        protected String phone;
        protected String phone2;
        protected String email;
        protected String pin;
        protected String year_of_birth;
        protected String month_of_birth;
        protected String date_of_birth;
        protected String hin;
        protected String ver;
        protected String roster_status;
        protected String patient_status;
        protected String date_joined;
        protected String chart_no;
        protected String provider_no;
        protected String sex;
        protected String end_date;
        protected String eff_date;
        protected String pcn_indicator;
        protected String hc_type;
        protected String hc_renew_date;
        protected String family_doctor;
        public RxInformation RxInfo;
        public EctInformation EctInfo;

        public Demographic(String DemographicNo) {
            init(DemographicNo);
        }

        protected Demographic(String DemographicNo, String last_name, String first_name, String address, String city, String province, String postal, String phone, String phone2, String email, String pin, String year_of_birth, String month_of_birth, String date_of_birth, String hin, String ver, String roster_status, String patient_status, String date_joined, String chart_no, String provider_no, String sex, String end_date, String eff_date, String pcn_indicator, String hc_type, String hc_renew_date,
                String family_doctor) {
            this.demographic_no = DemographicNo;
            this.last_name = last_name;
            this.first_name = first_name;
            this.address = address;
            this.city = city;
            this.province = province;
            this.postal = postal;
            this.phone = phone;
            this.phone2 = phone2;
            this.email = email;
            this.pin = pin;
            this.year_of_birth = year_of_birth;
            this.month_of_birth = month_of_birth;
            this.date_of_birth = date_of_birth;
            this.hin = hin;
            this.ver = ver;
            this.roster_status = roster_status;
            this.patient_status = patient_status;
            this.date_joined = date_joined;
            this.chart_no = chart_no;
            this.provider_no = provider_no;
            this.sex = sex;
            this.end_date = end_date;
            this.eff_date = eff_date;
            this.pcn_indicator = pcn_indicator;
            this.hc_type = hc_type;
            this.hc_renew_date = hc_renew_date;
            this.family_doctor = family_doctor;
            this.RxInfo = getRxInformation();
            this.EctInfo = getEctInformation();
        }

        private void init(String DemographicNo) {

            try {
                DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
                ResultSet rs;
                String sql = "SELECT * FROM demographic WHERE demographic_no = '" + DemographicNo + "'";

                rs = db.GetSQL(sql);

                if (rs.next()) {
                    this.demographic_no = DemographicNo;
                    this.last_name = rs.getString("last_name");
                    this.first_name = rs.getString("first_name");
                    this.address = rs.getString("address");
                    this.city = rs.getString("city");
                    this.province = rs.getString("province");
                    this.postal = rs.getString("postal");
                    this.phone = rs.getString("phone");
                    this.phone2 = rs.getString("phone2");
                    this.email = rs.getString("email");
                    this.pin = rs.getString("pin");
                    this.year_of_birth = rs.getString("year_of_birth");
                    this.month_of_birth = rs.getString("month_of_birth");
                    this.date_of_birth = rs.getString("date_of_birth");
                    this.hin = rs.getString("hin");
                    this.ver = rs.getString("ver");
                    this.roster_status = rs.getString("roster_status");
                    this.patient_status = rs.getString("patient_status");
                    this.date_joined = rs.getString("date_joined");
                    this.chart_no = rs.getString("chart_no");
                    this.provider_no = rs.getString("provider_no");
                    this.sex = rs.getString("sex");
                    this.end_date = rs.getString("end_date");
                    this.eff_date = rs.getString("eff_date");
                    this.pcn_indicator = rs.getString("pcn_indicator");
                    this.hc_type = rs.getString("hc_type");
                    this.hc_renew_date = rs.getString("hc_renew_date");
                    this.family_doctor = rs.getString("family_doctor");
                }

                rs.close();
                db.CloseConn();

                this.RxInfo = getRxInformation();
                this.EctInfo = getEctInformation();

            }
            catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }

        public String getDemographicNo() {
            return demographic_no;
        }

        public String getLastName() {
            return last_name;
        }

        public String getFirstName() {
            return first_name;
        }

        public String getAddress() {
            return address;
        }

        public String getCity() {
            return city;
        }

        public String getProvince() {
            return province;
        }

        public String getPostal() {
            return postal;
        }

        public String getPhone() {
            return phone;
        }

        public String getPhone2() {
            return phone2;
        }

        public String getEmail() {
            return email;
        }

        public String getPin() {
            return pin;
        }

        public String getIndivoId() {
            return pin;
        }

        public String getAge() {
            return(String.valueOf(oscar.util.UtilDateUtilities.calcAge(year_of_birth, month_of_birth, date_of_birth)));
        }

        public String getAgeAsOf(Date asofDate) {
            return UtilDateUtilities.calcAgeAtDate(UtilDateUtilities.calcDate(year_of_birth, month_of_birth, date_of_birth), asofDate);
        }

        public int getAgeInMonths() {
            return UtilDateUtilities.getNumMonths(UtilDateUtilities.calcDate(year_of_birth, month_of_birth, date_of_birth), Calendar.getInstance().getTime());
        }

        public int getAgeInMonthsAsOf(Date asofDate) {
            return UtilDateUtilities.getNumMonths(UtilDateUtilities.calcDate(year_of_birth, month_of_birth, date_of_birth), asofDate);
        }

        public int getAgeInYears() {
            return UtilDateUtilities.getNumYears(UtilDateUtilities.calcDate(year_of_birth, month_of_birth, date_of_birth), Calendar.getInstance().getTime());
        }

        public int getAgeInYearsAsOf(Date asofDate) {
            return UtilDateUtilities.getNumYears(UtilDateUtilities.calcDate(year_of_birth, month_of_birth, date_of_birth), asofDate);
        }

        public String getDob() {
            return addZero(year_of_birth, 4) + addZero(month_of_birth, 2) + addZero(date_of_birth, 2);
        }

        public Date getDOBObj() {
            Date date = null;
            try {
                DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                date = (Date)formatter.parse(addZero(year_of_birth, 4) + "-" + addZero(month_of_birth, 2) + "-" + addZero(date_of_birth, 2));
            }
            catch (Exception eg) {
            }
            return date;
        }

        public String getDob(String seperator) {
            return this.getYearOfBirth() + seperator + this.getMonthOfBirth() + seperator + this.getDateOfBirth();
        }

        public String getYearOfBirth() {
            return addZero(year_of_birth, 4);
        }

        public String getMonthOfBirth() {
            return addZero(month_of_birth, 2);
        }

        public String getDateOfBirth() {
            return addZero(date_of_birth, 2);
        }

        public String getHIN() {
            return hin + ver;
        }

        public String getJustHIN() {
            return hin;
        }

        public String getVersionCode() {
            return ver;
        }

        public String getRosterStatus() {
            return roster_status;
        }

        public String getPatientStatus() {
            return patient_status;
        }

        public String getDateJoined() {
            return date_joined;
        }

        public String getChartNo() {
            return chart_no;
        }

        public String getProviderNo() {
            return provider_no;
        }

        public String getSex() {
            return sex;
        }

        public boolean isFemale() {
            boolean female = false;
            if (sex != null && sex.trim().equalsIgnoreCase("f")) {
                female = true;
            }
            return female;
        }

        public boolean isMale() {
            boolean male = false;
            if (sex != null && sex.trim().equalsIgnoreCase("m")) {
                male = true;
            }
            return male;
        }

        public String getEndDate() {
            return end_date;
        }

        public String getEffDate() {
            return eff_date;
        }

        public String getPCNindicator() {
            return pcn_indicator;
        }

        public String getHCType() {
            return hc_type;
        }

        public String getHCRenewDate() {
            return hc_renew_date;
        }

        public String getFamilyDoctor() {
            return family_doctor;
        }

        public String addZero(String text, int num) {
            text = text.trim();
            String zero = "0";
            for (int i = text.length(); i < num; i++) {
                text = zero + text;
            }
            return text;
        }

        public RxInformation getRxInformation() {
            return new RxInformation();
        }

        public EctInformation getEctInformation() {
            return new EctInformation();
        }

        public class RxInformation {
            private String currentMedication;
            private String allergies;

            public String getCurrentMedication() {
                oscar.oscarRx.data.RxPrescriptionData prescriptData = new oscar.oscarRx.data.RxPrescriptionData();
                oscar.oscarRx.data.RxPrescriptionData.Prescription[] arr = {};
                arr = prescriptData.getUniquePrescriptionsByPatient(Integer.parseInt(demographic_no));
                StringBuffer stringBuffer = new StringBuffer();
                for (int i = 0; i < arr.length; i++) {
                    if (arr[i].isCurrent()) {
                        stringBuffer.append(arr[i].getRxDisplay() + "\n");
                    }
                }
                this.currentMedication = stringBuffer.toString();
                return this.currentMedication;
            }

            public String getAllergies() {
                try {
                    oscar.oscarRx.data.RxPatientData pData = new oscar.oscarRx.data.RxPatientData();
                    oscar.oscarRx.data.RxPatientData.Patient patient = pData.getPatient(Integer.parseInt(demographic_no));
                    oscar.oscarRx.data.RxPatientData.Patient.Allergy[] allergies = {};
                    allergies = patient.getAllergies();
                    StringBuffer stringBuffer = new StringBuffer();
                    for (int i = 0; i < allergies.length; i++) {
                        oscar.oscarRx.data.RxAllergyData.Allergy allerg = allergies[i].getAllergy();
                        stringBuffer.append(allerg.getDESCRIPTION() + "  " + allerg.getTypeDesc() + " \n");
                    }
                    this.allergies = stringBuffer.toString();
                }
                catch (SQLException e) {
                    System.out.println(e.getMessage());
                }
                return this.allergies;
            }
        }

        public class EctInformation {

            private oscar.oscarEncounter.data.EctPatientData.Patient patient;
            private oscar.oscarEncounter.data.EctPatientData.Patient.eChart eChart;

            EctInformation() {
                init();
            }

            private void init() {
                try {
                    oscar.oscarEncounter.data.EctPatientData patientData = new oscar.oscarEncounter.data.EctPatientData();
                    this.patient = patientData.getPatient(demographic_no);
                    this.eChart = patient.getEChart();
                }
                catch (SQLException e) {
                    System.out.println(e.getMessage());
                }
            }

            public Date getEChartTimeStamp() {
                return eChart.getEChartTimeStamp();
            }

            public String getSocialHistory() {
                return eChart.getSocialHistory();
            }

            public String getFamilyHistory() {
                return eChart.getFamilyHistory();
            }

            public String getMedicalHistory() {
                return eChart.getMedicalHistory();
            }

            public String getOngoingConcerns() {
                return eChart.getOngoingConcerns();
            }

            public String getReminders() {
                return eChart.getReminders();
            }

            public String getEncounter() {
                return eChart.getEncounter();
            }

            public String getSubject() {
                return eChart.getSubject();
            }
        }
    }

    ////////////////
    String add_record_string = "insert into demographic (last_name, first_name, address, city, province, postal, phone, phone2, email, pin, year_of_birth, month_of_birth, date_of_birth, hin, ver, roster_status, patient_status, date_joined, chart_no, provider_no, sex, end_date, eff_date, pcn_indicator, hc_type, hc_renew_date, family_doctor) values(?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)";

    public DemographicAddResult addDemographic(String last_name, String first_name, String address, String city, String province, String postal, String phone, String phone2, String year_of_birth, String month_of_birth, String date_of_birth, String hin, String ver, String roster_status, String patient_status, String date_joined, String chart_no, String provider_no, String sex, String end_date, String eff_date, String pcn_indicator, String hc_type, String hc_renew_date, String family_doctor, String email,
            String pin) throws SQLException {

        boolean duplicateRecord = false;
        DemographicAddResult ret = new DemographicAddResult();

        //  "insert into demographic (last_name, first_name, address, city, province, postal, phone, phone2, email, pin, year_of_birth, month_of_birth, date_of_birth, hin, ver, roster_status, patient_status, date_joined, chart_no, provider_no, sex, end_date, eff_date, pcn_indicator, hc_type, hc_renew_date, family_doctor) values(?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)" },

        if (end_date != null && end_date.equals("")) {
            end_date = "0001-01-01";
        }
        if (eff_date != null && eff_date.equals("")) {
            eff_date = "0001-01-01";
        }
        if (hc_renew_date != null && hc_renew_date.equals("")) {
            hc_renew_date = "0001-01-01";
        }

        ArrayList demos = new ArrayList();
        if (hin != null && !hin.trim().equals("")) {
            demos = getDemographicWithHIN(hin);
        }

        //System.out.println("demos "+demos.size());

        if (demos.size() == 0) { //Unique HIN
            demos = null;
            demos = getDemographicWithLastFirstDOB(last_name, first_name, year_of_birth, month_of_birth, date_of_birth);
            if (demos.size() != 0) {
                duplicateRecord = true;
                ret.addWarning("Patient " + last_name + ", " + first_name + " DOB (" + year_of_birth + "-" + month_of_birth + "-" + date_of_birth + ") exists in database. Record not added");
            }
        }
        else { // Duplicate HIN
            for (int i = 0; i < demos.size(); i++) {
                Demographic d = (Demographic)demos.get(i);
                if (last_name.equalsIgnoreCase(d.getLastName()) && first_name.equalsIgnoreCase(d.getFirstName()) && year_of_birth.equals(d.getYearOfBirth()) && month_of_birth.equals(d.getMonthOfBirth()) && date_of_birth.equals(d.getDateOfBirth())) {
                    //DUP don't add
                    //System.out.println("NOT ADDING becuase of dup with same hin");
                    duplicateRecord = true;
                    ret.addWarning("Patient " + last_name + ", " + first_name + " DOB (" + year_of_birth + "-" + month_of_birth + "-" + date_of_birth + ") exists in database. Record not added");
                }
                else {//add without HIN
                    //System.out.println("ADDING without him because of same hin");
                    ret.addWarning("Patient " + last_name + ", " + first_name + " DOB (" + year_of_birth + "-" + month_of_birth + "-" + date_of_birth + ") was added without a HIN because it is already in use");
                    hin = "";
                }
            }
        }

        demos = null;

        if (!duplicateRecord) {
            Connection c = DbConnectionFilter.getThreadLocalDbConnection();
            PreparedStatement ps = null;
            ResultSet rs=null;
            try {
                ps = c.prepareStatement(add_record_string);
                ps.setString(1, last_name);
                ps.setString(2, first_name);
                ps.setString(3, address);
                ps.setString(4, city);
                ps.setString(5, province);
                ps.setString(6, postal);
                ps.setString(7, phone);
                ps.setString(8, phone2);
                ps.setString(9, "");
                ps.setString(10, "");
                ps.setString(11, year_of_birth);
                ps.setString(12, month_of_birth);
                ps.setString(13, date_of_birth);
                ps.setString(14, hin);
                ps.setString(15, ver);
                ps.setString(16, roster_status);
                ps.setString(17, patient_status);
                ps.setString(18, date_joined);
                ps.setString(19, chart_no);
                ps.setString(20, provider_no);
                ps.setString(21, sex);
                ps.setString(22, end_date);
                ps.setString(23, eff_date);
                ps.setString(24, pcn_indicator);
                ps.setString(25, hc_type);
                ps.setString(26, hc_renew_date);
                ps.setString(27, family_doctor);

                String outString = ps.toString();
                int firstmark = outString.indexOf(':');
                //System.out.println(add_record.toString().substring(firstmark+1)+";");

                ps.executeUpdate();
                //conn.createStatement().execute(sql
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    ret.setAdded(true);
                    ret.setId("" + rs.getInt(1));
                }
            }
            catch (Exception e) {
                System.out.println("LOG ADD RECORD " + chart_no);
                e.printStackTrace();
                ret = null;
            }
            finally {
                SqlUtils.closeResources(c, ps, rs);
            }
        }
        else {
            System.out.println("NOT ADDED");
        }

        return ret;
    }

    public class DemographicAddResult {
        ArrayList warnings = null;
        boolean added = false;
        String id = null;

        public void addWarning(String str) {
            //System.out.println("Adding warning "+str);
            if (warnings == null) {
                warnings = new ArrayList();
            }
            warnings.add(str);
        }

        public String[] getWarnings() {
            String[] s = {};
            if (warnings != null) {
                s = (String[])warnings.toArray(s);
            }
            return s;
        }

        public ArrayList getWarningsCollection() {
            if (warnings == null) {
                warnings = new ArrayList();
            }
            return warnings;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public boolean wasAdded() {
            return added;
        }

        public void setAdded(boolean b) {
            added = b;
        }
    }

    ////////////////

}
