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

package org.oscarehr.PMmodule.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.oscarehr.PMmodule.model.ClientHistory;
import org.oscarehr.PMmodule.model.ClientHistoryFilter;
import org.oscarehr.PMmodule.model.ClientReferral;
import org.oscarehr.PMmodule.model.QuatroIntake;
import org.oscarehr.PMmodule.model.Admission;
import com.quatro.dao.LookupDao;
import com.quatro.model.LookupCodeValue;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import java.util.Calendar;
import com.quatro.util.Utility;
import org.apache.struts.util.LabelValueBean;

import oscar.MyDateFormat;

public class ClientHistoryDao extends HibernateDaoSupport {

    private Logger log = LogManager.getLogger(getClass());
    private MergeClientDao mergeClientDao;
    private LookupDao lookupDao; 

    public List getClientHistories(Integer clientId, String providerNo, 
    		Integer shelterId, ClientHistoryFilter filter) {
    	String clientIds =mergeClientDao.getMergedClientIds(clientId);
    	clientIds=clientIds.substring(1,clientIds.length()-1);
    	String[] cIds= clientIds.split(",");
    	Object[] clients=new Object[cIds.length];
    	for(int i=0;i<cIds.length;i++){
    		clients[i] =Integer.valueOf(cIds[i]);
    	}
    	String orgSql = Utility.getUserOrgSqlString(providerNo, shelterId);
        Criteria criteria = getSession().createCriteria(ClientHistory.class);
        String sql = "(program_id in " + orgSql + " or program_id2 in " + orgSql + ")"; 
        criteria.add(Restrictions.sqlRestriction(sql));
        criteria.add(Restrictions.in("ClientId", clients));
        if(filter.getActionTxt()!=null){
          criteria.add(Restrictions.eq("Action", filter.getActionTxt()));
        }
        if(filter.getProgramId()!=null){
            criteria.add(Restrictions.eq("ProgramId", filter.getProgramId()));
        }
        String sDt = MyDateFormat.getStandardDateTime(filter.getActionStartDate());
        String eDt = MyDateFormat.getStandardDateTime(filter.getActionEndDate());
        if(filter.getActionStartDate()!=null){
            criteria.add(Restrictions.ge("ActionDate", MyDateFormat.getDayStart(filter.getActionStartDate())));
        }
        if(filter.getActionEndDate()!=null){
            criteria.add(Restrictions.le("ActionDate", MyDateFormat.getDayEnd(filter.getActionEndDate())));
        }
  //      criteria.addOrder(Order.desc("ActionDate"));
//        criteria.addOrder(Order.asc("Action"));
        criteria.addOrder(Order.desc("HistoryDate"));
        List results = criteria.list();
        
        if (log.isDebugEnabled()) {
            log.debug("getReferrals: # of results=" + results.size());
        }

        return results;
    }

    public List getClientHistoryPrograms(Integer clientId, String providerNo, 
    		Integer shelterId, ClientHistoryFilter filter) {
    	String clientIds =mergeClientDao.getMergedClientIds(clientId);
    	clientIds=clientIds.substring(1,clientIds.length()-1);
    	String[] cIds= clientIds.split(",");
    	Object[] clients=new Object[cIds.length];
    	for(int i=0;i<cIds.length;i++){
    		clients[i] =Integer.valueOf(cIds[i]);
    	}
    	String orgSql = Utility.getUserOrgSqlString(providerNo, shelterId);
    	String programIds="";
    	List programIdLst = getSession().createSQLQuery(orgSql).list();
    	for(int i=0;i<programIdLst.size();i++){
    		if(i==0){
    		  programIds = programIdLst.get(i).toString();
    		}else{
      		  programIds += "," + programIdLst.get(i).toString();
    		}
    	}

    	if(!programIds.equals("")){
    	  String sql = "select distinct h.ProgramId, h.ProgramName from ClientHistory h where ClientId=? and (h.ProgramId in (" + programIds + ") or h.ProgramId2 in (" + programIds + ")) order by h.ProgramName"; 
          List results = getHibernateTemplate().find(sql, clientId);
          ArrayList lst = new ArrayList();
          lst.add(new LabelValueBean("", ""));
          for(int i=0;i<results.size();i++){
        	Object oo[] = (Object[]) results.get(i); 
            lst.add(new LabelValueBean((String)oo[1], ((Integer)oo[0]).toString()));
       	  }
          return lst;
    	}else{
          return new ArrayList();    	  
    	}

    }

    public List getClientHistories(ClientHistory his) {
    	String clientIds =mergeClientDao.getMergedClientIds(his.getClientId());
    	clientIds=clientIds.substring(1,clientIds.length()-1);
    	String[] cIds= clientIds.split(",");
    	Object[] clients=new Object[cIds.length];
    	for(int i=0;i<cIds.length;i++){
    		clients[i] =Integer.valueOf(cIds[i]);
    	}
    	String orgSql = Utility.getUserOrgSqlString(his.getProviderNo(), new Integer(0));
        Criteria criteria = getSession().createCriteria(ClientHistory.class);
        String sql = "(program_id in " + orgSql + " or program_id2 in " + orgSql + ")"; 
        criteria.add(Restrictions.sqlRestriction(sql));
        criteria.add(Restrictions.in("ClientId", clients));
        criteria.add(Restrictions.eq("Action", his.getAction()));
        criteria.add(Restrictions.eq("ActionDate", his.getActionDate()));
        criteria.add(Restrictions.eq("Notes", his.getNotes()));
        criteria.add(Restrictions.eq("ProviderNo", his.getProviderNo()));

     //   criteria.addOrder(Order.desc("ActionDate"));
        List results = criteria.list();
        
        if (log.isDebugEnabled()) {
            log.debug("getReferrals: # of results=" + results.size());
        }

        return results;
    }

    public void saveClientHistory(ClientHistory history) {
        if (history == null) {
            throw new IllegalArgumentException();
        }
//        List lhis = getClientHistories(history);
//        if (lhis.size() > 0) return;

        this.getHibernateTemplate().saveOrUpdate(history);

        if (log.isDebugEnabled()) {
            log.debug("saveClientReferral: id=" + history.getId());
        }

    }
    public void saveClientHistory(ClientReferral referral) {
        if (referral == null) {
            return;
        }
        ClientHistory history = new ClientHistory();
        history.setClientId(referral.getClientId());
        history.setAction("Referral");
        history.setActionDate(referral.getReferralDate());
        history.setHistoryDate(Calendar.getInstance().getTime());
        history.setNotes(referral.getNotes());
        history.setProgramId(referral.getProgramId());
        history.setProgramId2(referral.getFromProgramId());
        history.setProviderNo(referral.getProviderNo());
        saveClientHistory(history);

        if (log.isDebugEnabled()) {
            log.debug("saveClientReferral: id=" + history.getId());
        }
    }
    
    public void saveClientHistory(QuatroIntake intake)  {
        if (intake == null) {
            return;
        }
        try {
	        ClientHistory history = new ClientHistory();
	        history.setClientId(intake.getClientId());
	        history.setAction("Intake");
	        history.setActionDate(intake.getCreatedOn());
	        history.setHistoryDate(Calendar.getInstance().getTime());
	        LookupCodeValue referedBy = lookupDao.GetCode("RFB", intake.getReferredBy()); 
	        if (referedBy != null) history.setNotes("Referred by: " + referedBy.getDescription());
	        history.setProgramId(intake.getProgramId());
	        history.setProviderNo(intake.getStaffId());
	       
	        saveClientHistory(history);
	
	        if (log.isDebugEnabled()) {
	            log.debug("saveClientReferral: id=" + history.getId());
	        }
        }
		catch(SQLException e)
		{
			return;
		}
    }
    
    public void saveClientHistory( Admission admission, String room, String bed) {
        if (admission == null) {
            return;
        }
        try {
	        ClientHistory history = new ClientHistory();
	        history.setId(new Integer(0));
	        history.setClientId(admission.getClientId());
	        if ("admitted".equals(admission.getAdmissionStatus())) {
	        	history.setAction("Admit/Bed Assignment");
	        	history.setActionDate(Calendar.getInstance());
	        	history.setHistoryDate(Calendar.getInstance().getTime());
	        	LookupCodeValue provider = lookupDao.GetCode("USR", admission.getPrimaryWorker());
	        	String notes = "";
	        	if(provider != null) notes += " Primary Worker: " + provider.getDescription();
	        	if (room != null) notes = Utility.append(notes,  "Room: " + room, ", ");
	        	if (bed != null) notes = Utility.append(notes,"Bed: " + bed,  ", ");
	        	history.setNotes(notes);
	        	history.setProgramId(admission.getProgramId());
	        	history.setProviderNo(admission.getProviderNo());
	        }
	        else if("discharged".equals(admission.getAdmissionStatus()))
	        {
	            history.setAction("Discharge");
	            if(admission.getDischargeDate()!=null) history.setActionDate(admission.getDischargeDate());
	            history.setHistoryDate(Calendar.getInstance().getTime());
	            LookupCodeValue dischargeReason = lookupDao.GetCode("DRN", admission.getDischargeReason());
	            if(dischargeReason!=null){
	            	history.setNotes("Discharge Reason: " + dischargeReason.getDescription());
	            }else{
	            	history.setNotes("Discharge Reason: ");
	            }
	            history.setProgramId(admission.getProgramId());
	            history.setProviderNo(admission.getProviderNo());
	        }
	        history.setHistoryDate(Calendar.getInstance().getTime());
	        saveClientHistory(history);
	
	        if (log.isDebugEnabled()) {
	            log.debug("saveClientReferral: id=" + history.getId());
	        }
        }
		catch(SQLException e)
		{
			return;
		}
    }

	public void setMergeClientDao(MergeClientDao mergeClientDao) {
		this.mergeClientDao = mergeClientDao;
	}
	public void setLookupDao(LookupDao lookupDao) {
		this.lookupDao = lookupDao;
	}
}
