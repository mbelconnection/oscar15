<%@ include file="/taglibs.jsp" %>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro" %>
<%@page import="org.oscarehr.PMmodule.model.Admission"%>
<%@page import="java.util.Date"%>
<%@page import="org.oscarehr.PMmodule.model.Bed"%>
<%@page import="org.oscarehr.PMmodule.model.Room"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
 
<html-el:form action="/PMmodule/QuatroAdmission.do">
<input type="hidden" name="method"/>
<input type="hidden" name="pageChanged" id="pageChanged" value='<c:out value="${pageChanged}" />' />
<input type="hidden" name="isFamilyMember" value='<c:out value="${isFamilyMember}" />' />
<html:hidden property="admission.clientId"/>
<html:hidden property="admission.intakeId"/>
<html:hidden property="familyIntakeType"/>
<html:hidden property="intakeClientNum"/>
<html:hidden property="admission.id"/>
<html:hidden property="admission.programId"/>
<html:hidden property="admission.admissionDateTxt"/>
<html:hidden property="admission.admissionStatus"/>
<input type="hidden" id="scrollPosition" name="scrollPosition" value='<c:out value="${scrPos}"/>' />
<script lang="javascript">
function checkSignLinkVisibility(objSel) {
  if(objSel.value==''){
    var signLink = document.getElementById("signLink");
    signLink.style.visibility = 'visible';
  }else{
    var signLink = document.getElementById("signLink");
    signLink.style.visibility = 'hidden';
  } 
}

function submitForm(methodVal) {
	if(!isDateValid) return;
	trimInputBox();
	/*
	var ovPassStartDateTxt = document.getElementsByName("admission.ovPassStartDateTxt")[0];
	var ovPassEndDateTxt = document.getElementsByName("admission.ovPassEndDateTxt")[0];
	if(ovPassEndDateTxt.value!='')
	{
	  if(ovPassStartDateTxt.value=='') {
	      alert("Please input Overnight Pass start date.");
    	  ovPassStartDateTxt.focus();
      	  return;
      } else {
	    if(isBeforeToday(ovPassStartDateTxt.value)){
           alert("Overnight Pass start date must not be earlier than today.");
           ovPassStartDateTxt.focus();
           return;
	    }else if(!isBefore(ovPassStartDateTxt.value, ovPassEndDateTxt.value)){
           alert("Overnight Pass end date must be after start date.");
           ovPassEndDateTxt.focus();
           return;
	    }
	  }
	}
	*/
	if(methodVal=="save" && noChanges()){
		alert("There are no changes detected to save");
	}else{   
		document.getElementById("btnSave").disabled=true;
		document.forms[0].method.value = methodVal;
	    document.forms[0].submit();
	}
}  

function signSignature(){
   var url='<c:out value="${ctx}" />/topazGetImage.do?method=sign&' +
     "rid=<c:out value="${quatroClientAdmissionForm.admission.intakeId}" />" + 
     "&moduleName=admission";
   if(win!=null) win.close();
   document.forms[0].pageChanged.value="1";
   win = window.open(url,"_blank","toolbar=yes,menubar= yes,resizable=yes,scrollbars=yes,status=yes,width=520,height=320");
   win.focus();
}
function viewSignature(){
   var url='<c:out value="${ctx}" />/topazGetImage.do?' +
     "rid=<c:out value="${quatroClientAdmissionForm.admission.intakeId}" />" +"&moduleName=admission";

   if(win!=null) win.close();
   win = window.open(url,"_blank","toolbar=yes,menubar= yes,resizable=yes,scrollbars=yes,status=yes,width=400,height=200");
   win.focus();
}
function roomChanged()
{
	quatroClientAdmissionForm.method.value='roomchange';
	quatroClientAdmissionForm.pageChanged.value='1';
	setNoConfirm();
	quatroClientAdmissionForm.submit();
}
</script>
<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
	<tr>
		<th class="pageTitle" align="center">Client Management - Admission</th>
	</tr>
	<tr>	
		<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>	
	</tr>
	<tr>
		<td align="left" class="buttonBar2">
		<html:link action="/PMmodule/QuatroAdmission.do" name="actionParam" style="color:Navy;text-decoration:none;">
		<img border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;</html:link>
		<c:if test="${!isReadOnly &&(quatroClientAdmissionForm.admission.admissionStatus=='active' ||
		 quatroClientAdmissionForm.admission.admissionStatus=='admitted' || quatroClientAdmissionForm.admission.admissionStatus=='pending')}">		 
		<a id="btnSave" href="javascript:void1();" style="color:Navy;text-decoration:none;" onclick="javascript: setNoConfirm();return deferedSubmit('save');">
		<img border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save&nbsp;&nbsp;</a>|
        </c:if>       
        </td>
	</tr>
	<tr><td align="left" class="message">
      <logic:messagesPresent message="true">
        <html:messages id="message" message="true" bundle="pmm"><c:out escapeXml="false" value="${message}" />
        </html:messages> 
      </logic:messagesPresent>
	</td></tr>
	<tr>
		<td height="100%">
		<div id="scrollBar"  onscroll="getDivPosition()"
			style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;">

<!--  start of page content -->
<table width="100%" class="edit">
<tr><td><br>
<table class="simple" cellpadding="3" cellspacing="0" border="0">
<tr><th>Program</th>
<th>Admission Date</th>
<th>Status</th></tr>
<tr><td><c:out value="${quatroClientAdmissionForm.admission.programName}"/>
<html:hidden property="admission.programName" />
</td>
<td>
<c:if test="${quatroClientAdmissionForm.admission.admissionDateStr!=null && quatroClientAdmissionForm.admission.admissionStatus!='active'}">
<c:out value="${quatroClientAdmissionForm.admission.admissionDateStr}"/>
</c:if>
</td>
<td><c:out value="${quatroClientAdmissionForm.admission.admissionStatus}"/></td></tr>
</table></td></tr>

<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Admission Information</th></tr>
</table></div></td></tr>

<tr><td>
<table class="simple" cellspacing="2" cellpadding="3">
<td width="20%">Primary Worker</td>
<td width="30%">
<html:select property="admission.primaryWorker">
<html-el:optionsCollection property="providerList" value="providerNo" label="formattedName"/>
</html:select>
</td><td colspan="2"/></tr>
<tr><td>Locker#</td>
<td><html:text property="admission.lockerNo" maxlength="20"/></td>
<td># of Bags</td>
<td><html:text property="admission.noOfBags" maxlength="20" /></td></tr>
</table>
</td></tr>

<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Next of Kin</th></tr>
</table></div></td></tr>

<tr><td>
<table class="simple" cellspacing="2" cellpadding="3">
<tr><td width="10%">Name</td>
<td width="25%"><html:text property="admission.nextKinName" maxlength="60" /></td>
<td width="10%">Relationship</td>
<td width="20%"><html:text property="admission.nextKinRelationship" maxlength="20" /></td>
<td width="5%">Tel</td>
<td width="30%"><html:text property="admission.nextKinTelephone" style="width: 95%" maxlength="25" /></td></tr>
<tr><td>Street 1</td>
<td><html:text property="admission.nextKinNumber" maxlength="50" /></td>
<td>Street 2</td>
<td><html:text property="admission.nextKinStreet" style="width: 80%" maxlength="50" /></td>
<td>City</td>
<td>
	<html:text property="admission.nextKinCity" maxlength="20" /></td> </tr>
<tr>	<td>Province</td>
	<td><html:text property="admission.nextKinProvince" maxlength="20"></html:text>
	</td>
	<td>Postal Code</td>
	<td><html:text property="admission.nextKinPostal" style="width: 60%" maxlength="7" /></td>
<td>Country</td><td><html:text property="admission.nextKinCountry" style="width:100%" maxlength="50"/></td>
	</tr>
</table>
</td></tr>

<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Overnight Pass</th></tr>
</table></div></td></tr>

<tr><td>
<table class="simple" cellspacing="2" cellpadding="3">
<tr><td colspan="4">Overnight Pass</td>
<td>Issued By</td></tr>
<tr><td width="5%">Start</td>
<td width="20%">
<quatro:datePickerTag property="admission.ovPassStartDateTxt" width="80%" openerForm="quatroClientAdmissionForm" />
</td>
<td width="5%">End</td>
<td width="20%">
<quatro:datePickerTag property="admission.ovPassEndDateTxt" width="80%" openerForm="quatroClientAdmissionForm" />
</td>
<td width="50%"><c:out value="${issuedBy}" /></td></tr>
</table>
</td></tr>

<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Bed/Room*</th></tr>
</table></div></td></tr>

<tr><td>
<table class="simple" cellspacing="2" cellpadding="3">
	<tr><td width="16%">Assign Room*</td>
	<td>
	<c:choose>
	<c:when test="${quatroClientAdmissionForm.admission.admissionStatus=='active' ||
		 quatroClientAdmissionForm.admission.admissionStatus=='admitted'}">
	  <c:choose>
	    <c:when test="${quatroClientAdmissionForm.familyIntakeType!='Y'}">	 
	      <html:select property="roomDemographic.id.roomId" onchange="javascript: setNoConfirm();roomChanged();">
           <html-el:optionsCollection property="availableRooms" value="id" label="name" /> 
          </html:select>
          <html:hidden property="curDB_RoomId"/>
          <input type="hidden" name="prevDB_RoomId" value="<c:out value="${prevDB_RoomId}"/>">&nbsp;
          <c:out escapeXml="false" value="${properRoomMsg}"/>
        </c:when>
        <c:otherwise>
	      <html:select property="roomDemographic.id.roomId">
           <html-el:optionsCollection property="availableRooms" value="id" label="name" /> 
          </html:select>
          <html:hidden property="curDB_RoomId"/>
          <input type="hidden" name="prevDB_RoomId" value="<c:out value="${prevDB_RoomId}"/>">
          <c:out escapeXml="false" value="${properRoomMsg}"/>
        </c:otherwise>
      </c:choose>
    </c:when>
    <c:otherwise>
	      <c:out value="${historyRoomName}"/>
    </c:otherwise>
    </c:choose>          
	</td></tr>
<c:if test="${quatroClientAdmissionForm.familyIntakeType!='Y'}">	
	<c:choose>
	<c:when test="${quatroClientAdmissionForm.admission.admissionStatus=='active' ||
		 quatroClientAdmissionForm.admission.admissionStatus=='admitted'}">

	    <c:if test="${quatroClientAdmissionForm.availableBeds!=null}">
	      <tr><td>Assign Bed</td>
     	  <td><html:select property="roomDemographic.bedId">
              <html-el:optionsCollection property="availableBeds" value="id" label="name"/>
	        </html:select>
            <html:hidden property="curDB_BedId"/>
            <input type="hidden" name="roomAssignedBed" value="1">
	      </td></tr>
	   </c:if>
	   <c:if test="${quatroClientAdmissionForm.availableBeds==null}">
	      <tr><td></td>
     	  <td>Room capacity: <c:out value="${quatroClientAdmissionForm.curDB_RoomCapacity}"/>
            <input type="hidden" name="roomAssignedBed" value="0">
     	  </td></tr>
	   </c:if>
	  
    </c:when>
    <c:otherwise>
      <tr><td>Assign Bed</td><td><c:out value="${historyBedName}"/></td></tr>
    </c:otherwise>
    </c:choose>          
</c:if>
	</table>
</td></tr>

<tr><td align="center"><br>
<div id="signLink">
<c:choose>
<c:when test="${isFamilyMember=='N'}">
  <c:if test="${quatroClientAdmissionForm.admission.admissionStatus=='active' ||
    quatroClientAdmissionForm.admission.admissionStatus=='admitted'}">		 
  <a href="javascript:signSignature();" style="color:Navy;text-decoration:none;" onclick="javascript: setNoConfirm();">
   <img border=0 src=<html:rewrite page="/images/notepad.gif"/> />&nbsp;Sign&nbsp;&nbsp;</a>
  </c:if>
   <logic:greaterThan name="quatroClientAdmissionForm" property="admission.id" value="0">
     &nbsp;<a href="javascript:viewSignature();" style="color:Navy;text-decoration:none;" onclick="javascript: setNoConfirm();">
      <img border=0 src=<html:rewrite page="/images/search16.gif"/> />&nbsp;Preview Signature&nbsp;&nbsp;</a>
   </logic:greaterThan>
</c:when>
<c:otherwise>Signature: Refer to Family Head.</c:otherwise>
</c:choose>
</div><br>
<c:choose>
<c:when test="${isFamilyMember=='N'}">
Reason for not signing&nbsp;
<html-el:select property="admission.notSignReason" onchange="setNoConfirm();checkSignLinkVisibility(this);">
  <option value=""></option>
  <html-el:optionsCollection property="notSignReasonList" value="code" label="description"/>
</html-el:select>
</c:when>
<c:otherwise>
Reason for not signing&nbsp;
<html-el:select disabled="true" property="admission.notSignReason">
  <option value=""></option>
  <html-el:optionsCollection property="notSignReasonList" value="code" label="description"/>
</html-el:select>
</c:otherwise>
</c:choose>
<c:choose>
<c:when test="${quatroClientAdmissionForm.admission.notSignReason==null ||
         quatroClientAdmissionForm.admission.notSignReason==''}">
<script lang="javascript">
var signLink = document.getElementById("signLink");
signLink.style.visibility = 'visible';
</script>
</c:when>
<c:otherwise>
<script lang="javascript">
var signLink = document.getElementById("signLink");
signLink.style.visibility = 'hidden';
</script>
</c:otherwise>
</c:choose>
</td></tr>
<tr><td><br>
<b>Notice with Regard to the Collection of Personal Information:</b><br>
Personal information is collected under the legal authority of the City of Toronto Act, 1997, 
Municipal Act, 2001, Chapter 169, Article VII, By-law 112-2005 and Ontario Works Act, 1997, 
for the purposes of  administering Government of Ontario social assistance programs, 
providing shelter services and sharing information between shelter providers when 
specific consent is obtained.  Questions about this collection can be directed to the 
Administrative Supervisor, Shelter, Support and Housing Administration Division, 
Telephone no. 416-392-8741, Metro Hall, 55 John St. 6th Floor, Toronto, Ontario M5V 3C6.
</td></tr>

</table>

<!--  end of page content -->
</div>
</td>
</tr>
</table>
<%@ include file="/common/readonly.jsp" %>
</html-el:form>
