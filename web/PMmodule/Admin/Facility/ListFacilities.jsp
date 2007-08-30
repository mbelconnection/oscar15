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
            <th title="Facilities">Facilities management for agency "<c:out value="${agency.name}"/>"</th>
        </tr>
    </table>
</div>
<html:form action="/PMmodule/FacilityManager.do">
    <html:hidden property="agencyId"/>
    <display:table class="simple" cellspacing="2" cellpadding="3" id="facility" name="facilities" export="false" pagesize="0" requestURI="/PMmodule/FacilityManager.do">
        <display:setProperty name="paging.banner.placement" value="bottom" />
        <display:setProperty name="paging.banner.item_name" value="agency" />
        <display:setProperty name="paging.banner.items_name" value="facilities" />
        <display:setProperty name="basic.msg.empty_list" value="No facilities found." />

        <display:column sortable="false" title="">
            <a onclick="return ConfirmDelete('<c:out value="${facility.name}"/>')" href="<html:rewrite action="/PMmodule/FacilityManager.do"/>?method=delete&id=<c:out value="${facility.id}"/>&name=<c:out value="${facility.name}"/>"> Delete </a>
        </display:column>
        <display:column sortable="false" title="">
            <a href="<html:rewrite action="/PMmodule/FacilityManager.do"/>?method=edit&id=<c:out value="${facility.id}" />&agencyId=<c:out value="${agencyId}" />"> Edit </a>
        </display:column>
        <display:column property="name" sortable="true" title="Name"/>
        <display:column property="description" sortable="true" title="Description" />
        <display:column sortable="false" title="">
            <a href="<html:rewrite action="/PMmodule/BedManager.do"/>?method=manage&facilityId=<c:out value="${facility.id}" />" />Manage Beds </a>
        </display:column>
    </display:table>
</html:form>
<div>
    <p><a href="<html:rewrite action="/PMmodule/FacilityManager.do"/>?method=add&agencyId=<c:out value="${agencyId}" />"> Add new facility </a></p>
    <p><html:link action="/PMmodule/MultiAgencyManager.do">Return to agency list</html:link></p>
</div>
