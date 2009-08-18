<%@ include file="/taglibs.jsp" %>
<%@ taglib uri="/WEB-INF/quatro-tag.tld" prefix="quatro" %>
<%@page import="org.oscarehr.PMmodule.model.Admission"%>
<%@page import="java.util.Date"%>
<%@page import="com.quatro.common.KeyConstants;"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
 
<html-el:form action="/PMmodule/QuatroAdmission.do">
<input type="hidden" name="method"/>
<input type="hidden" name="clientId"/>
<script lang="javascript">
function submitForm(methodVal) {
		if (!trimInputBox()) return false;
		document.forms[0].method.value = methodVal;
		document.forms[0].submit();
}
	
function updateQuatroAdmission(clientId, admissionId) {
	location.href = '<html:rewrite action="/PMmodule/QuatroAdmission.do"/>' + "?method=update&admissionId=" + admissionId + "&clientId=" + clientId;
}
	
</script>
<table width="100%" height="100%" cellpadding="0px" cellspacing="0px">
	<tr>
		<th class="pageTitle" align="center">Client Management - Admission</th>
	</tr>
	<tr>
		<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
	</tr>
	<tr>
		<td align="left" class="buttonBar2">
		<html:link action="/PMmodule/ClientSearch2.do" style="color:Navy;text-decoration:none;">
		<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Back16.png"/> />&nbsp;Back to Client Search&nbsp;&nbsp;</html:link>
		</td>
	</tr>
	<tr><td align="left" class="message">
      <logic:messagesPresent message="true">
        <html:messages id="message" message="true" bundle="pmm"><c:out escapeXml="false" value="${message}" />
        </html:messages> 
      </logic:messagesPresent>
	</td></tr>
	<tr>
		<td height="100%">
		<div
			style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 100%; width: 100%; overflow: auto;" id="scrollBar">

<!--  start of page content -->
<table width="100%" class="edit">

<tr><td><br><div class="tabs">
<table cellpadding="3" cellspacing="0" border="0">
<tr><th>Admission Form</th></tr>
</table></div></td></tr>

<tr><td>
<display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="admission" name="admissions" export="false" pagesize="50" requestURI="/PMmodule/QuatroAdmission.do">
   <display:setProperty name="paging.banner.placement" value="bottom" />
   <display:setProperty name="basic.msg.empty_list" value="No admissions found." />
   <display:column property="programName" sortable="true" title="Program Name" />
   <display:column property="admissionDate.time" sortable="true" title="Admission Date" format="{0,date,yyyy/MM/dd hh:mm:ss a}" />
   <display:column property="providerName" sortable="true" title="Staff" />
   <display:column property="admissionStatus" sortable="true" title="Status" />
   <display:column sortable="false" title="Actions" >
	<c:choose>	
	 
	  <c:when test="${admission.admissionStatus == 'admitted'}">
		  <security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTADMISSION %>" rights="<%=KeyConstants.ACCESS_UPDATE %>">								
	          <a href="javascript:updateQuatroAdmission('<c:out value="${clientId}" />', '<c:out value="${admission.id}" />')">Update</a>
              <c:set var="acc_update" value="Y" scope="request"/>
	       </security:oscarSec> 
		   <c:if test="${acc_update!='Y'}">
	        <security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTADMISSION %>" rights="<%=KeyConstants.ACCESS_READ %>">								
	       		<a href="javascript:updateQuatroAdmission('<c:out value="${clientId}" />', '<c:out value="${admission.id}" />')">View</a>
	       	</security:oscarSec>	
	       </c:if>
	  </c:when>
	  <c:otherwise>
        <a href="javascript:updateQuatroAdmission('<c:out value="${clientId}" />', '<c:out value="${admission.id}" />')">View</a>
	  </c:otherwise>
	 </c:choose>
   </display:column>
</display:table>

</td></tr>

</table>

<!--  end of page content -->
</div>
</td>
</tr>
</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html-el:form>
