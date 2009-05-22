<%@ include file="/taglibs.jsp"%>
<%@page import="java.util.Date"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"
	scope="request" />
<script type="text/javascript"
	src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>

<html-el:form action="/PMmodule/QuatroConsent.do">
	<input type="hidden" name="method" />
	<input type="hidden" name="signed" />
	<input type="hidden" name="rId" value='<c:out  value="${recordId}" />'/>
	<html-el:hidden property="consentValue.demographicNo"  />	
	<html-el:hidden property="consentValue.demographicNo"  />	
	<html-el:hidden property="consentValue.demographicNo"  />	
	<html-el:hidden property="consentValue.id" />
	<input type="hidden" name="clientId" value="<c:out value="${clientId}"/>"/>	
	<input type="hidden" name="scrollPosition" value='<c:out value="${scrPos}"/>' />
	
	<script lang="javascript">
	function printForm(recordId, programId){
    	//To PDF 
    	// var url = appPath + "/Print/PrintView.aspx?id=" + reportId + ":" + recordId + ":p";

    	var url='<c:out value="${ctx}" />/PMmodule/PrintView.do?rId=' +recordId+'&moduleName=consent&programId=' + programId;
		top.childWin = window.open(url,"_blank","toolbar=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width=650,height=400,top=50, left=50");
		top.childWin.focus();
	}
	function refresh()
	{
	 		document.forms[0].method.value = "edit";
			document.forms[0].submit();
	}
	function submitForm(methodVal) {
		trimInputBox();
		if(!isDateValid) return;
		if(methodVal=="save" && !validateSave()) return;
		if(methodVal=="save" && noChanges())
		{
			alert("There are no changes detected to save");
		}
		else
		{
	 		document.forms[0].method.value = methodVal;
			document.forms[0].submit();
		}
	}
	
	function validateStateLength(){
	    var fieldValue = document.consentDetailForm.elements["consentValue.statePurpose"].value;
		if (fieldValue.length>512)
		{
			alert("State Purpose input length is over 512!!!");
			return false;
		}else{
		 	return true;
		}	
	}
	function validateNotesLength(){
	    var fieldValue = document.consentDetailForm.elements["consentValue.notes"].value;
		if (fieldValue.length>512)
		{
			return false;
		}else{
		 	return true;
		}	
	}
	function validateSave(){
	
		var str1="State Purpose input length is over 512!!!" ;
		var str2="Notes input length is over 512!!!" ;
		
		if (!validateStateLength()){
			alert(str1); return false;
		}
		if (!validateNotesLength()){
			alert(str2); return false;
		}
			return true;
	}
	
	function signSignature(){
	   var rId=document.consentDetailForm.elements['consentValue.id'].value;
	   var url='<c:out value="${ctx}" />/topazGetImage.do?method=sign&' +
	     "rid=" +rId +"&moduleName=consent";
	
	   win = window.open(url,"_blank","toolbar=yes,menubar= yes,resizable=yes,scrollbars=yes,status=yes,width=600,height=400");
	   win.focus();
	}
	function viewSignature(){
	  var rId=document.consentDetailForm.elements['consentValue.id'].value;
	   var url='<c:out value="${ctx}" />/topazGetImage.do?' +
	     "rid=" +rId +"&moduleName=consent";
	
	   win = window.open(url,"_blank","toolbar=yes,menubar= yes,resizable=yes,scrollbars=yes,status=yes,width=400,height=200");
	   win.focus();
	}
</script>


	<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
		<tr>
			<th class="pageTitle" align="center">Client Management - Consent</th>
			
		</tr>
		<tr>
			<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
		</tr>
		<tr>
			<td align="left" class="buttonBar2">
		        <a href='javaScript:submitForm("list");' style="color:Navy;text-decoration:none;">
				<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;</a>|
			
				<c:if test="${!isReadOnly}" >		
					<a href='javaScript:void1();'  onclick="javascript: setNoConfirm();return deferedSubmit('save');"	style="color:Navy;text-decoration:none;">
					<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save&nbsp;&nbsp;</a>
				</c:if>
				<logic:greaterThan name="consentDetailForm" property="consentValue.id" value="0">		  			
		  			<c:if test="${!isReadOnly && (signed==null || 'N'==signed)}" >
		  			<a href="javascript:signSignature();" style="color:Navy;text-decoration:none;">
		 		 		<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/notepad.gif"/> />&nbsp;Sign&nbsp;&nbsp;</a>|
		  			</c:if>
		  			<a href="javascript:viewSignature();" style="color:Navy;text-decoration:none;">
		  				<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/search16.gif"/> />&nbsp;Preview Signature&nbsp;&nbsp;</a>|
		  			<a href="javaScript:printForm('<bean:write name="consentDetailForm" property="consentValue.id" />','<bean:write name="consentDetailForm" property="consentValue.programId" />');"        
         				style="color:Navy;text-decoration:none;">
						<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Print16x16.gif"/> />&nbsp;Print&nbsp;&nbsp;</a>	
		        </logic:greaterThan>				
			</td>
		</tr>
		<tr height="18px">
			<td align="left" class="message">		
				<logic:messagesPresent	message="true">
					<html:messages id="message" message="true" bundle="pmm">
						<c:out escapeXml="false" value="${message}" />
					</html:messages>
				</logic:messagesPresent>
				<br />
			</td>
		</tr>
		<tr>
			<td height="100%">
			<div style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 95%; overflow: auto;" id="scrollBar">
<!--  start of page content -->

				<table width="100%" class="edit">
					<tr>
						<td>						
							<table cellpadding="3" cellspacing="0" border="0">
								<tr>
									<th>Consent</th>
								</tr>
							</table>						
						</td>
					</tr>
					<tr><td><hr></td></tr>
					<tr><td>
						<table cellspacing="2" cellpadding="3">
							<tr>
								<td rowspan="2" style="width: 50%">
									<font size="4"><b>Client Consent to the Collection of<br />
										Information from External Agencies
									</b></font>
								</td>
								<td style="width: 30%">Shelter Name:<c:out value="${shelter.description}" /><br />
									Shelter Mailing Address:<c:out value="${shelter.buf3}"/>
								</td>
								<td style="width: 20%">Tel:<c:out value="${shelter.buf8}" /><br /> Fax:<c:out value="${shelter.buf9}" /></td>
							</tr>
						</table>
					</td></tr>
					<tr><td><br></td></tr>					
					<tr>
						<td>
							<table class="simple" cellspacing="2" cellpadding="3">							
								<tr>
									<td colspan="2">I,	
									<c:out value="${client.firstName}" /> &nbsp;<c:out value="${client.lastName}" />&nbsp;
									  , consent to the release and exchange of the following information:
									</td>
								</tr>
								<tr>
									<td colspan="2" width="90%" ><html:textarea  rows="3" property="consentValue.notes" cols="105"  /> </td>
								</tr>
							</table>
							<table class="simple" cellspacing="2" cellpadding="3">
								<tr><td colspan="2">Between an authorized representative of &nbsp;<c:out value="${facilityDesc}"></c:out>&nbsp; and the agency/organization named below:</td></tr>
								<tr>
									<td style="width:20%">Program:</td>
									<td>
										<html:select property="consentValue.programId">			                
				              			<html:options collection="programs" property="code" labelProperty="description" />
				              			</html:select>
									</td>
								</tr>
								<tr><td style="width:20%">Agency Name:</td><td ><html-el:text style="width: 60%" property="consentValue.agencyName" maxlength="60" /></td></tr>
								<tr><td style="width:20%">Contact Person Name:</td><td><html-el:text style="width: 60%" property="consentValue.contactName" maxlength="60" /></td></tr>
								<tr><td style="width:20%">Contact Person Title:</td><td><html-el:text style="width: 60%" property="consentValue.contactTitle" maxlength="30" /></td></tr>
								<tr><td style="width:20%">Contact Person Phone:</td><td><html-el:text style="width: 60%" property="consentValue.contactPhone" maxlength="25" /></td></tr>							
								<tr><td colspan="2">For the following Stated purpose(s):</td></tr>
								<tr><td colspan="2"><html-el:textarea property="consentValue.statePurpose" cols="105"  rows="3" /></td></tr>
						  </table>
						 <table  class="simple" cellspacing="2" cellpadding="3">
								<tr>
									<td colspan="2">
										I fully understand the purpose of this consent and give it voluntarily.  </td>
								</tr>
								<tr>
									<td colspan="2">
										<table>
											<tr>
												<td >
													 The consent is valid for the period starting from 
									: <jsp:useBean id="now" class="java.util.Date" /><fmt:formatDate pattern="yyyy/MM/dd hh:mm a" value="${now}" />
												</td>
												<td > To*  &nbsp; &nbsp;</td>
												<td > <quatro:datePickerTag property="consentValue.endDateStr" openerForm="consentDetailForm" width="150px"></quatro:datePickerTag></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr><td width="77">Dated This:</td><td width="363">							
								<fmt:formatDate pattern="yyyy/MM/dd" value="${now}" /></td></tr>
						</table>								
						<table width="100%" align="right" class="simple">
									<tr><td width="75%"></td><td align="right" width="25%">
										<u><bean:write name="consentDetailForm" property="consentValue.providerFormattedName" /></u>
									</td></tr>
									<tr><td width="75%"></td><td align="right" width="25%" >	Witness Name</td></tr>
						
														
							<tr><td colspan="2">
								<b>Notice with Regard to the Collection of Personal Information:</b><br />
								Personal information is collected under the legal authority of the City of Toronto Act, 1997, 
								Municipal Act, 2001, Chapter 169, Article VII, By-law 112-2005 and Ontario Works Act, 1997, 
								for the purposes of  administering Government of Ontario social assistance programs, 
								providing shelter services and sharing information between shelter providers when 
								specific consent is obtained.  Questions about this collection can be directed to the 
								Administrative Supervisor, Shelter, Support and Housing Administration Division, 
								Telephone no. 416-392-8741, Metro Hall, 55 John St. 6th Floor, Toronto, Ontario M5V 3C6.
								</td></tr>
						</table>					
					</td>
					</tr>					
				</table>

<!--  end of page content -->
			
			</div>
			</td>
		</tr>
	</table>
	<%@ include file="/common/readonly.jsp" %>
</html-el:form>
