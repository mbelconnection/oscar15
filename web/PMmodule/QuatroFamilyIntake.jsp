<%@ include file="/taglibs.jsp" %>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro" %>
<%@page import="com.quatro.common.KeyConstants;"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<script type="text/javascript" src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
 
<html-el:form action="/PMmodule/QuatroFamilyIntake.do">
<input type="hidden" name="method"/>
<input type="hidden" name="pageChanged" value='<c:out value="${pageChanged}"/>' />
<input type="hidden" name="clientId" value="<c:out value="${clientId}" />"/>
<input type="hidden" name="headclientId" value="<c:out value="${headclientId}" />"/>
<input type="hidden" name="intakeHeadId" value="<c:out value="${intakeHeadId}" />"/>
<input type="hidden" name="programId" value="<c:out value="${programId}" />" />
<input type="hidden" name="isFamilyAdmitted" value="<c:out value="${isFamilyAdmitted}" />"/>
<input type="hidden" name="isRoomFull"       value="<c:out value="${isRoomFull}" />" /> 
<input type="hidden" name="roomCapacity"       value="<c:out value="${roomCapacity}" />" /> 
<html:hidden property="intakeStatus"/>
<html:hidden property="intakeId" />
<input type="hidden" name="scrollPosition" value='<c:out value="${scrPos}"/>' />
<script lang="javascript">
function isName(str) 
{ 
    var reg = new RegExp(/^[\s\'\-a-zA-Z]+$/); 
    var flag = reg.test(str);
    if(flag){
		var len = str.length;
		var startChar = str.substring(0,1);
		var endChar = str.substring(len-1);
		if(startChar == "'" || startChar == "-" || endChar == "'" || endChar == "-" || str.indexOf("''") >= 0 || str.indexOf("--") >= 0|| str.indexOf("  ") >= 0){
			flag = false	
		}	
	}
	return flag;
}
function submitForm(methodVal) 
{
	trimInputBox();
	if(!isDateValid) return;

    var lineNum = document.getElementsByName("dependentsSize")[0].value;
    var lastName;
    var firstName;
	var dob;
	var gender;
	var relation;
	var ans = true;
	var famAdmitted = document.getElementsByName("isFamilyAdmitted")[0];
	if (famAdmitted.value=="true" && methodVal == "add") 
	{
		var roomFull = document.getElementsByName("isRoomFull")[0];
		if (roomFull.value=="true") {
			alert("Room capacity reached");
			return;
		}
		ans = confirm("New members added to the family will be discharged from other shelters if they are currently admitted to those shelters. To proceed, click OK.");	
		if (!ans) return;
	}
    if (methodVal == "save") 
    {	    
	    for(var i=0;i<lineNum;i++){
	      lastName = document.getElementsByName("dependent[" + i + "].lastName")[0];
	      firstName = document.getElementsByName("dependent[" + i + "].firstName")[0];
	      dob = document.getElementsByName("dependent[" + i + "].dob")[0];
	      gender = document.getElementsByName("dependent[" + i + "].sex")[0];
	      relation = document.getElementsByName("dependent[" + i + "].relationship")[0];
	      if(firstName.value.trim()==""){
	        alert("First name is empty.");
	        firstName.value="";
	        firstName.focus();
	        return; 
	      }
	      if(!isName(firstName.value.trim())){
	        alert("First name contains illegal character!");
	        firstName.focus();
	        return; 
	      }
	      if(lastName.value.trim()==""){
	        alert("Last name is empty.");
	        lastName.value="";
	        lastName.focus();
	        return; 
	      }
	      if(!isName(lastName.value.trim())){
	        alert("Last name contains illegal character!");
	        lastName.focus();
	        return; 
	      }
	      if (dob.value==null || dob.value=='')
		  {
			alert('The field Date of Birth is required.');
			return;
		  }
		  
	      if(validateBirthDay(dob.value)==false){
    	    dob.focus();
        	return;
      	  }
		  
	      if (gender.value==null || gender.value=='')
		  {
			alert('The field Gender is required.');
			return;
		  }
	      if (relation.value==null || relation.value=='')
		  {
			alert('The field Relationship is required.');
			return;
		  }
	    }
	}
	if(methodVal=="save" && noChanges())
	{
		alert("There are no changes detected to save");
	}
	else
	{
		document.forms[0].method.value = methodVal;
		document.forms[0].submit();
	}
}

function checkExistClients(i){
   var varStr="quatroClientFamilyIntakeForm," + "dependent[" + i + "].firstName," +
        "dependent[" + i + "].lastName," + "dependent[" + i + "].sex," +
        "dependent[" + i + "].dob," + "dependent[" + i + "].alias," +
        "dependent[" + i + "].clientId," + "dependent[" + i + "].statusMsg," +
        "dependent[" + i + "].newClientChecked";

   var lastName = document.getElementsByName("dependent[" + i + "].lastName")[0];
   var firstName = document.getElementsByName("dependent[" + i + "].firstName")[0];
   var dob = document.getElementsByName("dependent[" + i + "].dob")[0];
   var sex = document.getElementsByName("dependent[" + i + "].sex")[0];
   var alias = document.getElementsByName("dependent[" + i + "].alias")[0];
   var url='<c:out value="${ctx}" />/PMmodule/DuplicateClientCheck.do?' +
     "var=" + varStr + 
     "&firstName=" + firstName.value + "&lastName=" + lastName.value + 
     "&dob=" + dob.value + "&sex=" + sex.value +
     "&alias=" + alias.value + "&shortFlag=Y";
   win = window.open(url,"_blank","toolbar=yes,menubar= yes,resizable=yes,scrollbars=yes,status=yes,width=750,height=600");
   win.focus();
}
</script>
<%String a="debug"; %>
<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
	<tr><th class="pageTitle" align="center">Client Management - Family Intake</th></tr>
	<tr>
	<td style="background: lavender">
		<table width="100%" class="simple" cellspacing="2" cellpadding="3">
			<tr>
			<td style="width: 15%"><font><b>Client No.</b></font></td><td colspan="3"><font><b><c:out value="${client.demographicNo}" /></b></font></td>
			</tr>
			<tr>
				<td style="width: 15%"<font><b>Name</b></font></td>
				<td style="width: 35%"><font><b><c:out value="${client.formattedName}" /></b></font></td>
				<td style="width: 15%"><font><b>DOB</b></font></td>
				<td style="width: 35%"><font><b><c:out value="${client.dob}" /></b></font></td>
			</tr>
		</table>
	</td>
	</tr>
	<tr>
		<td align="left" class="buttonBar2">
        <html:link action="/PMmodule/QuatroIntakeEdit.do?method=update" name="actionParam" style="color:Navy;text-decoration:none;">
        <img border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close</html:link>
        <c:if test="${!isReadOnly}">
		  &nbsp;|&nbsp;<a href="javascript:void1();"  style="color:Navy;text-decoration:none;" onclick="javascript: setNoConfirm();return deferedSubmit('save');">
			<img border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save</a>
         </c:if>
		  &nbsp;|&nbsp;<a href='QuatroFamilyIntake.do?method=history&intakeHeadId=<c:out value="${intakeHeadId}"/>&programId=<c:out value="${programId}" />' style="color:Navy;text-decoration:none;" onclick="javascript: setNoConfirm();return isDateValid;" target="_blank">
			<img border=0 src=<html:rewrite page="/images/history.gif"/> />&nbsp;History&nbsp;&nbsp;</a>
		</td>
	</tr>
	<tr><td align="left" class="message">
      <logic:messagesPresent message="true">
        <html:messages id="message" message="true" bundle="pmm"><c:out escapeXml="false" value="${message}" />
        </html:messages> 
      </logic:messagesPresent>
	</td></tr>
	<tr>
		<td>
		<c:choose>
<c:when test="${bDupliDemographicNoApproved==false}">
<input type=checkbox name="newClientConfirmed" value="Y">Confirm all new clients.
</c:when>
<c:when test="${bDupliDemographicNoApproved==true}">
<input type="hidden" name="newClientConfirmed" value="Y">
</c:when>
<c:otherwise>
<input type="hidden" name="newClientConfirmed" value="N">
</c:otherwise>
</c:choose>
		
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
<tr><th>Head</th></tr>
</table></div></td></tr>
<tr><td>
<table class="simple" cellpadding="3" cellspacing="0" border="0">
<tr><td width="3%"></td>
<td width="6%"></td>
<td width="15%">Last Name</td>
<td width="15%">First Name</td>
<td width="16%">DOB</td>
<td width="14%">Gender</td>
<td width="14%">Alias(es)</td>
<td width="18%"></td></tr>
<tr><td></td>
<td></td>
<td><c:out value="${quatroClientFamilyIntakeForm.familyHead.lastName}" />
<html:hidden property="familyHead.demographicNo"  />
<html:hidden property="familyHead.lastName" /></td>
<td><c:out value="${quatroClientFamilyIntakeForm.familyHead.firstName}" />
<html:hidden property="familyHead.firstName" /></td>
<td><c:out value="${quatroClientFamilyIntakeForm.dob}" />
<html:hidden property="dob" /></td>
<td><c:out value="${quatroClientFamilyIntakeForm.familyHead.sexDesc}" />
<html:hidden property="familyHead.sex" /></td>
<td><c:out value="${quatroClientFamilyIntakeForm.familyHead.alias}" />
<html:hidden property="familyHead.alias" /></td>
<td>
<c:if test="${intakeHeadId > 0 &&  intakeHeadId != intakeId}">
	<a href="<c:out value="${ctx}"/>/PMmodule/QuatroIntakeEdit.do?method=showHeadIntake&intakeId=<c:out value="${intakeHeadId}"/>&clientId=<c:out value="${quatroClientFamilyIntakeForm.familyHead.demographicNo}"/>" style="color:Navy;text-decoration:underline;">View Family Head Intake</a>
</c:if>
</td></tr>
</table>
</td></tr>
</table>

<table width="100%" class="edit">
<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Spouse/Dependant(s)</th></tr>
</table></div></td></tr>

<tr><td>
<table class="simple" cellpadding="3" cellspacing="0" border="0">
<tr><td width="3%"></td>
<td width="12%"></td>
<td width="16%">Last Name*</td>
<td width="16%">First Name*</td>
<td width="12%">DOB*</td>
<td width="12%">Gender*</td>
<td width="15%">Alias(es)</td>
<td width="14%">Relationship*</td></tr>

<logic:iterate id="dependent" name="quatroClientFamilyIntakeForm" property="dependents" indexId="rIndex">
    <tr><td>
     <html:checkbox name="dependent" property="select" indexed="true" />
     <html:hidden name="dependent" property="intakeId" indexed="true" />
     <html:hidden name="dependent" property="admissionId" indexed="true" />
     <html:hidden name="dependent" property="clientId" indexed="true" />
     <html:hidden name="dependent" property="effDate" indexed="true" />
     <html:hidden name="dependent" property="joinFamilyDateTxt" indexed="true" />
     <html:hidden name="dependent" property="newClientChecked" indexed="true" />
     <html:hidden name="dependent" property="duplicateClient" indexed="true" />
     <html:hidden name="dependent" property="serviceRestriction" indexed="true" />
    </td>
    <logic:empty name="dependent" property="admissionId">
    <td>
	  <c:if test="${!isReadOnly}">
      <a href="javascript:checkExistClients(<%=rIndex%>);" onclick='javascript:setNoConfirm();' style="color:Navy;text-decoration:none;">
       <img border="0" src="<html:rewrite page="/images/search16.gif"/>" />
       </a>
       </c:if>
       <logic:greaterThan name="dependent" property="clientId" value="0">
	       <c:out value="${dependent.clientId}" />
       </logic:greaterThan>
       <html:hidden name="dependent" property="statusMsg"  indexed="true" />
    </td>
    <td><html:text name="dependent" property="lastName" maxlength="30" indexed="true"  style="width:90%" /></td>
    <td><html:text name="dependent" property="firstName" maxlength="30" indexed="true"  style="width:90%" /></td>
    <td><quatro:datePickerTag name="dependent" property="dob" indexed="true" openerForm="quatroClientFamilyIntakeForm"></quatro:datePickerTag></td>
    <td><html:select name="dependent" property="sex" indexed="true" style="width:90%" >
       <html:optionsCollection property="genders" value="code" label="description"/>
      </html:select>
    </td>
    <td><html:text name="dependent" property="alias" maxlength="70" indexed="true" style="width:95%" /></td>
    <td><html:select name="dependent" property="relationship" indexed="true"  style="width:90%">
       <html:optionsCollection property="relationships" value="code" label="description"/>
      </html:select>
    </td></tr>
    <logic:equal name="dependent" property="clientId" value="0">
       <logic:equal name="dependent" property="duplicateClient" value="Y">
       <tr><td></td><td colspan="6">
       		<font color="#ff0000"> This new client may be an existing client.</font>
       </td></tr>
       </logic:equal>
    </logic:equal>
    <logic:notEqual name="dependent" property="clientId" value="0">
       <logic:equal name="dependent" property="duplicateClient" value="Y">
       <tr><td></td><td colspan="6">
       		<font color="#ff0000"> This client is already a member of this family.</font>
       </td></tr>
       </logic:equal>
    </logic:notEqual>
    <logic:notEqual name="dependent" property="clientId" value="0">
       <logic:equal name="dependent" property="serviceRestriction" value="Y">
       <tr><td></td><td colspan="6">
       <font color="#ff0000">Service Restriction applied.<br></font>
       </td></tr>
       </logic:equal>
       <logic:equal name="dependent" property="statusMsg" value="x">
       <tr><td></td><td colspan="6">
       <font color="#ff0000"> This client is the head of the family.<br></font>
       </td></tr>
       </logic:equal>
       <logic:equal name="dependent" property="statusMsg" value="+">
       <tr><td></td><td colspan="6">
       <font color="#ff0000"> This client is active in another family.<br></font>
       </td></tr>
       </logic:equal>
       <logic:equal name="dependent" property="statusMsg" value="-">
       <tr><td></td><td colspan="6">
       <font color="#ff0000"> This client is a member of another family in this program.<br></font>
       </td></tr>
       </logic:equal>
    </logic:notEqual>
</logic:empty>
<logic:notEmpty name="dependent" property="admissionId">
	<html:hidden name="dependent" property="statusMsg"  indexed="true" />
	<html:hidden name="dependent" property="lastName"  indexed="true" />
	<html:hidden name="dependent" property="firstName"  indexed="true" />
	<html:hidden name="dependent" property="dob"  indexed="true" />
	<html:hidden name="dependent" property="sex"  indexed="true" />
	<html:hidden name="dependent" property="alias"  indexed="true" />
	<html:hidden name="dependent" property="relationship"  indexed="true" />
    <td>
       <logic:greaterThan name="dependent" property="clientId" value="0">
	       <c:out value="${dependent.clientId}" />
		</logic:greaterThan>
       <html:text name="dependent" property="statusMsg" maxlength="20" readonly="true" style="border: 0px;width: 20px"/>
    </td>
    <td><html:text name="dependent" property="lastName" maxlength="30" style="width:90%" readonly="true"/></td>
    <td><html:text name="dependent" property="firstName" maxlength="30" style="width:90%" readonly="true"/></td>
    <td><html:text name="dependent" property="dob" style="width:90%"  readonly="true"></html:text></td>
    <td><html:select name="dependent" property="sex" style="width:90%"  disabled="true">
       <html:optionsCollection property="genders" value="code" label="description"/>
      </html:select>
    </td>
    <td><html:text name="dependent" property="alias" maxlength="70" style="width:95%"  readonly="true"/></td>
    <td><html:select name="dependent" property="relationship" indexed="true" style="width:90%"  disabled="true">
       <html:optionsCollection property="relationships" value="code" label="description"/>
      </html:select>
    </td></tr>
    <logic:notEqual name="dependent" property="clientId" value="0">
       <logic:equal name="dependent" property="serviceRestriction" value="Y">
       <tr><td></td><td colspan="6"> &nbsp;
       <font color="#ff0000">Service Restriction applied.<br></font>
       <tr><td></td><td colspan="6"> &nbsp;
       </logic:equal>
    </logic:notEqual>
    </td>
</logic:notEmpty>
    </tr>
</logic:iterate>

<tr><td colspan="8" class="buttonBar4">
<html:hidden property="dependentsSize"/>
<c:if test="${!isReadOnly}">
<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTINTAKE%>" rights="<%=KeyConstants.ACCESS_WRITE %>">								
<c:if test= "${quatroClientFamilyIntakeForm.intakeStatus=='active' or quatroClientFamilyIntakeForm.intakeStatus=='admitted'}" >
&nbsp;<a href='javascript:submitForm("add");' onclick='javascript:setNoConfirm();' style="color:Navy;text-decoration:underline;">Add Dependant</a>
&nbsp;|
</c:if>
&nbsp;
	<a href='javascript:submitForm("delete");' onclick='javascript:setNoConfirm();' style="color:Navy;text-decoration:underline;">Remove Dependant</a>
</security:oscarSec>
</c:if>
</td>
</tr>

<tr><td colspan="8" class="buttonBar4">#&nbsp; existing client</td></tr>
</table>
</td></tr>

</table>

<!--  end of page content -->
</div>
</td>
</tr>
</table>
<%@ include file="/common/readonly.jsp" %>
</html-el:form>
