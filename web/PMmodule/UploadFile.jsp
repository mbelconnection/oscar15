
<%@ include file="/taglibs.jsp"%>

<%
response.setHeader("Cache-Control", "no-cache");
%>
<c:set var="ctx" value="${pageContext.request.contextPath}"
	scope="request" />
<script type="text/javascript"
	src='<c:out value="${ctx}"/>/js/quatroLookup.js'></script>
<script>	
	function submitForm(methodValue)
	{
		if (!trimInputBox()) return;
		if(document.forms[0].imagefile.value=="") {
			alert ("Please browse a file to upload first");
			inRefreshing = false;
			return;
		}
		document.forms[0].method.value=methodValue;
		document.forms[0].submit();
	}
</script>

<html:form action="/PMmodule/UploadFile.do"	enctype="multipart/form-data" >
	<input type="hidden" name="method" value="save"/>
	<input type="hidden" name="clientId" value="<c:out value="${clientId}"/>" /> 
	<html-el:hidden property="attachmentValue.refNo" />
	<html-el:hidden property="attachmentValue.id" />
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<th class="pageTitle" width="100%">Attachment Edit</th>
		</tr>
		<tr>
			<td class="simple" style="background: lavender"><%@ include file="ClientInfo.jsp" %></td>
		</tr>
		<tr>
			<td align="left" class="buttonBar2">
				<html:link action="/PMmodule/UploadFile.do" 	style="color:Navy;text-decoration:none;">
					<img border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;
				</html:link> |
				<a	href="javascript:submitForm('save')" onclick="javascript: setNoConfirm();" style="color:Navy;text-decoration:none;">
					<img border=0 src=<html:rewrite page="/images/Save16.png"/> />&nbsp;Upload&nbsp;&nbsp;|</a>
			</td>
		</tr>
		<tr>
			<td align="left" class="message">
			<logic:messagesPresent	message="true">
				<html:messages id="message" message="true" bundle="pmm">
					<c:out escapeXml="false" value="${message}" />
				</html:messages>
			</logic:messagesPresent></td>
		</tr>
	</table>

	<br>

	<table WIDTH="95%">
		<tr>
			<th align="right" width="20%">Document Category</th>
			<td><html:select property="attachmentValue.docType">
				<html:options collection="lstDocType" property="code" labelProperty="description"></html:options>
			</html:select></td>
		</tr>
		<tr>
			<th ALIGN="right" width="20%">File Path</th>
			<td><html-el:file property="attachmentText.imagefile"  size="30" styleId="imagefile"  >
			
			</html-el:file> <!-- 	accept="*.gif,*.jpg" /> --> <br />
			<!-- html:submit value="Upload" property="method" />--></td>
		</tr>
		<tr>
			<th>&nbsp;</th>
			<td>Maximum Size: <%=oscar.OscarProperties.getInstance().getProperty("maxfilesize")%></td>
		</tr>
	</table>
	<%@ include file="/common/readonly.jsp" %>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>

