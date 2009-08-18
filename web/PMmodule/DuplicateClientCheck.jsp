<%@ include file="/taglibs.jsp"%>
<html>
<head>
<link rel="shortcut icon" href="../images/favicon.ico" type="image/x-icon" />
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<title>Duplicate Client Check</title>
<link rel="stylesheet" type="text/css" href='<html:rewrite page="/css/displaytag.css" />' />
<link rel="stylesheet" type="text/css" href='<html:rewrite page="/css/core.css" />' />
<script type="text/javascript" src="<html:rewrite page="/js/quatroLookup.js" />"></script>
<script type="text/javascript" src="<html:rewrite page="/js/checkDate.js" />" ></script>
<script language="Javascript">
	var readOnly = false;
	var win = null;
	function replacePrime(str)
	{
		return str.replace(/&#39;/g,"\'");
	}

	function selectDuplicateClient(form_name, firstName, firstNameValue, 
	   lastName, lastNameValue, sex, sexValue, dob, dobValue, alias, aliasValue, 
	   clientNo, clientNoValue, statusMsg, statusMsgValue, 
	   newClientChecked,newClientCheckedValue, shortFlag) {
	   var fromPage=document.forms[0].elements["pageFrom"]; 
  	   if(fromPage==null || fromPage.value=="") { 
		   var fn = opener.document.getElementsByName(firstName)[0];
		   fn.value = replacePrime(firstNameValue);
		   var ln = opener.document.getElementsByName(lastName)[0];
		   ln.value = replacePrime(lastNameValue);
		   var elSel= window.opener.document.getElementsByName(sex)[0]; 
		   for(var i=0;i<elSel.options.length;i++){
		      if(sexValue==elSel.options[i].value)
		      {
		         elSel.options[i].selected=true;
		         break;
		      }
		    }
		
		   myexpr = "opener.document." + form_name + ".elements['" + dob +"'].value='" + dobValue + "'";
		   eval(myexpr);
		   myexpr = "opener.document." + form_name + ".elements['" + alias +"'].value='" + aliasValue + "'";
		   eval(myexpr);
		   myexpr = "opener.document." + form_name + ".elements['" + clientNo +"'].value='" + clientNoValue + "'";
		   eval(myexpr);
				
		   var statusMsgValue2=statusMsgValue;
		   if(shortFlag=="Y"){
		     if(statusMsgValue=="(Existing Client)"){
		       statusMsgValue2="#";
		     }else{
		       statusMsgValue2="";
		     } 
		   }
		   myexpr = "opener.document." + form_name + ".elements['" + statusMsg +"'].value='" + statusMsgValue2 + "'";
		   eval(myexpr);
		
		   myexpr = "opener.document." + form_name + ".elements['" + newClientChecked +"'].value='" + newClientCheckedValue + "'";
		   eval(myexpr);
		}
		else{
			AddtoDropdown(clientNoValue, lastNameValue + ", " + firstNameValue, "incidentForm.lstClient");	   
		}
	   self.close();
	}
function submitForm(shortFlagValue){
    document.forms[0].elements["method"].value="search";
	document.forms[0].submit();
}

</script>
</head>
<body>
<html:form action="/PMmodule/DuplicateClientCheck.do">
<input type="hidden" name="var" value="<c:out value="${var}"/>" />
<input type="hidden" name="method" />
<input type="hidden" name="pageFrom" value="<c:out value="${pageFrom}"/>" />
<input type="hidden" name="shortFlag" value="<c:out value="${shortFlag}"/>"/>
<table width="100%" class="edit">
<tr><td colspan="4"><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Personal information</th></tr>
</table></div></td></tr>
<tr><td width="15%">First name*</td>
<td width="35%"><html-el:text property="client.firstName" size="20" maxlength="30" /></td>
<td width="19%">Gender*</td>
<td width="31%"><html-el:select property="client.sex">
   <html-el:optionsCollection property="genders" value="code" label="description"/>
</html-el:select></td></tr>
<tr><td>Last name*</td><td><html-el:text property="client.lastName" size="20" maxlength="30" /></td>
<td style="{display:none}">Date of birth<br>(yyyy/mm/dd)</td><td style="{display:none}">
<quatro:datePickerTag property="client.dob" width="65%" openerForm="duplicateClientCheckForm">
</quatro:datePickerTag>
</td></tr>
<tr>
<td colspan="2">
<a href="javascript:submitForm('');" style="color:Navy;text-decoration:none;">
<img border="0" src="<html:rewrite page="/images/search16.gif"/>" />&nbsp;Search&nbsp;&nbsp;
</a>
</td>
<td></td></tr>
</table>

<display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="client" name="clients" export="false" pagesize="10" requestURI="/PMmodule/DuplicateClientCheck.do">
  <display:setProperty name="paging.banner.placement" value="bottom" />
  <display:setProperty name="basic.msg.empty_list" value="No records found (First or Last Name is required for search.)" />
  <display:column sortable="false" title="Action">    
        <c:choose>
	      <c:when test="${client.demographicNo==0}">
	        <a href="javascript:selectDuplicateClient('<c:out value="${formName}"/>',
	        '<c:out value="${firstName}"/>', '<c:out value="${client.firstNameJS}"/>',
	        '<c:out value="${lastName}"/>', '<c:out value="${client.lastNameJS}"/>',
	        '<c:out value="${sex}"/>', '<c:out value="${client.sex}"/>',
	        '<c:out value="${dob}"/>', '<c:out value="${client.dob}"/>',
	        '<c:out value="${alias}"/>', '<c:out value="${client.alias}"/>',
	        '<c:out value="${clientNo}"/>','0',
	        '<c:out value="${statusMsg}"/>', '(New Client)',
	        '<c:out value="${newClientChecked}"/>', 'Y', '<c:out value="${shortFlag}"/>');">
	         Add New Client</a>
	      </c:when>
	      <c:otherwise>
	        <a href="javascript:selectDuplicateClient('<c:out value="${formName}"/>',
	        '<c:out value="${firstName}"/>', '<c:out value="${client.firstNameJS}"/>',
	        '<c:out value="${lastName}"/>', '<c:out value="${client.lastNameJS}"/>',
	        '<c:out value="${sex}"/>', '<c:out value="${client.sex}"/>',
	        '<c:out value="${dob}"/>', '<c:out value="${client.dob}"/>',
	        '<c:out value="${alias}"/>', '<c:out value="${client.alias}"/>',
	        '<c:out value="${clientNo}"/>','<c:out value="${client.demographicNo}"/>',
	        '<c:out value="${statusMsg}"/>', '(Existing Client)',
	        '<c:out value="${newClientChecked}"/>', 'N', '<c:out value="${shortFlag}"/>');">
	          Add Existing</a>
	      </c:otherwise>
    </c:choose>   
  </display:column>	
  <display:column sortable="false" title="Client No">
    <c:choose>
      <c:when test="${client.demographicNo==0}">
        &nbsp;
      </c:when>
      <c:otherwise>
        <a href="javascript:selectDuplicateClient('<c:out value="${formName}"/>',
        '<c:out value="${firstName}"/>', '<c:out value="${client.firstName}"/>',
        '<c:out value="${lastName}"/>', '<c:out value="${client.lastName}"/>',
        '<c:out value="${sex}"/>', '<c:out value="${client.sex}"/>',
        '<c:out value="${dob}"/>', '<c:out value="${client.dob}"/>',
        '<c:out value="${alias}"/>', '<c:out value="${client.alias}"/>',
        '<c:out value="${clientNo}"/>','<c:out value="${client.demographicNo}"/>',
        '<c:out value="${statusMsg}"/>', '(Existing Client)',
        '<c:out value="${newClientChecked}"/>', 'N', '<c:out value="${shortFlag}"/>');">
          <c:out value="${client.demographicNo}" /></a>
      </c:otherwise>
    </c:choose>
  </display:column>
  <display:column sortable="false" title="Name">
    <c:choose>
      <c:when test="${client.demographicNo==0}">
        <c:out value="${client.formattedName}" />
      </c:when>
      <c:otherwise>
        <a href="javascript:selectDuplicateClient('<c:out value="${formName}"/>',
        '<c:out value="${firstName}"/>', '<c:out value="${client.firstName}"/>',
        '<c:out value="${lastName}"/>', '<c:out value="${client.lastName}"/>',
        '<c:out value="${sex}"/>', '<c:out value="${client.sex}"/>',
        '<c:out value="${dob}"/>', '<c:out value="${client.dob}"/>',
        '<c:out value="${alias}"/>', '<c:out value="${client.alias}"/>',
        '<c:out value="${clientNo}"/>','<c:out value="${client.demographicNo}"/>',
        '<c:out value="${statusMsg}"/>', '(Existing Client)',
        '<c:out value="${newClientChecked}"/>', 'N', '<c:out value="${shortFlag}"/>');">
           <c:out value="${client.formattedName}" /></a>
      </c:otherwise>
    </c:choose>
  </display:column>
  <display:column sortable="false" title="Date of Birth">
    <c:if test="${client.dob!=null}">
	  <c:out value="${client.dob}" />
    </c:if>
  </display:column>
  <display:column sortable="false" title="Gender"><c:out value="${client.sexDesc}" /></display:column>                        
  <display:column sortable="false" title="Alias"><c:out value="${client.alias}" /></display:column>
</display:table>
<input type="hidden" name="formName" value="<c:out value="${formName}"/>">
<input type="hidden" name="firstName" value="<c:out value="${firstName}"/>">
<input type="hidden" name="lastName" value="<c:out value="${lastName}"/>">
<input type="hidden" name="sex" value="<c:out value="${sex}"/>">
<input type="hidden" name="dob" value="<c:out value="${dob}"/>">
<input type="hidden" name="alias" value="<c:out value="${alias}"/>">
<input type="hidden" name="clientNo" value="<c:out value="${clientNo}"/>">
<input type="hidden" name="statusMsg" value="<c:out value="${statusMsg}"/>">
<input type="hidden" name="newClientChecked" value="<c:out value="${newClientChecked}"/>">
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
</body>
</html>
