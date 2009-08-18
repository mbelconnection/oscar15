<%@ include file="/taglibs.jsp"%>
<% String s = "debug"; %>
<%@ page import="org.oscarehr.PMmodule.model.Facility"%>
<bean:define id="facility" name="facilityManagerForm"
	property="facility" />

<html:form action="/PMmodule/FacilityManager.do">
	<input type="hidden" name="method" value="save" />

	<table cellpadding="0" cellspacing="0" border="0" width="100%"
		height="100%">

		<!-- Title -->
		<tr>
			<th class="pageTitle" align="center">Facility Management - Facility Details</th>
		</tr>

		<!-- body start -->
		<tr>
			<td height="100%">

			<table width="100%" cellpadding="0px" cellspacing="0px" height="100%"
				border="0">
				<!-- submenu -->
				<tr>
					<td align="left" class="buttonBar2">
					<html:link
						action="/PMmodule/FacilityManager.do?method=list"
						style="color:Navy;text-decoration:none;">
						<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/close16.png"/>" />&nbsp;Close&nbsp;&nbsp;</html:link>
					</td>
				</tr>

				<!-- messages -->
				<tr>
					<td align="left" class="message"><logic:messagesPresent
						message="true">
						<br />
						<html:messages id="message" message="true" bundle="pmm">
							<c:out escapeXml="false" value="${message}" />
						</html:messages>
						<br />
					</logic:messagesPresent></td>
				</tr>

				<tr>
					<td height="100%">
					<div
						style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
				                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">


					<br />
					<div class="tabs" id="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th title="Facility Details">Facility Details</th>
						</tr>
					</table>
					</div>

					<table width="100%" cellpadding="0px" cellspacing="0px">

						<tr>
							<td>
							<table width="100%" border="1" cellspacing="2" cellpadding="3">
								<tr class="b">
									<td width="20%">Facility ID:</td>
									<td><c:out value="${facilityManagerForm.facility.id}" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Name:</td>
									<td><c:out
										value="${facilityManagerForm.facility.name}" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Description:</td>
									<td><c:out
										value="${facilityManagerForm.facility.description}" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Health Information Custodian:</td>
									<td><c:out value="${facilityManagerForm.facility.hic}" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Primary Contact Name:</td>
									<td><c:out
										value="${facilityManagerForm.facility.contactName}" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Primary Contact Email:</td>
									<td><c:out
										value="${facilityManagerForm.facility.contactEmail}" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Primary Contact Phone:</td>
									<td><c:out
										value="${facilityManagerForm.facility.contactPhone}" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Shelter:</td>
									<td><c:out
										value="${facilityManagerForm.facility.shelter}" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Sector:</td>
									<td><c:out
										value="${facilityManagerForm.facility.sector}" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Active:</td>
									<td>
										<logic:equal name="facilityManagerForm" property="facility.active" value="true">Yes</logic:equal>
										<logic:equal name="facilityManagerForm" property="facility.active" value="false">No</logic:equal>
									
									</td>
								</tr>

							</table>
							</td>
						</tr>
					</table>
					
					</div>
					</td>
				</tr>
			</table>



			</td>
		</tr>
		<!-- body end -->
	</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>

