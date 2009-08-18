<%@ include file="/taglibs.jsp"%>
<%
String s = "debug";
%>
<%@ page import="org.oscarehr.PMmodule.model.Facility"%>
<%@page import="com.quatro.common.KeyConstants;"%>

<html:form action="/FacilityMessage.do">
	<input type="hidden" name="method" value="save" />

	<table cellpadding="0" cellspacing="0" border="0" width="100%"
		height="100%">

		<!-- Title -->
		<tr>
			<th class="pageTitle" align="center">Facility Management -
			Messages</th>
		</tr>

		<!-- body start -->
		<tr>
			<td height="100%">

			<table width="100%" cellpadding="0px" cellspacing="0px" height="100%"
				border="0">
				<!-- submenu -->
				<tr>
					<td align="left" class="buttonBar2">
					<html:link
						action="/PMmodule/FacilityManager.do?method=list"
						style="color:Navy;text-decoration:none;">
						<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/Back16.png"/>" />&nbsp;Back to Facilities</html:link>
						<c:if test="${!isReadOnly}">
							 <security:oscarSec objectName="<%=KeyConstants.FUN_FACILITY_MESSAGE %>" rights="<%=KeyConstants.ACCESS_WRITE %>">
							&nbsp;|&nbsp;<html:link	action="/FacilityMessage.do?method=edit" name="actionParam" 	style="color:Navy;text-decoration:none;">
							<img style="vertical-align: middle" border="0" src="<html:rewrite page="/images/New16.png"/>" />&nbsp;New</html:link>
							</security:oscarSec>
						</c:if>	
					</td>
				</tr>

				<!-- messages -->
				<tr>
					<td align="left" class="message"><logic:messagesPresent
						message="true">
						<br />
						<html:messages id="message" message="true" bundle="pmm">
							<c:out escapeXml="false" value="${message}" />
						</html:messages>
						<br />
					</logic:messagesPresent></td>
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
							<th title="Facility Messages">Messages</th>
						</tr>
					</table>
					</div>
										
					<br />

					
					
					<display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="message" name="ActiveFacilityMessages" export="false" pagesize="0" requestURI="/FacilityMessage.do?method=list">
						        <display:setProperty name="paging.banner.placement" value="bottom" />
						        <display:setProperty name="paging.banner.item_name" value="agency" />
						        <display:setProperty name="paging.banner.items_name" value="messages" />
						        <display:setProperty name="basic.msg.empty_list" value="No message found." />
						
						        <display:column sortable="false" title="">
						        	<a href="<html:rewrite action="FacilityMessage.do"/>?method=edit&id=<c:out value="${message.id}"/>&facilityId=<c:out value="${facility.id}"/>" > 
						        		<logic:equal name="message" property="expired" value="false">
						        			Edit
						        		</logic:equal>
						        		<logic:equal name="message" property="expired" value="true">
						        			View
						        		</logic:equal>
						        	</a>
						        </display:column>
						        
								
						        <display:column property="formattedCreationDate" sortable="true" title="Creation Date"/>
						        <display:column property="formattedExpiryDate" sortable="true" title="Expiry Date" />
						        <display:column property="message" sortable="true" title="Message" />
						        
						        
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

