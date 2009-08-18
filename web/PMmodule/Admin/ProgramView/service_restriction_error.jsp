
<%@ include file="/taglibs.jsp"%>
<%@ taglib uri="/WEB-INF/caisi-tag.tld" prefix="caisi" %>
<%@page import="org.oscarehr.PMmodule.web.formbean.*"%>
<%@page import="org.oscarehr.PMmodule.web.utils.UserRoleUtils"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.oscarehr.PMmodule.service.ClientManager"%>
<%@page import="org.oscarehr.PMmodule.model.Demographic"%>
<%@page import="org.oscarehr.PMmodule.model.DemographicExt"%>


<html:form action="/PMmodule/ProgramManagerView">

    <%@ include file="/common/messages.jsp"%>

    <input type="hidden" name="method" value="override_restriction" />
    <html:hidden property="clientId" />
    <html:hidden property="queueId" />
    <input type="hidden" name="id" value="<c:out value="${requestScope.id}"/>" />

    <b style="color:red">The client currently has a service restriction in effect on the program you are trying to admit the client into.</b>

    <c:if test="${requestScope.hasOverridePermission}">
        <b>You have permission to override this restriction. To do so click on the "Override" below.  Otherwise, click on "Cancel".</b>
    </c:if>

    <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <th title="Restriction details">Service restriction details</th>
        </tr>
    </table>
    <table width="100%" border="1" cellspacing="2" cellpadding="3">
        <tr class="b">
            <td width="20%">Client name:</td>
            <td><bean:write name="programManagerViewForm" property="serviceRestriction.client.formattedName"/></td>
        </tr>
        <tr class="b">
            <td width="20%">Restricted program:</td>
            <td><bean:write name="programManagerViewForm" property="serviceRestriction.program.name"/></td>
        </tr>
        <tr class="b">
            <td width="20%">Service restriction creator:</td>
            <td><bean:write name="programManagerViewForm" property="serviceRestriction.provider.formattedName"/></td>
        </tr>
        <tr class="b">
            <td width="20%">Comments:</td>
            <td><bean:write name="programManagerViewForm" property="serviceRestriction.comments"/></td>
        </tr>

        <tr class="b">
            <td width="20%">Start date:</td>
            <td><bean:write name="programManagerViewForm" property="serviceRestriction.startDate"/></td>
        </tr>

        <tr class="b">
            <td width="20%">End date:</td>
            <td><bean:write name="programManagerViewForm" property="serviceRestriction.endDate"/></td>
        </tr>

        <tr class="b">
            <td width="20%">Days remaining:</td>
            <td><bean:write name="programManagerViewForm" property="serviceRestriction.daysRemaining"/></td>
        </tr>

        <tr>
            <td colspan="2">
                <c:if test="${requestScope.hasOverridePermission}">
                    <html:submit property="submit.override">Override</html:submit>
                </c:if>
                <html:cancel property="submit.cancel">Cancel</html:cancel>
            </td>
        </tr>

    </table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>