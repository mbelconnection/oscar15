package org.oscarehr.PMmodule.web;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.GregorianCalendar;
import java.util.List;

import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.caisi_integrator.CaisiIntegratorManager;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.caisi_integrator.ws.CachedFacility;
import org.oscarehr.common.dao.IntegratorConsentDao;
import org.oscarehr.common.model.IntegratorConsent;
import org.oscarehr.common.model.Provider;
import org.oscarehr.common.model.IntegratorConsent.ConsentStatus;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;

public class ManageConsent {
	private static Logger logger=MiscUtils.getLogger();
	private static IntegratorConsentDao integratorConsentDao = (IntegratorConsentDao) SpringUtils.getBean("integratorConsentDao");
	private static ProviderDao providerDao = (ProviderDao) SpringUtils.getBean("providerDao");

	private LoggedInInfo loggedInInfo = LoggedInInfo.loggedInInfo.get();
	private int clientId = -1;
	/**
	 * consentToView is null if editing consent, if viewing consent it should have the consent to view.
	 */
	private IntegratorConsent previousConsentToView = null;
	
	private boolean integratorServerError=false;

	public ManageConsent(int clientId) {
		this.clientId = clientId;
	}

	/**
	 * It's safe to pass in null, it's ignore it. The string should be a number though and will be casted to one. It just seemed better to cast it here than in the jsp to reduce code in the jsp.
	 */
	public void setViewConsentId(String consentId) {
		if (consentId != null) {
			previousConsentToView = integratorConsentDao.find(Integer.parseInt(consentId));
		}
	}

	public Collection<CachedFacility> getAllFacilitiesToDisplay() {
		try {
			if (previousConsentToView == null) return (getAllRemoteFacilities());
			else return (getPreviousConsentFacilities());
		} catch (Exception e) {
			integratorServerError=true;
			logger.error("unexpected error", e);
			return (null);
		}
	}

	private Collection<CachedFacility> getPreviousConsentFacilities() throws MalformedURLException {
		ArrayList<CachedFacility> results = new ArrayList<CachedFacility>();

		for (Integer remoteFacilityId : previousConsentToView.getConsentToShareData().keySet()) {
			CachedFacility cachedFacility = CaisiIntegratorManager.getRemoteFacility(remoteFacilityId);
			results.add(cachedFacility);
		}

		return (results);
	}

	private Collection<CachedFacility> getAllRemoteFacilities() throws MalformedURLException {
		List<CachedFacility> results = CaisiIntegratorManager.getRemoteFacilities();
		return (results);
	}

	public boolean displayAsCheckedExcludeFacility(int remoteFacilityId) {
		if (previousConsentToView == null) {
			IntegratorConsent result = integratorConsentDao.findLatestByFacilityDemographic(loggedInInfo.currentFacility.getId(), clientId);
			if (result != null) {
				Boolean checked = result.getConsentToShareData().get(remoteFacilityId);
				if (checked == null) return (false);
				else return (!checked);
			}

			return (false);
		} else {
			return (!previousConsentToView.getConsentToShareData().get(remoteFacilityId));
		}
	}

	public boolean displayAsCheckedExcludeMentalHealthData() {
		if (previousConsentToView == null) {
			IntegratorConsent result = integratorConsentDao.findLatestByFacilityDemographic(loggedInInfo.currentFacility.getId(), clientId);
			if (result != null) {
				return (result.isExcludeMentalHealthData());
			}

			return (false);
		} else {
			return (previousConsentToView.isExcludeMentalHealthData());
		}
	}

	public boolean useDigitalSignatures() {
		return (loggedInInfo.currentFacility.isEnableDigitalSignatures());
	}

	public Integer getPreviousConsentDigitalSignatureId() {
		return (previousConsentToView.getDigitalSignatureId());
	}

	public boolean displayAsSelectedConsentStatus(ConsentStatus status) {
		if (previousConsentToView == null) return (status == ConsentStatus.REVOKED);
		else return (previousConsentToView.getClientConsentStatus() == status);
	}

	public boolean displayAsSelectedExpiry(int months) {
		if (previousConsentToView == null) return (months == -1);
		else {
			if (previousConsentToView.getExpiry() == null) return (months == -1);
			else {
				GregorianCalendar cal1 = new GregorianCalendar();
				cal1.setTime(previousConsentToView.getCreatedDate());
				cal1.add(Calendar.MONTH, months);

				return (DateUtils.isSameDay(cal1.getTime(), previousConsentToView.getExpiry()));
			}
		}
	}
	
	public boolean disableEdit()
	{
		if (previousConsentToView!=null) return(true);
		
		return(integratorServerError);
	}
	
	public String getPreviousConsentProvider()
	{
		Provider provider=providerDao.getProvider(previousConsentToView.getProviderNo());
		return(provider.getFormattedName()+", "+provider.getProviderType());
	}
	
	public String getPreviousConsentDate()
	{
		return(DateFormatUtils.ISO_DATETIME_FORMAT.format(previousConsentToView.getCreatedDate()).replace('T', ' '));
	}
}