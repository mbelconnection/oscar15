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
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */
package oscar.oscarRx.pageUtil;

import java.io.IOException;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;

import oscar.log.LogAction;
import oscar.log.LogConst;
import oscar.oscarRx.data.RxPatientData;


public final class RxDeleteAllergyAction extends Action {

    public ActionForward execute(ActionMapping mapping,
				 ActionForm form,
				 HttpServletRequest request,
				 HttpServletResponse response)
	throws IOException, ServletException {

            // Extract attributes we will need
            Locale locale = getLocale(request);
            MessageResources messages = getResources(request);

            // Setup variables            
            // Add allergy

            int id = Integer.parseInt(request.getParameter("ID"));
            String demographicNo = request.getParameter("demographicNo");
            String action = request.getParameter("action");
            
            RxPatientData.Patient patient = (RxPatientData.Patient)request.getSession().getAttribute("Patient");

            RxPatientData.Patient.Allergy allergy = patient.getAllergy(id);
            if(action!= null && action.equals("activate")) {
            	patient.activateAllergy(id);
            	String ip = request.getRemoteAddr();
                LogAction.addLog((String) request.getSession().getAttribute("user"), "Activate", LogConst.CON_ALLERGY, ""+id, ip,""+patient.getDemographicNo(), allergy.getAllergy().getAuditString());            
            } else {
            	patient.deleteAllergy(id);
            	String ip = request.getRemoteAddr();
                LogAction.addLog((String) request.getSession().getAttribute("user"), LogConst.DELETE, LogConst.CON_ALLERGY, ""+id, ip,""+patient.getDemographicNo(), allergy.getAllergy().getAuditString());
            }
            
            
            if(demographicNo != null) {
            	request.setAttribute("demographicNo",demographicNo);
            }
            return (mapping.findForward("success"));
    }
}