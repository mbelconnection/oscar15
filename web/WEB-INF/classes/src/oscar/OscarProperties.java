// -----------------------------------------------------------------------------------------------------------------------
// *
// *
// * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
// * This software is published under the GPL GNU General Public License.
// * This program is free software; you can redistribute it and/or
// * modify it under the terms of the GNU General Public License
// * as published by the Free Software Foundation; either version 2
// * of the License, or (at your option) any later version. *
// * This program is distributed in the hope that it will be useful,
// * but WITHOUT ANY WARRANTY; without even the implied warranty of
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License
// * along with this program; if not, write to the Free Software
// * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *
// *
// * <OSCAR TEAM>
// * This software was written for the
// * Department of Family Medicine
// * McMaster Unviersity
// * Hamilton
// * Ontario, Canada
// *
// -----------------------------------------------------------------------------------------------------------------------
package oscar;

import java.util.Properties;
import java.io.*;

/*
 * This class is an interface with the file WEB-INF/classes
 * It is a singleton class. Do not instaciate it, use the method getInstance().
 * Every time that the properties file changes, tomcat must be restarted.
 */
public class OscarProperties extends Properties {

	/**
	 * @return OscarProperties the instance of OscarProperties
	 */
	public static OscarProperties getInstance() {
		return oscarProperties;
	}

	static OscarProperties oscarProperties = new OscarProperties();
	static boolean loaded = false;

	/* Do not use this constructor. Use getInstance instead */
	/* If cant find the file, inform and continue */
	/*
	 * private OscarProperties() {
	 * 
	 * InputStream is = getClass().getResourceAsStream("/oscar_mcmaster.properties"); try { load(is); } catch (Exception e) { System.out.println("Error, file oscar_mcmaster.properties not found."); System.out.println("This file must be placed at WEB-INF/classes."); }
	 * 
	 * try{ is.close(); } catch (IOException e) { System.out.println("IO error."); e.printStackTrace(); } } //OscarProperties - end
	 * 
	 * 
	 */
	private OscarProperties() {
		System.out.println("OSCAR PROPS CONSTRUCTOR");
	}

	/**
	 * Will check the properties to see if that property is set and if its set to the value. If it is method returns true if not method returns false
	 * 
	 * @param key
	 *            key of property
	 * @param val
	 *            value that will cause a true value to be returned
	 * @return boolean
	 */
	public boolean getBooleanProperty(String key, String val) {
		boolean prop = false;
		String propertyValue = getProperty(key);
		if (propertyValue != null && propertyValue.equalsIgnoreCase(val)) {
			prop = true;
		}
		return prop;
	}

	public void loader(String propFileName) {
		if (!loaded) {
			try {
				FileInputStream fis2 = new FileInputStream(propFileName);
				load(fis2);
				fis2.close();
				loaded = true;
			} catch (Exception e) {
				System.out.println("Error, file oscar_mcmaster.properties not found.");
				System.out.println("This file must be placed at WEB-INF/classes.");
				e.printStackTrace();
			}

		}
	}

    public boolean isTorontoRFQ() {
        return getBooleanProperty("TORONTO_RFQ", "yes") || getBooleanProperty("TORONTO_RFQ", "true");
    }
}