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

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page language="java"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/oscarProperties-tag.tld" prefix="oscar"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ page import="oscar.oscarProvider.data.*, oscar.log.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="oscar.*,java.lang.*,java.util.Date,oscar.oscarRx.util.RxUtil,org.springframework.web.context.WebApplicationContext,
         org.springframework.web.context.support.WebApplicationContextUtils,
         org.oscarehr.common.dao.UserPropertyDAO,org.oscarehr.common.model.UserProperty"%>
<%@ page import="org.oscarehr.util.SpringUtils"%>
         
<% response.setHeader("Cache-Control","no-cache");%>

<html:html locale="true">
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<script type="text/javascript" src="../share/javascript/prototype.js"></script>
<script type="text/javascript" src="../share/javascript/Oscar.js"/>"></script>
<title><bean:message key="RxPreview.title"/></title>
<html:base />

<logic:notPresent name="RxSessionBean" scope="session">
	<logic:redirect href="error.html" />
</logic:notPresent>
<logic:present name="RxSessionBean" scope="session">
	<bean:define id="bean" type="oscar.oscarRx.pageUtil.RxSessionBean"
		name="RxSessionBean" scope="session" />
	<logic:equal name="bean" property="valid" value="false">
		<logic:redirect href="error.html" />
	</logic:equal>
</logic:present>

<link rel="stylesheet" type="text/css" href="styles.css">
<script type="text/javascript" language="Javascript">

    function onPrint2(method) {

            document.getElementById("preview2Form").action = "../form/createcustomedpdf?__title=Rx&__method=" + method;
            document.getElementById("preview2Form").target="_blank";
            document.getElementById("preview2Form").submit();
       return true;
    }
</script>

</head>
<body topmargin="0" leftmargin="0" vlink="#0000FF">

<%
System.out.println("==========================IN Preview2.jsp2=======================");

Date rxDate = oscar.oscarRx.util.RxUtil.Today();
//String rePrint = request.getParameter("rePrint");
String rePrint = (String)request.getSession().getAttribute("rePrint");
//String rePrint = (String)request.getSession().getAttribute("rePrint");
System.out.println("rePrint"+rePrint);
oscar.oscarRx.pageUtil.RxSessionBean bean;
oscar.oscarRx.data.RxProviderData.Provider provider;
String signingProvider;
if( rePrint != null && rePrint.equalsIgnoreCase("true") ) {
    bean = (oscar.oscarRx.pageUtil.RxSessionBean)session.getAttribute("tmpBeanRX");
    signingProvider = bean.getStashItem(0).getProviderNo();
    //System.out.println("in if, signingProvider="+signingProvider);
    rxDate = bean.getStashItem(0).getRxDate();
    //System.out.println("RX DATE " + rxDate);
    provider = new oscar.oscarRx.data.RxProviderData().getProvider(signingProvider);
    //System.out.println("in if, provider no="+provider.getProviderNo());
    session.setAttribute("tmpBeanRX", null);
    String ip = request.getRemoteAddr();System.out.println("in if, ip="+ip);
    //LogAction.addLog((String) session.getAttribute("user"), LogConst.UPDATE, LogConst.CON_PRESCRIPTION, String.valueOf(bean.getDemographicNo()), ip);
}
else {
    bean = (oscar.oscarRx.pageUtil.RxSessionBean)pageContext.findAttribute("bean");

    //set Date to latest in stash
    Date tmp;
    //System.out.println("bean.getStashSize()="+bean.getStashSize());

    for( int idx = 0; idx < bean.getStashSize(); ++idx ) {
        tmp = bean.getStashItem(idx).getRxDate();
        //System.out.println("in else, tmp="+tmp);
        if( tmp.after(rxDate) ) {
            rxDate = tmp;
        }
    }
    rePrint = "";
    signingProvider = bean.getProviderNo();
    //System.out.println("in else , signingProvider="+signingProvider);
    provider = new oscar.oscarRx.data.RxProviderData().getProvider(bean.getProviderNo());
    //System.out.println("in else, provider no="+provider.getProviderNo());
}

String providerPhone = null;
org.oscarehr.common.model.Provider pprovider = org.oscarehr.util.LoggedInInfo.loggedInInfo.get().loggedInProvider;
if(pprovider.getWorkPhone() != null && pprovider.getWorkPhone().length()>0) {
	providerPhone = pprovider.getWorkPhone();
}


oscar.oscarRx.data.RxPatientData.Patient patient = new oscar.oscarRx.data.RxPatientData().getPatient(bean.getDemographicNo());

oscar.oscarRx.data.RxPrescriptionData.Prescription rx = null;
int i;
ProSignatureData sig = new ProSignatureData();
boolean hasSig = sig.hasSignature(signingProvider);
String doctorName = "";
if (hasSig){
   doctorName = sig.getSignature(signingProvider);
   //System.out.println("in if doctorName="+doctorName);
}else{
   doctorName = (provider.getFirstName() + ' ' + provider.getSurname());System.out.println("in else doctorName="+doctorName);
}

doctorName = doctorName.replaceAll("\\d{6}","");
doctorName = doctorName.replaceAll("\\-","");
//System.out.println("doctorName="+doctorName);

OscarProperties props = OscarProperties.getInstance();

String pracNo = provider.getPractitionerNo();
//System.out.println("pracNo="+pracNo);
String strUser = (String)session.getAttribute("user");System.out.println("strUser="+strUser);
ProviderData user = new ProviderData(strUser);System.out.println("user="+user);
System.out.println(provider.getClinicName().replaceAll("\\(\\d{6}\\)",""));
String patientDOBStr=RxUtil.DateToString(patient.getDOB(), "MMM d, yyyy") ;
boolean showPatientDOB=false;

//check if user prefer to show dob in print
WebApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
UserPropertyDAO userPropertyDAO = (UserPropertyDAO) ctx.getBean("UserPropertyDAO");
UserProperty prop = userPropertyDAO.getProp(signingProvider, UserProperty.RX_SHOW_PATIENT_DOB);
if(prop!=null && prop.getValue().equalsIgnoreCase("yes")){
    showPatientDOB=true;
}
%>
<html:form action="/form/formname" styleId="preview2Form">
    
    <p id="pharmInfo" style="float:right;">
    </p>    
    <table>
        <tr>
            <td>
                            <table id="pwTable" width="400px" height="500px" cellspacing=0 cellpadding=10 border=2>
                                    <tr>
                                            <td valign=top height="100px"><input type="image"
                                                    src="img/rx.gif" border="0" alt="[Submit]"
                                                    name="submit" title="Print in a half letter size paper"
                                                    onclick="<%=rePrint.equalsIgnoreCase("true") ? "javascript:return onPrint2('rePrint');" : "javascript:return onPrint2('print');"  %>"/>
                                            <!--input type="hidden" name="printPageSize" value="PageSize.A6" /--> <% 	String clinicTitle = provider.getClinicName().replaceAll("\\(\\d{6}\\)","") + "<br>" ;
                                                    clinicTitle += provider.getClinicAddress() + "<br>" ;
                                                    clinicTitle += provider.getClinicCity() + "   " + provider.getClinicPostal()  ;
                                            %> <input type="hidden" name="doctorName"
                                                    value="<%= StringEscapeUtils.escapeHtml(doctorName) %>" /> <c:choose>
                                                    <c:when test="${empty infirmaryView_programAddress}">
                                                            <input type="hidden" name="clinicName"
                                                                    value="<%= StringEscapeUtils.escapeHtml(clinicTitle.replaceAll("(<br>)","\\\n")) %>" />
                                                            <!-- override phone & fax -->
                                               <%
                                                	UserProperty phoneProp = userPropertyDAO.getProp(provider.getProviderNo(),"rxPhone");
                                                	UserProperty faxProp = userPropertyDAO.getProp(provider.getProviderNo(),"faxnumber");
                                                
                                                	String finalPhone = provider.getClinicPhone();
                                                	String finalFax = provider.getClinicFax();
                                                	//if(providerPhone != null) {
                                                	//	finalPhone = providerPhone;
                                                	//}
                                                	if(phoneProp != null && phoneProp.getValue().length()>0) {                                                		
                                                		finalPhone = phoneProp.getValue();
                                                	}
                                                	
                                                	if(faxProp != null && faxProp.getValue().length()>0) {                                                		
                                                		finalFax = faxProp.getValue();
                                                	}
                                                	
                                                	request.setAttribute("phone",finalPhone);
                                                
                                             	%>                                                            
                                                            <input type="hidden" name="clinicPhone"
                                                                    value="<%= StringEscapeUtils.escapeHtml(finalPhone) %>" />
                                                            <input type="hidden" name="clinicFax"
                                                                    value="<%= StringEscapeUtils.escapeHtml(finalFax) %>" />
                                                    </c:when>
                                                    <c:otherwise>
                                               <%
                                                	UserProperty phoneProp = userPropertyDAO.getProp(provider.getProviderNo(),"rxPhone");
                                                	UserProperty faxProp = userPropertyDAO.getProp(provider.getProviderNo(),"faxnumber");
                                                
                                                	String finalPhone = (String)session.getAttribute("infirmaryView_programTel");
                                                	String finalFax =(String)session.getAttribute("infirmaryView_programFax");
                                                	
                                                	//if(providerPhone != null) {
                                                	//	finalPhone = providerPhone;
                                                	//}
                                                	if(phoneProp != null && phoneProp.getValue().length()>0) {                                                		
                                                		finalPhone = phoneProp.getValue();
                                                	}
                                                	
                                                	if(faxProp != null && faxProp.getValue().length()>0) {                                                		
                                                		finalFax = faxProp.getValue();
                                                	}
                                                	
                                                	request.setAttribute("phone",finalPhone);
                                                
                                             	%>                                                           		
                                                            <input type="hidden" name="clinicName"
                                                                    value="<c:out value="${infirmaryView_programAddress}"/>" />
                                                            <input type="hidden" name="clinicPhone"
                                                                    value="<%=finalPhone %>" />
                                                            <input type="hidden" name="clinicFax"
                                                                    value="<%=finalFax %>" />
                                                    </c:otherwise>
                                            </c:choose> <input type="hidden" name="patientName"
                                                    value="<%= StringEscapeUtils.escapeHtml(patient.getFirstName())+ " " +StringEscapeUtils.escapeHtml(patient.getSurname()) %>" />
                                            <input type="hidden" name="patientDOB" value="<%= StringEscapeUtils.escapeHtml(patientDOBStr) %>" />
                                            <input type="hidden" name="showPatientDOB" value="<%=showPatientDOB%>"
                                            <input type="hidden" name="patientAddress"
                                                    value="<%= StringEscapeUtils.escapeHtml(patient.getAddress()) %>" />
                                            <input type="hidden" name="patientCityPostal"
                                                    value="<%= StringEscapeUtils.escapeHtml(patient.getCity())+ " " + StringEscapeUtils.escapeHtml(patient.getPostal())%>" />
                                            <input type="hidden" name="patientPhone"
                                                    value="<bean:message key="RxPreview.msgTel"/><%=StringEscapeUtils.escapeHtml(patient.getPhone()) %>" />

                                            <input type="hidden" name="rxDate"
                                                    value="<%= StringEscapeUtils.escapeHtml(oscar.oscarRx.util.RxUtil.DateToString(rxDate, "MMMM d, yyyy")) %>" />
                                            <input type="hidden" name="sigDoctorName"
                                                    value="<%= StringEscapeUtils.escapeHtml(doctorName) %>" /> <!--img src="img/rx.gif" border="0"-->
                                            </td>
                                            <td valign=top height="100px" id="clinicAddress"><b><%=doctorName%></b><br>                                            
                                                
                                            <c:choose>
                                                    <c:when test="${empty infirmaryView_programAddress}">
                                                            <%= provider.getClinicName().replaceAll("\\(\\d{6}\\)","") %><br>
                                                            <%= provider.getClinicAddress() %><br>
                                                            <%= provider.getClinicCity() %>&nbsp;&nbsp;<%=provider.getClinicProvince()%>&nbsp;&nbsp;
                                                <%= provider.getClinicPostal() %><br>
                                                <!-- override with user properties - phone and fax -->                 
                                                <%
                                                	UserProperty phoneProp = userPropertyDAO.getProp(provider.getProviderNo(),"rxPhone");
                                                	UserProperty faxProp = userPropertyDAO.getProp(provider.getProviderNo(),"faxnumber");
                                                
                                                	String finalPhone = provider.getClinicPhone();
                                                	String finalFax = provider.getClinicFax();
                                                	//if(providerPhone != null) {
                                                	//	finalPhone = providerPhone;
                                                	//}
                                                	if(phoneProp != null && phoneProp.getValue().length()>0) {                                                		
                                                		finalPhone = phoneProp.getValue();
                                                	}
                                                	
                                                	if(faxProp != null && faxProp.getValue().length()>0) {                                                		
                                                		finalFax = faxProp.getValue();
                                                	}
                                                	
                                                	request.setAttribute("phone",finalPhone);
                                                
                                             	%>
                                                <bean:message key="RxPreview.msgTel"/>: <%= finalPhone %><br>
                                                <oscar:oscarPropertiesCheck property="RXFAX" value="yes">
                                                    <bean:message key="RxPreview.msgFax"/>: <%= finalFax %><br>
                                                </oscar:oscarPropertiesCheck>
                                                    </c:when>
                                                    <c:otherwise>
                                                <%   
                                                	UserProperty phoneProp = userPropertyDAO.getProp(provider.getProviderNo(),"rxPhone");
                                                	UserProperty faxProp = userPropertyDAO.getProp(provider.getProviderNo(),"faxnumber");
                                                
                                                	String finalPhone = (String)session.getAttribute("infirmaryView_programTel");
                                                	String finalFax =(String)session.getAttribute("infirmaryView_programFax");
                                                	
                                                	//if(providerPhone != null) {
                                                	//	finalPhone = providerPhone;
                                                	//}
                                                	if(phoneProp != null && phoneProp.getValue().length()>0) {                                                		
                                                		finalPhone = phoneProp.getValue();
                                                	}
                                                	
                                                	if(faxProp != null && faxProp.getValue().length()>0) {                                                		
                                                		finalFax = faxProp.getValue();
                                                	}
                                                	
                                                	request.setAttribute("phone",finalPhone);
                                                
                                             	%>
                                                                                                 
                                                    		
                                                            <c:out value="${infirmaryView_programAddress}" escapeXml="false" />
                                                            <br />
                                                    <bean:message key="RxPreview.msgTel"/>: <%=finalPhone %>
                                                            <br />
                                                            <oscar:oscarPropertiesCheck property="RXFAX" value="yes">
                                                        <bean:message key="RxPreview.msgFax"/>: <%=finalFax %>
                                                    </oscar:oscarPropertiesCheck>
                                                    </c:otherwise>
                                            </c:choose></td>
                                    </tr>
                                    <tr>
                                            <td colspan=2 valign=top height="75px">
                                            <table width=100% cellspacing=0 cellpadding=0>
                                                    <tr>
                                                            <td align=left valign=top><br>
                                                                <%= patient.getFirstName() %> <%= patient.getSurname() %> <%if(showPatientDOB){%>&nbsp;&nbsp; DOB:<%= StringEscapeUtils.escapeHtml(patientDOBStr) %> <%}%><br>
                                                            <%= patient.getAddress() %><br>
                                                            <%= patient.getCity() %> <%= patient.getPostal() %><br>
                                                            <%= patient.getPhone() %><br>
                                                            <b> <% if(!props.getProperty("showRxHin", "").equals("false")) { %>
                                                            <bean:message key="oscar.oscarRx.hin" /><%= patient.getHin() %> <% } %>
                                                            </b></td>
                                                            <td align=right valign=top><b> <%= oscar.oscarRx.util.RxUtil.DateToString(rxDate, "MMMM d, yyyy",request.getLocale()) %>
                                                            </b></td>
                                                    </tr>
                                            </table>
                                            </td>
                                    </tr>
                                    <tr>
                                            <td colspan=2 valign=top height="275px">
                                            <table height=100% width=100%>
                                                    <tr valign=top>
                                                            <td colspan=2 height=225px>
                                                            <%
                                            String strRx = "";
                                            StringBuffer strRxNoNewLines = new StringBuffer();
                                            for(i=0;i<bean.getStashSize();i++)
                                            {
                                            rx = bean.getStashItem(i);
                                                                    String fullOutLine=rx.getFullOutLine().replaceAll(";","<br />");

                                                                    if (fullOutLine==null || fullOutLine.length()<=6)
                                                                    {
                                                                            Logger.getLogger("preview_jsp").error("drug full outline was null");
                                                                            fullOutLine="<span style=\"color:red;font-size:16;font-weight:bold\">An error occurred, please write a new prescription.</span><br />"+fullOutLine;
                                                                    }
                                            %>
                                            <%=fullOutLine%>
                                                            <hr>
                                                            <%
                                            strRx += rx.getFullOutLine() + ";;";
                                            strRxNoNewLines.append(rx.getFullOutLine().replaceAll(";"," ")+ "\n");
                                            }
                                            %> <input type="hidden" name="rx"
                                                                    value="<%= StringEscapeUtils.escapeHtml(strRx.replaceAll(";","\\\n")) %>" />
                                                            <input type="hidden" name="rx_no_newlines"
                                                                    value="<%= strRxNoNewLines.toString() %>" /></td>
                                                    </tr>

                                                    <tr valign="bottom">
                                                            <td colspan="2" id="additNotes">
                                                            <input type="hidden" name="additNotes" value="">
                                                            </td>
                                                    </tr>


                                                    <% if ( oscar.OscarProperties.getInstance().getProperty("RX_FOOTER") != null ){ out.write(oscar.OscarProperties.getInstance().getProperty("RX_FOOTER")); }%>


                                                    <tr valign=bottom>
                                                            <td height=25px width=25%><bean:message key="RxPreview.msgSignature"/>:</td>
                                                            <td height=25px width=75%
                                                                    style="border-width: 0; border-bottom-width: 1; border-style: solid;">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr valign=bottom>
                                                            <td height=25px></td>
                                                            <td height=25px>&nbsp; <%= doctorName%> <% if ( pracNo != null && ! pracNo.equals("") && !pracNo.equalsIgnoreCase("null")) { %>
                                                                Pract. No. <%= pracNo%> <% } %>
                                                            </td>



                                                    </tr>
                                                    <% if( rePrint.equalsIgnoreCase("true") && rx != null ) { %>
                                                    <tr valign=bottom style="font-size: 6px;">
                                                        <td height=25px colspan="2"><bean:message key="RxPreview.msgReprintBy"/> <%=user.getProviderName(strUser)%><span style="float: left;">
                                                            <bean:message key="RxPreview.msgOrigPrinted"/>:&nbsp;<%=rx.getPrintDate()%></span> <span
                                                                    style="float: right;"><bean:message key="RxPreview.msgTimesPrinted"/>:&nbsp;<%=String.valueOf(rx.getNumPrints())%></span>
                                                            <input type="hidden" name="origPrintDate" value="<%=rx.getPrintDate()%>"/>
                                                            <input type="hidden" name="numPrints" value="<%=String.valueOf(rx.getNumPrints())%>"/>
                                                        </td>
                                                    </tr>

                                                    <%
                                       }
                                     if (oscar.OscarProperties.getInstance().getProperty("FORMS_PROMOTEXT") != null){%>
                                                    <tr valign=bottom align="center" style="font-size: 9px">
                                                            <td height=25px colspan="2"></br>
                                                            <%= oscar.OscarProperties.getInstance().getProperty("FORMS_PROMOTEXT") %>
                                                            </td>
                                                    </tr>
                                                    <%}%>
                                            </table>
                                            </td>
                                    </tr>
                            </table>
			</td>
		</tr>
	</table>
</html:form>
</body>
</html:html>
