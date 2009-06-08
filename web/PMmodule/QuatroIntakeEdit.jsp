<%@ include file="/taglibs.jsp"%>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro"%>
<%@page import="com.quatro.common.KeyConstants;" %>
<%String a="debug"; %>

<c:set var="ctx" value="${pageContext.request.contextPath}"
	scope="request" />
<script type="text/javascript"
	src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>

<html-el:form action="/PMmodule/QuatroIntakeEdit.do">
	<input type="hidden" name="clientId" value="<c:out value="${clientId}" />" />
	<input type="hidden" name="intakeHeadId" value="<c:out value="${intakeHeadId}" />" />
	<input type="hidden" name="pageChanged" id="pageChanged" value='<c:out value="${pageChanged}" />' />
	<html:hidden property="intake.staffId" />
	<html:hidden property="intake.intakeStatus" />
	<html:hidden property="intake.clientId" />
	<html:hidden property="intake.id" />
	<html:hidden property="intake.createdOnTxt" />
	<html:hidden property="client.active" />
	<input type="hidden" name="referralId" value="<c:out value="${referralId}"/>" />
	<input type="hidden" name="fromManualReferralId" value="<c:out value="${fromManualReferralId}"/>" />
	<input type="hidden" name="method" />
	<input type="hidden" name="newClientChecked" value="<c:out value="${newClientChecked}" />" />
    <input type="hidden" id="scrollPosition" name="scrollPosition" value='<c:out value="${scrPos}"/>' />

<script lang="javascript">

function submitForm(methodVal) {
	trimInputBox();
	if(!isDateValid) return;
	if(methodVal=='programChange'){

	}
	else if (methodVal == 'queue') 
	{
		if (!noChanges())
		{
			if (!confirm("You have made changes to this form.\n Click on Cancel to be able to Save information or click OK to proceed without saving?")) return false;
			setNoConfirm();
		}
		if (!confirmActive()) return;
	}
	else
	{
      var obj = document.getElementsByName("client.firstName")[0];
      if(obj.value.trim()==""){
        alert("First name is empty.");
        obj.value="";
        obj.focus();
        return; 
      }
      if(!isName(obj.value.trim())){
        alert("First name contains illegal character!");
        obj.focus();
        return; 
      }
    
      obj = document.getElementsByName("client.lastName")[0];
      if(obj.value.trim()==""){
        alert("Last name is empty.");
        obj.value="";
        obj.focus();
        return; 
      }
      if(!isName(obj.value.trim())){
        alert("Last name contains illegal character!");
        obj.focus();
        return; 
      }
    
      obj = document.getElementsByName("client.sex")[0];
      if(obj !=null && obj.value.trim()==""){
        alert("Gender is empty.");
        obj.value="";
        obj.focus();
        return; 
      }

      obj = document.getElementsByName("dob")[0];
      if(obj!=null && obj.value.trim()==""){
        alert("Date of birth is empty.");
        obj.value="";
        obj.focus();
        return; 
      }

      if(validateBirthDay(obj.value)==false){
        obj.focus();
        return;
      }
    
      obj = document.getElementsByName("intake.livedBefore")[0];
      if(obj.value.trim()==""){
        alert("Lived the last 12 months is empty.");
        obj.focus();
        return; 
      }

      obj = document.getElementsByName("intake.programId")[0];
      if(obj.value.trim()==""){
        alert("No program selected.");
        obj.focus();
        return; 
      }
    }
	if(methodVal=="save" && noChanges())
	{
		alert("There are no changes detected to save");
	}
	else
	{
		document.getElementById("btnSave").disabled=true;
		var adm = document.getElementById("btnAdmission");
		if (adm) adm.disabled=true;
		var fam = document.getElementById("btnFamily");
		if (fam) fam.disabled=true;
		document.forms[0].method.value = methodVal;
		document.forms[0].submit();
	}
}


function checkExistClients(){
   var lastName = document.getElementsByName("client.lastName")[0];
   var firstName = document.getElementsByName("client.firstName")[0];
   var dob = document.getElementsByName("dob")[0];
   var sex = document.getElementsByName("client.sex")[0];
   var alias = document.getElementsByName("client.alias")[0];
   var url='<c:out value="${ctx}" />/PMmodule/DuplicateClientCheck.do?' +
     "var=quatroIntakeEditForm,client.firstName,client.lastName,client.sex,dob,client.alias,intake.clientId,statusMsg,newClientChecked" + 
     "&firstName=" + firstName.value + "&lastName=" + lastName.value + 
     "&dob=" + dob.value + "&sex=" + sex.value +
     "&alias=" + alias.value + "&shortFlag=N";
   win = window.open(url,"_blank","toolbar=yes,menubar= yes,resizable=yes,scrollbars=yes,status=yes,width=750,height=600");
   win.focus();
}

function confirmActive()
{
   	var isActive = document.getElementsByName("client.active")[0].value;
	if(isActive == "true"){
		var ans = confirm("The client is currently admitted in another program. If you admit the client now, this will cause an automatic discharge. Click OK to proceed?");
		return ans && isDateValid;
	}
	else
		return true;
}

</script>
	<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
		<tr>
			<th class="pageTitle" align="center">Client Management -
			Add/Edit Intake</th>
		</tr>
		<tr>			
			<td class="simple" style="background: lavender">
				<%@ include	file="ClientInfo.jsp"%></td>			
		</tr>
		<tr>
			<td align="left" class="buttonBar2">
			<html:link	action="/PMmodule/QuatroIntake.do" 	style="color:Navy;text-decoration:none;">&nbsp;
            <img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;|</html:link>

			<c:if	test="${!isReadOnly && (quatroIntakeEditForm.intake.intakeStatus=='active' ||
			 	quatroIntakeEditForm.intake.intakeStatus=='admitted')}">
				<a id="btnSave" href='javascript:void1();' onclick="javascript: setNoConfirm();return deferedSubmit('save');"	style="color:Navy;text-decoration:none;">&nbsp; 
					<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save&nbsp;&nbsp;|</a>
	         </c:if> 
	         <c:if	test="${quatroIntakeEditForm.intake.id!=0}">
				<c:if test="${quatroIntakeEditForm.intake.intakeStatus=='active' || intakeHeadId>0}">
	    	 			 <a	id="btnFamily" href="<c:out value="${ctx}"/>/PMmodule/QuatroFamilyIntake.do?intakeId=<c:out value="${quatroIntakeEditForm.intake.id}"/>&clientId=<c:out value="${clientId}"/>"
							style="color:Navy;text-decoration:none;" onclick="javascript: return isDateValid;"> 
							<img border=0	src=<html:rewrite page="/images/sel.gif"/> />&nbsp;Family Intake &nbsp;&nbsp;|</a>
				</c:if>
				
				<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTADMISSION %>"   orgCd='<%=((Integer) request.getAttribute("programId")).toString()%>' rights="<%=KeyConstants.ACCESS_WRITE %>">
					<c:if test="${admitable}">
               			<!--  a	onclick="javascript:return confirmActive()"; href="<c:out value="${ctx}"/>/PMmodule/QuatroAdmission.do?method=queue&clientId=<c:out value="${clientId}"/>&referralId=<c:out value="${referralId}"/>&programId=<c:out value="${programId}"/>"
									style="color:Navy;text-decoration:none;"> 
									<img border=0	src=<html:rewrite page="/images/sel.gif"/> />&nbsp;Admission&nbsp;&nbsp;|</a -->
					<a id="btnAdmission" href='javascript:void1();' onclick="javascript: return deferedSubmit('queue');"	style="color:Navy;text-decoration:none;">&nbsp; 
					<img border=0	src=<html:rewrite page="/images/sel.gif"/> />&nbsp;Admission&nbsp;&nbsp;|</a>
					</c:if>
				</security:oscarSec>
			</c:if></td>
		</tr>
		<tr>
			<td align="left" class="message">
			<logic:messagesPresent	message="true">
				<html:messages id="message" message="true" bundle="pmm">
					<c:out escapeXml="false" value="${message}" />
				</html:messages>
			</logic:messagesPresent></td>
		</tr>
		<tr>
			<td height="100%">
			<div id="scrollBar" onscroll="getDivPosition()"
				style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;"><!--  start of page content -->
			<table width="100%">
				<tr>
					<td>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>Personal information</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>

				<tr>
					<td>
					<table width="100%" class="simple">
						<tr>
							<td width="15%">First name*</td>
							<td width="35%"><html:hidden property="client.effDateTxt" />
							<html-el:text property="client.firstName" size="20"
								maxlength="25" /></td>
							<td width="19%">Last name*</td>
							<td width="31%"><html-el:text property="client.lastName" size="20"
								maxlength="25" /></td>
						</tr>
						<tr>
							<td>Gender*</td>
							<td>
							<c:choose>
								<c:when	 test="${!ageGenderReadOnly}">
									<html-el:select property="client.sex">
									<html-el:optionsCollection property="optionList.gender"
										value="value" label="label" />
								</html-el:select>
								</c:when>
								<c:otherwise>
									<html-el:text property="client.sexDesc" readonly="true" />
								</c:otherwise>
							</c:choose>
							</td>
							<td>Date of birth*<br>
							(yyyy/mm/dd)</td>
							<td>
							<c:choose>
								<c:when	 test="${!ageGenderReadOnly}">
									<quatro:datePickerTag property="dob" width="65%" openerForm="quatroIntakeEditForm">
									</quatro:datePickerTag>
								</c:when>
								<c:otherwise>
									<html-el:text property="dob" readonly="true" />									
								</c:otherwise>	
							</c:choose>	
							</td>
						</tr>
						<tr>
							<td>Alias</td>
							<td><html-el:text size="30" maxlength="30"
								property="client.alias" /></td>
							<td><c:if test="${newClientFlag=='true'}">
								<html:link href="javascript:checkExistClients();" onclick="javascript:setNoConfirm();"style="color:Navy;text-decoration:none;">
									<img border="0"	src="<html:rewrite page="/images/search16.gif"/>" />&nbsp;Check&nbsp;&nbsp;
								</html:link>
							</c:if></td>
							<td><c:choose>
								<c:when test="${quatroIntakeEditForm.client.demographicNo>0}">
									<input type="text" name="statusMsg" value="(existing client)"
										readonly="readonly" style="border: 0px">
								</c:when>
								<c:otherwise>
									<input type="text" name="statusMsg" readonly="readonly"
										value="(new client)" style="border: 0px">
								</c:otherwise>
							</c:choose></td>
						</tr>
					</table>
					</td>
				</tr>

				<tr>
					<td>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>Referred by</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>

				<tr>
					<td>
					<table width="100%" class="simple">
						<tr>
							<td width="20%">Referred by</td>
							<td width="80%"><html-el:select property="intake.referredBy">
								<html-el:optionsCollection property="optionList.referredBy"
									value="value" label="label" />
							</html-el:select></td>
						</tr>
						<tr>
							<td>Contact name</td>
							<td><html-el:text style="width: 50%"
								property="intake.contactName" maxlength="50" /></td>
						</tr>
						<tr>
							<td>Contact number</td>
							<td><html-el:text style="width: 35%"
								property="intake.contactNumber" maxlength="21" /></td>
						</tr>
						<tr>
							<td>Contact email</td>
							<td><html-el:text style="width: 50%"
								property="intake.contactEmail" maxlength="50" /></td>
						</tr>
					</table>
					</td>
				</tr>

				<tr>
					<td>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>Other information</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>

				<tr>
					<td>
					<table width="100%" class="simple">
						<tr>
							<td width="22%">Language</td>
							<td width="32%"><quatro:lookupTag name="quatroIntakeEditForm"
								tableName="LNG" formProperty="quatroIntakeEditForm" 
								codeProperty="language.code" bodyProperty="language.description" width="90%"
								codeWidth="1px" showCode="false" /></td>
							<td width="19%">Youth</td>
							<td width="27%"><html-el:select property="intake.youth">
								<html-el:option value=""></html-el:option>
								<html-el:option value="1">Yes</html-el:option>
								<html-el:option value="0">No</html-el:option>
							</html-el:select></td>
						</tr>
						<tr>
							<td>Aboriginal</td>
							<td><html-el:select property="intake.aboriginal">
								<html-el:optionsCollection property="optionList.aboriginal"
									value="value" label="label" />
							</html-el:select></td>
							<td>Aboriginal other</td>
							<td><html-el:text property="intake.aboriginalOther"
								maxlength="100" /></td>
						</tr>
						<tr>
							<td>VAW</td>
							<td><html-el:select property="intake.VAW">
								<html-el:option value=""></html-el:option>
								<html-el:option value="1">Yes</html-el:option>
								<html-el:option value="0">No</html-el:option>
							</html-el:select></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td>Current sleeping arrangements</td>
							<td cospan="2"><html-el:select
								property="intake.curSleepArrangement">
								<html-el:optionsCollection
									property="optionList.curSleepArrangement" value="value"
									label="label" />
							</html-el:select></td>
							<td></td>
						</tr>
						<tr>
							<td>Have you stayed in a shelter before?</td>
							<td><html-el:select property="intake.inShelterBefore">
								<html-el:option value=""></html-el:option>
								<html-el:option value="1">Yes</html-el:option>
								<html-el:option value="0">No</html-el:option>
							</html-el:select></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td>Reason for homelessness</td>
							<td><html-el:select
								property="intake.reasonForHomeless">
								<html-el:optionsCollection
									property="optionList.reasonForHomeless" value="value"
									label="label" />
							</html-el:select></td>
							<td>Length of homelessness</td>
							<td><html-el:select
								property="intake.lengthOfHomeless">
								<html-el:optionsCollection
									property="optionList.lengthOfHomeless" value="value"
									label="label" />
							</html-el:select></td>
						</tr>
						<tr>
							<td>Reason for Service</td>
							<td><html-el:select property="intake.reasonForService">
								<html-el:optionsCollection
									property="optionList.reasonForService" value="value"
									label="label" />
							</html-el:select></td>
							<td></td>
							<td></td>
						</tr>
					</table>
					</td>
				</tr>

				<tr>
					<td>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>Presenting issues</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>

				<tr>
					<td>
					<table width="100%" class="simple">
						<tr>
							<td width="15%"></td>
							<td width="20%"></td>
							<td width="15%"></td>
							<td width="35%"></td>
							<td></td>
						</tr>
						<tr>
							<td>Disability</td>
							<td colspan="2"><html-el:text style="width: 80%"
								property="intake.disability" maxlength="100" /></td>
							<td>Disclosed substance use</td>
							<td><html-el:checkbox property="intake.disclosedAbuse"
								value="1" /></td>
						</tr>
						<tr>
							<td>Pregnant</td>
							<td></td>
							<td><html-el:checkbox property="intake.pregnant" value="1" /></td>
							<td>Observed substance use</td>
							<td><html-el:checkbox property="intake.observedAbuse"
								value="1" /></td>
						</tr>
						<tr>
							<td colspan="2">Disclosed mental health issues</td>
							<td><html-el:checkbox property="intake.disclosedMentalIssue"
								value="1" /></td>
							<td>Poor hygiene</td>
							<td><html-el:checkbox property="intake.poorHygiene"
								value="1" /></td>
						</tr>
						<tr>
							<td colspan="2">Observed mental health issues</td>
							<td><html-el:checkbox property="intake.observedMentalIssue"
								value="1" /></td>
							<td>Disclosed alcohol use</td>
							<td><html-el:checkbox
								property="intake.disclosedAlcoholAbuse" value="1" /></td>
						</tr>
						<tr>
							<td colspan="2"></td>
							<td></td>
							<td>Observed alcohol use</td>
							<td><html-el:checkbox property="intake.observedAlcoholAbuse"
								value="1" /></td>
						</tr>
					</table>
					</td>
				</tr>

				<tr>
					<td>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>Identification</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>

				<tr>
					<td>
					<table width="100%" class="simple">
						<tr>
							<td width="30%">Birth Certificate</td>
							<td width="50%"><html-el:text
								property="intake.birthCertificate" size="14" maxlength="14" /></td>
							<td width="10%">On file?</td>
							<td width="10%"><html-el:checkbox
								property="intake.birthCertificateYN" value="1" /></td>
						</tr>
						<tr>
							<td>Social Insurance No.</td>
							<td><html-el:text property="intake.SIN" size="9"
								maxlength="9" /></td>
							<td>On file?</td>
							<td><html-el:checkbox property="intake.SINYN" value="1" /></td>
						</tr>
						<tr>
							<td>Health card No.</td>
							<td><html-el:text property="intake.healthCardNo" size="15"
								maxlength="12" /></td>
							<td>On file?</td>
							<td><html-el:checkbox property="intake.healthCardNoYN"
								value="1" /></td>
						</tr>
						<tr>
							<td>Driver's License No.</td>
							<td><html-el:text property="intake.driverLicenseNo"
								size="17" maxlength="20" /></td>
							<td>On file?</td>
							<td width="53"><html-el:checkbox
								property="intake.driverLicenseNoYN" value="1" /></td>
						</tr>
						<tr>
							<td>Canadian Citizenship Card</td>
							<td><html-el:text property="intake.citizenCardNo" size="7"
								maxlength="7" /></td>
							<td>On file?</td>
							<td><html-el:checkbox property="intake.citizenCardNoYN"
								value="1" /></td>
						</tr>
						<tr>
							<td>Native Status Card</td>
							<td><html-el:text property="intake.nativeReserveNo"
								size="20" maxlength="20" /></td>
							<td>On file?</td>
							<td><html-el:checkbox property="intake.nativeReserveNoYN"
								value="1" /></td>
						</tr>
						<tr>
							<td>Veteran No.</td>
							<td><html-el:text property="intake.veteranNo" size="20"
								maxlength="16" /></td>
							<td>On file?</td>
							<td><html-el:checkbox property="intake.veteranNoYN"
								value="1" /></td>
						</tr>
						<tr>
							<td>Record of Landing</td>
							<td><html-el:text property="intake.recordLanding" size="20"
								maxlength="16" /></td>
							<td>On file?</td>
							<td><html-el:checkbox property="intake.recordLandingYN"
								value="1" /></td>
						</tr>
						<tr>
							<td>Library Card</td>
							<td><html-el:text property="intake.libraryCard" size="20"
								maxlength="16" /></td>
							<td>On file?</td>
							<td><html-el:checkbox property="intake.libraryCardYN"
								value="1" /></td>
						</tr>
						<tr>
							<td>Other</td>
							<td><html-el:text property="intake.idOther" size="20"
								maxlength="16" /></td>
							<td></td>
							<td width="53"></td>
						</tr>
					</table>
					</td>
				</tr>

				<tr>
					<td>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>Additional information</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>

				<tr>
					<td>
					<table width="100%" class="simple">
						<tr>
							<td width="20%">Source of income</td>
							<td width="35%"><c:forEach var="sIncome"
								items="${quatroIntakeEditForm.optionList.sourceIncome}">
								<html-el:multibox property="intake.sourceIncome"
									value="${sIncome.value}" />
								<c:out value="${sIncome.label}" />
								<br />
							</c:forEach></td>
							<td width="8%">Other</td>
							<td width="37%"><html-el:text property="intake.income"
								size="20" maxlength="30" /></td>
						</tr>
						<tr>
							<td>Name and contact information for income worker (if
							applicable)</td>
							<td colspan="3">
							<table style="background-color:#e0e0e0;" width="100%"
								cellpadding="1" cellspacing="1">
								<tr>
									<td width="9%">Name:</td>
									<td width="39%"><html-el:text style="width: 95%"
										property="intake.incomeWorkerName1" maxlength="30" /></td>
									<td width="10%">Phone:</td>
									<td width="42%"><html-el:text style="width: 95%"
										property="intake.incomeWorkerPhone1" maxlength="21" /></td>
								</tr>
								<tr>
									<td></td>
									<td></td>
									<td>Email:</td>
									<td><html-el:text style="width: 95%"
										property="intake.incomeWorkerEmail1" maxlength="30" /></td>
								</tr>
								<tr>
									<td>Name:</td>
									<td><html-el:text style="width: 95%"
										property="intake.incomeWorkerName2" maxlength="30" /></td>
									<td>Phone:</td>
									<td><html-el:text style="width: 95%"
										property="intake.incomeWorkerPhone2" maxlength="21" /></td>
								</tr>
								<tr>
									<td></td>
									<td></td>
									<td>Email:</td>
									<td><html-el:text style="width: 95%"
										property="intake.incomeWorkerEmail2" maxlength="30" /></td>
								</tr>
								<tr>
									<td>Name:</td>
									<td><html-el:text style="width: 95%"
										property="intake.incomeWorkerName3" maxlength="30" /></td>
									<td>Phone:</td>
									<td><html-el:text style="width: 95%"
										property="intake.incomeWorkerPhone3" maxlength="21" /></td>
								</tr>
								<tr>
									<td></td>
									<td></td>
									<td>Email:</td>
									<td><html-el:text style="width: 95%"
										property="intake.incomeWorkerEmail3" maxlength="30" /></td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td>Lived the last 12 months*</td>
							<td><html-el:select property="intake.livedBefore">
								<html-el:optionsCollection property="optionList.livedBefore"
									value="value" label="label" />
							</html-el:select></td>
							<td>Other</td>
							<td><html-el:text property="intake.livedBeforeOther"
								size="20" maxlength="30" /></td>
						</tr>
						<tr>
							<td>Status in Canada</td>
							<td><html-el:select property="intake.statusInCanada">
								<html-el:optionsCollection property="optionList.statusInCanada"
									value="value" label="label" />
							</html-el:select></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td>Country of origin</td>
							<td><quatro:lookupTag name="quatroIntakeEditForm" tableName="CNT"
								formProperty="quatroIntakeEditForm" codeProperty="originalCountry.code"
								bodyProperty="originalCountry.description" width="90%" codeWidth="1px"
								showCode="false" /></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td>Referred to</td>
							<td><html-el:select property="intake.referredTo">
								<html-el:optionsCollection property="optionList.referredTo"
									value="value" label="label" />
							</html-el:select></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td>Reason for non-admittance</td>
							<td><html-el:select property="intake.reasonNoAdmit">
								<html-el:optionsCollection property="optionList.reasonNoAdmit"
									value="value" label="label" />
							</html-el:select></td>
							<td></td>
							<td></td>
						</tr>
					</table>
					</td>
				</tr>

				<tr>
					<td>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>Program</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>

				<tr>
					<td>
					<table width="100%" class="simple">
						<tr>
							<td width="20%">Program*</td>
							<td width="30%">
							<c:choose>
							<c:when test="${programEditable ne true}">
							<html-el:hidden	property="intake.currentProgramId" /> 
								<html-el:select	property="intake.programId" disabled="true">
								<option value=""></option>
								<html-el:optionsCollection property="programList" value="value"
									label="label" />
							</html-el:select>
							</c:when>
							<c:otherwise>
							<html-el:hidden	property="intake.currentProgramId" /> 
								<html-el:select	property="intake.programId" onchange="setNoConfirm();submitForm('programChange')">
								<option value=""></option>
								<html-el:optionsCollection property="programList" value="value"
									label="label" />
							</html-el:select>
							</c:otherwise>
							</c:choose>
							</td>
							<td width="25%">Service Program End Date</td>
							<td width="25%"><quatro:datePickerTag
								property="intake.endDateTxt" openerForm="quatroIntakeEditForm">
							</quatro:datePickerTag></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							</td>
							<td width="25%">Service Program Never Expires</td>
							<td width="25%">
								<html-el:checkbox property="intake.nerverExpiry"
								value="1" />
								</td>
						</tr>
					</table>
					</td>
				</tr>

				<tr>
					<td>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>Comments/Details</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>

				<tr>
					<td>
					<table width="100%" class="simple">
						<tr>
							<td width="15%">Comments/Details</td>
							<td width="85%"><html-el:textarea property="intake.comments" 
								rows="6" style="width:90%" /></td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>OW/ODSP Status</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>

				<tr>
					<td>
					<table width="100%" class="simple">
						<tr>
							<td width="25%">Benefit Unit Status</td>
							<td width="75%">
							<html-el:text style="width: 80%"
										property="intake.sdmtBenUnitStatus" readonly="true" /></td>
						</tr>
						<tr>
							<td width="25%">Last Benefit Month of OW</td>
							<td width="75%">
							<html-el:text style="width: 80%"
										property="intake.sdmtLastBenMonth" readonly="true" /></td>
						</tr>
						<tr>
							<td width="25%">Office</td>
							<td width="75%">
							<html-el:text style="width: 80%"
										property="intake.sdmtOffice" readonly="true" /></td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td>
					<div class="tabs">
					<table cellpadding="3" cellspacing="0" border="0">
						<tr>
							<th>Intake Status</th>
						</tr>
					</table>
					</div>
					</td>
				</tr>
				<tr>
					<td>
						<table  class="simple">
						<tr>
							<td width="15%">Intake Status</td>
							<td width="15%">
							<html-el:text style="width: 90%"
										property="intake.intakeStatus" readonly="true" /></td>
										<td width="15%">Last updated by</td>
							<td width="15%">
							<html-el:text style="width: 90%"
										property="intake.staffDesc" readonly="true" /></td>
							<td width="15%">Last updated date</td>
							<td width="15%">
							<html-el:text style="width: 90%"
										property="intake.lastUpdateDateTxt" readonly="true" />
							</td>			
						</tr>
						</table>				
						
					</td>
				</tr>
				<tr><td>
					<table  class="Simple" width="100%">
						<tr>
							<td width="15%">Rejection Reason</td>
							<td width="30%">
								<html-el:text style="width: 90%"
										property="intake.rejectionReasonDesc" readonly="true" />
							</td>
						
							<td width="15%">Rejection Note</td>
							<td >
								<html-el:text  style="width: 90%"
										property="intake.completionNotes"  readonly="true" />
							</td>	
						</tr>
					</table>
					
				</td></tr>
					
			</table>
						
			<!--  end of page content --></div>
			</td>
		</tr>
	</table>
	<%@ include file="/common/readonly.jsp" %>
</html-el:form>
