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
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.util.LabelValueBean;
import org.caisi.model.CustomFilter;
import org.caisi.model.Tickler;
import org.caisi.model.TicklerComment;
import org.caisi.service.TicklerManager;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.service.ProviderManager;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.web.formbean.TicklerForm;

import oscar.Misc;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.IntakeManager;

public class ClientTaskAction extends BaseClientAction{
    private ClientManager clientManager;
    private ProgramManager programManager;
    private TicklerManager ticklerManager;
    private ProviderManager providerManager;
    private IntakeManager intakeManager;

    public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        return list(mapping, form, request, response);
    }

    //for My Task
    public ActionForward filter(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
    	TicklerForm ticklerForm = (TicklerForm) form;

    	Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);        
        String providerNo = (String)request.getSession().getAttribute("user");
        
        List programs=programManager.getPrograms(Program.PROGRAM_STATUS_ACTIVE, providerNo, shelterId);
        ticklerForm.setProgramLst(programs);
        
        CustomFilter filter = ticklerForm.getFilter();
        if("".equals(filter.getStatus())) {
        	filter.setStatus("Active");
        }
        List ticklers = ticklerManager.getTicklers(filter, shelterId, providerNo);

        request.setAttribute("ticklers", ticklers);
        request.setAttribute("mytask", "Y");
        
        return mapping.findForward("mytask_filter");
    }

    //for My Task save
    public ActionForward mytasksave(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ActionMessages messages = new ActionMessages();
    	TicklerForm ticklerForm = (TicklerForm) form;
    	
    	String newComment = request.getParameter("newcomment");
        String providerNo = (String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
        Tickler tickler = ticklerForm.getTickler();
        String tickler_no = tickler.getTickler_no().toString();
        Tickler tickler1 = ticklerManager.getTickler(tickler_no);

        if(tickler1 == null || !tickler1.getTask_assigned_to().equals(providerNo)) return mapping.findForward("failure");

        String status = tickler.getStatus();        
    	ticklerManager.addComment(tickler_no, providerNo, newComment,status);
    	{
    		messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("message.save.success", request.getContextPath()));
    		request.setAttribute("pageChanged", "");
    	}
        saveMessages(request,messages);
        
        return mytaskedit(mapping, form, request, response);
    }
    
    public ActionForward mytaskedit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	TicklerForm ticklerForm = (TicklerForm) form;

        String tickler_no =  request.getParameter("ticklerNo");
        request.setAttribute("ticklerNo", tickler_no);
        Tickler tickler = ticklerManager.getTickler(tickler_no);

        /* check if the task is assigned to current user */
        String providerNo = (String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
        if(tickler == null || !tickler.getTask_assigned_to().equals(providerNo)) return mapping.findForward("failure");
        
        java.util.Date service_date = tickler.getService_date();
        Calendar cal = Calendar.getInstance();
        cal.setTime(service_date);
        tickler.setService_hour(Misc.forwardZero(String.valueOf(cal.get(Calendar.HOUR)),2));
        tickler.setService_minute(Misc.forwardZero(String.valueOf(cal.get(Calendar.MINUTE)),2));
        if(cal.get(Calendar.AM_PM)==0){
           tickler.setService_ampm("AM");
        }else{
           tickler.setService_ampm("PM");
        }
        ticklerForm.setTickler(tickler);
        
        Set comments = tickler.getComments();
        Iterator iterator = comments.iterator();
        String msg="";
        while (iterator.hasNext()){
          TicklerComment tct = (TicklerComment)iterator.next();
          if(tct.getMessage()!=null && !"".equals(tct.getMessage())){
             if(msg.equals("")){
               msg = tct.getMessage();
             }else{
               msg = msg + "\n\n" + tct.getMessage();
             }
          }
        }
        
        request.setAttribute("client", tickler.getDemographic());
        request.setAttribute("comments", msg);
        if("Completed".equals(tickler.getStatus())) request.setAttribute("isReadOnly", Boolean.TRUE);
        return mapping.findForward("mytask_edit");
    }
    
    private ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	try {
	    	TicklerForm ticklerForm = (TicklerForm) form;
	
	 	    super.setScreenMode(request, KeyConstants.TAB_CLIENT_TASK);
	
	        Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);        
	        String providerNo = (String)request.getSession().getAttribute("user");
	        
	        List programs=programManager.getBedPrograms(providerNo, shelterId);
	        ticklerForm.setProgramLst(programs);
	        
	        List ticklers = ticklerManager.getTicklersByClientId(shelterId, providerNo, super.getClientId(request));
	
	        request.setAttribute("ticklers", ticklers);
	
//		    super.isReadOnly(request, "", KeyConstants.FUN_CLIENTTASKS, programId);
	        return mapping.findForward("list");
    	}
    	catch(NoAccessException e)
    	{
    		return mapping.findForward("failure");
    	}
    }
    
    public ActionForward view(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
	    	TicklerForm ticklerForm = (TicklerForm) form;
	    		
	 	    super.setScreenMode(request, KeyConstants.FUN_CLIENTTASKS);
	 	    
	        ArrayList ampmLst = new ArrayList();
	        LabelValueBean lvb1 = new LabelValueBean("AM", "AM");
	        ampmLst.add(lvb1);
	        LabelValueBean lvb2 = new LabelValueBean("PM", "PM");
	        ampmLst.add(lvb2);
	        ticklerForm.setAmpmLst(ampmLst);
	
	        ArrayList serviceHourLst = new ArrayList();
	        for(int i=1;i<=12;i++){
	          LabelValueBean lvb3 = new LabelValueBean(Misc.forwardZero(String.valueOf(i),2), Misc.forwardZero(String.valueOf(i),2));
	          serviceHourLst.add(lvb3);
	        }
	        ticklerForm.setServiceHourLst(serviceHourLst);
	
	        ArrayList serviceMinuteLst = new ArrayList();
	        for(int i=0;i<60;i++){
	          LabelValueBean lvb4 = new LabelValueBean(Misc.forwardZero(String.valueOf(i),2), Misc.forwardZero(String.valueOf(i),2));
	          serviceMinuteLst.add(lvb4);
	        }
	        ticklerForm.setServiceMinuteLst(serviceMinuteLst);
	        
	        ArrayList priorityLst = new ArrayList();
	        LabelValueBean lvb5 = new LabelValueBean("High", "High");
	        priorityLst.add(lvb5);
	        LabelValueBean lvb6 = new LabelValueBean("Normal", "Normal");
	        priorityLst.add(lvb6);
	        LabelValueBean lvb7 = new LabelValueBean("Low", "Low");
	        priorityLst.add(lvb7);
	        ticklerForm.setPriorityLst(priorityLst);
	
			Integer shelterId = (Integer) request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
			String providerNo = (String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
	        List programLst = programManager.getPrograms(super.getClientId(request), providerNo, shelterId);
	        ticklerForm.setProgramLst(programLst);
	        
	        String tickler_no =  request.getParameter("ticklerNo");
	        Tickler tickler = ticklerManager.getTickler(tickler_no);
	        
	        /* check security */
	        if(tickler==null)
	        {
	        	return mapping.findForward("failure");
	        }
	        else
	        {
	        	super.getAccess(request, KeyConstants.FUN_CLIENTTASKS, tickler.getProgram_id());
	        }
	        
	        Calendar service_date = Calendar.getInstance();
	        service_date.setTime(tickler.getService_date());
	        tickler.setService_hour(Misc.forwardZero(String.valueOf(service_date.get(Calendar.HOUR)),2));
	        tickler.setService_minute(Misc.forwardZero(String.valueOf(service_date.get(Calendar.MINUTE)),2));
	        if(service_date.get(Calendar.AM_PM)==0){
	          tickler.setService_ampm("AM");
	        }else{
	          tickler.setService_ampm("PM");
	        }
	        ticklerForm.setTickler(tickler);
	        request.setAttribute("viewTickler", "Y");
	        request.setAttribute("isReadOnly", Boolean.valueOf(true));
	
	        List providerLst = providerManager.getActiveProviders(tickler.getProgram_id());
	        ticklerForm.setProviderLst(providerLst);
	        
	        return mapping.findForward("add");
    	}
    	catch(NoAccessException e)
    	{
    		return mapping.findForward("failure");
    	}
    }
    
    public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ActionMessages messages = new ActionMessages();
        
        boolean isError = false;
        boolean isWarning = false;

        TicklerForm ticklerForm = (TicklerForm) form;
    	
    	Integer clientId = super.getClientId(request);
    	HashMap actionParam = new HashMap();
        actionParam.put("clientId", clientId); 
        request.setAttribute("actionParam", actionParam);

        Integer programId = ticklerForm.getTickler().getProgram_id();
        super.getAccess(request, KeyConstants.FUN_CLIENTTASKS, programId, KeyConstants.ACCESS_WRITE);
 	    super.setScreenMode(request, KeyConstants.FUN_CLIENTTASKS);
 	    
 	    
        Tickler tickler = (Tickler) ticklerForm.getTickler();

        tickler.setServiceTime(tickler.getService_hour() + ":" + tickler.getService_minute() + 
           		" " + tickler.getService_ampm());
        tickler.setUpdate_date(new java.util.Date());
        ticklerManager.addTickler(tickler);

        
        ArrayList ampmLst = new ArrayList();
        LabelValueBean lvb1 = new LabelValueBean("AM", "AM");
        ampmLst.add(lvb1);
        LabelValueBean lvb2 = new LabelValueBean("PM", "PM");
        ampmLst.add(lvb2);
        ticklerForm.setAmpmLst(ampmLst);

        ArrayList serviceHourLst = new ArrayList();
        for(int i=1;i<=12;i++){
          LabelValueBean lvb3 = new LabelValueBean(Misc.forwardZero(String.valueOf(i),2), Misc.forwardZero(String.valueOf(i),2));
          serviceHourLst.add(lvb3);
        }
        ticklerForm.setServiceHourLst(serviceHourLst);

        ArrayList serviceMinuteLst = new ArrayList();
        for(int i=0;i<60;i++){
          LabelValueBean lvb4 = new LabelValueBean(Misc.forwardZero(String.valueOf(i),2), Misc.forwardZero(String.valueOf(i),2));
          serviceMinuteLst.add(lvb4);
        }
        ticklerForm.setServiceMinuteLst(serviceMinuteLst);
        
        ArrayList priorityLst = new ArrayList();
        LabelValueBean lvb5 = new LabelValueBean("High", "High");
        priorityLst.add(lvb5);
        LabelValueBean lvb6 = new LabelValueBean("Normal", "Normal");
        priorityLst.add(lvb6);
        LabelValueBean lvb7 = new LabelValueBean("Low", "Low");
        priorityLst.add(lvb7);
        ticklerForm.setPriorityLst(priorityLst);

		Integer shelterId = (Integer) request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
		String providerNo = (String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
        List programLst = programManager.getPrograms(clientId, providerNo, shelterId);
        ticklerForm.setProgramLst(programLst);
        
        List providerLst = providerManager.getActiveProviders(ticklerForm.getTickler().getProgram_id());
        ticklerForm.setProviderLst(providerLst);

 	    if(!(isWarning || isError)) 
 	    {
 	    	messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("message.save.success", request.getContextPath()));
 	    	request.setAttribute("pageChanged", "");
 	    }
 	    	saveMessages(request,messages);
        
       return mapping.findForward("add");
    }
    
    public ActionForward changeProgram(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	TicklerForm ticklerForm = (TicklerForm) form;
    	Integer programId = ticklerForm.getTickler().getProgram_id();
    	super.getAccess(request, KeyConstants.FUN_CLIENTTASKS, programId,KeyConstants.ACCESS_WRITE);
    	Integer clientId = super.getClientId(request);

 	    super.setScreenMode(request, KeyConstants.FUN_CLIENTTASKS);
 	    
        ArrayList ampmLst = new ArrayList();
        LabelValueBean lvb1 = new LabelValueBean("AM", "AM");
        ampmLst.add(lvb1);
        LabelValueBean lvb2 = new LabelValueBean("PM", "PM");
        ampmLst.add(lvb2);
        ticklerForm.setAmpmLst(ampmLst);

        ArrayList serviceHourLst = new ArrayList();
        for(int i=1;i<=12;i++){
          LabelValueBean lvb3 = new LabelValueBean(Misc.forwardZero(String.valueOf(i),2), Misc.forwardZero(String.valueOf(i),2));
          serviceHourLst.add(lvb3);
        }
        ticklerForm.setServiceHourLst(serviceHourLst);

        ArrayList serviceMinuteLst = new ArrayList();
        for(int i=0;i<60;i++){
          LabelValueBean lvb4 = new LabelValueBean(Misc.forwardZero(String.valueOf(i),2), Misc.forwardZero(String.valueOf(i),2));
          serviceMinuteLst.add(lvb4);
        }
        ticklerForm.setServiceMinuteLst(serviceMinuteLst);
        
        ArrayList priorityLst = new ArrayList();
        LabelValueBean lvb5 = new LabelValueBean("High", "High");
        priorityLst.add(lvb5);
        LabelValueBean lvb6 = new LabelValueBean("Normal", "Normal");
        priorityLst.add(lvb6);
        LabelValueBean lvb7 = new LabelValueBean("Low", "Low");
        priorityLst.add(lvb7);
        ticklerForm.setPriorityLst(priorityLst);

		Integer shelterId = (Integer) request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
		String providerNo = (String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
        List programLst = programManager.getPrograms(clientId, providerNo, shelterId);
        ticklerForm.setProgramLst(programLst);
        
        List providerLst = providerManager.getActiveProviders(ticklerForm.getTickler().getProgram_id());
        ticklerForm.setProviderLst(providerLst);
        request.setAttribute("pageChanged", "1");
        return mapping.findForward("add");
    }
    
    public ActionForward add(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	TicklerForm ticklerForm = (TicklerForm) form;
    	super.getAccess(request, KeyConstants.FUN_CLIENTTASKS, null, KeyConstants.ACCESS_WRITE);
 	    super.setScreenMode(request, KeyConstants.FUN_CLIENTTASKS);

 	    Integer clientId = super.getClientId(request);
 	    Tickler tickler = new Tickler();
        tickler.setTickler_no(new Integer(0));
		String providerNo = (String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
        tickler.setCreator(providerNo);
        
        tickler.setDemographic_no(clientId);


        Calendar cal = com.quatro.util.CurrentDateTime.getCurrentDateTime();
 	    
 	    tickler.setService_date(cal.getTime());

 	    if(cal.get(Calendar.HOUR_OF_DAY)==0 || cal.get(Calendar.HOUR_OF_DAY)==12){
  	       tickler.setService_hour("12");
 	    }else{
 	       tickler.setService_hour(Misc.forwardZero(String.valueOf(cal.get(Calendar.HOUR)),2));
 	    }
 	    
 	    tickler.setService_minute(Misc.forwardZero(String.valueOf(cal.get(Calendar.MINUTE)),2));
		boolean curAm = (cal.get(Calendar.HOUR_OF_DAY) < 12) ? true : false;
        if(curAm){
 	      tickler.setService_ampm("AM");
        }else{
   	      tickler.setService_ampm("PM");
        }
        if(tickler.getPriority()==null) tickler.setPriority("Normal");
        
        ticklerForm.setTickler(tickler);
        
        ArrayList ampmLst = new ArrayList();
        LabelValueBean lvb1 = new LabelValueBean("AM", "AM");
        ampmLst.add(lvb1);
        LabelValueBean lvb2 = new LabelValueBean("PM", "PM");
        ampmLst.add(lvb2);
        ticklerForm.setAmpmLst(ampmLst);

        ArrayList serviceHourLst = new ArrayList();
        for(int i=1;i<=12;i++){
          LabelValueBean lvb3 = new LabelValueBean(Misc.forwardZero(String.valueOf(i),2), Misc.forwardZero(String.valueOf(i),2));
          serviceHourLst.add(lvb3);
        }
        ticklerForm.setServiceHourLst(serviceHourLst);

        ArrayList serviceMinuteLst = new ArrayList();
        for(int i=0;i<60;i++){
          LabelValueBean lvb4 = new LabelValueBean(Misc.forwardZero(String.valueOf(i),2), Misc.forwardZero(String.valueOf(i),2));
          serviceMinuteLst.add(lvb4);
        }
        ticklerForm.setServiceMinuteLst(serviceMinuteLst);
        
        ArrayList priorityLst = new ArrayList();
        LabelValueBean lvb5 = new LabelValueBean("High", "High");
        priorityLst.add(lvb5);
        LabelValueBean lvb6 = new LabelValueBean("Normal", "Normal");
        priorityLst.add(lvb6);
        LabelValueBean lvb7 = new LabelValueBean("Low", "Low");
        priorityLst.add(lvb7);
        ticklerForm.setPriorityLst(priorityLst);

		Integer shelterId = (Integer) request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
        List programLst = programManager.getPrograms(clientId, providerNo, shelterId);
        if(programLst.size()==0) throw new NoAccessException();
        ticklerForm.setProgramLst(programLst);
        
        ticklerForm.setProviderLst(new ArrayList());
        
        return mapping.findForward("add");
    }
    
	public void setClientManager(ClientManager clientManager) {
		this.clientManager = clientManager;
	}

	public void setProgramManager(ProgramManager programManager) {
		this.programManager = programManager;
	}

	public void setProviderManager(ProviderManager providerManager) {
		this.providerManager = providerManager;
	}

	public void setTicklerManager(TicklerManager ticklerManager) {
		this.ticklerManager = ticklerManager;
	}

	public void setIntakeManager(IntakeManager intakeManager) {
		this.intakeManager = intakeManager;
	}
	public IntakeManager getIntakeManager() {
		return this.intakeManager;
	}

}
