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

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.common.dao.ApptRecurrenceDao;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.LookupListDao;
import org.oscarehr.common.dao.MyGroupDao;
import org.oscarehr.common.dao.OscarAppointmentDao;
import org.oscarehr.common.dao.RoomDao;
import org.oscarehr.common.dao.ScheduleDateDao;
import org.oscarehr.common.dao.ScheduleTemplateDao;
import org.oscarehr.common.model.Appointment;
import org.oscarehr.common.model.AppointmentArchive;
import org.oscarehr.common.model.AppointmentStatus;
import org.oscarehr.common.model.AppointmentType;
import org.oscarehr.common.model.ApptRecurrence;
import org.oscarehr.common.model.LookupList;
import org.oscarehr.common.model.LookupListItem;
import org.oscarehr.common.model.Provider;
import org.oscarehr.common.model.Room;
import org.oscarehr.common.model.ScheduleDate;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.bo.AppointmentBO;
import org.oscarehr.ws.rest.conversion.DemographicConverter;
import org.oscarehr.ws.rest.exception.AppointmentException;
import org.oscarehr.ws.rest.to.model.AppointmentStatusTo;
import org.oscarehr.ws.rest.to.model.AppointmentTo;
import org.oscarehr.ws.rest.to.model.AppointmentTo1;
import org.oscarehr.ws.rest.to.model.AppointmentTypeTo;
import org.oscarehr.ws.rest.to.model.PatientSearchResults;
import org.oscarehr.ws.rest.to.model.RoomTo;
import org.oscarehr.ws.rest.util.DateUtils;
import org.oscarehr.ws.rest.util.ErrorCodes;
import org.oscarehr.ws.rest.util.KeyToValueMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import oscar.log.LogAction;

@Service
public class AppointmentManager {
	
	private static Logger log = MiscUtils.getLogger();

	@Autowired
	private OscarAppointmentDao appointmentDao;
	
	@Autowired
	private ProviderDao providerDao;
	
	@Autowired
	private LookupListDao lookupListDao;
	
	@Autowired
	private DemographicDao demographicDao;
	
	@Autowired
	private ScheduleDateDao scheduleDao;
	
	@Autowired
	private ScheduleTemplateDao scheduleTempDao;
	
	@Autowired
	private MyGroupDao mygroupDao;
	
	@Autowired
	private ApptRecurrenceDao apptRecurrenceDao;
	
	@Autowired
	private RoomDao roomDao;
	
	
	public List<Appointment> getAppointmentHistoryAfter(Integer demographicNo, Date startDateInclusive, Integer offset, Integer limit) {
		StringBuilder ids = new StringBuilder();
		
		List<Appointment> result = appointmentDao.getAppointmentHistoryAfter(demographicNo,startDateInclusive, offset, limit);
		
		
		//--- log action ---
		if (result.size()>0) {
		
			LogAction.addLogSynchronous("AppointmentManager.getAppointmentHistoryAfter", "ids returned=" + ids);
		}
		return result;
	}
	
	public List<Object> getAppointmentHistoryWithoutDeleted(Integer demographicNo, Integer offset, Integer limit) {
		List<Object> result = new ArrayList<Object>();
		StringBuilder ids = new StringBuilder();
		
		List<Appointment> nonDeleted = appointmentDao.getAppointmentHistory(demographicNo, offset, limit);
		for(Appointment tmp:nonDeleted) {
			ids.append(tmp.getId() + ",");
		}
		result.addAll(nonDeleted);
		
		
		//--- log action ---
		if (result.size()>0) {
		
			LogAction.addLogSynchronous("AppointmentManager.getAppointmentHistoryWithDeleted", "ids returned=" + ids);
		}
		return result;
	}
	
	public List<Object> getAppointmentHistoryWithDeleted(Integer demographicNo, Integer offset, Integer limit) {
		List<Object> result = new ArrayList<Object>();
		StringBuilder ids = new StringBuilder();
		
		List<Appointment> nonDeleted = appointmentDao.getAppointmentHistory(demographicNo, offset, limit);
		for(Appointment tmp:nonDeleted) {
			ids.append(tmp.getId() + ",");
		}
		result.addAll(nonDeleted);
		
		List<AppointmentArchive> deleted =  appointmentDao.getDeletedAppointmentHistory(demographicNo, offset, limit);
		
		
		for(AppointmentArchive aa:deleted) {
			if(!hasAppointmentNo(result,aa.getAppointmentNo()) && !aaIsAlreadyInList(result,aa)) {
				result.add(aa);
				ids.append(aa.getId() + ",");
			}
		}
		
		//--- log action ---
		if (result.size()>0) {
		
			LogAction.addLogSynchronous("AppointmentManager.getAppointmentHistoryWithDeleted", "ids returned=" + ids);
		}
		return result;
	}
	
	private boolean hasAppointmentNo(List<Object> appts, Integer appointmentNo) {
		for(Object o:appts) {
			if(o instanceof Appointment) {
				Appointment appt = (Appointment)o;
				if(appt.getId().equals(appointmentNo))
					return true;
			}
		}
		return false;
	}
	
	private boolean aaIsAlreadyInList(List<Object> appts, AppointmentArchive aa) {
		for(Object o:appts) {
			if(o instanceof AppointmentArchive) {
				AppointmentArchive appt = (AppointmentArchive)o;
				if(appt.getAppointmentNo().equals(aa.getAppointmentNo()))
					return true;
			}
		}
		return false;
	}
	
	/**
	 * Returns appointment for display.
	 * 
	
	 * @param appointmentTo				appointment data
	 * @return							appointment data
	 * @throws AppointmentException		in cases of error
	 */
	public AppointmentTo saveAppointment(AppointmentTo appointmentTo, String user) throws AppointmentException {
		log.debug("AppointmentManager.saveApppointment() stsaveUpdatedAppointmentarts");
		AppointmentTo apptTo = null;
		Appointment appt = null;
		HashMap<String,Integer> recMap = null;
		try {
			int recFrequency=0;
				AppointmentBO.validate(appointmentTo);
				Calendar startDateCal = Calendar.getInstance();
				
				String [] proList = appointmentTo.getProvId().split(",");;
				String [] demoList = appointmentTo.getPatientId().split(",");
				String [] patientName = appointmentTo.getPatientName().split("\\^");
				
					ApptRecurrence apptRec=null;
				if(("D".equals(appointmentTo.getFrequency())) || ("W".equals(appointmentTo.getFrequency())) || ("M".equals(appointmentTo.getFrequency())) || ("Y".equals(appointmentTo.getFrequency()))){
					Date startDate = DateUtils.formatDate(appointmentTo.getStartDate());
					Date endDate = DateUtils.formatDate(appointmentTo.getEndDate());
					startDateCal.setTime(DateUtils.formatDate(appointmentTo.getStartDate()));
					long diffInMilis = endDate.getTime() - startDate.getTime();
					long monthTime = 2592000000L;
					long yearTime = 31536000000L;
					if(appointmentTo.getRecurrenceId()==null || "".equals(appointmentTo.getRecurrenceId())){
						recMap = new HashMap<String,Integer>();
						
						
						for (int i = 0; i < proList.length; i++){ 
				            for (int j = 0; j < demoList.length; j++) {
				            	apptRec = new ApptRecurrence();
				            	apptRec = AppointmentBO.convertToRecObject(appointmentTo);
				            	ApptRecurrence apptRec1 = apptRecurrenceDao.saveAppointmentRec(apptRec);
								//appointmentTo.setRecurrenceId(String.valueOf(apptRec1.getId()));
				            	recMap.put(proList[i]+"~"+demoList[j], apptRec1.getId());
				            }
						}
						
					}
					
					if("D".equals(appointmentTo.getFrequency())){
						recFrequency = (int) (diffInMilis/(24 * 60 * 60 * 1000));
					}else if("W".equals(appointmentTo.getFrequency())){
						recFrequency = (int) (diffInMilis/(7*24 * 60 * 60 * 1000));
					}else if("M".equals(appointmentTo.getFrequency())){
						recFrequency =(int) (diffInMilis/monthTime);	
					}else if("Y".equals(appointmentTo.getFrequency())){
						recFrequency = (int) (diffInMilis/yearTime);
					}
				}else{
					recFrequency=0;
					appointmentTo.setRecurrenceId("0");
				}
				
				String formMultiPatientId = appointmentTo.getMultiApptId();
				for(int k=0;k<=recFrequency;k++){
					if(k>0){
						if("D".equals(appointmentTo.getFrequency())){
							startDateCal.add(Calendar.DATE, 1);
						}else if("W".equals(appointmentTo.getFrequency())){
							startDateCal.add(Calendar.DATE, 7);
						}else if("M".equals(appointmentTo.getFrequency())){
							startDateCal.add(Calendar.MONTH, 1);	
						}else if("Y".equals(appointmentTo.getFrequency())){
							startDateCal.add(Calendar.YEAR, 1);
						}
						appointmentTo.setApptStartDate(DateUtils.convertDateToString(startDateCal.getTime()));
						
					}
					
						int multiApptId = demographicDao.getMaxMultiApptId();
					
					
					for (int i = 0; i < proList.length; i++) {
						
							multiApptId = multiApptId+1;
						
			            for (int j = 0; j < demoList.length; j++) {
			            	
			            	appointmentTo.setProvId(proList[i]);
			            	appointmentTo.setPatientId(demoList[j]);
			            	appointmentTo.setPatientName(patientName[j]);
			            	if(formMultiPatientId == null ||"".equals(formMultiPatientId)){
			            		appointmentTo.setMultiApptId(String.valueOf(multiApptId));
			            	}
			            	if(!"0".equals(appointmentTo.getRecurrenceId())){
			            		if(recMap!=null){
			            			appointmentTo.setRecurrenceId(String.valueOf(recMap.get(proList[i]+"~"+demoList[j])));
			            		}
			            	}
			            	Appointment appointment = AppointmentBO.createAppointmentCriteria(appointmentTo, user);
			            	appt = appointmentDao.saveAppointment(appointment);
		                }
			            
		            }
				}
			apptTo = AppointmentBO.setAppointmentData(appt);
		} catch (Exception e) {
			log.error("Error in AppointmentManager.saveApppointment()", e);
			if (e instanceof AppointmentException) {
				throw new AppointmentException(((AppointmentException)e).getBean().getMessage(), e);
			}
			throw new AppointmentException(ErrorCodes.APPT_ERROR_001);
		}
		log.debug("AppointmentManager.saveApppointment() ends");
		return apptTo;
	}
	
	/**
	 * Returns appointment types.
	 * 
	 * @throws AppointmentException	when error occurs
	 */
	public List<AppointmentTypeTo> getAppointmentType() throws AppointmentException {
		log.debug("AppointmentManager.getAppointmentType() starts");
		List<AppointmentTypeTo> apptTypeTo = null;
		try {
			List<AppointmentType> apptType = appointmentDao.getAppointmentType();
			if (null == apptType || apptType.isEmpty()) {
				throw new AppointmentException(ErrorCodes.APPT_ERROR_002);
			}
			apptTypeTo = AppointmentBO.copyAppointmentTypes(apptType, apptTypeTo);
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getAppointmentType()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_002);
		}
		log.debug("AppointmentManager.getAppointmentType() ends");
		return apptTypeTo;
	}
	
	/**
	 * Returns appointment status.
	 * 
	 * @throws AppointmentException	when error occurs
	 */
	public List<AppointmentStatusTo> getAppointmentStatus() throws AppointmentException {
		log.debug("AppointmentManager.getAppointmentStatus() starts");
		List<AppointmentStatusTo> apptStatusTo = null;
		try {
			List<AppointmentStatus> apptStatus = appointmentDao.getAppointmentStatus();
			if (null == apptStatus || apptStatus.isEmpty()) {
				throw new AppointmentException(ErrorCodes.APPT_ERROR_003);
			}
			apptStatusTo = AppointmentBO.copyAppointmentStatus(apptStatus, apptStatusTo);
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getAppointmentStatus()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_003);
		}
		log.debug("AppointmentManager.getAppointmentStatus() ends");
		return apptStatusTo;
	}
	
	/**
	 * delete appointment.
	 * 
	 * @throws AppointmentException	when error occurs
	 */
	public void deleteAppointment(int apptNo) throws AppointmentException {
		log.debug("AppointmentManager.deleteAppointment() starts");
		try {
			appointmentDao.deleteAppointment(apptNo);
		} catch (Exception e) {
			log.error("Error in AppointmentManager.deleteAppointment()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_004);
		}
		log.debug("AppointmentManager.deleteAppointment() ends");
	}
	
	/**
	 * Returns reason codes.
	 * 
	 * @return				list of return codes
	 * @throws exception
	 */
	public List<LookupListItem> getAppointmentReason() throws AppointmentException {
		log.debug("AppointmentManager.getAppointmentReason() starts");
		List<LookupListItem> itemsLst = null;
		try {
			LookupList list = lookupListDao.findByName("reasonCode");
			itemsLst = list.getItems();
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getAppointmentReason()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		log.debug("AppointmentManager.getAppointmentReason() ends");
		return itemsLst;
	}
	
	/**
	 * Void method
	 * 
	 * @param providerNo		the provider number
	 * @return					void
	 * @throws AppointmentException 
	 */
	
	public void saveUpdatedAppointment(AppointmentTo appointmentTo,String user) throws AppointmentException {
		log.debug("AppointmentManager.saveUpdatedAppointment() starts");
		try {
			Appointment appointment = AppointmentBO.createAppointmentCriteria(appointmentTo, user);
			appointment.setId(Integer.parseInt(appointmentTo.getId()));
			
				
					appointmentDao.editAppointment(appointment);
				
				
				if((appointmentTo.getNewPatients()!=null) && (!"".equals(appointmentTo.getNewPatients()))){
					appointmentTo.setPatientId(appointmentTo.getNewPatients());
					appointmentTo.setPatientName(appointmentTo.getNewPatNames());
					saveAppointment(appointmentTo, user);
				}
		
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getSelectedAppointment()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		log.debug("AppointmentManager.saveUpdatedAppointment() ends");

	}
	
	/**
	 * Returns list of appointment details for a provider
	 * 
	 * @param providerNo		the provider number
	 * @return					appointment list
	 * @throws AppointmentException 
	 */
	
	public AppointmentTo getSelectedAppointment(String appointmentNo) throws AppointmentException {
		log.debug("AppointmentManager.getSelectedAppointment() starts");
		AppointmentTo apptTo = null;
		try {
		List <Appointment> result = appointmentDao.getSelectedAppointment(Integer.parseInt(appointmentNo));
		
		apptTo = AppointmentBO.setSelectedAppointment(result);
		String providerName = providerDao.getProviderName(apptTo.getProvId());
		apptTo.setProviderName(providerName);
		if(null == apptTo.getRecurrenceId())
			apptTo.setRecurrenceId("0");
		
			if(!"0".equals(apptTo.getRecurrenceId())){
				ApptRecurrence apptRec = apptRecurrenceDao.fetchAppointmentRec(Integer.parseInt(apptTo.getRecurrenceId()));
				apptTo.setFrequency(apptRec.getFrequency());
				apptTo.setStartDate(DateUtils.convertDateToString(apptRec.getStartDate()));
				apptTo.setEndDate(DateUtils.convertDateToString(apptRec.getEndDate()));
			}
		String maxPatientId = demographicDao.getCountMaxMultiApptId(Integer.parseInt(apptTo.getMultiApptId()));
		apptTo.setNoOfPatient(maxPatientId);
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getSelectedAppointment()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		log.debug("AppointmentManager.getSelectedAppointment() ends");
		return apptTo;
	}

	public PatientSearchResults getExistAppointments(String demographicNo) {
		PatientSearchResults searchResults =null;
		List<Appointment> result = null;
	try {
		result = appointmentDao.getExistAppointments(Integer.parseInt(demographicNo));
	//	searchResults.setDemoGraphhics(demoGraphhics);
		//searchResults.setProviders(providers);
		
	} catch (Exception e) {
		// TODO: handle exception
	}
	    return searchResults;
    }
	
	/**
	 * returns boolean after successful update
	 * 
	 * @param providerNo		the provider number
	 * @return					void
	 * @throws AppointmentException 
	 */
	
	public boolean saveUpdatedAppointmentStatus(String apptId,String apptStatus) throws AppointmentException {
		log.debug("AppointmentManager.saveUpdatedAppointment() starts");
		boolean result = false;
		try {
			
			result = appointmentDao.updateAppointmentStatus(Integer.parseInt(apptId), KeyToValueMapper.getStatusValue(apptStatus));
		
		} catch (Exception e) {
			log.error("Error in AppointmentManager.saveUpdatedAppointmentStatus()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		log.debug("AppointmentManager.saveUpdatedAppointmentStatus() ends");
		return result;
	}
	
	
	/**
	 * returns boolean after successful update
	 * 
	 * @param providerNo		the provider number
	 * @return					void
	 * @throws AppointmentException 
	 */
	
	public boolean saveUpdatedAppointmentType(String apptId,String apptType) throws AppointmentException {
		log.debug("AppointmentManager.saveUpdatedAppointment() starts");
		boolean result = false;
		try {
			
			result = appointmentDao.updateAppointmentType(Integer.parseInt(apptId), apptType);
		
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getSelectedAppointment()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		log.debug("AppointmentManager.saveUpdatedAppointment() ends");
		return result;
	}
	
	
	/**
	 * returns boolean after successful update
	 * 
	 * @param providerNo		the provider number
	 * @return					void
	 * @throws AppointmentException 
	 */
	
	public boolean saveUpdatedAppointmentCritical(String apptId,String critical) throws AppointmentException {
		log.debug("AppointmentManager.saveUpdatedAppointment() starts");
		boolean result = false;
		try {
			
			result = appointmentDao.updateAppointmentCriticality(Integer.parseInt(apptId), critical);
		
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getSelectedAppointment()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		log.debug("AppointmentManager.saveUpdatedAppointment() ends");
		return result;
	}
	
	/**
	 * returns boolean after successful update
	 * 
	 * @param providerNo		the provider number
	 * @return					void
	 * @throws AppointmentException 
	 */
	
	public Map<String,Set<AppointmentTo1>> fetchMonthlyData(String startDate, String endDate,String providersData) throws AppointmentException {
		log.debug("AppointmentManager.nextAvalibleAppt() starts");
		Map<String,Set<AppointmentTo1>> returnResult = new java.util.HashMap<String,Set<AppointmentTo1>>();
		DemographicConverter converter = new DemographicConverter();
		try {
			
			String[] providersData1 = providersData.split("~");
			String providerIds = "";
			
			if(providersData1[1].equals("G")){
				List<Provider> archivedClients1 = mygroupDao.search_groupprovider(String.valueOf(providersData1[0]));
				for (Iterator i = archivedClients1.iterator(); i.hasNext();) {
		            Provider provider = (Provider) i.next();
		            
		            if(!"".equals(providerIds)){
		            	providerIds = providerIds+","+provider.getProviderNo();
		            }else{
		            	providerIds = provider.getProviderNo();
		            }
	            }
			}else if(providersData1[1].equals("I")){
				providerIds = String.valueOf(providersData1[0]);
			}
			
			Set<Appointment> archivedClients1 = demographicDao.fetchMonthlyData(startDate,endDate,providerIds);
			
			returnResult = converter.getAsTransferMapMonthlyObject(archivedClients1);
		} catch (Exception e) {
			log.error("Error in AppointmentManager.nextAvalibleAppt()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		log.debug("AppointmentManager.nextAvalibleAppt() ends");
		return returnResult;
	}
	/**
	 * Returns reason codes.
	 * 
	 * @return				list of return codes
	 * @throws exception
	 */
	public List<LookupListItem> getBlockTimeReason() throws AppointmentException {
		log.debug("AppointmentManager.getAppointmentReason() starts");
		List<LookupListItem> itemsLst = null;
		try {
			LookupList list = lookupListDao.findByName("reasonBlockCode");
			itemsLst = list.getItems();
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getAppointmentReason()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		log.debug("AppointmentManager.getAppointmentReason() ends");
		return itemsLst;
	}
	
	
	/**
	 * Returns reason codes.
	 * 
	 * @return				list of return codes
	 * @throws exception
	 */
	public HashMap<String,String> getFlipDetails(String providerId,String sDate,String eDate) throws AppointmentException {
		log.debug("AppointmentManager.getFlipDetails() starts");
		List<ScheduleDate> itemsLst = null;
		HashMap<String,String> flipData = null;
		try {
			itemsLst = scheduleDao.findByProviderAndDateRange(providerId, DateUtils.formatDate(sDate),DateUtils.formatDate(eDate));
			
			flipData = AppointmentBO.setFlipData(itemsLst, scheduleTempDao);
			
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getFlipDetails()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		log.debug("AppointmentManager.getFlipDetails() ends");
		return flipData;
	}
	
	
	/**
	 * Returns reason codes.
	 * 
	 * @return				list of return codes
	 * @throws exception
	 */
	public HashMap<String,String> getFlipDayDetails(String providerIds,String sDate) throws AppointmentException {
		log.debug("AppointmentManager.getFlipDetails() starts");
		ScheduleDate itemsLst = null;
		String [] providerId = providerIds.split(",");
		HashMap<String,String> dayFlipData = new HashMap<String, String>();
		try {
			for (int i = 0; i < providerId.length; i++) {
				itemsLst = new ScheduleDate();
				itemsLst = scheduleDao.findByProviderNoAndDate(providerId[i], DateUtils.formatDate(sDate));
				String template =  scheduleTempDao.findByName(itemsLst.getHour().trim(),itemsLst.getProviderNo());	
				dayFlipData.put(providerId[i], template);
            }
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getFlipDetails()", e);
			throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
		}
		log.debug("AppointmentManager.getFlipDetails() ends");
		return dayFlipData;
	}
	
	/**
	 * Returns Room Details.
	 * 
	 * @return				list of Room Details
	 * @throws exception
	 */
	public List<RoomTo> getRoomDetails() {
		log.debug("AppointmentManager.getRoomDetails() starts");
		
		List<RoomTo> roomToList = new ArrayList<RoomTo>();
		try {
			List<Room> roomList = roomDao.getActiveRooms();
			for (Iterator i = roomList.iterator(); i.hasNext();) {
	            Room room = (Room) i.next();
	            RoomTo roomTo = AppointmentBO.convertRoomObject(room);
	            roomToList.add(roomTo);
            }
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getRoomDetails()", e);
			
		}
		log.debug("AppointmentManager.getRoomDetails() ends");
		return roomToList;
	}
	
	
	/**
	 * Returns Room Details.
	 * 
	 * @return				list of Room Details
	 * @throws exception
	 */
	public Map<String,Integer> checkAppointmentDetails(String providerId,String apptDate,String startTime,String endTime) {
		log.debug("AppointmentManager.getRoomDetails() starts");
		
		Map<String,List<Appointment>> apptMap = new HashMap<String,List<Appointment>>();
		Map<String,Integer> resultMap = new HashMap<String,Integer>();
		List<Appointment> apptList = new ArrayList<Appointment>();
		try {
			SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
			String convDate =  f.format(DateUtils.formatDate(apptDate));
			List<Appointment> apptList1 = demographicDao.getByProvidersAndDayTime(convDate, providerId, startTime, endTime);
			for (Iterator i = apptList1.iterator(); i.hasNext();) {
	            Appointment appointment = (Appointment) i.next();
	           
	           
	            
	            if(apptMap.get(appointment.getProviderNo())!=null){
	            	List<Appointment> tempList =apptMap.get(appointment.getProviderNo());
	            	tempList.add(appointment);
	            	apptMap.put(appointment.getProviderNo(), tempList);
	            }else{
	            	apptList.add(appointment);
		            apptMap.put(appointment.getProviderNo(), apptList);
	            }
	            
            }
			
			String [] providers = providerId.split(",");
			for (int i = 0; i < providers.length; i++) {
	            if(apptMap.get(providers[i])!=null){
	            	resultMap.put(providers[i], 1);
	            }else{
	            	resultMap.put(providers[i], 0);
	            }
            }
			
		} catch (Exception e) {
			log.error("Error in AppointmentManager.getRoomDetails()", e);
			
		}
		log.debug("AppointmentManager.getRoomDetails() ends");
		return resultMap;
	}

}
