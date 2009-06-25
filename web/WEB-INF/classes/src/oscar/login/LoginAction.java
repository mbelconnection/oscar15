/*
 * Copyright (c) 2005. Department of Family Medicine, McMaster University. All Rights Reserved. *
 * This software is published under the GPL GNU General Public License. This program is free
 * software; you can redistribute it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version. * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more details. * * You should have
 * received a copy of the GNU General Public License along with this program; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * <OSCAR
 * TEAM> This software was written for the Department of Family Medicine McMaster University
 * Hamilton Ontario, Canada
 */
package oscar.login;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.oscarehr.PMmodule.model.Provider;
import org.oscarehr.PMmodule.service.ProviderManager;
import org.oscarehr.PMmodule.web.BaseAction;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import oscar.OscarProperties;
import oscar.log.LogAction;
import oscar.log.LogConst;
import oscar.util.UtilDateUtilities;

import com.quatro.model.security.*;
import com.quatro.service.LookupManager;
import com.quatro.common.KeyConstants;

public final class LoginAction extends BaseAction {
    private static final Logger _logger = Logger.getLogger(LoginAction.class);
    private static final String LOG_PRE = "Login!@#$: ";

//    private ProviderManager providerManager = (ProviderManager) SpringUtils.getBean("providerManager");
    private LookupManager lookupManager; // = (LookupManager) SpringUtils.getBean("lookupManager");
    private ProviderManager providerManager;
    
    public ActionForward login(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	OscarProperties props = OscarProperties.getInstance();
    	if (props.isSiteSecured()) {
    		return mapping.findForward("login");
    	}
        ActionMessages messages = new ActionMessages();
        String ip = request.getRemoteAddr();
        String where = "shelterSelection";
        // String userName, password, pin, propName;
        String userName = ((LoginForm) form).getUsername();
        String password = ((LoginForm) form).getPassword();
        String pin = ((LoginForm) form).getPin();
        if (userName.equals("")) {
            messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.login.invalid"));
            saveMessages(request,messages);
            return mapping.getInputForward();
        }

        userName = userName.toLowerCase();
        request.setAttribute("userName", userName);
        LoginCheckLogin cl = new LoginCheckLogin();
        Security user;
        ApplicationContext appContext = getAppContext();
        try {
            user = cl.auth(userName, password, pin, ip, appContext);
	        String expired_days = "";
	        if (user.getLoginStatus() == Security.LOGIN_SUCCESS) { // login successfully
				// Give warning if the password will be expired in 10 days.
	            cl.unlock(user.getUserName());
				if (user.getBExpireset().intValue() == 1) {
					long date_expireDate = user.getDateExpiredate().getTime();
					long date_now = UtilDateUtilities.now().getTime();
					long date_diff = (date_expireDate - date_now)
							/ (24 * 3600 * 1000);
	
					if (user.getBExpireset().intValue() == 1 && date_diff < 11) {
						expired_days = String.valueOf(date_diff);
					}
				}
	            // invalidate the existing sesson
	            HttpSession session = request.getSession(false);
	            if (session != null) {
	                session.invalidate();
	            }
	            session = request.getSession(); // Create a new session for this user
	            
	            String providerNo = user.getProviderNo();
	            Provider provider = providerManager.getProvider(providerNo);
	
	            _logger.info("Assigned new session for: " + providerNo + " : " + provider.getLastName() + ", " + provider.getFirstName());
	            LogAction.addLog(userName,providerNo, LogConst.LOGIN, LogConst.CON_LOGIN, "", ip);
	
	            session.setAttribute(KeyConstants.SESSION_KEY_PROVIDERNO, user.getProviderNo());
	            session.setAttribute(KeyConstants.SESSION_KEY_PROVIDERNAME, provider.getLastName() + ", "+ provider.getFirstName());
	
	            session.setAttribute("oscar_context_path", request.getContextPath());
	            session.setAttribute("expired_days", expired_days);
	            
	
	            session.setAttribute("provider", provider);
	            return mapping.findForward(where);
	        }
	        // expired password
	        else if (user.getLoginStatus() == Security.PASSWORD_EXPIRED) {
	           // cl.updateLoginList(ip, userName);
	   	     	messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.login",	"Your account is expired. Please contact your administrator."));
	        }
	        else if (user.getLoginStatus() == Security.ACCOUNT_BLOCKED) {
                _logger.info(LOG_PRE + " Blocked: " + userName);
                // return mapping.findForward(where); //go to block page
                messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.login","Your account is locked. Please contact your administrator to unlock."));
                saveMessages(request,messages);
                return mapping.getInputForward();
            }
	        else { 
	            // request.setAttribute("login", "failed");
	            LogAction.addLog(userName,null,"login", "failed", LogConst.CON_LOGIN,  ip);
	            if (cl.updateLoginList(user) == Security.ACCOUNT_BLOCKED) {
	                messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.login","Your account is locked. Please contact your administrator to unlock."));
	            }
	            else
	            {
	   	     		messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.login.invalid"));
	            }
	        }
	        saveMessages(request,messages);
	        return mapping.getInputForward();
        }
        catch (Exception e) 
        {
	        String newURL = mapping.getInput();
	        messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.login", "Server is temporarily unavailable, please try again later"));
	        saveMessages(request,messages);
	        return mapping.getInputForward();
        }
    }
    public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
    	LoginForm loginForm = (LoginForm) form;
    	loginForm.setUsername("");
    	return mapping.findForward("login");
    }
    public ActionForward logout(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
    	 HttpSession session = request.getSession(false);
	     String ip = request.getRemoteAddr();
    	 if( session != null) {
    		    Object user = session.getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
    		    if (user != null) {
    			  LogAction.addLog((String)user,(String)user, LogConst.LOGOUT, LogConst.CON_LOGIN, "", ip);
    		      session.invalidate();
    		      request.getSession();
    		    }
    		    else
    		    {
    		    	if(request.getParameter("requri") != null) {
    		    		LogAction.addLog("Unknown","0", LogConst.LOGOUT, request.getParameter("requri"), "", ip);
    		    	}
    		    }
    	}
    	LoginForm loginForm = (LoginForm) form;
    	loginForm.setUsername("");
    	return mapping.findForward("logout");
    }
	public ApplicationContext getAppContext() {
		return WebApplicationContextUtils.getWebApplicationContext(getServlet().getServletContext());
	}

	public void setProviderManager(ProviderManager providerManager) {
		this.providerManager = providerManager;
	}

	public void setLookupManager(LookupManager lookupManager) {
		this.lookupManager = lookupManager;
	}
}
