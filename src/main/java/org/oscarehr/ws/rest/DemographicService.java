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
import java.util.Set;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.oscarehr.util.SpringUtils;
import org.oscarehr.PMmodule.web.formbean.ClientSearchFormBean;
import org.oscarehr.PMmodule.service.ClientManager;

import org.apache.commons.lang.time.DateFormatUtils;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.common.dao.CountryCodeDao;
import org.oscarehr.common.dao.DemographicCustDao;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.DemographicExtDao;
import org.oscarehr.common.model.CountryCode;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.DemographicCust;
import org.oscarehr.common.model.DemographicExt;
import org.oscarehr.common.model.Provider;
import org.oscarehr.managers.DemographicManager;
import org.oscarehr.managers.WaitListManager;
import org.oscarehr.ws.rest.bo.PatientBO;
import org.oscarehr.ws.rest.conversion.DemographicConverter;
import org.oscarehr.ws.rest.exception.AppointmentException;
import org.oscarehr.ws.rest.exception.PatientException;
import org.oscarehr.ws.rest.to.DemographicResponse;
import org.oscarehr.ws.rest.to.OscarSearchResponse;
import org.oscarehr.ws.rest.to.model.AppointmentTo;
import org.oscarehr.ws.rest.to.model.AppointmentTo1;
import org.oscarehr.ws.rest.to.model.DemographicSearchResultItem;
import org.oscarehr.ws.rest.to.model.DemographicSearchResults;
import org.oscarehr.ws.rest.to.model.DemographicSearchTo;
import org.oscarehr.ws.rest.to.model.DemographicTo;
import org.oscarehr.ws.rest.to.model.DemographicTo1;
import org.oscarehr.ws.rest.to.model.DemographicsTo;
import org.oscarehr.ws.rest.to.model.OscarResponseTo;
import org.oscarehr.ws.rest.util.ErrorCodes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import oscar.util.StringUtils;

/**
 * Defines a service contract for main operations on demographic. 
 */
@Path("/demographics")
@Component("demographicService")
public class DemographicService extends AbstractServiceImpl {
	@Autowired
	private DemographicManager demographicManager;
	@Autowired
	private DemographicDao demographicDao;
	@Autowired
	private DemographicExtDao demographicExtDao;
	@Autowired
	private WaitListManager waitingListManager;
	@Autowired
	private CountryCodeDao countryCodeDao;
	@Autowired
	private DemographicCustDao demographicCustDao;
	@Autowired
	private ProviderDao providerDao;
	
	private DemographicConverter demoConverter = new DemographicConverter();
	
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
	 * Get country codes
	 * @return
	 * 		Returns data of all country codes
	 */
	@GET
	@Path("/countries")
	@Produces("application/json")
	public DemographicResponse getCountryCodes() {		
		DemographicResponse result = new DemographicResponse();
	    List<CountryCode> countryList = this.countryCodeDao.getAllCountryCodes();
	    for (CountryCode c : countryList) {
	    	//TODO: marc - I broke this rebasing I guess.
	    	//result.getCountries().add(this.demoConverter.getCountryCodeAsTransferObject(c));
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
	public DemographicTo1 getDemographicData(@PathParam("dataId") Integer id) {		
		Demographic demo = demographicManager.getDemographic(id);
		if (demo == null) {
			return null;
		}
		
		DemographicTo1 result = demoConverter.getAsTransferObject(demo);
		return result;
	}
	
	
	/* * Gets detailed demographic data as JSON.
	 * 
	 * @param id
	 * 		Id of the demographic to get data for 
	 * @return
	 * 		Returns data for the demographic provided 
	 */
	
	@GET
	@Path("/detail/{dataId}")
	@Produces("application/json")
	public DemographicTo1 getDemographicDataJson(@PathParam("dataId") Integer id) {		
		Demographic demo = demographicManager.getDemographic(id);
		if (demo == null) {
			return null;
		}
		List<DemographicExt> extra = demographicManager.getDemographicExts(id);
		if (extra.size() > 0) {
			DemographicExt[] extraArray = new DemographicExt[extra.size()];
			for (int i = 0; i < extra.size(); i++) {
				extraArray[i] = extra.get(i);
			}
			demo.setExtras(extraArray);
		}
		DemographicTo1 result = demoConverter.getAsTransferObject(demo);
		
		DemographicCust cust = demographicCustDao.find(id);
		result.setAlert(cust.getAlert());
		result.setNotes(cust.getNotes());
		
		result.setCellPhone(this.getExtValue(extra, "demo_cell"));
		result.setHomeExt(this.getExtValue(extra, "hPhoneExt"));
		result.setWorkExt(this.getExtValue(extra, "wPhoneExt"));
		result.setAboriginal(this.getExtValue(extra, "aboriginal"));
		result.setPhoneComment(this.getExtValue(extra, "phoneComment"));
		result.setCytology(this.getExtValue(extra, "cytolNum"));
		
		result.setEthnicity(this.getExtValue(extra, "ethnicity"));
		result.setArea(this.getExtValue(extra, "area"));
		result.setStatus(this.getExtValue(extra, "statusNum"));
		result.setFirstNation(this.getExtValue(extra, "fNationCom"));
		/*
		result.setCellPhone(this.getExtValue(extra, "given_consent"));
		result.setCellPhone(this.getExtValue(extra, "rxInteractionWarningLevel"));
		result.setCellPhone(this.getExtValue(extra, "primaryEMR"));
		result.setCellPhone(this.getExtValue(extra, "usSigned"));
		result.setCellPhone(this.getExtValue(extra, "privacyConsent"));
		result.setCellPhone(this.getExtValue(extra, "informedConsent"));
		*/
		return result;
	}
	
	private String getExtValue(List<DemographicExt> extra, String key) {
		for (DemographicExt ext : extra) {
			if (ext.getKey().equals(key)) {
				return ext.getValue();
			}
		}
		return "";
	}
	
	/**
	 * Search demographics - used by navigation of OSCAR webapp
	 * 
	 * Currently supports LastName[,FirstName] and address searches.
	 * 
	 * @param id
	 * 		Id of the demographic to get data for 
	 * @return
	 * 		Returns data for the demographic provided 
	 */
	@GET
	@Path("/search")
	@Produces("application/json")
	public DemographicSearchResults search(@QueryParam("query") String query) {		
		
		long start = System.currentTimeMillis();
		List<Demographic> demo = new ArrayList<Demographic>();
		
		if(query.startsWith("addr:")) {
			demo = demographicManager.searchDemographicByAddress(query, 0, 10);
		} else if(query.startsWith("chartNo:")) {
			demo = demographicManager.searchDemographicByChartNo(query, 0, 10);
		} else {
			demo = demographicManager.searchDemographicByNames(query, 0, 10);
		}
		if (demo == null) {
			return null;
		}
		long execTime = System.currentTimeMillis() - start;
		
		DemographicSearchResults results = new DemographicSearchResults();
		results.setTime(execTime);
		for(Demographic d:demo) {
			DemographicSearchResultItem item = new DemographicSearchResultItem();
			item.setId(d.getDemographicNo());
			item.setName(d.getFormattedName());
			if(StringUtils.filled(d.getHin()))
				item.setHin(d.getHin() + (StringUtils.filled(d.getVer()) ?" " + d.getVer():""));
			if(d.getDOB() != null) {
				item.setDob(d.getDOB());
				item.setDobString(DateFormatUtils.ISO_DATE_FORMAT.format(d.getDOB()));
			}
			results.getItems().add(item);
		}
		
		return results;
	}
	
	@GET
	@Path("/list/{providerNo}")
	@Produces("application/json")
	public DemographicSearchTo list(@PathParam("providerNo") String providerNo) {		
		DemographicSearchTo result = new DemographicSearchTo();
		for(Demographic demographic: demographicDao.getActiveDemographics(0, -1)) {
			DemographicTo1 to = new DemographicTo1();
			to.setDemographicNo(demographic.getDemographicNo());
			to.setFirstName(demographic.getFirstName());
			to.setLastName(demographic.getLastName());
			result.getDemographics().add(to);
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
	@Consumes("application/json")
	public DemographicTo1 createDemographicData(DemographicTo1 data) {
		Demographic demographic = demoConverter.getAsDomainObject(data);
		demographicManager.createDemographic(demographic);
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
	@Consumes("application/json")
	@Produces("application/json")
	public DemographicResponse updateDemographicData(DemographicTo1 data) {
		DemographicResponse result = new DemographicResponse();
		Demographic demographic = demoConverter.getAsDomainObject(data);
	    // demographicManager.updateDemographic(demographic);
		demographicDao.save(demographic);
	    
	    DemographicCust cust = this.demographicCustDao.find(data.getDemographicNo());
	    cust.setAlert(data.getAlert());
	    cust.setNotes("<unotes>" + data.getNotes() + "</unotes>");
	    this.demographicCustDao.saveEntity(cust);
	    
	    
	    
	    result.setResult(true);
	    return result;
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
	
	/**
	 * To get Demograhic no and Name for search in Add Appointments. 
	 * 
	 * @param nameLike
	 * 		first three characters of First Name entered in the search Patients text box
	 * @return
	 * 		Returns the List of Demographic objects containing DemographicNo and Full Name
	 */	
	@GET
	@Path("/patlist")
	@Produces("application/json")
	public Response getDemographicsAndEvents()  {
    	List<Demographic> demographics = null;
    	List<DemographicTo> demographicLst = null;
    	DemographicsTo demographicsTo = null;
    	try {
    		//String[] names = nameLike.split(",");
    		demographics = demographicManager.getActiveDemographisFirstNameSearch();
    		if (null == demographics || demographics.isEmpty()) {
				throw new PatientException(ErrorCodes.PAT_ERROR_001);
			}
    		demographicLst = PatientBO.copy(demographics, demographicLst, "FN");
    		
    		demographicsTo = new DemographicsTo();
    		demographicsTo.setDemographics(demographicLst);
    	} catch(PatientException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
    	return Response.status(Status.OK).entity(demographicsTo).build();
    	}
	
	@GET
	@Path("/{id}/patientTotalDetails")
	@Produces("application/json")
	public Response fetchPatientDetails(@PathParam("id") String id) {
		//logger.debug("AppointmentService.editAppointments() starts");	
		DemographicTo1 demoTo = null;
		OscarResponseTo response = new OscarResponseTo();
		Set<AppointmentTo1> archivedClients = new java.util.LinkedHashSet<AppointmentTo1>();
		try {
			demoTo = demographicManager.getPatientDetails(id);
			archivedClients = demographicManager.fetchPatientsHistory(id);
			response.setDemographic(demoTo);
			response.setAppointmentsHistory(archivedClients);
		}catch(PatientException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		//log.debug("AppointmentService.editAppointments() ends");
		return Response.status(Status.OK).entity(response).build();
	}
	
	
	@GET
	@Path("/{id}/patientHistory")
	@Produces("application/json")
	public Response fetchPatientsHistory(@PathParam("id") String id) {
		//logger.debug("AppointmentService.editAppointments() starts");	
		Set<AppointmentTo1> archivedClients = new java.util.LinkedHashSet<AppointmentTo1>();
		//OscarResponseTo response = new OscarResponseTo();
		try {
			archivedClients = demographicManager.fetchPatientsHistory(id);
			//response.setAppointments(apptTo);
		}catch(PatientException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		//log.debug("AppointmentService.editAppointments() ends");
		return Response.status(Status.OK).entity(archivedClients).build();
	}
	
	@POST
	@Path("/nextAvaAppt")
	@Produces("application/json")
	@Consumes("application/json")
	public Response nextAvailAppt(AppointmentTo appointmentTo) {
			
		Set<AppointmentTo1> archivedClients = new java.util.LinkedHashSet<AppointmentTo1>();
		OscarResponseTo response = new OscarResponseTo();
		try {
			archivedClients = demographicManager.nextAvalibleAppt(appointmentTo);
		
		} catch (AppointmentException e) {
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
        }
		
		return Response.status(Status.OK).entity(archivedClients).build();
	}


	@POST
	@Path("/advancedSearch")
	@Consumes("application/json")
	@Produces("application/json")
	public DemographicSearchResults search(ClientSearchFormBean searchQuery) {		
		DemographicSearchResults results = new DemographicSearchResults();
		
		ClientManager clientManager = SpringUtils.getBean(ClientManager.class);
		
		List<Demographic> demo = clientManager.search(searchQuery);
		
		for(Demographic d:demo) {
			DemographicSearchResultItem item = new DemographicSearchResultItem();
			item.setId(d.getDemographicNo());
			item.setName(d.getFormattedName());
			if(StringUtils.filled(d.getHin()))
				item.setHin(d.getHin() + (StringUtils.filled(d.getVer()) ?" " + d.getVer():""));
			if(d.getDOB() != null) {
				item.setDob(d.getDOB());
				item.setDobString(DateFormatUtils.ISO_DATE_FORMAT.format(d.getDOB()));
			}
			item.setChartNo(d.getChartNo()!=null?d.getChartNo():"");
			item.setRosterStatus(d.getRosterStatus()!=null?d.getRosterStatus():"");
			item.setPatientStatus(d.getPatientStatus()!=null?d.getPatientStatus():"");
			item.setMrp("");
			if(d.getProviderNo() != null && d.getProviderNo().length()>0) {
				Provider prov = providerDao.getProvider(d.getProviderNo());
				if(prov != null) {
					item.setMrp(prov.getFormattedName());
				}
			}
			item.setGender(d.getSex());
			item.setPhone(d.getPhone()==null||d.getPhone().equals("")?"&nbsp;":(d.getPhone().length()==10?(d.getPhone().substring(0,3)+"-"+d.getPhone().substring(3)):d.getPhone()));
			results.getItems().add(item);
		}
		
		return results;
	}
}
