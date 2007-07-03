<%@ include file="/taglibs.jsp"%>
<%@ page import="org.oscarehr.PMmodule.model.Intake"%>
<%@ page import="org.oscarehr.PMmodule.web.formbean.GenericIntakeEditFormBean"%>
<%
    GenericIntakeEditFormBean intakeEditForm = (GenericIntakeEditFormBean) session.getAttribute("genericIntakeEditForm");
    Intake intake = intakeEditForm.getIntake();
%>
<html:html xhtml="true" locale="true">
<head>
    <title>Generic Intake Edit</title>
    <style type="text/css">
        @import "<html:rewrite page="/css/genericIntake.css" />";
    </style>
    <script type="text/javascript">
        <!--
        var djConfig = {
            isDebug: false,
            parseWidgets: false,
            searchIds: ["layoutContainer", "topPane", "clientPane", "bottomPane", "clientTable", "admissionsTable"]
        };
        // -->
    </script>
    <script type="text/javascript" src="<html:rewrite page="/dojoAjax/dojo.js" />"></script>
    <script type="text/javascript" src="<html:rewrite page="/js/AlphaTextBox.js" />"></script>
    <script type="text/javascript">
        <!--
        dojo.require("dojo.widget.*");
        dojo.require("dojo.validate.*");
        // -->
    </script>
    <script type="text/javascript" src="<html:rewrite page="/js/genericIntake.js" />"></script>
    <html:base />
</head>
<body class="edit">
<html:form action="/PMmodule/GenericIntake/Edit" onsubmit="return validateEdit()">
<html:hidden property="method" />
<div id="layoutContainer" dojoType="LayoutContainer" layoutChildPriority="top-bottom" class="intakeLayoutContainer">
<div id="topPane" dojoType="ContentPane" layoutAlign="top" class="intakeTopPane">
    <c:out value="${sessionScope.genericIntakeEditForm.title}" />
</div>
<div id="clientPane" dojoType="ContentPane" layoutAlign="client" class="intakeChildPane">

<div id="clientTable" dojoType="TitlePane" label="Client Information" title="(Fields marked with * are mandatory)" labelNodeClass="intakeSectionLabel" containerNodeClass="intakeSectionContainer">
    <table class="intakeTable">
        <tr>
            <td><label>First Name *<br><html:text property="client.firstName" /></label></td>
            <td><label>Last Name *<br><html:text property="client.lastName" /></label></td>
            <td>
                <label>Gender<br>
                    <html:select property="client.sex">
                        <html:optionsCollection property="genders" value="value" label="label" />
                    </html:select>
                </label>
            </td>
            <td>
                <table>
                    <tr>
                        <td>
                            <label>Birth Date<br>
                                <html:select property="client.monthOfBirth">
                                    <html:optionsCollection property="months" value="value" label="label" />
                                </html:select>
                            </label>
                        </td>
                        <td>
                            <label>&nbsp;<br>
                                <html:select property="client.dateOfBirth">
                                    <html:optionsCollection property="days" value="value" label="label" />
                                </html:select>
                            </label>
                        </td>
                        <td>
                            <label>&nbsp;<br>
                                <html:text property="client.yearOfBirth" size="4" />&nbsp;(YYYY)
                            </label>
                        </td>
                    </tr>
                </table>

            </td>
        </tr>
        <tr>
            <td><label>Health Card #<br>
                <input type="text" size="10" maxlength="10" dojoType="IntegerTextBox" name="client.hin" value="<bean:write name="genericIntakeEditForm"  property="client.hin"/>"/>
            </label></td>
            <td><label>Version<br>
                <input type="text" size="2" maxlength="2" dojoType="AlphaTextBox" name="client.ver" value="<bean:write name="genericIntakeEditForm"  property="client.ver"/>"/>
            </label></td>
        </tr>
        <tr>
            <td>
                <label>Email<br>
                    <input type="text" dojoType="EmailTextBox" name="client.email" value="<bean:write name="genericIntakeEditForm"  property="client.email"/>"/>
                </label></td>
            <td>
                <label>Phone #<br>
                    <input type="text" dojoType="UsPhoneNumberTextbox" name="client.phone" value="<bean:write name="genericIntakeEditForm"  property="client.phone"/>"/>
                </label></td>
            <td>
                <label>Secondary Phone #<br>
                    <input type="text" dojoType="UsPhoneNumberTextbox" name="client.phone2" value="<bean:write name="genericIntakeEditForm"  property="client.phone2"/>"/>
                </label>
            </td>
        </tr>
        <tr>
            <td><label>Street<br><html:text property="client.address" /></label></td>
            <td><label>City<br><html:text property="client.city" /></label></td>
            <td><label>Province<br>
                <html:select property="client.province">
                    <html:optionsCollection property="provinces" value="value" label="label" />
                </html:select>
            </label>
            </td>
            <!-- <td><label>Province<br><html:text property="client.province" /></label></td> -->
            <td><label>Postal Code<br><html:text property="client.postal" /></label></td>
        </tr>
        <c:if test="${not empty sessionScope.genericIntakeEditForm.client.demographicNo}">
            <tr>
                <td>
                    <a href="javascript:void(0);" onclick="window.open('<caisi:CaseManagementLink demographicNo="<%=intake.getClientId()%>" providerNo="<%=intake.getStaffId()%>" providerName="<%=intake.getStaffName()%>" />', '', 'width=800,height=600,resizable=1,scrollbars=1')" >
                        <span>Case Management Notes</span>
                    </a>
                </td>
            </tr>
        </c:if>
    </table>
</div>
<c:if test="${not empty sessionScope.genericIntakeEditForm.bedCommunityPrograms || not empty sessionScope.genericIntakeEditForm.servicePrograms}">
    <div id="admissionsTable" dojoType="TitlePane" label="Program Admissions" labelNodeClass="intakeSectionLabel" containerNodeClass="intakeSectionContainer">
        <table class="intakeTable">
            <tr>
                <c:if test="${not empty sessionScope.genericIntakeEditForm.bedCommunityPrograms}">
                    <td class="intakeBedCommunityProgramCell"><label><c:out value="${sessionScope.genericIntakeEditForm.bedCommunityProgramLabel}" /></label></td>
                </c:if>
                <c:if test="${not empty sessionScope.genericIntakeEditForm.servicePrograms}">
                    <td><label>Service Programs</label></td>
                </c:if>
            </tr>
            <tr>
                <c:if test="${not empty sessionScope.genericIntakeEditForm.bedCommunityPrograms}">
                    <td class="intakeBedCommunityProgramCell">
                        <html:select property="bedCommunityProgramId">
                            <html:optionsCollection property="bedCommunityPrograms" value="value" label="label" />
                        </html:select>
                    </td>
                </c:if>
                <c:if test="${not empty sessionScope.genericIntakeEditForm.servicePrograms}">
                    <td>
                        <c:forEach var="serviceProgram" items="${sessionScope.genericIntakeEditForm.servicePrograms}">
                            <html-el:multibox property="serviceProgramIds" value="${serviceProgram.value}" />&nbsp;<c:out value="${serviceProgram.label}" /><br />
                        </c:forEach>
                    </td>
                </c:if>
            </tr>
        </table>
    </div>
</c:if>
<br />
<caisi:intake base="<%=5%>" intake="<%=intake%>" />
</div>
<div id="bottomPane" dojoType="ContentPane" layoutAlign="bottom" class="intakeBottomPane">
    <table class="intakeTable">
        <logic:messagesPresent>
            <html:messages id="error" bundle="pmm">
                <tr>
                    <td class="error"><c:out value="${error}" /></td>
                </tr>
            </html:messages>
        </logic:messagesPresent>
        <logic:messagesPresent message="true">
            <html:messages id="message" message="true" bundle="pmm">
                <tr>
                    <td class="message"><c:out value="${message}" /></td>
                </tr>
            </html:messages>
        </logic:messagesPresent>
        <tr>
            <td>
                <html:submit onclick="save()">Save</html:submit>&nbsp;
                <html:reset>Reset</html:reset>
            </td>
            <td align="right">
                <c:choose>
                    <c:when test="${not empty sessionScope.genericIntakeEditForm.client.demographicNo}">
                        <html:submit onclick="clientEdit()">Close</html:submit>
                    </c:when>
                    <c:otherwise>
                        <input type="button" value="Close" onclick="history.go(-1)" />
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
</div>
</div>
</html:form>
</body>
</html:html>