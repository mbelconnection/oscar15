/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.oscarehr.phr.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.oscarehr.phr.PHRAuthentication;
import org.oscarehr.util.MiscUtils;

import oscar.OscarProperties;
import oscar.oscarDemographic.data.DemographicData;

/**
 *
 * @author apavel
 */
public class PHRViewPatientRecord extends DispatchAction {
    private static final Logger log2 = MiscUtils.getLogger();

    @Override
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
       return super.execute(mapping, form, request, response);
    }

    @Override
    public ActionForward unspecified(ActionMapping mapping, ActionForm  form,
           HttpServletRequest request, HttpServletResponse response)
           throws Exception {
           return viewMyOscarRecord(mapping,form,request,response);
    }
    

    
    public ActionForward viewMyOscarRecord(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String demographicNo = request.getParameter("demographic_no");
        if (demographicNo == null) { //shouldn't really happy, but just in case
            response.getWriter().println("Error: Lost demographic number.  Please try again");
            return null;
        }
        PHRAuthentication auth = (PHRAuthentication) request.getSession().getAttribute(PHRAuthentication.SESSION_PHR_AUTH);
        
        if (auth == null || auth.getMyOscarUserId() == null) {
            request.setAttribute("forwardToOnSuccess", request.getContextPath() + "/demographic/viewPhrRecord.do?demographic_no=" + demographicNo);
            return mapping.findForward("login");
        } else {
            String phrPath = OscarProperties.getInstance().getProperty("myOSCAR.url"); //http://130.113.106.96:8080/myoscar_client/
            if (phrPath == null) {
                response.getWriter().println("Error: 'myOSCAR.url' property is not configured... please contact support to have this feature enabled");
                return null;
            }
            DemographicData demographicData = new DemographicData();
            String patientMyOscarId = demographicData.getDemographic(demographicNo).getIndivoId();
           
//            request.setAttribute("userid", auth.getUserId());
//            request.setAttribute("ticket", auth.getToken());
            request.setAttribute("userName", auth.getMyOscarUserName());
            request.setAttribute("password", auth.getMyOscarPassword());
            request.setAttribute("viewpatient", patientMyOscarId);
            request.setAttribute("url", phrPath + (phrPath.endsWith("/")?"":"/") + "patient_view_action.jsp");
            return mapping.findForward("phr");
        }

    }
}