/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.oscarehr.common.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.criterion.Expression;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.oscarehr.common.model.Billingreferral;
import org.oscarehr.util.MiscUtils;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 *
 * @author Toby
 */
public class BillingreferralDao extends HibernateDaoSupport {

	 public Billingreferral getByReferralNo(String referral_no) {
		 String sql = "From Billingreferral br WHERE br.referralNo=?";

		 @SuppressWarnings("unchecked")
		 List<Billingreferral> brs = this.getHibernateTemplate().find(sql,referral_no);
		 if(!brs.isEmpty())
			 return brs.get(0);
		 return null;
	 }

	 public Billingreferral getById(int id) {
		 return (Billingreferral)this.getHibernateTemplate().get(Billingreferral.class, id);
	 }

    public List getBillingreferral(String referral_no) {

        List cList = null;
        Session session = null;
        try {
            session = getSession();
            cList = session.createCriteria(Billingreferral.class).add(Expression.eq("referralNo", referral_no)).addOrder(Order.asc("referralNo")).list();
        } catch (Exception e) {
            MiscUtils.getLogger().error("Error", e);
        } finally {
            if (session != null) {
                releaseSession(session);
            }
        }

        if (cList != null && cList.size() > 0) {
            return cList;
        } else {
            return null;
        }
    }

    public List<Billingreferral> getBillingreferral(String last_name, String first_name) {

        List cList = null;
        Session session = null;
        try {
            session = getSession();
            cList = session.createCriteria(Billingreferral.class).add(Restrictions.like("lastName", "%" + last_name + "%")).add(Restrictions.like("firstName", "%" + first_name + "%")).addOrder(Order.asc("lastName")).list();
        } catch (Exception e) {
            MiscUtils.getLogger().error("Error", e);
        } finally {
            if (session != null) {
                releaseSession(session);
            }
        }

        if (cList != null && cList.size() > 0) {
            return cList;
        } else {
            return null;
        }
    }

    public void updateBillingreferral(Billingreferral obj) {
    	if(obj.getBillingreferralNo() == null || obj.getBillingreferralNo().intValue() == 0) {
    		getHibernateTemplate().save(obj);
    	} else {
    		getHibernateTemplate().update(obj);
    	}
    }
}