<%@ include file="/taglibs.jsp"%>


<%@page import="org.oscarehr.PMmodule.web.ClientManagerAction"%>
<%@page import="org.oscarehr.common.model.CdsClientForm"%>
<%@page import="java.util.Enumeration"%><input type="hidden" name="clientId" value="" />
<input type="hidden" name="formId" value="" />
<input type="hidden" id="formInstanceId" value="0" />

<script>
function updateQuickIntake(clientId) {
	location.href = '<html:rewrite action="/PMmodule/GenericIntake/Edit.do"/>' + "?method=update&type=quick&clientId=" + clientId;
}

function updateIndepthIntake(clientId) {
	location.href = '<html:rewrite action="/PMmodule/GenericIntake/Edit.do"/>' + "?method=update&type=indepth&clientId=" + clientId;
}

function updateProgramIntake(clientId, programId) {
	location.href = '<html:rewrite action="/PMmodule/GenericIntake/Edit.do"/>' + "?method=update&type=program&clientId=" + clientId + "&programId=" + programId;
}

function updateProgramIntake(clientId) {
	var selectBox = getElement('programWithIntakeId');
	var programId = selectBox.options[selectBox.selectedIndex].value;
	
	if (programId != null) {
		location.href = '<html:rewrite action="/PMmodule/GenericIntake/Edit.do"/>' + "?method=update&type=program&clientId=" + clientId + "&programId=" + programId;
		return true;
	}
	
	return false;
}

function printQuickIntake(clientId, intakeId) {
	url = '<html:rewrite action="/PMmodule/GenericIntake/Edit.do"/>' + "?method=print&type=quick&intakeId=" + intakeId + "&clientId=" + clientId;
	window.open(url, 'quickIntakePrint', 'width=1024,height=768,scrollbars=1');
}

function printIndepthIntake(clientId) {
	url = '<html:rewrite action="/PMmodule/GenericIntake/Edit.do"/>' + "?method=print&type=indepth&intakeId=-1&clientId=" + clientId;
	window.open(url, 'indepthIntakePrint', 'width=1024,height=768,scrollbars=1');
}

function printIntake(clientId, intakeId) {
	url = '<html:rewrite action="/PMmodule/GenericIntake/Edit.do"/>' + "?method=print&type=quick&intakeId="+intakeId+"&clientId=" + clientId;
	window.open(url, 'indepthIntakePrint', 'width=1024,height=768,scrollbars=1');
}

function printProgramIntake(clientId, programId) {
	url = '<html:rewrite action="/PMmodule/GenericIntake/Edit.do"/>' + "?method=print&type=program&intakeId=-1&clientId=" + clientId + "&programId=" + programId;
	window.open(url, 'programIntakePrint', 'width=1024,height=768,scrollbars=1');
}

function openSurvey(methodId) {
	var selectBox = getElement('form.formId');	
	var formId = selectBox.options[selectBox.selectedIndex].value;	
	document.clientManagerForm.clientId.value='<c:out value="${client.demographicNo}"/>'; 
	document.clientManagerForm.formId.value=formId;		
	var id = document.getElementById('formInstanceId').value;	
	if(methodId == 0) 
		methodName = "survey";
	else	
	 	methodName = "printPreview_survey";
		
	location.href = '<html:rewrite action="/PMmodule/Forms/SurveyExecute.do"/>' + "?method="+ methodName + "&formId=" + formId + "&formInstanceId=" + id + "&clientId=" + '<c:out value="${client.demographicNo}"/>';
}

function createIntake(clientId,nodeId) {
	if(nodeId == '') {
		return;
	}
	location.href = '<html:rewrite action="/PMmodule/GenericIntake/Edit.do"/>' + "?method=update&type=none&nodeId="+nodeId+"&clientId=" + clientId;

}

function getIntakeReportByNodeId(nodeId) {
    var oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    var startDate = prompt("Please enter a start date in this format (e.g. 2000-01-01)", dojo.date.format(oneWeekAgo, {selector:'dateOnly', datePattern:'yyyy-MM-dd'}));
    if (startDate == null) {
        return;
    }
    if (!dojo.validate.isValidDate(startDate, 'YYYY-MM-DD')) {
        alert("'" + startDate + "' is not a valid start date");
        return;
    }

    var endDate = prompt("Please enter the end date in this format (e.g. 2000-12-01)", dojo.date.format(new Date(), {selector:'dateOnly', datePattern:'yyyy-MM-dd'}));
    if (endDate == null) {
        return;
    }
    if (!dojo.validate.isValidDate(endDate, 'YYYY-MM-DD')) {
        alert("'" + endDate + "' is not a valid end date");
        return;
    }

    var includePast = confirm("Do you want to include past intake forms in your report? ([OK] for yes / [Cancel] for no)");

    alert("Generating report from " + startDate + " to " + endDate + ". Please note: it is normal for the generation process to take up to a few minutes to complete, be patient.");

    var url = '<html:rewrite action="/PMmodule/GenericIntake/Report"/>?' + 'nodeId=' + nodeId + '&method=report' + '&type=&startDate=' + startDate + '&endDate=' + endDate + '&includePast=' + includePast;
    
    popupPage2(url, "IntakeReport" + nodeId);
}
</script>

<div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
	<tr>
		<th title="Programs">Registration Intake</th>
	</tr>
</table>
</div>
<table class="simple" cellspacing="2" cellpadding="3">
	<thead>
		<tr>
			<th>Date</th>
			<th>Staff</th>
			<th>Status</th>
			<th>Actions</th>
		</tr>
	</thead>
	<c:forEach var="intake" items="${regIntakes}">
		<tr>
			<td width="20%"><c:out value="${intake.createdOnStr}" /></td>
			<td><c:out value="${intake.staffName}" /></td>
			<td><c:out value="${intake.intakeStatus}" /></td>
			<td><input type="button" value="Print Preview" onclick="printQuickIntake('<c:out value="${client.demographicNo}" />','<c:out value="${intake.id}" />')" /></td>
		</tr>
	</c:forEach>
	<tr>
		<td colspan="3"><input type="button" value="Update" onclick="updateQuickIntake('<c:out value="${client.demographicNo}" />')" /></td>
	</tr>
</table>
<br />
<br />

<div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
	<tr>
		<th title="Programs">Follow-up Intake</th>
	</tr>
</table>
</div>
<table class="simple" cellspacing="2" cellpadding="3">
	<thead>
		<tr>
			<th>Date</th>
			<th>Name</th>
			<th>Staff</th>
			<th>Actions</th>
		</tr>
	</thead>
	<c:forEach var="intake" items="${indepthIntakes}">
		<tr>
			<td width="20%"><c:out value="${intake.createdOnStr}" /></td>
			<td><c:out value="${intake.node.label.label}" /></td>
			<td><c:out value="${intake.staffName}" /></td>
			<td><input type="button" value="Update" onclick="createIntake('<c:out value="${client.demographicNo}" />',<c:out value="${intake.node.id}"/>)" /> <input type="button" value="Print Preview"
				onclick="printIntake('<c:out value="${client.demographicNo}" />',<c:out value="${intake.id}" />)" /></td>
		</tr>
	</c:forEach>
</table>
New Follow-up Intake:&nbsp;
<select onchange="createIntake('<c:out value="${client.demographicNo}" />',this.options[this.selectedIndex].value);">
	<option value="" selected></option>
	<c:forEach var="node" items="${indepthIntakeNodes}">
		<option value="<c:out value="${node.id}"/>"><c:out value="${node.label.label}" /></option>
	</c:forEach>
</select>

<br />
<br />

<div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
	<tr>
		<th title="Programs">General Forms</th>
	</tr>
</table>
</div>
<table class="simple" cellspacing="2" cellpadding="3">
	<thead>
		<tr>
			<th>Date</th>
			<th>Name</th>
			<th>Staff</th>
			<th>Actions</th>
		</tr>
	</thead>
	<c:forEach var="intake" items="${generalIntakes}">
		<tr>
			<td width="20%"><c:out value="${intake.createdOnStr}" /></td>
			<td><c:out value="${intake.node.label.label}" /></td>
			<td><c:out value="${intake.staffName}" /></td>
			<td>
				<input type="button" value="Update" onclick="createIntake('<c:out value="${client.demographicNo}" />',<c:out value="${intake.node.id}"/>)" /> 
				<input type="button" value="Print Preview" onclick="printIntake('<c:out value="${client.demographicNo}" />',<c:out value="${intake.id}" />)" />				
			</td>
		</tr>
	</c:forEach>
</table>
New General Form:&nbsp;
<select onchange="createIntake('<c:out value="${client.demographicNo}" />',this.options[this.selectedIndex].value);">
	<option value="" selected></option>
	<c:forEach var="node" items="${generalIntakeNodes}">
		<option value="<c:out value="${node.id}"/>"><c:out value="${node.label.label}" /></option>
	</c:forEach>
</select>
<br />

<br />
<br />
<!-- 
<div class="tabs">
	<table cellpadding="3" cellspacing="0" border="0">
		<tr>
			<th title="Programs">Program Intakes</th>
		</tr>
	</table>
</div>
<table class="simple" cellspacing="2" cellpadding="3">
	<thead>
		<tr>
			<th>Date</th>
			<th>Staff</th>
			<th>Actions</th>
		</tr>
	</thead>
	<c:forEach var="intake" items="${programIntakes}">
		<tr>
			<td width="20%"><c:out value="${intake.createdOnStr}" /></td>
			<td><c:out value="${intake.staffName}" /></td>
			<td>
				<input type="button" value="Print Preview" onclick="printProgramIntake('<c:out value="${client.demographicNo}" />', '<c:out value="${intake.programId}" />')" />
				<input type="button" value="Update" onclick="updateProgramIntake('<c:out value="${client.demographicNo}" />', '<c:out value="${intake.programId}" />')" />
			</td>
		</tr>
	</c:forEach>
	<tr>
		<td colspan="3">
			<html:select property="programWithIntakeId">
				<html:options collection="programsWithIntake" property="id" labelProperty="name" />
			</html:select>
			<input type="button" value="Update" onclick="updateProgramIntake('<c:out value="${client.demographicNo}" />')" />
		</td>
	</tr>
</table>
<br />
<br />
-->
<div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
	<tr>
		<th title="Programs">User Created Forms</th>
	</tr>
</table>
</div>
<table class="simple" cellspacing="2" cellpadding="3">
	<thead>
		<tr>
			<th>Form Name</th>
			<th>Date</th>
			<th>Staff</th>
			<th>Actions</th>
		</tr>
	</thead>
	<c:forEach var="form" items="${surveys}">
		<tr>
			<td><c:out value="${form.description}" /></td>
			<td><c:out value="${form.dateCreated}" /></td>
			<td><c:out value="${form.username}" /></td>
			<td><input type="button" value="Update" onclick="document.clientManagerForm.elements['form.formId'].value='<c:out value="${form.formId}"/>';document.clientManagerForm.elements['formInstanceId'].value='<c:out value="${form.id}"/>';openSurvey(0);" />
			<input type="button" value="Print Preview" onclick="document.clientManagerForm.elements['form.formId'].value='<c:out value="${form.formId}"/>';document.clientManagerForm.elements['formInstanceId'].value='<c:out value="${form.id}"/>';openSurvey(1);" /></td>

		</tr>
	</c:forEach>
</table>
New User Created Form:&nbsp;
<html:select property="form.formId" onchange="openSurvey(0)">
	<html:option value="0">&nbsp;</html:option>
	<html:options collection="survey_list" property="formId" labelProperty="description" />
</html:select>
<br />
<br />

<div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
	<tr>
		<th title="Programs">Consent History</th>
	</tr>
</table>
</div>
<table class="simple" cellspacing="2" cellpadding="3">
	<thead>
		<tr>
			<th>Date</th>
			<th>Provider</th>
			<th></th>
		</tr>
	</thead>
	<c:forEach var="form" items="${consents}">
		<tr>
			<td><c:out value="${form.createdDate}" /></td>
			<td><c:out value="${form.provider}" /></td>
			<td><a href="ClientManager/manage_consent.jsp?viewConsentId=<c:out value="${form.consentId}" />&demographicId=<%=request.getAttribute("id")%>">details</a></td>
		</tr>
	</c:forEach>
</table>
<br />
<br />

<div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
	<tr>
		<th title="Programs">CDS History</th>
	</tr>
</table>
</div>
<table class="simple" cellspacing="2" cellpadding="3">
	<thead>
		<tr>
			<th>Admission</th>
			<th>Date</th>
			<th>Provider</th>
			<th>Signed</th>
			<th></th>
		</tr>
	</thead>
	<c:forEach var="form" items="${cdsForms}">
		<tr>
			<c:set var="form" value="${form}" scope="request" />
			<%
				System.err.println("----- req ");
				Enumeration e=request.getAttributeNames();
				while (e.hasMoreElements())
				{
					System.err.println(e.nextElement());
				}

				CdsClientForm cdsForm=(CdsClientForm)request.getAttribute("form");
				String admissionString=ClientManagerAction.getEscapedAdmissionSelectionDisplay(cdsForm.getAdmissionId());
			%>
			<td><%=admissionString%></td>
			<td><%=ClientManagerAction.getEscapedDateDisplay(cdsForm.getCreated())%></td>
			<td><%=ClientManagerAction.getEscapedProviderDisplay(cdsForm.getProviderNo())%></td>
			<td><%=cdsForm.isSigned()%></td>
			<td><a>details</a></td>
		</tr>
	</c:forEach>
</table>
<br />
<br />