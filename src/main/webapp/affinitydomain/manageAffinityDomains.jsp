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

<%@page import="ca.marc.ihe.core.configuration.*"%>
<%@page import="org.oscarehr.web.eform.EfmPatientFormList"%>
<%@page import="org.oscarehr.affinityDomain.IheConfigurationUtil"%>
<%@page import="java.util.List"%>
<% String pageHeading = "marc-hi.affinityDomains.headers.affinityDomain"; %>
<%@ include file="../layouts/marc/header.jsp" %>
<%@ include file="../layouts/marc/affDomSidebar.jsp" %>

<%
	IheConfiguration iheConfiguration = IheConfigurationUtil.load();
	
	List<IheAffinityDomainConfiguration> affinityDomains = iheConfiguration.getAffinityDomains();
	
	if (request.getParameter("deleteId") != null) {
		boolean deleteResult =  IheConfigurationUtil.removeAffinityDomainByName(iheConfiguration, request.getParameter("deleteId"));
		if (deleteResult) {
			// Messages should be localized/read from a properties file.
			%><bean:message key="marc-hi.affinityDomains.success.deleted" /><%			
		} else {
			%><bean:message key="marc-hi.affinityDomains.errors.unableToDelete" /><%			
		}
	}	
%>

<% if (affinityDomains.size() > 0) { %>


	<table id="manage">
		<tr>
			<th><bean:message key="marc-hi.affinityDomains.name" /></th>
			<th><bean:message key="marc-hi.affinityDomains.facilityName" /></th>
			<th><bean:message key="marc-hi.affinityDomains.uniqueId" /></th>
			<th><bean:message key="marc-hi.affinityDomains.policyUrl" /></th>
			<th><bean:message key="marc-hi.affinityDomains.actors" /></th>
			<th><bean:message key="marc-hi.affinityDomains.action" /></th>
		</tr>
		
	<%
		for (int i = 0; i < affinityDomains.size(); i++) {
			IheAffinityDomainConfiguration affinityDomainConfig = affinityDomains.get(i);
	%>
			<tr>
				<td><%=affinityDomainConfig.getName()%></td>
				<td><%=affinityDomainConfig.getIdentification().getFacilityName()%></td>
				<td><%=affinityDomainConfig.getIdentification().getUniqueId()%></td>
				<td><%=affinityDomainConfig.getPolicyURL()%></td>
				<td>
					<%								
						StringBuilder actorsBuilder = new StringBuilder();
						boolean first = true;
						for (IheActorConfiguration actorConfig : affinityDomainConfig.getActors())
						{
							if (first) {
								first = false;	
								actorsBuilder.append(String.format("%s : %s <br />", actorConfig.getName(), actorConfig.getEndPointAddress()));
							} else {
								actorsBuilder.append(String.format("%s : %s <br />", actorConfig.getName(), actorConfig.getEndPointAddress()));						
							}
						}
						
						out.print(actorsBuilder.toString());
					%>
				</td>
				<td>
					<a href="edit.jsp?id=<%=affinityDomains.get(i).getName()%>"><bean:message key="marc-hi.affinityDomains.edit" /></a>
					<br />
					<a class="deleteAffinityDomain" href="<%=request.getRequestURI()%>?deleteId=<%=affinityDomains.get(i).getName()%>"><bean:message key="marc-hi.affinityDomains.delete" /></a>
				</td>
			</tr>
		 
	<% } %>
	
	</table>
	
<% } else { %>
	<h4><bean:message key="marc-hi.affinityDomains.errors.noAffinityDomainsFound" /></h4>
<% } %>

<%@ include file="../layouts/marc/footer.jsp" %>
