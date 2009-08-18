<%@ include file="/taglibs.jsp"%>
<%@page import="com.quatro.common.KeyConstants;"%>
<script>
    function ConfirmDelete(name)
    {
        return confirm("Are you sure you want to delete " + name + " ?");
    }
    
    function roomFilter(){
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
  <input type="hidden" name="roomId" value="<c:out value="${roomId}"/>" />
  <table cellpadding="0" cellspacing="0" border="0" width="100%" 	height="100%">
	<tr><th class="pageTitle" align="center">Facility Management - Beds List</th></tr>
	<tr><td height="100%">
	 <table width="100%" cellpadding="0px" cellspacing="0px" height="100%" 	border="0">
	 <!-- submenu -->
	  <tr><td align="left" class="buttonBar2">
		<a href="<html:rewrite action="/PMmodule/BedManager.do?method=editRoom&facilityId="/><c:out value="${bedManagerForm.facilityId}"/>&roomId=<c:out value="${roomId}"/>" style="color:Navy;text-decoration:none;">
		<img border="0" src="<html:rewrite page="/images/Back16.png"/>" />&nbsp;Back to Room</a>
		<c:if test="${!isReadOnly}">
		 <security:oscarSec objectName="<%=KeyConstants.FUN_FACILITY_BED %>" rights="<%=KeyConstants.ACCESS_WRITE %>">
		  &nbsp;|&nbsp;<a href='<html:rewrite action="/PMmodule/BedManager.do?method=editBed&facilityId="/><c:out value="${bedManagerForm.facilityId}"/>&roomId=<c:out value="${roomId}"/>&bedId=0' style="color:Navy;text-decoration:none">
		  <img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/New16.png"/> />&nbsp;Add Bed</a>
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
		  <table width="100%" height="100%" cellpadding="0px"	cellspacing="0px">				
			<tr><td>
			  <table width="100%" summary="Manage rooms and beds">
				<html:hidden property="facilityId" />

                 <tr><td><div class="tabs">
                   <table cellpadding="3" cellspacing="0" border="0">
                      <tr><th>Room</th></tr>
                 </table></div></td></tr>

				<tr><td width="100%">								
				<table width="100%" class="simple">
				  <tr>
				  <th style="background-color: #eee" width="25%">Program</th>
				  <th style="background-color: #eee" width="25%">Room Name</th>
				  <th style="background-color: #eee" width="10%">Floor</th>
				  <th style="background-color: #eee" width="15%">Type</th>
				  <th style="background-color: #eee" width="10%">Assigned Beds</th>
				  <th style="background-color: #eee" width="10%">Room Capacity</th>
				  <th style="background-color: #eee" width="5%">Active</th>
				  </tr>

				  <tr>
				  <td><c:out value="${program.name}" /></td>
				  <td><c:out value="${bedManagerForm.room.name}"/></td>
				  <td><c:out value="${bedManagerForm.room.floor}"/></td>
				  <td>
					<c:forEach var="roomType" items="${roomTypes}">
					<c:if test="${roomType.id == bedManagerForm.room.roomTypeId}"><c:out value="${roomType.name}" /></c:if>
					</c:forEach>
				  </td>
				  <td>
					<c:choose>
					<c:when test="${bedManagerForm.room.assignedBed != 1}">N</c:when>
					<c:otherwise>Y</c:otherwise>
					</c:choose>
				  </td>
				  <td><c:out value="${bedManagerForm.room.capacity}"/></td>
				  <td>
				   <c:choose>
				     <c:when test="${bedManagerForm.room.active}">Y</c:when>
				     <c:otherwise>N</c:otherwise>
				   </c:choose>
				  </td></tr>
				</table><br></td></tr>

                 <tr><td><div class="tabs">
                   <table cellpadding="3" cellspacing="0" border="0">
                      <tr><th>Bed</th></tr>
                 </table></div></td></tr>
                
                <tr><td>
				<display:table class="simple" sort="list" name="beds"	id="bed" requestURI="/PMmodule/BedManager.do" pagesize="20">
				   <display:column title="Name" sortable="true" sortProperty="name">
				    <a href="<html:rewrite action="/PMmodule/BedManager.do?method=editBed" />&facilityId=<c:out value="${bedManagerForm.facilityId}"/>&roomId=<c:out value="${roomId}"/>&bedId=<c:out value="${bed.id}"/>">
                      <c:out value="${bed.name}"/>
                    </a>  
                   </display:column>   
				   <display:column title="Type">
					<c:forEach var="bedType" items="${bedTypes}">
					<c:if test="${bedType.id == bed.bedTypeId}"><c:out value="${bedType.name}" /></c:if>
					</c:forEach>
				   </display:column>
				   <display:column title="Active" sortable="true" sortProperty="active">
					   <c:choose>
					     <c:when test="${bed.active}">Y</c:when>
					     <c:otherwise>N</c:otherwise>
					   </c:choose>
					</display:column>
				</display:table>
				</td></tr>
								
			</table>
			</td></tr>
		</table>


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
