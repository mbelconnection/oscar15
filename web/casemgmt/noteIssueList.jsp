<%-- 
// -----------------------------------------------------------------------------------------------------------------------
// *
// *
// * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
// * This software is published under the GPL GNU General Public License. 
// * This program is free software; you can redistribute it and/or 
// * modify it under the terms of the GNU General Public License 
// * as published by the Free Software Foundation; either version 2 
// * of the License, or (at your option) any later version. * 
// * This program is distributed in the hope that it will be useful, 
// * but WITHOUT ANY WARRANTY; without even the implied warranty of 
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
// * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
// * along with this program; if not, write to the Free Software 
// * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
// * 
// * <OSCAR TEAM>
// * This software was written for the 
// * Department of Family Medicine 
// * McMaster Unviersity 
// * Hamilton 
// * Ontario, Canada 
// *
// -----------------------------------------------------------------------------------------------------------------------
--%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page
	import="org.oscarehr.casemgmt.web.formbeans.CaseManagementEntryFormBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ include file="/casemgmt/taglibs.jsp"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"
	scope="request" />
<% String noteIndex = "";
   String encSelect = "encTypeSelect";
   String demoNo = request.getParameter("demographicNo");
   String caseMgmtEntryFrm = "caseManagementEntryForm" + demoNo;
   CaseManagementEntryFormBean frm = (CaseManagementEntryFormBean)request.getAttribute("caseManagementEntryForm");
   System.out.println("Fetching form bean from request");
   if( frm == null ) {
        System.out.println("No form bean in request - Fetching from session");
        frm = (CaseManagementEntryFormBean)session.getAttribute(caseMgmtEntryFrm);
        request.setAttribute("caseManagementEntryForm", frm);
   }
   
        
%>
<nested:empty name="caseManagementEntryForm" property="caseNote.id">
	<nested:notEmpty name="newNoteIdx">
		<% noteIndex = request.getParameter("newNoteIdx"); %>
		<div id="sumary<nested:write name="newNoteIdx"/>">
		<div id="observation<nested:write name="newNoteIdx"/>"
			style="float: right; margin-right: 3px;">
	</nested:notEmpty>
	<nested:empty name="newNoteIdx">
		<% noteIndex = "0";%>
		<div id="sumary0">
		<div id="observation0" style="float: right; margin-right: 3px;">
	</nested:empty>
</nested:empty>
<nested:notEmpty name="caseManagementEntryForm" property="caseNote.id">
	<%        
       noteIndex = String.valueOf(frm.getCaseNote().getId());       
       
    %>
	<div style="background-color: #CCCCFF;"
		id="sumary<nested:write name="caseManagementEntryForm" property="caseNote.id" />">
	<div
		id="observation<nested:write name="caseManagementEntryForm" property="caseNote.id" />"
		style="float: right; margin-right: 3px;">
</nested:notEmpty>
<nested:notEmpty name="ajaxsave">
	<i><bean:message key="oscarEncounter.date.title"/>:&nbsp;<span
		id="obs<nested:write name="caseManagementEntryForm" property="caseNote.id" />">
	<nested:write name="caseManagementEntryForm"
		property="caseNote.observation_date" format="dd-MMM-yyyy H:mm" /> </span>&nbsp;
	<bean:message key="oscarEncounter.noteRev.title"/><a href="#"
		onclick="return showHistory('<nested:write name="caseManagementEntryForm" property="caseNote.id" />', event);"><nested:write
		name="caseManagementEntryForm" property="caseNote.revision" /></a></i>
</nested:notEmpty>
<nested:empty name="ajaxsave">
	<i><bean:message key="oscarEncounter.date.title"/>:</i>&nbsp;<img src="<c:out value="${ctx}/images/cal.gif" />"
		id="observationDate_cal" alt="calendar">&nbsp;<input type="text"
		id="observationDate" name="observation_date"
		ondblclick="this.value='';"
		style="font-style: italic; border: none; width: 140px;" readonly
		value="<nested:write name="caseManagementEntryForm" property="caseNote.observation_date" format="dd-MMM-yyyy H:mm" />">
                rev<a href="#"
		onclick="return showHistory('<nested:write name="caseManagementEntryForm" property="caseNote.id" />', event);"><nested:write
		name="caseManagementEntryForm" property="caseNote.revision" /></a>
</nested:empty>
</div>
<div><span style="float: left;"><bean:message key="oscarEncounter.editors.title"/>:</span> <nested:equal
	name="newNote" value="false">
	<ul style="list-style: none inside none; margin: 0px;">
		<nested:iterate indexId="eIdx" id="editor" property="caseNote.editors"
			name="caseManagementEntryForm">
                
			<c:if test="${eIdx % 2 == 0}">
				<li><nested:write property="formattedName" />;
			</c:if>
			<c:if test="${eIdx % 2 != 0}">
				<nested:write property="formattedName" />
				</li>
			</c:if>
		</nested:iterate>
		<c:if test="${eIdx % 2 == 0}">
			</li>
		</c:if>
	</ul>
</nested:equal> <nested:equal name="newNote" value="true">
	<div style="margin: 0px;">&nbsp;</div>
</nested:equal></div>
<% encSelect += noteIndex; %>
<div style="clear: right; margin-right: 3px; margin: 0px; float: right;"><bean:message key="oscarEncounter.encType.title"/>
:&nbsp;<span id="encType<%=noteIndex%>"> <nested:empty
	name="ajaxsave">
	<html:select styleId="<%=encSelect%>" styleClass="encTypeCombo"
		name="caseManagementEntryForm" property="caseNote.encounter_type">
		<html:option value=""></html:option>
		<html:option value="face to face encounter with client"><bean:message key="oscarEncounter.faceToFaceEnc.title"/></html:option>
		<html:option value="telephone encounter with client"><bean:message key="oscarEncounter.telephoneEnc.title"/></html:option>
		<html:option value="encounter without client"><bean:message key="oscarEncounter.noClientEnc.title"/></html:option>
	</html:select>
</nested:empty> <nested:notEmpty name="ajaxsave">
            &quot;<nested:write name="caseManagementEntryForm"
		property="caseNote.encounter_type" />&quot;
         </nested:notEmpty> </span></div>
<nested:size id="numIssues" name="caseManagementEntryForm"
	property="caseNote.issues" />
<%-- <nested:equal name="numIssues" value="0">
        <div>&nbsp;</div>
    </nested:equal> --%>
<nested:greaterThan name="numIssues" value="0">
	<div style="display: block;"><span style="float: left;"><bean:message key="oscarEncounter.assignedIssues.title"/>
	</span>
	<ul style="float: left; list-style: circle inside; margin: 0px;">
		<nested:iterate id="noteIssue" property="caseNote.issues"
			name="caseManagementEntryForm">
			<li><c:out value="${noteIssue.issue.description}" /></li>
		</nested:iterate>
	</ul>
	<br style="clear: both;">
	</div>
</nested:greaterThan>
<nested:equal name="numIssues" value="0">
	<div style="margin: 0px;"><br style="clear: both;">
	</div>
</nested:equal>
</div>

<div id="noteIssues"
	style="margin: 0px; background-color: #CCCCFF; font-size: 8px; display: none;">
<b><bean:message key="oscarEncounter.referenceIssues.title"/></b>
<table id="setIssueList" style="font-size: 8px;">
	<nested:iterate indexId="ind" id="issueCheckList" property="issueCheckList" name="caseManagementEntryForm" type="org.oscarehr.casemgmt.web.CheckBoxBean">
		<%
                                String winame = "window" + issueCheckList.getIssue().getIssue().getDescription();
                                winame = winame.replaceAll("\\s|\\/|\\*", "_");
                                winame = winame.replaceAll("'","");
                                winame = StringEscapeUtils.escapeJavaScript(winame);
                                if( ind % 2 == 0 ) {%>
		<tr>
			<% } %>
			<td style="width: 50%; font-size: 8px; background-color: #CCCCFF;">
			<%String submitString = "this.form.method.value='issueChange';";
                                submitString = submitString + "this.form.lineId.value=" + "'"
                                + ind.intValue() + "'; return ajaxUpdateIssues('issueChange', $('noteIssues').up().id);";
                                String id = "noteIssue" + ind;
                                org.oscarehr.casemgmt.web.CheckBoxBean cbb = (org.oscarehr.casemgmt.web.CheckBoxBean)pageContext.getAttribute("issueCheckList");
                                String programId = (String) request.getSession().getAttribute("case_program_id");
                                boolean writeAccess = cbb.getIssue().isWriteAccess(Integer.parseInt(programId));                                
                                boolean disabled = !writeAccess;
                                %> <nested:checkbox styleId="<%=id%>"
				indexed="true" name="issueCheckList" property="checked"
				disabled="<%=disabled%>"></nested:checkbox> <a href="#"
				onclick="return displayIssue('<%=winame%>');"><nested:write
				name="issueCheckList" property="issue.issue.description" /></a> <nested:equal
				name="issueCheckList" property="used" value="false">
				<%String submitDelete = "removeIssue('" + winame + "');document.forms['caseManagementEntryForm'].deleteId.value=" + "'"
                                    + ind.intValue() + "';return ajaxUpdateIssues('issueDelete', $('noteIssues').up().id);";
                                    %>
                                    &nbsp;<a href="#"
					onclick="<%=submitDelete%>">Delete</a>&nbsp;
                                </nested:equal> <!--  change diagnosis button --> <%String submitChange = "return changeDiagnosis('" + ind.intValue() + "');";
                                %> &nbsp;<a href="#"
				onclick="<%=submitChange%>">Change</a>
			<div id="<%=winame%>" style="margin-left: 20px; display: none;">

			<div>
			<div style="width: 50%; float: left; display: inline;"><nested:radio
				indexed="true" name="issueCheckList" property="issue.acute"
				value="true" onchange="<%=submitString%>">acute</nested:radio></div>
			<div style="width: 50%; float: left; display: inline; clear: right;"><nested:radio
				indexed="true" name="issueCheckList" property="issue.acute"
				value="false" onchange="<%=submitString%>">chronic</nested:radio></div>
			<div style="width: 50%; float: left; display: inline;"><nested:radio
				indexed="true" name="issueCheckList" property="issue.certain"
				disabled="<%=disabled%>" value="true" onchange="<%=submitString%>">certain</nested:radio></div>
			<div style="width: 50%; float: left; display: inline; clear: right;"><nested:radio
				indexed="true" name="issueCheckList" property="issue.certain"
				disabled="<%=disabled%>" value="false" onchange="<%=submitString%>">uncertain</nested:radio></div>
			<div style="width: 50%; float: left; display: inline;"><nested:radio
				indexed="true" name="issueCheckList" property="issue.major"
				disabled="<%=disabled%>" value="true" onchange="<%=submitString%>">major</nested:radio></div>
			<div style="width: 50%; float: left; display: inline; clear: right;"><nested:radio
				indexed="true" name="issueCheckList" property="issue.major"
				disabled="<%=disabled%>" value="false" onchange="<%=submitString%>">not major</nested:radio></div>
			<div style="width: 50%; float: left; display: inline;"><nested:radio
				indexed="true" name="issueCheckList" property="issue.resolved"
				value="true" onchange="<%=submitString%>">resolved</nested:radio></div>
			<div style="width: 50%; float: left; display: inline; clear: right;"><nested:radio
				indexed="true" name="issueCheckList" property="issue.resolved"
				value="false" onchange="<%=submitString%>">unresolved</nested:radio></div>
			<div style="text-align: center;"><nested:text indexed="true"
				name="issueCheckList" property="issue.type" size="10"
				disabled="<%=disabled%>" /></div>
			</div>
			</div>
			</td>
			<% if( ind % 2 != 0 ) { %>
		</tr>
		<% } %>

	</nested:iterate>
</table>
</div>
<div id='autosaveTime' class='sig' style='text-align:center; margin:0px;'></div>
<script type="text/javascript">   
    
    //check to see if we need to update div containers to most recent note id
   //this happens only when we're called thru ajaxsave  
   <nested:notEmpty name="ajaxsave">
        var origId = "<nested:write name="origNoteId" />";
        var newId = "<nested:write name="ajaxsave" />";  
        var oldDiv;
        var newDiv;
        var prequel = ["n","sig","signed","full","bgColour","print", "editWarn"];

        for( var idx = 0; idx < prequel.length; ++idx ) {
            oldDiv = prequel[idx] + origId;
            newDiv = prequel[idx] + newId;            
            if( $(oldDiv) != null )
                $(oldDiv).id = newDiv;        
        }  
       updatedNoteId = newId;
      
       <%
            //CaseManagementEntryFormBean form = (CaseManagementEntryFormBean)request.getAttribute("caseManagementEntryForm");            
            String noteTxt = frm.getCaseNote().getNote();
            noteTxt = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(noteTxt);
       %>
       completeChangeToView("<%=noteTxt%>",newId);
       if( origId.substr(0,1) == "0" ) {
            $("nc"+origId).id = "nc" + numNotes;
            ++numNotes;
       }
       
       <nested:notEmpty name="DateError">
            alert("<nested:write name="DateError"/>");
       </nested:notEmpty>
    </nested:notEmpty>
    
   var c = "bgColour" + "<%=noteIndex%>";          
   var txtStyles = $F(c).split(";");
   var txtColour = txtStyles[0].substr(txtStyles[0].indexOf("#"));
   var background = txtStyles[1].substr(txtStyles[1].indexOf("#"));
   var summary = "sumary" + "<%=noteIndex%>";
   
   if( $("observationDate") != null ) {
        $("observationDate").style.color = txtColour;
        $("observationDate").style.backgroundColor = background; 
   }
   $(summary).style.color = txtColour;
   $(summary).style.backgroundColor = background; 
   
   if( $("toggleIssue") != null )
        $("toggleIssue").disabled = false;
    
   if( showIssue ) {
        $("noteIssues").show();
        for( var idx = 0; idx < expandedIssues.length; ++idx )            
            displayIssue(expandedIssues[idx]);                   
   }           
   
   //do we have a custom encounter type?  if so add an option to the encounter type select
   var encounterType = '<nested:write name="caseManagementEntryForm" property="caseNote.encounter_type"/>';
   var selectEnc = "<%=encSelect%>";
   
   if( $(selectEnc) != null ) {        
        
        if( $F(selectEnc) == "" && encounterType != "" ) {
            var select = document.getElementById(selectEnc);
            var newOption =document.createElement('option');        
            newOption.text = encounterType;
            newOption.value = encounterType;

            try
            {
                select.add(newOption,null); // standards compliant            
            }
            catch(ex)
            {
                select.add(newOption); // IE only            
            }  

            select.selectedIndex = select.options.length - 1;
        }
        
        new Autocompleter.SelectBox(selectEnc);        
        
   }     
   
         
   //store observation date so we know if user changes it
   if( $("observationDate") != null ) {
        origObservationDate = $("observationDate").value;            
   
        //create calendar
        Calendar.setup({ inputField : "observationDate", ifFormat : "%d-%b-%Y %H:%M ", showsTime :true, button : "observationDate_cal", singleClick : true, step : 1 });    
   }
</script>
