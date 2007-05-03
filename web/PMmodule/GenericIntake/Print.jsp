<%@ include file="/taglibs.jsp"%>
<%@ page import="org.oscarehr.PMmodule.model.Intake"%>
<%@ page import="org.oscarehr.PMmodule.web.formbean.GenericIntakeEditFormBean"%>
<%
GenericIntakeEditFormBean intakeEditForm = (GenericIntakeEditFormBean) session.getAttribute("genericIntakeEditForm");
Intake intake = intakeEditForm.getIntake();
%>
<html:html xhtml="true" locale="true">
	<head>
		<title>Generic Intake Print</title>
		<style type="text/css">
			@import "<html:rewrite page="/css/genericIntake.css" />";
		</style>
		<script type="text/javascript">
			<!--
			var djConfig = {
				isDebug: false,
				parseWidgets: false,
				searchIds: ["layoutContainer", "topPane", "clientPane", "bottomPane", "clientTable", "admissionsTable"]
			};
			// -->
		</script>
		<script type="text/javascript" src="<html:rewrite page="/dojoAjax/dojo.js" />"></script>
		<script type="text/javascript">
			<!--
			dojo.require("dojo.widget.*");
			dojo.require("dojo.validate.*");
			// -->
		</script>
		<html:base />
	</head>
	<body class="printBody">
		<table class="intakeTable">
			<tr>
				<td>
					<input type="button" value="Print" onclick="window.print()">
				</td>
				<td align="right">
					<input type="button" value="Close" onclick="self.close()" />
				</td>
			</tr>
		</table>
		<div id="topPane" dojoType="ContentPane" layoutAlign="top" class="intakeTopPane">
			<c:out value="${sessionScope.genericIntakeEditForm.title}" />
		</div>
		<div id="clientPane" dojoType="ContentPane" layoutAlign="client" class="intakeChildPane">
			<div id="clientTable" dojoType="TitlePane" label="Client Information" title="(Fields marked with * are mandatory)" labelNodeClass="intakeSectionLabel" containerNodeClass="intakeSectionContainer">
				<table class="intakeTable">
					<tr>
						<td><label>First Name<br><c:out value="${sessionScope.genericIntakeEditForm.client.firstName}" /></label></td>
						<td><label>Last Name<br><c:out value="${sessionScope.genericIntakeEditForm.client.lastName}" /></label></td>
						<td><label>Gender<br><c:out value="${sessionScope.genericIntakeEditForm.client.sex}" /></label></td>
						<td><label>Birth Date<br><c:out value="${sessionScope.genericIntakeEditForm.client.formattedDob}" /></label></td>
					</tr>
					<tr>
						<td><label>Health Card #<br><c:out value="${sessionScope.genericIntakeEditForm.client.hin}" /></label></td>
						<td><label>Version<br><c:out value="${sessionScope.genericIntakeEditForm.client.ver}" /></label></td>
					</tr>
					<tr>
						<td><label>Email<br><c:out value="${sessionScope.genericIntakeEditForm.client.email}" /></label></td>
						<td><label>Phone #<br><c:out value="${sessionScope.genericIntakeEditForm.client.phone}" /></label></td>
						<td><label>Secondary Phone #<br><c:out value="${sessionScope.genericIntakeEditForm.client.phone2}" /></label></td>
					</tr>
					<tr>
						<td><label>Street<br><c:out value="${sessionScope.genericIntakeEditForm.client.address}" /></label></td>
					<td><label>City<br><c:out value="${sessionScope.genericIntakeEditForm.client.city}" /></label></td>
						<td><label>Province<br><c:out value="${sessionScope.genericIntakeEditForm.client.province}" /></label></td>
							<td><label>Postal Code<br><c:out value="${sessionScope.genericIntakeEditForm.client.postal}" /></label></td>
					</tr>
				</table>
			</div>
			<caisi:intake base="<%=3%>" intake="<%=intake%>" />
		</div>
	</body>
</html:html>
