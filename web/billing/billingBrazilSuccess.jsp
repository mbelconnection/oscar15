<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
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
<html>
<html:html locale="true">
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<title>Faturamento</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../../web_fat.css">
</head>

<body background="../../../images/gray_bg.jpg" bgproperties="fixed"
	onLoad="setfocus()" topmargin="0" leftmargin="0" rightmargin="0">
<table cellspacing="0" cellpadding="2" width="95%" border="1"
	align="center">
	<tr>
		<th>Faturamento realizado com sucesso</th>
	</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td><a href="#" onclick="window.close();"> <img
			src="../../../images/leftarrow.gif" border="0" width="25" height="20"
			align="absmiddle"><bean:message key="global.btnBack" /></a></td>
		<td align="right"><a href="#" onclick="window.close();"><bean:message
			key="global.btnLogout" /><img src="../../../images/rightarrow.gif"
			border="0" width="25" height="20" align="absmiddle"></a></td>
	</tr>
</table>
</body>
</html:html>
</html>