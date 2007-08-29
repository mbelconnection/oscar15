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
            <th title="Agencies">Managed beds and rooms</th>
        </tr>
    </table>
</div>

<html:form action="/PMmodule/BedManager.do">

<table width="100%" summary="Create and edit rooms, and beds">
<tr>
    <td width="80%">
        <div class="tabs">
            <table cellpadding="3" cellspacing="0" border="0">
                <tr>
                    <th>Rooms</th>
                </tr>
            </table>
        </div>
        <display:table class="simple" name="sessionScope.bedManagerForm.rooms" uid="room" requestURI="/PMmodule/BedManager.do" summary="Edit rooms">
            <display:column title="Name" sortable="true">
                <input type="text" name="rooms[<c:out value="${room_rowNum - 1}" />].name" value="<c:out value="${room.name}" />" />
            </display:column>
            <display:column title="Floor" sortable="true">
                <input type="text" name="rooms[<c:out value="${room_rowNum - 1}" />].floor" value="<c:out value="${room.floor}" />" />
            </display:column>
            <display:column title="Type">
                <select name="rooms[<c:out value="${room_rowNum - 1}" />].roomTypeId">
                    <c:forEach var="roomType" items="${bedManagerForm.roomTypes}">
                        <c:choose>
                            <c:when test="${roomType.id == room.roomTypeId}">
                                <option value="<c:out value="${roomType.id}"/>" selected="selected">
                                    <c:out value="${roomType.name}" />
                                </option>
                            </c:when>
                            <c:otherwise>
                                <option value="<c:out value="${roomType.id}"/>">
                                    <c:out value="${roomType.name}" />
                                </option>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </select>
            </display:column>
            <display:column title="Program">
                <select name="rooms[<c:out value="${room_rowNum - 1}" />].programId">
                    <c:forEach var="program" items="${bedManagerForm.programs}">
                        <c:choose>
                            <c:when test="${program.id == room.programId}">
                                <option value="<c:out value="${program.id}"/>" selected="selected">
                                    <c:out value="${program.name}" />
                                </option>
                            </c:when>
                            <c:otherwise>
                                <option value="<c:out value="${program.id}"/>">
                                    <c:out value="${program.name}" />
                                </option>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </select>
            </display:column>
            <display:column title="Active" sortable="true">
                <c:choose>
                    <c:when test="${room.active}">
                        <input type="checkbox" name="rooms[<c:out value="${room_rowNum - 1}" />].active" checked="checked" />
                    </c:when>
                    <c:otherwise>
                        <input type="checkbox" name="rooms[<c:out value="${room_rowNum - 1}" />].active" />
                    </c:otherwise>
                </c:choose>
            </display:column>
        </display:table>
    </td>
    <td width="20%">
        <br />
        <html:submit onclick="bedManagerForm.method.value='saveRooms';">Save Rooms</html:submit>
    </td>
</tr>
<tr>
    <td>
        <html:text property="numRooms" />
        <html:submit onclick="bedManagerForm.method.value='addRooms';">Add Rooms</html:submit>
    </td>
</tr>
<tr>
    <td>
        <br />
    </td>
</tr>
<tr>
    <td width="80%">
        <div class="tabs">
            <table cellpadding="3" cellspacing="0" border="0">
                <tr>
                    <th>Beds</th>
                </tr>
            </table>
        </div>
        <display:table class="simple" name="sessionScope.bedManagerForm.beds" uid="bed" requestURI="/PMmodule/BedManager.do" summary="Edit beds">
            <display:column title="Name" sortable="true">
                <input type="text" name="beds[<c:out value="${bed_rowNum - 1}" />].name" value="<c:out value="${bed.name}" />" />
            </display:column>
            <display:column title="Type">
                <select name="beds[<c:out value="${bed_rowNum - 1}" />].bedTypeId">
                    <c:forEach var="bedType" items="${bedManagerForm.bedTypes}">
                        <c:choose>
                            <c:when test="${bedType.id == bed.bedTypeId}">
                                <option value="<c:out value="${bedType.id}"/>" selected="selected">
                                    <c:out value="${bedType.name}" />
                                </option>
                            </c:when>
                            <c:otherwise>
                                <option value="<c:out value="${bedType.id}"/>">
                                    <c:out value="${bedType.name}" />
                                </option>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </select>
            </display:column>
            <display:column title="Room">
                <select name="beds[<c:out value="${bed_rowNum - 1}" />].roomId">
                    <c:forEach var="room" items="${bedManagerForm.rooms}">
                        <c:choose>
                            <c:when test="${room.id == bed.roomId}">
                                <option value="<c:out value="${room.id}"/>" selected="selected">
                                    <c:out value="${room.name}" />
                                </option>
                            </c:when>
                            <c:otherwise>
                                <option value="<c:out value="${room.id}"/>">
                                    <c:out value="${room.name}" />
                                </option>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </select>
            </display:column>
            <display:column property="reservationEnd" sortable="true" title="Reserved Until" />
            <display:column title="Active" sortable="true">
                <c:choose>
                    <c:when test="${bed.active}">
                        <input type="checkbox" name="beds[<c:out value="${bed_rowNum - 1}" />].active" checked="checked" />
                    </c:when>
                    <c:otherwise>
                        <input type="checkbox" name="beds[<c:out value="${bed_rowNum - 1}" />].active" />
                    </c:otherwise>
                </c:choose>
            </display:column>
        </display:table>
    </td>
    <td width="20%">
        <br />
        <html:submit onclick="bedManagerForm.method.value='saveBeds';">Save Beds</html:submit>
    </td>
</tr>
<tr>
    <td>
        <c:choose>
            <c:when test="${not empty bedManagerForm.rooms}">
                <html:text property="numBeds" />
                <html:submit onclick="bedManagerForm.method.value='addBeds';">Add Beds</html:submit>
            </c:when>
            <c:otherwise>
                <html:submit disabled="true">Add Beds</html:submit>
            </c:otherwise>
        </c:choose>
    </td>
</tr>
</table>
</html:form>