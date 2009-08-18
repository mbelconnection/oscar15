<%@ include file="/taglibs.jsp"%>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro"%>
<%@page import="java.util.Date"%>
<%@page import="org.oscarehr.util.SpringUtils"%>
<%@page import="org.oscarehr.PMmodule.model.ProgramClientRestriction"%>
<%@page import="org.oscarehr.PMmodule.model.Provider"%>
<%@page import="com.quatro.common.KeyConstants"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"
	scope="request" />
<script type="text/javascript"
	src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
<script lang="javascript">
	function submitForm(methodVal) {
		if (!trimInputBox()) return false;
		document.forms[0].method.value = methodVal;
		document.forms[0].submit();
	}
	function terminateEarly(restrictionId, clientId)
    {
    	if (confirm('Do you wish to terminate this service restriction?'))
    	{
	        var form = document.serviceRestrictionForm;
	        form.action = '<html:rewrite action="/PMmodule/QuatroServiceRestriction.do?clientId=" />' + clientId;
	        form.method.value='terminate_early';
	        form.rId.value=restrictionId;
	        form.submit();
    	}
    }
</script>
<html-el:form action="/PMmodule/QuatroServiceRestriction.do">
	<input type="hidden" name="method" />
	<input type="hidden" name="demoNo" />
	<input type="hidden" name="rId" />
	<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
		<tr>
			<th class="pageTitle" align="center">Client Management - Service
			Restriction List</th>
		</tr>
		<tr>
			<td class="simple" style="background: lavender"><%@ include
				file="ClientInfo.jsp"%></td>
		</tr>
		<tr>
			<td align="left" class="buttonBar2">
				<html:link action="/PMmodule/ClientSearch2.do" style="color:Navy;text-decoration:none;">
					<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Back16.png"/> />&nbsp;Back to Client Search&nbsp;&nbsp;|</html:link>
			    <c:if test="${currentIntakeProgramId>0}">
				<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTRESTRICTION %>"  orgCd='<%=((Integer) request.getSession().getAttribute("currentIntakeProgramId")).toString()%>' rights="<%=KeyConstants.ACCESS_WRITE %>">
					<html:link	action="/PMmodule/QuatroServiceRestriction.do?method=edit&rId=0"  style="color:Navy;text-decoration:none;">&nbsp;
					<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/New16.png"/> />&nbsp;New Service Restriction&nbsp;&nbsp;</html:link> 
				</security:oscarSec>	
				</c:if>
			</td>
		</tr>
		<tr>
			<td align="left" class="message"><logic:messagesPresent
				message="true">
				<html:messages id="message" message="true" bundle="pmm">
					<c:out escapeXml="false" value="${message}" />
				</html:messages>
			</logic:messagesPresent></td>
		</tr>
		<tr>
			<td><br>
			<div class="tabs">
			<table cellpadding="3" cellspacing="0" border="0">
				<tr>
					<th>Service Restrictions</th>
				</tr>
			</table>
			</div>
			</td>
		</tr>
		<tr>
			<td height="100%">
			<div
				style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">

			<!--  start of page content -->
			<table width="100%" class="edit">
				<tr>
					<td><display:table class="simple" cellspacing="2" 
						cellpadding="3" id="service_restriction"
						name="serviceRestrictions" export="false" pagesize="0"
						requestURI="/PMmodule/QuatroServiceRestriction.do">
						<%
									boolean allowTerminateEarly = false;
									ProgramClientRestriction temp = null;
						%>
						<display:setProperty name="paging.banner.placement" value="bottom" />
						
						<display:column sortable="true"	title="ID" sortProperty="id">
							<a href="<html:rewrite action="/PMmodule/QuatroServiceRestriction.do"/>?method=edit&clientId=<c:out value="${clientId}" />&rId=<c:out value="${service_restriction.id}" />">
								<c:out value="${service_restriction.id}" /> </a>
						</display:column>	
						
						<display:column property="programDesc" sortable="true"
							title="Program Name" />
							
						<display:column property="providerFormattedName"
							sortProperty="providerFormattedName" sortable="true"
							title="Restricted By" />
						<display:column property="startDateDisplay" sortable="true"
							title="Start date">
						</display:column>
						<display:column property="endDateDisplay" sortable="true"
							title="End date">

						</display:column>
						<display:column sortable="true" title="Status">
							<c:set var="pName"
								value="${service_restriction.providerFormattedName}" />

							<%
								String needAppend = "N";
								temp = (ProgramClientRestriction) service_restriction;
								String status = "";
								allowTerminateEarly = false;
								if (temp.getEarlyTerminationProvider() != null) {
									needAppend = "Y";
									status = "terminated early";
								} else if (temp.getEndDate().getTime().getTime() < System
										.currentTimeMillis()) {
									status = "completed";
								} else if (temp.getStartDate().getTime().getTime() <= System
										.currentTimeMillis()
										&& temp.getEndDate().getTime().getTime() >= System
										.currentTimeMillis()) {
									status = "in progress";
									allowTerminateEarly = true;
								}
							%>
							<c:set var="addYn" value="${needAppend}" />
							<c:choose>
								<c:when test="${addYn eq 'Y'}">
									<%=status%>
									<c:out value="${pName}"></c:out>
								</c:when>
								<c:otherwise>
									<%=status%>
								</c:otherwise>
							</c:choose>
						</display:column>
						<display:column sortable="true" title="">
						   <security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTRESTRICTION %>" rights="<%=KeyConstants.ACCESS_UPDATE %>">								
								<input type="button" <%=allowTerminateEarly?"":"disabled=\"disabled\""%>
									value="Terminate Early"
									onclick="terminateEarly(<%=temp.getId()%>, <%=request.getAttribute("clientId") %>)" />
								</security:oscarSec>
						</display:column>
						
					</display:table></td>
				</tr>
			</table>
			<!--  end of page content --></div>
			</td>
		</tr>
	</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
