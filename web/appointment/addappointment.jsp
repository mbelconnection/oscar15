<%
  if(session.getValue("user") == null)    response.sendRedirect("../logout.jsp");
  String curProvider_no = request.getParameter("provider_no");
  String curUser_no = (String) session.getAttribute("user");
  String userfirstname = (String) session.getAttribute("userfirstname");
  String userlastname = (String) session.getAttribute("userlastname");
  int everyMin=Integer.parseInt(((String) session.getAttribute("everymin")).trim());

  boolean bFirstDisp=true; //this is the first time to display the window
  if (request.getParameter("bFirstDisp")!=null) bFirstDisp= (request.getParameter("bFirstDisp")).equals("true");
  String duration = request.getParameter("duration")!=null?(request.getParameter("duration").equals(" ")||request.getParameter("duration").equals("")||request.getParameter("duration").equals("null")?(""+everyMin) :request.getParameter("duration")):(""+everyMin) ;
%>
<%@ page import="java.util.*, java.sql.*, oscar.*, java.text.*, java.lang.*,java.net.*" errorPage="../appointment/errorpage.jsp" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<jsp:useBean id="addApptBean" class="oscar.AppointmentMainBean" scope="page" />
<%@ include file="../admin/dbconnection.jsp" %>
<% 
  String [][] dbQueries=new String[][] { 
    {"search_appt", "select count(appointment_no) AS n from appointment where appointment_date = ? and provider_no = ? and status !='C' and ((start_time>= ? and start_time<= ?) or (end_time>= ? and end_time<= ?) or (start_time<= ? and end_time>= ?) )" }, 
    {"search_demographiccust_alert", "select cust3 from demographiccust where demographic_no = ? " }, 
    {"search_demographic_statusroster", "select patient_status,roster_status from demographic where demographic_no = ? " }, 
  };
  addApptBean.doConfigure(dbParams,dbQueries);
%>

<html:html locale="true">
<head><title><bean:message key="appointment.addappointment.title"/></title>

<script language="javascript">
<!-- start javascript ---- check to see if it is really empty in database
function setfocus() {
	this.focus();
  document.ADDAPPT.keyword.focus();
  document.ADDAPPT.keyword.select();
}
function upCaseCtrl(ctrl) {
	ctrl.value = ctrl.value.toUpperCase();
}
function onBlockFieldFocus(obj) {
  obj.blur();
  document.ADDAPPT.keyword.focus();
  document.ADDAPPT.keyword.select();
  window.alert("<bean:message key="Appointment.msgFillNameField"/>");
}
function checkTypeNum(typeIn) {
	var typeInOK = true;
	var i = 0;
	var length = typeIn.length;
	var ch;
	// walk through a string and find a number
	if (length>=1) {
	  while (i <  length) {
		  ch = typeIn.substring(i, i+1);
		  if (ch == ":") { i++; continue; }
		  if ((ch < "0") || (ch > "9") ) {
			  typeInOK = false;
			  break;
		  }
	    i++;
    }
	} else typeInOK = false;
	return typeInOK;
}
function checkTimeTypeIn(obj) {
  if(!checkTypeNum(obj.value) ) {
	  alert ("<bean:message key="Appointment.msgFillTimeField"/>");
	} else {
	  if(obj.value.indexOf(':')==-1) {
	    if(obj.value.length < 3) alert("<bean:message key="Appointment.msgFillValidTimeField"/>");
	    obj.value = obj.value.substring(0, obj.value.length-2 )+":"+obj.value.substring( obj.value.length-2 );
	  } 
	}
}
function calculateEndTime() {
  var stime = document.ADDAPPT.start_time.value;
  var vlen = stime.indexOf(':')==-1?1:2;
 
  var shour = stime.substring(0,2) ;
  var smin = stime.substring(stime.length-vlen) ;
  var duration = document.ADDAPPT.duration.value ;
  if(eval(duration) == 0) { duration =1; }
  if(eval(duration) < 0) { duration = Math.abs(duration) ; }
  
  var lmin = eval(smin)+eval(duration)-1 ;
  var lhour = parseInt(lmin/60);
  
  if((lmin) > 59) {
    shour = eval(shour) + eval(lhour);
    shour = shour<10?("0"+shour):shour;
    smin = lmin - 60*lhour;
  } else {
    smin = lmin;
  }
  smin = smin<10?("0"+ smin):smin;
  document.ADDAPPT.end_time.value = shour +":"+ smin;
  
  if(shour > 23) {
    alert("<bean:message key="Appointment.msgCheckDuration"/>");
    return false;
  }
  
  //no show
  if(document.ADDAPPT.keyword.value.substring(0,1)=="." && document.ADDAPPT.demographic_no.value=="" ) {
    document.ADDAPPT.status.value = 'N' ;
  }
}

function onButRepeat() {
	document.forms[0].action = "appointmentrepeatbooking.jsp" ;
	document.forms[0].submit();
}
// stop javascript -->
</script>

</head>
<meta http-equiv="Cache-Control" content="no-cache" >

<%
  SimpleDateFormat fullform = new SimpleDateFormat ("yyyy-MM-dd HH:mm");
  SimpleDateFormat inform = new SimpleDateFormat ("yyyy-MM-dd");
  SimpleDateFormat outform = new SimpleDateFormat ("EEE");
  java.util.Date apptDate = fullform.parse(bFirstDisp?(request.getParameter("year")+"-"+request.getParameter("month")+"-"+request.getParameter("day")+" "+ request.getParameter("start_time")):(request.getParameter("appointment_date")+" "+ request.getParameter("start_time") )) ;
  String dateString1 = outform.format(apptDate );
  String dateString2 = inform.format(apptDate );

	GregorianCalendar caltime =new GregorianCalendar( );
	caltime.setTime(apptDate);
	caltime.add(caltime.MINUTE, Integer.parseInt(duration)-1 );

  String [] param = new String[8] ;
  param[0] = dateString2;
  param[1] = curProvider_no;
  param[2] = request.getParameter("start_time");
  param[3] = caltime.get(Calendar.HOUR_OF_DAY) +":"+ caltime.get(Calendar.MINUTE);
//	System.out.println(param[3] );
  param[4] = param[2];
  param[5] = param[3];
  param[6] = param[2];
  param[7] = param[3];
	ResultSet rsdemo = addApptBean.queryResults(param, "search_appt");
	int apptnum = rsdemo.next()?rsdemo.getInt("n"):0 ;
  String deepcolor = apptnum==0?"#CCCCFF":"gold", weakcolor = apptnum==0?"#EEEEFF":"ivory";
%>
<body  background="../images/gray_bg.jpg" bgproperties="fixed"  onLoad="setfocus()" topmargin="0"  leftmargin="0" rightmargin="0">
<FORM NAME = "ADDAPPT" METHOD="post" ACTION="appointmentcontrol.jsp" onsubmit="return(calculateEndTime())">
<INPUT TYPE="hidden" NAME="displaymode" value="">

<table border=0 cellspacing=0 cellpadding=0 width="100%" >
  <tr bgcolor="<%=deepcolor%>"><th><font face="Helvetica"><bean:message key="appointment.addappointment.msgMainLabel"/></font></th></tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr><td width="100%">
  
        <table BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="100%" BGCOLOR="#C0C0C0">
          <tr valign="middle" BGCOLOR="#EEEEFF"> 
            <td width="20%"> 
              <div align="right"><font face="arial"><bean:message key="Appointment.formDate"/><font size='-1' color='brown'>(<%=dateString1%>)</font>:</font></div>
            </td>
            <td width="20%"> 
              <INPUT TYPE="TEXT" NAME="appointment_date" VALUE="<%=dateString2%>" WIDTH="25" HEIGHT="20" border="0" hspace="2">
            </td>
            <td width="5%" ></td>
            <td width="20%"> 
              <div align="right"><font face="arial"><bean:message key="Appointment.formStatus"/>:</font></div>
            </td>
            <td width="20%"> 
              <INPUT TYPE="TEXT" NAME="status" VALUE="<%=bFirstDisp?"t":request.getParameter("status").equals("")?"":request.getParameter("status")%>"  WIDTH="25" HEIGHT="20" border="0" hspace="2">
            </td>
          </tr>
          <tr valign="middle" BGCOLOR="#EEEEFF"> 
            <td width="20%"> 
              <div align="right"><font face="arial"><font face="arial"><bean:message key="Appointment.formStartTime"/>:</font></font></div>
            </td>
            <td width="20%"> 
              <INPUT TYPE="TEXT" NAME="start_time" VALUE="<%=request.getParameter("start_time")%>" WIDTH="25" HEIGHT="20" border="0"  onChange="checkTimeTypeIn(this)">
            </td>
            <td width="5%" ></td>
            <td width="20%" > 
              <div align="right"><font face="arial"><bean:message key="Appointment.formType"/>:</font></div>
            </td>
            <td width="20%"> 
              <INPUT TYPE="TEXT" NAME="type" VALUE="<%=bFirstDisp?"":request.getParameter("type").equals("")?"":request.getParameter("type")%>" WIDTH="25" HEIGHT="20" border="0" hspace="2">
            </td>
          </tr>
          <tr valign="middle" BGCOLOR="#EEEEFF" > 
            <td width="20%"  align="right"> 
              <font face="arial"><bean:message key="Appointment.formDuration"/>:</font>
              <!--font face="arial"> End Time :</font-->
            </td>
            <td width="20%"> 
              <INPUT TYPE="TEXT" NAME="duration" VALUE="<%=duration%>" WIDTH="25" HEIGHT="20" border="0" hspace="2" >
              <INPUT TYPE="hidden" NAME="end_time" VALUE="<%=request.getParameter("end_time")%>" WIDTH="25" HEIGHT="20" border="0" hspace="2"  onChange="checkTimeTypeIn(this)">
            </td>
            <td width="5%" ></td>
            <td width="20%"> 
              <div align="right"></div>
            </td>
            <td width="20%">&nbsp; </td>
          </tr>
          <tr valign="middle" BGCOLOR="#CCCCFF"> 
            <td width="20%"> 
              <div align="right"><font face="arial"><bean:message key="appointment.addappointment.formSurName"/>:</font></div>
            </td>
            <td width="20%"> 
              <INPUT TYPE="TEXT" NAME="keyword" VALUE="<%=bFirstDisp?"":request.getParameter("name").equals("")?session.getAttribute("appointmentname"):request.getParameter("name")%>" HEIGHT="20" border="0" hspace="2" width="25" tabindex="1">
            </td>
            <td width="5%"></td>
            <td width="20%"> 
              <div align="right"><font face="arial">
				      <INPUT TYPE="hidden" NAME="orderby" VALUE="last_name, first_name" >
				      <INPUT TYPE="hidden" NAME="search_mode" VALUE="search_name" >
				      <INPUT TYPE="hidden" NAME="originalpage" VALUE="../appointment/addappointment.jsp" >
				      <INPUT TYPE="hidden" NAME="limit1" VALUE="0" >
				      <INPUT TYPE="hidden" NAME="limit2" VALUE="5" >
				      <INPUT TYPE="hidden" NAME="ptstatus" VALUE="active">
              <!--input type="hidden" name="displaymode" value="Search " -->
              <INPUT TYPE="submit" onclick="document.forms['ADDAPPT'].displaymode.value='Search '" VALUE="<bean:message key="appointment.addappointment.btnSearch"/>"></font></div>
            </td>
            <td width="20%" > 
              <input type="TEXT" name="demographic_no" ONFOCUS="onBlockFieldFocus(this)" readonly value="<%=bFirstDisp?"":request.getParameter("demographic_no").equals("")?"":request.getParameter("demographic_no")%>" width="25" height="20" border="0" hspace="2">
            </td>
          </tr>
          <tr valign="middle" BGCOLOR="#CCCCFF"> 
            <td width="20%"> 
              <div align="right"><font face="arial"><bean:message key="Appointment.formReason"/>:</font></div>
            </td>
            <td width="20%"><font face="Times New Roman">
              <textarea name="reason"  tabindex="2" rows="2" wrap="virtual" cols="18"><%=bFirstDisp?"":request.getParameter("reason").equals("")?"":request.getParameter("reason")%></textarea>
              </font> </TD>
            <td width="5%"><font face="Times New Roman"> </font></td>
            <td width="20%"> 
              <div align="right"><font face="arial"><bean:message key="Appointment.formNotes"/>:</font></div>
            </td>
            <td width="20%"><font face="Times New Roman">
              <textarea name="notes"  tabindex="3" rows="2" wrap="virtual" cols="18"><%=bFirstDisp?"":request.getParameter("notes").equals("")?"":request.getParameter("notes")%></textarea>
              </font> </td>
          </tr>
          <tr valign="middle" BGCOLOR="#EEEEFF"> 
            <td width="20%"> 
              <div align="right"><font face="arial"><bean:message key="Appointment.formLocation"/>:</font></div>
            </td>
            <td width="20%"> 
              <input type="TEXT" name="location"  tabindex="4" value="<%=bFirstDisp?"":request.getParameter("location").equals("")?"":request.getParameter("location")%>" width="25" height="20" border="0" hspace="2">
            </TD>
            <td width="5%" ></td>
            <td width="20%"> 
              <div align="right"><font face="arial"><bean:message key="Appointment.formResources"/>:</font></div>
            </td>
            <td width="20%"> 
              <input type="TEXT" name="resources"  tabindex="5" value="<%=bFirstDisp?"":request.getParameter("resources").equals("")?"":request.getParameter("resources")%>" width="25" height="20" border="0" hspace="2">
            </td>
          </tr>
          <tr valign="middle" BGCOLOR="#EEEEFF"> 
            <td width="20%"> 
              <div align="right"><font face="arial"><bean:message key="Appointment.formCreator"/>:</font></div>
            </td>
            <td width="20%"> 
              <INPUT TYPE="TEXT" NAME="user_id" readonly VALUE='<%=bFirstDisp?(userlastname+", "+userfirstname):request.getParameter("user_id").equals("")?"Unknown":request.getParameter("user_id")%>' WIDTH="25" HEIGHT="20" border="0" hspace="2">
            </td>
            <td width="5%" ></td>
            <td width="20%"> 
              <div align="right"><font face="arial"><bean:message key="Appointment.formDateTime"/>:</font></div>
            </td>
            <td width="20%"> <%
				GregorianCalendar now=new GregorianCalendar();
                        GregorianCalendar cal = (GregorianCalendar) now.clone();
                        cal.add(cal.DATE, 1);
				String strDateTime=now.get(Calendar.YEAR)+"-"+(now.get(Calendar.MONTH)+1)+"-"+now.get(Calendar.DAY_OF_MONTH)+" "
					+	now.get(Calendar.HOUR_OF_DAY)+":"+now.get(Calendar.MINUTE)+":"+now.get(Calendar.SECOND);
			%> 
			
              <INPUT TYPE="TEXT" NAME="createdatetime" readonly VALUE="<%=strDateTime%>" WIDTH="25" HEIGHT="20" border="0" hspace="2">
              <INPUT TYPE="hidden" NAME="provider_no" VALUE="<%=curProvider_no%>">
              <INPUT TYPE="hidden" NAME="dboperation" VALUE="add_apptrecord">
              <INPUT TYPE="hidden" NAME="creator" VALUE="<%=userlastname+", "+userfirstname%>">
              <INPUT TYPE="hidden" NAME="remarks" VALUE="">
            </td>
          </tr>
        </table>
	
	</td></tr>
</table>

<table width="100%" BGCOLOR="<%=deepcolor%>">
  <tr>
    <TD nowrap>
        <INPUT TYPE="submit" onclick="document.forms['ADDAPPT'].displaymode.value='Group Appt'" VALUE="<bean:message key="appointment.addappointment.btnGroupAppt"/>" >
<%
  if(dateString2.equals( inform.format(inform.parse(now.get(Calendar.YEAR)+"-"+(now.get(Calendar.MONTH)+1)+"-"+now.get(Calendar.DAY_OF_MONTH))) ) 
     || dateString2.equals( inform.format(inform.parse(cal.get(Calendar.YEAR)+"-"+(cal.get(Calendar.MONTH)+1)+"-"+cal.get(Calendar.DAY_OF_MONTH))) ) ) {
    org.apache.struts.util.MessageResources resources = org.apache.struts.util.MessageResources.getMessageResources("oscarResources");
    %><INPUT TYPE="submit" onclick="document.forms['ADDAPPT'].displaymode.value='Add Appt & PrintPreview'" VALUE="<bean:message key='appointment.addappointment.btnAddApptPrintPreview'/>"><%
  }
%>        
        <INPUT TYPE="submit" onclick="document.forms['ADDAPPT'].displaymode.value='Add Appointment'" tabindex="6" VALUE="<bean:message key="appointment.addappointment.btnAddAppointment"/>">
      </TD>
    <TD></TD>
    <TD align="right"><INPUT TYPE = "RESET" VALUE = "<bean:message key="appointment.addappointment.btnCancel"/>" onClick="window.close();">
	<input type="button" value="<bean:message key="appointment.addappointment.btnRepeat"/>" onclick="onButRepeat()">
    </TD>
  </tr>
</TABLE>

</FORM>
<%
  //to show Alert msg
  if (!bFirstDisp && !request.getParameter("demographic_no").equals("")) {
	  rsdemo = addApptBean.queryResults(request.getParameter("demographic_no"), "search_demographic_statusroster");
      while (rsdemo.next()) { 
		  String patientStatus = rsdemo.getString("patient_status");
            if (patientStatus == null || patientStatus.equalsIgnoreCase("AC")) {
               patientStatus = "";
            }
            String rosterStatus = rsdemo.getString("roster_status");
            if (rosterStatus == null || rosterStatus.equalsIgnoreCase("RO")) {
               rosterStatus = "";
            }
/*          patientStatus = (patientStatus != null && !patientStatus.equalsIgnoreCase("AC")) ? 
			  (" Patient Status:<font color='yellow'>" + patientStatus + "</font>" ) : "";

		  String rosterStatus = rsdemo.getString("roster_status");
          rosterStatus = (rosterStatus != null && !rosterStatus.equalsIgnoreCase("RO")) ?
			  (" Roster Status:<font color='yellow'>" + rosterStatus + "</font> ") : "";
*/

		  if(!patientStatus.equals("") || !rosterStatus.equals("") ) {
              String rsbgcolor = "BGCOLOR=\"orange\"" ;
			  String exp = " null-undefined\n IN-inactive ID-deceased OP-out patient\n NR-not signed\n FS-fee for service\n TE-terminated\n SP-self pay\n TP-third party";
%>
<table width="98%" <%=rsbgcolor%> border=0 align='center'>
  <tr><td><font color='blue' title='<%=exp%>'> <b><bean:message key="Appointment.msgPatientStatus"/>:&nbsp;<font color='yellow'><%=patientStatus%></font>&nbsp;<bean:message key="Appointment.msgRosterStatus"/>:&nbsp;<font color='yellow'><%=rosterStatus%></font></b></td>
  </tr>
</table>
<% 
	      }
      }
	  rsdemo = addApptBean.queryResults(request.getParameter("demographic_no"), "search_demographiccust_alert");
      while (rsdemo.next()) { 
          if(rsdemo.getString("cust3")!=null && !rsdemo.getString("cust3").equals("") ) {
%>
<p>
<table width="98%" BGCOLOR="yellow" border=1 align='center'>
  <tr><td><font color='red'><bean:message key="Appointment.formAlert"/>: <b><%=rsdemo.getString("cust3")%></b></td>
  </tr>
</table>

<%    
          }
      }
      addApptBean.closePstmtConn();
  }
  
  if(apptnum!=0) {
%>
<table width="98%" BGCOLOR="<%=deepcolor%>" border=1 align='center'>
  <tr>
<%--    <TH><font color='red'><%=apptnum>1?"Double ++ ":"Double"%> Booking</font></TH>--%>
    <TH><font color='red'>
    <% if(apptnum>1) {
         %><bean:message key='appointment.addappointment.msgBooking'/><%
       } else {
          %><bean:message key='appointment.addappointment.msgDoubleBooking'/><%
       }
     %></font></TH>
  </tr>
</TABLE>

<% } %>

</body>
</html:html>
