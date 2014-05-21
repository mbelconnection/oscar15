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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.apache.log4j.Logger;
import org.apache.tools.ant.util.DateUtils;
import org.oscarehr.common.model.Appointment;
import org.oscarehr.common.model.Provider;
import org.oscarehr.managers.AppointmentManager;
import org.oscarehr.managers.DemographicManager;
import org.oscarehr.managers.ProviderManager2;
import org.oscarehr.managers.ScheduleManager;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.web.PatientListApptBean;
import org.oscarehr.web.PatientListApptItemBean;
import org.oscarehr.ws.rest.bo.AppointmentBO;
import org.oscarehr.ws.rest.bo.ProviderBO;
import org.oscarehr.ws.rest.bo.ScheduleBO;
import org.oscarehr.ws.rest.conversion.AppointmentConverter;
import org.oscarehr.ws.rest.exception.ScheduleException;
import org.oscarehr.ws.rest.to.AppointmentResponse;
import org.oscarehr.ws.rest.to.model.EventsTo1;
import org.oscarehr.ws.rest.to.model.ProviderAndEventSearchResponse;
import org.oscarehr.ws.rest.to.model.ProviderAndEventSearchResults;
import org.oscarehr.ws.rest.to.model.ProvidersTo1;
import org.oscarehr.ws.rest.util.ErrorCodes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Path("/schedule")
@Component("ScheduleService")
public class ScheduleService extends AbstractServiceImpl {
	
	private static Logger logger=MiscUtils.getLogger();

	private SimpleDateFormat timeFormatter = new SimpleDateFormat("hh:mm aa");
	
	@Autowired
	private ScheduleManager scheduleManager;
	@Autowired
	private AppointmentManager appointmentManager;
	@Autowired
	private DemographicManager demographicManager;
	@Autowired
	private ProviderManager2 providerManager;
	
	//private DemographicConverter demoConverter = new DemographicConverter();
	private AppointmentConverter apptConverter = new AppointmentConverter();
	
	
	@GET
	@Path("/{providerNo}/day/{date}")
	@Produces("application/json")
	public PatientListApptBean getAppointmentsForDay(@PathParam("providerNo") String providerNo, @PathParam("date") String date) {
		PatientListApptBean response = new PatientListApptBean();
		
		try {
			Date dateObj = null;
			if("today".equals(date)) {
				dateObj = new Date(); 
			} else {
				dateObj = DateUtils.parseIso8601Date(date);
			}
			List<Appointment> appts = scheduleManager.getDayAppointments(providerNo, dateObj);
			for(Appointment appt:appts) {
				PatientListApptItemBean item = new PatientListApptItemBean();
				item.setDemographicNo(appt.getDemographicNo());
				item.setName(demographicManager.getDemographicFormattedName(appt.getDemographicNo()));
				item.setStartTime(timeFormatter.format(appt.getStartTime()));
				item.setReason(appt.getReason());
				item.setStatus(appt.getStatus());
				response.getPatients().add(item);
			}
		}catch(ParseException e) {
			throw new RuntimeException("Invalid Date sent, use yyyy-MM-dd format");
		}
		return response;
	}
	
	@GET
	@Path("/nextAppointments/{demographicNo}")
	@Produces("application/json")
	public AppointmentResponse getNextAppointmentsForDemographic(@PathParam("demographicNo") String demographicNo) {
		AppointmentResponse result = new AppointmentResponse();
		
		result.getContent().addAll(apptConverter.getAllAsTransferObjects(appointmentManager.getAppointmentHistoryAfter(Integer.parseInt(demographicNo), new Date(), 0, Integer.MAX_VALUE))); 
		
		return result;
	}
	
	@GET
	@Path("/{day}/list1")
	@Produces("application/json")
	public Response getProvidersAndEvents(@PathParam("day") String day) {
		logger.debug("ScheduleService.getProvidersAndEvents() starts");
		ProviderAndEventSearchResults rstLst = null;
		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
		try {
			rstLst = scheduleManager.getProviderAndEvents(day);
			response.setResponse(rstLst);
		} catch(ScheduleException e) {
			logger.error("Error in ScheduleService.getProvidersAndEvents()", e);
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		logger.debug("ScheduleService.getProvidersAndEvents() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
	@GET
	@Path("/{day}/{providerNo}/list1")
	@Produces("application/json")
	public Response getSingleProvidersAndEvents(@PathParam("day") String day,@PathParam("providerNo") String providerNo) {
		logger.debug("ScheduleService.getProvidersAndEvents() starts");
		ProviderAndEventSearchResults rstLst = null;
		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
		try {
			rstLst = scheduleManager.getSingleProviderAndEvents(day,providerNo);
			response.setResponse(rstLst);
		} catch(ScheduleException e) {
			logger.error("Error in ScheduleService.getProvidersAndEvents()", e);
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		logger.debug("ScheduleService.getProvidersAndEvents() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
	@GET
	@Path("/{group}/{day}/list33")
	@Produces("application/json")
	public Response getGroupDayEvents(@PathParam("group") String group, @PathParam("day") String day) {
		logger.debug("ScheduleService.getProvidersAndEvents() starts");
		ProviderAndEventSearchResults rstLst = null;
		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
		try {
			rstLst = scheduleManager.getGroupDayEvents(day, group);
			response.setResponse(rstLst);
		} catch(ScheduleException e) {
			logger.error("Error in ScheduleService.getProvidersAndEvents()", e);
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		logger.debug("ScheduleService.getProvidersAndEvents() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
	@GET
	@Path("/{group}/{stday},{endday}/grpwkevnts")
	@Produces("application/json")
	public Response getGroupWeekEvents(@PathParam("group") String group, @PathParam("stday") String stday , @PathParam("endday") String endday) {
		logger.debug("ScheduleService.getGroupWeekEvents() starts");
		ProviderAndEventSearchResults rstLst = null;
		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
		try {
			rstLst = scheduleManager.getGroupWeekEvents(stday, endday, group);
			response.setResponse(rstLst);
		} catch(ScheduleException e) {
			logger.error("Error in ScheduleService.getProvidersAndEvents()", e);
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		logger.debug("ScheduleService.getGroupWeekEvents() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
	@GET
	@Path("/{group}/{day}/grpmonevnts")
	@Produces("application/json")
	public Response getGroupMonthEvents(@PathParam("group") String group, @PathParam("day") String day) {
		logger.debug("ScheduleService.getGroupMonthEvents() starts");
		ProviderAndEventSearchResults rstLst = null;
		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
		try {
			rstLst = scheduleManager.getGroupMonthEvents(day, group);
			response.setResponse(rstLst);
		} catch(ScheduleException e) {
			logger.error("Error in ScheduleService.getProvidersAndEvents()", e);
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		logger.debug("ScheduleService.getGroupMonthEvents() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
	@GET
	@Path("/{week}/{providerNo}/list")
	@Produces("application/json")
	public Response getProvidersAndEventsForWeek(@PathParam("week") String week, @PathParam("providerNo") String providerNo) {
		logger.debug("ScheduleService.getProvidersAndEventsForWeek() starts");
		
		ProviderAndEventSearchResults rstLst = null;
		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
		List<Appointment> appointments = null;
		List<ProvidersTo1> providersTo1 = null;
		List<EventsTo1> events = null;
		
		try {
			appointments = scheduleManager.getEventsForWeek(week.split(",")[0], week.split(",")[1], providerNo);
			if (null == appointments || appointments.isEmpty()) {
				rstLst = ScheduleBO.setProvidersAndEventsForWeek(week.split(",")[0], week.split(",")[1], null, null);
			} else {
				if(Integer.parseInt(providerNo)>0){
				Provider provider = providerManager.getProvider(providerNo);
				List<Provider> providers = new ArrayList<Provider>();
				providers.add(provider);
				providersTo1 = ProviderBO.copyProviders(providers, providersTo1);
				if (null == providersTo1 || providersTo1.isEmpty()) {
						throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
					}
				}
				 events = AppointmentBO.copyEvents(appointments, null);
				
				rstLst = ScheduleBO.setProvidersAndEventsForWeek(week.split(",")[0], week.split(",")[1], providersTo1, events);
				
			}
			response.setResponse(rstLst);
		} catch(Exception e) {
			logger.error("Error in ScheduleService.getProvidersAndEvents()", e);
			ScheduleException ex = new ScheduleException();
			if (e instanceof ScheduleException) {
				ex = (ScheduleException) e;
			}
			return Response.status(Status.NOT_FOUND).entity(ex.getBean()).build();
		}
		logger.debug("ScheduleService.getProvidersAndEventsForWeek() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
}
