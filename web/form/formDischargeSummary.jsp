
<%@ page language="java"%>
<%@ page import="oscar.util.*, oscar.form.*, oscar.form.data.*" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="oscarVariables" class="java.util.Properties" scope="session" />

<%
	String formClass = "DischargeSummary";
	String formLink = "formDischargeSummary.jsp";
	int programNo = Integer.parseInt((String)request.getSession().getAttribute("infirmaryView_programId"));
    int demoNo = Integer.parseInt(request.getParameter("demographic_no"));
    int formId = Integer.parseInt(request.getParameter("formId"));
	int provNo = Integer.parseInt((String) session.getAttribute("user"));
	FrmRecord rec = (new FrmRecordFactory()).factory(formClass);
    //java.util.Properties props = rec.getFormRecord(demoNo, formId);
    java.util.Properties props = rec.getCaisiFormRecord(demoNo, formId, provNo, programNo);
    //FrmData fd = new FrmData();    String resource = fd.getResource(); resource = resource + "ob/riskinfo/";

	//get project_home
	String project_home = request.getContextPath().substring(1);	
%>
<%
  boolean bView = false;
  if (request.getParameter("view") != null && request.getParameter("view").equals("1")) bView = true; 
%>
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
<html:html locale="true">
<% response.setHeader("Cache-Control","no-cache");%>

<head>
    <title>MULTI-DISCIPLINARY TEAM DISCHARGE SUMMARY</title>
    <link rel="stylesheet" type="text/css" href="arStyle.css">
    <html:base/>
</head>


<script type="text/javascript" language="Javascript">

    function reset() {
        document.forms[0].target = "apptProviderSearch";
        document.forms[0].action = "/<%=project_home%>/form/formname.do" ;
	}
    function onPrint() {
        document.forms[0].submit.value="print"; //printAR1
        var ret = checkAllDates();
        if(ret==true)
        {
            //ret = confirm("Do you wish to save this form and view the print preview?");
            popupFixedPage(650,850,'../provider/notice.htm');
            document.forms[0].action = "../form/createpdf?__title=&__cfgfile=&__cfgfile=&__template=";
            document.forms[0].target="planner";
            document.forms[0].submit();
            document.forms[0].target="apptProviderSearch";
        }
        return ret;
    }
    function onSave() {
        document.forms[0].submit.value="save";
        var ret = checkAllDates();
        if(ret==true) {
            reset();
            ret = confirm("Are you sure you want to save this form?");
        }
        return ret;
    }
    function onExit() {
        if(confirm("Are you sure you wish to exit without saving your changes?")==true) {
            window.close();
        }
        return(false);
    }
    function onSaveExit() {
        document.forms[0].submit.value="exit";
        var ret = checkAllDates();
        if(ret == true) {
            reset();
            ret = confirm("Are you sure you wish to save and close this window?");
        }
        return ret;
    }
    function popupPage(varpage) {
        windowprops = "height=700,width=960"+
            ",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=no,screenX=50,screenY=50,top=20,left=20";
        var popup = window.open(varpage, "ar2", windowprops);
        if (popup.opener == null) {
            popup.opener = self;
        }
    }
    function popPage(varpage,pageName) {
        windowprops = "height=700,width=960"+
            ",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=no,screenX=50,screenY=50,top=20,left=20";
        var popup = window.open(varpage,pageName, windowprops);
        //if (popup.opener == null) {
        //    popup.opener = self;
        //}
        popup.focus();
    }
    function popupFixedPage(vheight,vwidth,varpage) { 
       var page = "" + varpage;
       windowprop = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=10,screenY=0,top=0,left=0";
       var popup=window.open(page, "planner", windowprop);
    }

/**
 * DHTML date validation script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
 */
// Declaring valid date character, minimum year and maximum year
var dtCh= "/";
var minYear=1900;
var maxYear=9900;

    function isInteger(s){
        var i;
        for (i = 0; i < s.length; i++){
            // Check that current character is number.
            var c = s.charAt(i);
            if (((c < "0") || (c > "9"))) return false;
        }
        // All characters are numbers.
        return true;
    }

    function stripCharsInBag(s, bag){
        var i;
        var returnString = "";
        // Search through string's characters one by one.
        // If character is not in bag, append to returnString.
        for (i = 0; i < s.length; i++){
            var c = s.charAt(i);
            if (bag.indexOf(c) == -1) returnString += c;
        }
        return returnString;
    }

    function daysInFebruary (year){
        // February has 29 days in any year evenly divisible by four,
        // EXCEPT for centurial years which are not also divisible by 400.
        return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
    }
    function DaysArray(n) {
        for (var i = 1; i <= n; i++) {
            this[i] = 31
            if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
            if (i==2) {this[i] = 29}
       }
       return this
    }

    function isDate(dtStr){
        var daysInMonth = DaysArray(12)
        var pos1=dtStr.indexOf(dtCh)
        var pos2=dtStr.indexOf(dtCh,pos1+1)
        var strMonth=dtStr.substring(0,pos1)
        var strDay=dtStr.substring(pos1+1,pos2)
        var strYear=dtStr.substring(pos2+1)
        strYr=strYear
        if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
        if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
        for (var i = 1; i <= 3; i++) {
            if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
        }
        month=parseInt(strMonth)
        day=parseInt(strDay)
        year=parseInt(strYr)
        if (pos1==-1 || pos2==-1){
            return "format"
        }
        if (month<1 || month>12){
            return "month"
        }
        if (day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
            return "day"
        }
        if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
            return "year"
        }
        if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
            return "date"
        }
    return true
    }


    function checkTypeIn(obj) {
      if(!checkTypeNum(obj.value) ) {
          alert ("You must type in a number in the field.");
        }
    }

    function valDate(dateBox)
    {
        try
        {
            var dateString = dateBox.value;
            if(dateString == "")
            {
				//alert('dateString'+dateString);
                return true;
            }
            var dt = dateString.split('/');
            //var y = dt[2];  var m = dt[1];  var d = dt[0];
            var y = dt[0];  var m = dt[1];  var d = dt[2];
            var orderString = m + '/' + d + '/' + y;
            var pass = isDate(orderString);

            if(pass!=true)
            {
                alert('Invalid '+pass+' in field ' + dateBox.name);
                dateBox.focus();
                return false;
            }
        }  catch (ex)  {
            alert('Catch Invalid Date in field ' + dateBox.name);
            dateBox.focus();
            return false;
        }
        return true;
    }

    function checkAllDates() {
        var b = true;
        if(valDate(document.forms[0].pg1_eddByDate)==false){
            b = false;
        } else if(valDate(document.forms[0].pg1_eddByUs)==false){
            b = false;
        } 

        return b;
    }
</script>

<body bgproperties="fixed" topmargin="0" leftmargin="1" rightmargin="1">
<html:form action="/form/formname">
<input type="hidden" name="demographic_no" value="<%= props.getProperty("demographic_no", "0") %>" />
<input type="hidden" name="formCreated" value="<%= props.getProperty("formCreated", "") %>" />
<input type="hidden" name="form_class" value="<%=formClass%>" />
<input type="hidden" name="form_link" value="<%=formLink%>" />
<input type="hidden" name="formId" value="<%=formId%>" />
<!--input type="hidden" name="provider_no" value=<%=request.getParameter("provNo")%> />
<input type="hidden" name="provNo" value="<%= request.getParameter("provNo") %>" /-->
<input type="hidden" name="submit" value="exit"/>

<!-- 
<table width="100%" class="Head" class="hidePrint">
 -->
 <table width="100%">
    <tr width="100%">
        <td align="left">
<%
  if (!bView) {
%>
            <input type="submit" value="Save" onclick="javascript:return onSave();" />
            <input type="submit" value="Save and Exit" onclick="javascript:return onSaveExit();"/>
<%
  }
%>
            <input type="button" value="Exit" onclick="javascript:return onExit();"/>
            <input type="button" value="Print" onclick="javascript:window.print();"/>
        </td>
<%
  if (!bView) {
%>
        <td align="right">
            <a href="javascript: popupFixedPage(700,950,'../decision/antenatal/antenatalplanner.jsp?demographic_no=<%=demoNo%>&formId=<%=formId%>');">Planner</a>
        </td>
<%
  }
%>
    </tr>
</table>


<table border="0" cellspacing="0" cellpadding="0" width="100%" >
 <tr bgcolor="#486ebd">
      <th align='CENTER'  ><font face="Arial, Helvetica, sans-serif" color="#FFFFFF">Sherbourne Health Centre</font></th>
 </tr>
<tr>
<td align="center" bgcolor="#CCCCCC" ><b><font face="Verdana, Arial, Helvetica, sans-serif">MULTI-DISCIPLINARY TEAM DISCHARGE SUMMARY
</font></b></td>
</tr>
</table>


<table width="100%" border="1"  cellspacing="0" cellpadding="0" >
    <tr width="100%">
     <td width="10%" align="left">Client Name:</td>
     <td width="25%">
      <input type="text" name="clientName" readonly="true" style="width:100%" size="30" maxlength="30" value="<%= props.getProperty("clientName", "") %>" />
	 </td>
     <td width="15%" align="right">DOB<small>(yyyy/mm/dd)</small>: </td>
     <td width="15%">
      <input type="text" name="birthDate" readonly="true" style="width:100%" size="20" maxlength="12" value="<%= props.getProperty("birthDate", "") %>"/>
	 </td>
	 <td width="5%" align="right">OHIP#: </td>
     <td width="30%">
      <input type="text" name="ohip" readonly="true" style="width:100%" size="20" maxlength="20" value="<%= props.getProperty("ohip", "") %>"/>
	 </td>
    </tr>    

<!--
<table border="0" cellspacing="0" cellpadding="0" width="100%" >
  <tr bgcolor="#486ebd">
    <th align=CENTER  ><font face="Arial, Helvetica, sans-serif" color="#FFFFFF">&nbsp;</font></th>
</tr>
</table>
  -->

    <tr width="100%">
     <td width="5%" align="left">Admit Date:</td>
     <td width="10%">
      <input type="text" name="admitDate" readonly="true" style="width:100%" size="10" maxlength="10" value="<%= props.getProperty("admitDate", "") %>" />
	 </td>
     <td width="10%" align="right">Discharge Date(yyyy/mm/dd): </td>
     <td width="5%">
      <input type="text" name="dischargeDate" style="width:100%" size="10" maxlength="12" value="<%= props.getProperty("dischargeDate", "") %>"/>
	 </td>
	 <td width="5%" align="right">Program Name: </td>
	 <td width="25%"><input type="text" name="programName" readonly style="width:100%" value="<%= props.getProperty("programName", "") %>"/></td>
	 </tr>
	 
	 <tr width="100%">
	 <td align="left">Allergies: </td>
     <td colspan="5">
      <input type="text" name="allergies" readonly="true" style="width:100%" value="<%= props.getProperty("allergies", "") %>"/>
	 </td>
    </tr>
     
</table>

<table width="100%" border="1"  cellspacing="0" cellpadding="0" >
<tr>
<td colspan="3">Admitting Diagnosis/Primary Diagnosis:
		<textarea  name="admissionNotes" readonly style="width:100%" cols="20" rows="3" @oscar.formDB dbType="text"/><%= props.getProperty("admissionNotes", "") %></textarea>
</td>
</tr>
<tr>
<td colspan="3">Problem List:
		<textarea  name="currentIssues" readonly style="width:100%" cols="20" rows="3" @oscar.formDB dbType="text"/><%= props.getProperty("currentIssues", "") %></textarea>
</td>
</tr>
<tr>
<td colspan="3">Brief Summary of stay (include special procedures/treatment/complications):
		<textarea  name="briefSummary" style="width:100%" cols="20" rows="3" @oscar.formDB dbType="text"/><%= props.getProperty("briefSummary", "") %></textarea>
</td>
</tr>
<tr>
<td colspan="3">Discharge Plan of Care/Recommendations/Outstanding Issues:
		<textarea  name="dischargePlan" style="width:100%" cols="20" rows="3" @oscar.formDB dbType="text"/><%= props.getProperty("dischargePlan", "") %></textarea>
</td>
</tr>			
</table>
<table width="100%" border="1"  cellspacing="0" cellpadding="0" >
<tr>
	<td colspan="4">Follow-up Appointment(s):  To be arranged by Patient:</td>	
	<td align="right">
	<%if(props.getProperty("followUpAppointment","").equals("1")){%>
	<input type="radio" name="followUpAppointment" value="1" checked />
	<%}else { %>
	<input type="radio" name="followUpAppointment" value="1" />
	<%} %>
	</td>
	<td>Yes</td>
	<td align="right">
	<%if(props.getProperty("followUpAppointment","").equals("0")){%>
	<input type="radio" name="followUpAppointment" value="0" checked />
	<%}else { %>
	<input type="radio" name="followUpAppointment" value="0"/>
	<%} %>
	</td>
	<td>No</td>
</tr> 
<tr>
	<td align="right">Dr. </td>
     <td>
      <input type="text" name="doctor1" style="width:100%" size="30" maxlength="30" value="<%= props.getProperty("doctor1", "") %>"/>
	 </td>
	 <td align="right">Phone No: </td>
     <td>
      <input type="text" name="phoneNumber1" style="width:100%" size="25" maxlength="25" value="<%= props.getProperty("phoneNumber1", "") %>"/>
	 </td>
	 <td align="right">Date/Time: </td>
     <td>
      <input type="text" name="date1" style="width:100%" size="20" maxlength="20" value="<%= props.getProperty("date1", "") %>"/>
	 </td>
	 <td align="right">Location: </td>
     <td>
      <input type="text" name="location1" style="width:100%" size="45" maxlength="45" value="<%= props.getProperty("location1", "") %>"/>
	 </td>
</tr>
<tr>
	<td align="right">Dr. </td>
     <td>
      <input type="text" name="doctor2" style="width:100%" size="30" maxlength="30" value="<%= props.getProperty("doctor2", "") %>"/>
	 </td>
	 <td align="right">Phone No: </td>
     <td>
      <input type="text" name="phoneNumber2" style="width:100%" size="25" maxlength="25" value="<%= props.getProperty("phoneNumber2", "") %>"/>
	 </td>
	 <td align="right">Date/Time: </td>
     <td>
      <input type="text" name="date2" style="width:100%" size="20" maxlength="20" value="<%= props.getProperty("date2", "") %>"/>
	 </td>
	 <td align="right">Location: </td>
     <td>
      <input type="text" name="location2" style="width:100%" size="45" maxlength="45" value="<%= props.getProperty("location2", "") %>"/>
	 </td>
</tr>
<tr>
	<td align="right">Dr. </td>
     <td>
      <input type="text" name="doctor3" style="width:100%" size="30" maxlength="30" value="<%= props.getProperty("doctor3", "") %>"/>
	 </td>
	 <td align="right">Phone No: </td>
     <td>
      <input type="text" name="phoneNumber3" style="width:100%" size="25" maxlength="25" value="<%= props.getProperty("phoneNumber3", "") %>"/>
	 </td>
	 <td align="right">Date/Time: </td>
     <td>
      <input type="text" name="date3" style="width:100%" size="20" maxlength="20" value="<%= props.getProperty("date3", "") %>"/>
	 </td>
	 <td align="right">Location: </td>
     <td>
      <input type="text" name="location3" style="width:100%" size="35" maxlength="35" value="<%= props.getProperty("location3", "") %>"/>
	 </td>
</tr>
</table>

<table width="100%" border="1"  cellspacing="0" cellpadding="0" >
<tr>
	<td>
		<table width="100%" border="1"  cellspacing="0" cellpadding="0" >
		<tr><td>Summary of Current Medication Upon Discharge:</td></tr>
		<tr><td><textarea name="prescriptionSummary" readonly="true" style="width:100%" cols="30" rows="7" @oscar.formDB dbType="text"/><%= props.getProperty("prescriptionSummary", "") %></textarea></td></tr>
		</table>
	</td>
	<td>
		<table width="100%" border="1"  cellspacing="0" cellpadding="0" >
		<tr>
			<td>Prescription Provided:</td>
			<td align="right">
			<%if(props.getProperty("prescriptionProvided","").equals("1")){%>
			<input type="radio" name="prescriptionProvided" value="1" checked />
			<%}else { %>
			<input type="radio" name="prescriptionProvided" value="1" />
			<%} %>
			</td>
			<td>Yes</td>
			<td align="right">
			<%if(props.getProperty("prescriptionProvided","").equals("0")){%>
			<input type="radio" name="prescriptionProvided" value="0" checked />
			<%}else { %>
			<input type="radio" name="prescriptionProvided" value="0"/>
			<%} %>
			</td>
			<td>No</td>			
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td>Covered by Ontario Drug Benefit:</td>
			<td align="right">
			<%if(props.getProperty("coveredByODB","").equals("1")){%>
			<input type="radio" name="coveredByODB" value="1" checked />
			<%}else { %>
			<input type="radio" name="coveredByODB" value="1" />
			<%} %>
			</td>
			<td>Yes</td>
			<td align="right">
			<%if(props.getProperty("coveredByODB","").equals("0")){%>
			<input type="radio" name="coveredByODB" value="0" checked />
			<%}else { %>
			<input type="radio" name="coveredByODB" value="0"/>
			<%} %>
			</td>
			<td>No</td>	
			<td></td>
			<td></td>			
		</tr>
		<tr>
			<td>ODB Form Required:</td>
			<td align="right">
			<%if(props.getProperty("ODBFormReqired","").equals("1")){%>
			<input type="radio" name="ODBFormReqired" value="1" checked />
			<%}else { %>
			<input type="radio" name="ODBFormReqired" value="1" />
			<%} %>
			</td>
			<td>Yes</td>
			<td align="right">
			<%if(props.getProperty("ODBFormReqired","").equals("0")){%>
			<input type="radio" name="ODBFormReqired" value="0" checked />
			<%}else { %>
			<input type="radio" name="ODBFormReqired" value="0"/>
			<%} %>
			</td>
			<td>No</td>	
			<td align="right">
			<%if(props.getProperty("ODBFormReqired","").equals("2")){%>
			<input type="radio" name="ODBFormReqired" value="2" checked />
			<%}else { %>
			<input type="radio" name="ODBFormReqired" value="2"/>
			<%} %>
			</td>
			<td>Completed</td>					
		</tr>
		<tr>
			<td>Counselling Provided by:</td>
			<td><input type="text" name="counsellorName" style="width:100%" size="26" maxlength="26" value="<%= props.getProperty("counsellorName", "") %>"/><td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>			
		</tr>
		<tr>
			<td>Follow-up Required:</td>
			<td align="right">
			<%if(props.getProperty("followUpRequired","").equals("1")){%>
			<input type="radio" name="followUpRequired" value="1" checked />
			<%}else { %>
			<input type="radio" name="followUpRequired" value="1" />
			<%} %>
			</td>
			<td>Yes</td>
			<td align="right">
			<%if(props.getProperty("followUpRequired","").equals("0")){%>
			<input type="radio" name="followUpRequired" value="0" checked />
			<%}else { %>
			<input type="radio" name="followUpRequired" value="0"/>
			<%} %>
			</td>
			<td>No</td>				
			<td></td>
			<td></td>			
		</tr>
		<tr>
			<td>If yes, please specify:</td>
			<td colspan="6"><input type="text" name="followUpRequiredDetail" style="width:100%" size="60" maxlength="60" value="<%= props.getProperty("followUpRequiredDetail", "") %>"/><td>						
		</tr>
		<tr>
			<td>Changes in Medications (include explanation):</td>
			<td colspan="6"><input type="text" name="changeMedications" style="width:100%" size="60" maxlength="60" value="<%= props.getProperty("changeMedications", "") %>"/><td>					
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td colspan="2">Referrals made/pending:
		<textarea name="referrals" style="width:100%" cols="30" rows="3" @oscar.formDB dbType="text"/><%= props.getProperty("referrals", "") %></textarea>
	</td>
</tr>
</table>
<table width="100%" border="1"  cellspacing="0" cellpadding="0" >
<tr>
	<td>Program:
		<textarea name="program" style="width:100%" cols="30" rows="5" @oscar.formDB dbType="text"/><%= props.getProperty("program", "") %></textarea>
	</td>
	<td>Referral Made:
		<textarea name="referralMade" style="width:100%" cols="30" rows="5" @oscar.formDB dbType="text"/><%= props.getProperty("referralMade", "") %></textarea>
	</td>
	<td>Outcome:
		<textarea name="outcome" style="width:100%" cols="30" rows="5" @oscar.formDB dbType="text"/><%= props.getProperty("outcome", "") %></textarea>
	</td>
</tr>

</table>

<table>
<tr>	
     <td align="left">Infirmary Health Care Provider:</td> 
     <td>
		<input type="text" name="providerName" readonly="true" style="width:100%" size="30" maxlength="30" value="<%= props.getProperty("providerName", "") %>" />
	 </td>
	<td>Physician's Signature:</td>
	<td>
		<input type="text" name="signature" size="25" maxlength="25" value="<%= props.getProperty("signature", "") %>" @oscar.formDB />
	</td>
	<td>Date(yyyy/mm/dd):</td>
	<td>
		<input type="text" name="signatureDate" size="10" maxlength="10" value="<%= props.getProperty("signatureDate", "") %>" />
    </td>
</tr>
</table>


<table>
    <tr>
        <td align="left">
<%
  if (!bView) {
%>
            <input type="submit" value="Save" onclick="javascript:return onSave();" />
            <input type="submit" value="Save and Exit" onclick="javascript:return onSaveExit();"/>
<%
  }
%>
            <input type="button" value="Exit" onclick="javascript:return onExit();"/>
            <input type="button" value="Print" onclick="javascript:window.print();"/>
        </td>
<%
  if (!bView) {
%>
        <td align="right">
            <a href="javascript: popupFixedPage(700,950,'../decision/antenatal/antenatalplanner.jsp?demographic_no=<%=demoNo%>&formId=<%=formId%>');">Planner</a>
        </td>
<%
  }
%>
    </tr>
</table>


</html:form>
</body>
</html:html>

