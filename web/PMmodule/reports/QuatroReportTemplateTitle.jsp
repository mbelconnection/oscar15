<%@page language="java" contentType="text/html; charset=ISO-8859-1"	pageEncoding="ISO-8859-1"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<html>
<head>
<title>QuatroReportTemplateTitle</title>
<script language="javascript">
function showTitle() {
   quatroReportSaveTemplateForm.txtTitle.disabled = false;
   quatroReportSaveTemplateForm.txtDescription.disabled = true;
   return true;
}

function showNew() {
   quatroReportSaveTemplateForm.txtTitle.disabled = true;
   quatroReportSaveTemplateForm.txtDescription.disabled = false;
   return true;
}

function setupOpt(){
  var selectedRadio=document.getElementById('<c:out value="${quatroReportSaveTemplateForm.optSaveAsSelected}" />');
  if(selectedRadio!=null) {
  	selectedRadio.checked=true;
  	if (selectedRadio.id == "optNew") {
	  	var optOldB =document.getElementById('optOld');
	  	optOldB.disabled = true;
	    quatroReportSaveTemplateForm.txtTitle.disabled = true;
  	}
  	else
  	{
	   quatroReportSaveTemplateForm.txtDescription.disabled = true;
  	}
  }
}
</script>
</head>
<body onload="setupOpt()">
	<html:form action="/QuatroReport/SaveReportTemplate.do">
	<input type="hidden" name="postback" value="Y" />
	<table width="100%">
		<tr><td align="center" colspan="2"><b>Saving Report Template</b></td></tr>
		<tr><td colspan="2" style="color:#ff0000;"><c:out value="${quatroReportSaveTemplateForm.msg}" /></td></tr>
		<tr><td width="25%" align="right" nowrap="nowrap">As New: 
		  <input value="optNew" name="optSaveAs" id="optNew" type="radio" onclick="javascript:showNew();" /> 
		</td>
		<td><html:text property="txtDescription" size="70%" maxlength="200" /></td></tr>
		<tr><td align="right" nowrap="nowrap">To replace the template:
		  <input value="optOld" name="optSaveAs" id="optOld" type="radio" onclick="javascript:showTitle();" />
		</td>
		<td><html:text property="txtTitle" size="70%" maxlength="80" /></td></tr>
		<tr><td align="right">Private:</td>
		<td><html:checkbox property="chkPrivate"/></td></tr>
		<tr><td>&nbsp;</td>
		<td><input type="submit" name="Save" value="Save" />
		<input type="submit" name="btnClose" value="Close"  onclick="window.close();" /></td></tr>
	</table>
	</html:form>
</body>
</html>
