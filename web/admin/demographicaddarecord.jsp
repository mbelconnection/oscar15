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

<%@ page import="java.sql.*, java.util.*, oscar.MyDateFormat"
	errorPage="errorpage.jsp"%>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean"
	scope="session" />

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>

<html:html locale="true">
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<script LANGUAGE="JavaScript">
    <!--
    function start(){
      this.focus();
    }
    function closeit() {
      //parent.refresh();
      close();
    }   
    //-->
</script>
</head>
<body onload="start()" background="../images/gray_bg.jpg"
	bgproperties="fixed" topmargin="0" leftmargin="0" rightmargin="0">
<center>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr bgcolor="#486ebd">
		<th align="CENTER"><font face="Helvetica" color="#FFFFFF">
		<bean:message key="admin.demographicaddrecord.title" /></font></th>
	</tr>
</table>

<%
  //if action is good, then give me the result
	  //param[0]=Integer.parseInt((new GregorianCalendar()).get(Calendar.MILLISECOND) ); //int
    String[] param =new String[25];
	  param[0]=request.getParameter("last_name");
	  param[1]=request.getParameter("first_name");
	  param[2]=request.getParameter("address");
	  param[3]=request.getParameter("city");
	  param[4]=request.getParameter("province");
	  param[5]=request.getParameter("postal");
	  param[6]=request.getParameter("phone");
	  param[7]=request.getParameter("phone2");
	  param[8]=request.getParameter("year_of_birth");
	  param[9]=request.getParameter("month_of_birth");
	  param[10]=request.getParameter("date_of_birth");
	  param[11]=request.getParameter("hin");
	  param[12]=request.getParameter("ver");
	  param[13]=request.getParameter("roster_status");
	  param[14]=request.getParameter("patient_status");
	  param[15]=request.getParameter("date_joined");
	  param[16]=request.getParameter("chart_no");
	  param[17]=request.getParameter("staff");
	  param[18]=request.getParameter("sex");
	  param[19]=request.getParameter("end_date");
	  param[20]=request.getParameter("eff_date");
	  param[21]=request.getParameter("pcn_indicator");
	  param[22]=request.getParameter("hc_type");
	  param[23]=request.getParameter("hc_renew_date");
	  param[24]=request.getParameter("family_doctor");
	  
	  // should confirm the new DEMOGRAPHIC does not exist in database
	  // check dob and (hin) and lastname, if someone's there, alarm and provide the choice (go or stop).
	  // need to rs.close();?
    String[] paramName =new String[5];
	  paramName[0]=param[0].trim();
	  paramName[1]=param[1].trim();
	  paramName[2]=param[8].trim();
	  paramName[3]=param[9].trim();
	  paramName[4]=param[10].trim();
	  //System.out.println("from -------- :"+ param[0]+ ": next :"+param[1]);
    ResultSet rs = apptMainBean.queryResults(paramName, "search_lastfirstnamedob");
    System.out.println("Parametros de Add");
    System.out.println("0["+paramName[0]+"]");
    System.out.println("1["+paramName[1]+"]");
    System.out.println("2["+paramName[2]+"]");
    System.out.println("3["+paramName[3]+"]");
    System.out.println("4["+paramName[4]+"]");
    if(rs.next()){ //!rs.getString("cpp_id").equals(""))%> ***<font
	color='red'><bean:message
	key="admin.demographicaddrecord.msgDuplicated" />***</font><br>
<%}%> <%
    // int rowsAffected = apptMainBean.queryExecuteUpdate(intparam, param, request.getParameter("dboperation"));
    
  int rowsAffected = apptMainBean.queryExecuteUpdate(param, request.getParameter("dboperation")); //add_record
  if (rowsAffected ==1) {
    //find the demo_no 
    String[] param1 =new String[7];
	  param1[0]=request.getParameter("last_name");
	  param1[1]=request.getParameter("first_name");
	  param1[2]=request.getParameter("year_of_birth");
	  param1[3]=request.getParameter("month_of_birth");
	  param1[4]=request.getParameter("date_of_birth");
	  param1[5]=request.getParameter("hin");
	  param1[6]=request.getParameter("ver");
    
    rs = apptMainBean.queryResults(param1, "demographic_search_demoaddno");
    if(rs.next()) { //
	  	if (request.getParameter("dboperation2") != null) {
	  	  	String[] parametros = new String[13];
  	  	
	  	  	parametros[0]=apptMainBean.getString(rs,"demographic_no");
	  	  	parametros[1]=request.getParameter("cpf");
	  	  	parametros[2]=request.getParameter("rg");
	  	  	parametros[3]=request.getParameter("chart_address");
	  	  	parametros[4]=request.getParameter("marriage_certificate");
	  	  	parametros[5]=request.getParameter("birth_certificate");
	  	  	parametros[6]=request.getParameter("marital_state");
	  	  	parametros[7]=request.getParameter("partner_name");
	  	  	parametros[8]=request.getParameter("father_name");
	  	  	parametros[9]=request.getParameter("mother_name");
	  	  	parametros[10]=request.getParameter("district");
	  	  	parametros[11]=request.getParameter("address_no")==null || request.getParameter("address_no").trim().equals("")?"0":request.getParameter("address_no");
	  	  	parametros[12]=request.getParameter("complementary_address");
  	
  	
	  		rowsAffected = apptMainBean.queryExecuteUpdate(parametros, request.getParameter("dboperation2")); //add_record
	  	}
	}
      
  
%>
<p>
<h2><bean:message key="admin.demographicaddrecord.msgSuccessful" />
</h2>
</p>
<%  
  } else {
%>
<p>
<h1><bean:message key="admin.demographicaddrecord.msgFailed" /></h1>
</p>
<%  
  }
  apptMainBean.closePstmtConn();
%>
<p></p>
<%@ include file="footer2htm.jsp"%></center>
</body>
</html:html>