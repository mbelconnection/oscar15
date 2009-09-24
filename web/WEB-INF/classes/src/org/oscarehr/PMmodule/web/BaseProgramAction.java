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
package org.oscarehr.PMmodule.web;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.oscarehr.PMmodule.web.admin.BaseAdminAction;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.security.SecurityManager;
import com.quatro.util.Utility;

public class BaseProgramAction extends BaseAdminAction {

	
	protected void setViewScreenMode(HttpServletRequest request, String currentTab,Integer orgId)throws NoAccessException {
		try {
			super.setMenu(request, KeyConstants.MENU_PROGRAM);
			SecurityManager sec = super.getSecurityManager(request);
			// general
			
			if (sec.GetAccess(KeyConstants.FUN_PROGRAM, orgId.toString()).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_PROGRAM_GENERAL,	KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_GENERAL))
					request.setAttribute(KeyConstants.TAB_PROGRAM_GENERAL,	KeyConstants.ACCESS_CURRENT);
			}
			else
			{
				request.setAttribute(KeyConstants.TAB_PROGRAM_GENERAL,	KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_GENERAL)) throw new NoAccessException();
			}
			
			// Queue
			if (sec.GetAccess(KeyConstants.FUN_PROGRAM_QUEUE, orgId.toString()).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_PROGRAM_QUEUE,	KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_QUEUE))
					request.setAttribute(KeyConstants.TAB_PROGRAM_QUEUE,	KeyConstants.ACCESS_CURRENT);
			} 
			else
			{
				request.setAttribute(KeyConstants.TAB_PROGRAM_QUEUE,	KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_QUEUE)) throw new NoAccessException();
			}
			
			// Clients
			if (sec.GetAccess(KeyConstants.FUN_PROGRAM_CLIENTS  , orgId.toString()).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_PROGRAM_CLIENTS,	KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_CLIENTS))
					request.setAttribute(KeyConstants.TAB_PROGRAM_CLIENTS,	KeyConstants.ACCESS_CURRENT);
			} 
			else
			{
				request.setAttribute(KeyConstants.TAB_PROGRAM_CLIENTS,KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_CLIENTS)) throw new NoAccessException();
			}
			
			//	Incidents
			if (sec.GetAccess(KeyConstants.FUN_PROGRAM_INCIDENT, orgId.toString()).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_PROGRAM_INCIDENTS,KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_INCIDENTS))
					request.setAttribute(KeyConstants.TAB_PROGRAM_INCIDENTS,KeyConstants.ACCESS_CURRENT);
			} 
			else
			{
				request.setAttribute(KeyConstants.TAB_PROGRAM_INCIDENTS,KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_INCIDENTS)) throw new NoAccessException();
			}
			
			//	Bed
			if (sec.GetAccess(KeyConstants.FUN_PROGRAM_SERVICERESTRICTIONS, orgId.toString()).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_PROGRAM_SEVICE,	KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_SEVICE))
					request.setAttribute(KeyConstants.TAB_PROGRAM_SEVICE,	KeyConstants.ACCESS_CURRENT);
			} else
			{
				request.setAttribute(KeyConstants.TAB_PROGRAM_SEVICE,	KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_SEVICE)) throw new NoAccessException();
			}
	//		Staff
			if (sec.GetAccess(KeyConstants.FUN_PROGRAM_STAFF, orgId.toString()).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_PROGRAM_STAFF,	KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_STAFF))
					request.setAttribute(KeyConstants.TAB_PROGRAM_STAFF,	KeyConstants.ACCESS_CURRENT);
			} else
			{
				request.setAttribute(KeyConstants.TAB_PROGRAM_STAFF,	KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_STAFF)) throw new NoAccessException();
			}
		}
		catch(SQLException e)
		{
			throw new NoAccessException();
		}

	}
	
	protected void setEditScreenMode(HttpServletRequest request, String currentTab, Integer programId) throws NoAccessException{
		try {
			super.setMenu(request, KeyConstants.MENU_PROGRAM);
			SecurityManager sec = super.getSecurityManager(request);
			// general
			String orgCd = "P" + programId.toString();
			if (sec.GetAccess(KeyConstants.FUN_PROGRAM, orgCd).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_PROGRAM_GENERAL,	KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_GENERAL))
					request.setAttribute(KeyConstants.TAB_PROGRAM_GENERAL,	KeyConstants.ACCESS_CURRENT);
			}
			else
			{
				request.setAttribute(KeyConstants.TAB_PROGRAM_GENERAL,	KeyConstants.ACCESS_NULL);			
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_GENERAL)) throw new NoAccessException();
			}
			
			if (sec.GetAccess(KeyConstants.FUN_PROGRAMEDIT_SERVICERESTRICTIONS,orgCd).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_PROGRAM_SEVICE,	KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_SEVICE))
					request.setAttribute(KeyConstants.TAB_PROGRAM_SEVICE,	KeyConstants.ACCESS_CURRENT);
			}
			else
			{
				request.setAttribute(KeyConstants.TAB_PROGRAM_SEVICE,	KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_PROGRAM_SEVICE)) throw new NoAccessException();
			}
		}
		catch(SQLException e)
		{
			throw new NoAccessException();
		}

	}
	
	
	public boolean isReadOnly(HttpServletRequest request, String funName,Integer programId) throws NoAccessException {
		try {
			
			boolean readOnly =false;
	
			if (request.getAttribute("programId") == null) request.setAttribute("programId", programId); 
			
			SecurityManager sec = super.getSecurityManager(request);
			//summary
			String orgCd="";
			if(programId!=null && programId.intValue()!=0) orgCd="P" + programId.toString();
			if (sec.GetAccess(funName, orgCd).compareTo(KeyConstants.ACCESS_READ) < 0)
			{
				throw new NoAccessException();
			}
			else if (sec.GetAccess(funName, orgCd).compareTo(KeyConstants.ACCESS_READ) == 0)
			{
				readOnly=true;
			}
			return readOnly;
		}
		catch(SQLException e)
		{
			throw new NoAccessException();
		}

	}
	public String getAccess(HttpServletRequest request, String funName,Integer programId, String right) throws NoAccessException {
		try {
			if (request.getAttribute("programId") == null) request.setAttribute("programId", programId); 		
			SecurityManager sec = super.getSecurityManager(request);
			//summary
			String orgCd="";
			if(programId!=null && programId.intValue()!=0) orgCd="P" + programId.toString();
			String access = sec.GetAccess(funName, orgCd);
			if (access.compareTo(right) < 0)
			{
				throw new NoAccessException();
			}
			return access;
		}
		catch(SQLException e)
		{
			throw new NoAccessException();
		}
	}
}
