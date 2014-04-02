/**
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
 * This software is published under the GPL GNU General Public License.
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */
package org.oscarehr.ws.rest;

import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

import org.oscarehr.PMmodule.model.ProgramProvider;
import org.oscarehr.common.model.Provider;
import org.oscarehr.managers.MessagingManager;
import org.oscarehr.managers.ProgramManager2;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.ws.rest.conversion.ProgramProviderConverter;
import org.oscarehr.ws.rest.to.NavbarResponse;
import org.oscarehr.ws.rest.to.model.MenuTo1;
import org.oscarehr.ws.rest.to.model.NavBarMenuTo1;
import org.oscarehr.ws.rest.to.model.ProgramProviderTo1;
import org.springframework.beans.factory.annotation.Autowired;

@Path("/persona")
public class PersonaService {

	
	@Autowired
	private ProgramManager2 programManager2;
	
	@Autowired
	private MessagingManager messsagingManager;
	
	
	@GET
	@Path("/navbar")
	@Produces("application/json")
	public NavbarResponse getMyNavbar() {
		Provider provider = LoggedInInfo.loggedInInfo.get().loggedInProvider;
		
		NavbarResponse result = new NavbarResponse();
		
		/* program domain, current program */
		List<ProgramProvider> ppList = programManager2.getProgramDomain(provider.getProviderNo());
		ProgramProviderConverter ppConverter = new ProgramProviderConverter();
		List<ProgramProviderTo1> programDomain = new ArrayList<ProgramProviderTo1>();
		
		for(ProgramProvider pp:ppList) {
			programDomain.add(ppConverter.getAsTransferObject(pp));
		}
		result.setProgramDomain(programDomain);
		
		ProgramProvider pp = programManager2.getCurrentProgramInDomain(provider.getProviderNo());
		if(pp != null) {
			ProgramProviderTo1 ppTo = ppConverter.getAsTransferObject(pp);
			result.setCurrentProgram(ppTo);
		}
		
		/* counts */
		int messageCount = messsagingManager.getMyInboxMessageCount(false);
		int ptMessageCount = messsagingManager.getMyInboxMessageCount(true);
		result.setUnreadMessagesCount(messageCount);
		result.setUnreadPatientMessagesCount(ptMessageCount);
		
		
		/* this is manual right now. Need to have this generated from some kind
		 * of user data
		 */
		NavBarMenuTo1 navBarMenu = new NavBarMenuTo1();
		
		MenuTo1 patientSearchMenu = new MenuTo1().add(0,"New Patient",null,"#/newpatient")
				.add(1,"Advanced Search",null,"#/search");
		navBarMenu.setPatientSearchMenu(patientSearchMenu);
		
		MenuTo1 menu = new MenuTo1()
				.add(0,"Inbox",null,"#/inbox")
				.add(1,"Consultations",null,"#/consults")
				.add(2,"Billing",null,"#/billing")
				.add(3,"Tickler",null,"#/ticklers")
				.add(4,"Schedule",null,"#/schedule")
				//.add(0,"K2A",null,"#/k2a")
				.add(5,"Admin",null,"#/admin");
		navBarMenu.setMenu(menu);
		
		MenuTo1 moreMenu = new MenuTo1()
		.add(0,"Reports",null,"#/report")
		.add(1,"Caseload",null,"#/caseload")
		.add(2,"Resources",null,"#/resources")
		.add(3,"Documents",null,"#/documents");
		navBarMenu.setMoreMenu(moreMenu);
		
		MenuTo1 userMenu = new MenuTo1()
		.add(0,"Settings",null,"#/settings")
		.add(1,"Support",null,"#/support")
		.add(2,"Help",null,"#/help");
		navBarMenu.setUserMenu(userMenu);
		
		result.setMenus(navBarMenu);
		
		return result;
	}

}
