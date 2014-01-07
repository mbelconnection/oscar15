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
