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
package org.oscarehr.PMmodule.service;

import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.oscarehr.PMmodule.dao.AdmissionDao;
import org.oscarehr.PMmodule.dao.BedDAO;
import org.oscarehr.PMmodule.dao.ClientHistoryDao;
import org.oscarehr.PMmodule.dao.ClientReferralDAO;
import org.oscarehr.PMmodule.dao.ProgramDao;
import org.oscarehr.PMmodule.dao.ProgramQueueDao;
import org.oscarehr.PMmodule.dao.RoomDAO;
import org.oscarehr.PMmodule.dao.RoomDemographicDAO;
import org.oscarehr.PMmodule.dao.RoomDemographicHistoricalDao;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.PMmodule.model.Bed;
import org.oscarehr.PMmodule.model.ClientReferral;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.ProgramQueue;
import org.oscarehr.PMmodule.model.QuatroIntake;
import org.oscarehr.PMmodule.model.QuatroIntakeFamily;
import org.oscarehr.PMmodule.model.RoomDemographic;
import org.oscarehr.PMmodule.model.RoomDemographicHistorical;
import org.oscarehr.PMmodule.model.RoomDemographicPK;
import org.oscarehr.PMmodule.web.formbean.ClientForm;
import org.oscarehr.PMmodule.model.Room;

import com.quatro.common.KeyConstants;
import com.quatro.dao.IntakeDao;

public class AdmissionManager {
	private IntakeDao intakeDao;
	private AdmissionDao admissionDao;
	private RoomDAO roomDAO;
	private BedDAO bedDAO;
	private RoomDemographicDAO roomDemographicDAO;
	private ProgramQueueDao programQueueDao;
	private ClientReferralDAO clientReferralDAO;
	private RoomDemographicHistoricalDao roomDemographicHistoricalDao;

	public List getAdmissions(Integer demographicNo,String providerNo, Integer shelterId) {
		return admissionDao.getAdmissionList(demographicNo,false,providerNo, shelterId);
	}
	
	public RoomDemographicHistorical getLatestRoomDemographicHistory(Integer admissionId){
        return roomDemographicHistoricalDao.getLatestRoomDemographicHistory(admissionId);
	}

	private void saveRoomDemographicHistory(Admission admission, RoomDemographic rdm, Calendar currentTime){
        RoomDemographicHistorical history = new RoomDemographicHistorical( rdm.getId().getRoomId(),rdm.getBedId(), admission.getId(), admission.getClientId(), currentTime, null);
        roomDemographicHistoricalDao.saveOrUpdate(history);
	}
	
	private void updateRoomDemographicHistory(Admission admission, RoomDemographic rdm){
        RoomDemographicHistorical history = roomDemographicHistoricalDao.findById(rdm.getId().getRoomId(), admission.getId());
        if(history!=null){
     	   	history.setUsageEnd(Calendar.getInstance());
            roomDemographicHistoricalDao.saveOrUpdate(history);
        }
	}
	public Integer saveAdmission(Admission admission, Integer intakeId, RoomDemographic roomDemographic,  boolean bFamily) {
  	    String roomName = null;
   	    String bedName = null;
   	    Integer admissionId= new Integer(0);

   	    //to set RoomDemographicHistory:usageStart  
    	Calendar cal = Calendar.getInstance();

    	if(bFamily)
    	{
    	   List lstFamily= intakeDao.getClientIntakeFamily(intakeId);
           for(int i=0;i<lstFamily.size();i++){
             QuatroIntakeFamily qif = (QuatroIntakeFamily)lstFamily.get(i);
             RoomDemographic rdm2 = new RoomDemographic();
             RoomDemographicPK rdmPK = new RoomDemographicPK(qif.getClientId(), roomDemographic.getId().getRoomId());
             rdm2.setId(rdmPK);
             rdm2.setProviderNo(roomDemographic.getProviderNo());
             rdm2.setAssignStart(roomDemographic.getAssignStart());
             intakeDao.setIntakeStatusAdmitted(qif.getIntakeId());
   		     Admission admObj =(Admission)admission.clone();
   		     admObj.setClientId(qif.getClientId());
   		     admObj.setIntakeId(qif.getIntakeId());
   		     admissionDao.saveAdmission(admObj, qif.getIntakeId());
   		     
   		     if(admission.getClientId().intValue()==qif.getClientId().intValue()) admissionId=admObj.getId(); 
       	     
 		     //remove old room assignment
   		     rdm2.setAdmissionId(admObj.getId());
   		     RoomDemographic rdm = roomDemographicDAO.getRoomDemographicByDemographic(qif.getClientId());
   		     if(rdm!=null && !rdm.getId().getRoomId().equals(rdm2.getId().getRoomId())){
           	   roomDemographicDAO.deleteRoomDemographic(rdm);
          	   roomDemographicDAO.saveRoomDemographic(rdm2);
      	     }else{
               roomDemographicDAO.saveRoomDemographic(rdm2);
      	     }
             saveRoomDemographicHistory(admObj, roomDemographic, cal);
        	 roomName = roomDAO.getRoom(rdm2.getId().getRoomId()).getName();
             clientHistoryDao.saveClientHistory(admObj, roomName, bedName);
           }
    	}
    	else{
		  intakeDao.setIntakeStatusAdmitted(intakeId);
		  admissionDao.saveAdmission(admission, intakeId);
		  admissionId=admission.getId();
		  
    	  //remove old room/bed assignment
    	  RoomDemographic rdm = roomDemographicDAO.getRoomDemographicByDemographic(admission.getClientId());
          roomDemographic.setAdmissionId(admissionId);
          roomDemographic.setLastUpdateDate(Calendar.getInstance());
          if(roomDemographic.getBedId()!=null && roomDemographic.getBedId().intValue()==0) roomDemographic.setBedId(null);
    	  if(rdm!=null){
    		Integer roomId = rdm.getId().getRoomId();
    		Integer bedId = rdm.getBedId();
    		  
    	    if(!(roomId.equals(roomDemographic.getId().getRoomId()) &&
    	    	((bedId==null && roomDemographic.getBedId()==null) || bedId.equals(roomDemographic.getBedId())))) {
      	      roomDemographicDAO.deleteRoomDemographic(rdm);
     	      roomDemographicDAO.saveRoomDemographic(roomDemographic);
              updateRoomDemographicHistory(admission, rdm);             
    	    }
    	  }else{    		  
       	    roomDemographicDAO.saveRoomDemographic(roomDemographic);
    	  }
     	  roomName = roomDAO.getRoom(roomDemographic.getId().getRoomId()).getName();
      	  if (roomDemographic.getBedId() != null) bedName = bedDAO.getBed(roomDemographic.getBedId()).getName();
          saveRoomDemographicHistory(admission, roomDemographic, cal);
          clientHistoryDao.saveClientHistory(admission,roomName, bedName);
    	}
    	return admissionId;
    }

    public void dischargeAdmission(String admissionIds, String comment) {
    	admissionDao.dischargeAdmission(admissionIds, comment);
    }
    

    public void updateAdmission(Admission admission, RoomDemographic roomDemographic, boolean bFamilyHead) {
    	admissionDao.updateAdmission(admission);
    	
    	//remove old room/bed assignment
    	String roomName=null;
    	String bedName = null;
    	roomDemographic.setAdmissionId(admission.getId());
    	Calendar cal = Calendar.getInstance();

    	if(bFamilyHead){
     	   List lstFamily= intakeDao.getClientIntakeFamily(admission.getIntakeId());
           for(int i=0;i<lstFamily.size();i++){
             QuatroIntakeFamily qif = (QuatroIntakeFamily)lstFamily.get(i);
             RoomDemographic rdm2 = new RoomDemographic();
             RoomDemographicPK rdmPK = new RoomDemographicPK(qif.getClientId(), roomDemographic.getId().getRoomId());
             rdm2.setId(rdmPK);
             rdm2.setProviderNo(roomDemographic.getProviderNo());
             rdm2.setAssignStart(roomDemographic.getAssignStart());
             intakeDao.setIntakeStatusAdmitted(qif.getIntakeId());
   		     Admission admObj =admissionDao.getAdmissionByIntakeId(qif.getIntakeId());
//   		     admObj.setClientId(qif.getClientId());
//   		     admObj.setIntakeId(qif.getIntakeId());
//   		     admissionDao.saveAdmission(admObj, qif.getIntakeId());
   		     
//   		     if(admission.getClientId().intValue()==qif.getClientId().intValue()) admissionId=admObj.getId(); 
       	     
 		     //remove old room assignment
   		     rdm2.setAdmissionId(admObj.getId());
   		     RoomDemographic rdm = roomDemographicDAO.getRoomDemographicByDemographic(qif.getClientId());
   		     if(rdm!=null && !rdm.getId().getRoomId().equals(rdm2.getId().getRoomId())){
           	   roomDemographicDAO.deleteRoomDemographic(rdm);
          	   roomDemographicDAO.saveRoomDemographic(rdm2);
               updateRoomDemographicHistory(admObj, rdm);
               saveRoomDemographicHistory(admObj, rdm2, cal);
      	     }else{
               roomDemographicDAO.saveRoomDemographic(rdm2);
               saveRoomDemographicHistory(admObj, rdm2, cal);
      	     }
        	 roomName = roomDAO.getRoom(rdm2.getId().getRoomId()).getName();
             clientHistoryDao.saveClientHistory(admObj, roomName, bedName);
             
           }    		
           
    	}else{
    	  RoomDemographic rdm = roomDemographicDAO.getRoomDemographicByDemographic(roomDemographic.getId().getDemographicNo());
  	      if(rdm!=null){
  	        Integer roomId = rdm.getId().getRoomId();
  	        Integer bedId = rdm.getBedId();
	        if(!( roomId.equals(roomDemographic.getId().getRoomId()) &&
  	      	  ((bedId==null && roomDemographic.getBedId()==null) || roomDemographic.getBedId().equals(bedId)))) {
  	      
	    	  roomDemographicDAO.deleteRoomDemographic(rdm);
  	       	  roomDemographicDAO.saveRoomDemographic(roomDemographic);
              updateRoomDemographicHistory(admission, rdm);
              saveRoomDemographicHistory(admission, roomDemographic, cal);
  	        }
  	      }else{
  	    	roomDemographicDAO.saveRoomDemographic(roomDemographic);
            saveRoomDemographicHistory(admission, roomDemographic, cal);            
  	      }
  	      rdm = roomDemographicDAO.getRoomDemographicByDemographic(roomDemographic.getId().getDemographicNo());
//   	      roomName = rdm.getRoomName();
//   	      bedName = rdm.getBedName();
     	  roomName = roomDAO.getRoom(rdm.getId().getRoomId()).getName();
      	  if (rdm.getBedId() != null) bedName = bedDAO.getBed(rdm.getBedId()).getName();
  	      clientHistoryDao.saveClientHistory(admission, roomName, bedName);
    	}
    }

    public void setAdmissionDao(AdmissionDao admissionDao) {
		this.admissionDao = admissionDao;
	}
	
	public List getAdmissionListByProgram(Integer programId) {
		return admissionDao.getAdmissionListByProgram(programId);
	}

	public List getClientsListForBedProgram(Program program, ClientForm form) {
	   return admissionDao.getClientsListForBedProgram(program, form);
	}
	
    public Admission getAdmissionByIntakeId(Integer intakeId){
		return admissionDao.getAdmissionByIntakeId(intakeId);
    }

    public Admission getAdmissionByAdmissionId(Integer admissionId){
		return admissionDao.getAdmissionByAdmissionId(admissionId);
    }
    
    public List getCurrentAdmissions(Integer demographicNo, String providerNo,Integer shelterId) {
		return admissionDao.getCurrentAdmissions(demographicNo,providerNo, shelterId);
    }

	public void setRoomDemographicDAO(RoomDemographicDAO roomDemographicDao) {
		this.roomDemographicDAO = roomDemographicDao;
	}

	public void setIntakeDao(IntakeDao intakeDao) {
		this.intakeDao = intakeDao;
	}

	public Admission getRecentAdmissions(Integer clientId,String providerNo,Integer shelterId){
		return admissionDao.getRecentAdmission(clientId, providerNo, shelterId);
	}
	
	public Admission getCurrentBedProgramAdmission(Integer demographicNo) {
		return admissionDao.getCurrentBedProgramAdmission(demographicNo);
	}
	
	public List getCurrentAdmissionsByProgramId(String programId) {
		return admissionDao.getCurrentAdmissionsByProgramId(Integer.valueOf(programId));
	}
	
    public Admission getAdmission(Integer id) {
		return admissionDao.getAdmission(id);
	}
  
  public void dischargeAdmission(Admission admission, boolean isReferral, List lstFamily){
	 try{
	  admissionDao.updateDischargeInfo(admission);
       clientHistoryDao.saveClientHistory(admission,null,null);

	   RoomDemographic rdm = roomDemographicDAO.getRoomDemographicByDemographic(admission.getClientId());
	   if(rdm!=null) {
		   roomDemographicDAO.deleteRoomDemographic(rdm);
      	   // update room_history
           updateRoomDemographicHistory(admission, rdm);
	   }
	   if(lstFamily!=null){
		 Iterator item = lstFamily.iterator();
		 while(item.hasNext()){
			QuatroIntakeFamily qifTmp = (QuatroIntakeFamily)item.next();
			Admission admLoc =admissionDao.getAdmissionByIntakeId(qifTmp.getIntakeId());
			if(admLoc != null && admLoc.getId().intValue()!=admission.getId().intValue()){ 
				admLoc.setAdmissionStatus(KeyConstants.INTAKE_STATUS_DISCHARGED);
				admLoc.setDischargeDate(Calendar.getInstance());
			  	admLoc.setDischargeNotes(admission.getDischargeNotes());			  	
				admLoc.setCommunityProgramCode(admission.getCommunityProgramCode());
				admLoc.setDischargeReason(admission.getDischargeReason());
				admLoc.setTransportationType(admission.getTransportationType());
			  	admissionDao.updateDischargeInfo(admLoc);
				RoomDemographic rdm2 = roomDemographicDAO.getRoomDemographicByDemographic(admLoc.getClientId());
				if(rdm2!=null){ 
					roomDemographicDAO.deleteRoomDemographic(rdm2);
		      	   // update room_history
		           updateRoomDemographicHistory(admission, rdm);
				}
		        clientHistoryDao.saveClientHistory(admLoc,null,null);
			}
		 }
	   }
	  
	  if(isReferral){
		ClientReferral referral= clientReferralDAO.getReferralsByProgramId(admission.getClientId(), admission.getProgramId());
		ProgramQueue queue = programQueueDao.getQueue(admission.getProgramId(), admission.getClientId());
		if(referral==null){
		  referral = new ClientReferral();
		  referral.setClientId(admission.getClientId());
		  referral.setNotes("Discharge Automated referral");
		  referral.setProgramId(admission.getProgramId());
		  referral.setFromProgramId(admission.getProgramId());
		  referral.setProviderNo(admission.getProviderNo());
		  referral.setReferralDate(Calendar.getInstance());
		  referral.setStatus(KeyConstants.STATUS_PENDING);
		  referral.setAutoManual(KeyConstants.AUTOMATIC);
	      clientReferralDAO.saveClientReferral(referral);
	      if(queue!=null) programQueueDao.delete(queue);
		  queue = new ProgramQueue();
	      queue.setClientId(referral.getClientId());
	      queue.setNotes(referral.getNotes());
	      queue.setProgramId(referral.getProgramId());
		  queue.setProviderNo(Integer.valueOf(referral.getProviderNo()));
		  queue.setReferralDate(referral.getReferralDate().getTime());
	      queue.setReferralId(referral.getId());
	      queue.setPresentProblems(referral.getPresentProblems());
		  queue.setReferralId(referral.getId());
		  programQueueDao.saveProgramQueue(queue);
		}else{
		  if(queue==null){
		    queue = new ProgramQueue();
            queue.setClientId(referral.getClientId());
            queue.setNotes(referral.getNotes());
            queue.setProgramId(referral.getProgramId());
		    queue.setProviderNo(Integer.valueOf(referral.getProviderNo()));
		    queue.setReferralDate(referral.getReferralDate().getTime());
            queue.setReferralId(referral.getId());
            queue.setPresentProblems(referral.getPresentProblems());
	        queue.setReferralId(referral.getId());
	        programQueueDao.saveProgramQueue(queue);
		  }
		}
	  }
	 }catch(Exception ex){
		 String a =ex.getMessage();
	 }
  }
  
    public void setClientReferralDAO(ClientReferralDAO clientReferralDAO) {
	  this.clientReferralDAO = clientReferralDAO;
    }

    public void setProgramQueueDao(ProgramQueueDao programQueueDao) {
	  this.programQueueDao = programQueueDao;
    }
    private ClientHistoryDao clientHistoryDao;
	public void setClientHistoryDao(ClientHistoryDao clientHistoryDao) {
		this.clientHistoryDao = clientHistoryDao;
	}


	public ClientReferralDAO getClientReferralDAO() {
		return clientReferralDAO;
	}


	public void setRoomDemographicHistoricalDao(
			RoomDemographicHistoricalDao roomDemographicHistoricalDao) {
		this.roomDemographicHistoricalDao = roomDemographicHistoricalDao;
	}

	public void setRoomDAO(RoomDAO roomDAO) {
		this.roomDAO = roomDAO;
	}
	public void setBedDAO(BedDAO bedDAO) {
		this.bedDAO = bedDAO;
	}
 }
