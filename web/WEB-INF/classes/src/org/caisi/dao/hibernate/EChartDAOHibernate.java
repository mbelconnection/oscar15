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

package org.caisi.dao.hibernate;


import java.util.List;

import org.caisi.dao.EChartDAO;
import org.caisi.model.EChart;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * Hibernate implementation for the corresponding DAO interface 
 * @author Marc Dumontier <a href="mailto:marc@mdumontier.com">marc@mdumontier.com</a>
 *
 */
public class EChartDAOHibernate extends HibernateDaoSupport implements
		EChartDAO {

	public void saveEncounter(EChart chart) {
		this.getHibernateTemplate().save(chart);
	}

	public EChart getLatestChart(int demographicNo) {
		List results = getHibernateTemplate().find("from EChart c where c.demographicNo = ? order by c.echartTimeStamp desc",new Object[] {String.valueOf(demographicNo)});
		if(results.size()>0) {
			return (EChart)results.get(0);
		} else {
			return null;
		}
		
		//return (EChart)getHibernateTemplate().find("from EChart c where c.demographicNo = ? order by c.echartTimeStamp desc",new Object[] {String.valueOf(demographicNo)}).get(0);
	}
}
