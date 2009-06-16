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
 * TEAM> This software was written for the Department of Family Medicine McMaster Unviersity
 * Hamilton Ontario, Canada
 */
package oscar.login;

import java.security.MessageDigest;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.ArrayList;
import java.util.Calendar;

import org.oscarehr.util.SpringUtils;
import org.springframework.context.ApplicationContext;
import org.apache.log4j.Logger;

import oscar.util.UtilDateUtilities;


import com.quatro.model.security.*;

public class LoginCheckLogin {
//    private LookupManager lookupManager = (LookupManager) SpringUtils.getBean("lookupManager");

    LoginInfoBean linfo = null;

    LoginList llist = null;

    String propFileName = "";

    boolean propFileFound = true;
    
    // private static final Logger _logger = Logger.getLogger(LoginCheckLogin.class);
    // private static final String LOG_PRE = "Login!@#$: ";

    public LoginCheckLogin() {
    }

    public boolean isBlock(String userId) {
        boolean bBlock = false;
        
        GregorianCalendar now = new GregorianCalendar();
        while (llist == null) {
            llist = LoginList.getLoginListInstance(); // LoginInfoBean info =
            // null;
        }
        String sTemp = null;

        // delete the old entry in the loginlist if time out
        if (!llist.isEmpty()) {
            for (Enumeration e = llist.keys(); e.hasMoreElements();) {
                sTemp = (String) e.nextElement();
                linfo = (LoginInfoBean) llist.get(sTemp);
                if (linfo.getTimeOutStatus(now))
                    llist.remove(sTemp);
            }
            // check if it is blocked
            if (llist.get(userId) != null && ((LoginInfoBean) llist.get(userId)).getStatus() == 0)
                bBlock = true;
        }
        return bBlock;
    }

    // authenticate is used to check password
    public Security auth(String userName, String password, String pin, String ip, ApplicationContext appContext) throws Exception, SQLException {
        boolean isOk = false;
    	Security user = new Security();
    	user.setUserName(userName);
    	user.setPassword(password);
    	user.setPin(pin);
    	user.setLoginIP(ip);
    	user.setLoginDate(Calendar.getInstance().getTime());
    	if (isBlock(userName)) {
    		user.setLoginStatus(Security.ACCOUNT_BLOCKED);
    		return user;
    	}
    	return authenticate(appContext,user); 
    }

	private Security authenticate(ApplicationContext appContext,
			 Security user) throws Exception, SQLException {
		Security dbUser = getUser(user.getUserName(),appContext);
		// the user is not in security table
		if (dbUser == null) {
			user.setLoginStatus(Security.USER_NOT_EXISTS);
			return user;
		}
		if (dbUser.getBExpireset().intValue() == 1
				&& (dbUser.getDateExpiredate() == null || 
						dbUser.getDateExpiredate().before(UtilDateUtilities.now()))) {
			user.setLoginStatus(Security.PASSWORD_EXPIRED);
			return user;
		}
		boolean isAuthenticated = false;
    	if ("yes".equals(oscar.OscarProperties.getInstance().getProperty("ldap_authentication")))
    	{
    		com.quatro.ldap.LdapAuthentication ldap = (com.quatro.ldap.LdapAuthentication) appContext.getBean("ldapAuthentication");
    		isAuthenticated = ldap.authenticate(user.getUserName(), user.getPassword());
    	}
    	else
		{
			StringBuffer sbTemp = new StringBuffer();
			MessageDigest md = MessageDigest.getInstance("SHA");
			byte[] btTypeInPasswd = md.digest(user.getPassword().getBytes());
			for (int i = 0; i < btTypeInPasswd.length; i++)
				sbTemp = sbTemp.append(btTypeInPasswd[i]);
			String password = sbTemp.toString();

			String userpassword = dbUser.getPassword();
			if (userpassword.length() < 20) {
				sbTemp = new StringBuffer();
				byte[] btDBPasswd = md.digest(userpassword.getBytes());
				for (int i = 0; i < btDBPasswd.length; i++)
					sbTemp = sbTemp.append(btDBPasswd[i]);
				userpassword = sbTemp.toString();
			}
			isAuthenticated = password.equals(userpassword);
		}
		if (isAuthenticated) {
			dbUser.setLoginStatus(Security.LOGIN_SUCCESS);
			return dbUser;
		} else {
	    	if (isBlock(user.getUserName())) {
	    		user.setLoginStatus(Security.ACCOUNT_BLOCKED);
	    	}
	    	else
	    	{
	    		user.setLoginStatus(Security.LOGIN_FAILED);
	    	}
			return user;
		}
	}
	private com.quatro.model.security.Security getUser(String username,
			ApplicationContext appContext) throws SQLException {
		com.quatro.service.security.UsersManager um = (com.quatro.service.security.UsersManager) SpringUtils
				.getBean("usersManager");
		Security dbUser = um.getUser(username);
		if (dbUser == null)
			return null;
		com.quatro.model.security.SecProvider prov = um
				.getProviderByProviderNo(dbUser.getProviderNo(),"1");
		if(null==prov){
			return null;
		}
		return dbUser;
	}

    // update login list if login failed
    public synchronized int updateLoginList(Security user) {
    		oscar.OscarProperties pvar = oscar.OscarProperties.getInstance();
            GregorianCalendar now = new GregorianCalendar();
            String userName = user.getUserName();
            if (llist.get(userName) == null) {
                linfo = new LoginInfoBean(now, Integer.parseInt(pvar.getProperty("LOGIN_MAX_FAILED_TIMES")), Integer
                        .parseInt(pvar.getProperty("USER_LOCK_MAX_DURATION")),user);
            } else {
                linfo = (LoginInfoBean) llist.get(userName);
                linfo.updateLoginInfoBean(now, 1);
            }
            llist.put(userName, linfo);
            System.out.println(userName + "  status: " + ((LoginInfoBean) llist.get(userName)).getStatus() + " times: "
                    + linfo.getTimes() + " time: ");
            return isBlock(userName)?Security.ACCOUNT_BLOCKED:Security.LOGIN_FAILED;
    }

    public boolean unlock(String userId) {
        boolean bBlock = false;

        while (llist == null) {
            llist = LoginList.getLoginListInstance();
        }
        String sTemp = null;

        // unlocl the entry in the loginlist
        if (!llist.isEmpty()) {
            for (Enumeration e = llist.keys(); e.hasMoreElements();) {
                sTemp = (String) e.nextElement();
                if (sTemp.equals(userId)) {
                    llist.remove(sTemp);
                    bBlock = true;
                }
            }
        }
        return bBlock;
    }
    public void unlockSite(String siteId) {
        BadSiteList siteList = BadSiteList.getLoginListInstance();

        if (!siteList.isEmpty()) {
        	BadSite bs = (BadSite)siteList.get(siteId); 
        	if (bs != null) bs.setStatus(1);
        }
    }
    public LoginList findLockList() {

        while (llist == null) {
            llist = LoginList.getLoginListInstance();
        }
        return llist;
    }
    
    public ArrayList getBadSiteList()
    {
        BadSiteList  llist = BadSiteList.getLoginListInstance();
        ArrayList siteList = new ArrayList();
        for (Enumeration e = llist.keys(); e.hasMoreElements();) {
        	String key = (String) e.nextElement();
            BadSite bs = (BadSite)llist.get(key) ;
            siteList.add(bs);
        }
        return siteList;
    }

    public ArrayList getLockUserList() {

        while (llist == null) {
            llist = LoginList.getLoginListInstance();
        }
        ArrayList userList = new ArrayList();
        for (Enumeration e = llist.keys(); e.hasMoreElements();) {
        	String key = (String) e.nextElement();
            LoginInfoBean lb = (LoginInfoBean)llist.get(key) ;
            userList.add(lb.getUser());
        }
        return userList;
    }

	/**
	 * @return Returns the propFileFound.
	 */
	public boolean isPropFileFound() {
		return propFileFound;
	}

	/**
	 * @param propFileFound The propFileFound to set.
	 */
	public void setPropFileFound(boolean propFileFound) {
		this.propFileFound = propFileFound;
	}

	/**
	 * @return Returns the propFileName.
	 */
	public String getPropFileName() {
		return propFileName;
	}

	/**
	 * @param propFileName The propFileName to set.
	 */
	public void setPropFileName(String propFileName) {
		this.propFileName = propFileName;
	}
	
}
