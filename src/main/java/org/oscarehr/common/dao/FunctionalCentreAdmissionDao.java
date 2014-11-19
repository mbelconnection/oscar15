/**
 *
 * Copyright (c) 2005-2012. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved.
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
 * This software was written for
 * Centre for Research on Inner City Health, St. Michael's Hospital,
 * Toronto, Ontario, Canada
 */
package org.oscarehr.common.dao;

import java.util.List;

import javax.persistence.Query;

import org.oscarehr.common.model.FunctionalCentreAdmission;
import org.springframework.stereotype.Repository;

@Repository
public class FunctionalCentreAdmissionDao extends AbstractDao<FunctionalCentreAdmission> {

	public FunctionalCentreAdmissionDao() {
		super(FunctionalCentreAdmission.class);
	}
	
	public FunctionalCentreAdmission getCurrentAdmissionByDemographicNoAndFunctionalCentreId(Integer demographicNo, String functionalCentreId) {

		String sqlCommand = "select f from FunctionalCentreAdmission f where f.demographicNo=?1 and f.functionalCentreId=?2 and f.discharged=0";
		Query query = entityManager.createQuery(sqlCommand);		
		query.setParameter(1, demographicNo);		
		query.setParameter(2, functionalCentreId);	
		return getSingleResultOrNull(query);		
	}
	
	
	public FunctionalCentreAdmission getLatestAdmissionByDemographicNoAndFunctionalCentreId(Integer demographicNo, String functionalCentreId) {

		String sqlCommand = "select f from FunctionalCentreAdmission f where f.demographicNo=?1 and f.functionalCentreId=?2 order by f.id desc";
		Query query = entityManager.createQuery(sqlCommand);		
		query.setParameter(1, demographicNo);		
		query.setParameter(2, functionalCentreId);	
		@SuppressWarnings("unchecked")
        List<FunctionalCentreAdmission> results = query.getResultList();
		if(results.size()>0)
			return results.get(0);
		return null;
	}
	
	
	public List<FunctionalCentreAdmission> getAllAdmissionsByDemographicNo(Integer demographicNo) {

		String sqlCommand = "select f from FunctionalCentreAdmission f where f.demographicNo=?1 order by f.id desc";

		Query query = entityManager.createQuery(sqlCommand);
		query.setParameter(1, demographicNo);		
		
		@SuppressWarnings("unchecked")
		List<FunctionalCentreAdmission> results=query.getResultList();
		
		return (results);
	}
	
	public List<FunctionalCentreAdmission> getDistinctAdmissionsByDemographicNo(Integer demographicNo) {

		String sqlCommand = "select f from FunctionalCentreAdmission f where f.id in (select max(f2.id) from FunctionalCentreAdmission f2 where f2.demographicNo=?1 GROUP BY f2.functionalCentreId ) order by f.id desc";
		
		Query query = entityManager.createQuery(sqlCommand);
		query.setParameter(1, demographicNo);		
		
		@SuppressWarnings("unchecked")
		List<FunctionalCentreAdmission> results=query.getResultList();
		
		return (results);
	}
	
}
