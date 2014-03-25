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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.apache.log4j.Logger;
import org.oscarehr.managers.AppointmentManager;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.exception.AppointmentException;
import org.oscarehr.ws.rest.to.model.AppointmentTo;
import org.oscarehr.ws.rest.to.model.AppointmentTo1;
import org.oscarehr.ws.rest.to.model.OscarResponseTo;
import org.oscarehr.ws.rest.to.model.PatientSearchResponse;
import org.oscarehr.ws.rest.to.model.PatientSearchResults;
import org.oscarehr.ws.rest.to.model.RoomTo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

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
	public Response addAppointments(AppointmentTo appointmentTo) {
		log.debug("AppointmentService.addAppointments() starts");	
		AppointmentTo apptTo = null;
		OscarResponseTo response = new OscarResponseTo();
		try {
			apptTo = appointmentManager.saveAppointment(appointmentTo, getCurrentProvider().getLastName() + ", " + getCurrentProvider().getFirstName());
			response.setAppointments(apptTo);
		}catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("AppointmentService.addAppointments() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
	@DELETE
	@Path("/{id}/delete")
	@Consumes("application/json")
	public Response deleteAppointment(@PathParam("id") String id) {
		log.debug("AppointmentService.deleteAppointment() starts");	
		try {
			appointmentManager.deleteAppointment(Integer.parseInt(id));
		}catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("AppointmentService.deleteAppointment() ends");
		return Response.status(Status.OK).build();
	}

	@POST
	@Path("/saveEdit")
	@Consumes("application/json")
	public Response saveEditAppointments(AppointmentTo appointmentTo) {
		log.debug("AppointmentService.addAppointments() starts");	
		boolean success=false;
		try {
			appointmentManager.saveUpdatedAppointment(appointmentTo, getCurrentProvider().getLastName() + ", " + getCurrentProvider().getFirstName());
			success=true;
		}catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("AppointmentService.addAppointments() ends");
		return Response.status(Status.OK).entity(success).build();
	}
	
	@POST
	@Path("/{demographicNo}/findExist")
	@Produces("application/json")
	public Response findExistAppointments(@PathParam("demographicNo") String demographicNo) {
		log.debug("AppointmentService.findExistAppointments() starts");
		PatientSearchResults psLst = null;
		//List<Appointment> result = null;
		PatientSearchResponse response = new PatientSearchResponse();
		
		psLst = appointmentManager.getExistAppointments(demographicNo);
		response.setResponse(psLst);
		 
		log.debug("ScheduleService.getProvidersAndEvents() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
	@GET
	@Path("/{id}/{status}/saveStatus")
	@Produces("application/json")
	public Response saveAppointmentStatus(@PathParam("id") String id, @PathParam("status") String status) {
		log.debug("AppointmentService.saveAppointmentStatus() starts");	

		boolean result= false;
		
		try {
				result= appointmentManager.saveUpdatedAppointmentStatus(id.trim(), status);
			
		}catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("AppointmentService.editAppointments() ends");
		return Response.status(Status.OK).entity(result).build();
	}
	
	@GET
	@Path("/{id}/{type}/saveType")
	@Produces("application/json")
	public Response saveAppointmentType(@PathParam("id") String id, @PathParam("type") String type) {
		log.debug("AppointmentService.saveAppointmentType() starts");	

		boolean result= false;
		try {
				result= appointmentManager.saveUpdatedAppointmentType(id.trim(), type);
			
		}catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("AppointmentService.saveAppointmentType() ends");
		return Response.status(Status.OK).entity(result).build();
	}
	
	@GET
	@Path("/{id}/{urgency}/saveCritical")
	@Produces("application/json")
	public Response saveAppointmentCriticality(@PathParam("id") String id, @PathParam("urgency") String urgency) {
		log.debug("AppointmentService.saveAppointmentCriticality() starts");	
		boolean result= false;
		try {
				result= appointmentManager.saveUpdatedAppointmentCritical(id.trim(), urgency);
			
		}catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("AppointmentService.saveAppointmentCriticality() ends");
		return Response.status(Status.OK).entity(result).build();
	}
	
	@GET
	@Path("/{startDate}/{endDate}/{providersData}/fetchMonthly")
	@Produces("application/json")
	public Response fetchMonthlyData(@PathParam("startDate") String startDate, @PathParam("endDate") String endDate, @PathParam("providersData") String providersData) {
		log.debug("AppointmentService.saveAppointmentCriticality() starts");	
		
		OscarResponseTo response = new OscarResponseTo();
		Map<String,Set<AppointmentTo1>> returnResult = new java.util.HashMap<String,Set<AppointmentTo1>>();
		try {
			returnResult= appointmentManager.fetchMonthlyData(startDate, endDate,providersData);
			
		}catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("AppointmentService.saveAppointmentCriticality() ends");
		return Response.status(Status.OK).entity(returnResult).build();
	}
	
	@GET
	@Path("/{startDate}/{endDate}/{providerId}/fetchFlipView")
	@Produces("application/json")
	public Response fetchFlipView(@PathParam("startDate") String startDate, @PathParam("endDate") String endDate, @PathParam("providerId") String providerId) {
		log.debug("AppointmentService.fetchFlipView() starts");	
		
		OscarResponseTo response = new OscarResponseTo();
		java.util.HashMap<String,String> returnResult = new java.util.HashMap<String,String>();
		try {
			returnResult= appointmentManager.getFlipDetails(providerId, startDate, endDate);
			
		}catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("AppointmentService.fetchFlipView() ends");
		return Response.status(Status.OK).entity(returnResult).build();
	}
	
	
	@GET
	@Path("/roomDetails/get")
	@Produces("application/json")
	public Response getRoomDetails() {
		List<RoomTo> roomList = new ArrayList<RoomTo>();
		
			roomList = appointmentManager.getRoomDetails();
			
	
		log.debug("AppoimentService.getRoomDetails() ends");
		return Response.status(Status.OK).entity(roomList).build();
	}
	
	@GET
	@Path("/{appDate}/{providerId}/{startTime}/{endTime}/checkProvAvali")
	@Produces("application/json")
	public Response checkProviderAvaliablity( @PathParam("appDate") String appDate, @PathParam("providerId") String providerId,@PathParam("startTime") String startTime, @PathParam("endTime") String endTime) {
		Map<String,Integer> rstLst = new HashMap<String,Integer>();
		
			rstLst = appointmentManager.checkAppointmentDetails(providerId, appDate, startTime, endTime);
		
		log.debug("Appointmentservice.checkProviderAvaliablity() ends");
		return Response.status(Status.OK).entity(rstLst).build();
	}
}
