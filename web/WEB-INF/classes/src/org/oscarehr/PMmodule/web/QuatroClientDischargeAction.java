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

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.PMmodule.service.AdmissionManager;
import org.oscarehr.PMmodule.service.BedManager;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.service.ProviderManager;
import org.oscarehr.PMmodule.service.RoomDemographicManager;
import org.oscarehr.PMmodule.service.RoomManager;
import org.oscarehr.PMmodule.web.formbean.QuatroClientDischargeForm;
import org.oscarehr.casemgmt.service.CaseManagementManager;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;

public class QuatroClientDischargeAction  extends BaseClientAction {
   private ClientManager clientManager;
   private ProgramManager programManager;
   private AdmissionManager admissionManager;
   private LookupManager lookupManager;
   private IntakeManager intakeManager;
   


   public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
       
       return list(mapping, form, request, response);
   }
   
   public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
       try {
           setEditAttributes(form, request);
	       super.setScreenMode(request, KeyConstants.TAB_CLIENT_DISCHARGE);
	       return mapping.findForward("edit");
       }
       catch(NoAccessException e)
       {
	       return mapping.findForward("failure");
       }
   }
   public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   try {
		   QuatroClientDischargeForm clientForm = (QuatroClientDischargeForm) form;
		   Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
	       String providerNo = (String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
		   ActionMessages messages = new ActionMessages();
		   boolean isError = false;
		   boolean isWarning = false;
		   Admission admObj =(Admission)clientForm.getAdmission();
		   admObj.setAdmissionStatus(KeyConstants.INTAKE_STATUS_DISCHARGED);
		   admObj.setDischargeDate(Calendar.getInstance());
		   admObj.setLastUpdateDate(new GregorianCalendar());
		   admObj.setProviderNo(providerNo);
		   super.getAccess(request, KeyConstants.FUN_CLIENTDISCHARGE, admObj.getProgramId(), KeyConstants.ACCESS_WRITE);
		   List lstFamily = intakeManager.getClientFamilyByIntakeId(admObj.getIntakeId());
		   boolean isReferral=false;
		   admissionManager.dischargeAdmission(admObj, isReferral, lstFamily);
	/*	   
		   if(lstFamily!=null){
			   admissionManager.updateDischargeInfo(admObj, isReferral);
			   Iterator item = lstFamily.iterator();
				while(item.hasNext()){
					QuatroIntakeFamily qifTmp = (QuatroIntakeFamily)item.next();
					Admission admLoc =admissionManager.getAdmissionByIntakeId(qifTmp.getIntakeId());
					if(admLoc.getId().intValue()!=admObj.getId().intValue()){ 
						admLoc.setAdmissionStatus(KeyConstants.INTAKE_STATUS_DISCHARGED);
						admLoc.setDischargeDate(Calendar.getInstance());
					  	admLoc.setDischargeNotes(admObj.getDischargeNotes());	
						admLoc.setCommunityProgramCode(admObj.getCommunityProgramCode());
					  	admissionManager.updateDischargeInfo(admLoc, false);
					}
				}
				
		   }else{
			   admissionManager.updateDischargeInfo(admObj, isReferral);		  
		   }
	*/
		   
	       super.setScreenMode(request, KeyConstants.TAB_CLIENT_DISCHARGE);	
		   
		   if(!(isWarning || isError)) messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("message.save.success", request.getContextPath()));
	       saveMessages(request,messages);
	       
	       /* discharge */      
	      
	       List lstCommProgram =lookupManager.LoadCodeList("IDS", true, null, null);
	       request.setAttribute("lstCommProgram", lstCommProgram);
	       List lstDischargeReason =lookupManager.LoadCodeList("DRN", true, null, null);
	       request.setAttribute("lstDischargeReason", lstDischargeReason);
	       List lstTransType =lookupManager.LoadCodeList("TPT", true, null, null);
	       request.setAttribute("lstTransType", lstTransType);     
	       List  lstBed=programManager.getBedPrograms(providerNo, shelterId);
	       request.setAttribute("lstBedProgram",lstBed);
	       request.setAttribute("admission", admObj);
	       request.setAttribute("admissionId", admObj.getId());
	       super.cacheClient(request, admObj.getClientId());
		   super.setCurrentIntakeProgramId(request, admObj.getClientId(), shelterId, providerNo);
	       
	       return mapping.findForward("edit");
	   }
       catch(NoAccessException e)
       {
	       return mapping.findForward("failure");
       }
   }
   public ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   try {
	       setListAttributes(form, request);
	       super.setScreenMode(request, KeyConstants.TAB_CLIENT_DISCHARGE);
	       return mapping.findForward("list");
	   }
       catch(NoAccessException e)
       {
	       return mapping.findForward("failure");
       }
   }
   private void setEditAttributes(ActionForm form, HttpServletRequest request) throws NoAccessException {
	   QuatroClientDischargeForm clientForm = (QuatroClientDischargeForm) form;

       Integer aId = new Integer(request.getParameter("admissionId"));
       
       Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
       String providerNo=(String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
       Admission admsObj =admissionManager.getAdmission(aId);
       if(!admsObj.getAdmissionStatus().equals(KeyConstants.STATUS_DISCHARGED))
    	   super.getAccess(request, KeyConstants.FUN_CLIENTDISCHARGE, admsObj.getProgramId(),KeyConstants.ACCESS_WRITE);
       
       clientForm.setAdmission(admsObj);       

       boolean readOnly=super.isReadOnly(request,admsObj.getAdmissionStatus(), KeyConstants.FUN_CLIENTDISCHARGE,admsObj.getProgramId());
       if(readOnly) request.setAttribute("isReadOnly", Boolean.valueOf(readOnly));

       /* discharge */
       List lstCommProgram =lookupManager.LoadCodeList("IDS", !readOnly, null, null);
       request.setAttribute("lstCommProgram", lstCommProgram);
       List lstDischargeReason =lookupManager.LoadCodeList("DRN", !readOnly, null, null);
       request.setAttribute("lstDischargeReason", lstDischargeReason);
       List lstTransType =lookupManager.LoadCodeList("TPT", !readOnly, null, null);
       request.setAttribute("lstTransType", lstTransType);     
       List  lstBed=programManager.getBedPrograms(providerNo,shelterId);
       request.setAttribute("lstBedProgram",lstBed);
       request.setAttribute("admission", admsObj);
       request.setAttribute("admissionId", admsObj.getId());

       
   }

   private void setListAttributes(ActionForm form, HttpServletRequest request) {
	   QuatroClientDischargeForm clientForm = (QuatroClientDischargeForm) form;
       
       Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
       
       String providerNo = (String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
           
       List lstDischarge = admissionManager.getAdmissions(super.getClientId(request), providerNo,shelterId);
       request.setAttribute("quatroDischarge", lstDischarge);
       for(int i=0;i<lstDischarge.size();i++){
    	 Admission admission = (Admission)lstDischarge.get(i);
	     admission.setFamilyMember(false);	 
    	 if(admission.getAdmissionStatus().equals(KeyConstants.INTAKE_STATUS_ADMITTED)){
    	   Integer intakeFamilyHeadId = intakeManager.getIntakeFamilyHeadId(admission.getIntakeId());
    	   if(intakeFamilyHeadId.intValue()!=0){  //family
    		 if(!intakeFamilyHeadId.equals(admission.getIntakeId())) admission.setFamilyMember(true);
    	   }
    	 }
       }
   }
   
   public void setIntakeManager(IntakeManager intakeManager){
	   this.intakeManager =intakeManager;
   }
	public IntakeManager getIntakeManager() {
		return this.intakeManager;
	}
   public void setAdmissionManager(AdmissionManager admissionManager) {
	 this.admissionManager = admissionManager;
   }


   public void setClientManager(ClientManager clientManager) {
	 this.clientManager = clientManager;
   }

   public void setProgramManager(ProgramManager programManager) {
	 this.programManager = programManager;
   }

   public void setLookupManager(LookupManager lookupManager) {
	 this.lookupManager = lookupManager;
   }

   
}
