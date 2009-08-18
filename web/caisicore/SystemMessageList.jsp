<%@ include file="/taglibs.jsp"%>
<%
String s = "debug";
%>

<%@page import="com.quatro.common.KeyConstants" %>
<html:form action="/SystemMessage.do" >
	<input type="hidden" name="method" value="list" />
    <input type="hidden" name="scrollPosition" value='<c:out value="${scrPos}"/>' />

	<table cellpadding="0" cellspacing="0" border="0" width="100%"
		height="100%">

		<!-- Title -->
		<tr>
			<th class="pageTitle" align="center">System Messages</th>
		</tr>

		<!-- body start -->
		<tr>
			<td height="100%">

			<table width="100%" cellpadding="0px" cellspacing="0px" height="100%"
				border="0">
				<!-- submenu -->
				<tr>
					<td align="left" class="buttonBar2">
						<html:link	action="/PMmodule/Admin/SysAdmin.do" style="color:Navy;text-decoration:none;">
						<img border="0" src="<html:rewrite page="/images/close16.png"/>" />&nbsp;Close&nbsp;&nbsp;</html:link>
					<security:oscarSec objectName="<%=KeyConstants.FUN_ADMIN_SYSTEMMESSAGE %>" rights="<%=KeyConstants.ACCESS_WRITE%>">
						<html:link
						action="/SystemMessage.do?method=edit" 
						style="color:Navy;text-decoration:none;">
						<img border="0" src="<html:rewrite page="/images/New16.png"/>" />&nbsp;New&nbsp;&nbsp;</html:link>
					</security:oscarSec>
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
							<th title="System Messages">Messages</th>
						</tr>
					</table>
					</div>
										
					<display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="message" name="ActiveMessages" export="false" pagesize="30" requestURI="/SystemMessage.do?method=list">
						        <display:setProperty name="paging.banner.placement" value="bottom" />
						        <display:setProperty name="paging.banner.item_name" value="agency" />
						        <display:setProperty name="paging.banner.items_name" value="messages" />
						        <display:setProperty name="basic.msg.empty_list" value="No message found." />
								
							    <display:column sortable="false" title="">
							    	<logic:equal value="true" name="message" property="expired">
							        	<a href="<html:rewrite action="SystemMessage.do"/>?method=edit&id=<c:out value="${message.id}"/>" > View </a>
						        	</logic:equal>
									<logic:equal value="false" name="message" property="expired">
							        	<a href="<html:rewrite action="SystemMessage.do"/>?method=edit&id=<c:out value="${message.id}"/>" > Edit </a>
									</logic:equal>
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

