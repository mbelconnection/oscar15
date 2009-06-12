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
<%@ include file="/taglibs.jsp"%>

<%@ page language="java" contentType="text/html"
	import="oscar.OscarProperties,oscar.util.BuildInfo,javax.servlet.http.Cookie,oscar.oscarSecurity.CookieSecurity"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/caisi-tag.tld" prefix="caisi"%>
<%
	OscarProperties props = OscarProperties.getInstance();
	if (!props.isSiteSecured()) {
		response.sendRedirect("index.jsp");
	}
%>

<html:html locale="true">
<head>
<html:base />
<link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=UTF-8">
<title>
<%
if (props.getProperty("logintitle", "").equals("")) {
%> <bean:message
	key="loginApplication.title" /> <%
 } else {
 %> <%=props.getProperty("logintitle", "")%>
<%
}
%>
</title>
<!--LINK REL="StyleSheet" HREF="web.css" TYPE="text/css"-->

<script language="JavaScript">
  <!-- hide
  function setfocus() {
    document.loginForm.username.focus();
    document.loginForm.username.select();
  }
  function popupPage(vheight,vwidth,varpage) {
    var page = "" + varpage;
    windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes";
    var popup=window.open(page, "gpl", windowprops);
  }
  -->
        </script>

<style type="text/css">
            body { 
               font-family: Verdana, helvetica, sans-serif;
               margin-left: 1px;
               margin-right: 0px;
               margin-bottom: 0px;
               margin-top: 0px;
               margin: 0px;
               padding:0px;
               
            }
            
            td.topbar{
               background-color: gold;
               
               
            }
            td.leftbar{
                background-color: #009966;
                color: white;
            }
            td.leftinput{
                background-color: #f5fffa;
                //background-color: #ffffff;
                
                font-size: small;
                }
                
                span.extrasmall{
                    font-size: x-small;
                }
        </style>
</head>


<body>


<div align="center">
<html:form action="login">
<input
						type="hidden" name="pin" size="15" maxlength="15"
						autocomplete="off" value="1117"/>
<table align="center" border="0" cellspacing="0" width="100%" height="100%">
	<tr>
		<td>
			<table align="center">
				<tr>
					<td align="center"><img src="images/QuatroShelter-Logo400.gif" height="80" width="400" ></td>
				</tr>
				<tr>
					<Td align="center"><font size="3" face="Arial">City of
					Toronto</font></td>
				</tr>
				<tr>
					<td align="center"><font size="1" face="Arial">Build: <%=OscarProperties.getInstance().getBuildDate()%></font>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td>
			<table align="center" width="100%">
				<tr>
					<td align="center">
					<font size="5" face="Arial">Welcome to QuatroShelter</font><br><br>
					<font size="3" face="Arial">Please log in</font>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<!-- messages -->
				<tr>
					<td align="center" class="message">
					<logic:messagesPresent message="true">
						<br />
						<html:messages id="message" message="true">
							<c:out escapeXml="false" value="${message}" />
						</html:messages>
						<br />
					</logic:messagesPresent></td>
				</tr>
				<tr>
					<td align="center">
						<object
							classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93"
								width="500" height="150"
								codebase="http://java.sun.com/products/plugin/autodl/jinstall-1_5_0-windows-i586.cab#Version=1,5,0,0">
								    <PARAM NAME="code" VALUE="com.quatro.model.security.QSSecurity.class">
								    <PARAM NAME="archive" VALUE="QSSecurity.jar, registry.jar">
								    <PARAM NAME="type" VALUE="application/x-java-applet;jpi-version=1.5">
								    <COMMENT>
									<embed align="baseline" code="com.quatro.model.security.QSSecurity.class"
									  	width="500" height="150"
											  	type="application/x-java-applet;version=1.5.0"
											  	pluginspage="http://java.sun.com/j2se/1.5.0/download.html"					        
								        archive="QSSecurity.jar, registry.jar">
								    <NOEMBED>
								        No Java 2 SDK, Standard Edition v 1.5 support for APPLET!!
								    </NOEMBED>
								    </EMBED>
								    </COMMENT>
						</object>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height=70></td></tr>
	<tr>
		<td  height="41" align="center"><img border="0"
			src="images/QuatroGroup-Logo.gif" >&nbsp;&nbsp;&nbsp;&nbsp;
		<img border="0" src="images/SMIS-Logo.gif"  >&nbsp;&nbsp;&nbsp;&nbsp;
		<img border="0" src="images/Caisi-Logo.gif" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img border="0" src="images/OSCAR-LOGO.gif" ></td>
	</tr>
	<tr><td height=30></td></tr>
	<tr>
		<td height="25" align="center" style="BORDER-TOP:Gray 1px solid; BORDER-right:Silver 1px solid; BORDER-LEFT:Gray 1px solid" background="images/Silver-background.gif">
		<p align="center"><font face="Arial" size="2">Quatro Group
		Software System Inc. Support at: <a href="http://www.QuatroGroup.com">http://www.QuatroGroup.com</a></font>
		</td>
	</tr>
	<tr><td height=20></td></tr>
</table>
</html:form>
</div>

</body>
</html:html>



