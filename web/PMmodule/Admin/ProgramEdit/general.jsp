<!-- 

Source:web/PMmodule/Admin/ProgramEdit/general.jsp 

-->

<%@page import="org.oscarehr.PMmodule.model.Program"%>
<%@page import="com.quatro.common.KeyConstants;"%>


<script type="text/javascript">
<!--
	function save() {
	    trimInputBox();
		if(noChanges()) {
			alert("There are no changes detected");
			return false;
		}
		var obj1 = document.getElementsByName('program.capacity_funding')[0];
		var obj2 = document.getElementsByName('program.capacity_space')[0];
		var obj3 = document.getElementsByName('program.ageMin')[0];
		var obj4 = document.getElementsByName('program.ageMax')[0];
		var obj5 = document.getElementsByName('program.name')[0];
		var obj6 = document.getElementsByName('program.manOrWoman')[0];
		var obj7 = document.getElementsByName('program.type')[0];		
		var obj8 = document.getElementsByName('programManagerForm_program.facilityId')[0];		
		if(obj8 == null) obj8 = document.getElementsByName('program.facilityId')[0];
		obj5.value = trim(obj5.value);
			
		if(obj8 != null && obj8.value == '') {
			alert('Facility can not be blank.');
		}else if(obj5.value == null || obj5.value == '') {
			alert('The program name can not be blank.');
		} else if(obj7.value == null || obj7.value == '') {
			alert('The program type can not be blank.');
		}else if(!isNumberInRange(obj1, 0, 'unlimit', 'Funding Capacity')){
			//alert('1');
			
		}else if(!isNumberInRange(obj2, 0, 'unlimit', 'Space Capacity')){
			//alert('2');
			
		} else if(obj6.value == null || obj6.value == '') {
			alert('The program Male/Female can not be blank.');
			obj6.focus();
		}else if(!isNumberInRange(obj3, 0, 100, 'Minimum Age')){
			//alert('3');
			
		}else if( !isNumberInRange(obj4, 0, 100, 'Maximum Age')){
			//alert('4');
			
		}else if(!compareNumber(obj3.value, obj4.value, 'Maximum Age field must be greater or equal to Minimum Age field.')){
			//alert('5');
			
		}else{
		  var obj9 = document.getElementsByName('program.programStatus')[0];
		  if(obj9.value=='0'){
            if(!confirm("You are going to deactivate this program. Select Ok to proceed or Cancel to cancel."))
            return false;
		  }

			document.programManagerForm.method.value="save";
			document.programManagerForm.submit();
		}
		return false;
	}
	
	function getProgramSignatures(id) {
	    if (id==null || id == "") return;
		var url = '<html:rewrite action="/PMmodule/ProgramManager.do"/>?method=programSignatures&programId=';
		window.open(url + id, 'signature', 'width=600,height=600,scrollbars=1');
	}
	
	function compareNumber(small, big, errorMsg){


		if( parseInt(small) > parseInt(big)){
			alert(errorMsg);
			return false;
		}
		return true;
	}
	
	function isNumberInRange(obj, min, max, fldName){
		//alert("isNumberInRange");
		var num = obj.value;
		//alert(fldName + ":" +num + ":" +min+":"+max);

		if(isNaN(num)){
	        alert(fldName + " field must be digital characters");
			return false;
		}  
	
		if(num < min ){
	        alert( fldName + " field must be greater than " + min );
	        return false;
	    }
	    if(max !== "unlimit" && num > max ){
	        alert( fldName + " field must be less than " + max );
	        return false;
	    }
	    return true;
	}
	// trim leading and ending spaces
	function trim (str) {
		var	str = str.replace(/^\s\s*/, ''),
			ws = /\s/,
			i = str.length;
		while (ws.test(str.charAt(--i)));
		return str.slice(0, i + 1);
	}

//-->
</script>
			
			
			
			
<%@ include file="/taglibs.jsp"%>




<table width="100%" cellpadding="0px" cellspacing="0px" height="100%"
	border="0">
	<!-- submenu -->
	<tr>
		<td align="left" class="buttonBar2">
			<html:link	action="/PMmodule/ProgramManager.do"	style="color:Navy;text-decoration:none;">
			<img border="0" src="<html:rewrite page="/images/close16.png"/>" />&nbsp;Close &nbsp;&nbsp;</html:link>
			<c:if test="${!isReadOnly}">
				<html:link href="javascript:void1();" style="color:Navy;text-decoration:none;" onclick="javascript: setNoConfirm();return save();">
				<img border="0" src="<html:rewrite page="/images/Save16.png"/>" />&nbsp;Save&nbsp;&nbsp;</html:link>
			</c:if>
		</td>
	</tr>

	<!-- messages -->
	<tr>
		<td align="left" class="message">
			<logic:messagesPresent message="true">			
				<html:messages id="message" message="true" bundle="pmm">
					<c:out escapeXml="false" value="${message}" />
				</html:messages>
			</logic:messagesPresent>
		</td>
	</tr>
	
	<tr>
		<td height="100%">
		<div style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">

		<!-- Page Content Start --> 
		
			<br />
			<div class="tabs">
				<table cellpadding="3" cellspacing="0" border="0">
					<tr>
						<th title="sinatures">General Information</th>
					</tr>
				</table>
			</div>

			<table width="100%" border="1" cellspacing="2" cellpadding="3">
				<tr class="b">
					<td width="20%">Name</td>
					<td><html:text property="program.name" size="30"	maxlength="70" /></td>
				</tr>
				<tr class="b">
					<td width="20%">Facility</td>
					<td>
					<security:oscarSec objectName="<%=KeyConstants.FUN_PROGRAMEDIT%>"   rights="<%=KeyConstants.ACCESS_WRITE%>" orgCd="<%=KeyConstants.ORG_ROOT%>">
						<quatro:lookupTag tableName="FAC" name="programManagerForm" formProperty="programManagerForm" bodyProperty="program.facilityDesc" codeProperty="program.facilityId" showCode="false"></quatro:lookupTag>
					</security:oscarSec>
					<security:oscarSec objectName="<%=KeyConstants.FUN_PROGRAMEDIT%>"  rights="<%=KeyConstants.ACCESS_WRITE%>" orgCd="<%=KeyConstants.ORG_ROOT%>" reverse="true">
						<html:hidden property="program.facilityId"/>
						<bean:write property="program.facilityDesc" name="programManagerForm"/>
					</security:oscarSec>
					</td>
				</tr>
				<tr class="b">
					<td width="20%">Description</td>
					<td><html:text property="program.descr" size="80" maxlength="255" /></td>
				</tr>
				<tr class="b">
					<td width="20%">Phone</td>
					<td><html:text property="program.phone" size="25" maxlength="22"/></td>
				</tr>
				<tr class="b">
					<td width="20%">Health Information Custodian</td>
					<td><html:checkbox property="program.hic" /></td>
				</tr>
				
				<tr class="b">
					<td width="20%">Type</td>
					<td>
					<security:oscarSec objectName="<%=KeyConstants.FUN_PROGRAMEDIT%>"   rights="<%=KeyConstants.ACCESS_WRITE%>" orgCd="<%=KeyConstants.ORG_ROOT%>" reverse="true">
					<html:hidden property="program.type" /> 
					<html-el:select property="program.type"  disabled="true">
						<html-el:option value="">
						</html-el:option>
						<c:forEach var="pt" items="${programTypeLst}">
							<html-el:option value="${pt.code}">
								<c:out value="${pt.description}" />
							</html-el:option>
						</c:forEach>
					</html-el:select>
					</security:oscarSec>
					<security:oscarSec objectName="<%=KeyConstants.FUN_PROGRAMEDIT%>"   rights="<%=KeyConstants.ACCESS_WRITE%>" orgCd="<%=KeyConstants.ORG_ROOT%>">
					<html-el:select property="program.type">
						<html-el:option value="">
						</html-el:option>
						<c:forEach var="pt" items="${programTypeLst}">
							<html-el:option value="${pt.code}">
								<c:out value="${pt.description}" />
							</html-el:option>
						</c:forEach>
					</html-el:select>
					</security:oscarSec>
					</td>
				</tr>
				<tr class="b">
					<td width="20%">Status</td>
					<td>
					<security:oscarSec objectName="<%=KeyConstants.FUN_PROGRAMEDIT%>"   rights="<%=KeyConstants.ACCESS_WRITE%>" orgCd="<%=KeyConstants.ORG_ROOT%>" reverse="true">
					<html:hidden property="program.programStatus"/>
					<html:select property="program.programStatus" disabled="true">
						<html:option value="1"> Active</html:option>
						<html:option value="0"> Inactive</html:option>
					</html:select>
					</security:oscarSec>
					<security:oscarSec objectName="<%=KeyConstants.FUN_PROGRAMEDIT%>"   rights="<%=KeyConstants.ACCESS_WRITE%>" orgCd="<%=KeyConstants.ORG_ROOT%>">
						<html:select property="program.programStatus">
						<html:option value="1"> Active</html:option>
						<html:option value="0"> Inactive</html:option>
					</html:select>
					</security:oscarSec>
					</td>
				</tr>
				
				<tr class="b">
					<td width="20%">Space Capacity</td>
					<td><html:text property="program.capacity_space" size="8"	maxlength="8"  /></td>
				</tr>
				<tr class="b">
					<td width="20%">Funding Capacity</td>
					<td><html:text property="program.capacity_funding" size="8"		maxlength="8"  /></td>
				</tr>
				<logic-el:present property="removethe2boxes" name="programManagerForm">
				<tr class="b">
					<td width="20%">Allow Batch Admissions</td>
					<td><html:checkbox property="program.allowBatchAdmission" /></td>
				</tr>
				<tr class="b">
					<td width="20%">Allow Batch Discharges</td>
					<td><html:checkbox property="program.allowBatchDischarge" /></td>
				</tr>
				</logic-el:present>
				<tr class="b">
					<td width="20%">Male/Female</td>
					<td><html-el:select property="program.manOrWoman">
							<html-el:option value="">
								
							</html-el:option>
						<c:forEach var="gen" items="${genderLst}">
							<html-el:option value="${gen.code}">
								<c:out value="${gen.buf1}" />
							</html-el:option>
						</c:forEach>
					</html-el:select></td>
					
				</tr>
				<logic-el:present property="removetheboxe" name="programManagerForm">
				<tr class="b">
					<td width="20%">Bed Program Affiliated</td>
					<td><html:checkbox property="program.bedProgramAffiliated" /></td>
				</tr>
				</logic-el:present>
				<tr class="b">
					<td width="20%">Minimum Age (inclusive)</td>
					<td><html:text property="program.ageMin" size="8"
						maxlength="3"  /></td>
				</tr>
				<tr class="b">
					<td width="20%">Maximum Age (inclusive)</td>
					<td><html:text property="program.ageMax" size="8"
						maxlength="3" /></td>
				</tr>

			</table>

			</br>

<!-- Signature part
			<div class="tabs">
				<table cellpadding="3" cellspacing="0" border="0">
					<tr>
						<th title="sinatures">Signature</th>
					</tr>
				</table>
			</div>


			<table width="100%" border="1" cellspacing="2" cellpadding="3">
				<tr class="b">
					<td></td>
					<td>User</td>
					<td>Date</td>
				</tr>
				<logic:iterate id="ps" name="programSignatureLst" indexId="index">
					<tr class="b">
						<td><@%=String.valueOf(index + 1)%></td>
						<td><c:out value="${ps.providerName}" /></td>
						<td><c:out value="${ps.updateDateStr}" /></td>
					</tr>
				</logic:iterate>

			</table>
 -->
 		
		</div>



	<%
 		Program p = (Program) request.getAttribute("oldProgram");
 	%> 
 	<input type="hidden" name="old_maxAllowed" value=<%if(p!=null) { %>	"<%=p.getMaxAllowed() %>" <%}else{ %> "0" <%} %> /> 
	<input type="hidden" name="old_name" value=<%if(p!=null) { %> "<%=p.getName()%>" <%}else{ %> "" <%} %> /> 
	<input type="hidden"	name="old_descr" value=<%if(p!=null) { %> "<%=p.getDescr()%>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_type" value=<%if(p!=null) { %> "<%=p.getType()%>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_address" value=<%if(p!=null) { %> "<%=p.getAddress()%>"<%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_phone" value=<%if(p!=null) { %>	"<%=p.getPhone()%>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_fax" value=<%if(p!=null) { %> "<%=p.getFax() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_url" value=<%if(p!=null) { %> "<%=p.getUrl()%>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_email" value=<%if(p!=null) { %>	"<%=p.getEmail()%>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_emergencyNumber" value=<%if(p!=null) { %> "<%=p.getEmergencyNumber()%>"<%}else{ %> "" <%} %> /> 
	<input	type="hidden" name="old_location" value=<%if(p!=null) { %>	"<%=p.getLocation()%>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_programStatus" value=<%if(p!=null) { %>	"<%=p.getProgramStatus()%>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_bedProgramLinkId" value=<%if(p!=null) { %> "<%=p.getBedProgramLinkId()%>" <%}else{ %> "0" <%} %> />
	<input type="hidden" name="old_manOrWoman" value=<%if(p!=null) { %>	"<%=p.getManOrWoman() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_abstinenceSupport" value=<%if(p!=null) { %>	"<%=p.getAbstinenceSupport() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_exclusiveView" value=<%if(p!=null) { %> "<%=p.getExclusiveView() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_holdingTank" value=<%if(p!=null) { %> "<%=p.isHoldingTank() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_allowBatchAdmission" value=<%if(p!=null) { %> "<%=p.isAllowBatchAdmission() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_allowBatchDischarge" value=<%if(p!=null) { %> "<%=p.isAllowBatchDischarge() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_hic" value=<%if(p!=null) { %> "<%=p.isHic() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_transgender" value=<%if(p!=null) { %> "<%=p.isTransgender() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_firstNation" value=<%if(p!=null) { %> "<%=p.isFirstNation() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_bedProgramAffiliated" value=<%if(p!=null) { %> "<%=p.isBedProgramAffiliated() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_alcohol" value=<%if(p!=null) { %> "<%=p.isAlcohol()%>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_physicalHealth" value=<%if(p!=null) { %>	"<%=p.isPhysicalHealth() %>" <%}else{ %> "" <%} %> /> 
	<input	type="hidden" name="old_mentalHealth" value=<%if(p!=null) { %>	"<%=p.isMentalHealth() %>" <%}else{ %> "" <%} %> /> 
	<input	type="hidden" name="old_facility_id" value=<%if(p!=null) { %>	"<%=p.getFacilityId() %>" <%}else{ %> "" <%} %> /> 
	<input	type="hidden" name="old_housing" value=<%if(p!=null) { %>	"<%=p.isHousing() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_ageMax" value=<%if(p!=null) { %>	"<%=p.getAgeMax() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_ageMin" value=<%if(p!=null) { %>	"<%=p.getAgeMin() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_capacity_funding" value=<%if(p!=null) { %>	"<%=p.getCapacity_funding() %>" <%}else{ %> "" <%} %> /> 
	<input type="hidden" name="old_capacity_space" value=<%if(p!=null) { %> 	"<%=p.getCapacity_space() %>" <%}else{ %> "" <%} %> /> 
		
			<!-- Page Content End -->
		</td>
	</tr>

</table>
<%@ include file="/common/readonly.jsp" %>


