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
import java.io.ObjectInputStream;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Properties;
import com.quatro.model.security.*;

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
import org.apache.struts.actions.DispatchAction;

import com.quatro.model.LookupCodeValue;
import com.quatro.model.security.*;

import org.oscarehr.PMmodule.dao.FacilityDAO;
import org.oscarehr.PMmodule.model.Facility;
import org.oscarehr.PMmodule.model.Provider;
import org.oscarehr.PMmodule.service.ProviderManager;
import org.oscarehr.PMmodule.web.BaseAction;
import org.oscarehr.util.SpringUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import oscar.OscarProperties;
import oscar.log.LogAction;
import oscar.log.LogConst;
import oscar.oscarDB.DBPreparedHandler;
import oscar.util.UtilDateUtilities;

import com.quatro.service.LookupManager;
import com.quatro.service.security.*;
import com.quatro.service.security.SecurityManager;
import com.quatro.common.KeyConstants;

public final class SiteCheckAction extends BaseAction {
    private static final Logger _logger = Logger.getLogger(LoginAction.class);
    private static final String LOG_PRE = "Login!@#$: ";

    private ProviderManager providerManager = (ProviderManager) SpringUtils.getBean("providerManager");
    private LookupManager lookupManager = (LookupManager) SpringUtils.getBean("lookupManager");

    private SecSiteManager secSiteManager;
    
    public void setSecSiteManager(SecSiteManager  secSiteManager)
    {
    	this.secSiteManager = secSiteManager;
    }
    private ApplicationContext getAppContext()
    {
    	return WebApplicationContextUtils.getWebApplicationContext(
        		getServlet().getServletContext());
    }
    public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ObjectInputStream ois = new ObjectInputStream(request.getInputStream());       
	    SecSiteValue ssv;
	    try {
	    	ssv = (SecSiteValue)ois.readObject();
 	    }
 	    catch(Exception ex)
 	    {
 	    	sendMessage(response,"error:" + ex.getMessage());
 	    	return null;
 	    }
	    ois.close();
 	    if(ssv.getUserName() == null || "".equals(ssv.getUserName())) {
 	    	try{
     	    	int newKey = 0;
	     	    if (isKeyValid(ssv.getSiteId(),ssv.getSiteKey(),request.getRemoteAddr()))
	     	    {
	     	    	newKey = secSiteManager.generateNewKey();
		     	    sendMessage(response,"confirmed:" + newKey);
	     	    }
	     	    else
	     	    {
		     	    sendMessage(response,"error:" + "Your computer is not authorized to access QuatroShelter.<br> Please contact your system administrator for help.");
	     	    }
 	    	}catch(Exception e){ 
 	    		sendMessage(response,"error:" + e.getMessage());
 	    	}
	    	return null;
 	    }
 	    else
 	    {
 	    	secSiteManager.setSiteKey(ssv.getSiteId(), ssv.getSiteKey()); 
 	    	sendMessage(response,login(request,mapping, ssv));
 	    	return null;
 	    }
    }
	private boolean isKeyValid(String siteId, int siteKey, String ip)
	{
		boolean isValid = secSiteManager.isKeyValid(siteId, siteKey);
		BadSiteList siteList = BadSiteList.getLoginListInstance();
		BadSite badSite = (BadSite)siteList.get(siteId);
		if (isValid)
		{
			if (badSite != null) siteList.remove(siteId); 
		}
		else
		{
			if ( badSite== null) {
				badSite = new BadSite();
				badSite.setLastUpdateTime(GregorianCalendar.getInstance());
				badSite.setSiteId(siteId);
				badSite.setSiteKey(String.valueOf(siteKey));
				badSite.setStatus(0);
				badSite.setIp(ip);

				siteList.put(siteId, badSite);
				
			}
			else
			{
				if (badSite.getStatus() == 1) 
				{
					siteList.remove(siteId);
					isValid = true;
				}
			}
		}
		return isValid;
	}
    
    private void sendMessage(HttpServletResponse response, String message) throws IOException
    {
	        response.setContentType("text/plain");
		    PrintWriter out = new PrintWriter(response.getOutputStream());
  	        out.println(message);
 		    out.flush();
 		    out.close();
    }
    
    private String login(HttpServletRequest request,ActionMapping mapping, SecSiteValue ssv)
    {
            String ip = request.getRemoteAddr();

            String where = "shelterSelection";
            // String userName, password, pin, propName;
            String userName = ssv.getUserName();
            String password = String.valueOf(ssv.getPassword());
            String pin = ssv.getPin();
            if (userName.equals("")) {
                return "error:Login failed, please try again";
            }

            LoginCheckLogin cl = new LoginCheckLogin();
            if (cl.isBlock(userName)) {
                _logger.info(LOG_PRE + " Blocked: " + userName);
                return("error:Your account is locked. Please contact your administrator to unlock.");
            }

            Security user = null;
            String message = "";
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
    	                session = request.getSession(); // Create a new session for this user
    	            }
    	            
    	            String providerNo = user.getProviderNo();
    	            Provider provider = providerManager.getProvider(providerNo);
    	
    	            _logger.info("Assigned new session for: " + providerNo + " : " + provider.getLastName() + ", " + provider.getFirstName());
    	            LogAction.addLog(userName,providerNo, LogConst.LOGIN, LogConst.CON_LOGIN, "", ip);
    	
    	            session.setAttribute(KeyConstants.SESSION_KEY_PROVIDERNO, user.getProviderNo());
    	            session.setAttribute(KeyConstants.SESSION_KEY_PROVIDERNAME, provider.getLastName() + ", "+ provider.getFirstName());
    	
    	            session.setAttribute("oscar_context_path", request.getContextPath());
    	            session.setAttribute("expired_days", expired_days);
    	            
    	            // initiate security manager
    	            UserAccessManager userAccessManager = (UserAccessManager) getAppContext().getBean("userAccessManager");
    	            
    	            SecurityManager secManager = userAccessManager.getUserSecurityManager(providerNo,null,lookupManager);
    	            session.setAttribute(KeyConstants.SESSION_KEY_SECURITY_MANAGER, secManager);
    	
    	            session.setAttribute("provider", provider);
    	            return("confirmed:" +  mapping.findForward(where).getPath());
    	        }
    	        // expired password
    	        else if (user.getLoginStatus() == Security.PASSWORD_EXPIRED) {
    	           // cl.updateLoginList(ip, userName);
    	   	     	message = "Your account is expired. Please contact your administrator.";
    	        }
    	        else if (user.getLoginStatus() == Security.ACCOUNT_BLOCKED) {
                    _logger.info(LOG_PRE + " Blocked: " + userName);
                    // return mapping.findForward(where); //go to block page
                    message="Your account is locked. Please contact your administrator to unlock.";
                }
    	        else { 
    	            // request.setAttribute("login", "failed");
    	            LogAction.addLog(userName,null,"login", "failed", LogConst.CON_LOGIN,  ip);
    	            if (cl.updateLoginList(user) == Security.ACCOUNT_BLOCKED) {
    	                message="Your account is locked. Please contact your administrator to unlock.";
    	            }
    	            else
    	            {
    	   	     		message="Invalid Login or Password";
    	            }
    	        }
            }
            catch (Exception e) 
            {
    	        message =  e.getMessage();
            }
	        return("failed:"+message);        
        }
    
}
