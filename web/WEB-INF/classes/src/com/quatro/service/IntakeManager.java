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
package com.quatro.service;

import java.sql.SQLException;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;
import java.util.Calendar;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quatro.dao.IntakeDao;
import com.quatro.dao.LookupDao;
import org.oscarehr.PMmodule.dao.ClientDao;
import org.oscarehr.PMmodule.dao.AdmissionDao;
import org.oscarehr.PMmodule.dao.ProgramDao;
import org.oscarehr.PMmodule.dao.RoomDAO;

import com.quatro.web.intake.OptionList;
import com.quatro.model.QuatroIntakeOptionValue;
import com.quatro.web.intake.IntakeConstant;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.util.LabelValueBean;
import org.oscarehr.PMmodule.model.ClientReferral;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.PMmodule.model.ProgramClientRestriction;
import org.oscarehr.PMmodule.model.ProgramQueue;
import org.oscarehr.PMmodule.model.QuatroIntakeAnswer;
import org.oscarehr.PMmodule.model.QuatroIntakeDB;
import org.oscarehr.PMmodule.model.QuatroIntake;
import org.oscarehr.PMmodule.model.QuatroIntakeFamily;
import org.oscarehr.PMmodule.model.QuatroIntakeFamilyHis;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.model.Room;
import org.oscarehr.PMmodule.model.RoomDemographic;
import org.oscarehr.PMmodule.model.RoomDemographicPK;
import org.oscarehr.PMmodule.dao.ClientHistoryDao;
import com.quatro.common.KeyConstants;
import com.quatro.model.LookupCodeValue;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.service.RoomManager;
import org.oscarehr.PMmodule.web.QuatroFamilyIntakeAction;
import org.oscarehr.PMmodule.web.formbean.ClientForm;

import org.oscarehr.PMmodule.dao.ClientReferralDAO;
import org.oscarehr.PMmodule.dao.ProgramQueueDao;

import oscar.MyDateFormat;

public class IntakeManager {
    private IntakeDao intakeDao;
    private AdmissionDao admissionDao;
    private ClientReferralDAO clientReferralDAO;
    private ProgramQueueDao programQueueDao;
    private RoomDAO roomDAO;
    private LookupDao lookupDao;
    private ClientDao clientDao;
    private ProgramDao programDao;
    private ClientHistoryDao historyDao;
    
	public IntakeDao getIntakeDao() {
		return intakeDao;
	}
	public void setIntakeDao(IntakeDao intakeDao) {
		this.intakeDao = intakeDao;
	}
	public AdmissionDao getAdmissionDao()
	{
		return admissionDao;
	}
	public void setAdmissionDao(AdmissionDao admissionDao)
	{
		this.admissionDao = admissionDao;
	}
	public void setClientHistoryDao(ClientHistoryDao historyDao) {
		this.historyDao = historyDao;
	}
	public List getActiveIntakeIds(Integer clientId){
		return intakeDao.getActiveIntakeIds(clientId);
	}

    public void removeInactiveIntakeFamilyMember(String sDependentInakeIds, Integer intakeHeadId){
    	if(sDependentInakeIds==null) return;
    	
    	List lst = intakeDao.getClientIntakeFamily(intakeHeadId);
    	if(lst.size()==0) return;
    	
    	StringBuffer sb = new StringBuffer();
    	if(sDependentInakeIds.equals("")){
          for(int i=0;i<lst.size();i++){
        	QuatroIntakeFamily obj= (QuatroIntakeFamily)lst.get(i);
        	if(obj.getIntakeHeadId().equals(obj.getIntakeId())) continue;  //skip family head
        	sb.append("," + obj.getIntakeId().toString());
          }
    	}else{
    	  String[] split = sDependentInakeIds.split(","); 
          for(int i=0;i<lst.size();i++){
      	    int j=0;
      	    QuatroIntakeFamily obj= (QuatroIntakeFamily)lst.get(i);
        	if(obj.getIntakeHeadId().equals(obj.getIntakeId())) continue;  //skip family head
   	        for(j=0;j<split.length;j++){
    		  if(obj.getIntakeId().toString().equals(split[j])){
                break;    			
    		  }
    	    }
      	    if(j==split.length) sb.append("," + obj.getIntakeId().toString());
          }
    	}

        if(sb.length()==0) return;
    	
  	    //remove inactive family memeber from family intake, 
    	//and update their referal and queue#
    	String sRemovedDependentIds=sb.substring(1);
    	intakeDao.removeInactiveIntakeFamilyMember(sRemovedDependentIds);
    	
    	String[] split2 = sRemovedDependentIds.split(",");
    	
  	    List lst2 = intakeDao.getQuatroIntakeDBByIntakeIds(sRemovedDependentIds);
    	for(int i=0;i<split2.length;i++){
    	  QuatroIntakeDB intake = (QuatroIntakeDB) lst2.get(i);	

    	  if(intake.getIntakeStatus().equals(KeyConstants.INTAKE_STATUS_ACTIVE)){
    	    //create new referral#
    	    ClientReferral referral = new ClientReferral();
            if(intake.getClientId()!=null) referral.setClientId(intake.getClientId());
            referral.setNotes("Intake Automated referral");
            if(intake.getProgramId()!=null) {
            	referral.setProgramId(intake.getProgramId());
            	referral.setFromProgramId(intake.getProgramId());
            }
            referral.setProviderNo(intake.getStaffId());
            referral.setReferralDate(Calendar.getInstance());
            referral.setStatus(KeyConstants.STATUS_PENDING);
            referral.setAutoManual(KeyConstants.AUTOMATIC);
            referral.setFromIntakeId(intake.getId());
            clientReferralDAO.saveClientReferral(referral);
          
            //create new queue# 
            ProgramQueue queue = new ProgramQueue();
            queue.setClientId(referral.getClientId());
            queue.setNotes(referral.getNotes());
            queue.setProgramId(referral.getProgramId());
            queue.setProviderNo(Integer.valueOf(referral.getProviderNo()));
            queue.setReferralDate(referral.getReferralDate().getTime());
            queue.setFromIntakeId(intake.getId());
            
            queue.setReferralId(referral.getId());
            programQueueDao.saveProgramQueue(queue);
    	  }
    	}
  	    
    }
    public Integer getProgramIdByProvider(Integer clientId, Integer shelterId, String providerNo){
     return intakeDao.getProgramIdByProvider(clientId, shelterId, providerNo);
    }
    public List getActiveIntakeByProgram(Integer programId){
    	return intakeDao.getActiveIntakeByProgram(programId);
    }
	public List getIntakesByProgram(Integer programId){
    	return intakeDao.getIntakesByProgram(programId);
	}
	/* returns the merged client if the client was merged */
	public Demographic getClientByDemographicNo(Integer demographicNo) {
        if (demographicNo == null || demographicNo.intValue() == 0) {
            return null;
        }
        return  clientDao.getClientMergedTo(demographicNo);
    }

    //for single person intake check
    public List checkExistBedIntakeByFacility(Integer clientId, Integer programId){
    	return intakeDao.checkExistBedIntakeByPrograms(clientId, programId);
    }
    
    //for family member intake check
	public QuatroIntakeDB findActiveQuatroIntakeDB(Integer clientId, Integer programId){
    	return intakeDao.findActiveQuatroIntakeDB(clientId, programId);
    }

	public List getActiveIntakeByProgramByClient(Integer clientId, Integer programId) {
    	return intakeDao.getActiveIntakeByProgramByClient(clientId, programId);
	}
		
	public Integer getIntakeFamilyHeadId(Integer intakeId){
		return intakeDao.getIntakeFamilyHeadId(intakeId);
	}
	public QuatroIntakeFamily getIntakeFamilyRecord(Integer intakeId) {
        if (intakeId == null || intakeId.intValue() == 0) {
            return null;
        }
        return intakeDao.getIntakeFamilyRecord(intakeId);
	}
	
	public List getClientFamilyByIntakeId(Integer intakeId) throws SQLException{
        if (intakeId == null || intakeId.intValue() == 0) {
            return new ArrayList();
        }
        
        //avoid to join intake_family/intake table and demegraphic table for query
        List lst = intakeDao.getClientIntakeFamily(intakeId);
        
        if(lst.size()==0) return lst;

        List relationships = lookupDao.LoadCodeList("FRA",true, null, null);
        Iterator it = lst.iterator();
        while(it.hasNext()){
        	Object element = (Object)it.next();
        
       	  QuatroIntakeFamily obj=(QuatroIntakeFamily)element;
       	  obj.setJoinFamilyDateTxt(MyDateFormat.getStandardDateTime(obj.getJoinFamilyDate()));
       	  Iterator it2 = relationships.iterator();
       	  while(it2.hasNext()){
        	Object element2 = (Object)it2.next();
          
        	LookupCodeValue obj2= (LookupCodeValue)element2;  
       	    if(obj2.getCode().equals(obj.getRelationship())){
        	  obj.setRelationshipDesc(obj2.getDescription());
       	      break;
       	    }else if(KeyConstants.FAMILY_HEAD_CODE.equals(obj.getRelationship())){
          	  obj.setRelationshipDesc(KeyConstants.FAMILY_HEAD_DESC);
       	      break;
       	    }
          }  
        }
        
        StringBuffer sb= new StringBuffer();
        Iterator it3 = lst.iterator();
        while(it3.hasNext()){
        	Object element = (Object)it3.next();
    	
    	  QuatroIntakeFamily obj=(QuatroIntakeFamily)element;
          sb.append("," +  obj.getClientId().toString());          
        }

    	List lst2 = clientDao.getClientFamilyByDemographicNo(sb.substring(1));
    	Iterator it4 = lst2.iterator();
        while(it4.hasNext()){
        	Object element2 = (Object)it4.next();
    	//for(Object element2 : lst2) {
    	  Demographic dmg= (Demographic)element2;
    	  
    	  Iterator it5 = lst.iterator();
          while(it5.hasNext()){
          	Object element = (Object)it5.next();
          //for(Object element : lst) {
       	    QuatroIntakeFamily obj=(QuatroIntakeFamily)element;
    		if(dmg.getDemographicNo().equals(obj.getClientId())){
       	      obj.setFirstName(dmg.getFirstName());
       	      obj.setLastName(dmg.getLastName());
       	      obj.setSex(dmg.getSex());
       	      obj.setSexDesc(dmg.getSexDesc());
       	      obj.setDob(MyDateFormat.getStandardDate(dmg.getDateOfBirth()));
       	      obj.setAlias(dmg.getAlias());
      		  obj.setEffDate(MyDateFormat.getSysDateString(dmg.getEffDate()));
    		  break;
    		}  
          }
    	}
        return lst;	
    }
	
	public List getClientIntakeFamilyHistory(Integer intakeHeadId) throws SQLException
	{
		List lst =  intakeDao.getClientIntakeFamilyHistory(intakeHeadId);
		for(int i=0; i<lst.size();i++)
		{
			QuatroIntakeFamilyHis obj = (QuatroIntakeFamilyHis) lst.get(i);
			Demographic dmg = clientDao.getClientByDemographicNo(obj.getClientId());
				
	 	    obj.setFirstName(dmg.getFirstName());
	   	    obj.setLastName(dmg.getLastName());
	   	    obj.setSex(dmg.getSex());
	   	    obj.setSexDesc(dmg.getSexDesc());
	   	    obj.setDob(MyDateFormat.getStandardDate(dmg.getDateOfBirth()));
	   	    obj.setAlias(dmg.getAlias());
	  		obj.setEffDate(MyDateFormat.getSysDateString(dmg.getEffDate()));
	  		LookupCodeValue rel = lookupDao.GetCode("FRA", obj.getRelationship());
	  		if(rel == null) 
	  			obj.setRelationshipDesc("Family Head");
	  		else
	  			obj.setRelationshipDesc(rel.getDescription());
	  			
		}
  		return lst;
	}
	public OptionList LoadOptionsList(boolean activeOnly) {
        List lst=intakeDao.LoadOptionsList(activeOnly);
        OptionList lst2= new OptionList();
        HashMap map= IntakeConstant.getPrefixDefined();

        ArrayList[] lst3 = new ArrayList[12];
        for(int i=0;i<12;i++){
           lst3[i]= new ArrayList();
           if(i==IntakeConstant.SOURCEINCOME) continue;
           LabelValueBean obj2 = new LabelValueBean();
   	       obj2.setLabel("  ");
       	   obj2.setValue("");
           lst3[i].add(obj2);
        }
        
        boolean getRec;
        for(int i=0;i<12;i++){
          getRec=false;
          for(int j=0;j<lst.size();j++){
        	QuatroIntakeOptionValue obj= (QuatroIntakeOptionValue)lst.get(j);
       	    if(obj.getPrefix().equals(map.get(new Integer(i)))){
       	      LabelValueBean obj2 = new LabelValueBean();
       	      obj2.setLabel(obj.getDescription());
       	      obj2.setValue(obj.getCode());
        	  lst3[i].add(obj2);
        	  getRec=true;
        	}else{
              if(getRec==true){
            	  getRec=false;
            	  break;	
              }
            }
          }
      	  lst2.setValue(i, lst3[i]);            	
        }
        
        return lst2;
	}

	public List getActiveQuatroIntakeHeaderListByFacility(Integer clientId, Integer shelterId, String providerNo) {
        List lst2 = intakeDao.getActiveQuatroIntakeHeaderListByFacility(clientId, shelterId, providerNo);
        return lst2;
	}

	public List getQuatroIntakeHeaderListByFacility(Integer clientId, Integer shelterId, String providerNo) {

        List lst= programDao.getProgramIdsByProvider(providerNo, shelterId);

        List lst2 = intakeDao.getQuatroIntakeHeaderListByFacility(clientId, shelterId, providerNo);
		for(int i=0;i<lst2.size();i++){
          QuatroIntakeHeader obj2 = (QuatroIntakeHeader)lst2.get(i);
          
          Iterator it3 = lst.iterator();
          while(it3.hasNext()){
          	Object element3 = (Object)it3.next();
            Object[] obj3 = (Object[])element3;
            if(((Integer)obj3[0]).equals(obj2.getProgramId())){
              obj2.setProgramName((String)obj3[1]);
              obj2.setProgramType((String)obj3[2]);
              if(KeyConstants.PROGRAM_TYPE_Service.equals((String)obj3[2])){
              	if(obj2.getEndDate()!=null && obj2.getEndDate().before(Calendar.getInstance())){
              	   obj2.setIntakeStatus(KeyConstants.STATUS_INACTIVE);	
              	}
              }
              break;
            }
          }
        }
        return lst2;
	}

	public List getActiveServiceIntakeHeaderListByFacility(Integer clientId, Integer shelterId, String providerNo) {

        List lst= programDao.getProgramIdsByProvider(providerNo, shelterId);

        List lst2 = intakeDao.getQuatroIntakeHeaderListByFacility(clientId, shelterId, providerNo);
        ArrayList lst3= new ArrayList();
		for(int i=0;i<lst2.size();i++){
          QuatroIntakeHeader obj2 = (QuatroIntakeHeader)lst2.get(i);
          
          Iterator it3 = lst.iterator();
          while(it3.hasNext()){
          	Object element3 = (Object)it3.next();
            Object[] obj3 = (Object[])element3;
            if(((Integer)obj3[0]).equals(obj2.getProgramId())){
              if(KeyConstants.PROGRAM_TYPE_Service.equals((String)obj3[2])){
            	if(obj2.getEndDate()==null || 
            	  (obj2.getEndDate()!=null && !(obj2.getEndDate().before(Calendar.getInstance())))){
                   obj2.setProgramName((String)obj3[1]);
                   obj2.setProgramType((String)obj3[2]);
                   lst3.add(obj2);
            	}
                break;
              }  
            }
          }
          
        }
        return lst3;
	}
	
	public QuatroIntake getQuatroIntake(Integer intakeId) {
		return intakeDao.getQuatroIntake(intakeId);
	}

	public QuatroIntakeDB getQuatroIntakeDBByReferralId(Integer referralId) {
		return intakeDao.getQuatroIntakeDBByReferralId(referralId);
	}
	public QuatroIntakeDB getQuatroIntakeDBByIntakeId(Integer intakeId) {
		return intakeDao.getQuatroIntakeDBByIntakeId(intakeId);
	}
	
	public ArrayList saveQuatroIntake(Demographic client, QuatroIntake intake, Integer intakeHeadId, boolean isFamily, Integer fromManualReferralId) {
		clientDao.saveClient(client);
		intake.setClientId(client.getDemographicNo());
		historyDao.saveClientHistory(intake);
		return intakeDao.saveQuatroIntake(intake, intakeHeadId, isFamily, fromManualReferralId);
	}
	public void saveQuatroIntakeFamilyHead(QuatroIntakeFamily intakeFamily) {
		intakeDao.saveQuatroIntakeFamilyRelation(intakeFamily);
	}

	public ArrayList saveQuatroIntakeFamily(boolean familyAdmitted,Demographic client, Integer intakeHeadId, QuatroIntake intake, QuatroIntakeDB exist_intakeDB, QuatroIntakeFamily intakeFamily) {
		ArrayList lst = new ArrayList();
		clientDao.saveClient(client);
		intake.setClientId(client.getDemographicNo());
		if(intake.getId().intValue()==0){
	    	List lst2 = intakeDao.saveQuatroIntake(intake, intakeHeadId, true, null);
			historyDao.saveClientHistory(intake);
		    intakeFamily.setIntakeId((Integer)lst2.get(0));
		}
		if(familyAdmitted)
		{
	    	List admLst = admissionDao.saveAdmission(intake, intakeHeadId);
	    	Admission adm = (Admission) admLst.get(0); 
	    	RoomDemographic rdm = (RoomDemographic) admLst.get(1);
	    	Room rm = roomDAO.getRoom(rdm.getId().getRoomId());
	    	historyDao.saveClientHistory(adm, rm.getName(), null);
		}  
		intakeDao.saveQuatroIntakeFamilyRelation(intakeFamily);
		
		//remove referral# and queue# from old active intake,
		//and set this familily member's intake queue#=0.
		if(exist_intakeDB!=null){
		  Integer exist_intakeDB_referralId = new Integer(0);
		  Integer exist_intakeDB_programQueueId = new Integer(0);
		  ClientReferral exist_intakeDB_referral = clientReferralDAO.getReferralAutoByIntakeId(exist_intakeDB.getId());
		  if(exist_intakeDB_referral!=null) exist_intakeDB_referralId= exist_intakeDB_referral.getId();
		  ProgramQueue exist_intakeDB_programQueue = programQueueDao.getProgramQueueByIntakeId(exist_intakeDB.getId());
		  if(exist_intakeDB_programQueue!=null) exist_intakeDB_programQueueId= exist_intakeDB_programQueue.getId();
		  
		  intakeDao.deleteReferralIdQueueId(exist_intakeDB_referralId, exist_intakeDB_programQueueId);
		}
		
		lst.add(intakeFamily.getIntakeHeadId());
		lst.add(intakeFamily.getIntakeId());
		lst.add(client.getDemographicNo());
		return lst;
	}

	public List getClientsListForServiceProgram(Program program, String firstName, 
			String lastName, String clientId) {
	   return intakeDao.getClientsListForServiceProgram(program, firstName, lastName, clientId);
	}
	
	public ClientDao getClientDao() {
		return clientDao;
	}

	public void setClientDao(ClientDao clientDao) {
		this.clientDao = clientDao;
	}

	public ProgramDao getProgramDao() {
		return programDao;
	}

	public void setProgramDao(ProgramDao programDao) {
		this.programDao = programDao;
	}

	public void setLookupDao(LookupDao lookupDao) {
		this.lookupDao = lookupDao;
	}

	public void setClientReferralDAO(ClientReferralDAO clientReferralDAO) {
		this.clientReferralDAO = clientReferralDAO;
	}

	public void setProgramQueueDao(ProgramQueueDao programQueueDao) {
		this.programQueueDao = programQueueDao;
	}
	public void setRoomDAO(RoomDAO roomDAO) {
		this.roomDAO = roomDAO;
	}

}
