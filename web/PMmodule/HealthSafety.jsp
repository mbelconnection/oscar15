<%@ include file="/taglibs.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="org.oscarehr.PMmodule.model.Demographic"%>
<html>
<head>
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
	<title>Health and Safety</title>
<script type="text/javascript" src="<html:rewrite page="/js/validation.js" />"></script>

<script>
function submitForm(form) {
 if (!trimInputBox()) return false;
 var message = form.elements['healthsafety.message'].value;
 if(message!=null && message.length==0){
   alert("message can not be empty.");
   inRefreshing = false;
   return false;
 }  
 if(message!=null && message.length>500){
   alert("message can not exceed 500 characters.");
	inRefreshing = false;
   return false;
 }  
			
  form.submit();
  opener.document.clientManagerForm.submit();
}
</script>	
</head>

<body topmargin="20" leftmargin="10">

<html:form action="/PMmodule/HealthSafety.do">
<input type="hidden" name="method" value="savehealthSafety" />
<input type="hidden" name="id"	value="<c:out value="${requestScope.id}"/>">
<html:hidden property="healthsafety.id" />
<html:hidden property="healthsafety.userName" />
<html:hidden property="healthsafety.demographicNo" />
<table border="2" width="700" cellspacing="0" cellpadding="0">
<tr><td colspan="3">Message:<br>
			<html:textarea property="healthsafety.message" rows="5" style="width:100%;"></html:textarea></td></tr>
<tr><td width="40%">User Name: <c:out value="${healthsafety.userName}"/> </td>
<td width="40%">Date: <fmt:formatDate value="${healthsafety.updateDate}" pattern="yyyy-MM-dd" /></td>
<td width="20%">
	<input type="button" value="Save" onclick="submitForm(document.healthSafetyForm)" />
	<input type="button" value="Cancel"	onclick="window.close()" />
</td></tr>
</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
</body>
</html>
