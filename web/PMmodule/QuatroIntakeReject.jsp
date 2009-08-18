<%@ include file="/taglibs.jsp" %>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro" %>
<%@page import="java.util.Date"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<script type="text/javascript" src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
 
<html-el:form action="/PMmodule/QuatroIntakeReject.do">
<input type="hidden" name="method"/>
<input type="hidden" name="clientId" value="<c:out value="${clientId}"/>"/>
<html:hidden property="queueId" />
<input type="hidden" name="programId" value="<c:out value="${programId}"/>"/>
<script lang="javascript">
function submitForm(methodVal) {
	if (!trimInputBox()) return false;
	var note =  document.getElementsByName("rejectNote")[0];
	var reason = document.getElementsByName("rejectReason")[0];
	if(reason.value == "") {
		alert("Rejection Reason is empty!");
		inRefreshing = false;
	}
	else if(note.value == "") {
		alert("Rejection Note is empty!");
		inRefreshing = false;
	}
	else if(methodVal=="save" && noChanges())
	{
		alert("There are no changes detected to save");
		inRefreshing = false;
	}
	else
	{
		document.forms[0].method.value = methodVal;
		document.forms[0].submit();
	}
	return false;
}
</script>
<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
	<tr>
		<th class="pageTitle" align="center">Client Management - Admission Rejection</th>
	</tr>
	<tr>
	<td>
		<table width="100%" class="simple">
			<tr>
			<td style="width: 15%"><font><b>Client No.</b></font></td><td colspan="3"><font><b><c:out value="${client.demographicNo}" /></b></font></td>
			</tr>
			<tr>
				<td style="width: 15%"<font><b>Name</b></font></td>
				<td style="width: 35%"><font><b><c:out value="${client.formattedName}" /></b></font></td>
				<td style="width: 15%"><font><b>Date of Birth </b></font></td>
				<td style="width: 35%"><font><b><c:out value="${client.dob}" /></b></font></td>
			</tr>
		</table>
	</td>
	</tr>
	<tr>
		<td align="left" class="buttonBar2">
		<a href="<%=request.getContextPath()%>/PMmodule/ProgramManagerView.do?tab=Queue&programId=<c:out value="${programId}"/>"  style="color:Navy;text-decoration:none;">&nbsp;
			<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/close16.png"/>" />&nbsp;Close&nbsp;&nbsp;|
		</a>
		<a href='javascript:void1();' onclick='javascript: setNoConfirm();return submitForm("save");' style="color:Navy;text-decoration:none;">
		<img border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save&nbsp;&nbsp;</a></td>
	</tr>
	<tr><td align="left" class="message">
      <logic:messagesPresent message="true">
        <html:messages id="message" message="true" bundle="pmm"><c:out escapeXml="false" value="${message}" />
        </html:messages> 
      </logic:messagesPresent>
	</td></tr>
	<tr>
		<td height="100%">
		<div
			style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">

<!--  start of page content -->
<table width="100%" class="edit">
<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Admission Rejection</th></tr>
</table></div></td></tr>

<tr><td>
<table class="simple" cellspacing="2" cellpadding="3">
<tr><td width="25%">Rejection Reason*</td>
<td width="75%"><html:select property="rejectReason">
<html-el:option value=""></html-el:option>
<html-el:optionsCollection property="rejectReasonList" value="code" label="description"/>
</html:select></td></tr>
<tr><td>Rejection Note*</td>
<td><html:textarea property="rejectNote" rows="6" style="width: 90%;" /></td></tr>
</table>
</td></tr>

</table>

<!--  end of page content -->
</div>
</td>
</tr>
</table>
<%@ include file="/common/readonly.jsp" %>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
