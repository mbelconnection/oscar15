<%@ include file="/taglibs.jsp" %>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro" %>
<%@page import="com.quatro.common.KeyConstants;"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>

<head>
 	<link rel="stylesheet" type="text/css" href='<html:rewrite page="/css/core.css" />' />
	<link rel="stylesheet" type="text/css" href='<html:rewrite page="/css/displaytag.css" />' />
	<script type="text/javascript">
	function winClose() {		
		window.close();
	}
	</script>
</head>
<html-el:form action="/PMmodule/QuatroFamilyIntake.do">
<input type="hidden" name="intakeHeadId" value="<c:out value="${intakeHeadId}" />"/>
<input type="hidden" name="scrollPosition" value='<c:out value="${scrPos}"/>' />
<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
	<tr><th class="pageTitle" align="center">Client Management - Family Intake History</th></tr>
	<tr>
		<td align="left" class="buttonBar2">
            <a style="color:Navy;text-decoration:none;" href="javascript:winClose();">
	            <img border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;</a>
	    </td>
	</tr>
	<tr>
		<td height="100%">
		<div style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">
<!--  start of page content -->
<table width="100%" class="edit">
<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Family Members</th></tr>
</table></div></td></tr>
<tr><td>
<display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="dependent" name="dependents" export="false" pagesize="50" 
requestURI="/PMmodule/QuatroFamilyIntake.do">
			<display:setProperty name="paging.banner.placement" value="bottom" />
			<display:setProperty name="basic.msg.empty_list" value="No record found." />
            <display:column property="lastName" sortable="true" title="Last Name"/>
            <display:column property="firstName" sortable="true" title="First Name"/>
            <display:column property="dob" sortable="true" title="Date of Birth"/>
            <display:column property="sexDesc" sortable="true" title="Gender"/>
            <display:column property="alias" sortable="true" title="Alias"/>
            <display:column property="relationshipDesc" sortable="true" title="Relationship"/>
            <display:column property="joinFamilyDate.time" sortable="true" title="Join Date" format="{0,date,yyyy/MM/dd}"/>
            <display:column property="leaveFamilyDate.time" sortable="true" title="Left Date" format="{0,date, yyyy/MM/dd}"/>
</display:table>
</td></tr>
</table>
</div>
</td>
</tr>
</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
