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

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
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
import org.oscarehr.ws.rest.to.model.OscarResponseTo;
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
	
}
