/**
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
 * This software is published under the GPL GNU General Public License.
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */
package org.oscarehr.ob;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.common.dao.ConsultationReportDao;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.DemographicExtDao;
import org.oscarehr.common.dao.ProfessionalSpecialistDao;
import org.oscarehr.common.model.ConsultationReport;
import org.oscarehr.common.model.ProfessionalSpecialist;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.SpringUtils;

public class OBAction extends DispatchAction {

	DemographicDao demographicDao= (DemographicDao)SpringUtils.getBean("demographicDao");
	DemographicExtDao demographicExtDao = SpringUtils.getBean(DemographicExtDao.class);
	ProfessionalSpecialistDao professionalSpecialistDao = SpringUtils.getBean(ProfessionalSpecialistDao.class);
	ProviderDao providerDao = SpringUtils.getBean(ProviderDao.class);
	ConsultationReportDao consultationReportDao = (ConsultationReportDao)SpringUtils.getBean("generalConsultationReportDao");
	
	
	public ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)  {
		org.apache.struts.validator.DynaValidatorForm f = (org.apache.struts.validator.DynaValidatorForm)form;
		OBConsultationReportForm search = (OBConsultationReportForm)f.get("search");
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = null;
		Date endDate = null;
		if(search.getStartDate().length()>0) {
			try {startDate = formatter.parse(search.getStartDate());}catch(ParseException e){}
			try {endDate = formatter.parse(search.getEndDate());}catch(ParseException e){}
		}
		List<ConsultationReport> reports = consultationReportDao.search(search.getStatus(),search.getProvider(),search.getDemographicNo(),startDate,endDate);
		for(ConsultationReport report:reports) {
			report.setDemographic(demographicDao.getDemographicById(report.getDemographicNo()));
		}
		request.setAttribute("reports", reports);
		
		return mapping.findForward("list");
	}
	
	public ActionForward listForDemographic(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)  {
		String demoNo = request.getParameter("demographicNo");
		
		List<ConsultationReport> reports = consultationReportDao.findByDemographicNo(Integer.parseInt(demoNo));
		
		request.setAttribute("reports", reports);
		
		return mapping.findForward("listDemographic");
	}
	
	public ActionForward createOBForm(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)  {
		String demoNo = request.getParameter("demographicNo");
		ConsultationReport con = new ConsultationReport();
		con.setProvider(LoggedInInfo.loggedInInfo.get().loggedInProvider.getFormattedName());
		con.setDemographicNo(Integer.parseInt(demoNo));
		con.setStatus("1");
		
		org.apache.struts.validator.DynaValidatorForm f = (org.apache.struts.validator.DynaValidatorForm)form;
		f.set("cp", con);
		
		return mapping.findForward("obForm");
	}
	
	public ActionForward editOBForm(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)  {
		String id = request.getParameter("id");
		ConsultationReport con = consultationReportDao.find(Integer.parseInt(id));
		
		//convert the plan to something i can use.
		String[] tests = con.getPlan().split(";");
		Map<String,Boolean> testMap = new HashMap<String,Boolean>();
		for(String test:tests) {
			testMap.put(test,true);
		}
		request.setAttribute("testMap", testMap);
		
		org.apache.struts.validator.DynaValidatorForm f = (org.apache.struts.validator.DynaValidatorForm)form;
		f.set("cp", con);
		
		return mapping.findForward("obForm");
	}
	
	public ActionForward saveConReport(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)  {
		ConsultationReport con = null;
		String id = request.getParameter("cp.id");
		
		org.apache.struts.validator.DynaValidatorForm f = (org.apache.struts.validator.DynaValidatorForm)form;
		con = (ConsultationReport)f.get("cp");
		con.setStatusText(formatStatus(con.getStatus()));
		
		List<ProfessionalSpecialist> specs = professionalSpecialistDao.findByReferralNo(con.getReferralId());
		if(specs.size()>0) {
			ProfessionalSpecialist ps = specs.get(0);
			con.setSendTo(ps.getFormattedName());
		}
		con.setConType("AR2");
		
		StringBuilder sb = new StringBuilder();
		for(String val:request.getParameterValues("cp.plan")) {
			if(sb.length()>0)
				sb.append(";");
			sb.append(val);
		}
		con.setPlan(sb.toString());
		
		if(id != null && !id.equals("null") && !id.equals("") && Integer.parseInt(id) > 0) {
			con.setId(Integer.parseInt(id));
			consultationReportDao.merge(con);
		} else {
			con.setId(null);
			consultationReportDao.persist(con);
		}
	
		if(request.getParameter("print") != null && request.getParameter("print").equals("true")) {
			request.setAttribute("report",con);
			if(specs.size()>0)
				request.setAttribute("spec",specs.get(0));
			request.setAttribute("demographic",demographicDao.getDemographicById(con.getDemographicNo()));
			
			return mapping.findForward("print");
		}
		return mapping.findForward("close");
	}
	
	private String formatStatus(String s) {
		if(s.equals("1"))
			return "Incomplete";
		if(s.equals("2"))
			return "Completed, not sent";
		if(s.equals("3"))
			return "Completed, and sent";
		return "";
	}
	
}
