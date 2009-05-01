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

package org.oscarehr.PMmodule.caisi_integrator;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.ws.WebServiceException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.jfree.util.Log;
import org.oscarehr.PMmodule.dao.ProgramDao;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.caisi_integrator.ws.CachedDemographicDrug;
import org.oscarehr.caisi_integrator.ws.CachedDemographicIssue;
import org.oscarehr.caisi_integrator.ws.CachedDemographicPrevention;
import org.oscarehr.caisi_integrator.ws.CachedFacility;
import org.oscarehr.caisi_integrator.ws.CachedProgram;
import org.oscarehr.caisi_integrator.ws.CachedProvider;
import org.oscarehr.caisi_integrator.ws.ConsentParameters;
import org.oscarehr.caisi_integrator.ws.DemographicTransfer;
import org.oscarehr.caisi_integrator.ws.DemographicWs;
import org.oscarehr.caisi_integrator.ws.FacilityIdDemographicIssueCompositePk;
import org.oscarehr.caisi_integrator.ws.FacilityIdIntegerCompositePk;
import org.oscarehr.caisi_integrator.ws.FacilityIdStringCompositePk;
import org.oscarehr.caisi_integrator.ws.FacilityWs;
import org.oscarehr.caisi_integrator.ws.HnrWs;
import org.oscarehr.caisi_integrator.ws.NoteTransfer;
import org.oscarehr.caisi_integrator.ws.PreventionExtTransfer;
import org.oscarehr.caisi_integrator.ws.ProgramWs;
import org.oscarehr.caisi_integrator.ws.ProviderWs;
import org.oscarehr.casemgmt.dao.CaseManagementIssueDAO;
import org.oscarehr.casemgmt.dao.CaseManagementNoteDAO;
import org.oscarehr.casemgmt.dao.ClientImageDAO;
import org.oscarehr.casemgmt.model.CaseManagementIssue;
import org.oscarehr.casemgmt.model.CaseManagementNote;
import org.oscarehr.casemgmt.model.ClientImage;
import org.oscarehr.casemgmt.model.Issue;
import org.oscarehr.common.dao.ClientLinkDao;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.DrugDao;
import org.oscarehr.common.dao.FacilityDao;
import org.oscarehr.common.dao.IntegratorConsentDao;
import org.oscarehr.common.dao.PreventionDao;
import org.oscarehr.common.model.ClientLink;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.Drug;
import org.oscarehr.common.model.Facility;
import org.oscarehr.common.model.IntegratorConsent;
import org.oscarehr.common.model.Prevention;
import org.oscarehr.common.model.Provider;
import org.oscarehr.util.DbConnectionFilter;
import org.oscarehr.util.LoggedInUserFilter;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.ShutdownException;
import org.oscarehr.util.SpringUtils;

import oscar.OscarProperties;

public class CaisiIntegratorUpdateTask extends TimerTask {

	private static final Logger logger = LogManager.getLogger(CaisiIntegratorUpdateTask.class);

	private static final String INTEGRATOR_UPDATE_PERIOD_PROPERTIES_KEY = "INTEGRATOR_UPDATE_PERIOD";

	private static Timer timer = new Timer("CaisiIntegratorUpdateTask Timer", true);
	private static TimerTask timerTask = null;

	private CaisiIntegratorManager caisiIntegratorManager = (CaisiIntegratorManager) SpringUtils.getBean("caisiIntegratorManager");
	private FacilityDao facilityDao = (FacilityDao) SpringUtils.getBean("facilityDao");
	private DemographicDao demographicDao = (DemographicDao) SpringUtils.getBean("demographicDao");
	private CaseManagementIssueDAO caseManagementIssueDAO = (CaseManagementIssueDAO) SpringUtils.getBean("caseManagementIssueDAO");
	private CaseManagementNoteDAO caseManagementNoteDAO = (CaseManagementNoteDAO) SpringUtils.getBean("CaseManagementNoteDAO");
	private ClientImageDAO clientImageDAO = (ClientImageDAO) SpringUtils.getBean("clientImageDAO");
	private IntegratorConsentDao integratorConsentDao = (IntegratorConsentDao) SpringUtils.getBean("integratorConsentDao");
	private ProgramDao programDao = (ProgramDao) SpringUtils.getBean("programDao");
	private ProviderDao providerDao = (ProviderDao) SpringUtils.getBean("providerDao");
	private PreventionDao preventionDao = (PreventionDao) SpringUtils.getBean("preventionDao");
	private ClientLinkDao clientLinkDao = (ClientLinkDao) SpringUtils.getBean("clientLinkDao");
	private DrugDao drugDao = (DrugDao) SpringUtils.getBean("drugDao");

	// private CaseManagementNoteDAO caseManagementNoteDAO = (CaseManagementNoteDAO) SpringUtils.getBean("CaseManagementNoteDAO");

	static {
		// ensure cxf uses log4j
		System.setProperty("org.apache.cxf.Logger", "org.apache.cxf.common.logging.Log4jLogger");
	}

	public static synchronized void startTask() {
		if (timerTask == null) {
			int period = 0;
			String periodStr = null;
			try {
				periodStr = (String) OscarProperties.getInstance().get(INTEGRATOR_UPDATE_PERIOD_PROPERTIES_KEY);
				period = Integer.parseInt(periodStr);
			} catch (Exception e) {
				logger.error("CaisiIntegratorUpdateTask not scheduled, period is missing or invalid properties file : " + INTEGRATOR_UPDATE_PERIOD_PROPERTIES_KEY + '=' + periodStr, e);
				return;
			}

			logger.info("Scheduling CaisiIntegratorUpdateTask for period : " + period);
			timerTask = new CaisiIntegratorUpdateTask();
			timer.schedule(timerTask, 10000, period);
		} else {
			logger.error("Start was called twice on this timer task object.", new Exception());
		}
	}

	public static synchronized void stopTask() {
		if (timerTask != null) {
			timerTask.cancel();
			timerTask = null;

			logger.info("CaisiIntegratorUpdateTask has been unscheduled.");
		}
	}

	public void run() {
		logger.debug("CaisiIntegratorUpdateTask starting");

		LoggedInUserFilter.setLoggedInInfoToCurrentClassName();

		try {
			pushAllFacilities();
		} catch (ShutdownException e) {
			logger.debug("CaisiIntegratorUpdateTask received shutdown notice.");
		} catch (Exception e) {
			logger.error("unexpected error occurred", e);
		} finally {
			LoggedInUserFilter.loggedInInfo.remove();
			DbConnectionFilter.releaseThreadLocalDbConnection();

			logger.debug("CaisiIntegratorUpdateTask finished");
		}
	}

	public void pushAllFacilities() throws IOException, DatatypeConfigurationException, IllegalAccessException, InvocationTargetException, ShutdownException {
		List<Facility> facilities = facilityDao.findAll(null);

		for (Facility facility : facilities) {
			MiscUtils.checkShutdownSignaled();

			try {
				if (facility.isDisabled() == false && facility.isIntegratorEnabled() == true) {
					pushAllFacilityData(facility);
				}
			} catch (WebServiceException e) {
				if (CxfClientUtils.isConnectionException(e)) {
					logger.warn("Error connecting to integrator. " + e.getMessage());
					logger.debug("Error connecting to integrator.", e);
				} else {
					logger.error("Unexpected error.", e);
				}
			} catch (Exception e) {
				logger.error("Unexpected error.", e);
			}
		}
	}

	private void pushAllFacilityData(Facility facility) throws IOException, DatatypeConfigurationException, IllegalAccessException, InvocationTargetException, ShutdownException {
		logger.debug("Pushing data for facility : " + facility.getId() + " : " + facility.getName());

		// check all parameters are present
		String integratorBaseUrl = facility.getIntegratorUrl();
		String user = facility.getIntegratorUser();
		String password = facility.getIntegratorPassword();

		if (integratorBaseUrl == null || user == null || password == null) {
			logger.warn("Integrator is enabled but information is incomplete. facilityId=" + facility.getId() + ", user=" + user + ", password=" + password + ", url=" + integratorBaseUrl);
			return;
		}

		// get the time here so there's a slight over lap in actual runtime and
		// activity time, other wise you'll have a gap, better to unnecessarily
		// send a few more records than to miss some.
		Date currentPushTime = new Date();

		// do all the sync work
		// in theory sync should only send changed data, but currently due to
		// the lack of proper data models, we don't have a reliable timestamp on when things change so we just push everything, highly inefficient but it works until we fix the
		// data model.
		pushFacility(facility);
		pushPrograms(facility);
		pushProviders(facility);
		pushAllDemographics(facility);

		// update late push time only if an exception didn't occur
		// re-get the facility as the sync time could be very long and changes
		// may have been made to the facility.
		facility = facilityDao.find(facility.getId());
		facility.setIntegratorLastPushTime(currentPushTime);
		facilityDao.merge(facility);
	}

	private void pushFacility(Facility facility) throws MalformedURLException, IllegalAccessException, InvocationTargetException {
		CachedFacility cachedFacility = new CachedFacility();
		BeanUtils.copyProperties(cachedFacility, facility);

		FacilityWs service = caisiIntegratorManager.getFacilityWs(facility.getId());

		logger.debug("pushing facility");
		service.setMyFacility(cachedFacility);
	}

	private void pushPrograms(Facility facility) throws MalformedURLException, IllegalAccessException, InvocationTargetException, ShutdownException {
		List<Program> programs = programDao.getProgramsByFacilityId(facility.getId());

		ArrayList<CachedProgram> cachedPrograms = new ArrayList<CachedProgram>();

		for (Program program : programs) {
			MiscUtils.checkShutdownSignaled();

			CachedProgram cachedProgram = new CachedProgram();

			BeanUtils.copyProperties(cachedProgram, program);

			FacilityIdIntegerCompositePk pk = new FacilityIdIntegerCompositePk();
			pk.setCaisiItemId(program.getId());
			cachedProgram.setFacilityIdIntegerCompositePk(pk);

			cachedProgram.setGender(program.getManOrWoman());
			if (program.isTransgender()) cachedProgram.setGender("T");

			cachedProgram.setMaxAge(program.getAgeMax());
			cachedProgram.setMinAge(program.getAgeMin());
			cachedProgram.setStatus(program.getProgramStatus());

			cachedPrograms.add(cachedProgram);
		}

		ProgramWs service = caisiIntegratorManager.getProgramWs(facility.getId());
		service.setCachedPrograms(cachedPrograms);
	}

	private void pushProviders(Facility facility) throws MalformedURLException, IllegalAccessException, InvocationTargetException, ShutdownException {
		List<String> providerIds = ProviderDao.getProviderIds(facility.getId());

		ArrayList<CachedProvider> cachedProviders = new ArrayList<CachedProvider>();

		for (String providerId : providerIds) {
			MiscUtils.checkShutdownSignaled();
			logger.debug("Adding provider " + providerId + " for " + facility.getName());
			Provider provider = providerDao.getProvider(providerId);

			CachedProvider cachedProvider = new CachedProvider();

			BeanUtils.copyProperties(cachedProvider, provider);

			FacilityIdStringCompositePk pk = new FacilityIdStringCompositePk();
			pk.setCaisiItemId(provider.getProviderNo());
			cachedProvider.setFacilityIdStringCompositePk(pk);

			cachedProviders.add(cachedProvider);
		}

		ProviderWs service = caisiIntegratorManager.getProviderWs(facility.getId());
		service.setCachedProviders(cachedProviders);
	}

	private void pushAllDemographics(Facility facility) throws MalformedURLException, DatatypeConfigurationException, IllegalAccessException, InvocationTargetException, ShutdownException {
		List<Integer> demographicIds = DemographicDao.getDemographicIdsAdmittedIntoFacility(facility.getId());
		DemographicWs demogrpahicService = caisiIntegratorManager.getDemographicWs(facility.getId());
		HnrWs hnrService = caisiIntegratorManager.getHnrWs(facility.getId());
		List<Program> programsInFacility = programDao.getProgramsByFacilityId(facility.getId());
		List<String> providerIdsInFacility = ProviderDao.getProviderIds(facility.getId());

		for (Integer demographicId : demographicIds) {
			logger.debug("pushing demographic facilityId:" + facility.getId() + ", demographicId:" + demographicId);

			MiscUtils.checkShutdownSignaled();

			try {
				pushDemographic(facility, demogrpahicService, demographicId);
				// it's safe to set the consent later so long as we default it to none when we send the original demographic data in the line above.
				pushDemographicConsent(facility, demogrpahicService, hnrService, demographicId);
				pushDemographicIssues(facility, programsInFacility, demogrpahicService, demographicId);
				pushDemographicPreventions(facility, providerIdsInFacility, demogrpahicService, demographicId);
				pushDemographicNotes(facility, demogrpahicService, demographicId);
				pushDemographicDrugs(facility, providerIdsInFacility, demogrpahicService, demographicId);
			} catch (IllegalArgumentException iae) {
				// continue processing demographics if date values in current demographic are bad
				// all other errors thrown by the above methods should indicate a failure in the service
				// connection at large -- continuing to process not possible
				// need some way of notification here.
				logger.error("Error updating demographic, continuing with Demographic batch", iae);
			} catch (Exception e) {
				logger.error("Unexpected error.", e);
			}
		}
	}

	private void pushDemographic(Facility facility, DemographicWs service, Integer demographicId) throws IllegalAccessException, InvocationTargetException, DatatypeConfigurationException {
		DemographicTransfer demographicTransfer = new DemographicTransfer();

		// set demographic info
		Demographic demographic = demographicDao.getDemographicById(demographicId);

		BeanUtils.copyProperties(demographicTransfer, demographic);

		demographicTransfer.setCaisiDemographicId(demographic.getDemographicNo());
		demographicTransfer.setBirthDate(demographic.getBirthDay().getTime());

		demographicTransfer.setHinVersion(demographic.getVer());
		demographicTransfer.setGender(demographic.getSex());

		// set image
		ClientImage clientImage = clientImageDAO.getClientImage(demographicId);
		if (clientImage != null) {
			demographicTransfer.setPhoto(clientImage.getImage_data());
			demographicTransfer.setPhotoUpdateDate(clientImage.getUpdate_date());
		}

		// send the request
		service.setDemographic(demographicTransfer);
	}

	private void pushDemographicConsent(Facility facility, DemographicWs demographicService, HnrWs hnrService, Integer demographicId) throws MalformedURLException, IllegalAccessException, InvocationTargetException, DatatypeConfigurationException {

		// get a list of all remove facilities
		// for each remote facility get the latest consent
		// then send the latest consent to the integrator
		List<CachedFacility> remoteFacilities = caisiIntegratorManager.getRemoteFacilities(facility.getId());
		for (CachedFacility remoteFacility : remoteFacilities) {
			IntegratorConsent consent = integratorConsentDao.findLatestByFacilityDemographicAndRemoteFacility(facility.getId(), demographicId, remoteFacility.getIntegratorFacilityId());
			if (consent != null) {
				ConsentParameters consentParameters = new ConsentParameters();

				// copy consent manually because it's kinda dangerous to use bean copy for these objects, too large with too many unrelated variables
				consentParameters.setIntegratorFacilityId(consent.getIntegratorFacilityId());
				consentParameters.setCaisiDemographicId(demographicId);
				consentParameters.setConsentToHealthNumberRegistry(consent.isConsentToHealthNumberRegistry());
				consentParameters.setRestrictConsentToHic(consent.isRestrictConsentToHic());
				consentParameters.setConsentToAllNonDomainData(consent.isConsentToAllNonDomainData());
				consentParameters.setConsentToMentalHealthData(consent.isConsentToMentalHealthData());
				consentParameters.setConsentToSearches(consent.isConsentToSearches());
				consentParameters.setCreatedDate(consent.getCreatedDate());

				demographicService.setCachedDemographicConsent(consentParameters);

				// deal with hnr consent
				List<ClientLink> clientLinks = clientLinkDao.findByFacilityIdClientIdType(facility.getId(), demographicId, true, ClientLink.Type.HNR);
				if (clientLinks.size() > 1) logger.warn("HNR link should only be 1 link. Links found :" + clientLinks.size());
				if (clientLinks.size() > 0) {
					hnrService.setHnrClientHidden(clientLinks.get(0).getRemoteLinkId(), !consent.isConsentToHealthNumberRegistry(), consent.getCreatedDate());
				}
			}
		}
	}

	private void pushDemographicIssues(Facility facility, List<Program> programsInFacility, DemographicWs service, Integer demographicId) throws IllegalAccessException, InvocationTargetException, ShutdownException {
		logger.debug("pushing demographicIssues facilityId:" + facility.getId() + ", demographicId:" + demographicId);

		List<CaseManagementIssue> caseManagementIssues = caseManagementIssueDAO.getIssuesByDemographic(demographicId.toString());
		if (caseManagementIssues.size() == 0) return;

		ArrayList<CachedDemographicIssue> issues = new ArrayList<CachedDemographicIssue>();
		for (CaseManagementIssue caseManagementIssue : caseManagementIssues) {
			MiscUtils.checkShutdownSignaled();

			// don't send issue if it is not in our facility.
			logger.debug("Facility:" + facility.getName() + " - caseManagementIssue = " + caseManagementIssue.toString());
			if (caseManagementIssue.getProgram_id() == null || !isProgramIdInProgramList(programsInFacility, caseManagementIssue.getProgram_id())) continue;

			Issue issue = caseManagementIssue.getIssue();
			CachedDemographicIssue issueTransfer = new CachedDemographicIssue();

			FacilityIdDemographicIssueCompositePk facilityDemographicIssuePrimaryKey = new FacilityIdDemographicIssueCompositePk();
			facilityDemographicIssuePrimaryKey.setCaisiDemographicId(Integer.parseInt(caseManagementIssue.getDemographic_no()));
			facilityDemographicIssuePrimaryKey.setIssueCode(issue.getCode());
			issueTransfer.setFacilityDemographicIssuePk(facilityDemographicIssuePrimaryKey);

			BeanUtils.copyProperties(issueTransfer, caseManagementIssue);
			issueTransfer.setIssueDescription(issue.getDescription());

			issues.add(issueTransfer);
		}

		if (issues.size() > 0) service.setCachedDemographicIssues(issues);
	}

	private boolean isProgramIdInProgramList(List<Program> programList, int programId) {
		for (Program p : programList) {
			if (p.getId().intValue() == programId) return (true);
		}

		return (false);
	}

	private void pushDemographicPreventions(Facility facility, List<String> providerIdsInFacility, DemographicWs service, Integer demographicId) throws DatatypeConfigurationException, ShutdownException {
		logger.debug("pushing demographicPreventions facilityId:" + facility.getId() + ", demographicId:" + demographicId);

		ArrayList<CachedDemographicPrevention> preventionsToSend = new ArrayList<CachedDemographicPrevention>();
		ArrayList<PreventionExtTransfer> preventionExtsToSend = new ArrayList<PreventionExtTransfer>();

		// get all preventions
		// for each prevention, copy fields to an integrator prevention
		// need to copy ext info
		// add prevention to array list to send
		List<Prevention> localPreventions = preventionDao.findNotDeletedByDemographicId(demographicId);
		for (Prevention localPrevention : localPreventions) {
			MiscUtils.checkShutdownSignaled();

			if (!providerIdsInFacility.contains(localPrevention.getCreatorProviderNo())) continue;

			CachedDemographicPrevention cachedDemographicPrevention = new CachedDemographicPrevention();
			cachedDemographicPrevention.setCaisiDemographicId(demographicId);
			cachedDemographicPrevention.setCaisiProviderId(localPrevention.getProviderNo());

			{
				FacilityIdIntegerCompositePk pk = new FacilityIdIntegerCompositePk();
				pk.setCaisiItemId(localPrevention.getId());
				cachedDemographicPrevention.setFacilityPreventionPk(pk);
			}

			cachedDemographicPrevention.setNextDate(localPrevention.getNextDate());
			cachedDemographicPrevention.setPreventionDate(localPrevention.getPreventionDate());

			cachedDemographicPrevention.setPreventionType(localPrevention.getPreventionType());

			preventionsToSend.add(cachedDemographicPrevention);

			// add ext info
			Integer preventionId = localPrevention.getId();
			HashMap<String, String> localPreventionExts = preventionDao.getPreventionExt(preventionId);
			for (Map.Entry<String, String> entry : localPreventionExts.entrySet()) {
				PreventionExtTransfer preventionExtTransfer = new PreventionExtTransfer();
				preventionExtTransfer.setPreventionId(preventionId);
				preventionExtTransfer.setKey(entry.getKey());
				preventionExtTransfer.setValue(entry.getValue());
				preventionExtsToSend.add(preventionExtTransfer);
			}
		}

		if (preventionsToSend.size() > 0) service.setCachedDemographicPreventions(preventionsToSend, preventionExtsToSend);
	}

	@SuppressWarnings("unchecked")
	private void pushDemographicNotes(Facility facility, DemographicWs service, Integer demographicId) {
		logger.debug("pushing demographicNotes facilityId:" + facility.getId() + ", demographicId:" + demographicId);
		// Only notes from the COMMUNITY_ISSUE_CODETYPE group will be sent
		String issueType = OscarProperties.getInstance().getProperty("COMMUNITY_ISSUE_CODETYPE");
		if (issueType == null || issueType.equalsIgnoreCase("")) {
			logger.info("No Community Issue Code Type specified, community notes will not be shared.");
			return;
		}
		// need to get all issue IDs for notes on COMMUNITY ISSUES
		List<CaseManagementNote> localNotes = (List<CaseManagementNote>) caseManagementNoteDAO.getNotesByDemographic(demographicId.toString());
		ArrayList<NoteTransfer> notes = new ArrayList<NoteTransfer>();
		for (CaseManagementNote localNote : localNotes) {
			// don't upload locked notes
			logger.debug("Checking note " + localNote.getId());
			if (localNote.isLocked()) {
				logger.debug("Note " + localNote.getId() + " is locked, skipping");
				continue;
			}
			// filter out notes from a programs attached to different facilities
			try {
				Integer.parseInt(localNote.getProgram_no());
			} catch(NumberFormatException e) {
				Log.debug("Note " + localNote.getId() + " has no programNo, skipping");
			}
			Program noteProgram = programDao.getProgram(Integer.parseInt(localNote.getProgram_no()));
			if (noteProgram.getFacilityId() != facility.getId()) {
				logger.debug("Note " + localNote.getId() + " is attached to Program " + localNote.getProgram_no() + " from " + noteProgram.getFacilityId() + ", NOT " + facility.getId() + ", skipping");
				continue;
			}
			Set issues = localNote.getIssues();
			List<String> communityIssueCodes = new ArrayList<String>();
			Iterator<CaseManagementIssue> iter = issues.iterator();
			while (iter.hasNext()) {
				Issue issue = (iter.next()).getIssue();
				if (issue.getType().equalsIgnoreCase(issueType))
				;
				{
					communityIssueCodes.add(issue.getCode());
				}
			}

			// if there are community issue codes attached to this note, add it to the transfer list
			if (!communityIssueCodes.isEmpty()) {
				NoteTransfer transfer = new NoteTransfer();
				transfer.setFacilityId(facility.getId());
				transfer.setNoteId(localNote.getId().intValue());
				transfer.setProgramId(Integer.parseInt(localNote.getProgram_no()));
				transfer.setDemographicId(Integer.parseInt(localNote.getDemographic_no()));
				transfer.setObservationCaisiProviderId(localNote.getProviderNo());
				transfer.setSigningCaisiProviderId(localNote.getSigning_provider_no());
				transfer.setEncounterType(localNote.getEncounter_type());
				transfer.setNote(localNote.getNote());
				transfer.setUpdateDate(localNote.getUpdate_date());
				transfer.setObservationDate(localNote.getObservation_date());
				// transfer.setIssueCodes(communityIssueCodes.toArray(new String[communityIssueCodes.size()]));
				transfer.setRole(localNote.getRoleName());
				StringBuffer buff = new StringBuffer();
				for (String code : communityIssueCodes) {
					buff.append(code);
					buff.append("||");
				}
				transfer.setIssueCodes(buff.substring(0, buff.length() - 2));
				notes.add(transfer);
			}
		}
		// NoteTransfer[] notesToSend = (NoteTransfer[])notes.toArray();
		service.setCachedDemographicNotes(notes);
	}

	private void pushDemographicDrugs(Facility facility, List<String> providerIdsInFacility, DemographicWs demogrpahicService, Integer demographicId) throws IllegalAccessException, InvocationTargetException, DatatypeConfigurationException,
	        ShutdownException {
		logger.debug("pushing demographicDrugss facilityId:" + facility.getId() + ", demographicId:" + demographicId);

		List<Drug> drugs = drugDao.findByDemographicIdOrderByDate(demographicId, null);
		ArrayList<CachedDemographicDrug> drugsToSend = new ArrayList<CachedDemographicDrug>();
		if (drugs != null) {
			for (Drug drug : drugs) {
				MiscUtils.checkShutdownSignaled();

				if (!providerIdsInFacility.contains(drug.getProviderNo())) continue;

				CachedDemographicDrug cachedDemographicDrug = new CachedDemographicDrug();

				cachedDemographicDrug.setArchived(drug.isArchived());
				cachedDemographicDrug.setAtc(drug.getAtc());
				cachedDemographicDrug.setBrandName(drug.getBrandName());
				cachedDemographicDrug.setCaisiDemographicId(drug.getDemographicId());
				cachedDemographicDrug.setCaisiProviderId(drug.getProviderNo());
				cachedDemographicDrug.setCreateDate(drug.getCreateDate());
				cachedDemographicDrug.setCustomInstructions(drug.isCustomInstructions());
				cachedDemographicDrug.setCustomName(drug.getCustomName());
				cachedDemographicDrug.setDosage(drug.getDosage());
				cachedDemographicDrug.setDrugForm(drug.getDrugForm());
				cachedDemographicDrug.setDuration(drug.getDuration());
				cachedDemographicDrug.setDurUnit(drug.getDurUnit());
				cachedDemographicDrug.setEndDate(drug.getEndDate());
				FacilityIdIntegerCompositePk pk = new FacilityIdIntegerCompositePk();
				pk.setCaisiItemId(drug.getId());
				cachedDemographicDrug.setFacilityIdIntegerCompositePk(pk);
				cachedDemographicDrug.setFreqCode(drug.getFreqCode());
				cachedDemographicDrug.setGenericName(drug.getGenericName());
				cachedDemographicDrug.setLastRefillDate(drug.getLastRefillDate());
				cachedDemographicDrug.setLongTerm(drug.getLongTerm());
				cachedDemographicDrug.setMethod(drug.getMethod());
				cachedDemographicDrug.setNoSubs(drug.isNoSubs());
				cachedDemographicDrug.setPastMed(drug.getPastMed());
				cachedDemographicDrug.setPatientCompliance(drug.getPatientCompliance());
				cachedDemographicDrug.setPrn(drug.isPrn());
				cachedDemographicDrug.setQuantity(drug.getQuantity());
				cachedDemographicDrug.setRegionalIdentifier(drug.getRegionalIdentifier());
				cachedDemographicDrug.setRepeats(drug.getRepeat());
				cachedDemographicDrug.setRoute(drug.getRoute());
				cachedDemographicDrug.setRxDate(drug.getRxDate());
				cachedDemographicDrug.setScriptNo(drug.getScriptNo());
				cachedDemographicDrug.setSpecial(drug.getSpecial());
				cachedDemographicDrug.setTakeMax(drug.getTakeMax());
				cachedDemographicDrug.setTakeMin(drug.getTakeMin());
				cachedDemographicDrug.setUnit(drug.getUnit());
				cachedDemographicDrug.setUnitName(drug.getUnitName());

				drugsToSend.add(cachedDemographicDrug);
			}
		}

		if (drugsToSend.size() > 0) demogrpahicService.setCachedDemographicDrugs(drugsToSend);
	}

}
