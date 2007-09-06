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


package org.oscarehr.casemgmt.dao.hibernate;

import java.util.Date;
import java.util.List;

import org.oscarehr.casemgmt.dao.AllergyDAO;
import org.oscarehr.casemgmt.model.Allergy;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class AllergyDAOHibernate extends HibernateDaoSupport implements
		AllergyDAO {

	public Allergy getAllergy(Long allergyid) {
		return (Allergy)this.getHibernateTemplate().get(Allergy.class,allergyid);
	}
	
	public List getAllergies(String demographic_no) {
		return this.getHibernateTemplate().find("from Allergy a where a.demographic_no = ?",new Object[] {demographic_no});
	}

	public void saveAllergy(Allergy allergy) {
		/*find the old allergy record for client*/
		Allergy tempAllergy;
		String demographicNo=allergy.getDemographic_no();
		List allergies = getAllergies(demographicNo);
		if(allergies.size()==0) {
			tempAllergy = allergy;
		} else {
			tempAllergy = (Allergy) allergies.get(0);
			tempAllergy.setReaction(allergy.getReaction());		
			tempAllergy.setEntry_date(new Date());
		}		
		
		this.getHibernateTemplate().saveOrUpdate(tempAllergy);
	}
}
