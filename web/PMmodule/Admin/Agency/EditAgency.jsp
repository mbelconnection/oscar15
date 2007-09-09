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
            <th title="Agency">Modify or create agency</th>
        </tr>
    </table>
</div>
<html:form action="/PMmodule/MultiAgencyManager.do">
	<input type="hidden" name="method" value="save" />
    <table width="100%" border="1" cellspacing="2" cellpadding="3">
        <tr class="b">
            <td width="20%">Agency Id:</td>
            <td><c:out value="${requestScope.id}" /></td>
        </tr>
        <tr class="b">
            <td width="20%">Name:</td>
            <td><html:text property="agency.name" size="50" maxlength="50"/></td>
        </tr>
        <tr class="b">
            <td width="20%">Description:</td>
            <td><html:text property="agency.description" size="50" maxlength="255"/></td>
        </tr>
        <tr class="b">
            <td width="20%">HIC:</td>
            <td><html:checkbox property="agency.hic" /></td>
        </tr>
        <tr class="b">
            <td width="20%">Primary Contact Name:</td>
            <td><html:text property="agency.contactName" size="50" maxlength="255"/></td>
        </tr>
        <tr class="b">
            <td width="20%">Primary Contact Email:</td>
            <td><html:text property="agency.contactEmail" size="50" maxlength="255"/></td>
        </tr>
        <tr class="b">
            <td width="20%">Primary Contact Phone:</td>
            <td><html:text property="agency.contactPhone" size="50" maxlength="255"/></td>
        </tr>
        <tr>
            <td colspan="2">
                <html:submit property="submit.save">Save</html:submit>
                <html:cancel property="submit.cancel">Cancel</html:cancel>
            </td>
        </tr>
    </table>
</html:form>
