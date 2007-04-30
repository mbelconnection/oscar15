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
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;

import oscar.log.LogAction;
import oscar.log.LogConst;
import oscar.oscarDB.DBHandler;
import oscar.util.UtilDateUtilities;

public class LoginCheckLoginBean {
    private static final Logger _logger = Logger.getLogger(LoginCheckLoginBean.class);
    private static final String LOG_PRE = "Login!@#$: ";

    private String username = "";
    private String password = "";
    private String pin = "";
    private String ip = "";

    //private String userid = null; //who is logining? provider_no
    private String userpassword = null; //your password in the table
    //private String userpin = null; //your password in the table

    private String firstname = null;
    private String lastname = null;
    private String profession = null;
    private String rolename = null;
    Properties oscarVariables = null;
    private MessageDigest md;

    LoginSecurityBean secBean = null;
    DBHelp accessDB = null;

    public LoginCheckLoginBean() {
    }

    public void ini(String user_name, String password, String pin1, String ip1, Properties variables) {
        setUsername(user_name);
        setPassword(password);
        setPin(pin1);
        setIp(ip1);
        setVariables(variables);
    }

    public String[] authenticate() throws Exception, SQLException {
        secBean = getUserID();

        // the user is not in security table
        if (secBean == null) {
            return cleanNullObj(LOG_PRE + "No Such User: " + username);
        }
        // check pin if needed
        if (isWAN() && secBean.getB_RemoteLockSet().intValue() == 1
                && (!pin.equals(secBean.getPin()) || pin.length() < 3)) {
            return cleanNullObj(LOG_PRE + "Pin-remote needed: " + username);
        } else if (!isWAN() && secBean.getB_LocalLockSet().intValue() == 1
                && (!pin.equals(secBean.getPin()) || pin.length() < 3)) {
            return cleanNullObj(LOG_PRE + "Pin-local needed: " + username);
        }

        // check if it is expired
        if (secBean.getB_ExpireSet().intValue() == 1 && secBean.getDate_ExpireDate().before(UtilDateUtilities.now())) {
            return cleanNullObjExpire(LOG_PRE + "Expired: " + username);
        }
        
        //Give warning if the password will be expired in 10 days.
        long date_expireDate = secBean.getDate_ExpireDate().getTime();
       	long date_now = UtilDateUtilities.now().getTime();
        long date_diff = (date_expireDate - date_now)/(24*3600*1000);
        String expired_days = "";        
        if (secBean.getB_ExpireSet().intValue() == 1 && date_diff < 11) {
        	expired_days = String.valueOf(date_diff);        	
        }
        
        StringBuffer sbTemp = new StringBuffer();
        byte[] btTypeInPasswd = md.digest(password.getBytes());
        for (int i = 0; i < btTypeInPasswd.length; i++)
            sbTemp = sbTemp.append(btTypeInPasswd[i]);
        password = sbTemp.toString();

        userpassword = secBean.getPassword();
        if (userpassword.length() < 20) {
            sbTemp = new StringBuffer();
            byte[] btDBPasswd = md.digest(userpassword.getBytes());
            for (int i = 0; i < btDBPasswd.length; i++)
                sbTemp = sbTemp.append(btDBPasswd[i]);
            userpassword = sbTemp.toString();
        }

        if (password.equals(userpassword)) { // login successfully           
        	String[] strAuth = new String[6];
            strAuth[0] = secBean.getProvider_no();
            strAuth[1] = firstname;
            strAuth[2] = lastname;
            strAuth[3] = profession;
            strAuth[4] = rolename;
            strAuth[5] = expired_days;            
            return strAuth;
        } else { // login failed
            return cleanNullObj(LOG_PRE + "password failed: " + username);
        }
    }

    private String[] cleanNullObj(String errorMsg) {
        _logger.info(errorMsg);
        LogAction.addALog("", "failed", LogConst.CON_LOGIN, username, ip);
        userpassword = null;
        password = null;
        return null;
    }

    private String[] cleanNullObjExpire(String errorMsg) {
        _logger.info(errorMsg);
        LogAction.addALog("", "expired", LogConst.CON_LOGIN, username, ip);
        userpassword = null;
        password = null;
        return new String[] { "expired" };
    }

    private LoginSecurityBean getUserID() {
        LoginSecurityBean secBean = null;
        try {
            if (!DBHandler.isInit())
                DBHandler.init(oscarVariables.getProperty("db_name"), oscarVariables.getProperty("db_driver"),
                        oscarVariables.getProperty("db_uri"), oscarVariables.getProperty("db_username"),
                        oscarVariables.getProperty("db_password"));

            accessDB = new DBHelp();
            
            String sql = "select * from security where user_name = '" + StringEscapeUtils.escapeSql(username) + "'";
            ResultSet rs = accessDB.searchDBRecord(sql);
            while (rs.next()) {
                secBean = new LoginSecurityBean();
                secBean.setUser_name(rs.getString("user_name"));
                secBean.setPassword(rs.getString("password"));
                secBean.setProvider_no(rs.getString("provider_no"));
                secBean.setPin(rs.getString("pin"));
                secBean.setB_ExpireSet(new Integer(rs.getInt("b_ExpireSet")));
                secBean.setDate_ExpireDate(rs.getDate("date_ExpireDate"));
                secBean.setB_LocalLockSet(new Integer(rs.getString("b_LocalLockSet")));
                secBean.setB_RemoteLockSet(new Integer(rs.getString("b_RemoteLockSet")));
            }
            rs.close();

            if (secBean == null)
                return null;

            // find the detail of the user
            sql = "select first_name, last_name, provider_type from provider where provider_no = '"
                    + secBean.getProvider_no() + "'";
            rs = accessDB.searchDBRecord(sql);
            while (rs.next()) {
                firstname = rs.getString("first_name");
                lastname = rs.getString("last_name");
                profession = rs.getString("provider_type");
            }
            sql = "select * from secUserRole where provider_no = '" + secBean.getProvider_no() + "'";
            rs = accessDB.searchDBRecord(sql);
            while (rs.next()) {
                if (rolename == null) {
                    rolename = rs.getString("role_name");
                } else {
                    rolename += "," + rs.getString("role_name");
                }
            }
            return secBean;
        } catch (SQLException e) {
          e.printStackTrace();
            return null;
        }
    }

    public String[] getPreferences() {
    	if (org.oscarehr.common.IsPropertiesOn.isCaisiEnable()){
        String[] temp =  new String[] { "8", "18", "15", "a" ,"disabled"};
        ResultSet rs = null;
        try {
            String strSQL = "select start_hour, end_hour, every_min, mygroup_no,new_tickler_warning_window from preference where provider_no = '"
                    + secBean.getProvider_no() + "'";
            rs = accessDB.searchDBRecord(strSQL);
            while (rs.next()) {
                temp[0] = rs.getString("start_hour");
                temp[1] = rs.getString("end_hour");
                temp[2] = rs.getString("every_min");
                temp[3] = rs.getString("mygroup_no");
                temp[4] = rs.getString("new_tickler_warning_window");
            }
            rs.close();
        } catch (SQLException e) {
        } finally {
            if (temp[0] == null) { //no preference for the useid
                temp[0] = "8"; //default value
                temp[1] = "18";
                temp[2] = "15";
                temp[3] = "a";
                temp[4] = "disabled";
            }
        }
        return temp;
    	}else{
        String[] temp = new String[] { "8", "18", "15", "a" };
        ResultSet rs = null;
        try {
            String strSQL = "select start_hour, end_hour, every_min, mygroup_no from preference where provider_no = '"
                    + secBean.getProvider_no() + "'";
            rs = accessDB.searchDBRecord(strSQL);
            while (rs.next()) {
                temp[0] = rs.getString("start_hour");
                temp[1] = rs.getString("end_hour");
                temp[2] = rs.getString("every_min");
                temp[3] = rs.getString("mygroup_no");
            }
            rs.close();
        } catch (SQLException e) {
        } finally {
            if (temp[0] == null) { //no preference for the useid
                temp[0] = "8"; //default value
                temp[1] = "18";
                temp[2] = "15";
                temp[3] = "a";
            }
        }
        return temp;
    	}
    }

    public boolean isWAN() {
        boolean bWAN = true;
        if (ip.startsWith(oscarVariables.getProperty("login_local_ip")))
            bWAN = false;
        return bWAN;
    }

    public void setUsername(String user_name) {
        this.username = user_name;
    }

    public void setPassword(String password) {
        this.password = password.replace(' ', '\b'); //no white space to be allowed in the password
    }

    public void setPin(String pin1) {
        this.pin = pin1.replace(' ', '\b');
    }

    public void setIp(String ip1) {
        this.ip = ip1;
    }

    public void setVariables(Properties variables) {
        this.oscarVariables = variables;
        try {
            md = MessageDigest.getInstance("SHA"); //may get from prop file, e.g. MD5
        } catch (NoSuchAlgorithmException foo) {
            _logger.error(LOG_PRE + "NoSuchAlgorithmException - SHA");
        }
    }

}
