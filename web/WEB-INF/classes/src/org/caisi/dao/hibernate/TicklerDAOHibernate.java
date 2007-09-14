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

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;

import org.caisi.dao.TicklerDAO;
import org.caisi.model.CustomFilter;
import org.caisi.model.Tickler;
import org.caisi.model.TicklerComment;
import org.caisi.model.TicklerUpdate;
import org.oscarehr.PMmodule.model.Provider;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import oscar.util.SqlUtils;

/**
 * Hibernate implementation for the corresponding DAO interface 
 * @author Marc Dumontier <a href="mailto:marc@mdumontier.com">marc@mdumontier.com</a>
 *
 */
public class TicklerDAOHibernate extends HibernateDaoSupport implements
		TicklerDAO {

	
	
	public void saveTickler(Tickler tickler) {
		getHibernateTemplate().saveOrUpdate(tickler);
	}
	
	public Tickler getTickler(Long id) {
		return (Tickler)getHibernateTemplate().get(Tickler.class,id);
	}
	
	public void addComment(Long tickler_id, String provider, String message) {
		Tickler tickler = this.getTickler(tickler_id);
		if(tickler != null) {
			TicklerComment comment = new TicklerComment();
			comment.setTickler_no(tickler_id.longValue());
			comment.setUpdate_date(new Date());
			comment.setProvider_no(provider);
			comment.setMessage(message);
			tickler.getComments().add(comment);
			this.saveTickler(tickler);
		}
	}
	
	public void reassign(Long tickler_id, String provider,String task_assigned_to) {
		Tickler tickler = this.getTickler(tickler_id);
		if(tickler != null) {
			String message;
			String former_assignee= tickler.getAssignee().getFormattedName();
			String current_assignee;
			tickler.setTask_assigned_to(task_assigned_to);
			TicklerComment comment = new TicklerComment();
			comment.setTickler_no(tickler_id.longValue());
			comment.setUpdate_date(new Date());
			comment.setProvider_no(provider);
			current_assignee= ((Provider)(getHibernateTemplate().find("from Provider p where p.ProviderNo = ?",task_assigned_to)).get(0)).getFormattedName();
			message = "RE-ASSIGNMENT RECORD: [Tickler \""+tickler.getDemographic().getFormattedName()+"\" was reassigned from \""+former_assignee+"\"  to \""+current_assignee +"\"]";
			comment.setMessage(message);
			tickler.getComments().add(comment);			
			this.saveTickler(tickler);
		}
	}
	
	
	
	public List getTicklers() {
		return (List)getHibernateTemplate().find("from Tickler");
	}
	
	public List getTicklers(CustomFilter filter) {
		
		String tickler_date_order = filter.getSort_order(); //get "asc"

		String query = "from Tickler t where t.service_date >= ? and t.service_date <= ? ";
		boolean includeProviderClause = true;
		boolean includeAssigneeClause = true;
		boolean includeStatusClause = true;
		boolean includeClientClause = true;
		boolean includeDemographicClause = true;
		List paramList = new ArrayList();
		
		//ORACLE DATE: DD-MMM-YYYY
		try {
			System.out.println("start date="+filter.getStartDate());
			System.out.println("end date="+filter.getEndDate());
			if(filter.getStartDate() == null || filter.getStartDate().length()==0) {
				//filter.setStartDate("0001-01-01");
				filter.setStartDate("01-JAN-1900");
			} 
		
			if(filter.getEndDate() == null ||filter.getEndDate().length()==0) {
				//filter.setEndDate("9999-12-31");
				filter.setEndDate("31-DEC-9999");
			} 
				
			paramList.add(filter.getStartDate());
		
			//paramList.add(filter.getEndDate() + " 23:59:59");
			//paramList.add(filter.getEndDate());
			paramList.add(SqlUtils.addOneDay(filter.getEndDate()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if(filter.getProvider() == null || filter.getProvider().equals("All Providers")) {
			includeProviderClause=false;
		}
		if(filter.getAssignee() == null || filter.getAssignee().equals("All Providers")) {
			includeAssigneeClause=false;
		}
		if(filter.getClient() == null || filter.getClient().equals("All Clients")) {
			includeClientClause=false;
		}
		if(filter.getDemographic_no()==null||filter.getDemographic_no().equals("")||filter.getDemographic_no().equalsIgnoreCase("All Clients")) {
			includeDemographicClause=false;
		}
		
		if(filter.getStatus().equals("") || filter.getStatus().equals("Z")) {
			includeStatusClause = false;
		}
		
				
		//TODO: IN clause
		if(includeProviderClause) {
			query = query + " and t.creator IN (";
			Set pset = filter.getProviders();
			Provider[] providers = (Provider[])pset.toArray(new Provider[pset.size()]);
			for(int x=0;x<providers.length;x++) {
				if(x>0) {
					query += ",";
				}
				query += "?";
				paramList.add(providers[x].getProvider_no());
			}
			query += ")";
		}
		
		//TODO: IN clause
		if(includeAssigneeClause) {
			query = query + " and t.task_assigned_to IN (";
			Set pset = filter.getAssignees();
			Provider[] providers = (Provider[])pset.toArray(new Provider[pset.size()]);
			for(int x=0;x<providers.length;x++) {
				if(x>0) {
					query += ",";
				}
				query += "?";
				paramList.add(providers[x].getProvider_no());
			}
			query += ")";
		}
		
		if(includeStatusClause) {
			query = query + " and t.status = ?";
			paramList.add(String.valueOf(filter.getStatus()));
		}
		if(includeClientClause) {
			query = query + "and t.demographic_no = ?";
			paramList.add(filter.getClient());
		}
		if(includeDemographicClause) {
			query = query + "and t.demographic_no = ?";
			paramList.add(filter.getDemographic_no());
		}
		Object params[] = paramList.toArray(new Object[paramList.size()]);
		System.out.println(".....query= " + query);
		return (List)getHibernateTemplate().find(query + "order by t.service_date "+tickler_date_order,params);
	}
	
	private void updateTickler(Long tickler_id, String provider, char status) {
		Tickler tickler = this.getTickler(tickler_id);
		if(tickler != null) {
			tickler.setStatus(status);
			TicklerUpdate update = new TicklerUpdate();
			update.setProvider_no(provider);
			update.setStatus(status);
			update.setTickler_no(tickler_id.longValue());
			update.setUpdate_date(new Date());
			tickler.getUpdates().add(update);
			this.saveTickler(tickler);
		}
	}
	
	public void completeTickler(Long tickler_id, String provider) {
		updateTickler(tickler_id,provider,'C');
	}
	
	public void deleteTickler(Long tickler_id, String provider) {
		updateTickler(tickler_id,provider,'D');
	}
	
	public void activateTickler(Long tickler_id, String provider) {
		updateTickler(tickler_id,provider,'A');
	}

}
