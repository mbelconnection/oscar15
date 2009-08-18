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


<table width="100%" cellpadding="0px" cellspacing="0px" height="100%"	border="0">
	<tr>
		<td align="left" class="buttonBar2">
			<a	href="javascript:clickTab('General');"	style="color:Navy;text-decoration:none;">
				<img border="0" src="<html:rewrite page="/images/close16.png"/>" />&nbsp;Close&nbsp;&nbsp;</a>		
			&nbsp;|&nbsp;<html:link	action="/PMmodule/ProgramManager.do"	style="color:Navy;text-decoration:none;">&nbsp;
				<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/Back16.png"/>" />&nbsp;Back to Programs&nbsp;
			</html:link>			
			<html:link href="javascript:searchStaff();"	style="color:Navy;text-decoration:none;">
				<img border="0" src="<html:rewrite page="/images/search16.gif"/>" />&nbsp;Search&nbsp;&nbsp;</html:link>
			<html:link href="javascript:resetForm();" 	style="color:Navy;text-decoration:none;">
				<img border="0" src="<html:rewrite page="/images/searchreset.gif"/>" />&nbsp;Reset&nbsp;&nbsp;</html:link>
		</td>
	</tr>
	<tr>
		<td><logic:messagesPresent message="true">			
			<html:messages id="message" message="true" bundle="pmm">
				<c:out escapeXml="false" value="${message}" />
			</html:messages>			
		</logic:messagesPresent></td>
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
		<table border="0" cellspacing="2" cellpadding="3">
			<tr>
				<th>First Name</th>
				<td><html:text property="view.staffForm.firstName" size="20" /></td>
			</tr>
			<tr>
				<th>Last Name</th>
				<td><html:text property="view.staffForm.lastName" size="20" /></td>
			</tr>


		</table>
		</div>



		</td>
	</tr>

	<tr>
		<td height="100%">
		<div style="color: Black; background-color: White; border-width: 1px; border-style: Ridge; height: 100%; width: 100%; overflow: auto;" id="scrollBar">
		<br />
		<div class="tabs" id="tabs">
		<table cellpadding="3" cellspacing="0" border="0">
			<tr>
				<th title="Programs">Staff</th>
			</tr>
		</table>
		</div>
		<display:table class="simple" cellspacing="2" cellpadding="3" id="pp"	name="existStaffLst" export="false" pagesize="0"	
			requestURI="/PMmodule/ProgramManager.do" defaultsort="2">

			<display:setProperty name="paging.banner.placement" value="bottom" />
			<display:setProperty name="basic.msg.empty_list" value="No staff currently in place for this program." />

			<display:column sortable="true" title="User No" property="providerNo" />

			<display:column sortable="true" title="Name" property="providerName" />

			<display:column sortable="true" title="Role" property="roleName_desc" />

		</display:table>
		<br />

		<logic:notEmpty name="newStaffLst">

			<table align="center" class="simple" width="100%">
				<thead>
					<tr>
						<th align="center"><b>Provider No.</b></th>
						<th align="center"><b>Name</b></th>
						<th align="center"><b>Role</b></th>
						<th align="center"><b></b></th>
					</tr>
				</thead>

				<logic:iterate id="pp" name="newStaffLst" indexId="rIndex">
					<input type="hidden" name="lineno"	value="<%=String.valueOf(rIndex)%>" />
					<tr>
						

						<td width="120px">
						<table cellpadding="0" style="border:0px;" cellspacing="0"	width="100%">
							<tr>
								<td style="border:0px;" width="120px">
									<input	style="width:100px;" type="text" name="providerNo<%=String.valueOf(rIndex)%>"
										value='<c:out value="${pp.providerNo}"/>' readonly>
								</td>
							</tr>
						</table>
						</td>
						<td width="250px">
						<table cellpadding="0" style="border:0px;" cellspacing="0"	width="100%">
							<tr>
								<td style="border:0px;" width="100%">
									<input	id="ORGfld<%=String.valueOf(rIndex)%>" style="width:100%;"	type="text" name="providerName<%=String.valueOf(rIndex)%>"
									value='<c:out value="${pp.providerName}"/>' readonly>
								</td>
								<td style="border:0px;" width="35px">
									<a	href="javascript:void();"	onclick="showLookup('USR', '', '', 'programManagerForm','providerNo<%=String.valueOf(rIndex)%>','providerName<%=String.valueOf(rIndex)%>', true, '<c:out value="${ctx}"/>');">
										<img	src="<c:out value="${ctx}"/>/images/microsoftsearch.gif" border="0"></a>
								</td>
							</tr>
						</table>
						</td>
						<td width="250px">
						<table cellpadding="0" style="border:0px;" cellspacing="0"	width="100%">
							<tr>
								<td style="border:0px;" width="1px">
									<input type="text"	style="width:1px;" name="role_code<%=String.valueOf(rIndex)%>"	value='<c:out value="${pp.roleName}"/>' readonly></td>
								<td style="border:0px;" width="100%">
									<input	style="width:100%;" type="text"	name="role_description<%=String.valueOf(rIndex)%>"
									value='<c:out value="${pp.roleName_desc}"/>' readonly></td>
								<td style="border:0px;" width="35px">
									<a	href="javascript:void();"	onclick="showLookup('ROL', '', '', 'programManagerForm','role_code<%=String.valueOf(rIndex)%>','role_description<%=String.valueOf(rIndex)%>', true, '<c:out value="${ctx}"/>');">
									<img src="<c:out value="${ctx}"/>/images/microsoftsearch.gif"	border="0"></a>
								</td>
							</tr>
						</table>
						</td>

						<td class="clsButtonBarText">&nbsp;&nbsp; 
							<logic:equal	value="0" name="rIndex">
								<a href="javascript:submitForm('saveStaff');" onclick="javascript: setNoConfirm();">Save</a>
						</logic:equal></td>
					</tr>
				</logic:iterate>
			</table>

		</logic:notEmpty></div>

		</td>
	</tr>
</table>
<script>
	function submitForm(mthd) {
		if (!trimInputBox()) return false;
		var flag = true;
		var form = document.programManagerForm; 
		if(mthd == "removeExistStaff"){
			flag = confirm('Do you really want to remove these records?');
		}
		if(flag){
			form.method.value=mthd;
			form.submit();
		}
		else
		{
			inRefreshing = false;
		}
	}
	
	function resetForm() {
		document.getElementsByName("view.staffForm.firstName")[0].value = "";
		document.getElementsByName("view.staffForm.lastName")[0].value = "";
	}
	
	function searchStaff(){
		if (!trimInputBox()) return false;
		document.forms[0].method.value = "edit";
		document.forms[0].mthd.value = "search";
		document.forms[0].elements["view.tab"].value = "Staff";
		document.forms[0].submit();
		
	
	}
</script>
