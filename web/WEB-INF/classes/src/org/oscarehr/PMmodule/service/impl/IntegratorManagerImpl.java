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
package org.oscarehr.PMmodule.service.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.caisi.integrator.message.AuthenticationToken;
import org.caisi.integrator.message.agencies.FindAgenciesRequest;
import org.caisi.integrator.message.agencies.FindAgenciesResponse;
import org.caisi.integrator.message.agencies.RegisterAgencyRequest;
import org.caisi.integrator.message.agencies.RegisterAgencyResponse;
import org.caisi.integrator.message.demographics.GetDemographicRequest;
import org.caisi.integrator.message.demographics.GetDemographicResponse;
import org.caisi.integrator.message.demographics.SynchronizeAgencyDemographicsRequest;
import org.caisi.integrator.message.demographics.SynchronizeAgencyDemographicsResponse;
import org.caisi.integrator.message.info.GetIntegratorInformationRequest;
import org.caisi.integrator.message.search.SearchCandidateDemographicRequest;
import org.caisi.integrator.message.search.SearchCandidateDemographicResponse;
import org.caisi.integrator.model.*;
import org.caisi.integrator.model.transfer.AgencyTransfer;
import org.caisi.integrator.model.transfer.DemographicTransfer;
import org.caisi.integrator.service.IntegratorService;
import org.codehaus.xfire.XFire;
import org.codehaus.xfire.XFireFactory;
import org.codehaus.xfire.client.XFireProxy;
import org.codehaus.xfire.client.XFireProxyFactory;
import org.codehaus.xfire.service.Service;
import org.codehaus.xfire.service.binding.ObjectServiceFactory;
import org.codehaus.xfire.transport.http.SoapHttpTransport;
import org.oscarehr.PMmodule.dao.AgencyDao;
import org.oscarehr.PMmodule.exception.IntegratorException;
import org.oscarehr.PMmodule.exception.IntegratorNotEnabledException;
import org.oscarehr.PMmodule.exception.IntegratorNotInitializedException;
import org.oscarehr.PMmodule.exception.OperationNotImplementedException;
import org.oscarehr.PMmodule.model.*;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.Provider;
import org.oscarehr.PMmodule.model.Agency;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.IntegratorManager;
import org.springframework.jms.core.JmsTemplate;

import java.lang.reflect.Proxy;
import java.util.*;

public class IntegratorManagerImpl implements IntegratorManager {

    private static Log log = LogFactory.getLog(IntegratorManagerImpl.class);

    private static Agency localAgency;
    private static Map<Long, Agency> agencyMap;

    private boolean initCalled = false;

    private AgencyDao agencyDAO;
    private JmsTemplate jmsTemplate;

    protected ClientManager clientManager;

    private IntegratorService integratorService;
    private AuthenticationToken authenticationToken;

    public static Agency getLocalAgency() {
        return localAgency;
    }

    public static Map<Long, Agency> getAgencyMap() {
        return agencyMap;
    }

    public void setAgencyDao(AgencyDao dao) {
        this.agencyDAO = dao;
    }

    public boolean isActive() {
        return isEnabled() && isRegistered();
    }

    public boolean isEnabled() {
        if (!initCalled) {
            init();
        }

        return localAgency != null && localAgency.isIntegratorEnabled();
    }

    public boolean isRegistered() {
        if (!isEnabled()) {
            log.warn("integrator not enabled");
            return false;
        }

        return localAgency != null && localAgency.getId() > 0;

    }

    public void init() {
        if (initCalled) {
            return;
        }

        initCalled = true;

        try {
            localAgency = agencyDAO.getLocalAgency();
        } catch (Throwable e) {
            log.error("could not get local agency", e);
            return;
        }

        if (localAgency == null) {
            log.warn("local agency information not in database");
            return;
        }

        if (isActive()) {
            try {
                XFire xfire = XFireFactory.newInstance().getXFire();
                XFireProxyFactory factory = new XFireProxyFactory(xfire);

                Service integratorServiceModel = new ObjectServiceFactory().create(IntegratorService.class);
                integratorService = (IntegratorService) factory.create(integratorServiceModel, localAgency.getIntegratorUrl() + "/services/IntegratorService");

                XFireProxy proxy = (XFireProxy) Proxy.getInvocationHandler(integratorService);

                proxy.getClient().setTransport(new SoapHttpTransport());

                authenticationToken = new AuthenticationToken(localAgency.getIntegratorUsername(), localAgency.getIntegratorPassword());

                setupAgencyMap();

                localAgency.setIntegratorEnabled(false);
            } catch (Throwable e) {
                localAgency.setIntegratorEnabled(false);

                throw new IntegratorNotInitializedException(e);
            } finally {
                if (agencyMap == null && localAgency != null) {
                    setupLocalAgencyMap();
                }
            }
        } else {
            if (agencyMap == null && localAgency != null) {
                setupLocalAgencyMap();
            }
        }
    }

    public void setupAgencyMap() {
        if (integratorService != null) {
            FindAgenciesResponse response = getIntegratorService().findAgencies(new FindAgenciesRequest( new Date() ), authenticationToken);
            agencyMap = new HashMap<Long, Agency>();
            for (org.caisi.integrator.model.Agency agency : response.getAgencies()) {
                agencyMap.put(agency.getId(), integratorAgencyToCAISIAgency(agency));
            }
        }
        agencyMap.put((long) 0, localAgency);
        Agency.setAgencyMap(agencyMap);
        log.info("Agency Map is setup");
    }

    private IntegratorService getIntegratorService() {
        if (!isEnabled())
            throw new IntegratorNotEnabledException("request made for integrator service, but integrator is not enabled");
        else if (integratorService == null)
            throw new IntegratorNotInitializedException("request made for integrator service, which was not initialized");
        else
            return integratorService;
    }

    /**
     * @return a list of all agencies
     */
    public List<Agency> getAgencies() {
        FindAgenciesResponse response = getIntegratorService().findAgencies(new FindAgenciesRequest( new Date() ), authenticationToken);
        List<Agency> agencies = new ArrayList<Agency>();
        for (org.caisi.integrator.model.Agency agency : response.getAgencies()) {
            agencies.add(integratorAgencyToCAISIAgency(agency));
        }

        return agencies;
    }

    public void setupLocalAgencyMap() {
        agencyMap = new HashMap<Long, Agency>();
        agencyMap.put((long) 0, localAgency);
        Agency.setAgencyMap(agencyMap);
        log.info("Agency Map is setup");
    }

    public void refresh() {
        init();
    }

    /**
     * @return the id of the local agency
     */
    public long getLocalAgencyId() {
        return localAgency.getId();
    }

    /**
     * Register an agency (presumably the local agency) with the integrator
     *
     * @param agencyInfo the agency to register
     * @return the agency's id
     */
    public Long register(Agency agencyInfo) {
        RegisterAgencyResponse response = getIntegratorService().registerAgency(
                new RegisterAgencyRequest(
                        new Date(),
                        caisiAgencyToIntegratorAgency(agencyInfo)

                ),
                authenticationToken
        );

        return response.getAgency().getId();
    }

    public Collection<Demographic> matchClient(Demographic client) throws IntegratorException {

        org.caisi.integrator.model.Demographic searchDemographic = caisiDemographicToIntegratorDemographic(client);
        SearchCandidateDemographicResponse response =
                getIntegratorService().searchCandidateDemographic(new SearchCandidateDemographicRequest(new Date(),
                        searchDemographic), authenticationToken);

        Collection<Client> clients = response.getCandidateClients();

        Collection<Demographic> demographics = new ArrayList<Demographic>();
        for (Client client1 : clients) {
            for (org.caisi.integrator.model.Demographic demographic : client1.getDemographics()) {
                demographics.add(integratorDemographicToCaisiDemographic(demographic));
            }
        }

        return demographics;
    }

    public Demographic getDemographic(long agencyId, long demographicNo) throws IntegratorException {
        // TODO in the new integrator we look up the agency by its username, not by its id, so until i finish unwinding all of marc's code that uses the integer id, we'll have to look it up
        String agencyUsername = getAgencyUsername(agencyId);
        GetDemographicResponse response = getIntegratorService().getDemographic(
                new GetDemographicRequest(new Date(),
                        agencyUsername, demographicNo), authenticationToken);


        Demographic demographic = integratorDemographicToCaisiDemographic(response.getDemographic());

        return demographic;
    }

    // TODO is this used? and why this name?
    public Demographic getClient(long demographicNo) {
        GetDemographicResponse response = getIntegratorService().getDemographic(
                new GetDemographicRequest(new Date(),
                        localAgency.getIntegratorUsername(), demographicNo), authenticationToken);

        Demographic demographic = integratorDemographicToCaisiDemographic(response.getDemographic());

        return demographic;
    }


    private String getAgencyUsername(long agencyId) {
        return agencyMap.get(agencyId).getIntegratorUsername();
    }

    public void refreshClients(List<Demographic> clients) throws IntegratorException {
        List<org.caisi.integrator.model.Demographic> demographics = new ArrayList<org.caisi.integrator.model.Demographic>();
        for (Demographic client : clients) {
            demographics.add(caisiDemographicToIntegratorDemographic(client));
        }
        SynchronizeAgencyDemographicsResponse response = getIntegratorService().synchronizeAgencyDemographics(
                new SynchronizeAgencyDemographicsRequest(new Date(), demographics),
                authenticationToken
        );
    }

    protected boolean updateClient(long id) {
        // TODO stubbed for now, must implement
//        if(!isEnabled() || agencyService == null) {
//            return false;
//        }
//
//        Demographic demographic = clientManager.getClientByDemographicNo(id);
//        List<DemographicExt> extras = clientManager.getDemographicExtByDemographicNo((int)id);
//
//        demographic.setExtras(extras.toArray(new DemographicExt[extras.size()]));
//
//        agencyService.updateClient(getLocalAgency().getId().longValue(),demographic.getDemographicNo().intValue(),demographic);

        return true;
    }


    public void saveClient(Demographic client) throws IntegratorException {
        // TODO stubbed for now, must implement
//        if (!isEnabled() || agencyService == null) {
//            throw new IntegratorNotEnabledException();
//        }
//        try {
//            agencyService.saveClient(localAgency.getId(), client);
//        } catch (XFireRuntimeException e) {
//            throw new IntegratorException(e.getMessage());
//        }
    }

    public void mergeClient(Demographic localClient, long remoteAgency, long remoteClientId) throws IntegratorException {
        // TODO change integration-side to allow this form instead
//        if (!isEnabled() || agencyService == null) {
//            throw new IntegratorNotEnabledException();
//        }
//        try {
//            agencyService.mergeClients(getLocalAgencyId(), String.valueOf(localClient.getDemographicNo()), remoteAgency, String.valueOf(remoteClientId));
//        } catch (XFireRuntimeException e) {
//            throw new IntegratorException(e.getMessage());
//        }
    }

    public String getIntegratorVersion() {
        return getIntegratorService().getIntegratorInformation(new GetIntegratorInformationRequest(new Date()), authenticationToken).getVersion();
    }

    public boolean notifyUpdate(short dataType, long id) {
        if (!isEnabled()) {
            return false;
        }

        switch (dataType) {
            case IntegratorManager.DATATYPE_CLIENT:
                return updateClient(id);
        }

        return true;
    }

    private org.caisi.integrator.model.Agency caisiAgencyToIntegratorAgency(Agency agencyInfo) {
        AgencyTransfer agencyTransfer = new AgencyTransfer();

        agencyTransfer.setHic(agencyInfo.isHic());
        agencyTransfer.setLocal(agencyInfo.isLocal());
        agencyTransfer.setName(agencyInfo.getName());
        agencyTransfer.setUsername(agencyInfo.getIntegratorUsername());
        agencyTransfer.setDescription(agencyInfo.getDescription());
        agencyTransfer.setContactPhone(agencyInfo.getContactPhone());
        agencyTransfer.setContactName(agencyInfo.getContactName());
        agencyTransfer.setContactEmail(agencyInfo.getContactEmail());

        return agencyTransfer;
    }

    private Agency integratorAgencyToCAISIAgency(org.caisi.integrator.model.Agency agencyTransfer) {
        Agency agency = new Agency();

        agency.setLocal(agencyTransfer.isLocal());
        agency.setName(agencyTransfer.getName());
        agency.setIntegratorUsername(agencyTransfer.getUsername());
        agency.setDescription(agencyTransfer.getDescription());
        agency.setContactPhone(agencyTransfer.getContactPhone());
        agency.setContactName(agencyTransfer.getContactName());
        agency.setContactEmail(agencyTransfer.getContactEmail());

        return agency;
    }

    public org.caisi.integrator.model.Demographic caisiDemographicToIntegratorDemographic(Demographic demographicInfo) {
        DemographicTransfer demographicTransfer = new DemographicTransfer();

        demographicTransfer.setAddress(demographicInfo.getAddress());
        org.caisi.integrator.model.Agency agency = caisiAgencyToIntegratorAgency(agencyDAO.getAgency(demographicInfo.getAgencyId()));
        demographicTransfer.setAgency(agency);
        demographicTransfer.setAgencyDemographicNo(demographicInfo.getDemographicNo());
        demographicTransfer.setChartNo(demographicInfo.getChartNo());
        demographicTransfer.setCity(demographicInfo.getCity());
        demographicTransfer.setDateJoined(demographicInfo.getDateJoined());
        demographicTransfer.setDateOfBirth(strToIntegerOrNull(demographicInfo.getDateOfBirth()));
        demographicTransfer.setEffDate(demographicInfo.getEffDate());
        demographicTransfer.setEmail(demographicInfo.getEmail());
        demographicTransfer.setEndDate(demographicInfo.getEndDate());
        demographicTransfer.setFamilyDoctor(demographicInfo.getFamilyDoctor());
        demographicTransfer.setFirstName(demographicInfo.getFirstName());
        demographicTransfer.setHcRenewDate(demographicInfo.getHcRenewDate());
        demographicTransfer.setHcType(demographicInfo.getHcType());
        demographicTransfer.setHin(demographicInfo.getHin());
        demographicTransfer.setLastName(demographicInfo.getLastName());
        demographicTransfer.setMonthOfBirth(strToIntegerOrNull(demographicInfo.getMonthOfBirth()));
        demographicTransfer.setPatientStatus(demographicInfo.getPatientStatus());
        demographicTransfer.setPcnIndicator(demographicInfo.getPcnIndicator());
        demographicTransfer.setPhone(demographicInfo.getPhone());
        demographicTransfer.setPhone2(demographicInfo.getPhone2());
        demographicTransfer.setPin(demographicInfo.getPin());
        demographicTransfer.setPostal(demographicInfo.getPostal());
        // TODO provider conversion here
        demographicTransfer.setProvince(demographicInfo.getProvince());
        demographicTransfer.setRosterStatus(demographicInfo.getRosterStatus());
        demographicTransfer.setSex(demographicInfo.getSex());
        demographicTransfer.setVer(demographicInfo.getVer());
        demographicTransfer.setYearOfBirth(strToIntegerOrNull(demographicInfo.getYearOfBirth()));

        return demographicTransfer;
    }

    public Demographic integratorDemographicToCaisiDemographic(org.caisi.integrator.model.Demographic demographicTransfer) {
        Demographic demographicInfo = new Demographic();

        demographicInfo.setAgencyId(demographicTransfer.getAgency().getId());
        demographicInfo.setAddress(demographicTransfer.getAddress());
        demographicInfo.setChartNo(demographicTransfer.getChartNo());
        demographicInfo.setCity(demographicTransfer.getCity());
        demographicInfo.setDateJoined(demographicTransfer.getDateJoined());
        demographicInfo.setDateOfBirth(intToStrOrNull(demographicTransfer.getDateOfBirth()));
        demographicInfo.setEffDate(demographicTransfer.getEffDate());
        demographicInfo.setEmail(demographicTransfer.getEmail());
        demographicInfo.setEndDate(demographicTransfer.getEndDate());
        demographicInfo.setFamilyDoctor(demographicTransfer.getFamilyDoctor());
        demographicInfo.setFirstName(demographicTransfer.getFirstName());
        demographicInfo.setHcRenewDate(demographicTransfer.getHcRenewDate());
        demographicInfo.setHcType(demographicTransfer.getHcType());
        demographicInfo.setHin(demographicTransfer.getHin());
        demographicInfo.setLastName(demographicTransfer.getLastName());
        demographicInfo.setMonthOfBirth(intToStrOrNull(demographicTransfer.getMonthOfBirth()));
        demographicInfo.setPatientStatus(demographicTransfer.getPatientStatus());
        demographicInfo.setPcnIndicator(demographicTransfer.getPcnIndicator());
        demographicInfo.setPhone(demographicTransfer.getPhone());
        demographicInfo.setPhone2(demographicTransfer.getPhone2());
        demographicInfo.setPin(demographicTransfer.getPin());
        demographicInfo.setPostal(demographicTransfer.getPostal());
        // TODO provider conversion here
        demographicInfo.setProvince(demographicTransfer.getProvince());
        demographicInfo.setRosterStatus(demographicTransfer.getRosterStatus());
        demographicInfo.setSex(demographicTransfer.getSex());
        demographicInfo.setVer(demographicTransfer.getVer());
        demographicInfo.setYearOfBirth(intToStrOrNull(demographicTransfer.getYearOfBirth()));

        return demographicInfo;
    }

    public Integer strToIntegerOrNull(String value) {
        try {
            return Integer.valueOf(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public String intToStrOrNull(Integer value) {
        return value == null ? null : "" + value;
    }

    public void refreshPrograms(List<Program> programs) throws IntegratorException {
        throw new OperationNotImplementedException("program registrations not yet implemented in integrator");
    }

    public void refreshAdmissions(List<Admission> admissions) throws IntegratorException {
        throw new OperationNotImplementedException("admission registrations not yet implemented in integrator");

    }

    public void refreshProviders(List<Provider> providers) throws IntegratorException {
        throw new OperationNotImplementedException("provider registrations not yet implemented in integrator");
    }

    public void refreshReferrals(List<ClientReferral> referrals) throws IntegratorException {
        throw new OperationNotImplementedException("referral registrations not yet implemented in integrator");
    }


    public void updateProgramData(List<Program> programs) {
        throw new OperationNotImplementedException("program registry not yet implemented");
    }

    public List<Program> searchPrograms(Program criteria) {
        throw new OperationNotImplementedException("program registry not yet implemented");
    }

    public Program getProgram(Long agencyId, Long programId) throws IntegratorNotEnabledException {
        throw new OperationNotImplementedException("program registry not yet implemented");
    }

    public void sendReferral(Long agencyId, ClientReferral referral) {
        throw new OperationNotImplementedException("referral registrations not yet implemented in integrator");
    }

    public List getCurrentAdmissions(long clientId) throws IntegratorException {
        throw new OperationNotImplementedException("admission registrations not yet implemented in integrator");
    }

    public List getCurrentReferrals(long clientId) throws IntegratorException {
        throw new OperationNotImplementedException("referral registrations not yet implemented in integrator");
    }

    public void setClientManager(ClientManager mgr) {
        this.clientManager = mgr;
    }

    public ClientManager getClientManager() {
        return this.clientManager;
    }

}
