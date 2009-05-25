/*******************************************************************************
 * Copyright (c) 2005, 2009 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU General Public License
 * which accompanies this distribution, and is available at
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Contributors:
 *     <Quatro Group Software Systems inc.>  <OSCAR Team>
 *******************************************************************************/
package org.oscarehr.PMmodule.dao;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SQLQuery;
import org.hibernate.Transaction;
import org.oscarehr.PMmodule.model.ClientReferral;
import org.oscarehr.PMmodule.model.ConsentDetail;
import org.oscarehr.PMmodule.model.ProgramQueue;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.model.SdmtIn;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import oscar.MyDateFormat;
import com.quatro.model.ProgramOccupancy;
import com.quatro.util.Utility;

public class ProgramOccupancyDao extends HibernateDaoSupport {
	private Log log = LogFactory.getLog(ProgramOccupancyDao.class);

	private ProgramQueueDao programQueueDao;

	public void insertProgramOccupancy(String providerNo, Calendar occDate) {
		// Transaction tx = getSession().beginTransaction();
		String sql = " insert into program_occupancy(recordid,occdate,program_id,occupancy,"
				+ "capacity_actual,capacity_funding,queue,lastupdateuser,lastupdatedate) "
				+ "select seq_program_occupancy.nextval,?,p.program_id,ad.v_occupancy,"
				+ "pr.v_actualCapacity,p.Capacity_funding,pq.v_queue,?,sysdate "
				+ " from program p,"
				+ "(select program_id, count(*) v_occupancy from admission where admission_status='admitted' group by program_id) ad,"
				+ "(select r.program_id, sum(r.beds) v_actualCapacity from v_room_beds r group by r.program_id) pr,"
				+ "(select program_id, count(*) v_queue from program_queue group by program_id) pq "
				+ " where p.program_id = ad.program_id and p.program_id=pr.program_id and p.program_id = pq.program_id(+)";
		SQLQuery query = getSession().createSQLQuery(sql);
		query.setCalendar(0, occDate);
		query.setString(1, providerNo);
		query.executeUpdate();
		// tx.commit();
	}

	public void deleteProgramOccupancy(Calendar occDate) {

		String sql = " delete from program_occupancy "
				+ " where trunc(occdate)=?";
		SQLQuery query = getSession().createSQLQuery(sql);
		query.setCalendar(0, DateUtils.truncate(occDate, Calendar.DATE));
		query.executeUpdate();
	}

	public void insertSdmtOut() {
		String sql = "select max(batch_no) from sdmt_out";
		SQLQuery q = getSession().createSQLQuery(sql);
		BigDecimal result = (BigDecimal) q.uniqueResult();
		if (result == null)
			result = new BigDecimal(0);

		int batchNo = result.intValue() + 1;
		sql = " insert into sdmt_out(recordid,batch_no,batch_date,first_name,last_name,dob,sin,health_card_no,client_id,sdmt_id,sdmt_ben_unit_id) ";
		sql += " select seq_sdmt_out.nextval,"
				+ batchNo
				+ ",sysdate,d.first_name,d.last_name,d.dob,ltrim(rtrim(ri.sin)),";
		sql += " ri.healthcardno,d.hin,d.demographic_no,d.pin from demographic d,admission a,report_intake ri ";
		sql += " where  d.demographic_no=a.client_id and a.intake_id=ri.intake_id and a.admission_status='admitted'";
		q = getSession().createSQLQuery(sql);
		q.executeUpdate();
	}

	public List getSdmtOutList(Calendar today, boolean includeSendout) {
		Object[] params;
		String sql = "from SdmtOut i where ";
		List result = null;
		Calendar sDt = new GregorianCalendar(today.get(Calendar.YEAR), today
				.get(Calendar.MONTH), today.get(Calendar.DATE), 0, 0, 0);
		Calendar eDt = new GregorianCalendar(today.get(Calendar.YEAR), today
				.get(Calendar.MONTH), today.get(Calendar.DATE), 23, 59, 59);
		params = new Object[] { sDt, eDt };
		if (includeSendout)
			sql += "i.batchDateStr between ? and ? ";
		else
			sql += "(i.batchDateStr between ? and ?) and sendOut=0";
		sql += " order by i.recordId";
		result = getHibernateTemplate().find(sql, params);
		return result;
	}

	public void updateSdmtOut(int batchNo) {
		String sql = "update SdmtOut set sendOut=1 where batchNumber=? ";
		getHibernateTemplate().bulkUpdate(sql, new Integer(batchNo));
	}

	public void insertSdmtIn(SdmtIn sdVal) {
		try {
			if (sdVal.getRecordId() == null)
				sdVal.setRecordId(new Integer(0));
			getHibernateTemplate().saveOrUpdate(sdVal);
			updateIntake(sdVal);
		} catch (Exception e) {
			System.out.print("DAO" + e.getMessage());
		}
	}

	private void updateIntake(SdmtIn sdVal) {
		String sql = "update intake set sdmt_ben_unit_status=?,sdmt_office=?,sdmt_last_ben_month=?";
		sql += " where client_id=? and intake_status in ('active','admitted')"
				+ " and (end_date > ? or never_end=1)";
		SQLQuery q = getSession().createSQLQuery(sql);
		q.setString(0, sdVal.getBenefitUnitStatus());
		q.setString(1, sdVal.getOffice());
		q.setString(2, sdVal.getLastBenMonth());
		q.setInteger(3, sdVal.getClientId().intValue());
		Calendar today = Calendar.getInstance();
		today.clear(Calendar.HOUR_OF_DAY);
		today.clear(Calendar.HOUR);
		today.clear(Calendar.MINUTE);
		today.clear(Calendar.SECOND);
		today.clear(Calendar.MILLISECOND);
		q.setDate(4, today.getTime());

		q.executeUpdate();
	}

	public void deactiveServiceProgram() {
		Calendar now = Calendar.getInstance();
		Integer maxAge = Integer.valueOf(oscar.OscarProperties.getInstance().getProperty("DEACTIVE_INTAKE_HOURS"));
		List result = null;
		String sql = "from QuatroIntakeHeader where nerverExpiry=0 and endDate is null and programType='Service'";
		result = getHibernateTemplate().find(sql, null);
		Object[] params;
		int i = 0;
		sql = "update  QuatroIntakeHeader set endDate=? where id in ( ";
		String ids = "";
		if (result.size() > 0) {
			Iterator items = result.iterator();
			while (items.hasNext()) {
				QuatroIntakeHeader qih = (QuatroIntakeHeader) items.next();

				if (MyDateFormat.getHoursDiff(qih.getCreatedOn(), now) > maxAge.intValue()) {
					i++;
					ids += qih.getId().toString() + ",";
				}
			}
			if (ids.endsWith(","))
				ids = ids.substring(0, ids.length() - 1);
			if (i > 0) {
				sql += ids + ")";
				params = new Object[] { Calendar.getInstance() };
				getHibernateTemplate().bulkUpdate(sql, params);
			}

		}
	}

	public void deactiveBedProgram() {
		Calendar now = Calendar.getInstance();
		Integer maxAge = Integer.valueOf(oscar.OscarProperties.getInstance().getProperty("DEACTIVE_INTAKE_HOURS"));
		List result = null;
		String sql = "from QuatroIntakeHeader where intakeStatus='active' and programType='Bed'";
		result = getHibernateTemplate().find(sql, null);
		// Calendar now =Calendar.getInstance();
		Object[] params;

		String qIds = "";
		String rIds = "";
		String iIds = "";
		String qDel = "delete  ProgramQueue where Id in ( ";
		String refUpdSql = "update ClientReferral set status='rejected',autoManual='A',rejectionReason='50',"
				+ "completionNotes='Intake Automated reject process',completionDate=?  where id in (";
		String intakeUpdSql = "update  QuatroIntakeHeader set intakeStatus='rejected' where id in ( ";
		sql = "from ProgramQueue where fromIntakeId in (";
		if (result.size() > 0) {
			Iterator items = result.iterator();
			while (items.hasNext()) {
				QuatroIntakeHeader qih = (QuatroIntakeHeader) items.next();
				if (MyDateFormat.getHoursDiff(qih.getCreatedOn(), now) > maxAge.intValue()) {
					iIds += qih.getId().toString() + ",";
				}
			}
			if (iIds.endsWith(","))
				iIds = iIds.substring(0, iIds.length() - 1);
			if (!Utility.IsEmpty(iIds)) {
				intakeUpdSql += iIds + ")";

				getHibernateTemplate().bulkUpdate(intakeUpdSql, null);

				sql += iIds + ")";

				result = getHibernateTemplate().find(sql, null);

				if (result.size() > 0) {
					Iterator item = result.iterator();
					while (item.hasNext()) {
						ProgramQueue queue = (ProgramQueue) item.next();
						if (queue != null) {
							qIds += queue.getId().toString() + ",";
							rIds += queue.getReferralId().toString() + ",";
						}
					}
				}
			}

			if (qIds.endsWith(","))
				qIds = qIds.substring(0, qIds.length() - 1);
			if (!Utility.IsEmpty(qIds)) {
				qDel += qIds + ")";
				getHibernateTemplate().bulkUpdate(qDel, null);
			}
			if (rIds.endsWith(","))
				rIds = rIds.substring(0, rIds.length() - 1);
			if (!Utility.IsEmpty(rIds)) {
				refUpdSql += rIds + ")";
				params = new Object[] { Calendar.getInstance() };
				getHibernateTemplate().bulkUpdate(refUpdSql, params);
			}

		}

		sql = "from ClientReferral where status='active'";
		result = getHibernateTemplate().find(sql, null);
		String delQsql = "delete  ProgramQueue where referralId in ( ";
		String updCRSql = "update ClientReferral set status='rejected',autoManual='A',rejectionReason='50',"
				+ "completionNotes='Intake Automated reject process',completionDate=? where id in(";
		qIds = "";
		rIds = "";
		if (result.size() > 0) {
			Iterator items = result.iterator();
			while (items.hasNext()) {

				ClientReferral cr = (ClientReferral) items.next();
				if (MyDateFormat.getHoursDiff(cr.getReferralDate(), now) > maxAge.intValue()) {
					qIds += cr.getId().toString() + ",";

				}
			}
			if (qIds.endsWith(","))
				qIds = qIds.substring(0, qIds.length() - 1);
			if (!Utility.IsEmpty(qIds)) {
				delQsql += qIds + ")";
				getHibernateTemplate().bulkUpdate(delQsql, null);
				updCRSql += qIds + ")";
				params = new Object[] { Calendar.getInstance() };
				getHibernateTemplate().bulkUpdate(updCRSql, params);
			}
		}

	}

	public void setProgramQueueDao(ProgramQueueDao programQueueDao) {
		this.programQueueDao = programQueueDao;
	}
}
