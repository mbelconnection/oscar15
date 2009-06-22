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

package org.oscarehr.PMmodule.web.admin;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.DynaActionForm;
import org.oscarehr.PMmodule.dao.FacilityDAO;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.ProgramSignature;
import org.oscarehr.PMmodule.service.BedCheckTimeManager;
import org.oscarehr.PMmodule.service.FacilityManager;
import org.oscarehr.PMmodule.service.LogManager;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.service.ProgramQueueManager;
import org.oscarehr.PMmodule.service.ProviderManager;
import org.oscarehr.PMmodule.web.BaseProgramAction;
import org.oscarehr.PMmodule.web.formbean.ProgramManagerViewFormBean;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;
import com.quatro.util.Utility;

public class ProgramManagerAction extends BaseProgramAction {

    private FacilityManager facilityManager=null;
    private BedCheckTimeManager bedCheckTimeManager;
    private LogManager logManager;
    private ProgramManager programManager;
    private ProviderManager providerManager;
    private ProgramQueueManager programQueueManager;
    private LookupManager lookupManager;
    private IntakeManager intakeManager;

    public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        return list(mapping, form, request, response);
    }

    public ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
	    	DynaActionForm programForm = (DynaActionForm) form;
	        String searchStatus = (String) programForm.get("searchStatus");
	        String searchType = (String) programForm.get("searchType");
	        String searchFacilityId = (String) programForm.get("searchFacilityId");
	        if (Utility.IsEmpty(searchFacilityId)) searchFacilityId = "0";
	        String providerNo =(String)request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
	   		Integer shelterId=(Integer)request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
	        
	        List list =  null;
	        list = programManager.getAllPrograms(searchStatus, searchType, Integer.valueOf(searchFacilityId),providerNo,shelterId);
	    	request.setAttribute("programs", list);
	    	List lstFac=facilityManager.getActiveFacilities(providerNo,shelterId);
	        request.setAttribute("facilities",lstFac);
	        List programTypeLst = lookupManager.LoadCodeList("PTY", true, null, null);
	        request.setAttribute("programTypeLst", programTypeLst);
	        
	
	        logManager.log("read", "full program list", "", request);
	        super.setMenu(request, KeyConstants.MENU_PROGRAM);
	        return mapping.findForward("list");
    	}
    	catch(NoAccessException e)
    	{
    		return mapping.findForward("failure");
    	}
    }

    public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
	    	DynaActionForm programForm = (DynaActionForm) form;
	
	        String id = request.getParameter("programId");
	        if(id == null || id.equals(""))
	        	id = ((Integer)request.getAttribute("programId")).toString();
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT, KeyConstants.ACCESS_READ);
    		String r1Right = super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ORG_ROOT);
	        HashMap actionParam = (HashMap) request.getAttribute("actionParam");
	        if(actionParam==null){
	     	  actionParam = new HashMap();
	           actionParam.put("programId", id); 
	        }
	        request.setAttribute("actionParam", actionParam);
	        Integer programId = Integer.valueOf(id);
	        if (id != null) {
	            Program program = programManager.getProgram(id);
	
	            if (program == null) {
	                ActionMessages messages = new ActionMessages();
	                messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.missing"));
	                saveMessages(request, messages);
	
	                return list(mapping, form, request, response);
	            }
	
	            programForm.set("program", program);
	            request.setAttribute("pageTitle",program.getName() + " - Edit");
	            request.setAttribute("programName",program.getName());
	            request.setAttribute("programId", program.getId());
	            
	            programForm.set("bedCheckTimes", bedCheckTimeManager.getBedCheckTimesByProgram(Integer.valueOf(id)));
	
	            //programForm.set("programFirstSignature",programManager.getProgramFirstSignature(Integer.valueOf(id)));
	
	            //List<ProgramSignature> pss = programManager.getProgramSignatures(Integer.valueOf(id));
	            //programForm.set("programSignatures", (ProgramSignature[] ) pss.toArray(new ProgramSignature[pss.size()]));
	            //request.setAttribute("programSignatures",programManager.getProgramSignatures(Integer.valueOf(id)));
	        }
	
	        String viewTab=request.getParameter("view.tab");
	        if(Utility.IsEmpty(viewTab)) viewTab=KeyConstants.TAB_PROGRAM_GENERAL;
	        ProgramManagerViewFormBean view = (ProgramManagerViewFormBean) programForm.get("view");
	        view.setTab(viewTab);  
	       
	        if(view.getTab().equals(KeyConstants.TAB_PROGRAM_SEVICE)){
	        	 super.setEditScreenMode(request, KeyConstants.TAB_PROGRAM_SEVICE,programId);
	             boolean isReadOnly =super.isReadOnly(request, KeyConstants.FUN_PROGRAMEDIT_SERVICERESTRICTIONS, programId);
	             if(isReadOnly)request.setAttribute("isReadOnly", Boolean.valueOf(isReadOnly));        	
	        }
	        else{
	        	 super.setEditScreenMode(request, KeyConstants.TAB_PROGRAM_GENERAL,programId);
	             setEditAttributes(request, form, KeyConstants.FUN_PROGRAMEDIT);
	        }
	        
	        return mapping.findForward("edit");
	   }
	   catch(NoAccessException e)
	   {
		   return mapping.findForward("failure");
	   }

    }
    /*
    public ActionForward programSignatures(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException {
    	super.getAccess(request, KeyConstants.FUN_PROGRAM);
    	DynaActionForm programForm = (DynaActionForm) form;
        Integer programId = Integer.valueOf(request.getParameter("programId"));
        if (programId != null) {
            //List<ProgramSignature> pss = programManager.getProgramSignatures(Integer.valueOf(programId));
            //programForm.set("programSignatures", (ProgramSignature[] ) pss.toArray(new ProgramSignature[pss.size()]));
            request.setAttribute("programSignatures",programManager.getProgramSignatures(programId));
        }
        return mapping.findForward("programSignatures");
    }
	*/
    public ActionForward add(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_WRITE);
	    	DynaActionForm programForm = (DynaActionForm) form;
	    	Program prog = new Program();
	    	Integer maxDays = new Integer(oscar.OscarProperties.getInstance().getProperty("maximum_service_restriction_days_default","90"));
	    	prog.setMaximumServiceRestrictionDays(maxDays);
	        programForm.set("program", new Program());
	        
	        request.setAttribute("pageTitle","Program Management - New Program");
	        
	        setEditAttributes(request, form, KeyConstants.FUN_PROGRAMEDIT);
	
	        return mapping.findForward("edit");
	   }
	   catch(NoAccessException e)
	   {
		   return mapping.findForward("failure");
	   }
    }

    /*
    public ActionForward addBedCheckTime(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        String programId = request.getParameter("programId");
        String addTime = request.getParameter("addTime");

        BedCheckTime bedCheckTime = BedCheckTime.create(Integer.valueOf(programId), addTime);
        bedCheckTimeManager.addBedCheckTime(bedCheckTime);

        return edit(mapping, form, request, response);
    }
    public ActionForward assign_role(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        caisi_ProgramProvider provider = (caisi_ProgramProvider) programForm.get("provider");

        caisi_ProgramProvider pp = programManager.getProgramProvider(String.valueOf(provider.getId()));

        pp.setRoleId(provider.getRoleId());

        programManager.saveProgramProvider(pp);

        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
        saveMessages(request, messages);

        logManager.log("write", "edit program - assign role", String.valueOf(program.getId()), request);
        programForm.set("provider", new caisi_ProgramProvider());

        setEditAttributes(request, String.valueOf(program.getId()));

        return mapping.findForward("edit");
    }

    public ActionForward assign_team(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        caisi_ProgramProvider provider = (caisi_ProgramProvider) programForm.get("provider");

        caisi_ProgramProvider pp = programManager.getProgramProvider(String.valueOf(provider.getId()));

        ProgramTeam team = programManager.getProgramTeam(request.getParameter("teamId"));

        if (team != null) {
            pp.getTeams().add(team);
        }

        programManager.saveProgramProvider(pp);

        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
        saveMessages(request, messages);

        logManager.log("write", "edit program - assign team", String.valueOf(program.getId()), request);
        programForm.set("provider", new caisi_ProgramProvider());

        setEditAttributes(request, String.valueOf(program.getId()));

        return mapping.findForward("edit");
    }
*/  
    
/*
    public ActionForward assign_team_client(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        Admission admission = (Admission) programForm.get("admission");

        Admission ad = admissionManager.getAdmission(admission.getId());

        ad.setTeamId(admission.getTeamId());

        admissionManager.saveAdmission(ad);

        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
        saveMessages(request, messages);

        logManager.log("write", "edit program - assign client to team", String.valueOf(program.getId()), request);

        setEditAttributes(request, String.valueOf(program.getId()));

        return mapping.findForward("edit");
    }
*/
/*
    public ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException {
		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_WRITE);
        String id = request.getParameter("programId");
        String name = request.getParameter("name");

        if (id == null) {
            return list(mapping, form, request, response);
        }

//           * have to make sure 1) no clients 2) no queue
          Program program = programManager.getProgram(id);
        if (program == null) {
            ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.missing", name));
            saveMessages(request, messages);
            return list(mapping, form, request, response);
        }

        int numAdmissions = admissionManager.getCurrentAdmissionsByProgramId(id).size();
        if (numAdmissions > 0) {
            ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.delete.admission", name, String.valueOf(numAdmissions)));
            saveMessages(request, messages);
            return list(mapping, form, request, response);
        }

        int numQueue = programQueueManager.getProgramQueuesByProgramId(Integer.valueOf(id)).size();
        if (numQueue > 0) {
            ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.delete.queue", name, String.valueOf(numQueue)));
            saveMessages(request, messages);
            return list(mapping, form, request, response);
        }

        programManager.removeProgram(id);
        
        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.deleted", request.getContextPath(), name));
        saveMessages(request, messages);

        logManager.log("write", "delete program", String.valueOf(program.getId()), request);

        return list(mapping, form, request, response);
    }
*/
/*
    public ActionForward delete_function(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
	    	DynaActionForm programForm = (DynaActionForm) form;
	        Program program = (Program) programForm.get("program");
	        ProgramFunctionalUser function = (ProgramFunctionalUser) programForm.get("function");
	
	        programManager.deleteFunctionalUser(String.valueOf(function.getId()));
	
	        ActionMessages messages = new ActionMessages();
	        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
	        saveMessages(request, messages);
	        logManager.log("write", "edit program - delete function user", String.valueOf(program.getId()), request);
	
	        this.setEditAttributes(request, form);
	
	        return edit(mapping, form, request, response);
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
    }
*/
/*
    public ActionForward delete_provider(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        caisi_ProgramProvider pp = (caisi_ProgramProvider) programForm.get("provider");

        if (pp.getId() != null && pp.getId().intValue() >= 0) {
            programManager.deleteProgramProvider(String.valueOf(pp.getId()));

            ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
            saveMessages(request, messages);

            logManager.log("write", "edit program - delete provider", String.valueOf(program.getId()), request);
        }
        this.setEditAttributes(request, String.valueOf(program.getId()));
        programForm.set("provider", new caisi_ProgramProvider());

        return edit(mapping, form, request, response);
    }
*/
/*    
    public ActionForward delete_team(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        ProgramTeam team = (ProgramTeam) programForm.get("team");

        if (programManager.getAllProvidersInTeam(program.getId(), team.getId()).size() > 0 || programManager.getAllClientsInTeam(program.getId(), team.getId()).size() > 0) {

            ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.team.not_empty", program.getName()));
            saveMessages(request, messages);

            this.setEditAttributes(request, String.valueOf(program.getId()));
            return edit(mapping, form, request, response);
        }

        programManager.deleteProgramTeam(String.valueOf(team.getId()));

        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
        saveMessages(request, messages);

        this.setEditAttributes(request, String.valueOf(program.getId()));
        programForm.set("function", new ProgramFunctionalUser());

        return edit(mapping, form, request, response);
    }
*/
    
/*
    public ActionForward edit_function(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
	    	DynaActionForm programForm = (DynaActionForm) form;
	        Program program = (Program) programForm.get("program");
	        ProgramFunctionalUser function = (ProgramFunctionalUser) programForm.get("function");
	
	        ProgramFunctionalUser pfu = programManager.getFunctionalUser(String.valueOf(function.getId()));
	
	        if (pfu == null) {
	            ActionMessages messages = new ActionMessages();
	            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_function.missing"));
	            saveMessages(request, messages);
	            setEditAttributes(request, form);
	            return edit(mapping, form, request, response);
	        }
	        programForm.set("function", pfu);
	        request.setAttribute("providerName", pfu.getProvider().getFormattedName());
	
	        setEditAttributes(request, form);
	
	        return mapping.findForward("edit");
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
    }
*/
/*
    public ActionForward edit_provider(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        caisi_ProgramProvider provider = (caisi_ProgramProvider) programForm.get("provider");

        caisi_ProgramProvider pp = programManager.getProgramProvider(String.valueOf(provider.getId()));

        if (pp == null) {
            ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_provider.missing"));
            saveMessages(request, messages);
            setEditAttributes(request, String.valueOf(program.getId()));
            return edit(mapping, form, request, response);
        }
        programForm.set("provider", pp);
        request.setAttribute("providerName", pp.getProvider().getFormattedName());

        logManager.log("write", "edit program - edit provider", String.valueOf(program.getId()), request);

        setEditAttributes(request, String.valueOf(program.getId()));

        return mapping.findForward("edit");
    }

    public ActionForward edit_team(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        ProgramTeam team = (ProgramTeam) programForm.get("team");

        ProgramTeam pt = programManager.getProgramTeam(String.valueOf(team.getId()));

        if (pt == null) {
            ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_team.missing"));
            saveMessages(request, messages);
            setEditAttributes(request, String.valueOf(program.getId()));
            return edit(mapping, form, request, response);
        }
        programForm.set("team", pt);
        setEditAttributes(request, String.valueOf(program.getId()));

        return mapping.findForward("edit");
    }
*/
/*
    public ActionForward removeBedCheckTime(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("programId");
        String removeId = request.getParameter("removeId");

        bedCheckTimeManager.removeBedCheckTime(Integer.valueOf(removeId));

        return edit(mapping, form, request, response);
    }
*/
/*
    public ActionForward remove_queue(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
	    	DynaActionForm programForm = (DynaActionForm) form;
	        Program program = (Program) programForm.get("program");
	        ProgramQueue queue = (ProgramQueue) programForm.get("queue");
	
	        ProgramQueue fullQueue = programQueueManager.getProgramQueue(String.valueOf(queue.getId()));
	//        fullQueue.setStatus(KeyConstants.STATUS_REMOVED);
	        programQueueManager.saveProgramQueue(fullQueue);
	
	        logManager.log("write", "edit program - queue removal", String.valueOf(program.getId()), request);
	
	        setEditAttributes(request, form);
	
	        return mapping.findForward("edit");
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
    }
*/
/*
    public ActionForward remove_team(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        ProgramProvider provider = (ProgramProvider) programForm.get("provider");

        ProgramProvider pp = programManager.getProgramProvider(String.valueOf(provider.getId()));

        String teamId = request.getParameter("teamId");

        if (teamId != null && teamId.length() > 0) {
        	Integer team_id = Integer.valueOf(teamId);

            for (Object o : pp.getTeams()) {
                ProgramTeam team = (ProgramTeam) o;

                if (team.getId() == team_id) {
                    pp.getTeams().remove(team);
                    break;
                }
            }

            programManager.saveProgramProvider(pp);
        }

        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
        saveMessages(request, messages);

        logManager.log("write", "edit program - assign team (removal)", String.valueOf(program.getId()), request);
        programForm.set("provider", new ProgramProvider());

        setEditAttributes(request, String.valueOf(program.getId()));

        return mapping.findForward("edit");
    }
*/
    
    public ActionForward save_restriction_settings(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT_SERVICERESTRICTIONS,KeyConstants.ACCESS_UPDATE);
	    	DynaActionForm programForm = (DynaActionForm) form;
	
	        Program program = (Program) programForm.get("program");
	        Program realProgram = programManager.getProgram(program.getId());
	
	        Integer maxRestrictionDays = program.getMaximumServiceRestrictionDays();
	        Integer defaultRestrictionDays = program.getDefaultServiceRestrictionDays();

	        if(maxRestrictionDays == null) maxRestrictionDays = new Integer(0);
	        if(defaultRestrictionDays == null) defaultRestrictionDays = new Integer(0);

	        if (maxRestrictionDays.intValue() != 0 && defaultRestrictionDays.intValue() > maxRestrictionDays.intValue()) {
	            ActionMessages messages = new ActionMessages();
	            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.default_restriction_exceeds_maximum", request.getContextPath(),defaultRestrictionDays, maxRestrictionDays));
	            saveMessages(request, messages);
	            setEditAttributes(request, form, KeyConstants.FUN_PROGRAMEDIT_SERVICERESTRICTIONS);
	
	            return edit(mapping, form, request, response);
	        }
	        // copy over modified attributes
	        realProgram.setDefaultServiceRestrictionDays(defaultRestrictionDays);
	       // if (maxRestrictionDays != null && maxRestrictionDays.intValue() != 0)
	        realProgram.setMaximumServiceRestrictionDays(maxRestrictionDays);
	        
	        // save program & sign the modification of the program
	        programManager.saveProgram(realProgram);
	        
	        
	        ActionMessages messages = new ActionMessages();
	        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.save.success", request.getContextPath()));
	        saveMessages(request, messages);
	
	        logManager.log("write", "edit program", String.valueOf(program.getId()), request);
	
	        setEditAttributes(request, form, KeyConstants.FUN_PROGRAMEDIT_SERVICERESTRICTIONS);
	
	        return edit(mapping, form, request, response);
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
    }
/*
	public void changeLstTable(int operationType, ActionForm myForm,
			HttpServletRequest request) {
		
//		ActionMessages messages = new ActionMessages();
		
		ArrayList newStaffLst = new ArrayList();
		ArrayList existStaffLst = new ArrayList();

		
		switch (operationType) {
		
		case REMOVE: // remove
			newStaffLst = (ArrayList)getRowList(request, myForm, REMOVE);
			break;
			
		case ADD: // add
			newStaffLst = (ArrayList)getRowList(request, myForm, ADD);
			
			// add one more
			newStaffLst.add(new Secuserrole());
			
			break;
			
		case RESET: // reset
				
			// add one more
			//newStaffLst.add(new Secuserrole());
			
			break;

		}
		
		existStaffLst = (ArrayList)getStaffList(request, myForm, ADD);
		request.setAttribute("existStaffLst", existStaffLst);
		
		request.setAttribute("newStaffLst", newStaffLst);

	}
*/	
/*
	private List getStaffList(HttpServletRequest request, ActionForm form, int operationType){
		
		ArrayList newStaffLst = new ArrayList();
		ArrayList staffIdLstForRemove = new ArrayList();
		
		//ProgramManagerViewFormBean programManagerViewForm = (ProgramManagerViewFormBean) form;
		//String providerNo = (String) secuserForm.get("providerNo");

		Map map = request.getParameterMap();
		String[] arr_lineno = (String[]) map.get("lineno2");
		int lineno = 0;
		if (arr_lineno != null)
			lineno = arr_lineno.length;
		
		for (int i = 1; i <= lineno; i++) {
			
			String[] isChecked = (String[]) map.get("p2" + i);
			if ((operationType == REMOVE && isChecked == null) || operationType != REMOVE) {

				Secuserrole objNew = new Secuserrole();
				
				String[] providerNo = (String[]) map
						.get("providerNo2" + i);
				String[] providerName = (String[]) map
						.get("providerName2" + i);
				String[] role_code = (String[]) map
						.get("role_code2" + i);
				String[] role_description = (String[]) map
						.get("role_description2" + i);
				String[] id = (String[]) map
						.get("id" + i);
		
				if (providerNo != null)
					objNew.setProviderNo(providerNo[0]);
				if (providerName != null)
					objNew.setProviderName(providerName[0]);
				if (role_code != null)
					objNew.setRoleName(role_code[0]);
				if (role_description != null)
					objNew.setRoleName_desc(role_description[0]);
				if (id != null)
					objNew.setId(Integer.valueOf(id[0]));
		
				newStaffLst.add(objNew);
			}
			
			if (operationType == REMOVE && isChecked != null ) {

				Integer id = Integer.valueOf(isChecked[0]);
		
				staffIdLstForRemove.add(id);
			}
			
			
		}
		request.setAttribute("staffIdLstForRemove", staffIdLstForRemove);
		
		return newStaffLst;
	}
	private List getRowList(HttpServletRequest request, ActionForm form, int operationType){
		
		ArrayList newStaffLst = new ArrayList();
		
		//ProgramManagerViewFormBean programManagerViewForm = (ProgramManagerViewFormBean) form;
		//String providerNo = (String) secuserForm.get("providerNo");

		Map map = request.getParameterMap();
		String[] arr_lineno = (String[]) map.get("lineno");
		int lineno = 0;
		if (arr_lineno != null)
			lineno = arr_lineno.length;
		
		for (int i = 0; i < lineno; i++) {
			
			String[] isChecked = (String[]) map.get("p" + i);
			if ((operationType == REMOVE && isChecked == null) || operationType != REMOVE) {

				Secuserrole objNew = new Secuserrole();
				
				String[] providerNo = (String[]) map
						.get("providerNo" + i);
				String[] providerName = (String[]) map
						.get("providerName" + i);
				String[] role_code = (String[]) map
						.get("role_code" + i);
				String[] role_description = (String[]) map
						.get("role_description" + i);
		
				if (providerNo != null)
					objNew.setProviderNo(providerNo[0]);
				if (providerName != null)
					objNew.setProviderName(providerName[0]);
				if (role_code != null)
					objNew.setRoleName(role_code[0]);
				if (role_description != null)
					objNew.setRoleName_desc(role_description[0]);
				
		
				newStaffLst.add(objNew);
			}
			
		}
		return newStaffLst;
	}
*/
    /*
	private void processStaff( HttpServletRequest request, Integer programId, ProgramManagerViewFormBean formBean){
    	
    	changeLstTable(RESET, formBean, request);
    	
    	
    	//List lst = programManager.getProgramProviders("P" + programId);
    	
    	//request.setAttribute("existStaffLst", lst);
    	
    	    	
    	String mthd = request.getParameter("mthd");
    	
    	StaffForm staffForm = null;
    	
		List lst = new ArrayList();
		if(mthd != null && mthd.equals("search")){
			
	    	String orgcd = "P" + programId;
	    	
			staffForm = formBean.getStaffForm();
			staffForm.setOrgcd(orgcd);
			lst =  // providerManager.getActiveProviders(programId);
				programManager.searchStaff(staffForm);
			
		}else{
			staffForm = new StaffForm();
			formBean.setStaffForm(staffForm);
			lst = programManager.getProgramProviders("P" + programId, true);
		}
		
		request.setAttribute("existStaffLst", lst);		
   	
    }
*/
    public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
	    	DynaActionForm programForm = (DynaActionForm) form;	
	        Program program = (Program) programForm.get("program");
	        boolean isNew = false;
	        try {
	            program.setFacilityId(Integer.valueOf(request.getParameter("programManagerForm_program.facilityId")));
	        }
	        catch (NumberFormatException e) {
	            e.printStackTrace();
	        }
	        if(program.getId() != null && program.getId().intValue() > 0)
	        {
	        	Program programOld = programManager.getProgram(program.getId());
	        	if (programOld == null || programOld.getFacilityId().intValue() != program.getFacilityId().intValue())
	        	{
	        		isNew = true;
	        	}
	        }
	        if(isNew)
	        {
	        	super.getAccess(request, KeyConstants.FUN_PROGRAM,KeyConstants.ACCESS_WRITE);
	        }
	        else
	        {
	    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
	        }
	        
	        program.setLastUpdateUser((String)request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO));
	        program.setLastUpdateDate(Calendar.getInstance());
	        if (this.isCancelled(request)) {
	            return list(mapping, form, request, response);
	        }
	        
	                
	        if (request.getParameter("program.allowBatchAdmission") == null) {
	            program.setAllowBatchAdmission(false);
	        }
	        if (request.getParameter("program.allowBatchDischarge") == null) {
	            program.setAllowBatchDischarge(false);
	        }
	        if (request.getParameter("program.hic") == null) {
	            program.setHic(false);
	        }
	//        if (request.getParameter("program.holdingTank") == null) {
	//            program.setHoldingTank(false);
	//        }
	//        if(request.getParameter("program.transgender") == null)
	//            program.setTransgender(false);
	//        if(request.getParameter("program.firstNation") == null)
	//            program.setFirstNation(false);
	        if(request.getParameter("program.bedProgramAffiliated") == null)
	            program.setBedProgramAffiliated(false);
	//        if(request.getParameter("program.alcohol") == null)
	//            program.setAlcohol(false);
	//        if(request.getParameter("program.physicalHealth") == null)
	//            program.setPhysicalHealth(false);
	//        if(request.getParameter("program.mentalHealth") == null)
	//            program.setMentalHealth(false);
	//        if(request.getParameter("program.housing") == null)
	//            program.setHousing(false);
	        if (request.getParameter("program.hic") == null) {
	            program.setHic(false);
	        }
	        request.setAttribute("oldProgram",program);
	
	        //if a program has a client in it, you cannot make it inactive
	        if ("0".equals(program.getProgramStatus()) && program.getId().intValue()>0) {            
	                //Admission ad = admissionManager.getAdmission(Long.valueOf(request.getParameter("id")));
	                List intakes = intakeManager.getActiveIntakeByProgram(program.getId());
	                if(intakes.size()>0){
	                    ActionMessages messages = new ActionMessages();
	                    messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.client_in_the_program", program.getName()));
	                    saveMessages(request, messages);
	                    setEditAttributes(request, form, KeyConstants.FUN_PROGRAMEDIT);
	                    return mapping.findForward("edit");
	                }
	                int numQueue = programQueueManager.getProgramQueuesByProgramId(program.getId()).size();
	                if (numQueue > 0) {
	                    ActionMessages messages = new ActionMessages();
	                    messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.client_in_the_queue", program.getName(), String.valueOf(numQueue)));
	                    saveMessages(request, messages);
	                    setEditAttributes(request, form, KeyConstants.FUN_PROGRAMEDIT);
	                   // return edit(mapping,form,request,response);  
	                    return mapping.findForward("edit");
	                }
	            }
	
	
	        if (!program.getType().equalsIgnoreCase("bed") && program.isHoldingTank()) {
	            ActionMessages messages = new ActionMessages();
	            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.invalid_holding_tank"));
	            saveMessages(request, messages);
	            setEditAttributes(request,form, KeyConstants.FUN_PROGRAMEDIT);
	           // return edit(mapping,form,request,response);
	            return mapping.findForward("edit");
	        }
	        
	        if(program.getId()!=null && program.getId().intValue()>0){
	        	Integer actCap = programManager.getProgram(program.getId()).getCapacity_actual();
	        	if((program.getCapacity_space()!=null && actCap!=null
	        			&& actCap.intValue()>program.getCapacity_space().intValue())
	        		|| (program.getCapacity_space()==null && actCap!=null 
	        				&& actCap.intValue()>0)	
	        	){
	        		ActionMessages messages = new ActionMessages();
	                messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.invalid_capacity_space",request.getContextPath(),actCap,program.getCapacity_space()));
	                saveMessages(request, messages);
	                setEditAttributes(request, form, KeyConstants.FUN_PROGRAMEDIT);
	                return mapping.findForward("edit");
	        	}        	
	        }
	        if(program.getDefaultServiceRestrictionDays() == null)
	        	program.setDefaultServiceRestrictionDays(new Integer(1));
	        
	        saveProgram(request, program);
	
	        ActionMessages messages = new ActionMessages();
	        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.save.success", request.getContextPath()));
	        saveMessages(request, messages);
	
	        logManager.log("write", "edit program", String.valueOf(program.getId()), request);
	
	        setEditAttributes(request, form, KeyConstants.FUN_PROGRAMEDIT);
	
	        return edit(mapping,form,request,response);
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
    }

    private void saveProgram(HttpServletRequest request, Program program) {
        programManager.saveProgram(program);
    }
/*    
    public ActionForward addStaff(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)throws NoAccessException {
    	String programId = request.getParameter("programId");
		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);

        if (programId == null) {
            programId = (String) request.getAttribute("programId");
        }
        request.setAttribute("programId", programId);
        Program program = programManager.getProgram(programId);
        request.setAttribute("program", program);
       
                
        if (isCancelled(request)) {
			return edit(mapping, form, request, response);
		}
		
		changeLstTable(ADD, form, request);
		
		request.setAttribute("existStaffLst", getStaffList( request, form, ADD));
		// get existing Staff List
		ProgramManagerViewFormBean formBean = (ProgramManagerViewFormBean) ((DynaActionForm)form).get("view");
		String orgcd = "P" + programId;
		StaffForm staffForm = null;
    	staffForm = formBean.getStaffForm();
		staffForm.setOrgcd(orgcd);
		List lst = programManager.searchStaff(staffForm);
		request.setAttribute("existStaffLst", lst);
		
        return mapping.findForward("edit");
    }

	public ActionForward saveStaff(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws NoAccessException {

		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
		
		String programId = request.getParameter("programId");
        if (programId == null) {
            programId = (String) request.getAttribute("programId");
        }
        request.setAttribute("programId", programId);
        String orgcd = "P" + programId;
        
		ActionMessages messages = new ActionMessages();
		List secUserRoleLst = getRowList(request, form, 0);
		ArrayList LstforSave = new ArrayList();
		
		Iterator it = secUserRoleLst.iterator();
		while(it.hasNext()){
			Secuserrole tmp = (Secuserrole)it.next();
			if(tmp.getProviderNo() != null && tmp.getProviderNo().length() > 0 && tmp.getRoleName() != null && tmp.getRoleName().length() > 0){
				tmp.setActiveyn(new Integer(1));
				tmp.setOrgcd(orgcd);
				LstforSave.add(tmp);
			}
			
		}
		
		
		if(LstforSave.size() > 0){
			try{
				//usersManager.saveRolesToUser(LstforSave);
				usersManager.saveStaffToProgram(LstforSave, orgcd);
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.save.success",
				request.getContextPath()));
				saveMessages(request,messages);	
				
			}catch(Exception e){
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.save.failed",
				request.getContextPath()));
				saveMessages(request,messages);				
			}
		}else{
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.save.failed",
			request.getContextPath()));
			saveMessages(request,messages);	
		}
		


		
//		ProgramManagerViewFormBean formBean = (ProgramManagerViewFormBean)form;
//		StaffForm staffForm = formBean.getStaffForm();
//		staffForm.setOrgcd(orgcd);
//		List lst = programManager.searchStaff(staffForm);
//		request.setAttribute("existStaffLst", lst);
		
		
		return edit(mapping,form,request,response);

	}

    public ActionForward removeStaff(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException {
		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
        
        String programId = request.getParameter("programId");

        if (programId == null) {
            programId = (String) request.getAttribute("programId");
        }
        request.setAttribute("programId", programId);
        Program program = programManager.getProgram(programId);
        request.setAttribute("program", program);
        
        //request.setAttribute("existStaffLst", getStaffList( request, form, ADD));
        
        changeLstTable(REMOVE, form, request);

        // get existing Staff List
		ProgramManagerViewFormBean formBean = (ProgramManagerViewFormBean) form;
		String orgcd = "P" + programId;
		StaffForm staffForm = null;
    	staffForm = formBean.getStaffForm();
		staffForm.setOrgcd(orgcd);
		List lst = programManager.searchStaff(staffForm);
		request.setAttribute("existStaffLst", lst);

        return mapping.findForward("view");
    }
    
    public ActionForward removeExistStaff(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException{
		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);

        String programId = request.getParameter("programId");

        if (programId == null) {
            programId = (String) request.getAttribute("programId");
        }
        request.setAttribute("programId", programId);
        Program program = programManager.getProgram(programId);
        request.setAttribute("program", program);
        
        ActionMessages messages = new ActionMessages();
        
        ArrayList existStaffLst = (ArrayList)getStaffList( request, form, REMOVE);
        ArrayList staffIdLstForRemove = (ArrayList)request.getAttribute("staffIdLstForRemove");
        
        if(staffIdLstForRemove.size() >0){
        	try{
				
	        	programManager.deleteProgramProvider(staffIdLstForRemove);
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("message.remove.success",
				request.getContextPath()));
				saveMessages(request,messages);	
				
				
				
			}catch(Exception e){
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("error.remove.failed",
				request.getContextPath()));
				saveMessages(request,messages);	
				
				
			}
        }   
        
        request.setAttribute("newStaffLst", getRowList(request, form, ADD));
//      get existing Staff List
		ProgramManagerViewFormBean formBean = (ProgramManagerViewFormBean) ((DynaValidatorForm)form).get("view");
		String orgcd = "P" + programId;
		StaffForm staffForm = null;
    	staffForm = formBean.getStaffForm();
		staffForm.setOrgcd(orgcd);
		List lst = programManager.searchStaff(staffForm);
		request.setAttribute("existStaffLst", lst);

        return edit(mapping,form,request,response);
    }
*/    
/*
    public ActionForward save_access(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        ProgramAccess access = (ProgramAccess) programForm.get("access");

        if (this.isCancelled(request)) {
            return list(mapping, form, request, response);
        }
        access.setProgramId(program.getId());

        if (programManager.getProgramAccess(String.valueOf(access.getProgramId()), access.getAccessTypeId()) != null) {
            ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.duplicate_access", program.getName()));
            saveMessages(request, messages);
            programForm.set("access", new ProgramAccess());
            setEditAttributes(request, String.valueOf(program.getId()));
            return mapping.findForward("edit");
        }

        String roles[] = request.getParameterValues("checked_role");
        if (roles != null) {
            if (access.getRoles() == null) {
                access.setRoles(new HashSet());
            }
            for (String role : roles) {
                access.getRoles().add(roleManager.getRole(role));
            }
        }

        programManager.saveProgramAccess(access);

        logManager.log("write", "access", String.valueOf(program.getId()), request);

        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
        saveMessages(request, messages);
        programForm.set("access", new ProgramAccess());
        setEditAttributes(request, String.valueOf(program.getId()));

        return mapping.findForward("edit");
    }
*/
/*    
    public ActionForward save_function(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
	    	DynaActionForm programForm = (DynaActionForm) form;
	        Program program = (Program) programForm.get("program");
	        ProgramFunctionalUser function = (ProgramFunctionalUser) programForm.get("function");
	
	        if (this.isCancelled(request)) {
	            return list(mapping, form, request, response);
	        }
	        function.setProgramId(program.getId());
	
	        Integer pid = programManager.getFunctionalUserByUserType(program.getId(), function.getUserTypeId());
	
	        if (pid != null && function.getId().intValue() != pid.intValue()) {
	            ActionMessages messages = new ActionMessages();
	            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_function.duplicate", program.getName()));
	            saveMessages(request, messages);
	            programForm.set("function", new ProgramFunctionalUser());
	       //     setEditAttributes(request, String.valueOf(program.getId()));
	            setEditAttributes(request, form);
	            return mapping.findForward("edit");
	        }
	        programManager.saveFunctionalUser(function);
	
	        ActionMessages messages = new ActionMessages();
	        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
	        saveMessages(request, messages);
	
	        logManager.log("write", "edit program - save function user", String.valueOf(program.getId()), request);
	
	        programForm.set("function", new ProgramFunctionalUser());
	        setEditAttributes(request, form);        
	        return mapping.findForward("edit");
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
    }
*/
/*
    public ActionForward save_provider(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        caisi_ProgramProvider provider = (caisi_ProgramProvider) programForm.get("provider");

        if (this.isCancelled(request)) {
            return list(mapping, form, request, response);
        }
        provider.setProgramId(program.getId());

        if (programManager.getProgramProvider(provider.getProviderNo(), String.valueOf(program.getId())) != null) {
            ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.provider.exists"));
            saveMessages(request, messages);
            programForm.set("provider", new caisi_ProgramProvider());
            setEditAttributes(request, String.valueOf(program.getId()));
            return mapping.findForward("edit");
        }

        programManager.saveProgramProvider(provider);

        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
        saveMessages(request, messages);

        logManager.log("write", "edit program - save provider", String.valueOf(program.getId()), request);
        programForm.set("provider", new caisi_ProgramProvider());
        setEditAttributes(request, String.valueOf(program.getId()));

        return mapping.findForward("edit");
    }

    public ActionForward save_team(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        DynaActionForm programForm = (DynaActionForm) form;
        Program program = (Program) programForm.get("program");
        ProgramTeam team = (ProgramTeam) programForm.get("team");

        if (this.isCancelled(request)) {
            return list(mapping, form, request, response);
        }
        team.setProgramId(program.getId());

        if (programManager.teamNameExists(program.getId(), team.getName())) {
            ActionMessages messages = new ActionMessages();
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_team.duplicate", team.getName()));
            saveMessages(request, messages);
            programForm.set("team", new ProgramTeam());
            setEditAttributes(request, String.valueOf(program.getId()));
            return mapping.findForward("edit");
        }

        programManager.saveProgramTeam(team);

        logManager.log("write", "edit program - save team", String.valueOf(program.getId()), request);

        ActionMessages messages = new ActionMessages();
        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
        saveMessages(request, messages);
        programForm.set("team", new ProgramTeam());
        setEditAttributes(request, String.valueOf(program.getId()));

        return mapping.findForward("edit");
    }
*/
    private void setEditAttributes(HttpServletRequest request, ActionForm form, String funCd ) throws NoAccessException {
		ArrayList programSignatureLst = new ArrayList();
    	 DynaActionForm programForm = (DynaActionForm) form;
    	Program program = (Program) programForm.get("program");
    	Integer programId = program.getId(); 
        String providerNo =(String)request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
   		Integer shelterId=(Integer)request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_SHELTERID);

    	if (programId != null) {
        	request.setAttribute("programId", programId);
            request.setAttribute("programName", program.getName());
        }else{
	        // signature part
	        HttpSession se=request.getSession(true);
	        ProgramSignature ps = new ProgramSignature();
	        ps.setProviderName(providerManager.getProvider(providerNo).getFormattedName());
	        ps.setProviderId(providerNo);
	        ps.setUpdateDate(Calendar.getInstance());
	        programSignatureLst.add(ps);
        }
        request.setAttribute("programSignatureLst", programSignatureLst);
        
        List programTypeLst = lookupManager.LoadCodeList("PTY", true, null, null);
        request.setAttribute("programTypeLst", programTypeLst);
        List genderLst = lookupManager.LoadCodeList("GEN", true, null, null);
        request.setAttribute("genderLst", genderLst);
        
        request.setAttribute("facilities",facilityManager.getActiveFacilities(providerNo,shelterId));
        
        boolean isReadOnly =super.isReadOnly(request, funCd, programId);
        if(isReadOnly)request.setAttribute("isReadOnly", Boolean.valueOf(isReadOnly));
 		request.setAttribute("typeEditable", Boolean.TRUE);
   		request.setAttribute("statusEditable", Boolean.TRUE);

        if(programId != null && !isReadOnly )
	    {
	       	 List intakes = intakeManager.getIntakesByProgram(programId);
	       	 if(intakes.size() > 0) {
	       		 request.setAttribute("typeEditable", Boolean.FALSE);
	       	 }
	       	 List activeIntakes = intakeManager.getActiveIntakeByProgram(programId); 
	       	 if(activeIntakes.size() > 0) {
	       		 request.setAttribute("statusEditable", Boolean.FALSE);
	       	 }
	    }
    }

/*
    public ActionForward delete_status(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
	    	DynaActionForm programForm = (DynaActionForm) form;
	        Program program = (Program) programForm.get("program");
	        ProgramClientStatus status = (ProgramClientStatus) programForm.get("client_status");
	
	        if (programManager.getAllClientsInStatus(program.getId(), status.getId()).size() > 0) {
	
	            ActionMessages messages = new ActionMessages();
	            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.status.not_empty", program.getName()));
	            saveMessages(request, messages);
	
	            this.setEditAttributes(request, form);
	            return edit(mapping, form, request, response);
	        }
	
	        programManager.deleteProgramClientStatus(String.valueOf(status.getId()));
	
	        ActionMessages messages = new ActionMessages();
	        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
	        saveMessages(request, messages);
	
	        this.setEditAttributes(request, form);
	        programForm.set("function", new ProgramFunctionalUser());
	
	        return edit(mapping, form, request, response);
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
    }

    public ActionForward edit_status(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
	    	DynaActionForm programForm = (DynaActionForm) form;
	        Program program = (Program) programForm.get("program");
	        ProgramClientStatus status = (ProgramClientStatus) programForm.get("client_status");
	
	        ProgramClientStatus pt = programManager.getProgramClientStatus(String.valueOf(status.getId()));
	
	        if (pt == null) {
	            ActionMessages messages = new ActionMessages();
	            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_status.missing"));
	            saveMessages(request, messages);
	            setEditAttributes(request, form);
	            return edit(mapping, form, request, response);
	        }
	        programForm.set("client_status", pt);
	        setEditAttributes(request, form);
	
	        return mapping.findForward("edit");
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
    }

    public ActionForward save_status(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
	    	DynaActionForm programForm = (DynaActionForm) form;
	        Program program = (Program) programForm.get("program");
	        ProgramClientStatus status = (ProgramClientStatus) programForm.get("client_status");
	
	        if (this.isCancelled(request)) {
	            return list(mapping, form, request, response);
	        }
	        status.setProgramId(program.getId());
	
	        if (programManager.clientStatusNameExists(program.getId(), status.getName())) {
	            ActionMessages messages = new ActionMessages();
	            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_status.duplicate", status.getName()));
	            saveMessages(request, messages);
	            programForm.set("client_status", new ProgramClientStatus());
	            setEditAttributes(request, form);
	            return mapping.findForward("edit");
	        }
	
	        programManager.saveProgramClientStatus(status);
	
	        logManager.log("write", "edit program - save status", String.valueOf(program.getId()), request);
	
	        ActionMessages messages = new ActionMessages();
	        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
	        saveMessages(request, messages);
	        programForm.set("client_status", new ProgramClientStatus());
	        setEditAttributes(request, form);
	
	        return mapping.findForward("edit");
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
    }

    
    public ActionForward assign_status_client(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
    	try {
    		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
	    	DynaActionForm programForm = (DynaActionForm) form;
	        Program program = (Program) programForm.get("program");
	        Admission admission = (Admission) programForm.get("admission");
	
	//        Admission ad = admissionManager.getAdmission(admission.getId());
	
	//        ad.setClientStatusId(admission.getClientStatusId());
	
	//        admissionManager.saveAdmission(ad);
	
	        ActionMessages messages = new ActionMessages();
	        messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
	        saveMessages(request, messages);
	
	        logManager.log("write", "edit program - assign client to status", String.valueOf(program.getId()), request);
	
	        setEditAttributes(request,form);
	
	        return mapping.findForward("edit");
 	   }
 	   catch(NoAccessException e)
 	   {
 		   return mapping.findForward("failure");
 	   }
    }

    
    public ActionForward disable_restriction(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException {
		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);
    	DynaActionForm programForm = (DynaActionForm) form;
	
	        ProgramClientRestriction prc = (ProgramClientRestriction) programForm.get("restriction");
	        String providerNo =(String)request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
	        prc.setProviderNo(providerNo);
	        prc.setLastUpdateDate(new GregorianCalendar());
	        clientRestrictionManager.disableClientRestriction(prc);
	
	        return edit(mapping, form, request, response);
    }

    public ActionForward enable_restriction(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException{
        DynaActionForm programForm = (DynaActionForm) form;
		super.getAccess(request, KeyConstants.FUN_PROGRAMEDIT,KeyConstants.ACCESS_UPDATE);

        ProgramClientRestriction prc = (ProgramClientRestriction) programForm.get("restriction");
        String providerNo =(String)request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
        prc.setProviderNo(providerNo);
        prc.setLastUpdateDate(new GregorianCalendar());
        clientRestrictionManager.enableClientRestriction(prc);

        return edit(mapping, form, request, response);
    }
*/
    private boolean isChanged(Program program1, Program program2) {
        boolean changed = false;

        if( 
                !program1.getName().equals(program2.getName()) ||
                !program1.getType().equals(program2.getType()) ||
                !program1.getDescr().equals(program2.getDescr()) ||
                !program1.getProgramStatus().equals(program2.getProgramStatus()) ||
                !program1.getManOrWoman().equals(program2.getManOrWoman()) ||
                (program1.isAllowBatchAdmission() ^ program2.isAllowBatchAdmission()) ||
                (program1.isAllowBatchDischarge() ^ program2.isAllowBatchDischarge()) ||
                (program1.isHic() ^ program2.isHic()) ||
                (program1.isBedProgramAffiliated() ^ program2.isBedProgramAffiliated()) ||
                (program1.getFacilityId() != program2.getFacilityId()) ||
                (program1.getCapacity_funding() != program2.getCapacity_funding()) ||
                (program1.getCapacity_space() != program2.getCapacity_space()) ||
                (program1.getAgeMax() != program2.getAgeMax()) ||
                (program1.getAgeMin() != program2.getAgeMin())
                )

            changed = true;
        
//        if( program1.getMaxAllowed().intValue() != program2.getMaxAllowed().intValue() ||
//                !program1.getName().equals(program2.getName()) ||
//                !program1.getType().equals(program2.getType()) ||
//                !program1.getDescr().equals(program2.getDescr()) ||
//                !program1.getAddress().equals(program2.getAddress()) ||
//                !program1.getPhone().equals(program2.getPhone()) ||
//                !program1.getFax().equals(program2.getFax()) ||
//                !program1.getUrl().equals(program2.getUrl()) ||
//                !program1.getEmail().equals(program2.getEmail()) ||
//                !program1.getEmergencyNumber().equals(program2.getEmergencyNumber()) ||
//                !program1.getLocation().equals(program2.getLocation()) ||
//                !program1.getProgramStatus().equals(program2.getProgramStatus()) ||
//                !program1.getBedProgramLinkId().equals(program2.getBedProgramLinkId()) ||
//                !program1.getManOrWoman().equals(program2.getManOrWoman()) ||
//                !program1.getAbstinenceSupport().equals(program2.getAbstinenceSupport()) ||
//                !program1.getExclusiveView().equals(program2.getExclusiveView()) ||
//                (program1.isHoldingTank() ^ program2.isHoldingTank()) ||
//                (program1.isAllowBatchAdmission() ^ program2.isAllowBatchAdmission()) ||
//                (program1.isAllowBatchDischarge() ^ program2.isAllowBatchDischarge()) ||
//                (program1.isHic() ^ program2.isHic()) ||
//                (program1.isTransgender() ^ program2.isTransgender()) ||
//                (program1.isFirstNation() ^ program2.isFirstNation()) ||
//                (program1.isBedProgramAffiliated() ^ program2.isBedProgramAffiliated()) ||
//                (program1.isAlcohol() ^ program2.isAlcohol()) ||
//                (program1.isPhysicalHealth() ^ program2.isPhysicalHealth()) ||
//                (program1.isMentalHealth() ^ program2.isMentalHealth()) ||
//                (program1.getFacilityId() != program2.getFacilityId()) ||
//                (program1.isHousing() ^ program2.isHousing())
//                )
//
//            changed = true;

        return changed;
    }


    public void setBedCheckTimeManager(BedCheckTimeManager bedCheckTimeManager) {
        this.bedCheckTimeManager = bedCheckTimeManager;
    }

    public void setLogManager(LogManager mgr) {
    	this.logManager = mgr;
    }

    public void setProgramManager(ProgramManager mgr) {
    	this.programManager = mgr;
    }

    public void setProgramQueueManager(ProgramQueueManager mgr) {
    	this.programQueueManager = mgr;
    }

    public void setProviderManager(ProviderManager mgr) {
    	this.providerManager = mgr;
    }

    public void setFacilityManager(FacilityManager mgr) {
    	this.facilityManager = mgr;
    }

	public void setLookupManager(LookupManager lookupManager) {
		this.lookupManager = lookupManager;
	}
	public void setIntakeManager(IntakeManager intakeManager) {
		this.intakeManager = intakeManager;
	}

}