<%@ include file="/taglibs.jsp"%>
<%@ page import="org.oscarehr.PMmodule.web.formbean.*"%>
<html:form action="/PMmodule/AgencyManager">
	<html:hidden property="view.tab" />
	<input type="hidden" name="id" value="<c:out value="${requestScope.id}"/>" />
	<input type="hidden" name="method" value="view" />
	<div class="tabs" id="tabs">
		<script>
			function clickTab(name) {
				document.agencyManagerForm.elements['view.tab'].value=name;
				document.agencyManagerForm.submit();
			}
		</script>
		<%
			String selectedTab = request.getParameter("view.tab");
		
			if (selectedTab == null || selectedTab.trim().equals("")) {
				selectedTab = AgencyManagerViewFormBean.tabs[0];
			}
		%>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<%
				for (int x = 0; x < AgencyManagerViewFormBean.tabs.length; x++) {
					if (AgencyManagerViewFormBean.tabs[x].equals(selectedTab)) {
				%>
				<td style="background-color: #555;">
					<a href="javascript:void(0)" onclick="javascript:clickTab('<%=AgencyManagerViewFormBean.tabs[x] %>'); return false;"><%=AgencyManagerViewFormBean.tabs[x]%></a>
				</td>
				<%
					} else {
				%>
				<td>
					<a href="javascript:void(0)" onclick="javascript:clickTab('<%=AgencyManagerViewFormBean.tabs[x] %>');return false;"><%=AgencyManagerViewFormBean.tabs[x]%></a>
				</td>
				<%
					}
				}
				%>
			</tr>
		</table>
	</div>
	<%@include file="/common/messages.jsp"%>
	<jsp:include page="<%="/PMmodule/Admin/AgencyView/" + selectedTab.toLowerCase().replaceAll(" ", "_") + ".jsp"%>" />
</html:form>