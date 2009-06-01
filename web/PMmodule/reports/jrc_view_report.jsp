<%
/* 
 * Applies to versions:	XI Release 2
 * Date Created: December 2005
 * Description: This sample demonstrates how to launch a report in the zero-client DHTML viewer (CrystalReportViewer).  
 * Author: CW.
 */
%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%//Crystal Java Reporting Component (JRC) imports.%>
<%@page import="com.crystaldecisions.reports.sdk.*" %>
<%@page import="com.crystaldecisions.sdk.occa.report.lib.*" %>

<%
//Report can be opened from the relative location specified in the CRConfig.xml, or the report location
//tag can be removed to open the reports as Java resources or using an absolute path (absolute path not recommended
//for Web applications).
String REPORT_NAME =(String)  session.getAttribute("rptPath");
%>

<%

try {
	
	//Open report.
	ReportClientDocument reportClientDoc = new ReportClientDocument();
	reportClientDoc.open(REPORT_NAME, 0);

	//Store the report source in session, will be used by the CrystalReportViewer.
	session.setAttribute("reportSource", reportClientDoc.getReportSource());
		
	//Launch CrystalReportViewer page that contains the report viewer.
	response.sendRedirect("CrystalReportViewer.jsp");
		
}
catch(ReportSDKException ex) {	
	out.println(ex);
}
catch(Exception ex) {
	out.println(ex);			
}
%>