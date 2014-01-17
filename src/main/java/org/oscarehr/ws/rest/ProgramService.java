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

import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.ProgramProvider;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.ws.rest.to.ProgramDomainResponse;
import org.oscarehr.ws.rest.to.model.ProgramTo1;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Path("/program")
@Component("programService")
public class ProgramService extends AbstractServiceImpl {
	
	@Autowired
	private ProgramManager programManager;
	
	@GET
	@Path("/programDomain/{providerNo}")
	@Produces("application/json")
	public ProgramDomainResponse getProgramDomain(@PathParam("providerNo") String providerNo) {
		ProgramDomainResponse response = new ProgramDomainResponse();
				
		List<ProgramProvider> ppList = programManager.getProgramProvidersByProvider(providerNo);
		for(ProgramProvider pp:ppList) {
			Program p = pp.getProgram();
			ProgramTo1 item = new ProgramTo1();
			item.setId(p.getId());
			item.setName(p.getName());
			response.getContent().add(item);
		}
		
		
		response.setCurrentProgramId(ppList.get(0).getId().intValue());
		
		return response;

	}
	
}
