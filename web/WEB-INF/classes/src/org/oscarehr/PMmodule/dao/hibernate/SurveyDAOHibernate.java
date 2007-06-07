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

package org.oscarehr.PMmodule.dao.hibernate;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.oscarehr.PMmodule.dao.SurveyDAO;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.survey.model.oscar.OscarForm;
import org.oscarehr.survey.model.oscar.OscarFormData;
import org.oscarehr.survey.model.oscar.OscarFormInstance;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class SurveyDAOHibernate extends HibernateDaoSupport implements
		SurveyDAO {

	public OscarForm getForm(Long formId) {
		return (OscarForm)this.getHibernateTemplate().get(OscarForm.class,formId);
	}

	public void saveFormInstance(OscarFormInstance instance) {
		this.getHibernateTemplate().save(instance);
	}

	public OscarFormInstance getLatestForm(Long formId, Long clientId) {
		List result = this.getHibernateTemplate().find("from OscarFormInstance f where f.formId = ? and f.clientId = ? order by f.dateCreated DESC",
				new Object[] {formId,clientId});
		if(result.size()>0) {
			return (OscarFormInstance)result.get(0);
		}
		return null;
	}

	public List getForms(Long clientId) {
		List result = this.getHibernateTemplate().find("from OscarFormInstance f where f.clientId = ? order by f.dateCreated DESC",clientId);
		return result;
	}

	public List getForms(Long formId, Long clientId) {
		List result = this.getHibernateTemplate().find("from OscarFormInstance f where f.formId = ?, and f.clientId = ? order by f.dateCreated DESC",
				new Object[] {formId,clientId});
		return result;
	}
	
	public void saveFormData(OscarFormData data) {
		this.getHibernateTemplate().save(data);
	}
	
	public List getAllForms() {
		return this.getHibernateTemplate().find("from OscarForm f where f.status = " + OscarForm.STATUS_ACTIVE+" order by description ASC");
	}

	public List getCurrentForms(String formId, List clients) {
		List results = new ArrayList();
		
		for(Iterator iter=clients.iterator();iter.hasNext();) {
			Demographic client = (Demographic)iter.next();
			OscarFormInstance ofi = getLatestForm(new Long(formId), new Long(client.getDemographicNo().longValue()));
			results.add(ofi);
		}
		
		return results;
	}
}
