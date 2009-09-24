/*******************************************************************************
 * Copyright (c) 2005, 2009 IBM Corporation and others.
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
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.oscarehr.PMmodule.service.ClientManager;

import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;
import com.quatro.util.Utility;

import org.oscarehr.PMmodule.web.formbean.ClientSearchFormBean;
import org.oscarehr.PMmodule.model.Demographic;

import com.quatro.common.KeyConstants;
import com.quatro.model.LookupCodeValue;
import com.quatro.model.security.NoAccessException;

import oscar.MyDateFormat;

public class DuplicateClientCheckAction extends BaseClientAction {
   private ClientManager clientManager;
   private LookupManager lookupManager;
   private IntakeManager intakeManager;

   public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException{
	   try {
		   super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, null);
		   DynaActionForm qform = (DynaActionForm) form;
	       Demographic client = (Demographic) qform.get("client");
	       
	       client.setFirstName(request.getParameter("firstName"));
		   client.setLastName(request.getParameter("lastName"));
		   client.setDob(request.getParameter("dob"));
		   client.setSex( request.getParameter("sex"));
		   client.setAlias(request.getParameter("alias"));
	
		   List clients = getClientList(client);
		   if(!Utility.IsEmpty(client.getFirstName()) && !Utility.IsEmpty(client.getLastName()))
		   {
			   client.setDemographicNo(new Integer(0));
			   clients.add(0, client);
		   }
		   request.setAttribute("clients", clients);
		   
		   request.setAttribute("pageFrom", request.getParameter("pageFrom"));
		   request.setAttribute("var", request.getParameter("var"));
		   request.setAttribute("shortFlag", request.getParameter("shortFlag"));
		   if(!Utility.IsEmpty(request.getParameter("var"))){
			   String[] split= request.getParameter("var").split(",");
			   request.setAttribute("formName", split[0]);
			   request.setAttribute("firstName", split[1]);
			   request.setAttribute("lastName", split[2]);
			   request.setAttribute("sex", split[3]);
			   request.setAttribute("dob", split[4]);
			   request.setAttribute("alias", split[5]);
			   request.setAttribute("clientNo", split[6]);
			   request.setAttribute("statusMsg", split[7]);
			   request.setAttribute("newClientChecked", split[8]);
		   }
		   setEditFields(request,qform);
		   request.setAttribute("notoken", "Y");
		   return mapping.findForward("edit");
	   }
	   catch(SQLException e)
	   {
			return mapping.findForward("failure");
	   }
   }
   public ActionForward search(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException {
	   try {
		   super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, null);
	       DynaActionForm qform = (DynaActionForm) form;
	       Demographic client = (Demographic) qform.get("client");
	       
	       List clients = getClientList(client);
		   request.setAttribute("clients", clients);
	
	       setEditFields(request,qform);
	
		   request.setAttribute("formName", request.getParameter("formName"));
		   request.setAttribute("firstName", request.getParameter("firstName"));
		   request.setAttribute("lastName", request.getParameter("lastName"));
		   request.setAttribute("sex", request.getParameter("sex"));
		   request.setAttribute("dob", request.getParameter("dob"));
		   request.setAttribute("alias", request.getParameter("alias"));
		   request.setAttribute("clientNo", request.getParameter("clientNo"));
		   request.setAttribute("statusMsg", request.getParameter("statusMsg"));
		   request.setAttribute("newClientChecked", request.getParameter("newClientChecked"));
		   request.setAttribute("notoken", "Y");
		   return mapping.findForward("edit");
	   }
	   catch(SQLException e)
	   {
			return mapping.findForward("failure");
	   }
   }
   private List getClientList(Demographic client)
   {
       ClientSearchFormBean criteria = new ClientSearchFormBean();
       boolean hasCriteria = false;
	   criteria.setActive("");
	   criteria.setAssignedToProviderNo("");
	   if (!Utility.IsEmpty(client.getLastName())) hasCriteria=true; 
       criteria.setLastName(client.getLastName());
	   if (!Utility.IsEmpty(client.getFirstName())) hasCriteria=true; 
       criteria.setFirstName(client.getFirstName());
	   if (!Utility.IsEmpty(client.getDob())) hasCriteria=true; 
//       criteria.setDob(client.getDob());
       criteria.setGender(client.getSex());
       if(hasCriteria) {
    	   return clientManager.search(criteria, false,true);
       }
       else
       {
    	   return new java.util.ArrayList();
       }
   }
   private void setEditFields(HttpServletRequest request, DynaActionForm qform) throws SQLException
   {
	   List genders = lookupManager.LoadCodeList("GEN", true, null, null);
	   LookupCodeValue obj3= new LookupCodeValue();
	   obj3.setCode("");
	   obj3.setDescription("");
	   genders.add(0, obj3);
	   qform.set("genders",genders);

	   request.setAttribute("pageFrom", request.getParameter("pageFrom"));
	   request.setAttribute("var", request.getParameter("var"));
	   request.setAttribute("shortFlag", request.getParameter("shortFlag"));
   }
   
   public void setClientManager(ClientManager clientManager) {
	 this.clientManager = clientManager;
   }

   public void setLookupManager(LookupManager lookupManager) {
	 this.lookupManager = lookupManager;
  }
	public void setIntakeManager(IntakeManager intakeManager) {
		this.intakeManager = intakeManager;
	}
	public IntakeManager getIntakeManager() {
		return this.intakeManager;
	}

}
