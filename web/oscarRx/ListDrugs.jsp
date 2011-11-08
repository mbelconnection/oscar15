<%--

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
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */

--%><%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page language="java"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/oscar-tag.tld" prefix="oscar" %>
<%@ taglib uri="/WEB-INF/security.tld" prefix="security" %>
<%@ taglib uri="/WEB-INF/indivo-tag.tld" prefix="indivo" %>
<%@ page import="oscar.oscarRx.data.*,oscar.oscarProvider.data.ProviderMyOscarIdData,oscar.oscarDemographic.data.DemographicData,oscar.OscarProperties,oscar.log.*"%>
<%@ page import="org.oscarehr.common.model.OscarAnnotation" %>
<%@page import="org.oscarehr.casemgmt.service.CaseManagementManager,org.springframework.web.context.WebApplicationContext,
		org.springframework.web.context.support.WebApplicationContextUtils,org.oscarehr.casemgmt.model.CaseManagementNoteLink,org.oscarehr.casemgmt.model.CaseManagementNote"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Calendar" %>
<%@page import="java.util.Enumeration"%>
<%@page import="org.oscarehr.util.SpringUtils"%>
<%@page import="org.oscarehr.util.SessionConstants"%>
<%@page import="java.util.List"%>
<%@page import="org.oscarehr.PMmodule.caisi_integrator.CaisiIntegratorManager"%>
<%@page import="org.oscarehr.util.LoggedInInfo"%>
<%@page import="java.util.ArrayList,oscar.util.*,java.util.*,org.oscarehr.common.model.Drug,org.oscarehr.common.dao.*"%>
<bean:define id="patient" type="oscar.oscarRx.data.RxPatientData.Patient" name="Patient" />
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
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%
		String roleName$ = (String)session.getAttribute("userrole") + "," + (String)session.getAttribute("user");
		com.quatro.service.security.SecurityManager securityManager = new com.quatro.service.security.SecurityManager();
        oscar.oscarRx.pageUtil.RxSessionBean bean = (oscar.oscarRx.pageUtil.RxSessionBean) pageContext.findAttribute("bean");
        boolean showall = false;
        if (request.getParameter("show") != null) {
            if (request.getParameter("show").equals("all")) {
                showall = true;
            }
        }       

        boolean integratorEnabled = LoggedInInfo.loggedInInfo.get().currentFacility.isIntegratorEnabled();
        String annotation_display = org.oscarehr.casemgmt.model.CaseManagementNoteLink.DISP_PRESCRIP;
        String heading = request.getParameter("heading");
if (heading != null){
%>
<h4 style="margin-bottom:1px;margin-top:3px;"><%=heading%></h4>
<%}%>
<div class="drugProfileText" style="">
    <table width="100%" cellpadding="3" border="0" class="sortable" id="Drug_table<%=heading%>">
        <tr>
        	<th align="left"><b>Entered Date</b></th>
            <th align="left"><b><bean:message key="SearchDrug.msgRxDate"/></b></th>
            <th align="left"><b>Days to Exp</b></th>
            <th align="left"><b>LT Med</b></th>
            <th align="left"><b><bean:message key="SearchDrug.msgPrescription"/></b></th>
            <%if(securityManager.hasWriteAccess("_rx",roleName$,true)) {%>
            	<th align="center" width="35px"><b><bean:message key="SearchDrug.msgReprescribe"/></b></th>            
            	<!--<th align="center" width="35px"><b><bean:message key="SearchDrug.msgDelete"/></b></th>-->
            	<th align="center" width="35px"><b>Discontinue</b></th>
            <%} %>
            <th align="center" width="35px"><b><bean:message key="SearchDrug.msgPastMed"/></b></th>
            <%if(securityManager.hasWriteAccess("_rx",roleName$,true)) {%>
            	<th align="center" width="15px">&nbsp;</th>
            <% } %>
            <th align="center"><bean:message key="SearchDrug.msgLocationPrescribed"/></th>
        </tr>

        <%
            CaseManagementManager caseManagementManager = (CaseManagementManager) SpringUtils.getBean("caseManagementManager");
            List<Drug> prescriptDrugs = caseManagementManager.getPrescriptions(patient.getDemographicNo(), showall);
            if(showall) {
            	Collections.sort(prescriptDrugs,new oscar.oscarRx.util.ShowAllSorter());
            }
            //DrugDao drugDao = (DrugDao) SpringUtils.getBean("drugDao");
            //List<Drug> prescriptDrugs = drugDao.getPrescriptions(""+patient.getDemographicNo(), showall);
            List<String> reRxDrugList=bean.getReRxDrugIdList();


            long now = System.currentTimeMillis();
            long month = 1000L * 60L * 60L * 24L * 30L;
            
            for (Drug prescriptDrug : prescriptDrugs) {
                boolean isPrevAnnotation=false;
                String styleColor = "";
                //test for previous note
                HttpSession se = request.getSession();
                Integer tableName = caseManagementManager.getTableNameByDisplay(annotation_display);
                CaseManagementNoteLink cml = caseManagementManager.getLatestLinkByTableId(tableName, Long.parseLong(prescriptDrug.getId().toString()));
                CaseManagementNote p_cmn = null;
                if (cml!=null) {p_cmn = caseManagementManager.getNote(cml.getNoteId().toString());}
                if (p_cmn!=null){isPrevAnnotation=true;}
              //  System.out.println("in list drugs.jsp: "+Long.parseLong(prescriptDrug.getId().toString())+"--"+tableName+"--"+p_cmn+"--"+cml);

                if (request.getParameter("status") != null) { //TODO: Redo this in a better way
                    String stat = request.getParameter("status");
                    if (stat != null && stat.equals("active") && prescriptDrug.isExpired()) {
                        continue;
                    } else if (stat != null && stat.equals("inactive") && !prescriptDrug.isExpired()) {
                        continue;
                    }
                }
                if (request.getParameter("longTermOnly") != null && request.getParameter("longTermOnly").equals("true")){
                    if (!prescriptDrug.isLongTerm()){
                      continue;
                    }
                }

                if (request.getParameter("longTermOnly") != null && request.getParameter("longTermOnly").equals("acute")){
                    if (prescriptDrug.isLongTerm()){
                      continue;
                    }
                }
                if(request.getParameter("drugLocation")!=null&&request.getParameter("drugLocation").equals("external")){
                    if(!prescriptDrug.isExternal())
                        continue;
                }
                //add all long term med drugIds to an array.
                styleColor = getClassColour( prescriptDrug, now, month);
                String specialText=prescriptDrug.getSpecial();
                specialText=specialText.replace("\n"," ");
                Integer prescriptIdInt=prescriptDrug.getId();
                String bn=prescriptDrug.getBrandName();
                
                boolean startDateUnknown = prescriptDrug.getStartDateUnknown();
        %>
        <tr>
        	<td valign="top"><a id="createDate_<%=prescriptIdInt%>"   <%=styleColor%> href="StaticScript2.jsp?regionalIdentifier=<%=prescriptDrug.getRegionalIdentifier()%>&amp;cn=<%=response.encodeURL(prescriptDrug.getCustomName())%>&amp;bn=<%=response.encodeURL(bn)%>"><%=oscar.util.UtilDateUtilities.DateToString(prescriptDrug.getCreateDate())%></a></td>
            <td valign="top">
            	<% if(startDateUnknown) { %>
            		
            	<% } else { %>
            		<a id="rxDate_<%=prescriptIdInt%>"   <%=styleColor%> href="StaticScript2.jsp?regionalIdentifier=<%=prescriptDrug.getRegionalIdentifier()%>&amp;cn=<%=response.encodeURL(prescriptDrug.getCustomName())%>&amp;bn=<%=response.encodeURL(bn)%>"><%=oscar.util.UtilDateUtilities.DateToString(prescriptDrug.getRxDate())%></a>
            	<% } %>
            </td>
            <td valign="top">
            	<% if(startDateUnknown) { %>
            		
            	<% } else { %>
            		<%=prescriptDrug.daysToExpire()%>
            	<% } %>
            </td>
            <td valign="top">
            	<%if(prescriptDrug.isLongTerm()){%>*
            	<%}else{%>
            		<%            			
            			if(securityManager.hasWriteAccess("_rx",roleName$,true)) {            		
            		%>
            			<a id="notLongTermDrug_<%=prescriptIdInt%>" title="<bean:message key='oscarRx.Prescription.changeDrugLongTerm'/>" onclick="changeLt('<%=prescriptIdInt%>');" href="javascript:void(0);">L</a>
            		<% } else { %>
            			<span style="color:blue">L</span>
            		<% } %>
           		<%}%>
            </td>
            
            <td valign="top"><a id="prescrip_<%=prescriptIdInt%>" <%=styleColor%> href="StaticScript2.jsp?regionalIdentifier=<%=prescriptDrug.getRegionalIdentifier()%>&amp;cn=<%=response.encodeURL(prescriptDrug.getCustomName())%>&amp;bn=<%=response.encodeURL(bn)%>"><%=RxPrescriptionData.getFullOutLine(prescriptDrug.getSpecial()).replaceAll(";", " ")%></a></td>
            <%            			
            	if(securityManager.hasWriteAccess("_rx",roleName$,true)) {            		
           	%>
            <td width="20px" align="center" valign="top">
            
                <%if (prescriptDrug.getRemoteFacilityName() == null) {%>
                <input id="reRxCheckBox_<%=prescriptIdInt%>" type=CHECKBOX onclick="updateReRxDrugId(this.id)" <%if(reRxDrugList.contains(prescriptIdInt.toString())){%>checked<%}%> name="checkBox_<%=prescriptIdInt%>">
                <a name="rePrescribe" style="vertical-align:top" id="reRx_<%=prescriptIdInt%>" <%=styleColor%> href="javascript:void(0)" onclick="represcribe(this)">ReRx</a>
                <%} else {%> 
                <form action="<%=request.getContextPath()%>/oscarRx/searchDrug.do" method="post">
                    <input type="hidden" name="demographicNo" value="<%=patient.getDemographicNo()%>" />
                    <input type="hidden" name="searchString" value="<%=getName(prescriptDrug)%>" />
                    <input type="submit" class="ControlPushButton" value="Search to Re-prescribe" />
                </form>
                <%}%>
            </td>            
            <!-- 
            <td width="20px" align="center" valign="top">
                <%if (prescriptDrug.getRemoteFacilityName() == null) {%>
                   <a id="del_<%=prescriptIdInt%>" name="delete" <%=styleColor%> href="javascript:void(0);" onclick="Delete2(this);">Del</a>
                <%}%>
            </td>
            -->
            <td width="20px" align="center" valign="top">
                <%if(!prescriptDrug.isDiscontinued()){%>
                <a id="discont_<%=prescriptIdInt%>" href="javascript:void(0);" onclick="Discontinue(event,this);" <%=styleColor%> >Discon</a>
                <%}else{%>
                  <%=prescriptDrug.getArchivedReason()%>
                <%}%>
            </td>
            <% } %>
                      
            <td align="center" valign="top"><%=(prescriptDrug.getPastMed())?"yes":"no" %></td>

			<%if(securityManager.hasWriteAccess("_rx",roleName$,true)) {%>
            <td width="10px" align="center" valign="top">
                <a href="javascript:void(0);" title="Annotation" onclick="window.open('../annotation/annotation.jsp?display=<%=annotation_display%>&amp;table_id=<%=prescriptIdInt%>&amp;demo=<%=bean.getDemographicNo()%>&amp;drugSpecial=<%=specialText%>','anwin','width=400,height=250');">
                    <%if(!isPrevAnnotation){%> <img src="../images/notes.gif" alt="rxAnnotation" height="16" width="13" border="0"><%} else{%><img src="../images/filledNotes.gif" height="16" width="13" alt="rxFilledNotes" border="0"> <%}%></a>
            </td>
            <% } %>
            
            <td width="10px" align="center" valign="top">
                <%
                if (prescriptDrug.getRemoteFacilityName() != null){ %>
                    <%=prescriptDrug.getRemoteFacilityName()%>
                <%}else if(  prescriptDrug.getOutsideProviderName() !=null && !prescriptDrug.getOutsideProviderName().equals("")  ){%>
                    <%=prescriptDrug.getOutsideProviderName()%>
                <%}else{%>
                    local
                <%}%>


            </td>
            
        </tr>
        <%}%>
    </table>

</div>
        <br>
<script type="text/javascript">
sortables_init();
</script>
<%!

String getName(Drug prescriptDrug){
    String searchString = prescriptDrug.getBrandName();
    if (searchString == null) {
        searchString = prescriptDrug.getCustomName();
    }
    if (searchString == null) {
        searchString = prescriptDrug.getRegionalIdentifier();
    }
    if (searchString == null) {
        searchString = prescriptDrug.getSpecial();
    }
    return searchString;
}

    String getClassColour(Drug drug, long referenceTime, long durationToSoon){
        StringBuffer sb = new StringBuffer("class=\"");

        if (!drug.isExpired() && drug.getEndDate()!=null && (drug.getEndDate().getTime() - referenceTime <= durationToSoon)) {  // ref = now and duration will be a month
            sb.append("expireInReference ");
        }
        
        if (!drug.isExpired() && !drug.isArchived()) {
            sb.append("currentDrug ");
        }

        if (drug.isArchived()) {
            sb.append("archivedDrug ");
        }

        if(drug.isExpired()) {
            sb.append("expiredDrug ");
        }

        if(drug.isLongTerm()){
            sb.append("longTermMed ");
        }

        if(drug.isDiscontinued()){
            sb.append("discontinued ");
        }

        if(drug.isDeleted()){
                sb.append("deleted ");

        }
        String retval = sb.toString();

        if(retval.equals("class=\"")){
            return "";
        }



        

        return retval.substring(0,retval.length())+"\"";

    }

%>
