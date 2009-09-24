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
* Toronto, Ontario, Canada  - UPDATED: Quatro Group 2008/2009
 */

package org.oscarehr.PMmodule.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import org.oscarehr.PMmodule.web.formbean.IncidentForm;

import oscar.MyDateFormat;

import com.quatro.dao.IncidentDao;
import com.quatro.dao.security.SecProviderDao;
import com.quatro.model.IncidentValue;
import com.quatro.model.security.SecProvider;
import com.quatro.service.LookupManager;
import com.quatro.util.KeyValueBean;

public class IncidentManager {

	private IncidentDao incidentDao;
	
	private SecProviderDao secProviderDao;
	
	private LookupManager lookupManager;

	public IncidentForm getIncidentForm(String incidentId) throws SQLException{
		IncidentForm incidentForm = new IncidentForm();
		IncidentValue incident = null;
		if( incidentId == null || incidentId.equals("0"))
			incident = new IncidentValue();
		else{
			incident = incidentDao.findById(Integer.valueOf(incidentId));
			
			String clients = incident.getClients();
			if(clients != null && clients.length() > 1){
				ArrayList clientSelectionList = new ArrayList();
				int sep = clients.indexOf("/");
				String keys = clients.substring(0, sep);
				String values = clients.substring(sep + 1);
				String[] k = keys.split(":");
				String[] v = values.split(":");
				for(int i = 0; i < k.length; i++){
					clientSelectionList.add(new KeyValueBean(k[i],v[i]));
				}
				incidentForm.setClientSelectionList(clientSelectionList);
			}
			String staff = incident.getStaff();
			if(staff != null && staff.length() > 1){
				ArrayList staffSelectionList = new ArrayList();
				int sep = staff.indexOf("/");
				String keys = staff.substring(0, sep);
				String values = staff.substring(sep + 1);
				String[] k = keys.split(":");
				String[] v = values.split(":");
				for(int i = 0; i < k.length; i++){
					staffSelectionList.add(new KeyValueBean(k[i],v[i]));
				}
				incidentForm.setStaffSelectionList(staffSelectionList);
			}
	
			String incidentTime = incident.getIncidentTime();
			
			String	hour = incidentTime.substring(0,2);
			if(hour.equals("--"))
				hour = "";
			String minute = incidentTime.substring(3,5);
			if(minute.equals("--"))
				minute = "";
			String ampm = incidentTime.substring(5);
			
			incidentForm.setHour(hour);
			incidentForm.setMinute(minute);
			incidentForm.setAmpm(ampm);
		
		}

		String others = incident.getOtherInvolved();
		String natures = incident.getNature();
		String issues = incident.getClientIssues();
		String disposition = incident.getDisposition();
		if (others != null) {
			String[] othersArr = others.split(",");
			incidentForm.setOthersArr(othersArr);
		}
		
		if (natures != null) {
			String[] naturesArr = natures.split(",");
			incidentForm.setNaturesArr(naturesArr);
		}
		
		if (issues != null) {
			String[] issuesArr = issues.split(",");
			incidentForm.setIssuesArr(issuesArr);
		}
		
		if (disposition != null) {
			String[] dispositionArr = disposition.split(",");
			incidentForm.setDispositionArr(dispositionArr);
		}
		
		List clientIssuesLst = lookupManager.LoadCodeList("ICI", true,
				null, null);
		List dispositionLst = lookupManager.LoadCodeList("IDS", true,
				null, null);
		List natureLst = lookupManager.LoadCodeList("INI",
				true, null, null);
		List othersLst = lookupManager.LoadCodeList("IOI",
				true, null, null);

				
		incidentForm.setClientIssuesLst(clientIssuesLst);
		incidentForm.setDispositionLst(dispositionLst);
		incidentForm.setNatureLst(natureLst);
		incidentForm.setOthersLst(othersLst);
		
		if(incident.getProviderNo() != null){
			SecProvider provider = secProviderDao.findById(incident.getProviderNo());
			incidentForm.setProviderName(provider.getFirstName() + " " + provider.getLastName() );
		}
		incidentForm.setIncident(incident);
		return incidentForm;
	}
	public String saveIncident(IncidentForm incidentForm) {
		
		IncidentValue incident = incidentForm.getIncident();
		
		String ampm = incidentForm.getAmpm();
		String hour = incidentForm.getHour();
		String minute = incidentForm.getMinute();
		if(ampm == null)
			ampm = "NA";
		if(hour == null || hour.equals(""))
			hour = "--";
		if(minute == null || minute.equals(""))
			minute = "--";
		String incidentTime = hour + ":" + minute + ampm;
		
		incident.setIncidentTime(incidentTime);
		incident.setCreatedDate(MyDateFormat.getCalendar(incidentForm.getCreatedDateStr()));
		incident.setFollowupDate(MyDateFormat.getCalendar(incidentForm.getFollowupDateStr()));
		incident.setIncidentDate(MyDateFormat.getCalendar(incidentForm.getIncidentDateStr()));
		incident.setInvestigationDate(MyDateFormat.getCalendar(incidentForm.getInvestigationDateStr()));

		if (incident.getId() == null || incident.getId().intValue() == 0) {
			incident.setId(null);
			incident.setCreatedDate(Calendar.getInstance());
		} 
		
		// checkboxes
		String[] othersArr = incidentForm.getOthersArr();
		String[] naturesArr = incidentForm.getNaturesArr();
		String[] issuesArr = incidentForm.getIssuesArr();
		String[] dispositionArr = incidentForm.getDispositionArr();
		
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < othersArr.length; i++) {
			sb.append("," + othersArr[i]);
		}
		incident.setOtherInvolved(sb.toString());
		
		StringBuffer sb2 = new StringBuffer();
		for (int i = 0; i < naturesArr.length; i++) {
			sb2.append("," + naturesArr[i]);
		}
		incident.setNature(sb2.toString());
		
		StringBuffer sb3 = new StringBuffer();
		for (int i = 0; i < issuesArr.length; i++) {
			sb3.append("," + issuesArr[i]);
		}
		incident.setClientIssues(sb3.toString());
		
		StringBuffer sb4 = new StringBuffer();
		for (int i = 0; i < dispositionArr.length; i++) {
			sb4.append("," + dispositionArr[i]);
		}
		incident.setDisposition(sb4.toString());

		String clients = incidentForm.getTxtClientKeys() + "/" + incidentForm.getTxtClientValues();
		incident.setClients(clients);
		String staff = incidentForm.getTxtStaffKeys() + "/" + incidentForm.getTxtStaffValues();
		incident.setStaff(staff);
		if(incident.getDescription()!=null && incident.getDescription().length() > 4000)
		incident.setDescription(incident.getDescription().substring(0, 3999));
		
 		incidentDao.save(incident);
 		String incidentId = "";
 		if(incident.getId() != null )
 			incidentId = incident.getId().toString();
 		return incidentId;
	}
	
	public void setIncidentDao(IncidentDao incidentDao) {
		this.incidentDao = incidentDao;
	}
	
	public List search(IncidentForm incidentForm) {
		return incidentDao.search(incidentForm);
	}
	
	public List getIncidentsByProgramId(Integer programId) {
		return incidentDao.findByProgramId(programId);
	}

	public IncidentValue getIncidentsById(Integer incidentId) {
		return incidentDao.findById(incidentId);
	}

	public void save(IncidentValue incident) {
		incidentDao.save(incident);
	}
	public void setLookupManager(LookupManager lookupManager) {
		this.lookupManager = lookupManager;
	}
	public void setSecProviderDao(SecProviderDao secProviderDao) {
		this.secProviderDao = secProviderDao;
	}
	public SecProvider findProviderById(String providerNo){
		return secProviderDao.findById(providerNo);
	}
}
