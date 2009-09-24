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
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.web.formbean.QuatroClientIntakeRejectForm;
import org.oscarehr.PMmodule.service.ProgramQueueManager;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.LookupManager;

public class QuatroClientIntakeRejectAction extends BaseProgramAction {
   private ClientManager clientManager;
   private ProgramQueueManager programQueueManager;
   private LookupManager lookupManager;
   private ProgramManager programManager;
	   
   public void setProgramManager(ProgramManager programManager) {
	this.programManager = programManager;
}
   
   public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   try {
		   QuatroClientIntakeRejectForm clientForm = (QuatroClientIntakeRejectForm) form;	   
		   String viewTab=request.getParameter("tab");
	       String id = request.getParameter("programId");
	       if(id == null || id.equals(""))
	       	id = (String)request.getAttribute("programId");
		   
	       super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE,Integer.valueOf(id),KeyConstants.ACCESS_WRITE);

		   HashMap actionParam = (HashMap) request.getAttribute("actionParam");
	       if(actionParam==null){
	    	  actionParam = new HashMap();
	          actionParam.put("programId", id); 
	       }
	       
	       String demographicNo= request.getParameter("clientId");
	       request.setAttribute("clientId", demographicNo);
	       request.setAttribute("client", clientManager.getClientByDemographicNo(demographicNo));
	
	       request.setAttribute("actionParam", actionParam);
	       request.setAttribute("programId", id);
	       request.setAttribute("program", programManager.getProgram(new Integer(id)));
	       super.setViewScreenMode(request, KeyConstants.TAB_PROGRAM_QUEUE,new Integer(id));      
	       List rejectReasons = lookupManager.LoadCodeList("IRR", true, null, null);
	       clientForm.setRejectReasonList(rejectReasons);
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

   public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
       ActionMessages messages = new ActionMessages();
       try {
	       String id = request.getParameter("programId");
	       if(id == null || id.equals(""))
	       	id = (String)request.getAttribute("programId");
	       
	       super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE,Integer.valueOf(id),KeyConstants.ACCESS_WRITE);

	       HashMap actionParam = (HashMap) request.getAttribute("actionParam");
	       if(actionParam==null){
	    	  actionParam = new HashMap();
	          actionParam.put("programId", id); 
	       }
	       request.setAttribute("actionParam", actionParam);
	       request.setAttribute("programId", id);
	       request.setAttribute("program", programManager.getProgram(new Integer(id)));
	       super.setViewScreenMode(request, KeyConstants.TAB_PROGRAM_QUEUE,new Integer(id));
	       boolean isError = false;
	       boolean isWarning = false;
		   QuatroClientIntakeRejectForm clientForm = (QuatroClientIntakeRejectForm) form;
		   programQueueManager.rejectQueue(clientForm.getQueueId(), clientForm.getRejectNote(), clientForm.getRejectReason());
	
		   if(!(isWarning || isError)) messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("message.save.success", request.getContextPath()));
	       saveMessages(request,messages);
		   
	       return edit(mapping, form, request, response);
	   }
	   catch(NoAccessException e)
	   {
		   return mapping.findForward("failure");
	   }
   }
   
   public void setClientManager(ClientManager clientManager) {
	 this.clientManager = clientManager;
   }

   public void setProgramQueueManager(ProgramQueueManager programQueueManager) {
	 this.programQueueManager = programQueueManager;
   }

   public void setLookupManager(LookupManager lookupManager) {
	 this.lookupManager = lookupManager;
   }

}
