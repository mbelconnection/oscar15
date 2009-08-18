<%@ include file="/taglibs.jsp"%>

<%@ page import="org.oscarehr.PMmodule.web.formbean.*"%>
<%@ page import="org.oscarehr.PMmodule.model.Program"%>
<%@ page import="org.apache.struts.validator.DynaValidatorForm"%>
<%@ taglib uri="/WEB-INF/security.tld" prefix="security"%>

<html:form action="/PMmodule/ProgramManager">
	<html:hidden property="view.tab" />
	<input type="hidden" name="programId" value="<c:out value="${requestScope.programId}"/>" />
	<input type="hidden" name="method" value="edit" />
	<input type="hidden" name="mthd" />
	<html:hidden property="program.id" />
	<html:hidden property="program.numOfMembers" />
	<% 	String selectedTab = request.getParameter("view.tab");%>
			
	<table cellpadding="0" cellspacing="0" border="0" width="100%"	height="100%">
		
		<!-- Title -->
		<tr>
			<th class="pageTitle" align="center"><c:out value="${pageTitle}" /></th>
		</tr>

		<!-- function body start -->
		<tr>
			<td height="100%"> 
				<c:choose>
					<c:when test="${programId != null && programId gt 0}">
	
						<%
							if (selectedTab == null || selectedTab.trim().equals("")) {
						%>						
							<jsp:include page="/PMmodule/Admin/ProgramEdit/general.jsp" />						
						<%
							} else {
						%>
						<jsp:include page='<%="/PMmodule/Admin/ProgramEdit/" + selectedTab.toLowerCase() + ".jsp"%>' />
						<%
							}
						%>
					</c:when>
					<c:otherwise>
						<jsp:include page="/PMmodule/Admin/ProgramEdit/general.jsp" />
					</c:otherwise>
				</c:choose> 
			</td>
		</tr>
		<!-- function body end -->
	</table>

<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
