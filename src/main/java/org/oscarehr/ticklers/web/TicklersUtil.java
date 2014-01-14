/**
 * Copyright (c) 2013-2020. Department of Family Medicine, McMaster University. All Rights Reserved.
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

package org.oscarehr.ticklers.web;

import java.util.List;

import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.common.dao.SiteDao;
import org.oscarehr.common.model.Provider;
import org.oscarehr.common.model.Site;
import org.oscarehr.util.SpringUtils;


public class TicklersUtil {

    private ProviderDao providerDao = (ProviderDao)SpringUtils.getBean("providerDao");
    private SiteDao siteDao = (SiteDao)SpringUtils.getBean("siteDao");

    public List<Site> getSites(String providerNo)  {
        
	    List<Site> sites = siteDao.getActiveSitesByProviderNo(providerNo);
        return sites;
    }
    
    public List<Provider> getActiveProviders()  {
		List<Provider> providersActive = providerDao.getActiveProviders();
        return providersActive;
    }

}
