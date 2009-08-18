<%@ include file="/taglibs.jsp"%>
<%@page import="com.quatro.common.KeyConstants;" %>

<table width="100%" height="100%" cellpadding="0px" cellspacing="0px"
	border="0">
	<tr>
		<th class="pageTitle" align="center">Program Management - Search</th>
	</tr>
	<tr>
		<td align="left" class="buttonBar2">
			<html:link action="/Home.do" style="color:Navy;text-decoration:none;">&nbsp;
				<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/close16.png"/>" />&nbsp;Close&nbsp;|
			</html:link>			
			<security:oscarSec  objectName="<%=KeyConstants.FUN_PROGRAMEDIT %>"  rights="<%=KeyConstants.ACCESS_WRITE %>">
				<html:link	href="javascript:submitForm('add');"	style="color:Navy;text-decoration:none;">&nbsp;
					<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/New16.png"/>" />&nbsp;New Program&nbsp;|
				</html:link>
			</security:oscarSec>
			<html:link href="javascript:submitForm('list');"	style="color:Navy;text-decoration:none;">&nbsp;
				<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/search16.gif"/>" />&nbsp;Search&nbsp;|
			</html:link>
			<html:link href="javascript:resetForm();"	style="color:Navy;text-decoration:none;">&nbsp;
				<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/searchreset.gif"/>" />&nbsp;Reset&nbsp;</html:link>
		</td>
	</tr>
	<tr>
		<td>
			<logic:messagesPresent message="true">				
				<html:messages id="message" message="true" bundle="pmm">
					<c:out escapeXml="false" value="${message}" />
				</html:messages>				
			</logic:messagesPresent>
		</td>
	</tr>
	<tr>
		<td>


		<html:form action="/PMmodule/ProgramManager.do">
			<html:hidden property="method" />
			<div class="app">
			<table cellspacing="1" cellpadding="4" width="100%" bgcolor="#E8E8E8">
				<tr>
					<th align="left" width="20%">Status:</th>
					<th align="left" width="80%"><html:select property="searchStatus">
						<html:option value="">Any </html:option>
						<html:option value="1">Active</html:option>
						<html:option value="0">Inactive</html:option>
					</html:select></th>
				</tr>
				<tr>
					<th align="left" width="20%">Type:</th>
					<th align="left" width="80%"><html-el:select property="searchType">
						<html:option value="Any" />
						<c:forEach var="pt" items="${programTypeLst}">
							<html-el:option value="${pt.code}">
								<c:out value="${pt.description}" />
							</html-el:option>
						</c:forEach>
					</html-el:select></th>
				</tr>
				<tr>
					<th align="left" width="20%">Facility:</th>
					<th align="left" width="80%"><html-el:select property="searchFacilityId">
						<html-el:option value="0">Any</html-el:option>
						<c:forEach var="facility" items="${facilities}">
							<html-el:option value="${facility.id}">
								<c:out value="${facility.name}" />
							</html-el:option>
						</c:forEach>
					</html-el:select></th>
				</tr>

			</table>
			</div>
		<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form> <br />
		</td>
	</tr>
	<tr>
		<td>
		<!-- Page Content Start -->
			<div class="tabs" id="tabs">
			<table cellpadding="3" cellspacing="0" border="0">
				<tr>
					<th title="Programs">Programs</th>
				</tr>
			</table>
			</div>
		</td>
	</tr>
	<tr height="100%">
		<td>
   			<div style="color: Black; background-color: White; border-style: ridge; border-width: 1px; width: 100%; height: 100%; overflow: auto">
	
			<display:table class="simple" cellspacing="2" cellpadding="3"	id="program" name="programs" export="false" pagesize="0"
				requestURI="/PMmodule/ProgramManager.do">
				<display:setProperty name="paging.banner.placement" value="bottom" />
				<display:setProperty name="paging.banner.item_name" value="program" />
				<display:setProperty name="paging.banner.items_name" value="programs" />
				<display:setProperty name="basic.msg.empty_list" value="No programs found." />

				<display:column sortable="false" title="" style="width:8%">		
					<security:oscarSec  objectName="<%=KeyConstants.FUN_PROGRAMEDIT %>"  rights="<%=KeyConstants.ACCESS_READ %>">			
						<a	href="<html:rewrite action="/PMmodule/ProgramManager.do"/>?method=edit&programId=<c:out value="${program.id}" />">
							Edit </a>
					</security:oscarSec>		
				</display:column>
					
				<display:column sortable="true" title="Name" sortName="program" sortProperty="name"  style="width:24%">
					<a	href="<html:rewrite action="/PMmodule/ProgramManagerView.do"/>?programId=<c:out value="${program.id}" />">
					<c:out value="${program.name}" /> </a>
				</display:column>
				<display:column property="type" sortable="true" title="Type"  style="width:7%"/>
				<display:column sortable="true"	title="Status" sortName="program" sortProperty="programStatus"  style="width:7%">
					<c:if test="${program.programStatus == '1'}"> Active</c:if>
					<c:if test="${program.programStatus == '0'}"> Inactive</c:if>
				</display:column>
				<display:column property="facilityDesc" sortable="true" title="Facility"  style="width:16%"/>				
				<display:column sortable="true" title="Occupancy" sortName="program" sortProperty="numOfMembers"  style="{text-align:right}">
					<c:out value="${program.numOfMembers}" />
				</display:column>
				<display:column sortable="true" title="Queue" sortName="program" sortProperty="queueSize"  style="{text-align:right;width:7%}">
					<c:if test="${program.type == 'Bed'}">
						<c:out value="${program.queueSize}" />
					</c:if>
				</display:column>
				
				<display:column sortable="true" title="Capacity (actual)" sortName="program" sortProperty="capacity_actual"  style="{text-align:right;width:8%}">
					<c:out value="${program.capacity_actual}" />
				</display:column>
				<display:column sortable="true" title="Capacity (funding)" sortName="program" sortProperty="capacity_funding"  style="{text-align:right;width:8%}">
					<c:out value="${program.capacity_funding}" />
				</display:column>
				<display:column sortable="false" title="Vacancy"  style="{text-align:right;width:8%}">
					<c:if test="${program.type == 'Bed'}">
						<c:out value="${program.capacity_actual - program.numOfMembers}" />
					</c:if>
				</display:column>
			</display:table>  
			
			<script>
				function ConfirmDelete(name)
				{
					if(confirm("Are you sure you want to delete " + name + " ?")) {
						return true;
					}
					return false;
				}
				function submitForm(method)
				{
					if (!trimInputBox()) return false;
					document.programManagerForm.method.value=method;
					document.programManagerForm.submit()
				}
				function resetForm()
				{
					document.getElementsByName("searchStatus")[0].selectedIndex = 0;
					document.getElementsByName("searchType")[0].selectedIndex = 0;
					document.getElementsByName("searchFacilityId")[0].value="0";
					//document.programManagerForm.submit()
				}
				function init()
				{
					var form = document.forms[0];
					form.onkeypress=function() {keypress(event);}
				}
				function keypress(event)
				{
					var keynum;
					if(window.event) // IE
			  		{
			  			keynum = event.keyCode;
			  		}
					else if(event.which) // Netscape/Firefox/Opera
			  		{
			  			keynum = event.which;
			  		}
					if (keynum==13) submitForm('list');
					return true;
				}
			</script> 
		
		<!-- Page Content End -->

			</div>
		</td>
	</tr>
</table>

	