package oscar.oscarRx.pageUtil;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.caisi_integrator.CaisiIntegratorManager;
import org.oscarehr.caisi_integrator.ws.CachedDemographicAllergy;
import org.oscarehr.caisi_integrator.ws.DemographicWs;
import org.oscarehr.common.dao.PartialDateDao;
import org.oscarehr.common.model.PartialDate;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;

import oscar.oscarRx.data.RxPatientData;
import oscar.oscarRx.data.RxPatientData.Patient.Allergy;
import oscar.util.DateUtils;

public final class AllergyHelperBean {
	private static Logger logger = MiscUtils.getLogger();
	private static final PartialDateDao partialDateDao = (PartialDateDao) SpringUtils.getBean("partialDateDao");

	public static List<AllergyDisplay> getAllergiesToDisplay(Integer demographicId, Locale locale) throws SQLException {
		ArrayList<AllergyDisplay> results = new ArrayList<AllergyDisplay>();

		addLocalAllergies(demographicId, results, locale);

		LoggedInInfo loggedInInfo = LoggedInInfo.loggedInInfo.get();
		if (loggedInInfo.currentFacility.isIntegratorEnabled()) {
			addIntegratorAllergies(demographicId, results, locale);
		}

		return (results);
	}

	private static void addLocalAllergies(Integer demographicId, ArrayList<AllergyDisplay> results, Locale locale) throws SQLException {
		Allergy[] allergies = RxPatientData.getPatient(demographicId).getActiveAllergies();

		if (allergies == null) return;

		for (Allergy allergy : allergies) {
			AllergyDisplay allergyDisplay = new AllergyDisplay();

			allergyDisplay.setId(allergy.getAllergyId());

			allergyDisplay.setDescription(allergy.getAllergy().getDESCRIPTION());
			allergyDisplay.setOnSetCode(allergy.getAllergy().getOnSetOfReaction());
			allergyDisplay.setReaction(allergy.getAllergy().getReaction());
			allergyDisplay.setSeverityCode(allergy.getAllergy().getSeverityOfReaction());
			allergyDisplay.setTypeCode(allergy.getAllergy().getTYPECODE());
			allergyDisplay.setArchived(allergy.getAllergy().getArchived());
			
			String entryDate = partialDateDao.getDatePartial(allergy.getEntryDate(), PartialDate.ALLERGIES, allergy.getAllergyId(), PartialDate.ALLERGIES_ENTRYDATE);
			String startDate = partialDateDao.getDatePartial(allergy.getAllergy().getStartDate(), PartialDate.ALLERGIES, allergy.getAllergyId(), PartialDate.ALLERGIES_STARTDATE);
			allergyDisplay.setEntryDate(entryDate);
			allergyDisplay.setStartDate(startDate);
			
			results.add(allergyDisplay);
		}
	}

	private static void addIntegratorAllergies(Integer demographicId, ArrayList<AllergyDisplay> results, Locale locale) {
		try {
			DemographicWs demographicWs = CaisiIntegratorManager.getDemographicWs();
			List<CachedDemographicAllergy> remoteAllergies = demographicWs.getLinkedCachedDemographicAllergies(demographicId);

			for (CachedDemographicAllergy remoteAllergy : remoteAllergies) {
				AllergyDisplay allergyDisplay = new AllergyDisplay();

				allergyDisplay.setRemoteFacilityId(remoteAllergy.getFacilityIdIntegerCompositePk().getIntegratorFacilityId());
				allergyDisplay.setId(remoteAllergy.getFacilityIdIntegerCompositePk().getCaisiItemId());

				allergyDisplay.setDescription(remoteAllergy.getDescription());
				allergyDisplay.setEntryDate(DateUtils.formatDate(remoteAllergy.getEntryDate(), locale));
				allergyDisplay.setOnSetCode(remoteAllergy.getOnSetCode());
				allergyDisplay.setReaction(remoteAllergy.getReaction());
				allergyDisplay.setSeverityCode(remoteAllergy.getSeverityCode());
				allergyDisplay.setStartDate(DateUtils.formatDate(remoteAllergy.getStartDate(), locale));
				allergyDisplay.setTypeCode(remoteAllergy.getTypeCode());
				
				results.add(allergyDisplay);
			}
		} catch (Exception e) {
			logger.error("error getting remote allergies", e);
		}
	}
}