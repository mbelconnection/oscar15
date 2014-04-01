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
		
		int messageCount = messsagingManager.getMyInboxMessageCount(false);
		int ptMessageCount = messsagingManager.getMyInboxMessageCount(true);
		
		result.setUnreadMessagesCount(messageCount);
		result.setUnreadPatientMessagesCount(ptMessageCount);
		
		return result;
	}

}
