package org.oscarehr.PMmodule.web.admin;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.*;
import org.oscarehr.PMmodule.model.Agency;
import org.oscarehr.PMmodule.web.BaseAction;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 */
public class MultiAgencyManagerAction extends BaseAction {

    private static final Log log = LogFactory.getLog(MultiAgencyManagerAction.class);

    private static final String FORWARD_EDIT = "edit";
    private static final String FORWARD_LIST = "list";
    private static final String BEAN_AGENCIES = "agencies";

    public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        return list(mapping, form, request, response);
    }

    public ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        List<Agency> filteredAgencies = getAgencies();
        request.setAttribute(BEAN_AGENCIES, filteredAgencies);
        return mapping.findForward(FORWARD_LIST);
    }

    private List<Agency> getAgencies() {
        List<Agency> agencies = agencyManager.getAgencies();
        List<Agency> filteredAgencies = new ArrayList<Agency>();
        for (Agency agency : agencies) {
            if (!agency.isDisabled())
                filteredAgencies.add(agency);
        }
        return filteredAgencies;
    }

    public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        Agency agency = agencyManager.getAgency(id);
        ((MultiAgencyManagerForm) form).setAgency(agency);

        request.setAttribute("id", agency.getId());

        return mapping.findForward(FORWARD_EDIT);
    }

    public ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        Agency agency = agencyManager.getAgency(id);
        agency.setDisabled(true);
        agencyManager.saveAgency(agency);
        
        return list(mapping, form, request, response);

    }

    public ActionForward add(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        Agency agency = new Agency(null, 1, "HS", "HS", "", true, false);
        
        ((MultiAgencyManagerForm) form).setAgency(agency);

        return mapping.findForward(FORWARD_EDIT);
    }

    public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        MultiAgencyManagerForm mform = (MultiAgencyManagerForm) form;
        Agency agency = mform.getAgency();

        if (isCancelled(request)) {
            request.getSession().removeAttribute("agencyManagerForm");
            request.setAttribute("id", agency.getId());

            return list(mapping, form, request, response);
        }

        if (request.getParameter("agency.hic") == null) {
            agency.setHic(false);
        }

        agencyManager.saveAgency(agency);

        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("agency.saved", agency.getName()));
        saveMessages(request, messages);

        request.setAttribute("id", agency.getId());

        logManager.log("write", "agency", agency.getId().toString(), request);

        return list(mapping, form, request, response);
    }
}
