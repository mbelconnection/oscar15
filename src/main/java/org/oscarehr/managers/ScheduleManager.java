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

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.common.dao.AppointmentTypeDao;
import org.oscarehr.common.dao.LookupListItemDao;
import org.oscarehr.common.dao.OscarAppointmentDao;
import org.oscarehr.common.dao.RoomDao;
import org.oscarehr.common.dao.ScheduleDateDao;
import org.oscarehr.common.dao.ScheduleHolidayDao;
import org.oscarehr.common.dao.ScheduleTemplateCodeDao;
import org.oscarehr.common.dao.ScheduleTemplateDao;
import org.oscarehr.common.model.Appointment;
import org.oscarehr.common.model.AppointmentStatus;
import org.oscarehr.common.model.AppointmentType;
import org.oscarehr.common.model.Provider;
import org.oscarehr.common.model.ScheduleDate;
import org.oscarehr.common.model.ScheduleHoliday;
import org.oscarehr.common.model.ScheduleTemplate;
import org.oscarehr.common.model.ScheduleTemplateCode;
import org.oscarehr.common.model.ScheduleTemplatePrimaryKey;
import org.oscarehr.common.model.Security;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.bo.AppointmentBO;
import org.oscarehr.ws.rest.bo.ProviderBO;
import org.oscarehr.ws.rest.bo.ScheduleBO;
import org.oscarehr.ws.rest.conversion.ProviderConverter;
import org.oscarehr.ws.rest.exception.AppointmentException;
import org.oscarehr.ws.rest.exception.ScheduleException;
import org.oscarehr.ws.rest.to.model.EventsTo1;
import org.oscarehr.ws.rest.to.model.ProviderAndEventSearchResults;
import org.oscarehr.ws.rest.to.model.ProviderTo1;
import org.oscarehr.ws.rest.to.model.ProvidersTo1;
import org.oscarehr.ws.rest.util.ErrorCodes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import oscar.log.LogAction;
import oscar.util.DateUtils;


@SuppressWarnings("deprecation")
@Service
public class ScheduleManager {

	private static Logger logger=MiscUtils.getLogger();
	
	@Autowired
	private OscarAppointmentDao oscarAppointmentDao;

	@Autowired
	private ScheduleHolidayDao scheduleHolidayDao;

	@Autowired
	private ScheduleDateDao scheduleDateDao;

	@Autowired
	private ScheduleTemplateDao scheduleTemplateDao;

	@Autowired
	private ScheduleTemplateCodeDao scheduleTemplateCodeDao;

	@Autowired
	private AppointmentTypeDao appointmentTypeDao;
	
	@Autowired
	private ProviderDao providerDao;
	
	@Autowired
	private LookupListItemDao reasonDao;
	
	@Autowired
	private DemographicManager demoManager;
	
	@Autowired
	private RoomDao roomDao;

	/*Right now the date object passed is converted to a local time.  
	*
	* As in, if the server's timezone is set to EST and the method is called with two data objects set to
	*
	* 2011-11-11 2:01 TZ america/new york
	* 2011-11-10 23:01 TZ america/los angeles
	* 
	* They will both return the DayWorkSchedule for November 11 2011;
	* 
	* The DayWorkSchedule returned will be in the server's local timezone.
	*
	*/
	public DayWorkSchedule getDayWorkSchedule(String providerNo, Calendar date) {
		// algorithm
		//----------
		// select entries from scheduledate for the given day/provider where status = 'A' (for active?)
		// "hour" setting is the template to apply, i.e. template name
		// select entry from scheduletemplate to get the template to apply for the given day
		// timecode is a breakdown of the day into equal slots, where _ means nothing and some letter means a code in scheduletemplatecode
		// The only way to know the duration of the time code is to divide it up, i.e. minutes_per_day/timecode.length, i.e. 1440 minutes per second / 96 length = 15 minutes per slot.
		// For each time slot, then look up the scheduletemplatecode

		
		DayWorkSchedule dayWorkSchedule = new DayWorkSchedule();

		ScheduleHoliday scheduleHoliday = scheduleHolidayDao.find(date.getTime());
		dayWorkSchedule.setHoliday(scheduleHoliday != null);

		ScheduleDate scheduleDate = scheduleDateDao.findByProviderNoAndDate(providerNo, date.getTime());
		if (scheduleDate==null)
		{
			logger.debug("No scheduledate for date requested. providerNo="+providerNo+", date="+date.getTime());
			return(null);
		}
		String scheduleTemplateName = scheduleDate.getHour();

		// okay this is a mess, the ScheduleTemplate is messed up because no one links there via a PK, they only link there via the name column
		// and the name column isn't unique... so... we will have to do a search for the right template.
		// first we'll check under the providersId, if not we'll check under the public id.
		ScheduleTemplatePrimaryKey scheduleTemplatePrimaryKey = new ScheduleTemplatePrimaryKey(providerNo, scheduleTemplateName);
		ScheduleTemplate scheduleTemplate = scheduleTemplateDao.find(scheduleTemplatePrimaryKey);
		if (scheduleTemplate == null) {
			scheduleTemplatePrimaryKey = new ScheduleTemplatePrimaryKey(ScheduleTemplatePrimaryKey.DODGY_FAKE_PROVIDER_NO_USED_TO_HOLD_PUBLIC_TEMPLATES, scheduleTemplateName);
			scheduleTemplate = scheduleTemplateDao.find(scheduleTemplatePrimaryKey);
		}

		//  if it's still null, then ignore it as there's no schedule for the day.
		if (scheduleTemplate != null) {
			// time interval
			String timecode=scheduleTemplate.getTimecode();
			int timeSlotDuration=(60 * 24) / timecode.length();
			dayWorkSchedule.setTimeSlotDurationMin(timeSlotDuration);
			
			// sort out designated timeslots and their purpose
			Calendar timeSlot=(Calendar) date.clone();
			
			//make sure the appts returned are in local time. 
			timeSlot.setTimeZone(Calendar.getInstance().getTimeZone());
			DateUtils.zeroTimeFields(timeSlot);
			TreeMap<Calendar, Character> allTimeSlots=dayWorkSchedule.getTimeSlots();
			
			for (int i=0; i<timecode.length(); i++)
			{
				// ignore _ because that's a blank place holder identifier... also not my fault, just processing what's been already written.
				if ('_'!=timecode.charAt(i))
				{
					allTimeSlots.put((Calendar) timeSlot.clone(), timecode.charAt(i));
				}
				
				timeSlot.add(GregorianCalendar.MINUTE, timeSlotDuration);
			}
		}

		// This method will not log access as the schedule is not private medical data.
		return (dayWorkSchedule);
	}

	public List<Appointment> getDayAppointments(String providerNo, Date date) {
		List<Appointment> appointments = oscarAppointmentDao.findByProviderAndDayandNotStatus(providerNo, date, AppointmentStatus.APPOINTMENT_STATUS_CANCELLED);

		//--- log action ---
		LogAction.addLogSynchronous("AppointmentManager.getDayAppointments", "appointments for providerNo=" + providerNo + ", appointments for date=" + date);

		return (appointments);
	}
	
	public List<Appointment> getDayAppointments(String providerNo, Calendar date) {
		return getDayAppointments(providerNo,date.getTime());
	}
	
	public List<ScheduleTemplateCode> getScheduleTemplateCodes()
	{
		List<ScheduleTemplateCode> scheduleTemplateCodes=scheduleTemplateCodeDao.getAll();
		
		// This method will not log access as the codes are not private medical data.
		return(scheduleTemplateCodes);
	}
	
	public List<AppointmentType> getAppointmentTypes()
	{
		List<AppointmentType> appointmentTypes=appointmentTypeDao.listAll();
		
		// This method will not log access as the appointment types are not private medical data.
		return(appointmentTypes);
	}

	public void addAppointment(Appointment appointment) {
	    LoggedInInfo loggedInInfo=LoggedInInfo.loggedInInfo.get();
		Security security=loggedInInfo.loggedInSecurity;
	    appointment.setCreatorSecurityId(security.getSecurityNo());
	    appointment.setCreator(security.getUserName());
	    
	    oscarAppointmentDao.persist(appointment);
	    	    
		//--- log action ---
    	LogAction.addLogSynchronous("AppointmentManager.addAppointment", appointment.toString());
    }

	public List<Appointment> getAppointmentsForPatient(Integer demographicId, int startIndex, int itemsToReturn) {
		List<Appointment> results=oscarAppointmentDao.findByDemographicId(demographicId, startIndex, itemsToReturn);
		
		//--- log action ---
		LogAction.addLogSynchronous("AppointmentManager.getAppointmentsForPatient", "appointments for demographicId=" + demographicId + ", startIndex=" + startIndex + ", itemsToReturn=" + itemsToReturn);

		return(results);
    }

	public Appointment getAppointment(Integer appointmentId) {
		Appointment result=oscarAppointmentDao.find(appointmentId);
		
		//--- log action ---
		if (result!=null)
		{
			LogAction.addLogSynchronous("AppointmentManager.getAppointment", "appointmentId=" + appointmentId);
		}
		
		return(result);
    }

	public void updateAppointment(Appointment appointment) {
		//--- log action ---
		LogAction.addLogSynchronous("AppointmentManager.updateAppointment", "appointmentId=" + appointment.getId());
	    
		// generate archive object
		oscarAppointmentDao.archiveAppointment(appointment.getId());
		
		// save new changes
		oscarAppointmentDao.merge(appointment);
    }
	
	/**
	 * Returns providers and events list.
	 * 
	 * @return						providers and events list
	 * @throws ScheduleException	when error occurs
	 */
	public ProviderAndEventSearchResults getProviderAndEvents(String apptDay) throws ScheduleException {
		logger.debug("ScheduleService.getProviderAndEvents() starts");
		List<Provider> providers = null;
		List<ProvidersTo1> providersTo1 = null;
		List<EventsTo1> events = null;
		List<Appointment> appointments = null;
		ProviderAndEventSearchResults rstLst = new ProviderAndEventSearchResults();
		List <EventsTo1> totalEvents = new java.util.ArrayList<EventsTo1>();
		try {
			appointments = oscarAppointmentDao.getAppointmentsByAppointmentDate(apptDay);
			logger.debug("ScheduleManager.getProviderAndEvents()"+appointments);
			if (null == appointments || appointments.isEmpty()) {
				Calendar cal = Calendar.getInstance();
				cal.set(Calendar.HOUR, 0);
				cal.set(Calendar.MINUTE, 0);
				cal.set(Calendar.SECOND, 0);
				cal.set(Calendar.MILLISECOND, 0);
				//if (org.oscarehr.ws.rest.util.DateUtils.formatDate(apptDay).compareTo(cal.getTime()) < 0) {
					//throw new ScheduleException(ErrorCodes.SCH_ERROR_002);
				//} else {
					List<Provider> providerLst = providerDao.getProviders();
					if (null != providerLst && !providerLst.isEmpty()) {
						providersTo1 = ProviderBO.copyProviders(providerLst, providersTo1,scheduleDateDao,scheduleTemplateDao,apptDay);
						rstLst = ScheduleBO.setProvidersAndEvents(providersTo1, events, apptDay);
						return rstLst;
					}
				}
			//}
			events = AppointmentBO.copyEvents(appointments, events,reasonDao,providerDao,roomDao);
			
			Map<String,EventsTo1> eventMap = new HashMap<String,EventsTo1>();
			for (Iterator k = events.iterator(); k.hasNext();) {
	            EventsTo1 event = (EventsTo1) k.next();
	            
	           if(eventMap.get(event.getMultiApptId())!=null){
	        	   EventsTo1 event1 = eventMap.get(event.getMultiApptId());
	        	   String patientId = event1.getPatientId()+","+event.getPatientId();
	        	   event1.setPatientId(patientId);
	        	   String appointment = event1.getApptId()+","+event.getApptId();
	        	   event1.setApptId(appointment);
	        	   
	        	   eventMap.put(event.getMultiApptId(),event1);
	        	   
	           }else{
	            eventMap.put(event.getMultiApptId(),event);
	           }
            }
			
			 totalEvents = new java.util.ArrayList<EventsTo1>(eventMap.values());
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_002);
		}
		try {
			//Object []provider = ProviderBO.getUniqueProviders(events);
			
			//ScheduleDateDao scheduleDao,ScheduleTemplateDao scheduleTempDao,String sDate
			
			providers = providerDao.getProviders();
			providersTo1 = ProviderBO.copyProviders(providers, providersTo1,scheduleDateDao,scheduleTemplateDao,apptDay);
			if (null == providersTo1 || providersTo1.isEmpty()) {
				throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
			}
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
		}
		
		rstLst = ScheduleBO.setProvidersAndEvents(providersTo1, totalEvents, apptDay);
		logger.debug("ScheduleService.getProviderAndEvents() ends");
		return rstLst;
	}
	
	/**
	 * Returns providers and events list.
	 * 
	 * @return						providers and events list
	 * @throws ScheduleException	when error occurs
	 */
	public ProviderAndEventSearchResults getSingleProviderAndEvents(String apptDay, String providerNo) throws ScheduleException {
		logger.debug("ScheduleService.getProviderAndEvents() starts");
		List<Provider> providers = null;
		List<ProvidersTo1> providersTo1 = null;
		List<EventsTo1> events = null;
		List<Appointment> appointments = null;
		ProviderAndEventSearchResults rstLst = new ProviderAndEventSearchResults();
		String[] providerNoList = new String[1];
		try {
			appointments = oscarAppointmentDao.getAppointmentsByAppointmentDate(apptDay, providerNo);
			logger.debug("ScheduleManager.getProviderAndEvents()"+appointments);
			if (null == appointments || appointments.isEmpty()) {
				Calendar cal = Calendar.getInstance();
				cal.set(Calendar.HOUR, 0);
				cal.set(Calendar.MINUTE, 0);
				cal.set(Calendar.SECOND, 0);
				cal.set(Calendar.MILLISECOND, 0);
				providerNoList[0]=providerNo;
					List<Provider> providerLst = providerDao.getProviders(providerNoList);
					if (null != providerLst && !providerLst.isEmpty()) {
						providersTo1 = ProviderBO.copyProviders(providerLst, providersTo1);
						rstLst = ScheduleBO.setProvidersAndEvents(providersTo1, events, apptDay);
						return rstLst;
					}
				}
			//}
			events = AppointmentBO.copyEvents(appointments, events,providerDao,reasonDao);
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_002);
		}
		try {
			//Object []provider = ProviderBO.getUniqueProviders(events);
			providerNoList[0]=providerNo;
			providers = providerDao.getProviders(providerNoList);
			providersTo1 = ProviderBO.copyProviders(providers, providersTo1);
			if (null == providersTo1 || providersTo1.isEmpty()) {
				throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
			}
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
		}
		
		rstLst = ScheduleBO.setProvidersAndEvents(providersTo1, events, apptDay);
		logger.debug("ScheduleService.getProviderAndEvents() ends");
		return rstLst;
	}
	
	public ProviderAndEventSearchResults getGroupDayEvents(String apptDay, String group) throws ScheduleException {
		logger.debug("ScheduleService.getProviderAndEvents() starts");
		List<Provider> providers = null;
		List<ProvidersTo1> providersTo1 = null;
		List<EventsTo1> events = null;
		List<Appointment> appointments = null;
		ProviderAndEventSearchResults rstLst = new ProviderAndEventSearchResults();
		try {
			appointments = oscarAppointmentDao.getGroupDayEvents(group, apptDay);			
			events = AppointmentBO.copyEvents(appointments, events);
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_002);
		}
		try {
			//Object []provider = ProviderBO.getUniqueProviders(events);
			providers = providerDao.getGroupProviders(group);
			providersTo1 = ProviderBO.copyProviders(providers, providersTo1);
			if (null == providersTo1 || providersTo1.isEmpty()) {
				throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
			}
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
		}
		
		rstLst = ScheduleBO.setProvidersAndEvents(providersTo1, events, apptDay);
		logger.debug("ScheduleService.getProviderAndEvents() ends");
		return rstLst;
	}
	
	public ProviderAndEventSearchResults getGroupWeekEvents(String stdate, String enddate, String group) throws ScheduleException {
		logger.debug("ScheduleService.getProviderAndEvents() starts");
		List<Provider> providers = null;
		List<ProvidersTo1> providersTo1 = null;
		List<EventsTo1> events = null;
		List<Appointment> appointments = null;
		ProviderAndEventSearchResults rstLst = new ProviderAndEventSearchResults();
		try {
			appointments = oscarAppointmentDao.getGroupWeekEvents(stdate, enddate, group);			
			events = AppointmentBO.copyEvents(appointments, events);
			providers = providerDao.getGroupProviders(group);
			providersTo1 = ProviderBO.copyProviders(providers, providersTo1);
			if (null == providersTo1 || providersTo1.isEmpty()) {
				throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
			}
			rstLst = ScheduleBO.setProvidersAndEventsForWeek(stdate, enddate, providersTo1, events);
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
		}
		
		//rstLst = ScheduleBO.setProvidersAndEvents(providersTo1, events, stdate);
		logger.debug("ScheduleService.getProviderAndEvents() ends");
		return rstLst;
	}
	
	public ProviderAndEventSearchResults getGroupMonthEvents(String day, String group) throws ScheduleException {
		logger.debug("ScheduleService.getGroupMonthEvents() starts");
		List<Provider> providers = null;
		List<ProvidersTo1> providersTo1 = null;
		List<EventsTo1> events = null;
		List<Appointment> appointments = null;
		ProviderAndEventSearchResults rstLst = new ProviderAndEventSearchResults();
		
		try {
			appointments = oscarAppointmentDao.getGroupMonthEvents(day, group);			
			events = AppointmentBO.copyEvents(appointments, events);
			providers = providerDao.getGroupProviders(group);
			providersTo1 = ProviderBO.copyProviders(providers, providersTo1);
			if (null == providersTo1 || providersTo1.isEmpty()) {
				throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
			}
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
		}
		
		rstLst = ScheduleBO.setProvidersAndEvents(providersTo1, events, day);
		logger.debug("ScheduleService.getGroupMonthEvents() ends");
		return rstLst;
	}
	
	/**
	 * Returns events list.
	 * 
	 * @return						events list
	 * @throws ScheduleException	when error occurs
	 */
	public List<Appointment> getEventsForWeek(String startDay, String endDay, String provider) throws ScheduleException {
		logger.debug("ScheduleService.getEventsForWeek() starts");
		List<Appointment> appointments = null;
		try {
			if(null != provider && (Integer.parseInt(provider)>0 )){
				appointments = oscarAppointmentDao.getAppointmentsForWeek(startDay, endDay, provider);
				//appointments = oscarAppointmentDao.getAppointmentsForWeekTotal(startDay, endDay);
				
			}else{
				appointments = oscarAppointmentDao.getAppointmentsForWeekTotal(startDay, endDay);
				//appointments = oscarAppointmentDao.getAppointmentsForWeek(startDay, endDay, "103");
			}
			
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getEventsForWeek()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_002);
		}
		logger.debug("ScheduleService.getEventsForWeek() ends");
		logger.debug("ScheduleManager.getEventsForWeek()"+appointments);
		return appointments;
	}
	
	
	/**
	 * Returns events list.
	 * 
	 * @return						events list
	 * @throws ScheduleException	when error occurs
	 */
	public List<EventsTo1> convertEventsForWeek(List<Appointment> appointments) throws ScheduleException {
		logger.debug("ScheduleService.getEventsForWeek() starts");
		List<EventsTo1> events = null;
		try {
			events = AppointmentBO.copyEvents(appointments, null,providerDao,reasonDao);
			
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getEventsForWeek()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_002);
		}
		logger.debug("ScheduleService.getEventsForWeek() ends");
		logger.debug("ScheduleManager.getEventsForWeek()"+events);
		return events;
	}
	
	
	public ProviderAndEventSearchResults getSelectedProviderAndEvents(List<ProviderTo1> providerIds,String apptDate) throws ScheduleException {
		logger.debug("ScheduleService.getProviderAndEvents() starts");
		List<Provider> providers = null;
		List<String> provsList = new ArrayList<String>();
		List<ProvidersTo1> providersTo1 = null;
		List<EventsTo1> events = null;
		List<Appointment> appointments = null;
		ProviderAndEventSearchResults rstLst = new ProviderAndEventSearchResults();
		List <EventsTo1> totalEvents = new java.util.ArrayList<EventsTo1>();
		String provider="";
		try {
			
			if(apptDate== null){
				try {
		            apptDate = org.oscarehr.ws.rest.util.DateUtils.convertDateToString(new Date());
	            } catch (ParseException e) {
		            // TODO Auto-generated catch block
	            	logger.error("Error in ScheduleService.getSelectedProviderAndEvents()", e);
	            }
			}
			
			
			
			for (Iterator<ProviderTo1> j = providerIds.iterator(); j.hasNext();) {
	            ProviderTo1 prov1 = (ProviderTo1) j.next();
	            
	            if(prov1.isEnabled()){
	            	provsList.add(prov1.getProviderNo());
	            	if(!"".equals(provider)){
	            		provider = provider+","+prov1.getProviderNo();
	            	}else {
	            		provider = prov1.getProviderNo();
	            	}
	            }
	            
            }
			String [] provsArray = new String[provsList.size()];
			for(int j =0;j<provsList.size();j++){
				provsArray[j] = provsList.get(j);
				}
			
			appointments = oscarAppointmentDao.getByProvidersAndDay(org.oscarehr.ws.rest.util.DateUtils.formatDate(apptDate), provsArray);
			logger.debug("ScheduleManager.getProviderAndEvents()"+appointments);
			if (null == appointments || appointments.isEmpty()) {
				Calendar cal = Calendar.getInstance();
				cal.set(Calendar.HOUR, 0);
				cal.set(Calendar.MINUTE, 0);
				cal.set(Calendar.SECOND, 0);
				cal.set(Calendar.MILLISECOND, 0);
				//if (org.oscarehr.ws.rest.util.DateUtils.formatDate(apptDay).compareTo(cal.getTime()) < 0) {
					//throw new ScheduleException(ErrorCodes.SCH_ERROR_002);
				//} else {
					List<Provider> providerLst = providerDao.getProvidersByIds(provider);
					if (null != providerLst && !providerLst.isEmpty()) {
						providersTo1 = ProviderBO.copyProviders(providerLst, providersTo1,scheduleDateDao,scheduleTemplateDao,apptDate);
						rstLst = ScheduleBO.setProvidersAndEvents(providersTo1, events, apptDate);
						return rstLst;
					}
				}
			//}
			events = AppointmentBO.copyEvents(appointments, events,reasonDao,providerDao,roomDao);
			
			Map<String,EventsTo1> eventMap = new HashMap<String,EventsTo1>();
			for (Iterator k = events.iterator(); k.hasNext();) {
	            EventsTo1 event = (EventsTo1) k.next();
	            
	           if(eventMap.get(event.getProgramId())!=null){
	        	   EventsTo1 event1 = eventMap.get(event.getProgramId());
	        	   String patientId = event1.getPatientId()+","+event.getPatientId();
	        	   event1.setPatientId(patientId);
	        	   String appointment = event1.getApptId()+","+event.getApptId();
	        	   event1.setApptId(appointment);
	        	   
	        	   eventMap.put(event.getProgramId(),event1);
	        	   
	           }else{
	            eventMap.put(event.getProgramId(),event);
	           }
            }
			
			 totalEvents = new java.util.ArrayList<EventsTo1>(eventMap.values());
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_002);
		}
		try {
			
			List<Provider> providerLst = providerDao.getProvidersByIds(provider);
			providersTo1 = ProviderBO.copyProviders(providerLst, providersTo1,scheduleDateDao,scheduleTemplateDao,apptDate);
			if (null == providersTo1 || providersTo1.isEmpty()) {
				throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
			}
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
		}
		
		
	        rstLst = ScheduleBO.setProvidersAndEvents(providersTo1, totalEvents, apptDate);
        
		logger.debug("ScheduleService.getProviderAndEvents() ends");
		return rstLst;
	}

	public ProviderAndEventSearchResults getTeamProviderAndEvents(String groupName,String appDate) throws ScheduleException{
		ProviderAndEventSearchResults rstLst = new ProviderAndEventSearchResults();
		
		try {
	        Map<String,List<ProviderTo1>> totList = demoManager.getGroupProviderDetails(groupName);
	        List<ProviderTo1> activeList = totList.get("active");
	        rstLst = getSelectedProviderAndEvents(activeList,appDate);
        } catch (AppointmentException e) {
        	logger.error("Error in ScheduleService.getTeamProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
        } catch (ScheduleException e) {
        	logger.error("Error in ScheduleService.getTeamProviderAndEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
        }
		
		return rstLst;
	}
	
	public ProviderAndEventSearchResults getTeamProviderHavingEvents(String groupName,String appDate) throws ScheduleException{
		ProviderAndEventSearchResults rstLst = new ProviderAndEventSearchResults();
		List<String> provsList = new ArrayList<String>();
		try {
	        Map<String,List<ProviderTo1>> totList = demoManager.getGroupProviderDetails(groupName);
	        List<ProviderTo1> activeList = totList.get("active");
	        String provider="";
	        List<ProviderTo1> converterActiveProvider = new ArrayList<ProviderTo1>();
	        ProviderTo1 providerTo = new ProviderTo1();
			ProviderConverter converter = new ProviderConverter();
			String [] provsArray = new String[activeList.size()];
			int k=0;
	        for (Iterator<ProviderTo1> j = activeList.iterator(); j.hasNext();) {
	            ProviderTo1 prov1 = (ProviderTo1) j.next();           
	            	if(!"".equals(provider)){
	            		provider = provider+","+prov1.getProviderNo();
	            	}else {
	            		provider = prov1.getProviderNo();
	            	}
	            	provsArray[k] =  prov1.getProviderNo();
	            	k++;
            }
	        
	        List<Provider> providerList = oscarAppointmentDao.getProvidersByAppointments(provsArray,org.oscarehr.ws.rest.util.DateUtils.formatDate(appDate));
	        
	        for (Iterator i = providerList.iterator(); i.hasNext();) {
	            Provider provider1 = (Provider) i.next();
	            providerTo = new ProviderTo1();
	            providerTo = converter.getAsTransferObject(provider1); 
	           	converterActiveProvider.add(providerTo);   
            }
	        
	        rstLst = getSelectedProviderAndEvents(converterActiveProvider,appDate);
        } catch (AppointmentException e) {
        	logger.error("Error in ScheduleService.getTeamProviderHavingEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
        } catch (ScheduleException e) {
        	logger.error("Error in ScheduleService.getTeamProviderHavingEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
        } catch (ParseException e) {
        	logger.error("Error in ScheduleService.getTeamProviderHavingEvents()", e);
			throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
        }
		
		return rstLst;
	}


}
