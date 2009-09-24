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

import java.util.Calendar;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.oscarehr.PMmodule.dao.AdmissionDao;
import org.oscarehr.PMmodule.dao.ProgramClientStatusDAO;
import org.oscarehr.PMmodule.dao.ProgramDao;
import org.oscarehr.PMmodule.dao.ProgramFunctionalUserDAO;
import org.oscarehr.PMmodule.dao.ProgramSignatureDao;
import org.oscarehr.PMmodule.model.FunctionalUserType;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.ProgramClientStatus;
import org.oscarehr.PMmodule.model.ProgramFunctionalUser;
import org.oscarehr.PMmodule.model.ProgramSignature;
import org.oscarehr.PMmodule.web.formbean.StaffForm;

import com.quatro.dao.LookupDao;
import com.quatro.dao.ORGDao;
import com.quatro.dao.security.SecuserroleDao;
import com.quatro.model.security.Secuserrole;

import org.caisi.dao.TicklerDAO;
import org.caisi.model.Tickler;

public class ProgramManager {

    private static Log log = LogFactory.getLog(ProgramManager.class);

    private ProgramDao programDao;
    private ProgramFunctionalUserDAO programFunctionalUserDAO;
    private AdmissionDao admissionDao;
    private ProgramClientStatusDAO clientStatusDAO;
    private ProgramSignatureDao programSignatureDao;
    private LookupDao lookupDao;
    private SecuserroleDao secuserroleDao;
    private ORGDao orgDao;
    private TicklerDAO ticklerDAO;
    
    private boolean enabled;

    public boolean getEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public ProgramSignatureDao getProgramSignatureDao() {
        return programSignatureDao;
    }

    public void setProgramSignatureDao(ProgramSignatureDao programSignatureDao) {
        this.programSignatureDao = programSignatureDao;
    }

    public void setProgramDao(ProgramDao dao) {
        this.programDao = dao;
    }

    public void setProgramFunctionalUserDAO(ProgramFunctionalUserDAO dao) {
        this.programFunctionalUserDAO = dao;
    }

    public void setAdmissionDao(AdmissionDao dao) {
        this.admissionDao = dao;
    }

    public void setProgramClientStatusDAO(ProgramClientStatusDAO dao) {
        this.clientStatusDAO = dao;
    }

    public void setLookupDao(LookupDao dao) {
        this.lookupDao = dao;
    }

    public Program getProgram(String programId) {
        return programDao.getProgram(Integer.valueOf(programId));
    }

    public Program getProgram(Integer programId) {
        return programDao.getProgram(programId);
    }

    public String getProgramName(String programId) {
        return programDao.getProgramName(Integer.valueOf(programId));
    }

    public List getAllPrograms(String programStatus, String type, Integer facilityId,String providerNo, Integer shelterId) {
        return programDao.getAllPrograms(programStatus, type,facilityId,providerNo, shelterId);
    }

    public List getBedProgramsInFacility(String providerNo, Integer facilityId) {
        return programDao.getBedProgramsInFacility(providerNo, facilityId);
    }
    
    public List getProgramsInFacility(String providerNo, Integer facilityId) {
        return programDao.getProgramsInFacility(providerNo, facilityId);
    }

    public List getCommunityPrograms(String providerNo,Integer shelterId) {
        return programDao.getAllPrograms(Program.PROGRAM_STATUS_ACTIVE, Program.COMMUNITY_TYPE,null,providerNo,shelterId);
    }

    /**
      * facilityId can be null, it will return all programs optionally filtering by facility id if filtering is enabled.
     */
    public List getPrograms(String programStatus, String providerNo,Integer shelterId) {
         return programDao.getAllPrograms(programStatus,null,null,providerNo,shelterId);
    }
    public List getPrograms(Integer clientId,String providerNo,Integer shelterId) {
        return programDao.getAllPrograms(Program.PROGRAM_STATUS_ACTIVE,null,null,clientId,providerNo,shelterId);
    }

    public List getProgramIds(Integer shelterId,String providerNo) {
    	return programDao.getProgramIdsByProvider(providerNo, shelterId);
    }

    public List getBedPrograms(String providerNo,Integer shelterId) {
        return programDao.getAllPrograms(Program.PROGRAM_STATUS_ACTIVE,Program.BED_TYPE,null,providerNo, shelterId);
    }
    
    public boolean isBedProgram(String programId) {
        return programDao.isTypeOf(Integer.valueOf(programId),Program.BED_TYPE);
    }

    public boolean isServiceProgram(String programId) {
        return programDao.isTypeOf(Integer.valueOf(programId),Program.SERVICE_TYPE);
    }

    public boolean isCommunityProgram(String programId) {
        return programDao.isTypeOf(Integer.valueOf(programId),Program.COMMUNITY_TYPE);
    }

    public void saveProgram(Program program) {
        programDao.saveProgram(program);
        try {
        	lookupDao.SaveAsOrgCode(program);
        }
        catch (Exception e)
        {
    		System.out.println(e.getStackTrace());
        }
    }

    public void removeProgram(String programId) {
        programSignatureDao.removeProgramSignature(Integer.valueOf(programId));
        secuserroleDao.deleteByOrgcd("P"+programId);
        orgDao.delete("P"+programId);
        programDao.removeProgram(Integer.valueOf(programId));
    }
    public void sendTask(Integer programId,Integer clientId, String msg)
    {
    	try {
    		List staffs = this.getProgramProviders("P" + programId.toString(), true);
    		for(int i = 0; i < staffs.size(); i++)
    		{
    			Secuserrole usr = (Secuserrole) staffs.get(i);
    			Tickler tickler = new Tickler();
    			tickler.setCreator("1111");
    			tickler.setDemographic_no(clientId);
    			tickler.setMessage(msg);
    			tickler.setProgram_id(programId);
    			tickler.setTask_assigned_to(usr.getProviderNo());
    			tickler.setService_date(Calendar.getInstance().getTime());
    			tickler.setStatus("Active");
    			ticklerDAO.saveTickler(tickler);
    		}
    	}
    	catch (Exception e)
    	{
    		e.printStackTrace();
    	}
    }
    public List getProgramProviders(String orgcd, boolean activeOnly) {
        return secuserroleDao.findByOrgcd(orgcd, activeOnly);
    }
    
    public List getFunctionalUserTypes() {
        return programFunctionalUserDAO.getFunctionalUserTypes();
    }

    public FunctionalUserType getFunctionalUserType(String id) {
        return programFunctionalUserDAO.getFunctionalUserType(Integer.valueOf(id));
    }

    public void saveFunctionalUserType(FunctionalUserType fut) {
        programFunctionalUserDAO.saveFunctionalUserType(fut);
    }

    public void deleteFunctionalUserType(String id) {
        programFunctionalUserDAO.deleteFunctionalUserType(Integer.valueOf(id));
    }

    public List getFunctionalUsers(String programId) {
        return programFunctionalUserDAO.getFunctionalUsers(Integer.valueOf(programId));
    }

    public ProgramFunctionalUser getFunctionalUser(String id) {
        return programFunctionalUserDAO.getFunctionalUser(Integer.valueOf(id));
    }

    public void saveFunctionalUser(ProgramFunctionalUser pfu) {
        programFunctionalUserDAO.saveFunctionalUser(pfu);
    }

    public void deleteFunctionalUser(String id) {
        programFunctionalUserDAO.deleteFunctionalUser(Integer.valueOf(id));
    }

    public Integer getFunctionalUserByUserType(Integer programId, Integer userTypeId) {
        return programFunctionalUserDAO.getFunctionalUserByUserType(programId, userTypeId);
    }

    public List search(Program criteria) {
        return this.programDao.search(criteria);
    }
    public List searchStaff(StaffForm staffForm) {
        return this.secuserroleDao.searchByCriteria(staffForm);
    }
    
    public Program getHoldingTankProgram() {
        return this.programDao.getHoldingTankProgram();
    }

    public List getProgramClientStatuses(Integer programId) {
        return clientStatusDAO.getProgramClientStatuses(programId);
    }

    public void saveProgramClientStatus(ProgramClientStatus status) {
        clientStatusDAO.saveProgramClientStatus(status);
    }

    public void deleteProgramClientStatus(String id) {
        clientStatusDAO.deleteProgramClientStatus(id);
    }

    public boolean clientStatusNameExists(Integer programId, String statusName) {
        return clientStatusDAO.clientStatusNameExists(programId, statusName);
    }

    public List getAllClientsInStatus(Integer programId, Integer statusId) {
        return clientStatusDAO.getAllClientsInStatus(programId, statusId);
    }

    public ProgramClientStatus getProgramClientStatus(String statusId) {
        return clientStatusDAO.getProgramClientStatus(statusId);
    }

    public ProgramSignature getProgramFirstSignature(Integer programId) {
        return programSignatureDao.getProgramFirstSignature(programId);
    }

    public List getProgramSignatures(Integer programId) {
        return programSignatureDao.getProgramSignatures(programId);
    }

    public void saveProgramSignature(ProgramSignature programSignature) {
        programSignatureDao.saveProgramSignature(programSignature);
    }

    /**
     * This method returns true if the provider is authorised to see items of this programId based on facility filtering.
     * 
     * @param programId
     *            is allowed to be null.
     */
    public boolean hasAccessBasedOnFacility(Integer currentFacilityId, Integer programId) {
        // if no program restrictions are defined.
    	boolean hasAccess = false;
        if (programId == null) return(true);
        if (currentFacilityId == null && programId == null) return(true);

        // check the providers facilities against the programs facilities
        Program program = getProgram(programId);        
        return(program.getFacilityId().intValue() == currentFacilityId.intValue());
    }

	public void setSecuserroleDao(SecuserroleDao secuserroleDao) {
		this.secuserroleDao = secuserroleDao;
	}

	public void setOrgDao(ORGDao orgDao) {
		this.orgDao = orgDao;
	}

	public TicklerDAO getTicklerDAO() {
		return ticklerDAO;
	}

	public void setTicklerDAO(TicklerDAO ticklerDAO) {
		this.ticklerDAO = ticklerDAO;
	}
}
