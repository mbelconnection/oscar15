<%@ include file="/taglibs.jsp"%>

<script>
    function submitForm(){
      if (!trimInputBox()) return false;
      	var name= document.getElementsByName("bed.name")[0];
      	if(name.value.trim()==''){
      	   alert("Please input Bed Name.");
      	   name.focus();
			inRefreshing = false;
      	   return;
      	}
      	var type= document.getElementsByName("bed.bedTypeId")[0];
      	if(type.value==''){
      	   alert("Please input Bed Type.");
      	   type.focus();
			inRefreshing = false;
      	   return;
      	}

      	bedManagerForm.method.value='saveBed';
        bedManagerForm.submit();  
    }    
</script>

<html:form action="/PMmodule/BedManager.do">
  <input type="hidden" name="method" />
  <html:hidden property="bed.id"/>
  <html:hidden property="bed.roomId"/>
  <table cellpadding="0" cellspacing="0" border="0" width="100%" 	height="100%">
    <c:choose>
    <c:when test="${bedId==0}">
	  <tr><th class="pageTitle" align="center">Facility Management - New Bed</th></tr>
	</c:when>
	<c:otherwise>
	  <tr><th class="pageTitle" align="center">Facility Management - Edit Bed</th></tr>
	</c:otherwise>
	</c:choose>  
	<tr><td height="100%">
	 <table width="100%" cellpadding="0px" cellspacing="0px" height="100%" 	border="0">
	 <!-- submenu -->
	  <tr><td align="left" class="buttonBar2">
		<a href='<html:rewrite action="/PMmodule/BedManager.do?method=managebed&facilityId="/><c:out value="${bedManagerForm.facilityId}"/>&roomId=<c:out value="${roomId}"/>' style="color:Navy;text-decoration:none">&nbsp;
		<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close</a>

		<c:if test="${!isReadOnly}">
		  &nbsp;|&nbsp;<html:link href="javascript:submitForm();" style="color:Navy;text-decoration:none;" onclick="javascript: setNoConfirm();">
		  <img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save Bed</html:link>
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
		  <table width="100%" height="100%" cellpadding="0px" cellspacing="0px">				
			<tr><td>
			  <table width="100%">
				<html:hidden property="facilityId" />
                 <tr><td><div class="tabs">
                   <table cellpadding="3" cellspacing="0" border="0">
                      <tr><th>Room</th></tr>
                 </table></div></td></tr>
                
                <tr><td>
				<table width="100%" class="simple">
				  <tr>
				  <td width="25%">Program</td>
				  <td width="25%">Room Name</td>
				  <td width="10%">Floor</td>
				  <td width="15%">Type</td>
				  <td width="10%">Assigned Beds</td>
				  <td width="10%">Room Capacity</td>
				  <td width="5%">Active</td>
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
				</table><br>
                </td></tr>
				
                 <tr><td><div class="tabs">
                   <table cellpadding="3" cellspacing="0" border="0">
                      <tr><th>Bed</th></tr>
                 </table></div></td></tr>

				<tr><td>								
				<table width="100%" class="simple">
				  <tr><td>Bed Name</td>
				  <td><html:text property="bed.name" maxlength="45"></html:text></td></tr>
				  <tr><td>Type</td>
				  <td><html:select property="bed.bedTypeId">
				  	<html:option value=""></html:option>
				    <html:optionsCollection name="bedTypes" value="id"	label="name" />
				  </html:select></td></tr>
				  <tr><td>Active</td>
				  <td><html:checkbox  property="bed.active" value="1"></html:checkbox></td></tr>
				</table>

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
