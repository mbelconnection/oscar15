<%@ include file="/taglibs.jsp"%>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"
	scope="request" />
<script type="text/javascript"
	src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
	
<html-el:form action="/PMmodule/QuatroServiceRestriction.do">

	<script lang="javascript">
	function resetClientFields() {
		var form = document.serviceRestrictionForm;
		form.elements['program.name'].value='';
	} 
    
    function submitForm(methodVal) {
		if (!trimInputBox()) return false;
    	var validProgram = document.getElementsByName("serviceRestriction.programId")[0].value.length > 0;
    	var validReason = document.getElementsByName("serviceRestriction.commentId")[0].value.length > 0;
    	
    	if(!validProgram){
    		alert("Please select 'Program' before saving.");
			inRefreshing = false;
    		return false;
    	}
    	if(!validReason){
    		alert("Please select 'Reason for service restriction' before saving.");
			inRefreshing = false;
    		return false;
    	}    	
	    if(validProgram && validReason && validateLength()){

			if(methodVal=="save" && noChanges())
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
		else
		{
				inRefreshing = false;
		}
		return false;
	}
	
	function validateLength() {
		var length = document.getElementsByName("serviceRestrictionLength")[0];
		var maxLengthStr = document.getElementsByName("maxLength")[0].value;
		var maxLength = parseInt( maxLengthStr );
		
		if(isNaN(length.value) || !isInt(length.value)){
			alert("Please enter a whole number of days for Length of Restriction.");
			return false;
		} 
		else
		{
			length.value = parseInt(length.value);
		} 
	
		if(length.value < 1 ){
			alert("'Length of restriction' must be greater or equal to 1 day.");
			return false;
		}
		
		if(maxLength == 0) maxLength = 1825;
		if( length.value > maxLength ){
			alert("'Length of restriction' must be less or equal to " + maxLength + " days.");
			return false;
		}
		
		return true;
    }	
    
    function programFilter(){
    	if(inRefreshing) return false;
		inRefreshing = true;
		serviceRestrictionForm.method.value = "edit";
		serviceRestrictionForm.submit();
    }
    
</script>
<%String a="1"; %>
	<input type="hidden" name="clientId"
		value="<c:out value='${clientId}'/>" />
	<input type="hidden" name="method" id="method" value="save" />
	<input type="hidden" name="ruleCheck" value="N" />
	<html:hidden property="serviceRestriction.demographicNo" />
	<html:hidden property="serviceRestriction.id" />
	<input type="hidden" name="scrollPosition" value='<c:out value="${scrPos}"/>' />

	<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
		<tr>
			<th class="pageTitle" align="center">Client Management - Service
			Restriction</th>
		</tr>
		<tr>
			<td class="simple" style="background: lavender"><%@ include
				file="ClientInfo.jsp"%></td>
		</tr>
		<tr>
			<td align="left" class="buttonBar2">
				<html:link action="/PMmodule/QuatroServiceRestriction.do"
				 style="color:Navy;text-decoration:none;">
				<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;|</html:link>
         <c:if test="${serviceObjStatus!='completed' && !isReadOnly}">				
			<a	href="javaScript:void1()" onclick="javascript: setNoConfirm();return submitForm('save');"	style="color:Navy;text-decoration:none;"> 
			<img style="vertical-align: middle" border=0	src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save&nbsp;&nbsp;</a>
         </c:if>				
</td>
		</tr>
		<tr>
			<td align="left" class="message"><logic:messagesPresent
				message="true">
				<html:messages id="message" message="true" bundle="pmm">
					<c:out escapeXml="false" value="${message}" />
				</html:messages>
			</logic:messagesPresent></td>
		</tr>
		<tr height="100%">
			<td>
			<div
				style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">

			<!--  start of page content -->
			<table width="100%">
				<tr>
					<td><br>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>Service Restrictions</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>
				<tr>
					<td>
					<table wdith="100%" class="edit">
						<tr>
							<td width="35%">Program*</td>
							<td width="65%">
							<html:select onchange="javascript:setNoConfirm(); programFilter();"
								property="serviceRestriction.programId">
								<html:option value=""></html:option>
								<html:options collection="allPrograms" property="code"
									labelProperty="description" />
							</html:select></td>
						</tr>
						<tr>
							<td width="35%">Reason for service restriction*</td>
							<td width="65%"><html:select
								property="serviceRestriction.commentId">
								<html:option value=""></html:option>
								<c:forEach var="restriction" items="${serviceRestrictionList}">									
									<html-el:option value="${restriction.code}">
										<c:out value="${restriction.description}" />
									</html-el:option>
								</c:forEach>
							</html:select></td>
						</tr>
						<tr>
							<td width="35%">Length of restriction (in days)</td>
							<td width="65%"><html:text size="12" maxlength="11"	property="serviceRestrictionLength" /> 
								<html:hidden property="maxLength" />
								<html:hidden property="serviceRestriction.startDateStr" />
							</td>
						</tr>
						<tr>
							<td width="35%">Notes</td>
							<td width="65%"><html:textarea cols="80" rows="10"
								property="serviceRestriction.notes" /> 
							</td>
						</tr>
						
					</table>
					</td>
				</tr>
			</table>
			<!--  end of page content --></div>
			</td>
		</tr>
	</table>
	<%@ include file="/common/readonly.jsp" %>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
