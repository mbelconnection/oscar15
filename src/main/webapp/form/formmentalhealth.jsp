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
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */
--%>
<%@ page import="oscar.form.*"%>
<%@ taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%
    if(session.getAttribute("userrole") == null )  response.sendRedirect("../logout.jsp");
    String roleName$ = (String)session.getAttribute("userrole") + "," + (String) session.getAttribute("user");
%>
<security:oscarSec roleName="<%=roleName$%>"
	objectName="_formMentalHealth" rights="o" reverse="<%=true%>">

	<%
    int demoNo = Integer.parseInt(request.getParameter("demographic_no"));
    int formId = Integer.parseInt(request.getParameter("formId"));
    //int provNo = Integer.parseInt(request.getParameter("provNo"));

	if(true) {
        out.clear();
		if (formId == 0) {
			pageContext.forward("formmhreferral.jsp?demographic_no=" + demoNo + "&formId=" + formId) ;
 		} else {
			FrmRecord rec = (new FrmRecordFactory()).factory("MentalHealth");
			java.util.Properties props = rec.getFormRecord(demoNo, formId);

			pageContext.forward("formmh" + props.getProperty("c_lastVisited", "referral")
				+ ".jsp?demographic_no=" + demoNo + "&formId=" + formId) ;
		}

		return;
    }
%>
</security:oscarSec>
You have no rights to view the page.