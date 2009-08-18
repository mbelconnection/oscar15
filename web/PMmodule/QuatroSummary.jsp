<%@ include file="/taglibs.jsp" %>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro" %>
<%@page import="com.quatro.common.KeyConstants;" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<script type="text/javascript" src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
<script lang="javascript">
<!--
	function submitForm(methodVal) {
	if (!trimInputBox()) return false;
	document.forms[0].method.value = methodVal;
	document.forms[0].submit();
}

function openHealthSafety(){
	var url = '<html:rewrite action="/PMmodule/QuatroHealthSafety.do"/>';
		url += '?method=form&clientId='+ '<c:out value="${client.demographicNo}"/>';
	win=window.open(url,'HealthSafety', 'scrollbars=1,width=800,height=450');
}	
// -->
</script>
 
<html-el:form action="/PMmodule/QuatroClientSummary.do">
<input type="hidden" name="method" value="edit" />
<input type="hidden" name="clientId" value="<c:out value="${clientId}"/>"/>
<input type="hidden" id="scrollPosition" name="scrollPosition" value='<c:out value="${scrPos}"/>' />
<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
	<tr><th class="pageTitle" align="center">Client Management - Summary</th></tr>
	<tr>
			<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
	</tr>
	<tr><td align="left" class="buttonBar2">
		<html:link action="/PMmodule/ClientSearch2.do" style="color:Navy;text-decoration:none;">&nbsp;
		<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Back16.png"/> />&nbsp;Back to Client Search&nbsp;&nbsp;</html:link></td>
	</tr>
	<tr><td align="left" class="message">
      <logic:messagesPresent message="true">
        <html:messages id="message" message="true" bundle="pmm"><c:out escapeXml="false" value="${message}" />
        </html:messages> 
      </logic:messagesPresent>
	</td></tr>
	<tr>
		<td height="100%">
		<div id="scrollBar"  onscroll="getDivPosition()"
			style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">

<!--  start of page content -->
<table width="100%" class="edit">
<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Personal information</th></tr>
</table></div></td></tr>

<tr><td>
<table wdith="100%" class="simple">
	<tr><td width="15%">Client No</td>
	<td width="35%"><c:out value="${client.demographicNo}" /></td>
	<td width="15%">Active</td>
	<td width="35%">
	  <logic:equal value="0" property="activeCount" name="client">No</logic:equal>
	  <logic:notEqual value="0" property="activeCount" name="client">Yes</logic:notEqual>
	</td></tr>
	<tr><td>First Name</td>
	<td><c:out value="${client.firstName}" /></td>
	<td>Gender</td>
	<td><c:out value="${client.sexDesc}" /></td></tr>
	<tr><td>Last Name</th>
	<td><c:out value="${client.lastName}" /></td>
	<td>Date of Birth</td>
	<td><c:out value="${client.dob}" /></td></tr>
	</tr>
	<tr><td>Alias</td>
	<td colspan="3"><c:out value="${client.alias}" /></td></tr>
	<tr><td>Health and Safety</td>
	<td colspan="3">&nbsp;      
        <table width="100%" class="simple" style="background: #e0e0e0;" cellspacing="2" cellpadding="2">
		<c:choose>
		  <c:when test="${empty healthsafety}">
			<tr><td>None found</td>
			<td>
			<c:if test="${accessTypeWrite}">
				<a href="javascript:openHealthSafety()">New Health and Safety</a>
			</c:if>
			</td></tr>
		  </c:when>
	      <c:when test="${empty healthsafety.message}">
			<tr><td>None found</td>
			<td> 
				 <c:if test="${accessTypeWrite}">
					<a href="javascript:openHealthSafety()">New Health and Safety</a>
				</c:if>			
			</td></tr>
		  </c:when>
		  <c:otherwise>
			<tr><td colspan="3"><c:out value="${healthsafety.message}" /></td></tr>
			<tr><td width="50%">User Name: <c:out value="${healthsafety.userName}" /></td>
			<td width="30%">Date: <fmt:formatDate value="${healthsafety.updateDate}" pattern="yyyy/MM/dd" /></td>
			<td width="20%">							 
				  <c:if test="${accessTypeWrite}">
			 		<a href="javascript:openHealthSafety()">Edit</a>
			 	</c:if>
			 	 <c:if test="${accessTypeWrite}">
			 		<a href="javascript:submitForm('deleteHS')"> &nbsp;&nbsp;Delete </a>
			 	</c:if>			
			</td></tr>
		  </c:otherwise>
		</c:choose>
       </table>

 	</td></tr>
</table>
</td></tr>

<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Family
  <c:if test="${groupHead != null}">
    -- <c:out value="${client.formattedName}" /> ( HEAD )
  </c:if>
</th></tr>
</table></div></td></tr>

<tr><td>
<display:table class="simple" cellspacing="2" cellpadding="3"  id="member" name="family" export="false" requestURI="/PMmodule/QuatroClientSummary.do">
	<display:setProperty name="paging.banner.placement" value="bottom" />
	<display:setProperty name="basic.msg.empty_list" value="No family member exists." />
	<display:column property="clientId" sortable="true" title="Client Id" />
	<display:column property="lastName" sortable="true" title="Last Name" />
	<display:column property="firstName" sortable="true" title="First Name" />
	<display:column property="dob" sortable="true" title="DOB" />
	<display:column property="sexDesc" sortable="true" title="Gender" />
	<display:column property="alias" sortable="true" title="Alias" />
	<display:column property="relationshipDesc" sortable="true" title="Relationship" />
</display:table>
</td></tr>

<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Bed/Room</th></tr>
</table></div></td></tr>

<tr><td>
<table wdith="100%" class="simple">
  <c:choose>
	<c:when test="${roomDemographic != null}">
	  <tr><th width="20%">Assigned Room:</th>
	  <td><c:out value="${roomDemographic.roomName}" /></td></tr>
	  <tr><th width="20%">Assigned Bed:</th>
	  <td><c:out value="${roomDemographic.bedName}" /></td></tr>
	</c:when>	
	<c:otherwise>
	  <tr><td>No bed or room reserved</td></tr>
	</c:otherwise>	
  </c:choose>
</table>
</td></tr>

<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Current Program</th></tr>
</table></div></td></tr>

<tr><td>
<display:table class="simple" cellspacing="2" cellpadding="3" id="clientCurrentProgram" name="clientCurrentPrograms" export="false" requestURI="/PMmodule/QuatroClientSummary.do">
	<display:setProperty name="paging.banner.placement" value="bottom" />
	<display:setProperty name="basic.msg.empty_list" value="This client is not currently admitted to any programs." />
	
	<display:column property="programName" sortable="true" title="Program Name" />
	<display:column property="programType" sortable="true" title="Program Type" />
	<display:column property="admissionDate.time" sortable="true" title="Admission Date" format="{0,date,yyyy/MM/dd hh:mm a}" />
	<display:column property="daysInProgram" sortable="true" title="Days in Program" />
</display:table>
</td></tr>

<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Referrals</th></tr>
</table></div></td></tr>

<tr><td>
<display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="referral" name="referrals" export="false" pagesize="0" requestURI="/PMmodule/QuatroClientSummary.do">
	<display:setProperty name="paging.banner.placement" value="bottom" />
	
	<display:column property="programName" sortable="true" title="Program Name" />
	<display:column property="programType" sortable="true" title="Program Type" />
	<display:column property="referralDate.time" format="{0, date, yyyy/MM/dd hh:mm a}" sortable="true" title="Referral Date" />
	<display:column property="providerFormattedName" sortable="true" title="Referring Provider" />
	<display:column property="daysCreated" sortable="true" title="Days in Queue">
	</display:column>
</display:table>
</td></tr>

</table>

<!--  end of page content -->
</div>
</td>
</tr>
</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
