package org.oscarehr.PMmodule.task;

import java.util.Date;
import java.util.List;
import java.util.TimerTask;

import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.PMmodule.service.AdmissionManager;
import org.oscarehr.util.DbConnectionFilter;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;

public class AnonymousClientDischargeTask extends TimerTask {

	private static final Logger logger = MiscUtils.getLogger();

	public void run() {
		try {
			LoggedInInfo.setLoggedInInfoToCurrentClassAndMethod();
			AdmissionManager admissionManager = (AdmissionManager) SpringUtils.getBean("admissionManager");

			List<Admission> admissions = admissionManager.getActiveAnonymousAdmissions();

			for (Admission admission : admissions) {
				if ((new Date().getTime() - admission.getAdmissionDate().getTime()) > (1000 * 60 * 60 * 24)) {
					logger.info("Admission ready for discharge.");
					admission.setDischargeDate(new Date());
					admission.setDischargeNotes("Auto-Discharge");
					admission.setAdmissionStatus(Admission.STATUS_DISCHARGED);
					admissionManager.saveAdmission(admission);
				} else {
					logger.info("Admission still under 24hrs - " + admission.getAdmissionDate());
				}
			}
		} catch (Exception e) {
			logger.error("Error", e);
		} finally {
			DbConnectionFilter.releaseAllThreadDbResources();
		}
	}

}