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

package org.oscarehr.PMmodule.web.admin;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.DynaActionForm;
import org.oscarehr.PMmodule.model.Facility;
import org.oscarehr.PMmodule.model.FacilityMessage;
import org.oscarehr.PMmodule.service.FacilityManager;
import org.oscarehr.PMmodule.service.FacilityMessageManager;
import org.oscarehr.PMmodule.web.BaseFacilityAction;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.LookupManager;

public class FacilityMessageAction extends BaseFacilityAction {
	protected FacilityMessageManager mgr = null;
	protected FacilityManager facilityMgr = null;
	private LookupManager lookupManager;
	
	public void setFacilityMessageManager(FacilityMessageManager mgr) {
		this.mgr = mgr;
	}
	
	public void setFacilityManager(FacilityManager facilityMgr) {
		this.facilityMgr = facilityMgr;
	}
/*	
	public void setProgramProviderDAO(ProgramProviderDAO dao) {
		this.programProviderDAO = dao;
	}	
*/	
	public ActionForward unspecified(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		return list(mapping,form,request,response);
	}
		
	public ActionForward list(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		
    	try {
	    	HashMap actionParam = (HashMap) request.getAttribute("actionParam");
	        if(actionParam==null){
	     	  actionParam = new HashMap();
	           actionParam.put("facilityId", request.getParameter("facilityId")); 
	        }
	        request.setAttribute("actionParam", actionParam);
	        
	        
	    	String idStr = request.getParameter("facilityId");
	        Integer facilityId = Integer.valueOf(idStr);
	        Facility facility = facilityMgr.getFacility(facilityId);
	        request.setAttribute("facility", facility);
	        
	        super.setScreenMode(request, KeyConstants.TAB_FACILITY_MESSAGE,facility.getActive(), facilityId);      
	        /*
	         *  Lillian change Message related to Shelter not related to Facility 
	         */
			Integer shelterId=(Integer)request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
			String providerNo = (String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
			boolean isReadOnly =super.isReadOnly(request, KeyConstants.FUN_FACILITY_MESSAGE, facilityId);
			isReadOnly = (!facility.getActive()) || isReadOnly;
			if(isReadOnly) request.setAttribute("isReadOnly", Boolean.valueOf(isReadOnly));
			List activeMessages = mgr.getMessagesByFacilityId(providerNo, facilityId);
			if(activeMessages!=null && activeMessages.size() >0)
				request.setAttribute("ActiveFacilityMessages",activeMessages);
			return mapping.findForward("list");
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
	}
	
	public ActionForward edit(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		try {
	    	HashMap actionParam = (HashMap) request.getAttribute("actionParam");
	        if(actionParam==null){
	     	  actionParam = new HashMap();
	           actionParam.put("facilityId", request.getParameter("facilityId")); 
	        }
	        request.setAttribute("actionParam", actionParam);
	        
	        Integer facilityId = null;        
	    	String idStr = request.getParameter("facilityId");
	    	if(idStr == null){
	    		facilityId = (Integer)actionParam.get("facilityId");
	    	}else
	    		facilityId = Integer.valueOf(idStr);
	        Facility facility = facilityMgr.getFacility(facilityId);
	        request.setAttribute("facility", facility);
	        super.setScreenMode(request, KeyConstants.TAB_FACILITY_MESSAGE,facility.getActive(), facilityId);
			DynaActionForm facilityMessageForm = (DynaActionForm)form;
			String messageId = request.getParameter("id");
			if(messageId == null) messageId = (String)request.getAttribute("id");
				
			//List facilities = programProviderDAO.getFacilitiesInProgramDomain(providerNo);
			//List facilities = new ArrayList();
			//facilities.add((Facility)request.getSession(true).getAttribute("currentFacility"));
			
			//request.getSession(true).setAttribute("facilities", facilities);
			
	        Integer shelterId=(Integer)request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
	        boolean isReadOnly =super.isReadOnly(request, KeyConstants.FUN_FACILITY_MESSAGE, facilityId);
	        FacilityMessage msg = null;
	        if(messageId != null) {
				msg = mgr.getMessage(messageId);
				if(msg == null) {
					ActionMessages webMessage = new ActionMessages();
					webMessage.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("system_message.missing"));
					saveErrors(request,webMessage);
					return list(mapping,form,request,response);
				}
				isReadOnly = isReadOnly || msg.getExpired();
			}
			else
			{
				msg = new FacilityMessage();
				msg.setFacilityId(facilityId);
			}
	
			facilityMessageForm.set("facility_message",msg);
			List msgTypepList = lookupManager.LoadCodeList("MTP", true, null, null);
	        request.setAttribute("msgTypepList", msgTypepList);
			if(isReadOnly) request.setAttribute("isReadOnly", Boolean.valueOf(isReadOnly));
			return mapping.findForward("edit");
		   }
		   catch(NoAccessException e)
		   {
			   return mapping.findForward("failure");
		   }
		   catch(SQLException e)
		   {
				return mapping.findForward("failure");
		   }
	}

	public ActionForward save(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		try {

			DynaActionForm userForm = (DynaActionForm)form;
			FacilityMessage msg = (FacilityMessage)userForm.get("facility_message");
			if (msg.getId() != null && msg.getId().intValue()> 0)
	        	super.getAccess(request,KeyConstants.FUN_FACILITY_MESSAGE, msg.getFacilityId(),KeyConstants.ACCESS_UPDATE);
			else
	        	super.getAccess(request,KeyConstants.FUN_FACILITY_MESSAGE, msg.getFacilityId(), KeyConstants.ACCESS_WRITE);

			msg.setCreation_date(new Date());
			Integer facilityId = msg.getFacilityId();
			
	    	HashMap actionParam = (HashMap) request.getAttribute("actionParam");
	        if(actionParam==null){
	     	  actionParam = new HashMap();
	           actionParam.put("facilityId", facilityId); 
	        }
	        request.setAttribute("actionParam", actionParam);
			
			String facilityName = "";
			if(facilityId!=null && facilityId.intValue()!=0)
				facilityName = facilityMgr.getFacility(facilityId).getName();
			msg.setFacilityName(facilityName);
			try{
				//after discussing with Tony, Lillian change this facility message to shelter ralated 
				msg.setFacilityId(facilityId);
				mgr.saveFacilityMessage(msg);
				ActionMessages messages = new ActionMessages();
	            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.save.success", request.getContextPath()));
	            saveMessages(request, messages);
			}catch(Exception e){
		        ActionMessages messages = new ActionMessages();
		        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.save.failed", request.getContextPath()));
		        saveMessages(request,messages);
			}
			
			Facility facility = facilityMgr.getFacility(facilityId);
	        request.setAttribute("facility", facility);
	        super.setScreenMode(request, KeyConstants.TAB_FACILITY_MESSAGE,facility.getActive(),facilityId);
	
	        request.setAttribute("id",msg.getId().toString());
	        return edit(mapping, form, request, response);
	   }
	   catch(NoAccessException e)
	   {
		   return mapping.findForward("failure");
	   }
	}
	
	public ActionForward view(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		        
		//String providerNo = (String)request.getSession(true).getAttribute("user");
		//List messages = programProviderDAO.getFacilityMessagesInProgramDomain(providerNo);
		Integer shelterId = (Integer) request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
		String providerNo = (String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
		List messages = mgr.getMessagesByShelterId(providerNo,shelterId);
		if(messages!=null && messages.size()>0) {
			request.setAttribute("FacilityMessages",messages);
		}
		return mapping.findForward("view");
	}

	public void setLookupManager(LookupManager lookupManager) {
		this.lookupManager = lookupManager;
	}
}
