<%--

    Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
    This software is published under the GPL GNU General Public License.
    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

    This software was written for the
    Department of Family Medicine
    McMaster University
    Hamilton
    Ontario, Canada

--%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/oscarProperties-tag.tld" prefix="oscarProp" %>

<%@ page import="oscar.OscarProperties,java.util.*" %>
<%@page import="org.oscarehr.util.SpringUtils"%>
<%@page import="org.oscarehr.PMmodule.dao.ProviderDao"%>
<%@page import="org.oscarehr.common.model.Provider"%>

<%@page import="org.oscarehr.common.model.ProfessionalSpecialist"%>
<%@page import="org.oscarehr.common.model.ConsultationReport"%>
<%@page import="org.oscarehr.common.model.Provider"%>
<%@page import="org.oscarehr.common.model.Demographic"%>

<html:html locale="true">

<%
	OscarProperties props = OscarProperties.getInstance();
	ProfessionalSpecialist spec = (ProfessionalSpecialist)request.getAttribute("spec");
	Demographic demographic = (Demographic)request.getAttribute("demographic");
	Provider provider = (Provider)request.getAttribute("provider");
	ConsultationReport report = (ConsultationReport)request.getAttribute("report");
%>

<head>
    <html:base/>
    <style type="text/css" media="print">
        .header {
        display:none;
        }

        .header INPUT {
        display:none;
        }

        .header A {
        display:none;
        }
    </style>

    <style type="text/css">
        .Header{
        background-color:#BBBBBB;
        padding-top:5px;
        padding-bottom:5px;
        width: 450pt;
        font-size:12pt;
        }

        .Header INPUT{
        width: 100px;
        }

        .Header A{
        font-size: 12pt;
        }

        table.patientInfo{
        border: 1pt solid #888888;
        }

        table.leftPatient{
        border-left: 1pt solid #AAAAAA;
        }

        table.printTable{
        width: 450pt;
        border: 1pt solid #888888;
        font-size: 10pt;
        font-family: arial, verdana, tahoma, helvetica, sans serif;
        }

        td.subTitles{
        font-size:12pt;
        font-family: arial, verdana, tahoma, helvetica, sans serif;
        }

        td.fillLine{
        border-bottom: 1pt solid #444444;
        font-size:10pt;
        font-family: arial, verdana, tahoma, helvetica, sans serif;
        }

        pre.text{
        font-size:10pt;
        font-family: arial, verdana, tahoma, helvetica, sans serif;
        }

        td.title4{
        font-size:12pt;
        font-family: arial, verdana, tahoma, helvetica, sans serif;
        }

        td.address{
        font-size:10pt;
        font-family: arial, verdana, tahoma, helvetica, sans serif;
        }

    </style>

    <script type="text/javascript">
    function PrintWindow(){
       	 window.print();
    }

    function CloseWindow(){
    	//window.close();
	//appear to close window and go back to form
	history.go(-1);
    }

var flag =1;

    function flipFaxFooter(){

        if (flag == 1 ){
            document.getElementById("faxFooter").innerHTML="<hr><bean:message key="oscarEncounter.oscarConsultationRequest.consultationFormPrint.msgFaxFooterMessage"/>";
            flag = 0;
        }else{
            document.getElementById("faxFooter").innerHTML="";
            flag = 1;
        }
    }

    </script>
    <title>
    Consultation Report
    </title>
    </head>
    <body>
        <form  method="get "action="attachmentReport.jsp">
            <input type="hidden" name="reqId" value=""/>
            <input type="hidden" name="demographicNo" value=""/>
            <input type="hidden" name="providerNo" value=""/>
        <table class="header" style="width:100%">
            <tr>
            <td align="center">
                
                <input type=button value="<bean:message key="oscarEncounter.oscarConsultationRequest.consultationFormPrint.msgFaxFooter"/>" onclick="javascript :flipFaxFooter();"/>
            </td>
            <td align="center">
                <input type=button value="<bean:message key="oscarEncounter.oscarConsultationRequest.consultationFormPrint.msgPrint"/>" onclick="javascript: PrintWindow();"/>
            </td>
           
            <td align="center">
                <input type=button value="<bean:message key="global.btnClose"/>" onclick="javascript: CloseWindow();"/>
            </td>
		
            </tr>
         </table>
         <table class="printTable" name="headerTable" style="width:100%" >
         	<tr>
         		<td>
         		<%=divy(spec.getStreetAddress()) %>
         		<br/><br/>
         		Phone:<%=spec.getPhoneNumber() %>
         		<br/>
         		Fax:<%=spec.getFaxNumber() %>
         		</td>
         	</tr>
         	<tr>
         		<td>
         			<center>
	         			<span style="font-weight:bold;font-size:14pt">Dr. <%=spec.getFirstName() %>&nbsp;<%=spec.getLastName() %>&nbsp;<%=spec.getProfessionalLetters() %></span>
	         			<br/>
	         			<span style="font-weight:bold;font-size:12pt"><%=spec.getSpecialtyType() %></span>
         			</center>
         		</td>
         	</tr>
         	<tr>
         	<td><hr/></td>
         	</tr>
         	<tr>
         		<td>
         		<p>Dear Dr.</p>
         		<p>Thank you for referring patient <%=demographic.getFirstName() + " " + demographic.getLastName() %></p>
         		<p></p>
         		<p>Thank you for sending all of the pertinent prenatal test results. It was very beneficial to have them available for
         		the consultation.</p>
         		<p>Thank you for involving me in <%=demographic.getFirstName() + " " + demographic.getLastName() %>'s care.
         		<p></p>
         		<p>Sincerely,</p>
         		<p></p>
         		<p>Dr. <%=report.getProvider() %></p>
         		</td>
         	</tr>
            <tr>
                    <td id="faxFooter">
 			

                    </td>
                </tr>
                <tr>
                <td align="center">
                    <% if (props.getProperty("FORMS_PROMOTEXT") != null){
                        %></br><%= props.getProperty("FORMS_PROMOTEXT") %>
                    <%}%>
                </td>
            </tr>
        </table>
        </form>
        <table class="printTable" name="headerTable">
 
        </table>



    </body>
</html:html>

<%!
public String divy (String str){
    StringBuffer stringBuffer = new StringBuffer();
    stringBuffer.append(str);
    int j =0;
    int i = 0 ;
    while (i < stringBuffer.length() ){
        if (stringBuffer.charAt(i) == '\n'){
        stringBuffer.insert(i,"<BR>");
        i = i + 4;
        }
    i++;
    }
return stringBuffer.toString();
}

public String wrap(String in,int len) {
	if(in==null)
		in="";
	//in=in.trim();
	if(in.length()<len) {
		if(in.length()>1 && !in.startsWith("  ")) {
			in=in.trim();
		}
		return in;
	}
	if(in.substring(0, len).contains("\n")) {
		String x = in.substring(0, in.indexOf("\n"));
		if(x.length()>1 && !x.startsWith("  ")) {
			x=x.trim();
		}
		return x + "\n" + wrap(in.substring(in.indexOf("\n") + 1), len);
	}
	int place=Math.max(Math.max(in.lastIndexOf(" ",len),in.lastIndexOf("\t",len)),in.lastIndexOf("-",len));
	if( place == 0 ) {
		place = len;
	}
	return in.substring(0,place).trim()+"\n"+wrap(in.substring(place),len);
}
%>
