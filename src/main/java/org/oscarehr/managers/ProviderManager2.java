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

package org.oscarehr.managers;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.common.dao.OscarAppointmentDao;
import org.oscarehr.common.dao.PropertyDao;
import org.oscarehr.common.model.Property;
import org.oscarehr.common.model.Provider;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.exception.ProviderException;
import org.oscarehr.ws.rest.exception.ScheduleException;
import org.oscarehr.ws.rest.util.ErrorCodes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import oscar.log.LogAction;

@Service
public class ProviderManager2 {
	
	private static Logger logger = MiscUtils.getLogger();
	
	@Autowired
	private OscarAppointmentDao oscarAppointmentDao;
	
	@Autowired
	private ProviderDao providerDao;

	@Autowired
	private PropertyDao propertyDao;

	public List<Provider> getProviders(Boolean active) {
		List<Provider> results = null;

		if (active == null) results = providerDao.getProviders();
		else results = providerDao.getProviders(active);

		//--- log action ---
		LogAction.addLogSynchronous("ProviderManager.getProviders, active=" + active, null);

		return (results);
	}

	public Provider getProvider(String providerNo) {

		Provider result = providerDao.getProvider(providerNo);

		//--- log action ---
		LogAction.addLogSynchronous("ProviderManager.getProvider, providerNo=" + providerNo, null);

		return (result);
	}

	public List<Provider> getActiveProviderFirstNameLikeSearch(String[] nameLike) throws ProviderException {
		logger.debug("ProviderManager2.getActiveProviderFirstNameLikeSearch() starts"); 
		List<Provider> results = null;
		try {
			results = providerDao.getActiveProviderFirstNameLikeSearch(nameLike);
		} catch (Exception e) {
			logger.error("Error in ProviderManager2.getActiveProviderFirstNameLikeSearch()", e);
			throw new ProviderException(ErrorCodes.PRV_ERROR_001);
		}
		logger.debug("ProviderManager2.getActiveProviderFirstNameLikeSearch() ends"); 
		return results;
	}
	
	public List<Provider> getActiveProviderLastNameLikeSearch(String[] nameLike) throws ProviderException {
		logger.debug("ProviderManager2.getActiveProviderLastNameLikeSearch() starts"); 
		List<Provider> results = null;
		try {
			results = providerDao.getActiveProviderLastNameLikeSearch(nameLike);
		} catch (Exception e) {
			logger.error("Error in ProviderManager2.getActiveProviderLastNameLikeSearch()", e);
			throw new ProviderException(ErrorCodes.PRV_ERROR_001);
		}
		logger.debug("ProviderManager2.getActiveProviderLastNameLikeSearch() ends"); 
		return results;
	}

	public List<Property> getProviderProperties(String providerNo, String propertyName)
	{
		List<Property> results=propertyDao.findByNameAndProvider(propertyName, providerNo);
		
		//--- log action ---
		LogAction.addLogSynchronous("ProviderManager.getProviderProperties, providerNo=" + providerNo+", propertyName="+propertyName, null);
		
		return(results);
	}
	
	public List getGroupAndIndividualForDropdown() throws ProviderException {
		logger.debug("ScheduleService.getActivePatients() starts");
		List<Map<String,String>> data = null;
		List<Map<String,String>> groupData = null;
		try {			
			data = oscarAppointmentDao.getActiveProvidersForDropdown();
			if(null == data)
				data = new ArrayList<Map<String,String>>();
			groupData = oscarAppointmentDao.getActiveGroupsForDropdown();
			data.addAll(groupData);
			if (null == data || data.isEmpty()) {
				throw new ScheduleException(ErrorCodes.SCH_ERROR_001);
			}
		} catch (Exception e) {
			logger.error("Error in ScheduleService.getProviderAndEvents()", e);
			throw new ProviderException(ErrorCodes.SCH_ERROR_001);
		}
		
		logger.debug("ScheduleService.getActivePatients() ends");
		return data;
	}
}
