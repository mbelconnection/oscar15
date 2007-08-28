/*
* 
* Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
* This software is published under the GPL GNU General Public License. 
* This program is free software; you can redistribute it and/or 
* modify it under the terms of the GNU General Public License 
* as published by the Free Software Foundation; either version 2 
* of the License, or (at your option) any later version. * 
* This program is distributed in the hope that it will be useful, 
* but WITHOUT ANY WARRANTY; without even the implied warranty of 
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
* GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
* along with this program; if not, write to the Free Software 
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
* 
* <OSCAR TEAM>
* 
* This software was written for 
* Centre for Research on Inner City Health, St. Michael's Hospital, 
* Toronto, Ontario, Canada 
*/

package org.oscarehr.PMmodule.dao;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.oscarehr.PMmodule.model.Agency;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class AgencyDao extends HibernateDaoSupport {

	private Log log = LogFactory.getLog(AgencyDao.class);

	public Agency getAgency(Long agencyId) {
		if (agencyId == null || agencyId < 0) {
			throw new IllegalArgumentException();
		}

		Agency agency = (Agency) getHibernateTemplate().get(Agency.class, agencyId);

		if (log.isDebugEnabled()) {
			log.debug("getAgency: agencyId = " + agencyId + ", found = " + (agency != null));
		}

		return agency;
	}

	public Agency getLocalAgency() {
		Agency agency = null;

		List results = getHibernateTemplate().find("from Agency a where a.local = true");

		if (!results.isEmpty()) {
			agency = (Agency) results.get(0);
		}

		if (log.isDebugEnabled()) {
			log.debug("getLocalAgency: found = " + (agency != null));
		}

		return agency;
	}

    @SuppressWarnings("unchecked")
    public List<Agency> getAgencies() {
		List results = this.getHibernateTemplate().find("from Agency");
		
		if (log.isDebugEnabled()) {
			log.debug("getAgencies : # of results = " + results.size());
		}
		
		return results;
	}

	public void saveAgency(Agency agency) {
		if (agency == null) {
			throw new IllegalArgumentException();
		}

		getHibernateTemplate().saveOrUpdate(agency);

		if (log.isDebugEnabled()) {
			log.debug("saveAgency : id = " + agency.getId());
		}

	}

}