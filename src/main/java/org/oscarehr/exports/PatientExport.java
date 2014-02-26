/**
 * Copyright (c) 2013. Department of Family Practice, University of British Columbia. All Rights Reserved.
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
 * This software was written for the
 * Department of Family Practice
 * Faculty of Medicine
 * University of British Columbia
 * Vancouver, Canada
 */
package org.oscarehr.exports;

import java.text.SimpleDateFormat;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.oscarehr.casemgmt.dao.CaseManagementIssueDAO;
import org.oscarehr.casemgmt.dao.CaseManagementNoteDAO;
import org.oscarehr.casemgmt.dao.CaseManagementNoteExtDAO;
import org.oscarehr.casemgmt.dao.IssueDAO;
import org.oscarehr.casemgmt.model.CaseManagementNoteExt;
import org.oscarehr.common.dao.AllergyDao;
import org.oscarehr.common.dao.CaseManagementIssueNotesDao;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.DrugDao;
import org.oscarehr.common.dao.DxresearchDAO;
import org.oscarehr.common.dao.Hl7TextInfoDao;
import org.oscarehr.common.dao.Icd9Dao;
import org.oscarehr.common.dao.MeasurementDao;
import org.oscarehr.common.dao.MeasurementTypeDao;
import org.oscarehr.common.dao.MeasurementsExtDao;
import org.oscarehr.common.dao.PatientLabRoutingDao;
import org.oscarehr.common.dao.PreventionDao;
import org.oscarehr.common.dao.PreventionExtDao;
import org.oscarehr.common.dao.ProviderDataDao;
import org.oscarehr.common.model.Drug;
import org.oscarehr.common.model.MeasurementType;
import org.oscarehr.common.model.ProviderData;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;

/**
 * Abstract data model for a patient object
 * 
 * @author Jeremy Ho
 */
public abstract class PatientExport {
	protected static Logger log = MiscUtils.getLogger();
	protected static String eol = System.getProperty("line.separator");

	protected static DemographicDao demographicDao = SpringUtils.getBean(DemographicDao.class);
	protected static AllergyDao allergyDao = SpringUtils.getBean(AllergyDao.class);
	protected static DrugDao drugDao = SpringUtils.getBean(DrugDao.class);
	protected static PreventionDao preventionDao = SpringUtils.getBean(PreventionDao.class);
	protected static PreventionExtDao preventionExtDao = SpringUtils.getBean(PreventionExtDao.class);
	protected static ProviderDataDao providerDataDao = SpringUtils.getBean(ProviderDataDao.class);
	protected static DxresearchDAO dxResearchDao = SpringUtils.getBean(DxresearchDAO.class);
	protected static Icd9Dao icd9Dao = SpringUtils.getBean(Icd9Dao.class);
	protected static PatientLabRoutingDao patientLabRoutingDao = SpringUtils.getBean(PatientLabRoutingDao.class);
	protected static Hl7TextInfoDao hl7TextInfoDao = SpringUtils.getBean(Hl7TextInfoDao.class);
	protected static IssueDAO issueDao = SpringUtils.getBean(IssueDAO.class);
	protected static MeasurementDao measurementDao = SpringUtils.getBean(MeasurementDao.class);
	protected static MeasurementsExtDao measurementsExtDao = SpringUtils.getBean(MeasurementsExtDao.class);
	protected static MeasurementTypeDao measurementTypeDao = SpringUtils.getBean(MeasurementTypeDao.class);
	protected static CaseManagementIssueDAO caseManagementIssueDao = SpringUtils.getBean(CaseManagementIssueDAO.class);
	protected static CaseManagementIssueNotesDao caseManagementIssueNotesDao = SpringUtils.getBean(CaseManagementIssueNotesDao.class);
	protected static CaseManagementNoteDAO caseManagementNoteDao = SpringUtils.getBean(CaseManagementNoteDAO.class);
	protected static CaseManagementNoteExtDAO caseManagementNoteExtDao = SpringUtils.getBean(CaseManagementNoteExtDAO.class);

	protected static final long OTHERMEDS = getIssueID("OMeds");
	protected static final long SOCIALHISTORY = getIssueID("SocHistory");
	protected static final long MEDICALHISTORY = getIssueID("MedHistory");
	protected static final long ONGOINGCONCERNS = getIssueID("Concerns");
	protected static final long REMINDERS = getIssueID("Reminders");
	protected static final long FAMILYHISTORY = getIssueID("FamHistory");
	protected static final long RISKFACTORS = getIssueID("RiskFactors");

	protected Date currentDate = new Date();
	protected Integer demographicNo = null;
	protected boolean isLoaded = false;
	protected boolean exMedicationsAndTreatments = false;
	protected boolean exAllergiesAndAdverseReactions = false;
	protected boolean exImmunizations = false;
	protected boolean exProblemList = false;
	protected boolean exLaboratoryResults = false;
	protected boolean exCareElements = false;
	protected boolean exRiskFactors = false;
	protected boolean exPersonalHistory = false;
	protected boolean exFamilyHistory = false;
	protected boolean exAlertsAndSpecialNeeds = false;
	protected boolean exClinicalNotes = false;

	public PatientExport() {
	}

	public abstract boolean loadPatient(String demoNo);

	/**
	 * Takes in string dates in multiple possible formats and returns a date object of that time
	 * 
	 * @param rhs
	 * @return Date represented by the string if possible, else return current time
	 */
	public static Date stringToDate(String rhs) {
		String[] formatStrings = {"yyyy-MM-dd hh:mm:ss", "yyyy-MM-dd hh:mm", "yyyy-MM-dd"};
		for(String format : formatStrings) {
			try {
				return new SimpleDateFormat(format).parse(rhs);
			} catch (Exception e) {}
		}
		if(rhs != null && !rhs.isEmpty()) log.warn("stringToDate - Can't parse ".concat(rhs));
		return new Date();
	}

	/*
	 * Boolean functions mapping the selections made from the UI
	 */
	public void setExMedications(boolean rhs) {
		this.exMedicationsAndTreatments = rhs;
	}

	public void setExAllergiesAndAdverseReactions(boolean rhs) {
		this.exAllergiesAndAdverseReactions = rhs;
	}

	public void setExImmunizations(boolean rhs) {
		this.exImmunizations = rhs;
	}

	public void setExProblemList(boolean rhs) {
		this.exProblemList = rhs;
	}

	public void setExLaboratoryResults(boolean rhs) {
		this.exLaboratoryResults = rhs;
	}

	public void setExCareElements(boolean rhs) {
		this.exCareElements = rhs;
	}

	public void setExRiskFactors(boolean rhs) {
		this.exRiskFactors = rhs;
	}

	public void setExPersonalHistory(boolean rhs) {
		this.exPersonalHistory = rhs;
	}

	public void setExFamilyHistory(boolean rhs) {
		this.exFamilyHistory = rhs;
	}

	public void setExAlertsAndSpecialNeeds(boolean rhs) {
		this.exAlertsAndSpecialNeeds = rhs;
	}

	public void setExClinicalNotes(boolean rhs) {
		this.exClinicalNotes = rhs;
	}

	public void setExAllTrue() {
		this.exMedicationsAndTreatments = true;
		this.exAllergiesAndAdverseReactions = true;
		this.exImmunizations = true;
		this.exProblemList = true;
		this.exLaboratoryResults = true;
		this.exCareElements = true;
		this.exRiskFactors = true;
		this.exPersonalHistory = true;
		this.exFamilyHistory = true;
		this.exAlertsAndSpecialNeeds = true;
		this.exClinicalNotes = true;
	}
	/*
	 * General Utility functions useful for template string manipulation
	 */
	public Date getCurrentDate() {
		return currentDate;
	}

	/**
	 * Checks if this object is loaded with patient data
	 * 
	 * @return True if loaded, else false
	 */
	public boolean isLoaded() {
		return this.isLoaded;
	}

	/**
	 * Attempts to return the description of measurement type rhs
	 * 
	 * @param rhs Type code
	 * @return Attempts to return string description of input measurement. Otherwise returns rhs
	 */
	public String getTypeDescription(String rhs) {
		try {
			List<MeasurementType> measurementType = measurementTypeDao.findByType(rhs);
			for(MeasurementType entry : measurementType) {
				return entry.getTypeDescription();
			}
		} catch (Exception e) {
			log.warn("getTypeDescription - Type description not found");
		}

		// Blood Pressure split case
		if(rhs.equals("SYST")) rhs = "Systolic Blood Pressure";
		if(rhs.equals("DIAS")) rhs = "Diastolic Blood Pressure";

		return rhs;
	}

	/**
	 * Checks if drug is "active" by comparing to current date
	 * 
	 * @param rhs
	 * @return True if active, false if not
	 */
	public boolean isActiveDrug(Date rhs) {
		if(currentDate.after(rhs)) return false;
		else return true;
	}

	/**
	 * Get Provider's First Name based on provider number
	 * 
	 * @param providerNo
	 * @return String of name if available, else empty string
	 */
	public String getProviderFirstName(String providerNo) {
		String name;
		try {
			ProviderData providerData = providerDataDao.findByProviderNo(providerNo);
			name = providerData.getFirstName();
		} catch (Exception e) {
			log.warn("getProviderFirstName - Provider ".concat(providerNo).concat(" not found"));
			name = "";
		}
		return name;
	}

	/**
	 * Get Provider's Last Name based on provider number
	 * 
	 * @param providerNo
	 * @return String of name if available, else empty string
	 */
	public String getProviderLastName(String providerNo) {
		String name;
		try {
			ProviderData providerData = providerDataDao.findByProviderNo(providerNo);
			name = providerData.getLastName();
		} catch (Exception e) {
			log.warn("getProviderLastName - Provider ".concat(providerNo).concat(" not found"));
			name = "";
		}
		return name;
	}

	/**
	 * Allows for collection sort by DIN numbers
	 * 
	 * @author Jeremy Ho
	 *
	 */
	public class sortByDin implements Comparator<Drug> {
		public int compare(Drug one, Drug two) {
			int answer;
			try {
				answer = Integer.parseInt(one.getRegionalIdentifier()) - Integer.parseInt(two.getRegionalIdentifier());
			} catch (Exception e) {
				answer = getDrugName(one).compareTo(getDrugName(two));
			}
			return answer;
		}

		private String getDrugName(Drug drug) {
			if(drug.getBrandName() != null) {
				return drug.getBrandName();
			} else if(drug.getGenericName() != null) {
				return drug.getGenericName();
			} else {
				return "";
			}
		}
	}

	/**
	 * Function to allow access to ICD9 Description table data based on ICD9 code
	 * 
	 * @param code
	 * @return String representing the ICD9 Code's description
	 */
	public static String getICD9Description(String code) {
		try {
			String result = icd9Dao.findByCode(code).getDescription();
			if (result == null || result.isEmpty()) {
				if (code == null || code.isEmpty()) {
					return "";
				} else {
					return code;
				}
			}
			return result;
		} catch (Exception E) {
			log.error("getICD9Description - code '".concat(code).concat("' missing description"));
			if (code == null || code.isEmpty()) {
				return "";
			} else {
				return code;
			}
		}
	}

	/**
	 * Function to allow access to Casemanagement Note Ext table data based on note id
	 * 
	 * @param id
	 * @param keyval
	 * @return String of result if available, otherwise empty string
	 */
	public static String getCMNoteExtValue(String id, String keyval) {
		List<CaseManagementNoteExt> cmNoteExts = caseManagementNoteExtDao.getExtByNote(Long.valueOf(id));
		for(CaseManagementNoteExt entry : cmNoteExts) {
			if(entry.getKeyVal().equals(keyval)) {
				return entry.getValue();
			}
		}
		return "";
	}

	/**
	 * Remove invalid characters and formatting from strings
	 * 
	 * @param rhs
	 * @return String without invalid characters
	 */
	public static String cleanString(String rhs) {
		if(rhs == null || rhs.isEmpty()) return rhs;
		String str = rhs.replaceAll("<br( )+/>", eol);
		str = str.replaceAll("&", "&amp;");
		str = str.replaceAll("<", "&lt;");
		str = str.replaceAll(">", "&gt;");
		return str;
	}

	/**
	 * @param rhs
	 * @return issueID as long
	 */
	protected static long getIssueID(String rhs) {
		long answer;
		try {
			answer = issueDao.findIssueByCode(rhs).getId();
		} catch (Exception e) {
			log.error(e.getMessage(), e);
			answer = 0;
		}
		return answer;
	}
}