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
import java.util.Date;
import java.util.List;
import java.util.ListIterator;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.oscarehr.PMmodule.dao.AdmissionDao;
import org.oscarehr.PMmodule.dao.ProgramDao;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.PMmodule.model.AdmissionSearchBean;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class AdmissionDaoHibernate extends HibernateDaoSupport implements AdmissionDao {

	private Log log = LogFactory.getLog(AdmissionDaoHibernate.class);
	
	public List getAdmissions_archiveView(Integer programId, Integer demographicNo) {
		Admission admission = null;

		if (programId == null || programId <= 0) {
			throw new IllegalArgumentException();
		}

		if (demographicNo == null || demographicNo <= 0) {
			throw new IllegalArgumentException();
		}

		String queryStr = "FROM Admission a WHERE admission_status='discharged' and a.ProgramId=? AND a.ClientId=? order by am_id DESC";
		List rs = getHibernateTemplate().find(queryStr, new Object[] { programId, demographicNo });
		/*
		if (!rs.isEmpty()) {
			admission = ((Admission) rs.get(0));
		}
		 */
		if (log.isDebugEnabled()) {
			log.debug((admission != null) ? "getAdmission:" + admission.getId() : "getAdmission: not found");
		}

		return rs;
	}
	public Admission getAdmission(Integer programId, Integer demographicNo) {
		Admission admission = null;

		if (programId == null || programId <= 0) {
			throw new IllegalArgumentException();
		}

		if (demographicNo == null || demographicNo <= 0) {
			throw new IllegalArgumentException();
		}

		String queryStr = "FROM Admission a WHERE a.ProgramId=? AND a.ClientId=?";
		List rs = getHibernateTemplate().find(queryStr, new Object[] { programId, demographicNo });

		if (!rs.isEmpty()) {
			admission = ((Admission) rs.get(0));
		}

		if (log.isDebugEnabled()) {
			log.debug((admission != null) ? "getAdmission:" + admission.getId() : "getAdmission: not found");
		}

		return admission;
	}

	public Admission getCurrentAdmission(Integer programId, Integer demographicNo) {
		Admission admission = null;

		if (programId == null || programId <= 0) {
			throw new IllegalArgumentException();
		}

		if (demographicNo == null || demographicNo <= 0) {
			throw new IllegalArgumentException();
		}

		String queryStr = "FROM Admission a WHERE a.ProgramId=? AND a.ClientId=? AND a.AdmissionStatus='current' ORDER BY a.AdmissionDate DESC";
		List rs = getHibernateTemplate().find(queryStr, new Object[] { programId, demographicNo });

		if (!rs.isEmpty()) {
			admission = ((Admission) rs.get(0));
		}

		if (log.isDebugEnabled()) {
			log.debug((admission != null) ? "getCurrentAdmission:" + admission.getId() : "getCurrentAdmission: not found");
		}

		return admission;
	}

	public List getAdmissions() {
		String queryStr = "FROM Admission a ORDER BY a.AdmissionDate DESC";
		List rs = getHibernateTemplate().find(queryStr);

		if (log.isDebugEnabled()) {
			log.debug("getAdmissions # of admissions: " + rs.size());
		}

		return rs;
	}

	public List getAdmissions(Integer demographicNo) {
		if (demographicNo == null || demographicNo <= 0) {
			throw new IllegalArgumentException();
		}

		String queryStr = "FROM Admission a WHERE a.ClientId=? ORDER BY a.AdmissionDate DESC";
		List rs = getHibernateTemplate().find(queryStr, new Object[] { demographicNo });

		if (log.isDebugEnabled()) {
			log.debug("getAdmissions for clientId " + demographicNo + ", # of admissions: " + rs.size());
		}

		return rs;
	}

	public List getCurrentAdmissions(Integer demographicNo) {
		if (demographicNo == null || demographicNo <= 0) {
			throw new IllegalArgumentException();
		}

		String queryStr = "FROM Admission a WHERE a.ClientId=? AND a.AdmissionStatus='current' ORDER BY a.AdmissionDate DESC";
		List rs = getHibernateTemplate().find(queryStr, new Object[] { demographicNo });

		if (log.isDebugEnabled()) {
			log.debug("getCurrentAdmissions for clientId " + demographicNo + ", # of admissions: " + rs.size());
		}

		return rs;

	}

	// TODO: rewrite
	public Admission getCurrentBedProgramAdmission(ProgramDao programDAO, Integer demographicNo) {
		if (programDAO == null) {
			throw new IllegalArgumentException();
		}

		if (demographicNo == null || demographicNo <= 0) {
			throw new IllegalArgumentException();
		}

		String queryStr = "FROM Admission a WHERE a.ClientId=? AND a.AdmissionStatus='current' ORDER BY a.AdmissionDate DESC";

		Admission admission = null;
		List rs = getHibernateTemplate().find(queryStr, new Object[] { demographicNo });

		if (rs.isEmpty()) {
			return null;
		}

		ListIterator listIterator = rs.listIterator();
		while (listIterator.hasNext()) {
			try {
				admission = (Admission) listIterator.next();
				if (programDAO.isBedProgram(admission.getProgramId())) {
					return admission;
				}
			} catch (Exception ex) {
				return null;
			}
		}
		return null;
	}

	// TODO: rewrite
	public List getCurrentServiceProgramAdmission(ProgramDao programDAO, Integer demographicNo) {
		if (programDAO == null) {
			throw new IllegalArgumentException();
		}

		if (demographicNo == null || demographicNo <= 0) {
			throw new IllegalArgumentException();
		}

		String queryStr = "FROM Admission a WHERE a.ClientId=? AND a.AdmissionStatus='current' ORDER BY a.AdmissionDate DESC";

		Admission admission = null;
		List admissions = new ArrayList();
		List rs = new ArrayList();

		rs = getHibernateTemplate().find(queryStr, new Object[] { demographicNo });

		if (rs.isEmpty()) {
			return null;
		}
		ListIterator listIterator = rs.listIterator();
		while (listIterator.hasNext()) {
			try {
				admission = (Admission) listIterator.next();
				if (programDAO.isServiceProgram(admission.getProgramId())) {
					admissions.add(admission);
				}
			} catch (Exception ex) {
				return null;
			}
		}
		return admissions;
	}

	public Admission getCurrentCommunityProgramAdmission(ProgramDao programDAO, Integer demographicNo) {
		if (programDAO == null) {
			throw new IllegalArgumentException();
		}

		if (demographicNo == null || demographicNo <= 0) {
			throw new IllegalArgumentException();
		}

		String queryStr = "FROM Admission a WHERE a.ClientId=? AND a.AdmissionStatus='current' ORDER BY a.AdmissionDate DESC";

		Admission admission = null;
		List rs = getHibernateTemplate().find(queryStr, new Object[] { demographicNo });

		if (rs.isEmpty()) {
			return null;
		}

		ListIterator listIterator = rs.listIterator();
		while (listIterator.hasNext()) {
			try {
				admission = (Admission) listIterator.next();
				if (programDAO.isCommunityProgram(admission.getProgramId())) {
					return admission;
				}
			} catch (Exception ex) {
				return null;
			}
		}
		return null;
	}

	public List getCurrentAdmissionsByProgramId(Integer programId) {
		if (programId == null || programId <= 0) {
			throw new IllegalArgumentException();
		}

		List results = this.getHibernateTemplate().find("from Admission a where a.ProgramId = ? and a.AdmissionStatus='current'", programId);

		if (log.isDebugEnabled()) {
			log.debug("getCurrentAdmissionsByProgramId for programId " + programId + ", # of admissions: " + results.size());
		}
		return results;
	}

	public Admission getAdmission(Long id) {

		if (id == null || id <= 0) {
			throw new IllegalArgumentException();
		}

		Admission admission = (Admission) this.getHibernateTemplate().get(Admission.class, id);

		if (log.isDebugEnabled()) {
			log.debug("getAdmission: id= " + id + ", found: " + (admission != null));
		}

		return admission;
	}

	public void saveAdmission(Admission admission) {
		if (admission == null) {
			throw new IllegalArgumentException();
		}

		getHibernateTemplate().saveOrUpdate(admission);
		getHibernateTemplate().flush();

		if (log.isDebugEnabled()) {
			log.debug("saveAdmission: id= " + admission.getId());
		}
	}

	public List getAdmissionsInTeam(Integer programId, Integer teamId) {
		if (programId == null || programId <= 0) {
			throw new IllegalArgumentException();
		}

		if (teamId == null || teamId <= 0) {
			throw new IllegalArgumentException();
		}

		List results = this.getHibernateTemplate().find("from Admission a where a.ProgramId = ? and a.TeamId = ? and a.AdmissionStatus='current'", new Object[] { programId, teamId });

		if (log.isDebugEnabled()) {
			log.debug("getAdmissionsInTeam: programId= " + programId + ",teamId=" + teamId + ",# results=" + results.size());
		}

		return results;
	}

	public Admission getTemporaryAdmission(Integer demographicNo) {
		Admission result = null;
		if (demographicNo == null || demographicNo <= 0) {
			throw new IllegalArgumentException();
		}

		List results = this.getHibernateTemplate().find("from Admission a where a.TemporaryAdmission = true and a.AdmissionStatus='current' and a.ClientId = ?", demographicNo);

		if (!results.isEmpty()) {
			result = (Admission) results.get(0);
		}

		if (log.isDebugEnabled()) {
			log.debug("getTemporaryAdmission: demographicNo= " + demographicNo + ",found=" + (result != null));
		}

		return result;
	}

	public List search(AdmissionSearchBean searchBean) {
		if (searchBean == null) {
			throw new IllegalArgumentException();
		}

		Criteria criteria = getSession().createCriteria(Admission.class);

		if (searchBean.getProviderNo() != null && searchBean.getProviderNo() > 0) {
			criteria.add(Restrictions.eq("ProviderNo", searchBean.getProviderNo()));
		}

		if (searchBean.getAdmissionStatus() != null && searchBean.getAdmissionStatus().length() > 0) {
			criteria.add(Restrictions.eq("AdmissionStatus", searchBean.getAdmissionStatus()));
		}

		if (searchBean.getClientId() != null && searchBean.getClientId() > 0) {
			criteria.add(Restrictions.eq("ClientId", searchBean.getClientId()));
		}

		if (searchBean.getProgramId() != null && searchBean.getProgramId() > 0) {
			criteria.add(Restrictions.eq("ProgramId", searchBean.getProgramId()));
		}

		if (searchBean.getStartDate() != null && searchBean.getEndDate() != null) {
			criteria.add(Restrictions.between("AdmissionDate", searchBean.getStartDate(), searchBean.getEndDate()));
		}
		List results = criteria.list();

		if (log.isDebugEnabled()) {
			log.debug("search: # of results: " + results.size());
		}

		return results;
	}

	public List getClientIdByProgramDate(int programId, Date dt) {
		String q = "FROM Admission a WHERE a.programId=? and a.admissionDate<=? and (a.dischargeDate>=? or (a.dischargeDate is null))";
		logger.debug("enter HibernateAdmissionDao");
		List rs = this.getHibernateTemplate().find(q, new Object[] { new Integer(programId), dt, dt });
		logger.debug(rs);
		return rs;
	}
}
