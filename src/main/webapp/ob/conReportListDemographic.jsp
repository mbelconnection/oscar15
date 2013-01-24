<%--

    Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
    This software is published under the GPL GNU General Public License.
    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

    This software was written for the
    Department of Family Medicine
    McMaster University
    Hamilton
    Ontario, Canada

--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="http://displaytag.sf.net/el" prefix="display-el"%>

<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.oscarehr.util.SpringUtils" %>
<%@ page import="org.oscarehr.common.model.Demographic" %>
<%@ page import="org.oscarehr.common.dao.DemographicDao" %>
<%@ page import="org.oscarehr.common.model.ConsultationReport" %>
<%
	DemographicDao demographicDao = SpringUtils.getBean(DemographicDao.class);
	String demographicNo = request.getParameter("demographicNo");
	Demographic demographic = demographicDao.getDemographic(demographicNo);
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
%>

<html:html locale="true">
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<title>Consultation Reports</title>
<link rel="stylesheet" type="text/css" href="../share/css/OscarStandardLayout.css">
<style>
.sortable {
        background-color: #6699CC;
        color: #555;
        text-align:left;
}

.b th {
        border-right: 1px solid #333;
        background-color: #ddd;
        color: #ddd;
        border-left: 1px solid #fff;
}

</style>

<script type="text/javascript" language="JavaScript" src="../share/javascript/prototype.js"></script>
<script type="text/javascript" language="JavaScript" src="../share/javascript/Oscar.js"></script>
<script>
function popupOscarRx(vheight,vwidth,varpage) {
	var page = varpage;
	windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";
	var popup=window.open(varpage, "consultReportOB", windowprops);
	if (popup != null) {
		if (popup.opener == null) {
			popup.opener = self;
		}
		popup.focus();
	}
}

</script>

<link rel="stylesheet" href="css/displaytag.css" type="text/css">
<style type="text/css">
.boldRow {
	color:red;
}
.commonRow{
	color:black;
}
span.h5 {
  margin-top: 1px;
  border-bottom: 1px solid #000;
  width: 90%;
  font-weight: bold;
  list-style-type: none;
  padding: 2px 2px 2px 2px;
  color: black;
  background-color: #69c;
  font-family: Trebuchet MS, Lucida Sans Unicode, Arial, sans-serif;
  font-size: 10pt;
  text-decoration: none;
  display: block;
  clear: both;
  white-space: nowrap;

}
</style>

<style type="text/css">
table.outline {
	margin-top: 50px;
	border-bottom: 1pt solid #888888;
	border-left: 1pt solid #888888;
	border-top: 1pt solid #888888;
	border-right: 1pt solid #888888;
}

table.grid {
	border-bottom: 1pt solid #888888;
	border-left: 1pt solid #888888;
	border-top: 1pt solid #888888;
	border-right: 1pt solid #888888;
}

td.gridTitles {
	border-bottom: 2pt solid #888888;
	font-weight: bold;
	text-align: center;
}

td.gridTitlesWOBottom {
	font-weight: bold;
	text-align: center;
}

td.middleGrid {
	border-left: 1pt solid #888888;
	border-right: 1pt solid #888888;
	text-align: center;
}

label {
	float: left;
	width: 120px;
	font-weight: bold;
}

label.checkbox {
	float: left;
	width: 116px;
	font-weight: bold;
}

label.fields {
	float: left;
	width: 80px;
	font-weight: bold;
}

span.labelLook {
	font-weight: bold;
}

input,textarea,select { //
	margin-bottom: 5px;
}

textarea {
	width: 450px;
	height: 100px;
}

.boxes {
	width: 1em;
}

#submitbutton {
	margin-left: 120px;
	margin-top: 5px;
	width: 90px;
}

br {
	clear: left;
}
</style>
</head>

<body vlink="#0000FF" class="BodyStyle">

<table class="MainTable">
	<tr class="MainTableTopRow">
		<td class="MainTableTopRowLeftColumn">Consultation Report</td>
		<td class="MainTableTopRowRightColumn">
		<table class="TopStatusBar" style="width: 100%;">
			<tr>
				<td>Consultation Report list for <%=demographic.getFormattedName() %></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="MainTableLeftColumn" valign="top" width="160px;">
		<a href="javascript:void(0);" onclick="popupOscarRx(625,1024,'<%=request.getContextPath()%>/ob/OB.do?method=createOBForm&demographicNo=<%=demographic.getDemographicNo()%>');return false;">New Consultation Report</a>
		</td>
		<td class="MainTableRightColumn" valign="top">
				
				
		<display:table name="reports" requestURI="/ob/OB.do?listForDemographic&demographicNo=<%=demographic.getDemographicNo()%>" defaultsort="2" sort="list" defaultorder="descending"
		id="report" pagesize="15">


		<display:column title="Date" sortable="true" headerClass="sortable" style="width:160px;">
			<%=formatter.format(((ConsultationReport)pageContext.getAttribute("report")).getDate()) %>	
		</display:column>
		
		<display:column title="Status"sortable="true" headerClass="sortable">
			<%=formatStatus(((ConsultationReport)pageContext.getAttribute("report")).getStatus()) %>
		</display:column>
		
		<display:column title="Provider" sortable="true" headerClass="sortable" style="width:165px;">
			<%=((ConsultationReport)pageContext.getAttribute("report")).getProvider() %>
		</display:column>
		

		<display:column title="" sortable="false" headerClass="sortable" style="width:210px;">
			<a href="javascript:void(0);" onclick="popupOscarRx(625,1024,'<%=request.getContextPath()%>/ob/OB.do?method=editOBForm&id=<%=((ConsultationReport)pageContext.getAttribute("report")).getId() %>');return false;">View</a>
		
		</display:column>

		
	</display:table>
		</td>
	</tr>
	<tr>
		<td class="MainTableBottomRowLeftColumn">&nbsp;</td>

		<td class="MainTableBottomRowRightColumn">&nbsp;</td>
	</tr>
</table>
</html:html>

<%!
String formatStatus(String s) {
	if(s.equals("1"))
		return "Incomplete";
	if(s.equals("2"))
		return "Completed, not sent";
	if(s.equals("3"))
		return "Completed, and sent";
	return "";
}
%>
