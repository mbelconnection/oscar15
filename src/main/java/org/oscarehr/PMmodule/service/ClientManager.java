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
 * Toronto, Ontario, Canada 
 */

package org.oscarehr.PMmodule.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.oscarehr.PMmodule.dao.ClientDao;
import org.oscarehr.PMmodule.dao.ClientReferralDAO;
import org.oscarehr.PMmodule.dao.JointAdmissionDAO;
import org.oscarehr.PMmodule.exception.AlreadyAdmittedException;
import org.oscarehr.PMmodule.exception.AlreadyQueuedException;
import org.oscarehr.PMmodule.exception.ServiceRestrictionException;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.PMmodule.model.ClientReferral;
import org.oscarehr.PMmodule.model.JointAdmission;
import org.oscarehr.PMmodule.model.ProgramClientRestriction;
import org.oscarehr.PMmodule.model.ProgramQueue;
import org.oscarehr.PMmodule.web.formbean.ClientSearchFormBean;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.DemographicExt;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public class ClientManager {

    private ClientDao dao;
    private ClientReferralDAO referralDAO;
    private JointAdmissionDAO jointAdmissionDAO;
    private ProgramQueueManager queueManager;
    private AdmissionManager admissionManager;
    private ClientRestrictionManager clientRestrictionManager;

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

    public List<Demographic> getClients() {
        return dao.getClients();
    }

    public List search(ClientSearchFormBean criteria, boolean returnOptinsOnly,boolean excludeMerged) {
        return dao.search(criteria, returnOptinsOnly,excludeMerged);
    }
    public List<Demographic> search(ClientSearchFormBean criteria) {
        return dao.search(criteria);
    }

    public java.util.Date getMostRecentIntakeADate(String demographicNo) {
        return dao.getMostRecentIntakeADate(Integer.valueOf(demographicNo));
    }

    public java.util.Date getMostRecentIntakeCDate(String demographicNo) {
        return dao.getMostRecentIntakeCDate(Integer.valueOf(demographicNo));
    }

    public String getMostRecentIntakeAProvider(String demographicNo) {
        return dao.getMostRecentIntakeAProvider(Integer.valueOf(demographicNo));
    }

    public String getMostRecentIntakeCProvider(String demographicNo) {
        return dao.getMostRecentIntakeCProvider(Integer.valueOf(demographicNo));
    }

    public List<ClientReferral> getReferrals() {
        return referralDAO.getReferrals();
    }

    public List<ClientReferral> getReferrals(String clientId) {
        return referralDAO.getReferrals(Long.valueOf(clientId));
    }

    public List<ClientReferral> getReferralsByFacility(Integer clientId, Integer facilityId) {
        return referralDAO.getReferralsByFacility(clientId.longValue(), facilityId);
    }

    public List<ClientReferral> getActiveReferrals(String clientId, String sourceFacilityId) {
        List<ClientReferral> results = referralDAO.getActiveReferrals(Long.valueOf(clientId), Integer.parseInt(sourceFacilityId));

        return results;
    }

    public ClientReferral getClientReferral(String id) {
        return referralDAO.getClientReferral(Long.valueOf(id));
    }

    /*
     * This should always be a new one. add the queue to the program.
     */
    public void saveClientReferral(ClientReferral referral) {

        referralDAO.saveClientReferral(referral);

        if (referral.getStatus().equalsIgnoreCase(ClientReferral.STATUS_ACTIVE)) {
            ProgramQueue queue = new ProgramQueue();
            queue.setClientId(referral.getClientId());
            queue.setNotes(referral.getNotes());
            queue.setProgramId(referral.getProgramId());
            queue.setProviderNo(Long.parseLong(referral.getProviderNo()));
            queue.setReferralDate(referral.getReferralDate());
            queue.setStatus(ProgramQueue.STATUS_ACTIVE);
            queue.setReferralId(referral.getId());
            queue.setTemporaryAdmission(referral.isTemporaryAdmission());
            queue.setPresentProblems(referral.getPresentProblems());

            queueManager.saveProgramQueue(queue);
        }
    }

    public List searchReferrals(ClientReferral referral) {
        return referralDAO.search(referral);
    }

    public void saveJointAdmission(JointAdmission admission) {
        if (admission == null) {
            throw new IllegalArgumentException();
        }

        jointAdmissionDAO.saveJointAdmission(admission);
    }

    public List<JointAdmission> getDependents(Long clientId) {
        return jointAdmissionDAO.getSpouseAndDependents(clientId);
    }

    public List<Long> getDependentsList(Long clientId) {
        List<Long> list = new ArrayList();
        List<JointAdmission> jadms = jointAdmissionDAO.getSpouseAndDependents(clientId);
        for (JointAdmission jadm : jadms) {
            list.add(jadm.getClientId());
        }
        return list;
    }

    public JointAdmission getJointAdmission(Long clientId) {
        return jointAdmissionDAO.getJointAdmission(clientId);
    }

    public boolean isClientDependentOfFamily(Integer clientId){
		
		JointAdmission clientsJadm = null;
		if(clientId != null){
			clientsJadm = getJointAdmission(Long.valueOf(clientId.toString()));
		}
		if (clientsJadm != null  &&  clientsJadm.getHeadClientId() != null) {
			return true;
		}
		return false;
    }
    
    
    public boolean isClientFamilyHead(Integer clientId){
		
		List<JointAdmission> dependentList = getDependents(Long.valueOf(clientId.toString()));
		if(dependentList != null  &&  dependentList.size() > 0){
			return true;
		}
		return false;
    }
    
    public void removeJointAdmission(Long clientId, String providerNo) {
        jointAdmissionDAO.removeJointAdmission(clientId, providerNo);
    }

    public void removeJointAdmission(JointAdmission admission) {
        jointAdmissionDAO.removeJointAdmission(admission);
    }

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
            referral.setStatus(ClientReferral.STATUS_REJECTED);
            referral.setCompletionNotes("Client currently admitted");
            referral.setCompletionDate(new Date());

            saveClientReferral(referral);
            throw new AlreadyAdmittedException();
        }

        ProgramQueue queue = queueManager.getActiveProgramQueue(String.valueOf(referral.getProgramId()), String.valueOf(referral.getClientId()));
        if (queue != null) {
            referral.setStatus(ClientReferral.STATUS_REJECTED);
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

    public void saveClient(Demographic client) {
        dao.saveClient(client);
    }

    public DemographicExt getDemographicExt(String id) {
        return dao.getDemographicExt(Integer.valueOf(id));
    }

    public List<DemographicExt> getDemographicExtByDemographicNo(int demographicNo) {
        return dao.getDemographicExtByDemographicNo(demographicNo);
    }

    public DemographicExt getDemographicExt(int demographicNo, String key) {
        return dao.getDemographicExt(demographicNo, key);
    }

    public void updateDemographicExt(DemographicExt de) {
        dao.updateDemographicExt(de);
    }

    public void saveDemographicExt(int demographicNo, String key, String value) {
        dao.saveDemographicExt(demographicNo, key, value);
    }

    public void removeDemographicExt(String id) {
        dao.removeDemographicExt(Integer.valueOf(id));
    }

    public void removeDemographicExt(int demographicNo, String key) {
        dao.removeDemographicExt(demographicNo, key);
    }

    public void setJointAdmissionDAO(JointAdmissionDAO jointAdmissionDAO) {
        this.jointAdmissionDAO = jointAdmissionDAO;
    }

    // public JointAdmission getJointAdmission(Long demoLong) {
    // return jointAdmissionDAO.getJointAdmission(demoLong);
    // }

    @Required
    public void setClientDao(ClientDao dao) {
        this.dao = dao;
    }

    @Required
    public void setClientReferralDAO(ClientReferralDAO dao) {
        this.referralDAO = dao;
    }

    @Required
    public void setProgramQueueManager(ProgramQueueManager mgr) {
        this.queueManager = mgr;
    }

    @Required
    public void setAdmissionManager(AdmissionManager mgr) {
        this.admissionManager = mgr;
    }

    @Required
    public void setClientRestrictionManager(ClientRestrictionManager clientRestrictionManager) {
        this.clientRestrictionManager = clientRestrictionManager;
    }

    @Required
    public void setOutsideOfDomainEnabled(boolean outsideOfDomainEnabled) {
        this.outsideOfDomainEnabled = outsideOfDomainEnabled;
    }

        
	public boolean checkHealthCardExists(String hin, String hcType) {
	   List<Demographic> results = this.dao.searchByHealthCard(hin,hcType);            
	   return (results.size()>0)?true:false;
	}
}