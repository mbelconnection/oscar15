<%--  
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
--%>

<table width="100%" border="2" valign="top">
	<% 
 String dateBegin = request.getParameter("xml_vdate");
   String dateEnd = request.getParameter("xml_appointment_date");
   if (dateEnd.compareTo("") == 0) dateEnd = MyDateFormat.getMysqlStandardDate(curYear, curMonth, curDay);
   if (dateBegin.compareTo("") == 0) dateBegin="0001-01-01";
 ResultSet rs=null ;
  String[] param =new String[3];
  param[0] = request.getParameter("providerview");
 param[1] = dateBegin;
  param[2] = dateEnd;
  rs = apptMainBean.queryResults(param, "search_unsettled_history_daterange");

  boolean bodd=false;
   nItems=0;
  String apptDoctorNo="", apptNo="", demoNo = "", demoName="", userno="", apptDate="", apptTime="", reason="",  note="";
  if(rs==null) {
    out.println("failed!!!"); 
  } else {
  %>
	<tr bgcolor="#CCCCFF">
		<TH align="center" width="20%"><b><font size="2"
			face="Arial, Helvetica, sans-serif">SERVICE DATE</font></b></TH>
		<TH align="center" width="10%"><b><font size="2"
			face="Arial, Helvetica, sans-serif">TIME</font></b></TH>
		<TH align="center" width="10%"><b><font size="2"
			face="Arial, Helvetica, sans-serif">PATIENT</font></b></TH>
		<TH align="center" width="20%"><b><font size="2"
			face="Arial, Helvetica, sans-serif">DESCRIPTION</font></b></TH>
		<TH align="center" width="10%"><b><font size="2"
			face="Arial, Helvetica, sans-serif">ACCOUNT</font></b></TH>
	</tr>
	<%
    while (rs.next()) {
     
      bodd=bodd?false:true; //for the color of rows
      nItems++; //to calculate if it is the end of records
      apptDoctorNo = rs.getString("apptProvider_no");
      apptNo = rs.getString("appointment_no");
      demoNo = rs.getString("demographic_no");
      demoName = rs.getString("demographic_name");
      userno=rs.getString("provider_no");
      apptDate = rs.getString("billing_date");
      apptTime = rs.getString("billing_time");
      reason = rs.getString("status");
      
      if (apptDoctorNo.compareTo("none") == 0){
      note = "No Appt / INR";
      } 
      else{
      if (apptDoctorNo.compareTo(userno) == 0) {
      note = "With Appt. Doctor";
      }else{
      note = "Unmatched Appt. Doctor";
      }
      }
      

%>
	<tr bgcolor="<%=bodd?"#EEEEFF":"white"%>">
		<TD align="center" width="20%"><b><font size="2"
			face="Arial, Helvetica, sans-serif"><%=apptDate%></font></b></TD>
		<TD align="center" width="10%"><b><font size="2"
			face="Arial, Helvetica, sans-serif"><%=apptTime==null?"00:00:00":apptTime%></font></b></TD>
		<TD align="center" width="10%"><b><font size="2"
			face="Arial, Helvetica, sans-serif"><%=demoName%></font></b></TD>
		<TD align="center" width="20%"><b><font size="2"
			face="Arial, Helvetica, sans-serif"><%=note%></font></b></TD>
		<TD align="center" width="10%"><b> <font size="2"
			face="Arial, Helvetica, sans-serif"><a href=#
			onClick='popupPage(700,720, "../../../billing/CA/BC/billingView.do?billing_no=<%=rs.getString("billing_no")%>&dboperation=search_bill&hotclick=0")'
			title="<%=reason%>"> <%=rs.getString("billing_no")%></a></font></b></TD>
	</tr>
	<%  rowCount = rowCount + 1;
    }
    if (rowCount == 0) {
    %>
	<tr bgcolor="<%=bodd?"ivory":"white"%>">
		<TD colspan="5" align="center"><b><font size="2"
			face="Arial, Helvetica, sans-serif">No unbill items</font></b></TD>
	</tr>
	<% }
  
}%>
</table>