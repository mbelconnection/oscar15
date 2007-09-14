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
<%@ taglib uri="/WEB-INF/security.tld" prefix="security" %>
<%
    if(session.getAttribute("userrole") == null )  response.sendRedirect("../logout.jsp");
    String roleName$ = (String)session.getAttribute("userrole") + "," + (String) session.getAttribute("user");
%>
<security:oscarSec roleName="<%=roleName$%>" objectName="_admin,_admin.userAdmin" rights="r" reverse="<%=true%>" >
<%response.sendRedirect("../logout.jsp");%>
</security:oscarSec>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page import="oscar.util.SqlUtils" %>
<%@ page  import="java.sql.*, java.util.*,java.security.*" errorPage="errorpage.jsp" %>

<%
  //if(session.getValue("user") == null)  response.sendRedirect("../logout.jsp");
%>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean" scope="session" />

<html:html locale="true">
<head><title><bean:message key="admin.securityaddsecurity.title"/></title>
<link rel="stylesheet" href="../web.css">
</head>
<body   background="../images/gray_bg.jpg" bgproperties="fixed"  topmargin="0" leftmargin="0" rightmargin="0">
<center>
    <table border="0" cellspacing="0" cellpadding="0" width="100%" >
      <tr bgcolor="#486ebd">
            <th align="CENTER"><font face="Helvetica" color="#FFFFFF"><bean:message key="admin.securityaddsecurity.description"/></font></th>
      </tr>
    </table>
<%
    StringBuffer sbTemp = new StringBuffer();
    MessageDigest md = MessageDigest.getInstance("SHA");
    byte[] btNewPasswd= md.digest(request.getParameter("password").getBytes());
    for(int i=0; i<btNewPasswd.length; i++) sbTemp = sbTemp.append(btNewPasswd[i]);

    String[] param =new String[8];
	  param[0]=request.getParameter("user_name");
	  param[1]=sbTemp.toString();
	  param[2]=request.getParameter("provider_no");
	  param[3]=request.getParameter("pin");
	  param[4]=request.getParameter("b_ExpireSet")==null?"0":request.getParameter("b_ExpireSet");
	  
	  param[5]=request.getParameter("date_ExpireDate");
	  param[5]=SqlUtils.isoToOracleDate(param[5]);
	  
	  param[6]=request.getParameter("b_LocalLockSet")==null?"0":request.getParameter("b_LocalLockSet");
	  param[7]=request.getParameter("b_RemoteLockSet")==null?"0":request.getParameter("b_RemoteLockSet");

  int rowsAffected = apptMainBean.queryExecuteUpdate(param, request.getParameter("dboperation"));
  if (rowsAffected ==1) {
  //System.out.println("********************");}
%>
  <h1><bean:message key="admin.securityaddsecurity.msgAdditionSuccess"/></h1>
<%
  } else {
%>
  <h1><bean:message key="admin.securityaddsecurity.msgAdditionFailure"/></h1>
<%
  }
  apptMainBean.closePstmtConn();
%>
<%@ include file="footer2htm.jsp" %>
</center>
</body>
</html:html>
