<%@ include file="/taglibs.jsp"%>
<%@ page import="org.oscarehr.PMmodule.web.formbean.*"%>
<%@page import="org.oscarehr.PMmodule.model.Program"%>

<html:form action="/PMmodule/ProgramManagerView">
	
	<html:hidden property="tab" />
	<input type="hidden" name="programId" value="<c:out value="${requestScope.programId}"/>" />
	<input type="hidden" name="method" value="view" />
	
	


	<%
		String selectedTab = request.getParameter("tab");
			
		if (selectedTab == null || selectedTab.trim().equals("")) {
			selectedTab = ProgramManagerViewFormBean.tabs[0];
		}
	%>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<th class="pageTitle" align="center">Program Management - <c:out value="${program.name}" /></th>
			
		</tr>
		
		<tr>
			<td height="100%">
				<jsp:include page='<%="/PMmodule/Admin/ProgramView/" + selectedTab.toLowerCase().replaceAll(" ", "_") + ".jsp"%>' />
			</td>
		</tr>
	</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
