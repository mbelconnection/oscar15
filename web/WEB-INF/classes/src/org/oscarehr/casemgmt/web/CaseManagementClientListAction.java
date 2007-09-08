package org.oscarehr.casemgmt.web;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.caisi.core.web.BaseAction;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.ProgramProvider;
import org.oscarehr.PMmodule.service.AdmissionManager;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.casemgmt.web.formbeans.ClientListFormBean;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 */
public class CaseManagementClientListAction extends BaseAction {
    private final static String FORWARD_LIST = "list";
    private final static String FORWARD_ARCHIVE = "archive";

    private ClientManager clientManager;
    private ProgramManager programManager;
    private AdmissionManager admissionManager;

    public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws ServletException {
        return list(mapping,form,request,response);
    }



    public ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws ServletException {
        String provider = (String) request.getSession().getAttribute("user");
        ClientListFormBean clientListForm = (ClientListFormBean) form;
        List<ProgramProvider> programProviders = programManager.getProgramProvidersByProvider(provider);
        request.setAttribute("programProviders", programProviders);

        Long programId = clientListForm.getProgramId();
        if (programId == null && !programProviders.isEmpty()) {
            clientListForm.setProgramId(programProviders.iterator().next().getProgramId());
            programId = clientListForm.getProgramId();
        }

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");


        Set<Demographic> clients = new HashSet<Demographic>();
        if (programId != null) {
            // get current admissions
            List<Admission> admissions;
            if (clientListForm.getAdmissionDate() == null || clientListForm.getAdmissionDate().equals(format.format(new Date()))) {
                admissions = admissionManager.getCurrentAdmissionsByProgramId("" + programId);
            } else {
                try {
                    Date admissionFilterDate = format.parse(clientListForm.getAdmissionDate());
                    admissions = admissionManager.getAdmittedByDate(programId.intValue(), admissionFilterDate, new Date(admissionFilterDate.getTime() + 86400000));
                } catch (ParseException e) {
                    throw new ServletException(e);
                }


            }

            // populate the program status list for this program
            request.setAttribute("programClientStatuses", programManager.getProgramClientStatuses(programId.intValue()));

            // populate client list with current admissions
            for (Admission admission : admissions) {
                String pcStatusId = clientListForm.getProgramClientStatusId();
                // if a program client status id has been selected, filter on it
                Demographic demographic = admission.getClient();
                if (pcStatusId != null && !pcStatusId.equals("") ) {
                    if (pcStatusId.equals("" + admission.getClientStatusId()))
                        clients.add(demographic);
                } else {
                    clients.add(demographic);
                }
            }
        }

        request.setAttribute("clients", clients);

        return mapping.findForward(FORWARD_LIST);
    }

    public ActionForward archive(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws ServletException {
        String provider = (String) request.getSession().getAttribute("user");
        ClientListFormBean clientListForm = (ClientListFormBean) form;
        List<ProgramProvider> programProviders = programManager.getProgramProvidersByProvider(provider);
        request.setAttribute("programProviders", programProviders);

        Long programId = clientListForm.getProgramId();
        if (programId == null && !programProviders.isEmpty()) {
            clientListForm.setProgramId(programProviders.iterator().next().getProgramId());
            programId = clientListForm.getProgramId();
        }

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");


        Set<Demographic> clients = new HashSet<Demographic>();
        if (programId != null) {
            // get current admissions
            List<Admission> admissions;
            if (clientListForm.getAdmissionDate() == null || clientListForm.getAdmissionDate().equals(format.format(new Date()))) {
                admissions = admissionManager.getCurrentDischargesByProgramId("" + programId);
            } else {
                try {
                    Date admissionFilterDate = format.parse(clientListForm.getAdmissionDate());
                    admissions = admissionManager.getDischargedByDate(programId.intValue(), admissionFilterDate, new Date(admissionFilterDate.getTime() + 86400000));
                } catch (ParseException e) {
                    throw new ServletException(e);
                }


            }

            // populate the program status list for this program
            request.setAttribute("programClientStatuses", programManager.getProgramClientStatuses(programId.intValue()));

            // populate client list with current admissions
            for (Admission admission : admissions) {
                String pcStatusId = clientListForm.getProgramClientStatusId();
                // if a program client status id has been selected, filter on it
                Demographic demographic = admission.getClient();
                if (pcStatusId != null && !pcStatusId.equals("") ) {
                    if (pcStatusId.equals("" + admission.getClientStatusId()))
                        clients.add(demographic);
                } else {
                    clients.add(demographic);
                }
            }
        }

        request.setAttribute("clients", clients);

        return mapping.findForward(FORWARD_ARCHIVE);
    }
    
    public ClientManager getClientManager() {
        return clientManager;
    }

    public void setClientManager(ClientManager clientManager) {
        this.clientManager = clientManager;
    }

    public ProgramManager getProgramManager() {
        return programManager;
    }

    public void setProgramManager(ProgramManager programManager) {
        this.programManager = programManager;
    }

    public AdmissionManager getAdmissionManager() {
        return admissionManager;
    }

    public void setAdmissionManager(AdmissionManager admissionManager) {
        this.admissionManager = admissionManager;
    }
}

