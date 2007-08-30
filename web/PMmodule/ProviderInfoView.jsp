<%@ include file="/taglibs.jsp"%>
<script>
    function popupHelp(topic) {
        url = '<html:rewrite page="/common/help.jsp?topic="/>';
        window.open(url + topic,'help','width=450, height=200');
    }
</script>
Welcome <b><c:out value="${requestScope.provider.formattedName}" /></b>
<p>
    Your Program Domain <a href="javascript:void(0)" onclick="popupHelp('program_domain')">?</a> includes:
    <display:table class="simple" cellspacing="2" cellpadding="3" id="program" name="programDomain" export="false" requestURI="/PMmodule/ProviderInfo.do">
        <display:setProperty name="basic.msg.empty_list" value="No programs." />
        <display:column sortable="true" sortProperty="program.name" title="Program Name">
            <a href="<html:rewrite action="/PMmodule/ProgramManagerView"/>?id=<c:out value="${program.programId}"/>"><c:out value="${program.program.name}" /></a>
        </display:column>
        <display:column property="role.name" sortable="true" title="Role" />
        <display:column property="program.type" sortable="true" title="Program Type" />
        <display:column property="program.queueSize" sortable="true" title="Clients in Queue" />
    </display:table>
</p>