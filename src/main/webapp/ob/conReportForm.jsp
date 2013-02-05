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

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/rewrite-tag.tld" prefix="rewrite"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/oscar-tag.tld" prefix="oscar"%>


<%@page import="java.util.*,oscar.OscarProperties, oscar.util.StringUtils"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@page import="org.oscarehr.util.LoggedInInfo"%>
<%@page import="org.oscarehr.util.SpringUtils"%>
<%@page import="org.oscarehr.PMmodule.dao.ProviderDao" %>
<%@page import="org.oscarehr.common.model.Provider" %>
<%@page import="org.oscarehr.common.dao.DemographicDao" %>
<%@page import="org.oscarehr.common.model.Demographic" %>
<%@page import="org.oscarehr.common.model.ConsultationReport" %>
<%@page import="org.oscarehr.common.dao.ProfessionalSpecialistDao" %>
<%@page import="org.oscarehr.common.model.ProfessionalSpecialist" %>

<%
org.apache.struts.validator.DynaValidatorForm form = (org.apache.struts.validator.DynaValidatorForm)request.getAttribute("obForm");
ConsultationReport conReport = (ConsultationReport)form.get("cp");

ProviderDao providerDao = SpringUtils.getBean(ProviderDao.class);
DemographicDao demographicDao = SpringUtils.getBean(DemographicDao.class);
ProfessionalSpecialistDao professionalSpecialistDao = SpringUtils.getBean(ProfessionalSpecialistDao.class);

//Provider provider = providerDao.getProvider(conReport.getProvider());
Demographic demographic = demographicDao.getDemographicById(conReport.getDemographicNo());

String referralDocName = null;

if(conReport.getSendTo() != null && conReport.getSendTo().length() >0) {
	referralDocName = conReport.getSendTo();
}


if(referralDocName==null)
	referralDocName=new String();

Map<String,Boolean> testMap = (Map<String,Boolean>)request.getAttribute("testMap");

%>

<html:html locale="true">
<head>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<script>
	
</script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/global.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery_oscar_defaults.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/share/javascript/prototype.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=request.getContextPath()%>/share/calendar/calendar.css" title="win2k-cold-1" />

<script type="text/javascript" src="<%=request.getContextPath()%>/share/calendar/calendar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/share/calendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/share/calendar/calendar-setup.js"></script>

<script>
  jQuery.noConflict();
</script>

<script>
function rs(n,u,w,h,x) {
		args="width="+w+",height="+h+",resizable=yes,scrollbars=yes,status=0,top=360,left=30";
		remote=window.open(u,n,args);
		if (remote != null) {
		if (remote.opener == null)
  		remote.opener = self;
		}
		if (x == 1) { return remote; }
}

function referralScriptAttach2(elementName, name2) {
    var d = elementName;
    t0 = escape("document.forms[0].elements[\'"+d+"\'].value");
    t1 = escape("document.forms[0].elements[\'"+name2+"\'].value");
    rs('att',('<%=(String)session.getAttribute("oscar_context_path")%>/billing/CA/ON/searchRefDoc.jsp?param='+t0+'&param2='+t1),600,600,1);
}
</script>

<oscar:customInterface section="conreport_ob"/>

<title>Consultation Report</title>

<html:base />
<style type="text/css">

/* Used for "import from enctounter" button */
input.btn{
   color:black;
   font-family:'trebuchet ms',helvetica,sans-serif;
   font-size:84%;
   font-weight:bold;
   background-color:#B8B8FF;
   border:1px solid;
   border-top-color:#696;
   border-left-color:#696;
   border-right-color:#363;
   border-bottom-color:#363;
}

.doc {
    color:blue;
}

.lab {
    color: #CC0099;
}
td.tite {

background-color: #bbbbFF;
color : black;
font-size: 12pt;

}

td.tite1 {

background-color: #ccccFF;
color : black;
font-size: 12pt;

}

th,td.tite2 {

background-color: #BFBFFF;
color : black;
font-size: 12pt;

}

td.tite3 {

background-color: #B8B8FF;
color : black;
font-size: 12pt;

}

td.tite4 {

background-color: #ddddff;
color : black;
font-size: 12pt;

}

td.stat{
font-size: 10pt;
}

input.righty{
text-align: right;
}
</style>

<link rel="stylesheet" type="text/css" href="../oscarEncounter/encounterStyles.css">

<script>
	function doPrint() {
		jQuery("#print").val("true");
		return true;
	}



function printCheck(v){

if(v!="" && document.getElementById("referral_doc_name").value!=""){
document.getElementById("printPreview").disabled = false;
}

}
</script>
</head>




<body topmargin="0" leftmargin="0" vlink="#0000FF">
<html:errors />

<html:form action="/ob/OB">

	
	<input type="hidden" name="cp.demographicNo" value="<%=conReport.getDemographicNo()%>">
	<input type="hidden" name="cp.provider" value="<%=conReport.getProvider()%>">
	<input type="hidden" name="cp.id" value="<%=conReport.getId()%>">
	<input type="hidden" name="cp.referralId" value="<%=conReport.getReferralId()%>">
	<input type="hidden" name="method" value="saveConReport"/>
	<input type="hidden" id="print" name="print" value="false"/>
	
	<!--  -->
	<table class="MainTable" id="scrollNumber1" name="encounterTable">
		<tr class="MainTableTopRow">
			<td class="MainTableTopRowLeftColumn">Consultation</td>
			<td class="MainTableTopRowRightColumn">
			<table class="TopStatusBar">
				<tr>
					<td class="Header"
						style="padding-left: 2px; padding-right: 2px; border-right: 2px solid #003399; text-align: left; font-size: 80%; font-weight: bold; width: 100%;"
						NOWRAP><%=demographic.getFormattedName()%></td>
				</tr>
			</table>
			</td>
		</tr>
		<tr style="vertical-align: top">
			<td class="MainTableLeftColumn">
			<table>
				<tr>
					<td class="tite4" colspan="2">
					<table>
						<tr>
							<td class="stat" colspan="2"><bean:message key="oscarEncounter.oscarConsultationRequest.ConsultationFormRequest.msgCreated" />:</td>
						</tr>
						<tr>
							<td class="stat" colspan="2" align="right" nowrap><%=conReport.getProvider()%>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="tite4" colspan="2"><bean:message key="oscarEncounter.oscarConsultationRequest.ConsultationFormRequest.msgStatus" />
					</td>
				</tr>
				<tr>
					<td class="tite4" colspan="2">
					<table>
						<tr>
							<td class="stat"><html:radio property="cp.status" value="1" />
							</td>
							<td class="stat">Incomplete:
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="tite4" colspan="2">
					<table>
						<tr>
							<td class="stat"><html:radio property="cp.status" value="2" />
							</td>
							<td class="stat">Completed,not sent</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="tite4" colspan="2">
					<table>
						<tr>
							<td class="stat"><html:radio property="cp.status" value="3" />
							</td>
							<td class="stat">Completed,and sent</td>
						</tr>
					</table>
					</td>
				</tr>

			</table>
			</td>
			<td class="MainTableRightColumn">
			<table cellpadding="0" cellspacing="2"
				style="border-collapse: collapse" bordercolor="#111111" width="100%"
				height="100%" border=1>

				<!----Start new rows here-->
				<tr>
					<td>
						<table border=0 width="100%">
							<tr>
								<td class="tite4">Send to:</td>

								<td align="left" class="tite1">
				<input type="text" name="referral_doc_name" id="referral_doc_name" value="<%=referralDocName%>" readonly/>
				
				<a href="javascript:referralScriptAttach2('cp.referralId','referral_doc_name')">
										<span style="font-size: 10;">Search #</span>
									</a>
								</td>
						</table>
					</td>
					
				</tr>
				
				<tr>
					<td class="tite4" colspan="3">
						Impression and Plan:<br/>
						<html:textarea property="cp.impression" rows="10" style="width:100%"></html:textarea>
					</td>
				</tr>
				
				<tr>
					<td class="tite4" colspan="3">
						Tests request:<br/>
						<div  style="background-color:white">
							<input type="checkbox" name="cp.plan" <%=getChecked("CBC",testMap) %> value="CBC" onchange="return printCheck(this.value)" />CBC<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("Blood type and screen",testMap) %> value="Blood type and screen" onchange="return printCheck(this.value)"/>Blood type and screen<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("Rubella",testMap) %> value="Rubella" onchange="return printCheck(this.value)"/>Rubella<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("HBsAG",testMap) %> value="HBsAG" onchange="return printCheck(this.value)"/>HBsAG<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("VDRL",testMap) %> value="VDRL" onchange="return printCheck(this.value)"/>VDRL<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("HIV",testMap) %> value="HIV" onchange="return printCheck(this.value)"/>HIV<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("PAP",testMap) %> value="PAP" onchange="return printCheck(this.value)"/>PAP<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("Cervical swabs",testMap) %> value="Cervical swabs" onchange="return printCheck(this.value)"/>Cervical swabs<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("Urine culture",testMap) %> value="Urine culture" onchange="return printCheck(this.value)"/>Urine culture<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("Genetic screening results",testMap) %> value="Genetic screening results" onchange="return printCheck(this.value)"/>Genetic screening results<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("Ultrasounds",testMap) %> value="Ultrasounds" onchange="return printCheck(this.value)"/>Ultrasounds<br/>
							<input type="checkbox" name="cp.plan" <%=getChecked("OGCT",testMap) %> value="OGCT" onchange="return printCheck(this.value)"/>OGCT<br/>
							<input type="checkbox" name="cp.plan"<%=getChecked("Other",testMap) %>  value="Other" onchange="return printCheck(this.value)"/>Other&nbsp;<html:text property="cp.conMemo" size="20" onchange="return printCheck(this.value)"/><br/>
						</div>
					</td>
				</tr>

				<tr>
					<td colspan="3" style="text-align:right">
						<input type="submit" value="Print Preview" id="printPreview" onclick="return doPrint();" disabled/>
						<input type="submit" value="Save and Close" />
					</td>
				</tr>
				<!----End new rows here-->

				<tr height="100%">
					<td></td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td class="MainTableBottomRowLeftColumn"></td>
			<td class="MainTableBottomRowRightColumn"></td>
		</tr>
	</table>
</html:form>
</body>

</html:html>
<%!
String getChecked(String name,Map<String,Boolean> testMap) {
	if(testMap != null && testMap.get(name) != null) {
		return " checked=\"checked\" ";
	}
	return "";
}
%>
