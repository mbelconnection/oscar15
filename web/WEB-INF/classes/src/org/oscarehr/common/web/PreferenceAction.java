package org.oscarehr.common.web;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.oscarehr.common.dao.PreferenceDao;
import org.oscarehr.common.model.Preference;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.SpringUtils;

public class PreferenceAction {
	
	private static PreferenceDao preferenceDao = (PreferenceDao) SpringUtils.getBean("preferenceDao");
	
	public static Preference createPreference(String providerNo)
	{
		Preference preference=new Preference();
		
		preference.setProvider_no(providerNo);
				
		return(preference);
	}
	
	
	public static void savePreference(Preference preference) {			
		if(preferenceDao.findPreferenceByProviderNo(preference.getProvider_no())==null) {
			preferenceDao.persist(preference);			
		} else {			
			preferenceDao.merge(preference);
		}
		
	}
	


}
