<%@ include file="/taglibs.jsp" %>
<%@page import="java.util.Date"%>
<%@page import="org.oscarehr.PMmodule.model.ClientReferral"%>
<%@page import="com.quatro.common.KeyConstants"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<script type="text/javascript" src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
<script lang="javascript">
		function submitForm(methodVal) {
			if (!trimInputBox()) return false;
			document.forms[0].method.value = methodVal;
			document.forms[0].submit();
		}
	
		function updateQuatroRefer(clientId, rId) {
			location.href = '<html:rewrite action="/PMmodule/QuatroRefer.do"/>' + "?method=edit&rId=" + rId + "&clientId=" + clientId;
		}	
</script>

<html-el:form action="/PMmodule/QuatroRefer.do">
		<% int a=1; %>
<input type="hidden" name="method"/>
<input type="hidden" name="clientId"/>
<table width="100%"  cellpadding="0px" cellspacing="0px">
	<tr>
		<th class="pageTitle" align="center">Client Management - Referral</th>
	</tr>
	<tr>
			<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
	</tr>	
	<tr>
		<td align="left" class="buttonBar2">
		<html:link action="/PMmodule/ClientSearch2.do" style="color:Navy;text-decoration:none;">
		<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Back16.png"/> />&nbsp;Back to Client Search&nbsp;&nbsp;</html:link>
        <c:if test="${currentIntakeProgramIdActive>0}">
		<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTREFER %>"   orgCd='<%=((Integer) request.getSession().getAttribute("currentIntakeProgramIdActive")).toString()%>' rights="<%=KeyConstants.ACCESS_WRITE %>">
            <security:oscarSec objectName="_clientRefer" orgCd='<%=((Integer)request.getSession().getAttribute("currentIntakeProgramIdActive")).toString() %>'  rights="<%=KeyConstants.ACCESS_UPDATE %>" >
				<html:link	action="/PMmodule/QuatroRefer.do?method=edit&rId=0" paramId="clientId"  paramName="clientId" style="color:Navy;text-decoration:none;">|&nbsp;
				<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/New16.png"/> />&nbsp;New Referral&nbsp;&nbsp;
				</html:link> 
			</security:oscarSec>
		</security:oscarSec>	
        </c:if>
		</td>
	</tr>
	<tr height="18px">
			<td align="left" class="message">			
			<logic:messagesPresent
				message="true">
				<html:messages id="message" message="true" bundle="pmm">
					<c:out escapeXml="false" value="${message}" />
				</html:messages>
			</logic:messagesPresent>
			<br /></td>
		</tr>
		<tr><td><div class="tabs">
              <table cellpadding="3" cellspacing="0" border="0">
                <tr><th>Referrals</th></tr>
              </table></div>
       </td></tr>
		<tr>
			<td>
				<div style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 500px; width: 100%; overflow: auto;" id="scrollBar">
               <display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="refer" name="lstRefers" export="false" pagesize="50" requestURI="/PMmodule/QuatroRefer.do">
			    <display:setProperty name="paging.banner.placement" value="bottom" />
    			<display:setProperty name="basic.msg.empty_list" value="No Referrals found." />
			    <display:column property="programName" sortable="true" title="Program Name" />
 			    <display:column property="referralDate.time" sortable="true" title="Created On" format="{0,date,yyyy/MM/dd hh:mm:ss a}" />
			    <display:column property="providerFormattedName" sortable="true" title="Staff" />
			    <display:column property="status" sortable="true" title="Status" />
			    <display:column  title="Actions">
					<c:choose>
						<c:when test="${'M' eq refer.autoManual and (refer.status eq 'pending') }">
                            <c:set var="acc_update" value="N" scope="request"/>
							<security:oscarSec objectName="_clientRefer" orgCd="<%=((ClientReferral)refer).getFromProgramId().toString() %>"  rights="<%=KeyConstants.ACCESS_UPDATE %>" >
								<a href="javascript:updateQuatroRefer('<c:out value="${refer.clientId}" />', '<c:out value="${refer.id}" />')" >Update</a>
                                <c:set var="acc_update" value="Y" scope="request"/>
							</security:oscarSec>
		                    <c:if test="${acc_update!='Y'}">
							<security:oscarSec objectName="_clientRefer"  orgCd="<%=((ClientReferral)refer).getFromProgramId().toString() %>" rights="<%=KeyConstants.ACCESS_READ %>" >
								<a href="javascript:updateQuatroRefer('<c:out value="${refer.clientId}" />', '<c:out value="${refer.id}" />')" >View</a>
							</security:oscarSec>
							</c:if>
						</c:when>					
						<c:otherwise>
							<security:oscarSec objectName="_clientRefer"  rights="<%=KeyConstants.ACCESS_READ %>" >
								<a href="javascript:updateQuatroRefer('<c:out value="${clientId}" />', '<c:out value="${refer.id}" />')" >View</a>
							</security:oscarSec>
						</c:otherwise>
				   </c:choose>
			    </display:column>
			   </display:table>
			    
				</div>
			</td>
		</tr>		
			
	</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
