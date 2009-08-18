<%@ include file="/taglibs.jsp" %>
<%@page import="com.quatro.common.KeyConstants;" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<script type="text/javascript" src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
<script lang="javascript">
		function submitForm(methodVal) {
			if (!trimInputBox()) return false;
			document.forms[0].method.value = methodVal;
			document.forms[0].submit();
		}
	
		function updateQuatroConsent(clientId, rId) {
			location.href = '<html:rewrite action="/PMmodule/QuatroConsent.do"/>' + "?method=edit&rId=" + rId + "&clientId=" + clientId;
		}	
		function withdraw(clientId,rId)
	    {
	    	if (confirm('Do you wish to withdraw this consent?'))
	    	{
		        var form = document.consentDetailForm;
		        form.method.value='withdraw';
		        form.clientId.value=clientId;
		        form.rId.value=rId;
		        form.submit();
	    	}
	    }
</script>

<html-el:form action="/PMmodule/QuatroConsent.do">
<input type="hidden" name="method"/>
<input type="hidden" name="clientId"/>
<input type="hidden" name="rId"/>
<table width="100%"  cellpadding="0px" cellspacing="0px">
	<tr>
		<th class="pageTitle" align="center">Client Management - Consent</th>
	</tr>
	<tr>
		<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
	</tr>	
</table>

<table width="100%">	
	<tr>
		<td align="left" class="buttonBar2">
			<html:link action="/PMmodule/ClientSearch2.do" style="color:Navy;text-decoration:none;">&nbsp;
			<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Back16.png"/> />&nbsp;Back to Client Search&nbsp;&nbsp;|</html:link>
			<c:if test="${currentIntakeProgramId>0}">
			<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTCONSENT %>"   orgCd='<%=((Integer) request.getSession().getAttribute("currentIntakeProgramId")).toString()%>' rights="<%=KeyConstants.ACCESS_WRITE %>">
				<html:link	action="/PMmodule/QuatroConsent.do?method=edit&rId=0" paramId="clientId"  paramName="clientId"	style="color:Navy;text-decoration:none;">
					<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/New16.png"/> />&nbsp;New Consent&nbsp;&nbsp;
				</html:link>
			</security:oscarSec>
			</c:if>
		</td>
	</tr>
	<tr>
		<td>		
				<div class="tabs">
					<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<th>Consents</th>
							</tr>
						</table>
					</div>
		 </td>
		</tr>	
		
		<tr>
			<td>
				<div style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 500px; width: 100%; overflow: auto;" id="scrollBar">
               <display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="consentDetail" name="lstConsents" export="false" pagesize="50" requestURI="/PMmodule/QuatroConsent.do">
    		    <display:setProperty name="paging.banner.placement" value="bottom" />
    			<display:setProperty name="basic.msg.empty_list" value="No Consents found." />
			    <display:column property="providerFormattedName" sortable="true" title="Staff" />
 			    <display:column property="dateSignedStr" sortable="true" title="Signed Date" format="{0,date,yyyy/MM/dd}" />
			    <display:column property="startDateStr" sortable="true" title="Start Date" />
			    <display:column property="endDateStr" sortable="true" title="End Date" />
			    <display:column property="status" sortable="true" title="Status" />
			    <display:column sortable="true" title="Actions" sortProperty="lnkAction">
				  <c:choose>
					<c:when test="${consentDetail.lnkAction eq 'Withdraw' or consentDetail.lnkAction eq 'withdrawn'}">
					<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTCONSENT %>" rights="<%=KeyConstants.ACCESS_UPDATE %>">								
					  <a href="javascript:withdraw('<c:out value="${clientId}" />','<c:out value="${consentDetail.id}" />')" >Withdraw</a>					  
					</security:oscarSec>
					<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTCONSENT %>" rights="<%=KeyConstants.ACCESS_READ %>">								
					<a href="javascript:updateQuatroConsent('<c:out value="${clientId}" />', '<c:out value="${consentDetail.id}" />')" >View</a>
					</security:oscarSec>
					</c:when>
					<c:when test="${consentDetail.lnkAction eq 'View' or consentDetail.lnkAction eq 'view'}">
					<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTCONSENT%>" rights="<%=KeyConstants.ACCESS_READ %>">								
					  <a href="javascript:updateQuatroConsent('<c:out value="${clientId}" />', '<c:out value="${consentDetail.id}" />')" >View</a>
					</security:oscarSec>
					</c:when>
					<c:otherwise>&nbsp;</c:otherwise>
				  </c:choose>
			    </display:column>
    		   </display:table>
				</div>
			</td>
		</tr>		
			
	</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
