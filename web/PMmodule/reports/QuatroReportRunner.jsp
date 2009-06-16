<%@page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.quatro.model.*" %>
<%@ page import="com.quatro.common.KeyConstants" %>

<%@ include  file="/taglibs.jsp" %>

<bean:define id="lstExportFormat" name="quatroReportRunnerForm" property="exportFormatList"/>
<bean:define id="lstReportOption" name="quatroReportRunnerForm" property="reportOptionList"/>
<bean:define id="lstOrgSelection" name="quatroReportRunnerForm" property="orgSelectionList"/>
<bean:define id="arRelations" name="quatroReportRunnerForm" property="relations"/>
<bean:define id="filterFields" name="quatroReportRunnerForm" property="filterFields"/>
<bean:define id="operatorList" name="quatroReportRunnerForm" property="operatorList"/>

<bean:define id="startField" name="quatroReportRunnerForm" property="startField" type="String" />
<bean:define id="endField" name="quatroReportRunnerForm" property="endField" type="String" />
<bean:define id="startDateProperty" name="quatroReportRunnerForm" property="startDateProperty" type="com.quatro.util.HTMLPropertyBean" />
<bean:define id="endDateProperty" name="quatroReportRunnerForm" property="endDateProperty" type="com.quatro.util.HTMLPropertyBean" />
<bean:define id="startTxtProperty" name="quatroReportRunnerForm" property="startTxtProperty" type="com.quatro.util.HTMLPropertyBean" />
<bean:define id="endTxtProperty" name="quatroReportRunnerForm" property="endTxtProperty" type="com.quatro.util.HTMLPropertyBean" />
<bean:define id="orgSelectionProperty" name="quatroReportRunnerForm" property="orgSelectionProperty" type="com.quatro.util.HTMLPropertyBean" />

<link rel="stylesheet" href="../style/style.css" type="text/css" />
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<script type="text/javascript" src='<c:out value="${ctx}"/>/js/quatroReport.js'></script>
<script type="text/javascript" src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>

<logic:equal name="quatroReportRunnerForm" property="strClientJavascript" value="showReport">
<script language="JavaScript">
showReport('<c:out value="${ctx}"/>/QuatroReport/ReportViewer.do?ini=1');
</script>
</logic:equal>
<logic:equal name="quatroReportRunnerForm" property="strClientJavascript" value="saveTemplate">
<script language="JavaScript">
saveTemplate('<c:out value="${ctx}"/>/QuatroReport/SaveReportTemplate.do');
var criChanged = false;
function saveTemplate(url){
  top.childWin = window.open(url,"_blank","toolbar=yes,menubar= yes,resizable=yes,scrollbars=yes,status=yes,width=650,height=400,top=50, left=50");
  top.childWin.focus();
}
</script>
</logic:equal>
<script language="JavaScript">
var criChanged = false;
function CriteriaChanged(obj){
	if(criChanged) return false;
	criChanged = true;
  	document.forms[0].method.value=obj.name;
  	document.forms[0].onCriteriaChange.value=obj.name;
	getOrgList();
  	document.forms[0].submit();
}

function getOrgList(){
  var elSel= document.forms[0].lstOrg; 
  var txtKey= document.forms[0].txtOrgKey; 
  var txtValue= document.forms[0].txtOrgValue; 
  txtKey.value="";
  txtValue.value="";
  for(var i=0;i<elSel.options.length;i++){
    if(txtKey.value==""){
       txtKey.value = elSel.options[i].value;
    }else{  
       txtKey.value = txtKey.value + ":" + elSel.options[i].value;
    }
    
    if(txtValue.value==""){
       txtValue.value = elSel.options[i].text;
    }else{  
       txtValue.value = txtValue.value + ":" + elSel.options[i].text;
    }
  }
  return true;
}
function submitForm(mthd)
{
	if(!isDateValid) return;
	document.forms[0].method.value=mthd;
	getOrgList();
	document.forms[0].submit();
}
</script>

<html:form action="/QuatroReport/ReportRunner.do">
<input type="hidden" id="method" name="method" />
<!-- input type="hidden" name="templateNo" value="<c:out value="${templateNo}"/>" /> -->
<input type="hidden" id="onCriteriaChange" name="onCriteriaChange" />

<table cellpadding="0" cellspacing="0" border="0" width="100%">

	<!-- Title -->
	<tr>
		<th class="pageTitle" align="center">Report Management</th>
	</tr>

	<tr class="buttonBar2"><td align="left" class="buttonBar2">
		<img src="../images/Back16.png" border="0"/>&nbsp;<html:link action="/QuatroReport/ReportList.do">Back to Reports</html:link>
		<security:oscarSec objectName="<%=KeyConstants.FUN_REPORTS%>" rights="<%=KeyConstants.ACCESS_UPDATE%>">
		&nbsp;|&nbsp;
		<a href="javascript:void1();" onclick="return deferedSubmit('Save');"><img src="../images/Save16.png" border="0"/> Save Template</a>
		</security:oscarSec>
		<img src="../images/Print16x16.gif"/>
		&nbsp;|&nbsp;<a href="javascript:void1();" onclick="return deferedSubmit('Run');">Run Report</a>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>

<div class="tabs" id="tabs">
	<table cellpadding="3" cellspacing="0" border="0">
		<tr>
			<th title="LookupTableList">Report: <c:out value="${quatroReportRunnerForm.reportTitle}" /></th>
		</tr>
	</table>
</div>



<table width="100%" border="1">
   <tr>
       <td class="clsNameLabels"  colspan="2" style="color: #ff0000;"><c:out escapeXml="false" value="${quatroReportRunnerForm.lblError}" /></td>
   </tr>
  <tr>
    <td class="clsTdBackGround" width="50%">
      <html:hidden property="reportNo" />
      <table width="100%">
        <tr>
           <td class="clsNameLabels"  colspan="3" width="100%"><c:out value="${quatroReportRunnerForm.lblDateRange}" /></td>
        </tr>

        <tr>
           <td width="10%">&nbsp;</td>
           <td class="clsNameLabels" width="20%"><c:out value="${quatroReportRunnerForm.lblStartDate}"/></td>
           <td width="70%">
           <logic:equal name="quatroReportRunnerForm" property="startDateProperty.visible" value="visibility:visible;">
             <quatro:datePickerTag property="startField" width="70%" style="<%=startDateProperty.getVisible()%>" openerForm="quatroReportRunnerForm"></quatro:datePickerTag>
           </logic:equal>
           <logic:equal name="quatroReportRunnerForm" property="startTxtProperty.visible" value="visibility:visible;">
             <html:text property="startField" maxlength="50" style="<%=startTxtProperty.getVisible()%>" value="<%=startField%>" />
           </logic:equal>
           </td>
        </tr>
        <tr>
           <td width="10%">&nbsp;</td>
           <td class="clsNameLabels" width="20%"><c:out value="${quatroReportRunnerForm.lblEndDate}"/></td>
           <td width="70%">
           <logic:equal name="quatroReportRunnerForm" property="endDateProperty.visible" value="visibility:visible;">
             <quatro:datePickerTag property="endField" width="70%" style="<%=endDateProperty.getVisible()%>" openerForm="quatroReportRunnerForm"></quatro:datePickerTag>
           </logic:equal>
           <logic:equal name="quatroReportRunnerForm" property="endTxtProperty.visible" value="visibility:visible;">
             <html:text property="endField" maxlength="50" style="<%=endTxtProperty.getVisible()%>" value="<%=endField%>" ></html:text>
           </logic:equal>
        </td>
        </tr>

      </table>
    </td>
    <td class="clsTdBackGround" width="50%">
      <table width="100%">
        <tr>
           <td class="clsNameLabels" width="100%">OUTPUT FORMAT</td>
        </tr>
        <tr>
           <td width="100%"><html:select property="exportFormat">
           <html:options collection="lstExportFormat" property="key" labelProperty="value"></html:options>
           </html:select></td>
        </tr>
      </table>
    </td>
  </tr>  
  <tr>
    <td width="50%">
      <table width="100%" >
        <tr>
           <td class="clsMenuLables" valign="top" width="50%">ORG</td>
        </tr>
        <tr>
           <td><html:select property="lstOrg" multiple="true" size="5" style="width:90%;" styleId="lstOrg">
              <html:options collection="lstOrgSelection" property="key" labelProperty="value"></html:options>
           </html:select>
           <html:hidden property="txtOrgKey" value="" styleId="txtOrgKey"/>
           <html:hidden property="txtOrgValue" styleId="txtOrgValue" value="" /></td>
        </tr>
        <tr>
           <td class="clsButtonBarText">
               <div style="<%=orgSelectionProperty.getVisible()%>">
               &nbsp;&nbsp;<!-- <a id="orgAdd" href="javascript:showOrgLookup('ORG')"> -->
              <a id="orgAdd" href="javascript:void1();" onclick="javascript:return showLookupTree('ORG', '', '', 'quatroReportRunnerForm','lstOrg','', true, '<c:out value="${ctx}"/>')">               
               Add</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;
                    <a href="javascript:removeSel('lstOrg')">Remove</a>
                </div>
           </td>
        </tr>
      </table>
    </td>
    <td width="50%">
      <table width="100%" >
        <tr>
          <td class="clsMenuLables" valign="top">REPORT OPTIONS</td>
        </tr>
        <tr>
          <td>
             <html:select property="reportOption"  multiple="true" size="5" style="width:90%;">
               <html:options collection="lstReportOption" property="optionNo" labelProperty="optionDescription"></html:options>
             </html:select>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
      </table>
        </td>
    </tr> 
    <tr>
        <td colspan="2" width="100%">
           <table width="100%">
             <tr>
               <td class="clsNameLabels" width="100%">ADDITIONAL CRITERIA</td></tr>   	
             <tr>
		       <td class="clsDataGridList" width="100%">
	           </td>
	         </tr>
	     </table>
	     </td>
	</tr>
<tr><td colspan="2" width="100%">
<%String a = "1" ;%>
<TABLE align="center" class="simple" width="100%"><!--  722px-->
<thead>
   	<TR><th class="sortable" width="10%">Select</th>
    	<th class="sortable" width="10%">Relation</TH>
		<TH class="sortable" width="20%">Field Name</TH>
      	<TH class="sortable" width="5%">Operator</TH>
		<TH class="sortable">Value(s)</TH></TR></thead>

	<logic:iterate id="tplCriteria" name="quatroReportRunnerForm" property="templateCriteriaList" indexId="rIndex">
	<TR><TD align="center">
        <logic:equal name="tplCriteria" property="required" value="true">
     	  <input type="checkbox" disabled="disabled" name="p<%=String.valueOf(rIndex)%>" value="<%=String.valueOf(rIndex)%>" /> 
        </logic:equal>
        <logic:notEqual name="tplCriteria" property="required" value="true">
     	  <input type="checkbox" name="p<%=String.valueOf(rIndex)%>" value="<%=String.valueOf(rIndex)%>" /> 
        </logic:notEqual>
     	<input type="hidden" name="lineno" value="<%=String.valueOf(rIndex)%>" /> 
   	</TD>
   	<TD>
		<html:select name="tplCriteria" property="relation" indexed="true" style="width: 100%;">
          <logic:iterate id="relation" name="arRelations" type="String">
            <html:option value="<%=relation%>"><%=relation%></html:option>
          </logic:iterate>
		</html:select>
	</TD>  
	<TD>
        <logic:equal name="tplCriteria" property="required" value="true">
		<html:select name="tplCriteria" disabled="true" property="fieldNo" indexed="true" onchange="CriteriaChanged(this);"  style="width: 100%;">
           <option value="0"></option>
           <html:options collection="filterFields" property="fieldNo" labelProperty="fieldDesc"></html:options>
		</html:select>
        </logic:equal>
        <logic:notEqual name="tplCriteria" property="required" value="true">
		<html:select name="tplCriteria" property="fieldNo" indexed="true" onchange="CriteriaChanged(this);">
           <option value="0"></option>
           <html:options collection="filterFields" property="fieldNo" labelProperty="fieldDesc"></html:options>
		</html:select>
        </logic:notEqual>
	</TD>  
	<TD>
        <logic:equal name="tplCriteria" property="required" value="true">
		<html:select name="tplCriteria" disabled="true" property="op" indexed="true"  style="width: 100%;">
           <option value=""></option>
           <logic:iterate id="ops" name="tplCriteria" property="operatorList" type="com.quatro.util.KeyValueBean">
              <html:option value="<%=(String)ops.getKey()%>"><bean:write name="ops" property="value" /></html:option>
           </logic:iterate>
		</html:select>
        </logic:equal>
        <logic:notEqual name="tplCriteria" property="required" value="true">
		<html:select name="tplCriteria" property="op" indexed="true">
           <option value=""></option>
           <logic:iterate id="ops" name="tplCriteria" property="operatorList" type="com.quatro.util.KeyValueBean">
              <html:option value="<%=(String)ops.getKey()%>"> <bean:write name="ops" property="value" /></html:option>
           </logic:iterate>
		</html:select>
        </logic:notEqual>
	</TD>  
	<TD>
        <logic:notEmpty name="tplCriteria" property="filter">
          <html:hidden name="tplCriteria" property="filter.fieldType" indexed="true" />
          <logic:equal name="tplCriteria" property="filter.fieldType" value="S">
            <logic:empty name="tplCriteria" property="filter.lookupTable">
              <html:text name="tplCriteria" property="val" indexed="true" maxlength="50"/>
            </logic:empty>
            <logic:notEmpty name="tplCriteria" property="filter.lookupTable">
              <html:hidden name="tplCriteria" property="filter.lookupTable" indexed="true" />
              <quatro:lookupTag name="tplCriteria" tableName="<%=((ReportTempCriValue)tplCriteria).getFilter().getLookupTable()   %>" indexed="true" formProperty="quatroReportRunnerForm" 
                 codeProperty ="val" bodyProperty="valDesc"></quatro:lookupTag>
            </logic:notEmpty>
          </logic:equal>  
          <logic:equal name="tplCriteria" property="filter.fieldType" value="D">
            <quatro:datePickerTag name="tplCriteria" property="val" indexed="true" openerForm="quatroReportRunnerForm"></quatro:datePickerTag>
          </logic:equal>  
          <logic:equal name="tplCriteria" property="filter.fieldType" value="N">
            <logic:notEmpty name="tplCriteria" property="filter.lookupTable">
              <html:hidden name="tplCriteria" property="filter.lookupTable" indexed="true" />
              <quatro:lookupTag name="tplCriteria" tableName="<%=((ReportTempCriValue)tplCriteria).getFilter().getLookupTable()   %>" indexed="true" formProperty="quatroReportRunnerForm" 
                 codeProperty ="val" bodyProperty="valDesc"></quatro:lookupTag>
            </logic:notEmpty>
            <logic:empty name="tplCriteria" property="filter.lookupTable">
	             <html:text name="tplCriteria" property="val" indexed="true" maxlength="50"/>
             </logic:empty>
          </logic:equal>  
          <logic:equal name="tplCriteria" property="filter.fieldType" value="I">
            <logic:notEmpty name="tplCriteria" property="filter.lookupTable">
              <html:hidden name="tplCriteria" property="filter.lookupTable" indexed="true" />
              <quatro:lookupTag name="tplCriteria" tableName="<%=((ReportTempCriValue)tplCriteria).getFilter().getLookupTable()   %>" indexed="true" formProperty="quatroReportRunnerForm" 
                 codeProperty ="val" bodyProperty="valDesc"></quatro:lookupTag>
            </logic:notEmpty>
            <logic:empty name="tplCriteria" property="filter.lookupTable">
	             <html:text name="tplCriteria" property="val" indexed="true" maxlength="50"/>
	        </logic:empty>
          </logic:equal>  
        </logic:notEmpty>
	</TD>  
   	</TR>
   	</logic:iterate>
</TABLE>
</td></tr>
<tr><td colspan="2" width="100%">
           <table width="100%">
	         <tr>
                <td class="clsButtonBarText" width="100%">
                    &nbsp;&nbsp;<a href="javascript:submitForm('AddTplCri');">Add</a>&nbsp;&nbsp;&nbsp;|
                        &nbsp;&nbsp;<a href="javascript:submitForm('InsertTplCri');">Insert</a>&nbsp;&nbsp;&nbsp;|
                        &nbsp;&nbsp;<a href="javascript:submitForm('RemoveTplCri');">Remove</a>
	                </td>     
	            </tr>
            </table>
        </td>
    </tr>	
</table>
</html:form>
