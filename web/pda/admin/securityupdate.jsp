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
 * McMaster Unviersity 
 * Hamilton 
 * Ontario, Canada 
 */
-->

<%@ page import="java.sql.*, java.util.*,java.security.*"
	errorPage="errorpage.jsp"%>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean"
	scope="session" />

<html>
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<title>Security: the following records</title>
</head>
<link rel="stylesheet" href="../web.css" />
<body background="../images/gray_bg.jpg" bgproperties="fixed"
	topmargin="0" leftmargin="0" rightmargin="0">
<center>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr bgcolor="#486ebd">
		<th align="CENTER"><font face="Helvetica" color="#FFFFFF">
		SECURITY</font></th>
	</tr>
</table>
<%
  //if action is good, then give me the result
    StringBuffer sbTemp = new StringBuffer();
    MessageDigest md = MessageDigest.getInstance("SHA");
    byte[] btNewPasswd= md.digest(request.getParameter("password").getBytes());
    for(int i=0; i<btNewPasswd.length; i++) sbTemp = sbTemp.append(btNewPasswd[i]);
    
    String[] param =new String[3];
	  param[0]=request.getParameter("user_name");
	  param[1]=sbTemp.toString();
	  param[2]=request.getParameter("provider_no");
	  int[] nparam=new int[1];
	  nparam[0]=Integer.parseInt(request.getParameter("security_no"));
  int rowsAffected = apptMainBean.queryExecuteUpdate(param,nparam, request.getParameter("dboperation"));
  if (rowsAffected ==1) {
%>
<p>
<h2>Update a Security Record Successfully ! <%=request.getParameter("provider_no")%>
</h2>
<%  
  } else {
%>
<h1>Sorry, fail to update !!! <%= request.getParameter("provider_no") %>.
<%  
  }
  apptMainBean.closePstmtConn(); 
%>
<p></p>
<%@ include file="footer2.htm"%>
</center>
</body>
</html>