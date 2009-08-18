<!-- 

Source:web/PMmodule/Admin/ProgramEdit/service_restrictions.jsp 

-->

<%@ include file="/taglibs.jsp" %>
<%@ page import="org.oscarehr.PMmodule.model.ProgramClientRestriction" %>
<%@ page import="org.oscarehr.PMmodule.model.Provider" %>
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
* Toronto, Ontario, Canada
*/
-->

<%@ include file="/taglibs.jsp"%>
<script>
	function submitForm(){
     	if (!trimInputBox()) return false;
		var maxDays = document.programManagerForm.elements['program.maximumServiceRestrictionDays'];
		if("" != maxDays.value) {
			if(isNaN(maxDays.value) || !isInt(maxDays.value)) {
				alert("Maximum length of service restriction '" + maxDays.value + "' must be a whole number");
				inRefreshing = false;
				return false;
			}
			else
			{
				var mds = parseInt(maxDays.value);
				if(mds > 1825) {
					alert("Maximum length of service restriction '" + maxDays.value + "' should be less than 1825 days (5 years)");
					inRefreshing = false;
					return false;
				}
				maxDays.value = mds;
			}
		}

        var defDays = document.programManagerForm.elements['program.defaultServiceRestrictionDays'];
		if(""!=defDays.value && (isNaN(defDays.value) || !isInt(defDays.value))) {
			alert("Default length of service restrcition '" + defDays.value + "' must be a whole number");
			inRefreshing = false;
			return false;
		}
		else
		{
			if("" != defDays.value) defDays.value = parseInt(defDays.value);
		}
        document.programManagerForm.method.value='save_restriction_settings';
		document.programManagerForm.submit()
		return false;
	}

</script>
<table width="100%">
	<tr height="18px">
		<td align="left" class="buttonBar2">
			<html:link	action="/PMmodule/ProgramManager.do"	style="color:Navy;text-decoration:none;">&nbsp;
				<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/Back16.png"/>" />&nbsp;Back to Programs&nbsp;
			</html:link>			

		<c:if test="${!isReadOnly}">
			&nbsp;|&nbsp;<html:link href="javascript:void1();" style="color:Navy;text-decoration:none;" onclick="javascript: setNoConfirm();return submitForm();">
			<img border="0" src="<html:rewrite page="/images/Save16.png"/>" />&nbsp;Save&nbsp;&nbsp;</html:link>
		</c:if>	
		</td>
	</tr>
	<!-- messages -->
	<tr>
		<td align="left" class="message">
			<logic:messagesPresent message="true">
				<br />
				<html:messages id="message" message="true" bundle="pmm">
					<c:out escapeXml="false" value="${message}" />
				</html:messages>
				<br />
			</logic:messagesPresent>
		</td>
	</tr>
</table>
<div class="tabs" id="tabs">
    <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <th title="Service Restrictions">Service Restriction Settings</th>
        </tr>
    </table>
</div>
The following parameters will be applied on new service restrictions for this program.
<table width="100%" border="1" cellspacing="2" cellpadding="3">
	<tr class="b">
		<td width="20%">Maximum length of service restriction (in days):</td>
		<td><html-el:text property="program.maximumServiceRestrictionDays" size="4" maxlength="4"/>&nbsp;(zero means no maximum)</td>
	</tr>
	<tr class="b">
		<td width="20%">Default service restriction length (in days):</td>
		<td><html-el:text property="program.defaultServiceRestrictionDays" size="4" maxlength="4"/>&nbsp;(zero means no default)</td>
	</tr>
</table>
<br/>
<%@ include file="/common/readonly.jsp" %>
