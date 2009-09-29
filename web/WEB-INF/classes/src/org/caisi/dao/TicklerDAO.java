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
* Toronto, Ontario, Canada  - UPDATED: Quatro Group 2008/2009
*/

package org.caisi.dao;

import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.time.DateUtils;
import org.caisi.model.CustomFilter;
import org.caisi.model.Tickler;
import org.caisi.model.TicklerComment;
import org.oscarehr.PMmodule.dao.MergeClientDao;
import org.oscarehr.PMmodule.model.ClientMerge;
import org.oscarehr.PMmodule.model.Provider;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import oscar.MyDateFormat;

import com.quatro.util.Utility;



/**
 */
public class TicklerDAO extends HibernateDaoSupport {
    private MergeClientDao mergeClientDao;
    public void setMergeClientDao(MergeClientDao mergeClientDao) {
		this.mergeClientDao = mergeClientDao;
	}

    public void saveTickler(Tickler tickler) {
        getHibernateTemplate().saveOrUpdate(tickler);
    }

    public Tickler getTickler(Integer id) {
        return (Tickler)getHibernateTemplate().get(Tickler.class, id);
    }

    public void addComment(Integer tickler_id, String provider, String message, String status) {
        Tickler tickler = this.getTickler(tickler_id);
        if (tickler != null) {
            TicklerComment comment = new TicklerComment();
            comment.setTickler_no(tickler_id);
            comment.setUpdate_date(new Date());
            comment.setProvider_no(provider);
            comment.setMessage(message);
            comment.setStatus(status);
            tickler.getComments().add(comment);
            tickler.setStatus(status);
            this.saveTickler(tickler);
        }
    }

    public void reassign(Integer tickler_id, String provider, String task_assigned_to) {
        Tickler tickler = this.getTickler(tickler_id);
        if (tickler != null) {
            String message;
            String former_assignee = tickler.getAssignee().getFormattedName();
            String current_assignee;
            tickler.setTask_assigned_to(task_assigned_to);
            TicklerComment comment = new TicklerComment();
            comment.setTickler_no(tickler_id);
            comment.setUpdate_date(new Date());
            comment.setProvider_no(provider);
            current_assignee = ((Provider)(getHibernateTemplate().find("from Provider p where p.ProviderNo = ?", task_assigned_to)).get(0)).getFormattedName();
            message = "RE-ASSIGNMENT RECORD: [Tickler \"" + tickler.getDemographic().getFormattedName() + "\" was reassigned from \"" + former_assignee + "\"  to \"" + current_assignee + "\"]";
            comment.setMessage(message);
            tickler.getComments().add(comment);
            this.saveTickler(tickler);
        }
    }
/*
    public List getTicklers() {
        return (List)getHibernateTemplate().find("from Tickler");
    }
*/
    
    public List getTicklers(CustomFilter filter, Integer shelterId, String providerNo) {
/*
    	String tickler_date_order = filter.getSort_order();
        String query = "from Tickler t where t.service_date >= ? and t.service_date <= ? ";
        ArrayList paramList = new ArrayList();
        query = getTicklerQueryString(query,  paramList,  filter);
        Object params[] = paramList.toArray(new Object[paramList.size()]);
        return (List)getHibernateTemplate().find(query + "order by t.service_date " + tickler_date_order, params);
*/
    	String query;
    	if(filter!=null && filter.getProgramId()!=null && !"".equals(filter.getProgramId())){
            query = "from Tickler t where t.task_assigned_to=" + providerNo + " and t.program_id = " + filter.getProgramId();
        }else{
            query = "from Tickler t where t.task_assigned_to=" + providerNo + " and t.program_id in " + Utility.getUserOrgQueryString(providerNo,shelterId);
        }
    	
        if(filter==null){
           return (List)getHibernateTemplate().find(query + "order by t.service_date");
        }else{
           ArrayList paramList = new ArrayList();
           query = getTicklerQueryString(query,  paramList,  filter);
           Object params[] = paramList.toArray(new Object[paramList.size()]);
           return (List)getHibernateTemplate().find(query + "order by t.service_date", params);
        }
    }
    
    public List getTicklersByClientId(Integer shelterId, String providerNo, Integer clientId) {
    	String clientIds = mergeClientDao.getMergedClientIds(clientId);
        String query = "from Tickler t where t.demographic_no in " + clientIds + " and t.program_id in " + Utility.getUserOrgQueryString(providerNo,shelterId);
        return (List)getHibernateTemplate().find(query + "order by t.id desc, t.service_date desc");
    }

    public int getActiveTicklerCount(String providerNo){
        ArrayList paramList = new ArrayList();
        String query = "select count(*) from Tickler t where t.status = 'A' and t.service_date <= ? and (t.task_assigned_to  = '"+ providerNo + "' or t.task_assigned_to='All Providers')";
        GregorianCalendar currentDate = new GregorianCalendar();
        currentDate.setTime(new Date());
        paramList.add(currentDate.getTime());
        //paramList.add(new Date());
        Object params[] = paramList.toArray(new Object[paramList.size()]);
        Integer count = (Integer) getHibernateTemplate().find(query ,params).get(0);
        return count.intValue();
 }
    
    public int getNumTicklers(CustomFilter filter){
            ArrayList paramList = new ArrayList();
            String query = "select count(*) from Tickler t where t.service_date >= ? and t.service_date <= ? ";   
            query = getTicklerQueryString(query,  paramList,  filter);
            Object params[] = paramList.toArray(new Object[paramList.size()]);
            listParams(params);
            Integer count = (Integer) getHibernateTemplate().find(query ,params).get(0);
            return count.intValue();
     }
    
    private String getTicklerQueryString(String query, List paramList, CustomFilter filter){
//      boolean includeProviderClause = true;
      boolean includeStatusClause = true;
//      boolean includeClientClause = true;
      Date startDt;
      Date endDt;
      
      if (filter.getStartDate() == null || filter.getStartDate().length() == 0) 
    	  startDt = MyDateFormat.getSysDate("1900/01/01");
      else
    	  startDt = filter.getStart_date().getTime();
      if (filter.getEndDate() == null || filter.getEndDate().length() == 0) 
    	  endDt = MyDateFormat.getSysDate("9999/12/31");
      else
    	  endDt = filter.getEnd_date().getTime();

//      if (filter.getProvider() == null || filter.getProvider().equals("All Providers")) includeProviderClause=false;
//      if (filter.getClient() == null || filter.getClient().equals("All Clients")) includeClientClause=false;
      if (filter.getStatus().equals("Any")) includeStatusClause = false;

      query = query + " and t.service_date >= ? and t.service_date <= ?";
	  paramList.add(startDt);
      paramList.add(new Date(endDt.getTime()+DateUtils.MILLIS_PER_DAY));

/*      
      if(includeProviderClause) {
         query = query + " and t.creator IN (";
         Set pset = filter.getProviders();
         Provider[] providers = (Provider[])pset.toArray(new Provider[pset.size()]);
         for(int x=0;x<providers.length;x++) {
           if(x>0) query += ",";
           query += "?";
           paramList.add(providers[x].getProviderNo());
         }
         query += ")";
      }
*/
      
      if(includeStatusClause) {
         query = query + " and t.status = ?";
         paramList.add(String.valueOf(filter.getStatus()));
      }
/*            
      if(includeClientClause) {
         query = query + "and t.demographic_no = ?";
         paramList.add(filter.getClient());
      }
*/
      return query;
    }

    private void listParams(Object params[]){
//        for(Object obj: params){
        for(int i=0;i<params.length;i++){
        	Object obj = params[i]; 
            System.out.print("Object Type:"+obj.getClass().getName());
            System.out.print(" "+obj.toString());
            System.out.println("");
        }
        
    }
    
    
    private void updateTickler(Integer tickler_id, String provider, String status) {
        Tickler tickler = this.getTickler(tickler_id);
        if (tickler != null) {
            tickler.setStatus(status);
/*
            TicklerUpdate update = new TicklerUpdate();
            update.setProvider_no(provider);
            update.setStatus(status);
            update.setTickler_no(tickler_id);
            update.setUpdate_date(new Date());
            tickler.getUpdates().add(update);
*/            
            this.saveTickler(tickler);
        }
    }

    public void completeTickler(Integer tickler_id, String provider) {
        updateTickler(tickler_id, provider, "'Completed");
    }

    public void deleteTickler(Integer tickler_id, String provider) {
//        updateTickler(tickler_id, provider, "D');
    }

    public void activateTickler(Integer tickler_id, String provider) {
        updateTickler(tickler_id, provider, "Active");
    }

}
