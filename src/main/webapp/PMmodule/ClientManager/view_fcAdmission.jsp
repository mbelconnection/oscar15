<%@ page import="org.apache.struts.validator.DynaValidatorForm"%>
<%@ page import="org.oscarehr.PMmodule.model.Admission"%>
<%@ page import="org.oscarehr.PMmodule.model.DischargeReason"%>

<%--


    Copyright (c) 2005-2012. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved.
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

    This software was written for
    Centre for Research on Inner City Health, St. Michael's Hospital,
    Toronto, Ontario, Canada

--%>

<%@ include file="/taglibs.jsp"%>
<%@page import="org.oscarehr.common.model.FunctionalCentreAdmission"%>

<script>
function save() {
		alert("save fc admission");
		document.clientManagerForm.method.value='saveFcAdmission';
		document.clientManagerForm.submit()
	}
</script>
<%
FunctionalCentreAdmission fcAdmission = (FunctionalCentreAdmission)request.getAttribute("fcAdmission");
%>
<html>
<head></head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<title>Functional Centre Admission Details</title>

<link rel="stylesheet" type="text/css" media="all" href="../share/css/extractedFromPages.css"  />
<body>
<form id="fcAdmissionForm" name="fcAdmissionForm" action="ClientManager/functionalCentreAdmissionAction.jsp" method="post" >	

<table width="100%" border="0" cellspacing="1" cellpadding="1">

<input type="hidden" id="fcAdmissionId" name="fcAdmissionId" value=<%=fcAdmission.getId() %> >

<input type="hidden" id="clientId" name="clientId" value=<%=fcAdmission.getDemographicNo() %> >

<tr class="b">
	<td width="70%">Referral Date (YYYY-MM-DD):</td>
	<td><input type="text" name="referralDate" id="referralDate" value=<%=fcAdmission.getReferralDate() %> size="10" maxlength="10"></td>
</tr>

<tr class="b">
	<td width="70%">Admission Date (YYYY-MM-DD):</td>
	<td><input type="text" name="admissionDate" id="admissionDate" value=<%=fcAdmission.getAdmissionDate() %> size="10" maxlength="10"></td>
</tr>

<tr class="b">
	<td width="70%">Service Initiation Date (YYYY-MM-DD):</td>
	<td><input type="text" name="serviceInitiationDate" id="serviceInitiationDate" value=<%=fcAdmission.getServiceInitiationDate() %> size="10" maxlength="10"></td>
</tr>

<tr class="b">
	<td width="70%">Discharge Date (YYYY-MM-DD):</td>
	<td><input type="text" name="dischargeDate" id="dischargeDate" value=<%=fcAdmission.getDischargeDate() %> size="10" maxlength="10"></td>
</tr>

<tr>
	<td colspan="2">
		<input type="submit" value="Save" onclick="window.close();"/>
		<input type="button" name="cancel" value="Cancel" onclick="window.close()" />
	</td>
</tr>

</table>
</form>

</body>
</html>
