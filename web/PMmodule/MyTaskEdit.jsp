<%@ include file="/taglibs.jsp"%>
	
<script type="text/javascript">
function submitForm(methodVal) {
	if (!trimInputBox()) return false;
	if(methodVal == "mytasksave" && noChanges())
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
</script>

<table border="0" cellspacing="0" cellpadding="1" width="100%">
<tr><th  class="pageTitle">My Tasks -Update Task</th></tr>

<tr><td class="buttonBar2">
	<html:link action="/PMmodule/Task.do?method=filter" style="color:Navy;text-decoration:none;">
	<img style="vertical-align: middle" border=0 src='<html:rewrite page="/images/close16.png"/>' >&nbsp;Close&nbsp;&nbsp;|</html:link>
	<c:if test="${!isReadOnly }" >
		<a href='javascript:submitForm("mytasksave");' onclick="javascript:setNoConfirm();"	style="color:Navy;text-decoration:none;">
		<img style="vertical-align: middle" border=0 src='<html:rewrite page="/images/Save16.png"/>' >&nbsp;Save&nbsp;&nbsp;</a>
	</c:if>
</td></tr>
<tr><td align="left" class="message">
   <logic:messagesPresent message="true">
     <html:messages id="message" message="true" bundle="pmm"><c:out escapeXml="false" value="${message}" /></html:messages> 
   </logic:messagesPresent>
</td></tr>
	
</table>
<html:form action="/PMmodule/Task.do" onsubmit="return validateTicklerForm(this);">
        <input type="hidden" name="method"/>
        <input type="hidden" name="clientId" value ="<c:out value="${clientId}" />"/> 
        <input type="hidden" name="ticklerNo" value ="<c:out value="${ticklerNo}" />"/> 
		<html:hidden property="tickler.creator" />
		<html:hidden property="tickler.demographic_no" />
		<html:hidden property="tickler.tickler_no" />
		<input type="hidden" name="pageChanged" id="pageChanged" value='<c:out value="${pageChanged}" />' />

	<table width="100%" class="simple">
		
		<tr><td width="10%">Client:</td>
		<td width="50%"><c:out value="${client.formattedName}"/></td>
		<td width="15%">Service Date</td>
		<td width="25%"><c:out value="${ticklerForm.tickler.serviceDate}"/>&nbsp;<c:out value="${ticklerForm.tickler.service_hour}"/>:<c:out value="${ticklerForm.tickler.service_minute}"/>&nbsp;
		  <c:out value="${ticklerForm.tickler.service_ampm}"/></td></tr>
		<tr><td>Creator:</td>
		<td><c:out value="${ticklerForm.tickler.provider.formattedName}" /></td>
		<td>Priority:</td>
		<td>
          <c:choose>
           <c:when test="${ticklerForm.tickler.priority == 'High'}">
             <img border=0 src=<html:rewrite page="/images/importance_high.jpg"/> />
           </c:when>
          <c:when test="${ticklerForm.tickler.priority == 'Normal'}">
            &nbsp;
          </c:when>
          <c:otherwise>
            <img border=0 src=<html:rewrite page="/images/importance_low.jpg"/> />
          </c:otherwise>
         </c:choose>
		</td></tr>
		<tr><td colspan="4">
		<table class="simple">
		<tr><td width="20%">Task Assigned To:</td>
		<td width="10%">Program:</td>
		<td width="31%"><c:out value="${ticklerForm.tickler.program.name}" /></td>
		<td width="10%">User:</td>
		<td wdith="29%"><c:out value="${ticklerForm.tickler.assignee.formattedName}" /></td></tr>
		</table></td></tr>
		<tr><td>Status:</td>
		<td colspan="3"><html:select property="tickler.status">
            <html:option value="Active">Active</html:option>
            <html:option value="Completed">Completed</html:option>
			</html:select>
		</td></tr>
		<tr><td>Message:</td>
		<td colspan="3"><html:textarea readonly="true" style="width: 90%;" rows="10" property="tickler.message"  /></td></tr>

		<tr><td>Comments:</td>
		<td colspan="3"><textarea readonly="true" style="width: 90%;" rows="10"><c:out value="${comments}"/></textarea></td></tr>

		<tr><td>New Comment:</td>
		<td colspan="3"><textarea name="newcomment" style="width: 90%;" rows="8"></textarea></td></tr>
</table>
<%@ include file="/common/readonly.jsp" %>
	<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
	</body>
</html>
