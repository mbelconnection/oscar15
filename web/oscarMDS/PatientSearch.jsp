<%@ page
	import="java.util.*, java.sql.*,java.net.*, oscar.oscarDB.DBPreparedHandler, oscar.MyDateFormat, oscar.Misc"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<% 

// Apologies for the crap code.  Definitely could do with a major rewrite...

  if(session.getValue("user") == null)    response.sendRedirect("../logout.jsp");
  // String curProvider_no = (String) session.getAttribute("user");
  String curProvider_no = request.getParameter("provider_no");
  String strLimit1="0";
  String strLimit2="10";
  StringBuffer bufChart = null, bufName = null, bufNo = null;
  if(request.getParameter("limit1")!=null) strLimit1 = request.getParameter("limit1");
  if(request.getParameter("limit2")!=null) strLimit2 = request.getParameter("limit2");
%>


<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean"
	scope="session" />
<jsp:useBean id="providerBean" class="java.util.Properties"
	scope="session" />


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



<html>
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<title><bean:message
	key="oscarMDS.segmentDisplay.patientSearch.title" /></title>
<meta http-equiv="Expires" content="Monday, 8 Aug 88 18:18:18 GMT">
<meta http-equiv="Cache-Control" content="no-cache">
<script language="JavaScript">
<!--
function setfocus() {
  this.focus();
  document.titlesearch.keyword.focus();
  document.titlesearch.keyword.select();
}
function checkTypeIn() {
  var dob = document.titlesearch.keyword ;
  if(document.titlesearch.search_mode[2].checked) {
    if(dob.value.length==8) {
      dob.value = dob.value.substring(0, 4)+"-"+dob.value.substring(4, 6)+"-"+dob.value.substring(6, 8);
      //alert(dob.value.length);
    }
    if(dob.value.length != 10) {
      alert("DOB format is incorrect");
      return false;
    }
  }
}

function confirmMatch(last_name,first_name) {
	if(confirm("Are you sure you want to associate lab with patient " + last_name + "," + first_name + "?")) {
		return true;	
	}
	return false;
}
//-->
</SCRIPT>
</head>
<body background="../images/gray_bg.jpg" bgproperties="fixed"
	onLoad="setfocus()" topmargin="0" leftmargin="0" rightmargin="0">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr bgcolor="#486ebd">
		<th align=CENTER NOWRAP><font face="Helvetica" color="#FFFFFF">PATIENT
		MATCHING</font></th>
	</tr>
</table>

<table border="0" cellpadding="1" cellspacing="0" width="100%"
	bgcolor="#C4D9E7">
	<form method="post" name="titlesearch" action="PatientSearch.jsp"
		onSubmit="return checkTypeIn();"><input type="hidden"
		name="labNo" value="<%=request.getParameter("labNo")%>" /> <input
		type="hidden" name="labType"
		value="<%=request.getParameter("labType")%>" /> <%--@ include file="zdemographictitlesearch.htm"--%>
	<tr valign="top">
		<td rowspan="2" ALIGN="right" valign="middle"><font
			face="Verdana" color="#0000FF"><b><i>Search</i></b></font></td>
		<td width="10%" nowrap><font size="1" face="Verdana"
			color="#0000FF"> <input type="radio" checked
			name="search_mode" value="search_name"> <bean:message
			key="oscarMDS.segmentDisplay.patientSearch.formName" /> </font></td>
		<td nowrap><font size="1" face="Verdana" color="#0000FF">
		<input type="radio" name="search_mode" value="search_phone"> <bean:message
			key="oscarMDS.segmentDisplay.patientSearch.formPhone" /> </font></td>
		<td nowrap><font size="1" face="Verdana" color="#0000FF">
		<input type="radio" name="search_mode" value="search_dob"> <bean:message
			key="oscarMDS.segmentDisplay.patientSearch.formDOB" /> </font></td>
		<td valign="middle" rowspan="2" ALIGN="left"><input type="text"
			NAME="keyword" SIZE="17" MAXLENGTH="100"
			value="<%=request.getParameter("keyword")%>"> <INPUT
			TYPE="hidden" NAME="orderby" VALUE="last_name"> <INPUT
			TYPE="hidden" NAME="dboperation" VALUE="search_titlename"> <INPUT
			TYPE="hidden" NAME="limit1" VALUE="0"> <INPUT TYPE="hidden"
			NAME="limit2" VALUE="5"> <input type="hidden"
			name="displaymode" value="Search "> <input type="SUBMIT"
			name="displaymode"
			value="<bean:message key="oscarMDS.segmentDisplay.patientSearch.btnSearch"/>"
			size="17"></td>
	</tr>
	<tr>
		<td nowrap><font size="1" face="Verdana" color="#0000FF">
		<input type="radio" name="search_mode" value="search_address">
		<bean:message key="oscarMDS.segmentDisplay.patientSearch.formAddress" />
		</font></td>
		<td nowrap><font size="1" face="Verdana" color="#0000FF">
		<input type="radio" name="search_mode" value="search_hin"> <bean:message
			key="oscarMDS.segmentDisplay.patientSearch.formHIN" /> </font></td>
		<td>&nbsp;</td>
	</tr>
	</form>
</table>

<table width="95%" border="0">
	<tr>
		<td align="left"><font size="-1"> <i><bean:message
			key="oscarMDS.segmentDisplay.patientSearch.msgResults" /></i> : <%=request.getParameter("keyword")%>
		</font></td>
	</tr>
</table>


<script language="JavaScript">
        <!--
        var fullname="";
        function addName(lastname, firstname, chartno) {
          fullname=lastname+","+firstname;
          document.addform.action="<%=request.getParameter("originalpage")%>?name="+fullname+"&chart_no="+chartno+"&bFirstDisp=false";  //+"\"" ;
          document.addform.submit(); // 
          //return;
        }
        //-->
   </SCRIPT>

<CENTER>
<table width="100%" border="1" cellpadding="0" cellspacing="1"
	bgcolor="#ffffff">
	<form method="post" name="addform" action="PatientMatch.do"><input
		type="hidden" name="labNo" value="<%=request.getParameter("labNo")%>">
	<input type="hidden" name="labType"
		value="<%=request.getParameter("labType")%>" />
	<tr bgcolor="#339999">
		<TH align="center" width="20%"><b><bean:message
			key="oscarMDS.segmentDisplay.patientSearch.msgPatientId" /></b></TH>
		<TH align="center" width="20%"><b><bean:message
			key="oscarMDS.segmentDisplay.patientSearch.msgLastName" /></b></TH>
		<TH align="center" width="20%"><b><bean:message
			key="oscarMDS.segmentDisplay.patientSearch.msgFirstName" /></b></TH>
		<TH align="center" width="5%"><b><bean:message
			key="oscarMDS.segmentDisplay.patientSearch.msgAge" /></b></TH>
		<TH align="center" width="10%"><b><bean:message
			key="oscarMDS.segmentDisplay.patientSearch.msgRosterStatus" /></b></TH>
		<TH align="center" width="5%"><b><bean:message
			key="oscarMDS.segmentDisplay.patientSearch.msgSex" /></B></TH>
		<TH align="center" width="10%"><b><bean:message
			key="oscarMDS.segmentDisplay.patientSearch.msgDOB" /></B></TH>
		<TH align="center" width="10%"><b><bean:message
			key="oscarMDS.segmentDisplay.patientSearch.msgDoctor" /></B></TH>
	</tr>

	<%
  GregorianCalendar now=new GregorianCalendar();
  int curYear = now.get(Calendar.YEAR);
  int curMonth = (now.get(Calendar.MONTH)+1);
  int curDay = now.get(Calendar.DAY_OF_MONTH);
  int age=0;
  
  ResultSet rs=null;
  Properties props = (Properties) request.getSession().getAttribute("oscarVariables");
  DBPreparedHandler db = new DBPreparedHandler();
  
  String keyword="";
  if ( request.getParameter("keyword") != null ) {        
    keyword = request.getParameter("keyword").trim();    
  }

  String orderby="", limit="", limit1="", limit2="";
  if(request.getParameter("orderby")!=null) orderby="order by "+request.getParameter("orderby");
  if(request.getParameter("limit1")!=null) limit1=request.getParameter("limit1");
  if(request.getParameter("limit2")!=null) {
    limit2=request.getParameter("limit2");
    limit="limit "+limit2+" offset "+limit1;
  }

  String fieldname="", regularexp="like"; // exactly search is not required by users, e.g. regularexp="=";
  if(request.getParameter("search_mode")!=null) {
    if(request.getParameter("keyword").indexOf("*")!=-1 || request.getParameter("keyword").indexOf("%")!=-1) regularexp="like";
    if(request.getParameter("search_mode").equals("search_address")) fieldname="address";
    if(request.getParameter("search_mode").equals("search_phone")) fieldname="phone";
    if(request.getParameter("search_mode").equals("search_hin")) fieldname="hin";
    if(request.getParameter("search_mode").equals("search_dob")) fieldname="year_of_birth "+regularexp+" ?"+" and month_of_birth "+regularexp+" ?"+" and date_of_birth ";
    if(request.getParameter("search_mode").equals("search_chart_no")) fieldname="chart_no";
    if(request.getParameter("search_mode").equals("search_name")) {
      if(request.getParameter("keyword").indexOf(",")==-1)  fieldname="last_name";
      else if(request.getParameter("keyword").trim().indexOf(",")==(request.getParameter("keyword").trim().length()-1)) fieldname="last_name";
      else fieldname="last_name "+regularexp+" ?"+" and first_name ";
    }
  }

  String sql = "select demographic_no,first_name,last_name,roster_status,sex,chart_no,year_of_birth,month_of_birth,date_of_birth,provider_no from demographic where "+fieldname+ " "+regularexp+" ? " +orderby; // + " "+limit;  
  
  if(request.getParameter("search_mode").equals("search_name")) {      
      keyword=keyword+"%";
      if(keyword.indexOf(",")==-1){         
         rs = db.queryResults(sql, keyword) ; //lastname
      }
      else if(keyword.indexOf(",")==(keyword.length()-1)){         
         rs = db.queryResults(sql, keyword.substring(0,(keyword.length()-1)));//lastname
      }
      else { //lastname,firstname         
    		String[] param =new String[2];
    		int index = keyword.indexOf(",");
	  		param[0]=keyword.substring(0,index).trim()+"%";//(",");
	  		param[1]=keyword.substring(index+1).trim()+"%";
	  		//System.out.println("from -------- :"+ param[0]+ ": next :"+param[1]);
    		rs = db.queryResults(sql, param);
   	}
  } else if(request.getParameter("search_mode").equals("search_dob")) {      
    		String[] param =new String[3];
	  		param[0]=""+MyDateFormat.getYearFromStandardDate(keyword)+"%";//(",");
	  		param[1]=""+MyDateFormat.getMonthFromStandardDate(keyword)+"%";
	  		param[2]=""+MyDateFormat.getDayFromStandardDate(keyword)+"%";  
	  		//System.out.println("1111111111111111111 " +param[0]+param[1]+param[2]);
    		rs = db.queryResults(sql, param);
  } else {      
    keyword=keyword+"%";
    rs = db.queryResults(sql, keyword);
  }
 
  boolean bodd=false;
  int nItems=0;
  
  if(rs==null) {
    out.println("failed!!!");
  } else {
  	int offset = Integer.parseInt(strLimit1);
  	int idx = 0;
  	while(idx < offset) {
  		rs.next();
                idx++;
  	}
  	idx = 0;
    while (rs.next() && idx < Integer.parseInt(strLimit2)) {
      bodd=bodd?false:true; //for the color of rows
      nItems++; //to calculate if it is the end of records

     if(!(db.getString(rs,"month_of_birth").equals(""))) {//   ||db.getString(rs,"year_of_birth")||db.getString(rs,"date_of_birth")) {
    	if(curMonth>Integer.parseInt(db.getString(rs,"month_of_birth"))) {
    		age=curYear-Integer.parseInt(db.getString(rs,"year_of_birth"));
    	} else {
    		if(curMonth==Integer.parseInt(db.getString(rs,"month_of_birth")) &&
    			curDay>Integer.parseInt(db.getString(rs,"date_of_birth"))) {
    			age=curYear-Integer.parseInt(db.getString(rs,"year_of_birth"));
    		} else {
    			age=curYear-Integer.parseInt(db.getString(rs,"year_of_birth"))-1; 
    		}
    	}	
     }	     
%>

	<tr bgcolor="<%=bodd?"ivory":"white"%>" align="center">
		<td>
			<input type="submit" name="demographicNo" value="<%=db.getString(rs,"demographic_no")%>" onclick="return confirmMatch('<%=nbsp( Misc.toUpperLowerCase(db.getString(rs,"last_name")) )%>','<%=nbsp( Misc.toUpperLowerCase(db.getString(rs,"first_name")) )%>');">
		</td>
		<td><%=nbsp( Misc.toUpperLowerCase(db.getString(rs,"last_name")) )%></td>
		<td><%=nbsp( Misc.toUpperLowerCase(db.getString(rs,"first_name")) )%></td>
		<td><%= age %></td>
		<td><%=nbsp( db.getString(rs,"roster_status") )%></td>
		<td><%=nbsp( db.getString(rs,"sex") )%></td>
		<td><%=nbsp( db.getString(rs,"year_of_birth")+"-"+db.getString(rs,"month_of_birth")+"-"+db.getString(rs,"date_of_birth") )%></td>
		<td><%=providerBean.getProperty(db.getString(rs,"provider_no"))==null?"&nbsp;":providerBean.getProperty(db.getString(rs,"provider_no")) %></td>

	</tr>
	<%
      bufName = new StringBuffer( (db.getString(rs,"last_name")+ ","+ db.getString(rs,"first_name")) );
      bufNo = new StringBuffer( (db.getString(rs,"demographic_no")) );
      bufChart = new StringBuffer( (db.getString(rs,"chart_no"))   );
    }
  }
%>
	</form>

</table>

<%
  int nLastPage=0,nNextPage=0;
  nNextPage=Integer.parseInt(strLimit2)+Integer.parseInt(strLimit1);
  nLastPage=Integer.parseInt(strLimit1)-Integer.parseInt(strLimit2);
%> <script language="JavaScript">
<!--
function last() {
  document.nextform.action="PatientSearch.jsp?keyword=<%=request.getParameter("keyword")%>&search_mode=<%=request.getParameter("search_mode")%>&displaymode=<%=request.getParameter("displaymode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=<%=request.getParameter("orderby")%>&limit1=<%=nLastPage%>&limit2=<%=strLimit2%>" ;
  //document.nextform.submit();  
}
function next() {
  document.nextform.action="PatientSearch.jsp?keyword=<%=request.getParameter("keyword")%>&search_mode=<%=request.getParameter("search_mode")%>&displaymode=<%=request.getParameter("displaymode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=<%=request.getParameter("orderby")%>&limit1=<%=nNextPage%>&limit2=<%=strLimit2%>" ;
  //document.nextform.submit();  
}
//-->
</SCRIPT>

<form method="post" name="nextform"
	action="../demographic/demographiccontrol.jsp"><input
	type="hidden" name="labNo" value="<%=request.getParameter("labNo")%>">
<input type="hidden" name="labType"
	value="<%=request.getParameter("labType")%>" /> <%
  if(nLastPage>=0) {
%> <input type="submit" name="submit"
	value="<bean:message key="oscarMDS.segmentDisplay.patientSearch.btnLastPage"/>"
	onClick="last()"> <%
  }
  if(nItems==Integer.parseInt(strLimit2)) {
%> <input type="submit" name="submit"
	value="<bean:message key="oscarMDS.segmentDisplay.patientSearch.btnNextPage"/>"
	onClick="next()"> <%
}
%>
</form>

<bean:message
	key="oscarMDS.segmentDisplay.patientSearch.msgSearchMessage" /></center>
</body>
</html>
<%!
String nbsp(String s){
   String ret = s;
   if (ret == null || ret.equals("")){
       ret = "&nbsp;";
   }
   return ret;
}
%>