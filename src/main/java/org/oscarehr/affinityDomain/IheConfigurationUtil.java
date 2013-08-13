/**
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
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
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */


package org.oscarehr.affinityDomain;

import java.io.File;
import ca.marc.ihe.core.configuration.IheConfiguration;
import ca.marc.ihe.core.configuration.JKSStoreInformation;

public class IheConfigurationUtil
{
	private static final oscar.OscarProperties oscarProperties = oscar.OscarProperties.getInstance();
	private static final String ConfigFileLocation = oscarProperties.getProperty("AFFINITY_DOMAINS_CONFIG_PATH", null);
	private static final String keyStoreFile = oscarProperties.getProperty("TOMCAT_KEYSTORE_FILE", null);
	private static final String keyStorePassword = oscarProperties.getProperty("TOMCAT_KEYSTORE_PASSWORD", null);
	private static final String trustStoreFile = oscarProperties.getProperty("TOMCAT_TRUSTSTORE_FILE", null);
	private static final String trustStorePassword = oscarProperties.getProperty("TOMCAT_TRUSTSTORE_PASSWORD", null);
	
	public static IheConfiguration load() {
		return IheConfigurationUtil.load(ConfigFileLocation);
	}
	
	public static IheConfiguration load(String filePath) {
		IheConfiguration retVal = IheConfiguration.load(filePath);
		retVal.setKeyStore(new JKSStoreInformation(keyStoreFile, keyStorePassword));
		retVal.setTrustStore(new JKSStoreInformation(trustStoreFile, trustStorePassword));
		
		return retVal;
	}
	
	public static boolean save(IheConfiguration config) {
		return config.save(ConfigFileLocation);
	}
	
	public static boolean save(IheConfiguration config, String filePath) {
		return config.save(filePath);
	}
	
	public static boolean removeAffinityDomainByName(IheConfiguration config, String affinityDomainName) {
		boolean result = false;
		
		// Loop through the affinity domains to find the matching name.
		for (int i = 0; i < config.getAffinityDomains().size(); i++) {

			if (config.getAffinityDomains().get(i).getName().equals(affinityDomainName)) {
				
				config.getAffinityDomains().remove(i);				
				result = IheConfigurationUtil.save(config);
				
				break;
				
			}
		}
		
		return result;
	}
	
	public static boolean isEnabled() {
		// if the file path is available and exists, return true
		return (ConfigFileLocation != null && new File(ConfigFileLocation).isFile());
	}
}
