<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%
    String noteStr = (String)request.getAttribute("noteStr");
    Boolean raw = (Boolean)request.getAttribute("raw");
    if( raw ) {
 %>
        <%=noteStr%>
    <% } else { %>
        <%=noteStr.replaceAll("\n","<br>")%>
    <%}%>