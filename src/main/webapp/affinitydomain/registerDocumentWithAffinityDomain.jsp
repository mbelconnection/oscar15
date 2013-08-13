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

<%@page import="org.oscarehr.affinityDomain.IheAffinityDomainUtil"%>
<%
	String pageHeading = "marc-hi.affinityDomains.headers.register";
%>
<%@ include file="../layouts/marc/header.jsp" %>
<%@ include file="../layouts/marc/eFormSidebar.jsp" %>

Register Documents
<br />
<%

String demographicId = request.getParameter("demographic_no");
String[] docIds = request.getParameterValues("docNo");
String providerNumber = (String) session.getAttribute("user");
String affinityDomain = request.getParameter("affinityDomain");
String confidentialityCode = request.getParameter("confidentialityCode");
// legal authenticator
String authenticator = request.getParameter("authenticator");

if (docIds == null || docIds.length == 0) {
		%><h1><bean:message key="marc-hi.affinityDomains.errors.noDocuments" /></h1><%
} else {

	IheAffinityDomainUtil util = new IheAffinityDomainUtil(affinityDomain);
	
	boolean registerDocumentResult = false;
	
	if (util.isPatientRegistered(Integer.parseInt(demographicId))) {
		
		// Register the documents.
		if (request.getParameter("source").equalsIgnoreCase("edocs")) {
			registerDocumentResult = util.registerEDocs(providerNumber, Integer.parseInt(demographicId), docIds, confidentialityCode);
		} else if (request.getParameter("source").equalsIgnoreCase("eform")) {
			registerDocumentResult = util.registerEForms(providerNumber, Integer.parseInt(demographicId), docIds, confidentialityCode);
		} else if (request.getParameter("source").equalsIgnoreCase("cds")) {
			registerDocumentResult = util.registerCDSExport(providerNumber, Integer.parseInt(demographicId), docIds[0], confidentialityCode);
		}
		
		if (registerDocumentResult) {
			%><h1><bean:message key="marc-hi.affinityDomains.success.documentRegistered" /></h1><br/><%
		} else {
			%><h1><bean:message key="marc-hi.affinityDomains.errors.unableToRegisterDocument" /></h1><br/><%
		}
			
		} else if (request.getParameter("shareInformation") != null) {
			
			// It was agreed to share the patient information.
			boolean registerPatientResult = util.sharePatient(Integer.parseInt(demographicId));
			
			if (registerPatientResult) {
				%><h2><bean:message key="marc-hi.affinityDomains.success.patientRegistered" /></h2><br/><%
						
				// Perform BPPC
				boolean bppcResult = util.sendBppc(providerNumber, Integer.parseInt(demographicId), Integer.valueOf(authenticator));
				if (bppcResult) {
					%><h4><bean:message key="marc-hi.affinityDomains.success.bppcRegistered" /></h4><br/><%
				} else {
					%><h4><bean:message key="marc-hi.affinityDomains.errors.unableToRegisterBppc" /></h4><br/><%
				}
				
				// Register the documents.
				if (request.getParameter("source").equalsIgnoreCase("edocs")) {
					registerDocumentResult = util.registerEDocs(providerNumber, Integer.parseInt(demographicId), docIds, confidentialityCode);
				} else if (request.getParameter("source").equalsIgnoreCase("eform")) {
					registerDocumentResult = util.registerEForms(providerNumber, Integer.parseInt(demographicId), docIds, confidentialityCode);
				} else if (request.getParameter("source").equalsIgnoreCase("cds")) {
					registerDocumentResult = util.registerCDSExport(providerNumber, Integer.parseInt(demographicId), docIds[0], confidentialityCode);
				}
		
			if (registerDocumentResult) {
				%><h1><bean:message key="marc-hi.affinityDomains.success.documentRegistered" /></h1><br/><%
			} else {
				%><h1><bean:message key="marc-hi.affinityDomains.errors.unableToRegisterDocument" /></h1><br/><%
			}
				
		} else {
			%><h2><bean:message key="marc-hi.affinityDomains.errors.unableToRegisterPatient" /></h2><br/><%
		}

	}

}
%>
<jsp:include page="../layouts/marc/footer.jsp" />
