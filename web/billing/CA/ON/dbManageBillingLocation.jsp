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

<%@ page
	import="java.math.*, java.util.*, java.io.*, java.sql.*, oscar.*, java.net.*,oscar.MyDateFormat"%>
<%@ include file="../../../admin/dbconnection.jsp"%>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean"
	scope="session" />
<%@ include file="dbBilling.jsp"%>
<%
String location1="",location1desc ="";
for (int i=1; i<6; i++){
	location1 = request.getParameter("location"+i);
	location1desc=request.getParameter("location"+i+"desc")==null?"":request.getParameter("location"+i+"desc");

	if (location1 != ""){
		if (location1desc != null && location1desc.compareTo("") != 0) {
			StringBuffer sotherBuffer = new StringBuffer(location1desc);
			int f = location1desc.indexOf('\'');
			if ( f != -1) {
				sotherBuffer.deleteCharAt(f);
				sotherBuffer.insert(f,"\'");
			}
			location1desc = sotherBuffer.toString();  

			String[] param3 =new String[3];
			param3[0]=location1;
			param3[1]="1";
			param3[2]=location1desc;

			int   recordAffected = apptMainBean.queryExecuteUpdate(param3,"save_clinic_location");
		}
	}
}

response.sendRedirect("manageBillingLocation.jsp"); 

%>