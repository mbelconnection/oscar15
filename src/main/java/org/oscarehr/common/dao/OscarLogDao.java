/*
 * Copyright (c) 2010. Department of Family Medicine, McMaster University. All Rights Reserved.
 * 
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
package org.oscarehr.common.dao;

import java.util.List;

import javax.persistence.Query;

import org.oscarehr.common.model.OscarLog;
import org.springframework.stereotype.Repository;

@Repository
public class OscarLogDao extends AbstractDao<OscarLog> {

	public OscarLogDao() {
		super(OscarLog.class);
	}

    public List<OscarLog> findByDemographicId(Integer demographicId) {

    	String sqlCommand="select x from "+modelClass.getSimpleName()+" x where x.demographicId=?1";
    	
    	Query query = entityManager.createQuery(sqlCommand);
		query.setParameter(1, demographicId);

	    @SuppressWarnings("unchecked")
		List<OscarLog> results=query.getResultList();
		
		return(results);
    }
    
    
    public boolean hasRead(String providerNo, String content, String contentId){
    	String sqlCommand="select x from "+modelClass.getSimpleName()+" x where x.action = 'read' and  x.providerNo=?1 and x.content = ?2 and x.contentId = ?3";
    	Query query = entityManager.createQuery(sqlCommand);
		query.setParameter(1, providerNo);
		query.setParameter(2, content);
		query.setParameter(3, contentId);
		
	    @SuppressWarnings("unchecked")
		List<OscarLog> results=query.getResultList();
	    if(results.size() == 0){
	    	return false;
	    }
		
		return true;
    }
    

}