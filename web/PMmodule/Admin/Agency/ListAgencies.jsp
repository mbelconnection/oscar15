<%@ include file="/taglibs.jsp"%>

<script>
    function ConfirmDelete(name)
    {
        if(confirm("Are you sure you want to delete " + name + " ?")) {
            return true;
        }
        return false;
    }
</script>
<%@ include file="/common/messages.jsp"%>
<div class="tabs" id="tabs">
    <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <th title="Agencies">Agencies</th>
        </tr>
    </table>
</div>
<html:form action="/PMmodule/MultiAgencyManager.do">

    <display:table class="simple" cellspacing="2" cellpadding="3" id="agency" name="agencies" export="false" pagesize="0" requestURI="/PMmodule/MultiAgencyManager.do">
        <display:setProperty name="paging.banner.placement" value="bottom" />
        <display:setProperty name="paging.banner.item_name" value="agency" />
        <display:setProperty name="paging.banner.items_name" value="agencies" />
        <display:setProperty name="basic.msg.empty_list" value="No agencies found." />

        <display:column sortable="false" title="">
            <a onclick="return ConfirmDelete('<c:out value="${agency.name}"/>')" href="<html:rewrite action="/PMmodule/MultiAgencyManager.do"/>?method=delete&id=<c:out value="${agency.id}"/>&name=<c:out value="${program.name}"/>"> Delete </a>
        </display:column>
        <display:column sortable="false" title="">
            <a href="<html:rewrite action="/PMmodule/MultiAgencyManager.do"/>?method=edit&id=<c:out value="${agency.id}" />"> Edit </a>
        </display:column>
        <display:column property="name" sortable="true" title="Name"/>
        <display:column property="description" sortable="true" title="Description" />
        <display:column property="contactName" sortable="true" title="Contact name" />
        <display:column property="contactPhone" sortable="true" title="Contact phone" />
        <display:column property="contactEmail" sortable="true" title="Contact email" />
        <display:column property="hic" sortable="true" title="Is HIC?" />
        <display:column sortable="false" title="">
            <a href="<html:rewrite action="/PMmodule/MultiAgencyManager.do"/>?method=displayPrograms&id=<c:out value="${agency.id}" />"> Show/Assign Bed Programs </a>
        </display:column>
    </display:table>
</html:form>
