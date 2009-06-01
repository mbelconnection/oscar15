<%
/* 
 * Applies to: XI Release 2.
 * Date Created: December 2005.
 * Description: This sample demonstrates to how to launch a report in the Crystal Report DHTML viewer (CrystalReportViewer).
 *				NOTE: The CrystalReportViewer is kept on this special viewer page as the viewer also will 'post-back' during 
 *				a viewer event such as page navigation, drill down, or launching other toolbar commands.  The viewer
 *				then renders a new 'view' of the report source object previously created before calling this page and stored in session.
 * Author: CW
 */
%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%//Crystal Report Viewer imports.%>
<%@page import="com.crystaldecisions.report.web.viewer.*"%>
<%@page import="com.crystaldecisions.reports.sdk.*" %>
<%@page import="com.crystaldecisions.sdk.occa.report.data.*" %>

<%

//Refer to the Viewers SDK in the Java Developer Documentation for more information on using the CrystalReportViewer
//API. 
CrystalReportViewer viewer = new CrystalReportViewer();
viewer.setOwnPage(true);
viewer.setOwnForm(true);
viewer.setPrintMode(CrPrintMode.ACTIVEX);

//Get the report source object that this viewer will be displaying.
Object reportSource = session.getAttribute("reportSource");
viewer.setReportSource(reportSource);

Fields fields = (Fields) session.getAttribute("paramFields");
viewer.setParameterFields(fields);
//Render the report.
viewer.processHttpRequest(request, response, getServletConfig().getServletContext(), null); 

%>