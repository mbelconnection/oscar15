<%@page import="java.util.Calendar"%>
<%@ include file="/taglibs.jsp"%>
<%String a="debug"; %>	
<script type="text/javascript">
var prgChanged = false;
function submitForm(methodVal) {
	trimInputBox();
	if(!isDateValid) return;
	if (methodName = 'changeProgram') {
		if ( prgChanged) return false;
		prgChanged = true;
	}	
    else if(methodVal=='save'){
	   if(noChanges())
	   {
		  alert("There are no changes detected to save");
		  return false;
	   }

	   var serviceDate = document.ticklerForm.elements['tickler.serviceDate'];
	   var serviceHour = parseInt(document.ticklerForm.elements['tickler.service_hour'].value);
	   var serviceMinute = parseInt(document.ticklerForm.elements['tickler.service_minute'].value);
	   var serviceAmpm = document.ticklerForm.elements['tickler.service_ampm'].value;
	   
	   if ("PM" == serviceAmpm) serviceHour = parseInt(serviceHour) + 12;
	   if(serviceDate.value == '') {
		  alert('Please provide a service date.');
		  return;
	   }else if(isBeforeNowxMin(serviceDate.value, serviceHour, serviceMinute,5)){
		  alert('Service date/time should not be before now for more than 5 minutes.');
		  return;
	   }

	   var task_assigned_to = document.ticklerForm.elements['tickler.program_id'];
	   if(task_assigned_to.value == '') {
		  alert('Please select a program.');
		  return false;
	   }

	   var task_assigned_to = document.ticklerForm.elements['tickler.task_assigned_to'];
	   if(task_assigned_to.value == '') {
		  alert('Please assign the task to a valid provider.');
		  return false;
	   }

	   var message = document.ticklerForm.elements['tickler.message'];
	   if(message.value == '') {
		  alert('You must provide a message');
		  return false;
	   }
	}
    document.forms[0].method.value = methodVal;
    document.forms[0].submit();
}
</script>

<html:form action="/PMmodule/Task.do" onsubmit="return validateTicklerForm(this);">
       <input type="hidden" name="method"/>
	<html:hidden property="tickler.creator" />
	<html:hidden property="tickler.demographic_no" />
	<html:hidden property="tickler.tickler_no" />
	<input type="hidden" name="pageChanged" id="pageChanged" value='<c:out value="${pageChanged}" />' />
<table border="0" cellspacing="0" cellpadding="1" width="100%">
<c:choose>
<c:when test="${viewTickler=='Y'}">
<tr><th  class="pageTitle">Client Management - View Task</th></tr>
</c:when>
<c:otherwise>
<tr><th  class="pageTitle">Client Management - New Task</th></tr>
</c:otherwise>
</c:choose>

<tr><td class="buttonBar2">
	<html:link action="/PMmodule/Task.do" style="color:Navy;text-decoration:none;">
	<img border=0 src='<html:rewrite page="/images/close16.png"/>' >&nbsp;Close&nbsp;&nbsp;</html:link>
   <c:if test="${viewTickler!='Y'}">
     <a href="javascript:void1();"  onclick="javascript: setNoConfirm();return deferedSubmit('save');"	style="color:Navy;text-decoration:none;">
		<img border=0 src='<html:rewrite page="/images/Save16.png"/>' >&nbsp;Save&nbsp;&nbsp;</a>|
   </c:if>		
</td></tr>
<tr><td align="left" class="message">
   <logic:messagesPresent message="true">
     <html:messages id="message" message="true" bundle="pmm"><c:out escapeXml="false" value="${message}" /></html:messages> 
   </logic:messagesPresent>
</td></tr>
	
</table>

<table width="100%" class="simple">
		<tr><td>Client:</td>
		<td colspan="2"><input type=hidden name="clientId" value="<c:out value="${client.demographicNo}"/>">
		<c:out value="${client.formattedName}"/></td></tr>
		<tr><td>Service Date:</td>
		<td colspan="2"><quatro:datePickerTag property="tickler.serviceDate" openerForm="ticklerForm" width="30%"/></td></tr>
		<tr><td>Service Time:</td>
		<td colspan="2"><html:select property="tickler.service_hour">
           <html:optionsCollection property="serviceHourLst" value="value" label="label"/>
		</html:select> : 
		<html:select property="tickler.service_minute">
           <html:optionsCollection property="serviceMinuteLst" value="value" label="label"/>
		</html:select> &nbsp; 
		<html:select property="tickler.service_ampm">
           <html:optionsCollection property="ampmLst" value="value" label="label"/>
		</html:select>
		</td></tr>
		<tr><td>Priority:</td>
		<td colspan="2"><html:select property="tickler.priority">
           <html:optionsCollection property="priorityLst" value="value" label="label"/>
		</html:select></td></tr>
		<tr><td width="20%">Task Assigned To:</td>
		<td width="10%">Program:</td>
		<td width="70%"> 
          <c:choose>
            <c:when test="${viewTickler!='Y'}">
		      <html:select property="tickler.program_id" onchange="setNoConfirm();submitForm('changeProgram');">
		        <option value=""> --- </option>
                <html:optionsCollection property="programLst" value="id" label="name"/>
		      </html:select>
		    </c:when>
		    <c:otherwise>
		      <html:select property="tickler.program_id">
		        <option value=""> --- </option>
                <html:optionsCollection property="programLst" value="id" label="name"/>
		      </html:select>
		    </c:otherwise>
		  </c:choose>
		</td></tr>
        <tr><td></td>		      
		<td>User:</td>
		<td><html:select property="tickler.task_assigned_to">
		   <option value=""> --- </option>
           <html:optionsCollection property="providerLst" value="providerNo" label="formattedName"/>
		</html:select>
		</td></tr>
		<tr><td>Status:</td>
		<td colspan="2"><html:select property="tickler.status">
			<html:option value="Active">Active</html:option>
			<html:option value="Completed">Completed</html:option>
			</html:select>
		</td></tr>
		<tr><td>Message:</td>
		<td colspan="2"><html:textarea style="width: 90%" rows="16" property="tickler.message" /></td></tr>
</table>
<%@ include file="/common/readonly.jsp" %>
	</html:form>
	</body>
</html>
