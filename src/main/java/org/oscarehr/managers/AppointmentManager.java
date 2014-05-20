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
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.oscarehr.common.dao.LookupListDao;
import org.oscarehr.common.dao.OscarAppointmentDao;
import org.oscarehr.common.model.Appointment;
import org.oscarehr.common.model.AppointmentArchive;
import org.oscarehr.common.model.AppointmentStatus;
import org.oscarehr.common.model.AppointmentType;
import org.oscarehr.common.model.LookupList;
import org.oscarehr.common.model.LookupListItem;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.bo.AppointmentBO;
import org.oscarehr.ws.rest.exception.AppointmentException;
import org.oscarehr.ws.rest.to.model.AppointmentStatusTo;
import org.oscarehr.ws.rest.to.model.AppointmentTo;
import org.oscarehr.ws.rest.to.model.AppointmentTypeTo;
import org.oscarehr.ws.rest.util.ErrorCodes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import oscar.log.LogAction;

@Service
public class AppointmentManager {
	
	private static Logger log = MiscUtils.getLogger();

	@Autowired
	private OscarAppointmentDao appointmentDao;
	
	@Autowired
	private LookupListDao lookupListDao;
	
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
		log.debug("AppointmentManager.saveApppointment() starts");
		AppointmentTo apptTo = null;
		try {
			AppointmentBO.validate(appointmentTo);
			Appointment appointment = AppointmentBO.createAppointmentCriteria(appointmentTo, user);
			Appointment appt = appointmentDao.saveAppointment(appointment);
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
}
