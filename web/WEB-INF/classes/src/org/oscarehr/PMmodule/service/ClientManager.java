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

package org.oscarehr.PMmodule.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;


import org.oscarehr.PMmodule.dao.ClientDao;
import org.oscarehr.PMmodule.dao.ClientHistoryDao;
import org.oscarehr.PMmodule.dao.ClientReferralDAO;
import org.oscarehr.PMmodule.dao.ProgramDao;
import org.oscarehr.PMmodule.dao.ProgramQueueDao;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.PMmodule.model.ClientReferral;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.DemographicExt;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.ProgramClientRestriction;
import org.oscarehr.PMmodule.model.ProgramQueue;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.web.formbean.ClientSearchFormBean;
import org.oscarehr.PMmodule.dao.AdmissionDao;
import com.quatro.common.KeyConstants;
import com.quatro.dao.IntakeDao;
import com.quatro.dao.LookupDao;

public class ClientManager {

    private ClientDao dao;
    private ClientHistoryDao clientHistoryDao;
    private ClientReferralDAO referralDAO;
    private ProgramQueueDao queueDao; 
    private AdmissionDao admissionDao;
    private IntakeDao intakeDao;   
    private ProgramDao programDao;
    private LookupDao lookupDao;
    
    private boolean outsideOfDomainEnabled;

    public boolean isOutsideOfDomainEnabled() {
        return outsideOfDomainEnabled;
    }

    public Demographic getClientByDemographicNo(String demographicNo) {
        if (demographicNo == null || demographicNo.length() == 0) {
            return null;
        }
        return dao.getClientByDemographicNo(Integer.valueOf(demographicNo));
    }

    public List getClients() {
        return dao.getClients();
    }
    public Admission getCurrentAdmission(Integer clientId,String providerNo,Integer shelterId) {
    	List lstAdm= admissionDao.getCurrentAdmissions(clientId, providerNo, shelterId);
    	Admission admission=null;
    	if(lstAdm.size()>0)admission=(Admission)lstAdm.get(0);
    	return admission;
    }
    public List search(ClientSearchFormBean criteria, boolean returnOptinsOnly,boolean excludeMerged) {
        return dao.search(criteria, returnOptinsOnly,excludeMerged);
    }
    
	public List getIntakeByFacility(Integer demographicNo, Integer shelterId){
		return dao.getIntakeByShelter(demographicNo, shelterId);
	}

    public List getRecentProgramIds(Integer clientId, String providerNo, Integer shelterId){
    	return dao.getRecentProgramIds(clientId, providerNo, shelterId);
    }
    public Integer getRecentProgramId(Integer clientId, String providerNo, Integer shelterId){
    	return dao.getRecentProgramId(clientId, providerNo, shelterId);
    }

/*    
    public List getReferrals() {
        return referralDAO.getReferrals();
    }
*/
    public List getReferrals(String clientId,String providerNo,Integer shelterId) {
        return referralDAO.getReferrals(Integer.valueOf(clientId),providerNo,shelterId);
    }

    public List getManualReferrals(String clientId,String providerNo,Integer shelterId) {
        return referralDAO.getManualReferrals(Integer.valueOf(clientId),providerNo,shelterId);
    }
    
    public List getActiveReferrals(String clientId,String providerNo, Integer shelterId) {
        List results = referralDAO.getActiveReferrals(Integer.valueOf(clientId),providerNo, shelterId);

        return results;
    }

	public List getActiveManualReferrals(String clientId,String providerNo, Integer shelterId) {
        List results = referralDAO.getActiveManualReferrals(Integer.valueOf(clientId),providerNo, shelterId);
        return results;
    }


    public ClientReferral getClientReferral(String id) {
        return referralDAO.getClientReferral(Integer.valueOf(id));
    }
    public List getProgramLookups(Integer clientId, Integer shelterId, String providerNo)throws SQLException {
		
		String progIds = "";
		List programs =new ArrayList();
		List intakes=intakeDao.getActiveQuatroIntakeHeaderListByFacility(clientId, shelterId,providerNo);		
		if(!intakes.isEmpty()){
			for(int i=0;i<intakes.size();i++)
			{
				QuatroIntakeHeader intakeTmp =(QuatroIntakeHeader)intakes.get(i);
				Program program=programDao.getProgram(intakeTmp.getProgramId());
				if(KeyConstants.PROGRAM_TYPE_Bed.equals(program.getType())){
					  progIds +=intakeTmp.getProgramId() + ",";
				}
				else if(KeyConstants.PROGRAM_TYPE_Service.equals(program.getType()) 
						&& (intakeTmp.getEndDate()==null ||
					(intakeTmp.getEndDate()!=null && intakeTmp.getEndDate().after(Calendar.getInstance()))))
					progIds+=intakeTmp.getProgramId()+",";				
			}
		}
		if(progIds.endsWith(",")) progIds=progIds.substring(0,progIds.length()-1);
		programs = lookupDao.LoadCodeList("PRO", true, progIds, null);
		return programs;
	}
    public void saveClientReferral(ClientReferral referral) {

        referralDAO.saveClientReferral(referral);

        //don't create new queue if referral Id>0
        if (referral.getStatus().equalsIgnoreCase(KeyConstants.STATUS_PENDING )){
          ProgramQueue queue;
          if(referral.getId().intValue()==0) {
            queue = new ProgramQueue();
            queue.setClientId(referral.getClientId());
            queue.setNotes(referral.getNotes());
            queue.setProgramId(referral.getProgramId());
            queue.setProviderNo(Integer.valueOf(referral.getProviderNo()));
            queue.setReferralDate(referral.getReferralDate().getTime());
            queue.setReferralId(referral.getId());
            queue.setPresentProblems(referral.getPresentProblems());
          }else{
        	queue = queueDao.getProgramQueueByReferralId(referral.getId());
        	if(queue == null){
               queue = new ProgramQueue();
               queue.setClientId(referral.getClientId());
               queue.setNotes(referral.getNotes());
               queue.setProgramId(referral.getProgramId());
               queue.setProviderNo(Integer.valueOf(referral.getProviderNo()));
               queue.setReferralDate(referral.getReferralDate().getTime());
               queue.setReferralId(referral.getId());
               queue.setPresentProblems(referral.getPresentProblems());
        	}else{
               queue.setClientId(referral.getClientId());
               queue.setNotes(referral.getNotes());
               queue.setProgramId(referral.getProgramId());
               queue.setProviderNo(Integer.valueOf(referral.getProviderNo()));
               queue.setReferralDate(referral.getReferralDate().getTime());
               queue.setReferralId(referral.getId());
               queue.setPresentProblems(referral.getPresentProblems());
        	}
          }
          queueDao.saveProgramQueue(queue);
        }
        
        clientHistoryDao.saveClientHistory(referral);
    }

    public List searchReferrals(ClientReferral referral) {
        return referralDAO.search(referral);
    }
    
    public ClientReferral getClientReferralAutoByIntake(Integer intakeId){
    	return referralDAO.getReferralAutoByIntakeId(intakeId);
    }

/*    
    public void processReferral(ClientReferral referral) throws AlreadyAdmittedException, AlreadyQueuedException, ServiceRestrictionException {
        processReferral(referral, false);
    }

    public void processReferral(ClientReferral referral, boolean override) throws AlreadyAdmittedException, AlreadyQueuedException, ServiceRestrictionException {
        if (!override) {
            // check if there's a service restriction in place on this individual for this program
            ProgramClientRestriction restrInPlace = clientRestrictionManager.checkClientRestriction(referral.getProgramId().intValue(), referral.getClientId().intValue(), new Date());
            if (restrInPlace != null) {
                throw new ServiceRestrictionException("service restriction in place", restrInPlace);
            }
        }

        Admission currentAdmission = admissionManager.getCurrentAdmission(String.valueOf(referral.getProgramId()), referral.getClientId().intValue());
        if (currentAdmission != null) {
            referral.setStatus(KeyConstants.STATUS_REJECTED);
            referral.setCompletionNotes("Client currently admitted");
            referral.setCompletionDate(new Date());

            saveClientReferral(referral);
            throw new AlreadyAdmittedException();
        }

        ProgramQueue queue = queueManager.getActiveProgramQueue(String.valueOf(referral.getProgramId()), String.valueOf(referral.getClientId()));
        if (queue != null) {
            referral.setStatus(KeyConstants.STATUS_REJECTED);
            referral.setCompletionNotes("Client already in queue");
            referral.setCompletionDate(new Date());

            saveClientReferral(referral);
            throw new AlreadyQueuedException();
        }

        saveClientReferral(referral);
        List<JointAdmission> dependents = getDependents(referral.getClientId());
        for (JointAdmission jadm : dependents) {
            referral.setClientId(jadm.getClientId());
            saveClientReferral(referral);
        }

    }
*/
    
    public void saveClient(Demographic client) {
        dao.saveClient(client);
    }

    public DemographicExt getDemographicExt(String id) {
        return dao.getDemographicExt(Integer.valueOf(id));
    }

    public List getDemographicExtByDemographicNo(int demographicNo) {
        return dao.getDemographicExtByDemographicNo(new Integer(demographicNo));
    }

    public DemographicExt getDemographicExt(int demographicNo, String key) {
        return dao.getDemographicExt(new Integer(demographicNo), key);
    }

    public void updateDemographicExt(DemographicExt de) {
        dao.updateDemographicExt(de);
    }

    public void saveDemographicExt(int demographicNo, String key, String value) {
        dao.saveDemographicExt(new Integer(demographicNo), key, value);
    }

    public void removeDemographicExt(String id) {
        dao.removeDemographicExt(Integer.valueOf(id));
    }

    public void removeDemographicExt(int demographicNo, String key) {
        dao.removeDemographicExt(new Integer(demographicNo), key);
    }

    //@Required
    public void setClientDao(ClientDao dao) {
        this.dao = dao;
    }

    //@Required
    public void setClientReferralDAO(ClientReferralDAO dao) {
        this.referralDAO = dao;
    }

    //@Required
    public void setProgramQueueDao(ProgramQueueDao mgr) {
        this.queueDao = mgr;
    }   

    //@Required
    public void setOutsideOfDomainEnabled(boolean outsideOfDomainEnabled) {
        this.outsideOfDomainEnabled = outsideOfDomainEnabled;
    }

	public void setClientHistoryDao(ClientHistoryDao clientHistoryDao) {
		this.clientHistoryDao = clientHistoryDao;
	}

	public void setAdmissionDao(AdmissionDao admissionDao) {
		this.admissionDao = admissionDao;
	}

	public void setIntakeDao(IntakeDao intakeDao) {
		this.intakeDao = intakeDao;
	}

	public void setProgramDao(ProgramDao programDao) {
		this.programDao = programDao;
	}

	public void setLookupDao(LookupDao lookupDao) {
		this.lookupDao = lookupDao;
	}

}
