<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%
        long loadPage = System.currentTimeMillis();
    if(session.getAttribute("userrole") == null )  response.sendRedirect("../logout.jsp");
    String roleName$ = (String)session.getAttribute("userrole") + "," + (String) session.getAttribute("user");
    
%>


<%@ page
	import="java.util.*, java.sql.*, java.net.URLEncoder, oscar.*, oscar.util.*, oscar.oscarDemographic.data.DemographicMerged"
	errorPage="errorpage.jsp"%>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean"
	scope="session" />
<jsp:useBean id="providerBean" class="java.util.Properties"
	scope="session" />

<%
	if(session.getAttribute("user") == null) response.sendRedirect("../logout.jsp");

	String strLimit1="0";
	String strLimit2="18";
	String deepColor = "#CCCCFF", weakColor = "#EEEEFF" ;
	if(request.getParameter("limit1")!=null) strLimit1 = request.getParameter("limit1");
	if(request.getParameter("limit2")!=null) strLimit2 = request.getParameter("limit2");
      //  boolean fromMessenger = request.getParameter("fromMessenger") == null ? false : (request.getParameter("fromMessenger")).equalsIgnoreCase("true")?true:false;            

        GregorianCalendar now=new GregorianCalendar();
        int curYear = now.get(Calendar.YEAR);
        int curMonth = (now.get(Calendar.MONTH)+1);
        int curDay = now.get(Calendar.DAY_OF_MONTH);    
        String curProvider_no = (String) session.getAttribute("user");
%>
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
<html:html locale="true">
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<title><bean:message
	key="demographic.demographicsearchresults.title" /></title>
<link rel="stylesheet" href="../web.css">
<script language="JavaScript">
function setfocus() {
  document.titlesearch.keyword.focus();
  document.titlesearch.keyword.select();
}

function checkTypeIn() {
  var dob = document.titlesearch.keyword; typeInOK = true;
  
  if (dob.value.indexOf('%b610054') == 0 && dob.value.length > 18){
     document.titlesearch.keyword.value = dob.value.substring(8,18);
     document.titlesearch.search_mode[4].checked = true;                  
  }
  	if(document.titlesearch.search_mode[0].checked) {
		var keyword = document.titlesearch.keyword.value; 
      	var keywordLowerCase = keyword.toLowerCase();
      	document.titlesearch.keyword.value = keywordLowerCase;		
	}
  if(document.titlesearch.search_mode[2].checked) {
    if(dob.value.length==8) {
      dob.value = dob.value.substring(0, 4)+"-"+dob.value.substring(4, 6)+"-"+dob.value.substring(6, 8);
    }
    if(dob.value.length != 10) {
      alert("<bean:message key="demographic.search.msgWrongDOB"/>");
      typeInOK = false;
    }
    
    return typeInOK ;
  } else {
    return true;
  }
}

function popup(vheight,vwidth,varpage) {
  var page = varpage;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";
  var popup=window.open(varpage, "<bean:message key="global.oscarRx"/>_demosearch", windowprops);
  if (popup != null) {
    if (popup.opener == null) {
      popup.opener = self;
    }
    popup.focus();
  }
}

function popupEChart(vheight,vwidth,varpage) { //open a new popup window
  var page = "" + varpage;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=50,screenY=50,top=20,left=20";
  var popup=window.open(page, "Encounter", windowprops);
  if (popup != null) {
    if (popup.opener == null) {
      popup.opener = self;
    }    
    popup.focus();
  }
}


</SCRIPT>
</head>
<body background="../images/gray_bg.jpg" bgproperties="fixed"
	onLoad="setfocus()" topmargin="0" leftmargin="0" rightmargin="0">

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr bgcolor="<%=deepColor%>">
		<th NOWRAP><bean:message
			key="demographic.demographicsearchresults.msgSearchPatient" /></th>
	</tr>
</table>

<%@ include file="zdemographicfulltitlesearch.jsp"%>

<table width="95%" border="0">
	<tr>
		<td align="left"><i><bean:message
			key="demographic.demographicsearchresults.msgSearchKeys" /></i> : <%=request.getParameter("keyword")%></td>
	</tr>
</table>

<CENTER>
<table width="100%" border="0" bgcolor="#ffffff" cellspacing="2"
	cellpadding="2">
	<tr bgcolor="#CCCCFF">
		<% if ( fromMessenger ) {%>
		<! -- leave blank -->
		<%} else {%>
		<TH width="10%"><b><a
			href="demographiccontrol.jsp?fromMessenger=<%=fromMessenger%>&keyword=<%=request.getParameter("keyword")%>&displaymode=<%=request.getParameter("displaymode")%>&search_mode=<%=request.getParameter("search_mode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=demographic_no&limit1=0&limit2=<%=strLimit2%>"><bean:message
			key="demographic.demographicsearchresults.btnDemoNo" /></a></b></TH>
		<TH>&nbsp;<!-- b><a href="demographiccontrol.jsp?fromMessenger=<%=fromMessenger%>&keyword=<%=request.getParameter("keyword")%>&displaymode=<%=request.getParameter("displaymode")%>&search_mode=<%=request.getParameter("search_mode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=demographic_no&limit1=0&limit2=<%=strLimit2%>">Links<sup>*</sup></a></b --></TH>

		<%}%>

		<TH width="20%"><b><a
			href="demographiccontrol.jsp?fromMessenger=<%=fromMessenger%>&keyword=<%=request.getParameter("keyword")%>&displaymode=<%=request.getParameter("displaymode")%>&search_mode=<%=request.getParameter("search_mode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=last_name&limit1=0&limit2=<%=strLimit2%>"><bean:message key="demographic.demographicsearchresults.btnDemoName"/><sup>1</sup></a>
		</b></font></TH>

		<TH width="10%"><b><a
			href="demographiccontrol.jsp?fromMessenger=<%=fromMessenger%>&keyword=<%=request.getParameter("keyword")%>&displaymode=<%=request.getParameter("displaymode")%>&search_mode=<%=request.getParameter("search_mode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=chart_no&limit1=0&limit2=<%=strLimit2%>"><bean:message
			key="demographic.demographicsearchresults.btnChart" /></a></b></TH>

		<TH width="2%"><b><a
			href="demographiccontrol.jsp?fromMessenger=<%=fromMessenger%>&keyword=<%=request.getParameter("keyword")%>&displaymode=<%=request.getParameter("displaymode")%>&search_mode=<%=request.getParameter("search_mode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=sex&limit1=0&limit2=<%=strLimit2%>"><bean:message
			key="demographic.demographicsearchresults.btnSex" /></a></B></TH>

		<TH width="10%"><b><a
			href="demographiccontrol.jsp?fromMessenger=<%=fromMessenger%>&keyword=<%=request.getParameter("keyword")%>&displaymode=<%=request.getParameter("displaymode")%>&search_mode=<%=request.getParameter("search_mode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=year_of_birth,month_of_birth,date_of_birth&limit1=0&limit2=<%=strLimit2%>"><bean:message
			key="demographic.demographicsearchresults.btnDOB" /></a></B></TH>

		<TH width="20%"><b><a
			href="demographiccontrol.jsp?fromMessenger=<%=fromMessenger%>&keyword=<%=request.getParameter("keyword")%>&displaymode=<%=request.getParameter("displaymode")%>&search_mode=<%=request.getParameter("search_mode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=provider_no&limit1=0&limit2=<%=strLimit2%>"><bean:message
			key="demographic.demographicsearchresults.btnDoctor" /></a></b></TH>

		<TH width="5%"><b><a
			href="demographiccontrol.jsp?fromMessenger=<%=fromMessenger%>&keyword=<%=request.getParameter("keyword")%>&displaymode=<%=request.getParameter("displaymode")%>&search_mode=<%=request.getParameter("search_mode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=roster_status&limit1=0&limit2=<%=strLimit2%>"><font
			size='-1'><bean:message
			key="demographic.demographicsearchresults.btnRosSta" /></font></a></b></TH>

		<TH width="3%"><b><a
			href="demographiccontrol.jsp?fromMessenger=<%=fromMessenger%>&keyword=<%=request.getParameter("keyword")%>&displaymode=<%=request.getParameter("displaymode")%>&search_mode=<%=request.getParameter("search_mode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=patient_status&limit1=0&limit2=<%=strLimit2%>"><font
			size='-1'><bean:message
			key="demographic.demographicsearchresults.btnPatSta" /></font></a></b></TH>

		<TH width="10%"><b><a
			href="demographiccontrol.jsp?fromMessenger=<%=fromMessenger%>&keyword=<%=request.getParameter("keyword")%>&displaymode=<%=request.getParameter("displaymode")%>&search_mode=<%=request.getParameter("search_mode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=phone&limit1=0&limit2=<%=strLimit2%>"><bean:message
			key="demographic.demographicsearchresults.btnPhone" /></a></b></TH>
	</tr>
	<%
    java.util.Locale vLocale =(java.util.Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);
    	
	int age=0; 
	ResultSet rs=null ;
    
	String dboperation = request.getParameter("dboperation");
	String keyword=request.getParameter("keyword").trim();
	//keyword.replace('*', '%').trim();

    int iRSOffSet=0;
    int iPageSize=10;
    int iRow=0;
    if(request.getParameter("limit1")!=null) iRSOffSet= Integer.parseInt(request.getParameter("limit1"));
    if(request.getParameter("limit2")!=null) iPageSize = Integer.parseInt(request.getParameter("limit2"));

    String sDbType = oscar.OscarProperties.getInstance().getProperty("db_type").trim();
    if (sDbType.equalsIgnoreCase("oracle")) {
	  if(request.getParameter("search_mode").equals("search_name")) {
	 	 if(keyword.indexOf(",")==-1) 
		    rs = apptMainBean.queryResults_paged("%" + keyword + "%", dboperation, iRSOffSet) ; //lastname
		 else if(keyword.indexOf(",")==(keyword.length()-1))  
		    rs = apptMainBean.queryResults_paged("%" + keyword.substring(0,(keyword.length()-1)) + "%", dboperation, iRSOffSet);//lastname
		 else { //lastname,firstname
            String[] param =new String[2];
            int index = keyword.indexOf(",");
            param[0]="%" + keyword.substring(0,index).trim() + "%";
            param[1]=keyword.substring(index+1).trim() + "%";
            rs = apptMainBean.queryResults_paged(param, dboperation, iRSOffSet);
   		 }
	  } else if(request.getParameter("search_mode").equals("search_dob")) {
		 String[] param =new String[3];
		 param[0] = keyword.substring(0,4);
		 param[1] = keyword.substring(keyword.indexOf("-")+1, keyword.lastIndexOf("-"));
		 param[2] = keyword.substring(keyword.lastIndexOf("-")+1);
		 rs = apptMainBean.queryResults_paged(param, dboperation, iRSOffSet);
      } else if(request.getParameter("search_mode").equals("search_address") || request.getParameter("search_mode").equals("search_phone") ||
         request.getParameter("search_mode").equals("search_hin")) {
         if(keyword.length()>0) keyword="%" + request.getParameter("keyword") + "%";		
         keyword = keyword.replaceAll("-", "%-%");
         rs = apptMainBean.queryResults_paged(keyword, dboperation, iRSOffSet);
	  } else {
		 keyword="%" + request.getParameter("keyword") + "%";		
		 rs = apptMainBean.queryResults_paged(keyword, dboperation, iRSOffSet);
	  }
    
    }else{  //MySQL
          dboperation += "_mysql";          
	  if(request.getParameter("search_mode").equals("search_name")) {
		 keyword="^"+keyword;
		 if(keyword.indexOf(",")==-1)
		    rs = apptMainBean.queryResults(keyword, dboperation) ; //lastname
		 else if(keyword.indexOf(",")==(keyword.length()-1))
		    rs = apptMainBean.queryResults(keyword.substring(0,(keyword.length()-1)), dboperation);//lastname
		 else { //lastname,firstname
            String[] param =new String[2];
            int index = keyword.indexOf(",");
            param[0]=keyword.substring(0,index).trim(); // already has an "^" at the front, so no need to add another
            param[1]="^"+keyword.substring(index+1).trim();

            rs = apptMainBean.queryResults(param, dboperation);
   		 }
	  } else if(request.getParameter("search_mode").equals("search_dob")) {
		 String[] param =new String[3];
		 param[0] = keyword.substring(0,4);//+"%";//(",");
		 param[1] = keyword.substring(keyword.indexOf("-")+1, keyword.lastIndexOf("-"));
		 //param[1] = param[1].startsWith("0") ? param[1].substring(1) : param[1];
		 param[2] = keyword.substring(keyword.lastIndexOf("-")+1);
		 //param[2] = param[2].startsWith("0") ? param[2].substring(1) : param[2];
		 System.out.println(param[1] + " "+ param[2] );
		 rs = apptMainBean.queryResults(param, dboperation);
                 
      } else if(request.getParameter("search_mode").equals("search_address") || request.getParameter("search_mode").equals("search_phone")) {
         keyword = keyword.replaceAll("-", "-?");
         if (keyword.length() < 1) keyword="^";
         rs = apptMainBean.queryResults(keyword, dboperation);
	  } else {
		 keyword="^"+request.getParameter("keyword");		
		 rs = apptMainBean.queryResults(keyword, dboperation);
	  }
    }
    
	boolean bodd=false;
	int nItems=0;
  
	if(rs==null) {
		out.println("failed!!!");
	} else {
		while (rs.next()) {
			bodd=bodd?false:true; //for the color of rows
			nItems++; //to calculate if it is the end of records

			//if( !(apptMainBean.getString(rs,"month_of_birth").equals("")) && !apptMainBean.getString(rs,"year_of_birth").equals("") && !apptMainBean.getString(rs,"date_of_birth").equals("") ) {  
    		//age = UtilDateUtilities.calcAge(apptMainBean.getString(rs,"year_of_birth"), apptMainBean.getString(rs,"month_of_birth"), apptMainBean.getString(rs,"date_of_birth"));
			//}	
%>

	<tr bgcolor="<%=bodd?"white":"#EEEEFF"%>">
		<td align="center" nowrap>
		<%DemographicMerged dmDAO = new DemographicMerged();
            String dem_no = apptMainBean.getString(rs,"demographic_no");    
            String head = dmDAO.getHead(dem_no);
            if (vLocale.getCountry().equals("BR")) { %> <a
			href="demographiccontrol.jsp?demographic_no=<%= head %>&displaymode=edit&dboperation=search_detail_ptbr"><%=dem_no%></a>
		<!-- Link to Oscar Message with display mode = linkMsg2Demo --> <%}else if ( fromMessenger ) {%>
		<a
			href="demographiccontrol.jsp?keyword=<%=Misc.toUpperLowerCase(apptMainBean.getString(rs,"last_name")+", "+apptMainBean.getString(rs,"first_name"))%>&demographic_no=<%= dem_no %>&displaymode=linkMsg2Demo&dboperation=search_detail"><%=apptMainBean.getString(rs,"demographic_no")%></a>
		<!-- Link to Oscar Message with display mode = edit ( default) --> <%}else{%>
		<a title="Master Demo File" href="#"
			onclick="popup(600,900,'demographiccontrol.jsp?demographic_no=<%= head %>&displaymode=edit&dboperation=search_detail')"><%=dem_no%></a>
		<!-- Rights -->
		<td nowrap><security:oscarSec roleName="<%=roleName$%>"
			objectName="_eChart" rights="r">
			<a title="Encounter" href="#"
				onclick="popupEChart(710,1024,'<c:out value="${ctx}"/>/oscarEncounter/IncomingEncounter.do?providerNo=<%=curProvider_no%>&appointmentNo=&demographicNo=<%=dem_no%>&curProviderNo=&reason=<%=URLEncoder.encode("Tel-Progress Notes")%>&encType=&curDate=<%=""+curYear%>-<%=""+curMonth%>-<%=""+curDay%>&appointmentDate=&startTime=&status=');return false;">E</a>
		</security:oscarSec> <!-- Rights --> <security:oscarSec roleName="<%=roleName$%>"
			objectName="_rx" rights="r">
			<a title="Prescriptions" href="#"
				onclick="popup(600,900,'../oscarRx/choosePatient.do?providerNo=<%=rs.getString("provider_no")%>&demographicNo=<%=dem_no%>')">Rx</a>
		</security:oscarSec></td>
		<%}%>
		</td>
		<td><%=Misc.toUpperLowerCase(rs.getString("last_name"))%>, <%=Misc.toUpperLowerCase(rs.getString("first_name"))%></td>
		<td align="center"><%=apptMainBean.getString(rs,"chart_no")==null||apptMainBean.getString(rs,"chart_no").equals("")?"&nbsp;":apptMainBean.getString(rs,"chart_no")%></td>
		<td align="center"><%=apptMainBean.getString(rs,"sex")%></td>
		<td align="center" nowrap><%=apptMainBean.getString(rs,"year_of_birth")+"-"+apptMainBean.getString(rs,"month_of_birth")+"-"+apptMainBean.getString(rs,"date_of_birth")%></td>
		<td align="center"><%=Misc.getShortStr(providerBean.getProperty(apptMainBean.getString(rs,"provider_no")),"_",12 )%></td>
		<td align="center"><%=apptMainBean.getString(rs,"roster_status")==null||apptMainBean.getString(rs,"roster_status").equals("")?"&nbsp;":apptMainBean.getString(rs,"roster_status")%></td>
		<td align="center"><%=apptMainBean.getString(rs,"patient_status")==null||apptMainBean.getString(rs,"patient_status").equals("")?"&nbsp;":apptMainBean.getString(rs,"patient_status")%></td>
		<td align="center" nowrap><%=apptMainBean.getString(rs,"phone")==null||apptMainBean.getString(rs,"phone").equals("")?"&nbsp;":(apptMainBean.getString(rs,"phone").length()==10?(apptMainBean.getString(rs,"phone").substring(0,3)+"-"+apptMainBean.getString(rs,"phone").substring(3)):apptMainBean.getString(rs,"phone"))%></td>
	</tr>
	<%
		}
	}
	apptMainBean.closePstmtConn();
%>

</table>
<sup>*</sup><bean:message key="demographic.demographicsearchresults.msgSortDemographic"/>  <br>
<sup>1</sup><bean:message key="demographic.demographicsearchresults.msgSortsLastName"/>   <br>

<br>
<%
  int nLastPage=0,nNextPage=0;
  nNextPage=Integer.parseInt(strLimit2)+Integer.parseInt(strLimit1);
  nLastPage=Integer.parseInt(strLimit1)-Integer.parseInt(strLimit2);
  if(nLastPage>=0) {
%> <a
	href="demographiccontrol.jsp?keyword=<%=request.getParameter("keyword")%>&search_mode=<%=request.getParameter("search_mode")%>&displaymode=<%=request.getParameter("displaymode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=<%=request.getParameter("orderby")%>&limit1=<%=nLastPage%>&limit2=<%=strLimit2%>&ptstatus=<%=request.getParameter("ptstatus")%>"><bean:message
	key="demographic.demographicsearchresults.btnLastPage" /></a> <%
  }
  if(nItems==Integer.parseInt(strLimit2)) {
      if (nLastPage>=0) {
%> | <%    } %> <a
	href="demographiccontrol.jsp?keyword=<%=request.getParameter("keyword")%>&search_mode=<%=request.getParameter("search_mode")%>&displaymode=<%=request.getParameter("displaymode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=<%=request.getParameter("orderby")%>&limit1=<%=nNextPage%>&limit2=<%=strLimit2%>&ptstatus=<%=request.getParameter("ptstatus")%>">
<bean:message key="demographic.demographicsearchresults.btnNextPage" /></a>
<%
}
%>

<p><a href="demographicaddarecordhtm.jsp"><b><font size="+1"><bean:message
	key="demographic.search.btnCreateNew" /></font></b></a></p>
<br>
<p><bean:message key="demographic.demographicsearchresults.msgClick" /></p>
</center>
</body>
</html:html>
