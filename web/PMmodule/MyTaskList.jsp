<%@ include file="/taglibs.jsp"%>
<script lang="javascript">
function validate()
{
		var form = document.ticklerForm;
		var startDt = form.elements['filter.startDate'];
		var endDt = form.elements['filter.endDate'];
		if(startDt.value != "" && endDt.value != "") {
			if(isBefore(endDt.value,startDt.value))
			{
				alert("start date must be before or equal to end date");
				startDt.focus();
				return false;
			}
		}
		return true;
}

	function submitForm(methodVal) {
		if (!trimInputBox()) return false;
		if(!isDateValid) {
			inRefreshing = false;
			return;
		}		
		if (!validate()) return;
		document.forms[0].method.value = methodVal;
		document.forms[0].submit();
	}
	function searchClicked()
	{
		if(deferSubmit) {
			setTimeout("submitForm('filter')", 200);
		}
		else
		{
			submitForm("filter");
		}
		return false;
	}
	function init()
	{
		var form = document.ticklerForm;
		form.elements['filter.startDate'].focus();
		form.onkeypress=function() {keypress(event);}
	}
	function keypress(event)
	{
		var keynum;
		if(window.event) // IE
  		{
  			keynum = event.keyCode;
  		}
		else if(event.which) // Netscape/Firefox/Opera
  		{
  			keynum = event.which;
  		}
		if (keynum==13) {
			searchClicked();
		}
	}
</script>
<html:form action="/PMmodule/Task.do">
<table border="0" cellspacing="0" cellpadding="1" width="100%">
<tr><th class="pageTitle">My Tasks - List</th></tr>
<input type="hidden" name="method" />

<tr><td class="buttonBar2">
	<html:link action="/Home.do" style="color:Navy;text-decoration:none;">
	<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Back16.png"/> />&nbsp;Back to Home&nbsp;&nbsp;|</html:link>
	<a href="javascript:void1();" onclick="return searchClicked();" style="color:Navy;text-decoration:none;">
	<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/search16.gif"/> />&nbsp;Search&nbsp;&nbsp;</a>

</td></tr>
<tr><td align="left" class="message">
   <logic:messagesPresent message="true">
     <html:messages id="message" message="true" bundle="pmm"><c:out escapeXml="false" value="${message}" /></html:messages> 
   </logic:messagesPresent>
</td></tr>

<tr><td><table class="simple" cellspacing="2" cellpadding="3">
<tr><td width="30%">Service Date Range:</td>
<td width="5%">Start:</td>
<td width="20%"><quatro:datePickerTag property="filter.startDate" openerForm="ticklerForm" width="90%" /></td>
<td width="5%">End:</td>
<td width="40%"><quatro:datePickerTag property="filter.endDate" openerForm="ticklerForm" width="45%" /></td></tr>
<tr><td colspan="2">Status: <html:select property="filter.status">
	<html:option value="Any">Any</html:option>
	<html:option value="Active">Active</html:option>
	<html:option value="Completed">Completed</html:option>
</html:select></td>
<td colspan="3">Program: <html:select property="filter.programId">
	<html:option value="">Any</html:option>
    <html:optionsCollection property="programLst" value="id" label="name"/>
</html:select></td></tr>
</table>
</td></tr>


<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Tasks</th></tr>
</table></div></td></tr>

<tr><td>
<display:table class="simple" cellspacing="2" cellpadding="3" id="tickler" name="ticklers" 
                       pagesize="0"	requestURI="/PMmodule/Task.do">
<display:setProperty name="paging.banner.placement" value="bottom" />
<display:setProperty name="basic.msg.empty_list" value="No task found." />
<display:column sortable="false" title="" sortProperty="priority" >
<c:choose>
  <c:when test="${tickler.priority == 'High'}">
    <img border=0 src=<html:rewrite page="/images/importance_high.jpg"/> />
  </c:when>
  <c:when test="${tickler.priority == 'Normal'}">
    &nbsp;
  </c:when>
  <c:otherwise>
    <img border=0 src=<html:rewrite page="/images/importance_low.jpg"/> />
  </c:otherwise>
</c:choose>
</display:column>
<display:column sortable="true" sortProperty="tickler_no" title="Task ID">
 <a href='<html:rewrite page="/PMmodule/Task.do"/>?method=mytaskedit&clientId=<c:out value="${tickler.demographic_no}" />&ticklerNo=<c:out value="${tickler.tickler_no}" />'>
   <c:out value="${tickler.tickler_no}" /></a>
</display:column>
<display:column property="status" sortable="true" title="Status" />
<display:column property="provider.formattedName" sortable="true" sortProperty="provider.formattedName" title="Creator" />
<display:column property="service_date.time" sortable="true" title="Service Date" format="{0, date, yyyy/MM/dd hh:mm:ss a}"  />
<display:column property="demographic.formattedName" sortable="true" sortProperty="demographic.lastName" title="Client" />
<display:column property="program.name" sortable="true"	title="Program" />
</display:table> 
</td></tr>
</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>

