<%@include file="/taglibs.jsp" %>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro" %>
<%@page import="java.util.Date"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<script type="text/javascript" src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
<script type="text/javascript">
	function resetClientFields() {
		var form = document.quatroClientReferForm;
		form.elements['program.name'].value='';
	}

	 function popupProgramSearch(clientId) {
        var page = '<html:rewrite action="/PMmodule/QuatroProgramSearch.do?formName=quatroClientReferForm&formElementId=selectedProgramId&clientId=" />'+clientId;       
        var windowprops = "height=600,width=800,location=no,"
                + "scrollbars=yes,menubars=no,toolbars=no,resizable=yes,top=10,left=0,statusbar=yes";
        // alert("page name" +page);
        var popup = window.open(page, "_blank", windowprops);
        if (popup != null) {
            if (popup.opener == null) {
                popup.opener = self;
            }
            popup.focus();
        }
    }	
    
    
    function submitForm(methodVal) {
		if (!trimInputBox()) return false;
		if(methodVal=="save")
		{
			if (noChanges())
			{
		    	alert("There are no changes detected to save");
				inRefreshing = false;
		    	return;
			}
			var programFrom = document.getElementsByName("referral.fromProgramId")[0];
			if(programFrom.value == "") 
			{
				alert("Please select From Program");
				inRefreshing = false;
				return;
			}
		}
		document.forms[0].method.value = methodVal;
		document.forms[0].submit();
	}
    
</script>

<html-el:form action="/PMmodule/QuatroRefer.do">
<input type="hidden" name="clientId" /> 
<input type="hidden" name="pageChanged" id="pageChanged" value='<c:out value="${pageChanged}" />'/> 
<html:hidden property="referral.clientId" />
<html:hidden property="referral.id" />
<html:hidden property="referral.programId" />
<html:hidden property="referral.status"/>
<html:hidden property="referral.referralDateTxt" />
<html:hidden property="referral.completionDateTxt" />
<input type="hidden" name="selectedProgramId"/>
<input type="hidden" name="rId" />
<input type="hidden" name="method" />
<input type="hidden" name="ruleCheck" value="Y" />
<input type="hidden" name="scrollPosition" value='<c:out value="${scrPos}"/>' />
<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
	<tr>
		<th class="pageTitle" align="center">Client Management - Referral</th>
	</tr>
	<tr>
			<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
	</tr>
	<tr>
		<td align="left" class="buttonBar2">
		<html:link action="/PMmodule/QuatroRefer.do"  style="color:Navy;text-decoration:none;">
		<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;|</html:link>
		<c:if test="${!isReadOnly && (referralStatus=='' || referralStatus=='pending') }">
				<a href='javascript:submitForm("save");' onclick="javascript: setNoConfirm();" style="color:Navy;text-decoration:none;">
				<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save&nbsp;&nbsp;</a>				
		</c:if>
</td>
	</tr>
	<tr height="18px"><td align="left" class="message">
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
<table>

<tr><td><br>
<table cellpadding="3" class="simple" cellspacing="0" border="0">
<tr><th title="LookupTableList">Referral</th></tr>
</table></td></tr>
<tr><td>
  <table class="simple" cellspacing="2" cellpadding="3">
	<tr><th style="color:black" rowspan="2">Program* <br>
	<c:if test="${!isReadOnly}">
		<a href="javaScript:popupProgramSearch('<bean:write name="quatroClientReferForm" property="clientId" />');" style="color:Navy;text-decoration:none;"
			onclick="javascript: setNoConfirm();">			
		<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/search16.gif"/> height="16px" width="16px"/>&nbsp;Search&nbsp;&nbsp;</a>
	</c:if>	
		</th>
	<th style="color:black">Name</th>
	<th style="color:black">Type</th>
	<th style="color:black">Occupancy/Queue</th>
	<th style="color:black">Phone</th>
	</tr>
	<tr><td><c:out value="${program.name }" /></td>
	<td><c:out value="${program.type }" /></td>
	<td><c:out value="${program.numOfMembers}" />/<c:out value="${program.maxAllowed}" /> <c:out value="${program.queueSize}" /> (waiting)</td>
	<td><c:out value="${program.phone }" /></td>
	
	</tr>		
 </table>
</td></tr>

<tr><td>
  <table class="edit" cellspacing="2" cellpadding="3">
	<tr><td width="20%">Reason for referral</td>
	<td><html:textarea cols="60" rows="7" property="referral.notes" /></td></tr>
	<tr><td width="20%">Notes</td>
	<td><html:textarea cols="60" rows="7" property="referral.presentProblems" /></td></tr>
	<tr><td width="20%">From Program*</td>
	  <c:choose>
	  <c:when test="${isReadOnly==null || isReadOnly==false}">
		<td><html:select property="referral.fromProgramId">
				<html-el:option value=""></html-el:option>
				<html:options collection="lstProgram" property="code"
					labelProperty="description"></html:options>
				</html:select>
			</td>
   	  </c:when>
   	  <c:otherwise><td><c:out value="${fromProgramName}"/></td>
   	  </c:otherwise>
   	  </c:choose>		
	</tr>
    <tr>
  	<td>Rejection Reason</td>
  	<td><html-el:text property="referral.rejectionReasonDesc" readonly="true" style="width:90%"></html-el:text></td>
  	</tr>
  	<tr>  	<td>Rejection Note</td>
  	<td><html-el:textarea property="referral.completionNotes"  readonly="true" style="width:90%" /> </td>
  	</tr>
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
