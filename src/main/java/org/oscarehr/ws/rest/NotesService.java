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
package org.oscarehr.ws.rest;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.ws.rs.Consumes;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

import org.apache.log4j.Logger;
import org.oscarehr.casemgmt.model.CaseManagementNote;
import org.oscarehr.casemgmt.service.CaseManagementManager;
import org.oscarehr.casemgmt.service.NoteSelectionCriteria;
import org.oscarehr.casemgmt.service.NoteSelectionResult;
import org.oscarehr.casemgmt.service.NoteService;
import org.oscarehr.casemgmt.web.NoteDisplay;
import org.oscarehr.common.dao.SecRoleDao;
import org.oscarehr.common.model.SecRole;
//import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;
import org.oscarehr.ws.rest.to.model.NoteSelectionTo1;
import org.oscarehr.ws.rest.to.model.NoteTo1;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import oscar.oscarEncounter.data.EctProgram;

//import oscar.OscarProperties;

@Path("/notes")
@Component("notesService")
public class NotesService extends AbstractServiceImpl {

	private static Logger logger = MiscUtils.getLogger();
	
	@Autowired
	private NoteService noteService; 
	//= SpringUtils.getBean(NoteService.class);
	
	@Autowired
	private CaseManagementManager caseManagementMgr;
	
	
	@GET
	@Path("/{demographicNo}/all")
	@Produces("application/json")
	public NoteSelectionTo1 getFormsForHeading(@PathParam("demographicNo") Integer demographicNo ,@DefaultValue("20") @QueryParam("numToReturn") Integer numToReturn,@DefaultValue("0") @QueryParam("offset") Integer offset){
	/*
		HttpSession se = request.getSession();
		if (se.getAttribute("userrole") == null) {
			return mapping.findForward("expired");
		}

		String demoNo = getDemographicNo(request);

		logger.debug("is client in program");
		// need to check to see if the client is in our program domain
		// if not...don't show this screen!
		String roles = (String) se.getAttribute("userrole");
		if (OscarProperties.getInstance().isOscarLearning() && roles != null && roles.indexOf("moderator") != -1) {
			logger.info("skipping domain check..provider is a moderator");
		} else if (!caseManagementMgr.isClientInProgramDomain(LoggedInInfo.loggedInInfo.get().loggedInProvider.getProviderNo(), demoNo) && !caseManagementMgr.isClientReferredInProgramDomain(LoggedInInfo.loggedInInfo.get().loggedInProvider.getProviderNo(), demoNo)) {
			return mapping.findForward("domain-error");
		}
		 */ 
		
		HttpSession se = getLoggedInInfo().session;
		String user_no = (String) se.getAttribute("user");
		String programId = new EctProgram(se).getProgram(user_no);
		
		//String programId = "10016";//(String) request.getSession().getAttribute("case_program_id");

		// viewCurrentIssuesTab_newCmeNotesOpt(request, caseForm, demoNo, programId);
		
		NoteSelectionCriteria criteria = new NoteSelectionCriteria();
		
		criteria.setMaxResults(numToReturn);
		criteria.setFirstResult(offset);
		
		criteria.setDemographicId(demographicNo);
		//criteria.setUserRole((String) request.getSession().getAttribute("userrole"));
		//criteria.setUserName((String) request.getSession().getAttribute("user"));
//				if (request.getParameter("note_sort") != null && request.getParameter("note_sort").length() > 0) {
		criteria.setNoteSort("observation_date_desc");
	///	}
				

		if (programId != null && !programId.trim().isEmpty()) {
			criteria.setProgramId(programId);
		}
		
		/*
		if (caseForm != null && caseForm.getFilter_roles() != null) {
			List<String> rs = Arrays.asList(caseForm.getFilter_roles());
			criteria.getRoles().addAll(rs);
			se.setAttribute("CaseManagementViewAction_filter_roles", rs);
		}

		if (caseForm != null && caseForm.getFilter_providers() != null) {
			List<String> rs = Arrays.asList(caseForm.getFilter_providers());
			criteria.getProviders().addAll(rs);
			se.setAttribute("CaseManagementViewAction_filter_providers", rs);
		}
		
		String[] checkedIssues = request.getParameterValues("issues");
		if (checkedIssues != null) {
			List<String> rs = Arrays.asList(checkedIssues);
			criteria.getIssues().addAll(rs);
			se.setAttribute("CaseManagementViewAction_filter_issues", rs);
		}
		 */
		if (logger.isDebugEnabled()) {
			logger.debug("SEARCHING FOR NOTES WITH CRITERIA: " + criteria);
		}
		
		NoteSelectionResult result = noteService.findNotes(criteria);
		
		if (logger.isDebugEnabled()) {
			logger.debug("FOUND: " + result);
			for(NoteDisplay nd : result.getNotes()) {
				logger.debug("   " + nd.getClass().getSimpleName() + " " + nd.getNoteId() + " " + nd.getNote());
			}
		}
		
		
		NoteSelectionTo1 returnResult = new NoteSelectionTo1();
		returnResult.setMoreNotes(result.isMoreNotes());
		List<NoteTo1> noteList = returnResult.getNotelist();
		for(NoteDisplay nd : result.getNotes()) {
			NoteTo1 note = new NoteTo1();
			note.setNoteId(nd.getNoteId());
			
			note.setIsSigned(nd.isSigned());
			note.setIsEditable(nd.isEditable());
			note.setObservationDate(nd.getObservationDate());
			note.setRevision(nd.getRevision());
			note.setUpdateDate(nd.getUpdateDate());
			note.setProviderName(nd.getProviderName());
			note.setProviderNo(nd.getProviderNo());
			note.setStatus(nd.getStatus());
			note.setProgramName(nd.getProgramName());
			note.setLocation(nd.getLocation());
			note.setRoleName(nd.getRoleName());
			note.setRemoteFacilityId(nd.getRemoteFacilityId());
			note.setUuid(nd.getUuid());
			note.setHasHistory(nd.getHasHistory());
			note.setLocked(nd.isLocked());
			note.setNote(nd.getNote());
			note.setDocument(nd.isDocument());
			note.setRxAnnotation(nd.isRxAnnotation());
			note.setEformData(nd.isEformData());
			note.setEncounterForm(nd.isEncounterForm());
			note.setInvoice(nd.isInvoice());
			note.setTicklerNote(nd.isTicklerNote());
			note.setEncounterType(nd.getEncounterType());
			note.setEditorNames(nd.getEditorNames());
			note.setIssueDescriptions(nd.getIssueDescriptions());
			note.setReadOnly(nd.isReadOnly());
			note.setGroupNote(nd.isGroupNote());
			note.setCpp(nd.isCpp());
			note.setEncounterTime(nd.getEncounterTime());	
			note.setEncounterTransportationTime(nd.getEncounterTransportationTime());
			
			noteList.add(note);
			logger.debug("   " + nd.getClass().getSimpleName() + " " + nd.getNoteId() + " " + nd.getNote());
		}
		
		
		return returnResult;
	}
	
	@POST
	@Path("/{demographicNo}/save")
	@Consumes("application/json")
	@Produces("application/json")
	public NoteTo1 saveNote(@PathParam("demographicNo") Integer demographicNo ,NoteTo1 note){
		logger.debug("note"+note.getNote()+" note "+note);
		CaseManagementNote cmn = new CaseManagementNote();
		cmn.setNote(note.getNote());
		cmn.setObservation_date(new Date());
		cmn.setDemographic_no(""+demographicNo);
		cmn.setProvider(getCurrentProvider());
		cmn.setProviderNo(getCurrentProvider().getProviderNo());
		cmn.setSigning_provider_no(getCurrentProvider().getProviderNo());
		
		String programId = new EctProgram(getLoggedInInfo().session).getProgram(getCurrentProvider().getProviderNo());
		
		
		cmn.setProgram_no(programId);
		//cmn.setReporter_caisi_role("2");
		
		SecRoleDao secRoleDao = (SecRoleDao) SpringUtils.getBean("secRoleDao");
		SecRole doctorRole = secRoleDao.findByName("doctor");		
		cmn.setReporter_caisi_role(doctorRole.getId().toString());
		
		//reporter_program_team
		cmn.setReporter_program_team("0");
		cmn.setHistory(note.getNote());

		
		caseManagementMgr.saveNoteSimple(cmn);
		
		note.setNoteId(Integer.parseInt(""+cmn.getId()));
		return note;
	}
		
	

}
