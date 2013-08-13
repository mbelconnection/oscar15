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
<%@page import="org.oscarehr.affinityDomain.IheAffinityDomainUtil"%>
<%@page import="org.oscarehr.affinityDomain.IheConfigurationUtil"%>

<% String pageHeading = "marc-hi.affinityDomains.headers.affinityDomain"; %>
<%@ include file="../layouts/marc/header.jsp" %>
<%@ include file="../layouts/marc/affDomSidebar.jsp" %>

<%
	String demoId = request.getParameter("demoId");	
	String affinityDomain = request.getParameter("affinityDomain");	
	String[] eDocs = request.getParameterValues("docNo");
	String confidentialityCode = request.getParameter("confidentialityCode");
	
	StringBuilder actionForward = new StringBuilder();
	
	IheAffinityDomainUtil util = new IheAffinityDomainUtil(affinityDomain);	
	
	// Check if the patient is registered on the external demographics. 
	// If the patient isn't, redirect to the share information page, otherwise redirect to register the documents.
	actionForward.append((util.isPatientRegistered(Integer.parseInt(demoId))) ? "registerDocumentWithAffinityDomain.jsp?demographic_no=" : "sharePatientWithAffinityDomain.jsp?demographic_no=");
	actionForward.append(demoId);
	
	actionForward.append("&source=edocs&affinityDomain=");
	actionForward.append(affinityDomain);
	
	actionForward.append("&confidentialityCode=");
	actionForward.append(confidentialityCode);
	
	for (String docId : eDocs) 
	{
		actionForward.append("&docNo=");
		actionForward.append(docId);
	}
	
	response.sendRedirect(actionForward.toString());

%>
