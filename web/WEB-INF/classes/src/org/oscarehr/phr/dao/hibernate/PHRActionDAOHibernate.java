/*
 *  Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
 *  This software is published under the GPL GNU General Public License.
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 *  Jason Gallagher
 *
 *  This software was written for the
 *  Department of Family Medicine
 *  McMaster University
 *  Hamilton
 *  Ontario, Canada
 *
 * PHRDocumentDAOHibernate.java
 *
 * Created on May 29, 2007, 4:18 PM
 *
 */

package org.oscarehr.phr.dao.hibernate;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.oscarehr.phr.dao.PHRActionDAO;
import org.oscarehr.phr.model.PHRAction;
import org.oscarehr.phr.PHRConstants;
import org.oscarehr.phr.indivo.IndivoConstantsImpl;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 *
 * @author Paul
 */
public class PHRActionDAOHibernate extends HibernateDaoSupport implements PHRActionDAO {
	
	private static Log log = LogFactory.getLog(PHRActionDAOHibernate.class);
        
     /**
     * Creates a new instance of PHRDocumentDAOHibernate
     */
        public PHRActionDAOHibernate() {
        }

        public List<PHRAction> getQueuedActions(String providerNo){
            PHRConstants phrConstants = new IndivoConstantsImpl(); //put in a clause to send access policies
            String sql = "from PHRAction a where (a.senderOscar = ? OR (a.receiverOscar = ? AND phr_classification = ?)) and a.status = " + PHRAction.STATUS_SEND_PENDING;
            String[] f = new String[3];
            f[0] = providerNo;
            f[1] = providerNo;
            f[2] = phrConstants.DOCTYPE_ACCESSPOLICIES();
            List<PHRAction> list = getHibernateTemplate().find(sql,f);
            return list;
        }
        
        public PHRAction getActionById(String id){ 
            String sql ="from PHRAction a where a.id = ? ";
            
            List<PHRAction> list = getHibernateTemplate().find(sql, new Integer(id));
            
            if (list == null || list.size() == 0){
                return null;
            }
            
            return list.get(0);
        }
        
            //actionType = -1 for all actions
        public List<PHRAction> getPendingActionsByProvider(String classification, int actionType, String providerNo) {
            String sql ="FROM PHRAction a WHERE a.phrClassification = ? AND a.senderOscar = ? AND a.status != " + PHRAction.STATUS_SENT + " AND a.status != " + PHRAction.STATUS_NOT_SENT_DELETED;
            if (actionType != -1) {
                sql = sql + " AND a.actionType = " + actionType;
            }
            String[] f = new String[2];
            f[0] = classification;
            f[1] = providerNo;
            List<PHRAction> list = getHibernateTemplate().find(sql,f);
            
            if (list == null){
                return new ArrayList();
            }
            log.debug("Found pending actions: " + list.size());
            return list;
        }
        
        public List<PHRAction> getPendingActionsByProvider(int actionType, String providerNo) {
            String sql ="FROM PHRAction a WHERE a.senderOscar = ? AND a.status != " + PHRAction.STATUS_SENT + " AND a.status != " + PHRAction.STATUS_NOT_SENT_DELETED;
            if (actionType != -1) {
                sql = sql + " AND a.actionType = " + actionType;
            }
            String[] f = new String[2];
            f[0] = providerNo;
            List<PHRAction> list = getHibernateTemplate().find(sql,f);
            
            if (list == null){
                return new ArrayList();
            }
            log.debug("Found pending actions: " + list.size());
            return list;
            
        }
        
        public List<PHRAction> getActionsByStatus(int status, String providerNo) {
            String sql ="FROM PHRAction a WHERE a.receiverOscar = ? AND a.status = " + status;
            String[] f = new String[1];
            f[0] = providerNo;
            List<PHRAction> list = getHibernateTemplate().find(sql,f);
            
            if (list == null){
                return new ArrayList();
            }
            return list;
        }
        
        public List<PHRAction> getActionsByStatus(int status, String providerNo, String classification) {
            String sql ="FROM PHRAction a WHERE a.receiverOscar = ? AND a.phrClassification = ? AND a.status = " + status;
            String[] f = new String[2];
            f[0] = providerNo;
            f[1] = classification;
            List<PHRAction> list = getHibernateTemplate().find(sql,f);
            
            if (list == null){
                return new ArrayList();
            }
            return list;
        }
        
        public List<PHRAction> getActionsByStatus(List<Integer> statuses, String providerNo, String classification) {
            String sql ="FROM PHRAction a WHERE a.receiverOscar = ? AND a.phrClassification = ?";
            if (statuses != null && !statuses.isEmpty()) {
                sql += " AND (";
                for (int i=0; i<statuses.size(); i++) {
                    sql += "a.status = " + statuses.get(i);
                    if (i != statuses.size()-1) sql += " OR ";
                }
                sql += ")";
            }
            sql += "ORDER BY a.status";
            //System.out.println(sql);
            String[] f = new String[2];
            f[0] = providerNo;
            f[1] = classification;
            List<PHRAction> list = getHibernateTemplate().find(sql,f);
            
            if (list == null){
                return new ArrayList();
            }
            return list;
        }
            
            
        public boolean ifActionsWithErrors(final String providerNo) {
            Long num =  (Long) getHibernateTemplate().execute(new HibernateCallback() {
                public Object doInHibernate(Session session) throws HibernateException, SQLException {
                Query q = session.createQuery("select count(*) from PHRAction a where a.senderOscar = '" + providerNo + "' AND a.status=" + PHRAction.STATUS_NOT_AUTHORIZED);
                q.setCacheable(true);
                return q.uniqueResult();
                }
            });
            if (num > 0) return true;
            return false;
        }
        
        
        public void save(PHRAction action) {
            this.getHibernateTemplate().save(action);
	}

        public Integer saveAndGetId(PHRAction action) {
            this.save(action);
            this.getHibernateTemplate().refresh(action);
            return action.getId();
        }
        
        public void update(PHRAction action) {
            this.getHibernateTemplate().update(action);
        }
    
        public void updatePhrIndexes(String classification, String oscarId, String providerNo, String newPhrIndex) {
            HibernateTemplate ht = getHibernateTemplate();
            String sql ="FROM PHRAction a WHERE a.phrClassification = ? AND a.oscarId = ? AND a.senderOscar = ? AND a.status = " + PHRAction.STATUS_SEND_PENDING;
            String[] f = new String[3];
            f[0] = classification;
            f[1] = oscarId;
            f[2] = providerNo;
            List<PHRAction> list = ht.find(sql,f);
            for (PHRAction action :list) {
                action.setPhrIndex(newPhrIndex);
                ht.update(action);
            }
        }
        
        //get indivo idx
        
        //checks to see whether this document has been sent to indivo before (for update/add decision)
        public boolean isIndivoRegistered(final String classification, final String oscarId) {
            Long num =  (Long) getHibernateTemplate().execute(new HibernateCallback() {
                public Object doInHibernate(Session session) throws HibernateException, SQLException {
                Query q = session.createQuery("select count(*) from PHRAction a where a.phrClassification = '" + classification + "' and a.oscarId = '" + oscarId + "'");
                q.setCacheable(true);
                return q.uniqueResult();
                }
            });
            if (num > 0) return true;
            return false;
            
            /*System.out.println("starting isIndivoReg");
            List<PHRAction> list = this.getSession().createCriteria(PHRAction.class)
                   .add(Restrictions.eq("phrClassification", classification))
                   .add(Restrictions.eq("oscarId", oscarId))
                   .setMaxResults(1)
                   .list();
            System.out.println("listFirst");
            System.out.println("closing conn");
            if (list.size() > 0) return true;
            return false;*/
        }
        
        /*public boolean isIndivoRegistered(String classification, String oscarId) {
            String sql = "FROM PHRAction a WHERE a.phrClassification = ? AND a.oscarId = ? AND a.sent = " + PHRAction.STATUS_SENT;
            String[] f = new String[2];
            f[0] = classification;
            f[1] = oscarId;
            List<PHRAction> list = this.getHibernateTemplate().find(sql, f);
            if (list.size() > 0) return true;
            return false; 
        }*/
       
        
        public String getPhrIndex(final String classification, final String oscarId) {
            List<PHRAction> list = (List<PHRAction>) getHibernateTemplate().execute(new HibernateCallback() {
                public Object doInHibernate(Session session) throws HibernateException, SQLException {
                Criteria criteria = session.createCriteria(PHRAction.class);
                criteria.add(Restrictions.eq("phrClassification", classification));
                criteria.add(Restrictions.eq("oscarId", oscarId));
                criteria.add(Restrictions.eq("status", PHRAction.STATUS_SENT));
                criteria.setMaxResults(1);
                return criteria.list();
                }
            });
            if (list.size() > 0) return list.get(0).getPhrIndex();
            return null;
            
            /*Criteria criteria = this.getSession().createCriteria(PHRAction.class);
            criteria.add(Restrictions.eq("phrClassification", classification));
            criteria.add(Restrictions.eq("oscarId", oscarId));
            criteria.add(Restrictions.eq("sent", PHRAction.STATUS_SENT));
            criteria.setMaxResults(1);
            List<PHRAction> list = criteria.list();
            if (list.size() > 0) return list.get(0).getPhrIndex();
            return null;*/
        }
        
        /*public String getPhrIndex(String classification, String oscarId) {
            String sql = "FROM PHRAction a WHERE a.phrClassification = ? AND a.oscarId = ? AND a.sent = 1 LIMIT 1";
            String[] f = new String[2];
            f[0] = classification;
            f[1] = oscarId;
            List<PHRAction> list = this.getHibernateTemplate().find(sql, f);
            if (list.size() > 0) return list.get(0).getPhrIndex();
            return null;
        }*/
}