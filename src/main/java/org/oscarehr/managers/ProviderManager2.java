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

import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.common.dao.PropertyDao;
import org.oscarehr.common.model.Property;
import org.oscarehr.common.model.Provider;
import org.oscarehr.ws.rest.bo.ProviderBO;
import org.oscarehr.ws.rest.to.model.ProviderTo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import oscar.log.LogAction;

@Service
public class ProviderManager2 {
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

	public List<ProviderTo> getProvidersforSearch(String nameLike) {
		List<ProviderTo> providersTo = null;
		try {
			List<Provider> results = providerDao.getActiveProvideFirstNameLikeSearch(nameLike);
			//--- log action ---
			LogAction.addLogSynchronous("ProviderManager.getProviders" + results.size(), null);
			// copy provider into provider transfer object
			providersTo = new ArrayList<ProviderTo>();
			providersTo = ProviderBO.copy(results, providersTo);
		} catch (Exception e) {
			return new ArrayList<ProviderTo>();
		}
		return providersTo;
	}

	public List<Property> getProviderProperties(String providerNo, String propertyName)
	{
		List<Property> results=propertyDao.findByNameAndProvider(propertyName, providerNo);
		
		//--- log action ---
		LogAction.addLogSynchronous("ProviderManager.getProviderProperties, providerNo=" + providerNo+", propertyName="+propertyName, null);
		
		return(results);
	}
}
