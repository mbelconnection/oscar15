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

package org.oscarehr.PMmodule.service.impl;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.oscarehr.PMmodule.dao.ClientReferralDAO;
import org.oscarehr.PMmodule.dao.ProgramQueueDao;
import org.oscarehr.PMmodule.model.ClientReferral;
import org.oscarehr.PMmodule.model.ProgramQueue;
import org.oscarehr.PMmodule.model.QuatroIntakeDB;
import org.oscarehr.PMmodule.service.ProgramQueueManager;
import com.quatro.dao.IntakeDao;

import com.quatro.common.KeyConstants;
import org.oscarehr.PMmodule.model.QuatroIntakeFamily;

public class ProgramQueueManagerImpl implements ProgramQueueManager
{
	private static Log log = LogFactory.getLog(ProgramQueueManagerImpl.class);
	private ProgramQueueDao dao;
	private ClientReferralDAO referralDAO;
	private IntakeDao intakeDao;
	
	
	public void setProgramQueueDao(ProgramQueueDao dao)	{
		this.dao = dao;
	}
	
	public void setClientReferralDAO(ClientReferralDAO dao)	{
		this.referralDAO = dao;
	}
	
	public ProgramQueue getProgramQueue(String queueId)
	{
		ProgramQueue pq = dao.getProgramQueue(Integer.valueOf(queueId));
		if(pq == null)
		{
//			log.warn("queueId '" + queueId + "' not found in database.");			
		}
		return pq;
	}
	
	public ProgramQueue getProgramQueuesByIntakeId(Integer intakeId) {
		return dao.getProgramQueueByIntakeId(intakeId);
	}

	public List getProgramQueuesByProgramId(Integer programId) {
		return dao.getProgramQueuesByProgramId(programId);
	}

	public List getProgramQueuesByClientIdProgramId(Integer clientId, Integer programId) {
		return dao.getProgramQueuesByClientIdProgramId(clientId, programId);
	}

	public ProgramQueue getProgramQueueByReferralId(Integer referralId) {
		return dao.getProgramQueueByReferralId(referralId);
	}

	public List getProgramQueuesByClientId(Integer clientId) {
		return dao.getProgramQueuesByClientId(clientId);
	}
	
	public void saveProgramQueue(ProgramQueue programQueue)	{
		dao.saveProgramQueue(programQueue);
	}

	public void rejectQueue(Integer queueId, String notes, String rejectionReason) {
		ProgramQueue queue = getProgramQueue(queueId.toString());
		if(queue==null) {
			return;
		}

		ClientReferral referral = this.referralDAO.getClientReferral(queue.getReferralId());
		if(referral != null) {
			referral.setStatus(KeyConstants.STATUS_REJECTED);
			referral.setCompletionDate(java.util.Calendar.getInstance());
			referral.setCompletionNotes(notes);			
			referral.setRejectionReason(rejectionReason);			
			this.referralDAO.saveClientReferral(referral);
		}
		if(KeyConstants.AUTOMATIC.equals(referral.getAutoManual())){
	        QuatroIntakeDB intakeDB =  intakeDao.getQuatroIntakeDBByReferralId(referral.getId());
	        if(intakeDB!=null){
	          List familyList = intakeDao.getClientIntakeFamily(intakeDB.getId());
			  if(familyList.size()==0){
	            dao.setIntakeRejectStatus(intakeDB.getId().toString());
			  }else{
			    String sIntakeIds = "";	
			    for(int i=0;i<familyList.size();i++){
				   QuatroIntakeFamily qif = (QuatroIntakeFamily)familyList.get(i); 
				   sIntakeIds = sIntakeIds +  "," + qif.getIntakeId().toString();  
			    }
		        dao.setIntakeRejectStatus(sIntakeIds.substring(1));
			  }
	        }
		}

		dao.delete(queue);
	}

	public void setIntakeDao(IntakeDao intakeDao) {
		this.intakeDao = intakeDao;
	}
}
