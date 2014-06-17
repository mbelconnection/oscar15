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
package org.oscarehr.exports.e2e;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import org.oscarehr.casemgmt.model.CaseManagementNote;
import org.oscarehr.common.dao.DaoTestFixtures;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.ProviderDataDao;
import org.oscarehr.common.dao.utils.EntityDataGenerator;
import org.oscarehr.common.dao.utils.SchemaUtils;
import org.oscarehr.common.model.Allergy;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.Drug;
import org.oscarehr.common.model.Dxresearch;
import org.oscarehr.common.model.Hl7TextInfo;
import org.oscarehr.common.model.Measurement;
import org.oscarehr.common.model.MeasurementsExt;
import org.oscarehr.common.model.Prevention;
import org.oscarehr.common.model.ProviderData;
import org.oscarehr.exports.PatientExport;
import org.oscarehr.exports.PatientExport.sortByDin;
import org.oscarehr.exports.e2e.E2EPatientExport.Lab;
import org.oscarehr.exports.e2e.E2EPatientExport.LabGroup;
import org.oscarehr.util.SpringUtils;

/**
 * This class tests the model used for patient data export
 * 
 * @author Raymond Rusk
 */
public class E2EPatientExportTest extends DaoTestFixtures {
	private static DemographicDao demographicDao = (DemographicDao)SpringUtils.getBean("demographicDao");
	private static ProviderDataDao providerDataDao = (ProviderDataDao)SpringUtils.getBean("providerDataDao");
	private static Integer demographicNo;
	private static String[] tables = {"admission", "allergies", "casemgmt_note_ext", "casemgmt_issue",
		"clinic", "demographic", "demographicSets", "demographic_merged", "drugs", "dxresearch",
		"health_safety", "icd9", "issue", "lst_gender", "measurementMap", "measurementType", "measurements",
		"measurementsExt", "patientLabRouting", "preventions", "preventionsExt", "program", "provider"};

	@BeforeClass
	public static void onlyOnce() throws Exception {
		SchemaUtils.restoreTable(tables);
		Demographic entity = new Demographic();
		EntityDataGenerator.generateTestDataForModelClass(entity);
		entity.setDemographicNo(null);
		demographicDao.save(entity);
		demographicNo = entity.getDemographicNo();
	}

	// Testing constructors
	@Ignore // failed when connector upgraded
	@Test
	public void testPatientExport() {
		assertNotNull(demographicNo);
		assertNotNull(demographicDao.getDemographic(demographicNo.toString()));
		assertNotNull(demographicDao.getDemographicById(demographicNo));
		assertNotNull(demographicDao.getClientByDemographicNo(demographicNo));

		E2EPatientExport p = new E2EPatientExport();
		assertNotNull("PatientExport object unexpectedly null", p);
		assertFalse("PatientExport isLoaded flag unexpectedly true", p.isLoaded());
		if(p.loadPatient(demographicNo.toString())) {
			assertEquals("Unexpected demographic number",p.getDemographic().getDemographicNo(),demographicNo);
			assertTrue("PatientExport isLoaded flag unexpectedly false", p.isLoaded());
		}
	}

	// Testing utility methods
	@Ignore // failed when connector upgraded
	@Test
	public void testGetCurrentDate() {
		assertNotNull((new E2EPatientExport()).getCurrentDate());
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testIsLoaded() {
		assertFalse((new E2EPatientExport()).isLoaded());
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testStringToDate() {
		assertNotNull(E2EPatientExport.stringToDate("2013-03-07 15:30:00"));
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testCleanString() {
		assertNotNull(E2EPatientExport.cleanString(" "));
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetAuthorId() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		assertNotNull(p.getAuthorId());
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testIsActive() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		assertNotNull(p.isActive());
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetProviderFirstName() {
		PatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());

		assertNotNull(providerDataDao);
		List<ProviderData> list = providerDataDao.findAllOrderByLastName();
		assertNotNull(list);
		assertFalse(list.isEmpty());
		assertNotNull(list.get(0));
		assertNotNull(list.get(0).getId());
		assertFalse(list.get(0).getId().isEmpty());

		String provider = p.getProviderFirstName(list.get(0).getId());
		assertNotNull(provider);
		assertFalse(provider.isEmpty());
		assertTrue(provider.equals(list.get(0).getFirstName()));
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetProviderLastName() {
		PatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());

		assertNotNull(providerDataDao);
		List<ProviderData> list = providerDataDao.findAllOrderByLastName();
		assertNotNull(list);
		assertFalse(list.isEmpty());
		assertNotNull(list.get(0));
		assertNotNull(list.get(0).getId());
		assertFalse(list.get(0).getId().isEmpty());

		String provider = p.getProviderLastName(list.get(0).getId());
		assertNotNull(provider);
		assertFalse(provider.isEmpty());
		assertTrue(provider.equals(list.get(0).getLastName()));
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetProviderHomePhone() {
		PatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());

		assertNotNull(providerDataDao);
		List<ProviderData> list = providerDataDao.findAllOrderByLastName();
		assertNotNull(list);
		assertFalse(list.isEmpty());
		assertNotNull(list.get(0));
		assertNotNull(list.get(0).getId());
		assertFalse(list.get(0).getId().isEmpty());

		String provider = p.getProviderHomePhone(list.get(0).getId());
		assertNotNull(provider);
		assertTrue(provider.equals(list.get(0).getPhone()));
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetProviderWorkPhone() {
		PatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());

		assertNotNull(providerDataDao);
		List<ProviderData> list = providerDataDao.findAllOrderByLastName();
		assertNotNull(list);
		assertFalse(list.isEmpty());
		assertNotNull(list.get(0));
		assertNotNull(list.get(0).getId());
		assertFalse(list.get(0).getId().isEmpty());

		String provider = p.getProviderWorkPhone(list.get(0).getId());
		assertNotNull(provider);
		assertTrue(provider.equals(list.get(0).getWorkPhone()));
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetProviderEmail() {
		PatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());

		assertNotNull(providerDataDao);
		List<ProviderData> list = providerDataDao.findAllOrderByLastName();
		assertNotNull(list);
		assertFalse(list.isEmpty());
		assertNotNull(list.get(0));
		assertNotNull(list.get(0).getId());
		assertFalse(list.get(0).getId().isEmpty());

		String provider = p.getProviderEmail(list.get(0).getId());
		assertNotNull(provider);
		assertTrue(provider.equals(list.get(0).getEmail()));
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetID() {
		PatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());

		assertNotNull(providerDataDao);
		List<ProviderData> list = providerDataDao.findAllOrderByLastName();
		assertNotNull(list);
		assertFalse(list.isEmpty());
		assertNotNull(list.get(0));
		assertNotNull(list.get(0).getId());
		assertFalse(list.get(0).getId().isEmpty());

		String provider = p.getProviderID(list.get(0).getId());
		assertNotNull(provider);
	}

	// Testing booleans
	@Ignore // failed when connector upgraded
	@Test
	public void testSetExAllTrue() {
		PatientExport p = new E2EPatientExport();
		p.setExAllTrue();
		p.loadPatient(demographicNo.toString());
		assertTrue("PatientExport isLoaded flag unexpectedly false", p.isLoaded());
	}

	// Testing Demographics
	@Ignore // failed when connector upgraded
	@Test
	public void testDemographic() {		
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		assertNotNull(p.getDemographic());
	}

	// Test convenience methods
	@Ignore // failed when connector upgraded
	@Test
	public void testGetBirthDate() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		String result = p.getBirthDate();
		assertNotNull("Birth date unexpectedly null", result);
		assertTrue("Birth date unexpectedly empty", !result.isEmpty());
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetGenderDesc() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		String result = p.getBirthDate();
		assertNotNull("GenderDesc unexpectedly null", result);
		assertFalse("GenderDesc unexpectedly empty", result.isEmpty());
	}

	// Test allergies
	@Ignore // failed when connector upgraded
	@Test
	public void testAllergies() {		
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		List<Allergy> list = p.getAllergies();
		if (p.hasAllergies()) {
			// exAllergiesAndAdverseReactions must be true
			assertNotNull(list);
			p.setExAllergiesAndAdverseReactions(false);
			assertFalse(p.hasAllergies());
			// put boolean back to original state
			p.setExAllergiesAndAdverseReactions(true);
			assertTrue(p.hasAllergies());
		}
		if (!p.hasAllergies() && list!=null && !list.isEmpty()) {
			// exAllergiesAndAdverseReactions must be false
			p.setExAllergiesAndAdverseReactions(true);
			assertTrue(p.hasAllergies());
			// put boolean back to original state
			p.setExAllergiesAndAdverseReactions(false);
			assertFalse(p.hasAllergies());
		}
	}

	// Test Clinically Measured Observations
	@Ignore // failed when connector upgraded
	@Test
	public void testMeasurements() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		List<Measurement> list = p.getMeasurements();
		if (p.hasMeasurements()) {
			// exCareElements must be true
			assertNotNull(list);
			assertFalse(list.isEmpty());
			p.setExCareElements(false);
			assertFalse(p.hasMeasurements());
			// put boolean back to original state
			p.setExCareElements(true);
			assertTrue(p.hasMeasurements());
		}
		if (!p.hasMeasurements() && list!=null && !list.isEmpty()) {
			// exCareElements must be false
			p.setExCareElements(true);
			assertTrue(p.hasMeasurements());
			// put boolean back to original state
			p.setExCareElements(false);
			assertFalse(p.hasMeasurements());
		}
	}

	// Test Encounters
	@Ignore // failed when connector upgraded
	@Test
	public void testEncounters() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		List<CaseManagementNote> list = p.getEncounters();
		if (p.hasEncounters()) {
			// exClinicalNotes must be true
			assertNotNull(list);
			assertFalse(list.isEmpty());
			p.setExClinicalNotes(false);
			assertFalse(p.hasEncounters());
			// put boolean back to original state
			p.setExClinicalNotes(true);
			assertTrue(p.hasEncounters());
		}
		if (!p.hasEncounters() && list!=null && !list.isEmpty()) {
			// exClinicalNotes must be false
			p.setExClinicalNotes(true);
			assertTrue(p.hasEncounters());
			// put boolean back to original state
			p.setExClinicalNotes(false);
			assertFalse(p.hasEncounters());
		}
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetTypeDescription() {
		assertNotNull((new E2EPatientExport()).getTypeDescription("test"));
	}

	// Test immunizations
	@Ignore // failed when connector upgraded
	@Test
	public void testImmunizations() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		List<Prevention> list = p.getImmunizations();
		if (p.hasImmunizations()) {
			// exImmunizations must be true
			assertNotNull(list);
			assertFalse(list.isEmpty());
			p.setExImmunizations(false);
			assertFalse(p.hasImmunizations());
			// put boolean back to original state
			p.setExImmunizations(true);
			assertTrue(p.hasImmunizations());
		}
		if (!p.hasImmunizations() && list!=null && !list.isEmpty()) {
			// exImmunizations must be false
			p.setExImmunizations(true);
			assertTrue(p.hasImmunizations());
			// put boolean back to original state
			p.setExImmunizations(false);
			assertFalse(p.hasImmunizations());
		}
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetImmuExtValue() {
		assertNotNull((E2EPatientExport.getImmuExtValue("1", "route")));
	}

	// Test laboratory reports
	@Ignore // failed when connector upgraded
	@Test
	public void testLabs() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		List<Lab> list = p.getLabs();
		if (p.hasLabs()) {
			// exLaboratoryResults must be true
			assertNotNull("lab results unexpectedly null",list);
			assertFalse("lab results unexpectedly empty",list.isEmpty());
			p.setExLaboratoryResults(false);
			assertFalse(p.hasLabs());
			// put boolean back to original state
			p.setExLaboratoryResults(true);
			assertTrue(p.hasLabs());
		}
		if (!p.hasLabs() && list!=null && !list.isEmpty()) {
			// exLaboratoryResults must be false
			p.setExLaboratoryResults(true);
			assertTrue("has labs unexpectedly not true", p.hasLabs());
			// put boolean back to original state
			p.setExLaboratoryResults(false);
			assertFalse("has labs unexpectedly not false",p.hasLabs());
		}
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetLabExtValue1() {
		assertNotNull((E2EPatientExport.getLabExtValue("1", "abnormal")));
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetLabExtValue2() {
		assertNotNull((E2EPatientExport.getLabExtValue(new ArrayList<MeasurementsExt>(), "abnormal")));
	}

	// Test Nested Lab and Group Object Models
	@Ignore // failed when connector upgraded
	@Test
	public void testLabObject() {
		Lab l = new Lab();
		assertNotNull(l);
		l.hl7TextInfo = new Hl7TextInfo();
		assertNotNull(l.getHl7TextInfo());
		assertNotNull(l.getGroup());
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testLabGroupObject() {
		LabGroup lg = new LabGroup(1);
		assertNotNull(lg);
		assertTrue(lg.getGroupId() == 1);
		assertNotNull(lg.getMeasurement());
		assertNotNull(lg.getMeasurementsExt());
	}

	// Test medications
	@Ignore // failed when connector upgraded
	@Test
	public void testMedications() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		List<Drug> list = p.getMedications();
		if (p.hasMedications()) {
			// exMedicationsAndTreatments must be true
			assertNotNull("drugs unexpectedly null",list);
			assertFalse("drugs unexpectedly empty",list.isEmpty());
			p.setExMedications(false);
			assertFalse(p.hasMedications());
			// put boolean back to original state
			p.setExMedications(true);
			assertTrue(p.hasMedications());
		}
		if (!p.hasMedications() && list!=null && !list.isEmpty()) {
			// exMedicationsAndTreatments must be false
			p.setExMedications(true);
			assertTrue("medications unexpectedly not true", p.hasMedications());
			// put boolean back to original state
			p.setExMedications(false);
			assertFalse("medications unexpectedly not false",p.hasMedications());
		}
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testIsActiveDrug() {
		PatientExport p = new E2EPatientExport();
		Date pastDate = E2EPatientExport.stringToDate("2012-01-01 00:00:00");
		assertFalse(p.isActiveDrug(pastDate));
		Date futureDate = E2EPatientExport.stringToDate("9999-12-31 23:59:59");
		assertTrue(p.isActiveDrug(futureDate));
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testSortByDinCompare() {
		PatientExport p = new E2EPatientExport();
		sortByDin sbd = p.new sortByDin();
		assertNotNull(sbd.compare(new Drug(), new Drug()));
	}

	// Test problem list
	@Ignore // failed when connector upgraded
	@Test
	public void testProblems() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		List<Dxresearch> list = p.getProblems();
		if (p.hasProblems()) {
			// exProblemList must be true
			assertNotNull("problems unexpectedly null",list);
			assertFalse("problems unexpectedly empty",list.isEmpty());
			p.setExProblemList(false);
			assertFalse(p.hasProblems());
			// put boolean back to original state
			p.setExProblemList(true);
			assertTrue(p.hasProblems());
		}
		if (!p.hasProblems() && list!=null && !list.isEmpty()) {
			// exProblemList must be false
			p.setExProblemList(true);
			assertTrue("problems unexpectedly not true", p.hasProblems());
			// put boolean back to original state
			p.setExProblemList(false);
			assertFalse("problems unexpectedly not false",p.hasProblems());
		}
	}

	@Ignore // failed when connector upgraded
	@Test
	public void testGetICD9Description() {
		// the test dataset has a row in the icd9
		// table for icd9 = '001' ("CHOLERA")
		String desc = E2EPatientExport.getICD9Description("001");
		assertNotNull(desc);
		assertFalse(desc.isEmpty());
	}

	// Test Case Management Utility Functions
	@Ignore // failed when connector upgraded
	@Test
	public void testGetCMNoteExtValue() {
		assertNotNull((E2EPatientExport.getCMNoteExtValue("1", "Hide Cpp")));
	}

	// Test Risk Factors
	@Ignore // failed when connector upgraded
	@Test
	public void testRiskFactors() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		List<CaseManagementNote> list = p.getRiskFactorsandPersonalHistory();
		if (p.hasRiskFactorsandPersonalHistory()) {
			// exRiskFactors or exPersonalHistory must be true
			assertNotNull("risk factors unexpectedly null",list);
			assertFalse("risk factors unexpectedly empty",list.isEmpty());
			p.setExRiskFactors(false);
			p.setExPersonalHistory(false);
			assertFalse(p.hasRiskFactorsandPersonalHistory());
			// put boolean back to original state
			p.setExRiskFactors(true);
			p.setExPersonalHistory(true);
			assertTrue(p.hasRiskFactorsandPersonalHistory());
		}
		if (!p.hasRiskFactorsandPersonalHistory() && list!=null && !list.isEmpty()) {
			// exRiskFactors and exPersonalHistory must be false
			p.setExRiskFactors(true);
			assertTrue("risk factors unexpectedly not true", p.hasRiskFactorsandPersonalHistory());
			// put boolean back to original state
			p.setExRiskFactors(false);
			assertFalse("risk factors unexpectedly not false",p.hasRiskFactorsandPersonalHistory());
		}
	}

	// Test Family History
	@Ignore // failed when connector upgraded
	@Test
	public void testFamilyHistory() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		List<CaseManagementNote> list = p.getFamilyHistory();
		if (p.hasFamilyHistory()) {
			// exFamilyHistory must be true
			assertNotNull("family history unexpectedly null",list);
			assertFalse("family history unexpectedly empty",list.isEmpty());
			p.setExFamilyHistory(false);
			assertFalse(p.hasFamilyHistory());
			// put boolean back to original state
			p.setExFamilyHistory(true);
			assertTrue(p.hasFamilyHistory());
		}
		if (!p.hasFamilyHistory() && list!=null && !list.isEmpty()) {
			// exFamilyHistory must be false
			p.setExFamilyHistory(true);
			assertTrue("family history unexpectedly not true", p.hasFamilyHistory());
			// put boolean back to original state
			p.setExFamilyHistory(false);
			assertFalse("family history unexpectedly not false",p.hasFamilyHistory());
		}
	}

	// Test Alerts
	@Ignore // failed when connector upgraded
	@Test
	public void testAlerts() {
		E2EPatientExport p = new E2EPatientExport();
		p.loadPatient(demographicNo.toString());
		List<CaseManagementNote> list = p.getAlerts();
		if (p.hasAlerts()) {
			// exAlertsAndSpecialNeeds must be true
			assertNotNull("alerts unexpectedly null",list);
			assertFalse("alerts unexpectedly empty",list.isEmpty());
			p.setExAlertsAndSpecialNeeds(false);
			assertFalse(p.hasAlerts());
			// put boolean back to original state
			p.setExAlertsAndSpecialNeeds(true);
			assertTrue(p.hasAlerts());
		}
		if (!p.hasAlerts() && list!=null && !list.isEmpty()) {
			// exAlertsAndSpecialNeeds must be false
			p.setExAlertsAndSpecialNeeds(true);
			assertTrue("alerts unexpectedly not true", p.hasAlerts());
			// put boolean back to original state
			p.setExAlertsAndSpecialNeeds(false);
			assertFalse("alerts unexpectedly not false",p.hasAlerts());
		}
	}
}
