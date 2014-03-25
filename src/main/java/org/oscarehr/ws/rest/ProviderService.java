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
import java.util.Map;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsDateJsonBeanProcessor;

import org.apache.cxf.message.Message;
import org.apache.cxf.phase.PhaseInterceptorChain;
import org.apache.cxf.rs.security.oauth.data.OAuthContext;
import org.apache.cxf.security.SecurityContext;
import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.common.model.Provider;
import org.oscarehr.managers.DemographicManager;
import org.oscarehr.managers.ProviderManager2;
import org.oscarehr.managers.ScheduleManager;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.bo.ProviderBO;
import org.oscarehr.ws.rest.exception.AppointmentException;
import org.oscarehr.ws.rest.exception.ProviderException;
import org.oscarehr.ws.rest.exception.ScheduleException;
import org.oscarehr.ws.rest.to.model.OscarResponseTo;
import org.oscarehr.ws.rest.to.model.ProviderAndEventSearchResponse;
import org.oscarehr.ws.rest.to.model.ProviderAndEventSearchResults;
import org.oscarehr.ws.rest.to.model.ProviderTo;
import org.oscarehr.ws.rest.to.model.ProviderTo1;
import org.oscarehr.ws.transfer_objects.ProviderTransfer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


@Path("/providerService")
@Component("ProviderService")
public class ProviderService {

	private static Logger log = MiscUtils.getLogger();

	
	@Autowired
	ProviderDao providerDao;
	
	@Autowired
	ProviderManager2 providerManager;
	
	@Autowired
	private DemographicManager demographicManager;
	
	@Autowired
	private ScheduleManager scheduleManager;
	
	protected SecurityContext getSecurityContext() {
		Message m = PhaseInterceptorChain.getCurrentMessage();
    	org.apache.cxf.security.SecurityContext sc = m.getContent(org.apache.cxf.security.SecurityContext.class);
    	return sc;
	}
	
	protected OAuthContext getOAuthContext() {
		Message m = PhaseInterceptorChain.getCurrentMessage();
		OAuthContext sc = m.getContent(OAuthContext.class);
    	return sc;
	}
	
    public ProviderService() {
    }

    @GET
    @Path("/providers")
    public org.oscarehr.ws.rest.to.OscarSearchResponse<ProviderTransfer> getProviders() {
    	org.oscarehr.ws.rest.to.OscarSearchResponse<ProviderTransfer> lst = new 
    			org.oscarehr.ws.rest.to.OscarSearchResponse<ProviderTransfer>();
    	   	
    	for(Provider p: providerDao.getActiveProviders()) {
    		lst.getContent().add(ProviderTransfer.toTransfer(p));
    	} 
      
        return lst;
    }
 
    @GET
    @Path("/providers_json")
    public String getProvidersAsJSON() {
    	JsonConfig config = new JsonConfig();
    	config.registerJsonBeanProcessor(java.sql.Date.class, new JsDateJsonBeanProcessor());
    	
    	List<Provider> p = providerDao.getActiveProviders();
    	JSONArray arr = JSONArray.fromObject(p, config);
    	return arr.toString();
    }

    @GET
    @Path("/provider/{id}")
    public ProviderTransfer getProvider(@PathParam("id") String id) {
        return ProviderTransfer.toTransfer(providerDao.getProvider(id));
    }
    
    @GET
    @Path("/provider/me")
    public String getLoggedInProvider() {
    	Provider provider = LoggedInInfo.loggedInInfo.get().loggedInProvider;
    	
    	if(provider != null) {
    		JsonConfig config = new JsonConfig();
        	config.registerJsonBeanProcessor(java.sql.Date.class, new JsDateJsonBeanProcessor());
            return JSONObject.fromObject(provider,config).toString();
    	}
    	return null;
    }
    
    @GET
    @Path("/providerjson/{id}")
    public String getProviderAsJSON(@PathParam("id") String id) {
    	JsonConfig config = new JsonConfig();
    	config.registerJsonBeanProcessor(java.sql.Date.class, new JsDateJsonBeanProcessor());
        return JSONObject.fromObject(providerDao.getProvider(id),config).toString();
    }

    @GET
    @Path("/providers/bad")
    public Response getBadRequest() {
        return Response.status(Status.BAD_REQUEST).build();
    }
    

    @GET
   	@Path("/{nameLike}/list")
   	@Produces("application/json")
   	public Response getProviders(@PathParam("nameLike") String nameLike) {
       	log.debug("ProviderService.getProviders() starts");
       	List<ProviderTo> providerLst = null;
       	List<Provider> providers = null;
       	OscarResponseTo response = null;
       	try {
       		String []multi = nameLike.split("- ");
       		String[] names = multi[multi.length - 1].split(",");
       		providers = providerManager.getActiveProviderFirstNameLikeSearch(names);
       		if (null == providers || providers.isEmpty()) {
       			providers = providerManager.getActiveProviderLastNameLikeSearch(names);
       			/*Commented by Schedular Team
       			 * if (null == providers || providers.isEmpty()) {
   					throw new ProviderException(ErrorCodes.PRV_ERROR_001);
   				}*/
       			providerLst = ProviderBO.copy(providers, providerLst, "LN");
       		} else {
       			providerLst = ProviderBO.copy(providers, providerLst, "FN");
       		}
       		response = new OscarResponseTo();
       		response.setProviders(providerLst);
       	} catch(ProviderException e) {
       		log.error("Error in ProviderService.getProviders()", e);
   			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
   		}
       	log.debug("ProviderService.getProviders() ends");
       	return Response.status(Status.OK).entity(response).build();
       }
    
    @GET
	@Path("/getteam")
	@Produces("application/json")
	public Response getGroupAndIndividualForDropdown() {
		log.debug("ScheduleService.getGroupAndIndividual() starts");
		List rstLst = null;
		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
		try {
			rstLst = providerManager.getGroupAndIndividualForDropdown();			
		} catch(ProviderException e) {
			log.error("Error in ScheduleService.getProvidersAndEvents()", e);
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("ScheduleService.getGroupAndIndividual() ends");
		return Response.status(Status.OK).entity(rstLst).build();
	}
    
    
    @GET
   	@Path("/{groupName}/groupProvList")
   	@Produces("application/json")
   	public Response getGroupProviderList(@PathParam("groupName") String groupName) {
   		log.debug("ProviderService.getGroupProviderList() starts");
   		Map<String,List<ProviderTo1>> provList = null;
   		
   			try {
	            provList = demographicManager.getGroupProviderDetails(groupName);
            } catch (AppointmentException e) {
            	log.error("Error in ProviderService.getGroupProviderList()", e);
    			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
	         }
   			
   		
   		log.debug("providerservice.getGroupProviderList() ends");
   		return Response.status(Status.OK).entity(provList).build();
   	}
    
    @POST
   	@Path("/saveGroupProvList")
   	@Consumes("application/json")
    @Produces("application/json")
   	public Response saveGroupProviderList(List<ProviderTo1> providerList) {
   		log.debug("AppointmentService.getBlockTimeReason() starts");
   		Map<String,List<ProviderTo1>> provList = null;
   		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
   		ProviderAndEventSearchResults rstLst = null;
   		boolean result;
   		try {
   			result = demographicManager.saveProviderDetails(providerList);
   			rstLst = scheduleManager.getSelectedProviderAndEvents(providerList,null);
   			response.setResponse(rstLst);
   		}catch(AppointmentException e) {
   			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
   		} catch (ScheduleException e) {
   			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
        }
   		log.debug("AppointmentService.getBlockTimeReason() ends");
   		return Response.status(Status.OK).entity(response).build();
   	}
    
    @GET
	@Path("/{appDate}/{groupName}/fetchGroupAppointments")
	@Produces("application/json")
	public Response fetchGroupSchedules( @PathParam("appDate") String appDate, @PathParam("groupName") String groupName) {
		ProviderAndEventSearchResults rstLst = null;
		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
		try {
			rstLst = scheduleManager.getTeamProviderAndEvents(groupName,appDate);
			response.setResponse(rstLst);
		} catch(ScheduleException e) {
			log.error("Error in ScheduleService.getProvidersAndEvents()", e);
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("ScheduleService.getProvidersAndEvents() ends");
		return Response.status(Status.OK).entity(response).build();
	}
    
    
    @GET
	@Path("/{appDate}/{groupName}/fetchGroupHavingEvents")
	@Produces("application/json")
	public Response fetchGroupHavingSchedules( @PathParam("appDate") String appDate, @PathParam("groupName") String groupName) {
		ProviderAndEventSearchResults rstLst = null;
		ProviderAndEventSearchResponse response = new ProviderAndEventSearchResponse();
		try {
			rstLst = scheduleManager.getTeamProviderHavingEvents(groupName,appDate);
			response.setResponse(rstLst);
		} catch(ScheduleException e) {
			log.error("Error in ScheduleService.getProvidersAndEvents()", e);
			return Response.status(Status.NOT_FOUND).entity(e.getBean()).build();
		}
		log.debug("ScheduleService.getProvidersAndEvents() ends");
		return Response.status(Status.OK).entity(response).build();
	}

    
}
