<%
  if(session.getValue("user") == null) response.sendRedirect("../logout.jsp");
  //int demographic_no =new Integer(request.getParameter("demographic_no")).intValue(); 
  String deepColor = "#CCCCFF" , weakColor = "#EEEEFF" ;
%>  

<%@ page import = "java.net.*,java.sql.*"   errorPage="../errorpage.jsp"%> 
<jsp:useBean id="myFormBean" class="oscar.AppointmentMainBean" scope="page" />
<%@ include file="../admin/dbconnection.jsp" %>
<% 
  String param = request.getParameter("orderby")!=null?request.getParameter("orderby"):"form_name";
  
  String [][] dbQueries=new String[][] { 
{"search_deleted", "select * from eform where status = 0 order by "+param+" ,form_date desc, form_time desc" }, 
  };
  myFormBean.doConfigure(dbParams,dbQueries);

  
  ResultSet rs = myFormBean.queryResults("search_deleted");
%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html locale="true">
<head>
<meta http-equiv="Cache-Control" content="no-cache" />
<title>CallDeletedForm</title>
<link rel="stylesheet" href="../web.css">
</head>
<script language="javascript">
<!--
function newWindow(file,window) {
    msgWindow=open(file,window,'scrollbars=yes,width=760,height=520,screenX=0,screenY=0,top=0,left=10');
    if (msgWindow.opener == null) msgWindow.opener = self;
} 
//-->
</script>
<body topmargin="0" leftmargin="0" rightmargin="0">
<center>
<table border="0" cellspacing="0" cellpadding="0" width="100%" >
  <tr bgcolor="<%=deepColor%>" ><th><font face="Helvetica"><bean:message key="eform.calldeletedform.title"/></font></th></tr>
</table>

<table border="0" cellspacing="0" cellpadding="2" width="98%">
  <tr bgcolor=<%=weakColor%>>
    <td><bean:message key="eform.calldeletedform.msgtitle"/>: </td>
    <td align='right'><a href="uploadhtml.jsp"><bean:message key="eform.calldeletedformdata.btnGoToForm"/></a> | 
      <a href="../admin/admin.jsp"><bean:message key="eform.uploadhtml.btnBack"/></a>
    </td> 
  </tr>
</table>
  
<table border="0" cellspacing="2" cellpadding="2" width="98%">
  <tr bgcolor=<%=deepColor%> >
  <th width=20%><a href="calldeletedform.jsp?orderby=form_name"><bean:message key="eform.showmyform.btnFormName"/></a></th>
  <th width=40%><a href="calldeletedform.jsp?orderby=subject"><bean:message key="eform.showmyform.btnSubject"/></a></th>
  <th><a href="calldeletedform.jsp"><bean:message key="eform.showmyform.formDate"/></a></th>
  <th><a href="calldeletedform.jsp"><bean:message key="eform.showmyform.formTime"/></a></th> 
  <th>Action</th>
  </tr> 
<%
  String bgcolor = null;
  if (rs.next()){ 
    rs.beforeFirst();
    while (rs.next()){
      bgcolor = rs.getRow()%2==0?"white":weakColor ;
%>
  <tr bgcolor="<%=bgcolor%>">
  <td><a href="JavaScript:newWindow('showhtml.jsp?fid=<%=rs.getInt("fid")%>','window2')"><%=rs.getString("form_name")%></a></td>
  <td><%=rs.getString("subject")%></td>
  <td nowrap align='center'><%=rs.getString("form_date")%></td>
  <td nowrap align='center'><%=rs.getString("form_time")%></td>
  <td nowrap align='center'><a href="undeleteform.jsp?fid=<%=rs.getInt("fid")%>"><bean:message key="eform.calldeletedformdata.btnUndelete"/></a></td>
  </tr>
<%
    }  
  }else {
%>
    <tr><td><bean:message key="eform.showmyform.msgNoData"/></td></tr>
<%  }
  myFormBean.closePstmtConn();
%>               
</table>
</center>

</body>
</html:html>
 
