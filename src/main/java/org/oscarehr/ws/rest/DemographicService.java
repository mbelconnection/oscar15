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

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

import org.apache.log4j.Logger;
import org.oscarehr.common.model.Appointment;
import org.oscarehr.common.model.Contact;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.DemographicContact;
import org.oscarehr.common.model.DemographicExt;
import org.oscarehr.managers.ContactManager;
import org.oscarehr.managers.DemographicManager;
import org.oscarehr.managers.ScheduleManager;
import org.oscarehr.managers.WaitListManager;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.conversion.ContactConverter;
import org.oscarehr.ws.rest.conversion.DemographicContactConverter;
import org.oscarehr.ws.rest.conversion.DemographicConverter;
import org.oscarehr.ws.rest.to.OscarSearchResponse;
import org.oscarehr.ws.rest.to.model.DemographicContactAndContactTo1;
import org.oscarehr.ws.rest.to.model.DemographicTo1;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.oscarehr.PMmodule.web.GenericIntakeEditAction;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.service.AdmissionManager;

import oscar.oscarEncounter.data.EctProgram;


/**
 * Defines a service contract for main operations on demographic. 
 */
@Path("/demographics")
@Component("demographicService")
public class DemographicService extends AbstractServiceImpl {
	
	private static Logger logger = MiscUtils.getLogger();
	
	@Autowired
	private DemographicManager demographicManager;
	
	@Autowired
	private ContactManager contactManager;
	
	@Autowired
	private WaitListManager waitingListManager;
	
	@Autowired 
	private AdmissionManager admissionManager;
	
	@Autowired
	private ProgramManager programManager;
	//ProgramManager pm = SpringUtils.getBean(ProgramManager.class);
		//AdmissionManager am = SpringUtils.getBean(AdmissionManager.class);
	
	@Autowired
	private ScheduleManager scheduleManager;
	
	private DemographicConverter demoConverter = new DemographicConverter();
	private DemographicContactConverter demoContactConverter = new DemographicContactConverter();
	private ContactConverter contactConverter = new ContactConverter();
	
	/**
	 * Finds all demographics.
	 * <p/>
	 * In case limit or offset parameters are set to null or zero, the entire result set is returned.
	 * 
	 * @param offset
	 * 		First record in the entire result set to be returned
	 * @param limit
	 * 		Maximum total number of records that should be returned
	 * @return
	 * 		Returns all demographics.
	 */
	@GET
	public OscarSearchResponse<DemographicTo1> getAllDemographics(@QueryParam("offset") Integer offset, @QueryParam("limit") Integer limit) {
		OscarSearchResponse<DemographicTo1> result = new OscarSearchResponse<DemographicTo1>();
		
		if (offset == null) {
			offset = 0;
		}
		if (limit == null) {
			limit = 0;
		}
		
		result.setLimit(limit);
		result.setOffset(offset);
		result.setTotal(demographicManager.getActiveDemographicCount().intValue());
		
		for(Demographic demo : demographicManager.getActiveDemographics(offset, limit)) {
			result.getContent().add(demoConverter.getAsTransferObject(demo));
		}
		
		return result;
	}

	/**
	 * Gets detailed demographic data.
	 * 
	 * @param id
	 * 		Id of the demographic to get data for 
	 * @return
	 * 		Returns data for the demographic provided 
	 */
	@GET
	@Path("/{dataId}")
	@Produces("application/json")
	public DemographicTo1 getDemographicData(@PathParam("dataId") Integer id) {		
		Demographic demo = demographicManager.getDemographic(id);
		if (demo == null) {
			return null;
		}
		
		List<DemographicExt> demoExts = demographicManager.getDemographicExts(id);
		if (demoExts!=null && !demoExts.isEmpty()) {
			DemographicExt[] demoExtArray = demoExts.toArray(new DemographicExt[demoExts.size()]);
			demo.setExtras(demoExtArray);
		}

		DemographicTo1 result = demoConverter.getAsTransferObject(demo);
		
		List<DemographicContact> demoContacts = demographicManager.getDemographicContacts(id);
		if (demoContacts!=null) {
			for (DemographicContact demoContact : demoContacts) {
				Integer contactId = Integer.valueOf(demoContact.getContactId());
				Contact contact = contactManager.getContact(contactId);
				
				DemographicContactAndContactTo1 demoContactAndContact = new DemographicContactAndContactTo1();
				demoContactAndContact.setDemoContact(demoContactConverter.getAsTransferObject(demoContact));
				demoContactAndContact.setContact(contactConverter.getAsTransferObject(contact));
				result.getDemoContactAndContacts().add(demoContactAndContact);
			}
		}
		return result;
	}

	/**
	 * Saves demographic information. 
	 * 
	 * @param data
	 * 		Detailed demographic data to be saved
	 * @return
	 * 		Returns the saved demographic data
	 */
	@POST
	@Produces("application/json")
	@Consumes("application/json")
	public DemographicTo1 createDemographicData(DemographicTo1 data) {
		Demographic demographic = demoConverter.getAsDomainObject(data);
		demographicManager.createDemographic(demographic);
		
		//need to admin them into the oscar program.
		GenericIntakeEditAction gieat = new GenericIntakeEditAction();
        gieat.setAdmissionManager(admissionManager);
        gieat.setProgramManager(programManager);
        String programId = new EctProgram(getLoggedInInfo().session).getProgram(getCurrentProvider().getProviderNo());
        try{
        	gieat.admitBedCommunityProgram(demographic.getDemographicNo(),org.oscarehr.util.LoggedInInfo.loggedInInfo.get().loggedInProvider.getProviderNo(),Integer.parseInt(programId),"","",null);
        }catch(Exception e){
        	logger.error("problem adding to program : "+programId,e);
        }
		
        
        
        Date appointmentDate = new Date();
        Appointment appointment = new Appointment();
        appointment.setProviderNo("999998");
        appointment.setAppointmentDate(appointmentDate);
        appointment.setStartTime(appointmentDate);
        appointment.setCreateDateTime(appointmentDate);
        appointment.setUpdateDateTime(appointmentDate);
        appointment.setName(demographic.getLastName()+", "+demographic.getFirstName());
        appointment.setDemographicNo(demographic.getDemographicNo());
        
        appointment.setNotes("");
        appointment.setLocation("");
        appointment.setResources("");
        appointment.setReason("");
        appointment.setStatus("t");
        

		appointment.setProgramId(Integer.parseInt("0"));
		Calendar cal = Calendar.getInstance();
		cal.setTime(appointmentDate);
		cal.add(Calendar.MINUTE, 15);
		cal.add(Calendar.MILLISECOND, -1);
		appointment.setEndTime(cal.getTime());

		
		scheduleManager.addAppointment(appointment);
		
	    return demoConverter.getAsTransferObject(demographic);
	}

	/**
	 * Updates demographic information. 
	 * 
	 * @param data
	 * 		Detailed demographic data to be updated
	 * @return
	 * 		Returns the updated demographic data
	 */
	@PUT
	@Produces("application/json")
	@Consumes("application/json")
	public DemographicTo1 updateDemographicData(DemographicTo1 data) {
	    //create or update Contacts & link with DemographicContacts
		for (DemographicContactAndContactTo1 demoContactAndContact : data.getDemoContactAndContacts()) {
			Contact contact = contactConverter.getAsDomainObject(demoContactAndContact.getContact());
	    	Integer contactId = contactManager.createUpdateContact(contact);
	    	
	    	DemographicContact demoContact = demoContactConverter.getAsDomainObject(demoContactAndContact.getDemoContact());
	    	demoContact.setContactId(contactId.toString());
	    	
	    	demoContact.setFacilityId(getLoggedInInfo().currentFacility.getId());
	    	demoContact.setCreator(getLoggedInInfo().loggedInProvider.getProviderNo());
	    	
	    	demographicManager.createUpdateDemographicContact(demoContact);
		}
		Demographic demographic = demoConverter.getAsDomainObject(data);
	    demographicManager.updateDemographic(demographic);
	    
	    return demoConverter.getAsTransferObject(demographic);
	}

	/**
	 * Deletes demographic information. 
	 * 
	 * @param id
	 * 		Id of the demographic data to be deleted
	 * @return
	 * 		Returns the deleted demographic data
	 */
	@DELETE
	@Path("/{dataId}")
	public DemographicTo1 deleteDemographicData(@PathParam("dataId") Integer id) {
		Demographic demo = demographicManager.getDemographic(id);
    	DemographicTo1 result = getDemographicData(id);
    	if (demo == null) {
    		throw new IllegalArgumentException("Unable to find demographic record with ID " + id);
    	}
    	
		demographicManager.deleteDemographic(demo);
	    return result;
	}

}
