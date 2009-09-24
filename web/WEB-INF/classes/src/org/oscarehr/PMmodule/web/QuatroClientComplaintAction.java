/*******************************************************************************
 * Copyright (c) 2008, 2009 Quatro Group Inc. and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU General Public License
 * which accompanies this distribution, and is available at
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Contributors:
 *     <Quatro Group Software Systems inc.>  <OSCAR Team>
 *******************************************************************************/
package org.oscarehr.PMmodule.web;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ComplaintManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.web.formbean.QuatroClientComplaintForm;

import oscar.MyDateFormat;

import com.quatro.common.KeyConstants;
import com.quatro.model.Complaint;
import com.quatro.model.LookupCodeValue;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;
import com.quatro.util.Utility;

public class QuatroClientComplaintAction extends BaseClientAction {

	private ComplaintManager complaintManager;

	private LookupManager lookupManager;
	private ClientManager clientManager;
	private ProgramManager programManager;
    private IntakeManager intakeManager;
	
	public void setClientManager(ClientManager clientManager) {
		this.clientManager = clientManager;
	}

	public ActionForward unspecified(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		return list(mapping, form, request, response);
	}

	private ActionForward list(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			super.setScreenMode(request, KeyConstants.TAB_CLIENT_COMPLAINT);
	
			Integer clientId = super.getClientId(request);
			String providerNo = (String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
			Integer shelterId = (Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
	
			List complaints = complaintManager.getComplaintsByClientId(clientId, providerNo, shelterId);
	
			request.setAttribute("complaints", complaints);
			
			return mapping.findForward("list");
		} catch (NoAccessException e) {
			return mapping.findForward("failure");
		}
	}

	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		boolean readOnly= false;
		System.out
				.println("=========== edit ========= in QuatroClientComplaintAction");
		try {
			super.setScreenMode(request, KeyConstants.TAB_CLIENT_COMPLAINT);
	
			QuatroClientComplaintForm complaintForm = (QuatroClientComplaintForm) form;
	
			String complaintId = request.getParameter("complaintId");
			if (complaintId == null && complaintForm.getComplaint() != null
					&& complaintForm.getComplaint().getId() != null)
				complaintId = complaintForm.getComplaint().getId().toString();
	
			Complaint complaint = null;
			if (complaintId == null || "0".equals(complaintId)) {
				super.getAccess(request, KeyConstants.FUN_CLIENTCOMPLAINT, null, KeyConstants.ACCESS_WRITE);
				complaint = new Complaint();
				complaint.setStandardsBreached("0");
				complaintForm.setIsStandards("1");
			} else {
				complaint = complaintManager
						.getComplaint(Integer.valueOf(complaintId));
			}
			super.getAccess(request, KeyConstants.FUN_CLIENTCOMPLAINT, complaint.getProgramId());
			if (complaint.getCompletedDate() != null)
				complaint.setCompletedDatex(MyDateFormat.getStandardDate(complaint
						.getCompletedDate()));
			if (complaint.getCreatedDate() != null)
				complaint.setCreatedDatex(MyDateFormat.getStandardDate(complaint
						.getCreatedDate()));
			if (complaint.getDate1() != null)
				complaint.setDate1x(MyDateFormat.getStandardDate(complaint
						.getDate1()));
			if (complaint.getDate2() != null)
				complaint.setDate2x(MyDateFormat.getStandardDate(complaint
						.getDate2()));
			if (complaint.getDate3() != null)
				complaint.setDate3x(MyDateFormat.getStandardDate(complaint
						.getDate3()));
			if (complaint.getDate4() != null)
				complaint.setDate4x(MyDateFormat.getStandardDate(complaint
						.getDate4()));
			complaintForm.setIsStandards(complaint.isStandardsRelated()?"on":null);
			String standards = complaint.getStandards();
			if (standards != null) {
				String[] standards1 = standards.split(",");
				complaint.setStandards1(standards1);
			}
					

			if(null==complaint.getId() || complaint.getId().intValue()==0) {
				complaint.setStatus("0");
			}else{
			readOnly=super.isReadOnly(request,complaint.getComplaintStatus(), KeyConstants.FUN_CLIENTCOMPLAINT,complaint.getProgramId());
				if(readOnly)request.setAttribute("isReadOnly", Boolean.valueOf(readOnly));
			}
		
			
			
			complaintForm.setComplaint(complaint);
			Integer clientId = super.getClientId(request);
			String providerNo = (String)request.getSession().getAttribute("user");
			Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
			 List programIds =clientManager.getRecentProgramIds(clientId,providerNo,shelterId);
		     List programs = null;
		     if (programIds.size() > 0) {
			     String progs = ((Integer)programIds.get(0)).toString();
			     for (int i=1; i<programIds.size(); i++)
			     {
			   	   progs += "," + ((Integer)programIds.get(i)).toString();
			     }
			     programs =  lookupManager.LoadCodeList("PRO", !readOnly, progs, null);
		      }
		      else
		      {
		    	  throw new NoAccessException();
		      }
			complaintForm.setPrograms(programs);
			List sources = lookupManager.LoadCodeList("CPS", !readOnly,
					null, null);
			List methods = lookupManager.LoadCodeList("CPM", !readOnly,
					null, null);
			List outcomes = lookupManager.LoadCodeList("CPO",
					!readOnly, null, null);
			List allSections = lookupManager.LoadCodeList("CPB",
					!readOnly, null, null);
	
			int length = (allSections.size()) / 2; // value of offset in JSP file
			int parentPlace = 0;
			for (int i = 0; i < allSections.size(); i++) {
				LookupCodeValue item = (LookupCodeValue)allSections.get(i);
				if (item.getCode().equals(item.getParentCode())) { // section
					item.setParentCode("0");
					parentPlace = i;
					if (i < length && length - i < 2)
						length = length - 1;
	
				} else { // subsection
					if (i >= length && parentPlace < length)
						length = i + 1;
				}
	
			}
	
			complaintForm.setSources(sources);
			complaintForm.setMethods(methods);
			complaintForm.setOutcomes(outcomes);
			complaintForm.setSections(allSections);
			
			request.setAttribute("ComplaintForm_length", new Integer(length));
			
			return mapping.findForward("edit");
		} catch (NoAccessException e) {
			return mapping.findForward("failure");
		}
	   catch(SQLException e)
	   {
			return mapping.findForward("failure");
	   }
	}

	public ActionForward save(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		ActionMessages messages = new ActionMessages();
		try {
			super.setScreenMode(request, KeyConstants.TAB_CLIENT_COMPLAINT);
	
			QuatroClientComplaintForm complaintForm = (QuatroClientComplaintForm) form;
			Complaint complaint = complaintForm.getComplaint();
			if(complaint.getId() != null && complaint.getId().intValue() > 0)
				super.getAccess(request, KeyConstants.FUN_CLIENTCOMPLAINT, complaint.getProgramId(),KeyConstants.ACCESS_UPDATE);
			else
				super.getAccess(request, KeyConstants.FUN_CLIENTCOMPLAINT, complaint.getProgramId(),KeyConstants.ACCESS_WRITE);

			complaint.setDate1(MyDateFormat.getCalendar(complaint.getDate1x()));
			complaint.setDate2(MyDateFormat.getCalendar(complaint.getDate2x()));
			complaint.setDate3(MyDateFormat.getCalendar(complaint.getDate3x()));
			complaint.setDate4(MyDateFormat.getCalendar(complaint.getDate4x()));
	
			if (complaint.getCompletedDatex() != null
					&& complaint.getCompletedDatex().length() > 0) {
				complaint.setCompletedDate(MyDateFormat.getCalendar(complaint
						.getCompletedDatex()));
				complaint.setStatus("1");
			} else {
				complaint.setStatus("0");
			}
			if (complaint.getId() == null || complaint.getId().intValue() == 0) {
				complaint.setId(null);
				complaint.setCreatedDate(Calendar.getInstance());
				complaint.setClientId(super.getClientId(request));
			} else {
				String str = complaint.getCreatedDatexFromPage();
				Calendar c = MyDateFormat.getCalendar(str);
				complaint.setCreatedDate(c);
			}
			String providerNo=(String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
			// checkboxes
			String isChecked = complaintForm.getIsStandards();
			complaint.setStandardsRelated("on".equals(isChecked));
			complaint.setLastUpdateUser(providerNo);
			complaint.setLastUpdateDate(new GregorianCalendar());
			if(complaint.isStandardsRelated()){
				
				String[] standards1 = complaint.getStandards1();
				StringBuffer sb = new StringBuffer();
				for (int i = 0; i < standards1.length; i++) {
					sb.append("," + standards1[i]);
				}
				
				complaint.setStandards(sb.toString());
				
			}else{
				complaint.setStandards("");
			}

			complaintManager.save(complaint);

			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
					"message.save.success", request.getContextPath()));
			saveMessages(request, messages);
			complaintForm.setComplaint(complaint);

		} catch (NoAccessException e) {
			return mapping.findForward("failure");
		} catch (Exception e) {
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
					"error.saveComplaint.failed", request.getContextPath()));
			saveMessages(request, messages);

		}
		return edit(mapping, form, request, response);
		// return mapping.findForward("edit");
	}

	

	public void setComplaintManager(ComplaintManager complaintManager) {
		this.complaintManager = complaintManager;
	}

	public void setLookupManager(LookupManager lookupManager) {
		this.lookupManager = lookupManager;
	}

	public void setProgramManager(ProgramManager programManager) {
		this.programManager = programManager;
	}

	public void setIntakeManager(IntakeManager intakeManager) {
		this.intakeManager = intakeManager;
	}
	public IntakeManager getIntakeManager() {
		return this.intakeManager;
	}

}
