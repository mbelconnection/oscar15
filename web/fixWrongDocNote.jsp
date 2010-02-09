<%-- 
    Document   : fixWrongDocNote
    Created on : Feb 8, 2010, 9:53:37 PM
    Author     : jackson
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="oscar.util.*,java.util.*" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Shows unmatching doc notes</h1>
            <%
                Vector<String> vec=new Vector();
                vec=fixWrongDocNote.checkWrongDocNote();

                for(String ss: vec){

            %>
        
        <%=ss%>
        <br>

        <%}%>
        <br>
        <br>
        Total number of errors:   <%=vec.size()%>
    </body>


</html>
