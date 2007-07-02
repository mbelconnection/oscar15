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
<%@ include file="/taglibs.jsp" %>
<html:html locale="true">
    <head>
        <title>Referral Details</title>

        <style type="text/css">
            @import "<html:rewrite page="/css/tigris.css" />";
            @import "<html:rewrite page="/css/displaytag.css" />";
            @import "<html:rewrite page="/jsCalendar/skins/aqua/theme.css" />";
        </style>

    <body>
    <html:form action="/PMmodule/ClientManager.do">

        <html:hidden property="referral.id"/>

        <table width="100%" border="1" cellspacing="2" cellpadding="3">
            <tr class="b">
                <td width="20%">Client name:</td>
                <td><bean:write name="clientManagerForm" property="client.formattedName"/></td>
            </tr>
            <tr class="b">
                <td width="20%">Provider name:</td>
                <td><bean:write name="clientManagerForm" property="provider.formattedName"/></td>
            </tr>
            <tr class="b">
                <td width="20%">Program name:</td>
                <td><bean:write name="clientManagerForm" property="referral.programName"/></td>
            </tr>
          
            <tr class="b">
                <td width="20%">Agency:</td>
                <td><c:out value="${agency.name}" /></td>              
            </tr> 
            
            <tr class="b">
                <td width="20%">Provider:</td>
                <td><bean:write name="clientManagerForm" property="referral.providerFormattedName"/></td>
            </tr>

            <tr class="b">
                <td width="20%">Completion date:</td>
                <td><bean:write name="clientManagerForm" property="referral.completionDate"/></td>
            </tr>
            <tr class="b">
                <td width="20%">Completion status:</td>
                <td><bean:write name="clientManagerForm" property="referral.status"/></td>
            </tr>
            <tr class="b">
                <td width="20%">Completion notes:</td>
                <td><bean:write name="clientManagerForm" property="referral.completionNotes"/></td>
            </tr>

            <tr class="b">
                <td width="20%">Referral date:</td>
                <td><bean:write name="clientManagerForm" property="referral.referralDate"/></td>
            </tr>

            <tr class="b">
                <td width="20%">Temporary admission:</td>
                <td><bean:write name="clientManagerForm" property="referral.temporaryAdmission"/></td>
            </tr>

            <tr class="b">
                <td width="20%">Present problems:</td>
                <td><bean:write name="clientManagerForm" property="referral.presentProblems"/></td>
            </tr>

            <tr class="b">
                <td width="20%">Rejection reason:</td>
                <td><bean:write name="clientManagerForm" property="referral.radioRejectionReason"/></td>
            </tr>

        </table>

        <!--
        public static String PROP_STATUS = "Status";
        public static String PROP_PROGRAM_NAME = "ProgramName";
        public static String PROP_AGENCY_ID = "AgencyId";
        public static String PROP_NOTES = "Notes";
        public static String PROP_PROGRAM_ID = "ProgramId";
        public static String PROP_PROGRAM_TYPE = "programType";
        public static String PROP_COMPLETION_NOTES = "CompletionNotes";
        public static String PROP_PROVIDER_LAST_NAME = "ProviderLastName";
        public static String PROP_CLIENT_ID = "ClientId";
        public static String PROP_PROVIDER_NO = "ProviderNo";
        public static String PROP_SOURCE_AGENCY_ID = "SourceAgencyId";
        public static String PROP_PROVIDER_FIRST_NAME = "ProviderFirstName";
        public static String PROP_COMPLETION_DATE = "CompletionDate";
        public static String PROP_ID = "Id";
        public static String PROP_REFERRAL_DATE = "ReferralDate";
        public static String PROP_TEMPORARY_ADMISSION = "TemporaryAdmission";
        -->


    </html:form>
    </body>
</html:html>
