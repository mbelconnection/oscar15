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

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

import org.oscarehr.common.model.Appointment;
import org.oscarehr.managers.AppointmentManager;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.to.model.AppointmentTo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.apache.log4j.Logger;

@Path("/appointment")
@Component("AppointmentService")
public class AppointmentService extends AbstractServiceImpl {

	private static Logger log = MiscUtils.getLogger();
	
	@Autowired
	private AppointmentManager appointmentManager;
	
	@POST
	@Path("/add")
	@Produces("application/json")
	@Consumes("application/json")
	//public String addAppointments(@PathParam("providerNo") String providerNo, AppointmentTo appointment) {
	public AppointmentTo addAppointments(AppointmentTo appointmentTo) {
			
		try {
			Appointment appointment = new Appointment();
			if (null != appointmentTo.getPatientId()) {
				appointment.setDemographicNo(Integer.parseInt(appointmentTo.getPatientId()));
			}
			appointment.setAppointmentDate(formatDate(appointmentTo.getApptStartDate()));
			appointment.setCreateDateTime(new Date());
			appointment.setCreator("Naresh");
			appointment.setLastUpdateUser("Naresh");
			appointment.setName(appointmentTo.getPatientName());
			appointment.setNotes(appointmentTo.getApptNotes());
			appointment.setProviderNo(appointmentTo.getProvId());
			appointment.setReason(appointmentTo.getAppRreason());
			appointment.setRemarks(appointmentTo.getApptReasonDtls());
			appointment.setResources(appointmentTo.getApptResources());
			Calendar c = Calendar.getInstance();
			c.setTime(formatDate(appointmentTo.getApptStartDate()));
			c.add(Calendar.HOUR, Integer.parseInt(appointmentTo.getApptTime().split("_")[0]));
			c.add(Calendar.MINUTE, 0);
			appointment.setStartTime(c.getTime());
			c.add(Calendar.MINUTE, Integer.parseInt(appointmentTo.getApptDuration()));
			appointment.setEndTime(c.getTime());
			appointment.setStatus(appointmentTo.getApptStatus());
			appointment.setType(appointmentTo.getProviderType());
			appointment.setUpdateDateTime(new Date());
			appointment.setUrgency(appointmentTo.getIsCritical());
			appointment = appointmentManager.saveAppointment(appointment);
			appointmentTo.setApptStartDate(convertDateToString(appointment.getAppointmentDate()));
			appointmentTo.setApptEndDate(convertDateToString(appointment.getAppointmentDate()));
			appointmentTo.setPatientName(appointment.getName());
			appointmentTo.setApptNotes(appointment.getNotes());
			appointmentTo.setProvId(appointment.getProviderNo());
			appointmentTo.setAppRreason(appointment.getReason());
			appointmentTo.setApptReasonDtls(appointment.getRemarks());
			appointmentTo.setApptResources(appointment.getResources());
			c = Calendar.getInstance();
			c.setTime(appointment.getStartTime());
			String apptTime =  c.get(Calendar.HOUR) + "_" + c.get(Calendar.MINUTE);
			appointmentTo.setApptTime(apptTime.toString());
			c.setTime(appointment.getEndTime());
			appointmentTo.setApptDuration(c.get(Calendar.MINUTE) + "");
			appointmentTo.setApptStatus(appointment.getStatus());
			appointmentTo.setProviderType(appointment.getType());
			appointmentTo.setIsCritical(appointment.getUrgency());
			appointmentTo.setId(appointment.getId() + "");
			
		}catch(Exception e) {
			log.error("Error occured in AppointmentService.addAppointments " + e);
		}
		return appointmentTo;
	}
	
	private Date formatDate(String fromDate) throws ParseException {
		SimpleDateFormat f = new SimpleDateFormat("dd-MMM-yyyy");
		Date toDate = f.parse(fromDate);
		return toDate;
	}
	
	private String convertDateToString(Date date) throws ParseException {
		SimpleDateFormat f = new SimpleDateFormat("dd-MMM-yyyy");
		return f.format(date);
	}
	
}
