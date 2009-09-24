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
package org.oscarehr.PMmodule.service;

import java.util.Calendar;
import java.util.List;

import org.oscarehr.PMmodule.dao.ClientDao;
import org.oscarehr.PMmodule.dao.ProgramDao;
import org.oscarehr.PMmodule.dao.ProgramOccupancyDao;
import org.oscarehr.PMmodule.dao.ProgramQueueDao;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.SdmtIn;

public class ProgramOccupancyManager {
	
	private ProgramOccupancyDao  programOccupancyDao;	
	private ClientDao clientDao;	
	private ProgramQueueDao programQueueDao;
	public void insertProgramOccupancy(String providerNo,Calendar occDate) {
		programOccupancyDao.insertProgramOccupancy(providerNo, occDate);
	}
	public void deleteProgramOccupancy(Calendar occDate) {
		programOccupancyDao.deleteProgramOccupancy(occDate);
	}
	public void insertSdmtOut(){
		 programOccupancyDao.insertSdmtOut();
	 }
	
	public void setProgramOccupancyDao(ProgramOccupancyDao programOccupancyDao) {
		this.programOccupancyDao = programOccupancyDao;
	}
	public List getSdmtOutList(Calendar today,boolean includeSendout){
		return programOccupancyDao.getSdmtOutList(today, includeSendout);
	}
	public void updateSdmtOut(int batchNo){
		programOccupancyDao.updateSdmtOut(batchNo);
	}
	 public void insertSdmtIn(SdmtIn sdVal){
		 programOccupancyDao.insertSdmtIn(sdVal);
		 Demographic client=new Demographic();
		 client.setDemographicNo(sdVal.getClientId());
		 client.setBenefitUnitStatus(sdVal.getBenefitUnitStatus());
		 client.setHin(sdVal.getSdmtBenUnitId().toString()); 
		 client.setPin(sdVal.getMemberId().toString());  //sdmt member id
		 clientDao.updateClientBenUnitStatus(client);
	 }
	 public void DeactiveServiceIntake(){
		 programOccupancyDao.deactiveServiceProgram();
	 }
	 public void DeactiveBedIntake(){
		 programOccupancyDao.deactiveBedProgram();
	 }
	public void setClientDao(ClientDao clientDao) {
		this.clientDao = clientDao;
	}
	public void setProgramQueueDao(ProgramQueueDao programQueueDao) {
		this.programQueueDao = programQueueDao;
	}
	
	
}
