<%@ include file="/taglibs.jsp"%>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro"%>
<%@ page import="com.quatro.common.KeyConstants"  %>
<c:set var="ctx" value="${pageContext.request.contextPath}"	scope="request" />
<script type="text/javascript"	src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
<script lang="javascript">
		function submitForm(methodVal) {
			if (!trimInputBox()) return false;
 			document.forms[0].method.value = methodVal;
			document.forms[0].submit();
		}
	
		function updateQuatroDischarge(clientId, admId) {
			location.href = '<html:rewrite action="/PMmodule/QuatroDischarge.do"/>' + "?method=edit&admissionId=" + admId + "&clientId=" + clientId;
		}	
</script>
<html-el:form action="/PMmodule/QuatroDischarge.do">
	<input type="hidden" name="method" />	
	<input type="hidden" name="clientId"/>
	<% String admitStr="admitted" ;%>
	<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
		<tr>
			<th class="pageTitle" align="center">Client Management - Discharge</th>
		</tr>
		<tr>
			<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
		</tr>
		<tr>
			<td align="left" class="buttonBar2">
				<html:link action="/PMmodule/ClientSearch2.do" style="color:Navy;text-decoration:none;">
				<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Back16.png"/> />&nbsp;Back to Client Search&nbsp;&nbsp;</html:link>
			</td>
		</tr>
		<tr>
			<td align="left" class="message">
				<logic:messagesPresent	message="true">
					<html:messages id="message" message="true" bundle="pmm">
						<c:out escapeXml="false" value="${message}" />
					</html:messages>
				</logic:messagesPresent>
			</td>
		</tr>
		<tr>
			<td height="100%">
			<div style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">

			<!--  start of page content -->
			<table width="100%" class="edit">
				<tr>
					<td><br>
					<div class="tabs">
						<table cellpadding="3" cellspacing="0" border="0">
							<tr>
								<th>Discharge</th>
							</tr>
						</table>
					</div>
					</td>
				</tr>
				<tr>
					<td>
          <display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="discharge" name="quatroDischarge" export="false" pagesize="50" requestURI="/PMmodule/QuatroDischarge.do">
			<display:setProperty name="paging.banner.placement" value="bottom" />
			<display:setProperty name="basic.msg.empty_list" value="No record found." />
            <display:column property="programName" sortable="true" title="Program Name"/>
            <display:column property="admissionDate.time" sortable="true" title="Admission Date" format="{0,date,yyyy/MM/dd hh:mm:ss a}" />
            <display:column property="providerName" sortable="true" title="Staff"/>
            <display:column property="admissionStatus" sortable="true" title="Status"/>
            <display:column sortable="false" title="Actions">
				<c:choose>								
					<c:when test="${discharge.admissionStatus == 'admitted'}">
					  <c:choose>								
						  <c:when test="${discharge.familyMember == false}">
						  	<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTDISCHARGE %>" rights="<%=KeyConstants.ACCESS_WRITE %>">								
						    	<a href="javascript:updateQuatroDischarge('<c:out value="${client.demographicNo}" />', '<c:out value="${discharge.id}" />')" >Discharge</a>
						 	</security:oscarSec>						 	
						  </c:when>
						  <c:otherwise>Family Member</c:otherwise>
					  </c:choose>
					</c:when>
					<c:when test="${discharge.admissionStatus == 'discharged'}">
						<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTDISCHARGE %>" rights="<%=KeyConstants.ACCESS_READ %>">								
						  	 	<a href="javascript:updateQuatroDischarge('<c:out value="${client.demographicNo}" />', '<c:out value="${discharge.id}" />')" >View</a>
							</security:oscarSec>
					</c:when>
					<c:otherwise>
					<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTDISCHARGE %>" rights="<%=KeyConstants.ACCESS_READ %>">								
				      <a href="javascript:updateQuatroDischarge('<c:out value="${client.demographicNo}" />', '<c:out value="${discharge.id}" />')" >View</a>
					</security:oscarSec>
					</c:otherwise>
				</c:choose>
            </display:column>
         </display:table>
					</td>
				</tr>

			</table>

			<!--  end of page content --></div>
			</td>
		</tr>
	</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
