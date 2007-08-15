/*
* 
* Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
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
* This software was written for 
* Centre for Research on Inner City Health, St. Michael's Hospital, 
* Toronto, Ontario, Canada 
*/

package org.oscarehr.PMmodule.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.oscarehr.PMmodule.exception.IntegratorException;
import org.oscarehr.PMmodule.exception.IntegratorNotEnabledException;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.web.formbean.ClientSearchFormBean;
import org.oscarehr.PMmodule.web.formbean.PreIntakeForm;
import org.oscarehr.PMmodule.web.utils.UserRoleUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class IntakeAction extends BaseAction {

	private static Log log = LogFactory.getLog(IntakeAction.class);

	
	public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		request.getSession().setAttribute("demographic",null);
		
		return mapping.findForward("pre-intake");
	}
	
	public ActionForward do_intake(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm preIntakeForm = (DynaActionForm)form;
		PreIntakeForm formBean = (PreIntakeForm)preIntakeForm.get("form");
		request.getSession().setAttribute("demographic",null);
		boolean doLocalSearch=false;
		
		
		Collection<Demographic> results = new ArrayList<Demographic>();

		/* here we want to switch to the integrator, if available */
		Demographic d = new Demographic();		
		d.setFirstName(formBean.getFirstName());
		d.setLastName(formBean.getLastName());
		d.setYearOfBirth(formBean.getYearOfBirth());
		d.setMonthOfBirth(String.valueOf(formBean.getMonthOfBirth()));
		d.setDateOfBirth(String.valueOf(formBean.getDayOfBirth()));
		d.setHin(formBean.getHealthCardNumber());
		d.setVer(formBean.getHealthCardVersion());

		try {
			results  = integratorManager.matchClient(d);
			log.debug("integrator found " + results.size() + " match(es)");
		} catch(IntegratorNotEnabledException e) {
			log.info(e);
			doLocalSearch=true;
		} catch(Throwable e) {
			log.error(e);
			doLocalSearch=true;
		}
		if (doLocalSearch) {
			ClientSearchFormBean searchBean = new ClientSearchFormBean();
			searchBean.setFirstName(formBean.getFirstName());
			searchBean.setLastName(formBean.getLastName());
			searchBean.setSearchOutsideDomain(true);
			searchBean.setSearchUsingSoundex(true);
			
			boolean allowOnlyOptins=UserRoleUtils.hasRole(request, UserRoleUtils.Roles.external);

			results = clientManager.search(searchBean,allowOnlyOptins);
            log.debug("local search found " + results.size() + " match(es)");

        }
		
		if(results != null && results.size() > 0) {
			request.setAttribute("localSearch", doLocalSearch);
			request.setAttribute("clients",results);			
			return mapping.findForward("pre-intake");
		}

		return new_client(mapping,form,request,response);
	}
	
	/*
	 * There can be a new client in 2 scenerios
	 * 1) new client button was clicked.
	 * 2) new client, but they are being linked to a record already
	 * 		existing on the integrator; in which case the session variable
	 * 		'demographic' will be set.
	 *  
	 */
	public ActionForward new_client(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm preIntakeForm = (DynaActionForm)form;
		PreIntakeForm formBean = (PreIntakeForm)preIntakeForm.get("form");
		
		/* no matches */
		if(formBean.getClientId().equals("")) {
			return mapping.findForward(getIntakeForward());
		}
		
		
		Demographic demographic = null;
		if(formBean.getAgencyId() != 0) {
			//integrator
			try {
				demographic = integratorManager.getDemographic(formBean.getAgencyId(), Long.valueOf(formBean.getClientId()));
			}catch(IntegratorException e) {
				log.error(e);
			}
		} else {
			//local...can this even happen?
			//demographic = clientManager.getClientByDemographicNo(formBean.getClientId());
		}
		
		request.getSession().setAttribute("demographic",demographic);
		
		return mapping.findForward(getIntakeForward());
	}
	
	/*
	 * This is just updating the intake form on a client since
	 * he/she are already in the local database.
	 */
	public ActionForward update_client(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm preIntakeForm = (DynaActionForm)form;
		PreIntakeForm formBean = (PreIntakeForm)preIntakeForm.get("form");
		
		String demographicNo = formBean.getClientId();
		
		log.debug("update intake for client " + demographicNo);
		
		request.setAttribute("demographicNo",demographicNo);

		return mapping.findForward(getIntakeForward());
	}
	
	
	private String getIntakeForward() {
		String value = "intakea";
		
		if(intakeAManager.isNewClientForm()) {
			value = "intakea";
		}
		if(intakeCManager.isNewClientForm()) {
			value = "intakec";
		}
		return value;
	}
}
