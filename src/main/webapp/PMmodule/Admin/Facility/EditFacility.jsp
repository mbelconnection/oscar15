<%@ include file="/taglibs.jsp"%>

<%@ include file="/common/messages.jsp"%>

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/validation.js">
</script>
<script type="text/javascript">
	function validateForm()
	{
		if (bCancel == true) 
			return confirm("Do you really want to Cancel?");
		var isOk = false;
		isOk = validateRequiredField('facilityName', 'Facility Name', 32);
		if (isOk) isOk = validateRequiredField('facilityDesc', 'Facility Description', 70);
		return isOk;
	}
</script>
<!-- don't close in 1 statement, will break IE7 -->


<div class="tabs" id="tabs">
<table cellpadding="3" cellspacing="0" border="0">
	<tr>
		<th title="Facility">Edit facility</th>
	</tr>
</table>
</div>

<html:form action="/PMmodule/FacilityManager.do"
	onsubmit="return validateForm();">
	<input type="hidden" name="method" value="save" />
	<table width="100%" border="1" cellspacing="2" cellpadding="3">
		<tr class="b">
			<td width="20%">Facility Id:</td>
			<td><c:out value="${requestScope.id}" /></td>

		</tr>
		<tr class="b">
			<td width="20%">Name: *</td>
			<td><html:text property="facility.name" size="32" maxlength="32"
				styleId="facilityName" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Description: *</td>
			<td><html:text property="facility.description" size="70"
				maxlength="70" styleId="facilityDesc" /></td>
		</tr>
		<tr class="b">
			<td width="20%">HIC:</td>
			<td><html:checkbox property="facility.hic" /></td>
		</tr>
		<tr class="b">
			<td width="20%">OCAN Service Org Number: *</td>
			<td><html:text property="facility.ocanServiceOrgNumber" size="5" maxlength="5"
				styleId="ocanServiceOrgNumber" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Primary Contact Name:</td>
			<td><html:text property="facility.contactName" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Primary Contact Email:</td>
			<td><html:text property="facility.contactEmail" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Primary Contact Phone:</td>
			<td><html:text property="facility.contactPhone" /></td>
		</tr>
		<%
        	Integer orgId = (Integer)request.getAttribute("orgId");
        	Integer sectorId = (Integer)request.getAttribute("sectorID");
        
        %>
		<tr class="b">
			<td width="20%">Organization:</td>
			<td><select name="facility.orgId">
				<option value="0">&nbsp;</option>
				<c:forEach var="org" items="${orgList}">
					<c:choose>
						<c:when test="${orgId == org.code }">
							<option value="<c:out value="${org.code}"/>" selected><c:out
								value="${org.description}" /></option>
						</c:when>
						<c:otherwise>
							<option value="<c:out value="${org.code}"/>"><c:out
								value="${org.description}" /></option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</select></td>
		</tr>
		<tr class="b">
			<td width="20%">Sector:</td>
			<td><select name="facility.sectorId">
				<option value="0">&nbsp;</option>
				<c:forEach var="sector" items="${sectorList}">
					<c:choose>
						<c:when test="${sectorId == sector.code }">
							<option value="<c:out value="${sector.code}"/>" selected><c:out
								value="${sector.description}" /></option>
						</c:when>
						<c:otherwise>
							<option value="<c:out value="${sector.code}"/>"><c:out
								value="${sector.description}" /></option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</select></td>
		</tr>
		<tr class="b">
			<td width="20%">Enable Digital Signatures:</td>
			<td><html:checkbox property="facility.enableDigitalSignatures" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Enable Integrator:</td>
			<td><html:checkbox property="facility.integratorEnabled" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Integrator Url:</td>
			<td><html:text property="facility.integratorUrl" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Integrator User:</td>
			<td><html:text property="facility.integratorUser" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Integrator Password:</td>
			<td><html:password property="facility.integratorPassword" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Allow SIMS Integration:</td>
			<td><html:checkbox property="facility.allowSims" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Enable Integrated Referrals:</td>
			<td><html:checkbox property="facility.enableIntegratedReferrals" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Enable Health Number Registry:</td>
			<td><html:checkbox property="facility.enableHealthNumberRegistry" /></td>
		</tr>		
		<tr class="b">
			<td width="20%">Enable OCAN Forms:</td>
			<td><html:checkbox property="facility.enableOcanForms" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Enable Anonymous Clients:</td>
			<td><html:checkbox property="facility.enableAnonymous" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Enable Group Notes:</td>
			<td><html:checkbox property="facility.enableGroupNotes" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Enable Mandatory Encounter Time in Encounter:</td>
			<td><html:checkbox property="facility.enableEncounterTime" /></td>
		</tr>
		<tr class="b">
			<td width="20%">Enable Mandatory Transportation Time in Encounter:</td>
			<td><html:checkbox property="facility.enableEncounterTransportationTime" /></td>
		</tr>
		
		<tr class="b">
			<td width="20%">Rx Interaction Warning Level:</td>
			<td>
				<html:select property="facility.rxInteractionWarningLevel">
					<html:option value="0">Not Specified</html:option>
					<html:option value="1">Low</html:option>
					<html:option value="2">Medium</html:option>
					<html:option value="3">High</html:option>
					<html:option value="4">None</html:option>					
				</html:select>
				
			</td>
		</tr>
		
		<tr>
			<td colspan="2"><html:submit property="submit.save" onclick="bCancel=false;">Save</html:submit>
			<html:cancel>Cancel</html:cancel></td>
		</tr>
	</table>
</html:form>
<div>
<p><a
	href="<html:rewrite action="/PMmodule/FacilityManager.do"/>?method=list" >Return
to facilities list</a></p>
</div>