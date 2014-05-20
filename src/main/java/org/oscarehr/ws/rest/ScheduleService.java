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
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

import org.apache.tools.ant.util.DateUtils;
import org.oscarehr.common.model.Appointment;
import org.oscarehr.managers.AppointmentManager;
import org.oscarehr.managers.DemographicManager;
import org.oscarehr.managers.ScheduleManager;
import org.oscarehr.web.PatientListApptBean;
import org.oscarehr.web.PatientListApptItemBean;
import org.oscarehr.ws.rest.conversion.AppointmentConverter;
import org.oscarehr.ws.rest.to.AppointmentResponse;
import org.oscarehr.ws.rest.to.model.EventsTo1;
import org.oscarehr.ws.rest.to.model.ProviderAndEventSearchResponse;
import org.oscarehr.ws.rest.to.model.ProviderAndEventSearchResults;
import org.oscarehr.ws.rest.to.model.ProvidersTo1;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Path("/schedule")
@Component("scheduleService")
public class ScheduleService extends AbstractServiceImpl {

	private SimpleDateFormat timeFormatter = new SimpleDateFormat("hh:mm aa");
	
	@Autowired
	private ScheduleManager scheduleManager;
	@Autowired
	private AppointmentManager appointmentManager;
	@Autowired
	private DemographicManager demographicManager;
	
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
	@Path("/{providerNo}/list")
	@Produces("application/json")
	public ProviderAndEventSearchResponse getProvidersAndEvents(@PathParam("providerNo") String providerNo) {
		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
		ProviderAndEventSearchResults results = null;
		try {
			List<ProviderAndEventSearchResults> rstLst = new ArrayList<ProviderAndEventSearchResults>();
			for (int i = 1; i <= 2; i++) {
				results = new ProviderAndEventSearchResults();
				ProvidersTo1 providers = new ProvidersTo1();
				List<ProvidersTo1> provLst = new ArrayList<ProvidersTo1>();
				providers.setGroup("group1");
				providers.setId("1");
				providers.setName("Dr. Oscardoc");
				provLst.add(providers);
				providers = new ProvidersTo1();
				providers.setGroup("group2");
				providers.setId("2");
				providers.setName("Dr. Jones");
				provLst.add(providers);
				results.setProviders(provLst);
				
				EventsTo1 events =  new EventsTo1();
				events.setAppointStatus("DP");
				events.setApptId("10");
				events.setDocId("1");
				events.setDuration("30");
				events.setFromTime("9:00");
				events.setGoTo("E");
				events.setIsCritical("Y");
				events.setNoOfPat("5");
				events.setNotes("Noted complications since last year");
				events.setPatientName("John");
				events.setReason("Blood Test Results");
				List<EventsTo1> evnLst = new ArrayList<EventsTo1>();
				evnLst.add(events);
				events =  new EventsTo1();
				events.setAppointStatus("DP");
				events.setApptId("20");
				events.setDocId("2");
				events.setDuration("30");
				events.setFromTime("9:00");
				events.setGoTo("E");
				events.setIsCritical("Y");
				events.setNoOfPat("5");
				events.setNotes("Noted complications since last year");
				events.setPatientName("John C");
				events.setReason("Physical Examination.");
				evnLst.add(events);
				results.setEvents(evnLst);
				Calendar c = null;
				if (i%2==0) {
				c = Calendar.getInstance();
				c.set(Calendar.DAY_OF_MONTH, c.get(Calendar.DAY_OF_MONTH) - 1);
				results.setDay(new SimpleDateFormat("dd-MMM-yyyy").format(c.getTime()));
				} else {
				c = Calendar.getInstance();
				results.setDay(new SimpleDateFormat("dd-MMM-yyyy").format(c.getTime()));
				}
				rstLst.add(results);
			}
			response.setResponse(rstLst);
			
		}catch(Exception e) {
			throw new RuntimeException("");
		}
		return response;
	}
}
