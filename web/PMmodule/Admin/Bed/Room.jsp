<%@ include file="/taglibs.jsp"%>
<%@page import="com.quatro.common.KeyConstants;"%>
<script>
	var rmStatusChanged = false;
    function ConfirmDelete(name)
    {
        return confirm("Are you sure you want to delete " + name + " ?");
    }
    
    function roomFilter(){
	    if (rmStatusChanged) return;
	    rmStatusChanged = true;
		var obj = document.getElementById("hrefSort");
		var obj2 = document.getElementsByName("bedProgramFilterForRoom")[0];
		var obj3 = document.getElementsByName("roomStatusFilter")[0];
		
		obj.href='<html:rewrite action="/PMmodule/BedManager.do?method=doRoomFilter" />' + 
   		    '&facilityId=<c:out value="${bedManagerForm.facilityId}"/>&bedProgramFilterForRoom=' + 
   		    obj2.value + '&roomStatusFilter=' + obj3.value; 
   		    
   		obj.click();   
    }
    
/*    
    function deleteRoom(){
    	var doDelete = confirm("Are you sure you want to delete the room?");
    	if(doDelete){
			document.forms[0].action = '<html:rewrite action="/PMmodule/BedManager.do?method=deleteRoom" />';
			document.forms[0].submit();
    	}
    }
*/    
    function deleteRoom(rid){
    	var doDelete = confirm("Are you sure you want to delete the room?");
    	if(doDelete){
    	  document.forms[0].roomToDelete.value=rid;
		  var obj = document.getElementById("method");
		  obj.value='deleteRoom';
		  document.forms[0].submit();
		}  
    }
</script>

<html:form action="/PMmodule/BedManager.do">
  <input type="hidden" name="method" />
  <input type="hidden" name="hasErrorRoom" />
  <input type="hidden" name="hasErrorBed" />
  <table cellpadding="0" cellspacing="0" border="0" width="100%" 	height="100%">
	<tr><th class="pageTitle" align="center">Facility Management - Rooms List</th></tr>
	<tr><td height="100%">
	 <table width="100%" cellpadding="0px" cellspacing="0px" height="100%" 	border="0">
	 <!-- submenu -->
	  <tr><td align="left" class="buttonBar2">
		<html:link action="/PMmodule/FacilityManager.do?method=list" style="color:Navy;text-decoration:none;">
		<img border="0" src="<html:rewrite page="/images/Back16.png"/>" />&nbsp;Back to Facilities</html:link>

		<c:if test="${!isReadOnly}">
			 <security:oscarSec objectName="<%=KeyConstants.FUN_FACILITY_BED %>" rights="<%=KeyConstants.ACCESS_WRITE %>">
		  &nbsp;|&nbsp;<a href='<html:rewrite action="/PMmodule/BedManager.do?method=editRoom&facilityId="/><c:out value="${bedManagerForm.facilityId}"/>&roomId=0' style="color:Navy;text-decoration:none">
		  <img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/New16.png"/> />&nbsp;Add Room&nbsp;</a>
		</security:oscarSec>
		</c:if>	
	  </td></tr>

	  <!-- messages -->
	  <tr><td align="left" class="message">
		<logic:messagesPresent	message="true"><br />
		  <html:messages id="message" message="true" bundle="pmm"><c:out escapeXml="false" value="${message}" />
		  </html:messages><br />
		</logic:messagesPresent>
	  </td></tr>

   	  <tr><td height="100%">
		<div style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;  height: 100%; width: 100%; overflow: auto;" id="scrollBar">
		 <logic:notEmpty name="bedManagerForm" property="programs">
		  <table width="100%" height="100%" cellpadding="0px"	cellspacing="0px">				
			<tr><td>
			  <table width="100%" summary="Manage rooms and beds">
				<html:hidden property="facilityId" />
				<tr><td width="100%">								
				<!-- begin room status & bed program filter -->
				<table width="100%">
				  <tr><td width="35%">Room Status
					<html:select property="roomStatusFilter"	name="bedManagerForm" onchange="setNoConfirm();roomFilter();" title="filter">
					<html:optionsCollection property="roomStatusNames"	value="key" label="value" />
					</html:select>
				  </td>
				  <td width="65%">Bed Program
				  <html:select property="bedProgramFilterForRoom"	name="bedManagerForm" onchange="setNoConfirm();roomFilter();"  title="filter">
					<option value="0">Any</option>
					<html:optionsCollection property="programs" value="id" label="name" />
				  </html:select>
				  <a id="hrefSort" href="">
				  </td></tr>
				</table>

				<!-- end room status & bed program filter --> 
				<display:table class="simple" sort="list" name="rooms"	id="room" requestURI="/PMmodule/BedManager.do">
					<display:column title="Program">
						 <c:forEach var="program" items="${bedManagerForm.programs}">
						 <c:if test="${program.id == room.programId}"><c:out value="${program.name}" /></c:if>
						 </c:forEach>
					</display:column>
				   <display:column title="Name" sortable="true" sortProperty="name">
				    <a href="<html:rewrite action="/PMmodule/BedManager.do?method=editRoom" />&facilityId=<c:out value="${bedManagerForm.facilityId}"/>&roomId=<c:out value="${room.id}"/>">
                      <c:out value="${room.name}"/>
                    </a>  
                   </display:column>   
				   <display:column property="floor" title="Floor" sortable="true"/>
				   <display:column title="Type" sortable="true">
					<c:forEach var="roomType"	items="${roomTypes}">
					<c:if test="${roomType.id == room.roomTypeId}"><c:out value="${roomType.name}" /></c:if>
					</c:forEach>
				   </display:column>
				   <display:column title="Assigned Beds" sortable="true">
						<c:choose>
						<c:when test="${room.assignedBed != 1}">N</c:when>
						<c:otherwise>Y</c:otherwise>
						</c:choose>
				   </display:column>
				   <display:column property="bedNum" title="Beds" />
				   <display:column property="capacity" title="Room Capacity" />
					<display:column title="Active" sortable="true" sortProperty="active">
					   <c:choose>
					     <c:when test="${room.active}">Y</c:when>
					     <c:otherwise>N</c:otherwise>
					   </c:choose>
					</display:column>
				</display:table>
				</td></tr>
								
			</table>
			</td></tr>
		</table>

</logic:notEmpty>

					</div>
					</td>
				</tr>
			</table>



			</td>
		</tr>
		<!-- body end -->
	</table>
	<%@ include file="/common/readonly.jsp" %>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
