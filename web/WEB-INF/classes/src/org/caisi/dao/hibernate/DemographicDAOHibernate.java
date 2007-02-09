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

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.caisi.dao.DemographicDAO;
import org.oscarehr.PMmodule.model.Demographic;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * Hibernate implementation for the corresponding DAO interface
 * 
 * @author Marc Dumontier <a href="mailto:marc@mdumontier.com">marc@mdumontier.com</a>
 */
public class DemographicDAOHibernate extends HibernateDaoSupport implements DemographicDAO {

	public Demographic getDemographic(String demographic_no) {
		if (demographic_no == null || demographic_no.length() == 0) {
			return null;
		}

		return (Demographic) this.getHibernateTemplate().get(Demographic.class, Integer.valueOf(demographic_no));
	}

	// ADD BY PINE-SOFT
	public List getDemographics() {
		return this.getHibernateTemplate().find("from Demographic d order by d.LastName");
	}

	public Demographic getDemographicById(Integer demographic_id) {
		String q = "FROM Demographic d WHERE d.DemographicNo = ?";
		List rs = (List) getHibernateTemplate().find(q, demographic_id);

		if (rs.size() == 0)
			return null;
		else
			return (Demographic) rs.get(0);
	}

	/*
	 * get demographics according to their program, admit time, discharge time, ordered by lastname and first name
	 */
	public List getDemographicByProgram(int programId, Date dt, Date defdt) {
		String q = "Select d From Demographic d, Admission a " + "Where d.DemographicNo=a.DlientId and a.ProgramId=? and a.AdmissionDate<=? and " + "(a.DischargeDate>=? or (a.DischargeDate is null) or a.DischargeDate=?)" + " order by d.LastName,d.FirstName";
		List rs = (List) getHibernateTemplate().find(q, new Object[] { new Integer(programId), dt, dt, defdt });
		return rs;
	}

	/*
	 * get demographics according to their program, admit time, discharge time, ordered by lastname and first name
	 */
	public List getActiveDemographicByProgram(int programId, Date dt, Date defdt) {
		String q = "Select d From Demographic d, Admission a " + "Where (d.PatientStatus=? or d.PatientStatus='' or d.PatientStatus=null) and d.DemographicNo=a.ClientId and a.ProgramId=? and a.AdmissionDate<=? and " + "(a.DischargeDate>=? or (a.DischargeDate is null) or a.DischargeDate=?)"
		        + " order by d.LastName,d.FirstName";

		String status = "AC"; // only show active clients
		List rs = (List) getHibernateTemplate().find(q, new Object[] { status, new Integer(programId), dt, dt, defdt });

		return rs;
	}

	public List getArchiveDemographicByPromgram(int programId,Date dt, Date defdt) {
		String q = "Select d From Demographic d, Admission a " + "Where (d.PatientStatus=? or d.PatientStatus='' or d.PatientStatus=null) and d.DemographicNo=a.ClientId and a.ProgramId=? and a.AdmissionDate<=? )"
        		+ " order by d.LastName,d.FirstName";

		String status = "AC"; // only show active clients
		List rs = (List) getHibernateTemplate().find(q, new Object[] { status, new Integer(programId), dt});

		return rs;
	}
	
	public List getProgramIdByDemoNo(String demoNo) {
		String q = "Select a.ProgramId From Admission a " + "Where a.ClientId=? and a.AdmissionDate<=? and " + "(a.DischargeDate>=? or (a.DischargeDate is null) or a.DischargeDate=?)";

		/* default time is Oscar default null time 0001-01-01. */
		Date defdt = new GregorianCalendar(1, 0, 1).getTime();

		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.HOUR_OF_DAY,23);
		cal.set(Calendar.MINUTE,59);
		cal.set(Calendar.SECOND,59);
		Date dt = cal.getTime();	

		List rs = (List) getHibernateTemplate().find(q, new Object[] { demoNo, dt, dt, defdt });
		return rs;
	}

	public void clear() {
		getHibernateTemplate().clear();

	}

	public List getDemoProgram(String demoNo) {
		String q = "Select a.ProgramId From Admission a Where a.ClientId=?";
		List rs = (List) getHibernateTemplate().find(q, new Object[] { demoNo });
		return rs;
	}

}
