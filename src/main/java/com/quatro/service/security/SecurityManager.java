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
package com.quatro.service.security;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;

import org.oscarehr.util.SpringUtils;

import com.quatro.common.KeyConstants;
import com.quatro.dao.security.SecobjprivilegeDao;
import com.quatro.model.LookupCodeValue;
import com.quatro.model.security.Secobjprivilege;
import com.quatro.model.security.UserAccessValue;
import com.quatro.service.LookupManager;
import com.quatro.util.Utility;
public class SecurityManager {
	public static final String ACCESS_NONE = "o";
	public static final String ACCESS_READ = "r";
	public static final String ACCESS_UPDATE = "u";
	public static final String ACCESS_WRITE = "w";
	public static final String ACCESS_ALL = "x";
	private LookupManager lookupManager;
	Hashtable _userFunctionAccessList;
	List _userOrgAccessList;    /* list of all orgs the user has at least read only rights */
	public void setUserFunctionAccessList(Hashtable functionAccessList) {
		_userFunctionAccessList = functionAccessList;
	}
	
	public List getUserOrgAccessList() {
		return _userOrgAccessList;
	}

	public void setUserOrgAccessList(List orgAccessList) {
		_userOrgAccessList = orgAccessList;
	}

	public void setLookupManager(LookupManager lkManager) {
		lookupManager=lkManager;
		}
	
    public String GetAccess(String functioncd, String orgcd)
    {
        String privilege = this.ACCESS_NONE;
        LookupCodeValue lcv=lookupManager.GetLookupCode("ORG", orgcd);
        String codecsv="";
        if(lcv !=null)   codecsv= lcv.getCodecsv();
        
        try
        {
            List  orgList =  (List ) _userFunctionAccessList.get(functioncd);
            if(orgList!=null){ 
	            Iterator it = orgList.iterator();
	            
	            while(it.hasNext())
	            {
	            	UserAccessValue uav = (UserAccessValue)it.next();            
	            	if (uav.isOrgApplicable()) 
	            	{
	            		if ("".equals(orgcd) || Utility.IsEmpty(uav.getOrgCd()) || codecsv.startsWith(uav.getOrgCdcsv()))
		            	{
		            		privilege = uav.getPrivilege();
		            		break;
		            	} 
	            	}else{
	            		privilege = uav.getPrivilege();
	            		break;
	            	}
	            }
            }
        }  
        catch (Exception ex)
        {
        	;
        }

        if(privilege==null || privilege.equals(this.ACCESS_NONE)) {
        	if (functioncd.equals(KeyConstants.FUN_CLIENTHEALTHSAFETY)) {
        		privilege = this.ACCESS_READ;
        	}
        	else
        	{
        		privilege = this.ACCESS_NONE;
        	}
        }
        return privilege;
    }
    public String GetAccess(String function)
    {
        return GetAccess(function, "");
    }

    public boolean hasReadAccess(String objectName, String roleNames) {
    	boolean result=false;
    	
    	SecobjprivilegeDao secobjprivilegeDao = (SecobjprivilegeDao)SpringUtils.getBean("secobjprivilegeDao");
        
    	List<String> rl = new ArrayList<String>();
        for(String tmp:roleNames.split(",")) {
        	rl.add(tmp);
        }
        List<Secobjprivilege> priv = secobjprivilegeDao.getByObjectNameAndRoles(objectName,rl);
       
        if(priv.size()==0) {
        	return true;
        }
        for(Secobjprivilege p:priv) {
			if(p.getPrivilege_code().indexOf("r")!= -1)
				result=true;
			if(p.getPrivilege_code().indexOf("x")!= -1)
				result=true;
		}
    	return result;
    }

    public boolean hasWriteAccess(String objectName, String roleNames) {
    	return hasWriteAccess(objectName,roleNames,false);
    }
    
    public boolean hasWriteAccess(String objectName, String roleNames, boolean required) {
    	boolean result=false;
    	
    	SecobjprivilegeDao secobjprivilegeDao = (SecobjprivilegeDao)SpringUtils.getBean("secobjprivilegeDao");
        
    	List<String> rl = new ArrayList<String>();
        for(String tmp:roleNames.split(",")) {
        	rl.add(tmp);
        }
        List<Secobjprivilege> priv = secobjprivilegeDao.getByObjectNameAndRoles(objectName,rl);
       
        if(!required && priv.size()==0) {
        	return true;
        }
        if(required && priv.size()==0) {
        	return false;
        }
        for(Secobjprivilege p:priv) {
			if(p.getPrivilege_code().indexOf("w")!= -1)
				result=true;
			if(p.getPrivilege_code().indexOf("x")!= -1)
				result=true;
		}
    	return result;
    }
    
    public boolean hasDeleteAccess(String objectName, String roleNames) {
    	boolean result=false;
    	
    	SecobjprivilegeDao secobjprivilegeDao = (SecobjprivilegeDao)SpringUtils.getBean("secobjprivilegeDao");
        
    	List<String> rl = new ArrayList<String>();
        for(String tmp:roleNames.split(",")) {
        	rl.add(tmp);
        }
        List<Secobjprivilege> priv = secobjprivilegeDao.getByObjectNameAndRoles(objectName,rl);
       
        if(priv.size()==0) {
        	return true;
        }
        for(Secobjprivilege p:priv) {
			if(p.getPrivilege_code().indexOf("d")!= -1)
				result=true;
			if(p.getPrivilege_code().indexOf("x")!= -1)
				result=true;
		}
    	return result;
    }
}