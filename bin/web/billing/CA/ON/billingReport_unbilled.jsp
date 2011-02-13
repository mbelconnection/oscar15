<table width="100%" border="2" valign="top">
	<% 
String dateBegin = request.getParameter("xml_vdate");
String dateEnd = request.getParameter("xml_appointment_date");
if (dateEnd.compareTo("") == 0) dateEnd = MyDateFormat.getMysqlStandardDate(curYear, curMonth, curDay);
if (dateBegin.compareTo("") == 0) dateBegin="2001-01-01";

String[] param =new String[3];
param[0] = request.getParameter("providerview");
param[1] = dateBegin;
param[2] = dateEnd;
ResultSet rs = apptMainBean.queryResults(param, "search_unbill_history_daterange");

boolean bodd=false;
nItems=0;
String apptNo="", demoNo = "", demoName="", userno="", apptDate="", apptTime="", reason="";
if(rs==null) {
	out.println("failed!!!"); 
} else {
%>
	<tr bgcolor="#CCCCFF">
		<TH width="20%"><b><font size="2"
			face="Arial, Helvetica, sans-serif">SERVICE DATE</font></b></TH>
		<TH width="10%"><b><font size="2"
			face="Arial, Helvetica, sans-serif">TIME</font></b></TH>
		<TH width="10%"><b><font size="2"
			face="Arial, Helvetica, sans-serif">PATIENT</font></b></TH>
		<TH width="20%"><b><font size="2"
			face="Arial, Helvetica, sans-serif">DESCRIPTION</font></b></TH>
		<TH width="10%"><b><font size="2"
			face="Arial, Helvetica, sans-serif">COMMENTS</font></b></TH>
	</tr>
	<%
	while (rs.next()) {
		bodd=bodd?false:true; //for the color of rows
		nItems++; //to calculate if it is the end of records
		apptNo = rs.getString("appointment_no");
		demoNo = rs.getString("demographic_no");
		demoName = rs.getString("name");
		userno=rs.getString("provider_no");
		apptDate = rs.getString("appointment_date");
		apptTime = rs.getString("start_time");
		reason = rs.getString("reason");
%>
	<tr bgcolor="<%=bodd?"#EEEEFF":"white"%>" align="center">
		<TD width="20%"><b><font size="2"
			face="Arial, Helvetica, sans-serif"><%=apptDate%></font></b></TD>
		<TD width="10%"><b><font size="2"
			face="Arial, Helvetica, sans-serif"><%=apptTime%></font></b></TD>
		<TD width="10%"><b><font size="2"
			face="Arial, Helvetica, sans-serif"><%=demoName%></font></b></TD>
		<TD width="20%"><b><font size="2"
			face="Arial, Helvetica, sans-serif"><%=reason%></font></b></TD>
		<TD width="10%"><b> <font size="2"
			face="Arial, Helvetica, sans-serif"><a href=#
			onClick='popupPage(700,720, "billingOB.jsp?billForm=<%=URLEncoder.encode(oscarVariables.getProperty("default_view"))%>&hotclick=&appointment_no=<%=apptNo%>&demographic_name=<%=URLEncoder.encode(demoName)%>&demographic_no=<%=demoNo%>&user_no=<%=userno%>&apptProvider_no=<%=providerview%>&appointment_date=<%=apptDate%>&start_time=<%=apptTime%>&bNewForm=1")'
			title="<%=reason%>">Bill |$|</a></font></b></TD>
	</tr>
	<%
		rowCount = rowCount + 1;
	}

	if (rowCount == 0) {
%>
	<tr bgcolor="<%=bodd?"ivory":"white"%>">
		<TD colspan="5"><b><font size="2"
			face="Arial, Helvetica, sans-serif">No unbill items</font></b></TD>
	</tr>
	<% 
	}
}
%>
</table>
