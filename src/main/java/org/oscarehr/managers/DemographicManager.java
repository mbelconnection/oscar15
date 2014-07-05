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

package org.oscarehr.managers;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.common.Gender;
import org.oscarehr.common.dao.DemographicArchiveDao;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.DemographicExtDao;
import org.oscarehr.common.dao.DemographicMergedDao;
import org.oscarehr.common.dao.MyGroupDao;
import org.oscarehr.common.dao.PHRVerificationDao;
import org.oscarehr.common.dao.ScheduleTemplateCodeDao;
import org.oscarehr.common.model.Appointment;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.Demographic.PatientStatus;
import org.oscarehr.common.model.DemographicExt;
import org.oscarehr.common.model.DemographicMerged;
import org.oscarehr.common.model.PHRVerification;
import org.oscarehr.common.model.Provider;
import org.oscarehr.common.model.ScheduleTemplateCode;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.bo.AppointmentBO;
import org.oscarehr.ws.rest.conversion.DemographicConverter;
import org.oscarehr.ws.rest.conversion.ProviderConverter;
import org.oscarehr.ws.rest.exception.AppointmentException;
import org.oscarehr.ws.rest.exception.PatientException;
import org.oscarehr.ws.rest.to.model.AppointmentTo;
import org.oscarehr.ws.rest.to.model.AppointmentTo1;
import org.oscarehr.ws.rest.to.model.DemographicTo1;
import org.oscarehr.ws.rest.to.model.ProviderTo1;
import org.oscarehr.ws.rest.to.model.ScheduleTemplateCodeTo;
import org.oscarehr.ws.rest.util.ErrorCodes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import oscar.log.LogAction;
import oscar.util.ConversionUtils;

/**
 * Will provide access to demographic data, as well as closely related data such as 
 * extensions (DemographicExt), merge data, archive data, etc.
 * 
 * Future Use: Add privacy, security, and consent profiles
 * 
 *
 */
@Service
public class DemographicManager {
	public static final String PHR_VERIFICATION_LEVEL_3 = "+3";
	public static final String PHR_VERIFICATION_LEVEL_2 = "+2";
	public static final String PHR_VERIFICATION_LEVEL_1 = "+1";

	private static Logger logger=MiscUtils.getLogger();
	
	@Autowired
	private DemographicDao demographicDao;
	@Autowired
	private DemographicExtDao demographicExtDao;
	
	@Autowired
	private DemographicArchiveDao demographicArchiveDao;

	@Autowired
	private DemographicMergedDao demographicMergedDao;

	@Autowired
	private PHRVerificationDao phrVerificationDao;
	
	@Autowired
	private MyGroupDao myGroupDao;
	
	@Autowired
	private ProviderDao providerDao;
	
	@Autowired
	private ScheduleTemplateCodeDao tempCodeDao;

	public Demographic getDemographic(Integer demographicId) {
		Demographic result = demographicDao.getDemographicById(demographicId);

		//--- log action ---
		if (result != null) {
			LogAction.addLogSynchronous("DemographicManager.getDemographic", "demographicId=" + demographicId);
		}

		return (result);
	}
	
	public Demographic getDemographicByMyOscarUserName(String myOscarUserName) {
		Demographic result = demographicDao.getDemographicByMyOscarUserName(myOscarUserName);

		//--- log action ---
		if (result != null) {
			LogAction.addLogSynchronous("DemographicManager.getDemographic", "demographicId=" + result.getDemographicNo());
		}

		return (result);
	}

	public List<Demographic> searchDemographicByName(String searchString, int startIndex, int itemsToReturn) {
		
		List<Demographic> results = demographicDao.searchDemographicByNameString(searchString, startIndex, itemsToReturn);
		
		if(logger.isDebugEnabled()) {
			logger.debug("searchDemographicByName, searchString="+searchString+", result.size="+results.size());
		}
		
		//--- log action ---
		for (Demographic demographic : results) {
			LogAction.addLogSynchronous("DemographicManager.searchDemographicByName result", "demographicId=" + demographic.getDemographicNo());
		}

		return (results);
	}
	
	/*
	 * Format is LastName[,FirstName]
	 */
	public List<Demographic> searchDemographicByNames(String searchString, int startIndex, int itemsToReturn) {
		
		List<Demographic> results = demographicDao.searchDemographicByNamesString(searchString, startIndex, itemsToReturn);
		
		if(logger.isDebugEnabled()) {
			logger.debug("searchDemographicByName, searchString="+searchString+", result.size="+results.size());
		}
		
		//--- log action ---
		for (Demographic demographic : results) {
			LogAction.addLogSynchronous("DemographicManager.searchDemographicByName result", "demographicId=" + demographic.getDemographicNo());
		}

		return (results);
	}
	
	/**
	 * Format is addr:term
	 * 
	 * @param searchString
	 * @param startIndex
	 * @param itemsToReturn
	 * @return
	 */
	public List<Demographic> searchDemographicByAddress(String searchString, int startIndex, int itemsToReturn) {
		
		List<Demographic> results = demographicDao.searchDemographicByAddressString(searchString, startIndex, itemsToReturn);
		
		if(logger.isDebugEnabled()) {
			logger.debug("searchDemographicByAddress, searchString="+searchString+", result.size="+results.size());
		}
		
		//--- log action ---
		for (Demographic demographic : results) {
			LogAction.addLogSynchronous("DemographicManager.searchDemographicByAddress result", "demographicId=" + demographic.getDemographicNo());
		}

		return (results);
	}
	
	/**
	 * Format is chartNo:term
	 * 
	 * @param searchString
	 * @param startIndex
	 * @param itemsToReturn
	 * @return
	 */
	public List<Demographic> searchDemographicByChartNo(String searchString, int startIndex, int itemsToReturn) {
		
		List<Demographic> results = demographicDao.searchDemographicByChartNo(searchString, startIndex, itemsToReturn);
		
		if(logger.isDebugEnabled()) {
			logger.debug("searchDemographicByChartNo, searchString="+searchString+", result.size="+results.size());
		}
		
		//--- log action ---
		for (Demographic demographic : results) {
			LogAction.addLogSynchronous("DemographicManager.searchDemographicByChartNo result", "demographicId=" + demographic.getDemographicNo());
		}

		return (results);
	}
	
	public List<DemographicExt> getDemographicExts(Integer id) {
		
		List<DemographicExt> result = null;
		
		result = demographicExtDao.getDemographicExtByDemographicNo(id);
		
		//--- log action ---
		if (result != null) {
			for(DemographicExt item:result) {
				LogAction.addLogSynchronous("DemographicManager.getDemographicExts", "id="+item.getId() + "(" + id.toString() +")");
			}
		}

		return result;
	}

	public List<Demographic> getDemographicsByProvider(Provider provider) {
		List<Demographic> result = demographicDao.getDemographicByProvider(provider.getProviderNo(), true);
		
		//--- log action ---
		if (result != null) {
			for (Demographic demographic : result) {
				LogAction.addLogSynchronous("DemographicManager.getDemographicsByProvider result", "demographicId=" + demographic.getDemographicNo());
			}
		}
		
		return result;
	}

	public void createDemographic(Demographic demographic) {
		try {
			demographic.getBirthDay();
		} catch (Exception e) {
			throw new IllegalArgumentException("Birth date was specified for " + demographic.getFullName() 
					+ ": " + demographic.getBirthDayAsString());
		}
		
		demographic.setPatientStatus(PatientStatus.AC.name());
		demographicDao.save(demographic);

		if (demographic.getExtras() != null) {
			for(DemographicExt ext : demographic.getExtras()) {
				createExtension(ext);
			}
		}
		
		//--- log action ---
		LogAction.addLogSynchronous("DemographicManager.createDemographic", "new id is =" + demographic.getDemographicNo());
		
	}
	
	public void updateDemographic(Demographic demographic) {
		try {
			demographic.getBirthDay();
		} catch (Exception e) {
			throw new IllegalArgumentException("Birth date was specified for " + demographic.getFullName() 
					+ ": " + demographic.getBirthDayAsString());
		}
		
		demographicDao.save(demographic);
		
		// TODO What needs to be done with extras - delete first, then save?!?, or build another service? 
		if (demographic.getExtras() != null) {
			for(DemographicExt ext : demographic.getExtras()) {
				LogAction.addLogSynchronous("DemographicManager.updateDemographic ext", "id=" + ext.getId() + "(" +  ext.toString() + ")");
				updateExtension(ext);
			}
		}
		
		//--- log action ---
		LogAction.addLogSynchronous("DemographicManager.updateDemographic", "demographicNo=" + demographic.getDemographicNo());
				
	}

	public void createExtension(DemographicExt ext) {
		demographicExtDao.saveEntity(ext);
		
		//--- log action ---
		LogAction.addLogSynchronous("DemographicManager.createExtension", "id=" + ext.getId());
	}
	
	public void updateExtension(DemographicExt ext) {
		demographicExtDao.saveEntity(ext);
		
		//--- log action ---
		LogAction.addLogSynchronous("DemographicManager.updateExtension", "id=" + ext.getId());
	}

	public void deleteDemographic(Demographic demographic) {
		demographicArchiveDao.archiveRecord(demographic);
		demographic.setPatientStatus(Demographic.PatientStatus.DE.name());
		demographicDao.save(demographic);
		
		for(DemographicExt ext : getDemographicExts(demographic.getDemographicNo())) {
			LogAction.addLogSynchronous("DemographicManager.deleteDemographic ext", "id=" + ext.getId() + "(" + ext.toString() +")");
			deleteExtension(ext);
		}
		
		//--- log action ---
		LogAction.addLogSynchronous("DemographicManager.deleteDemographic", "demographicNo=" + demographic.getDemographicNo());
	}

	public void deleteExtension(DemographicExt ext) {
		demographicExtDao.removeDemographicExt(ext.getId());
		
		//--- log action ---
		LogAction.addLogSynchronous("DemographicManager.removeDemographicExt", "id=" + ext.getId());
	}

	public void mergeDemographics(Integer parentId, List<Integer> children) {
		for (Integer child : children) {
			DemographicMerged dm = new DemographicMerged();
			dm.setDemographicNo(child);
			dm.setMergedTo(parentId);
			demographicMergedDao.persist(dm);
			
			//--- log action ---
			LogAction.addLogSynchronous("DemographicManager.mergeDemographics", "id=" + dm.getId());
		}
		
	}

	public void unmergeDemographics(Integer parentId, List<Integer> children) {
		for (Integer childId : children) {
			List<DemographicMerged> dms = demographicMergedDao.findByParentAndChildIds(parentId, childId);
			if (dms.isEmpty()) {
				throw new IllegalArgumentException("Unable to find merge record for parent " + parentId + " and child " + childId);
			}
			for(DemographicMerged dm : demographicMergedDao.findByParentAndChildIds(parentId, childId)) {
				dm.setDeleted(1);
				demographicMergedDao.merge(dm);
				
				//--- log action ---
				LogAction.addLogSynchronous("DemographicManager.unmergeDemographics", "id=" + dm.getId());
			}
		}
	}



	public Long getActiveDemographicCount() {
		Long count =  demographicDao.getActiveDemographicCount();
		
		//--- log action ---
		LogAction.addLogSynchronous("DemographicManager.getActiveDemographicCount", "");
		
		return count;
	}
	
	public List<Demographic> getActiveDemographics(int offset, int limit) {
	    List<Demographic>  result = demographicDao.getActiveDemographics(offset, limit);
	    
	    if(result != null) {
	    	for(Demographic d:result) {
		    	//--- log action ---
				LogAction.addLogSynchronous("DemographicManager.getActiveDemographics result", "demographicNo="+d.getDemographicNo());
	    	}
	    }
	    
	    return result;
    }

	/**
	 * Gets all merged demographic for the specified parent record ID 
	 * 
	 * @param parentId
	 * 		ID of the parent demographic record 
	 * @return
	 * 		Returns all merged demographic records for the specified parent id.
	 */
	public List<DemographicMerged> getMergedDemographics(Integer parentId) {
	    List<DemographicMerged> result = demographicMergedDao.findCurrentByMergedTo(parentId);
	    
	    if(result != null) {
	    	for(DemographicMerged d:result) {
		    	//--- log action ---
				LogAction.addLogSynchronous("DemographicManager.getMergedDemogrpaphics result", "demographicNo="+d.getDemographicNo());
	    	}
	    	
	    }
	    
	    return result;
    }

	
	public PHRVerification getLatestPhrVerificationByDemographicId(Integer demographicId)
	{
		PHRVerification result=phrVerificationDao.findLatestByDemographicId(demographicId);

		//--- log action ---
		if (result != null) {
			LogAction.addLogSynchronous("DemographicManager.getLatestPhrVerificationByDemographicId", "demographicId=" + demographicId);
		}
		
		return(result);
	}
	
	public String getPhrVerificationLevelByDemographicId(Integer demographicId)
	{
		PHRVerification phrVerification=getLatestPhrVerificationByDemographicId(demographicId);
		
        if (phrVerification!=null){
        	String authLevel =phrVerification.getVerificationLevel();
        	if ( PHRVerification.VERIFICATION_METHOD_FAX.equals(authLevel) || PHRVerification.VERIFICATION_METHOD_MAIL.equals(authLevel)  || PHRVerification.VERIFICATION_METHOD_EMAIL.equals(authLevel)){
        		return PHR_VERIFICATION_LEVEL_1;
        	}else if (PHRVerification.VERIFICATION_METHOD_TEL.equals(authLevel) || PHRVerification.VERIFICATION_METHOD_VIDEOPHONE.equals(authLevel)){
        		return PHR_VERIFICATION_LEVEL_2;
        	}else if (PHRVerification.VERIFICATION_METHOD_INPERSON.equals(authLevel)){
        		return PHR_VERIFICATION_LEVEL_3;
        	}
        }
        
        // blank string because preserving existing behaviour moved from PHRVerificationDao, I would have preferred returnning null on a new method...
        return("");
	}
	
	/**
	 * This method should only return true if the demographic passed in is "phr verified" to a sufficient level to allow a provider to send this phr account messages.
	 */
	public boolean isPhrVerifiedToSendMessages(Integer demographicId)
	{
		String level=getPhrVerificationLevelByDemographicId(demographicId);
		// hard coded to 3 until some one tells me how to configure/check this
		if (PHR_VERIFICATION_LEVEL_3.equals(level)) return(true);
		else return(false);
	}

	/**
	 * This method should only return true if the demographic passed in is "phr verified" to a sufficient level to allow a provider to send this phr account medicalData.
	 */
	public boolean isPhrVerifiedToSendMedicalData(Integer demographicId)
	{
		String level=getPhrVerificationLevelByDemographicId(demographicId);
		// hard coded to 3 until some one tells me how to configure/check this
		if (PHR_VERIFICATION_LEVEL_3.equals(level)) return(true);
		else return(false);		
	}

	/**
	 * @deprecated there should be a generic call for getDemographicExt(Integer demoId, String key) instead. Then the caller should assemble what it needs from the demographic and ext call itself.
	 */
	public String getDemographicWorkPhoneAndExtension(Integer demographicNo)
	{
		Demographic result=demographicDao.getDemographicById(demographicNo);
		String workPhone = result.getPhone2();
		if(workPhone != null && workPhone.length()>0) {
			String value = demographicExtDao.getValueForDemoKey(demographicNo, "wPhoneExt");
			if(value != null && value.length()>0) {
				workPhone += "x" + value;
			}
		}
		
		//--- log action ---
		if (result!=null)
		{
			LogAction.addLogSynchronous("DemographicManager.getDemographicWorkPhoneAndExtension", "demographicId="+result.getDemographicNo() + "result=" + workPhone);
		}
		
		return(workPhone);
	}
	
	/**
	 * @see DemographicDao.findByAttributes for parameter details
	 */
	public List<Demographic> searchDemographicsByAttributes(String hin, String firstName, String lastName, Gender gender, Calendar dateOfBirth, String city, String province, String phone, String email, String alias, int startIndex, int itemsToReturn) {
		List<Demographic> results=demographicDao.findByAttributes(hin, firstName, lastName, gender, dateOfBirth, city, province, phone, email, alias, startIndex, itemsToReturn);

		// log all items read
		for(Demographic d : results) {
	    	LogAction.addLogSynchronous("DemographicManager.searchDemographicsByAttributes result", "demographicNo="+d.getDemographicNo());
    	}
		
		return(results);
	}
	
	public List<Demographic> getActiveDemographisFirstNameSearch() throws PatientException {
		logger.debug("DemographicManager.getActiveDemographisFirstNameSearch() starts");
		List<Demographic> demographics = null;
		try {
			demographics = demographicDao.getActiveDemographisFirstNameSearch();
		} catch (Exception e) {
			logger.error("Error in DemographicManager.getActiveDemographisFirstNameSearch()", e);
			throw new PatientException(ErrorCodes.PAT_ERROR_001);
		}
		logger.debug("DemographicManager.getActiveDemographisFirstNameSearch() ends");
		return demographics;
	}
	
	/*public List<Demographic> getActiveDemographisLastNameSearch() throws PatientException {
		logger.debug("DemographicManager.getActiveDemographisLastNameSearch() starts");
		List<Demographic> demographics = null;
		try {
			demographics = demographicDao.getActiveDemographisFirstNameSearch();
		} catch (Exception e) {
			logger.error("Error in DemographicManager.getActiveDemographisLastNameSearch()", e);
			throw new PatientException(ErrorCodes.PAT_ERROR_001);
		}
		logger.debug("DemographicManager.getActiveDemographisLastNameSearch() ends");
		return demographics;
	}*/
	
	/**
	 * Returns details of patient
	 * 
	 * @param                   demogrphicNo		
	 * @return					DemographicTo1
	 * @throws AppointmentException 
	 */
	
	public DemographicTo1 getPatientDetails(String demographic_no) throws PatientException {
		logger.debug("DemographicManager.getPatientDetails() starts");
		DemographicTo1 demoTo = null;
		DemographicConverter converter = new DemographicConverter();
		try {
			Demographic demo = demographicDao.getDemographic(demographic_no);
		
			demoTo = converter.getAsTransferObject(demo);
		} catch (Exception e) {
			logger.error("Error in DemographicManager.getPatientDetails()", e);
			throw new PatientException(ErrorCodes.APPT_ERROR_005);
		}
		logger.debug("DemographicManager.getPatientDetails() ends");
		return demoTo;
	}
	
	
	/**
	 * Returns details of patient
	 * 
	 * @param                   demogrphicNo		
	 * @return					DemographicTo1
	 * @throws AppointmentException 
	 */
	
	public Set fetchPatientsHistory(String demographic_no) throws PatientException {
		logger.debug("DemographicManager.getPatientDetails() starts");
		Set<AppointmentTo1> archivedClients = new java.util.LinkedHashSet<AppointmentTo1>();
		AppointmentTo demoTo = null;
		DemographicConverter converter = new DemographicConverter();
		try {
			Set<Appointment> archivedClients1 = demographicDao.fetchPreviousAppointments(Integer.parseInt(demographic_no));
		
			archivedClients = converter.getAsTransferSetObject(archivedClients1);
		} catch (Exception e) {
			logger.error("Error in DemographicManager.getPatientDetails()", e);
			throw new PatientException(ErrorCodes.APPT_ERROR_005);
		}
		logger.debug("DemographicManager.getPatientDetails() ends");
		return archivedClients;
	}
	
	
	/**
	 * returns boolean after successful update
	 * 
	 * @param providerNo		the provider number
	 * @return					void
	 * @throws AppointmentException 
	 */
	
	public Set<AppointmentTo1> nextAvalibleAppt(AppointmentTo apptTo) throws AppointmentException {
		logger.debug("AppointmentManager.nextAvalibleAppt() starts");
		Set<AppointmentTo1> archivedClients = new java.util.LinkedHashSet<AppointmentTo1>();
		DemographicConverter converter = new DemographicConverter();
		try {
			String provId = apptTo.getProvId();
			if(provId.lastIndexOf(",")>0){
				provId = provId.substring(0, provId.lastIndexOf(","));
			}
			
			int weekDay = -1;
			if(apptTo.getDayOfWeek()!=null && "".equals(apptTo.getDayOfWeek())){	
				weekDay = Integer.parseInt(apptTo.getDayOfWeek());
			}
			Set<Appointment> archivedClients1 = demographicDao.fetchNextAvali(provId,apptTo.getApptDuration(),apptTo.getApptType(),weekDay,apptTo.getStartTime(),apptTo.getEndTime(),Integer.parseInt(apptTo.getResultCount()));
			archivedClients = converter.getAsTransferSetObject(archivedClients1);
		} catch (Exception e) {
			logger.error("Error in AppointmentManager.nextAvalibleAppt()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		logger.debug("AppointmentManager.nextAvalibleAppt() ends");
		return archivedClients;
	}
	
	
	/**
	 * returns boolean after successful update
	 * 
	 * @param providerNo		the provider number
	 * @return					void
	 * @throws AppointmentException 
	 */
	
	public Map<String,List<ProviderTo1>> getGroupProviderDetails(String groupName) throws AppointmentException {
		logger.debug("demographicManager.nextAvalibleAppt() starts");
		
		List<ProviderTo1> converterActiveProvider = new ArrayList<ProviderTo1>();
		List<ProviderTo1> converterInActiveProvider = new ArrayList<ProviderTo1>();
		Map <String,List<ProviderTo1>> hm = new HashMap<String,List<ProviderTo1>>();
		ProviderTo1 providerTo = new ProviderTo1();
		ProviderConverter converter = new ProviderConverter();
		try {
			List<Provider> archivedClients1 = myGroupDao.search_groupprovider(groupName);
			for (Iterator<Provider> i = archivedClients1.iterator(); i.hasNext();) {
	            Provider provider = (Provider) i.next();
	            providerTo = new ProviderTo1();
	            providerTo = converter.getAsTransferObject(provider);
	            
	            if(!providerTo.isEnabled()){
	            	converterInActiveProvider.add(providerTo);
	            }else if(providerTo.isEnabled()){
	            	converterActiveProvider.add(providerTo);
	            }
            }
			
			hm.put("active", converterActiveProvider);
			hm.put("inActive", converterInActiveProvider);
			
		} catch (Exception e) {
			logger.error("Error in demographicManager.nextAvalibleAppt()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		logger.debug("demographicManager.nextAvalibleAppt() ends");
		return hm;
	}
	
	
	public boolean saveProviderDetails(List<ProviderTo1> providerList) throws AppointmentException {
		logger.debug("demographicManager.saveProviderDetails() starts");
		
		boolean result = false;
		Provider provider = new Provider();
		ProviderConverter converter = new ProviderConverter();
		String providerIds = "";
		try {
			
			for (Iterator iterator = providerList.iterator(); iterator.hasNext();) {
	            ProviderTo1 providerTo1 = (ProviderTo1) iterator.next();
	            if(!"".equals(providerIds)){
	            providerIds = providerIds+","+providerTo1.getProviderNo();
	            }else{
	            	providerIds = providerTo1.getProviderNo();
	            }
            }
			
			List<Provider> providerList1 = providerDao.getProvidersByIds(providerIds);
			
			for (Iterator i = providerList.iterator(); i.hasNext();) {
	            ProviderTo1 providerTo1 = (ProviderTo1) i.next();

	            for (Iterator iterator = providerList1.iterator(); iterator.hasNext();) {
	                Provider provider2 = (Provider) iterator.next();
	                
	                if(providerTo1.getProviderNo().equals(provider2.getProviderNo())){
	                	provider2.setStatus(ConversionUtils.toBoolString(providerTo1.isEnabled()));
	                	 providerDao.updateProvider(provider2);
	                	 break;
	                }
                }

	           
	            result = true;
            }
			
		} catch (Exception e) {
			logger.error("Error in demographicManager.saveProviderDetails()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		logger.debug("demographicManager.saveProviderDetails() ends");
		return result;
	}
	
	
	public List<ScheduleTemplateCodeTo> fetchScheduleTempCode(){
		
		List<ScheduleTemplateCodeTo> scheduleTempList = new ArrayList<ScheduleTemplateCodeTo>();
		
		List<ScheduleTemplateCode> tempCodeList = tempCodeDao.findAll();
		
		scheduleTempList = AppointmentBO.getAsTransferSetObject(tempCodeList);
		
		
		return scheduleTempList;
		
	}


}
