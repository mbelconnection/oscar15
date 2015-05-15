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

<%@page
	import="java.util.*,oscar.oscarDemographic.data.*,oscar.oscarPrevention.*,oscar.oscarProvider.data.*,oscar.util.*,oscar.oscarReport.data.*,oscar.oscarPrevention.pageUtil.*,oscar.oscarDemographic.pageUtil.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/oscar-tag.tld" prefix="oscar"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />

<%
  String demographicNo = request.getParameter("demographicNo");
  String userRole = (String)session.getAttribute("userrole");
%>

<html:html locale="true">

<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<!--I18n-->
<title>Demographic Export</title>
<script src="../share/javascript/Oscar.js"></script>
<link rel="stylesheet" type="text/css"
	href="../share/css/OscarStandardLayout.css">
<link rel="stylesheet" type="text/css" media="all"
	href="../share/calendar/calendar.css" title="win2k-cold-1" />

<script type="text/javascript" src="../share/calendar/calendar.js"></script>
<script type="text/javascript"
	src="../share/calendar/lang/<bean:message key="global.javascript.calendar"/>"></script>
<script type="text/javascript" src="../share/calendar/calendar-setup.js"></script>

<link rel="stylesheet" type="text/css" media="all" href="../share/css/extractedFromPages.css"  />

<SCRIPT LANGUAGE="JavaScript">

function checkAll(all) {
    var frm = document.DemographicExportPdfForm;
    if (all) {
	   	frm.incAllergies.checked = true;
		frm.incProblems.checked = true;
		frm.incCPP.checked = true;
		frm.incIssues.checked = true;
		frm.incMeds.checked = true;
		frm.incMeasurements.checked = true;
		frm.incNotes.checked = true;
		frm.incEForms.checked = true;
    } else {
       	frm.incAllergies.checked = false;
    	frm.incProblems.checked = false;
    	frm.incCPP.checked = false;
    	frm.incIssues.checked = false;
    	frm.incMeds.checked = false;
    	frm.incMeasurements.checked = false;
    	frm.incNotes.checked = false;
    	frm.incEForms.checked = false;
    }
}

function submitPdf() {
	 var frm = document.DemographicExportForm;
	 frm.action='<%=request.getContextPath()%>/demographic/DemographicPdfExport.do';
}
</SCRIPT>




<link rel="stylesheet" type="text/css" media="all" href="../share/css/extractedFromPages.css"  />
</head>

<body class="BodyStyle" vlink="#0000FF">


<table class="MainTable" id="scrollNumber1" name="encounterTable">
	<tr class="MainTableTopRow">
		<td style="max-width:200px;" class="MainTableTopRowLeftColumn">
		Demographic Export</td>
		<td class="MainTableTopRowRightColumn">
		<table class="TopStatusBar">
			<tr>
				<td>Demographic PDF</td>
				<td>&nbsp;</td>
				<td style="text-align: right"><oscar:help keywords="print demographic" key="app.top1"/> | <a
					href="javascript:popupStart(300,400,'About.jsp')"><bean:message
					key="global.about" /></a> | <a
					href="javascript:popupStart(300,400,'License.jsp')"><bean:message
					key="global.license" /></a></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="MainTableLeftColumn" valign="top" nowrap="nowrap">
		   <!-- left hand panel -->
		</td>
		<td valign="top" class="MainTableRightColumn">
		    <html:form action="/demographic/DemographicPdfExport" method="get">
		    <div>
		    <html:hidden property="demographicNo" value="<%=demographicNo%>" />
                            Generating PDF for Demographic No. <%=demographicNo%>
		   
		    </div>
                    <p><table border="1"><tr><td>
		       Categories:
		       <table cellpadding="10"><tr><td>
		       <html:checkbox property="incAllergies">Allergies</html:checkbox><br>
		       <html:checkbox property="incProblems">Problems</html:checkbox><br>
		       <html:checkbox property="incCPP">CPP</html:checkbox><br>
		       <html:checkbox property="incIssues">Issues</html:checkbox><br>
		       <html:checkbox property="incMeds">Medications</html:checkbox><br>
		       <html:checkbox property="incMeasurements">Measurements</html:checkbox><br>
		       <html:checkbox property="incNotes">Notes</html:checkbox><br>
		       <html:checkbox property="incEForms">EForms</html:checkbox><br>
		       
		       </td><td>
			   <input type="button" value="Check All" onclick="checkAll(true);"/><p>
			   <input type="button" value="Check None" onclick="checkAll(false);"/>
		       </td></tr></table>
		   </td></tr></table>
                       
		    <p>&nbsp;</p>
                    <input type="submit" value="Generate PDF"/>
          
		</html:form></td>
	</tr>
	<tr>
		<td class="MainTableBottomRowLeftColumn">&nbsp;</td>
		<td class="MainTableBottomRowRightColumn" valign="top">&nbsp;</td>
	</tr>
</table>
<script type="text/javascript">
    //Calendar.setup( { inputField : "asofDate", ifFormat : "%Y-%m-%d", showsTime :false, button : "date", singleClick : true, step : 1 } );
</script>

</body>
</html:html>
<%!

%>
