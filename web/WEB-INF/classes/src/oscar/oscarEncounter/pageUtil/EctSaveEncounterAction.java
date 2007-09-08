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
package oscar.oscarEncounter.pageUtil;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.oscarehr.util.SpringUtils;

import oscar.log.LogAction;
import oscar.log.LogConst;
import oscar.oscarDB.DBHandler;
import oscar.util.SqlUtils;
import oscar.util.UtilDateUtilities;
import oscar.util.UtilMisc;
import oscar.OscarProperties;

public class EctSaveEncounterAction extends Action {

    private String getLatestID(String demoNo) throws SQLException {
        DBHandler dbhandler = new DBHandler(DBHandler.OSCAR_DATA);
        String sql = "select MAX(eChartId) as maxID from eChart where demographicNo = " + demoNo;
        ResultSet rs = dbhandler.GetSQL(sql);
        String latestID = null;

        if (rs.next()) {
            latestID = rs.getString("maxID");
        }
        rs.close();

        dbhandler.CloseConn();

        return latestID;
    }

    //This function will compare the most current id in the echart with the 
    // id that is stored in the session variable.  If the ID in the echart is 
    // newer, then the user is working with a old (aka dirty) copy of the encounter
    private boolean isDirtyEncounter(String demographicNo, String userEChartID) {
        String latestID;
        try {
            latestID = getLatestID(demographicNo);
        }
        catch (SQLException sqlexception) {
            System.out.println(sqlexception.getMessage());
            return true;
        }

        //latestID should only be null if the assessed encounter is new, which
        // means that it can't be dirty
        if (latestID == null || latestID.equals("")) {
            return false;
        }
        // if the usrCopyID is null and the latestID isn't null, then
        // two people where probably trying to create a new encounter for
        // the same person at the same time.
        else if (userEChartID == null || userEChartID.equals("")) {
            return true;
        }

        try {
            Integer iLatestID = new Integer(latestID);
            Integer iUsrCopyID = new Integer(userEChartID);
            if (iLatestID.longValue() > iUsrCopyID.longValue()) {
                return true;
            }
            else {
                return false;
            }
        }
        catch (NumberFormatException e) {
            // already handled the null/empy string case, so shouldn't ever get this
            // exception.
            System.out.println(e.getMessage());
            return true;
        }
    }

    public ActionForward execute(ActionMapping actionmapping, ActionForm actionform, HttpServletRequest httpservletrequest, HttpServletResponse httpservletresponse) throws IOException, ServletException, SQLException {
        //UtilDateUtilities dateutilities = new UtilDateUtilities();
        EctSessionBean sessionbean = null;
        sessionbean = (EctSessionBean)httpservletrequest.getSession().getAttribute("EctSessionBean");

        sessionbean.socialHistory = httpservletrequest.getParameter("shTextarea");
        sessionbean.familyHistory = httpservletrequest.getParameter("fhTextarea");
        sessionbean.medicalHistory = httpservletrequest.getParameter("mhTextarea");
        sessionbean.ongoingConcerns = httpservletrequest.getParameter("ocTextarea");
        sessionbean.reminders = httpservletrequest.getParameter("reTextarea");
        sessionbean.encounter = httpservletrequest.getParameter("enTextarea");
        sessionbean.subject = httpservletrequest.getParameter("subject");
        java.util.Date date = UtilDateUtilities.Today();
        sessionbean.eChartTimeStamp = date;

        if (!httpservletrequest.getParameter("btnPressed").equals("Exit")) {
            try {
                ResourceBundle prop = ResourceBundle.getBundle("oscarResources", httpservletrequest.getLocale());
                if (httpservletrequest.getParameter("btnPressed").equals("Sign,Save and Bill")) {
                    sessionbean.encounter = sessionbean.encounter + "\n" + "[" + prop.getString("oscarEncounter.class.EctSaveEncounterAction.msgSigned") + " " + UtilDateUtilities.DateToString(date, prop.getString("date.yyyyMMddHHmmss"), httpservletrequest.getLocale()) + " " + prop.getString("oscarEncounter.class.EctSaveEncounterAction.msgSigBy") + " " + sessionbean.userName + "]";
                }
                if (httpservletrequest.getParameter("btnPressed").equals("Sign,Save and Exit")) {
                    sessionbean.encounter = sessionbean.encounter + "\n" + "[" + prop.getString("oscarEncounter.class.EctSaveEncounterAction.msgSigned") + " " + UtilDateUtilities.DateToString(date, prop.getString("date.yyyyMMddHHmmss"), httpservletrequest.getLocale()) + " " + prop.getString("oscarEncounter.class.EctSaveEncounterAction.msgSigBy") + " " + sessionbean.userName + "]";
                }
                if (httpservletrequest.getParameter("btnPressed").equals("Verify and Sign")) {
                    sessionbean.encounter = sessionbean.encounter + "\n" + "[" + prop.getString("oscarEncounter.class.EctSaveEncounterAction.msgVerAndSig") + " " + UtilDateUtilities.DateToString(date, prop.getString("date.yyyyMMddHHmmss"), httpservletrequest.getLocale()) + " " + prop.getString("oscarEncounter.class.EctSaveEncounterAction.msgSigBy") + " " + sessionbean.userName + "]";
                }
                if (httpservletrequest.getParameter("btnPressed").equals("Split Chart")) {
                    sessionbean.subject = prop.getString("oscarEncounter.class.EctSaveEncounterAction.msgSplitChart");
                }
                sessionbean.template = "";
            }
            catch (Exception e) {
                e.printStackTrace();
            }

            //This code is synchronized to ensure that only one person is modifying the same patient
            // record at a time
            synchronized (this) {
                //unfortunately, can't use the echart ID stored in the session bean, because it may
                // be overwritten when view split charts.
                String userEChartID = (String)httpservletrequest.getSession().getAttribute("eChartID");
                //make sure that user is trying to save the latest version of the encounter
                if (isDirtyEncounter(sessionbean.demographicNo, userEChartID)) {
                    //If it is an ajax submit, it should cause and exception, if it is a
                    // regular submission, it should just forward on to an error page.
                    if (httpservletrequest.getParameter("submitMethod").equals("ajax")) {
                        httpservletresponse.sendError(httpservletresponse.SC_PRECONDITION_FAILED, "Somebody else is currently modifying this encounter");
                    }
                    return actionmapping.findForward("concurrencyError");
                }

                Connection c = SpringUtils.getDbConnection();
                PreparedStatement ps = null;
                try {
                    String s = "insert into eChart (timeStamp, demographicNo,providerNo,subject,socialHistory,familyHistory,medicalHistory,ongoingConcerns,reminders,encounter) values (?,?,?,?,?,?,?,?,?,?)";
                    ps = c.prepareStatement(s);
                    ps.setTimestamp(1, new java.sql.Timestamp(date.getTime()));
                    ps.setString(2, sessionbean.demographicNo);
                    ps.setString(3, sessionbean.providerNo);
                    ps.setString(4, sessionbean.subject);
                    ps.setString(5, sessionbean.socialHistory);
                    ps.setString(6, sessionbean.familyHistory);
                    ps.setString(7, sessionbean.medicalHistory);
                    ps.setString(8, sessionbean.ongoingConcerns);
                    ps.setString(9, sessionbean.reminders);
                    ps.setString(10, sessionbean.encounter);
                    ps.executeUpdate();
                    sessionbean.eChartId = getLatestID(sessionbean.demographicNo);
                    httpservletrequest.getSession().setAttribute("eChartID", sessionbean.eChartId);

                    // add log here
                    String ip = httpservletrequest.getRemoteAddr();
                    LogAction.addLog((String)httpservletrequest.getSession().getAttribute("user"), LogConst.ADD, LogConst.CON_ECHART, sessionbean.demographicNo, ip);

                    DBHandler dbhandler = new DBHandler(DBHandler.OSCAR_DATA);
                    //change the appt status
                    if (sessionbean.status != null && !sessionbean.status.equals("")) {
                        oscar.appt.ApptStatusData as = new oscar.appt.ApptStatusData();
                        as.setApptStatus(sessionbean.status);
                        if (httpservletrequest.getParameter("btnPressed").equals("Sign,Save and Exit")) {
                            s = "update appointment set status='" + as.signStatus() + "' where appointment_no=" + sessionbean.appointmentNo;
                            dbhandler.RunSQL(s);
                        }
                        if (httpservletrequest.getParameter("btnPressed").equals("Verify and Sign")) {
                            s = "update appointment set status='" + as.verifyStatus() + "' where appointment_no=" + sessionbean.appointmentNo;
                            dbhandler.RunSQL(s);
                        }
                    }
                }
                catch (SQLException sqlexception) {
                    System.out.println(sqlexception.getMessage());
                }
                finally {
                    SqlUtils.closeResources(c, ps, null);
                }
            } //end of the synchronization block
        }

        try { // save enc. window sizes
            DBHandler dbhandler = new DBHandler(DBHandler.OSCAR_DATA);
            String s = "delete from encounterWindow where provider_no='" + sessionbean.providerNo + "'";
            dbhandler.RunSQL(s);
            s = "insert into encounterWindow (provider_no, rowOneSize, rowTwoSize, presBoxSize, rowThreeSize) values ('" + sessionbean.providerNo + "', '" + httpservletrequest.getParameter("rowOneSize") + "', '" + httpservletrequest.getParameter("rowTwoSize") + "', '" + httpservletrequest.getParameter("presBoxSize") + "', '" + httpservletrequest.getParameter("rowThreeSize") + "')";
            dbhandler.RunSQL(s);
            dbhandler.CloseConn();
        }
        catch (Exception e) {
            e.printStackTrace(System.out);
        }

        String forward = null;

        //billRegion=BC&billForm=GP&hotclick=&appointment_no=0&demographic_name=TEST%2CBILLING&demographic_no=10419&providerview=1&user_no=999998&apptProvider_no=none&appointment_date=2006-3-30&start_time=0:00&bNewForm=1&status=t')
        if (httpservletrequest.getParameter("btnPressed").equals("Sign,Save and Bill")) {

            String billRegion = OscarProperties.getInstance().getProperty("billregion");
            //
            oscar.oscarBilling.ca.bc.pageUtil.BillingSessionBean bean = new oscar.oscarBilling.ca.bc.pageUtil.BillingSessionBean();
            bean.setApptProviderNo(sessionbean.providerNo);
            bean.setPatientName(sessionbean.getPatientFirstName() + " " + sessionbean.getPatientLastName());
            bean.setBillRegion(billRegion);
            bean.setBillForm("GP");
            bean.setPatientNo(sessionbean.demographicNo);
            bean.setApptNo(httpservletrequest.getParameter("appointment_no"));
            bean.setApptDate(sessionbean.appointmentDate);
            bean.setApptStatus(httpservletrequest.getParameter("status"));
            httpservletrequest.setAttribute("encounter", "true");
            httpservletrequest.getSession().setAttribute("billingSessionBean", bean);
            forward = "bill";
        }

        else if (httpservletrequest.getParameter("btnPressed").equals("Sign,Save and Exit") || httpservletrequest.getParameter("btnPressed").equals("Verify and Sign")) {
            forward = "success";
        }
        else if (httpservletrequest.getParameter("btnPressed").equals("Save") || httpservletrequest.getParameter("btnPressed").equals("AutoSave")) {
            forward = "saveAndStay";
        }
        else if (httpservletrequest.getParameter("btnPressed").equals("Split Chart")) {
            forward = "splitchart";
        }
        else if (httpservletrequest.getParameter("btnPressed").equals("Exit")) {
            forward = "close";
        }
        else {
            forward = "failure";
        }
        return actionmapping.findForward(forward);
    }
}
