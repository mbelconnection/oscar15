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


package org.oscarehr.casemgmt.dao;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;
//TODO import java.util.UUID;
import com.ibm.ws.util.UUID;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.FetchMode;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Expression;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.oscarehr.PMmodule.dao.MergeClientDao;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.casemgmt.model.CaseManagementNote;
import org.oscarehr.casemgmt.model.CaseManagementSearchBean;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.quatro.common.KeyConstants;
import com.quatro.util.*;

import oscar.MyDateFormat;
import oscar.OscarProperties;

public class CaseManagementNoteDAO extends HibernateDaoSupport {
	
	private static Logger log = LogManager.getLogger(CaseManagementNoteDAO.class);   
	private MergeClientDao mergeClientDao;	
        
        public List getEditors(CaseManagementNote note) {
            String uuid = note.getUuid();
            String hql = "select distinct p from Provider p, CaseManagementNote cmn where p.ProviderNo = cmn.provider_no and cmn.uuid = ?";
            return this.getHibernateTemplate().find(hql,uuid);
        }

        public List getHistory(CaseManagementNote note) {
            String uuid = note.getUuid();
            return this.getHibernateTemplate().find("from CaseManagementNote cmn where cmn.uuid = ? order by cmn.update_date asc", uuid);
        }

	public CaseManagementNote getNote(Integer id) {
		CaseManagementNote note = (CaseManagementNote)this.getHibernateTemplate().get(CaseManagementNote.class,id);		
		getHibernateTemplate().initialize(note.getIssues());
		return note;
	}
        
        public List getNotesByDemographic(String demographic_no,String[] issues, String staleDate) {
            String list = null;
            if(issues != null && issues.length>0) {
                    list="";
                    for(int x=0;x<issues.length;x++) {
                            if(x!=0) {
                                    list += ",";
                            }
                            list += issues[x];
                    }
            }
            
            Date d;
            try {
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
                d = formatter.parse(staleDate);
            }
            catch(ParseException e) {
                GregorianCalendar cal = new GregorianCalendar(1970,1,1);
                d = cal.getTime();
                //e.printStackTrace();
            }
            String clientIds =mergeClientDao.getMergedClientIds(Integer.valueOf(demographic_no));
            String hql = "select distinct cmn from CaseManagementNote cmn join cmn.issues i where i.issue_id in (" + list + ") and cmn.demographic_no in "+clientIds+"  and cmn.id in (select max(cmn.id) from cmn where cmn.observation_date >= ? GROUP BY uuid) ORDER BY cmn.observation_date asc";            
             
          
            List result=getHibernateTemplate().find(hql,d);
            return result;
        }
               
        
        public List getNotesByDemographic(Integer clientId, String staleDate,Integer shelterId,String providerNo) {
        	if(shelterId==null || shelterId.intValue()==0)
        		return this.getHibernateTemplate().findByNamedQuery("mostRecentNotesAll",new Object[]{clientId,staleDate,providerNo});
        	else return this.getHibernateTemplate().findByNamedQuery("mostRecentNotes",new Object[]{clientId,staleDate,shelterId,providerNo});
        }
	
	//This was created by OSCAR. if all notes' UUID are same like null, it will only get one note.
	
	 
        public List getNotesByDemographic(Integer clientId,Integer shelterId,String providerNo){
        	if(shelterId==null || shelterId.intValue()==0) return this.getHibernateTemplate().findByNamedQuery("mostClientRecentNotesAll",new Object[]{clientId,providerNo});
        	else return this.getHibernateTemplate().findByNamedQuery("mostClientRecentNotes",new Object[]{clientId,shelterId,providerNo});        		
        }
        public List getNoteIdsByDemographic(Integer clientId,Integer shelterId,String providerNo){
        	if(shelterId==null || shelterId.intValue()==0)return this.getHibernateTemplate().findByNamedQuery("mostRecentNoteIdsAll", new Object[]{clientId,providerNo});
        	else return this.getHibernateTemplate().findByNamedQuery("mostRecentNoteIds", new Object[]{clientId,shelterId,providerNo});
        }
	 //This is the original method. It was created by CAISI, to get all notes for each client.
	/*public List getNotesByDemographic(String demographic_no) {
		return this.getHibernateTemplate().find("from CaseManagementNote cmn where cmn.demographic_no = ? ORDER BY cmn.update_date DESC", new Object[] {demographic_no});
	}
	 public List getNotesByDemographic(String demographic_no, String staleDate) {
     	if (OscarProperties.getInstance().getDbType().equals("oracle")) {
     		return this.getHibernateTemplate().findByNamedQuery("mostRecentTimeOra", new Object[] {demographic_no, staleDate});
     	}
     	else
     	{
             return this.getHibernateTemplate().findByNamedQuery("mostRecentTime", new Object[] {demographic_no, staleDate});
     	}
     }
     */
	
	//This was created by OSCAR. if all notes' UUID are same like null, it will only get one note.
	/*
    public List getNotesByDemographic(String demographic_no) {            
		  	if (OscarProperties.getInstance().getDbType().equals("oracle")) {
		        return this.getHibernateTemplate().findByNamedQuery("mostRecentOra", new Object[] {demographic_no});
		  	}
		  	else
		  	{
		         return this.getHibernateTemplate().findByNamedQuery("mostRecent", new Object[] {demographic_no});
		  	}
	}
	*/
	public List getNotesByDemographic(String demographic_no,String[] issues) {
            String list = null;
            if(issues != null && issues.length>0) {
                    list="";
                    for(int x=0;x<issues.length;x++) {
                            if(x!=0) {
                                    list += ",";
                            }
                            list += issues[x];
                    }
            }
            //String hql = "select distinct cmn from CaseManagementNote cmn where cmn.demographic_no = ? and cmn.issues.issue_id in (" + list + ") and cmn.id in (select max(cmn.id) from cmn GROUP BY uuid) ORDER BY cmn.observation_date asc";
            String clientIds =mergeClientDao.getMergedClientIds(Integer.valueOf(demographic_no));
            String hql = "select distinct cmn from CaseManagementNote cmn join cmn.issues i where i.issue_id in (" + list + ") and cmn.demographic_no in "+clientIds+" and cmn.id in (select max(cmn.id) from cmn GROUP BY uuid) ORDER BY cmn.observation_date asc";
            return this.getHibernateTemplate().find(hql);
	}

	public void saveNote(CaseManagementNote note) {
                if( note.getUuid() == null ) {
                    UUID uuid = new UUID();
                    // UUID uuid =UUID.randomUUID();
                    note.setUuid(uuid.toString());
                }
		this.getHibernateTemplate().saveOrUpdate(note);
	}

	public List search(CaseManagementSearchBean searchBean) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		
		Criteria criteria = getSession().createCriteria(CaseManagementNote.class);
		//criteria.createCriteria("issues");
		criteria.setFetchMode("issues", FetchMode.JOIN);
		criteria.createAlias("issues", "a1");
		String clientIds =mergeClientDao.getMergedClientIds(Integer.valueOf(searchBean.getDemographicNo()));
		clientIds =clientIds.substring(1,clientIds.length()-1);
		String[] cIds =clientIds.split(",");
		Integer[] demoIds = new Integer[cIds.length];
		for(int i=0;i<cIds.length;i++){
			demoIds[i] = new Integer(cIds[i]);
		}
		criteria.add(Expression.in("demographic_no", demoIds));		
		if(!Utility.IsEmpty(searchBean.getSearchProviderNo()))
		{
			criteria.add(Expression.eq("provider_no", String.valueOf(searchBean.getSearchProviderNo())));
		}
		// TODO  How to add issue criteria here
		
		if(!Utility.IsEmpty(searchBean.getSearchServiceComponent())){
			criteria.add(Expression.eq("a1.issue_id", Integer.valueOf(searchBean.getSearchServiceComponent())));
		}		
		try {
			java.sql.Date startDate;
			java.sql.Date endDate;
			if(searchBean.getSearchStartDate().length()>0) {
				//startDate = formatter.parse(searchBean.getSearchStartDate());				
				startDate=MyDateFormat.dayStart(searchBean.getSearchStartDate());
			} else {
				//startDate = formatter.parse("1970-01-01");
				startDate = MyDateFormat.getSysDate("1970/01/01");
			}
			if(searchBean.getSearchEndDate().length()>0) {
				//endDate = formatter.parse(searchBean.getSearchEndDate());				
				endDate=MyDateFormat.dayEnd(searchBean.getSearchEndDate());
			} else {
				endDate = MyDateFormat.getCurrentDate();
			}
			criteria.add(Restrictions.between("observation_date",startDate,endDate));
		}catch(Exception e) {
			log.warn(e);
		}
		if(!Utility.IsEmpty(searchBean.getSearchCaseStatus())){
			criteria.add(Expression.eq("caseStatusId", Integer.valueOf(searchBean.getSearchCaseStatus())));
		}
		criteria.addOrder(Order.desc("observation_date"));
		criteria.setResultTransformer(CriteriaSpecification.DISTINCT_ROOT_ENTITY);
//		List lst=criteria.list();
		return criteria.list();
		
	}
	
	public List getAllNoteIds() {
		List results = this.getHibernateTemplate().find("select n.id from CaseManagementNote n");
		return results;
	}

	public void setMergeClientDao(MergeClientDao mergeClientDao) {
		this.mergeClientDao = mergeClientDao;
	}
}
