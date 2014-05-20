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

import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.apache.log4j.Logger;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.managers.AppointmentManager;
import org.oscarehr.managers.DemographicManager;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.bo.AppointmentBO;
import org.oscarehr.ws.rest.bo.PatientBO;
import org.oscarehr.ws.rest.exception.AppointmentException;
import org.oscarehr.ws.rest.exception.PatientException;
import org.oscarehr.ws.rest.to.model.AppointmentReasonTo;
import org.oscarehr.ws.rest.to.model.AppointmentStatusTo;
import org.oscarehr.ws.rest.to.model.AppointmentTypeTo;
import org.oscarehr.ws.rest.to.model.DemographicTo;
import org.oscarehr.ws.rest.to.model.DemographicsTo;
import org.oscarehr.ws.rest.to.model.OscarResponseTo;
import org.oscarehr.ws.rest.util.ErrorCodes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


@Path("/patient")
@Component("PatientService")
public class PatientService {

	private static Logger log = MiscUtils.getLogger();
	
	@Autowired
	DemographicDao providerDao;
	
	@Autowired
	private DemographicManager demographicManager;
	
	@Autowired
	private AppointmentManager appointmentManager;
	
	public PatientService() {
		
	}
	
	@GET
	@Path("/{nameLike}/list")
	@Produces("application/json")
	public Response getPatients(@PathParam("nameLike") String nameLike) {
		log.debug("PatientService.getPatients() starts");
		List<Demographic> demographics = null;
		List<DemographicTo> demographicLst = null;
		DemographicsTo demographicsTo = null;
		try {
			String[] names = nameLike.split(",");
			demographics = demographicManager.getActiveDemographisFirstNameSearch(names);
			if (null == demographics || demographics.isEmpty()) {
    			demographics = demographicManager.getActiveDemographisLastNameSearch(names);
    			demographicLst = PatientBO.copy(demographics, demographicLst, "LN");
    		} else {
    			demographicLst = PatientBO.copy(demographics, demographicLst, "FN");
    		}
    		demographicsTo = new DemographicsTo();
    		demographicsTo.setDemographics(demographicLst);
		} catch(PatientException e) {
    		log.error("Error in PatientService.getPatients()", e);
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
    	log.debug("PatientService.getPatients() ends");
    	return Response.status(Status.OK).entity(demographicsTo).build();
    }
	
	@GET
	@Path("/type/list/{id}")
	@Produces("application/json")
	public Response getAppointmentTypes(@PathParam("id") String id) {
		log.debug("AppointmentService.getAppointmentTypes() starts");	
		List<AppointmentTypeTo> apptTypes = null;
		OscarResponseTo response = null;
		try {
			apptTypes = appointmentManager.getAppointmentType();
		} catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		response = new OscarResponseTo();
		response.setAppointmentTypes(apptTypes);
		log.debug("AppointmentService.getAppointmentTypes() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
	@GET
	@Path("/status/list/{id}")
	@Produces("application/json")
	public Response getAppointmentStatus(@PathParam("id") String id) {
		log.debug("AppointmentService.getAppointmentStatus() starts");	
		List<AppointmentStatusTo> apptStatus = null;
		OscarResponseTo response = null;
		try {
			apptStatus = appointmentManager.getAppointmentStatus();
		} catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		response = new OscarResponseTo();
		response.setAppointmentStatus(apptStatus);
		log.debug("AppointmentService.getAppointmentStatus() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
	@GET
	@Path("/reason/get")
	@Produces("application/json")
	public Response getAppointmentReaons() {
		log.debug("AppointmentService.getAppointmentReaons() starts");
		List<AppointmentReasonTo> reasonsLst = null;
		OscarResponseTo response = null;
		try {
			reasonsLst = AppointmentBO.copyReasons(appointmentManager.getAppointmentReason());
			if (null == reasonsLst || reasonsLst.isEmpty()) {
				throw new AppointmentException(ErrorCodes.APPT_ERROR_005);
			}
			response = new OscarResponseTo();
			response.setAppointmentReason(reasonsLst);
		}catch(AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("AppointmentService.getAppointmentReaons() ends");
		return Response.status(Status.OK).entity(response).build();
	}
}
