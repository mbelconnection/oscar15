/**
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
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada   Creates a new instance of PreventionData
 *
 *
 * PreventionData.java
 *
 * Created on May 25, 2005, 10:16 PM
 */

package oscar.oscarPrevention;

import java.net.MalformedURLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.caisi_integrator.CaisiIntegratorManager;
import org.oscarehr.PMmodule.caisi_integrator.RemotePreventionHelper;
import org.oscarehr.caisi_integrator.ws.CachedDemographicPrevention;
import org.oscarehr.caisi_integrator.ws.CachedFacility;
import org.oscarehr.caisi_integrator.ws.DemographicWs;
import org.oscarehr.util.DbConnectionFilter;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.MiscUtils;

import oscar.oscarDB.DBHandler;
import oscar.oscarDemographic.data.DemographicData;
import oscar.oscarProvider.data.ProviderData;
import oscar.util.UtilDateUtilities;

public class PreventionData {
	private static Logger log = MiscUtils.getLogger();

	/*
	 * create table preventions( id int(10) NOT NULL auto_increment primary key, demographic_no int(10) NOT NULL default '0', creation_date datetime, prevention_date date,
	 * provider_no varchar(6) NOT NULL default '', provider_name varchar(255), prevention_type varchar(20), next_date date, never char(1) default '0', deleted char(1) default '0',
	 * refused char(1) default '0', creator varchar(6) default NULL )
	 * 
	 * need to add next_date
	 * 
	 * create table preventionsExt( id int(10) NOT NULL auto_increment primary key, prevention_id int(10), keyval varchar(20), val text )
	 */

	private PreventionData() {
		// prevent instantiation
	}

	public static void insertPreventionData(String creator, String demoNo, String date, String providerNo, String providerName, String preventionType, String refused, String nextDate,
			String neverWarn, ArrayList<Map<String,String>> list) {
		String sql = null;
		try {
			
			ResultSet rs;
			sql = "Insert into preventions (creator,demographic_no,prevention_date,provider_no,provider_name,prevention_type,refused,creation_date,next_date,never) values " + "('"
					+ creator + "','" + demoNo + "','" + date + "','" + providerNo + "','" + providerName + "','" + preventionType + "','" + refused + "',now(),'" + nextDate
					+ "','" + neverWarn + "')";
			log.debug(sql);
			DBHandler.RunSQL(sql);
			rs = DBHandler.GetSQL("select Last_insert_id()");
			int insertId = -1;
			if (rs.next()) {
				insertId = rs.getInt(1);
			}
			if (insertId != -1) {
				for (int i = 0; i < list.size(); i++) {
					Map<String,String> h = list.get(i);
					for (Map.Entry<String, String> entry : h.entrySet()) {
						if (entry.getKey() != null && entry.getValue() != null) {
							addPreventionKeyValue("" + insertId, entry.getKey(), entry.getValue());
						}
					}
				}
			}
		}
		catch (SQLException e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
	}

	public static void addPreventionKeyValue(String preventionId, String keyval, String val) {
		String sql = null;
		try {
			sql = "Insert into preventionsExt (prevention_id,keyval,val) values " + "('" + preventionId + "','" + keyval + "','" + StringEscapeUtils.escapeSql(val) + "')";
			log.debug(sql);
			DBHandler.RunSQL(sql);
		}
		catch (SQLException e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
	}

	public static Map<String,String> getPreventionKeyValues(String preventionId) {
		Map<String,String> h = new HashMap<String,String>();
		String sql = null;
		try {
			
			ResultSet rs;
			sql = "select * from  preventionsExt where prevention_id = '" + preventionId + "'";
			log.debug(sql);
			rs = DBHandler.GetSQL(sql);
			while (rs.next()) {
				String key = oscar.Misc.getString(rs, "keyval");
				String val = oscar.Misc.getString(rs, "val");
				if (key != null && val != null) {
					h.put(key, val);
				}
			}
		}
		catch (SQLException e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
		return h;
	}

	public static void deletePreventionData(String id) {
		String sql = null;
		try {
			
			
			sql = "update preventions set deleted = '1' where id = '" + id + "' "; // TODO: logg this in the Deletion record table or generic logging table
			log.debug(sql);
			DBHandler.RunSQL(sql);
		}
		catch (SQLException e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
	}

	public static void setNextPreventionDate(String date, String id) {
		String sql = null;
		try {
			
			
			sql = "update preventions set next_date = '" + date + "' where id = '" + id + "' ";
			log.debug(sql);
			DBHandler.RunSQL(sql);
		}
		catch (SQLException e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
	}

	public static String getProviderName(Map<String,Object> hash) {
		String name = "";
		if (hash != null) {
			String proNum =  (String) hash.get("provider_no");
			if (proNum == null || proNum.equals("-1")) {
				name = (String) hash.get("provider_name");
			}
			else {
				name = ProviderData.getProviderName(proNum);
			}
		}
		return name;
	}

	public static void updatetPreventionData(String id, String creator, String demoNo, String date, String providerNo, String providerName, String preventionType, String refused,
			String nextDate, String neverWarn, ArrayList<Map<String,String>> list) {
		deletePreventionData(id);
		insertPreventionData(creator, demoNo, date, providerNo, providerName, preventionType, refused, nextDate, neverWarn, list);
	}

	public static ArrayList<Map<String,Object>> getPreventionData(String demoNo) {
		return getPreventionData("%", demoNo);
	}

	public static ArrayList<Map<String,Object>> getPreventionDataFromExt(String extKey, String extVal) {
		ArrayList<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String sql = null;
		try {
			
			ResultSet rs;
			sql = "Select prevention_id from preventionsExt where  keyval = '" + extKey + "' and val = '" + extVal + "'";
			log.debug(sql);
			rs = DBHandler.GetSQL(sql);
			while (rs.next()) {
				Map<String,Object> hash = getPreventionById(oscar.Misc.getString(rs, "prevention_id"));
				if (hash.get("deleted") != null && ((String) hash.get("deleted")).equals("0")) {
					list.add(hash);
				}
			}
		}
		catch (SQLException e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
		return list;
	}

        /*
         * Fetch one extended prevention key
         * Requires prevention id and keyval to return
         */
        public static String getExtValue(String id, String keyval) {
            String sql = "select val from preventionsExt where prevention_id = ? and keyval = ?";
           
            String key = "";
		try {           

                    PreparedStatement pstmt = DbConnectionFilter.getThreadLocalDbConnection().prepareStatement(sql);
                    pstmt.setString(1, id);
                    pstmt.setString(2, keyval);
                    ResultSet rs = pstmt.executeQuery();

                    if( rs.next() ) {
                        key = rs.getString(1);
                    }

                    rs.close();
                    pstmt.close();
                }
                catch (Exception e) {
                    log.error(e.getMessage(), e);
                    log.error(sql);
		}

            return key;
        }

	// //////
	/**
	 *Method to get a list of (demographic #, prevention dates, and key values) of a certain type <injectionTppe> from a start Date to an end Date with a Ext key value EG get all
	 * Rh injection's product #, from 2006-12-12 to 2006-12-18
	 * 
	 */
	public static ArrayList<Map<String,Object>> getExtValues(String injectionType, java.util.Date startDate, java.util.Date endDate, String keyVal) {
		String sql = "select preventions.id as preventions_id, demographic_no, prevention_date ,val from preventions, preventionsExt where preventions.id = preventionsExt.prevention_id  and prevention_type = ? and prevention_date >= ? and prevention_date <= ? and preventionsExt.keyval = ? and preventions.deleted = '0' and preventions.refused = '0' order by prevention_date";

		ArrayList<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		
		try {
			// log.debug("e-DATE: "+date);		

			PreparedStatement pstmt = DbConnectionFilter.getThreadLocalDbConnection().prepareStatement(sql);
			pstmt.setString(1, injectionType);
			pstmt.setDate(2, new java.sql.Date(startDate.getTime()));
			pstmt.setDate(3, new java.sql.Date(endDate.getTime()));
			pstmt.setString(4, keyVal);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				Map<String,Object> h = new HashMap<String,Object>();
                h.put("preventions_id", rs.getString("preventions_id"));
				h.put("demographic_no", oscar.Misc.getString(rs, "demographic_no"));
				h.put("val", oscar.Misc.getString(rs, "val"));
				h.put("prevention_date", rs.getDate("prevention_date"));
				list.add(h);
			}

			rs.close();
			pstmt.close();
		}
		catch (Exception e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
		return list;
	}

	public static Date getDemographicDateOfBirth(String demoNo)
	{
		DemographicData dd = new DemographicData();		
		return(dd.getDemographicDOB(demoNo));
	}	
	
	public static ArrayList<Map<String,Object>> getPreventionData(String preventionType, String demoNo) {
		ArrayList<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String sql = null;
		java.util.Date dob = getDemographicDateOfBirth(demoNo);

		try {
			
			ResultSet rs;
			sql = "Select * from preventions where  demographic_no = '" + demoNo + "' and prevention_type like '" + preventionType + "' and deleted != 1 order by prevention_date";
			log.debug(sql);
			rs = DBHandler.GetSQL(sql);
			while (rs.next()) {
				Map<String,Object> h = new HashMap<String,Object>();
				h.put("id", oscar.Misc.getString(rs, "id"));
				h.put("refused", oscar.Misc.getString(rs, "refused"));
				h.put("type", oscar.Misc.getString(rs, "prevention_type"));
				log.debug("id set to " + oscar.Misc.getString(rs, "id"));
				h.put("provider_no", oscar.Misc.getString(rs, "provider_no"));
				h.put("provider_name", oscar.Misc.getString(rs, "provider_name"));
				h.put("prevention_date", blankIfNull(oscar.Misc.getString(rs, "prevention_date")));
				java.util.Date date = null;

				try {
					date = rs.getDate("prevention_date");
					h.put("prevention_date_asDate", date);
				}
				catch (Exception pe) {
					log.error("error", pe);
				}
				
				String age = "N/A";
				if (date != null) {
					age = UtilDateUtilities.calcAgeAtDate(dob, date);
				}
				h.put("age", age);
				list.add(h);
			}
		}
		catch (SQLException e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
		return list;
	}

	public static ArrayList<HashMap<String,Object>> getLinkedRemotePreventionData(String preventionType, Integer localDemographicId) throws MalformedURLException {
		ArrayList<HashMap<String, Object>> allResults=RemotePreventionHelper.getLinkedPreventionDataMap(localDemographicId);
		ArrayList<HashMap<String, Object>> filteredResults=new ArrayList<HashMap<String, Object>>();

		for (HashMap<String, Object> temp : allResults) {
			if (preventionType.equals(temp.get("type"))) {
				filteredResults.add(temp);
			}
		}
			
		return(filteredResults);
	}
	
	private static String blankIfNull(String s) {
		if (s == null) return "";
		return s;
	}

	public static String getPreventionComment(String id) {
		log.debug("Calling getPreventionComment " + id);
		String comment = null;
		String sql = null;
		try {
			
			ResultSet rs;
			sql = "Select val from preventionsExt where  prevention_id = '" + id + "' and keyval = 'comments' ";
			log.debug(sql);
			rs = DBHandler.GetSQL(sql);
			if (rs.next()) {
				comment = oscar.Misc.getString(rs, "val");
				if (comment != null && comment.trim().length() == 0) {
					comment = null;
				}
			}
		}
		catch (SQLException e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
		return comment;
	}

	public static Prevention getPrevention(String demoNo) {
		DemographicData dd = new DemographicData();
		java.util.Date dob = getDemographicDateOfBirth(demoNo);
		String sex = dd.getDemographicSex(demoNo);
		String sql = null;
		Prevention p = new Prevention(sex, dob);

		try {
			
			ResultSet rs;
			sql = "Select * from preventions where  demographic_no = '" + demoNo + "'  and deleted != 1 order by prevention_type,prevention_date";
			log.debug(sql);
			rs = DBHandler.GetSQL(sql);
			while (rs.next()) {
				PreventionItem pi = new PreventionItem(oscar.Misc.getString(rs, "prevention_type"), rs.getDate("prevention_date"), oscar.Misc.getString(rs, "never"), rs
						.getDate("next_date"), rs.getString("refused"));
				p.addPreventionItem(pi);
			}
		}
		catch (SQLException e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
		return p;
	}

	private static List<CachedDemographicPrevention> getRemotePreventions(Integer demographicId) {
		
		List<CachedDemographicPrevention> remotePreventions = null;

		if (LoggedInInfo.loggedInInfo.get().currentFacility.isIntegratorEnabled()) {
			try {
				DemographicWs demographicWs = CaisiIntegratorManager.getDemographicWs();
				remotePreventions = demographicWs.getLinkedCachedDemographicPreventionsByDemographicId(demographicId);
			}
			catch (Exception e) {
				log.error("Error", e);
			}
		}

		return (remotePreventions);
	}

	public static Prevention addRemotePreventions(Prevention prevention, Integer demographicId) {
		List<CachedDemographicPrevention> remotePreventions = getRemotePreventions(demographicId);

		if (remotePreventions != null) {
			for (CachedDemographicPrevention cachedDemographicPrevention : remotePreventions) {
				Date preventionDate = MiscUtils.toDate(cachedDemographicPrevention.getPreventionDate());

				PreventionItem pItem = new PreventionItem(cachedDemographicPrevention.getPreventionType(), preventionDate);
				pItem.setRemoteEntry(true);
				prevention.addPreventionItem(pItem);
			}
		}

		return (prevention);
	}

	public static ArrayList<Map<String,Object>> addRemotePreventions(ArrayList<Map<String,Object>> preventions, Integer demographicId, String preventionType, Date demographicDateOfBirth) {
		List<CachedDemographicPrevention> remotePreventions = getRemotePreventions(demographicId);

		if (remotePreventions != null) {
			for (CachedDemographicPrevention cachedDemographicPrevention : remotePreventions) {
				if (preventionType.equals(cachedDemographicPrevention.getPreventionType())) {
					
					Map<String,Object> h = new HashMap<String,Object>();
					h.put("integratorFacilityId", cachedDemographicPrevention.getFacilityPreventionPk().getIntegratorFacilityId());
					h.put("integratorPreventionId", cachedDemographicPrevention.getFacilityPreventionPk().getCaisiItemId());
					String remoteFacilityName="N/A";
					CachedFacility remoteFacility=null;
					try {
						remoteFacility = CaisiIntegratorManager.getRemoteFacility(cachedDemographicPrevention.getFacilityPreventionPk().getIntegratorFacilityId());
					}
					catch (Exception e) {
						log.error("Error", e);
					}
					if (remoteFacility!=null) remoteFacilityName=remoteFacility.getName();
					h.put("remoteFacilityName", remoteFacilityName);
					h.put("integratorDemographicId", cachedDemographicPrevention.getCaisiDemographicId());
					h.put("type", cachedDemographicPrevention.getPreventionType());
					h.put("provider_no", "remote:" + cachedDemographicPrevention.getCaisiProviderId());
					h.put("provider_name", "remote:" + cachedDemographicPrevention.getCaisiProviderId());
					h.put("prevention_date", DateFormatUtils.ISO_DATE_FORMAT.format(cachedDemographicPrevention.getPreventionDate()));
					h.put("prevention_date_asDate", cachedDemographicPrevention.getPreventionDate());

					if (demographicDateOfBirth != null) {
						String age = UtilDateUtilities.calcAgeAtDate(demographicDateOfBirth, MiscUtils.toDate(cachedDemographicPrevention.getPreventionDate()));
						h.put("age", age);
					}
					else
					{
						h.put("age", "N/A");						
					}
										
					preventions.add(h);
				}
			}
			
			Collections.sort(preventions, new PreventionsComparator());
		}
		
		return(preventions);
	}

	public static class PreventionsComparator implements Comparator<Map<String,Object>>
	{
		public int compare(Map<String,Object> o1, Map<String,Object> o2) {
			Comparable date1=(Comparable)o1.get("prevention_date_asDate");
			Comparable date2=(Comparable)o2.get("prevention_date_asDate");
			
			if (date1!=null && date2!=null)
			{
				if (date1 instanceof Calendar)
				{
					date1=((Calendar)date1).getTime();
				}
				
				if (date2 instanceof Calendar)
				{
					date2=((Calendar)date2).getTime();
				}

				return(date1.compareTo(date2));
			}
			else
			{
				return(0);
			}
		}
	}
	
	public static Map<String,Object> getPreventionById(String id) {
		String sql = null;
		Map<String,Object> h = null;
		try {
			
			ResultSet rs;
			sql = "Select * from preventions where  id = '" + id + "' ";
			log.debug(sql);
			rs = DBHandler.GetSQL(sql);
			if (rs.next()) {
				h = new HashMap<String,Object>();
				log.debug("preventionType" + oscar.Misc.getString(rs, "prevention_type"));
				addToHashIfNotNull(h, "id", oscar.Misc.getString(rs, "id"));
				addToHashIfNotNull(h, "provider_no", oscar.Misc.getString(rs, "provider_no"));
				addToHashIfNotNull(h, "demographicNo", oscar.Misc.getString(rs, "demographic_no"));
				addToHashIfNotNull(h, "creationDate", oscar.Misc.getString(rs, "creation_date"));
				addToHashIfNotNull(h, "preventionDate", oscar.Misc.getString(rs, "prevention_date"));
				addToHashIfNotNull(h, "prevention_date_asDate", rs.getDate("prevention_date"));
				// log.debug(rs.getDate("prevention_date"));
				addToHashIfNotNull(h, "providerName", oscar.Misc.getString(rs, "provider_name"));
				addToHashIfNotNull(h, "preventionType", oscar.Misc.getString(rs, "prevention_type"));
				addToHashIfNotNull(h, "deleted", oscar.Misc.getString(rs, "deleted"));
				addToHashIfNotNull(h, "refused", oscar.Misc.getString(rs, "refused"));
				addToHashIfNotNull(h, "next_date", oscar.Misc.getString(rs, "next_date"));
				addToHashIfNotNull(h, "never", oscar.Misc.getString(rs, "never"));

				String refused = " completed";
				switch (Integer.parseInt(oscar.Misc.getString(rs, "refused"))) {
				case 1:
					refused = " refused";
					break;
				case 2:
					refused = " ineligible";
					break;
				}
				String provider = ProviderData.getProviderName(oscar.Misc.getString(rs, "provider_no"));
				String summary = "Prevention " + oscar.Misc.getString(rs, "prevention_type") + " provided by " + provider + " on " + oscar.Misc.getString(rs, "prevention_date")
						+ "\n";
				Map<String,String> ext = getPreventionKeyValues(oscar.Misc.getString(rs, "id"));
				if (ext.containsKey("result")) {
					summary += "Result: " + ext.get("result");
					if (ext.containsKey("reason") && !ext.get("reason").equals("")) {
						summary += "\nReason: " + ext.get("reason");
					}
				} else {
					if (ext.containsKey("name") && !ext.get("name").equals("")) {
						addToHashIfNotNull(h, "name",  ext.get("name"));
						summary += "Name: " + ext.get("name") + "\n";
					}
					if (ext.containsKey("location") && !ext.get("location").equals("")) {
						addToHashIfNotNull(h, "location",  ext.get("location"));
						summary += "Location: " + ext.get("location") + "\n";
					}
					if (ext.containsKey("route") && !ext.get("route").equals("")) {
						addToHashIfNotNull(h, "route",  ext.get("route"));
						summary += "Route: " + ext.get("route") + "\n";
					}
					if (ext.containsKey("dose") && !ext.get("dose").equals("")) {
						addToHashIfNotNull(h, "dose",  ext.get("dose"));
						summary += "Dose: " + ext.get("dose") + "\n";
					}
					if (ext.containsKey("lot") && !ext.get("lot").equals("")) {
						addToHashIfNotNull(h, "lot",  ext.get("lot"));
						summary += "Lot: " + ext.get("lot") + "\n";
					}
					if (ext.containsKey("manufacture") && !ext.get("manufacture").equals("")) {
						addToHashIfNotNull(h, "manufacture",  ext.get("manufacture"));
						summary += "Manufacturer: " + ext.get("manufacture") + "\n";
					}
					if (ext.containsKey("comments") && !ext.get("comments").equals("")) {
						addToHashIfNotNull(h, "comments",  ext.get("comments"));
						summary += "Comments: " + ext.get("comments");
					}
				}
				addToHashIfNotNull(h, "summary", summary);
				log.debug("1" + h.get("preventionType") + " " + h.size());
				log.debug("id" + h.get("id"));
			}
		}
		catch (SQLException e) {
			log.error(e.getMessage(), e);
			log.error(sql);
		}
		return h;
	}

	private static void addToHashIfNotNull(Map<String,Object> h, String key, String val) {
		if (val != null && !val.equalsIgnoreCase("null")) {
			h.put(key, val);
		}
	}

	private static void addToHashIfNotNull(Map<String,Object> h, String key, java.util.Date val) {
		if (val != null) {
			h.put(key, val);
		}
	}
}