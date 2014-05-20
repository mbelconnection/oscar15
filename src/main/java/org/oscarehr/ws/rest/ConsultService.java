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
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.dao.ProgramDao;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.common.dao.ConsultationRequestDao;
import org.oscarehr.common.dao.ConsultationServiceDao;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.ProfessionalSpecialistDao;
import org.oscarehr.common.model.ConsultationRequest;
import org.oscarehr.common.model.ConsultationRequestStatus;
import org.oscarehr.common.model.ConsultationServices;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.ProfessionalSpecialist;
import org.oscarehr.ws.rest.conversion.ConsultationConverter;
import org.oscarehr.ws.rest.conversion.DemographicConverter;
import org.oscarehr.ws.rest.to.ConsultationRequestResponse;
import org.oscarehr.ws.rest.to.model.ConsultationRequestTo;
import org.oscarehr.ws.rest.to.model.ConsultationServiceTo;
import org.oscarehr.ws.rest.to.model.LetterheadTo;
import org.oscarehr.ws.rest.to.model.SpecialtyTo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import oscar.OscarProperties;
import oscar.oscarClinic.ClinicData;
import oscar.oscarRx.data.RxProviderData;
import oscar.oscarRx.data.RxProviderData.Provider;

/**
 * Defines a service contract for main operations on demographic. 
 */
@Path("/consult")
@Component("consultService")
public class ConsultService extends AbstractServiceImpl {
	private Logger logger = Logger.getLogger(this.getClass().getName());
	@Autowired
	private ConsultationRequestDao consultDao;
	@Autowired
	private ProgramDao programDao;
	@Autowired
	private ConsultationServiceDao consultationServiceDao;
	@Autowired
	private DemographicDao demographicDao;
	@Autowired
	private ProfessionalSpecialistDao professionalSpecialistDao;

	@GET
	@Path("/detail/{requestId}")
	@Produces("application/json")
	public ConsultationRequestTo getConsultationRequest(@PathParam("requestId") Integer requestId) {
		ConsultationRequestTo consultationRequest = new ConsultationRequestTo();
		if (requestId > 0) {
			ConsultationConverter converter = new ConsultationConverter();
			consultationRequest = converter.getAsTransferObject(consultDao.find(requestId));
		}
		consultationRequest.getLetterheads().addAll(this.listLetterheads());
		consultationRequest.getServices().addAll(this.listServices());
		return consultationRequest;
	}

	private List<LetterheadTo> listLetterheads() {
		List<LetterheadTo> list = new ArrayList<LetterheadTo>();
		// Letterheads
		ClinicData clinic = new ClinicData();
		LetterheadTo to = new LetterheadTo();
		to.setId(clinic.getClinicName());
		to.setName(clinic.getClinicName());
		to.setAddress(clinic.getClinicAddress());
		to.setPhone(clinic.getClinicPhone());
		to.setFax(clinic.getClinicFax());
		list.add(to);

		RxProviderData rx = new RxProviderData();
		for (Provider provider : rx.getAllProviders()) {
			if (provider.getProviderNo().compareTo("-1") != 0 && (provider.getFirstName() != null || provider.getSurname() != null)) {
				to = new LetterheadTo();
				to.setId(provider.getProviderNo());
				to.setName(provider.getSurname() + ", " + provider.getFirstName());
				to.setAddress(provider.getFullAddress());
				to.setPhone(provider.getClinicPhone());
				to.setFax(provider.getClinicFax());
				list.add(to);
			}
		}
		if (OscarProperties.getInstance().getBooleanProperty("consultation_program_letterhead_enabled", "true")) {
			for (Program program : programDao.getAllActivePrograms()) {
				to = new LetterheadTo();
				to.setId("prog_" + program.getId().toString());
				to.setName(program.getName());
				to.setAddress(program.getAddress());
				to.setPhone(program.getPhone());
				to.setFax(program.getFax());
				list.add(to);
			}
		}
		return list;
	}

	private List<ConsultationServiceTo> listServices() {
		List<ConsultationServiceTo> list = new ArrayList<ConsultationServiceTo>();
		for (ConsultationServices service : this.consultationServiceDao.findAll()) {
			ConsultationServiceTo serviceTo = new ConsultationServiceTo();
			serviceTo.setId(service.getServiceId().toString());
			serviceTo.setDescription(service.getServiceDesc());
			for (ProfessionalSpecialist specialist : service.getSpecialists()) {
				SpecialtyTo specialistTo = new SpecialtyTo();
				specialistTo.setId(specialist.getId().toString());
				specialistTo.setFirstName(specialist.getFirstName());
				specialistTo.setLastName(specialist.getLastName());
				specialistTo.setProfessionalLetters(specialist.getProfessionalLetters());
				specialistTo.setAddress(specialist.getStreetAddress());
				specialistTo.setEmail(specialist.getEmailAddress());
				specialistTo.setFax(specialistTo.getFax());
				specialistTo.setPhone(specialist.getPhoneNumber());
				specialistTo.setWebSite(specialist.getWebSite());
				specialistTo.setSpecialtyType(specialist.getSpecialtyType());
				specialistTo.setAnnotation(specialist.getAnnotation());
				serviceTo.getSpecialties().add(specialistTo);
			}
			list.add(serviceTo);
		}
		return list;
	}

	@POST
	@Consumes("application/json")
	@Produces("application/json")
	public ConsultationRequestResponse saveConsult(ConsultationRequestTo to) {
		ConsultationRequestResponse response = new ConsultationRequestResponse();
		// Save demographic
		DemographicConverter demoConverter = new DemographicConverter();
		Demographic demographic = this.demographicDao.getDemographicById(to.getDemographic().getDemographicNo());
		demoConverter.getAsDomainObject(to.getDemographic(), demographic);
		this.demographicDao.save(demographic);

		// Save consult
		Integer id = to.getId();
		ConsultationConverter consultConverter = new ConsultationConverter();
		ConsultationRequest consult = null;
		if (id != null) {
			consult = this.consultDao.find(id);
			consultConverter.getAsDomainObject(to, consult);
		} else {
			consult = consultConverter.getAsDomainObject(to);
			consult.setProfessionalSpecialist(null);
			this.consultDao.saveEntity(consult);
		}
		if (to.getSpecId() != null) {
			ProfessionalSpecialist professionalSpecialist = professionalSpecialistDao.find(to.getSpecId());
			consult.setProfessionalSpecialist(professionalSpecialist);
		} else {
			consult.setProfessionalSpecialist(null);
		}
		this.consultDao.saveEntity(consult);
		
		response.setResult(true);
		return response;
	}

	@DELETE
	@Path("/delete/{requestId}")
	@Produces("application/json")
	public ConsultationRequestResponse deleteConsult(@PathParam("requestId") Integer requestId) {
		ConsultationRequestResponse response = new ConsultationRequestResponse();
		ConsultationRequest consult = this.consultDao.find(requestId);
		if (consult == null) {
			response.setResult(false);
			response.setMessage("Unable to find consultation request with ID " + requestId);
			throw new IllegalArgumentException("Unable to find consultation request with ID " + requestId);
		}
		consult.setStatus(ConsultationRequestStatus.Deleted.getStringValue());
		consult.setStatusText(ConsultationRequestStatus.Deleted.getText());
		this.consultDao.saveEntity(consult);
		response.setResult(true);
		return response;
	}
}
