/*
 *  Copyright (C) 2007  Heart & Stroke Foundation

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

 <HSFO TEAM>
 *
 * This software was written for the
 * The Heart and Stroke Foundation of Ontario
 * Toronto, Ontario, Canada
 *
 * Created on March 1, 2007, 11:53 PM
 *
 */

package oscar.form.study.HSFO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import org.oscarehr.util.SpringUtils;

import oscar.oscarDB.DBHandler;
import oscar.util.SqlUtils;

/**
 *Class used by the HSFO Study
 * 
 */
public class HSFODAO {

    /** Creates a new instance of HSFODAO */
    public HSFODAO() {
    }

    public void savePatient(PatientData patientData) throws SQLException {
        if (isFirstRecord(patientData.getPatient_Id())) {
            insertPatient(patientData);
        }
        else {
            updatePatient(patientData);
        }
    }

    public void insertPatient(PatientData patientData) throws SQLException {
        PreparedStatement st = null;
        String sqlstatement = "INSERT into hsfo_patient " + "(SiteCode,Patient_Id,FName,LName,BirthDate,Sex,PostalCode,Height,Height_unit,Ethnic_White,Ethnic_Black,Ethnic_EIndian,Ethnic_Pakistani,Ethnic_SriLankan,Ethnic_Bangladeshi,Ethnic_Chinese,Ethnic_Japanese,Ethnic_Korean,Ethnic_Hispanic,Ethnic_FirstNation,Ethnic_Other,Ethnic_Refused,Ethnic_Unknown,PharmacyName,PharmacyLocation,Sel_TimeAgoDx,EmrHCPId,ConsentDate)" + "values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

        System.out.println(sqlstatement);
        Connection connect = SpringUtils.getDbConnection();
        try {
            st = connect.prepareStatement(sqlstatement);

            st.setString(1, patientData.getSiteCode());
            st.setString(2, patientData.getPatient_Id());
            st.setString(3, patientData.getFName());
            st.setString(4, patientData.getLName());
            st.setDate(5, new java.sql.Date(patientData.getBirthDate().getTime()));
            st.setString(6, patientData.getSex());
            st.setString(7, patientData.getPostalCode());
            st.setDouble(8, patientData.getHeight());
            st.setString(9, patientData.getHeight_unit());
            st.setBoolean(10, patientData.isEthnic_White());
            st.setBoolean(11, patientData.isEthnic_Black());
            st.setBoolean(12, patientData.isEthnic_EIndian());
            st.setBoolean(13, patientData.isEthnic_Pakistani());
            st.setBoolean(14, patientData.isEthnic_SriLankan());
            st.setBoolean(15, patientData.isEthnic_Bangladeshi());
            st.setBoolean(16, patientData.isEthnic_Chinese());
            st.setBoolean(17, patientData.isEthnic_Japanese());
            st.setBoolean(18, patientData.isEthnic_Korean());
            st.setBoolean(19, patientData.isEthnic_Hispanic());
            st.setBoolean(20, patientData.isEthnic_FirstNation());
            st.setBoolean(21, patientData.isEthnic_Other());
            st.setBoolean(22, patientData.isEthnic_Refused());
            st.setBoolean(23, patientData.isEthnic_Unknown());
            st.setString(24, patientData.getPharmacyName());
            st.setString(25, patientData.getPharmacyLocation());
            st.setString(26, patientData.getSel_TimeAgoDx());
            st.setString(27, patientData.getEmrHCPId());
            st.setDate(28, new java.sql.Date(patientData.getConsentDate().getTime()));
            st.executeUpdate();
            st.clearParameters();
            //st.close();        
            //db.CloseConn();
        }
        catch (SQLException se) {
            System.out.println("SQL Error while inserting into the database : " + se.toString());
            se.printStackTrace();
        }
        catch (Exception ne) {
            System.out.println("Other Error while inserting into the database : " + ne.toString());
            ne.printStackTrace();
        }
        finally {
            SqlUtils.closeResources(connect, st, null);
        }
    }

    public void updatePatient(PatientData patientData) throws SQLException {
        PreparedStatement st = null;
        String sqlstatement = "UPDATE hsfo_patient SET " + "SiteCode = ? " + //1'" + patientData.getSiteCode() +
                ",Patient_Id = ? " + //2'" + patientData.getPatient_Id() +
                ",FName = ? " + //3'" + patientData.getFName() +
                ",LName = ? " + //4'" + patientData.getLName() +
                ",BirthDate = ? " + //5'" + patientData.getBirthDate() +
                ",Sex = ? " + //6'" + patientData.getSex() +
                ",PostalCode = ? " + //7'" + patientData.getPostalCode() +
                ",Height = ? " + //8" + patientData.getHeight() +
                ",Height_unit = ? " + //9'" + patientData.getHeight_unit() +
                ",Ethnic_White = ? " + //10" +  patientData.isEthnic_White() +
                ",Ethnic_Black = ? " + //11" + patientData.isEthnic_Black() +
                ",Ethnic_EIndian = ? " + //12" + patientData.isEthnic_EIndian() +
                ",Ethnic_Pakistani = ? " + //13" + patientData.isEthnic_Pakistani() +
                ",Ethnic_SriLankan = ? " + //14" + patientData.isEthnic_SriLankan() +
                ",Ethnic_Bangladeshi = ? " + //15" + patientData.isEthnic_Bangladeshi() +
                ",Ethnic_Chinese = ? " + //16" + patientData.isEthnic_Chinese() +
                ",Ethnic_Japanese = ? " + //17" + patientData.isEthnic_Japanese() +
                ",Ethnic_Korean = ? " + //18" + patientData.isEthnic_Korean() +
                ",Ethnic_Hispanic = ? " + //19" + patientData.isEthnic_Hispanic() +
                ",Ethnic_FirstNation = ? " + //20" + patientData.isEthnic_FirstNation() +
                ",Ethnic_Other = ? " + //21" + patientData.isEthnic_Other() +
                ",Ethnic_Refused = ? " + //22" + patientData.isEthnic_Refused() +
                ",Ethnic_Unknown = ? " + //23" + patientData.isEthnic_Unknown() +
                ",PharmacyName = ? " + //24'" + patientData.getPharmacyName() +
                ",PharmacyLocation = ? " + //25'" + patientData.getPharmacyLocation() +
                ",sel_TimeAgoDx = ? " + //26'" + patientData.getSel_TimeAgoDx() +
                ",EmrHCPId = ? " + //27'" +  patientData.getEmrHCPId() +
                ",ConsentDate = ? " + //28'" + new java.sql.Date(patientData.getConsentDate().getTime()) +
                " WHERE Patient_Id= ? "; //29'" + patientData.getPatient_Id() +"'";
        System.out.println(sqlstatement);
        Connection connect = SpringUtils.getDbConnection();
        try {
            st = connect.prepareStatement(sqlstatement);

            ///
            st.setString(1, patientData.getSiteCode());
            st.setString(2, patientData.getPatient_Id());
            st.setString(3, patientData.getFName());
            st.setString(4, patientData.getLName());
            st.setDate(5, new java.sql.Date(patientData.getBirthDate().getTime()));
            st.setString(6, patientData.getSex());
            st.setString(7, patientData.getPostalCode());
            st.setDouble(8, patientData.getHeight());
            st.setString(9, patientData.getHeight_unit());
            st.setBoolean(10, patientData.isEthnic_White());
            st.setBoolean(11, patientData.isEthnic_Black());
            st.setBoolean(12, patientData.isEthnic_EIndian());
            System.out.println("RIGHT BEFIRE UPDATE " + patientData.isEthnic_Pakistani());
            st.setBoolean(13, patientData.isEthnic_Pakistani());
            st.setBoolean(14, patientData.isEthnic_SriLankan());
            st.setBoolean(15, patientData.isEthnic_Bangladeshi());
            st.setBoolean(16, patientData.isEthnic_Chinese());
            st.setBoolean(17, patientData.isEthnic_Japanese());
            st.setBoolean(18, patientData.isEthnic_Korean());
            st.setBoolean(19, patientData.isEthnic_Hispanic());
            st.setBoolean(20, patientData.isEthnic_FirstNation());
            st.setBoolean(21, patientData.isEthnic_Other());
            st.setBoolean(22, patientData.isEthnic_Refused());
            st.setBoolean(23, patientData.isEthnic_Unknown());
            st.setString(24, patientData.getPharmacyName());
            st.setString(25, patientData.getPharmacyLocation());
            st.setString(26, patientData.getSel_TimeAgoDx());
            st.setString(27, patientData.getEmrHCPId());
            st.setDate(28, new java.sql.Date(patientData.getConsentDate().getTime()));
            st.setString(29, patientData.getPatient_Id());
            ///

            st.executeUpdate();
            st.clearParameters();
            //st.close();
            //db.CloseConn();
        }
        catch (SQLException se) {
            System.out.println("SQL Error while inserting into the database : " + se.toString());
        }
        catch (Exception ne) {
            System.out.println("Other Error while inserting into the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, st, null);
        }

    }

    public void lockVisit(int ID) throws SQLException {

        PreparedStatement st = null;
        String sqlstatement = "UPDATE form_hsfo_visit SET locked=true where ID=" + ID;
        System.out.println(sqlstatement);
        Connection connect = SpringUtils.getDbConnection();
        try {
            st = connect.prepareStatement(sqlstatement);
            st.executeUpdate();
            //db.CloseConn();
        }
        catch (SQLException se) {
            System.out.println("SQL Error while inserting into the database : " + se.toString());
        }
        catch (Exception ne) {
            System.out.println("Other Error while inserting into the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, st, null);
        }
        //st.close();
    }

    public int numberOfVisits(String demographic_no) throws SQLException {
        PreparedStatement st = null;
        String sqlstatement = "select distinct VisitDate_Id  from form_hsfo_visit where demographic_no = ? ";
        int i = 0;
        System.out.println(sqlstatement);
        ResultSet rs = null;
        Connection connect = SpringUtils.getDbConnection();
        try {
            st = connect.prepareStatement(sqlstatement);
            st.setString(1, demographic_no);
            rs = st.executeQuery();
            while (rs.next()) {
                i++;
            }
            //db.CloseConn();
        }
        catch (SQLException se) {
            System.out.println("SQL Error while inserting into the database : " + se.toString());
        }
        catch (Exception ne) {
            System.out.println("Other Error while inserting into the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, st, rs);
        }

        return i;

    }

    public boolean hasMoreThanOneVisit(String demographic_no) throws SQLException {
        boolean hasMoreThanOneVisit = false;
        if (numberOfVisits(demographic_no) > 1) {
            hasMoreThanOneVisit = true;
        }
        return hasMoreThanOneVisit;
    }

    public boolean hasLockedVisit(String demographic_no) throws SQLException {
        boolean hasLockedVisit = false;
        PreparedStatement st = null;
        String sqlstatement = "select * from form_hsfo_visit where locked=true and demographic_no = ?";
        System.out.println(sqlstatement);
        ResultSet rs = null;
        Connection connect = SpringUtils.getDbConnection();
        try {
            st = connect.prepareStatement(sqlstatement);
            st.setString(1, demographic_no);
            rs = st.executeQuery();
            if (rs.next()) {
                hasLockedVisit = true;
            }
            //db.CloseConn();
        }
        catch (SQLException se) {
            System.out.println("SQL Error while inserting into the database : " + se.toString());
        }
        catch (Exception ne) {
            System.out.println("Other Error while inserting into the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, st, rs);
        }
        return hasLockedVisit;
    }

    public int insertVisit(VisitData visitData, String provider_no) throws SQLException {
        int id = -1;
        String TC_DHL = "";
        if (visitData.getTC_HDL_LabresultsDate() != null && !visitData.getTC_HDL_LabresultsDate().equals("")) {
            TC_DHL = "'" + visitData.getTC_HDL_LabresultsDate() + "',";
        }
        else {
            TC_DHL = visitData.getTC_HDL_LabresultsDate() + ",";
        }
        String LDL = "";
        if (visitData.getLDL_LabresultsDate() != null && !visitData.getLDL_LabresultsDate().equals("")) {
            LDL = "'" + visitData.getLDL_LabresultsDate() + "',";
        }
        else {
            LDL = visitData.getLDL_LabresultsDate() + ",";
        }
        String HDL = "";
        if (visitData.getHDL_LabresultsDate() != null && !visitData.getHDL_LabresultsDate().equals("")) {
            HDL = "'" + visitData.getHDL_LabresultsDate() + "',";
        }
        else {
            HDL = visitData.getHDL_LabresultsDate() + ",";
        }
        String A1C = "";
        if (visitData.getA1C_LabresultsDate() != null && !visitData.getA1C_LabresultsDate().equals("")) {
            A1C = "'" + visitData.getA1C_LabresultsDate() + "',";
        }
        else {
            A1C = visitData.getA1C_LabresultsDate() + ",";
        }
        PreparedStatement st = null;
        String sqlstatement = "INSERT into form_hsfo_visit" + "(demographic_no,provider_no,formCreated,Patient_Id,VisitDate_Id,Drugcoverage,SBP,SBP_goal,DBP,DBP_goal," + "Bptru_used,Weight,Weight_unit,Waist,Waist_unit,TC_HDL,LDL,HDL,A1C,Nextvisit," + "Bpactionplan,PressureOff,PatientProvider,ABPM,Home,CommunityRes,ProRefer,HtnDxType,Dyslipid,Diabetes," + "KidneyDis,Obesity,CHD,Stroke_TIA,Risk_weight,Risk_activity,Risk_diet,Risk_smoking,Risk_alcohol,Risk_stress,"
                + "PtView,Change_importance,Change_confidence,Exercise_minPerWk,Smoking_cigsPerDay,Alcohol_drinksPerWk,Sel_DashDiet,Sel_HighSaltFood,Sel_Stressed,LifeGoal," + "FamHx_Htn,FamHx_Dyslipid,FamHx_Diabetes,FamHx_KidneyDis,FamHx_Obesity,FamHx_CHD,FamHx_Stroke_TIA,Diuret_rx,Diuret_SideEffects,Diuret_RxDecToday," + "Ace_rx,Ace_SideEffects,Ace_RxDecToday,Arecept_rx,Arecept_SideEffects,Arecept_RxDecToday,Beta_rx,Beta_SideEffects,Beta_RxDecToday,Calc_rx,"
                + "Calc_SideEffects,Calc_RxDecToday,Anti_rx,Anti_SideEffects,Anti_RxDecToday,Statin_rx,Statin_SideEffects,Statin_RxDecToday,Lipid_rx,Lipid_SideEffects," + "Lipid_RxDecToday,Hypo_rx,Hypo_SideEffects,Hypo_RxDecToday,Insul_rx,Insul_SideEffects,Insul_RxDecToday,Often_miss,Herbal,TC_HDL_LabresultsDate," + "LDL_LabresultsDate,HDL_LabresultsDate,A1C_LabresultsDate,Locked)" + " values " + "(?,?,now(),?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?,"
                + "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?)";

        System.out.println(sqlstatement);
        Connection connect = SpringUtils.getDbConnection();
        try {
            st = connect.prepareStatement(sqlstatement);
            //////

            st.setString(1, visitData.getPatient_Id());
            st.setString(2, provider_no);
            //now
            st.setString(3, visitData.getPatient_Id());
            st.setDate(4, new java.sql.Date(visitData.getVisitDate_Id().getTime()));
            st.setString(5, visitData.getDrugcoverage());
            st.setInt(6, visitData.getSBP());
            st.setInt(7, visitData.getSBP_goal());
            st.setInt(8, visitData.getDBP());
            st.setInt(9, visitData.getDBP_goal());
            st.setString(10, visitData.getBptru_used());
            st.setDouble(11, visitData.getWeight());
            st.setString(12, visitData.getWeight_unit());
            st.setDouble(13, visitData.getWaist());
            st.setString(14, visitData.getWaist_unit());
            st.setDouble(15, visitData.getTC_HDL());
            st.setDouble(16, visitData.getLDL());
            st.setDouble(17, visitData.getHDL());
            st.setDouble(18, visitData.getA1C());
            st.setString(19, visitData.getNextvisit());
            st.setBoolean(20, visitData.isBpactionplan());
            st.setBoolean(21, visitData.isPressureOff());
            st.setBoolean(22, visitData.isPatientProvider());
            st.setBoolean(23, visitData.isABPM());
            st.setBoolean(24, visitData.isHome());
            st.setBoolean(25, visitData.isCommunityRes());
            st.setBoolean(26, visitData.isProRefer());
            st.setString(27, visitData.getHtnDxType());
            st.setBoolean(28, visitData.isDyslipid());
            st.setBoolean(29, visitData.isDiabetes());
            st.setBoolean(30, visitData.isKidneyDis());
            st.setBoolean(31, visitData.isObesity());
            st.setBoolean(32, visitData.isCHD());
            st.setBoolean(33, visitData.isStroke_TIA());
            st.setBoolean(34, visitData.isRisk_weight());
            st.setBoolean(35, visitData.isRisk_activity());
            st.setBoolean(36, visitData.isRisk_diet());
            st.setBoolean(37, visitData.isRisk_smoking());
            st.setBoolean(38, visitData.isRisk_alcohol());
            st.setBoolean(39, visitData.isRisk_stress());
            st.setString(40, visitData.getPtView());
            st.setInt(41, visitData.getChange_importance());
            st.setInt(42, visitData.getChange_confidence());
            st.setInt(43, visitData.getExercise_minPerWk());
            st.setInt(44, visitData.getSmoking_cigsPerDay());
            st.setInt(45, visitData.getAlcohol_drinksPerWk());
            st.setString(46, visitData.getSel_DashDiet());
            st.setString(47, visitData.getSel_HighSaltFood());
            st.setString(48, visitData.getSel_Stressed());
            st.setString(49, visitData.getLifeGoal());
            st.setBoolean(50, visitData.isFamHx_Htn());
            st.setBoolean(51, visitData.isFamHx_Dyslipid());
            st.setBoolean(52, visitData.isFamHx_Diabetes());
            st.setBoolean(53, visitData.isFamHx_KidneyDis());
            st.setBoolean(54, visitData.isFamHx_Obesity());
            st.setBoolean(55, visitData.isFamHx_CHD());
            st.setBoolean(56, visitData.isFamHx_Stroke_TIA());
            st.setBoolean(57, visitData.isDiuret_rx());
            st.setBoolean(58, visitData.isDiuret_SideEffects());
            st.setString(59, visitData.getDiuret_RxDecToday());
            st.setBoolean(60, visitData.isAce_rx());
            st.setBoolean(61, visitData.isAce_SideEffects());
            st.setString(62, visitData.getAce_RxDecToday());
            st.setBoolean(63, visitData.isArecept_rx());
            st.setBoolean(64, visitData.isArecept_SideEffects());
            st.setString(65, visitData.getArecept_RxDecToday());
            st.setBoolean(66, visitData.isBeta_rx());
            st.setBoolean(67, visitData.isBeta_SideEffects());
            st.setString(68, visitData.getBeta_RxDecToday());
            st.setBoolean(69, visitData.isCalc_rx());
            st.setBoolean(70, visitData.isCalc_SideEffects());
            st.setString(71, visitData.getCalc_RxDecToday());
            st.setBoolean(72, visitData.isAnti_rx());
            st.setBoolean(73, visitData.isAnti_SideEffects());
            st.setString(74, visitData.getAnti_RxDecToday());
            st.setBoolean(75, visitData.isStatin_rx());
            st.setBoolean(76, visitData.isStatin_SideEffects());
            st.setString(77, visitData.getStatin_RxDecToday());
            st.setBoolean(78, visitData.isLipid_rx());
            st.setBoolean(79, visitData.isLipid_SideEffects());
            st.setString(80, visitData.getLipid_RxDecToday());
            st.setBoolean(81, visitData.isHypo_rx());
            st.setBoolean(82, visitData.isHypo_SideEffects());
            st.setString(83, visitData.getHypo_RxDecToday());
            st.setBoolean(84, visitData.isInsul_rx());
            st.setBoolean(85, visitData.isInsul_SideEffects());
            st.setString(86, visitData.getInsul_RxDecToday());
            st.setInt(87, visitData.getOften_miss());
            st.setString(88, visitData.getHerbal());
            st.setDate(89, getSQLDate(visitData.getTC_HDL_LabresultsDate()));
            st.setDate(90, getSQLDate(visitData.getLDL_LabresultsDate()));
            st.setDate(91, getSQLDate(visitData.getHDL_LabresultsDate()));
            st.setDate(92, getSQLDate(visitData.getA1C_LabresultsDate()));
            st.setBoolean(93, visitData.isLocked());

            //////
            st.executeUpdate();
            ResultSet rs = st.getGeneratedKeys();
            if (rs.next()) {
                id = rs.getInt(1);
            }
            st.clearParameters();
            //st.close();
            //db.CloseConn();
        }
        catch (SQLException se) {
            se.printStackTrace();
            System.out.println("SQL Error while inserting into the database : " + se.toString());
        }
        catch (Exception ne) {
            ne.printStackTrace();
            System.out.println("Other Error while inserting into the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, st, null);
        }
        return id;
    }

    public java.sql.Date getSQLDate(Date date) {
        if (date != null) {
            return new java.sql.Date(date.getTime());
        }
        return null;
    }

    // added by vic, hsfo
    public void updatePatientDx(String patientId, int hsfoRxDx) throws SQLException {
        String sql = "UPDATE hsfo_patient SET RxDx=?  WHERE Patient_Id=?";

        Connection connect = SpringUtils.getDbConnection();
        PreparedStatement ps = null;
        try {
            ps = connect.prepareStatement(sql);
            ps.setInt(1, hsfoRxDx);
            ps.setString(2, patientId);

            ps.execute();

        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }
        finally {
            SqlUtils.closeResources(connect, ps, null);
        }

    }

    // added by vic, hsfo
    /**
     * Get the Dx code of the patient.
     * 
     * @return -1 if patient is not enrolled or hsfo is not enabled.
     * @throws SQLException 
     */
    public int retrievePatientDx(String patientId) throws SQLException {
        // return -1 if hsfo is not enabled
        String hsfo = oscar.OscarProperties.getInstance().getProperty("hsfo.loginSiteCode");
        if (hsfo == null) return -1;

        String sql = "SELECT RxDx FROM hsfo_patient WHERE Patient_Id=?";

        Connection connect = SpringUtils.getDbConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = connect.prepareStatement(sql);
            ps.setString(1, patientId);

            ps.execute();

            rs = ps.getResultSet();
            if (rs.next()) {
                return rs.wasNull()?0:rs.getInt(1);
            }
            else return -1;

        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }
        finally {
            SqlUtils.closeResources(connect, ps, rs);
        }

    }

    public PatientData retrievePatientRecord(String ID) throws SQLException {
        PatientData patientData = new PatientData();

        String query = "SELECT * FROM hsfo_patient WHERE Patient_Id='" + ID + "'";
        System.out.println("query: " + query);
        Connection connect = SpringUtils.getDbConnection();
        Statement sql = null;
        ResultSet result = null;
        try {
            sql = connect.createStatement();
            result = sql.executeQuery(query);
            System.out.println("here " + query);
            // retrieve results and store into registrationData object
            while (result.next()) {

                patientData.setSiteCode(result.getString("SiteCode"));
                patientData.setPatient_Id(result.getString("Patient_Id"));
                patientData.setFName(result.getString("FName"));
                patientData.setLName(result.getString("LName"));
                patientData.setBirthDate(result.getDate("BirthDate"));
                patientData.setSex(result.getString("Sex"));
                patientData.setPostalCode(result.getString("PostalCode"));
                patientData.setHeight(result.getDouble("Height"));
                patientData.setHeight_unit(result.getString("Height_unit"));
                patientData.setEthnic_White(result.getBoolean("Ethnic_White"));
                patientData.setEthnic_Black(result.getBoolean("Ethnic_Black"));
                patientData.setEthnic_EIndian(result.getBoolean("Ethnic_EIndian"));
                patientData.setEthnic_Pakistani(result.getBoolean("Ethnic_Pakistani"));
                patientData.setEthnic_SriLankan(result.getBoolean("Ethnic_SriLankan"));
                patientData.setEthnic_Bangladeshi(result.getBoolean("Ethnic_Bangladeshi"));
                patientData.setEthnic_Chinese(result.getBoolean("Ethnic_Chinese"));
                patientData.setEthnic_Japanese(result.getBoolean("Ethnic_Japanese"));
                patientData.setEthnic_Korean(result.getBoolean("Ethnic_Korean"));
                patientData.setEthnic_Hispanic(result.getBoolean("Ethnic_Hispanic"));
                patientData.setEthnic_FirstNation(result.getBoolean("Ethnic_FirstNation"));
                patientData.setEthnic_Other(result.getBoolean("Ethnic_Other"));
                patientData.setEthnic_Refused(result.getBoolean("Ethnic_Refused"));
                patientData.setEthnic_Unknown(result.getBoolean("Ethnic_Unknown"));
                patientData.setPharmacyName(result.getString("PharmacyName"));
                patientData.setPharmacyLocation(result.getString("PharmacyLocation"));
                patientData.setSel_TimeAgoDx(result.getString("sel_TimeAgoDx"));
                patientData.setEmrHCPId(result.getString("EmrHCPId"));
                patientData.setConsentDate(result.getDate("ConsentDate"));

                System.out.println("ID:" + result.getString("Patient_Id") + " Name:" + result.getString("FName"));
                System.out.println(patientData.getPatient_Id() + patientData.getFName() + patientData.getLName());

            }
            //result.close();
            //sql.close();
            //db.CloseConn();
        }
        catch (SQLException se) {
            System.out.println("SQL Error while retreiving from the database : " + se.toString());
        }
        catch (Exception ne) {
            System.out.println("Other Error while retreiving to the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, sql, result);
        }
        return patientData;
    }

    public boolean isFirstRecord(String ID) throws SQLException {
        //check if this is a new record
        boolean isFirstRecord = true;

        String query = "SELECT FName FROM hsfo_patient WHERE Patient_Id='" + ID + "'";
        System.out.println("query: " + query);
        Connection connect = SpringUtils.getDbConnection();
        Statement sql = null;
        ResultSet result = null;
        try {
            sql = connect.createStatement();
            result = sql.executeQuery(query);
            System.out.println("here " + query);
            // retrieve results and store into registrationData object
            System.out.println("first");
            if (result.next()) {
                isFirstRecord = false;
            }
            //           result.close();
            //           sql.close();
            //           db.CloseConn();
        }
        catch (SQLException se) {
            System.out.println("SQL Error while retreiving from the database : " + se.toString());
        }
        catch (Exception ne) {
            System.out.println("Other Error while retreiving to the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, sql, result);
        }
        return isFirstRecord;
    }

    private VisitData parseVisitData(ResultSet result) throws Exception {
        VisitData visitData = new VisitData();
        visitData.setID(result.getInt("ID"));
        visitData.setPatient_Id(result.getString("Patient_Id"));
        visitData.setVisitDate_Id(result.getDate("VisitDate_Id"));
        visitData.setDrugcoverage(result.getString("Drugcoverage"));
        visitData.setSBP(result.getInt("SBP"));
        System.out.println("Retrieved sbp " + visitData.getSBP());
        visitData.setSBP_goal(result.getInt("SBP_goal"));
        visitData.setDBP(result.getInt("DBP"));
        visitData.setDBP_goal(result.getInt("DBP_goal"));
        visitData.setBptru_used(result.getString("Bptru_used"));
        visitData.setWeight(result.getDouble("Weight"));
        visitData.setWeight_unit(result.getString("Weight_unit"));
        visitData.setWaist(result.getDouble("Waist"));
        visitData.setWaist_unit(result.getString("Waist_unit"));
        visitData.setTC_HDL(result.getDouble("TC_HDL"));
        visitData.setLDL(result.getDouble("LDL"));
        visitData.setHDL(result.getDouble("HDL"));
        visitData.setA1C(result.getDouble("A1C"));
        visitData.setNextvisit(result.getString("Nextvisit"));
        visitData.setBpactionplan(result.getBoolean("Bpactionplan"));
        visitData.setPressureOff(result.getBoolean("PressureOff"));
        visitData.setPatientProvider(result.getBoolean("PatientProvider"));
        visitData.setABPM(result.getBoolean("ABPM"));
        visitData.setHome(result.getBoolean("Home"));
        visitData.setCommunityRes(result.getBoolean("CommunityRes"));
        visitData.setProRefer(result.getBoolean("ProRefer"));
        visitData.setHtnDxType(result.getString("HtnDxType"));
        visitData.setDyslipid(result.getBoolean("Dyslipid"));
        visitData.setDiabetes(result.getBoolean("Diabetes"));
        visitData.setKidneyDis(result.getBoolean("KidneyDis"));
        visitData.setObesity(result.getBoolean("Obesity"));
        visitData.setCHD(result.getBoolean("CHD"));
        visitData.setStroke_TIA(result.getBoolean("Stroke_TIA"));
        visitData.setRisk_weight(result.getBoolean("Risk_weight"));
        visitData.setRisk_activity(result.getBoolean("Risk_activity"));
        visitData.setRisk_diet(result.getBoolean("Risk_diet"));
        visitData.setRisk_smoking(result.getBoolean("Risk_smoking"));
        visitData.setRisk_alcohol(result.getBoolean("Risk_alcohol"));
        visitData.setRisk_stress(result.getBoolean("Risk_stress"));
        visitData.setPtView(result.getString("PtView"));
        visitData.setChange_importance(result.getInt("Change_importance"));
        visitData.setChange_confidence(result.getInt("Change_confidence"));
        visitData.setExercise_minPerWk(result.getInt("exercise_minPerWk"));
        visitData.setSmoking_cigsPerDay(result.getInt("smoking_cigsPerDay"));
        visitData.setAlcohol_drinksPerWk(result.getInt("alcohol_drinksPerWk"));
        visitData.setSel_DashDiet(result.getString("sel_DashDiet"));
        visitData.setSel_HighSaltFood(result.getString("sel_HighSaltFood"));
        visitData.setSel_Stressed(result.getString("sel_Stressed"));
        visitData.setLifeGoal(result.getString("LifeGoal"));
        visitData.setFamHx_Htn(result.getBoolean("FamHx_Htn"));
        visitData.setFamHx_Dyslipid(result.getBoolean("FamHx_Dyslipid"));
        visitData.setFamHx_Diabetes(result.getBoolean("FamHx_Diabetes"));
        visitData.setFamHx_KidneyDis(result.getBoolean("FamHx_KidneyDis"));
        visitData.setFamHx_Obesity(result.getBoolean("FamHx_Obesity"));
        visitData.setFamHx_CHD(result.getBoolean("FamHx_CHD"));
        visitData.setFamHx_Stroke_TIA(result.getBoolean("FamHx_Stroke_TIA"));
        visitData.setDiuret_rx(result.getBoolean("Diuret_rx"));
        visitData.setDiuret_SideEffects(result.getBoolean("Diuret_SideEffects"));
        visitData.setDiuret_RxDecToday(result.getString("Diuret_RxDecToday"));
        visitData.setAce_rx(result.getBoolean("Ace_rx"));
        visitData.setAce_SideEffects(result.getBoolean("Ace_SideEffects"));
        visitData.setAce_RxDecToday(result.getString("Ace_RxDecToday"));
        visitData.setArecept_rx(result.getBoolean("Arecept_rx"));
        visitData.setArecept_SideEffects(result.getBoolean("Arecept_SideEffects"));
        visitData.setArecept_RxDecToday(result.getString("Arecept_RxDecToday"));
        visitData.setBeta_rx(result.getBoolean("Beta_rx"));
        visitData.setBeta_SideEffects(result.getBoolean("Beta_SideEffects"));
        visitData.setBeta_RxDecToday(result.getString("Beta_RxDecToday"));
        visitData.setCalc_rx(result.getBoolean("Calc_rx"));
        visitData.setCalc_SideEffects(result.getBoolean("Calc_SideEffects"));
        visitData.setCalc_RxDecToday(result.getString("Calc_RxDecToday"));
        visitData.setAnti_rx(result.getBoolean("Anti_rx"));
        visitData.setAnti_SideEffects(result.getBoolean("Anti_SideEffects"));
        visitData.setAnti_RxDecToday(result.getString("Anti_RxDecToday"));
        visitData.setStatin_rx(result.getBoolean("Statin_rx"));
        visitData.setStatin_SideEffects(result.getBoolean("Statin_SideEffects"));
        visitData.setStatin_RxDecToday(result.getString("Statin_RxDecToday"));
        visitData.setLipid_rx(result.getBoolean("Lipid_rx"));
        visitData.setLipid_SideEffects(result.getBoolean("Lipid_SideEffects"));
        visitData.setLipid_RxDecToday(result.getString("Lipid_RxDecToday"));
        visitData.setHypo_rx(result.getBoolean("Hypo_rx"));
        visitData.setHypo_SideEffects(result.getBoolean("Hypo_SideEffects"));
        visitData.setHypo_RxDecToday(result.getString("Hypo_RxDecToday"));
        visitData.setInsul_rx(result.getBoolean("Insul_rx"));
        visitData.setInsul_SideEffects(result.getBoolean("Insul_SideEffects"));
        visitData.setInsul_RxDecToday(result.getString("Insul_RxDecToday"));
        visitData.setOften_miss(result.getInt("Often_miss"));
        visitData.setHerbal(result.getString("Herbal"));
        visitData.setTC_HDL_LabresultsDate(result.getDate("TC_HDL_LabresultsDate"));
        visitData.setLDL_LabresultsDate(result.getDate("LDL_LabresultsDate"));
        visitData.setHDL_LabresultsDate(result.getDate("HDL_LabresultsDate"));
        visitData.setA1C_LabresultsDate(result.getDate("A1C_LabresultsDate"));
        visitData.setLocked(result.getBoolean("Locked"));
        return visitData;
    }

    public List retrieveVisitRecord(String ID) throws SQLException {

        PatientList StorageList = new PatientList();
        List patientList = new LinkedList();
        DBHandler db = null;
        PreparedStatement query = null;
        ResultSet rs = null;
        Connection connect = SpringUtils.getDbConnection();
        try {
            query = connect.prepareStatement("SELECT * FROM form_hsfo_visit where ID in (SELECT max(ID) FROM form_hsfo_visit WHERE Patient_Id = ? group by VisitDate_Id)");
            query.setString(1, ID);

            rs = query.executeQuery();
            while (rs.next()) {
                patientList.add(parseVisitData(rs));
            }
            //            rs.close();
            //            query.clearParameters();
            //            query.close();
            //            
            //            db.CloseConn();
        }
        catch (SQLException se) {
            System.out.println("SQL Error while retreiving from the database : " + se.toString());
        }
        catch (Exception ne) {
            System.out.println("Other Error while retreiving to the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, query, rs);
        }

        return patientList;
    }

    public VisitData retrieveLatestRecord(Date visitdate, String demographic_no) throws SQLException {
        VisitData visitData = new VisitData();
        //String query = "SELECT MAX(FormEdited) as Max FROM form_hsfo_Visit WHERE VisitDate_Id='" + visitdate + "' and demographic_no = '"+demographic_no+"' ";
        String query = "SELECT ID FROM form_hsfo_Visit WHERE VisitDate_Id='" + visitdate + "' and demographic_no = '" + demographic_no + "' ";

        System.out.println("query1: " + query);
        String timestamp = "";
        Connection connect = SpringUtils.getDbConnection();
        Statement sql=null;
        try {
            sql = connect.createStatement();
            try {
                ResultSet result = sql.executeQuery(query);
                // retrieve results and store into registrationData object
                while (result.next()) {
                    timestamp = (result.getString("ID"));
                    System.out.println("Max timestamp:" + result.getString("Max"));
                }
            }
            catch (SQLException se) {
                System.out.println("SQL Error while retreiving from the database : " + se.toString());
            }
            catch (Exception ne) {
                System.out.println("Other Error while retreiving to the database : " + ne.toString());
            }

            String query2 = "SELECT DISTINCT * FROM form_hsfo_Visit WHERE ID='" + timestamp + "'";
            System.out.println("query2: " + query2);
            try {
                ResultSet result = sql.executeQuery(query2);
                // retrieve results and store into registrationData object
                while (result.next()) {
                    visitData.setID(result.getInt("ID"));
                    visitData.setPatient_Id(result.getString("Patient_Id"));
                    visitData.setVisitDate_Id(result.getDate("VisitDate_Id"));
                    visitData.setFormCreated(result.getDate("FormCreated"));
                    visitData.setFormEdited(result.getTimestamp("FormEdited"));
                    visitData.setDrugcoverage(result.getString("Drugcoverage"));
                    visitData.setSBP(result.getInt("SBP"));
                    visitData.setSBP_goal(result.getInt("SBP_goal"));
                    visitData.setDBP(result.getInt("DBP"));
                    visitData.setDBP_goal(result.getInt("DBP_goal"));
                    visitData.setBptru_used(result.getString("Bptru_used"));
                    visitData.setWeight(result.getDouble("Weight"));
                    visitData.setWeight_unit(result.getString("Weight_unit"));
                    visitData.setWaist(result.getDouble("Waist"));
                    visitData.setWaist_unit(result.getString("Waist_unit"));
                    visitData.setTC_HDL(result.getDouble("TC_HDL"));
                    visitData.setLDL(result.getDouble("LDL"));
                    visitData.setHDL(result.getDouble("HDL"));
                    visitData.setA1C(result.getDouble("A1C"));
                    visitData.setNextvisit(result.getString("Nextvisit"));
                    visitData.setBpactionplan(result.getBoolean("Bpactionplan"));
                    visitData.setPressureOff(result.getBoolean("PressureOff"));
                    visitData.setPatientProvider(result.getBoolean("PatientProvider"));
                    visitData.setABPM(result.getBoolean("ABPM"));
                    visitData.setHome(result.getBoolean("Home"));
                    visitData.setCommunityRes(result.getBoolean("CommunityRes"));
                    visitData.setProRefer(result.getBoolean("ProRefer"));
                    visitData.setHtnDxType(result.getString("HtnDxType"));
                    visitData.setDyslipid(result.getBoolean("Dyslipid"));
                    visitData.setDiabetes(result.getBoolean("Diabetes"));
                    visitData.setKidneyDis(result.getBoolean("KidneyDis"));
                    visitData.setObesity(result.getBoolean("Obesity"));
                    visitData.setCHD(result.getBoolean("CHD"));
                    visitData.setStroke_TIA(result.getBoolean("Stroke_TIA"));
                    visitData.setRisk_weight(result.getBoolean("Risk_weight"));
                    visitData.setRisk_activity(result.getBoolean("Risk_activity"));
                    visitData.setRisk_diet(result.getBoolean("Risk_diet"));
                    visitData.setRisk_smoking(result.getBoolean("Risk_smoking"));
                    visitData.setRisk_alcohol(result.getBoolean("Risk_alcohol"));
                    visitData.setRisk_stress(result.getBoolean("Risk_stress"));
                    visitData.setPtView(result.getString("PtView"));
                    visitData.setChange_importance(result.getInt("Change_importance"));
                    visitData.setChange_confidence(result.getInt("Change_confidence"));
                    visitData.setExercise_minPerWk(result.getInt("exercise_minPerWk"));
                    visitData.setSmoking_cigsPerDay(result.getInt("smoking_cigsPerDay"));
                    visitData.setAlcohol_drinksPerWk(result.getInt("alcohol_drinksPerWk"));
                    visitData.setSel_DashDiet(result.getString("sel_DashDiet"));
                    visitData.setSel_HighSaltFood(result.getString("sel_HighSaltFood"));
                    visitData.setSel_Stressed(result.getString("sel_Stressed"));
                    visitData.setLifeGoal(result.getString("LifeGoal"));
                    visitData.setFamHx_Htn(result.getBoolean("FamHx_Htn"));
                    visitData.setFamHx_Dyslipid(result.getBoolean("FamHx_Dyslipid"));
                    visitData.setFamHx_Diabetes(result.getBoolean("FamHx_Diabetes"));
                    visitData.setFamHx_KidneyDis(result.getBoolean("FamHx_KidneyDis"));
                    visitData.setFamHx_Obesity(result.getBoolean("FamHx_Obesity"));
                    visitData.setFamHx_CHD(result.getBoolean("FamHx_CHD"));
                    visitData.setFamHx_Stroke_TIA(result.getBoolean("FamHx_Stroke_TIA"));
                    visitData.setDiuret_rx(result.getBoolean("Diuret_rx"));
                    visitData.setDiuret_SideEffects(result.getBoolean("Diuret_SideEffects"));
                    visitData.setDiuret_RxDecToday(result.getString("Diuret_RxDecToday"));
                    visitData.setAce_rx(result.getBoolean("Ace_rx"));
                    visitData.setAce_SideEffects(result.getBoolean("Ace_SideEffects"));
                    visitData.setAce_RxDecToday(result.getString("Ace_RxDecToday"));
                    visitData.setArecept_rx(result.getBoolean("Arecept_rx"));
                    visitData.setArecept_SideEffects(result.getBoolean("Arecept_SideEffects"));
                    visitData.setArecept_RxDecToday(result.getString("Arecept_RxDecToday"));
                    visitData.setBeta_rx(result.getBoolean("Beta_rx"));
                    visitData.setBeta_SideEffects(result.getBoolean("Beta_SideEffects"));
                    visitData.setBeta_RxDecToday(result.getString("Beta_RxDecToday"));
                    visitData.setCalc_rx(result.getBoolean("Calc_rx"));
                    visitData.setCalc_SideEffects(result.getBoolean("Calc_SideEffects"));
                    visitData.setCalc_RxDecToday(result.getString("Calc_RxDecToday"));
                    visitData.setAnti_rx(result.getBoolean("Anti_rx"));
                    visitData.setAnti_SideEffects(result.getBoolean("Anti_SideEffects"));
                    visitData.setAnti_RxDecToday(result.getString("Anti_RxDecToday"));
                    visitData.setStatin_rx(result.getBoolean("Statin_rx"));
                    visitData.setStatin_SideEffects(result.getBoolean("Statin_SideEffects"));
                    visitData.setStatin_RxDecToday(result.getString("Statin_RxDecToday"));
                    visitData.setLipid_rx(result.getBoolean("Lipid_rx"));
                    visitData.setLipid_SideEffects(result.getBoolean("Lipid_SideEffects"));
                    visitData.setLipid_RxDecToday(result.getString("Lipid_RxDecToday"));
                    visitData.setHypo_rx(result.getBoolean("Hypo_rx"));
                    visitData.setHypo_SideEffects(result.getBoolean("Hypo_SideEffects"));
                    visitData.setHypo_RxDecToday(result.getString("Hypo_RxDecToday"));
                    visitData.setInsul_rx(result.getBoolean("Insul_rx"));
                    visitData.setInsul_SideEffects(result.getBoolean("Insul_SideEffects"));
                    visitData.setInsul_RxDecToday(result.getString("Insul_RxDecToday"));
                    visitData.setOften_miss(result.getInt("Often_miss"));
                    visitData.setHerbal(result.getString("Herbal"));
                    visitData.setTC_HDL_LabresultsDate(result.getDate("TC_HDL_LabresultsDate"));
                    visitData.setLDL_LabresultsDate(result.getDate("LDL_LabresultsDate"));
                    visitData.setHDL_LabresultsDate(result.getDate("HDL_LabresultsDate"));
                    visitData.setA1C_LabresultsDate(result.getDate("A1C_LabresultsDate"));
                    visitData.setLocked(result.getBoolean("Locked"));
                }
            }
            catch (SQLException se) {
                System.out.println("SQL Error while retreiving from the database : " + se.toString());
            }
            catch (Exception ne) {
                System.out.println("Other Error while retreiving to the database : " + ne.toString());
            }
        }
        finally {
            SqlUtils.closeResources(connect, sql, null);
        }

        return visitData;
    }

    //check if this is a new record
    public boolean isRecordExists(Date visitdate, String demographicNo) throws SQLException {
        boolean isRecordExists = false;
        PreparedStatement sql = null;
        Connection connect = SpringUtils.getDbConnection();
        try {
            int ID = 0;
            String query = "SELECT ID FROM form_hsfo_visit WHERE VisitDate_Id= ? and demographic_no = ?";
            sql = connect.prepareStatement(query);
            sql.setDate(1, new java.sql.Date(visitdate.getTime()));
            sql.setString(2, demographicNo);
            System.out.println("query: " + query);

            ResultSet result = sql.executeQuery();
            if (result.next()) {
                isRecordExists = true;
            }
            System.out.println("ID retrieved: " + ID);
            //            sql.close();
            //            db.CloseConn();
        }
        catch (Exception e) {

        }
        finally {
            SqlUtils.closeResources(connect, sql, null);
        }
        return isRecordExists;
    }

    //

    public VisitData retrieveSelectedRecord(int ID) throws SQLException {
        VisitData visitData = new VisitData();
        Connection connect = SpringUtils.getDbConnection();
        Statement sql = null;
        ResultSet result = null;
        String query = "SELECT DISTINCT * FROM form_hsfo_visit WHERE  ID = " + ID;;
        System.out.println("query: " + query);
        try {
            sql = connect.createStatement();
            result = sql.executeQuery(query);
            // retrieve results and store into registrationData object
            while (result.next()) {
                visitData.setID(result.getInt("ID"));
                visitData.setPatient_Id(result.getString("Patient_Id"));
                visitData.setVisitDate_Id(result.getDate("VisitDate_Id"));
                visitData.setFormCreated(result.getDate("FormCreated"));
                visitData.setFormEdited(result.getTimestamp("FormEdited"));
                visitData.setDrugcoverage(result.getString("Drugcoverage"));
                visitData.setSBP(result.getInt("SBP"));
                visitData.setSBP_goal(result.getInt("SBP_goal"));
                visitData.setDBP(result.getInt("DBP"));
                visitData.setDBP_goal(result.getInt("DBP_goal"));
                visitData.setBptru_used(result.getString("Bptru_used"));
                visitData.setWeight(result.getDouble("Weight"));
                visitData.setWeight_unit(result.getString("Weight_unit"));
                visitData.setWaist(result.getDouble("Waist"));
                visitData.setWaist_unit(result.getString("Waist_unit"));
                visitData.setTC_HDL(result.getDouble("TC_HDL"));
                visitData.setLDL(result.getDouble("LDL"));
                visitData.setHDL(result.getDouble("HDL"));
                visitData.setA1C(result.getDouble("A1C"));
                visitData.setNextvisit(result.getString("Nextvisit"));
                visitData.setBpactionplan(result.getBoolean("Bpactionplan"));
                visitData.setPressureOff(result.getBoolean("PressureOff"));
                visitData.setPatientProvider(result.getBoolean("PatientProvider"));
                visitData.setABPM(result.getBoolean("ABPM"));
                visitData.setHome(result.getBoolean("Home"));
                visitData.setCommunityRes(result.getBoolean("CommunityRes"));
                visitData.setProRefer(result.getBoolean("ProRefer"));
                visitData.setHtnDxType(result.getString("HtnDxType"));
                visitData.setDyslipid(result.getBoolean("Dyslipid"));
                visitData.setDiabetes(result.getBoolean("Diabetes"));
                visitData.setKidneyDis(result.getBoolean("KidneyDis"));
                visitData.setObesity(result.getBoolean("Obesity"));
                visitData.setCHD(result.getBoolean("CHD"));
                visitData.setStroke_TIA(result.getBoolean("Stroke_TIA"));
                visitData.setRisk_weight(result.getBoolean("Risk_weight"));
                visitData.setRisk_activity(result.getBoolean("Risk_activity"));
                visitData.setRisk_diet(result.getBoolean("Risk_diet"));
                visitData.setRisk_smoking(result.getBoolean("Risk_smoking"));
                visitData.setRisk_alcohol(result.getBoolean("Risk_alcohol"));
                visitData.setRisk_stress(result.getBoolean("Risk_stress"));
                visitData.setPtView(result.getString("PtView"));
                visitData.setChange_importance(result.getInt("Change_importance"));
                visitData.setChange_confidence(result.getInt("Change_confidence"));
                visitData.setExercise_minPerWk(result.getInt("exercise_minPerWk"));
                visitData.setSmoking_cigsPerDay(result.getInt("smoking_cigsPerDay"));
                visitData.setAlcohol_drinksPerWk(result.getInt("alcohol_drinksPerWk"));
                visitData.setSel_DashDiet(result.getString("sel_DashDiet"));
                visitData.setSel_HighSaltFood(result.getString("sel_HighSaltFood"));
                visitData.setSel_Stressed(result.getString("sel_Stressed"));
                visitData.setLifeGoal(result.getString("LifeGoal"));
                visitData.setFamHx_Htn(result.getBoolean("FamHx_Htn"));
                visitData.setFamHx_Dyslipid(result.getBoolean("FamHx_Dyslipid"));
                visitData.setFamHx_Diabetes(result.getBoolean("FamHx_Diabetes"));
                visitData.setFamHx_KidneyDis(result.getBoolean("FamHx_KidneyDis"));
                visitData.setFamHx_Obesity(result.getBoolean("FamHx_Obesity"));
                visitData.setFamHx_CHD(result.getBoolean("FamHx_CHD"));
                visitData.setFamHx_Stroke_TIA(result.getBoolean("FamHx_Stroke_TIA"));
                visitData.setDiuret_rx(result.getBoolean("Diuret_rx"));
                visitData.setDiuret_SideEffects(result.getBoolean("Diuret_SideEffects"));
                visitData.setDiuret_RxDecToday(result.getString("Diuret_RxDecToday"));
                visitData.setAce_rx(result.getBoolean("Ace_rx"));
                visitData.setAce_SideEffects(result.getBoolean("Ace_SideEffects"));
                visitData.setAce_RxDecToday(result.getString("Ace_RxDecToday"));
                visitData.setArecept_rx(result.getBoolean("Arecept_rx"));
                visitData.setArecept_SideEffects(result.getBoolean("Arecept_SideEffects"));
                visitData.setArecept_RxDecToday(result.getString("Arecept_RxDecToday"));
                visitData.setBeta_rx(result.getBoolean("Beta_rx"));
                visitData.setBeta_SideEffects(result.getBoolean("Beta_SideEffects"));
                visitData.setBeta_RxDecToday(result.getString("Beta_RxDecToday"));
                visitData.setCalc_rx(result.getBoolean("Calc_rx"));
                visitData.setCalc_SideEffects(result.getBoolean("Calc_SideEffects"));
                visitData.setCalc_RxDecToday(result.getString("Calc_RxDecToday"));
                visitData.setAnti_rx(result.getBoolean("Anti_rx"));
                visitData.setAnti_SideEffects(result.getBoolean("Anti_SideEffects"));
                visitData.setAnti_RxDecToday(result.getString("Anti_RxDecToday"));
                visitData.setStatin_rx(result.getBoolean("Statin_rx"));
                visitData.setStatin_SideEffects(result.getBoolean("Statin_SideEffects"));
                visitData.setStatin_RxDecToday(result.getString("Statin_RxDecToday"));
                visitData.setLipid_rx(result.getBoolean("Lipid_rx"));
                visitData.setLipid_SideEffects(result.getBoolean("Lipid_SideEffects"));
                visitData.setLipid_RxDecToday(result.getString("Lipid_RxDecToday"));
                visitData.setHypo_rx(result.getBoolean("Hypo_rx"));
                visitData.setHypo_SideEffects(result.getBoolean("Hypo_SideEffects"));
                visitData.setHypo_RxDecToday(result.getString("Hypo_RxDecToday"));
                visitData.setInsul_rx(result.getBoolean("Insul_rx"));
                visitData.setInsul_SideEffects(result.getBoolean("Insul_SideEffects"));
                visitData.setInsul_RxDecToday(result.getString("Insul_RxDecToday"));
                visitData.setOften_miss(result.getInt("Often_miss"));
                visitData.setHerbal(result.getString("Herbal"));
                visitData.setTC_HDL_LabresultsDate(result.getDate("TC_HDL_LabresultsDate"));
                visitData.setLDL_LabresultsDate(result.getDate("LDL_LabresultsDate"));
                visitData.setHDL_LabresultsDate(result.getDate("HDL_LabresultsDate"));
                visitData.setA1C_LabresultsDate(result.getDate("A1C_LabresultsDate"));
                visitData.setLocked(result.getBoolean("Locked"));

            }
        }
        catch (SQLException se) {
            System.out.println("SQL Error while retreiving from the database : " + se.toString());
        }
        catch (Exception ne) {
            System.out.println("Other Error while retreiving to the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, sql, result);
        }
        return visitData;
    }

    public List getAllPatientId() throws SQLException {
        List reList = new ArrayList();
        String query = "SELECT Distinct Patient_Id FROM hsfo_patient";
        Statement sql = null;
        ResultSet result = null;
        Connection connect = SpringUtils.getDbConnection();
        try {
            sql = connect.createStatement();
            result = sql.executeQuery(query);
            System.out.println("here " + query);
            // retrieve results and store into registrationData object
            while (result.next()) {
                reList.add(result.getString(1));
            }
            //            result.close();
            //            sql.close();
            //            db.CloseConn();
        }
        catch (SQLException se) {
            System.out.println("SQL Error while retreiving from the database : " + se.toString());
        }
        catch (Exception ne) {
            System.out.println("Other Error while retreiving to the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, sql, result);
        }
        return reList;
    }

    public List nullSafeRetrVisitRecord(String ID) throws SQLException {

        String query = "SELECT * FROM form_hsfo_visit where ID in (SELECT max(ID) FROM form_hsfo_visit WHERE Patient_Id='" + ID + "' group by VisitDate_Id)";
        Statement sql = null;
        ResultSet result = null;

        List patientList = new LinkedList();
        Connection connect = SpringUtils.getDbConnection();
        try {
            sql = connect.createStatement();
            result = sql.executeQuery(query);
            System.out.println("here " + query);
            // retrieve results and store into registrationData object

            while (result.next()) {
                VisitData visitData = new VisitData();
                visitData.setPatient_Id(result.getString("Patient_Id"));
                visitData.setProvider_Id(result.getString("provider_no"));
                visitData.setFormCreated(result.getDate("FormCreated"));
                visitData.setFormEdited(result.getTimestamp("FormEdited"));
                visitData.setVisitDate_Id(result.getDate("VisitDate_Id"));
                visitData.setDrugcoverage(result.getString("Drugcoverage"));

                visitData.setSBP(result.getInt("SBP"));
                if (result.wasNull()) visitData.setSBP(Integer.MIN_VALUE);

                visitData.setSBP_goal(result.getInt("SBP_goal"));
                if (result.wasNull()) visitData.setSBP_goal(Integer.MIN_VALUE);

                visitData.setDBP(result.getInt("DBP"));
                if (result.wasNull()) visitData.setSBP_goal(Integer.MIN_VALUE);

                visitData.setDBP_goal(result.getInt("DBP_goal"));
                if (result.wasNull()) visitData.setDBP_goal(Integer.MIN_VALUE);

                visitData.setBptru_used(result.getString("Bptru_used"));

                visitData.setWeight(result.getDouble("Weight"));
                if (result.wasNull()) visitData.setWeight(Double.MIN_VALUE);

                visitData.setWeight_unit(result.getString("Weight_unit"));

                visitData.setWaist(result.getDouble("Waist"));
                if (result.wasNull()) visitData.setWaist(Double.MIN_VALUE);

                visitData.setWaist_unit(result.getString("Waist_unit"));

                visitData.setTC_HDL(result.getDouble("TC_HDL"));
                if (result.wasNull()) visitData.setTC_HDL(Double.MIN_VALUE);

                visitData.setLDL(result.getDouble("LDL"));
                if (result.wasNull()) visitData.setLDL(Double.MIN_VALUE);

                visitData.setHDL(result.getDouble("HDL"));
                if (result.wasNull()) visitData.setHDL(Double.MIN_VALUE);

                visitData.setA1C(result.getDouble("A1C"));
                if (result.wasNull()) visitData.setA1C(Double.MIN_VALUE);

                visitData.setNextvisit(result.getString("Nextvisit"));
                visitData.setBpactionplan(result.getBoolean("Bpactionplan"));
                visitData.setPressureOff(result.getBoolean("PressureOff"));
                visitData.setPatientProvider(result.getBoolean("PatientProvider"));
                visitData.setABPM(result.getBoolean("ABPM"));
                visitData.setHome(result.getBoolean("Home"));
                visitData.setCommunityRes(result.getBoolean("CommunityRes"));
                visitData.setProRefer(result.getBoolean("ProRefer"));
                visitData.setHtnDxType(result.getString("HtnDxType"));
                visitData.setDyslipid(result.getBoolean("Dyslipid"));
                visitData.setDiabetes(result.getBoolean("Diabetes"));
                visitData.setKidneyDis(result.getBoolean("KidneyDis"));
                visitData.setObesity(result.getBoolean("Obesity"));
                visitData.setCHD(result.getBoolean("CHD"));
                visitData.setStroke_TIA(result.getBoolean("Stroke_TIA"));
                visitData.setRisk_weight(result.getBoolean("Risk_weight"));
                visitData.setRisk_activity(result.getBoolean("Risk_activity"));
                visitData.setRisk_diet(result.getBoolean("Risk_diet"));
                visitData.setRisk_smoking(result.getBoolean("Risk_smoking"));
                visitData.setRisk_alcohol(result.getBoolean("Risk_alcohol"));
                visitData.setRisk_stress(result.getBoolean("Risk_stress"));
                visitData.setPtView(result.getString("PtView"));

                visitData.setChange_importance(result.getInt("Change_importance"));
                if (result.wasNull()) visitData.setChange_importance(Integer.MIN_VALUE);

                visitData.setChange_confidence(result.getInt("Change_confidence"));
                if (result.wasNull()) visitData.setChange_confidence(Integer.MIN_VALUE);

                visitData.setExercise_minPerWk(result.getInt("exercise_minPerWk"));
                if (result.wasNull()) visitData.setExercise_minPerWk(Integer.MIN_VALUE);

                visitData.setSmoking_cigsPerDay(result.getInt("smoking_cigsPerDay"));
                if (result.wasNull()) visitData.setSmoking_cigsPerDay(Integer.MIN_VALUE);

                visitData.setAlcohol_drinksPerWk(result.getInt("alcohol_drinksPerWk"));
                if (result.wasNull()) visitData.setAlcohol_drinksPerWk(Integer.MIN_VALUE);

                visitData.setSel_DashDiet(result.getString("sel_DashDiet"));
                visitData.setSel_HighSaltFood(result.getString("sel_HighSaltFood"));
                visitData.setSel_Stressed(result.getString("sel_Stressed"));
                visitData.setLifeGoal(result.getString("LifeGoal"));
                visitData.setFamHx_Htn(result.getBoolean("FamHx_Htn"));
                visitData.setFamHx_Dyslipid(result.getBoolean("FamHx_Dyslipid"));
                visitData.setFamHx_Diabetes(result.getBoolean("FamHx_Diabetes"));
                visitData.setFamHx_KidneyDis(result.getBoolean("FamHx_KidneyDis"));
                visitData.setFamHx_Obesity(result.getBoolean("FamHx_Obesity"));
                visitData.setFamHx_CHD(result.getBoolean("FamHx_CHD"));
                visitData.setFamHx_Stroke_TIA(result.getBoolean("FamHx_Stroke_TIA"));
                visitData.setDiuret_rx(result.getBoolean("Diuret_rx"));
                visitData.setDiuret_SideEffects(result.getBoolean("Diuret_SideEffects"));
                visitData.setDiuret_RxDecToday(result.getString("Diuret_RxDecToday"));
                visitData.setAce_rx(result.getBoolean("Ace_rx"));
                visitData.setAce_SideEffects(result.getBoolean("Ace_SideEffects"));
                visitData.setAce_RxDecToday(result.getString("Ace_RxDecToday"));
                visitData.setArecept_rx(result.getBoolean("Arecept_rx"));
                visitData.setArecept_SideEffects(result.getBoolean("Arecept_SideEffects"));
                visitData.setArecept_RxDecToday(result.getString("Arecept_RxDecToday"));
                visitData.setBeta_rx(result.getBoolean("Beta_rx"));
                visitData.setBeta_SideEffects(result.getBoolean("Beta_SideEffects"));
                visitData.setBeta_RxDecToday(result.getString("Beta_RxDecToday"));
                visitData.setCalc_rx(result.getBoolean("Calc_rx"));
                visitData.setCalc_SideEffects(result.getBoolean("Calc_SideEffects"));
                visitData.setCalc_RxDecToday(result.getString("Calc_RxDecToday"));
                visitData.setAnti_rx(result.getBoolean("Anti_rx"));
                visitData.setAnti_SideEffects(result.getBoolean("Anti_SideEffects"));
                visitData.setAnti_RxDecToday(result.getString("Anti_RxDecToday"));
                visitData.setStatin_rx(result.getBoolean("Statin_rx"));
                visitData.setStatin_SideEffects(result.getBoolean("Statin_SideEffects"));
                visitData.setStatin_RxDecToday(result.getString("Statin_RxDecToday"));
                visitData.setLipid_rx(result.getBoolean("Lipid_rx"));
                visitData.setLipid_SideEffects(result.getBoolean("Lipid_SideEffects"));
                visitData.setLipid_RxDecToday(result.getString("Lipid_RxDecToday"));
                visitData.setHypo_rx(result.getBoolean("Hypo_rx"));
                visitData.setHypo_SideEffects(result.getBoolean("Hypo_SideEffects"));
                visitData.setHypo_RxDecToday(result.getString("Hypo_RxDecToday"));
                visitData.setInsul_rx(result.getBoolean("Insul_rx"));
                visitData.setInsul_SideEffects(result.getBoolean("Insul_SideEffects"));
                visitData.setInsul_RxDecToday(result.getString("Insul_RxDecToday"));

                visitData.setOften_miss(result.getInt("Often_miss"));
                if (result.wasNull()) visitData.setOften_miss(Integer.MIN_VALUE);

                visitData.setHerbal(result.getString("Herbal"));
                visitData.setTC_HDL_LabresultsDate(result.getDate("TC_HDL_LabresultsDate"));
                visitData.setLDL_LabresultsDate(result.getDate("LDL_LabresultsDate"));
                visitData.setHDL_LabresultsDate(result.getDate("HDL_LabresultsDate"));
                visitData.setA1C_LabresultsDate(result.getDate("A1C_LabresultsDate"));
                visitData.setLocked(result.getBoolean("Locked"));
                patientList.add(visitData);

            }
            //            result.close();
            //            sql.close();
            //            db.CloseConn();
        }
        catch (SQLException se) {
            System.out.println("SQL Error while retreiving from the database : " + se.toString());
        }
        catch (Exception ne) {
            System.out.println("Other Error while retreiving to the database : " + ne.toString());
        }
        finally {
            SqlUtils.closeResources(connect, sql, result);
        }

        return patientList;
    }

}

