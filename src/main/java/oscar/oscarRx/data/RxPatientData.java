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
 * <OSCAR TEAM> 
 * 
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */

package oscar.oscarRx.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.caisi_integrator.CaisiIntegratorManager;
import org.oscarehr.caisi_integrator.ws.CachedDemographicAllergy;
import org.oscarehr.caisi_integrator.ws.DemographicWs;
import org.oscarehr.common.dao.AllergyDao;
import org.oscarehr.common.dao.PartialDateDao;
import org.oscarehr.common.model.PartialDate;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;

import oscar.oscarDB.DBHandler;

public class RxPatientData {
	private static Logger logger = MiscUtils.getLogger();

	private static final PartialDateDao partialDateDao = (PartialDateDao) SpringUtils.getBean("partialDateDao");

	private RxPatientData() {
		// prevent instantitation
	}

	/* Patient Search */

	public static Patient[] PatientSearch(String surname, String firstName) {

		Patient[] arr = {};
		ArrayList lst = new ArrayList();
		try {

			ResultSet rs;
			Patient p;
			rs = DBHandler.GetSQL("SELECT demographic_no, last_name, first_name, sex, year_of_birth, " + "month_of_birth, date_of_birth, address, city, province, postal, phone " + "FROM demographic WHERE last_name LIKE '" + surname + "%' AND first_name LIKE '" + firstName + "%'");

			while (rs.next()) {
				p = new Patient(rs.getInt("demographic_no"), oscar.Misc.getString(rs, "last_name"), oscar.Misc.getString(rs, "first_name"), oscar.Misc.getString(rs, "sex"), calcDate(oscar.Misc.getString(rs, "year_of_birth"), oscar.Misc.getString(rs, "month_of_birth"), oscar.Misc.getString(rs, "date_of_birth")), oscar.Misc.getString(rs, "address"), oscar.Misc.getString(rs, "city"), oscar.Misc.getString(rs, "province"), oscar.Misc.getString(rs, "postal"), oscar.Misc.getString(rs, "phone"),
				        oscar.Misc.getString(rs, "hin"));
				lst.add(p);
			}
			rs.close();
			arr = (Patient[]) lst.toArray(arr);
		} catch (SQLException e) {
			MiscUtils.getLogger().error("Error", e);
		}
		return arr;

	}

	/* Patient Information */

	public static Patient getPatient(int demographicNo) {

		ResultSet rs;
		Patient p = null;
		try {
			rs = DBHandler.GetSQL("SELECT demographic_no, last_name, first_name, sex, year_of_birth, " + "month_of_birth, date_of_birth, address, city, province, postal, phone,hin " + "FROM demographic WHERE demographic_no = " + demographicNo);

			if (rs.next()) {
				p = new Patient(rs.getInt("demographic_no"), oscar.Misc.getString(rs, "last_name"), oscar.Misc.getString(rs, "first_name"), oscar.Misc.getString(rs, "sex"), calcDate(oscar.Misc.getString(rs, "year_of_birth"), oscar.Misc.getString(rs, "month_of_birth"), oscar.Misc.getString(rs, "date_of_birth")), oscar.Misc.getString(rs, "address"), oscar.Misc.getString(rs, "city"), oscar.Misc.getString(rs, "province"), oscar.Misc.getString(rs, "postal"), oscar.Misc.getString(rs, "phone"),
				        oscar.Misc.getString(rs, "hin"));
				MiscUtils.getLogger().debug(oscar.Misc.getString(rs, "first_name"));
			}
			rs.close();
		} catch (SQLException e) {
			MiscUtils.getLogger().error("Error", e);
		}

		return p;
	}

	public static Patient getPatient(String demographicNo) {

		ResultSet rs;
		Patient p = null;
		try {
			rs = DBHandler.GetSQL("SELECT demographic_no, last_name, first_name, sex, year_of_birth, " + "month_of_birth, date_of_birth, address, city, province, postal, phone,hin " + "FROM demographic WHERE demographic_no = " + demographicNo);

			if (rs.next()) {
				p = new Patient(rs.getInt("demographic_no"), oscar.Misc.getString(rs, "last_name"), oscar.Misc.getString(rs, "first_name"), oscar.Misc.getString(rs, "sex"), calcDate(oscar.Misc.getString(rs, "year_of_birth"), oscar.Misc.getString(rs, "month_of_birth"), oscar.Misc.getString(rs, "date_of_birth")), oscar.Misc.getString(rs, "address"), oscar.Misc.getString(rs, "city"), oscar.Misc.getString(rs, "province"), oscar.Misc.getString(rs, "postal"), oscar.Misc.getString(rs, "phone"),
				        oscar.Misc.getString(rs, "hin"));
			}
			rs.close();
		} catch (SQLException e) {
			MiscUtils.getLogger().error("Error", e);
		}

		return p;
	}

	private static java.util.Date calcDate(String year, String month, String day) {
		if (StringUtils.isBlank(year) || StringUtils.isBlank(month) || StringUtils.isBlank(day)) return null;
		if (!NumberUtils.isDigits(year) || !NumberUtils.isDigits(month) || !NumberUtils.isDigits(day)) return null;

		int iYear = Integer.parseInt(year);
		int iMonth = Integer.parseInt(month) - 1;
		int iDay = Integer.parseInt(day);

		GregorianCalendar ret = new GregorianCalendar(iYear, iMonth, iDay);
		return ret.getTime();
	}

	private static int calcAge(java.util.Date DOB) {
		if (DOB == null) return 0;

		GregorianCalendar now = new GregorianCalendar();
		int curYear = now.get(Calendar.YEAR);
		int curMonth = (now.get(Calendar.MONTH) + 1);
		int curDay = now.get(Calendar.DAY_OF_MONTH);

		Calendar cal = new GregorianCalendar();
		cal.setTime(DOB);
		int iYear = cal.get(Calendar.YEAR);
		int iMonth = (cal.get(Calendar.MONTH) + 1);
		int iDay = cal.get(Calendar.DAY_OF_MONTH);
		int age = 0;

		if (curMonth > iMonth || (curMonth == iMonth && curDay >= iDay)) {
			age = curYear - iYear;
		} else {
			age = curYear - iYear - 1;
		}

		return age;
	}

	public static class Patient {
		int demographicNo;
		String surname;
		String firstName;
		String sex;
		java.util.Date DOB;
		String address;
		String city;
		String province;
		String postal;
		String phone;
		String hin;

		public Patient(int demographicNo, String surname, String firstName, String sex, java.util.Date DOB, String address, String city, String province, String postal, String phone, String hin) {

			this.demographicNo = demographicNo;
			this.surname = surname;
			this.firstName = firstName;
			this.sex = sex;
			this.DOB = DOB;
			this.address = address;
			this.city = city;
			this.province = province;
			this.postal = postal;
			this.phone = phone;
			this.hin = hin;
		}

		public int getDemographicNo() {
			return this.demographicNo;
		}

		public String getSurname() {
			return this.surname;
		}

		public String getFirstName() {
			return this.firstName;
		}

		public String getSex() {
			return this.sex;
		}

		public String getHin() {
			return this.hin;
		}

		public java.util.Date getDOB() {
			return this.DOB;
		}

		public int getAge() {
			return calcAge(this.getDOB());
		}

		public String getAddress() {
			return this.address;
		}

		public String getCity() {
			return this.city;
		}

		public String getProvince() {
			return this.province;
		}

		public String getPostal() {
			return this.postal;
		}

		public String getPhone() {
			return this.phone;
		}

		public Allergy getAllergy(int id) {

			// I know none of this method makes sense, but I'm only converting this to JPA right now, too much work to fix it all to make sense.
			AllergyDao allergyDao = (AllergyDao) SpringUtils.getBean("allergyDao");
			org.oscarehr.common.model.Allergy tempAllergy = allergyDao.find(id);

			Allergy allergy = new Allergy(tempAllergy.getDemographicNo(), tempAllergy.getAllergyId(), tempAllergy.getEntryDate(), tempAllergy.getDescription(), tempAllergy.getHiclSeqno(), tempAllergy.getHicSeqno(), tempAllergy.getAgcsp(), tempAllergy.getAgccs(), tempAllergy.getTypeCode());
			allergy.getAllergy().setReaction(tempAllergy.getReaction());
			allergy.getAllergy().setStartDate(tempAllergy.getStartDate());
			allergy.getAllergy().setAgeOfOnset(tempAllergy.getAgeOfOnset());
			allergy.getAllergy().setSeverityOfReaction(tempAllergy.getSeverityOfReaction());
			allergy.getAllergy().setOnSetOfReaction(tempAllergy.getOnsetOfReaction());
			allergy.getAllergy().setRegionalIdentifier(tempAllergy.getRegionalIdentifier());
			allergy.getAllergy().setLifeStage(tempAllergy.getLifeStage());

			return allergy;
		}

		public Allergy[] getAllergies() {
			ArrayList<Allergy> results = new ArrayList<Allergy>();
			try {

				ResultSet rs;
				Allergy allergy;

				rs = DBHandler.GetSQL("SELECT * FROM allergies WHERE demographic_no = '" + getDemographicNo() + "' ORDER BY archived, CASE severity_of_reaction when 4 then severity_of_reaction end asc, CASE severity_of_reaction when  3 then severity_of_reaction end desc, CASE severity_of_reaction when 2 then severity_of_reaction end desc");

				while (rs.next()) {
					allergy = new Allergy(getDemographicNo(), rs.getInt("allergyid"), rs.getDate("entry_date"), oscar.Misc.getString(rs, "DESCRIPTION"), rs.getInt("HICL_SEQNO"), rs.getInt("HIC_SEQNO"), rs.getInt("AGCSP"), rs.getInt("AGCCS"), rs.getInt("TYPECODE"));

					allergy.getAllergy().setArchived(rs.getString("archived"));
					allergy.getAllergy().setReaction(oscar.Misc.getString(rs, "reaction"));
					allergy.getAllergy().setStartDate(rs.getDate("start_date"));
					allergy.getAllergy().setAgeOfOnset(oscar.Misc.getString(rs, "age_of_onset"));
					allergy.getAllergy().setSeverityOfReaction(oscar.Misc.getString(rs, "severity_of_reaction"));
					allergy.getAllergy().setOnSetOfReaction(oscar.Misc.getString(rs, "onset_of_reaction"));
					allergy.getAllergy().setRegionalIdentifier(oscar.Misc.getString(rs, "regional_identifier"));
					allergy.getAllergy().setLifeStage(oscar.Misc.getString(rs, "life_stage"));
					allergy.getAllergy().setPickID(rs.getInt("drugref_id"));
					allergy.getAllergy().setPosition(rs.getInt("position"));
					results.add(allergy);
				}
				rs.close();
			} catch (SQLException e) {
				MiscUtils.getLogger().error("Error", e);
			}

			LoggedInInfo loggedInInfo = LoggedInInfo.loggedInInfo.get();
			if (loggedInInfo.currentFacility.isIntegratorEnabled()) {
				try {
					DemographicWs demographicWs = CaisiIntegratorManager.getDemographicWs();
					List<CachedDemographicAllergy> remoteAllergies = demographicWs.getLinkedCachedDemographicAllergies(demographicNo);

					for (CachedDemographicAllergy remoteAllergy : remoteAllergies) {
						Date date = null;
						if (remoteAllergy.getEntryDate() != null) date = remoteAllergy.getEntryDate().getTime();

						Allergy allergy = new Allergy(getDemographicNo(), remoteAllergy.getFacilityIdIntegerCompositePk().getCaisiItemId().intValue(), date, remoteAllergy.getDescription(), remoteAllergy.getHiclSeqNo(), remoteAllergy.getHicSeqNo(), remoteAllergy.getAgcsp(), remoteAllergy.getAgccs(), remoteAllergy.getTypeCode());
						allergy.setIntegratorResult(true);

						allergy.getAllergy().setReaction(remoteAllergy.getReaction());

						if (remoteAllergy.getStartDate() != null) date = remoteAllergy.getStartDate().getTime();
						allergy.getAllergy().setStartDate(date);

						allergy.getAllergy().setAgeOfOnset(remoteAllergy.getAgeOfOnset());
						allergy.getAllergy().setSeverityOfReaction(remoteAllergy.getSeverityCode());
						allergy.getAllergy().setOnSetOfReaction(remoteAllergy.getOnSetCode());
						allergy.getAllergy().setRegionalIdentifier(remoteAllergy.getRegionalIdentifier());
						allergy.getAllergy().setLifeStage(remoteAllergy.getLifeStage());
						allergy.getAllergy().setPickID(remoteAllergy.getPickId());
						results.add(allergy);
					}
				} catch (Exception e) {
					logger.error("error getting remote allergies", e);
				}
			}

			return (results.toArray(new Allergy[0]));
		}

		public Allergy[] getActiveAllergies() {
			Allergy[] arr = {};
			LinkedList lst = new LinkedList();
			try {

				ResultSet rs;
				Allergy allergy;

				rs = DBHandler.GetSQL("SELECT * FROM allergies WHERE demographic_no = '" + getDemographicNo() + "' and archived=0 ORDER BY position,severity_of_reaction");

				while (rs.next()) {
					allergy = new Allergy(getDemographicNo(), rs.getInt("allergyid"), rs.getDate("entry_date"), oscar.Misc.getString(rs, "DESCRIPTION"), rs.getInt("HICL_SEQNO"), rs.getInt("HIC_SEQNO"), rs.getInt("AGCSP"), rs.getInt("AGCCS"), rs.getInt("TYPECODE"));

					allergy.getAllergy().setArchived(rs.getString("archived"));
					allergy.getAllergy().setReaction(oscar.Misc.getString(rs, "reaction"));
					allergy.getAllergy().setStartDate(rs.getDate("start_date"));
					allergy.getAllergy().setAgeOfOnset(oscar.Misc.getString(rs, "age_of_onset"));
					allergy.getAllergy().setSeverityOfReaction(oscar.Misc.getString(rs, "severity_of_reaction"));
					allergy.getAllergy().setOnSetOfReaction(oscar.Misc.getString(rs, "onset_of_reaction"));
					allergy.getAllergy().setRegionalIdentifier(oscar.Misc.getString(rs, "regional_identifier"));
					allergy.getAllergy().setLifeStage(oscar.Misc.getString(rs, "life_stage"));
					allergy.getAllergy().setPickID(rs.getInt("drugref_id"));
					allergy.getAllergy().setPosition(rs.getInt("position"));
					lst.add(allergy);
				}
				rs.close();
				arr = (Allergy[]) lst.toArray(arr);
			} catch (SQLException e) {
				MiscUtils.getLogger().error("Error", e);
			}

			return arr;
		}

		public Allergy addAllergy(java.util.Date entryDate, RxAllergyData.Allergy allergyCode) {
			Allergy allergy = null;
			try {
				allergy = new Allergy(this.demographicNo, entryDate, allergyCode);
				allergy.Save();
			} catch (SQLException e) {
				MiscUtils.getLogger().error("Error", e);
			}
			return allergy;
		}

		private static boolean setAllergyArchive(int allergyId, String archiveString) {
			
			AllergyDao allergyDao=(AllergyDao) SpringUtils.getBean("allergyDao");
			org.oscarehr.common.model.Allergy allergy=allergyDao.find(allergyId);
			if (allergy!=null)
			{
				allergy.setArchived(archiveString);
				allergyDao.merge(allergy);
				return(true);
			}
			
			return(false);
		}

		public boolean deleteAllergy(int allergyId) {
			return(setAllergyArchive(allergyId, "1"));
		}

		public boolean activateAllergy(int allergyId) {
			return(setAllergyArchive(allergyId, "0"));
		}

		public Disease[] getDiseases() {
			Disease[] arr = {};
			LinkedList lst = new LinkedList();
			try {

				ResultSet rs;
				Disease d;
				rs = DBHandler.GetSQL("SELECT * FROM diseases WHERE demographic_no = '" + getDemographicNo() + "'");
				while (rs.next()) {
					d = new Disease(rs.getInt("diseaseid"), oscar.Misc.getString(rs, "ICD9_E"), rs.getDate("entry_date"));
					lst.add(d);
				}
				rs.close();
				arr = (Disease[]) lst.toArray(arr);
			} catch (SQLException e) {
				MiscUtils.getLogger().error("Error", e);
			}
			return arr;
		}

		public Disease addDisease(String ICD9, java.util.Date entryDate) throws SQLException {
			Disease disease = new Disease(0, ICD9, entryDate);
			disease.Save();
			return disease;
		}

		// TODO should not delete
		public boolean deleteDisease(int diseaseId) throws SQLException {

			String sql = "DELETE FROM diseases WHERE diseaseid = " + diseaseId;
			boolean b = DBHandler.RunSQL(sql);
			return b;
		}

		public RxPrescriptionData.Prescription[] getPrescribedDrugsUnique() {
			return new RxPrescriptionData().getUniquePrescriptionsByPatient(this.getDemographicNo());
		}

		public RxPrescriptionData.Prescription[] getPrescribedDrugs() {
			return new RxPrescriptionData().getPrescriptionsByPatient(this.getDemographicNo());
		}

		public RxPrescriptionData.Prescription[] getPrescribedDrugScripts() {
			return new RxPrescriptionData().getPrescriptionScriptsByPatient(this.getDemographicNo());
		}

		public static class Allergy {
			boolean integratorResult = false;
			int allergyId;
			java.util.Date entryDate;
			RxAllergyData.Allergy allergy;
			int demographicId;

			public Allergy(int demographicId, int allergyId, java.util.Date entryDate, RxAllergyData.Allergy allergy) {
				this.demographicId = demographicId;
				this.allergyId = allergyId;
				this.entryDate = entryDate;
				this.allergy = allergy;
			}

			public Allergy(int demographicId, java.util.Date entryDate, RxAllergyData.Allergy allergy) {
				this.demographicId = demographicId;
				this.allergyId = 0;
				this.entryDate = entryDate;
				this.allergy = allergy;
			}

			public Allergy(int demographicId, int allergyId, java.util.Date entryDate, String DESCRIPTION, int HICL_SEQNO, int HIC_SEQNO, int AGCSP, int AGCCS, int TYPECODE) {
				this.demographicId = demographicId;
				this.allergyId = allergyId;
				this.entryDate = entryDate;
				this.allergy = new RxAllergyData().getAllergy(DESCRIPTION, HICL_SEQNO, HIC_SEQNO, AGCSP, AGCCS, TYPECODE);
			}

			public boolean isIntegratorResult() {
				return (integratorResult);
			}

			public void setIntegratorResult(boolean integratorResult) {
				this.integratorResult = integratorResult;
			}

			public int getAllergyId() {
				return this.allergyId;
			}

			public java.util.Date getEntryDate() {
				return this.entryDate;
			}

			public void setEntryDate(java.util.Date RHS) {
				this.entryDate = RHS;
			}

			public RxAllergyData.Allergy getAllergy() {
				return this.allergy;
			}

			public int getNextPosition() throws SQLException {
				String sql = "SELECT Max(position) FROM allergies WHERE demographic_no=" + demographicId;
				ResultSet rs = DBHandler.GetSQL(sql);

				int position = 0;
				if (rs.next()) {
					position = rs.getInt(1);
				}
				return (position + 1);
			}

			public void Save() throws SQLException {
				
				if (this.getAllergyId() == 0) {
					
					// This logic is twisted and messed up but I'm just converting to JPA, not fixing it... don't know why not all fields are saved, don't care, I'm just converting.
					AllergyDao allergyDao=(AllergyDao) SpringUtils.getBean("allergyDao");
					org.oscarehr.common.model.Allergy newAllergy=new org.oscarehr.common.model.Allergy();

					// need to add to the bottom of list
					newAllergy.setPosition(getNextPosition());
					
					newAllergy.setDemographicNo(demographicId);
					newAllergy.setEntryDate(getEntryDate());
					newAllergy.setDescription(allergy.getDESCRIPTION());
					newAllergy.setHiclSeqno(allergy.getHICL_SEQNO());
					newAllergy.setHicSeqno(allergy.getHIC_SEQNO());
					newAllergy.setAgcsp(allergy.getAGCSP());
					newAllergy.setAgccs(allergy.getAGCCS());
					newAllergy.setTypeCode(allergy.getTYPECODE());
					newAllergy.setReaction(allergy.getReaction());
					newAllergy.setDrugrefId(String.valueOf(allergy.getPickID()));
					newAllergy.setStartDate(allergy.getStartDate());
					newAllergy.setAgeOfOnset(allergy.getAgeOfOnset());
					newAllergy.setSeverityOfReaction(allergy.getSeverityOfReaction());
					newAllergy.setOnsetOfReaction(allergy.getOnSetOfReaction());
					newAllergy.setRegionalIdentifier(allergy.getRegionalIdentifier());
					newAllergy.setLifeStage(allergy.getLifeStage());
					
					LoggedInInfo loggedInInfo=LoggedInInfo.loggedInInfo.get();
					newAllergy.setProviderNo(loggedInInfo.loggedInProvider.getProviderNo());

					allergyDao.persist(newAllergy);
					
					this.allergyId = newAllergy.getId();

				} else {

					// This logic is twisted and messed up but I'm just converting to JPA, not fixing it... don't know why not all fields are saved, don't care, I'm just converting.
					AllergyDao allergyDao=(AllergyDao) SpringUtils.getBean("allergyDao");
					org.oscarehr.common.model.Allergy updateAllergy=allergyDao.find(getAllergyId());

					updateAllergy.setEntryDate(getEntryDate());
					updateAllergy.setDescription(allergy.getDESCRIPTION());
					updateAllergy.setHiclSeqno(allergy.getHICL_SEQNO());
					updateAllergy.setHicSeqno(allergy.getHIC_SEQNO());
					updateAllergy.setAgcsp(allergy.getAGCSP());
					updateAllergy.setAgccs(allergy.getAGCCS());
					updateAllergy.setTypeCode(allergy.getTYPECODE());
					updateAllergy.setReaction(allergy.getReaction());
					updateAllergy.setDrugrefId(String.valueOf(allergy.getPickID()));
					updateAllergy.setStartDate(allergy.getStartDate());
					updateAllergy.setAgeOfOnset(allergy.getAgeOfOnset());
					updateAllergy.setSeverityOfReaction(allergy.getSeverityOfReaction());
					updateAllergy.setOnsetOfReaction(allergy.getOnSetOfReaction());
					updateAllergy.setLifeStage(allergy.getLifeStage());
					updateAllergy.setPosition(allergy.getPosition());
					
					LoggedInInfo loggedInInfo=LoggedInInfo.loggedInInfo.get();
					updateAllergy.setProviderNo(loggedInInfo.loggedInProvider.getProviderNo());

					allergyDao.merge(updateAllergy);
				}

				// write partial date
				partialDateDao.setPartialDate(PartialDate.ALLERGIES, this.getAllergyId(), PartialDate.ALLERGIES_STARTDATE, allergy.getStartDateFormat());
			}

		}

		public class Disease {
			int diseaseId;
			String ICD9;
			java.util.Date entryDate;

			public Disease(int diseaseId, String ICD9, java.util.Date entryDate) {
				this.diseaseId = diseaseId;
				this.ICD9 = ICD9;
				this.entryDate = entryDate;
			}

			public int getDiseaseId() {
				return this.diseaseId;
			}

			public String getICD9() {
				return this.ICD9;
			}

			public void setICD9(String RHS) {
				this.ICD9 = RHS;
			}

			public RxCodesData.Disease getDisease() {
				return new RxCodesData().getDisease(this.getICD9());
			}

			public java.util.Date getEntryDate() {
				return this.entryDate;
			}

			public void setEntryDate(java.util.Date RHS) {
				this.entryDate = RHS;
			}

			public boolean Save() throws SQLException {
				boolean b = false;

				b = this.Save();
				return b;
			}

			public boolean Save(DBHandler db) throws SQLException {
				boolean b;
				String sql;
				if (this.getDiseaseId() == 0) {
					sql = "INSERT INTO diseases (demographic_no, ICD9, entry_date) " + "VALUES (" + Patient.this.getDemographicNo() + ", '" + this.getICD9() + "', '" + this.getEntryDate() + "')";
					b = DBHandler.RunSQL(sql);

					sql = "SELECT Max(diseaseid) FROM diseases";
					ResultSet rs = DBHandler.GetSQL(sql);

					if (rs.next()) {
						this.diseaseId = rs.getInt(1);
					}

					rs.close();
				} else {
					sql = "UPDATE diseases SET ICD9 = '" + this.getICD9() + "', " + "entry_date = '" + this.getEntryDate().toString() + "' " + "WHERE diseaseid = " + this.getDiseaseId();
					b = DBHandler.RunSQL(sql);
				}

				return b;
			}

		}

	}

}