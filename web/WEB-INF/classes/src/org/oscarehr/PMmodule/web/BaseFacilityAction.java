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

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.oscarehr.PMmodule.web.admin.BaseAdminAction;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.security.SecurityManager;

public abstract class BaseFacilityAction extends BaseAdminAction {

	protected void setScreenMode(HttpServletRequest request, String currentTab, boolean isFacilityActive, Integer facilityId) throws NoAccessException {
		try {
			super.setMenu(request, KeyConstants.MENU_FACILITY);
			SecurityManager sec = super.getSecurityManager(request);
			// general
			String orgCd = "F" + facilityId.toString();
			
			if (sec.GetAccess(KeyConstants.FUN_FACILITY, orgCd).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_FACILITY_GENERAL,	KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_FACILITY_GENERAL))
					request.setAttribute(KeyConstants.TAB_FACILITY_GENERAL,	KeyConstants.ACCESS_CURRENT);
			}
			else 
			{
				request.setAttribute(KeyConstants.TAB_FACILITY_GENERAL,	KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_FACILITY_GENERAL)) throw new NoAccessException();
			}
			
			
			// program
			if (sec.GetAccess(KeyConstants.FUN_FACILITY_PROGRAM, orgCd).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_FACILITY_PROGRAM,	KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_FACILITY_PROGRAM))
					request.setAttribute(KeyConstants.TAB_FACILITY_PROGRAM,	KeyConstants.ACCESS_CURRENT);
			} 
			else {
				request.setAttribute(KeyConstants.TAB_FACILITY_PROGRAM,	KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_FACILITY_PROGRAM)) throw new NoAccessException();
			}
			
			
			// message
			if (sec.GetAccess(KeyConstants.FUN_FACILITY_MESSAGE  , orgCd).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_FACILITY_MESSAGE,	KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_FACILITY_MESSAGE))
					request.setAttribute(KeyConstants.TAB_FACILITY_MESSAGE,	KeyConstants.ACCESS_CURRENT);
			} 
			else 
			{
				request.setAttribute(KeyConstants.TAB_FACILITY_MESSAGE,KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_FACILITY_MESSAGE)) throw new NoAccessException();
			}
			
			
			//	Edit
			if (sec.GetAccess(KeyConstants.FUN_FACILITY_EDIT,orgCd).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_FACILITY_EDIT,KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_FACILITY_EDIT))
					request.setAttribute(KeyConstants.TAB_FACILITY_EDIT,KeyConstants.ACCESS_CURRENT);
			} 
			else
			{
				request.setAttribute(KeyConstants.TAB_FACILITY_EDIT,KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_FACILITY_EDIT)) throw new NoAccessException();
			}
			
			
			//	Bed
			if (sec.GetAccess(KeyConstants.FUN_FACILITY_BED, orgCd).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				if(isFacilityActive) {
					request.setAttribute(KeyConstants.TAB_FACILITY_BED,	KeyConstants.ACCESS_VIEW);
					if (currentTab.equals(KeyConstants.TAB_FACILITY_BED))
						request.setAttribute(KeyConstants.TAB_FACILITY_BED,	KeyConstants.ACCESS_CURRENT);
				}
				else
				{
					request.setAttribute(KeyConstants.TAB_FACILITY_BED,	KeyConstants.ACCESS_VIEW_NOCLICK);
				}
			} 
			else
			{
				request.setAttribute(KeyConstants.TAB_FACILITY_BED,	KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_FACILITY_BED)) throw new NoAccessException();
			}
		}
		catch(SQLException e)
		{
			;
		}
	}
	public boolean isReadOnly(HttpServletRequest request, String funName,Integer facilityId) throws NoAccessException{
		try {
			boolean readOnly =false;
			request.setAttribute("programId", facilityId); //for access log purpose
			SecurityManager sec = super.getSecurityManager(request);
			//summary
			String orgCd="";
			if(facilityId!=null ||facilityId.intValue()!=0) orgCd="F" + facilityId.toString();
			if (sec.GetAccess(funName, orgCd).compareTo(KeyConstants.ACCESS_READ) < 0)
			{
				throw new NoAccessException();
			}
			else if (sec.GetAccess(funName, orgCd).compareTo(KeyConstants.ACCESS_READ) == 0)
				readOnly=true;
			return readOnly;
		}
		catch(SQLException e)
		{
			throw new NoAccessException();
		}
	}
	public String getAccess(HttpServletRequest request, String funName,Integer facilityId, String right) throws NoAccessException{
		try {
			request.setAttribute("programId", facilityId); //for access log purpose
			SecurityManager sec = super.getSecurityManager(request);
			//summary
			String orgCd="";
			if(facilityId!=null ||facilityId.intValue()!=0) orgCd="F" + facilityId.toString();
			String access = sec.GetAccess(funName, orgCd);
			if (access.compareTo(right) < 0)
			{
				throw new NoAccessException();
			}
			return access;
		}
		catch(SQLException e)
		{
			return KeyConstants.ACCESS_NONE;
		}

	}

	//privated for now
	private boolean isCreatable(HttpServletRequest request, String funName,Integer shelterId, Integer facilityId) throws NoAccessException{
		boolean readOnly =false;
		try {
			request.setAttribute("programId", shelterId); //for access log purpose
			
			SecurityManager sec = super.getSecurityManager(request);
			//summary
			String orgCd="";
			orgCd="S" + shelterId.toString();
			String access = sec.GetAccess(funName, orgCd);
			if(access.compareTo(KeyConstants.ACCESS_WRITE) < 0)
			{
				throw new NoAccessException();
			}
			orgCd =  "";
			if(facilityId!=null ||facilityId.intValue()!=0) 
				orgCd="F" + facilityId.toString();
			if (sec.GetAccess(funName, orgCd).compareTo(KeyConstants.ACCESS_WRITE) < 0)
			{
				throw new NoAccessException();
			}
			return true;
		}
		catch(SQLException e)
		{
			throw new NoAccessException();
		}

	}
}