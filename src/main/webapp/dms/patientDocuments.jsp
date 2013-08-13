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

<%@page import="oscar.dms.PatientDocumentsUtil"%>
<%@page import="org.oscarehr.common.model.PatientDocument"%>
<%@ page import="org.oscarehr.common.dao.DemographicDao, org.oscarehr.common.model.Demographic, org.oscarehr.util.SpringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<% String pageHeading = "marc-hi.patientDocuments.title"; %>
<%@ include file="../layouts/marc/header.jsp" %>
<%@ include file="../layouts/marc/patDocumentsSidebar.jsp" %>

<%
	if (request.getParameter("demographic_no") != null) {
		int demographicId = Integer.parseInt(request.getParameter("demographic_no"));
		String providerId = (String)session.getAttribute("user");
		
        DemographicDao demoDao = (DemographicDao) SpringUtils.getBean("demographicDao");
        Demographic demographic = demoDao.getDemographicById(demographicId);
		
		// the user clicked the 'Fetch Documents' button
		if (request.getParameter("fetchDocuments") != null) {
			int newDocsFetched = PatientDocumentsUtil.fetchDocuments(demographicId, providerId);
			%>
				<script type="text/javascript">alert("Number of documents fetched is <%=newDocsFetched%>");</script>
			<%
		}
		
		int currentPage = 1;
		
		if (request.getParameter("page") != null) {
			currentPage = Integer.parseInt(request.getParameter("page"));
		}
		
		String submitUrl = "patientDocuments.jsp?demographic_no=" + demographicId;
		String pageUrl = submitUrl + "&page=";
		int documentsPerPage = 15;
		
		// The total amount of documents for the patient.
		int totalDocuments = PatientDocumentsUtil.getDocumentCount(demographicId);
		
		// The amount of pages to display before and after the current page.
		int pagesToDisplay = 3;
		
		// Check if the user requested to download documents.
		if (request.getParameter("docsToDownload") != null) {
			for (String patientDocumentId : request.getParameterValues("docsToDownload"))
			{
				PatientDocumentsUtil.downloadDocument(Integer.parseInt(patientDocumentId), request.getParameter("demographic_no"), providerId);
			}
		}	
%>
		<div id="patientDocuments">
			<h3><%=demographic.getFirstName()%>, <%=demographic.getLastName()%></h3>
			<form action="<%=submitUrl%>" method="POST">
				<a href="#" id="selectAllLink"><bean:message key="marc-hi.patientDocuments.links.selectAll" /></a>
				<table id="patientDocumentsTable">
					<tr>
						<th><bean:message key="marc-hi.patientDocuments.table.colSelect" /></th>
						<th><bean:message key="marc-hi.patientDocuments.table.colTitle" /></th>
						<th><bean:message key="marc-hi.patientDocuments.table.colMimetype" /></th>
						<th><bean:message key="marc-hi.patientDocuments.table.colAuthor" /></th>
						<th><bean:message key="marc-hi.patientDocuments.table.colTimeCreated" /></th>
					</tr>
					
					<%  for (PatientDocument doc : PatientDocumentsUtil.getDocuments(demographicId, (currentPage - 1) * documentsPerPage, documentsPerPage)) { %>
						
						<tr class="<%= (doc.getDownloaded()) ? "downloaded" : "new" %>">
							<td><input type="checkbox" name="docsToDownload" value="<%=doc.getId()%>" <%= (doc.getDownloaded()) ? "disabled=\"disabled\"" : "" %> /></td>
							<td><%=doc.getTitle()%></td>
							<td><%=doc.getMimetype()%></td>
							<td><%=doc.getAuthor()%></td>
							<td><%=doc.getCreationTime().toString()%></td>
						</tr>
						
					<% } %>
					
				</table>
				<br />
				<input type="submit" name="submit" value="<bean:message key="marc-hi.patientDocuments.button.downloadSelected" />" /> &nbsp; <input type="submit" name="fetchDocuments" value="<bean:message key="marc-hi.patientDocuments.button.fetchDocuments" />" />
				<br />
				<br />
				
				<div id="pagination">
				<%
					String previousPage;
					String nextPage;
					
					for (int i = pagesToDisplay; i > 0; i--)
					{
						// Check previous page. Display as long as the page doesn't go below 1.
						if (currentPage - i > 0) {
							previousPage = pageUrl + (currentPage - i);
							%><a href="<%=previousPage%>"><%=(currentPage - i)%></a>&nbsp;<%
						}
					}
					
					%>
					
					<%=currentPage%>
					
					<%
					
					for (int i = 1; i <= pagesToDisplay; i++)
					{

						// Check next page.
						if ((currentPage + i ) * documentsPerPage < totalDocuments) 
						{
							nextPage = pageUrl + (currentPage + i);
							%>&nbsp;<a href="<%=nextPage%>"><%=(currentPage + i)%></a><%
						}
					}
				%>
				</div>
			</form>
			
		</div>
<% } %>
<%@ include file="../layouts/marc/footer.jsp" %>
