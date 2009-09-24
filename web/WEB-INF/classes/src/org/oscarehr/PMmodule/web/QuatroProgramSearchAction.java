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
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.Provider;

import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ProgramManager;

import com.quatro.common.KeyConstants;
import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;

public class QuatroProgramSearchAction  extends BaseClientAction {
	   
	   private ProgramManager programManager;
	   private ClientManager clientManager;
	   private LookupManager lookupManager;
	   private IntakeManager intakeManager;
	   
	   public void setLookupManager(LookupManager lookupManager) {
		this.lookupManager = lookupManager;
	   }
	   public void setIntakeManager(IntakeManager intakeManager) {
			 this.intakeManager = intakeManager;
	   }
		public IntakeManager getIntakeManager() {
			return this.intakeManager;
		}

	public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	    		
	       return search_programs(mapping, form, request, response);
	   }	  
	    
	   public ActionForward search_programs(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		   try {
			   DynaActionForm clientForm = (DynaActionForm) form;
	
		       Program criteria = (Program) clientForm.get("program");
		       List lstProgram=programManager.search(criteria);
		       request.setAttribute("programs", lstProgram);
		       String cId = super.getClientId(request).toString();
		       HashMap actionParam = (HashMap) request.getAttribute("actionParam");
		       if(actionParam==null){
		    	  actionParam = new HashMap();
		          actionParam.put("clientId", cId); 
		       }
		      
		       List lstFacility=this.lookupManager.LoadCodeList("FAC", false, null, null);
		       request.setAttribute("lstFacility", lstFacility);
	
		       request.setAttribute("actionParam", actionParam);
		       request.setAttribute("clientId", cId);
		       request.setAttribute("formName", request.getParameter("formName"));
		       request.setAttribute("formElementId", request.getParameter("formElementId"));
		       /* set up validation rules */
	//	       Demographic clientObj =clientManager.getClientByDemographicNo(cId);
	//	       request.setAttribute("gender", clientObj.getSex());
	//	       request.setAttribute("age", clientObj.getAge());
	//	       ProgramUtils.addProgramRestrictions(request);
			   
		       request.setAttribute("notoken", "Y");
	
		       return mapping.findForward("view");
		   }
		   catch(SQLException e)
		   {
				return mapping.findForward("failure");
		   }
	   }
	   
	 
	   public void setClientManager(ClientManager clientManager) {
		 this.clientManager = clientManager;
	   }

	   public void setProgramManager(ProgramManager programManager) {
		 this.programManager = programManager;
	   }

	}