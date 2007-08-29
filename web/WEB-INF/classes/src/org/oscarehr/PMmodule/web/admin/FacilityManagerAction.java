package org.oscarehr.PMmodule.web.admin;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.*;
import org.oscarehr.PMmodule.model.Facility;
import org.oscarehr.PMmodule.service.FacilityManager;
import org.oscarehr.PMmodule.web.BaseAction;
import org.springframework.beans.factory.annotation.Required;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 */
public class FacilityManagerAction extends BaseAction {
    private static final Log log = LogFactory.getLog(FacilityManagerAction.class);

    private FacilityManager facilityManager;

    private static final String FORWARD_EDIT = "edit";
    private static final String FORWARD_LIST = "list";
    private static final String BEAN_FACILITIES = "facilities";
    private static final String BEAN_AGENCY_ID = "agencyId";

    public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        return list(mapping, form, request, response);
    }

    public ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        Integer agencyId = Integer.valueOf(request.getParameter(BEAN_AGENCY_ID));

        List<Facility> facilities = facilityManager.getFacilitiesForAgency(agencyId);
        List<Facility> filteredFacilities = new ArrayList<Facility>();
        for (Facility facility : facilities) {
            if (!facility.isDisabled())
                filteredFacilities.add(facility);
        }
        request.setAttribute(BEAN_FACILITIES, filteredFacilities);

        request.setAttribute(BEAN_AGENCY_ID, agencyId);
        
        return mapping.findForward(FORWARD_LIST);
    }

    public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        Facility facility = facilityManager.getFacility(Integer.valueOf(id));
        Integer agencyId = Integer.valueOf(request.getParameter(BEAN_AGENCY_ID));
        FacilityManagerForm managerForm = (FacilityManagerForm) form;
        managerForm.setFacility(facility);
        managerForm.setAgencyId(agencyId);

        request.setAttribute("id", facility.getId());

        return mapping.findForward(FORWARD_EDIT);
    }

    public ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        Facility facility = facilityManager.getFacility(Integer.valueOf(id));
        facility.setDisabled(true);
        facilityManager.saveFacility(facility);

        return list(mapping, form, request, response);
    }

    public ActionForward add(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        Integer agencyId = Integer.valueOf(request.getParameter(BEAN_AGENCY_ID));
        Facility facility = new Facility(agencyId, "", "");

        ((FacilityManagerForm) form).setFacility(facility);

        return mapping.findForward(FORWARD_EDIT);
    }

    public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        FacilityManagerForm mform = (FacilityManagerForm) form;
        Facility facility = mform.getFacility();

        request.setAttribute(BEAN_AGENCY_ID, mform.getAgencyId());

        if (isCancelled(request)) {
            request.getSession().removeAttribute("facilityManagerForm");

            return list(mapping, form, request, response);
        }

        facility.setAgencyId(mform.getAgencyId());
        facilityManager.saveFacility(facility);

        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("facility.saved", facility.getName()));
        saveMessages(request, messages);

        request.setAttribute("id", facility.getId());

        logManager.log("write", "facility", facility.getId().toString(), request);

        return list(mapping, form, request, response);
    }

    public FacilityManager getFacilityManager() {
        return facilityManager;
    }

    @Required
    public void setFacilityManager(FacilityManager facilityManager) {
        this.facilityManager = facilityManager;
    }
}
