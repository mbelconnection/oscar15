<!-- 
/*
* 
* Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
* This software is published under the GPL GNU General Public License. 
* This program is free software; you can redistribute it and/or 
* modify it under the terms of the GNU General Public License 
* as published by the Free Software Foundation; either version 2 
* of the License, or (at your option) any later version. * 
* This program is distributed in the hope that it will be useful, 
* but WITHOUT ANY WARRANTY; without even the implied warranty of 
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
* GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
* along with this program; if not, write to the Free Software 
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
* 
* <OSCAR TEAM>
* 
* This software was written for 
* Centre for Research on Inner City Health, St. Michael's Hospital, 
* Toronto, Ontario, Canada  - UPDATED: Quatro Group 2008/2009
*/
 -->

<%@ include file="/taglibs.jsp"%>


<style>
	.non_sorted_header {
		color:black;
		background:white;
	}
</style>


<table width="100%" cellpadding="0px" cellspacing="0px" height="100%"
	border="0">
	<tr height="18px">
		<td align="left" class="buttonBar2">
			<html:link	action="/PMmodule/ProgramManager.do" style="color:Navy;text-decoration:none;">&nbsp;
			<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/Back16.png"/>" />&nbsp;Back to Programs&nbsp;&nbsp;</html:link>

<!-- 			<html:link
				href="javascript:submitForm('saveStaff');"
				style="color:Navy;text-decoration:none;">
				<img border="0" src="<html:rewrite page="/images/Save16.png"/>" />&nbsp;Save&nbsp;&nbsp;</html:link>
 -->
 			&nbsp;|&nbsp;<html:link
			href="javascript:searchStaff();"
			style="color:Navy;text-decoration:none;">
			<img border="0" src="<html:rewrite page="/images/search16.gif"/>" />&nbsp;Search&nbsp;&nbsp;</html:link>
			&nbsp;|&nbsp;<html:link
			href="javascript:resetForm();"
			style="color:Navy;text-decoration:none;">
			<img border="0" src="<html:rewrite page="/images/searchreset.gif"/>" />&nbsp;Reset&nbsp;&nbsp;</html:link>
		</td>
	</tr>
	<tr>
		<td>
			<logic:messagesPresent message="true">
				<br />
				<html:messages id="message" message="true" bundle="pmm">
					<c:out escapeXml="false" value="${message}" />
				</html:messages>
				<br />
			</logic:messagesPresent>
		</td>
	</tr>
	
	<tr>
		<td>			
			<div class="h4">
				<p></p>
				<h4>Search Staff by entering search criteria below</h4>
				<br />
			</div>
		</td>
	</tr>
	

	<tr>
		<td>
			<div class="axial">
				<table border="0" cellspacing="1" cellpadding="1" width="100%">
					<tr>
						<th width="20%" align="right">First Name:</th>
						<td align="left" width="80%"><html:text property="staffForm.firstName" size="20" maxlength="30"/></td>
					</tr>
					<tr>
						<th width="20%" align="right">Last Name:</th>
						<td align="left" width="80%"><html:text property="staffForm.lastName" size="20" maxlength="30"/></td>
					</tr>
					
				
				</table>
			</div>
			
			

		</td>
	</tr>

	<tr>
		<td height="100%">
		
		<div
			style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">
  
			 	
			<br /> 	
			<div class="tabs" id="tabs">
			<table cellpadding="3" cellspacing="0" border="0">
				<tr>
					<th title="Programs">Staff</th>
				</tr>
			</table>
			</div> 
			
			
			
			
			<display:table class="simple" cellspacing="2" cellpadding="3"
				id="pp" name="existStaffLst" export="false" pagesize="0"
				requestURI="/PMmodule/ProgramManagerView.do" >
				
				<display:setProperty name="paging.banner.placement" value="bottom" />
				<display:setProperty name="basic.msg.empty_list"
					value="No staff currently in place for this program." />
					
				<display:column sortable="true" title="User No" property="providerNo" sortProperty="providerNo"/>
				
				<display:column sortable="true" title="Name" property="providerName"/>
				
				<display:column sortable="true" title="Role" property="roleName_desc"/>
			
			</display:table>

<script>
	function resetForm() {
		document.getElementsByName("staffForm.firstName")[0].value = "";
		document.getElementsByName("staffForm.lastName")[0].value = "";
	}
	
	function searchStaff(){
		if (!trimInputBox()) return false;
		document.programManagerViewForm.action = document.programManagerViewForm.action + "?mthd=search";
		//alert(document.programManagerViewForm.action);
		document.programManagerViewForm.tab.value = "Staff";
		document.programManagerViewForm.submit();
	}
</script>