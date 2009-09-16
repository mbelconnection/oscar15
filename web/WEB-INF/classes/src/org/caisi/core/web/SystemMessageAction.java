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

package org.caisi.core.web;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.caisi.model.SystemMessage;
import org.caisi.service.SystemMessageManager;
import org.oscarehr.PMmodule.web.admin.BaseAdminAction;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.LookupManager;
import com.quatro.service.security.SecurityManager;

public class SystemMessageAction extends BaseAdminAction {

	private static Logger log = LogManager.getLogger(SystemMessageAction.class);
	
	protected SystemMessageManager mgr = null;
	private LookupManager lookupManager;
	
	public void setSystemMessageManager(SystemMessageManager mgr) {
		this.mgr = mgr;
	}
	
	public ActionForward unspecified(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		return list(mapping,form,request,response);
	}
		
	public ActionForward list(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response) {
//		List activeMessages = mgr.getMessages();
		try {
			super.getAccess(request, KeyConstants.FUN_ADMIN_SYSTEMMESSAGE);
			List activeMessages = mgr.getMessages();
			request.setAttribute("ActiveMessages",activeMessages);
			return mapping.findForward("list");
		}
		catch(NoAccessException e)
		{
			return mapping.findForward("failure");
		}
	}
	
	public ActionForward edit(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		try {
			DynaActionForm systemMessageForm = (DynaActionForm)form;
			String messageId = request.getParameter("id");
			if(messageId == null)
				messageId = (String)request.getAttribute("systemMsgId");
	        boolean isReadOnly =false;		
			if(messageId != null) {
				SystemMessage msg = mgr.getMessage(messageId);
				
				if(msg == null) {
					ActionMessages webMessage = new ActionMessages();
					webMessage.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("system_message.missing"));
					saveErrors(request,webMessage);
					return list(mapping,form,request,response);
				}
				isReadOnly = msg.getExpired();
				systemMessageForm.set("system_message",msg);
				super.getAccess(request, KeyConstants.FUN_ADMIN_SYSTEMMESSAGE);
			}
			else
			{
				super.getAccess(request, KeyConstants.FUN_ADMIN_SYSTEMMESSAGE,KeyConstants.ACCESS_WRITE);
			}
			
			List msgTypepList = lookupManager.LoadCodeList("MTP", true, null, null);
	        request.setAttribute("msgTypepList", msgTypepList);
			SecurityManager sec = (SecurityManager) request.getSession()
			.getAttribute(KeyConstants.SESSION_KEY_SECURITY_MANAGER);
			if (!isReadOnly)
			{
				if (sec.GetAccess(KeyConstants.FUN_ADMIN_SYSTEMMESSAGE, null).compareTo(KeyConstants.ACCESS_READ) <= 0) 
					isReadOnly=true;
			}
			if(isReadOnly) request.setAttribute("isReadOnly", Boolean.valueOf(isReadOnly));
			return mapping.findForward("edit");
		}
		catch(NoAccessException e)
		{
			return mapping.findForward("failure");
		}
	}

	public ActionForward save(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm userForm = (DynaActionForm)form;
		SystemMessage msg = (SystemMessage)userForm.get("system_message");
		msg.setCreation_date(new Date());
	
        try{
        	super.getAccess(request, KeyConstants.FUN_ADMIN_SYSTEMMESSAGE,KeyConstants.ACCESS_WRITE);
        	mgr.saveSystemMessage(msg);
			ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.save.success", request.getContextPath()));
            saveMessages(request, messages);
        }catch(NoAccessException e)
        {
        	return mapping.findForward("failure");
		}catch(Exception e){
	        ActionMessages messages = new ActionMessages();
	        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.save.failed", request.getContextPath()));
	        saveMessages(request,messages);
		}
		request.setAttribute("systemMsgId", msg.getId().toString());
        return edit(mapping, form, request, response);
	}
	public ActionForward view(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		try { 
			//super.getAccess(request, KeyConstants.FUN_ADMIN_SYSTEMMESSAGE);
			List messages = mgr.getActiveMessages();
			if(messages.size()>0) {
				request.setAttribute("messages",messages);
			}
			return mapping.findForward("view");
		}
		catch(Exception e)
		{
			return mapping.findForward("view");
			//return mapping.findForward("failure");
		}
	}

	public void setLookupManager(LookupManager lookupManager) {
		this.lookupManager = lookupManager;
	}
}
