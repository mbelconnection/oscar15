<%-- 
    Document   : PHRRedirectToPhrForm
    Created on : 27-Jul-2009, 12:36:58 PM
    Author     : apavel
--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>

<html>
    <head>
        <title>Redirecting</title>
        <script type="text/javascript" language="JavaScript">
            function onloadd() {
                document.forms["autosubmit"].submit();
            }
        </script>
    </head>
    <body onload="onloadd()">
        <form action="<bean:write name="url"/>" name="autosubmit" method="POST">
            <input type="hidden" name="userName" value="<bean:write name="userName"/>">
            <input type="hidden" name="password" value="<bean:write name="password"/>">
            <input type="hidden" name="viewpatient" value="<bean:write name="viewpatient"/>">
        </form>
    </body>
</html>