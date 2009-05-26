<%@ include file="/taglibs.jsp"%>

<%@ page import="org.springframework.web.context.WebApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="java.text.DateFormat" %>
<%
response.setHeader("Cache-Control", "no-cache");
%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.quatro.common.KeyConstants" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"	scope="request" } />
<script type="text/javascript">    
	function popupUploadPage(varpage,dn) {
        var page = "" + varpage+"?id="+dn;
        windowprops = "height=500,width=500,location=no,"
          + "scrollbars=no,menubars=no,toolbars=no,resizable=yes,top=50,left=50";
         var popup=window.open(page, "", windowprops);
         popup.focus();
    }
    function confirmDelete() 
    {
    	return confirm("Are you sure you want to delete this file? Click OK to continue.");
    }	    
</script>

<html:form action="/PMmodule/UploadFile.do">
<input type="hidden" name="clientId" value='<c:out value="${clientId}" />' />
	<div id="pageTitle">
	<table width="100%">
		<tr>
			<th class="pageTitle" width="100%">Attachment List</th>
		</tr>
		<tr>
			<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
		</tr>
		<tr>
			<td align="left" class="buttonBar2">
				<html:link action="/PMmodule/ClientSearch2.do" style="color:Navy;text-decoration:none;">&nbsp;
				<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Back16.png"/> />&nbsp;Back to Client Search&nbsp;&nbsp;|</html:link>
			    <c:if test="${currentIntakeProgramId>0}">
				<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTDOCUMENT %>" orgCd='<%=((Integer) request.getSession().getAttribute("currentIntakeProgramId")).toString()%>' rights="<%=KeyConstants.ACCESS_WRITE %>">
					<html:link	action="/PMmodule/UploadFile.do?method=addNew" 	style="color:Navy;text-decoration:none;">
						<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/New16.png"/> />&nbsp;Add&nbsp;&nbsp;
					</html:link>		
				</security:oscarSec>
				</c:if>	
			</td>
		</tr>
	</table>
	</div>
</html:form>
	<div	style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;
                    height: 450px; width: 100%; overflow: auto;" id="scrollBar">
		<display:table class="simple" sort="list" cellspacing="2" cellpadding="3" id="atth" name="att_files" export="false" pagesize="50"  requestURI="/PMmodule/UploadFile.do">
		  <display:setProperty name="paging.banner.placement" value="bottom"/>
		  <display:setProperty name="basic.msg.empty_list" value="No attachment found." />
		  <display:column sortable="false" title="">
		  	<!-- 
		  	<html:link action='/PMmodule/UploadFile.do?method=delete&id=<c:out value="${atth.id}"/>' title="Delete">
		  		Delete
		  	</html:link>		  	
		  	-->
		  	 <security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTDOCUMENT %>" rights="<%=KeyConstants.ACCESS_WRITE %>">
		  	<a title="Delete" onclick="javascript: return confirmDelete();" href="<html:rewrite  action="/PMmodule/UploadFile.do"/>?method=delete&id=<c:out value="${atth.id}"/>&clientId=<c:out value="${clientId}" />" >
				Delete </a>
			</security:oscarSec>	
		  </display:column>	
		  <display:column sortable="false" title="">
		   <security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTDOCUMENT %>" rights="<%=KeyConstants.ACCESS_WRITE %>">
		  	<a title="Edit" href="<html:rewrite  action="/PMmodule/UploadFile.do"/>?method=edit&id=<c:out value="${atth.id}" />&clientId=<c:out value="${clientId}" />">
				Replace </a>
			</security:oscarSec>	
		  </display:column>		  
		  <display:column  sortable="true" title="File Name">
		    <c:choose>
		    <c:when test="${atth.fileCount>1 }">
		    		<a href="javascript:popupUploadPage('<c:out value="${ctx}"/>/PMmodule/ShowFile.do',<c:out value="${atth.id}"/>);">		  
		  			<c:out value="${atth.fileName}"/>(*)</a>
		    </c:when>
		    <c:otherwise>
			  	<a href="javascript:popupUploadPage('<c:out value="${ctx}"/>/PMmodule/ShowFile.do',<c:out value="${atth.id}"/>);">		  
			  		<c:out value="${atth.fileName}"/>
			  	</a>
		  	</c:otherwise>
		  	</c:choose>
		  </display:column>
		  <display:column property="docDesc" sortable="true" title="Category"></display:column>
		  <display:column property="providerDesc" sortable="true" title="Last Update Provider"/>
		  <display:column property="revDt" format="{0,date,yyyy/MM/dd}" sortable="true" title="Last Update Date" />
		  
	</display:table>		
	</div>
		

