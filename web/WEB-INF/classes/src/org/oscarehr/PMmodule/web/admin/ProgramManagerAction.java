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

package org.oscarehr.PMmodule.web.admin;

import org.apache.struts.action.*;
import org.oscarehr.PMmodule.model.*;
import org.oscarehr.PMmodule.web.BaseAction;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

public class ProgramManagerAction extends BaseAction {

    public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		return list(mapping, form, request, response);
	}

	public ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        List<Program> programs = programManager.getAllPrograms();
        request.setAttribute("programs", programs);

        Map<Integer, String> agenciesForPrograms = new HashMap<Integer, String>();
        for (Program program : programs) {
            // get list of agencies for the program
            List<Agency> agencies = programManager.getAgenciesForProgram(program.getId());

            // now sort by agency name
            Collections.sort(agencies, new Comparator<Agency>() {

                public int compare(Agency agency, Agency agency1) {
                    return agency.getName().compareTo(agency1.getName());
                }
            });

            // now just make a list of the agency names, comma separated
            StringBuffer agencyNames = new StringBuffer();
            for (Iterator<Agency> iterator = agencies.iterator(); iterator.hasNext();) {
                Agency agency = iterator.next();
                agencyNames.append(agency.getName());
                if (iterator.hasNext())
                    agencyNames.append(", ");
            }
            agenciesForPrograms.put(program.getId(), agencyNames.toString());
        }

        // put agency associations into the page
        request.setAttribute("agenciesForPrograms", agenciesForPrograms);

        logManager.log("read", "full program list", "", request);

		return mapping.findForward("list");
	}

	public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;

		String id = request.getParameter("id");

		if (isCancelled(request)) {
			return list(mapping, form, request, response);
		}

		if (id != null) {
			Program program = programManager.getProgram(id);

			if (program == null) {
				ActionMessages messages = new ActionMessages();
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.missing"));
				saveMessages(request, messages);

				return list(mapping, form, request, response);
			}

			programForm.set("program", program);
			request.setAttribute("oldProgram",program);
			
			//request.setAttribute("programFirstSignature",programManager.getProgramFirstSignature(Integer.valueOf(id)));
			programForm.set("bedCheckTimes", bedCheckTimeManager.getBedCheckTimesByProgram(Integer.valueOf(id)));
			
			//programForm.set("programFirstSignature",programManager.getProgramFirstSignature(Integer.valueOf(id)));
			
			//List<ProgramSignature> pss = programManager.getProgramSignatures(Integer.valueOf(id));
			//programForm.set("programSignatures", (ProgramSignature[] ) pss.toArray(new ProgramSignature[pss.size()]));
			//request.setAttribute("programSignatures",programManager.getProgramSignatures(Integer.valueOf(id)));
			setEditAttributes(request, id);
		}

		return mapping.findForward("edit");
	}
	public ActionForward programSignatures(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		String programId = request.getParameter("programId");
		if (programId != null) {
			//List<ProgramSignature> pss = programManager.getProgramSignatures(Integer.valueOf(programId));
			//programForm.set("programSignatures", (ProgramSignature[] ) pss.toArray(new ProgramSignature[pss.size()]));
			request.setAttribute("programSignatures",programManager.getProgramSignatures(Integer.valueOf(programId)));
		}
		return mapping.findForward("programSignatures");
	}
	
	public ActionForward add(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		programForm.set("program", new Program());

		return mapping.findForward("edit");
	}

	public ActionForward addBedCheckTime(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		String programId = request.getParameter("id");
		String addTime = request.getParameter("addTime");
		
		BedCheckTime bedCheckTime = BedCheckTime.create(Integer.valueOf(programId), addTime);
		bedCheckTimeManager.addBedCheckTime(bedCheckTime);
		
		return edit(mapping, form, request, response);
	}

	public ActionForward assign_role(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramProvider provider = (ProgramProvider) programForm.get("provider");

		ProgramProvider pp = programManager.getProgramProvider(String.valueOf(provider.getId()));

		pp.setRoleId(provider.getRoleId());

		programManager.saveProgramProvider(pp);

		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
		saveMessages(request, messages);

		logManager.log("write", "edit program - assign role", String.valueOf(program.getId()), request);
		programForm.set("provider", new ProgramProvider());

		setEditAttributes(request, String.valueOf(program.getId()));

		return mapping.findForward("edit");
	}

	public ActionForward assign_team(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramProvider provider = (ProgramProvider) programForm.get("provider");

		ProgramProvider pp = programManager.getProgramProvider(String.valueOf(provider.getId()));

		ProgramTeam team = programManager.getProgramTeam(request.getParameter("teamId"));

		if (team != null) {
			pp.getTeams().add(team);
		}

		programManager.saveProgramProvider(pp);

		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
		saveMessages(request, messages);

		logManager.log("write", "edit program - assign team", String.valueOf(program.getId()), request);
		programForm.set("provider", new ProgramProvider());

		setEditAttributes(request, String.valueOf(program.getId()));

		return mapping.findForward("edit");
	}

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

	public ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		String id = request.getParameter("id");
		String name = request.getParameter("name");

		if (id == null) {
			return list(mapping, form, request, response);
		}

		/*
		 * have to make sure 1) no clients 2) no queue
		 */
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

		int numQueue = programQueueManager.getProgramQueuesByProgramId(id).size();
		if (numQueue > 0) {
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.delete.queue", name, String.valueOf(numQueue)));
			saveMessages(request, messages);
			return list(mapping, form, request, response);
		}

		programManager.removeProgram(id);
		programManager.deleteProgramProviderByProgramId(Long.valueOf(id));

		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.deleted", name));
		saveMessages(request, messages);

		logManager.log("write", "delete program", String.valueOf(program.getId()), request);

		return list(mapping, form, request, response);
	}

	public ActionForward delete_access(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramAccess access = (ProgramAccess) programForm.get("access");

		programManager.deleteProgramAccess(String.valueOf(access.getId()));

		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
		saveMessages(request, messages);

		logManager.log("write", "edit program - delete access", String.valueOf(program.getId()), request);

		this.setEditAttributes(request, String.valueOf(program.getId()));
		programForm.set("access", new ProgramAccess());

		return edit(mapping, form, request, response);
	}

	public ActionForward delete_function(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramFunctionalUser function = (ProgramFunctionalUser) programForm.get("function");

		programManager.deleteFunctionalUser(String.valueOf(function.getId()));

		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
		saveMessages(request, messages);
		logManager.log("write", "edit program - delete function user", String.valueOf(program.getId()), request);

		this.setEditAttributes(request, String.valueOf(program.getId()));

		return edit(mapping, form, request, response);
	}

	public ActionForward delete_provider(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramProvider pp = (ProgramProvider) programForm.get("provider");

		if (pp.getId() != null && pp.getId().longValue() >= 0) {
			programManager.deleteProgramProvider(String.valueOf(pp.getId()));

			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
			saveMessages(request, messages);

			logManager.log("write", "edit program - delete provider", String.valueOf(program.getId()), request);
		}
		this.setEditAttributes(request, String.valueOf(program.getId()));
		programForm.set("provider", new ProgramProvider());

		return edit(mapping, form, request, response);
	}

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

	public ActionForward edit_access(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramAccess access = (ProgramAccess) programForm.get("access");

		ProgramAccess pa = programManager.getProgramAccess(String.valueOf(access.getId()));

		if (pa == null) {
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_access.missing"));
			saveMessages(request, messages);
			setEditAttributes(request, String.valueOf(program.getId()));
			return edit(mapping, form, request, response);
		}
		programForm.set("access", pa);

		setEditAttributes(request, String.valueOf(program.getId()));

		return mapping.findForward("edit");
	}

	public ActionForward edit_function(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramFunctionalUser function = (ProgramFunctionalUser) programForm.get("function");

		ProgramFunctionalUser pfu = programManager.getFunctionalUser(String.valueOf(function.getId()));

		if (pfu == null) {
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_function.missing"));
			saveMessages(request, messages);
			setEditAttributes(request, String.valueOf(program.getId()));
			return edit(mapping, form, request, response);
		}
		programForm.set("function", pfu);
		request.setAttribute("providerName", pfu.getProvider().getFormattedName());

		setEditAttributes(request, String.valueOf(program.getId()));

		return mapping.findForward("edit");
	}

    public ActionForward edit_provider(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramProvider provider = (ProgramProvider) programForm.get("provider");

		ProgramProvider pp = programManager.getProgramProvider(String.valueOf(provider.getId()));

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

	public ActionForward removeBedCheckTime(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		String id = request.getParameter("id");
		String removeId = request.getParameter("removeId");
		
		bedCheckTimeManager.removeBedCheckTime(Integer.valueOf(removeId));
		
		return edit(mapping, form, request, response);
	}

	public ActionForward remove_queue(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramQueue queue = (ProgramQueue) programForm.get("queue");

		ProgramQueue fullQueue = programQueueManager.getProgramQueue(String.valueOf(queue.getId()));
		fullQueue.setStatus("removed");
		programQueueManager.saveProgramQueue(fullQueue);

		logManager.log("write", "edit program - queue removal", String.valueOf(program.getId()), request);

		setEditAttributes(request, String.valueOf(program.getId()));

		return mapping.findForward("edit");
	}

	public ActionForward remove_team(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramProvider provider = (ProgramProvider) programForm.get("provider");

		ProgramProvider pp = programManager.getProgramProvider(String.valueOf(provider.getId()));

		String teamId = request.getParameter("teamId");

		if (teamId != null && teamId.length() > 0) {
			long team_id = Long.valueOf(teamId);

			for (Iterator iter = pp.getTeams().iterator(); iter.hasNext();) {
				ProgramTeam team = (ProgramTeam) iter.next();

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

	public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		
		Program program = (Program) programForm.get("program");		
				
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
		if (request.getParameter("program.holdingTank") == null) {
			program.setHoldingTank(false);
		}
		if(request.getParameter("program.transgender") == null) 
			program.setTransgender(false);		
		if(request.getParameter("program.firstNation") == null) 
			program.setFirstNation(false);
		if(request.getParameter("program.bedProgramAffiliated") == null) 
			program.setBedProgramAffiliated(false);	
		if(request.getParameter("program.alcohol") == null) 
			program.setAlcohol(false);	
		if(request.getParameter("program.physicalHealth") == null) 
			program.setPhysicalHealth(false);	
		if(request.getParameter("program.mentalHealth") == null) 
			program.setMentalHealth(false);	
		if(request.getParameter("program.housing") == null) 
			program.setHousing(false);	
		
		request.setAttribute("oldProgram",program);
		
		//if a program has a client in it, you cannot make it inactive
		if(request.getParameter("program.programStatus").equals("inactive")) {
			//Admission ad = admissionManager.getAdmission(Long.valueOf(request.getParameter("id")));
			List admissions = admissionManager.getCurrentAdmissionsByProgramId(String.valueOf(program.getId()));
			if(admissions.size()>0){
				ActionMessages messages = new ActionMessages();
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.client_in_the_program", program.getName()));
				saveMessages(request, messages);
				setEditAttributes(request, String.valueOf(program.getId()));
				return mapping.findForward("edit");
			}
			int numQueue = programQueueManager.getActiveProgramQueuesByProgramId(String.valueOf(program.getId())).size();
			if (numQueue > 0) {
				ActionMessages messages = new ActionMessages();
				messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.client_in_the_queue", program.getName(), String.valueOf(numQueue)));
				saveMessages(request, messages);				
				setEditAttributes(request, String.valueOf(program.getId()));
				return mapping.findForward("edit");
			}
		}
				
				
		if (program.getMaxAllowed().intValue() < program.getNumOfMembers().intValue()) {
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.max_too_small", program.getName()));
			saveMessages(request, messages);
			setEditAttributes(request, String.valueOf(program.getId()));
			return mapping.findForward("edit");
		}

		if (!program.getType().equalsIgnoreCase("bed") && program.isHoldingTank()) {
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.invalid_holding_tank"));
			saveMessages(request, messages);
			setEditAttributes(request, String.valueOf(program.getId()));
			return mapping.findForward("edit");
		}

		programManager.saveProgram(program);
		
		//if there were some changes happened to the program, then save the signature of this program
		Program oldProgram = new Program();
		oldProgram.setMaxAllowed(Integer.valueOf(request.getParameter("old_maxAllowed")));
		oldProgram.setName(request.getParameter("old_name"));		
		oldProgram.setDescr(request.getParameter("old_descr"));		
		oldProgram.setType(request.getParameter("old_type"));
		oldProgram.setAddress(request.getParameter("old_address"));
		oldProgram.setPhone(request.getParameter("old_phone"));		
		oldProgram.setFax(request.getParameter("old_fax"));		
		oldProgram.setUrl(request.getParameter("old_url"));		
		oldProgram.setEmail(request.getParameter("old_email"));		
		oldProgram.setEmergencyNumber(request.getParameter("old_emergencyNumber"));		
		oldProgram.setLocation(request.getParameter("old_location"));		
		oldProgram.setProgramStatus(request.getParameter("old_programStatus"));				
		oldProgram.setBedProgramLinkId(Integer.valueOf(request.getParameter("old_bedProgramLinkId")));		
		oldProgram.setManOrWoman(request.getParameter("old_manOrWoman"));		
		oldProgram.setAbstinenceSupport(request.getParameter("old_abstinenceSupport"));		
		oldProgram.setExclusiveView(request.getParameter("old_exclusiveView"));
		
		oldProgram.setHoldingTank(Boolean.valueOf(request.getParameter("old_holdingTank")));
		oldProgram.setAllowBatchAdmission(Boolean.valueOf(request.getParameter("old_allowBatchAdmission")));
		oldProgram.setAllowBatchDischarge(Boolean.valueOf(request.getParameter("old_allowBatchDischarge")));
		oldProgram.setHic(Boolean.valueOf(request.getParameter("old_hic")));
		oldProgram.setTransgender(Boolean.valueOf(request.getParameter("old_transgender")));
		oldProgram.setFirstNation(Boolean.valueOf(request.getParameter("old_firstNation")));
		oldProgram.setBedProgramAffiliated(Boolean.valueOf(request.getParameter("old_bedProgramAffiliated")));
		oldProgram.setAlcohol(Boolean.valueOf(request.getParameter("old_alcohol")));
		oldProgram.setPhysicalHealth(Boolean.valueOf(request.getParameter("old_physicalHealth")));
		oldProgram.setMentalHealth(Boolean.valueOf(request.getParameter("old_mentalHealth")));
		oldProgram.setHousing(Boolean.valueOf(request.getParameter("old_housing")));
				
		if(isChanged(program,oldProgram)) {
			ProgramSignature programSignature = new ProgramSignature();
			programSignature.setProgramId(program.getId());
			programSignature.setProgramName(program.getName());
			String providerNo = (String)request.getSession().getAttribute("user");
			programSignature.setProviderId(providerNo);
			programSignature.setProviderName(providerManager.getProvider(providerNo).getFormattedName());
			programSignature.setCaisiRoleName(providerManager.getProvider(providerNo).getProviderType());
			Date now = new Date();
			programSignature.setUpdateDate(now);
			
			programManager.saveProgramSignature(programSignature);
		}
		
		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
		saveMessages(request, messages);

		logManager.log("write", "edit program", String.valueOf(program.getId()), request);
		
		setEditAttributes(request, String.valueOf(program.getId()));

		return mapping.findForward("edit");
	}

	public ActionForward save_access(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramAccess access = (ProgramAccess) programForm.get("access");

		if (this.isCancelled(request)) {
			return list(mapping, form, request, response);
		}
		access.setProgramId(new Long(program.getId().longValue()));

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
			for (int x = 0; x < roles.length; x++) {
				access.getRoles().add(roleManager.getRole(roles[x]));
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

	public ActionForward save_function(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramFunctionalUser function = (ProgramFunctionalUser) programForm.get("function");

		if (this.isCancelled(request)) {
			return list(mapping, form, request, response);
		}
		function.setProgramId(new Long(program.getId().longValue()));

		Long pid = programManager.getFunctionalUserByUserType(new Long(program.getId().longValue()), new Long(function.getUserTypeId()));

		if (pid != null && function.getId().longValue() != pid.longValue()) {
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_function.duplicate", program.getName()));
			saveMessages(request, messages);
			programForm.set("function", new ProgramFunctionalUser());
			setEditAttributes(request, String.valueOf(program.getId()));
			return mapping.findForward("edit");
		}
		programManager.saveFunctionalUser(function);

		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
		saveMessages(request, messages);

		logManager.log("write", "edit program - save function user", String.valueOf(program.getId()), request);

		programForm.set("function", new ProgramFunctionalUser());
		setEditAttributes(request, String.valueOf(program.getId()));

		return mapping.findForward("edit");
	}

	public ActionForward save_provider(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramProvider provider = (ProgramProvider) programForm.get("provider");

		if (this.isCancelled(request)) {
			return list(mapping, form, request, response);
		}
		provider.setProgramId(new Long(program.getId().longValue()));

		if (programManager.getProgramProvider(String.valueOf(provider.getProviderNo()), String.valueOf(program.getId())) != null) {
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.provider.exists"));
			saveMessages(request, messages);
			programForm.set("provider", new ProgramProvider());
			setEditAttributes(request, String.valueOf(program.getId()));
			return mapping.findForward("edit");
		}

		programManager.saveProgramProvider(provider);

		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
		saveMessages(request, messages);

		logManager.log("write", "edit program - save provider", String.valueOf(program.getId()), request);
		programForm.set("provider", new ProgramProvider());
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

	private void setEditAttributes(HttpServletRequest request, String programId) {
		request.setAttribute("id", programId);
		request.setAttribute("programName", programManager.getProgram(programId).getName());
		request.setAttribute("providers", programManager.getProgramProviders(programId));
		request.setAttribute("roles", roleManager.getRoles());
		request.setAttribute("functionalUserTypes", programManager.getFunctionalUserTypes());
		request.setAttribute("functional_users", programManager.getFunctionalUsers(programId));

		List teams = programManager.getProgramTeams(programId);

		for (Iterator i = teams.iterator(); i.hasNext();) {
			ProgramTeam team = (ProgramTeam) i.next();

			team.setProviders(programManager.getAllProvidersInTeam(Integer.valueOf(programId), team.getId()));
			team.setAdmissions(programManager.getAllClientsInTeam(Integer.valueOf(programId), team.getId()));
		}
		
		request.setAttribute("teams", teams);
		
		request.setAttribute("client_statuses", programManager.getProgramClientStatuses(new Integer(programId)));

		request.setAttribute("admissions", admissionManager.getCurrentAdmissionsByProgramId(programId));
		request.setAttribute("accesses", programManager.getProgramAccesses(programId));
		request.setAttribute("accessTypes", programManager.getAccessTypes());
		request.setAttribute("queue", programQueueManager.getProgramQueuesByProgramId(programId));
		
		request.setAttribute("bed_programs",programManager.getBedPrograms());
		request.setAttribute("programFirstSignature",programManager.getProgramFirstSignature(Integer.valueOf(programId)));
	}

	
	
	public ActionForward delete_status(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramClientStatus status = (ProgramClientStatus) programForm.get("client_status");

		if (programManager.getAllClientsInStatus(program.getId(), status.getId()).size() > 0) {

			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.status.not_empty", program.getName()));
			saveMessages(request, messages);

			this.setEditAttributes(request, String.valueOf(program.getId()));
			return edit(mapping, form, request, response);
		}

		programManager.deleteProgramClientStatus(String.valueOf(status.getId()));

		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
		saveMessages(request, messages);

		this.setEditAttributes(request, String.valueOf(program.getId()));
		programForm.set("function", new ProgramFunctionalUser());

		return edit(mapping, form, request, response);
	}
	
	public ActionForward edit_status(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramClientStatus status = (ProgramClientStatus) programForm.get("client_status");

		ProgramClientStatus pt = programManager.getProgramClientStatus(String.valueOf(status.getId()));


        if (pt == null) {
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_status.missing"));
			saveMessages(request, messages);
			setEditAttributes(request, String.valueOf(program.getId()));
			return edit(mapping, form, request, response);
		}
		programForm.set("client_status", pt);
        
        setEditAttributes(request, String.valueOf(program.getId()));

		return mapping.findForward("edit");
	}
	
	public ActionForward save_status(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		ProgramClientStatus status = (ProgramClientStatus) programForm.get("client_status");

        if (request.getParameter("client_status.blockReferral") == null)
            status.setBlockReferral(false);
        
        if (this.isCancelled(request)) {
			return list(mapping, form, request, response);
		}
		status.setProgramId(program.getId());

		if (status.getId() == null && programManager.clientStatusNameExists(program.getId(), status.getName())) {
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program_status.duplicate", status.getName()));
			saveMessages(request, messages);
			programForm.set("client_status", new ProgramClientStatus());
			setEditAttributes(request, String.valueOf(program.getId()));
			return mapping.findForward("edit");
		}

		programManager.saveProgramClientStatus(status);

		logManager.log("write", "edit program - save status", String.valueOf(program.getId()), request);

		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
		saveMessages(request, messages);
		programForm.set("client_status", new ProgramClientStatus());
		setEditAttributes(request, String.valueOf(program.getId()));

		return mapping.findForward("edit");
	}
	
	public ActionForward assign_status_client(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		DynaActionForm programForm = (DynaActionForm) form;
		Program program = (Program) programForm.get("program");
		Admission admission = (Admission) programForm.get("admission");

		Admission ad = admissionManager.getAdmission(admission.getId());

		ad.setClientStatusId(admission.getClientStatusId());

		admissionManager.saveAdmission(ad);

		ActionMessages messages = new ActionMessages();
		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("program.saved", program.getName()));
		saveMessages(request, messages);

		logManager.log("write", "edit program - assign client to status", String.valueOf(program.getId()), request);

		setEditAttributes(request, String.valueOf(program.getId()));

		return mapping.findForward("edit");
	}
	
	private boolean isChanged(Program program1, Program program2) {
		boolean changed = false;
		
		if( program1.getMaxAllowed().intValue() != program2.getMaxAllowed().intValue() ||
			!program1.getName().equals(program2.getName()) ||
			!program1.getType().equals(program2.getType()) ||
			!program1.getDescr().equals(program2.getDescr()) ||
			!program1.getAddress().equals(program2.getAddress()) ||
			!program1.getPhone().equals(program2.getPhone()) ||
			!program1.getFax().equals(program2.getFax()) ||
			!program1.getUrl().equals(program2.getUrl()) ||
			!program1.getEmail().equals(program2.getEmail()) ||
			!program1.getEmergencyNumber().equals(program2.getEmergencyNumber()) ||
			!program1.getLocation().equals(program2.getLocation()) ||
			!program1.getProgramStatus().equals(program2.getProgramStatus()) ||			
			!program1.getBedProgramLinkId().equals(program2.getBedProgramLinkId()) ||
			!program1.getManOrWoman().equals(program2.getManOrWoman()) ||
			!program1.getAbstinenceSupport().equals(program2.getAbstinenceSupport()) ||
			!program1.getExclusiveView().equals(program2.getExclusiveView()) ||
			(program1.isHoldingTank() ^ program2.isHoldingTank()) ||
			(program1.isAllowBatchAdmission() ^ program2.isAllowBatchAdmission()) ||
			(program1.isAllowBatchDischarge() ^ program2.isAllowBatchDischarge()) ||
			(program1.isHic() ^ program2.isHic()) ||
			(program1.isTransgender() ^ program2.isTransgender()) ||
			(program1.isFirstNation() ^ program2.isFirstNation()) ||
			(program1.isBedProgramAffiliated() ^ program2.isBedProgramAffiliated()) || 
			(program1.isAlcohol() ^ program2.isAlcohol()) || 			
			(program1.isPhysicalHealth() ^ program2.isPhysicalHealth()) ||
			(program1.isMentalHealth() ^ program2.isMentalHealth()) ||
			(program1.isHousing() ^ program2.isHousing())
		) 
		
			changed = true;
		
		return changed;			
	}
	
}