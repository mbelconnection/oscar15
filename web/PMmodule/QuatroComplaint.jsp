<!-- 

Source:web/PMmodule/QuatroComplaint.jsp 

-->

<%@ include file="/taglibs.jsp"%>
<%@page import="org.oscarehr.PMmodule.model.Admission"%>
<%@page import="java.util.Date"%>

<%@page import="com.quatro.model.Complaint"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"
	scope="request" />
<script type="text/javascript"
	src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
<script lang="javascript">
	function txtAreaLenChecker(obj, maxLen) {
	   //counting each end of line as two characters
	   
		var v = obj.value;
	
		var len = v.length;
		
		if(len > maxLen){
			alert("Length of this field can not exceed " + maxLen + " characters.");
			obj.value = v.substr(0, maxLen);
	   }
	
	}
	
	function submitForm(methodVal) {
		if (!trimInputBox()) return false;
		if(!isDateValid) {
			inRefreshing = false;
			return;
		}
		var validSource = document.getElementsByName("complaint.source")[0].value.length > 0;
		if(!validSource){
			alert("Please select Source of Complaint before saving.");
			document.getElementsByName("complaint.source")[0].focus();
			inRefreshing = false;
			return;
		}
		var validMethod = document.getElementsByName("complaint.method")[0].value.length > 0;
		if(!validMethod){
			document.getElementsByName("complaint.method")[0].focus();
			alert("Please select Method of Contact before saving.");
			inRefreshing = false;
			return;
		}
		//name
	var obj = document.getElementsByName("complaint.firstname")[0];
    if(obj.value.trim()==""){
      alert("First name is empty.");
      obj.focus();
	  inRefreshing = false;
      return; 
    }
    if(!isName(obj.value.trim())){
      alert("First name contains illegal character!");
      obj.focus();
	  inRefreshing = false;
      return; 
    }
    
    var obj = document.getElementsByName("complaint.lastname")[0];
    if(obj.value.trim()==""){
      alert("Last name is empty.");
      obj.focus();
	  inRefreshing = false;
      return; 
    }
    if(!isName(obj.value.trim())){
      alert("Last name contains illegal character!");
      obj.value="";
      obj.focus();
	  inRefreshing = false;
      return; 
    }
		
		var validProgram = document.getElementsByName("complaint.programId")[0].value.length > 0;
		if(!validProgram){
			alert("Please select program before saving.");
			document.getElementsByName("complaint.programId")[0].focus();
			inRefreshing = false;
			return;
		}
		//standards
		var validStandards = validateStandards();
		if(!validStandards){
			alert("Please select Toronto Shelter Standards before saving.");
			inRefreshing = false;
			return;
		}
		var validDescription = document.getElementsByName("complaint.description")[0].value.length > 0;
		if(!validDescription){
			alert("Please enter the Description of Complaint before saving.");
			document.getElementsByName("complaint.description")[0].focus();
			inRefreshing = false;
			return;
		}
		var validOutcome = document.getElementsByName("complaint.satisfiedWithOutcome")[0].value.length > 0;
		if(!validOutcome){
			alert("Please specify if the complainant was satisfied with the outcome before saving.");
			document.getElementsByName("complaint.satisfiedWithOutcome")[0].focus();
			inRefreshing = false;
			return;
		}
		var duration = document.getElementsByName("complaint.duration")[0].value;
		if(!isInteger(duration))
		{
			alert("Time Spent on Complaint is mandatory, should be a number, and not less than 0");
			document.getElementsByName("complaint.duration")[0].focus();
			inRefreshing = false;
			return;
		}
		
		var completeStatus = document.getElementsByName("complaint.status")[0].checked == true;
		var completeDate = document.getElementsByName("complaint.completedDatex")[0].value;
		if(completeStatus && completeDate.length == 0){
			alert("Please specify the complete date before saving.");
			document.getElementsByName("complaint.completedDatex")[0].focus();
			inRefreshing = false;
			return;
		}
		if(!completeStatus && completeDate.length > 0){
			confirmComplete();
		}
		if(isBeforeToday(completeDate)){
			alert("Date Completed - Should be today's date or after.");
			document.getElementsByName("complaint.completedDatex")[0].focus();
			inRefreshing = false;
			return;
		}
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
		//alert("Debug:submitted");
	}
	
	function isName(str) 
	{ 
	    var reg = new RegExp(/^[\s\'\-a-zA-Z]+$/); 
	    var flag = reg.test(str);
	    if(flag){
			var len = str.length;
			var startChar = str.substring(0,1);
			var endChar = str.substring(len-1);
			if(startChar == "'" || startChar == "-" || endChar == "'" || endChar == "-" || str.indexOf("''") >= 0 || str.indexOf("--") >= 0|| str.indexOf("  ") >= 0){
				flag = false	
			}	
		}
		return flag;
	}
	
	function confirmComplete(){
		var result = confirm("Complaint is about to be completed. \nNo further changes to the complaint will be allowed.\nAre you sure you want to complete this complaint?");
		if(!result){
			document.getElementsByName("complaint.completedDatex")[0].value = '';
			document.getElementsByName("complaint.status")[0].checked=false;
			document.getElementsByName("complaint.status")[1].checked=true;
		}else{
			document.getElementsByName("complaint.status")[0].checked=true;
			document.getElementsByName("complaint.status")[1].checked=false;
		}
		return result;
	}
	function cancelComplete(){
			document.getElementsByName("complaint.completedDatex")[0].value = '';
	}
	function validateStandards(){
		var result = false;
		var flag = document.getElementsByName("isStandards")[0].checked;
		if(flag == true){
			var chkList = document.getElementsByName("complaint.standards1");
			for(var i = 0; i < chkList.length; i++){
				if(chkList[i].checked == true){
					result = true;
					break;
				}
			}	
		}else{
			result = true;	
		}
		
		return result;
	}

	function setOutstanding(arg){
		//alert("Outstanding state="+arg);
	}
	
	function setStandard(obj){
		//alert(obj.checked);
		var jsReadOnly = false;
		if (document.forms[0].readOnly.value == 'true') {
			jsReadOnly = true;
		}
		var boxes = document.getElementsByName("complaint.standards1");
		
		for(var i = 0; i < boxes.length; i++ ){
			if(obj.checked == true && !jsReadOnly){
				boxes[i].disabled = false;
			}else{
				boxes[i].disabled = true;
			}
			
		}
	}
	function init() {
		var obj = document.getElementsByName("isStandards")[0];
		setStandard(obj);
	}
</script>

<html-el:form action="/PMmodule/QuatroComplaint.do">
	<input type="hidden" name="method" />
	<input type="hidden" name="clientId" value="<c:out value="${clientId}"/>" />
	<html-el:hidden property="complaint.clientId"  />
	<html-el:hidden property="complaint.id"  />
	<html-el:hidden property="complaint.createdDatex"  />
    <input type="hidden" name="scrollPosition" value='<c:out value="${scrPos}"/>' />
	<input type="hidden" name="readOnly" value='<c:out value="${isReadOnly}"/>' />

<%
		
	String length = request.getAttribute("ComplaintForm_length").toString();
	
 %>
	<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
		<tr>
			<th class="pageTitle" align="center">Client Management - Complaints</th>
		</tr>
		<tr>
			<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
		</tr>
		<tr>
			<td align="left" class="buttonBar2">
			<html:link	action="/PMmodule/QuatroComplaint.do" 	style="color:Navy;text-decoration:none;">
				<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;|</html:link>

					<c:if test="${!isReadOnly && (quatroClientComplaintForm.complaint.status=='0' || quatroClientComplaintForm.complaint.status==null)}">	
					<a href="javascript:void1();"  style="color:Navy;text-decoration:none;" onclick="javascript: setNoConfirm();return deferedSubmit('save');">
						<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save&nbsp;&nbsp;</a>
					</c:if>	
			</td>
		</tr>		
		<tr>
			<td align="left" class="message">
				<logic:messagesPresent
					message="true">
					<br />
					<html:messages id="message" message="true" bundle="pmm">
						<c:out escapeXml="false" value="${message}" />
					</html:messages>
					<br />
				</logic:messagesPresent>
			</td>
		</tr>
		<tr>
			<td height="100%">
			<div id="scrollBar"  onscroll="getDivPosition()"
				style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">

<!--  start of page content -->

			<table width="100%" class="edit">
				<tr>
					<td>
						<br />
						<div class="tabs">
							<table cellpadding="3" cellspacing="0" border="0">
								<tr>
									<th>Complainant</th>
								</tr>
							</table>
						</div>
					</td>
				</tr>

				<tr>
					<td>
						<table class="simple" cellspacing="2" cellpadding="3">
							<tr>
								<td width="18%">Source*</td>
								<td width="32%"><html-el:select
									property="complaint.source">
									<html-el:option value=""></html-el:option>
									<html-el:optionsCollection property="sources"
										value="code" label="description" />
								</html-el:select></td>
								<td width="18%">Method of Contact*</td>
								<td width="32%"><html-el:select
									property="complaint.method">
									<html-el:option value=""></html-el:option>
									<html-el:optionsCollection property="methods"
										value="code" label="description" />
								</html-el:select></td>
							</tr>
							<tr>
								<td>First Name*</td>
								<td><html-el:text property="complaint.firstname" maxlength="30" style="{width:96%;}" /></td>
								<td>Last Name*</td>
								<td><html-el:text property="complaint.lastname" maxlength="30" style="{width:96%;}" /></td>
							</tr>
								<tr>
									<td>Program*</td>
									<td colspan="3">
										<html:select property="complaint.programId"	name="quatroClientComplaintForm">
											<html-el:option value=""></html-el:option>
											<html:optionsCollection property="programs" value="code"
												label="description" />
										</html:select>
									</td>
								</tr>	
							
							
						</table>
					</td>
				</tr>
										
				<tr>
					<td><br>
						<div class="tabs">
							<table cellpadding="3" cellspacing="0" border="0">
								<tr>
									<th>Complaint Details</th>
								</tr>
							</table>
						</div>
					</td>
				</tr>

				<tr>
					<td>
						<table class="simple" cellspacing="2" cellpadding="3">
							<tr>
								<td colspan="2">Is complaint related to Toronto Shelter	Standards? 
									<html-el:checkbox name="quatroClientComplaintForm" property="isStandards"  onclick="setStandard(this)" />
								</td>
							</tr>
							<tr>
								<td colspan="2">If yes, Specify Complaints (Identify Section
								of Toronto Shelter Standards)</td>
							</tr>
	
	
							<tr>
								<td>
									<table width="100%">
									<c:forEach var="codeVal" items="${quatroClientComplaintForm.sections}" varStatus="index">
										<tr>
											<td>
												<logic:equal value="0" property="parentCode" name="codeVal">
													<b><c:out value="${codeVal.description}"></c:out></b>
												</logic:equal>
												<logic:notEqual value="0" property="parentCode"  name="codeVal">
														&nbsp;&nbsp;&nbsp;<html-el:multibox  property="complaint.standards1" value="${codeVal.code}" /><c:out value="${codeVal.description}" />
												</logic:notEqual>
											</td>
										</tr>
									<c:if test="${index.count==ComplaintForm_length}">
									</table>
								</td>
								<td>
									<table width="100%">
                                    </c:if>
									</c:forEach>
									</table>
								</td>
							<tr>
							
							
						</table>
					</td>
				</tr>

				<tr>
					<td><br>
						<div class="tabs">
							<table cellpadding="3" cellspacing="0" border="0">
								<tr>
									<th>Description of Complaint/Narrative*</th>
								</tr>
							</table>
						</div>
					</td>
				</tr>

				<tr>
					<td><html-el:textarea property="complaint.description" rows="10" style="width:500px;" ></html-el:textarea>
					</td>
				</tr>

				<tr>
					<td><br>
						<div class="tabs">
							<table cellpadding="3" cellspacing="0" border="0">
								<tr>
									<th>Outcome</th>
								</tr>
							</table>
						</div>
					</td>
				</tr>

				<tr>
					<td>
						<table class="simple" cellspacing="2" cellpadding="3">
							<tr>
								<td width="20%">Was the complainant satisfied with the outcome?*</td>
								<td width="30%"><html-el:select
									property="complaint.satisfiedWithOutcome">
									<html-el:option value=""></html-el:option>
									<html-el:optionsCollection property="outcomes"
										value="code" label="description" />
								</html-el:select></td>
								<td width="50%" colspan="2">Was Toronto Shelter Standards Breached?
									<html-el:radio property="complaint.standardsBreached" value="1">Yes</html-el:radio>
									<html-el:radio property="complaint.standardsBreached" value="0">No</html-el:radio>
								</td>
							</tr>
							<tr>
								<td colspan="4">Are There Outstanding Service System Issues?
									<font size="1">(Please specify below)</font><!-- 
									<input type="radio" name="OutstandingChk" onclick="setOutstanding('1')" value="1">Yes</input>
									<input type="radio" name="OutstandingChk" onclick="setOutstanding('0')" value="0">No</input>
									 -->
								</td>
															
							</tr>
							<div id="IssuesId">
								<tr>
									<td colspan="4">Specify Service System Issues:</td>
								</tr>
								<tr>
									<td colspan="4"><html-el:textarea style="width:500px;" rows="3"
										property="complaint.outstandingIssues" onkeyup="javascript:txtAreaLenChecker(this, 4000);"></html-el:textarea></td>
								</tr>
							</div>
	
							<tr>
								<td colspan="4">Complaint Status
									<html-el:radio property="complaint.status" value="1" onclick="javascript:confirmComplete();">Completed</html-el:radio>
									<html-el:radio property="complaint.status" value="0" onclick="javascript:cancelComplete();">In Progress</html-el:radio>
								</td>
								
							</tr>
	
							<tr>
								<td>Date Completed*</td>
								<td><quatro:datePickerTag property="complaint.completedDatex"
									width="70%" openerForm="quatroClientComplaintForm" onchange="javascript:confirmComplete();"/></td>
								<td>Time Spent on Complaint*</td>
								<td><html-el:text property="complaint.duration" maxlength="10"/> minutes</td>
							</tr>
							<tr><td colspan="4"><br /></td></tr>
							<tr>
								<td width="15%">Record Reviewed by (Person 1)</td>
								<td width="35%"><html-el:text property="complaint.person1" maxlength="60"/></td>
								<td width="15%">Record Reviewed by (Person 3)</td>
								<td width="35%"><html-el:text property="complaint.person3" maxlength="60"/></td>
							</tr>
	
							<tr>
								<td>Job Title</td>
								<td><html-el:text property="complaint.title1" maxlength="20"/></td>
								<td>Job Title</td>
								<td><html-el:text property="complaint.title3" maxlength="20"/></td>
							</tr>
	
							<tr>
								<td>Date Reviewed</td>
								<td><quatro:datePickerTag property="complaint.date1x"
									width="70%" openerForm="quatroClientComplaintForm" /></td>
								<td>Date Reviewed</td>
								<td><quatro:datePickerTag property="complaint.date3x"
									width="70%" openerForm="quatroClientComplaintForm" /></td>
							</tr>
	
							<tr>
								<td>Record Reviewed by (Person 2)</td>
								<td><html-el:text property="complaint.person2" maxlength="60"/></td>
								<td>Record Reviewed by (Person 4)</td>
								<td><html-el:text property="complaint.person4" maxlength="60"/></td>
							</tr>
	
							<tr>
								<td>Job Title</td>
								<td><html-el:text property="complaint.title2" maxlength="20"/></td>
								<td>Job Title</td>
								<td><html-el:text property="complaint.title4" maxlength="20"/></td>
							</tr>
	
							<tr>
								<td>Date Reviewed</td>
								<td><quatro:datePickerTag property="complaint.date2x"
									width="70%" openerForm="quatroClientComplaintForm" /></td>
								<td>Date Reviewed</td>
								<td><quatro:datePickerTag property="complaint.date4x"
									width="70%" openerForm="quatroClientComplaintForm" /></td>
							</tr>
	
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
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
