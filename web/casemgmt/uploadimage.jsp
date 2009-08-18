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

<%@ include file="../taglibs.jsp" %>

<%@ page import="org.oscarehr.casemgmt.model.*" %>
<%@ page import="org.oscarehr.casemgmt.web.formbeans.*" %>

<%
	if(application.getAttribute("javax.servlet.context.tempdir") == null) {
		System.out.println("no javax.servlet.context.tempdir defined");
		String tmpDir = System.getProperty("java.io.tmpdir");
		System.out.println("tmpDir=" + tmpDir);
		application.setAttribute("javax.servlet.context.tempdir",new java.io.File(tmpDir));
	}
%>
<head>
<title>Client Image Manager</title>
<meta http-equiv="Cache-Control" content="no-cache">
<link rel="stylesheet" href="../css/core.css" / >
<script>
	function init_page() {
		<%
			if(request.getAttribute("success") != null) {
				%>opener.document.caseManagementViewForm.submit(); self.close();<%
			}
		%>
	}
	
	function onPicUpload(){
  	  var obj= document.getElementsByName("clientImage.imagefile")[0];
      if(obj.value==""){
      	alert("Please specify picture path and name for upload.");
      	return false;
      }	
	  return true;
	}
	
	function submitForm(methodValue)
	{
		if (!trimInputBox()) return false;
		document.forms[0].method.value=methodValue;
		document.forms[0].submit();
	}
</script>
</head>
<body bgproperties="fixed" onLoad="self.focus();init_page();" topmargin="0" leftmargin="0" rightmargin="0">
<table border="0" cellspacing="0" cellpadding="0" width="100%" >
  <tr>
  <th class="pageTitle" width="100%">Client Image Manager  
  </th></tr>
  <tr>  	
	<td align="left" class="buttonBar2">
	 <a href="javascript:submitForm('saveImage')" onclick="return onPicUpload();" style="color:Navy;text-decoration:none;">&nbsp;Upload&nbsp;&nbsp;|</a>
	<a href="#" onClick='window.close()'> Cancel </a>
	</td>
  </tr>
</table>
<table BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">

	<html:form action="/ClientImage" enctype="multipart/form-data">
		<!-- input type="hidden" name="method" value="saveImage"/ -->
		<%	request.getSession(true).setAttribute("clientId",request.getParameter("demographicNo")); %>
		<tr valign="top"><td rowspan="2" ALIGN="right" valign="middle"> <font><b>Add Image
        </b></font></td>


    <td valign="middle" rowspan="2" ALIGN="left">		
		<html:file property="clientImage.imagefile" size="30" accept="*.gif,*.jpg"/><br>
		<!-- html:submit value="Upload" /-->
	</td>
		</tr>
	<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
</table>
<br>
<table width="100%">
<tr>
<th align="left">
Attention</th>
</tr>
<tr>
<td>
Only gif and jpg image type are allowed for the client photo uploading.
</td></tr>
</table>
</body>
