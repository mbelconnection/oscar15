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

package org.oscarehr.ws.rest.bo;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.common.dao.LookupListItemDao;
import org.oscarehr.common.dao.RoomDao;
import org.oscarehr.common.dao.ScheduleTemplateDao;
import org.oscarehr.common.model.Appointment;
import org.oscarehr.common.model.AppointmentStatus;
import org.oscarehr.common.model.AppointmentType;
import org.oscarehr.common.model.ApptRecurrence;
import org.oscarehr.common.model.LookupListItem;
import org.oscarehr.common.model.Room;
import org.oscarehr.common.model.ScheduleDate;
import org.oscarehr.common.model.ScheduleTemplateCode;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.exception.AppointmentException;
import org.oscarehr.ws.rest.to.model.AppointmentReasonTo;
import org.oscarehr.ws.rest.to.model.AppointmentStatusTo;
import org.oscarehr.ws.rest.to.model.AppointmentTo;
import org.oscarehr.ws.rest.to.model.AppointmentTypeTo;
import org.oscarehr.ws.rest.to.model.EventsTo1;
import org.oscarehr.ws.rest.to.model.RoomTo;
import org.oscarehr.ws.rest.to.model.ScheduleTemplateCodeTo;
import org.oscarehr.ws.rest.util.DateUtils;
import org.oscarehr.ws.rest.util.ErrorCodes;
import org.oscarehr.ws.rest.util.KeyToValueMapper;

import oscar.util.StringUtils;

public class AppointmentBO {

	
	private static Logger log = MiscUtils.getLogger();
	
	private static Map<String, String> reasonMap = new HashMap<String, String>();
	
	/**
	 * Creates appointment criteria to save data.
	 * 
	 * @param appointmentTo		data to create criteria
	 * @return					appointment criteria object
	 * @throws Exception		when any error occurs
	 */
	public static Appointment createAppointmentCriteria(AppointmentTo appointmentTo, String user) throws Exception {
		log.debug("AppointmentBO.createAppointmentCriteria() starts");
		Appointment appointment = new Appointment();
		if (StringUtils.isNullOrEmpty(appointmentTo.getPatientId())) {
			appointmentTo.setPatientId("0");
		}
		appointment.setDemographicNo(Integer.parseInt(appointmentTo.getPatientId()));
		appointment.setAppointmentDate(DateUtils.formatDate(appointmentTo.getApptStartDate()));
		appointment.setCreateDateTime(new Date());
		appointment.setCreator(user);
		appointment.setName(appointmentTo.getPatientName());
		appointment.setNotes(appointmentTo.getApptNotes());
		appointment.setProviderNo(appointmentTo.getProvId());
		appointment.setReason(appointmentTo.getApptReasonDtls());
		if (null != appointmentTo.getAppReason() && !"".equals(appointmentTo.getAppReason())) {
			appointment.setReasonCode(Integer.parseInt(appointmentTo.getAppReason()));
		}
		appointment.setResources(appointmentTo.getApptResources());
		Calendar c = Calendar.getInstance();
		c.setTime(DateUtils.formatDate(appointmentTo.getApptStartDate()));
		c.add(Calendar.HOUR, Integer.parseInt(appointmentTo.getApptTime().split("_")[0]));
		c.add(Calendar.MINUTE, Integer.parseInt(appointmentTo.getApptTime().split("_")[1]));
		appointment.setStartTime(c.getTime());
		c.add(Calendar.MINUTE, Integer.parseInt(appointmentTo.getApptDuration()));
		appointment.setEndTime(c.getTime());
		appointment.setStatus(KeyToValueMapper.getStatusValue(appointmentTo.getApptStatus()));
		appointment.setType(KeyToValueMapper.getTypeValue(appointmentTo.getGoTo()));
		appointment.setUpdateDateTime(new Date());
		appointment.setUrgency(appointmentTo.getIsCritical());
		appointment.setLocation(appointmentTo.getLocation());
		appointment.setMultiApptId(Integer.parseInt(appointmentTo.getMultiApptId()));
		if(appointmentTo.getRecurrenceId()!=null){
			appointment.setRecurrenceId(Integer.parseInt(appointmentTo.getRecurrenceId()));
		}else{
			appointment.setRecurrenceId(Integer.parseInt("0"));
		}
		appointment.setRoomId(appointmentTo.getRoomId());
		log.debug("AppointmentBO.createAppointmentCriteria() ends");
		return appointment;
	}
	
	/**
	 * Validations
	 * @param appointmentTo
	 * @throws AppointmentException
	 */
	public static void validate(AppointmentTo appointmentTo) throws AppointmentException {
		if ("".equals(appointmentTo.getProvId()) || null == appointmentTo.getProvId()) {
			throw new AppointmentException(ErrorCodes.PRV_ERROR_001);
		}
	}
	
	/**
	 * Returns appointment data for display
	 * 
	 * @param appointment		data to be displayed
	 * @return					appointment  object
	 * @throws Exception		when any error occurs
	 */
	public static AppointmentTo setAppointmentData(Appointment appointment) throws Exception {
		log.debug("AppointmentBo.setAppointmentData() starts");
		AppointmentTo appointmentTo = new AppointmentTo();
		appointmentTo.setApptStartDate(DateUtils.convertDateToString(appointment.getAppointmentDate()));
		appointmentTo.setApptEndDate(DateUtils.convertDateToString(appointment.getAppointmentDate()));
		appointmentTo.setPatientName(appointment.getName());
		appointmentTo.setApptNotes(appointment.getNotes());
		appointmentTo.setProvId(appointment.getProviderNo());
		appointmentTo.setAppReason(getReason(appointment.getReasonCode().toString()));
		appointmentTo.setApptReasonDtls(appointment.getReason());
		appointmentTo.setApptResources(appointment.getResources());
		Calendar cal = Calendar.getInstance();
		cal.setTime(appointment.getStartTime());
		String apptTime =  cal.get(Calendar.HOUR_OF_DAY) + "_" + cal.get(Calendar.MINUTE);
		appointmentTo.setApptTime(apptTime.toString());
		Calendar cal1 = Calendar.getInstance();
		cal1.setTime(appointment.getEndTime());
		long duration = ((cal1.getTime().getTime() - cal.getTime().getTime()) / 1000) / 60;
		appointmentTo.setApptDuration(String.valueOf(duration));
		appointmentTo.setApptStatus(KeyToValueMapper.getStatusValue(appointment.getStatus()));
		appointmentTo.setGoTo(KeyToValueMapper.getTypeValue(appointment.getType()));
		appointmentTo.setIsCritical(appointment.getUrgency());
		appointmentTo.setId(String.valueOf(appointment.getId()));
		appointmentTo.setPatientId(appointment.getProviderNo());
		appointmentTo.setLocation(appointment.getLocation());
		appointmentTo.setNoOfPatient("");
		log.debug("AppointmentBo.setAppointmentData() ends");
		return appointmentTo;
	}
	
	/**
	 * Returns events list.
	 * 
	 * @param scr		source data
	 * @param dest		destination data
	 * @return			events list
	 */
	public static List<EventsTo1> copyEvents(List<Appointment> src, List<EventsTo1> dest,LookupListItemDao reasonDao,ProviderDao proviDao,RoomDao roomDao) throws Exception {
		log.debug("AppointmentBo.copyEvents() starts");
		List<EventsTo1> evnLst = null;
		if (null != src && !src.isEmpty()) {
			evnLst = new ArrayList<EventsTo1>(src.size());
			Calendar cal = Calendar.getInstance();
			Calendar cal1 = Calendar.getInstance();
			for (Appointment appt : src) {
				EventsTo1 events =  new EventsTo1();
				if(appt.getDemographicNo() == 0){
					events.setAppointStatus("");				
					events.setApptType("");
				}else{
					events.setAppointStatus(KeyToValueMapper.getStatusValue(appt.getStatus()));					
					events.setApptType(KeyToValueMapper.getTypeValue(appt.getType()));
				}				
				events.setApptId(String.valueOf(appt.getId()));
				events.setDocId(appt.getProviderNo());
				events.setProviderName(proviDao.getProviderNameLastFirst(appt.getProviderNo()));
				cal.setTime(appt.getStartTime());
				String apptTime = (cal.get(Calendar.HOUR_OF_DAY) <= 9 ? "0" + cal.get(Calendar.HOUR_OF_DAY)
							: cal.get(Calendar.HOUR_OF_DAY))  + ":"
							+(cal.get(Calendar.MINUTE) <= 9 ? "0" + cal.get(Calendar.MINUTE) : cal.get(Calendar.MINUTE));
				events.setFromTime(apptTime.toString());
				cal1.setTime(appt.getEndTime());
				long duration = ((cal1.getTime().getTime() - cal.getTime().getTime()) / 1000) / 60;
				events.setDuration(String.valueOf(duration));
				events.setGoTo(KeyToValueMapper.getTypeValue(appt.getType()));
				events.setIsCritical(appt.getUrgency());
				events.setNoOfPat("");
				events.setNotes(appt.getNotes());
				events.setPatientName(appt.getName());
				events.setProgramId(String.valueOf(appt.getProgramId()));
				events.setMultiApptId(String.valueOf(appt.getMultiApptId()));
				events.setRecurrenceId(String.valueOf(appt.getRecurrenceId()));
				events.setRoomId(appt.getRoomId());
				events.setPatientId(String.valueOf(appt.getDemographicNo()));
				//if(appt.getDemographicNo() == 0){
					LookupListItem l = reasonDao.findNameById(appt.getReasonCode());
					events.setReason(l.getValue());
				/*}else{
					events.setReason(getReason(appt.getReasonCode()!=null?appt.getReasonCode().toString():""));
				}*/
					if(appt.getRoomId()!=null && !"".equals(appt.getRoomId())){
						Room room = roomDao.getRoom(Integer.parseInt(appt.getRoomId()));
						events.setRoomId(room.getName());
					}
				events.setApptStartDate(DateUtils.convertDateToString(appt.getAppointmentDate()));
				
				evnLst.add(events);
			}
		}
		log.debug("AppointmentBo.copyEvents() ends");
		return evnLst;
	}
	
	/**
	 * Returns events list.
	 * 
	 * @param scr		source data
	 * @param dest		destination data
	 * @return			events list
	 */
	public static List<EventsTo1> copyEvents(List<Appointment> src, List<EventsTo1> dest) throws Exception {
		log.debug("AppointmentBo.copyEvents() starts");
		List<EventsTo1> evnLst = null;
		if (null != src && !src.isEmpty()) {
			evnLst = new ArrayList<EventsTo1>(src.size());
			Calendar cal = Calendar.getInstance();
			Calendar cal1 = Calendar.getInstance();
			for (Appointment appt : src) {
				EventsTo1 events =  new EventsTo1();
				if(appt.getDemographicNo() == 0){
					events.setAppointStatus("");				
					events.setApptType("");
				}else{
					events.setAppointStatus(KeyToValueMapper.getStatusValue(appt.getStatus()));					
					events.setApptType(KeyToValueMapper.getTypeValue(appt.getType()));
				}				
				events.setApptId(String.valueOf(appt.getId()));
				events.setDocId(appt.getProviderNo());
				cal.setTime(appt.getStartTime());
				String apptTime = (cal.get(Calendar.HOUR_OF_DAY) <= 9 ? "0" + cal.get(Calendar.HOUR_OF_DAY)
							: cal.get(Calendar.HOUR_OF_DAY))  + ":"
							+(cal.get(Calendar.MINUTE) <= 9 ? "0" + cal.get(Calendar.MINUTE) : cal.get(Calendar.MINUTE));
				events.setFromTime(apptTime.toString());
				cal1.setTime(appt.getEndTime());
				long duration = ((cal1.getTime().getTime() - cal.getTime().getTime()) / 1000) / 60;
				events.setDuration(String.valueOf(duration));
				events.setGoTo(KeyToValueMapper.getTypeValue(appt.getType()));
				events.setIsCritical(appt.getUrgency());
				events.setNoOfPat("");
				events.setNotes(appt.getNotes());
				events.setPatientName(appt.getName());
				//events.s;
				
				//if(appt.getDemographicNo() == 0){
					//LookupListItem l = reasonDao.findNameById(appt.getReasonCode());
					//events.setReason(l.getValue());
				///}else{
					events.setReason(getReason(appt.getReasonCode()!=null?appt.getReasonCode().toString():""));
				//}
				events.setApptStartDate(DateUtils.convertDateToString(appt.getAppointmentDate()));
				evnLst.add(events);
			}
		}
		log.debug("AppointmentBo.copyEvents() ends");
		return evnLst;
	}
	
	
	/**
	 * Returns events list.
	 * 
	 * @param scr		source data
	 * @param dest		destination data
	 * @return			events list
	 */
	public static List<EventsTo1> copyEvents(List<Appointment> src, List<EventsTo1> dest,ProviderDao proviDao,LookupListItemDao reasonDao) throws Exception {
		log.debug("AppointmentBo.copyEvents() starts");
		List<EventsTo1> evnLst = null;
		if (null != src && !src.isEmpty()) {
			evnLst = new ArrayList<EventsTo1>(src.size());
			Calendar cal = Calendar.getInstance();
			Calendar cal1 = Calendar.getInstance();
			for (Appointment appt : src) {
				EventsTo1 events =  new EventsTo1();
				if(appt.getDemographicNo() == 0){
					events.setAppointStatus("");				
					events.setApptType("");
				}else{
					events.setAppointStatus(KeyToValueMapper.getStatusValue(appt.getStatus()));					
					events.setApptType(KeyToValueMapper.getTypeValue(appt.getType()));
				}				
				events.setApptId(String.valueOf(appt.getId()));
				events.setDocId(appt.getProviderNo());
				cal.setTime(appt.getStartTime());
				String apptTime = (cal.get(Calendar.HOUR_OF_DAY) <= 9 ? "0" + cal.get(Calendar.HOUR_OF_DAY)
							: cal.get(Calendar.HOUR_OF_DAY))  + ":"
							+(cal.get(Calendar.MINUTE) <= 9 ? "0" + cal.get(Calendar.MINUTE) : cal.get(Calendar.MINUTE));
				events.setFromTime(apptTime.toString());
				cal1.setTime(appt.getEndTime());
				long duration = ((cal1.getTime().getTime() - cal.getTime().getTime()) / 1000) / 60;
				events.setDuration(String.valueOf(duration));
				events.setGoTo(KeyToValueMapper.getTypeValue(appt.getType()));
				events.setIsCritical(appt.getUrgency());
				events.setNoOfPat("");
				events.setNotes(appt.getNotes());
				events.setPatientName(appt.getName());
				events.setProviderName(proviDao.getProviderNameLastFirst(appt.getProviderNo()));
				//if(appt.getDemographicNo() == 0){
					LookupListItem l = reasonDao.findNameById(appt.getReasonCode());
					events.setReason(l.getValue());
				//}else{
					//events.setReason(getReason(appt.getReasonCode()!=null?appt.getReasonCode().toString():""));
				//}
				//events.s;
				
				//if(appt.getDemographicNo() == 0){
				//	LookupListItem l = reasonDao.findNameById(appt.getReasonCode());
					//events.setReason(l.getValue());
				///}else{
				//	events.setReason(getReason(appt.getReasonCode()!=null?appt.getReasonCode().toString():""));
				//}
				events.setApptStartDate(DateUtils.convertDateToString(appt.getAppointmentDate()));
				evnLst.add(events);
			}
		}
		log.debug("AppointmentBo.copyEvents() ends");
		return evnLst;
	}
	
	
	/**
	 * Returns appointment Type
	 * 
	 * @param src		source data
	 * @param dest		destination data
	 * @return			appointment type
	 */
	public static List<AppointmentTypeTo> copyAppointmentTypes(List<AppointmentType> src, List<AppointmentTypeTo> dest) {
		log.debug("AppointmentBo.copyAppointmentTypes() starts");
		if (null != src && !src.isEmpty()) {
			dest = new ArrayList<AppointmentTypeTo>();
			for (AppointmentType type : src) {
				AppointmentTypeTo apptTypeTo = new AppointmentTypeTo();
				apptTypeTo.setId(KeyToValueMapper.getTypeValue(String.valueOf(type.getId())));
				apptTypeTo.setName(type.getName());
				dest.add(apptTypeTo);
			}
		}
		log.debug("AppointmentBo.copyAppointmentTypes() ends");
		return dest;
	}
	
	/**
	 * Returns appointment Type
	 * 
	 * @param src		source data
	 * @param dest		destination data
	 * @return			appointment type
	 */
	public static List<AppointmentStatusTo> copyAppointmentStatus(List<AppointmentStatus> src, List<AppointmentStatusTo> dest) {
		log.debug("AppointmentBo.copyAppointmentStatus() starts");
		if (null != src && !src.isEmpty()) {
			dest = new ArrayList<AppointmentStatusTo>();
			for (AppointmentStatus status : src) {
				AppointmentStatusTo apptStatusTo = new AppointmentStatusTo();
				apptStatusTo.setId(KeyToValueMapper.getStatusValue(status.getStatus()));
				apptStatusTo.setName(status.getDescription());
				apptStatusTo.setColor(status.getColor());
				apptStatusTo.setIcon(status.getIcon());
				dest.add(apptStatusTo);
			}
		}
		log.debug("AppointmentBo.copyAppointmentStatus() ends");
		return dest;
	}
	
	/**
	 * Returns reason codes.
	 * 
	 * @param items	reason code items
	 * @return
	 */
	public static List<AppointmentReasonTo> copyReasons(List<LookupListItem> items) {
		log.debug("AppointmentBo.copyReasons() starts");
		List<AppointmentReasonTo> reasonsLst = null;
		AppointmentReasonTo reason = null;
		if (null != items && !items.isEmpty()) {
			reasonsLst = new ArrayList<AppointmentReasonTo>(items.size());
			for (LookupListItem item : items) {
				reason = new AppointmentReasonTo();
				reason.setId(item.getId().toString());
				reason.setName(item.getValue());
				reasonsLst.add(reason);
			}
			if (null == reasonMap || reasonMap.isEmpty()) {
				for (LookupListItem item : items) {
					reasonMap.put(item.getId().toString(), item.getValue());
				}
			}
		}
		log.debug("AppointmentBo.copyReasons() ends");
		return reasonsLst;
	}

	public static String getReason(String key) {
		return reasonMap.get(key);
	}
	
	public static AppointmentTo setSelectedAppointment(List<Appointment> result){
		AppointmentTo appointmentTo=new AppointmentTo();
		for (Iterator<Appointment> i = result.iterator(); i.hasNext();) {
	        Appointment appointment = (Appointment) i.next();
	        try {
	            appointmentTo.setApptStartDate(DateUtils.convertDateToString(appointment.getAppointmentDate()));
           
			appointmentTo.setApptEndDate(DateUtils.convertDateToString(appointment.getAppointmentDate()));
			appointmentTo.setPatientName(appointment.getName());
			appointmentTo.setApptNotes(appointment.getNotes());
			appointmentTo.setProvId(appointment.getProviderNo());
			appointmentTo.setAppReason(""+appointment.getReasonCode());
			appointmentTo.setApptReasonDtls(appointment.getReason());
			appointmentTo.setApptResources(appointment.getResources());
			Calendar cal = Calendar.getInstance();
			cal.setTime(appointment.getStartTime());
			String min = ""+cal.get(Calendar.MINUTE);
			if(min.equals("0"))
				min = "00";
			String apptTime =  cal.get(Calendar.HOUR_OF_DAY) + "_" + min;
			appointmentTo.setApptTime(apptTime.toString());
			Calendar cal1 = Calendar.getInstance();
			cal1.setTime(appointment.getEndTime());
			long duration = ((cal1.getTime().getTime() - cal.getTime().getTime()) / 1000) / 60;
			appointmentTo.setApptDuration(String.valueOf(duration));
			appointmentTo.setApptStatus(KeyToValueMapper.getStatusValue(appointment.getStatus()));
			appointmentTo.setGoTo(KeyToValueMapper.getTypeValue(appointment.getType()));
			appointmentTo.setIsCritical(appointment.getUrgency());
			appointmentTo.setId(String.valueOf(appointment.getId()));
			appointmentTo.setPatientId(String.valueOf(appointment.getDemographicNo()));
			appointmentTo.setLocation(appointment.getLocation());
			appointmentTo.setNoOfPatient("");
			appointmentTo.setApptType(appointment.getType());
			appointmentTo.setCreator(appointment.getCreator());
			appointmentTo.setLastUpdateUser(appointment.getLastUpdateUser());
			appointmentTo.setCreateDateTime(DateUtils.convertDateToString(appointment.getCreateDateTime()));
			appointmentTo.setUpdateDateTime(DateUtils.convertDateToString(appointment.getUpdateDateTime()));
			
			appointmentTo.setProgramId(String.valueOf(appointment.getProgramId()));
			appointmentTo.setMultiApptId(String.valueOf(appointment.getMultiApptId()));
			appointmentTo.setRecurrenceId(String.valueOf(appointment.getRecurrenceId()));
			appointmentTo.setRoomId(appointment.getRoomId());
			
	        } catch (Exception e) {
            }
        }
		return appointmentTo;
	}
	
	public static HashMap<String,String> setFlipData(List<ScheduleDate> result,ScheduleTemplateDao scheduleTempDao){
		
		HashMap<String,String> flipData = new HashMap<String, String>();
		for (Iterator<ScheduleDate> i = result.iterator(); i.hasNext();) {
			ScheduleDate scheduleDate = (ScheduleDate) i.next();
	        try {
	        	
	        	String timeCode =  scheduleTempDao.findByName(scheduleDate.getHour().trim(),scheduleDate.getProviderNo());
	        	
	        	flipData.put(DateUtils.convertDateToString(scheduleDate.getDate()), timeCode);
	        
	        } catch (ParseException e) {
            }
        }
		return flipData;
	}

	public static List<ScheduleTemplateCodeTo> getAsTransferSetObject(List<ScheduleTemplateCode> archivedClients){
		List<ScheduleTemplateCodeTo> returnResult = new java.util.ArrayList<ScheduleTemplateCodeTo>();
		ScheduleTemplateCodeTo appTo = new ScheduleTemplateCodeTo(); 
		for (Iterator<ScheduleTemplateCode> i = archivedClients.iterator(); i.hasNext();) {
			ScheduleTemplateCode tempCode = (ScheduleTemplateCode) i.next();
	        appTo = new ScheduleTemplateCodeTo();
	        appTo.setBookinglimit(String.valueOf(tempCode.getBookinglimit()));
	        appTo.setCode(String.valueOf(tempCode.getCode()));
	        appTo.setColor(tempCode.getColor());
	        appTo.setConfirm(tempCode.getConfirm());
	        appTo.setDescription(tempCode.getDescription());
	        appTo.setDuration(tempCode.getDuration());
	        appTo.setId(String.valueOf(tempCode.getId()));
	        
	        returnResult.add(appTo);
        }
		return returnResult;
	}
	
	public static ApptRecurrence convertToRecObject(AppointmentTo apptTo){
		ApptRecurrence rec = new ApptRecurrence();
			
			try {
				rec.setFrequency(apptTo.getFrequency());
	            rec.setStartDate(DateUtils.formatDate(apptTo.getStartDate()));
	            rec.setEndDate(DateUtils.formatDate(apptTo.getEndDate()));
            } catch (ParseException e) {
	           
            }
		return rec;
	}

	public static RoomTo convertRoomObject(Room room){
		RoomTo roomTo = new RoomTo();
		roomTo.setId(String.valueOf(room.getId()));
		roomTo.setRoomTypeId(String.valueOf(room.getRoomTypeId()));
		if(room.getProgramId()!=null){
			roomTo.setProgramId(String.valueOf(room.getProgramId()));
		}
		roomTo.setName(room.getName());
		roomTo.setFloor(room.getFloor());
		roomTo.setFacilityId(String.valueOf(room.getFacilityId()));
		roomTo.setAssignedBed(String.valueOf(roomTo.getAssignedBed()));
		if(room.getOccupancy()!=null){
			roomTo.setOccupancy(String.valueOf(room.getOccupancy()));
		}
		return roomTo;
	}
}
