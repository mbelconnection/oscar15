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
package org.oscarehr.PMmodule.web;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.util.LabelValueBean;
import org.oscarehr.PMmodule.model.ClientReferral;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.ProgramClientRestriction;
import org.oscarehr.PMmodule.model.ProgramQueue;
import org.oscarehr.PMmodule.model.QuatroIntake;
import org.oscarehr.PMmodule.model.QuatroIntakeDB;
import org.oscarehr.PMmodule.model.QuatroIntakeFamily;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ClientRestrictionManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.service.ProgramQueueManager;
import org.oscarehr.PMmodule.web.formbean.ClientSearchFormBean;
import org.oscarehr.PMmodule.web.formbean.QuatroIntakeEditForm;

import oscar.MyDateFormat;

import com.quatro.common.KeyConstants;
import com.quatro.model.LookupCodeValue;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;
import com.quatro.util.Utility;

public class QuatroIntakeEditAction extends BaseClientAction {
	private ClientManager clientManager;

	private LookupManager lookupManager;

	private IntakeManager intakeManager;

	private ProgramManager programManager;

	private ClientRestrictionManager clientRestrictionManager;

	private ProgramQueueManager programQueueManager;

	// for new client
	public ActionForward create(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, null,
					KeyConstants.ACCESS_WRITE);
			QuatroIntakeEditForm qform = (QuatroIntakeEditForm) form;

			Integer clientId = Integer.valueOf("0");
			Integer intakeId = Integer.valueOf("0");
			super.cacheClient(request, clientId);

			Demographic client = new Demographic();
			qform.setDob("");
			qform.setClient(client);

			com.quatro.web.intake.OptionList optionValues = intakeManager
					.LoadOptionsList(true);
			qform.setOptionList(optionValues);

			Integer shelterId = (Integer) request.getSession().getAttribute(
					KeyConstants.SESSION_KEY_SHELTERID);
			ArrayList lst = (ArrayList) programManager.getProgramIds(shelterId,
					(String) request.getSession().getAttribute(
							KeyConstants.SESSION_KEY_PROVIDERNO));
			ArrayList lst2 = new ArrayList();
			ArrayList lst3 = new ArrayList();
			for (int i = 0; i < lst.size(); i++) {
				Object[] obj = (Object[]) lst.get(i);
				lst2.add(new LabelValueBean((String) obj[1], ((Integer) obj[0])
						.toString()));
				lst3.add(new LabelValueBean((String) obj[2], ((Integer) obj[0])
						.toString()));
			}
			qform.setProgramList(lst2);
			qform.setProgramTypeList(lst3);

			QuatroIntake obj;
			if (intakeId.intValue() != 0) {
				obj = intakeManager.getQuatroIntake(intakeId);
			} else {
				obj = new QuatroIntake();
				obj.setCreatedOn(Calendar.getInstance());
				obj.setId(new Integer(0));
				obj.setClientId(Integer.valueOf(qform.getClientId()));
				obj.setIntakeStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
				obj.setStaffId((String) request.getSession().getAttribute(
						KeyConstants.SESSION_KEY_PROVIDERNO));
				// obj.setYouth(KeyConstants.CONSTANT_NO);
				// obj.setVAW(KeyConstants.CONSTANT_NO);
			}

			obj.setCurrentProgramId(obj.getProgramId());
			qform.setIntake(obj);
			
			request.setAttribute("intakeHeadId", new Integer(0)); // intakeHeadId:
			// for intake
			// stauts='discharged'
			// or 'rejected'
			// to view
			// family
			// details.

			LookupCodeValue language;
			LookupCodeValue originalCountry;
			if (intakeId.intValue() != 0) {
				if (obj.getLanguage() != null) {
					language = lookupManager.GetLookupCode("LNG", obj
							.getLanguage());
				} else {
					language = new LookupCodeValue();
				}
				if (obj.getOriginalCountry() != null) {
					originalCountry = lookupManager.GetLookupCode("CNT", obj
							.getOriginalCountry());
				} else {
					originalCountry = new LookupCodeValue();
				}
			} else {
				language = new LookupCodeValue();
				originalCountry = new LookupCodeValue();
			}
           
			qform.setLanguage(language);
			qform.setOriginalCountry(originalCountry);
			request.setAttribute("clientId", clientId);
			request.setAttribute("newClientFlag", "true");
			request.setAttribute("isBedProgram", Boolean.FALSE);
			request.setAttribute("isReadOnly", Boolean.FALSE);
			setProgramEditable(request, obj, null);
			super.setScreenMode(request, KeyConstants.TAB_CLIENT_INTAKE);
			return mapping.findForward("edit");
		} catch (NoAccessException e) {
			return mapping.findForward("failure");
		}
	}
	// for existing client
	public ActionForward showHeadIntake(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		Integer clientId = Integer.valueOf(request.getParameter("clientId"));

		super.cacheClient(request, clientId);
		return update(mapping,form,request,response);
	}
	
	// for existing client
	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			Integer clientId = super.getClientId(request);
			Integer intakeId = Integer
					.valueOf(request.getParameter("intakeId"));
			QuatroIntakeEditForm qform = (QuatroIntakeEditForm) form;
			if (intakeId.intValue() == 0)
				super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, null,
						KeyConstants.ACCESS_WRITE);
			Integer intakeHeadId = intakeManager.getIntakeFamilyHeadId(intakeId);
			if (intakeHeadId.intValue() != 0) {
				request.setAttribute("intakeHeadId", intakeHeadId); // intakeHeadId:
				// for intake
				// stauts='discharged'
				// or 'rejected'
				// to view
				// family
				// details.
			} else {
				request.setAttribute("intakeHeadId", new Integer(0)); // intakeHeadId:
				// for
				// intake
				// stauts='discharged'
				// or
				// 'rejected'
				// to view
				// family
				// details.
			}

			request.setAttribute("fromManualReferralId", request.getParameter("fromManualReferralId"));

			Demographic client;
			if (clientId.intValue() > 0) {
				client = super.getClient(request, clientId);
				qform.setDob(MyDateFormat.getStandardDate(client.getDateOfBirth()));
				request.setAttribute("newClientChecked","Y");
			} else {
				client = new Demographic();
				request.setAttribute("newClientChecked","N");
				qform.setDob("");
			}
			qform.setClient(client);
			request.setAttribute("client", client);
			request.setAttribute("clientId", clientId);
			boolean readOnly = false;
			QuatroIntake intake;
			if (intakeId.intValue() != 0) {
				intake = intakeManager.getQuatroIntake(intakeId);
				if (KeyConstants.PROGRAM_TYPE_Service.equals(intake.getProgramType())) {
					if (intake.getEndDate() != null
							&& intake.getEndDate().before(Calendar.getInstance()))
						intake.setIntakeStatus(KeyConstants.STATUS_INACTIVE);
				}
				setAgeGenderReadonly(request, intake);

				readOnly = super.isReadOnly(request, intake.getIntakeStatus(),
						KeyConstants.FUN_CLIENTINTAKE, intake.getProgramId());
				request.setAttribute("isReadOnly", Boolean.valueOf(readOnly));
			} else {
				intake = new QuatroIntake();
				intake.setCreatedOn(Calendar.getInstance());
				intake.setId(new Integer(0));
				intake.setClientId(Integer.valueOf(qform.getClientId()));
				intake.setIntakeStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
				intake.setStaffId((String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO));
				// intake.setYouth(KeyConstants.CONSTANT_NO);
				// intake.setVAW(KeyConstants.CONSTANT_NO);
				request.setAttribute("isReadOnly", Boolean.FALSE);
			}
			com.quatro.web.intake.OptionList optionValues = intakeManager.LoadOptionsList(!readOnly);
			qform.setOptionList(optionValues);

			Integer shelterId = (Integer) request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
			ArrayList lst = (ArrayList) programManager.getProgramIds(shelterId,
					(String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO));
			ArrayList lst2 = new ArrayList();
			ArrayList lst3 = new ArrayList();
			for (int i = 0; i < lst.size(); i++) {
				Object[] obj = (Object[]) lst.get(i);
				// don't allow existing intake change program type
				// if program type is wrong, discharge/reject this intake (for
				// bed
				// program), then create a new intake with correct program type.
				if (intakeId.intValue() > 0) {
					if (intake.getProgramType().equals((String) obj[2])) {
						lst2.add(new LabelValueBean((String) obj[1],((Integer) obj[0]).toString()));
						lst3.add(new LabelValueBean((String) obj[2],((Integer) obj[0]).toString()));
					}
				} else {
					lst2.add(new LabelValueBean((String) obj[1],((Integer) obj[0]).toString()));
					lst3.add(new LabelValueBean((String) obj[2],((Integer) obj[0]).toString()));
				}
			}
			qform.setProgramList(lst2);
			qform.setProgramTypeList(lst3);
			LookupCodeValue language = null;
			intake.setCurrentProgramId(intake.getProgramId());
			if(!Utility.IsEmpty(intake.getStaffId())){
				language =lookupManager.GetLookupCode("USR", intake.getStaffId());
				String desc=language.getDescription();				
				intake.setStaffDesc(desc);				
			}
			ClientReferral clientRef = null;
			if(intakeHeadId!=null && intakeHeadId.intValue()>0)
				clientRef = clientManager.getClientReferralAutoByIntake(intakeHeadId);
			else clientRef = clientManager.getClientReferralAutoByIntake(intake.getId());
			request.setAttribute("programId", intake.getProgramId());
			if(clientRef != null)
			{
				if(!Utility.IsEmpty(clientRef.getRejectionReason()))					
				{
					intake.setCompletionNotes(clientRef.getCompletionNotes());
					intake.setRejectionReasonDesc(clientRef.getRejectionReasonDesc());
				}
				else{
					intake.setCompletionNotes("");
					intake.setRejectionReasonDesc("");
				}
			}
			qform.setIntake(intake);
			 language = null;
			LookupCodeValue originalCountry = null;
			if (intakeId.intValue() != 0) {
				
				language = lookupManager.GetLookupCode("LNG", intake.getLanguage());
				originalCountry = lookupManager.GetLookupCode("CNT", intake.getOriginalCountry());
			}
			if (language == null)
				language = new LookupCodeValue();
			if (originalCountry == null)
				originalCountry = new LookupCodeValue();
			
			qform.setLanguage(language);
			qform.setOriginalCountry(originalCountry);

			setProgramEditable(request, intake, intakeHeadId);
			super.setScreenMode(request, KeyConstants.TAB_CLIENT_INTAKE);
			
			return mapping.findForward("edit");
		} catch (NoAccessException e) {
			return mapping.findForward("failure");
		}
	}

	// this method loads a intake edit page from the program queue
	public ActionForward manualreferral(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			QuatroIntakeEditForm qform = (QuatroIntakeEditForm) form;

			String clientId = qform.getClientId();
			Integer programId = Integer.valueOf(request
					.getParameter("programId"));

		    super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, programId, KeyConstants.ACCESS_WRITE);

			Integer referralId = Integer.valueOf(request.getParameter("referralId"));

			HashMap actionParam = new HashMap();
			actionParam.put("clientId", clientId);
			actionParam.put("intakeId", "0");
			request.setAttribute("actionParam", actionParam);

			request.setAttribute("fromManualReferralId", referralId);

			Demographic client = super.getClient(request, Integer.valueOf(clientId));
			qform.setDob(MyDateFormat.getStandardDate(client.getDateOfBirth()));
			qform.setClient(client);

			com.quatro.web.intake.OptionList optionValues = intakeManager
					.LoadOptionsList(true);
			qform.setOptionList(optionValues);

			QuatroIntake intake;

			intake = new QuatroIntake();
			intake.setCreatedOn(Calendar.getInstance());
			intake.setId(new Integer(0));
			intake.setClientId(Integer.valueOf(qform.getClientId()));
			intake.setIntakeStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
			intake.setStaffId((String) request.getSession().getAttribute(
					KeyConstants.SESSION_KEY_PROVIDERNO));
			// intake.setYouth(KeyConstants.CONSTANT_NO);
			// intake.setVAW(KeyConstants.CONSTANT_NO);
			intake.setProgramId(programId);
			if(programManager.getProgram(programId).isBed()) 
				intake.setProgramType(KeyConstants.BED_PROGRAM_TYPE);
			else
				intake.setProgramType(KeyConstants.SERVICE_PROGRAM_TYPE);

			Integer shelterId = (Integer) request.getSession().getAttribute(
					KeyConstants.SESSION_KEY_SHELTERID);
			ArrayList lst = (ArrayList) programManager.getProgramIds(shelterId,
					(String) request.getSession().getAttribute(
							KeyConstants.SESSION_KEY_PROVIDERNO));
			ArrayList lst2 = new ArrayList();
			ArrayList lst3 = new ArrayList();
			for (int i = 0; i < lst.size(); i++) {
				Object[] obj = (Object[]) lst.get(i);
				lst2.add(new LabelValueBean((String) obj[1], ((Integer) obj[0])
						.toString()));
				lst3.add(new LabelValueBean((String) obj[2], ((Integer) obj[0])
						.toString()));
			}
			qform.setProgramList(lst2);
			qform.setProgramTypeList(lst3);

			intake.setCurrentProgramId(new Integer(0));
			qform.setIntake(intake);

			LookupCodeValue language = null;
			LookupCodeValue originalCountry = null;
			if (language == null)
				language = new LookupCodeValue();
			if (originalCountry == null)
				originalCountry = new LookupCodeValue();

			qform.setLanguage(language);
			qform.setOriginalCountry(originalCountry);

			setProgramEditable(request, intake, null);
			if(intake.getProgramType().equals(KeyConstants.PROGRAM_TYPE_Bed))
				request.setAttribute("isBedProgram", Boolean.TRUE);
				else request.setAttribute("isBedProgram", Boolean.FALSE);
			request.setAttribute("PROGRAM_TYPE_Bed",
					KeyConstants.PROGRAM_TYPE_Bed);
			super.setScreenMode(request, KeyConstants.TAB_CLIENT_INTAKE);
			return mapping.findForward("edit");
		} catch (NoAccessException e) {
			return mapping.findForward("failure");
		}
	}

	public ActionForward programChange(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		ActionMessages messages = new ActionMessages();
		request.setAttribute("newClientChecked",request.getParameter("newClientChecked"));
		try {
			QuatroIntakeEditForm qform = (QuatroIntakeEditForm) form;
			if(qform.getOptionList() == null) throw new NoAccessException();
			String clientId = qform.getClientId();
			if (Utility.IsEmpty(clientId))
				clientId = "0";
			if (clientId.equals("0")) request.setAttribute("newClientFlag", "true");
			QuatroIntake intake = qform.getIntake();
			Demographic client = qform.getClient();
			String cd = request.getParameter("quatroIntakeEditForm_language.code");
			
			if (!Utility.IsEmpty(cd)) {
				LookupCodeValue lcv = lookupManager.GetLookupCode("LNG", cd);
				qform.setLanguage(lcv);
			}
			cd = request.getParameter("quatroIntakeEditForm_originalCountry.code");
			if (!Utility.IsEmpty(cd)) {
				LookupCodeValue lcv = lookupManager.GetLookupCode("CNT", cd);
				qform.setOriginalCountry(lcv);
			}

			if (!clientId.equals("") && !"0".equals(clientId)) {
				List intakeHeads = intakeManager
						.getActiveIntakeByProgramByClient(Integer
								.valueOf(clientId), intake.getProgramId());
				for (int i = 0; i < intakeHeads.size(); i++) {
					QuatroIntakeHeader qih = (QuatroIntakeHeader) intakeHeads
							.get(i);
					if (qih.getId().equals(intake.getId()))
						continue;
					if (qih.getProgramType().equals(
							KeyConstants.SERVICE_PROGRAM_TYPE)) {
						if (qih.getEndDate() != null
								&& qih.getEndDate().before(
										Calendar.getInstance()))
							continue;
						messages.add(ActionMessages.GLOBAL_MESSAGE,
								new ActionMessage(
										"error.intake.duplicated_intake",
										request.getContextPath(), qih
												.getProgramName()));
						saveMessages(request, messages);
						break;
					} else if (qih.getProgramType().equals(
							KeyConstants.BED_PROGRAM_TYPE)) {
						messages.add(ActionMessages.GLOBAL_MESSAGE,
								new ActionMessage(
										"error.intake.duplicated_intake",
										request.getContextPath(), qih
												.getProgramName()));
						saveMessages(request, messages);
						break;
					}
				}
			}

			HashMap actionParam = new HashMap();
			actionParam.put("clientId", clientId);
			actionParam.put("intakeId", intake.getId().toString());
			request.setAttribute("clientId", clientId);
			request.setAttribute("actionParam", actionParam);
			request.setAttribute("client", client);
			request.setAttribute("fromManualReferralId", request
					.getParameter("fromManualReferralId"));
			String intakeHeadId = request.getParameter("intakeHeadId");
			request.setAttribute("intakeHeadId", intakeHeadId);
			if (Utility.IsEmpty(intakeHeadId))
				intakeHeadId = "0";
			setAgeGenderReadonly(request, intake);
			
			
			setProgramEditable(request, intake, Integer.valueOf(intakeHeadId));

			super.setScreenMode(request, KeyConstants.TAB_CLIENT_INTAKE);
			request.setAttribute("pageChanged", "1");
			if(Utility.IsEmpty(intake.getProgramType()) && intake.getProgramId().intValue()>0){
				if(programManager.getProgram(intake.getProgramId()).isBed()) 
					intake.setProgramType(KeyConstants.BED_PROGRAM_TYPE);
				else
					intake.setProgramType(KeyConstants.SERVICE_PROGRAM_TYPE);
			}
			
			return mapping.findForward("edit");
		} catch (NoAccessException e) {
			return mapping.findForward("failure");
		}
	}
	public ActionForward queue(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response) 
	{
		return mapping.findForward("admission");
	}
	private void setProgramEditable(HttpServletRequest request,
			QuatroIntake intake, Integer intakeHeadId) {
		boolean isEditable = true;
		if (!intake.getIntakeStatus().equals(KeyConstants.INTAKE_STATUS_ACTIVE)) {
			isEditable = false;
		} else {
			isEditable = (intakeHeadId == null || intakeHeadId.intValue() == 0
					// || intake.getId().equals(intakeHeadId)
			);
		}
		request.setAttribute("programId", intake.getProgramId());
		request.setAttribute("programEditable", Boolean.valueOf(isEditable));

		boolean isBedProgram = false;
		if(intake.getProgramType() != null)
			isBedProgram = intake.getProgramType().equals(KeyConstants.PROGRAM_TYPE_Bed);
		
		request.setAttribute("PROGRAM_TYPE_Bed",KeyConstants.PROGRAM_TYPE_Bed);
		request.setAttribute("admitable",Boolean.FALSE);			
		if (isBedProgram && intake.getId().intValue()>0 && intake.getIntakeStatus().equals("active"))
		{
			if (intakeHeadId.intValue()==0 || intakeHeadId.intValue()>0 && intake.getId().equals(intakeHeadId)) 
   			 {
   				 request.setAttribute("admitable", Boolean.TRUE);
   			 }
		}
		ClientReferral clientRef = clientManager.getClientReferralAutoByIntake(intake.getId());
		if(clientRef == null)
		{
			request.setAttribute("referralId", Integer.valueOf("0"));
		}
		else
		{
			request.setAttribute("referralId", clientRef.getId());
		}
	}

	private void setAgeGenderReadonly(HttpServletRequest request,
			QuatroIntake intake) {
		if (KeyConstants.INTAKE_STATUS_ADMITTED
				.equals(intake.getIntakeStatus())) {
			request.setAttribute("ageGenderReadOnly", Boolean.TRUE);
		}
		else
		{
			request.setAttribute("ageGenderReadOnly", Boolean.FALSE);
		}
	}

	private boolean validateDuplicate(QuatroIntake intake, Demographic client,
			HttpServletRequest request, ActionMessages messages) {
		boolean valid = true;

		ClientSearchFormBean criteria = new ClientSearchFormBean();
		criteria.setActive("");
		criteria.setAssignedToProviderNo("");
		criteria.setLastName(request.getParameter("client.lastName"));
		criteria.setFirstName(request.getParameter("client.firstName"));
		criteria.setDob(request.getParameter("dob"));
		criteria.setGender(request.getParameter("client.sex"));
		List lst = clientManager.search(criteria, false, true);
		if (lst.size() > 0) {
			messages
					.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
							"error.intake.duplicated_client", request
									.getContextPath()));
			saveMessages(request, messages);
			return false;

		}
		return valid;

	}

	private boolean validateInputWarning(QuatroIntake intake,
			Demographic client, HttpServletRequest request,
			ActionMessages messages) {
		boolean hasWarning = false;
		// check gender conflict and age conflict
		// if(intake.getProgramType().equals(KeyConstants.BED_PROGRAM_TYPE)){
		Program program = programManager.getProgram(intake.getProgramId());
		if (clientRestrictionManager.checkGenderConflict(program, client)) {
			messages
					.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
							"warning.intake.gender_conflict", request
									.getContextPath()));
			hasWarning = true;
		}
		if (clientRestrictionManager.checkAgeConflict(program, client)) {
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
					"warning.intake.age_conflict", request.getContextPath()));
			hasWarning = true;
		}
		// }
		return hasWarning;

	}

	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		ActionMessages messages = new ActionMessages();
		boolean isError = false;
		boolean isWarning = false;
		boolean isNew = false;
		Integer duplicatedReferralId = new Integer(0);
		request.setAttribute("newClientChecked",request.getParameter("newClientChecked"));
		try {
			QuatroIntakeEditForm qform = (QuatroIntakeEditForm) form;
			for(int i=0; i< 10000000; i++)
			{
				String a =  "";
			}
			Demographic client = qform.getClient();
			QuatroIntake intake = qform.getIntake();
			if (intake.getId() == null || intake.getId().intValue() == 0)
			{
				super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, intake.getProgramId(), KeyConstants.ACCESS_WRITE);
				isNew = true;
			}
			else
				super.getAccess(request, KeyConstants.FUN_CLIENTINTAKE, intake.getProgramId(), KeyConstants.ACCESS_UPDATE);

			String providerNo = (String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
			Integer intakeHeadId = new Integer(0);
			if (!Utility.IsEmpty(request.getParameter("intakeHeadId")))
				intakeHeadId = Integer.valueOf(request.getParameter("intakeHeadId"));
			request.setAttribute("intakeHeadId", request.getParameter("intakeHeadId"));
			setProgramEditable(request, intake, intakeHeadId);

			// check for new client duplication
			if (intake.getClientId().intValue() == 0
					&& !request.getParameter("newClientChecked").equals("Y")
					&& !validateDuplicate(intake, client, request, messages)) {
				request.setAttribute("newClientFlag", "true");
				HashMap actionParam2 = new HashMap();
				actionParam2.put("clientId", intake.getClientId());
				actionParam2.put("intakeId", intake.getId().toString());
				request.setAttribute("actionParam", actionParam2);
				request.setAttribute("fromManualReferralId", request.getParameter("fromManualReferralId"));
				super.setScreenMode(request, KeyConstants.TAB_CLIENT_INTAKE);
				return mapping.findForward("edit");
			}
			client.setDemographicNo(intake.getClientId());
			client.setDateOfBirth(MyDateFormat.getCalendar(qform.getDob()));
			client.setProviderNo(providerNo);
			client.setLastUpdateDate(Calendar.getInstance());
			if (qform.getClient().getEffDateTxt().equals("")) {
				client.setEffDate(new Date());
			} else {
				client.setEffDate(MyDateFormat.getSysDate(qform.getClient().getEffDateTxt()));
			}

			/* intake */
			if (null != intake.getEndDateTxt()) {
				intake.setEndDate(MyDateFormat.getCalendar(intake.getEndDateTxt()));
			}
			intake.setLastUpdateDate(Calendar.getInstance());
			
			// get program type
			Program prog = programManager.getProgram(intake.getProgramId());
			if (prog != null) {
				intake.setProgramType(prog.getType());
			}
			// boolean programChange =
			// !intake.getCurrentProgramId().equals(intake.getProgramId());
			if (!"Y".equals(request.getParameter(KeyConstants.CONFIRMATION_CHECKBOX_NAME))
					&& KeyConstants.INTAKE_STATUS_ACTIVE.equals(intake.getIntakeStatus())) {
				isWarning = validateInputWarning(intake, client, request,messages);
				// check service restriction
				// if(programChange){
				ProgramClientRestriction restrInPlace = clientRestrictionManager.checkClientRestriction(intake.getProgramId(), intake.getClientId(), new Date());
				if (restrInPlace != null && request.getParameter("skipError") == null) {
					List programs = qform.getProgramList();
					for (int i = 0; i < programs.size(); i++) {
						LabelValueBean obj3 = (LabelValueBean) programs.get(i);
						if (obj3.getValue().equals(intake.getProgramId().toString())) {
							if (intake.getProgramType().equals(KeyConstants.BED_PROGRAM_TYPE))
							{
								messages.add(ActionMessages.GLOBAL_MESSAGE,
								new ActionMessage("warning.intake.service_restriction",	request.getContextPath(),obj3.getLabel()));
								isWarning = true;
								break;
							} else {
								messages.add(ActionMessages.GLOBAL_MESSAGE,
								new ActionMessage("error.intake.service_restriction",request.getContextPath(),obj3.getLabel()));
								isError = true;
								break;
							}
						}
					}

					if (isError) {
						saveMessages(request, messages);
						HashMap actionParam = new HashMap();
						actionParam.put("clientId", client.getDemographicNo());
						actionParam.put("intakeId", intake.getId().toString());
						if (intakeHeadId.intValue() != 0) {
							Integer intakeHeadClientId = intakeManager.getQuatroIntakeDBByIntakeId(intakeHeadId).getClientId();
							request.setAttribute("clientId",intakeHeadClientId);
						} else {
							request.setAttribute("clientId", client.getDemographicNo());
						}
						request.setAttribute("actionParam", actionParam);
						request.setAttribute("client", client);
						intake.setClientId(client.getDemographicNo());
						request.setAttribute("fromManualReferralId", request.getParameter("fromManualReferralId"));
						super.setScreenMode(request,KeyConstants.TAB_CLIENT_INTAKE);
						return mapping.findForward("edit");
					}
				}
				// }
				if (isWarning) {
					messages.add(ActionMessages.GLOBAL_MESSAGE,
							new ActionMessage("warning.intake.overwrite_conflict",request.getContextPath()));
					saveMessages(request, messages);
					HashMap actionParam = new HashMap();
					actionParam.put("clientId", client.getDemographicNo());
					actionParam.put("intakeId", intake.getId().toString());
					if (intakeHeadId.intValue() != 0) {
						Integer intakeHeadClientId = intakeManager.getQuatroIntakeDBByIntakeId(intakeHeadId).getClientId();
						request.setAttribute("clientId", intakeHeadClientId);
					} else {
						request.setAttribute("clientId", client.getDemographicNo());
					}
					request.setAttribute("actionParam", actionParam);
					request.setAttribute("client", client);
					intake.setClientId(client.getDemographicNo());
					request.setAttribute("fromManualReferralId", request.getParameter("fromManualReferralId"));
					super.setScreenMode(request,KeyConstants.TAB_CLIENT_INTAKE);
					return mapping.findForward("edit");
				}
			}
			intake.setNerverExpiry(request.getParameter("intake.nerverExpiry"));
			if(!"1".equals(intake.getNerverExpiry()) ||KeyConstants.BED_PROGRAM_TYPE.equals(intake.getProgramType())) intake.setNerverExpiry("0");
			// check service program end date
			if (intake.getEndDate() != null	&& MyDateFormat.isBefore(intake.getEndDate(), Calendar.getInstance())) {
				if (intake.getProgramType().equals(	KeyConstants.SERVICE_PROGRAM_TYPE))
					messages.add(ActionMessages.GLOBAL_MESSAGE,
							new ActionMessage("warning.intake.serviceprogram_enddate",request.getContextPath()));
				else if (intake.getProgramType().equals(KeyConstants.BED_PROGRAM_TYPE))
					messages.add(ActionMessages.GLOBAL_MESSAGE,
							new ActionMessage("warning.intake.bedprogram_enddate",request.getContextPath()));
				saveMessages(request, messages);
				HashMap actionParam = new HashMap();
				actionParam.put("clientId", client.getDemographicNo());
				actionParam.put("intakeId", intake.getId().toString());
				if (intakeHeadId.intValue() != 0) {
					Integer intakeHeadClientId = intakeManager.getQuatroIntakeDBByIntakeId(intakeHeadId).getClientId();
					request.setAttribute("clientId", intakeHeadClientId);
				} else {
					request.setAttribute("clientId", client.getDemographicNo());
				}
				request.setAttribute("actionParam", actionParam);
				request.setAttribute("client", client);
				intake.setClientId(client.getDemographicNo());
				request.setAttribute("fromManualReferralId", request.getParameter("fromManualReferralId"));
				setAgeGenderReadonly(request, intake);
				setProgramEditable(request, intake, intakeHeadId);
				super.setScreenMode(request, KeyConstants.TAB_CLIENT_INTAKE);
				return mapping.findForward("edit");
			}
			if(intake.getProgramType().equals(KeyConstants.SERVICE_PROGRAM_TYPE))
			{
				if (intake.getEndDate() != null	&& "1".equals(intake.getNerverExpiry())){
					messages.add(ActionMessages.GLOBAL_MESSAGE,
					new ActionMessage("error.intake.serviceprogram_restriction",request.getContextPath()));
					saveMessages(request, messages);
					
					HashMap actionParam = new HashMap();
					actionParam.put("clientId", client.getDemographicNo());
					actionParam.put("intakeId", intake.getId().toString());
					request.setAttribute("clientId", client.getDemographicNo());
					request.setAttribute("actionParam", actionParam);
					request.setAttribute("client", client);
					request.setAttribute("fromManualReferralId", request.getParameter("fromManualReferralId"));
					setAgeGenderReadonly(request, intake);
					setProgramEditable(request, intake, intakeHeadId);
					super.setScreenMode(request,KeyConstants.TAB_CLIENT_INTAKE);
					return mapping.findForward("edit");
				}
			}
			if (intake.getClientId().intValue() > 0) {
				List intakeHeads = intakeManager.getActiveIntakeByProgramByClient(intake.getClientId(),	intake.getProgramId());
				for (int i = 0; i < intakeHeads.size(); i++) {
					QuatroIntakeHeader qih = (QuatroIntakeHeader) intakeHeads.get(i);
					if (qih.getId().equals(intake.getId()))
						continue;
					if (qih.getProgramType().equals(KeyConstants.SERVICE_PROGRAM_TYPE)) {
						if (qih.getEndDate() != null && qih.getEndDate().before(Calendar.getInstance()))
							continue;
						messages.add(ActionMessages.GLOBAL_MESSAGE,
								new ActionMessage("error.intake.duplicated_intake",	request.getContextPath(), qih.getProgramName()));
						saveMessages(request, messages);

						HashMap actionParam = new HashMap();
						actionParam.put("clientId", client.getDemographicNo());
						actionParam.put("intakeId", intake.getId().toString());
						request.setAttribute("clientId", client.getDemographicNo());
						request.setAttribute("actionParam", actionParam);
						request.setAttribute("client", client);
						request.setAttribute("fromManualReferralId", request.getParameter("fromManualReferralId"));
						setAgeGenderReadonly(request, intake);
						setProgramEditable(request, intake, intakeHeadId);
						super.setScreenMode(request,KeyConstants.TAB_CLIENT_INTAKE);
						return mapping.findForward("edit");
					} else if (qih.getProgramType().equals(KeyConstants.BED_PROGRAM_TYPE)) {
						messages.add(ActionMessages.GLOBAL_MESSAGE,
								new ActionMessage("error.intake.duplicated_intake",
										request.getContextPath(), qih.getProgramName()));
						saveMessages(request, messages);
						HashMap actionParam = new HashMap();
						actionParam.put("clientId", client.getDemographicNo());
						actionParam.put("intakeId", intake.getId().toString());
						request.setAttribute("clientId", client.getDemographicNo());
						request.setAttribute("actionParam", actionParam);
						request.setAttribute("client", client);
						request.setAttribute("fromManualReferralId", request.getParameter("fromManualReferralId"));
						setAgeGenderReadonly(request, intake);
						setProgramEditable(request, intake, intakeHeadId);
						super.setScreenMode(request,KeyConstants.TAB_CLIENT_INTAKE);
						return mapping.findForward("edit");
					}
				}
			}

			if (intake.getCreatedOnTxt().equals("") == false) {
				intake.setCreatedOn(MyDateFormat.getCalendarwithTime(intake.getCreatedOnTxt()));
			} else {
				Calendar cal = Calendar.getInstance();
				intake.setCreatedOn(cal);
				intake.setCreatedOnTxt(MyDateFormat.getStandardDateTime(cal));
			}

			if (intake.getId().intValue() == 0)
				intake.setIntakeStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
			intake.setLanguage(request.getParameter("quatroIntakeEditForm_language.code"));
			intake.setOriginalCountry(request.getParameter("quatroIntakeEditForm_originalCountry.code"));

			intake.setPregnant(request.getParameter("intake.pregnant"));
			intake.setDisclosedAbuse(request.getParameter("intake.disclosedAbuse"));
			intake.setObservedAbuse(request.getParameter("intake.observedAbuse"));
			intake.setDisclosedMentalIssue(request.getParameter("intake.disclosedMentalIssue"));
			intake.setPoorHygiene(request.getParameter("intake.poorHygiene"));
			intake.setObservedMentalIssue(request.getParameter("intake.observedMentalIssue"));
			intake.setDisclosedAlcoholAbuse(request.getParameter("intake.disclosedAlcoholAbuse"));
			intake.setObservedAlcoholAbuse(request.getParameter("intake.observedAlcoholAbuse"));
			intake.setBirthCertificateYN(request.getParameter("intake.birthCertificateYN"));
			intake.setSINYN(request.getParameter("intake.SINYN"));
			intake.setHealthCardNoYN(request.getParameter("intake.healthCardNoYN"));
			intake.setDriverLicenseNoYN(request.getParameter("intake.driverLicenseNoYN"));
			intake.setCitizenCardNoYN(request.getParameter("intake.citizenCardNoYN"));
			intake.setNativeReserveNoYN(request.getParameter("intake.nativeReserveNoYN"));
			intake.setVeteranNoYN(request.getParameter("intake.veteranNoYN"));
			intake.setRecordLandingYN(request.getParameter("intake.recordLandingYN"));
			intake.setLibraryCardYN(request.getParameter("intake.libraryCardYN"));
			intake.setStaffId(providerNo);
			
			intake.setLastUpdateDate(new GregorianCalendar());
			String sourceIncome = request.getParameter("intake.sourceIncome");
			if (Utility.IsEmpty(sourceIncome)) {
				intake.setSourceIncome(new String[] {});
			}
			LookupCodeValue language = new LookupCodeValue();
			language.setCode(request.getParameter("quatroIntakeEditForm_language.code"));
			language.setDescription(request.getParameter("quatroIntakeEditForm_language.description"));
			LookupCodeValue originalCountry = new LookupCodeValue();
			originalCountry.setCode(request.getParameter("quatroIntakeEditForm_originalCountry.code"));
			originalCountry.setDescription(request.getParameter("quatroIntakeEditForm_originalCountry.description"));
			qform.setLanguage(language);
			qform.setOriginalCountry(originalCountry);

			Integer shelterId = (Integer) request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);

			// no more than one mannual referral exists for same clientId and
			// programId.
			boolean intakeExist = false; // flag for same clientId and
			// programId
			if (intake.getClientId().intValue() > 0) {
				List queues = programQueueManager.getProgramQueuesByClientIdProgramId(intake.getClientId(), intake.getProgramId());
				if (queues.size() > 0) {
					ProgramQueue queue = (ProgramQueue) queues.get(0);
					if (queue.getFromIntakeId() == null) {
						duplicatedReferralId = queue.getReferralId();
					} else {
						if (intake.getId() != null	&& intake.getId().intValue() > 0 && !queue.getFromIntakeId().equals(intake.getId()))
							intakeExist = true;
					}
				}
			}

			if (intake.getId().intValue() == 0 && intakeManager.checkExistBedIntakeByFacility(intake.getClientId(), intake.getProgramId()).size() > 0) {
				messages.add(ActionMessages.GLOBAL_MESSAGE, 
						new ActionMessage("error.intake.duplicate_bedprogram_intake", request.getContextPath()));
				isError = true;
			} else if (intakeExist) {
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
						"error.referral.duplicated_queue", request.getContextPath()));
				isError = true;
			} else {
				Integer fromManualReferralId = null;
				if (!request.getParameter("fromManualReferralId").equals(""))
					fromManualReferralId = new Integer(request.getParameter("fromManualReferralId"));

				if (duplicatedReferralId.intValue() > 0	&& fromManualReferralId == null)
					fromManualReferralId = duplicatedReferralId;
				boolean isFamilyMember = (intakeHeadId.intValue() > 0 && intake.getId().intValue() != intakeHeadId.intValue());
				// boolean isFamilityMember = (intakeHeadId.intValue() > 0);
				ArrayList lst2 = intakeManager.saveQuatroIntake(client, intake,	intakeHeadId, isFamilyMember, fromManualReferralId);
				Integer intakeId = (Integer) lst2.get(0);
				Integer queueId = new Integer(0);
				if (lst2.get(2) != null)
					queueId = (Integer) lst2.get(2);
				intake.setId(intakeId);
				intake.setCurrentProgramId(intake.getProgramId());
				qform.setIntake(intake);
				request.setAttribute("queueId", queueId);

				if(isNew) {		
					isWarning =  copyFamily(request, fromManualReferralId, intake, messages);
				}
				
			}

			HashMap actionParam = new HashMap();
			actionParam.put("clientId", client.getDemographicNo());
			actionParam.put("intakeId", intake.getId().toString());
			request.setAttribute("clientId", client.getDemographicNo());
			request.setAttribute("actionParam", actionParam);
			request.setAttribute("client", client);
			request.setAttribute("fromManualReferralId", request
					.getParameter("fromManualReferralId"));

			if (!(isWarning || isError)) {
				if (duplicatedReferralId.intValue() > 0)
					messages.add(ActionMessages.GLOBAL_MESSAGE,
					new ActionMessage("message.intake.saved_with_duplicated_queue",	request.getContextPath()));
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
						"message.save.success", request.getContextPath()));
			} else if (isWarning) {
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("warning.intake.saved_with_warning"));
			}
			saveMessages(request, messages);
			request.setAttribute("pageChanged", "");
			request.setAttribute("PROGRAM_TYPE_Bed",KeyConstants.PROGRAM_TYPE_Bed);
			if(intake.getProgramType().equals(KeyConstants.PROGRAM_TYPE_Bed))
				request.setAttribute("isBedProgram", Boolean.TRUE);
				else request.setAttribute("isBedProgram", Boolean.FALSE);
			setAgeGenderReadonly(request, intake);
			setProgramEditable(request, intake, intakeHeadId);
			super.cacheClient(request, intake.getClientId());
			super.setCurrentIntakeProgramId(request, intake.getClientId(), shelterId, providerNo);
			super.setScreenMode(request, KeyConstants.TAB_CLIENT_INTAKE);
			return mapping.findForward("edit");
		} catch (NoAccessException e) {
			return mapping.findForward("failure");
		}
	}
	private boolean copyFamily(HttpServletRequest request,
			Integer fromReferralId, QuatroIntake headIntakeTo, ActionMessages messages) {
		boolean isWarning = false;
		if(fromReferralId == null) return isWarning;
		ClientReferral refer = clientManager.getClientReferral(fromReferralId.toString());
		Integer fromIntakeId = refer.getFromIntakeId();
		
		List dependents = intakeManager
				.getClientFamilyByIntakeId(fromIntakeId);
		if(dependents.size()<= 1 ) return isWarning; //the family include family head (this client)

		Integer programId = headIntakeTo.getProgramId();
		Program program = programManager
				.getProgram(headIntakeTo.getProgramId());
		for (int i = 0; i < dependents.size(); i++) {
			QuatroIntakeFamily obj3 = (QuatroIntakeFamily) dependents.get(i);
			if(obj3.getClientId().equals(headIntakeTo.getClientId())) continue;

			// check gender conflict and age conflict
			Demographic client = clientManager.getClientByDemographicNo(obj3
					.getClientId().toString());
			String clientName = client.getLastName() + ", " + client.getFirstName();
			if (clientRestrictionManager.checkGenderConflict(program, client)) {
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
						"warning.intake.gender_conflict_dep", request.getContextPath(), clientName));
				isWarning = true;
			}
			if (clientRestrictionManager.checkAgeConflict(program, client)) {
				messages.add(ActionMessages.GLOBAL_MESSAGE,
						new ActionMessage("warning.intake.age_conflict_dep",
								request.getContextPath(),clientName));
				isWarning = true;
			}

			// check service restriction
			obj3.setServiceRestriction("N");
			if (obj3.getClientId().intValue() > 0) {
				ProgramClientRestriction restrInPlace = clientRestrictionManager.checkClientRestriction(programId, obj3.getClientId(),new Date());
				if (restrInPlace != null) {
					obj3.setServiceRestriction("Y");
					messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage(
											"warning.intake.service_restriction_dep",
											request.getContextPath(), program.getName(),clientName));
					isWarning = true;
				}
			}
		}

		QuatroIntakeFamily intakeFamilyHead = new QuatroIntakeFamily();
		intakeFamilyHead.setIntakeHeadId(headIntakeTo.getId());
		intakeFamilyHead.setIntakeId(headIntakeTo.getId());
		intakeFamilyHead.setMemberStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
		intakeFamilyHead.setRelationship(KeyConstants.FAMILY_HEAD_CODE);
		intakeFamilyHead.setJoinFamilyDate(headIntakeTo.getCreatedOn());
		intakeFamilyHead.setLastUpdateUser(headIntakeTo.getStaffId());
		intakeFamilyHead.setLastUpdateDate(Calendar.getInstance());

		intakeManager.saveQuatroIntakeFamilyHead(intakeFamilyHead);

		for (int i = 0; i < dependents.size(); i++) {
			QuatroIntakeFamily intakeFamily = (QuatroIntakeFamily) dependents.get(i);
			if(intakeFamily.getClientId().equals(headIntakeTo.getClientId())) continue;
			QuatroIntake intake = intakeManager.getQuatroIntake(intakeFamily.getIntakeId());
			Demographic client = clientManager.getClientByDemographicNo(intakeFamily.getClientId().toString());
			QuatroIntakeDB newClient_intakeDBExist = null;
			if (intakeFamily.getIntakeId().intValue() == 0) {
				newClient_intakeDBExist = intakeManager.findActiveQuatroIntakeDB(intakeFamily.getClientId(),programId);
				if (newClient_intakeDBExist != null)
					intakeFamily.setIntakeId(newClient_intakeDBExist.getId());
			}

			intake.setId(Integer.valueOf("0"));
			intake.setProgramId(programId);
			intake.setCreatedOn(Calendar.getInstance());
			intake.setIntakeStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
			intake.setReferredBy(headIntakeTo.getReferredBy());
			intake.setContactName(headIntakeTo.getContactName());
			intake.setContactNumber(headIntakeTo.getContactNumber());
			intake.setContactEmail(headIntakeTo.getContactEmail());

			intake.setLanguage(headIntakeTo.getLanguage());
			intake.setAboriginal(headIntakeTo.getAboriginal());
			intake.setAboriginalOther(headIntakeTo.getAboriginalOther());
			intake.setVAW(headIntakeTo.getVAW());
			intake.setCurSleepArrangement(headIntakeTo.getCurSleepArrangement());
			intake.setLivedBefore(headIntakeTo.getLivedBefore());
			intake.setOriginalCountry(headIntakeTo.getOriginalCountry());
			intake.setStaffId(headIntakeTo.getStaffId());
			intake.setLastUpdateDate(new GregorianCalendar());
			intake.setEndDate(headIntakeTo.getEndDate());
			
			intakeFamily.setJoinFamilyDate(MyDateFormat.getCalendarwithTime(intakeFamily.getJoinFamilyDateTxt()));
			intakeFamily.setMemberStatus(KeyConstants.INTAKE_STATUS_ACTIVE);
			intakeFamily.setIntakeHeadId(headIntakeTo.getId());
			intakeFamily.setLastUpdateUser(headIntakeTo.getStaffId());
			intakeFamily.setLastUpdateDate(Calendar.getInstance());
			intakeManager.saveQuatroIntakeFamily(false, client, headIntakeTo.getId(), intake, newClient_intakeDBExist, intakeFamily);
		}

		return isWarning;
	}

	public ClientManager getClientManager() {
		return clientManager;
	}

	public void setClientManager(ClientManager clientManager) {
		this.clientManager = clientManager;
	}

	public LookupManager getLookupManager() {
		return lookupManager;
	}

	public void setLookupManager(LookupManager lookupManager) {
		this.lookupManager = lookupManager;
	}


	public void setIntakeManager(IntakeManager intakeManager) {
		this.intakeManager = intakeManager;
	}
	public IntakeManager getIntakeManager() {
		return this.intakeManager;
	}

	public void setProgramManager(ProgramManager programManager) {
		this.programManager = programManager;
	}

	public void setClientRestrictionManager(
			ClientRestrictionManager clientRestrictionManager) {
		this.clientRestrictionManager = clientRestrictionManager;
	}

	public void setProgramQueueManager(ProgramQueueManager programQueueManager) {
		this.programQueueManager = programQueueManager;
	}

}
