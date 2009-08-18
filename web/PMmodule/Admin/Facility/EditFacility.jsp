<%@ include file="/taglibs.jsp"%>
<%@page import="com.quatro.common.KeyConstants;"%>
<script type="text/javascript">
	function validateRequiredField(fieldId, fieldName, maxLength)
	{
		var field=document.getElementById(fieldId);
		if(field==null){
			field = document.getElementsByName(fieldId)[0];
		}
		field.value = trim(field.value);

		if (field.value==null || field.value=='')
		{
			alert('The field '+fieldName+' is required.');
			return(false);
		}
		
		if (field.value.length > maxLength)
		{
			alert('The value you entered for '+fieldName+' is too long, maximum length allowed is '+maxLength+' characters.');
			return(false);
		}
		
		return(true);
	}


	function submitForm(){
		var obj2 = document.getElementsByName('facility.active')[0];
		if(!obj2.checked){
          if(!confirm("Deactivating this facility will also deactivate programs in the facility. Select Ok to proceed or Cancel to cancel."))
            return false;
		}

		if (!trimInputBox()) return false;
		var isOk = false;
		isOk = validateRequiredField('facilityName', 'Facility Name', 32);
		if (isOk) isOk = validateRequiredField('facilityDesc', 'Facility Description', 70);
		if (isOk) isOk = validateRequiredField('facility.sectorId', 'Sector', 3);
		var obj1 = document.getElementsByName('facilityManagerForm_facility.orgId')[0];
		if(obj1 == null) obj1 = document.getElementsByName('facility.orgId')[0];
		if(obj1.value == null || obj1.value == '') {
		    isOk=false;
			alert('Shelter can not be blank.');
			obj1.focus();
        }
        
		if(isOk){
			if(noChanges())
			{
				alert("There are no changes detected to save");
				inRefreshing = false;
			}
			else
			{
				document.forms[0].submit();
			}
		}
		else
		{
			inRefreshing = false;
		}
		return false;
	}
	// trim leading and ending spaces
	function trim (str) {
		var	str = str.replace(/^\s\s*/, ''),
			ws = /\s/,
			i = str.length;
		while (ws.test(str.charAt(--i)));
		return str.slice(0, i + 1);
	}
</script>
<!-- don't close in 1 statement, will break IE7 -->

<html:form action="/PMmodule/FacilityManager.do">
	<input type="hidden" name="method" value="save" />

	<html-el:hidden property="facility.id" /> 
	<table cellpadding="0" cellspacing="0" border="0" width="100%"
		height="100%">

		<!-- Title -->
		<tr>
			<th class="pageTitle" align="center">Facility Management - Edit</th>
		</tr>

		<!-- body start -->
		<tr>
			<td height="100%">

			<table width="100%" cellpadding="0px" cellspacing="0px" height="100%"
				border="0">
				<!-- submenu -->
				<tr>
					<td align="left" class="buttonBar2">
						<html:link	action="/PMmodule/FacilityManager.do?method=list"	style="color:Navy;text-decoration:none;">
						<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/close16.png"/>" />&nbsp;Close&nbsp;&nbsp;|</html:link>
						<security:oscarSec objectName="<%=KeyConstants.FUN_FACILITY_EDIT %>" rights="<%=KeyConstants.ACCESS_UPDATE %>">						
							<html:link	href="javascript:void1();"	onclick="javascript: setNoConfirm();return submitForm();"	style="color:Navy;text-decoration:none;">
							<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/Save16.png"/>" />&nbsp;Save&nbsp;&nbsp;</html:link>
						</security:oscarSec>	
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





					<table width="100%" height="100%" cellpadding="0px"
						cellspacing="0px">

						<tr>
							<td>
							<table width="100%" border="1" cellspacing="2" cellpadding="3">
								<tr class="b">
									<td width="20%">Facility ID:</td>
									<td><c:out value="${facility.id}" /></td>

								</tr>
								<tr class="b">
									<td width="20%">Name: *</td>
									<td><html:text property="facility.name" size="32"
										maxlength="32" styleId="facilityName" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Description: *</td>
									<td><html:text property="facility.description" size="70"
										maxlength="70" styleId="facilityDesc" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Health Information Custodian:</td>
									<td><html:checkbox property="facility.hic" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Primary Contact Name:</td>
									<td><html:text property="facility.contactName" maxlength="80" /></td>
								</tr>
								<tr class="b">
									<td width="20%">Primary Contact Email:</td>
									<td><html:text property="facility.contactEmail"  maxlength="80"/></td>
								</tr>
								<tr class="b">
									<td width="20%">Primary Contact Phone:</td>
									<td><html:text property="facility.contactPhone" maxlength="30" /></td>
								</tr>
								<%
									Integer orgId = (Integer) request.getAttribute("orgId");
									Integer sectorId = (Integer) request.getAttribute("sectorID");
								%>
								<tr class="b">
									<td width="20%">Shelter: *</td>
									<td>
										<security:oscarSec objectName="<%=KeyConstants.FUN_FACILITY_EDIT %>"  rights="<%=KeyConstants.ACCESS_WRITE%>" orgCd="<%=KeyConstants.ORG_ROOT%>">
											<quatro:lookupTag name="facilityManagerForm" tableName="SHL" formProperty="facilityManagerForm" bodyProperty="facility.orgDesc" codeProperty="facility.orgId" showCode="false"></quatro:lookupTag>
										</security:oscarSec>
										<security:oscarSec objectName="<%=KeyConstants.FUN_FACILITY_EDIT %>"  rights="<%=KeyConstants.ACCESS_WRITE%>"  orgCd="<%=KeyConstants.ORG_ROOT%>" reverse="true">
											<html:hidden property="facility.orgId"/>
											<bean:write name="facilityManagerForm" property="facility.orgDesc" /> 
										</security:oscarSec>
									</td>
								</tr>
								<tr class="b">
									<td width="20%">Sector: *</td>
									<td><select name="facility.sectorId" >
										<option value="">&nbsp;</option>
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
									<td width="20%">Active:</td>
									<td>
									<security:oscarSec objectName="<%=KeyConstants.FUN_FACILITY_EDIT %>"  rights="<%=KeyConstants.ACCESS_WRITE%>" orgCd="<%=KeyConstants.ORG_ROOT%>">
									<html:checkbox property="facility.active" />
									</security:oscarSec>
									<security:oscarSec objectName="<%=KeyConstants.FUN_FACILITY_EDIT %>"  rights="<%=KeyConstants.ACCESS_WRITE%>" orgCd="<%=KeyConstants.ORG_ROOT%>" reverse="true">
										<html:checkbox property="facility.active" disabled="true" />
										<input type="hidden" id="lastActive" name="lastActive" value='<c:out value="${lastActive}" />' />
									</security:oscarSec>
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
	<%@ include file="/common/readonly.jsp" %>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
