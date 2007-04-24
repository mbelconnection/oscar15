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
 * Ontario, Canada   Creates a new instance of Startup
 *
 *
 * Startup.java
 *
 * Created on September 22, 2005, 3:13 PM
 */
package oscar.login;

import java.util.*;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import oscar.oscarDB.*;

/**
 * This ContextListener is used to Initialize classes at startup - Initialize the DBConnection Pool.
 * 
 * @author Jay Gallagher
 */
public class Startup implements ServletContextListener {

	public Startup() {}

	public void contextInitialized(ServletContextEvent sc) {
		System.out.println("contextInit");
		
		String contextPath = "";
		String propFileName = "";
		
		try {
			// Anyone know a better way to do this?
			String url = sc.getServletContext().getResource("/index.jsp").getPath();
			url = url.substring(url.indexOf('/', 1) + 1, url.lastIndexOf('/'));
			
			contextPath = url;
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		String propName = contextPath + ".properties";

		char sep = System.getProperty("file.separator").toCharArray()[0];
		
		try {
			// This has been used to look in the users home directory that started tomcat
			propFileName = System.getProperty("user.home") + sep + propName;
			oscar.OscarProperties p = oscar.OscarProperties.getInstance();
			p.loader(propFileName);

			if (!DBHandler.isInit())
				DBHandler.init(p.getProperty("db_name"), p.getProperty("db_driver"), p.getProperty("db_uri"), p.getProperty("db_username"), p.getProperty("db_password"));

			// Temporary Testing of new ECHART
			// To be removed
			String newDocs = p.getProperty("DOCS_NEW_ECHART");
			
			if (newDocs != null) {
				String[] arrnewDocs = newDocs.split(",");
				ArrayList newDocArr = new ArrayList(Arrays.asList(arrnewDocs));
				Collections.sort(newDocArr);
				sc.getServletContext().setAttribute("newDocArr", newDocArr);
			}

			String echartSwitch = p.getProperty("USE_NEW_ECHART");
			if (echartSwitch != null && echartSwitch.equalsIgnoreCase("yes")) {
				sc.getServletContext().setAttribute("useNewEchart", true);
			}
		} catch (Exception e) {
			System.out.println("*** No Property File ***");
			System.out.println("Property file not found at:");
			System.out.println(propFileName);
		}
		
		System.out.println("LAST LINE IN contextInitialized");
	}

	public void contextDestroyed(ServletContextEvent arg0) {}

}
