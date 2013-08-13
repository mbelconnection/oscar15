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

<%@page import="org.oscarehr.common.dao.DemographicDao"%>
<%@page import="org.oscarehr.common.model.Demographic"%>
<%@page import="org.oscarehr.util.SpringUtils"%>
<%@page import="org.oscarehr.common.model.Relationships"%>
<%@page import="org.oscarehr.common.dao.RelationshipsDao"%>
<%@page import="ca.marc.ihe.core.configuration.IheAffinityDomainConfiguration"%>
<%@page import="org.oscarehr.affinityDomain.IheConfigurationUtil"%>
<%@page import="ca.marc.ihe.core.configuration.IheConfiguration"%>
<%@page import="org.oscarehr.affinityDomain.IheAffinityDomainUtil"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<% String pageHeading = "marc-hi.affinityDomains.headers.register"; %>
<%@ include file="../layouts/marc/header.jsp" %>
<%@ include file="../layouts/marc/eFormSidebar.jsp" %>

<%

String demographicId = request.getParameter("demographic_no");
String confidentialityCode = request.getParameter("confidentialityCode");
String source = request.getParameter("source");
String[] docIds = request.getParameterValues("docNo");

String affinityDomain = request.getParameter("affinityDomain");
IheConfiguration iheConfig = IheConfigurationUtil.load();
IheAffinityDomainConfiguration domain = iheConfig.getAffinityDomain(affinityDomain);

RelationshipsDao relationshipsDao = SpringUtils.getBean(RelationshipsDao.class);
DemographicDao demographicDao = SpringUtils.getBean(DemographicDao.class);
//use the patient demographic to get the patient's name (and other details)
Demographic patientDemographic = demographicDao.getDemographic(demographicId);


if (demographicId != null && docIds != null) {	
	StringBuilder cancelUrl = null;
	StringBuilder shareUrl = null;
	if (source.equalsIgnoreCase("eform")) {
		cancelUrl = new StringBuilder("../eform/efmpatientformlist.jsp?demographic_no=");
		shareUrl = new StringBuilder("registerDocumentWithAffinityDomain.jsp?demographic_no=");
	} else if (source.equalsIgnoreCase("edocs")) {
		cancelUrl = new StringBuilder("../eform/efmpatientformlist.jsp?demographic_no="); // edocs
		shareUrl = new StringBuilder("registerDocumentWithAffinityDomain.jsp?demographic_no=");
	} else if (source.equalsIgnoreCase("cds")) {
		cancelUrl = new StringBuilder("../demographic/demographicExport.jsp?demographicNo=");
		shareUrl = new StringBuilder("../affinitydomain/registerDocumentWithAffinityDomain.jsp?demographic_no=");
	}
	
	cancelUrl.append(demographicId);
	shareUrl.append(demographicId);
	
	shareUrl.append("&affinityDomain=");
	shareUrl.append(affinityDomain);
	
	shareUrl.append("&source=");
	shareUrl.append(source);
	
	shareUrl.append("&confidentialityCode=");
	shareUrl.append(confidentialityCode);
	
	if (docIds.length == 0) {
		out.write("no doc ids");
	} else {
		for (String docId : docIds) {
			shareUrl.append("&docNo=");
			shareUrl.append(docId);
		}
	}
%>
	<form action="../affinitydomain/registerDocumentWithAffinityDomain.jsp">
		
		<input type="hidden" name="demographic_no" value="<%=demographicId%>" />
		<input type="hidden" name="affinityDomain" value="<%=affinityDomain%>" />
		<input type="hidden" name="source" value="<%=source%>" />
		<input type="hidden" name="confidentialityCode" value="<%=confidentialityCode%>" />		
		
		<%
			for (String docId : docIds) {
		%>			
				<input type="hidden" name="docNo" value="<%=docId%>" />		
		<%	
			}
		%>
		
		<h3><bean:message key="marc-hi.affinityDomains.firstPolicyStatement" /></h3>
		<h5><bean:message key="marc-hi.affinityDomains.secondPolicyStatement" /></h5>
		<iframe src="<%=domain.getPolicyURL()%>" width="800px" height="350px"></iframe>
		
		<p><span><bean:message key="marc-hi.affinityDomains.patientLabelName" /> </span> <b><%= patientDemographic.getFullName() %></b></p>

		<span><bean:message key="marc-hi.affinityDomains.decisionMakerLabelName" /> </span>&nbsp;&nbsp;
		<select name="authenticator">
			<option value="<%=demographicId%>"><%= patientDemographic.getFullName() %></option>
			<% for (Relationships relation : relationshipsDao.findActiveSubDecisionMaker(Integer.valueOf(demographicId))) { 
				Demographic relationDemographic = demographicDao.getDemographic(String.valueOf(relation.getRelationDemographicNo()));
			%>
				<option value="<%=relation.getRelationDemographicNo()%>"><%= relationDemographic.getFullName() %></option>
			<% } %>
		</select>
		<br/>
	
		<input type="checkbox" name="shareInformation" value="AgreeToShare" /> <bean:message key="marc-hi.affinityDomains.shareAgreement" />
		<br />
		<input type="submit" name="share" value="<bean:message key="marc-hi.affinityDomains.shareSubmit" />" />
	</form>
	<a href="<%=cancelUrl.toString()%>"><bean:message key="marc-hi.affinityDomains.shareCancel" /></a>

<% } %>
<%@ include file="../layouts/marc/footer.jsp" %>
