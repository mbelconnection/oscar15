/*
 *
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
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
 * Jason Gallagher
 *
 * UserPropertyDAO.java
 *
 * Created on December 19, 2007, 4:29 PM
 *
 *
 *
 */

package org.oscarehr.common.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.oscarehr.common.model.Provider;
import org.oscarehr.common.model.Site;
import org.oscarehr.util.MiscUtils;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * 
 * @author Victor Weng
 */
public class SiteDao extends HibernateDaoSupport {

	/** Creates a new instance of UserPropertyDAO */
	public SiteDao() {
	}

	public void save(Site s) {
		boolean isUpdate = s.getSiteId() != null && s.getSiteId() > 0;
		if (isUpdate) {
			Site old = (Site) getHibernateTemplate().get(Site.class,
					s.getSiteId());
			if (!old.getName().equals(s.getName())) {
				// site name changed, need to update all references as it serves as PK
				// so we need to update the tables that references to the site
				Session sess = getSession();
				try {
					sess.createSQLQuery(
									"update rschedule set avail_hour = replace(avail_hour, :oldname, :newname) ")
							.setParameter("oldname", ">"+old.getName()+"<")
							.setParameter("newname", ">"+s.getName()+"<").executeUpdate();
					sess.createSQLQuery(
									"update scheduledate set reason = :newname where reason = :oldname ")
							.setParameter("oldname", old.getName())
							.setParameter("newname", s.getName()).executeUpdate();
					sess.createSQLQuery(
									"update appointment set location = :newname where location = :oldname ")
							.setParameter("oldname", old.getName())
							.setParameter("newname", s.getName()).executeUpdate();
					sess.createSQLQuery(
									"update billing_on_cheader1 set clinic = :newname where clinic = :oldname ")
							.setParameter("oldname", old.getName())
							.setParameter("newname", s.getName()).executeUpdate();
				} catch (Exception e) {
					MiscUtils.getLogger().error("Error", e);
				} finally {
					try {
						sess.close();
					} catch (HibernateException e) {
						MiscUtils.getLogger().error("Error", e);
					}
				}
						
			}
		}

		getHibernateTemplate().merge(s);

	}

	public List<Site> getAllSites() {
		List rs = getHibernateTemplate().find("from Site s order by s.name");
		return rs;
	}

	public List<Site> getAllActiveSites() {
		List rs = getHibernateTemplate().find(
				"from Site s where s.status=1 order by s.name");
		return rs;
	}

	public List<Site> getActiveSitesByProviderNo(String provider_no) {
		Provider p = (Provider) getHibernateTemplate().get(Provider.class,
				provider_no);

		List<Site> rs = new ArrayList(p.getSites());
		Iterator<Site> it = rs.iterator();
		while (it.hasNext()) {
			Site site = (Site) it.next();
			// remove inactive sites
			if (site.getStatus() == 0)
				it.remove();
		}

		Collections.sort(rs, new Comparator<Site>() {
			public int compare(Site o1, Site o2) {
				return o1.getName().compareTo(o2.getName());
			}
		});

		return rs;
	}

	public Site getById(Integer id) {
		return (Site) getHibernateTemplate().get(Site.class, id);
	}
	
	public Site getByLocation(String location) {
		List<Site> rs = getHibernateTemplate().find(
				"from Site s where s.name=?", location);
		if (rs.size()>0)
			return rs.get(0);
		else
			return null;
	}

	public List<String> getGroupBySiteLocation(String location) {
		List<String> groupList = new ArrayList<String>();
		Session sess = getSession();
		try {
			SQLQuery  q = sess.createSQLQuery(
					"select distinct g.mygroup_no from mygroup g	" +
					" inner join provider p on p.provider_no = g.provider_no and p.status = 1 " +
					" inner join providersite ps on ps.provider_no = g.provider_no " +
					" inner join site s on s.site_id = ps.site_id " +
					" where  s.name = :sitename ") ;
			q.setParameter("sitename", location);
			q.addScalar("mygroup_no", Hibernate.STRING);			
			groupList = q.list();

		} catch (Exception e) {
			MiscUtils.getLogger().error("Error", e);
		} finally {
			try {
				sess.close();
			} catch (HibernateException e) {
				MiscUtils.getLogger().error("Error", e);
			}
		}		
		return groupList;
	}
	
	public List<String> getProviderNoBySiteLocation(String location) {
		List<String> pList = new ArrayList<String>();
		Session sess = getSession();
		try {
			SQLQuery  q = sess.createSQLQuery(
					"select distinct p.provider_no	" +
					" from provider p " +
					" inner join providersite ps on ps.provider_no = p.provider_no " +
					" inner join site s on s.site_id = ps.site_id " +
					" where  s.name = :sitename ") ;
			q.setParameter("sitename", location);
			q.addScalar("provider_no", Hibernate.STRING);			
			pList = q.list();

		} catch (Exception e) {
			MiscUtils.getLogger().error("Error", e);
		} finally {
			try {
				sess.close();
			} catch (HibernateException e) {
				MiscUtils.getLogger().error("Error", e);
			}
		}		
		return pList;
	}
	
	public List<String> getProviderNoBySiteManagerProviderNo(String providerNo) {
		List<String> pList = new ArrayList<String>();
		Session sess = getSession();
		try {
			SQLQuery  q = sess.createSQLQuery(
					"select distinct p.provider_no	" +
					" from provider p " +
					" inner join providersite ps on ps.provider_no = p.provider_no " +
					" where ps.site_id in (select site_id from providersite where provider_no = :providerno)");
			q.setParameter("providerno", providerNo);
			q.addScalar("provider_no", Hibernate.STRING);			
			pList = q.list();
		} catch (Exception e) {
			MiscUtils.getLogger().error("Error", e);
		} finally {
			try {
				sess.close();
			} catch (HibernateException e) {
				MiscUtils.getLogger().error("Error", e);
			}
		}		
		return pList;
	}	
	
	public List<String> getGroupBySiteManagerProviderNo(String providerNo) {
		List<String> groupList = new ArrayList<String>();
		Session sess = getSession();
		try {
			SQLQuery  q = sess.createSQLQuery(
					"select distinct g.mygroup_no from mygroup g	" +
					" inner join provider p on p.provider_no = g.provider_no and p.status = 1 " +
					" inner join providersite ps on ps.provider_no = g.provider_no " +
					" where ps.site_id in (select site_id from providersite where provider_no = :providerno)");
			q.setParameter("providerno", providerNo);
			q.addScalar("mygroup_no", Hibernate.STRING);			
			groupList = q.list();
		
		} catch (Exception e) {
			MiscUtils.getLogger().error("Error", e);
		} finally {
			try {
				sess.close();
			} catch (HibernateException e) {
				MiscUtils.getLogger().error("Error", e);
			}
		}		
		return groupList;
	}
	
	public String getSiteNameByAppointmentNo(String appointmentNo) {
		String siteName="";
		Session sess = getSession();
		try {
			SQLQuery  q = sess.createSQLQuery("select location from appointment where appointment_no = :appointmentno");
			q.setParameter("appointmentno", appointmentNo);
			q.addScalar("location", Hibernate.STRING);			
			siteName = (String)q.list().get(0);
		
		} catch (Exception e) {
			MiscUtils.getLogger().error("Error", e);
		} finally {
			try {
				sess.close();
			} catch (HibernateException e) {
				MiscUtils.getLogger().error("Error", e);
			}
		}		
		return siteName;		
	}
}