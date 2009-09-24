/*******************************************************************************
 * Copyright (c) 2008, 2009 Quatro Group Inc. and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU General Public License
 * which accompanies this distribution, and is available at
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Contributors:
 *     <Quatro Group Software Systems inc.>  <OSCAR Team>
 *******************************************************************************/
package com.quatro.servlets;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.oscarehr.util.SpringUtils;
import java.util.List;

import com.ibm.disthubmq.spi.ServerLogConstants;
import com.quatro.model.LookupCodeValue;
import oscar.OscarProperties;

import com.quatro.service.LookupManager;
public class InitPropertyServlet extends HttpServlet {
    public void init(ServletConfig servletConfig) throws ServletException {
    	try {
    	super.init(servletConfig);
        OscarProperties p = OscarProperties.getInstance();
       
        LookupManager lookupManager = (LookupManager) SpringUtils.getBean("lookupManager");
        List prps = lookupManager.LoadCodeList("PRP",true, null, null);
        for(int i=0; i<prps.size();i++)
        {
        	LookupCodeValue pv = (LookupCodeValue) prps.get(i);
        	p.setProperty(pv.getDescription(), pv.getBuf1());
        }
    	}
    	catch(Exception e)
    	{
    		throw new ServletException(e);
    	}
    }
}
