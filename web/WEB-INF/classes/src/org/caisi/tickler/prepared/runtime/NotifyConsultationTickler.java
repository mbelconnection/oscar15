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


package org.caisi.tickler.prepared.runtime;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.caisi.model.Consultation;
import org.caisi.model.ProfessionalSpecialists;
import org.caisi.model.Tickler;
import org.caisi.service.ConsultationManager;
import org.caisi.service.ProviderManagerTickler;
import org.caisi.service.TicklerManager;
import org.caisi.tickler.prepared.PreparedTickler;
import org.caisi.tickler.prepared.seaton.consultation.ConsultationConfiguration;
import org.caisi.tickler.prepared.seaton.consultation.ConsultationsConfigBean;
import org.caisi.tickler.prepared.seaton.consultation.NotifyConsultationBean;

public class NotifyConsultationTickler extends AbstractPreparedTickler
		implements PreparedTickler {

	private static Log log = LogFactory.getLog(NotifyConsultationTickler.class);
	
	
	private ConsultationManager consultationMgr;
	private TicklerManager ticklerMgr;
	private ProviderManagerTickler providerMgr;
	
	
	public void setConsultationManager(ConsultationManager consultationMgr) {
		this.consultationMgr = consultationMgr;
	}
	
	public void setTicklerManager(TicklerManager ticklerMgr) {
		this.ticklerMgr = ticklerMgr;
	}
	
	public void setProviderManager(ProviderManagerTickler providerMgr) {
		this.providerMgr = providerMgr;
	}
	
	
	public String getName() {
		return "Notify Consultation Appointment";
	}

	public String getViewPath() {
		return "/ticklerPlus/notifyConsultation.jsp";
	}

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
	
		NotifyConsultationBean formBean = null;
		
		String path = request.getSession().getServletContext().getRealPath("/");
		ConsultationConfiguration config = new ConsultationConfiguration(path + File.separator + "WEB-INF/consultation.xml");
		ConsultationsConfigBean configBean = config.loadConfig();
		
		String providerNo = (String)request.getSession().getAttribute("user");
		request.setAttribute("providers",providerMgr.getProviders());
		
		if(request.getParameter("action") == null) {
			formBean = new NotifyConsultationBean();
			formBean.setId("Notify Consultation Appointment");
			request.setAttribute("formHandler",formBean);
			return new ActionForward(getViewPath());
		}
		
		//populate the bean - better way to do this???
		formBean = tearForm(request);
	
		if(formBean.getDemographic_no() != null && formBean.getAction().equals("populate")) {
			List consultationRequests = consultationMgr.getConsultationsByStatus(formBean.getDemographic_no(),"1");
			request.setAttribute("consultations",consultationRequests);
			formBean.setAction("");
			request.setAttribute("formBean",formBean);
			return new ActionForward(this.getViewPath());
		}
		
		if(formBean.getAction().equals("generate")) {
			SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat timeFormatter = new SimpleDateFormat("hh:mm");
			String requestId = request.getParameter("current_consultation");
			Consultation consultation = consultationMgr.getConsultation(requestId);
			ProfessionalSpecialists spec = consultation.getProfessionalSpecialist();
			//Provider provider = providerMgr
			//create a tickler here
			Tickler tickler = new Tickler();
			tickler.setStatus('A');
			tickler.setCreator(providerNo);
			tickler.setDemographic_no(formBean.getDemographic_no());
			tickler.setPriority("Normal");
			tickler.setService_date(new Date());
			tickler.setTask_assigned_to(configBean.getNotifyconsultation().getRecipient());
			tickler.setUpdate_date(new Date());
			String contextName = request.getScheme()+ "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath().substring(0,request.getContextPath().indexOf("/",1));
			tickler.setMessage(
				"You are being notified that a consultation appointment has been arranged for<br/>"
				+ formBean.getDemographic_name() + "<br/>at<br/> " +
				spec.getFirstName() + " " + spec.getLastName() + 
				" <br/>ADDRESS:" + spec.getAddress() + " <br/>PHONE:" + spec.getPhone()
				+ " <br/>FAX:" + spec.getFax() + "<br/><br/>Reason: " + consultation.getReason()
				+ "<br/><br/>Appointment Date: " + dateFormatter.format(consultation.getAppointmentDate()) 
				+ "<br/>Appointment Time: " + timeFormatter.format(consultation.getAppointmentTime())
				
				+ "<br/><br/><a target=\"consultation\" href=\"" + contextName + "/OscarWAR/oscarEncounter/ViewRequest.do?requestId=" + consultation.getRequestId() + "\">Link to consultation</a>"
				+ "<br/><a target=\"demographic\" href=\"" + contextName +  "/demographic/demographiccontrol.jsp?displaymode=edit&demographic_no=" + formBean.getDemographic_no() + "&dboperation=search_detail\">Link to patient</a>"
			);
			
			ticklerMgr.addTickler(tickler);
		}

		return null;
	}
	
	public NotifyConsultationBean tearForm(HttpServletRequest request) {
		NotifyConsultationBean bean = new NotifyConsultationBean();
		bean.setAction(request.getParameter("action"));
		bean.setDemographic_name(request.getParameter("demographic_name"));
		bean.setDemographic_no(request.getParameter("demographic_no"));
		bean.setId(request.getParameter("id"));
		bean.setMethod(request.getParameter("method"));
		return bean;
	}
	

	
}