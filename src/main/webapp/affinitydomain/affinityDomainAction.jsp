<%--

    Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
    This software is published under the GPL GNU General Public License.
    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

    This software was written for the
    Department of Family Medicine
    McMaster University
    Hamilton
    Ontario, Canada

--%>

<%@page import="ca.marc.ihe.core.configuration.IheConfiguration"%>
<%@page import="ca.marc.ihe.core.configuration.IheActorConfiguration"%>
<%@page import="ca.marc.ihe.core.configuration.IheIdentification"%>
<%@page import="ca.marc.ihe.core.configuration.IheAffinityDomainConfiguration"%>
<%@page import="org.oscarehr.affinityDomain.IheConfigurationUtil"%>
<%@ taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<% String pageHeading = "marc-hi.affinityDomains.headers.affinityDomain"; %>
<%@ include file="../layouts/marc/header.jsp" %>
<%@ include file="../layouts/marc/affDomSidebar.jsp" %>

<%

// check the action (add vs edit)
String formAction = request.getParameter("action").toLowerCase();


// grab form input values
// validate input (future task)
String name = request.getParameter("name");
String facilityName = request.getParameter("facilityName");
String uniqueId = request.getParameter("uniqueId");
String policyUrl = request.getParameter("policyUrl");

String[] actorNameArray = request.getParameterValues("actorName");
String[] endPointArray = request.getParameterValues("endPoint");
String[] actorTypeArray = request.getParameterValues("actorType");
String[] binaryOnlyArray = request.getParameterValues("binaryOnly");
String[] localUniqueIdArray = request.getParameterValues("localUniqueId");
String[] localFacilityNameArray = request.getParameterValues("localFacilityName");
String[] remoteUniqueIdArray = request.getParameterValues("remoteUniqueId");
String[] remoteFacilityNameArray = request.getParameterValues("remoteFacilityName");


// create the affinity domain
IheConfiguration iheConfig = IheConfigurationUtil.load();
IheAffinityDomainConfiguration newDomain = new IheAffinityDomainConfiguration(name);
newDomain.setIdentification(new IheIdentification(uniqueId, facilityName));
newDomain.setPolicyURL(policyUrl);

// add actors
for (int i = 0; i < actorNameArray.length; i++) {
	IheActorConfiguration actor = new IheActorConfiguration(
			actorTypeArray[i], 
			actorNameArray[i], 
			binaryOnlyArray[i].equals("true"),
			endPointArray[i], 
			localUniqueIdArray[i],
			remoteUniqueIdArray[i],
			null, // local certificate not yet implemented
			null // remote certificate not yet implemented
	);
	actor.getLocalIdentification().setFacilityName(localFacilityNameArray[i]); // constructor doesn't set facility name
	actor.getRemoteIdentification().setFacilityName(remoteFacilityNameArray[i]);
	newDomain.addActor(actor);
}

// if this is an edit operation, remove the old domain
Boolean saveResult = false;
if (formAction.equals("edit") && !name.equals("")) {
	
	// remove the old domain (if exists)
	IheConfigurationUtil.removeAffinityDomainByName(iheConfig, request.getParameter("oldAffinityDomainName"));
	
	// add the affinity domain to the IHE config
	iheConfig.getAffinityDomains().add(newDomain);
	saveResult = IheConfigurationUtil.save(iheConfig);
	
} else if (formAction.equals("add") && !name.equals("")) {
	
	// if an affinity domain with the same name already exists, display an error
	IheAffinityDomainConfiguration duplicate = iheConfig.getAffinityDomain(newDomain.getName());
	if (duplicate == null) {
		// persist the new domain
		iheConfig.getAffinityDomains().add(newDomain);
		saveResult = IheConfigurationUtil.save(iheConfig);
	} else {
		// an affinity domain was found with the same name.. error
		out.write("<p>Error: Affinity domain name must be unique.</p>");
	}
	
}



// If the save operation was successful, display a success message
if (saveResult) {
	out.write("<h4>Affinity domain saved successfully.</h4>");
} else {
	out.write("<h4>An error occured while saving the affinity domain.</h4>");
}

%>

<%@ include file="../layouts/marc/footer.jsp" %>
