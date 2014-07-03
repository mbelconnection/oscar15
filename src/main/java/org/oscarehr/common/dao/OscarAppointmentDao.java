/**
 *
 * Copyright (c) 2005-2012. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved.
 * This software is published under the GPL GNU General Public License.
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * This software was written for
 * Centre for Research on Inner City Health, St. Michael's Hospital,
 * Toronto, Ontario, Canada
 */

package org.oscarehr.common.dao;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.persistence.Query;

import org.apache.log4j.Logger;
import org.oscarehr.common.NativeSql;
import org.oscarehr.common.model.Appointment;
import org.oscarehr.common.model.AppointmentArchive;
import org.oscarehr.common.model.AppointmentStatus;
import org.oscarehr.common.model.AppointmentType;
import org.oscarehr.common.model.Facility;
import org.oscarehr.common.model.Provider;
import org.oscarehr.util.MiscUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Repository;

import oscar.util.DateUtils;

@Repository
@SuppressWarnings({ "unchecked", "deprecation" })
public class OscarAppointmentDao extends AbstractDao<Appointment> {
	private static Logger log = MiscUtils.getLogger();
	public OscarAppointmentDao() {
		super(Appointment.class);
	}

	public boolean checkForConflict(Appointment appt) {
		String sb = "select a from Appointment a where a.appointmentDate = ? and a.startTime >= ? and a.endTime <= ? and a.providerNo = ? and a.status != 'N' and a.status != 'C'";

		Query query = entityManager.createQuery(sb);

		query.setParameter(1, appt.getAppointmentDate());
		query.setParameter(2, appt.getStartTime());
		query.setParameter(3, appt.getEndTime());
		query.setParameter(4, appt.getProviderNo());

		
		List<Facility> results = query.getResultList();

		if (!results.isEmpty()) return true;

		return false;
	}
	
	public List<Appointment> getAppointmentHistory(Integer demographicNo, Integer offset, Integer limit) {
		String sql = "select a from Appointment a where a.demographicNo=? order by a.appointmentDate DESC, a.startTime DESC";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, demographicNo);
		query.setFirstResult(offset);
		query.setMaxResults(limit);
		
		List<Appointment> result = query.getResultList();
		
		return result;
	}
	
	public List<Appointment> getAppointmentHistoryAfter(Integer demographicNo, Date startDateInclusive, Integer offset, Integer limit) {
		String sql = "select a from Appointment a where a.demographicNo=? and a.appointmentDate >= ? order by a.appointmentDate ASC, a.startTime ASC";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, demographicNo);
		query.setParameter(2,startDateInclusive);
		query.setFirstResult(offset);
		query.setMaxResults(limit);
		
		List<Appointment> results = query.getResultList();
		
		List<Appointment> filteredResults= new ArrayList<Appointment>();
		for(Appointment result:results) {
			if(DateUtils.isToday(result.getAppointmentDate())) {
				Calendar apptTimeCal = Calendar.getInstance();
				apptTimeCal.setTime(result.getStartTime());
				
				Calendar apptCal = Calendar.getInstance();
				apptCal.set(Calendar.HOUR_OF_DAY, apptTimeCal.get(Calendar.HOUR_OF_DAY));
				apptCal.set(Calendar.MINUTE, apptTimeCal.get(Calendar.MINUTE));
				
				if(apptCal.after(startDateInclusive)) {
					filteredResults.add(result);
				}
			} else {
				filteredResults.add(result);
			}
	
		}
		
		return filteredResults;
	}
	
	public List<AppointmentArchive> getDeletedAppointmentHistory(Integer demographicNo, Integer offset, Integer limit) {
		
		@SuppressWarnings("unused")
        List<Object> result = new ArrayList<Object>();
			
		String sql2 = "select a from AppointmentArchive a where a.demographicNo=? order by a.appointmentDate DESC, a.startTime DESC, id desc";
		Query query2 = entityManager.createQuery(sql2);
		query2.setParameter(1, demographicNo);
		query2.setFirstResult(offset);
		query2.setMaxResults(limit);
		
		List<AppointmentArchive> results = query2.getResultList();
		
		
		return results;
	}

	public List<Appointment> getAppointmentHistory(Integer demographicNo) {
		String sql = "select a from Appointment a where a.demographicNo=? order by a.appointmentDate DESC, a.startTime DESC";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, demographicNo);

		
		List<Appointment> rs = query.getResultList();

		return rs;
	}

	public void archiveAppointment(int appointmentNo) {
		Appointment appointment = this.find(appointmentNo);
		if (appointment != null) {
			AppointmentArchive apptArchive = new AppointmentArchive();
			String[] ignores={"id"};
			BeanUtils.copyProperties(appointment, apptArchive, ignores);
			apptArchive.setAppointmentNo(appointment.getId());
			entityManager.persist(apptArchive);
		}
	}

	public List<Appointment> getAllByDemographicNo(Integer demographicNo) {
		String sql = "SELECT a FROM Appointment a WHERE a.demographicNo = " + demographicNo + " ORDER BY a.id";
		Query query = entityManager.createQuery(sql);

		
		List<Appointment> rs = query.getResultList();

		return rs;
	}

	public List<Appointment> findByDateRange(Date startTime, Date endTime) {
		String sql = "SELECT a FROM Appointment a WHERE a.appointmentDate >=? and a.appointmentDate < ?";

		Query query = entityManager.createQuery(sql);
		query.setParameter(1, startTime);
		query.setParameter(2, endTime);
		
		List<Appointment> rs = query.getResultList();

		return rs;
	}


	public List<Appointment> findByDateRangeAndProvider(Date startTime, Date endTime, String providerNo) {
		String sql = "SELECT a FROM Appointment a WHERE a.appointmentDate >=? and a.appointmentDate < ? and providerNo = ?";

		Query query = entityManager.createQuery(sql);
		query.setParameter(1, startTime);
		query.setParameter(2, endTime);
		query.setParameter(3, providerNo);

		
		List<Appointment> rs = query.getResultList();

		return rs;
	}

	public List<Appointment> getByProviderAndDay(Date date, String providerNo) {
		String sql = "SELECT a FROM Appointment a WHERE a.providerNo=? and a.appointmentDate = ? and a.status != 'N' and a.status != 'C' order by a.startTime";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, providerNo);
		query.setParameter(2, date);
		
		List<Appointment> rs = query.getResultList();

		return rs;
	}

	public List<Appointment> findByProviderAndDayandNotStatuses(String providerNo, Date date, String[] notThisStatus) {
		String sql = "SELECT a FROM Appointment a WHERE a.providerNo=?1 and a.appointmentDate = ?2 and a.status NOT IN ( ?3 )";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, providerNo);
		query.setParameter(2, date);
		query.setParameter(3, Arrays.asList(notThisStatus));

		List<Appointment> results = query.getResultList();
		return results;
	}
	
	public List<Appointment> findByProviderAndDayandNotStatus(String providerNo, Date date, String notThisStatus) {
		String sql = "SELECT a FROM Appointment a WHERE a.providerNo=?1 and a.appointmentDate = ?2 and a.status != ?3";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, providerNo);
		query.setParameter(2, date);
		query.setParameter(3, notThisStatus);

		
		List<Appointment> results = query.getResultList();
		return results;
	}

	public List<Appointment> findByProviderDayAndStatus(String providerNo,Date date, String status) {
		String sql = "SELECT a FROM Appointment a WHERE a.providerNo=? and a.appointmentDate = ? and a.status=?";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, providerNo);
		query.setParameter(2, date);
		query.setParameter(3, status);
		
		List<Appointment> rs = query.getResultList();

		return rs;
	}

	public List<Appointment> findByDayAndStatus(Date date, String status) {
		String sql = "SELECT a FROM Appointment a WHERE a.appointmentDate = ? and a.status=?";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, date);
		query.setParameter(2, status);
		
		List<Appointment> rs = query.getResultList();

		return rs;
	}

	public List<Appointment> find(Date date, String providerNo,Date startTime, Date endTime, String name,
			String notes, String reason, Date createDateTime, String creator, Integer demographicNo) {

		String sql = "SELECT a FROM Appointment a " +
				"WHERE a.appointmentDate = ? and a.providerNo=? and a.startTime=?" +
				"and a.endTime=? and a.name=? and a.notes=? and a.reason=? and a.createDateTime=?" +
				"and a.creator=? and a.demographicNo=?";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, date);
		query.setParameter(2, providerNo);
		query.setParameter(3, startTime);
		query.setParameter(4, endTime);
		query.setParameter(5, name);
		query.setParameter(6, notes);
		query.setParameter(7, reason);
		query.setParameter(8, createDateTime);
		query.setParameter(9, creator);
		query.setParameter(10, demographicNo);

		
		List<Appointment> rs = query.getResultList();

		return rs;
	}

	/**
	 * @return return results ordered by appointmentDate, most recent first
	 */
	public List<Appointment> findByDemographicId(Integer demographicId, int startIndex, int itemsToReturn) {
		String sql = "SELECT a FROM Appointment a WHERE a.demographicNo = ?1 ORDER BY a.appointmentDate desc";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, demographicId);
		query.setFirstResult(startIndex);
		query.setMaxResults(itemsToReturn);

		
		List<Appointment> rs = query.getResultList();

		return rs;
	}

	public List<Appointment> findAll() {
		String sql = "SELECT a FROM Appointment a";
		Query query = entityManager.createQuery(sql);

		
		List<Appointment> rs = query.getResultList();

		return rs;
	}
	
	
    public List<Appointment> findNonCancelledFutureAppointments(Integer demographicId) {
		Query query = entityManager.createQuery("FROM Appointment appt WHERE appt.demographicNo = :demographicNo AND appt.status NOT LIKE '%C%' " +
				" AND appt.appointmentDate >= CURRENT_DATE ORDER BY appt.appointmentDate");
		query.setParameter("demographicNo", demographicId);
		return query.getResultList();
	}
	
	/**
	 * Finds appointment after current date and time for the specified demographic
	 * 
	 * @param demographicId
	 * 		Demographic to find appointment for
	 * @return
	 * 		Returns the next non-cancelled future appointment or null if there are no appointments
	 * 	scheduled
	 */
	public Appointment findNextAppointment(Integer demographicId) {
		Query query = entityManager.createQuery("FROM Appointment appt WHERE appt.demographicNo = :demographicNo AND appt.status NOT LIKE '%C%' " +
				"	AND (appt.appointmentDate > CURRENT_DATE OR (appt.appointmentDate = CURRENT_DATE AND appt.startTime >= CURRENT_TIME)) ORDER BY appt.appointmentDate");
		query.setParameter("demographicNo", demographicId);
		query.setMaxResults(1);
		return getSingleResultOrNull(query);
	}


	public Appointment findDemoAppointmentToday(Integer demographicNo) {
		Appointment appointment = null;

		String sql = "SELECT a FROM Appointment a WHERE a.demographicNo = ? AND a.appointmentDate=DATE(NOW())";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, demographicNo);

		try {
			appointment = (Appointment) query.getSingleResult();
		} catch (Exception e) {
			MiscUtils.getLogger().info("Couldn't find appointment for demographic " + demographicNo + " today.");
		}

		return appointment;
	}
	

	public List<Appointment> findByEverything(Date appointmentDate, String providerNo, Date startTime, Date endTime, String name, String notes, String reason, Date createDateTime, String creator, int demographicNo) {
		String sql = "SELECT a FROM Appointment a WHERE a.appointmentDate=? and a.providerNo=? and a.startTime=? and a.endTime=? and a.name=? and a.notes=? and a.reason=? and a.createDateTime like ? and a.creator = ? and a.demographicNo=?";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, appointmentDate);
		query.setParameter(2, providerNo);
		query.setParameter(3, startTime);
		query.setParameter(4, endTime);
		query.setParameter(5, name);
		query.setParameter(6, notes);
		query.setParameter(7, reason);
		query.setParameter(8, createDateTime);
		query.setParameter(9, creator);
		query.setParameter(10, demographicNo);

		
		List<Appointment> rs = query.getResultList();

		return rs;
	}
	
	
    public List<Appointment> findByProviderAndDate(String providerNo, Date appointmentDate) {
		Query query = createQuery("a", "a.providerNo = :pNo and a.appointmentDate= :aDate");
		query.setParameter("pNo", providerNo);
		query.setParameter("aDate", appointmentDate);
	    return query.getResultList();
    }

	
	public List<Object[]> findAppointments(Date sDate, Date eDate) {
		String sql = "FROM Appointment a, Demographic d " +
				"WHERE a.demographicNo = d.DemographicNo " +
				"AND d.Hin <> '' " +
				"AND a.appointmentDate >= :sDate " +
				"AND a.appointmentDate <= :eDate " +
				"AND (" +
				"	UPPER(d.Province) = 'ONTARIO' " +
				"	OR d.Province='ON' " +
				") GROUP BY d.DemographicNo " +
				"ORDER BY d.LastName";
		Query query = entityManager.createQuery(sql);
		query.setParameter("sDate", sDate == null ? new Date(Long.MIN_VALUE) : sDate);
		query.setParameter("eDate", eDate == null ? new Date(Long.MAX_VALUE) : eDate);
		return query.getResultList();
	}
	
    public List<Object[]> findPatientAppointments(String providerNo, Date from, Date to) {
        StringBuilder sql = new StringBuilder("FROM Demographic d, Appointment a, Provider p " +
                "WHERE a.demographicNo = d.DemographicNo " +
                "AND a.providerNo = p.ProviderNo ");

        	Map<String, Object> params = new HashMap<String, Object>();
        	if(providerNo != null && !providerNo.trim().equals("")){
		       sql.append("and a.providerNo = :pNo ");
		       params.put("pNo", providerNo);
		   }
        	
		   if(from != null){
		       sql.append("AND a.appointmentDate >= :from ");
		       params.put("from", from);
		   }if(to != null){
		       sql.append("AND a.appointmentDate <= :to ");
		       params.put("to", to);
		   }
		   sql.append("ORDER BY a.appointmentDate");
		   
		   Query query = entityManager.createQuery(sql.toString());
		   for(Entry<String, Object> e : params.entrySet()) {
			   query.setParameter(e.getKey(), e.getValue());
		   }
		   return query.getResultList();
        }

	public List<Appointment> search_unbill_history_daterange(String providerNo, Date startDate, Date endDate) {
		String sql = "select a from Appointment a where a.providerNo=? and a.appointmentDate >=? and a.appointmentDate<=? and (a.status='P' or a.status='H' or a.status='PV' or a.status='PS') and a.demographicNo <> 0 order by a.appointmentDate desc, a.startTime desc";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, providerNo);
		query.setParameter(2, startDate);
		query.setParameter(3, endDate);
		
		return query.getResultList();
	}
    
	public List<Appointment> findByDateAndProvider(Date date, String provider_no) {
		Query query = createQuery("a", "a.providerNo = :provider_no and a.appointmentDate = :date order by a.startTime asc");
		query.setParameter("provider_no", provider_no);
		query.setParameter("date", date);
		return query.getResultList();
    }
	
	public List<Appointment> search_appt(Date startTime, Date endTime, String providerNo) {
		String sql = "SELECT a FROM Appointment a WHERE a.appointmentDate >=? and a.appointmentDate <= ? and a.providerNo = ? order by a.appointmentDate,a.startTime,a.endTime";

		Query query = entityManager.createQuery(sql);
		query.setParameter(1, startTime);
		query.setParameter(2, endTime);
		query.setParameter(3, providerNo);

		
		List<Appointment> rs = query.getResultList();

		return rs;
	}
	
	//search_appt_name
	public List<Appointment> search_appt(Date date, String providerNo, Date startTime1, Date startTime2, Date endTime1, Date endTime2, Date startTime3, Date endTime3, Integer programId) {
		String sql = "select a from Appointment a where a.appointmentDate = ? and a.providerNo = ? and a.status <>'C' and ((a.startTime >= ? and a.startTime<= ?) or (a.endTime>= ? and a.endTime<= ?) or (a.startTime <= ? and a.endTime>= ?) ) and program_id=?";
		Query query = entityManager.createQuery(sql);
		query.setParameter(1, date);
		query.setParameter(2, providerNo);
		query.setParameter(3, startTime1);
		query.setParameter(4, startTime2);
		query.setParameter(5, endTime1);
		query.setParameter(6, endTime2);
		query.setParameter(7, startTime3);
		query.setParameter(8, endTime3);
		query.setParameter(9, programId);
		
		List<Appointment> rs = query.getResultList();

		return rs;
	}
	
    public List<Object[]> search_appt_future(Integer demographicNo, Date from, Date to) {
        StringBuilder sql = new StringBuilder("FROM Appointment a, Provider p " +
                "WHERE a.providerNo = p.ProviderNo and " +
                "a.demographicNo = ? and " +
                "a.appointmentDate >= ? and " +
                "a.appointmentDate < ?  " +
                "order by a.appointmentDate desc, a.startTime desc");
        
        Query query = entityManager.createQuery(sql.toString());
        query.setParameter(1, demographicNo);
        query.setParameter(2, from);
        query.setParameter(3, to);
        

        return query.getResultList();
    }
    
    public List<Object[]> search_appt_past(Integer demographicNo, Date from, Date to) {
        StringBuilder sql = new StringBuilder("FROM Appointment a, Provider p " +
                "WHERE a.providerNo = p.ProviderNo and " +
                "a.demographicNo = ? and " +
                "a.appointmentDate < ? and " +
                "a.appointmentDate > ?  " +
                "order by a.appointmentDate desc, a.startTime desc");
        
        Query query = entityManager.createQuery(sql.toString());
        query.setParameter(1, demographicNo);
        query.setParameter(2, from);
        query.setParameter(3, to);
        

        return query.getResultList();
    }
    
    public Appointment search_appt_no(String providerNo, Date appointmentDate, Date startTime, Date endTime, Date createDateTime, String creator, Integer demographicNo) {
    	String sql = "select a from Appointment a where a.providerNo=? and a.appointmentDate=? and a.startTime=? and "+
    				"a.endTime=? and a.createDateTime=? and a.creator=? and a.demographicNo=? order by a.id desc";
    	Query query = entityManager.createQuery(sql.toString());
        query.setParameter(1, providerNo);
        query.setParameter(2, appointmentDate);
        query.setParameter(3, startTime);
        query.setParameter(4, endTime);
        query.setParameter(5, createDateTime);
        query.setParameter(6, creator);
        query.setParameter(7, demographicNo);
        query.setMaxResults(1);
        
        return this.getSingleResultOrNull(query);
    }
    
    public List<Object[]> search_appt_data1(String providerNo, Date appointmentDate, Date startTime, Date endTime, Date createDateTime, String creator, Integer demographicNo) {
    	String sql = "from Provider prov, Appointment app " +
    			"where app.providerNo = prov.id and " +
    			"app.providerNo=? and " +
    			"app.appointmentDate=? and " + 
    			"app.startTime=? and "  +
    			"app.endTime=? and " +
    			"app.createDateTime=? and " + 
    			"app.creator=? and " +
    			"app.demographicNo=? " +
    			"order by app.id desc";
    	Query query = entityManager.createQuery(sql);
    	query.setMaxResults(1);
    	query.setParameter(1, providerNo);
    	 
         query.setParameter(2, appointmentDate);
         query.setParameter(3, startTime);
         query.setParameter(4, endTime);
         query.setParameter(5, createDateTime);
         query.setParameter(6, creator);
         query.setParameter(7, demographicNo);
         
         return query.getResultList();
    }
    
    public List<Object[]> export_appt(Integer demographicNo) {
    	String sql="from Appointment app, Provider prov where app.id = prov.id and app.demographicNo = ?";
    	Query query = entityManager.createQuery(sql);
    	query.setParameter(1, demographicNo);
         
        return query.getResultList();
    }
    
    public List<Appointment> search_otherappt(Date appointmentDate, Date startTime1, Date endTime1, Date startTime2, Date startTime3) {
    	String sql = "from Appointment a where a.appointmentDate=? and ((a.startTime <= ? and a.endTime >= ?) or (a.startTime > ? and a.startTime < ?) ) order by a.providerNo, a.startTime";
    	
    	
    	Query query = entityManager.createQuery(sql);
    	query.setParameter(1, appointmentDate);
         query.setParameter(2, startTime1);
         query.setParameter(3, endTime1);
         query.setParameter(4, startTime2);
         query.setParameter(5, startTime3);
          
         return query.getResultList();
    }
    
    public List<Appointment> search_group_day_appt(String myGroup, Integer demographicNo, Date appointmentDate) {
    	String sql = "select a  from Appointment a, MyGroup m " +
    			"where m.id.providerNo = a.providerNo " +
    			"and a.status <> 'C' " +
    			"and m.id.myGroupNo = ? " +
    			"and a.demographicNo = ? " +
    			"and a.appointmentDate = ?";
    	
    	
    	Query query = entityManager.createQuery(sql);
    	query.setParameter(1, myGroup);
        query.setParameter(2, demographicNo);
        query.setParameter(3, appointmentDate);
        
        return query.getResultList();
    }


	public Appointment findByDate(Date appointmentDate) {
		Query query = createQuery("a", "a.appointmentDate < :appointmentDate ORDER BY a.appointmentDate DESC");
		query.setMaxResults(1);
		query.setParameter("appointmentDate", appointmentDate);
		return getSingleResultOrNull(query);
    }
	
	public List<Object[]> findAppointmentAndProviderByAppointmentNo(Integer apptNo) {
		String sql = "FROM Appointment a, Provider p WHERE a.providerNo = p.ProviderNo AND a.id = :apptNo";
		Query query = entityManager.createQuery(sql);
		query.setParameter("apptNo", apptNo);
		return query.getResultList();
	}
    
    public List<Appointment> searchappointmentday(String providerNo, Date appointmentDate, Integer programId) {
    	Query query = createQuery("appt", "appt.providerNo = :providerNo AND appt.appointmentDate = :appointmentDate AND appt.programId = :programId ORDER BY appt.startTime, appt.status DESC");
    	query.setParameter("providerNo", providerNo);
        query.setParameter("appointmentDate", appointmentDate);
        query.setParameter("programId", programId);
        return query.getResultList();
    }

	@NativeSql({"demographic", "appointment", "drugs", "provider"})
    public List<Object[]> findAppointmentsByDemographicIds(Set<String> demoIds, Date from, Date to) {   	
		String sql = "" +
				"select " +
				"a.appointment_date, " +
				"concat(pAppt.first_name, ' ', pAppt.last_name), " +
				"concat(pFam.first_name, ' ', pFam.last_name), " +
				"bi.service_code, " +
				"drugs.BN, " +
				"concat(pDrug.first_name,' ',pDrug.last_name), " +
				"a.demographic_no, " +
				"drugs.GN, " +
				"drugs.customName " +
				"from demographic d," +
				"appointment a left outer join drugs " +
				"on drugs.demographic_no = a.demographic_no and drugs.rx_date = a.appointment_date and a.appointment_date >= :from and a.appointment_date <= :to and a.demographic_no in (:demoIds) " +
				" left join provider pDrug on pDrug.provider_no = drugs.provider_no, billing_on_cheader1 bc, billing_on_item bi, provider pAppt, provider pFam where a.appointment_date >= :from and a.appointment_date <= :to and a.demographic_no = d.demographic_no" +
				" and a.provider_no = pAppt.provider_no and d.provider_no = pFam.provider_no and bc.appointment_no = a.appointment_no and bi.ch1_id = bc.id and a.demographic_no in (:demoIds) order by a.demographic_no, a.appointment_date";
		
		Query query = entityManager.createNativeQuery(sql);
		query.setParameter("demoIds", demoIds);
		query.setParameter("from", from);
		query.setParameter("to", to);
		return query.getResultList();
    }

	/**
	 * Get billed appointment history. 
	 * Used if using the Clinicaid billing integration.
	 */
	public List<Appointment> findPatientBilledAppointmentsByProviderAndAppointmentDate(
			String providerNo, 
			Date startAppointmentDate, 
			Date endAppointmentDate ) 
	{
		String queryString = "FROM Appointment WHERE " +
			"providerNo = ? AND " +
			"appointmentDate >= ? AND " +
			"appointmentDate <= ? AND " +
			"status = 'B' AND " + 
			"demographicNo <> 0 " + 
			"ORDER BY appointmentDate DESC, startTime DESC ";

		Query q = entityManager.createQuery(queryString);
		q.setParameter(1, providerNo);
		q.setParameter(2, startAppointmentDate);
		q.setParameter(3, endAppointmentDate);
		
		@SuppressWarnings("unchecked")
		List<Appointment> results = q.getResultList();
		
		return results;
	}
	
    
	/**
	 * Get unbilled appointment history. 
	 * Used if using the Clinicaid billing integration.
	 */
	public List<Appointment> findPatientUnbilledAppointmentsByProviderAndAppointmentDate(
			String providerNo, 
			Date startAppointmentDate, 
			Date endAppointmentDate ) 
	{

		String queryString = "FROM Appointment WHERE " +
			"providerNo = ? AND " +
			"appointmentDate >= ? AND " +
			"appointmentDate <= ? AND " + 
			"status NOT LIKE 'B%' AND " + 
			"status NOT LIKE 'C%' AND " + 
			"status NOT LIKE 'N%' AND " + 
			"status NOT LIKE 'T%' AND " +
			"status NOT LIKE 't%' AND " + 
			"demographicNo != 0 " + 
			"ORDER BY appointmentDate DESC, startTime DESC";

		Query q = entityManager.createQuery(queryString);
		q.setParameter(1, providerNo);
		q.setParameter(2, startAppointmentDate);
		q.setParameter(3, endAppointmentDate);
		
		@SuppressWarnings("unchecked")
		List<Appointment> results = q.getResultList();
		
		return results;
	}
	

	/**
	 * This methods persists appointment information.
	 * 
	 * @param appt	the appointment object to be saved
	 * @return apptId  the appointment id
	 */
	public Appointment saveAppointment(Appointment appt) {
		Appointment appointment = null;
		try {
			//entityManager.getTransaction().begin();
			appointment = saveEntity(appt);
			//entityManager.getTransaction().commit();
		} catch (Exception e) {
			log.error("Error occured in AppointmentService.addAppointments " + e);
		}
		return appointment;
	}
	
	/**
	 * Returns list of appointment details for a provider
	 * 
	 * @param providerNo		the provider number
	 * @return					appointment list
	 */
	public List<Appointment> getAppointmentsByAppointmentDate(String appointmentDate) {

			String sql = "From Appointment a where date_format(a.appointmentDate, '%d-%b-%Y') = :date ";
			Query query = entityManager.createQuery(sql);
			query.setParameter("date", appointmentDate);
			return query.getResultList();
	}
	
	/**
	 * Returns list of appointment details for a provider
	 * 
	 * @param providerNo		the provider number
	 * @return					appointment list
	 */
	public List<Appointment> getAppointmentsByAppointmentDate(String appointmentDate, String providerNo) {

			String sql = "From Appointment a where date_format(a.appointmentDate, '%d-%b-%Y') = :date and a.providerNo=:providerNo";
			Query query = entityManager.createQuery(sql);
			query.setParameter("date", appointmentDate);
			query.setParameter("providerNo", providerNo);
			return query.getResultList();
	}
	
	/**
	 * Returns list of appointment types
	 * 
	 * @return					appointment type list
	 */
	public List<AppointmentType> getAppointmentType() {
		String sql = "From AppointmentType a";
		Query query = entityManager.createQuery(sql);
		return query.getResultList();
	}
	
	/**
	 * Returns list of appointment status
	 * 
	 * @return					appointment status list
	 */
	public List<AppointmentStatus> getAppointmentStatus() {
		String sql = "From AppointmentStatus a";
		Query query = entityManager.createQuery(sql);
		return query.getResultList();
	}
	
	/**
	 * Deletes appointment
	 * 
	 * @param apptNo		appointment number
	 */
	public void deleteAppointment(int apptNo) {
		Appointment appt = this.find(apptNo);
		if(appt != null) {
			log.debug("OscarAppointmentDao.deleteAppointment()"+appt);
			entityManager.remove(appt);
		}
	}
	
	/**
	 * Returns list of appointment details for a provider
	 * 
	 * TODO: Pass in Date objects not Strings!!!
	 * 
	 * @param providerNo		the provider number
	 * @return					appointment list
	 */
	public List<Appointment> getAppointmentsForWeek(String startDate, String endDate, String providerNo) {
		Date loStartDate = null, loEndDate = null;
		try {
			loStartDate = org.oscarehr.ws.rest.util.DateUtils.formatDate(startDate);
			loEndDate = org.oscarehr.ws.rest.util.DateUtils.formatDate(endDate);
		}catch(Exception e) {
			return new ArrayList<Appointment>();
		}
		String sql = "From Appointment a where a.appointmentDate between :startDate and :endDate and a.providerNo = :providerNo order by a.appointmentDate";
		Query query = entityManager.createQuery(sql);
		query.setParameter("startDate", loStartDate);
		query.setParameter("endDate", loEndDate);
		query.setParameter("providerNo", providerNo);
		return query.getResultList();
	}

	public List<Appointment> getAppointmentsForWeekTotal(String startDate, String endDate)  {
		Date loStartDate = null, loEndDate = null;
		try {
			loStartDate = org.oscarehr.ws.rest.util.DateUtils.formatDate(startDate);
			loEndDate = org.oscarehr.ws.rest.util.DateUtils.formatDate(endDate);
		}catch(Exception e) {
			return new ArrayList<Appointment>();
		}
		String sql = "From Appointment a where a.appointmentDate between :startDate and :endDate order by a.appointmentDate";
		Query query = entityManager.createQuery(sql);
		query.setParameter("startDate", loStartDate);
		query.setParameter("endDate", loEndDate);
		log.debug("OscarAppointmentDao.getAppointmentsForWeekTotal()"+query.getResultList());
		return query.getResultList();
    }
		
		public List<Appointment> getGroupDayEvents(String group, String day) {
			Date loStartDate = null;
			try {
				loStartDate = org.oscarehr.ws.rest.util.DateUtils.formatDate(day);	
			}catch(Exception e) {
				return new ArrayList<Appointment>();
			}
			
	
			//Date loEndDate = org.oscarehr.ws.rest.util.DateUtils.formatDate(endDate);
			String sql = "From Appointment a where a.providerNo IN (SELECT p.ProviderNo FROM Provider p where p.Team = :group) and a.appointmentDate= :date";
			Query query = entityManager.createQuery(sql);
			query.setParameter("group", group);
			query.setParameter("date", loStartDate);
			//List<Appointment> data = query.getResultList();
			return query.getResultList();
		}
		
		public List<Appointment> getGroupWeekEvents(String stday, String endday,String group) {
			Date loStartDate = null, loEndDate = null;
			try {
				loStartDate = org.oscarehr.ws.rest.util.DateUtils.formatDate(stday);
				loEndDate = org.oscarehr.ws.rest.util.DateUtils.formatDate(endday);
			}catch(Exception e) {
				return new ArrayList<Appointment>();
			}
			String sql = "From Appointment a where a.providerNo IN (SELECT p.ProviderNo FROM Provider p where p.Team = :group) and a.appointmentDate between :startDate and :endDate order by a.appointmentDate";
			Query query = entityManager.createQuery(sql);
			query.setParameter("group", group);
			query.setParameter("startDate", loStartDate);
			query.setParameter("endDate", loEndDate);
			List<Appointment> data = query.getResultList();
			return data;
		}
		
		public List<Appointment> getGroupMonthEvents(String stday, String group) {
			Date loStartDate = null;
			try {
				loStartDate = org.oscarehr.ws.rest.util.DateUtils.formatDate(stday);
			}catch(Exception e) {
				return new ArrayList<Appointment>();
			}
			String sql = "From Appointment a where a.providerNo IN (SELECT p.ProviderNo FROM Provider p where p.Team = :group) and month(a.appointmentDate) = month(:stdate) order by a.appointmentDate";
			Query query = entityManager.createQuery(sql);
			query.setParameter("group", group);
			query.setParameter("stdate", loStartDate);
			List<Appointment> data = query.getResultList();
			return data;
		}
		
		/**
		 * Edit the data
		 * 
		 * @param                   Appointment Object
		 * @return					void
		 */
		
		/*
		
		public void editAppointment(Appointment appt) {
			SessionFactory factory = null;
			Session session = factory.openSession();
		      Transaction tx = null;
		      try{
		         tx = session.beginTransaction();
		         session.update(appt); 
		         tx.commit();
		      }catch (HibernateException e) {
		         if (tx!=null) tx.rollback();
		      }finally {
		         session.close(); 
		      }
		}*/
		
		public void editAppointment(Appointment appt) {
			  //Appointment appt = this.find(apptNo);
			  entityManager.merge(appt);
		}
		
		/**
		 * Returns list of appointment details for a provider
		 * 
		 * @param providerNo		the provider number
		 * @return					appointment list
		 */
		
		public List<Appointment> getSelectedAppointment(Integer appointmentNo) {
			List<Appointment> rs = new java.util.ArrayList<Appointment>();
			try{
			String sql = "SELECT a FROM Appointment a WHERE a.id = " + appointmentNo + " ORDER BY a.id";
			Query query = entityManager.createQuery(sql);		
			 rs = query.getResultList();
			}catch(Exception e){
			}
			return rs;
		}

		public List<Appointment> getExistAppointments(Integer demographicNo) {
			String sql = "From Appointment a, Demographic d where a.demographicNo = :demographicNo";
			Query query = entityManager.createQuery(sql);
			query.setParameter("demographicNo", demographicNo);
			List<Appointment> data = query.getResultList();

			return data;
        }
		
		public boolean updateAppointmentStatus(Integer apptId,String apptStatus){
			boolean success=false;
			try{
				String sql = "update Appointment a set a.status = '"+apptStatus+"' WHERE a.id = " + apptId ;
				Query query = entityManager.createQuery(sql);		
				 int i =  query.executeUpdate();
				 success = true;
				}catch(Exception e){
					success = false;
				}
				return success;
			}
			
			public boolean updateAppointmentType(Integer apptId,String type){
				boolean success=false;
				try{
					String sql = "update Appointment a set a.type = '"+type+"' WHERE a.id = " + apptId ;
					Query query = entityManager.createQuery(sql);		
					 int i =  query.executeUpdate();
					 success = true;
					}catch(Exception e){
						success = false;
					}
					return success;
			}
			
			public boolean updateAppointmentCriticality(Integer apptId,String urgency){
				boolean success=false;
				try{
					String sql = "update Appointment a set a.urgency = '"+urgency+"' WHERE a.id = " + apptId ;
					Query query = entityManager.createQuery(sql);		
					 int i =  query.executeUpdate();
					 success = true;
					}catch(Exception e){
						success = false;
					}
					return success;
					
			}


			public List<Map<String,String>> getActiveProvidersForDropdown() {
				List<Map<String,String>> result = null;
				try{
					String sql = "SELECT p.ProviderNo,CONCAT(CONCAT(p.FirstName, ', '), p.LastName) FROM Provider p where p.Status='1' and p.ProviderType != 'system' ";
					Query query = entityManager.createQuery(sql);
					List<Object[]> rows = query.getResultList();
					
					result = getOptions(rows, "Individual");
				}catch(Exception e){
					
				}
				return result;
			}
			
			public List getActiveGroupsForDropdown() {
				List<Map<String,String>> result = null;
				try{
					String sql = "SELECT DISTINCT g.id.myGroupNo,g.id.myGroupNo FROM MyGroup g";
					Query query = entityManager.createQuery(sql);
					List<Object[]> rows = query.getResultList();
					
					result = getOptions(rows, "Group");
				}catch(Exception e){
					
				}
				return result;
			}
			
			private List<Map<String,String>> getOptions(List<Object[]> rows, String category){
				List<Map<String,String>> data = new ArrayList<Map<String,String>>();
				Map<String,String> result = null;
				for (Object[] row : rows) {
					result = new HashMap<String,String>();
				    result.put("id", String.valueOf(row[0]));
				    result.put("label", String.valueOf(row[1]));
				    result.put("category", category);
				    data.add(result);
				}
				return data;
			}
			
			
			public List<Appointment> getByProvidersAndDay(Date date, String providerNo) {
				String sql = "SELECT a FROM Appointment a WHERE a.providerNo IN ('"+providerNo+"') and a.appointmentDate = ? order by a.startTime";
				Query query = entityManager.createQuery(sql);
				
				query.setParameter(1, date);
				
				List<Appointment> rs = query.getResultList();

				return rs;
			}
			//TODO: FIX..this may be wrong now that I added quotes. A List<String> should be the input
			public List<Provider> getProvidersByAppointments(List<String> providers,Date apptDate) {
				String inClause = "";
				for(int x=0;x<providers.size();x++) {
					String provider = providers.get(x);
					if(x>0) {
						inClause += ",";
					}
					inClause += "'" +  provider + "'";
				}
				String sql = "select distinct b from Appointment a,Provider b where a.providerNo = b.ProviderNo and a.providerNo in ("+inClause+")  and a.appointmentDate=?";
				
				
				Query query = entityManager.createQuery(sql);
				
				query.setParameter(1, apptDate);
				
				List<Provider> rs = query.getResultList();

				return rs;
			}
			
			public List<Appointment> getSelectedRecAppointment(Integer recId,Date startDate,Date endDate) {
				List<Appointment> rs = new java.util.ArrayList<Appointment>();
				try{
				String sql = "SELECT a FROM Appointment a WHERE a.recurrenceId = " + recId + " and a.appointmentDate >=? and a.appointmentDate <= ?";
				Query query = entityManager.createQuery(sql);
				query.setParameter(1, startDate);
				query.setParameter(2, endDate);
			
				 rs = query.getResultList();
				}catch(Exception e){
				}
				return rs;
			}


			
}
