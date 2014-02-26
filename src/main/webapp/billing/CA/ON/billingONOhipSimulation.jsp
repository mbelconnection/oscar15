<!DOCTYPE html>
<%--

    Copyright (c) 2006-. OSCARservice, OpenSoft System. All Rights Reserved.
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

--%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ page import="org.oscarehr.util.DateRange"%>
<%! boolean bMultisites = org.oscarehr.common.IsPropertiesOn.isMultisitesEnable(); %>
<%@ taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@ page import="java.math.*, java.util.*, oscar.util.*"%>
<%
    if(session.getAttribute("userrole") == null )  response.sendRedirect("../logout.jsp");
    String roleName$ = (String)session.getAttribute("userrole") + "," + (String) session.getAttribute("user");
    boolean isTeamBillingOnly=false;
    boolean isSiteAccessPrivacy=false;
    boolean isTeamAccessPrivacy=false; 
%>
<security:oscarSec objectName="_team_billing_only" roleName="<%=roleName$ %>" rights="r" reverse="false">
<% isTeamBillingOnly=true; %>
</security:oscarSec>
<security:oscarSec objectName="_site_access_privacy" roleName="<%=roleName$%>" rights="r" reverse="false">
	<%isSiteAccessPrivacy=true; %>
</security:oscarSec>
<security:oscarSec objectName="_team_access_privacy" roleName="<%=roleName$%>" rights="r" reverse="false">
	<%isTeamAccessPrivacy=true; %>
</security:oscarSec>



<% 
if(session.getAttribute("user") == null) response.sendRedirect("../../../logout.jsp");
String user_no = (String) session.getAttribute("user");
%>


<%@ page import="java.util.*, java.sql.*, oscar.*, oscar.util.*, java.net.*" errorPage="errorpage.jsp"%>
<%@ page import="oscar.oscarBilling.ca.on.pageUtil.*"%>
<%@ page import="oscar.oscarBilling.ca.on.data.*"%>
<jsp:useBean id="SxmlMisc" class="oscar.SxmlMisc" scope="session" />

<%
GregorianCalendar now=new GregorianCalendar();
int curYear = now.get(Calendar.YEAR);
int curMonth = (now.get(Calendar.MONTH)+1);
int curDay = now.get(Calendar.DAY_OF_MONTH);

String nowDate = UtilDateUtilities.DateToString(UtilDateUtilities.now(), "yyyy/MM/dd"); //"yyyy/MM/dd HH:mm"
String monthCode = BillingDataHlp.propMonthCode.getProperty("" + curMonth);

OscarProperties props = OscarProperties.getInstance();
String billCenter = props.getProperty("billcenter", "").trim();
String healthOffice = BillingDataHlp.propBillingCenter.getProperty(billCenter);

boolean summaryView = "on".equals(request.getParameter("summaryView"));

if(request.getParameter("submit")!=null && request.getParameter("submit").equals("Create Report")) {
	String errorMsg = "";
	int PROVIDER_BILLINGNO_LENGTH = 6;
	int PROVIDER_SPECIALTYCODE_LENGTH = 2;
	int PROVIDER_GROUPNO_LENGTH = 4;
	int errorCount = 0;	
	int bCount = 1;
	String batchCount = "0";
	BigDecimal bigTotal = new BigDecimal((double) 0).setScale(2, BigDecimal.ROUND_HALF_UP);
	int recordCount = 0;
	String pro = request.getParameter("provider");
	BillingProviderData proObj;
	ArrayList<String> providers = new ArrayList<String>();
	String htmlValue="";
	
	if (bMultisites) {
		DateRange dateRange = null;
		String proOHIP=""; 
		String specialty_code; 
		String billinggroup_no;
		String dateBegin = request.getParameter("xml_vdate");
		String dateEnd = request.getParameter("xml_appointment_date");
		if (dateEnd.compareTo("") == 0) dateEnd = request.getParameter("curDate");
		if (dateBegin.compareTo("") == 0){
			dateRange = new DateRange(null, ConversionUtils.fromDateString(dateEnd));
		} else {
			dateRange = new DateRange(ConversionUtils.fromDateString(dateBegin), ConversionUtils.fromDateString(dateEnd));
		}
		proObj = (new JdbcBillingPageUtil()).getProviderObj(pro);
		
		if (proObj.getOhipNo().length() != PROVIDER_BILLINGNO_LENGTH) 
			errorMsg = "The provider's billing code is not correct!<br>";
			
		proOHIP = proObj.getOhipNo(); 
		billinggroup_no= proObj.getBillingGroupNo();
		specialty_code = proObj.getSpecialtyCode();

		if (specialty_code.length() != PROVIDER_SPECIALTYCODE_LENGTH){
			errorMsg += "The provider's specialty code is not correct!<br>";
			specialty_code = "00"; 
		}

		if (billinggroup_no.length() != PROVIDER_GROUPNO_LENGTH){
			errorMsg += "The provider's group no is not correct!<br>";
			billinggroup_no = "0000";
		} 

		JdbcBillingCreateBillingFile dbObj = new JdbcBillingCreateBillingFile();
		dbObj.setEFlag("0");
		dbObj.setDateRange(dateRange);
		dbObj.setProviderNo(pro);
		BillingBatchHeaderData bhObj = new BillingBatchHeaderData();
		//bhObj.setId(bid);
		//bhObj.setDisk_id("" + rs.getInt("disk_id"));
		//bhObj.setTransc_id(rs.getString("transc_id"));
		//bhObj.setRec_id(rs.getString("rec_id"));
		bhObj.setSpec_id("   ");
		bhObj.setMoh_office(" ");
		//bhObj.setBatch_id(rs.getString("batch_id"));
		//bhObj.setOperator(rs.getString("operator"));
		bhObj.setGroup_num(billinggroup_no);
		bhObj.setProvider_reg_num(proOHIP);
		bhObj.setSpecialty(specialty_code);
		//bhObj.setH_count(rs.getString("h_count"));
		//bhObj.setR_count(rs.getString("r_count"));
		//bhObj.setT_count(rs.getString("t_count"));
		//bhObj.setBatch_date(rs.getString("batch_date"));
		
		dbObj.setBatchHeaderObj(bhObj);	
		dbObj.createSiteBillingFileStr("0", new String[] {"O", "W", "I" });
		htmlValue = "<font color='red'>" + errorMsg + "</font>" + dbObj.getHtmlValue();
	}
	else {
		if ("all".equals(pro)) {
			BillingReviewPrep prep = new BillingReviewPrep();
			List<String> providerStr = null;
			if (isTeamBillingOnly || isTeamAccessPrivacy) {			
				providerStr = prep.getTeamProviderBillingStr(user_no);
			}
			else if (isSiteAccessPrivacy) {
				providerStr = prep.getSiteProviderBillingStr(user_no);
			}
			else {
				providerStr = prep.getProviderBillingStr();
			}
			for (int i = 0; i < providerStr.size(); i++) {
				providers.add((providerStr.get(i)).split("\\|")[0]);			
			}
		}
		else {
			providers.add(pro);
		}
		
		for (String provider : providers) {
			errorMsg = "";
			proObj = (new JdbcBillingPageUtil()).getProviderObj(provider);
			
			if (proObj.getOhipNo().length() != PROVIDER_BILLINGNO_LENGTH) 
				errorMsg = "The provider's billing code is not correct!<br>";
			
			String proOHIP=""; 
			String specialty_code; 
			String billinggroup_no;
			DateRange dateRange = null;
			
			String dateBegin = request.getParameter("xml_vdate");
			String dateEnd = request.getParameter("xml_appointment_date");
			if (dateEnd.compareTo("") == 0) dateEnd = request.getParameter("curDate");
			if (dateBegin.compareTo("") == 0){
				dateRange = new DateRange(null, ConversionUtils.fromDateString(dateEnd));
			} else {
				dateRange = new DateRange(ConversionUtils.fromDateString(dateBegin), ConversionUtils.fromDateString(dateEnd));
			}
			
			proOHIP = proObj.getOhipNo(); 
			billinggroup_no= proObj.getBillingGroupNo();
			specialty_code = proObj.getSpecialtyCode();
		
			if (specialty_code.length() != PROVIDER_SPECIALTYCODE_LENGTH){
				errorMsg += "The provider's specialty code is not correct!<br>";
				specialty_code = "00"; 
			}
		
			if (billinggroup_no.length() != PROVIDER_GROUPNO_LENGTH){
				errorMsg += "The provider's group no is not correct!<br>";
				billinggroup_no = "0000";
			} 
		
			JdbcBillingCreateBillingFile dbObj = new JdbcBillingCreateBillingFile();
			dbObj.setEFlag("0");
			dbObj.setDateRange(dateRange);
			dbObj.setProviderNo(provider);
			BillingBatchHeaderData bhObj = new BillingBatchHeaderData();
			bhObj.setSpec_id("   ");
			bhObj.setMoh_office(" ");
			bhObj.setGroup_num(billinggroup_no);
			bhObj.setProvider_reg_num(proOHIP);
			bhObj.setSpecialty(specialty_code);
			dbObj.setBatchHeaderObj(bhObj);
			dbObj.errorMsg += errorMsg;
			
			dbObj.createBillingFileStr("0", new String[] { "O", "W", "I" }, true, null, summaryView);
			if (dbObj.getRecordCount() > 0) {
				recordCount += dbObj.getRecordCount();	
				bigTotal = bigTotal.add(dbObj.getBigTotal());
				htmlValue += dbObj.getHtmlValue();			
			}			
			errorCount += "".equals(dbObj.errorMsg) ? 0 : dbObj.errorMsg.split("<br>").length;
			errorCount += "".equals(dbObj.errorFatalMsg) ? 0 : dbObj.errorFatalMsg.split("<br>").length;
			dbObj.errorMsg = "";
		}
		
		String billingTable = htmlValue;
		htmlValue  = "\n<table class='table table-striped table-hover'>\n"
					+ "<thead><tr><td colspan='12' ></td></tr>";
		if (summaryView) {
			htmlValue += "\n<tr><th >OHIP NO</th><th >Number of Records</th><th >Total Billed</th><th  colspan='9'></th></t></thead>";
		}
		else {
			htmlValue += "\n<thead><tr><th >OHIP NO</th><th >Acct NO</th>"
					+ "<th >Name</th><th >RO</th><th >DOB</th><th >Sex</th><th >Health #</th>"
					+ "<th >Billdate</th><th >Code</th>"
					+ "<th >Billed</th>"
					+ "<th >DX</th><th align='right' >Comment</th></tr></thead>";	
		
			
						
		}
		htmlValue  += "<tbody>"+billingTable;
		htmlValue  += "\n<tr><td colspan='12' >&nbsp;</td></tr><tr><td colspan='4'>" 
			+ recordCount
			+ " RECORDS PROCESSED, " 
			+ errorCount 
			+" ERROR"+ (errorCount > 1 ? "S" : "") + "</td><td colspan='8'>TOTAL: "
			+ bigTotal.toString()
			+ "\n</td></tr>";
		htmlValue  += "</tbody></table>";
	}
	request.setAttribute("html",htmlValue);
}
%>



<html>
<head>
<title>Billing Report</title>

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-1.9.1.min.js"></script>
<script src="<%=request.getContextPath() %>/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap-datepicker.js"></script>

<link href="<%=request.getContextPath() %>/css/bootstrap.min.css" rel="stylesheet">
<link href="<%=request.getContextPath() %>/css/datepicker.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/font-awesome.min.css">

<script type="text/javascript" language="JavaScript">
<!--
function openBrWindow(theURL,winName,features) {
	window.open(theURL,winName,features);
}


function checkData() {
	var b = true;
	if(document.forms[0].provider.value=="000000"){
		alert("Please select a provider!");
		b = false;
	}else if(document.forms[0].xml_vdate.value==""){
		alert("Please give a date!");
		b = false;
	}

	return b;
}
//-->
</script>
<style type="text/css">
	input[name=summaryView] {margin: 4px 4px 4px; margin-left:20px;}
	select[name=provider] {margin-right:20px;}
	input[name=submit] {margin-bottom: -60px;}
</style>
</head>

<body>

<div class="container-fluid">
<h3><bean:message key="admin.admin.btnSimulationOHIPDiskette" /></h3>

<form name="serviceform" method="post" action="billingONOhipSimulation.jsp" onSubmit="return checkData();">
<div class="row well">
<button type='button' name='print' value='Print' class="btn pull-right" onClick='window.print()'> <i class="icon icon-print"></i> Print</button><br/>


<%
String providerview=request.getParameter("provider")==null?user_no:request.getParameter("provider");
String xml_vdate=request.getParameter("xml_vdate") == null?"":request.getParameter("xml_vdate");
String xml_appointment_date = request.getParameter("xml_appointment_date")==null? nowDate : request.getParameter("xml_appointment_date");
%>


	<input type="hidden" name="monthCode" value="<%=monthCode%>"> 
	<input type="hidden" name="verCode" value="V03"> 
	<input type="hidden" name="curUser" value="<%=user_no%>"> 
	<input type="hidden" name="curDate" value="<%=nowDate%>">


<div class="span12">
	
<div class="span3">
Select Provider<br>
<select name="provider">
		<% if (bMultisites) { %>
		<option value="all">Select Providers</option>
		<% } else { %>
		<option value="all">All Providers</option>
		<% } %>
		<%
	BillingReviewPrep prep = new BillingReviewPrep();
		
		
	List providerStr; 
		
	if (isTeamBillingOnly || isTeamAccessPrivacy) {
		providerStr = prep.getTeamProviderBillingStr(user_no);
	}
	else if (isSiteAccessPrivacy) {
		providerStr = prep.getSiteProviderBillingStr(user_no);
	}
	else {
		providerStr = prep.getProviderBillingStr();
	}
	
	for (int i = 0; i < providerStr.size(); i++) {
		String temp[] = ((String) providerStr.get(i)).split("\\|");
		%>
		<option value="<%=temp[0]%>"
			<%=providerview.equals(temp[0])?"selected":(providerStr.size()==1?"selected":"")%>><%=temp[1]%>,
		<%=temp[2]%></option>
		<%}
	%>
</select>
</div><!--span3-->
		
	<div class="span2">	
	From:<br>
	<div class="input-append">
		<input type="text" name="xml_vdate" id="xml_vdate" value="<%=xml_vdate%>"  style="width:90px" autocomplete="off" />
		<span class="add-on"><i class="icon-calendar"></i></span>
	</div>
	</div>


	<div class="span2">	
	To:<br>
	<div class="input-append">
		<input type="text" name="xml_appointment_date" id="xml_appointment_date" value="<%=xml_appointment_date%>"  style="width:90px" autocomplete="off" />
		<span class="add-on"><i class="icon-calendar"></i></span>
	</div>
	</div>

</div> <!--span12-->

<div class="span12">
	<div class="span2">
	Bill Center: <input type="hidden" name="billcenter" value="<%=billCenter%>"> <%=healthOffice%>
	</div>


	<% if (!bMultisites) { %>
	<div class="span2"><input type="checkbox" name="summaryView" id="summaryView" <%= summaryView ? "checked" : "" %> />Summary View</div>
	<% } %>

	<div class="span2">
	<button class="btn btn-primary" type="submit" name="submit" value="Create Report">Create Report</button>
	</div>

</div><!--span12-->


</div><!--form well-->
</form>

<%=request.getAttribute("html") == null?"":request.getAttribute("html")%>



</div><!--container-->

<script type="text/javascript">
var startDate = $("#xml_vdate").datepicker({
	format : "yyyy/mm/dd"
});

var endDate = $("#xml_appointment_date").datepicker({
	format : "yyyy/mm/dd"
});

//open a new popup window
function popupPage(vheight,vwidth,varpage) { 
  var page = "" + varpage;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes";
  var popup=window.open(page, "attachment", windowprops);
  if (popup != null) {
    if (popup.opener == null) {
      popup.opener = self; 
    }
  }
}
</script>

</body>
</html>
