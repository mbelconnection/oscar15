<!--  
/*
 * 
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
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
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */
-->

<%@ page import="java.util.*,java.sql.*"
	errorPage="../provider/errorpage.jsp"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/caisi-tag.tld" prefix="caisi"%>
<%@ include file="/common/webAppContextAndSuperMgr.jsp"%>

<%
  String oldGroup_no = request.getParameter("mygroup_no")==null?".":request.getParameter("mygroup_no");
%>

<html:html locale="true">
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<title><bean:message
	key="recepcionist.recepcionistchangemygroup.title" /></title>
<script language="javascript">
<!-- start javascript ---- check to see if it is really empty in database

// stop javascript -->
</script>
</head>

<body background="../images/gray_bg.jpg" bgproperties="fixed"
	onLoad="setfocus()" topmargin="0" leftmargin="0" rightmargin="0">
<FORM NAME="UPDATEPRE" METHOD="post" ACTION="receptionistcontrol.jsp">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
	<tr bgcolor="#486ebd">
		<th align=CENTER NOWRAP><font face="Helvetica" color="#FFFFFF"><bean:message
			key="recepcionist.recepcionistchangemygroup.msgTitle" /></font></th>
	</tr>
</table>

<center>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td><bean:message
			key="recepcionist.recepcionistchangemygroup.formChange" />:</TD>
		<TD align="right"><select name="mygroup_no">
<%
	List<Map> resultList = oscarSuperManager.find("receptionistDao", "searchmygroupno", new Object[] {});
	for (Map group : resultList) {
		String groupNo = String.valueOf(group.get("mygroup_no"));
%>
			<option value="<%=groupNo%>"
				<%=oldGroup_no.equals(groupNo)?"selected":""%>><%=groupNo%></option>
<%
	}
%>
		</select> &nbsp;<INPUT TYPE="submit"
			VALUE="<bean:message key="recepcionist.recepcionistchangemygroup.btnChange"/>">
		<INPUT TYPE="RESET"
			VALUE="<bean:message key="recepcionist.recepcionistchangemygroup.btnCancel"/>"
			onClick="window.close();"></td>
	</tr>
</TABLE>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="100%">

		<table BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="100%"
			BGCOLOR="#C0C0C0">
			<tr BGCOLOR="#C4D9E7">
				<td ALIGN="center"><font face="arial"> <bean:message
					key="recepcionist.recepcionistchangemygroup.msgGroup" /></font></td>
				<td ALIGN="center"><font face="arial"> <bean:message
					key="recepcionist.recepcionistchangemygroup.msgName" /></font></td>
			</tr>
<%
	boolean bNewNo = false;
	String oldNo = "";
	resultList = oscarSuperManager.find("receptionistDao", "searchmygroupall", new Object[] {});
	for (Map group : resultList) {
		String groupNo = String.valueOf(group.get("mygroup_no"));
		if (!groupNo.equals(oldNo)) {
			bNewNo = bNewNo?false:true; oldNo = groupNo;
		}
%>
			<tr BGCOLOR="<%=bNewNo?"white":"ivory"%>">
				<td ALIGN="center"><font face="arial"><%=groupNo%></font></td>
				<td><font face="arial"> &nbsp;<%=group.get("last_name") + ", " + group.get("first_name")%></font></td>
			</tr>
<%
	}
%>
			<INPUT TYPE="hidden" NAME="start_hour"
				VALUE='<%=(String) session.getAttribute("starthour")%>'>
			<INPUT TYPE="hidden" NAME="end_hour"
				VALUE='<%=(String) session.getAttribute("endhour")%>'>
			<INPUT TYPE="hidden" NAME="every_min"
				VALUE='<%=(String) session.getAttribute("everymin")%>'>
			<INPUT TYPE="hidden" NAME="provider_no"
				VALUE='<%=(String) session.getAttribute("user")%>'>
			<caisi:isModuleLoad moduleName="ticklerplus">
				<INPUT TYPE="hidden" NAME="new_tickler_warning_window"
					VALUE='<%=(String) session.getAttribute("newticklerwarningwindow")%>'>
			</caisi:isModuleLoad>
			<INPUT TYPE="hidden" NAME="color_template" VALUE='deepblue'>
			<INPUT TYPE="hidden" NAME="dboperation" VALUE='updatepreference'>
			<INPUT TYPE="hidden" NAME="displaymode" VALUE='updatepreference'>

		</table>

		</td>
	</tr>
</table>
</center>

<table width="100%" BGCOLOR="#486ebd">
	<tr>
		<TD align="center"><INPUT TYPE="button"
			VALUE="<bean:message key="recepcionist.recepcionistchangemygroup.btnCancel"/>"
			onClick="window.close();"></TD>
	</tr>
</TABLE>
<INPUT TYPE="hidden" NAME="color_template" VALUE='deepblue'> <INPUT
	TYPE="hidden" NAME="dboperation" VALUE='updatepreference'> <INPUT
	TYPE="hidden" NAME="displaymode" VALUE='updatepreference'></FORM>

</body>
</html:html>