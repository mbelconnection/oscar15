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

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.ProgramClientRestriction;
import org.oscarehr.PMmodule.model.QuatroIntake;
import org.oscarehr.PMmodule.model.QuatroIntakeDB;
import org.oscarehr.PMmodule.model.QuatroIntakeFamily;
import org.oscarehr.PMmodule.model.Room;
import org.oscarehr.PMmodule.model.RoomDemographic;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ClientRestrictionManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.service.RoomDemographicManager;
import org.oscarehr.PMmodule.service.RoomManager;
import org.oscarehr.PMmodule.web.formbean.ClientSearchFormBean;
import org.oscarehr.PMmodule.web.formbean.QuatroClientFamilyIntakeForm;

import oscar.MyDateFormat;

import com.quatro.common.KeyConstants;
import com.quatro.model.LookupCodeValue;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;
import com.quatro.util.Utility;

public class QuatroFamilyIntakeAction extends BaseClientAction {

   private IntakeManager intakeManager;
   private LookupManager lookupManager;
   private ClientManager clientManager;
   private ProgramManager programManager;
   private ClientRestrictionManager clientRestrictionManager;
   private RoomDemographicManager roomDemographicManager;
   private RoomManager roomManager;
   public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
       return edit(mapping, form, request, response);
   }

   private ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
       try {
		   QuatroClientFamilyIntakeForm clientForm = (QuatroClientFamilyIntakeForm)form; 
	       
	       Integer intakeId = Integer.valueOf((String)clientForm.getIntakeId());
	       Integer intakeFamilyHeadId = intakeManager.getIntakeFamilyHeadId(intakeId);
	       if (intakeFamilyHeadId.intValue() == 0) intakeFamilyHeadId = intakeId;
	       request.setAttribute("intakeHeadId", intakeFamilyHeadId);
	       
	       QuatroIntakeDB headIntakeDB = intakeManager.getQuatroIntakeDBByIntakeId(intakeFamilyHeadId);
	       request.setAttribute("programId",headIntakeDB.getProgramId());
	       String intakeStatus = headIntakeDB.getIntakeStatus();
	       clientForm.setIntakeStatus(intakeStatus);
	       
	       HashMap actionParam = (HashMap) request.getAttribute("actionParam");
	       if(actionParam==null){
	    	  actionParam = new HashMap();
	          actionParam.put("intakeId", request.getParameter("intakeId")); 
	       }
	       request.setAttribute("actionParam", actionParam);
	       request.setAttribute("intakeId",request.getParameter("intakeId"));
	       
	       Integer programId = headIntakeDB.getProgramId();
	       request.setAttribute("programId", programId);
	       
	       boolean readOnly=super.isReadOnly(request,headIntakeDB.getIntakeStatus(), KeyConstants.FUN_CLIENTINTAKE,programId);
	   	   if (!readOnly)
	   	   {
	         if(!(intakeFamilyHeadId.equals(intakeId))) readOnly = true;
	   	   }
	   	   request.setAttribute("isReadOnly", Boolean.valueOf(readOnly));
	
	   	   List genders = lookupManager.LoadCodeList("GEN",true, null, null);
	       
	       LookupCodeValue obj2= new LookupCodeValue();
	       obj2.setCode("");
	       obj2.setDescription("");
	       genders.add(0,obj2);
	       clientForm.setGenders(genders);
	
	       List relationships = lookupManager.LoadCodeList("FRA",true, null, null);
	       relationships.add(0,obj2);
	       clientForm.setRelationships(relationships);
	       
	       Integer demographicNo = headIntakeDB.getClientId();
	       request.setAttribute("headclientId", demographicNo.toString());
		   Demographic familyHead = intakeManager.getClientByDemographicNo(demographicNo);
		   for(int i=0;i<genders.size();i++){
	           LookupCodeValue obj= (LookupCodeValue)genders.get(i);
	           if(obj.getCode().equals(familyHead.getSex())){
	        	 familyHead.setSexDesc(obj.getDescription());
			     break;
	           }  
		   }
		   
	       List dependent = intakeManager.getClientFamilyByIntakeId(intakeId);
	       if(dependent==null) dependent = new ArrayList(); 
	       for(int i=0;i<dependent.size();i++){
	     	  QuatroIntakeFamily obj= (QuatroIntakeFamily)dependent.get(i);
	     	  obj.setNewClientChecked("N");
	     	  obj.setDuplicateClient("N");
	     	  obj.setServiceRestriction("N");
	     	  obj.setStatusMsg("#");
	       }
	       boolean isFamilyAdmitted = intakeStatus.equals(KeyConstants.INTAKE_STATUS_ADMITTED);
 		   request.setAttribute("isFamilyAdmitted", new Boolean(isFamilyAdmitted));
	       Integer admId = null;
	       int familySize = dependent.size();
	       for(int i=0;i<dependent.size();i++){
	    	  QuatroIntakeFamily obj= (QuatroIntakeFamily)dependent.get(i);
	    	  if(obj.getIntakeHeadId().equals(obj.getIntakeId())){
	    		  admId = obj.getAdmissionId();
	    		  dependent.remove(obj);
	    		  break;
	    	  }
	       }
	       if (isFamilyAdmitted) 
	       {
	    	   RoomDemographic roomDemographic = roomDemographicManager.getRoomDemographicByAdmissionId(admId);
	    	   Room rm = roomManager.getRoom(roomDemographic.getId().getRoomId());
	    	   request.setAttribute("roomCapacity", rm.getCapacity());
	    	   request.setAttribute("isRoomFull", Boolean.valueOf(familySize >= rm.getCapacity().intValue()));
	       }
	       
	       clientForm.setFamilyHead(familyHead);
	       clientForm.setDob(MyDateFormat.getStandardDate(familyHead.getDateOfBirth()));
	       clientForm.setDependents(dependent);
	       clientForm.setDependentsSize(dependent.size());
	       
	       super.setScreenMode(request, KeyConstants.TAB_CLIENT_INTAKE);
	       return mapping.findForward("edit");
       }
       catch(NoAccessException e)
       {
	       return mapping.findForward("failure");
       }

   }

   public ActionForward history(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   request.setAttribute("notoken", "Y");
	   try {
		   QuatroClientFamilyIntakeForm clientForm = (QuatroClientFamilyIntakeForm)form; 
	
	       Integer intakeFamilyHeadId = Integer.valueOf(request.getParameter("intakeHeadId"));
	       Integer programId = Integer.valueOf(request.getParameter("programId"));
	       super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, programId, KeyConstants.ACCESS_READ);
       
	       List dependents = intakeManager.getClientIntakeFamilyHistory(intakeFamilyHeadId);
	       request.setAttribute("dependents",dependents);
	       
	       super.setScreenMode(request, KeyConstants.TAB_CLIENT_INTAKE);
	       return mapping.findForward("history");
       }
       catch(NoAccessException e)
       {
	       return mapping.findForward("failure");
       }
   }
   
   
   public ActionForward add(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
       try { 
		   QuatroClientFamilyIntakeForm clientForm = (QuatroClientFamilyIntakeForm)form; 
	    	setEditFields(request, clientForm);
	       
	    	List dependents = buildDependentList(request, clientForm);
	        QuatroIntakeFamily obj2 = new QuatroIntakeFamily();
	        obj2.setClientId(new Integer(0));
	        Integer programId = Integer.valueOf(request.getParameter("programId"));
		 	super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, programId, KeyConstants.ACCESS_WRITE);
			obj2.setIntakeHeadId(Integer.valueOf(request.getParameter("intakeHeadId")));
	        obj2.setIntakeId(new Integer(0));
	        obj2.setAdmissionId(null);
	        String currentDateTxt = MyDateFormat.getStandardDateTime(Calendar.getInstance());
	    	obj2.setDuplicateClient("N");  
			obj2.setNewClientChecked("N");
			obj2.setServiceRestriction("N");
			obj2.setStatusMsg("");
			obj2.setEffDate(currentDateTxt);
			obj2.setJoinFamilyDateTxt(currentDateTxt);
	        dependents.add(obj2);
	        clientForm.setDependents(dependents);
	        clientForm.setDependentsSize(dependents.size());
	        request.setAttribute("pageChanged", "1");
	        Boolean isFamilyAdmitted=Boolean.valueOf(request.getParameter("isFamilyAdmitted"));
	       if (isFamilyAdmitted.booleanValue()) 
	       {
	    	   	Integer roomCapacity = Integer.valueOf(request.getParameter("roomCapacity"));
	    	    request.setAttribute("isRoomFull", Boolean.valueOf(dependents.size()+1 >= roomCapacity.intValue()));
	       }

	       return mapping.findForward("edit");
       }
       catch(NoAccessException e)
       {
	       return mapping.findForward("failure");
       }
       
   }

   public ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   try {
		   QuatroClientFamilyIntakeForm clientForm = (QuatroClientFamilyIntakeForm)form; 
	       setEditFields(request, clientForm);
	       Integer programId = Integer.valueOf(request.getParameter("programId"));
	       super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, programId, KeyConstants.ACCESS_WRITE);
	       List dependents = buildDependentList(request, clientForm);
	
	       clientForm.setDependents(dependents);
	       clientForm.setDependentsSize(dependents.size());
	       request.setAttribute("pageChanged", "1");
	       Boolean isFamilyAdmitted=Boolean.valueOf(request.getParameter("isFamilyAdmitted"));
	       if (isFamilyAdmitted.booleanValue()) 
	       {
	    	   	Integer roomCapacity = Integer.valueOf(request.getParameter("roomCapacity"));
	    	   	request.setAttribute("isRoomFull", Boolean.valueOf(dependents.size()+1 >= roomCapacity.intValue()));
	       }
	       return mapping.findForward("edit");
       }
       catch(NoAccessException e)
       {
	       return mapping.findForward("failure");
       }
}

   public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
       ActionMessages messages = new ActionMessages();
       boolean isError = false;
       boolean isWarning = false;
       try {
    	   /*get page parameters */
    	   
	       QuatroClientFamilyIntakeForm clientForm = (QuatroClientFamilyIntakeForm)form; 
	       setEditFields(request, clientForm);
	
	       Integer intakeId = Integer.valueOf((String)clientForm.getIntakeId());
	       Integer headIntakeId = intakeId;    // only the family head have Save functionality
	       Integer headClientId = clientForm.getFamilyHead().getDemographicNo();

	       Integer programId = Integer.valueOf(request.getParameter("programId"));
	       super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, programId, KeyConstants.ACCESS_WRITE);
	       
		   String newClientConfirmed= request.getParameter("newClientConfirmed");
		   boolean bDupliDemographicNoApproved=true;
	       List dependents = buildDependentList(request, clientForm);       
	       boolean familyAdmitted = Boolean.valueOf(request.getParameter("isFamilyAdmitted")).booleanValue();
	       bDupliDemographicNoApproved = checkDuplicateDemographicNo(dependents,newClientConfirmed, headClientId, headIntakeId,programId,familyAdmitted);	       
	       if(!bDupliDemographicNoApproved){
			 messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.family.duplicated_client",
	          			request.getContextPath()));
		     saveMessages(request,messages);
	         isError = true;
	         clientForm.setDependents(dependents);
	         clientForm.setDependentsSize(dependents.size());
	         request.setAttribute("bDupliDemographicNoApproved", "false");
	         return mapping.findForward("edit");
	       }else{
	         request.setAttribute("bDupliDemographicNoApproved", "true");
	       }
	       
	       //check if family members existing in other families.
	       //if(KeyConstants.INTAKE_STATUS_ACTIVE.equals(clientForm.getIntakeStatus())){
	  	     //intakeFamily is null before a family created
	       /*
	    	 List intakeFamily = intakeManager.getClientFamilyByIntakeId(headIntakeId);
	         for(int i=0;i<dependents.size();i++){
	           QuatroIntakeFamily obj3 = (QuatroIntakeFamily)dependents.get(i);
	           int j=-1;
	           if(intakeFamily!=null){
	             for(j=0;j<intakeFamily.size();j++){
	               //obj5: current family member in DB
	        	   QuatroIntakeFamily obj5 = (QuatroIntakeFamily)intakeFamily.get(j);
	               if(obj3.getClientId().equals(obj5.getClientId())) break;
	             }
	           }
	         
	           //new added dependent (existing client)
	           if(intakeFamily==null || (j==intakeFamily.size() && obj3.getClientId().intValue()>0)){
	             //only check intake_status=active/admitted
	             List activeIntakeIds = intakeManager.getActiveIntakeIds(obj3.getClientId());
	             for(j=0;j<activeIntakeIds.size();j++){
	               Integer intakeHeadId_exist =intakeManager.getIntakeFamilyHeadId(((Integer)activeIntakeIds.get(j)));
	               if(intakeHeadId_exist.intValue()>0 && !intakeHeadId_exist.equals(headIntakeId)){
	          		  messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("warning.intake.family.existing_in_other_family",
	               			request.getContextPath(), obj3.getLastName() + ", " + obj3.getFirstName()));
	                  isWarning = true;
	                  break; //only show error once
	               }
	             }
	           }
	         //}
	         if(isError){
		       saveMessages(request,messages);
	           clientForm.setDependents(dependents);
	           clientForm.setDependentsSize(dependents.size());
	           return mapping.findForward("edit");
	         }
	       }       
	       */
	       String providerNo = (String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
	 	   QuatroIntake headIntake = intakeManager.getQuatroIntake(headIntakeId);
		   Program program = programManager.getProgram(headIntake.getProgramId());
		   StringBuffer sb = new StringBuffer();
	       for(int i=0;i<dependents.size();i++){
	         QuatroIntakeFamily obj3 = (QuatroIntakeFamily)dependents.get(i);
	
	   		 //check gender conflict and age conflict
	         Demographic client;
	         if(obj3.getClientId().intValue()==0){
	           client = new Demographic();
	         }else{
	           sb.append("," + obj3.getIntakeId().toString());
	           client = intakeManager.getClientByDemographicNo(obj3.getClientId());
	         }
		     if (obj3.getAdmissionId() == null) {
		         client.setDateOfBirth(MyDateFormat.getCalendar(obj3.getDob()));
		         client.setSex(obj3.getSex());
				 if(clientRestrictionManager.checkGenderConflict(program, client)){
		         	 messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("warning.intake.gender_conflict_dep", request.getContextPath(), obj3.getLastName() + ", " + obj3.getFirstName(),headIntake.getProgramName()));
		             isWarning = true;
				 }
				 if(clientRestrictionManager.checkAgeConflict(program, client)){
		         	  messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("warning.intake.age_conflict_dep", request.getContextPath(), obj3.getLastName() + ", " + obj3.getFirstName(),headIntake.getProgramName()));
		             isWarning = true;
				 }
		    	   
		  	     //check service restriction
		    	 obj3.setServiceRestriction("N");
		         if(obj3.getClientId().intValue()>0){
		           ProgramClientRestriction restrInPlace = clientRestrictionManager.checkClientRestriction(
		        		 headIntake.getProgramId(), obj3.getClientId(), new Date());
		           if (restrInPlace != null) {
		     	     obj3.setServiceRestriction("Y");
		        	 messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("warning.intake.service_restriction_dep",
		             			request.getContextPath(),  obj3.getLastName() + ", " + obj3.getFirstName(),headIntake.getProgramName()));
		       		 isWarning = true;
		           }
		         }
	         }
	       }
	       
	       QuatroIntakeFamily intakeFamilyHead = new QuatroIntakeFamily();
	       intakeFamilyHead.setIntakeHeadId(headIntake.getId());
	       intakeFamilyHead.setIntakeId(headIntake.getId());
	       intakeFamilyHead.setMemberStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
	       intakeFamilyHead.setRelationship(KeyConstants.FAMILY_HEAD_CODE);
	       intakeFamilyHead.setJoinFamilyDate(headIntake.getCreatedOn());
	       intakeFamilyHead.setLastUpdateUser(providerNo);
	       intakeFamilyHead.setLastUpdateDate(new GregorianCalendar());
	       intakeManager.saveQuatroIntakeFamilyHead(intakeFamilyHead);
	
	       //delete removed family memeber from family intake.
	       if(sb.length()>0){
	         intakeManager.removeInactiveIntakeFamilyMember(sb.substring(1), headIntake.getId());
	       }else{
	         intakeManager.removeInactiveIntakeFamilyMember("", headIntake.getId());
	       }
	       for(int i=0;i<dependents.size();i++){
	           QuatroIntakeFamily intakeFamilyCurr = (QuatroIntakeFamily)dependents.get(i);
	           if (intakeFamilyCurr.getAdmissionId() == null) {
			       	 Demographic client = new Demographic();
			         client.setDemographicNo(intakeFamilyCurr.getClientId());
			         client.setLastName(intakeFamilyCurr.getLastName());
			         client.setFirstName(intakeFamilyCurr.getFirstName());
			
					 client.setDateOfBirth(MyDateFormat.getCalendar(intakeFamilyCurr.getDob()));
			         
			         client.setSex(intakeFamilyCurr.getSex());
			         client.setAlias(intakeFamilyCurr.getAlias());
			         client.setProviderNo(providerNo);
			         client.setLastUpdateDate(new GregorianCalendar());
			         client.setEffDate(MyDateFormat.getCalendar(intakeFamilyCurr.getEffDate()).getTime());
			         
			     	 //check if this client has any existing active intake with same program before create new intake
			         QuatroIntakeDB newClient_intakeDBExist = null;
			     	 if(intakeFamilyCurr.getIntakeId().intValue()==0){
			     		newClient_intakeDBExist = intakeManager.findActiveQuatroIntakeDB(intakeFamilyCurr.getClientId(), headIntake.getProgramId());
			      	    if(newClient_intakeDBExist!=null) {
			      	    	List f = intakeManager.getClientFamilyByIntakeId(newClient_intakeDBExist.getId());
			      	    	if (f == null || f.size() == 0)
			      	    		intakeFamilyCurr.setIntakeId(newClient_intakeDBExist.getId());
			      	    }
			     	 }
			  		 
			  		 QuatroIntake intake = new QuatroIntake();
			     	 intake.setClientId(client.getDemographicNo());
			     	 intake.setId(intakeFamilyCurr.getIntakeId());
			     	 intake.setProgramId(headIntake.getProgramId());
			     	 //copy head intake to new client intake
			    
			     	 if(intake.getId().intValue()==0){
			     	 //  intake.setStaffId(providerNo);
			     	   intake.setCreatedOn(Calendar.getInstance());
					    if(familyAdmitted) {
					    	intake.setIntakeStatus(KeyConstants.INTAKE_STATUS_ADMITTED);
					    }
					    else
					    {
					    	intake.setIntakeStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
					    }
			       	   intake.setReferredBy(headIntake.getReferredBy());
			       	   intake.setContactName(headIntake.getContactName());
			       	   intake.setContactNumber(headIntake.getContactNumber());
			       	   intake.setContactEmail(headIntake.getContactEmail());
			
			       	   intake.setLanguage(headIntake.getLanguage());
			       	   intake.setAboriginal(headIntake.getAboriginal());
			       	   intake.setAboriginalOther(headIntake.getAboriginalOther());
			       	   intake.setVAW(headIntake.getVAW());
			       	   intake.setCurSleepArrangement(headIntake.getCurSleepArrangement());
			       	   intake.setLivedBefore(headIntake.getLivedBefore());
			       	   intake.setOriginalCountry(headIntake.getOriginalCountry());
			     	 }else{
			           intake.setIntakeStatus(headIntake.getIntakeStatus());
			     	 }
			     	 intake.setStaffId(providerNo);
			     	 intake.setLastUpdateDate(new GregorianCalendar());
			
			     	 intakeFamilyCurr.setJoinFamilyDate(MyDateFormat.getCalendarwithTime(intakeFamilyCurr.getJoinFamilyDateTxt()));
					 intakeFamilyCurr.setMemberStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
			     	 intakeFamilyCurr.setIntakeHeadId(headIntake.getId());
			     	 intakeFamilyCurr.setLastUpdateUser(providerNo);
			     	 intakeFamilyCurr.setLastUpdateDate(new GregorianCalendar());
			     	 ArrayList lst2 = intakeManager.saveQuatroIntakeFamily(familyAdmitted, client, headIntakeId, intake, newClient_intakeDBExist, intakeFamilyCurr);
			     	 intakeFamilyCurr.setIntakeId((Integer)lst2.get(1));
			     	 intakeFamilyCurr.setClientId((Integer)lst2.get(2));
	           }
	  	   }
	   
	  	   if(!(isWarning || isError)){
	  		  messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("message.save.success", request.getContextPath()));
		   }else if(isWarning){
			  messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("warning.intake.saved_with_warning"));
		   }
	       saveMessages(request,messages);
		   
	       //in case added same client in multiple family member lines,
	       //the save method saved family member correctly, 
	       //but need to remove duplicated family member line(s) by reading every family memeber from DB again.  
	       request.setAttribute("intakeHeadId", headIntakeId);
	
	       List dependentsDB = intakeManager.getClientFamilyByIntakeId(headIntakeId);
	       if(dependentsDB==null) dependentsDB = new ArrayList(); 
	       for(int i=0;i<dependentsDB.size();i++){
	     	  QuatroIntakeFamily obj= (QuatroIntakeFamily)dependentsDB.get(i);
	     	  obj.setNewClientChecked("N");
	     	  obj.setDuplicateClient("N");
	     	  obj.setServiceRestriction("N");
	     	  obj.setStatusMsg("#");
	       }
	       for(int i=0;i<dependentsDB.size();i++){
	    	  QuatroIntakeFamily obj= (QuatroIntakeFamily)dependentsDB.get(i);
	    	  if(obj.getIntakeHeadId().equals(obj.getIntakeId())){
	    		  dependentsDB.remove(obj);
	    		 break;
	    	  }
	       }
	       clientForm.setDependents(dependentsDB);
	       clientForm.setDependentsSize(dependentsDB.size());
	       request.setAttribute("pageChanged", "");
	       return mapping.findForward("edit");
       }
       catch(NoAccessException e)
       {
	       return mapping.findForward("failure");
       }
   }
   private List buildDependentList(HttpServletRequest request, QuatroClientFamilyIntakeForm clientForm)
   {
	   ArrayList dependents = new ArrayList();
	   int dependentsSize=clientForm.getDependentsSize();
	   StringBuffer sb = new StringBuffer();
	   String newClientConfirmed= request.getParameter("newClientConfirmed");
	   
       for(int i=0;i<dependentsSize;i++){
 	      if(!("delete".equals(request.getParameter("method")) && request.getParameter("dependent[" + i +"].select")!=null)){
	 		  QuatroIntakeFamily obj = new QuatroIntakeFamily();	
	 		  obj.setClientId(Integer.valueOf(request.getParameter("dependent[" + i +"].clientId")));
	 		  obj.setIntakeHeadId(Integer.valueOf(request.getParameter("intakeHeadId")));
	          obj.setIntakeId(Integer.valueOf(request.getParameter("dependent[" + i +"].intakeId")));
	          String admissionId = request.getParameter("dependent[" + i +"].admissionId");
	          if(!Utility.IsEmpty(admissionId)) {
	        	  obj.setAdmissionId(Integer.valueOf(admissionId));
 	      	  }
	          if(obj.getIntakeId().intValue()>0){
	 			 sb.append("," + obj.getIntakeId().toString());
	 		  }
	          obj.setLastName(request.getParameter("dependent[" + i +"].lastName"));
	 		  obj.setFirstName(request.getParameter("dependent[" + i +"].firstName"));
	 		  obj.setDob(request.getParameter("dependent[" + i +"].dob"));
	 		  obj.setSex(request.getParameter("dependent[" + i +"].sex"));
	 		  obj.setAlias(request.getParameter("dependent[" + i +"].alias"));
	 		  obj.setRelationship(request.getParameter("dependent[" + i +"].relationship"));
	 		  obj.setIntakeId(Integer.valueOf(request.getParameter("dependent[" + i +"].intakeId")));
	 		  obj.setSelect(request.getParameter("dependent[" + i +"].select"));
	 		  obj.setNewClientChecked(request.getParameter("dependent[" + i +"].newClientChecked"));
	 		  if(newClientConfirmed==null || newClientConfirmed.equals("N")){
	 			  obj.setDuplicateClient(request.getParameter("dependent[" + i +"].duplicateClient"));
	 		  }else{
	 			  obj.setDuplicateClient("N");
	 		  }
	 		  obj.setServiceRestriction("N");  //don't check service restriction until no duplicate client.
	 		  obj.setEffDate(request.getParameter("dependent[" + i +"].effDate"));
	 		  obj.setJoinFamilyDateTxt(request.getParameter("dependent[" + i +"].joinFamilyDateTxt"));
	
	 		  if(obj.getClientId().intValue()>0){
	 			obj.setStatusMsg("#");
	 		  }else{
	 			obj.setStatusMsg("");
	 		  }
	 	      dependents.add(obj);
 	      }
 	   }
       return dependents;
   }
   private boolean checkDuplicateDemographicNo(List dependents,String newClientConfirmed, Integer headClientId, Integer headIntakeId, Integer programId, boolean familyAdmitted)
   {
	   //check duplicate client for intakeId==0 && clientId==0 
	   boolean bDupliDemographicNoApproved = true;
	   Hashtable hs = new Hashtable(); 
	   for(int i=0; i<dependents.size(); i++) {
	 		QuatroIntakeFamily obj = (QuatroIntakeFamily) dependents.get(i);	
	 		if(obj.getClientId().intValue()==0){
	 			if(newClientConfirmed == null || newClientConfirmed.equals("N")){
			       ClientSearchFormBean criteria = new ClientSearchFormBean();
		           criteria.setLastName(obj.getLastName());
		           criteria.setFirstName(obj.getFirstName());
		           // criteria.setDob(obj.getDob());
		           criteria.setGender(obj.getSex());
			       List lst = clientManager.search(criteria, false,true);
		           if(lst.size()>0){
		             obj.setDuplicateClient("Y");
			         obj.setNewClientChecked("N");
					 obj.setStatusMsg("?");
		             bDupliDemographicNoApproved=false;
		           }else{
			         obj.setDuplicateClient("N");
			         obj.setNewClientChecked("Y");
			         obj.setStatusMsg("");
		           }
	 			}
	 		}
	 		else
	 		{
	 			if(obj.getClientId().intValue() == headClientId.intValue() || hs.containsKey(obj.getClientId().toString()))
	 			{
	 				obj.setDuplicateClient("Y");
	 				obj.setNewClientChecked("N");
	 				if (!hs.containsKey(obj.getClientId().toString()))
	 					obj.setStatusMsg("x");
	 				else
	 					obj.setStatusMsg("*");
		            bDupliDemographicNoApproved=false;
	 			}
	 			else
	 			{
	 				hs.put(obj.getClientId().toString(), obj.getClientId());
	 			}
	 			//if no duplicates, checking of the member is a member somewhere else
	 			if (bDupliDemographicNoApproved) {
	 				List intakeIds = intakeManager.getActiveIntakeIds(obj.getClientId());
		      	    if(intakeIds!=null && intakeIds.size() > 0) {
		      	    	for(int k=0; k<intakeIds.size(); k++)
		      	    	{
		      	    		QuatroIntakeFamily f = intakeManager.getIntakeFamilyRecord((Integer)intakeIds.get(k));
		      	    		if (f != null && !f.getIntakeHeadId().equals(headIntakeId)) {
		      	    			if (f.getAdmissionId() != null && f.getAdmissionId().intValue() > 0) {
		      	    				if (familyAdmitted)
		      	    				{
		      	    					obj.setStatusMsg("+");   // + admiited in another family, error because cannot do auto discharge
				      	    			bDupliDemographicNoApproved = false;
		      	    				}
		      	    				else if (f.getProgramId().equals(programId))
		      	    				{
		      	    					obj.setStatusMsg("-");   // - active in the same program 
				      	    			bDupliDemographicNoApproved = false;
		      	    				}
		      	    			}
		      	    			else
		      	    			{
		      	    				if (f.getProgramId().equals(programId)) {
				      	    			bDupliDemographicNoApproved = false;
				      	    			obj.setStatusMsg("-");  // intaked into another family in the same program
				      	    			bDupliDemographicNoApproved = false;
		      	    				}
		      	    			}
		      	    			
		      	    		}
		      	    	}
		      	    }
	 			}
	 			
	 		}
	   	}
	   return bDupliDemographicNoApproved;
   	}
   
   private void setEditFields(HttpServletRequest request, QuatroClientFamilyIntakeForm clientForm) throws NoAccessException
   {
       Integer intakeId = Integer.valueOf((String)clientForm.getIntakeId());
       Integer intakeFamilyHeadId = intakeManager.getIntakeFamilyHeadId(intakeId);
       request.setAttribute("intakeHeadId", intakeFamilyHeadId);

       HashMap actionParam = (HashMap) request.getAttribute("actionParam");
       if(actionParam==null){ 
    	  actionParam = new HashMap();
          actionParam.put("headclientId", request.getParameter("headclientId")); 
          actionParam.put("intakeId", request.getParameter("intakeId"));
          actionParam.put("programId", request.getParameter("programId"));
       }
       request.setAttribute("actionParam", actionParam);
       request.setAttribute("intakeId", intakeId);
       String demographicNo= (String)actionParam.get("headclientId");
       request.setAttribute("headclientId", demographicNo);
       request.setAttribute("programId", (String)actionParam.get("programId"));
       
   	   boolean readOnly=false;
   	   request.setAttribute("isReadOnly", request.getParameter("isReadOnly"));
   	   request.setAttribute("isFamilyAdmitted", request.getParameter("isFamilyAdmitted"));
	   request.setAttribute("roomCapacity", request.getParameter("roomCapacity")); 
	   request.setAttribute("isRoomFull", request.getParameter("isRoomFull"));
   	   
       List genders = lookupManager.LoadCodeList("GEN",true, null, null);
       LookupCodeValue obj2= new LookupCodeValue();
       obj2.setCode("");
       obj2.setDescription("");
       genders.add(0,obj2);
       clientForm.setGenders(genders);

       List relationships = lookupManager.LoadCodeList("FRA",true, null, null);
       relationships.add(0,obj2);
       clientForm.setRelationships(relationships);
       
	   Demographic familyHead = clientForm.getFamilyHead();
	   for(int i=0;i<genders.size();i++){
           LookupCodeValue obj= (LookupCodeValue)genders.get(i);
           if(obj.getCode().equals(familyHead.getSex())){
        	 familyHead.setSexDesc(obj.getDescription());
		     break;
           }  
	   }
       clientForm.setFamilyHead(familyHead);
       
       super.setScreenMode(request, KeyConstants.TAB_CLIENT_INTAKE);
   }
	public void setIntakeManager(IntakeManager intakeManager) {
		this.intakeManager = intakeManager;
	}
	public IntakeManager getIntakeManager() {
		return this.intakeManager;
	}

   public void setLookupManager(LookupManager lookupManager) {
	 this.lookupManager = lookupManager;
   }

   public void setClientManager(ClientManager clientManager) {
	 this.clientManager = clientManager;
   }

   public void setClientRestrictionManager(ClientRestrictionManager clientRestrictionManager) {
	 this.clientRestrictionManager = clientRestrictionManager;
   }

   public void setProgramManager(ProgramManager programManager) {
	 this.programManager = programManager;
   }
   public void setRoomDemographicManager(RoomDemographicManager roomDemographicManager) {
		 this.roomDemographicManager = roomDemographicManager;
   }
   public void setRoomManager(RoomManager roomManager)
   {
	   this.roomManager = roomManager;
   }
}
