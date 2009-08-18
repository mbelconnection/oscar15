<%@ include file="../taglibs.jsp"%>
<html>
<head>
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
<title>Case Management</title>
<c:set var="ctx" value="${pageContext.request.contextPath}"	scope="request" />
<script type="text/javascript" 	src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
<!-- link rel="stylesheet" href="<c:out value="${ctx}"/>/css/casemgmt.css"	type="text/css" -->
<script language="JavaScript"	src="<c:out value="${ctx}"/>/jspspellcheck/spellcheck-caller.js"></script>
<script type="text/javascript">

	var flag=<%=request.getAttribute("change_flag")%>; 
	<%
		org.oscarehr.casemgmt.web.formbeans.CaseManagementEntryFormBean form=(org.oscarehr.casemgmt.web.formbeans.CaseManagementEntryFormBean) session.getAttribute("caseManagementEntryForm");
		int size=form.getIssueCheckList().length;	
		if (session.getAttribute("newNote")!=null && "true".equalsIgnoreCase((String)session.getAttribute("newNote")))
	{%>
		var newNote=true;
	<%}else{%>
		var newNote=false;
	<%}	
		if (session.getAttribute("issueStatusChanged")!=null && "true".equalsIgnoreCase((String)session.getAttribute("issueStatusChanged")))
	{%>
		var issueChanged=true;
	<%}else{%>
		var issueChanged=false;
	<%}%>
	
	var issueSize=<%=size%>;
	
	function setChangeFlag(change){
		flag=change;
		document.getElementById("spanMsg").innerHTML="This note has not been saved yet!";
		document.getElementById("spanMsg").style.color="red";
	}
	
	function validateChange(){
		var str="You haven't saved the change yet. Please save first.";
		if (flag==true){
			/*if (confirm(str)) return true;
			else return false;*/
			alert(str);
			return false;
		}
		return true;
	}
	
	function validateBack(){
		var str="You haven't saved the change yet. Please save first.";
		if (flag==true){
			/*if (confirm(str)) return true;
			else return false;*/
			alert(str);
			return false;
		}else{
			return true;
		}
	}
	function validateIssuecheck(){
		var i=0;
		for (i=0;i<issueSize;i++)
		{
			//alert("checked="+document.caseManagementEntryForm.elements["issueCheckList["+i+"].checked"].checked);
			if (document.caseManagementEntryForm.elements["issueCheckList["+i+"].checked"].checked) 
			{
				//alert("issue check return true");
				return true;
			}
		}
		return false;
			
	}
	function validateEnounter(){
	
		if (document.caseManagementEntryForm.elements["caseNote.encounter_type"].value=="" ||document.caseManagementEntryForm.elements["caseNote.encounter_type"].value==" ")
		{
			return false;
		}else{
		 	return true;
		}	
	}
	function validateCaseStatus(){
	
		if (document.caseManagementEntryForm.elements["caseNote.encounter_type"].value=="" ||document.caseManagementEntryForm.elements["caseNote.encounter_type"].value==" ")
		{
			return false;
		}else{
		 	return true;
		}	
	}
	function validateProgram(){
		var elSel= document.caseManagementEntryForm.elements["caseNote.program_no"];				
		if (elSel==null ||elSel.value=="" ||elSel.value==" ")
		{
			return false;
		}else{
		 	return true;
		}	
	}
	
	function validateIssueStatus(){
		var signed=false;
		
		if (document.caseManagementEntryForm.sign.checked) signed=true;
		
		if (newNote==true && signed==true){
			var i=0;
			/*for (i=0;i<issueSize;i++)
			{
				if (document.caseManagementEntryForm.elements["issueCheckList["+i+"].issue.acute"].value=="true") return true;
				if (document.caseManagementEntryForm.elements["issueCheckList["+i+"].issue.certain"].value=="true") return true;
				if (document.caseManagementEntryForm.elements["issueCheckList["+i+"].issue.major"].value=="true") return true;
				if (document.caseManagementEntryForm.elements["issueCheckList["+i+"].issue.resolved"].value=="true") return true;
			}*/
			if (issueChanged==true) return true;
			else return false;
		}
		return true;
	}
	
	function validateSignStatus() {
		if(document.caseManagementEntryForm.sign.checked) 
			return true;
		else 
			return false;
	}
	function validateNoteStatus() {
		if (document.caseManagementEntryForm.elements["caseNote.caseStatusId"].value=="" ||document.caseManagementEntryForm.elements["caseNote.caseStatusId"].value==" ")
		{
			return false;
		}else{
		 	return true;
		}
	}
	function isIssueEmpty()
	{
		var elSel= document.getElementsByName("lstIssue")[0]; 
		var txtKey= "";
		if(elSel!=null && elSel.options[0]!=null) txtKey=elSel.options[0].value;
		if(txtKey=="") {			
			return true;		
		}
		else{						
			return false;
		}
	}
	function validateSave(methodValue){
	
		if(methodValue=="save" && noChanges())
		{
			alert("There are no changes detected to save");
			return;
		}

		var str1="Please choose program before saving." ;
		var str2="Are you sure that you want to sign and save without changing the status of any of the issues?";
		var str3="Please choose Encounter Type before saving the note.";
		var str4="Are you sure that you want to save without signing?";
		var str5="You cannot save a note when there is no Component of Service, please add a Component of Service before save." ;
		var str6="Please choose Case Status before saving." ;
		if(!validateNoteStatus()) {
			alert(str6); return false;
		}
		if (!validateEnounter()){
			alert(str3); return false;
		}				
		if(!validateProgram()){
			alert(str1); return false;
		}
		/*		
		if (!validateIssuecheck()){
			alert(str1); return false;
		}
		*/
		if(isIssueEmpty()){			
			alert(str5);  return false;
		}
		
		if (!validateSignStatus()){
			if(confirm(str4)) {
			    setNoConfirm();
				return true;
			}
			else return false;
		}
		
		setNoConfirm();
		return true;
	}
	

 	function spellCheck() {
            
                // Build an array of form elements (not there values)
                var elements = new Array(0);
                
                // Your form elements that you want to have spell checked                
                elements[elements.length] =  document.caseManagementEntryForm.elements["caseNote_note"];
               // alert(document.caseManagementEntryForm.elements["caseNote.note"].value);            
                // Start the spell checker
                startSpellCheck('<c:out value="${ctx}"/>/jspspellcheck/',elements);
                return false;
       }
 	function getIssueList(){
  		var elSel= document.getElementsByName("lstIssue")[0]; 
  		var txtKey= document.getElementsByName("txtIssueKey")[0]; 
  		var txtValue= document.getElementsByName("txtIssueValue")[0]; 
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

	function removeSel(str) {
    	var elSel= document.getElementsByName(str)[0]; 
    	if(elSel.selectedIndex>=0){
      		elSel.remove(elSel.selectedIndex);
    	}else{
      		alert("Please select one item to remove.");
    	} 
	}            

</script>

<script>
var XMLHttpRequestObject = false;

 if(window.XMLHttpRequest) {
        XMLHttpRequestObject = new XMLHttpRequest();
 } else if(window.ActiveXObject) {
        XMLHttpRequestObject = new ActiveXObject("Microsoft.XMLHTTP");
 }
 
 	function autoSave() {
		if(XMLHttpRequestObject) {
			var obj = document.getElementById('caseNote_note');
			XMLHttpRequestObject.open("POST",'<html:rewrite action="/CaseManagementEntry2"/>',true);
            XMLHttpRequestObject.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
            /*
			XMLHttpRequestObject.onreadystatechange = function()
			{
				if(XMLHttpRequestObject.readyState == 4 &&
						XMLHttpRequestObject.status == 200) {
					alert('saved');
                }
			}
			*/                        
			var demographicNo = '<c:out value="${param.demographicNo}"/>';
                        var noteId = '<%=request.getParameter("noteId") != null ? request.getParameter("noteId") : request.getAttribute("noteId") != null ? request.getAttribute("noteId") : ""%>';
			var program = '<c:out value="${case_program_id}"/>';
			XMLHttpRequestObject.send("method=autosave&demographicNo=" + demographicNo + "&programId=" + program + "&note_id=" + noteId + "&note="  + escape(obj.value));
						
		}	
		
	//	setTimer();	
	}
	/*
	function setTimer() {
		setTimeout("autoSave()", 60000);
	}
	
	function init() {
		setTimer();
		window.opener.location.reload(true);
	}
	*/

	function restore() {
		if(confirm('You have an unsaved note from a previous session.  Click ok to retrieve note.')) {
			document.caseManagementEntryForm.method.value='restore';
			document.caseManagementEntryForm.submit();			
		}		
	}	
	function submitForm(methodValue)
	{
		if (!trimInputBox()) return false;
		if(!isDateValid) return;
		if(methodValue=="save" && noChanges())
		{
			alert("There are no changes detected to save");
			inRefreshing = false;
		}
		else
		{
			getIssueList();
			document.forms[0].method.value=methodValue;
			document.forms[0].submit();
		}
	}
</script>

</head>
<body > 
<html:form action="/CaseManagementEntry2">
	<html:hidden property="demographicNo" />		
	<input type="hidden" name="method" value="save" />
	<c:if test="${param.from=='casemgmt'||requestScope.from=='casemgmt'}">
		<input type="hidden" name="from" value="casemgmt" />
	</c:if>	
	<input type="hidden" name="noteId" />
	<table width="100%">
		<tr>
			<th class="pageTitle" width="100%">Case Management Note</th>
		</tr>
		<tr>
			<td class="simple" style="background: lavender"><%@ include file="/PMmodule/ClientInfo.jsp" %></td>
		</tr>
		<tr>
			<td align="left" class="buttonBar2">
			<!-- 
			<span
				style="text-decoration: cursor:pointer;color: blue"
				onclick="document.caseManagementEntryForm.method.value='save';return validateSave();">
			<img border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save
			&nbsp;| </span>
			-->
			<html:link action="/CaseManagementView2.do"  paramId="clientId" paramName="clientId"	style="color:Navy;text-decoration:none;">
				<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;|
			</html:link>
			<c:if test="${!isReadOnly }">	
				<a onclick="javascript: if(validateSave('save')) return deferedSubmit('save'); else return false;" href='javascript:void1();' style="color:Navy;text-decoration:none;">
					<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save&nbsp;&nbsp;</a>
			</c:if>	
			</td>
		</tr>
		<tr height="18px">
			<td align="left" class="message">		
			<logic:messagesPresent
				message="true">
				<html:messages id="message" message="true" bundle="pmm">
					<c:out escapeXml="false" value="${message}" />
				</html:messages>
			</logic:messagesPresent>
			</td>
		</tr>
	</table>
	<table cellpadding="3" cellspacing="0" border="0" width="80%">
		<tr>
			<th style="width:40%">Case Status*</th>
			<td><html-el:select property="caseNote.caseStatusId">
				<html-el:option value=""></html-el:option>
				<html-el:options collection="lstCaseStatus" property="code"
					labelProperty="description"></html-el:options>
				</html-el:select>
			</td>
		</tr>
	</table>
	<table cellpadding="3" cellspacing="0" border="0" width="80%">
		<tr>
			<th style="width:40%">Program*</th>
			<td><html-el:select property="caseNote.program_no">
				<html-el:option value=""></html-el:option>
				<html-el:options collection="lstProgram" property="code"
					labelProperty="description"></html-el:options>
				</html-el:select>
			</td>
		</tr>
	</table>
	<table width="90%" border="0" cellpadding="0" cellspacing="1">
	<tr>
			<th>Components of Service*</th>
		</tr>
		<tr>
			<td width="60%"><html-el:select property="lstIssue" multiple="true" size="3"	 style="width:100%;">
				<html-el:options collection="lstIssueSelection" property="code"
					labelProperty="description"></html-el:options>
			</html-el:select>
			 <html:hidden property="txtIssueKey" value="" />
			 <html:hidden	property="txtIssueValue" value="" />
			</td>		
		
			<td align="left" valign="top">&nbsp;
			<c:if test="${!isReadOnly }">	
			<table width="100%" border="0">
			 <tr>
			 	<td>
					<a id="issAdd" 	href="javascript:void1();" onclick="setNoConfirm();return showLookup('ISS', '', '', 'caseManagementEntryForm','lstIssue','', true, '<c:out value="${ctx}"/>')">	Add</a>			 
				</td>
			</tr>
			<tr>
				<td><a	href="javascript:removeSel('lstIssue')" onclick="setNoConfirm();">Remove</a>
				</td>
			</tr>
			</table>
			</c:if>
			</td>
		</tr>
	</table>
	<br>		
	<%
		if ("true".equalsIgnoreCase((String) request.getAttribute("change_flag"))) {
	%>
	<span style="color:red">this note has not been saved yet!</span>
	<%
	} else {
	%>
	<span id="spanMsg" style="color:blue"> 
	<logic:messagesPresent	message="true">
		<html:messages id="message" message="true" bundle="casemgmt">
			<c:out value="${message}" />
		</html:messages>
	</logic:messagesPresent> </span>
	<%
	}
	%>
	<table style="width: 90%">
		<tr>
			<td align="left" class="buttonBar2">
			<c:if test="${!isReadOnly }">	
			<a href="javascript:void1();"
				style="text-decoration: cursor:pointer;color: blue"
				onclick="return spellCheck();"> <img border=0
				src=<html:rewrite page="/images/icon_confirmsml.gif"/> />&nbsp; Spell Check
			&nbsp;|</a>
			</c:if>
			</td>
		</tr>
	</table>
	<table width="90%" border="1">
		<tr>
			<td class="fieldValue" colspan="1">
				<html-el:textarea  cols="60" rows="12"	property="caseNote_note"  ></html-el:textarea>				
			</td>
			<td class="fieldTitle"></td>

		</tr>
  </table>
  <table width="90%">
		<tr>
			<td class="fieldTitle" width="40%">Encounter Type*</td>
			<td class="fieldValue">
			<html-el:select property="caseNote.encounter_type">
				<html-el:option value=""></html-el:option>
				<html-el:options collection="lstEncounterType" property="code"
					labelProperty="description"></html-el:options>
			</html-el:select></td>
		</tr>

		<!-- tr>
		<td class="fieldTitle">Billing Code:</td>
		<td class="fieldValue"><html:text property="caseNote.billing_code" /><input type="button" value="search"/></td>
	</tr -->

		<tr>
			<td class="fieldTitle" width="40%">Sign</td>
			<td class="fieldValue"><html-el:checkbox property="sign" /></td>
		</tr>
<!-- 
		<tr>
			<td class="fieldTitle" width="40%">Include checked components of service in note</td>
			<td class="fieldValue"><html:checkbox property="includeIssue" /></td>
		</tr>	
-->				 
	</table>
	<%@ include file="/common/readonly.jsp" %>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
</body>
</html>
