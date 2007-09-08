<!--
/*
*
* Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
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
* This software was written for
* Centre for Research on Inner City Health, St. Michael's Hospital,
* Toronto, Ontario, Canada
*/
 -->
<%@ page import="org.oscarehr.PMmodule.model.Demographic" %>
<%@ page import="org.oscarehr.casemgmt.web.formbeans.ClientListFormBean" %>
<%@ page import="java.net.URLEncoder" %>
<!--
Case management view;

Show admitted clients based on program and status
Allow selection of admission date using calendar widget
Archive view shows dismissed clients
-->
<%@ include file="/common/messages.jsp"%>

<%
    ClientListFormBean form = (ClientListFormBean) request.getAttribute("caseManagementClientListForm");
%>

<script type="text/javascript">
    function SubmitIfChanged(widget) {
        if (widget.getValue() != "<%=form.getAdmissionDate()%>")
            document.forms[0].submit();
    }
    function incrementDate(widget) {
        widget.setDate(dojo.date.add(widget.getDate(), dojo.date.dateParts.DAY, 1))
    }
    function decrementDate(widget) {
        widget.setDate(dojo.date.add(widget.getDate(), dojo.date.dateParts.DAY, -1))
    }

</script>
<div class="tabs" id="tabs">
    <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <th style="background-color: #555; color: #fff;"title="Admitted">Admitted</th>
            <th title="Discharged"><html:link action="/CaseManagementClientList?method=archive">Discharged (archive)</html:link></th>
        </tr>
    </table>
</div>
<html:form action="/CaseManagementClientList">

    <label>Show clients admitted to:</label>&nbsp;
    <html-el:select property="programId" onchange="this.form.submit()">
        <c:forEach var="pp" items="${programProviders}">
            <html-el:option value="${pp.programId}"><c:out value="${pp.programName}"/></html-el:option>
        </c:forEach>
    </html-el:select>

    <label>with client status:</label>&nbsp;
    <html-el:select property="programClientStatusId" onchange="this.form.submit()">
        <option value=""></option>
        <c:forEach var="pc" items="${programClientStatuses}">
            <html-el:option value="${pc.id}"><c:out value="${pc.name}"/></html-el:option>
        </c:forEach>
    </html-el:select>

    <br/>

    <label for="popupDatePicker">On:</label>&nbsp;
    <img src="../images/previous.gif" onclick="decrementDate(dojo.widget.byId('popupDatePicker'))"/>
    <input name="admissionDate" id="popupDatePicker" value="<%=form.getAdmissionDate()%>" endDate="<%=form.getEndDate()%>" dojoType="DropdownDatePicker" onValueChanged="SubmitIfChanged(this)" readonly="true" />
    <img src="../images/next.gif" onclick="incrementDate(dojo.widget.byId('popupDatePicker'))"/>

    <p/>

    <display:table class="simple" cellspacing="2" cellpadding="3" id="client" name="clients" export="false" pagesize="0" requestURI="/ClientList.do">

        <display:setProperty name="paging.banner.placement" value="bottom" />
        <display:setProperty name="paging.banner.item_name" value="client" />
        <display:setProperty name="paging.banner.items_name" value="clients" />
        <display:setProperty name="basic.msg.empty_list" value="No clients found." />


        <display:column sortable="true" title="First name">
            <c:out value="${client.firstName}"/>
        </display:column>
        <display:column sortable="true" title="Last name">
            <c:out value="${client.lastName}"/>
        </display:column>
        <display:column sortable="false" title="">
            <%
                Integer demographic_no = ((Demographic) pageContext.getAttribute("client")).getDemographicNo();
                String eURL = "../oscarEncounter/IncomingEncounter.do?demographicNo=" + demographic_no;
            %>
            <table border="0">
                <tr>
                    <td>
                        <div dojoType="Button" id="programClientManagerButton" onClick="document.location='../PMmodule/ClientManager.do?id=<%=demographic_no%>'">Program Management</div>
                    </td>
                    <td>
                        <div dojoType="Button" id="caseManagementButton" onClick="popup('caseManagementEncounter', '../oscarSurveillance/CheckSurveillance.do?demographicNo=<%=demographic_no%>&proceed=<%=URLEncoder.encode(eURL)%>')">Case Management Encounter</div>
                    </td>
                    <td>
                        <div dojoType="Button" id="masterFileButton" onClick="popup('patientDetail', '../demographic/demographiccontrol.jsp?demographic_no=<c:out value="${client.demographicNo}"/>&displaymode=edit&dboperation=search_detail')"/>Master File</div>
                    </td>
                </tr>
            </table>


        </display:column>
    </display:table>
</html:form>
