<%@ include file="/taglibs.jsp"%>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"
	scope="request" />
<script type="text/javascript"
	src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>

<script lang="javascript">
	
	function submitForm(methodVal) {
		if (!trimInputBox()) return false;
		if(methodVal == "save" && noChanges())
		{
			alert("There are no changes detected to save");
			inRefreshing = false;
		}
		else
		{
			document.forms[0].method.value = methodVal;
			document.forms[0].submit();
		}
	}
	
		
	function txtAreaLenChecker(obj, maxLen) {
	   //counting each end of line as two characters
	   
		var v = obj.value;
	
		var len = v.length;
		
		if(len > maxLen){
			alert("Length of this field can not exceed " + maxLen + " characters.");
			obj.value = v.substr(0, maxLen);
	   }
	
	}
	function validateProgram(){

	  var obj1=document.getElementsByName("admission.communityProgramCode")[0];
	  var obj2=document.getElementsByName("admission.dischargeReason")[0];

	  if(obj1.value=="" || obj2.value=="")
	     return false;
	  
	  else
	     return  true;
	}

	function validateSave(){
	
		var str1=" Please select 'Discharge Disposition' and 'Discharge Reason' before saving." ;
		
		if (!validateProgram()){
			alert(str1); 
			return false;
		}
		return true;
	}
	
</script>

<html-el:form action="/PMmodule/QuatroDischarge.do">
<input type="hidden" name="clientId" value="<c:out value="${clientId}"/>"/>
<input type="hidden" name="admissionId" value="<c:out value="${admissionId}"/>"/>
<html:hidden property="admission.id" />
<html:hidden property="admission.intakeId" />
<html:hidden property="admission.programId" />
<html:hidden property="admission.clientId" />
<input type="hidden" name="method" />
		<table width="100%" cellpadding="0px" cellspacing="0px">
		<tr>
			<th class="pageTitle" align="center">Client Management -Discharge Edit</th>
		</tr>
		<tr>
			<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
		</tr>
		<tr>
			<td align="left" class="buttonBar2">
				<a href='javascript:submitForm("list");'	style="color:Navy;text-decoration:none;">
					<img border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;</a>
		       <c:if test="${!isReadOnly && (quatroClientDischargeForm.admission.admissionStatus!='discharged' &&
		          	quatroClientDischargeForm.admission.admissionStatus!='rejected')}">
					<a onclick='javascript: setNoConfirm();return validateSave();'	href='javascript:submitForm("save");'	style="color:Navy;text-decoration:none;"> 
					<img border=0	src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save&nbsp;&nbsp;</a>|
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
	</table>
	<br>
	<div class="tabs">
	<table cellpadding="3" cellspacing="0" border="0">
		<tr>
			<th>Discharge</th>
		</tr>
	</table>
	</div>
			<!--  start of page content -->

		<table width="100%" class="edit">
			<tr>
				<td width="25%" >Discharge Disposition*</td>
				<td width="75%">
					<html:select	property="admission.communityProgramCode">
					<html:option value=""></html:option>
					<html:options collection="lstCommProgram" property="code"
						labelProperty="description"></html:options>
				</html:select></td>
			</tr>
			<tr>
				<td width="25%">Discharge Reason*</td>
				<td><html:select property="admission.dischargeReason">
					<html:option value=""></html:option>
					<html:options collection="lstDischargeReason" property="code"
						labelProperty="description"></html:options>
				</html:select></td>
			</tr>
			<tr>
				<td width="25%">Transportation Type Provided</td>
				<td><html:select property="admission.transportationType">
					<html:option value=""></html:option>
					<html:options collection="lstTransType" property="code"
						labelProperty="description"></html:options>
				</html:select></td>
			</tr>
			<tr>
				<td width="25%">Discharge Notes</td>
				<td><html:textarea cols="60" rows="7"
					property="admission.dischargeNotes" onkeyup="javascript:txtAreaLenChecker(this, 4000);" /></td>
			</tr>
		</table>
	<%@ include file="/common/readonly.jsp" %>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
