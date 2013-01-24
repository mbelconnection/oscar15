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
<%@page import="org.apache.struts.validator.DynaValidatorForm"%>
<%@ taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ taglib uri="http://displaytag.sf.net/el" prefix="display-el"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.oscarehr.util.SpringUtils" %>
<%@ page import="org.oscarehr.common.model.Demographic" %>
<%@ page import="org.oscarehr.common.dao.DemographicDao" %>
<%@ page import="org.oscarehr.common.model.Provider" %>
<%@ page import="org.oscarehr.PMmodule.dao.ProviderDao" %>
<%@ page import="org.oscarehr.common.model.ConsultationReport" %>
<%@ page import="org.oscarehr.ob.OBConsultationReportForm" %>
<%
	DemographicDao demographicDao = SpringUtils.getBean(DemographicDao.class);
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	ProviderDao providerDao = SpringUtils.getBean(ProviderDao.class);
	
	String dmname = null;
	
	DynaValidatorForm form = (DynaValidatorForm)request.getAttribute("obForm");
	OBConsultationReportForm cForm = (OBConsultationReportForm)form.get("search");
	if(cForm.getDemographicNo() > 0 ) {
		dmname = demographicDao.getDemographicById(cForm.getDemographicNo()).getFormattedName();
	}
	
	if(dmname==null) {
		dmname = request.getParameter("dmname");
		if(dmname == null) {
			dmname=new String();
		}
	}
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

<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
     <!-- calendar stylesheet -->
  <link rel="stylesheet" type="text/css" media="all" href="<c:out value="${ctx}"/>/share/calendar/calendar.css" title="win2k-cold-1">

  <!-- main calendar program -->
  <script type="text/javascript" src="<c:out value="${ctx}"/>/share/calendar/calendar.js"></script>

  <!-- language for the calendar -->
  <script type="text/javascript" src="<c:out value="${ctx}"/>/share/calendar/lang/<bean:message key="global.javascript.calendar"/>"></script>

  <!-- the following script defines the Calendar.setup helper function, which makes
       adding a calendar a matter of 1 or 2 lines of code. -->
  <script type="text/javascript" src="<c:out value="${ctx}"/>/share/calendar/calendar-setup.js"></script>

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
<script type="text/javascript" language=javascript>
function popupPage(varpage) {
        var page = "" + varpage;
        windowprops = "height=600,width=800,location=no,"
          +"left=50,top=50,scrollbars=yes,menubar=no,toolbars=no,resizable=yes,top=0,left=0";
        window.open(page, "_blank", windowprops);
    }

var check_demo_no;

function updTklrList() {
    clearInterval(check_demo_no);
   // createReport();
}

function search_demographic() {
    var url = '<c:out value="${ctx}"/>/ticklerPlus/demographicSearch2.jsp?form=obForm&elementName=dmname&elementId=search.demographicNo';
    var popup = window.open(url,'demographic_search');
    demo_no_orig = document.obForm.elements['search.demographicNo'].value;
     check_demo_no = setInterval("if (demo_no_orig != document.obForm.elements['search.demographicNo'].value) updTklrList()",100);
    	if (popup != null) {
		if (popup.opener == null) {
				popup.opener = self;
		}
		popup.focus();
		}
}

function clear_demographic() {
	document.obForm.elements['search.demographicNo'].value = '0';
	document.obForm.elements['dmname'].value='';
}

</script>
</head>

<body vlink="#0000FF" class="BodyStyle">

<table class="MainTable">
	<tr class="MainTableTopRow">
		<td class="MainTableTopRowLeftColumn">Consultation Report</td>
		<td class="MainTableTopRowRightColumn">
		<table class="TopStatusBar" style="width: 100%;">
			<tr>
				<td>Consultation Reports</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="MainTableLeftColumn" valign="top" width="160px;">
		&nbsp;
		</td>
		<td class="MainTableRightColumn" valign="top">
		
			<html:form action="/ob/OB">
			<html:hidden property="search.demographicNo"/>
			<input type="hidden" name="method" value="list"/>
			
			<table bgcolor="#ddeeff">
		<tr>

			<td>Status:</td>
			<td><html:select property="search.status">
				<html:option value="0">All</html:option>
				<html:option value="1">Incomplete</html:option>
				<html:option value="2">Completed,not sent</html:option>
				<html:option value="3">Completed,and sent</html:option>
			</html:select></td>
			<td>Internal Doctor:</td>
			<td><html:select property="search.provider">
				<html:option value="">All</html:option>
				<%for(Provider p:providerDao.getActiveProviders()) { %>
					<html:option value="<%=p.getFormattedName() %>"><%=p.getFormattedName() %></html:option>
				<% } %>
				
			</html:select></td>
			<td>Demographic:</td>
			<td>
			<input type="text" name="dmname" disabled="disabled" value="<%=dmname%>"/>
  			<input type="button" value="Clear" onclick="clear_demographic();"/>
  			<input type="button" value="Search Demographic" onclick="search_demographic();"/>
  			</td>
		</tr>
		<tr>
		<td>Report Start Date:</td>
		<td>
		 <html:text styleClass="plain" property="search.startDate" size="12" onfocus="this.blur()" readonly="readonly" styleId="sdate"/><img src="<%=request.getContextPath()%>/images/cal.gif" id="sdate_cal">
	    </td>
	<td>Report End Date:</td>
	<td>
	<html:text styleClass="plain" property="search.endDate" size="12" onfocus="this.blur()" readonly="readonly" styleId="edate"/><img src="<%=request.getContextPath()%>/images/cal.gif" id="edate_cal">

	</td>

	 <script type="text/javascript">
				Calendar.setup({ inputField : "sdate", ifFormat : "%Y-%m-%d", showsTime :false, button : "sdate_cal", singleClick : true, step : 1 });
				Calendar.setup({ inputField : "edate", ifFormat : "%Y-%m-%d", showsTime :false, button : "edate_cal", singleClick : true, step : 1 });
	   </script>
	<td></td>

			<td>

			<html:submit onclick="return doSubmit();">List Consultation Reports</html:submit>

			</td>

		</tr>
	</table>
		
		
		</html:form>
				
				
		<display:table name="reports" requestURI="/ob/OB.do?method=list" defaultsort="2" sort="list" defaultorder="descending"
		id="report" pagesize="15">

		<display:column title="Patient name" sortable="true" headerClass="sortable" style="width:210px;">
			<%=((ConsultationReport)pageContext.getAttribute("report")).getDemographic().getFormattedName() %>
			
		</display:column>

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