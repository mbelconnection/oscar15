<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html-el" prefix="html-el" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<%@ page import="oscar.oscarDemographic.data.DemographicData"%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@ page import="org.oscarehr.phr.PHRAuthentication"%>
<%@ page import="oscar.oscarProvider.data.ProviderData"%>
<%@ page import="java.util.*"%>
<%
String providerName = request.getSession().getAttribute("userfirstname") + " " + 
        request.getSession().getAttribute("userlastname");
String providerNo = (String) request.getSession().getAttribute("user");
ProviderData providerData = new ProviderData();
providerData.setProviderNo(providerNo);
String providerPhrId = providerData.getMyOscarId();
request.setAttribute("forwardto", request.getRequestURI());
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <html:base />
        <link rel="stylesheet" type="text/css" href="../../oscarMessenger/encounterStyles.css">
        <title>
        <%-- bean:message key="indivoMessenger.DisplayMessages.title"/ --%>  myOSCAR
        </title>
        <style type="text/css">
        td.messengerButtonsA{
            /*background-color: #6666ff;*/
            /*background-color: #6699cc;*/
            background-color: #003399;
        }
        td.messengerButtonsD{
            /*background-color: #84c0f4;*/
            background-color: #555599;
        }
        a.messengerButtons{
            color: #ffffff;
            font-size: 9pt;
            text-decoration: none;
        }


        table.messButtonsA{
        border-top: 2px solid #cfcfcf;
        border-left: 2px solid #cfcfcf;
        border-bottom: 2px solid #333333;
        border-right: 2px solid #333333;
        }

        table.messButtonsD{
        border-top: 2px solid #333333;
        border-left: 2px solid #333333;
        border-bottom: 2px solid #cfcfcf;
        border-right: 2px solid #cfcfcf;
        }
        
        .myoscarLoginElementNoAuth {
            border: 0;
            padding-left: 3px;
            padding-right: 3px;
            background-color: #f3e9e9;
        }
        
        .myoscarLoginElementAuth {
            border: 0;
            padding-left: 3px;
            padding-right: 3px;
            background-color: #d9ecd8;
        }
        .moreInfoBoxoverBody{
            border: 1px solid #9fbbe8;
            padding: 1px;
            padding-left: 3px;
            padding-right: 3px;
            border-top: 0px;
            font-size: 10px;
            background-color: white;
        }
        .moreInfoBoxoverHeader{
            border: 1px solid #9fbbe8;
            background-color: #e8ecf3;
            padding: 2px;
            padding-left: 3px;
            padding-right: 3px;
            border-bottom: 0px;
            font-size: 10px;
            color: red;
        }
        </style>

        <script type="text/javascript">
        function BackToOscar()
        {
               window.close();
        } 
        function setFocus() {
            if (document.getElementById('phrPassword'))
                document.getElementById('phrPassword').focus();
        }
        </script>
    </head>

    <body class="BodyStyle" vlink="#0000FF" onload="window.focus(); setFocus();">
        <!--  -->

    <table  class="MainTable" id="scrollNumber1" name="encounterTable">
        <tr class="MainTableTopRow">
            <td class="MainTableTopRowLeftColumn">
                <bean:message key="oscarMessenger.DisplayMessages.msgMessenger"/>
            </td>
            <td class="MainTableTopRowRightColumn">
                <table class="TopStatusBar">
                    <tr>
                        <td >
                            <div class="DivContentTitle"><bean:message key="oscarMessenger.DisplayMessages.msgInbox"/></div>
                        </td>
                        <td  >
                        </td>
                        <td style="text-align:right">
                            <a href="javascript:popupStart(300,400,'Help.jsp')"  ><bean:message key="global.help"/></a> | <a href="javascript:popupStart(300,400,'About.jsp')" ><bean:message key="global.about"/></a> | <a href="javascript:popupStart(300,400,'License.jsp')" ><bean:message key="global.license"/></a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="MainTableLeftColumn">
                &nbsp;
            </td>
            <td class="MainTableRightColumn">
                <table width="100%">
                    <tr>
                        <td>
                            <table  cellspacing=3 >
                                <tr>
                                    <td >
                                        <table class=messButtonsA cellspacing=0 cellpadding=3><tr><td class="messengerButtonsA">
                                                    <html:link page="/phr/PhrMessage.do?method=viewMessages" styleClass="messengerButtons">
                                                        <bean:message key="oscarMessenger.DisplayMessages.btnRefresh"/>
                                                    </html:link>
                                        </td></tr></table>
                                    </td>
                                    <td >
                                        <table class=messButtonsA cellspacing=0 cellpadding=3><tr><td class="messengerButtonsA">
                                                    <a href="javascript:window.close()" class="messengerButtons">Exit MyOscar Messenges</a>
                                        </td></tr></table>
                                    </td>
                                    <%PHRAuthentication phrAuth = (PHRAuthentication) session.getAttribute(PHRAuthentication.SESSION_PHR_AUTH);%>
                                    <logic:present name="<%=PHRAuthentication.SESSION_PHR_AUTH%>">
                                        <td class="myoscarLoginElementAuth">
                                            <div>
                                                Status: <b>Logged in as <%=providerName%></b> (<%=phrAuth.getUserId()%>)
                                                <form action="../../phr/Logout.do" name="phrLogout" method="POST"  style="margin: 0px; padding: 0px;">
                                                    <input type="hidden" name="forwardto" value="<%=request.getServletPath()%>?method=<%=(String) request.getParameter("method")%>">
                                                    <center><a href="javascript: document.forms['phrLogout'].submit()">Logout</a></center>
                                                </form>
                                            </div>
                                        </td>
                                      <!--<p style="background-color: #E00000"  title="fade=[on] requireclick=[on] header=[Diabetes Med Changes] body=[<span style='color:red'>no DM Med changes have been recorded</span> </br>]">dsfsdfsdfsdfgsdgsdg</p>-->
                                    </logic:present>
                                    <logic:notPresent name="<%=PHRAuthentication.SESSION_PHR_AUTH%>">
                                        <td class="myoscarLoginElementNoAuth">
                                            <div>
                                                <form action="../../phr/Login.do" name="phrLogin" method="POST"  style="margin-bottom: 0px;">
                                                    <%--=request.getParameter("phrUserLoginErrorMsg")%>
                                                    <%=request.getAttribute("phrUserLoginErrorMsg")--%>
                                                  <%request.setAttribute("phrUserLoginErrorMsg", request.getParameter("phrUserLoginErrorMsg"));
                                                    request.setAttribute("phrTechLoginErrorMsg", request.getParameter("phrTechLoginErrorMsg"));%>
                                                    <logic:present name="phrUserLoginErrorMsg">
                                                        <div class="phrLoginErrorMsg"><font color="red"><bean:write name="phrUserLoginErrorMsg"/>.</font>  
                                                        <logic:present name="phrTechLoginErrorMsg">
                                                            <a href="javascript:;" title="fade=[on] requireclick=[off] cssheader=[moreInfoBoxoverHeader] cssbody=[moreInfoBoxoverBody] singleclickstop=[on] header=[MyOSCAR Server Response:] body=[<bean:write name="phrTechLoginErrorMsg"/> </br>]">More Info</a></div>
                                                        </logic:present>
                                                    </logic:present>
                                                    Status: <b>Not logged in</b><br/>
                                                    <%=providerName%> password: <input type="password" id="phrPassword" name="phrPassword" style="font-size: 8px; width: 40px;"> <a href="javascript: document.forms['phrLogin'].submit()">Login</a>
                                                    <input type="hidden" name="forwardto" value="<%=request.getServletPath()%>?method=<%=(String) request.getParameter("method")%>">
                                                </form>
                                            </div>
                                        </td>
                                    </logic:notPresent>
                                </tr>
                            </table><!--cell spacing=3-->
                        </td>
                    </tr>
                </table><!--table width="100%">-->
            </td>
        </tr>
        <tr>
            <td class="MainTableLeftColumn">
                &nbsp;
            </td>
            <td class="MainTableRightColumn">
                <table border="0" width="80%" cellspacing="1">
                    <tr>
                        <th bgcolor="#DDDDFF" width="75">
                            &nbsp;
                        </th>
                        <th align="left" bgcolor="#DDDDFF">
                            <html-el:link action="/phr/PhrMessage?orderby=0" >
                            
                                <bean:message key="oscarMessenger.DisplayMessages.msgStatus"/>
                            </html-el:link>
                        </th>
                        <th align="left" bgcolor="#DDDDFF">
                             <html-el:link action="/phr/PhrMessage?orderby=1" >
                                <bean:message key="oscarMessenger.DisplayMessages.msgFrom"/>
                            </html-el:link>
                        </th>
                        <th align="left" bgcolor="#DDDDFF">
                            <html-el:link action="/phr/PhrMessage?orderby=2" >
                                <bean:message key="oscarMessenger.DisplayMessages.msgSubject"/>
                            </html-el:link>
                        </th>
                        <th align="left" bgcolor="#DDDDFF">
                            <html-el:link action="/phr/PhrMessage?orderby=3" >
                                <bean:message key="oscarMessenger.DisplayMessages.msgDate"/>
                            </html-el:link>
                        </th>                                    
                    </tr>          
                    <c:forEach var="iMessage" items="${indivoMessages}">
                        <tr>
                            <td bgcolor="#EEEEFF" width="75">
                               
                            <c:if test="${iMessage.replied}" > --> </c:if>
                            
                            </td>
                            <td bgcolor="#EEEEFF" width="75">
                                <c:choose>
                                   <c:when test="${iMessage.read}">read</c:when>
                                   <c:otherwise>new</c:otherwise>
                                </c:choose>
                            </td>
                            <td bgcolor="#EEEEFF">
                                <c:out value="${iMessage.senderPhr}"/></td>
                            <td bgcolor="#EEEEFF">
                                
                                <html-el:link action="/phr/PhrMessage?&method=read&id=${iMessage.id}"  >
                                   <c:out value="${iMessage.docSubject}"/>
                                </html-el:link>
                                
                            </td>
                            <td bgcolor="#EEEEFF"> 
                                <fmt:formatDate value="${iMessage.dateCreated}" type="DATE" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                        </tr>
                    </c:forEach> 
                </table>
            </td>
        </tr>
        <tr>
            <script type="text/javascript" src="../../share/javascript/boxover.js"></script>
            <td class="MainTableBottomRowLeftColumn">
            </td>
            <td class="MainTableBottomRowRightColumn">
            </td>
        </tr>
        
    </table>
    </body>
</html>