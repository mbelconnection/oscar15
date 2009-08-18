<!--
/*
 *
 * This software is published under the GPL GNU General Public License.
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version. *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *
 *
 * <OSCAR Service Group>
 */
-->
<%@ include file="/taglibs.jsp"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<script type="text/javascript">
<!--
function submitForm(func){
	var userIds = getUserIds();
	var siteIds = getSiteIds();
	if (userIds == "" && siteIds == "") {
			alert("Please select users/accounts you want to unlock/overwrite synchronize");
	}
	else
	{
		document.forms[0].method.value=func;
		document.forms[0].userId.value=userIds;
		document.forms[0].siteId.value=siteIds;
		document.forms[0].submit();
	}
}
function getUserIds()
{
		var userIds  = "";
		var elements = document.userUnlockForm.elements;
		for(var i=0;i<elements.length;i++) {
			if(elements[i].type == 'checkbox' && elements[i].name.substring(0,9) == 'checkedU_') {
				if(elements[i].checked == true) {
					var idx =elements[i].name.indexOf("_");
					var userId = elements[i].name.substring(idx+1);
					userIds +="," + userId;
				}
			}
		}		
		return userIds; 
}
function getSiteIds()
{
		var siteIds  = "";
		var elements = document.userUnlockForm.elements;
		for(var i=0;i<elements.length;i++) {
			if(elements[i].type == 'checkbox' && elements[i].name.substring(0,9) == 'checkedS_') {
				if(elements[i].checked == true) {
					var idx =elements[i].name.indexOf("_");
					var siteId = elements[i].name.substring(idx+1);
					siteIds +="," + siteId;
				}
			}
		}		
		return siteIds; 
}
//-->
</script>
<html:form action="/PMmodule/Admin/UnlockAccount.do"  method="post">
<html:hidden property="userId" styleId="userId"/>
<html:hidden property="siteId" styleId="siteId"/>
<input type="hidden" id="method" name="method" />
<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
	<tr>
		<th class="pageTitle" align="center"><span
			id="_ctl0_phBody_lblTitle" align="left">Unlock User Accounts</span></th>
	</tr>
	<tr height="18px">
		<td align="left" class="buttonBar2"><html:link
			action="/PMmodule/Admin/SysAdmin.do"
			style="color:Navy;text-decoration:none;">
			<img border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;|</html:link>
		    <security:oscarSec objectName="_admin.unlockUser" rights="w">
			<html:link href="javascript:submitForm('unlock');"
				style="color:Navy;text-decoration:none;">
				<img border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Unlock&nbsp;&nbsp;|</html:link>
			</security:oscarSec>
		</td>
	</tr>
	<logic:messagesPresent		message="true">
	<tr>
		<td align="left" class="message">
			<br />
			<html:messages id="message" message="true" bundle="pmm">
				<c:out escapeXml="false" value="${message}" />
			</html:messages>
		<br /></td>
	</tr>
	</logic:messagesPresent>
         <tr>
         	<th> Locked User Accounts</th>
         </tr>
       <tr>
           <td>
				<display:table class="simple" cellspacing="2" cellpadding="3" id="user" name="users" export="false" 
					pagesize="0" requestURI="/PMmodule/Admin/UnlockAccount.do">
					<display:setProperty name="paging.banner.placement" value="bottom" />
					<display:setProperty name="basic.msg.empty_list" value="No users are locked" />
					<display:column title="Select">
						<input type="checkbox" name='checkedU_<c:out value="${user.userName}"/>' />
					</display:column>
					<display:column property="userName" sortable="true" title="Login Id" />
					<display:column property="loginIP" sortable="true" title="Login from IP" />
					<display:column property="loginDate" sortable="true" title="Last Try Date"  format="{0, date, yyyy/MM/dd hh:mm:ss a}"/>
				</display:table>			
           </td>
         </tr>
        <tr><td>&nbsp</td></tr>
         <tr>
         	<th> Out of Sync Sites</th>
         </tr>
       <tr>
           <td>
				<display:table class="simple" cellspacing="2" cellpadding="3" id="site" name="sites" export="false" 
					pagesize="0" requestURI="/PMmodule/Admin/UnlockAccount.do">
					<display:setProperty name="paging.banner.placement" value="bottom" />
					<display:setProperty name="basic.msg.empty_list" value="No Sites are out of sync" />
					<display:column title="Select">
						<input type="checkbox" name='checkedS_<c:out value="${site.siteId}"/>' />
					</display:column>
					<display:column property="ip" sortable="true" title="IP" />
					<display:column property="siteId" sortable="true" title="Site Id" />
					<display:column property="siteKey" sortable="true" title="Site Key" />
					<display:column property="lastUpdateTime.time" sortable="true" title="Last Try Date"  format="{0, date, yyyy/MM/dd hh:mm:ss a}"/>
					<display:column property="times" sortable="true" title="Times Tried"/>
					<display:column property="statusDesc" sortable="true" title="Overridden" />
				</display:table>			
           </td>
         </tr>
        <tr height="100%"><td>&nbsp</td></tr>
   </table>
 <input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
