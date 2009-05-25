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
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.PMmodule.model.Bed;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.ProgramClientRestriction;
import org.oscarehr.PMmodule.model.Provider;
import org.oscarehr.PMmodule.model.QuatroIntake;
import org.oscarehr.PMmodule.model.QuatroIntakeDB;
import org.oscarehr.PMmodule.model.QuatroIntakeFamily;
import org.oscarehr.PMmodule.model.Room;
import org.oscarehr.PMmodule.model.RoomDemographic;
import org.oscarehr.PMmodule.model.RoomDemographicHistorical;
import org.oscarehr.PMmodule.model.RoomDemographicPK;
import org.oscarehr.PMmodule.service.AdmissionManager;
import org.oscarehr.PMmodule.service.BedManager;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ClientRestrictionManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.service.ProgramQueueManager;
import org.oscarehr.PMmodule.service.ProviderManager;
import org.oscarehr.PMmodule.service.RoomDemographicManager;
import org.oscarehr.PMmodule.service.RoomManager;
import org.oscarehr.PMmodule.web.formbean.QuatroClientAdmissionForm;
import org.oscarehr.casemgmt.service.CaseManagementManager;
import com.quatro.util.Utility;
import oscar.MyDateFormat;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;
import com.quatro.service.TopazManager;
import com.quatro.service.security.SecurityManager;
import com.quatro.util.Utility;

public class QuatroClientAdmissionAction  extends BaseClientAction {
   private TopazManager topazManager;
   private ClientManager clientManager;
   private LookupManager lookupManager;
   private ProgramManager programManager;
   private AdmissionManager admissionManager;
   private RoomDemographicManager roomDemographicManager;
   private RoomManager roomManager;
   private BedManager bedManager;
   private IntakeManager intakeManager;
   private ProviderManager providerManager;
   private ClientRestrictionManager clientRestrictionManager;

   public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
       return list(mapping, form, request, response);
   }

   private ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   try {
	   QuatroClientAdmissionForm clientForm = (QuatroClientAdmissionForm) form;
       super.setScreenMode(request, KeyConstants.TAB_CLIENT_ADMISSION);
       Integer clientId = super.getClientId(request);
       
       Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
       String providerNo = (String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
       List lstAdmission = admissionManager.getAdmissions(clientId,providerNo, shelterId);
       request.setAttribute("admissions", lstAdmission);

       return mapping.findForward("list");
	   }
	   catch(NoAccessException e)
	   {
		   return mapping.findForward("failure");
	   }
   }
   
   //from queue page, new admission 
   public ActionForward queue(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   try {
	   QuatroClientAdmissionForm clientForm = (QuatroClientAdmissionForm) form;

       Integer programId=null;
       Integer intakeId = null;
       
       HashMap actionParam = new HashMap();
       Integer referralId=Integer.valueOf(request.getParameter("referralId"));
       Integer clientId;
       if (request.getParameter("clientId") != null) {
    	   clientId = Integer.valueOf(request.getParameter("clientId"));
    	   super.getClient(request, clientId);
       }
       QuatroIntakeDB intakeDB =  intakeManager.getQuatroIntakeDBByReferralId(referralId);
       intakeId = intakeDB.getId();
       actionParam.put("intakeId", intakeId);
       request.setAttribute("actionParam", actionParam);
       request.setAttribute("programId", intakeDB.getProgramId());
       
       // check user's rights
       super.getAccess(request, KeyConstants.FUN_CLIENTADMISSION,intakeDB.getProgramId(),KeyConstants.ACCESS_WRITE);

       //check if admission existing (do this check to prevent somebody from deleting the signature 
       //by manual input of a url with method=queue.)
       Admission admissionExisting = admissionManager.getAdmissionByIntakeId(intakeId);
       if(admissionExisting==null) topazManager.deleteSignature(intakeId); 

       programId=intakeDB.getProgramId();

       List clientFamily = intakeManager.getClientFamilyByIntakeId(intakeId.toString());
       if(clientFamily.size()<=1){
         clientForm.setFamilyIntakeType("N");
     	 request.setAttribute("isFamilyMember", "N");
         clientForm.setIntakeClientNum(new Integer(1));
       }else{
         clientForm.setFamilyIntakeType("Y");
         Integer IntakeFamilyHeadId = intakeManager.getIntakeFamilyHeadId(intakeId.toString());
         if(IntakeFamilyHeadId==null || IntakeFamilyHeadId.equals(intakeId)){
        	request.setAttribute("isFamilyMember", "N");
         }else{
         	request.setAttribute("isFamilyMember", "Y");
         }
         clientForm.setIntakeClientNum(new Integer(clientFamily.size()));
       }
       clientId = super.getClientId(request);
       Admission admission = new Admission(); 
       admission.setId(new Integer(0));
       admission.setProgramId(programId);
       admission.setProgramName(programManager.getProgramName(programId.toString()));
       admission.setIntakeId(intakeId);
       admission.setClientId(clientId);
       admission.setAdmissionDate(Calendar.getInstance());
       admission.setAdmissionDateTxt(MyDateFormat.getStandardDateTime(admission.getAdmissionDate()));
       admission.setAdmissionStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
       admission.setNextKinProvince("");
       clientForm.setAdmission(admission);

       Room[] availableRooms = roomManager.getAvailableRooms(null, programId, Boolean.TRUE, clientId.toString(), clientForm.getFamilyIntakeType().equals("Y"));
 	   ArrayList availableRoomLst = new ArrayList();
	   Room emptyRoom=new Room();
	   emptyRoom.setId(new Integer(0));
	   emptyRoom.setName(" ---- ");
	   availableRoomLst.add(emptyRoom);
   	   for(int i=0;i<availableRooms.length;i++){
   		availableRoomLst.add(availableRooms[i]);
   	   }
   	   Room[] availableRooms2 =  (Room[]) availableRoomLst.toArray(new Room[availableRoomLst.size()]);
       clientForm.setAvailableRooms(availableRooms2);
       clientForm.setCurDB_RoomId(new Integer(0));

       if(!clientForm.getFamilyIntakeType().equals("Y")){
           Bed[] availableBeds=new Bed[1];
           Bed emptyBed = new Bed();
           emptyBed.setId(new Integer(0));
           emptyBed.setName(" ---- ");
           availableBeds[0]=emptyBed;
           clientForm.setAvailableBeds(availableBeds);
           clientForm.setCurDB_BedId(new Integer(0));
       }
       
	   //set dropdown values
	   List providerList = providerManager.getActiveProviders(programId);
  	   Provider pObj= new Provider();
  	   pObj.setProviderNo("");
  	   providerList.add(0, pObj);
  	   clientForm.setProviderList(providerList);
	   List provinceList = lookupManager.LoadCodeList("POV",true, null, null);
	   clientForm.setProvinceList(provinceList);
	   List notSignReasonList = lookupManager.LoadCodeList("RNS",true, null, null);
       clientForm.setNotSignReasonList(notSignReasonList);
       
       super.setScreenMode(request, KeyConstants.TAB_CLIENT_ADMISSION);
       return mapping.findForward("edit");
	   }
	   catch(NoAccessException e)
	   {
		   return mapping.findForward("failure");
	   }
   }
   
   //from quatroClientAdmission.jsp room change event 
   public ActionForward roomchange(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException {
	   try {
 	   QuatroClientAdmissionForm clientForm = (QuatroClientAdmissionForm) form;

       Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);

       request.setAttribute("isFamilyMember", request.getParameter("isFamilyMember"));
       request.setAttribute("prevDB_RoomId", request.getParameter("prevDB_RoomId"));
       
       HashMap actionParam = new HashMap();
       actionParam.put("clientId", clientForm.getAdmission().getClientId());            
   	   actionParam.put("intakeId", clientForm.getAdmission().getIntakeId());
   	   
       Integer programId=clientForm.getAdmission().getProgramId();
   	   String clientId = clientForm.getAdmission().getClientId().toString();
       request.setAttribute("clientId", clientId);
	   request.setAttribute("client", clientManager.getClientByDemographicNo(clientId));
       request.setAttribute("actionParam", actionParam);

       Admission admission = clientForm.getAdmission();
       request.setAttribute("programId", admission.getProgramId());
       if(admission.getId() != null && admission.getId().intValue()>0)
    	   super.getAccess(request, KeyConstants.FUN_CLIENTADMISSION, admission.getProgramId(),KeyConstants.ACCESS_UPDATE);
       else
    	   super.getAccess(request, KeyConstants.FUN_CLIENTADMISSION, admission.getProgramId(),KeyConstants.ACCESS_WRITE);
    	   
       //setup rooms
       Integer curDB_RoomId = clientForm.getRoomDemographic().getId().getRoomId();
       Integer prevDB_RoomId = null;
       if(!"".equals(request.getParameter("prevDB_RoomId")))
         prevDB_RoomId = Integer.valueOf(request.getParameter("prevDB_RoomId"));  //previous value before dropdown value changed
       clientForm.setCurDB_RoomId(curDB_RoomId);
       Room currentDB_room = null;
       if(curDB_RoomId.intValue()>0) currentDB_room = roomManager.getRoom(curDB_RoomId);

       Room prevDB_room = null;
       if(prevDB_RoomId!=null && prevDB_RoomId.intValue()>0 && !prevDB_RoomId.equals(curDB_RoomId))
    	   prevDB_room = roomManager.getRoom(prevDB_RoomId);
       
       ArrayList availableRoomLst = new ArrayList();
	   Room emptyRoom=new Room();
	   emptyRoom.setId(new Integer(0));
	   emptyRoom.setName(" ---- ");
	   availableRoomLst.add(emptyRoom);

	   if(currentDB_room!=null) availableRoomLst.add(currentDB_room);
       if(prevDB_room!=null) availableRoomLst.add(prevDB_room);
       
       Room[] availableRooms;
       if(admission.getId().intValue()==0){
          //for new admission, family intake admission only takes empty rooms.
    	  availableRooms = roomManager.getAvailableRooms(null, programId, Boolean.TRUE, 
    		           clientId, clientForm.getFamilyIntakeType().equals("Y"));
       }else{
           //for existing admission, can take any rooms.
           availableRooms = roomManager.getAvailableRooms(null, programId, Boolean.TRUE, 
		           clientId, false);
       }
       
       for(int i=0;i<availableRooms.length;i++){
     	   if((currentDB_room!=null && currentDB_room.equals(availableRooms[i])) ||
   			  (prevDB_room!=null && prevDB_room.equals(availableRooms[i]))) continue; 
           availableRoomLst.add(availableRooms[i]);
       }
       Room[] availableRooms2 =  (Room[]) availableRoomLst.toArray(new Room[availableRoomLst.size()]);
       clientForm.setAvailableRooms(availableRooms2);

       //setup beds
       //family intake doesn't need assign beds, just room. 
       if(!clientForm.getFamilyIntakeType().equals("Y") ||
    	(clientForm.getFamilyIntakeType().equals("Y") && admission!=null && admission.getId().intValue()>0)){
         Room newSelectedRoom = roomManager.getRoom(clientForm.getRoomDemographic().getId().getRoomId());        	  
         
         if(newSelectedRoom==null){
      	   Bed emptyBed=new Bed();
    	   emptyBed.setId(new Integer(0));
    	   emptyBed.setName(" ---- ");
           Bed[] availableBeds=new Bed[1];
   	       availableBeds[0] = emptyBed;
           clientForm.setAvailableBeds(availableBeds);
       	 }else if(newSelectedRoom.getAssignedBed().intValue()==1){
           Integer curDB_BedId = clientForm.getCurDB_BedId();
           ArrayList availableBedLst = new ArrayList();
  	       Bed emptyBed=new Bed();
  	       emptyBed.setId(new Integer(0));
  	       emptyBed.setName(" ---- ");
  	       availableBedLst.add(emptyBed);

  	       if(clientForm.getRoomDemographic().getId().getRoomId().intValue()>0){
             Bed currentDB_bed = null;
        	 if(curDB_BedId!=null && curDB_BedId.intValue()>0) currentDB_bed = bedManager.getBed(curDB_BedId);
             if(currentDB_bed!=null && currentDB_bed.getRoomId().equals(curDB_RoomId)) availableBedLst.add(currentDB_bed);

             //add current bed in bed_demographic table to bed dropdown when change room (assignedBed=0) to room (assignBed=1) 
             if(currentDB_bed==null){
               RoomDemographic roomDemographic = roomDemographicManager.getRoomDemographicByAdmissionId(admission.getId());
               if(roomDemographic!=null){
            	 Integer bedId = roomDemographic.getBedId(); 
            	 if(bedId != null && !bedId.equals(curDB_BedId)){
            	   currentDB_bed = bedManager.getBed(roomDemographic.getBedId());
            	   if(currentDB_bed!=null) availableBedLst.add(currentDB_bed);
            	 }
               }
             }
             
             Bed[] availableBeds = bedManager.getAvailableBedsByRoom(clientForm.getRoomDemographic().getId().getRoomId());
             for(int i=0;i<availableBeds.length;i++){
         	   if(currentDB_bed!=null && currentDB_bed.equals(availableBeds[i])) continue; 
               availableBedLst.add(availableBeds[i]);
             }
       	     Bed[] availableBeds2 =  (Bed[]) availableBedLst.toArray(new Bed[availableBedLst.size()]);
             clientForm.setAvailableBeds(availableBeds2);
             if((clientForm.getRoomDemographic().getId().getRoomId()!=null && clientForm.getRoomDemographic().getId().getRoomId().intValue()>0) && availableBeds2.length<2)
        	   request.setAttribute("properRoomMsg", "<font color='#ff0000'>Not available bed(s) in this room, please select other room.</font>");
             
   	       }else{
             Bed[] availableBeds=new Bed[1];
     	     availableBeds[0] = emptyBed;
             clientForm.setAvailableBeds(availableBeds);
             if((clientForm.getRoomDemographic().getId().getRoomId()!=null && clientForm.getRoomDemographic().getId().getRoomId().intValue()>0) && availableBeds.length<2)
               request.setAttribute("properRoomMsg", "<font color='#ff0000'>Not available bed(s) in this room, please select other room.</font>");
           }
      	 }else{
             clientForm.setAvailableBeds(null);
             Integer roomOccupancy = new Integer(roomDemographicManager.getRoomOccupanyByRoom(newSelectedRoom.getId()));
             
        	 if(newSelectedRoom.getCapacity().intValue()-roomOccupancy.intValue()>0){
        		clientForm.setCurDB_RoomCapacity(newSelectedRoom.getCapacity()); 
        	 }else{
         	    request.setAttribute("properRoomMsg", "<font color='#ff0000'>Not available space (Room capacity is " + newSelectedRoom.getCapacity().toString() + "), please select other room.</font>");
        	 }
      	 }
  	     
       //family intake needs check if there are enough beds in the selected room.
       }else{
          if(clientForm.getRoomDemographic().getId().getRoomId()!=null && clientForm.getRoomDemographic().getId().getRoomId().intValue()>0){
            Room newSelectedRoom = roomManager.getRoom(clientForm.getRoomDemographic().getId().getRoomId());        	  
      	    if(newSelectedRoom.getAssignedBed().intValue()==1){
              Bed[] availableBeds = bedManager.getAvailableBedsByRoom(clientForm.getRoomDemographic().getId().getRoomId());
      		  if(availableBeds.length<clientForm.getIntakeClientNum().intValue()) 
      			request.setAttribute("properRoomMsg", "<font color='#ff0000'>Not enough beds (" + String.valueOf(availableBeds.length) + " bed(s) in this room), please select other room.</font>");
            }else{
      		  if(newSelectedRoom.getCapacity().intValue()<clientForm.getIntakeClientNum().intValue()) 
        	    request.setAttribute("properRoomMsg", "<font color='#ff0000'>Not enough available space (Room capacity is " + newSelectedRoom.getCapacity().toString() + "), please select other room.</font>");
            }
          
          }
       }

	   //set dropdown values
	   List providerList = providerManager.getActiveProviders(programId);
  	   Provider pObj= new Provider();
  	   pObj.setProviderNo("");
  	   providerList.add(0, pObj);
  	   clientForm.setProviderList(providerList);
	   List provinceList = lookupManager.LoadCodeList("POV",true, null, null);
	   clientForm.setProvinceList(provinceList);
	   List notSignReasonList = lookupManager.LoadCodeList("RNS",true, null, null);
       clientForm.setNotSignReasonList(notSignReasonList);
       
       super.setScreenMode(request, KeyConstants.TAB_CLIENT_ADMISSION);
       return mapping.findForward("edit");
	   }
	   catch(NoAccessException e)
	   {
		   return mapping.findForward("failure");
	   }
   }
   	
   public ActionForward update(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
	   try {
	   QuatroClientAdmissionForm clientForm = (QuatroClientAdmissionForm) form;
      // super.setScreenMode(request, KeyConstants.TAB_CLIENT_ADMISSION);
	   Integer clientId = super.getClientId(request);
       boolean readOnly= false;
       Integer admissionId;
       Admission admission;
       if(request.getParameter("admissionId")!=null){
          admissionId = Integer.valueOf(request.getParameter("admissionId"));
          admission = admissionManager.getAdmissionByAdmissionId(admissionId);
          admission.setAdmissionDateTxt(MyDateFormat.getStandardDateTime(admission.getAdmissionDate()));
    	  if(admission.getOvPassStartDate()!=null) admission.setOvPassStartDateTxt(MyDateFormat.getStandardDate(admission.getOvPassStartDate()));
    	  if(admission.getOvPassEndDate()!=null) admission.setOvPassEndDateTxt(MyDateFormat.getStandardDate(admission.getOvPassEndDate()));
          clientForm.setAdmission(admission);
       }else{
          admissionId = clientForm.getAdmission().getId();
          admission = clientForm.getAdmission();
       }

       Integer programId = admission.getProgramId();
       HashMap actionParam = (HashMap) request.getAttribute("actionParam");
       if(actionParam==null){
    	  actionParam = new HashMap();          
       }       
   	   actionParam.put("intakeId", admission.getIntakeId());
   	   request.setAttribute("actionParam", actionParam);

       Integer intakeId = admission.getIntakeId();
       String FamilyIntakeType="N";
       clientForm.setFamilyIntakeType("N");

       String isFamilyMember;
       List clientFamily = intakeManager.getClientFamilyByIntakeId(intakeId.toString());
       if(clientFamily.size()<=1){
         clientForm.setFamilyIntakeType("N");
         FamilyIntakeType="N";
         isFamilyMember="N";
//     	 request.setAttribute("isFamilyMember", "N");
         clientForm.setIntakeClientNum(new Integer(1));
       }else{
         clientForm.setFamilyIntakeType("Y");
         FamilyIntakeType="Y";
         Integer IntakeFamilyHeadId = intakeManager.getIntakeFamilyHeadId(intakeId.toString());
         if(IntakeFamilyHeadId==null || IntakeFamilyHeadId.equals(intakeId)){
            isFamilyMember="N";
//        	request.setAttribute("isFamilyMember", "N");
         }else{
            isFamilyMember="Y";
//         	request.setAttribute("isFamilyMember", "Y");
         }
         clientForm.setIntakeClientNum(new Integer(clientFamily.size()));
       }
       request.setAttribute("isFamilyMember", isFamilyMember);
       
       Integer curDB_RoomId = new Integer(0);
       Integer curDB_BedId = new Integer(0);
       if(clientForm.getCurDB_RoomId()!=null) curDB_RoomId = clientForm.getCurDB_RoomId(); 
       if(clientForm.getCurDB_BedId()!=null) curDB_BedId = clientForm.getCurDB_BedId(); 
       

     if(admission.getAdmissionStatus().equals(KeyConstants.INTAKE_STATUS_ADMITTED)){
       if(request.getParameter("admissionId")!=null){
         RoomDemographic rdm = roomDemographicManager.getRoomDemographicByAdmissionId(Integer.valueOf(request.getParameter("admissionId")));
         if(rdm!=null){
           clientForm.setRoomDemographic(rdm);
           clientForm.setCurDB_RoomId(rdm.getId().getRoomId());
           request.setAttribute("prevDB_RoomId", rdm.getId().getRoomId());
           curDB_RoomId = rdm.getId().getRoomId();
    	   clientForm.setCurDB_BedId(rdm.getBedId());
    	   curDB_BedId = rdm.getBedId();
         }
       }
       
       //setup rooms
       Room currentDB_room = null;
       if(curDB_RoomId!=null && curDB_RoomId.intValue()>0) currentDB_room = roomManager.getRoom(curDB_RoomId);
       ArrayList availableRoomLst = new ArrayList();
       if(isFamilyMember.equals("N")){
      	 Room emptyRoom=new Room();
    	 emptyRoom.setId(new Integer(0));
    	 emptyRoom.setName(" ---- ");
    	 availableRoomLst.add(emptyRoom);
       }
       if(currentDB_room!=null) availableRoomLst.add(currentDB_room);
       
       Room[] availableRooms;
       if(isFamilyMember.equals("N")){
 	     availableRooms = roomManager.getAvailableRooms(null, programId, Boolean.TRUE, 
	           clientId.toString(), clientForm.getFamilyIntakeType().equals("Y"));
       }else{
    	 availableRooms = new Room[0];
       }
/* 	   
       if(admission.getId().intValue()==0){
          //for new admission, family intake admission only takes empty rooms.
    	  availableRooms = roomManager.getAvailableRooms(null, programId, Boolean.TRUE, 
    		           clientId, clientForm.getFamilyIntakeType().equals("Y"));
       }else{
           //for existing admission, can take any rooms.
           availableRooms = roomManager.getAvailableRooms(null, programId, Boolean.TRUE, 
		           clientId, false);
       }
*/
 	   
       for(int i=0;i<availableRooms.length;i++){
     	   if(currentDB_room!=null && currentDB_room.equals(availableRooms[i])) continue; 
           availableRoomLst.add(availableRooms[i]);
       }
       Room[] availableRooms2 =  (Room[]) availableRoomLst.toArray(new Room[availableRoomLst.size()]);
       clientForm.setAvailableRooms(availableRooms2);
       if(currentDB_room!=null && currentDB_room.getAssignedBed().intValue()==0) 
    	   clientForm.setCurDB_RoomCapacity(currentDB_room.getCapacity());

       //setup beds
       //new family intake admission doesn't need assign beds, just room. 
       if(!FamilyIntakeType.equals("Y") || admission.getId().intValue()>0){
      	 if(currentDB_room==null){
    	   Bed emptyBed=new Bed();
    	   emptyBed.setId(new Integer(0));
    	   emptyBed.setName(" ---- ");
           Bed[] availableBeds=new Bed[1];
   	       availableBeds[0] = emptyBed;
           clientForm.setAvailableBeds(availableBeds);
      	 }else if(currentDB_room.getAssignedBed().intValue()==1){  
           ArrayList availableBedLst = new ArrayList();
  	       Bed emptyBed=new Bed();
  	       emptyBed.setId(new Integer(0));
  	       emptyBed.setName(" ---- ");
  	       availableBedLst.add(emptyBed);
           if(clientForm.getRoomDemographic().getId().getRoomId()!=null && clientForm.getRoomDemographic().getId().getRoomId().intValue()>0){
             Bed currentDB_bed = null;
             if(curDB_RoomId.equals(clientForm.getRoomDemographic().getId().getRoomId())){
        	   if(curDB_BedId!=null && curDB_BedId.intValue()>0) currentDB_bed = bedManager.getBed(curDB_BedId);
               if(currentDB_bed!=null) availableBedLst.add(currentDB_bed);
             }

             //add current bed in bed_demographic table to bed dropdown when change room (assignedBed=0) to room (assignBed=1) 
             if(currentDB_bed==null){
               RoomDemographic roomDemographic = roomDemographicManager.getRoomDemographicByAdmissionId(admission.getId());
               if(roomDemographic!=null){
            	   Integer bedId = roomDemographic.getBedId();
            	   if(!(bedId == null || bedId.equals(curDB_BedId))){
            	      currentDB_bed = bedManager.getBed(bedId);
            	      if(currentDB_bed!=null) availableBedLst.add(currentDB_bed);
            	   }
               }
             }

             Bed[] availableBeds = bedManager.getAvailableBedsByRoom(clientForm.getRoomDemographic().getId().getRoomId());
             for(int i=0;i<availableBeds.length;i++){
         	   if(currentDB_bed!=null && currentDB_bed.equals(availableBeds[i])) continue; 
               availableBedLst.add(availableBeds[i]);
             }
       	     Bed[] availableBeds2 =  (Bed[]) availableBedLst.toArray(new Bed[availableBedLst.size()]);
             clientForm.setAvailableBeds(availableBeds2);
   	       }else{
             Bed[] availableBeds=new Bed[1];
     	     availableBeds[0] = emptyBed;
             clientForm.setAvailableBeds(availableBeds);
           }
    	 }else{
             clientForm.setAvailableBeds(null);
             Integer roomOccupancy = new Integer(roomDemographicManager.getRoomOccupanyByRoom(currentDB_room.getId()));
       		 clientForm.setCurDB_RoomCapacity(currentDB_room.getCapacity()); 
    	 }
       }
     
     //fail to create new admission due to error message.
     }else if(admission.getAdmissionStatus().equals(KeyConstants.INTAKE_STATUS_ACTIVE)){
         ArrayList availableRoomLst = new ArrayList();
  	     Room emptyRoom=new Room();
  	     emptyRoom.setId(new Integer(0));
  	     emptyRoom.setName(" ---- ");
  	     availableRoomLst.add(emptyRoom);
         Room[] availableRooms = roomManager.getAvailableRooms(null, programId, Boolean.TRUE, 
      		   clientId.toString(), FamilyIntakeType.equals("Y"));
         for(int i=0;i<availableRooms.length;i++){
             availableRoomLst.add(availableRooms[i]);
         }
         Room[] availableRooms2 =  (Room[]) availableRoomLst.toArray(new Room[availableRoomLst.size()]);
         clientForm.setAvailableRooms(availableRooms2);

         if(!FamilyIntakeType.equals("Y")){
             ArrayList availableBedLst = new ArrayList();
      	     Bed emptyBed=new Bed();
      	     emptyBed.setId(new Integer(0));
      	     emptyBed.setName(" ---- ");
      	     availableBedLst.add(emptyBed);
             if(clientForm.getRoomDemographic().getId().getRoomId()!=null && clientForm.getRoomDemographic().getId().getRoomId().intValue()>0){
               Bed[] availableBeds = bedManager.getAvailableBedsByRoom(clientForm.getRoomDemographic().getId().getRoomId());
               for(int i=0;i<availableBeds.length;i++){
                   availableBedLst.add(availableBeds[i]);
               }
           	   Bed[] availableBeds2 =  (Bed[]) availableBedLst.toArray(new Bed[availableBedLst.size()]);
               clientForm.setAvailableBeds(availableBeds2);
       	     }else{
               Bed[] availableBeds=new Bed[1];
         	   availableBeds[0] = emptyBed;
               clientForm.setAvailableBeds(availableBeds);
             }
           }
         
     //admission discharged
     }else{
       RoomDemographicHistorical rdm= admissionManager.getLatestRoomDemographicHistory(admissionId);
       if(rdm!=null){
         clientForm.setCurDB_RoomId(rdm.getRoomId());
         request.setAttribute("prevDB_RoomId", rdm.getRoomId());
         curDB_RoomId = rdm.getRoomId();
         request.setAttribute("historyRoomName", rdm.getRoomName());
       
  	     if(rdm.getBedId() !=null){
  	         clientForm.setCurDB_BedId(rdm.getBedId());
  	         curDB_BedId = rdm.getBedId();
             request.setAttribute("historyBedName", rdm.getBedName());
         }
       }
     }
     
	   //set dropdown values
	   List providerList = providerManager.getActiveProviders(programId);
  	   Provider pObj= new Provider();
  	   pObj.setProviderNo("");
  	   providerList.add(0, pObj);
  	   clientForm.setProviderList(providerList);
	   List provinceList = lookupManager.LoadCodeList("POV",!readOnly, null, null);
	   clientForm.setProvinceList(provinceList);
	   List notSignReasonList = lookupManager.LoadCodeList("RNS",!readOnly, null, null);
       clientForm.setNotSignReasonList(notSignReasonList);
       
       if(admission.getProviderNo()!=null) request.setAttribute("issuedBy",providerManager.getProvider(admission.getProviderNo()).getFormattedName());
       if("discharged".equalsIgnoreCase(admission.getAdmissionStatus())){
    	   request.setAttribute("isReadOnly", "true");
       }
       request.setAttribute("programId", admission.getProgramId());
       readOnly=super.isReadOnly(request,admission.getAdmissionStatus(), KeyConstants.FUN_CLIENTADMISSION,admission.getProgramId());
       if(readOnly) request.setAttribute("isReadOnly", Boolean.valueOf(readOnly));
       super.setScreenMode(request, KeyConstants.TAB_CLIENT_ADMISSION);
       return mapping.findForward("edit");
	   }
	   catch(NoAccessException e)
	   {
		   return mapping.findForward("failure");
	   }
     
   }

   private boolean canOverwrite(HttpServletRequest request,String programId){
	   SecurityManager sec = super.getSecurityManager(request);
		//summary
		if(programId==null) return false;
		
		return sec.GetAccess(KeyConstants.FUN_CLIENTADMISSION, programId).equals(KeyConstants.ACCESS_ALL);
   }
   private boolean validateConflict(HttpServletRequest request, Program program,Demographic client,
		   Integer roomId, Integer clientNum, ActionMessages messages){
	   boolean valid = true;
	   if(clientRestrictionManager.checkGenderConflict(program, client)){
    	   messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.gender_conflict", request.getContextPath()));
           valid = false;
 	   }
       if(clientRestrictionManager.checkAgeConflict(program, client)){
     	   messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.age_conflict", request.getContextPath()));
     	   valid = false;
       }

 	   //service restriction check
       StringBuffer sb = new StringBuffer();
       ProgramClientRestriction restrInPlace = clientRestrictionManager.checkClientRestriction(
     	     program.getId(), client.getDemographicNo(), new Date());
       if(restrInPlace != null) {
     	 sb.append(client.getLastName() + ", " + client.getFirstName() + "<br>");
	     messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.family_service_restriction",
       			request.getContextPath(), program.getName(), sb.toString()));
         valid = false;
       }
       
       //enough bed or room capacity check
       if(roomId.intValue()>0){
           Room newSelectedRoom = roomManager.getRoom(roomId);        	  
     	    if(newSelectedRoom.getAssignedBed().intValue()==1){
             Bed[] availableBeds = bedManager.getAvailableBedsByRoom(roomId);
     		 if(availableBeds.length<clientNum.intValue()){ 
  		        messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("warning.admission.room_bed_limitation",
  	       			request.getContextPath(), String.valueOf(availableBeds.length)));
                valid = false;
     		 } 
           }else{
     		  if(newSelectedRoom.getCapacity().intValue()<clientNum.intValue()){ 
	            messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("warning.admission.room_capacity_limitation",
	  	       		request.getContextPath(), newSelectedRoom.getCapacity().toString()));
                valid = false;
     		  }
           }
         
         }
       if(!valid) saveMessages(request,messages);         
	   return !valid;
   }
   public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {     
	   try {
	   request.setAttribute("isFamilyMember", request.getParameter("isFamilyMember"));

	   super.setScreenMode(request, KeyConstants.TAB_CLIENT_ADMISSION);
       HashMap actionParam = (HashMap) request.getAttribute("actionParam");
       if(actionParam==null){
    	  actionParam = new HashMap();
          actionParam.put("clientId", request.getParameter("admission.clientId")); 
       }
       request.setAttribute("actionParam", actionParam);
       boolean isError = false;
       boolean isWarning = false;
       QuatroClientAdmissionForm clientForm = (QuatroClientAdmissionForm) form;
       ActionMessages messages = new ActionMessages();
       Admission admission = clientForm.getAdmission();
       request.setAttribute("programId", admission.getProgramId());
       if(admission.getId() != null && admission.getId().intValue()> 0)
    	   super.getAccess(request, KeyConstants.FUN_CLIENTADMISSION, admission.getProgramId(),KeyConstants.ACCESS_UPDATE);
       else
    	   super.getAccess(request, KeyConstants.FUN_CLIENTADMISSION, admission.getProgramId(),KeyConstants.ACCESS_WRITE);
       Integer clientId = admission.getClientId();
       Integer intakeId = admission.getIntakeId();
       Integer programId = admission.getProgramId();
       Integer admissionId = admission.getId();
       Demographic client= super.getClient(request, clientId);
       String overrideYN =request.getParameter(KeyConstants.CONFIRMATION_CHECKBOX_NAME);
       boolean canOverride=false;
  	   Program program = programManager.getProgram(programId);
	   canOverride=canOverwrite(request, program.getId().toString());

	   List lstFamily = new ArrayList();
       //don't check these if intake admitted.
	   Integer headClientId = Integer.valueOf("0");
       if(admissionId.intValue()==0)
       {
    	 if(clientForm.getFamilyIntakeType().equals("Y")){  
    	   lstFamily = intakeManager.getClientFamilyByIntakeId(admission.getIntakeId().toString());
    	   if(lstFamily.size() > 0) headClientId = ((QuatroIntakeFamily)lstFamily.get(lstFamily.size()-1)).getClientId();
           for(int i=0;i<lstFamily.size();i++){
             QuatroIntakeFamily qif = (QuatroIntakeFamily)lstFamily.get(i);

      	     //check gender conflict and age conflict
             Demographic client2= intakeManager.getClientByDemographicNo(qif.getClientId());
             if(!"Y".equals(request.getParameter(KeyConstants.CONFIRMATION_CHECKBOX_NAME)))
               isWarning = isWarning || validateConflict(request, program, client2,
              	  clientForm.getRoomDemographic().getId().getRoomId(),clientForm.getIntakeClientNum(),messages);
           
             // check if the client is a dependent in another admission
             List lst=admissionManager.getCurrentAdmissions(qif.getClientId(),KeyConstants.SYSTEM_USER_PROVIDER_NO,null);
             for(int j = 0; j<lst.size(); j++) {
            	 Admission admObj = (Admission) lst.get(j);
            	 if(isClientAdmittedAsDependent(admObj, headClientId)) {
            		 Demographic client1 = intakeManager.getClientByDemographicNo(admObj.getClientId());
            		 messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.existing_dependent", request.getContextPath(),client1.getLastName() + ", " + client.getFirstName()));
            		 isError = true;
            	 }
             }
           }
    	 }else{
             // check if the client is a dependent in another admission
    		 List lst=admissionManager.getCurrentAdmissions(admission.getClientId(),KeyConstants.SYSTEM_USER_PROVIDER_NO,null);
             for(int j = 0; j<lst.size(); j++) {
            	 Admission admObj = (Admission) lst.get(j);
            	 if(isClientAdmittedAsDependent(admObj, admission.getClientId())) {
            		 Demographic client1 = intakeManager.getClientByDemographicNo(admObj.getClientId());
            		 messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.existing_dependent", request.getContextPath(),client1.getLastName() + ", " + client.getFirstName()));
            		 isError = true;
            	 }
             }
    		 
             //check gender conflict and age conflict
             isWarning = validateConflict(request, program, client,
               	  clientForm.getRoomDemographic().getId().getRoomId(),clientForm.getIntakeClientNum(),messages);
    	 }
    	 if(isError)
    	 {
    		 saveMessages(request, messages);
    		 return update(mapping, form, request, response);
    	 }
    	 else if(isWarning){
     		  if (!canOverride)  return update(mapping, form, request, response);
     		  else{
     			  if(!"Y".equals(overrideYN)){
	    	    	  messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("warning.admission.overwrite_conflict", request.getContextPath()));       	     	 
	    	    	  saveMessages(request,messages);
	    	    	  return update(mapping, form, request, response);
    	    	  }else{
    	    		  messages.clear(); 
    	    		  isWarning=false;
    	    	  }
    	    	 }
     		}
       }
       //check if roomId /bedId selected
       RoomDemographic rdm = clientForm.getRoomDemographic();
       if(rdm.getId().getRoomId().intValue()==0){
	     messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.empty_roomId",
         			request.getContextPath()));
         isError = true;
         saveMessages(request,messages);
	     return update(mapping, form, request, response);
//         clientForm.setFamilyIntakeType(familyIntakeType);
       }else{
    	  //check bedId selected for single person intake admission
    	  //admitted family member may not necessary be assigned bed on this page.  
    	  if((!clientForm.getFamilyIntakeType().equals("Y") && !"Y".equals(overrideYN)) ||
    		 (clientForm.getFamilyIntakeType().equals("Y") && !"Y".equals(overrideYN) && admission.getId().intValue()>0)){
    		 Room roomToSave = roomManager.getRoom(rdm.getId().getRoomId());  
    		 if(roomToSave.getAssignedBed().intValue()==1){
    	       Integer bedId = rdm.getBedId();
    	       if(bedId == null || bedId.intValue()==0){
    	          messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.empty_bedId",
      			     request.getContextPath()));
                  isError = true;
                  saveMessages(request,messages);
          	      return update(mapping, form, request, response);
    	       }
    	       else
    	       {
    	    	   RoomDemographic rdm0 = roomDemographicManager.getRoomDemographicByBed(bedId); 
    	    	   if(rdm0 != null)
    	    	   {
    	    		   if(rdm0.getId().getDemographicNo().intValue() != clientId.intValue())
    	    		   {
    	     	          messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.occupied_bedId",
    	           			     request.getContextPath()));
    	                       isError = true;
    	                       saveMessages(request,messages);
    	               	      return update(mapping, form, request, response);
    	    		   }
    	    	   }
    	       }
    		 }else{
                Integer roomOccupancy = new Integer(roomDemographicManager.getRoomOccupanyByRoom(roomToSave.getId()));
                RoomDemographic rdm_currentinDB = roomDemographicManager.getRoomDemographicByDemographic(clientId);
                if(rdm_currentinDB!=null && (!rdm_currentinDB.getId().getRoomId().equals(roomToSave.getId()) && roomToSave.getCapacity().intValue()-roomOccupancy.intValue()<1)){
     	          messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.not_available_room_space",
           			     request.getContextPath()));
                  isError = true;
                  saveMessages(request,messages);
            	  if (!canOverride)  return update(mapping, form, request, response);
               	  else{
               	    messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("warning.admission.overwrite_conflict", request.getContextPath()));       	     	 
               	    saveMessages(request,messages);
               	    return update(mapping, form, request, response);
               	  }
               	}
    		 }
    	  }   
       }
       
       
       String providerNo = (String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
	   admission.setProviderNo(providerNo);
       admission.setAdmissionDate(MyDateFormat.getCalendarwithTime(admission.getAdmissionDateTxt()));
       admission.setOvPassStartDate(MyDateFormat.getCalendar(admission.getOvPassStartDateTxt()));
       admission.setOvPassEndDate(MyDateFormat.getCalendar(admission.getOvPassEndDateTxt()));
       admission.setLastUpdateDate(new GregorianCalendar());
       
       RoomDemographic roomDemographic = clientForm.getRoomDemographic();
 	   RoomDemographicPK rdmPK= roomDemographic.getId();
 	   rdmPK.setDemographicNo(admission.getClientId());
 	   roomDemographic.setId(rdmPK);
 	   roomDemographic.setProviderNo(providerNo);
 	   roomDemographic.setAssignStart(new Date());
 	   //check # of bag
 	   if(!Utility.IsEmpty(admission.getNoOfBags()) &&(!Utility.IsInt(admission.getNoOfBags()) || Utility.IsIntLessThanZero(admission.getNoOfBags()))){
 		  messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.invalid_no_of_bag", request.getContextPath()));
           isError = true;
           saveMessages(request,messages);
           return update(mapping, form, request, response);
 	   }
       //check overnight pass validation
 	   if(admission.getOvPassStartDate()!=null && admission.getOvPassEndDate()!=null){
         if(admission.getOvPassStartDate().after(admission.getOvPassEndDate())){
	        messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.invalid_overnight_pass_date",
     			   request.getContextPath()));
            isError = true;
            saveMessages(request,messages);
            return update(mapping, form, request, response);
         }
       }else if(admission.getOvPassStartDate()!=null || admission.getOvPassEndDate()!=null){
 	      messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.invalid_overnight_pass_date2",
    			   request.getContextPath()));
         isError = true;
         saveMessages(request,messages);
         return update(mapping, form, request, response);
       }
 	   
 	   if(clientForm.getFamilyIntakeType().equals("Y") && admission.getId().intValue()==0){  
  		 roomDemographic.setBedId(null);  
  	   }
  	   
       boolean isNotSigned = Utility.IsEmpty(admission.getNotSignReason());
       // skip signature validation for family memeber
 	   if(request.getParameter("isFamilyMember").equals("Y")){
 		   isNotSigned=false; 
 	   }else{
 	 	   if(isNotSigned) { 
 			  isNotSigned = !topazManager.isSignatureExist(intakeId);
 		   }
 	   }
	   
 	   if(isNotSigned)
	   {
 	      messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.intake.admission.miss_signature",
   			   request.getContextPath()));
          isError = true;
          saveMessages(request,messages);
          return update(mapping, form, request, response);
	    }

 	   /* auto discharge existing admissions */
 	   StringBuffer sb = new StringBuffer();
 	   if(lstFamily.size() > 0) {
           for(int i=0;i<lstFamily.size();i++){
               QuatroIntakeFamily qif = (QuatroIntakeFamily)lstFamily.get(i);
               
               List lst=admissionManager.getCurrentAdmissions(qif.getClientId(),KeyConstants.SYSTEM_USER_PROVIDER_NO,null);
               for(int j = 0; j<lst.size(); j++) {
              	 Admission admObj = (Admission) lst.get(j);
      		   	 admObj.setAdmissionStatus(KeyConstants.INTAKE_STATUS_DISCHARGED);
    		     admObj.setDischargeDate(Calendar.getInstance());
    		     admObj.setLastUpdateDate(new GregorianCalendar());
    		     admObj.setProviderNo(providerNo);
    		     admObj.setDischargeReason(KeyConstants.AUTO_DISCHARGE_REASON);
    		     admObj.setDischargeNotes("auto-discharge for other intake admission");
              	 List lstFam = intakeManager.getClientFamilyByIntakeId(admObj.getIntakeId().toString());
              	 boolean isReferral=false;
              	 admissionManager.dischargeAdmission(admObj, isReferral, lstFam);
               }
           }
 	   }
 	   else
 	   {
           List lst=admissionManager.getCurrentAdmissions(admission.getClientId(),KeyConstants.SYSTEM_USER_PROVIDER_NO,null);
           for(int j = 0; j<lst.size(); j++) {
            	 Admission admObj = (Admission) lst.get(j);
            	 if(admObj.getId().intValue()==admission.getId().intValue()) continue;
      		   	 admObj.setAdmissionStatus(KeyConstants.INTAKE_STATUS_DISCHARGED);
    		     admObj.setDischargeDate(Calendar.getInstance());
    		     admObj.setLastUpdateDate(new GregorianCalendar());
    		     admObj.setProviderNo(providerNo);
    		     admObj.setDischargeReason(KeyConstants.AUTO_DISCHARGE_REASON);
    		     admObj.setDischargeNotes("auto-discharge for other intake admission");
            	 
              	 List lstFam = intakeManager.getClientFamilyByIntakeId(admObj.getIntakeId().toString());
              	 boolean isReferral=false;
              	 admissionManager.dischargeAdmission(admObj, isReferral, lstFam);
              	 // programManager.sendTask(admObj.getProgramId(), admObj.getClientId(), "Client was auto-discharged");
             }
 	   }
 	   
 	    /* Saving the admission */
	    if(admission.getId().intValue() == 0)
	    {
    	  admission.setAdmissionStatus(KeyConstants.INTAKE_STATUS_ADMITTED);

    	  Integer newAdmissionId = admissionManager.saveAdmission(admission, intakeId,  
       			  roomDemographic,clientForm.getFamilyIntakeType().equals("Y"));
    	  request.setAttribute("newAdmissionSaved", "Y");
    	  admission.setId(newAdmissionId);
       }else{
    	  if(!clientForm.getFamilyIntakeType().equals("Y")){
     	     admissionManager.updateAdmission(admission, roomDemographic, false);
    	  }else{
    	     String isFamilyMember = request.getParameter("isFamilyMember");
             if(isFamilyMember.equals("N")){
    	       admissionManager.updateAdmission(admission, roomDemographic, true);
             }else{
      	       admissionManager.updateAdmission(admission, roomDemographic, false);
             }
    	  }
       }
       
	   if(!(isWarning || isError)) {
		   messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("message.save.success", request.getContextPath()));
	       request.setAttribute("pageChanged","");
	   }
       saveMessages(request,messages);

 	   clientForm.setAdmission(admission);
 	   clientForm.setRoomDemographic(roomDemographic);
 	   clientForm.setBedId(roomDemographic.getBedId());
 	   clientForm.setCurDB_RoomId(roomDemographic.getId().getRoomId());
       request.setAttribute("prevDB_RoomId", roomDemographic.getId().getRoomId());
 	   clientForm.setCurDB_BedId(roomDemographic.getBedId());
 	   request.setAttribute("clientId", clientId.toString());
       Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
       super.cacheClient(request, clientId);
       super.setCurrentIntakeProgramId(request, clientId, shelterId, providerNo);
       return update(mapping, form, request, response);
	   }
	   catch(NoAccessException e)
	   {
		   return mapping.findForward("failure");
	   }
   }
   private boolean isClientAdmittedAsDependent(Admission admObj, Integer headClientId)
   {
	   List lstFamily = intakeManager.getClientFamilyByIntakeId(admObj.getIntakeId().toString());
	   boolean isDependent=false;
	   if(lstFamily.size() > 0) {
		   boolean isHead = false;
		   for(int i=0; i<lstFamily.size(); i++)
		   {
			   QuatroIntakeFamily fam = (QuatroIntakeFamily) lstFamily.get(i);
			   if(fam.getIntakeHeadId().intValue() == admObj.getIntakeId().intValue()) {
				   isHead = true;
				   break;
			   }
			   if (fam.getIntakeHeadId().intValue() == fam.getIntakeId().intValue())
			   {
				   if(fam.getClientId().intValue() == headClientId.intValue()) 
				   {
					   isHead = true;
					   break;
				   }
			   }
		   }
		   isDependent = !isHead;
	   }
	   return isDependent;
   }
   public void setClientManager(ClientManager clientManager) {
	 this.clientManager = clientManager;
   }

   public void setProgramManager(ProgramManager programManager) {
	 this.programManager = programManager;
   }

   public void setRoomDemographicManager(RoomDemographicManager roomDemographicManager) {
	 this.roomDemographicManager = roomDemographicManager;
   }

   public void setRoomManager(RoomManager roomManager) {
	 this.roomManager = roomManager;
   }

   public void setBedManager(BedManager bedManager) {
	 this.bedManager = bedManager;
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

   public void setClientRestrictionManager(ClientRestrictionManager clientRestrictionManager) {
	 this.clientRestrictionManager = clientRestrictionManager;
   }
   
   public void setProviderManager(ProviderManager providerManager) {
	 this.providerManager = providerManager;
  }

   public void setAdmissionManager(AdmissionManager admissionManager) {
	 this.admissionManager = admissionManager;
  }

public void setTopazManager(TopazManager topazManager) {
	this.topazManager = topazManager;
}
   
}
