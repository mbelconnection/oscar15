<%@ include file="/taglibs.jsp"%>

<script>
    function submitForm(){
    	if (!trimInputBox()) return false;
      	var name= document.getElementsByName("room.name")[0];
      	if(name.value.trim()==''){
      	   alert("Please input Room Name.");
      	   name.focus();
			inRefreshing = false;
      	   return;
      	}
      	var rmtype= document.getElementsByName("room.roomTypeId")[0];
      	if(rmtype.value.trim()==''){
      	   alert("Please select Room Type.");
      	   rmtype.focus();
			inRefreshing = false;
      	   return;
      	}
 
        var bednum = document.getElementsByName("activebednum")[0];
        var current_assignedBed = document.getElementsByName("current_assignedBed")[0];
      	var assignedBed= document.getElementsByName("room.assignedBed")[0];

      	if(current_assignedBed.value=='1' && assignedBed.value=='0' && bednum.value>0){
    	   alert("This room already has bed(s) assigned, Assigned Beds can not be 'N'.");
      	   assignedBed.focus();
			inRefreshing = false;
      	   return;
      	}
 
      	if(assignedBed.value=='0'){
      	   var roomCapacity= document.getElementsByName("room.capacity")[0];
      	   if(!isInteger(roomCapacity.value)){
      	      alert("Please input valid Room Capacity.");
      	      roomCapacity.focus();
			inRefreshing = false;
      	      return;
      	   }
      	}

      	var programId= document.getElementsByName("room.programId")[0];
      	if(programId.value==''){
      	   alert("Please select a Program.");
      	   programId.focus();
			inRefreshing = false;
      	   return;
      	}

      	bedManagerForm.method.value='saveRoom';
        bedManagerForm.submit();  
    }    
</script>

<html:form action="/PMmodule/BedManager.do">
  <input type="hidden" name="method" />
  <html:hidden property="room.id"/>
  <html:hidden property="room.facilityId"/>
  <table cellpadding="0" cellspacing="0" border="0" width="100%" 	height="100%">
    <c:choose>
    <c:when test="${roomId==0}">
	  <tr><th class="pageTitle" align="center">Facility Management - New Room</th></tr>
	</c:when>
	<c:otherwise>
	  <tr><th class="pageTitle" align="center">Facility Management - Edit Room</th></tr>
	</c:otherwise>
	</c:choose>  
	<tr><td height="100%">
	 <table width="100%" cellpadding="0px" cellspacing="0px" height="100%" 	border="0">
	 <!-- submenu -->
	  <tr><td align="left" class="buttonBar2">
		<a href='<html:rewrite action="/PMmodule/BedManager.do?method=manageroom&facilityId="/><c:out value="${bedManagerForm.facilityId}"/>' style="color:Navy;text-decoration:none">&nbsp;
		<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close</a>
		<c:if test="${!isReadOnly}">
		  &nbsp;|&nbsp;<html:link href="javascript:submitForm();" style="color:Navy;text-decoration:none;" onclick="javascript:setNoConfirm();">
		  <img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Save Room</html:link>
		</c:if>	
		<c:if test="${bedManagerForm.room.assignedBed=='1'}">
		&nbsp;|&nbsp;<a href='<html:rewrite action="/PMmodule/BedManager.do?method=managebed&facilityId="/><c:out value="${bedManagerForm.facilityId}"/>&roomId=<c:out value="${roomId}"/>' style="color:Navy;text-decoration:none">
		<img border="0" src="<html:rewrite page="/images/greenarrow.gif"/>" />&nbsp;Beds</a>
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
			  <table width="100%">
				<html:hidden property="facilityId" />

                 <tr><td><div class="tabs">
                   <table cellpadding="3" cellspacing="0" border="0">
                      <tr><th>Room</th></tr>
                 </table></div></td></tr>

				<tr><td>								
				<table width="100%" class="simple">
				  <tr><td>Room Name*</td>
				  <td><html:text property="room.name" maxlength="45"></html:text></td></tr>
				  <tr><td>Floor</td>
				  <td><html:text property="room.floor" maxlength="45"></html:text></td></tr>
				  <tr><td>Type*</td>
				  <td><html:select property="room.roomTypeId">
				    <html:option value=""></html:option>
				    <html:optionsCollection name="roomTypes" value="id"	label="name" />
				  </html:select></td></tr>
				  <tr><td>Assigned Beds*</td>
				  <td><html:select property="room.assignedBed">
				    <html-el:optionsCollection name="assignedBedLst" value="value"	label="label" />
				  </html:select>
				  <input type=hidden name="current_assignedBed" value="<c:out value="${bedManagerForm.room.assignedBed}" />">
				  <input type=hidden name="activebednum" value="<c:out value="${activebednum}"/>">
				  </td></tr>
				  <tr><td>Room Capacity</td>
				  <td><html:text property="room.capacity" maxlength="10"></html:text> (Only enforced when Assigned Beds=N)</td></tr>
				  <tr><td>Program*</td>
				  <td><html:select property="room.programId">
				    <option value=""></option>
				    <html:optionsCollection property="programs" value="id"	label="name" />
				  </html:select></td></tr>
				  <tr><td>Active</td>
				  <td><html:checkbox  property="room.active" value="1"></html:checkbox></td></tr>
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
