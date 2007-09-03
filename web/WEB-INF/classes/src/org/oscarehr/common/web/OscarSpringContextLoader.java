/*
 * Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
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
 * OscarSpringContextLoader.java
 *
 * Created on May 4, 2007, 10:42 AM
 */
package org.oscarehr.common.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.oscarehr.util.SpringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextException;
import org.springframework.web.context.ConfigurableWebApplicationContext;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.XmlWebApplicationContext;
import oscar.OscarProperties;

import javax.servlet.ServletContext;

/**
 * @author rjonasz
 */
public class OscarSpringContextLoader extends ContextLoader {
	
	private final Log log = LogFactory.getLog(OscarSpringContextLoader.class);
	private final String CONTEXTNAME = "WEB-INF/applicationContext";
	private final String PROPERTYNAME = "ModuleNames";

	/** Creates a new instance of OscarSpringContextLoader */
	public OscarSpringContextLoader() {}

	protected WebApplicationContext createWebApplicationContext(ServletContext servletContext, ApplicationContext parent) throws BeansException {
		String contextClassName = servletContext.getInitParameter(CONTEXT_CLASS_PARAM);

        Class<?> contextClass;
        if (contextClassName != null) {
			try {
				contextClass = Class.forName(contextClassName, true, Thread.currentThread().getContextClassLoader());
			} catch (ClassNotFoundException ex) {
				throw new ApplicationContextException("Failed to load context class [" + contextClassName + "]", ex);
			}
			
			if (!ConfigurableWebApplicationContext.class.isAssignableFrom(contextClass)) {
				throw new ApplicationContextException("Custom context class [" + contextClassName + "] is not of type ConfigurableWebApplicationContext");
			}
		} else {
            contextClass = XmlWebApplicationContext.class;
        }

		ConfigurableWebApplicationContext wac = (ConfigurableWebApplicationContext) BeanUtils.instantiateClass(contextClass);
		wac.setParent(parent);
		wac.setServletContext(servletContext);

		// to load various contexts, we need to get Modules property
		String modules = (String) OscarProperties.getInstance().get(PROPERTYNAME);
		String[] moduleList = new String[0];

		if (modules != null) {
			modules = modules.trim();
			
			if (modules.length() > 0) {
				moduleList = modules.split(",");
			}
		}

		// now we create an array of application context file names
		String[] configLocations = new String[moduleList.length + 1];

		// always load applicationContext.xml
		configLocations[0] = CONTEXTNAME + ".xml";
		log.info("Preparing " + configLocations[0]);

		for (int idx = 0; idx < moduleList.length; ++idx) {
			configLocations[idx + 1] = CONTEXTNAME + moduleList[idx] + ".xml";
			log.info("Preparing " + configLocations[idx + 1]);
		}

		wac.setConfigLocations(configLocations);
		wac.refresh();
		
        if (SpringUtils.beanFactory==null) SpringUtils.beanFactory=wac;
        
		return wac;
	}
}
