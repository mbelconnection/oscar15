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

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.service.AdmissionManager;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.casemgmt.service.CaseManagementManager;


import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.IntakeManager;
import com.quatro.service.security.SecurityManager;
import com.quatro.util.Utility;

public abstract class BaseClientAction extends BaseAction {
	
	protected void setScreenMode(HttpServletRequest request, String currentTab)throws NoAccessException {

		super.setMenu(request, KeyConstants.MENU_CLIENT);
		SecurityManager sec = super.getSecurityManager(request);
		//summary
		Integer clientId = getClientId(request);
		if(clientId == null || clientId.intValue() == 0 ||KeyConstants.FUN_CLIENT.equals(currentTab)){
			request.setAttribute(KeyConstants.TAB_CLIENT_SUMMARY, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_HEALTH, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_DISCHARGE, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_ADMISSION, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_CONSENT, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_HISTORY, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_INTAKE, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_REFER, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_RESTRICTION, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_COMPLAINT, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_CASE, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_ATTCHMENT, KeyConstants.ACCESS_NULL);
			request.setAttribute(KeyConstants.TAB_CLIENT_TASK, KeyConstants.ACCESS_NULL);	
			request.setAttribute(KeyConstants.TAB_CLIENT_PRINTLABEL, KeyConstants.ACCESS_NULL);
			
		}
		else
		{
			if (sec.GetAccess(KeyConstants.FUN_CLIENT).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_SUMMARY, KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_SUMMARY))request.setAttribute(KeyConstants.TAB_CLIENT_SUMMARY, KeyConstants.ACCESS_CURRENT);
			} else
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_SUMMARY, KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_SUMMARY)) throw new NoAccessException();
			}
			if (sec.GetAccess(KeyConstants.FUN_CLIENTHEALTHSAFETY).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_HEALTH, KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_HEALTH))request.setAttribute(KeyConstants.TAB_CLIENT_SUMMARY, KeyConstants.ACCESS_CURRENT);
			} else
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_HEALTH, KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_HEALTH)) throw new NoAccessException();
			}
			//discharge
			if (sec.GetAccess(KeyConstants.FUN_CLIENTDISCHARGE).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_DISCHARGE, KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_DISCHARGE))	request.setAttribute(KeyConstants.TAB_CLIENT_DISCHARGE, KeyConstants.ACCESS_CURRENT);
			}else {
				request.setAttribute(KeyConstants.TAB_CLIENT_DISCHARGE, KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_DISCHARGE))	throw new NoAccessException();
			}
			//admission
			if (sec.GetAccess(KeyConstants.FUN_CLIENTADMISSION).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_ADMISSION, KeyConstants.ACCESS_VIEW);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_ADMISSION))request.setAttribute(KeyConstants.TAB_CLIENT_ADMISSION, KeyConstants.ACCESS_CURRENT);
			}
			else {
				request.setAttribute(KeyConstants.TAB_CLIENT_ADMISSION, KeyConstants.ACCESS_NULL);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_ADMISSION))throw new NoAccessException();
			}
			//consent
			if (sec.GetAccess(KeyConstants.FUN_CLIENTCONSENT).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_CONSENT, KeyConstants.ACCESS_VIEW);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_CONSENT))request.setAttribute(KeyConstants.TAB_CLIENT_CONSENT, KeyConstants.ACCESS_CURRENT);
			}
			else 
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_CONSENT, KeyConstants.ACCESS_NULL);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_CONSENT)) throw new NoAccessException();
			}
			//history
			if (sec.GetAccess(KeyConstants.FUN_CLIENTHISTORY).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_HISTORY, KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_HISTORY))request.setAttribute(KeyConstants.TAB_CLIENT_HISTORY, KeyConstants.ACCESS_CURRENT);
			}
			else 
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_HISTORY, KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_HISTORY)) throw new NoAccessException();
			}
			//intake
			if (sec.GetAccess(KeyConstants.FUN_CLIENTINTAKE).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_INTAKE, KeyConstants.ACCESS_VIEW);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_INTAKE))request.setAttribute(KeyConstants.TAB_CLIENT_INTAKE, KeyConstants.ACCESS_CURRENT);
			}
			else 
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_INTAKE, KeyConstants.ACCESS_NULL);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_INTAKE)) throw new NoAccessException();
			}
			//refer
			if (sec.GetAccess(KeyConstants.FUN_CLIENTREFER).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_REFER, KeyConstants.ACCESS_VIEW);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_REFER))request.setAttribute(KeyConstants.TAB_CLIENT_REFER, KeyConstants.ACCESS_CURRENT);
			}
			else 
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_REFER, KeyConstants.ACCESS_NULL);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_REFER))throw new NoAccessException();
			}
			//restriction
			if (sec.GetAccess(KeyConstants.FUN_CLIENTRESTRICTION).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_RESTRICTION, KeyConstants.ACCESS_VIEW);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_RESTRICTION))request.setAttribute(KeyConstants.TAB_CLIENT_RESTRICTION, KeyConstants.ACCESS_CURRENT);
			}
			else 
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_RESTRICTION, KeyConstants.ACCESS_NULL);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_RESTRICTION)) throw new NoAccessException();
			}
			//complaint
			if (sec.GetAccess(KeyConstants.FUN_CLIENTCOMPLAINT).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_COMPLAINT, KeyConstants.ACCESS_VIEW);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_COMPLAINT))request.setAttribute(KeyConstants.TAB_CLIENT_COMPLAINT, KeyConstants.ACCESS_CURRENT);
			}
			else
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_COMPLAINT, KeyConstants.ACCESS_NULL);
				if(currentTab.equals(KeyConstants.TAB_CLIENT_COMPLAINT))throw new NoAccessException();
			}
			//case
			if (sec.GetAccess(KeyConstants.FUN_CLIENTCASE).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_CASE, KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_CASE))request.setAttribute(KeyConstants.TAB_CLIENT_CASE, KeyConstants.ACCESS_CURRENT);
			}
			else
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_CASE, KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_CASE)) throw new NoAccessException();
			}
			//attachment
			if (sec.GetAccess(KeyConstants.FUN_CLIENTDOCUMENT).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_ATTCHMENT, KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_ATTCHMENT))request.setAttribute(KeyConstants.TAB_CLIENT_ATTCHMENT, KeyConstants.ACCESS_CURRENT);
			}
			else
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_ATTCHMENT, KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_ATTCHMENT)) throw new NoAccessException();
			}
			//task
			if (sec.GetAccess(KeyConstants.FUN_CLIENTTASKS).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_TASK, KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_TASK))request.setAttribute(KeyConstants.TAB_CLIENT_TASK, KeyConstants.ACCESS_CURRENT);
			}
			else
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_TASK, KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_TASK)) throw new NoAccessException();
			}
//			Print Label
			if (sec.GetAccess(KeyConstants.FUN_CLIENTPRINTLABEL).compareTo(KeyConstants.ACCESS_READ) >= 0) {
				request.setAttribute(KeyConstants.TAB_CLIENT_PRINTLABEL, KeyConstants.ACCESS_VIEW);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_PRINTLABEL))request.setAttribute(KeyConstants.TAB_CLIENT_PRINTLABEL, KeyConstants.ACCESS_CURRENT);
			}
			else 
			{
				request.setAttribute(KeyConstants.TAB_CLIENT_PRINTLABEL, KeyConstants.ACCESS_NULL);
				if (currentTab.equals(KeyConstants.TAB_CLIENT_PRINTLABEL)) throw new NoAccessException();
			}
		}
	}
	protected boolean isReadOnly(HttpServletRequest request, String status,String funName,Integer programId) throws NoAccessException 
	{
		if(request.getAttribute("programId") == null) request.setAttribute("programId", programId);
		if(getAccess(request, funName, programId).equals(KeyConstants.ACCESS_NONE)) throw new NoAccessException();
		boolean readOnly =false;
		if(KeyConstants.STATUS_COMPLETED.equals(status)) readOnly =true;
		else if(KeyConstants.STATUS_INACTIVE.equals(status)){
			if(KeyConstants.FUN_CLIENTINTAKE.equals(funName))readOnly =true;	
		}
		else if(KeyConstants.STATUS_SIGNED.equals(status)) readOnly =true;
		else if(KeyConstants.STATUS_DISCHARGED.equals(status)) readOnly =true;
		else if(KeyConstants.STATUS_EXPIRED.equals(status)) readOnly =true;
		else if(KeyConstants.STATUS_TERMEARLY.equals(status)) readOnly =true;
		else if(KeyConstants.STATUS_WITHDRAW.equals(status)) readOnly = true;
		else if(KeyConstants.STATUS_ACCEPTED.equals(status)){			
		//	if(KeyConstants.FUNCTION_INTAKE.equals(funName))readOnly =true;
		//	else if(KeyConstants.FUNCTION_ADMISSION.equals(funName))readOnly =true;	
			if(KeyConstants.FUN_CLIENTREFER.equals(funName))readOnly =true;	
		}
		else if(KeyConstants.STATUS_READONLY.equals(status)) readOnly =true;
		else if(KeyConstants.STATUS_REJECTED.equals(status)) {
			readOnly =true;
			if(KeyConstants.FUN_CLIENTREFER.equals(funName))readOnly =false;
		}
		SecurityManager sec = super.getSecurityManager(request);
		//summary
		if(programId==null) return true;
		
		String orgCd="";		
		if(programId.intValue()!=0) {
			orgCd="P" + programId.toString();
		}
		if (sec.GetAccess(funName, orgCd).compareTo(KeyConstants.ACCESS_READ) <= 0) 
			readOnly=true;
		return readOnly;
	}
	protected String getAccess(HttpServletRequest request, String fucName,Integer programId) throws NoAccessException {
		String orgCd="";
		if(programId != null && programId.intValue()!=0) {
			orgCd="P" + programId.toString();
		}
		if(request.getAttribute("programId") == null) request.setAttribute("programId", programId);
		SecurityManager sec = super.getSecurityManager(request);
		String access = sec.GetAccess(fucName, orgCd); 
		if(KeyConstants.ACCESS_NONE.equals(access)) throw new NoAccessException();
		return access;
	}
	protected String getAccess(HttpServletRequest request, String fucName,Integer programId, String rights) throws NoAccessException {
		String access = getAccess(request,fucName, programId);
		if(access.compareTo(rights) < 0) throw new NoAccessException();
		return access;
	}
	protected boolean hasAccess(HttpServletRequest request,String funName,Integer programId, Integer programId2)
	{
		if(request.getAttribute("programId") == null) request.setAttribute("programId", programId);
		String r = KeyConstants.ACCESS_NONE;
		try {
			r = getAccess(request, funName, programId);
		}
		catch(NoAccessException e)
		{
			r = KeyConstants.ACCESS_NONE;
		}
		if(r.equals(KeyConstants.ACCESS_NONE)) {
			try {
				r = getAccess(request, funName, programId2);
			}
			catch(Exception e)
			{
				r  = KeyConstants.ACCESS_NONE;
			}
		}
		return r.compareTo(KeyConstants.ACCESS_READ) >=0;
	}
	protected Demographic getClient(HttpServletRequest request, Integer clientId)
	{
		Demographic client = null;
		if (request.getSession().getAttribute("client") == null)
		{
			cacheClient(request, clientId);
			client = (Demographic)request.getSession().getAttribute("client");
		}
		else
		{
			client = (Demographic)request.getSession().getAttribute("client");
			if (client.getDemographicNo().intValue() != clientId.intValue())
			{
				cacheClient(request, clientId);
				client = (Demographic)request.getSession().getAttribute("client");
			}
		}
		return client;
	}
	
	protected void cacheClient(HttpServletRequest request, Integer clientId)
	{
		Demographic client = 	null;
		if (clientId == null || clientId.intValue() == 0 ) {
			request.getSession().removeAttribute("client");
			if (clientId == null) request.getSession().removeAttribute("clientId");
			return;
		}
		if (clientId.intValue() > 0)
		{
			client = this.getIntakeManager().getClientByDemographicNo(clientId);
		}
		else
		{
			client = new Demographic();
			client.setLastName("");
			client.setFirstName("");
		}
		request.getSession().setAttribute("client", client);
		request.getSession().setAttribute("clientId", clientId);		
	}
	protected void setCurrentIntakeProgramId(HttpServletRequest request,  Integer clientId, Integer shelterId, String providerNo)
	{
	       List lst = this.getIntakeManager().getQuatroIntakeHeaderListByFacility(clientId, shelterId, providerNo);
	       QuatroIntakeHeader obj0 = null;
	       Integer programIdActive = new Integer(0);
	       Integer programId  = new Integer(0);
	       Integer currentIntakeId = new Integer(0);
	       boolean isAdmittedOrActive = false;
	       for(int i=0; i<lst.size() ; i++) {
	    	   obj0=  (QuatroIntakeHeader)lst.get(i);
	  		   if (obj0.getIntakeStatus().equals(KeyConstants.STATUS_ADMITTED)) {
	  			   programIdActive = obj0.getProgramId();
	  			   programId = programIdActive;
	  			   currentIntakeId = obj0.getId();
		    	   isAdmittedOrActive = true;
		    	   break;
	  		   }
	       }       
	
	       if(!isAdmittedOrActive) {
	    	   for(int i=0;i<lst.size();i++){
	    		   QuatroIntakeHeader obj1 = (QuatroIntakeHeader)lst.get(i);
	    			   if(obj1.getIntakeStatus().equals(KeyConstants.STATUS_ACTIVE)) {
	    	  			   programIdActive = obj0.getProgramId();
	    	  			   programId = programIdActive;
	    	  			   currentIntakeId = obj1.getId();
	    		    	   isAdmittedOrActive = true;
	    		    	   break;
	    			   }
//	    		   }
	    	   }
	       }
	       if(!isAdmittedOrActive && lst.size() > 0) {
    		   QuatroIntakeHeader obj1 = (QuatroIntakeHeader)lst.get(0);
  			   programId = obj1.getProgramId();
  			   currentIntakeId = obj1.getId();
	       }
	       request.getSession().setAttribute("currentIntakeProgramIdActive",programIdActive);
	       request.getSession().setAttribute("currentIntakeProgramId",programId);
	       request.getSession().setAttribute("currentIntakeId",currentIntakeId);
	}
	protected Integer getCurrentIntakeProgramId(HttpServletRequest request,boolean activeOne)
	{
		if (activeOne)
			return (Integer)request.getSession().getAttribute("currentIntakeProgramIdActive");
		else
	        return (Integer) request.getSession().getAttribute("currentIntakeProgramId");
			
	}
	protected Integer getCurrentIntakeId(HttpServletRequest request)
	{
	    return (Integer) request.getSession().getAttribute("currentIntakeId");
	}
	protected Integer getClientId(HttpServletRequest request){
		 return (Integer) request.getSession().getAttribute("clientId");
	}
	protected String getClientName(HttpServletRequest request){
		 return ((Demographic) request.getSession().getAttribute("client")).getFormattedName();
	}

	protected abstract void setIntakeManager(IntakeManager intakeManager);
	protected abstract IntakeManager getIntakeManager();
}