package oscar.facility;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.oscarehr.PMmodule.web.BaseAction;
import org.oscarehr.common.dao.FacilityDao;
import org.oscarehr.common.model.Facility;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.SessionConstants;
import org.oscarehr.util.SpringUtils;
import org.oscarehr.util.WebUtils;


public class FacilityManagerAction extends BaseAction {

	private FacilityDao facilityDao;
        IntegratorControlDao integratorControlDao=(IntegratorControlDao)SpringUtils.getBean("integratorControlDao");

	public void setFacilityDao(FacilityDao facilityDao) {
		this.facilityDao = facilityDao;
	}
	private static final String FORWARD_EDIT = "edit";
	private static final String FORWARD_LIST = "list";
	private static final String BEAN_FACILITIES = "facilities";
        
        @Override
	public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		return list(mapping, form, request, response);
	}

	public ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		List<Facility> facilities = facilityDao.findAll(true);
		request.setAttribute(BEAN_FACILITIES, facilities);

		return mapping.findForward(FORWARD_LIST);
	}

	public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		String id = request.getParameter("id");
		Facility facility = facilityDao.find(Integer.valueOf(id));

		FacilityManagerForm managerForm = (FacilityManagerForm) form;
		managerForm.setFacility(facility);

		request.setAttribute("id", facility.getId());
		request.setAttribute("orgId", facility.getOrgId());
		request.setAttribute("sectorId", facility.getSectorId());

                boolean removeDemoId = integratorControlDao.readRemoveDemographicIdentity(Integer.valueOf(id));
//Ronnie                Integer updateInterval = integratorControlDao.readUpdateInterval(Integer.valueOf(id));
                managerForm.setRemoveDemographicIdentity(removeDemoId);
//Ronnie                managerForm.setUpdateInterval(updateInterval);
                
		return mapping.findForward(FORWARD_EDIT);
	}

	public ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		String id = request.getParameter("id");
		Facility facility = facilityDao.find(Integer.valueOf(id));
		facility.setDisabled(true);
		facilityDao.merge(facility);

		return list(mapping, form, request, response);
	}

	public ActionForward add(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		Facility facility = new Facility("", "");
		((FacilityManagerForm) form).setFacility(facility);
                ((FacilityManagerForm) form).setRemoveDemographicIdentity(true);
//Ronnie                ((FacilityManagerForm) form).setUpdateInterval(0);

		return mapping.findForward(FORWARD_EDIT);
	}

	public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		oscar.facility.FacilityManagerForm mform = (oscar.facility.FacilityManagerForm) form;
		Facility facility = mform.getFacility();
//Ronnie                Integer upi = mform.getUpdateInterval();
                boolean rdid = WebUtils.isChecked(request, "removeDemographicIdentity");
		if (request.getParameter("facility.hic") == null) facility.setHic(false);

		if (isCancelled(request)) {
			return list(mapping, form, request, response);
		}

                facility.setIntegratorEnabled(WebUtils.isChecked(request, "facility.integratorEnabled"));
                facility.setAllowSims(WebUtils.isChecked(request, "facility.allowSims"));
                facility.setEnableIntegratedReferrals(WebUtils.isChecked(request, "facility.enableIntegratedReferrals"));
                facility.setEnableHealthNumberRegistry(WebUtils.isChecked(request, "facility.enableHealthNumberRegistry"));
                facility.setEnableDigitalSignatures(WebUtils.isChecked(request, "facility.enableDigitalSignatures"));
                if (facility.getId() == null || facility.getId() == 0) facilityDao.persist(facility);
                else facilityDao.merge(facility);
                LoggedInInfo loggedInInfo=LoggedInInfo.loggedInInfo.get();
                // if we just updated our current facility, refresh local cached data in the session / thread local variable
                if (loggedInInfo.currentFacility.getId().intValue()==facility.getId().intValue())
                {
                        request.getSession().setAttribute(SessionConstants.CURRENT_FACILITY, facility);
                        loggedInInfo.currentFacility=facility;
                }
                ActionMessages mssgs = new ActionMessages();
                mssgs.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("facility.saved", facility.getName()));
                saveMessages(request, mssgs);
                request.setAttribute("id", facility.getId());

//Ronnie                        integratorControlDao.saveUpdateInterval(facility.getId(), upi);
                integratorControlDao.saveRemoveDemographicIdentity(facility.getId(), rdid);

                return list(mapping, form, request, response);
	}
}