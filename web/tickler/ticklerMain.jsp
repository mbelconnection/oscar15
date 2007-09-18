<%@ taglib uri="/WEB-INF/security.tld" prefix="security" %>
<%
    if(session.getAttribute("userrole") == null )  response.sendRedirect("../logout.jsp");
    String roleName$ = (String)session.getAttribute("userrole") + "," + (String) session.getAttribute("user");
%>
<security:oscarSec roleName="<%=roleName$%>" objectName="_tasks" rights="r" reverse="<%=true%>" >
<%response.sendRedirect("../noRights.html");%>
</security:oscarSec>

<%@ page import="java.util.*,java.text.*, java.sql.*, oscar.*, java.net.*" %>
<%@ include file="../admin/dbconnection.jsp" %>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean" scope="session" />
<jsp:useBean id="SxmlMisc" class="oscar.SxmlMisc" scope="session" />


 <%
 //select * from tickler where status = 'A' and service_date <= now() and task_assigned_to  = '999998' limit 1;
  if(session.getValue("user") == null)
    response.sendRedirect("../logout.jsp");
  String user_no;
  user_no = (String) session.getAttribute("user");
  int  nItems=0;
  String strLimit1="0";
  String strLimit2="5";
  if(request.getParameter("limit1")!=null) strLimit1 = request.getParameter("limit1");
  if(request.getParameter("limit2")!=null) strLimit2 = request.getParameter("limit2");
  String providerview = request.getParameter("providerview")==null?"all":request.getParameter("providerview") ;
  String assignedTo = request.getParameter("assignedTo")==null?"all":request.getParameter("assignedTo") ;
%>

<%@ include file="dbTicker.jsp" %>
<%
GregorianCalendar now=new GregorianCalendar();
  int curYear = now.get(Calendar.YEAR);
  int curMonth = (now.get(Calendar.MONTH)+1);
  int curDay = now.get(Calendar.DAY_OF_MONTH);
  %>
<% //String providerview=request.getParameter("provider")==null?"":request.getParameter("provider");
  String ticklerview=request.getParameter("ticklerview")==null?"A":request.getParameter("ticklerview");
  String xml_vdate=request.getParameter("xml_vdate") == null?"":request.getParameter("xml_vdate");
  String xml_appointment_date = request.getParameter("xml_appointment_date")==null?MyDateFormat.getMysqlStandardDate(curYear, curMonth, curDay):request.getParameter("xml_appointment_date");

  java.util.Locale vLocale =(java.util.Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);

  ResourceBundle oscarR = ResourceBundle.getBundle("oscarResources",request.getLocale());

  String stActive = oscarR.getString("tickler.ticklerMain.stActive");
  String stComplete = oscarR.getString("tickler.ticklerMain.stComplete");
  String stDeleted = oscarR.getString("tickler.ticklerMain.stDeleted");
%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
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
<%@page import="oscar.util.SqlUtils"%>
<html:html locale="true">
<head>
<title><bean:message key="tickler.ticklerMain.title"/></title>
      <meta http-equiv="expires" content="Mon,12 May 1998 00:36:05 GMT">
      <meta http-equiv="Pragma" content="no-cache">

<script language="JavaScript">
function popupPage(vheight,vwidth,varpage) { //open a new popup window
  var page = "" + varpage;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes";
  var popup=window.open(page, "attachment", windowprops);
  if (popup != null) {
    if (popup.opener == null) {
      popup.opener = self;
    }
  }
}
function selectprovider(s) {
  if(self.location.href.lastIndexOf("&providerview=") > 0 ) a = self.location.href.substring(0,self.location.href.lastIndexOf("&providerview="));
  else a = self.location.href;
	self.location.href = a + "&providerview=" +s.options[s.selectedIndex].value ;
}
function openBrWindow(theURL,winName,features) {
  window.open(theURL,winName,features);
}
function setfocus() {
  this.focus();
}
function refresh() {
  var u = self.location.href;
  if(u.lastIndexOf("view=1") > 0) {
    self.location.href = u.substring(0,u.lastIndexOf("view=1")) + "view=0" + u.substring(eval(u.lastIndexOf("view=1")+6));
  } else {
    history.go(0);
  }
}



function allYear()
{
var newD = "9999-12-31";
var beginD = "0001-01-01"
	document.serviceform.xml_appointment_date.value = newD;
		document.serviceform.xml_vdate.value = beginD;
}

</script>
<script>

    function Check(e)
    {
	e.checked = true;
	//Highlight(e);
    }

    function Clear(e)
    {
	e.checked = false;
	//Unhighlight(e);
    }

    function CheckAll()
    {
	var ml = document.ticklerform;
	var len = ml.elements.length;
	for (var i = 0; i < len; i++) {
	    var e = ml.elements[i];
	    if (e.name == "checkbox") {
		Check(e);
	    }
	}
	//ml.toggleAll.checked = true;
    }

    function ClearAll()
    {
	var ml = document.ticklerform;
	var len = ml.elements.length;
	for (var i = 0; i < len; i++) {
	    var e = ml.elements[i];
	    if (e.name == "checkbox") {
		Clear(e);
	    }
	}
	//ml.toggleAll.checked = false;
    }

    function Highlight(e)
    {
	var r = null;
	if (e.parentNode && e.parentNode.parentNode) {
	    r = e.parentNode.parentNode;
	}
	else if (e.parentElement && e.parentElement.parentElement) {
	    r = e.parentElement.parentElement;
	}
	if (r) {
	    if (r.className == "msgnew") {
		r.className = "msgnews";
	    }
	    else if (r.className == "msgold") {
		r.className = "msgolds";
	    }
	}
    }

    function Unhighlight(e)
    {
	var r = null;
	if (e.parentNode && e.parentNode.parentNode) {
	    r = e.parentNode.parentNode;
	}
	else if (e.parentElement && e.parentElement.parentElement) {
	    r = e.parentElement.parentElement;
	}
	if (r) {
	    if (r.className == "msgnews") {
		r.className = "msgnew";
	    }
	    else if (r.className == "msgolds") {
		r.className = "msgold";
	    }
	}
    }

    function AllChecked()
    {
	ml = document.messageList;
	len = ml.elements.length;
	for(var i = 0 ; i < len ; i++) {
	    if (ml.elements[i].name == "Mid" && !ml.elements[i].checked) {
		return false;
	    }
	}
	return true;
    }

    function Delete()
    {
	var ml=document.messageList;
	ml.DEL.value = "1";
	ml.submit();
    }

    function SynchMoves(which) {
	var ml=document.messageList;
	if(which==1) {
	    ml.destBox2.selectedIndex=ml.destBox.selectedIndex;
	}
	else {
	    ml.destBox.selectedIndex=ml.destBox2.selectedIndex;
	}
    }

    function SynchFlags(which)
    {
	var ml=document.messageList;
	if (which == 1) {
	    ml.flags2.selectedIndex = ml.flags.selectedIndex;
	}
	else {
	    ml.flags.selectedIndex = ml.flags2.selectedIndex;
	}
    }

    function SetFlags()
    {
	var ml = document.messageList;
	ml.FLG.value = "1";
	ml.submit();
    }

    function Move() {
	var ml = document.messageList;
	var dbox = ml.destBox;
	if(dbox.options[dbox.selectedIndex].value == "@NEW") {
	    nn = window.prompt("<bean:message key="tickler.ticklerMain.msgFolderName"/>","");
	    if(nn == null || nn == "null" || nn == "") {
		dbox.selectedIndex = 0;
		ml.destBox2.selectedIndex = 0;
	    }
	    else {
		ml.NewFol.value = nn;
		ml.MOV.value = "1";
		ml.submit();
	    }
	}
	else {
	    ml.MOV.value = "1";
	    ml.submit();
	}
    }

</script>
<style type="text/css">
	<!--
	A, BODY, INPUT, OPTION ,SELECT , TABLE, TEXTAREA, TD, TR {font-family:tahoma,sans-serif; font-size:11px;}
	TD.black              {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FFFFFF; background-color: #666699   ;}
	TD.lilac              {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #EEEEFF  ;}
	TD.lilacRed              {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: red; background-color: #EEEEFF  ;}

	TD.boldlilac          {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #EEEEFF  ;}
	TD.lilac A:link       {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #EEEEFF  ;}
	TD.lilac A:visited    {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #EEEEFF  ;}
	TD.lilac A:hover      {font-weight: normal;                                                                            color: #000000; background-color: #CDCFFF  ;}
	TD.lilacRed A:link       {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: red; background-color: #EEEEFF  ;}
	TD.lilacRed A:visited    {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: red; background-color: #EEEEFF  ;}
	TD.lilacRed A:hover      {font-weight: normal;                                                                            color: red; background-color: #CDCFFF  ;}
	TD.whiteRed              {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: red; background-color: #FFFFFF;}

	TD.white              {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	TD.heading            {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FDCB03; background-color: #666699   ;}
	H2                    {font-weight: bold  ; font-size: 12pt; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	H3                    {font-weight: bold  ; font-size: 10pt; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	H4                    {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	H6                    {font-weight: bold  ; font-size: 7pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	A:link                {                     font-size: 8pt ; font-family: verdana,arial,helvetica; color: #336666; }
	A:visited             {                     font-size: 8pt ; font-family: verdana,arial,helvetica; color: #336666; }
	A:hover               {                                                                            color: red; background-color: #CDCFFF  ;}
	TD.cost               {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: red; background-color: #FFFFFF;}
	TD.black A:link       {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FFFFFF; background-color: #FFFFFF;}
	TD.black A:visited    {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FFFFFF; background-color: #FFFFFF;}
	TD.black A:hover      {                                                                            color: #FDCB03; background-color: #FFFFFF;}
	TD.title              {font-weight: bold  ; font-size: 10pt; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	TD.white A:link       {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	TD.white A:visited    {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #FFFFFF;}
	TD.white A:hover      {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #000000; background-color: #CDCFFF  ;}
	TD.whiteRed A:link       {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: red; background-color: #FFFFFF;}
		TD.whiteRed A:visited    {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: red; background-color: #FFFFFF;}
		TD.whiteRed A:hover      {font-weight: normal; font-size: 8pt ; font-family: verdana,arial,helvetica; color: red; background-color: #CDCFFF  ;}

	#navbar               {                     font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FDCB03; background-color: #666699   ;}
	SPAN.navbar A:link    {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #FFFFFF; background-color: #666699   ;}
	SPAN.navbar A:visited {font-weight: bold  ; font-size: 8pt ; font-family: verdana,arial,helvetica; color: #EFEFEF; background-color: #666699   ;}
	SPAN.navbar A:hover   {                                                                            color: #FDCB03; background-color: #666699   ;}
	SPAN.bold             {font-weight: bold  ;                                                                                            background-color: #666699   ;}
	.sbttn {background: #EEEEFF;border-bottom: 1px solid #104A7B;border-right: 1px solid #104A7B;border-left: 1px solid #AFC4D5;border-top:1px solid #AFC4D5;color:#000066;height:19px;text-decoration:none;cursor: hand}
.mbttn {background: #D7DBF2;border-bottom: 1px solid #104A7B;border-right: 1px solid #104A7B;border-left: 1px solid #AFC4D5;border-top:1px solid #AFC4D5;color:#000066;height:19px;text-decoration:none;cursor: hand}

	-->
</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" rightmargin="0" topmargin="10">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="#FFFFFF">
    <td height="10" width="70%"> </td>
    <td height="10" width="30%" align=right></td>
</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="#000000">
    <td height="40" width="10%"><input type='button' name='print' value='<bean:message key="global.btnPrint"/>' onClick='window.print()' class="sbttn"></td>
    <td width="90%" align="left">
      <p><font face="Verdana, Arial, Helvetica, sans-serif" color="#FFFFFF"><b><font face="Arial, Helvetica, sans-serif" size="4"><bean:message key="tickler.ticklerMain.msgTickler"/></font></b></font>
      </p>
    </td>
  </tr>
</table>
<table width="100%" border="0" bgcolor="#EEEEFF">
  <form name="serviceform" method="get" action="ticklerMain.jsp">
    <tr>
      <td width="19%">
        <div align="right"> <font color="#003366"><font face="Arial, Helvetica, sans-serif" size="2"><b>
          <font color="#333333"><bean:message key="tickler.ticklerMain.formDateRange"/></font></b></font></font> </div>
      </td>
      <td width="41%">
        <div align="center">
          <input type="text" name="xml_vdate" value="<%=xml_vdate%>">
          <font size="1" face="Arial, Helvetica, sans-serif"><a href="#" onClick="openBrWindow('../billing/billingCalendarPopup.jsp?type=admission&amp;year=<%=curYear%>&amp;month=<%=curMonth%>','','width=300,height=300')"><bean:message key="tickler.ticklerMain.btnBegin"/>:</a></font>
        </div>
      </td>
      <td width="40%">
        <input type="text" name="xml_appointment_date" value="<%=xml_appointment_date%>">
        <font size="1" face="Arial, Helvetica, sans-serif"><a href="#" onClick="openBrWindow('../billing/billingCalendarPopup.jsp?type=end&amp;year=<%=curYear%>&amp;month=<%=curMonth%>','','width=300,height=300')"><bean:message key="tickler.ticklerMain.btnEnd"/>:</a> &nbsp; &nbsp; <a href="#" onClick="allYear()"><bean:message key="tickler.ticklerMain.btnViewAll"/></a></font>
      </td>
    </tr>
    <tr>

        <td colspan="3">
        <font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#333333"><b><bean:message key="tickler.ticklerMain.formMoveTo"/> </b>
        <select name="ticklerview">
        <option value="A" <%=ticklerview.equals("A")?"selected":""%>><bean:message key="tickler.ticklerMain.formActive"/></option>
        <option value="C" <%=ticklerview.equals("C")?"selected":""%>><bean:message key="tickler.ticklerMain.formCompleted"/></option>
        <option value="D" <%=ticklerview.equals("D")?"selected":""%>><bean:message key="tickler.ticklerMain.formDeleted"/></option>
        </select>
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#333333"><b><bean:message key="tickler.ticklerMain.formSelectProvider"/> </b></font>
        <select name="providerview">
        <option value="%" <%=providerview.equals("all")?"selected":""%>><bean:message key="tickler.ticklerMain.formAllProviders"/></option>
        <%  String proFirst="";
            String proLast="";
            String proOHIP="";
            String specialty_code;
            String billinggroup_no;
            String temp=null;
            int Count = 0;
            ResultSet rslocal;
            rslocal = null;
            rslocal = apptMainBean.queryResults("%", "search_provider_all_dt");
            while(rslocal.next()){
                proFirst = rslocal.getString("first_name");
                proLast = rslocal.getString("last_name");
                proOHIP = rslocal.getString("provider_no");

                temp=rslocal.getString("comments");
                if (temp!=null)
                {
                	billinggroup_no= SxmlMisc.getXmlContent(temp,"<xml_p_billinggroup_no>","</xml_p_billinggroup_no>");
                    specialty_code = SxmlMisc.getXmlContent(temp,"<xml_p_specialty_code>","</xml_p_specialty_code>");
                }
                else
                {
                	billinggroup_no=null;
                	specialty_code=null;
                }
                

        %>
        <option value="<%=proOHIP%>" <%=providerview.equals(proOHIP)?"selected":""%>><%=proLast%>,
        <%=proFirst%></option>
        <%
            }

        %>
          </select>


          <!-- -->
          &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#333333"><b>Assigned To </b></font>
        <select name="assignedTo">
        <option value="%" <%=assignedTo.equals("all")?"selected":""%>><bean:message key="tickler.ticklerMain.formAllProviders"/></option>
        <%
            rslocal = null;
            rslocal = apptMainBean.queryResults("%", "search_provider_all");
            while(rslocal.next()){
                proFirst = rslocal.getString("first_name");
                proLast = rslocal.getString("last_name");
                proOHIP = rslocal.getString("provider_no");
        %>
        <option value="<%=proOHIP%>" <%=assignedTo.equals(proOHIP)?"selected":""%>><%=proLast%>, <%=proFirst%></option>
        <%}%>
          </select>



      <!--/td>
      <td -->
        <font color="#333333" size="2" face="Verdana, Arial, Helvetica, sans-serif">
        <input type="hidden" name="Submit" value="">
        <input type="button" value="<bean:message key="tickler.ticklerMain.btnCreateReport"/>" class="mbttn" onclick="document.forms['serviceform'].Submit.value='Create Report'; document.forms['serviceform'].submit();">
        </font>
        </td>
    </tr>

  </form>
</table>

<table bgcolor=#666699 border=0 cellspacing=0 width=100%><form name="ticklerform" method="post" action="dbTicklerMain.jsp">
<tr><td>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
<TR bgcolor=#666699>
<TD width="3%"><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="-2"><B></B></FONT></TD>
<TD width="17%"><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="-2"><B><bean:message key="tickler.ticklerMain.msgDemographicName"/></B></FONT></TD>
<TD width="17%"><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="-2"><B><bean:message key="tickler.ticklerMain.msgDoctorName"/></B></FONT></TD>
<TD width="9%"><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="-2"><B><bean:message key="tickler.ticklerMain.msgDate"/></B></FONT></TD>
<TD width="9%"><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="-2"><B><bean:message key="tickler.ticklerMain.msgCreationDate"/></B></FONT></TD>
<TD width="6%"><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="-2"><B><bean:message key="tickler.ticklerMain.Priority"/></B></FONT></TD>
<TD width="12%"><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="-2"><B><bean:message key="tickler.ticklerMain.taskAssignedTo"/></B></FONT></TD>

<TD width="6%"><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="-2"><B><bean:message key="tickler.ticklerMain.msgStatus"/></B></FONT></TD>
<TD width="30%"><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="-2"><B><bean:message key="tickler.ticklerMain.msgMessage"/></B></FONT></TD>
</TR>
<%
    String dateBegin = xml_vdate;
    String dateEnd = xml_appointment_date;
    String redColor = "", lilacColor = "" , whiteColor = "";
    String vGrantdate = "1980-01-07 00:00:00.0";
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:ss:mm.SSS", request.getLocale());
    String provider;
    String taskAssignedTo = "";
    if (dateEnd.compareTo("") == 0) dateEnd = MyDateFormat.getMysqlStandardDate(curYear, curMonth, curDay);
    if (dateBegin.compareTo("") == 0) dateBegin="0001-01-01";
    ResultSet rs=null ;
    String[] param =new String[5];
    boolean bodd=false;
    param[0] = ticklerview;

    if (dateBegin!=null) dateBegin=SqlUtils.isoToOracleDate(dateBegin);
    param[1] = dateBegin;
    if (dateEnd!=null) dateEnd=SqlUtils.isoToOracleDate(dateEnd);
    param[2] = dateEnd;
    param[3] = request.getParameter("providerview")==null?"%": request.getParameter("providerview");
    param[4] = request.getParameter("assignedTo")==null?"%": request.getParameter("assignedTo");
//   System.out.println(request.getParameter("assignedTo")==null?"%": request.getParameter("assignedTo"));
//System.err.println("***** "+Arrays.toString(param));
   
    rs = apptMainBean.queryResults(param, "search_tickler");
    while (rs.next()) {
       nItems = nItems +1;

        if (rs.getString("provider_last")==null || rs.getString("provider_first")==null){
            provider = "";
        }
        else{
            provider = rs.getString("provider_last") + ", " + rs.getString("provider_first");
        }

        if (rs.getString("assignedLast")==null || rs.getString("assignedFirst")==null){
            taskAssignedTo = "";
        }
        else{
            taskAssignedTo = rs.getString("assignedLast") + ", " + rs.getString("assignedFirst");
        }
        bodd=bodd?false:true;
        vGrantdate = rs.getString("service_date")+ ".0";
        java.util.Date grantdate = dateFormat.parse(vGrantdate);
        java.util.Date toDate = new java.util.Date();
        long millisDifference = toDate.getTime() - grantdate.getTime();
        long daysDifference = millisDifference / (1000 * 60 * 60 * 24);
if (daysDifference > 0){

%>

<tr >
<TD width="3%"  ROWSPAN="1" class="<%=bodd?"lilacRed":"whiteRed"%>"><input type="checkbox" name="checkbox" value="<%=rs.getString("tickler_no")%>"></TD>
<%
	if (vLocale.getCountry().equals("BR")) { %>
     <TD width="12%" ROWSPAN="1" class="<%=bodd?"lilacRed":"whiteRed"%>"><a href=# onClick="popupPage(600,800,'../demographic/demographiccontrol.jsp?demographic_no=<%=rs.getString("demographic_no")%>&displaymode=edit&dboperation=search_detail_ptbr')"><%=rs.getString("last_name")%>,<%=rs.getString("first_name")%></a></TD>
<%}else{%>
     <TD width="12%" ROWSPAN="1" class="<%=bodd?"lilacRed":"whiteRed"%>"><a href=# onClick="popupPage(600,800,'../demographic/demographiccontrol.jsp?demographic_no=<%=rs.getString("demographic_no")%>&displaymode=edit&dboperation=search_detail')"><%=rs.getString("last_name")%>,<%=rs.getString("first_name")%></a></TD>
<%}%>
<TD ROWSPAN="1" class="<%=bodd?"lilacRed":"whiteRed"%>"><%=provider%></TD>
<TD ROWSPAN="1" class="<%=bodd?"lilacRed":"whiteRed"%>">
	<%
		java.util.Date service_date = rs.getDate("service_date");
		SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyy-MM-dd");
		String service_date_str = dateFormat2.format(service_date);
		out.print(service_date_str);
	%> 
</TD>
<TD ROWSPAN="1" class="<%=bodd?"lilacRed":"whiteRed"%>">
	<%
		service_date = rs.getDate("update_date");
		dateFormat2 = new SimpleDateFormat("yyyy-MM-dd");
		service_date_str = dateFormat2.format(service_date);
		out.print(service_date_str);
	%> 
</TD>
<TD ROWSPAN="1" class="<%=bodd?"lilacRed":"whiteRed"%>"><%=rs.getString("priority")%></TD>
<TD ROWSPAN="1" class="<%=bodd?"lilacRed":"whiteRed"%>"><%=taskAssignedTo%></TD>
<TD ROWSPAN="1" class="<%=bodd?"lilacRed":"whiteRed"%>"><%=rs.getString("status").equals("A")?stActive:rs.getString("status").equals("C")?stComplete:rs.getString("status").equals("D")?stDeleted:rs.getString("status")%></TD>
<TD ROWSPAN="1" class="<%=bodd?"lilacRed":"whiteRed"%>"><%=rs.getString("message")%></TD>
 </tr>
<%
}else {
%>
<tr >
<TD width="3%"  ROWSPAN="1" class="<%=bodd?"lilac":"white"%>"><input type="checkbox" name="checkbox" value="<%=rs.getString("tickler_no")%>"></TD>
<%
	if (vLocale.getCountry().equals("BR")) { %>
      <TD width="12%" ROWSPAN="1" class="<%=bodd?"lilac":"white"%>"><a href=# onClick="popupPage(600,800,'../demographic/demographiccontrol.jsp?demographic_no=<%=rs.getString("demographic_no")%>&displaymode=edit&dboperation=search_detail_ptbr')"><%=rs.getString("last_name")%>,<%=rs.getString("first_name")%></a></TD>
<%}else{%>
      <TD width="12%" ROWSPAN="1" class="<%=bodd?"lilac":"white"%>"><a href=# onClick="popupPage(600,800,'../demographic/demographiccontrol.jsp?demographic_no=<%=rs.getString("demographic_no")%>&displaymode=edit&dboperation=search_detail')"><%=rs.getString("last_name")%>,<%=rs.getString("first_name")%></a></TD>
<%}%>
<TD ROWSPAN="1" class="<%=bodd?"lilac":"white"%>"><%=provider%></TD>
<TD ROWSPAN="1" class="<%=bodd?"lilac":"white"%>">
	<%
		java.util.Date service_date = rs.getDate("service_date");
		SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyy-MM-dd");
		String service_date_str = dateFormat2.format(service_date);
		out.print(service_date_str);
	%> 
</TD>
<TD ROWSPAN="1" class="<%=bodd?"lilac":"white"%>">
	<%
		service_date = rs.getDate("update_date");
		dateFormat2 = new SimpleDateFormat("yyyy-MM-dd");
		service_date_str = dateFormat2.format(service_date);
		out.print(service_date_str);
	%> 
</TD>
<TD ROWSPAN="1" class="<%=bodd?"lilac":"white"%>"><%=rs.getString("priority")%></TD>
<TD ROWSPAN="1" class="<%=bodd?"lilac":"white"%>"><%=taskAssignedTo%></TD>
<TD ROWSPAN="1" class="<%=bodd?"lilac":"white"%>"><%=rs.getString("status").equals("A")?stActive:rs.getString("status").equals("C")?stComplete:rs.getString("status").equals("D")?stDeleted:rs.getString("status")%></TD>
<TD ROWSPAN="1" class="<%=bodd?"lilac":"white"%>"><%=rs.getString("message")%></TD>
 </tr>
<%
}

%>

<%}

apptMainBean.closePstmtConn();

if (nItems == 0) {
%>
<tr><td colspan="8" class="white"><bean:message key="tickler.ticklerMain.msgNoMessages"/></td></tr>
<%}%>
<tr bgcolor=#666699><td colspan="8" class="white"><a href="javascript:CheckAll();"><bean:message key="tickler.ticklerMain.btnCheckAll"/></a> - <a href="javascript:ClearAll();"><bean:message key="tickler.ticklerMain.btnClearAll"/></a> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
<input type="button" name="button" value="<bean:message key="tickler.ticklerMain.btnAddTickler"/>" onClick="popupPage('400','600', 'ticklerAdd.jsp')" class="sbttn">
<input type="hidden" name="submit_form" value="">
<% if (ticklerview.compareTo("D") == 0){%>
<input type="button" value="<bean:message key="tickler.ticklerMain.btnEraseCompletely"/>" class="sbttn" onclick="document.forms['ticklerform'].submit_form.value='Erase Completely'; document.forms['ticklerform'].submit();">
<%} else{%>
<input type="button" value="<bean:message key="tickler.ticklerMain.btnComplete"/>" class="sbttn" onclick="document.forms['ticklerform'].submit_form.value='Complete'; document.forms['ticklerform'].submit();">
<input type="button" value="<bean:message key="tickler.ticklerMain.btnDelete"/>" class="sbttn" onclick="document.forms['ticklerform'].submit_form.value='Delete'; document.forms['ticklerform'].submit();">
<%}%>
<input type="button" name="button" value="<bean:message key="global.btnCancel"/>" onClick="window.close()" class="sbttn"> </td></tr>
</table></td></tr></form></table>
<p><font face="Arial, Helvetica, sans-serif" size="2"> </font></p>
  <p>&nbsp; </p>
<%@ include file="../demographic/zfooterbackclose.jsp" %>

</body>
</html:html>
