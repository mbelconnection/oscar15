<%@ include file="/taglibs.jsp"%>
<%@page import="com.quatro.common.KeyConstants;"%>
<script>
    function ConfirmDelete(name)
    {
        if(confirm("Are you sure you want to delete " + name + " ?")) {
            return true;
        }
        return false;
    }
</script>
<html:form action="/PMmodule/FacilityManager.do">

<table cellpadding="0" cellspacing="0" border="0" width="100%"	height="100%">
		
		<!-- Title -->
		<tr>
			<th class="pageTitle" align="center">Facility Management</th>
		</tr>

		<!-- body start -->
		<tr>
			<td height="100%"> 
								
				<table width="100%" cellpadding="0px" cellspacing="0px" height="100%"
					border="0">
					<!-- submenu -->
					<tr>
						<td align="left" class="buttonBar2"><html:link
							action="/Home.do"
							style="color:Navy;text-decoration:none">&nbsp;
							<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/close16.png"/>" />&nbsp;Close</html:link>					
							<security:oscarSec objectName="<%=KeyConstants.FUN_FACILITY_EDIT %>" rights="<%=KeyConstants.ACCESS_WRITE%>"  orgCd="<%=KeyConstants.ORG_ROOT%>">
								&nbsp;|&nbsp;<html:link action="/PMmodule/FacilityManager.do?method=add"	style="color:Navy;text-decoration:none">&nbsp;
								<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/New16.png"/>" />&nbsp;New Facility</html:link>
							</security:oscarSec>
						</td>
					</tr>
				
					<!-- messages -->
					<tr>
						<td align="left" class="message">
							<logic:messagesPresent message="true">
								<br />
								<html:messages id="message" message="true" bundle="pmm">
									<c:out escapeXml="false" value="${message}" />
								</html:messages>
								<br />
							</logic:messagesPresent>
						</td>
					</tr>
					
					<tr>
						<td height="100%">
						<div
							style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
				                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">
														
							<br />
							<div class="tabs" id="tabs">
							    <table cellpadding="3" cellspacing="0" border="0">
							        <tr>
							            <th title="Facilities">Facilities</th>
							        </tr>
							    </table>
							</div>
						
						    <display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="facility" name="facilities" export="false" pagesize="0" requestURI="/PMmodule/FacilityManager.do">
						        <display:setProperty name="paging.banner.placement" value="bottom" />
						        <display:setProperty name="paging.banner.item_name" value="agency" />
						        <display:setProperty name="paging.banner.items_name" value="facilities" />
						        <display:setProperty name="basic.msg.empty_list" value="No facilities found." />
						
						        <display:column sortable="false" title="">	
						        <security:oscarSec objectName="<%=KeyConstants.FUN_FACILITY_EDIT %>" rights="<%=KeyConstants.ACCESS_READ %>">						        	
						          <a href="<html:rewrite action="/PMmodule/FacilityManager.do"/>?method=edit&facilityId=<c:out value="${facility.id}" />"> Edit </a>						        						        	
						        </security:oscarSec>
						        </display:column>
						        
								<display:column sortable="true" title="Name" sortProperty="name" sortName="facility">
									<a href="<html:rewrite action="/PMmodule/FacilityManager.do"/>?method=view&facilityId=<c:out value="${facility.id}" />"><c:out value="${facility.name}" /></a>
								</display:column>
						        
						        <display:column property="description" sortable="true" title="Description" />
						        <display:column property="contactName" sortable="true" title="Contact Name" />
						        <display:column sortable="true" title="HIC?" >
							        <logic:equal name="facility" property="hic" value="true">Yes</logic:equal>
									<logic:equal name="facility" property="hic" value="false">No</logic:equal>
								</display:column>
								<display:column sortable="true" title="Active?" >
							        <logic:equal name="facility" property="active" value="true">Yes</logic:equal>
									<logic:equal name="facility" property="active" value="false">No</logic:equal>
								</display:column>						        
						    </display:table>
						</div>
						</td>
					</tr>
				</table>				
				
				
				
			</td>
		</tr>
		<!-- body end -->
	</table>


	
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>

