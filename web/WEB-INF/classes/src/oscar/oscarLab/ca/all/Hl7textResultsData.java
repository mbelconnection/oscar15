/*
 * Hl7textResultsData.java
 *
 * Created on June 19, 2007, 10:33 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package oscar.oscarLab.ca.all;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;

import org.apache.log4j.Logger;
import org.oscarehr.util.DbConnectionFilter;

import oscar.oscarDB.DBHandler;
import oscar.oscarLab.ca.all.parsers.Factory;
import oscar.oscarLab.ca.all.parsers.MessageHandler;
import oscar.oscarLab.ca.on.LabResultData;
import oscar.util.SqlUtils;
import oscar.util.UtilDateUtilities;

/**
 *
 * @author wrighd
 */
public class Hl7textResultsData {

    Logger logger = Logger.getLogger(Hl7textResultsData.class);

    /** Creates a new instance of Hl7textResultsData */
    public Hl7textResultsData() {
    }

    public void populateMeasurementsTable(String lab_no, String demographic_no) throws SQLException {
        MessageHandler h = Factory.getInstance().getHandler(lab_no);

        java.util.Calendar calender = java.util.Calendar.getInstance();
        String day = Integer.toString(calender.get(java.util.Calendar.DAY_OF_MONTH));
        String month = Integer.toString(calender.get(java.util.Calendar.MONTH) + 1);
        String year = Integer.toString(calender.get(java.util.Calendar.YEAR));
        String hour = Integer.toString(calender.get(java.util.Calendar.HOUR));
        String min = Integer.toString(calender.get(java.util.Calendar.MINUTE));
        String second = Integer.toString(calender.get(java.util.Calendar.SECOND));
        String dateEntered = year + "-" + month + "-" + day + " " + hour + ":" + min + ":" + second + ":";

        Connection c = DbConnectionFilter.getThreadLocalDbConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);

            //Check for other versions of this lab
            String[] matchingLabs = getMatchingLabs(lab_no).split(",");
            //if this lab is the latest version delete the measurements from the previous version and insert the new ones

            int k = 0;
            while (k < matchingLabs.length && !matchingLabs[k].equals(lab_no)) {
                k++;
            }
            if (k != 0) {
                String sql = "SELECT measurement_id FROM measurementsExt WHERE keyval='lab_no' AND val='" + matchingLabs[k - 1] + "'";
                rs = db.GetSQL(sql);
                while (rs.next()) {
                    sql = "DELETE FROM measurements WHERE id='" + rs.getString("measurement_id") + "'";
                    db.RunSQL(sql);
                    sql = "DELETE FROM measurementsExt WHERE measurement_id='" + rs.getString("measurement_id") + "'";
                    db.RunSQL(sql);

                }

            }
            // loop through the measurements for the lab and insert them

            for (int i = 0; i < h.getOBRCount(); i++) {
                for (int j = 0; j < h.getOBXCount(i); j++) {

                    String result = h.getOBXResult(i, j);

                    // only insert if there is a result and it is supposed to be viewed
                    if (result.equals("") || result.equals("DNR") || h.getOBXName(i, j).equals("") || h.getOBXResultStatus(i, j).equals("DNS")) continue;

                    logger.info("obx(" + j + ") should be inserted");
                    String identifier = h.getOBXIdentifier(i, j);
                    String abnormal = h.getOBXAbnormalFlag(i, j);
                    if (abnormal != null && (abnormal.equals("A") || abnormal.startsWith("H"))) {
                        abnormal = "A";
                    }
                    else if (abnormal != null && abnormal.startsWith("L")) {
                        abnormal = "L";
                    }
                    else {
                        abnormal = "N";
                    }

                    String sql = "SELECT b.ident_code, type.measuringInstruction FROM measurementMap a, measurementMap b, measurementType type WHERE b.lab_type='FLOWSHEET' AND a.ident_code='" + identifier + "' AND a.loinc_code = b.loinc_code and type.type = b.ident_code";
                    ps = c.prepareStatement(sql);
                    String measType = "";
                    String measInst = "";
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        measType = rs.getString("ident_code");
                        measInst = rs.getString("measuringInstruction");
                    }

                    sql = "INSERT INTO measurements (type, demographicNo, providerNo, dataField, measuringInstruction, dateObserved, dateEntered )VALUES ('" + measType + "', '" + demographic_no + "', '0', '" + result + "', '" + measInst + "', '" + h.getTimeStamp(i, j) + "', '" + dateEntered + "')";
                    logger.info(sql);
                    ps = c.prepareStatement(sql);
                    ps.executeUpdate();
                    rs = ps.getGeneratedKeys();
                    String insertID = null;
                    if (rs.next()) insertID = rs.getString(1);

                    sql = "INSERT INTO measurementsExt (measurement_id, keyval, val) VALUES ('" + insertID + "', 'lab_no', '" + lab_no + "')";
                    logger.info(sql);
                    ps = c.prepareStatement(sql);
                    ps.executeUpdate();

                    sql = "INSERT INTO measurementsExt (measurement_id, keyval, val) VALUES ('" + insertID + "', 'abnormal', '" + abnormal + "')";
                    logger.info(sql);
                    ps = c.prepareStatement(sql);
                    ps.executeUpdate();

                    sql = "INSERT INTO measurementsExt (measurement_id, keyval, val) VALUES ('" + insertID + "', 'identifier', '" + identifier + "')";
                    logger.info(sql);
                    ps = c.prepareStatement(sql);
                    ps.executeUpdate();

                }
            }

            db.CloseConn();
        }
        catch (Exception e) {
            logger.error("Exception in HL7 populateMeasurementsTable", e);
        }
        finally {
            SqlUtils.closeResources(c, ps, rs);
        }

    }

    public String getMatchingLabs(String lab_no) {
        String sql = "SELECT a.lab_no, a.obr_date, b.obr_date as labDate FROM hl7TextInfo a, hl7TextInfo b WHERE a.accessionNum !='' AND a.accessionNum=b.accessionNum AND b.lab_no='" + lab_no + "' ORDER BY a.obr_date, a.final_result_count, a.lab_no";
        String ret = "";
        int monthsBetween = 0;

        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs = db.GetSQL(sql);

            while (rs.next()) {

                //Accession numbers may be recycled, accession
                //numbers for a lab should have lab dates within less than 4
                //months of eachother even this is a large timespan
                Date dateA = UtilDateUtilities.StringToDate(rs.getString("obr_date"), "yyyy-MM-dd hh:mm:ss");
                Date dateB = UtilDateUtilities.StringToDate(rs.getString("labDate"), "yyyy-MM-dd hh:mm:ss");
                if (dateA.before(dateB)) {
                    monthsBetween = UtilDateUtilities.getNumMonths(dateA, dateB);
                }
                else {
                    monthsBetween = UtilDateUtilities.getNumMonths(dateB, dateA);
                }
                logger.info("monthsBetween: " + monthsBetween);
                logger.info("lab_no: " + rs.getString("lab_no") + " lab: " + lab_no);
                if (monthsBetween < 4) {
                    if (ret.equals("")) ret = rs.getString("lab_no");
                    else ret = ret + "," + rs.getString("lab_no");
                }
            }
            rs.close();
            db.CloseConn();
        }
        catch (Exception e) {
            logger.error("Exception in HL7 getMatchingLabs: ", e);
        }
        if (ret.equals("")) return(lab_no);
        else return(ret);
    }

    /**
     *Populates ArrayList with labs attached to a consultation request
     */
    public ArrayList populateHL7ResultsData(String demographicNo, String consultationId, boolean attached) {
        String sql = "SELECT hl7.lab_no, hl7.obr_date, hl7.discipline, hl7.accessionNum, hl7.final_result_count, patientLabRouting.id " + "FROM hl7TextInfo hl7, patientLabRouting " + "WHERE patientLabRouting.lab_no = hl7.lab_no " + "AND patientLabRouting.lab_type = 'HL7' AND patientLabRouting.demographic_no=" + demographicNo;

        String attachQuery = "SELECT consultdocs.document_no FROM consultdocs, patientLabRouting " + "WHERE patientLabRouting.id = consultdocs.document_no AND " + "consultdocs.requestId = " + consultationId + " AND consultdocs.doctype = 'L' AND consultdocs.deleted IS NULL ORDER BY consultdocs.document_no";

        ArrayList labResults = new ArrayList();
        ArrayList attachedLabs = new ArrayList();
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);

            ResultSet rs = db.GetSQL(attachQuery);
            while (rs.next()) {
                LabResultData lbData = new LabResultData(LabResultData.HL7TEXT);
                lbData.labPatientId = rs.getString("document_no");
                attachedLabs.add(lbData);
            }
            rs.close();

            LabResultData lbData = new LabResultData(LabResultData.HL7TEXT);
            LabResultData.CompareId c = lbData.getComparatorId();
            rs = db.GetSQL(sql);

            while (rs.next()) {

                lbData.labType = LabResultData.HL7TEXT;
                lbData.segmentID = rs.getString("lab_no");
                lbData.labPatientId = rs.getString("id");
                lbData.dateTime = rs.getString("obr_date");
                lbData.discipline = rs.getString("discipline");
                lbData.accessionNumber = rs.getString("accessionNum");
                lbData.finalResultsCount = rs.getInt("final_result_count");

                if (attached && Collections.binarySearch(attachedLabs, lbData, c) >= 0) labResults.add(lbData);
                else if (!attached && Collections.binarySearch(attachedLabs, lbData, c) < 0) labResults.add(lbData);

                lbData = new LabResultData(LabResultData.EXCELLERIS);
            }
            rs.close();
            db.CloseConn();
        }
        catch (Exception e) {
            logger.error("exception in HL7Populate", e);
        }
        return labResults;
    }

    public ArrayList populateHl7ResultsData(String providerNo, String demographicNo, String patientFirstName, String patientLastName, String patientHealthNumber, String status) {

        if (providerNo == null) {
            providerNo = "";
        }
        if (patientFirstName == null) {
            patientFirstName = "";
        }
        if (patientLastName == null) {
            patientLastName = "";
        }
        if (patientHealthNumber == null) {
            patientHealthNumber = "";
        }
        if (status == null) {
            status = "";
        }

        ArrayList labResults = new ArrayList();
        String sql = "";
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            if (demographicNo == null) {
                // note to self: lab reports not found in the providerLabRouting table will not show up - need to ensure every lab is entered in providerLabRouting, with '0'
                // for the provider number if unable to find correct provider

                sql = "select info.lab_no, info.sex, info.health_no, info.result_status, info.obr_date, info.priority, info.requesting_client, info.discipline, info.last_name, info.first_name, info.report_status, info.accessionNum, info.final_result_count, providerLabRouting.status " + "from hl7TextInfo info, providerLabRouting " + " where info.lab_no = providerLabRouting.lab_no " + " AND providerLabRouting.status like '%" + status + "%' AND providerLabRouting.provider_no like '"
                        + (providerNo.equals("")?"%":providerNo) + "'" + " AND providerLabRouting.lab_type = 'HL7' " + " AND info.first_name like '" + patientFirstName + "%' AND info.last_name like '" + patientLastName + "%' AND info.health_no like '%" + patientHealthNumber + "%' ";

            }
            else {

                sql = "select info.lab_no, info.sex, info.health_no, info.result_status, info.obr_date, info.priority, info.requesting_client, info.discipline, info.last_name, info.first_name, info.report_status, info.accessionNum, info.final_result_count " + "from hl7TextInfo info, patientLabRouting " + " where info.lab_no = patientLabRouting.lab_no " + " AND patientLabRouting.lab_type = 'HL7' AND patientLabRouting.demographic_no='" + demographicNo + "' ";
            }

            logger.info(sql);
            ResultSet rs = db.GetSQL(sql);
            while (rs.next()) {

                LabResultData lbData = new LabResultData(LabResultData.HL7TEXT);
                lbData.labType = LabResultData.HL7TEXT;
                lbData.segmentID = rs.getString("lab_no");

                if (demographicNo == null && !providerNo.equals("0")) {
                    lbData.acknowledgedStatus = rs.getString("status");
                }
                else {
                    lbData.acknowledgedStatus = "U";
                }

                lbData.accessionNumber = rs.getString("accessionNum");
                lbData.healthNumber = rs.getString("health_no");
                lbData.patientName = rs.getString("last_name") + ", " + rs.getString("first_name");
                lbData.sex = rs.getString("sex");

                lbData.resultStatus = rs.getString("result_status");
                if (lbData.resultStatus.equals("A")) lbData.abn = true;

                lbData.dateTime = rs.getString("obr_date");

                //priority
                String priority = rs.getString("priority");

                if (priority != null && !priority.equals("")) {
                    switch (priority.charAt(0)) {
                        case 'C':
                            lbData.priority = "Critical";
                        break;
                        case 'S':
                            lbData.priority = "Stat/Urgent";
                        break;
                        case 'U':
                            lbData.priority = "Unclaimed";
                        break;
                        case 'A':
                            lbData.priority = "ASAP";
                        break;
                        case 'L':
                            lbData.priority = "Alert";
                        break;
                        default:
                            lbData.priority = "Routine";
                        break;
                    }
                }
                else {
                    lbData.priority = "----";
                }

                lbData.requestingClient = rs.getString("requesting_client");
                lbData.reportStatus = rs.getString("report_status");

                if (lbData.reportStatus != null && lbData.reportStatus.equals("F")) {
                    lbData.finalRes = true;
                }
                else {
                    lbData.finalRes = false;
                }

                lbData.discipline = rs.getString("discipline");
                lbData.finalResultsCount = rs.getInt("final_result_count");
                labResults.add(lbData);
            }
            rs.close();
            db.CloseConn();
        }
        catch (Exception e) {
            logger.error("exception in Hl7Populate:", e);
        }
        return labResults;
    }

}
