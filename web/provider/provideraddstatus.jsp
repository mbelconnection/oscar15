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
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */
-->

<%@ page import="java.sql.*, java.util.*, oscar.MyDateFormat"
	errorPage="errorpage.jsp"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ include file="/common/webAppContextAndSuperMgr.jsp"%>

<%
  //if action is good, then give me the result
    String[] param =new String[3];
    param[0]=request.getParameter("status")+ request.getParameter("statusch");
    param[1]=(String)session.getAttribute("user");
    param[2]=request.getParameter("appointment_no");
    oscarSuperManager.update("providerDao", "archive_appt", new String[]{request.getParameter("appointment_no")});
    int rowsAffected = oscarSuperManager.update("providerDao", request.getParameter("dboperation"), param);
    if (rowsAffected == 1) {//add_record
      int view=0;
      if(request.getParameter("view")!=null) view=Integer.parseInt(request.getParameter("view")); //0-multiple views, 1-single view
      String strView=(view==0)?"0":("1&curProvider="+request.getParameter("curProvider")+"&curProviderName="+request.getParameter("curProviderName") );
      String strViewAll=request.getParameter("viewall")==null?"0":(request.getParameter("viewall")) ;
      String displaypage="providercontrol.jsp?year="+request.getParameter("year")+"&month="+request.getParameter("month")+"&day="+request.getParameter("day") +"&view="+  strView  +"&displaymode=day&dboperation=searchappointmentday" +"&viewall=" +strViewAll;
    if (request.getParameter("viewWeek") != null) {
       displaypage += "&provider_no=" + request.getParameter("provider_no");
    }
    if(true) {
      out.clear();
    	response.sendRedirect(displaypage);
      //pageContext.forward(displaypage); //forward request&response to the target page
      return;
    }
  } else {
%>
<p>
<h1><bean:message key="AddProviderStatus.msgAddFailure" /></h1>

<%  
  }
%>
