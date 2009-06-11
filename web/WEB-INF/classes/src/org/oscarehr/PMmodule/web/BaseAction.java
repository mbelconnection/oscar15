/*
 * 
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
 * This software was written for 
 * Centre for Research on Inner City Health, St. Michael's Hospital, 
* Toronto, Ontario, Canada  - UPDATED: Quatro Group 2008/2009
 */

package org.oscarehr.PMmodule.web;

import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.RedirectingActionForward;
import org.apache.struts.actions.DispatchAction;
import org.oscarehr.PMmodule.model.Provider;
//import org.oscarehr.PMmodule.service.AgencyManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.service.ProgramQueueManager;
import org.oscarehr.PMmodule.service.ProviderManager;
import org.oscarehr.PMmodule.service.RatePageManager;
import org.oscarehr.PMmodule.service.RoomDemographicManager;
import org.oscarehr.PMmodule.service.RoomManager;
import org.oscarehr.PMmodule.utility.Utility;

import oscar.OscarProperties;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.security.SecurityManager;
import com.quatro.service.security.UserAccessManager;

public abstract class BaseAction extends DispatchAction {

	protected static final String PARAM_START = "?";

	protected static final String PARAM_EQUALS = "=";

	protected static final String PARAM_AND = "&";

	public void addError(HttpServletRequest req, String message) {
		ActionMessages msgs = getErrors(req);
		msgs.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
				"errors.detail", message));
		addErrors(req, msgs);
	}

	public void addMessage(HttpServletRequest req, String message) {
		ActionMessages msgs = getMessages(req);
		msgs.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
				"errors.detail", message));
		addMessages(req, msgs);
	}

	public void addMessage(HttpServletRequest req, String key, String val) {
		ActionMessages msgs = getMessages(req);
		msgs.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(key, val));
		addMessages(req, msgs);
	}

/*
	public AgencyManager getAgencyManager() {
		return (AgencyManager) getAppContext().getBean("agencyManager");
	}
*/
	protected String getProviderNo(HttpServletRequest request) {
		return ((Provider) request.getSession().getAttribute("provider"))
				.getProviderNo();
	}

	protected Provider getProvider(HttpServletRequest request) {
		return ((Provider) request.getSession().getAttribute("provider"));
	}

	protected SecurityManager getSecurityManager(HttpServletRequest request)
	{
		HttpSession session = request.getSession();
		SecurityManager secMgr =  (SecurityManager) 
		session.getAttribute(KeyConstants.SESSION_KEY_SECURITY_MANAGER);
		return secMgr;
	}
	protected String getParameter(HttpServletRequest request,
			String parameterName) {
		return request.getParameter(parameterName);
	}

	protected Object getSessionAttribute(HttpServletRequest request,
			String attributeName) {
		Object attribute = request.getSession().getAttribute(attributeName);

		if (attribute != null) {
			request.getSession().removeAttribute(attributeName);
		}

		return attribute;
	}
	
	protected void setMenu(HttpServletRequest request,String currentMenu) throws NoAccessException {
		/*
		  isPageChangedFlag appeared?
		*/
		if (request.getAttribute("pageChanged") == null) {
			if(request.getParameter("pageChanged")!= null) request.setAttribute("pageChanged", request.getParameter("pageChanged"));
		}
		String lastMenu = (String) request.getSession().getAttribute("currMenu");
		if (lastMenu == null) {
			initMenu(request);
		}
		else
		{
			request.getSession().setAttribute(lastMenu, KeyConstants.ACCESS_VIEW);
			if (!currentMenu.equals(KeyConstants.MENU_CLIENT) && lastMenu.equals(KeyConstants.MENU_CLIENT))
			{
				request.getSession().removeAttribute("clientId");
				request.getSession().removeAttribute("client");
			}
		}
		// check home page access
		if(!currentMenu.equals(KeyConstants.MENU_HOME))
		{
			if (request.getSession().getAttribute(currentMenu).equals(KeyConstants.ACCESS_NULL))
			{
				throw new NoAccessException();
			}
		}
		request.getSession().setAttribute("currMenu",currentMenu);
		String scrollPosition = (String) request.getParameter("scrollPosition");
		if(null != scrollPosition) {
			request.setAttribute("scrPos", scrollPosition);
		}
		else
		{
			request.setAttribute("scrPos", "0");
		}
	}

	private void initMenu(HttpServletRequest request)
	{
		SecurityManager sec = getSecurityManager(request);
		if (sec==null) return;		
		//Client Management
		if (sec.GetAccess(KeyConstants.FUN_CLIENT, "").compareTo(KeyConstants.ACCESS_READ) >= 0) {
			request.getSession().setAttribute(KeyConstants.MENU_CLIENT, KeyConstants.ACCESS_VIEW);
		} else
			request.getSession().setAttribute(KeyConstants.MENU_CLIENT, KeyConstants.ACCESS_NULL);
	
		//Program
		if (sec.GetAccess(KeyConstants.FUN_PROGRAM, "").compareTo(KeyConstants.ACCESS_READ) >= 0) {
			request.getSession().setAttribute(KeyConstants.MENU_PROGRAM, KeyConstants.ACCESS_VIEW);
		} else
			request.getSession().setAttribute(KeyConstants.MENU_PROGRAM, KeyConstants.ACCESS_NULL);

		//Facility Management
		if (sec.GetAccess(KeyConstants.FUN_FACILITY, "").compareTo(KeyConstants.ACCESS_READ) >= 0) {
			request.getSession().setAttribute(KeyConstants.MENU_FACILITY, KeyConstants.ACCESS_VIEW);
		} else
			request.getSession().setAttribute(KeyConstants.MENU_FACILITY, KeyConstants.ACCESS_NULL);

		//Report Runner
		if (sec.GetAccess(KeyConstants.FUN_REPORTS, "").compareTo(KeyConstants.ACCESS_READ) >= 0) {
			request.getSession().setAttribute(KeyConstants.MENU_REPORT, KeyConstants.ACCESS_VIEW);
		} else
			request.getSession().setAttribute(KeyConstants.MENU_REPORT, KeyConstants.ACCESS_NULL);

		//System Admin
		if (OscarProperties.getInstance().isAdminOptionOn() && sec.GetAccess("_admin", "").compareTo(KeyConstants.ACCESS_READ) >= 0) {
			request.getSession().setAttribute(KeyConstants.MENU_ADMIN, KeyConstants.ACCESS_VIEW);
		} else
			request.getSession().setAttribute(KeyConstants.MENU_ADMIN, KeyConstants.ACCESS_NULL);
		request.getSession().setAttribute(KeyConstants.MENU_HOME, KeyConstants.ACCESS_VIEW);
		request.getSession().setAttribute(KeyConstants.MENU_TASK, KeyConstants.ACCESS_VIEW);
	}
	
	protected ActionForward createRedirectForward(ActionMapping mapping,
			String forwardName, StringBuffer parameters) {
		ActionForward forward = mapping.findForward(forwardName);
		StringBuffer path = new StringBuffer(forward.getPath());
		path.append(parameters);

		return new RedirectingActionForward(path.toString());
	}
	protected ActionForward dispatchMethod(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response, String name) throws Exception
	{
		
		String tokenP = (String) request.getParameter("token");
		String methodName = name;
		Calendar startDt = Calendar.getInstance();

		if (methodName != null) methodName = methodName.toLowerCase();
		if (tokenP != null && !tokenP.equals("") && name!= null && (methodName.indexOf("save") >=0 || methodName.indexOf("login")>=0 || methodName.indexOf("hange")>=0)) {
			String tokenS = (String) request.getSession().getAttribute("token"); 
			if(Utility.isNotNullOrEmptyStr(tokenS)) {
				if(!tokenS.equals(tokenP))   {
			        log(0,request.getRequestURI() + "Sorry this page cannot be displayed. Token S:" + tokenS + "Token P:" + tokenP,name, 1, request);
					request.setAttribute("message", "Sorry this page cannot be displayed");
					return mapping.findForward("failure");
				}
			}
		}

		try {
			ActionForward fwd =  super.dispatchMethod(mapping, form, request, response, name);
			if(fwd != null && fwd.getName() != null && fwd.getName().equals("failure")) throw new NoAccessException();
	        if (fwd != null) {
				response.setHeader("Expires", "-1");
	//	        response.setHeader("Expires", "Jan 1, 1900 12:00 AM");
		        response.setHeader("Cache-Control",
		        	"no-cache, nostore, must-revalidate, post-check=0, pre-check=0");
		        response.setHeader("Pragma", "no-cache");
	        }
	        if (request.getAttribute("notoken") == null)
	        {
	        	request.getSession().setAttribute("token", request.getSession().getId() + String.valueOf(Calendar.getInstance().getTimeInMillis()));
	        }
	        // do a access log
	        Calendar endDt = Calendar.getInstance();
	        long timeSpan = endDt.getTimeInMillis() - startDt.getTimeInMillis();
	        log(timeSpan,request.getRequestURI(),name, 1, request);
	        return fwd;
		}
		catch (NoAccessException ex)
		{
	        Calendar endDt = Calendar.getInstance();
	        long timeSpan = endDt.getTimeInMillis()-startDt.getTimeInMillis();
			log(timeSpan, ex.toString(),name,0, request);
			request.setAttribute("message", "Access to the requested page has been denied due to insufficient privileges.");
			return mapping.findForward("failure");
		}
	}
	
	private void log(long timeSpan, String ExName,String method, int result, HttpServletRequest request)
	{
        if (!oscar.OscarProperties.getInstance().getProperty("audit_mode").equals("on")) return;
        HttpSession session = request.getSession();
        String providerNo = (String) session.getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
        String className = this.toString();
        if(method == null) method = "unspecified";
        if (request.getParameter("tab") != null) method = method + "(" + (String)request.getParameter("tab") + ")";
		if(method.equals("unspecified") && request.getParameter("method") != null) method = method + "(" + (String)request.getParameter("method") + ")";
        Integer programId = null;
        try {
        	programId = (Integer) request.getAttribute("programId");
        }
        catch(Exception ex)
        {
            if(request.getAttribute("programId") != null) programId = Integer.valueOf((String) request.getAttribute("programId"));
        }
        if(programId == null) programId = new Integer(0);
        String clientId = "";
        try {
        	clientId =  ((Integer) request.getSession().getAttribute("clientId")).toString();
        }
        catch(Exception ex)
        {
        	;
        }
        if(clientId == null || "".equals(clientId)) clientId = "0"; 
        Integer shelterId = (Integer) session.getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
        if(shelterId == null) shelterId = new Integer(0);
        String sessionId = request.getSession().getId();
        String queryString = request.getRequestURI()  + '?' + request.getQueryString();
        oscar.log.LogAction.logAccess(providerNo, className, method, programId.toString(), shelterId.toString(), clientId, queryString, sessionId, timeSpan, ExName, result);
	}
}