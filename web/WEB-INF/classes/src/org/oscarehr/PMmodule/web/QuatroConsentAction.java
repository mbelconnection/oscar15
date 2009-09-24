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

import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.DynaActionForm;
import org.oscarehr.PMmodule.model.ConsentDetail;

import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.ProgramClientRestriction;
import org.oscarehr.PMmodule.model.Provider;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ConsentManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.service.ProviderManager;
import org.oscarehr.PMmodule.web.formbean.ClientManagerFormBean;

import oscar.MyDateFormat;

import com.quatro.common.KeyConstants;
import com.quatro.model.LookupCodeValue;
import com.quatro.model.security.NoAccessException;
import com.quatro.model.signaturePad.TopazValue;
import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;
import com.quatro.service.TopazManager;
import com.quatro.util.Utility;

public class QuatroConsentAction extends BaseClientAction {
	private static Log log = LogFactory.getLog(QuatroConsentAction.class);
    private ClientManager clientManager;
    private ConsentManager consentManager;
    private LookupManager lookupManager;
    private ProviderManager providerManager;
    private ProgramManager programManager;
    private TopazManager topazManager;
    private IntakeManager intakeManager;

    public void setLookupManager(LookupManager lookupManager) {
		this.lookupManager = lookupManager;
	}

	public ActionForward unspecified(ActionMapping mapping,	ActionForm form, HttpServletRequest request, HttpServletResponse response) {		
		return list(mapping,form,request,response);
	}
	
	public ActionForward list(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
//		setListAttributes(form,request);
		try {
	
			Integer clientId = super.getClientId(request);
		    String providerNo = (String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
			Integer shelterId =(Integer)request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
		         
		    List lstConsents = consentManager.getConsentDetailByClient(clientId, providerNo,shelterId);
		    request.setAttribute("lstConsents", lstConsents);
	
		    super.setScreenMode(request, KeyConstants.TAB_CLIENT_CONSENT);
			return mapping.findForward("list");
	       }
	       catch(NoAccessException e)
	       {
		       return mapping.findForward("failure");
	       }
	}
	public ActionForward edit(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		try {
		   DynaActionForm dForm = (DynaActionForm) form;
	       ConsentDetail consentObj = (ConsentDetail)dForm.get("consentValue");
	       String  rId=(String)request.getAttribute("rId");
	       if(Utility.IsEmpty(rId)) {
		       rId=request.getParameter("rId");
	       }
	       LookupCodeValue shelter = new LookupCodeValue();
	       String providerNo = (String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
	       if("0".equals(rId))
	       {
	    	   consentObj = new ConsentDetail();
	    	   consentObj.setId(new Integer(0));
	    	   consentObj.setDemographicNo(super.getClientId(request));	  
	    	   consentObj.setProviderNo(providerNo);
	       }
	       else if(rId!=null && rId!="0"){
	    	   consentObj= consentManager.getConsentDetail(Integer.valueOf(rId));
	    	   shelter= lookupManager.GetLookupCode("SHL", consentObj.getShelterId().toString());
	    	   shelter.setBuf3(Utility.append(shelter.getBuf3(), shelter.getBuf4(), ", "));
	    	   shelter.setBuf3(Utility.append(shelter.getBuf3(), shelter.getBuf5(), ", "));
	    	   shelter.setBuf3(Utility.append(shelter.getBuf3(), shelter.getBuf6(), ", "));
	    	   shelter.setBuf3(Utility.append(shelter.getBuf3(), shelter.getBuf7(), ", "));
	    	   request.setAttribute("shelter", shelter);
	       }
	       dForm.set("consentValue", consentObj);
	       request.setAttribute("shelter", shelter);
	       request.setAttribute("recordId",rId);
		
	       setEditAttributes(form,request);
	       super.setScreenMode(request, KeyConstants.TAB_CLIENT_CONSENT);
	       return mapping.findForward("edit");
       }
       catch(NoAccessException e)
       {
	       return mapping.findForward("failure");
       }
	   catch(SQLException e)
	   {
			return mapping.findForward("failure");
	   }
	}
	 public ActionForward withdraw(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException
	 {
		 	   DynaActionForm clientForm = (DynaActionForm) form;
		       
		       ConsentDetail conObj = (ConsentDetail) clientForm.get("consentValue");
			   String recId=request.getParameter("rId");
			   if(Utility.IsEmpty(recId)) recId=request.getAttribute("rId").toString();
		       Integer rId=Integer.valueOf(recId);
			   String providerNo=(String)request.getSession().getAttribute("user");
			   conObj.setStatus(KeyConstants.STATUS_WITHDRAW);
		       
			   super.getAccess(request, KeyConstants.FUN_CLIENTCONSENT, conObj.getProgramId(),KeyConstants.ACCESS_UPDATE);
			   
			   consentManager.withdraw(rId, providerNo);
		       request.setAttribute("rId", recId);
		       return edit(mapping, form, request, response);
		   
	   }
	 private void setEditAttributes(ActionForm form, HttpServletRequest request) throws NoAccessException,SQLException {
		   DynaActionForm dForm = (DynaActionForm) form;
		   ConsentDetail cdObj =(ConsentDetail)dForm.get("consentValue");
	      // ClientManagerFormBean tabBean = (ClientManagerFormBean) clientForm.get("view");
	       
	       boolean isReadOnly = false;
	       if(cdObj != null && cdObj.getId().intValue()>0) {
	    	   Integer programId = cdObj.getProgramId();
	    	   Program prog = programManager.getProgram(programId);
		       request.setAttribute("facilityDesc",lookupManager.GetLookupCode("SHL", prog.getShelterId().toString()).getDescription());
	    	   TopazValue tv= topazManager.getTopazValue(cdObj.getId(),"consent");
	    	   if(cdObj.getStatus().equals(KeyConstants.STATUS_ACTIVE) && Calendar.getInstance().after(cdObj.getEndDate()))
   				cdObj.setStatus(KeyConstants.STATUS_EXPIRED);
		       
	    	   isReadOnly = super.isReadOnly(request, cdObj.getStatus(), KeyConstants.FUN_CLIENTCONSENT, cdObj.getProgramId());

	    	   if(tv!=null ||KeyConstants.STATUS_WITHDRAW.equals(cdObj.getStatus()) || KeyConstants.STATUS_EXPIRED.equals(cdObj.getStatus())){
		    	   request.setAttribute("signed","Y");
		    	   isReadOnly = true;
		       }
	    	   request.setAttribute("isReadOnly", Boolean.valueOf(isReadOnly));
	       }
	       else
	       {
	    	   super.getAccess(request, KeyConstants.FUN_CLIENTCONSENT, null,KeyConstants.ACCESS_WRITE);
		       request.setAttribute("facilityDesc","");
		       request.setAttribute("signed","N");
	       }

	       String providerNo = (String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
	       Provider proObj =providerManager.getProvider(providerNo);
	       if (cdObj.getId().intValue() ==0) {
	    	   cdObj.setProviderFirstName(proObj.getFirstName());
	    	   cdObj.setProviderLastName(proObj.getLastName());
	       }
	       
	       Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
	       List programIds =clientManager.getRecentProgramIds(super.getClientId(request),providerNo,shelterId);
	       List programs = null;
	       if (programIds.size() > 0) {
		       String progs = ((Integer)programIds.get(0)).toString();
		       for (int i=1; i<programIds.size(); i++)
		       {
		    	   progs += "," + ((Integer)programIds.get(i)).toString();
		       }
		       programs =  lookupManager.LoadCodeList("PRO", !isReadOnly, progs, null);
	       }
	       else
	       {
	    	   throw new NoAccessException();
	       }
	       request.setAttribute("programs", programs);
	      // request.setAttribute("signed","N");
	   }
	/*
	public ActionForward form(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		try {
			DynaActionForm consentForm = (DynaActionForm)form;
			
			String id = request.getParameter("id");
			String formName = request.getParameter("formName");
			String formMapping = getRandomForm();
			super.setScreenMode(request, KeyConstants.TAB_CLIENT_CONSENT);
			String gotoStr = request.getParameter("goto");
			
			if(id == null) {
				return mapping.findForward("error");
			}
					
			Demographic demographic = clientManager.getClientByDemographicNo(id);
			
			if(demographic == null) {
				return mapping.findForward("error");
			}
			
			ConsentDetail consent = consentManager.getConsentDetail(Integer.valueOf(id));
			Integer programId = null;
			if(consent != null) {
				consentForm.set("consentValue", consent);
				formMapping = consent.getFormName();
				programId = consent.getProgramId();
			}

			super.getAccess(request, KeyConstants.FUN_CLIENTCONSENT, programId);

			request.setAttribute("id",id);
			request.setAttribute("clientName", demographic.getFirstName() + " " + demographic.getLastName());
			
			if(gotoStr != null && !gotoStr.equals("")) {
				return new ActionForward(gotoStr);
			}
			
			if(formName != null) {
				return mapping.findForward("form" + formName.toUpperCase());
			}
			
	//        return mapping.findForward(formMapping);
			return mapping.findForward("formA");
	       }
	       catch(NoAccessException e)
	       {
		       return mapping.findForward("failure");
	       }
	}
*/	
	public ActionForward save(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
		try {
			log.debug("Saving Consent");
			ActionMessages messages = new ActionMessages();
			 boolean isError = false;
		     boolean isWarning = false;
			DynaActionForm consentForm = (DynaActionForm)form;
			super.setScreenMode(request, KeyConstants.TAB_CLIENT_CONSENT);
			ConsentDetail consent= (ConsentDetail)consentForm.get("consentValue");
			String rId=request.getParameter("recordId");
			if(Utility.IsEmpty(rId) && consent.getId()!=null) rId=consent.getId().toString();
			consent.setId(Integer.valueOf(rId));
			HashMap actionParam = (HashMap) request.getAttribute("actionParam");
		       if(actionParam==null){
		    	  actionParam = new HashMap();
		          actionParam.put("clientId", consent.getDemographicNo().toString()); 
		       }
		       request.setAttribute("actionParam", actionParam);
		       request.setAttribute("clientId", consent.getDemographicNo().toString());
		       
			Provider p =  (Provider)request.getSession().getAttribute("provider");
			consent.setProviderNo(p.getProviderNo());
			//consent.setProviderName(p.getFormattedName());		
			
			consent.setDateSigned(new GregorianCalendar());
			consent.setStartDate(new GregorianCalendar());
			String eDt = consent.getEndDateStr();
			consent.setEndDate(MyDateFormat.getCalendar(consent.getEndDateStr()));
			consent.setHardCopy(true);
			consent.setStatus(KeyConstants.STATUS_ACTIVE);
			consent.setLastUpdateDate(new GregorianCalendar());
			consent.setEndDate(MyDateFormat.getCalendar(consent.getEndDateStr()));
			if(Utility.IsEmpty(consent.getEndDateStr()) ||null== consent.getEndDate()){
				isError =true;
				messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.consent.date.failed", request.getContextPath()));
		        saveMessages(request,messages);
			}
			else if(consent.getEndDate().before(consent.getStartDate())){
				isError =true;
				messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.date.compare.failed", request.getContextPath()));
		        saveMessages(request,messages);
			}
			if(consent.getId() != null && consent.getId().intValue()> 0)
				super.getAccess(request,KeyConstants.FUN_CLIENTCONSENT,consent.getProgramId(), KeyConstants.ACCESS_UPDATE);
			else
				super.getAccess(request,KeyConstants.FUN_CLIENTCONSENT,consent.getProgramId(), KeyConstants.ACCESS_WRITE);

			if(!isError){
				consentManager.saveConsentDetail(consent);
				messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("message.save.success", request.getContextPath()));
		        saveMessages(request,messages);
		        request.setAttribute("rId", String.valueOf(consent.getId()));
		        return edit(mapping, form,request, response);
			}
			else
			{
				setEditAttributes(form,request);
				return mapping.findForward("edit");
			}
       }
       catch(NoAccessException e)
       {
	       return mapping.findForward("failure");
       }
	   catch(SQLException e)
	   {
			return mapping.findForward("failure");
	   }
	}
	
	private String getRandomForm() {
		int d = (int)(Math.random()*2);
		if(d == 0) {
			return "formA";
		}
//		return "formB";
        return "formA";
	}

    public void setClientManager(ClientManager mgr) {
    	this.clientManager = mgr;
    }


    public void setConsentManager(ConsentManager mgr) {
    	this.consentManager = mgr;
    }

	public void setProviderManager(ProviderManager providerManager) {
		this.providerManager = providerManager;
	}

	public void setTopazManager(TopazManager topazManager) {
		this.topazManager = topazManager;
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



