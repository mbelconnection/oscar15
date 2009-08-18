<%@ include file="/taglibs.jsp"%>
<html>
<head>
<script language="JavaScript">
	function submitForm(mthd)
	{
		document.forms[0].method.value=mthd;
		document.forms[0].submit();
	}
	
	function setValue(val)
	{
		alert(val);
	}
</script>
</head>
<body>

<html:form action="/QuatroReport/ReportList.do">
	<input type="hidden" name="method" />
	<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">

		<!-- Title -->
		<tr>
			<th class="pageTitle" align="center">Report Management</th>
		</tr>
		<tr class="buttonBar2">
			<td align="left" class="buttonBar2">
			<html:link action="/Home.do"
			style="color:Navy;text-decoration:none">&nbsp;
			<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/close16.png"/> />&nbsp;Close&nbsp;&nbsp;|</html:link>
			<html:link
				href="javascript:submitForm('delete');"
				style="color:Navy;text-decoration:none">&nbsp;
			<img style="vertical-align: middle" border="0"
					src="<html:rewrite page="/images/Delete16.gif"/>" />&nbsp;Delete Template(s)&nbsp;|</html:link>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	<tr height="100%">
		<td>
   			<div style="color: Black; background-color: White; border-style: ridge; border-width: 1px; width: 100%; height: 100%; overflow: auto">
	<table width="100%">
		<tr>
			<td>
				<%StringBuffer str= new StringBuffer(); %> 
				<logic:iterate
					id="reportGroup" property="reportGroups" name="quatroReportListForm"
					indexId="rIndex1">
					<ul>
						<bean:write name="reportGroup" property="reportGroupDesc" />
						<ul>
							<logic:iterate id="report" property="reports" name="reportGroup"
								indexId="rIndex2">
								<li><a	href="<html:rewrite action="/QuatroReport/ReportRunner.do"/>?id=<c:out value="${report.reportNo}" />">
									<c:out value="${report.title}" /> - <c:out	value="${report.description}" /> </a></li>
								<logic:iterate id="template" property="childList" name="report"	indexId="rIndex3">
									<ul>
										<logic:equal name="template" property="deleteable" value="true">
											<input type="checkbox" name='p<c:out value="${rIndex1}"></c:out>_<c:out value="${rIndex2}"></c:out>_<c:out value="${rIndex3}"></c:out>' value="<c:out value="${template.templateNo}" />">
										</logic:equal>
										<logic:equal name="template" property="deleteable" value="false">
											<input type="checkbox" disabled="true" name='p<c:out value="${rIndex1}"></c:out>_<c:out value="${rIndex2}"></c:out>_<c:out value="${rIndex3}"></c:out>' value="<c:out value="${template.templateNo}" />">
										</logic:equal>
										<%
										   str.append("," + String.valueOf(rIndex1) + "_" + String.valueOf(rIndex2) + "_" + String.valueOf(rIndex3)); 
										   
										%>
										<a href="<html:rewrite action="/QuatroReport/ReportRunner.do"/>?id=<c:out value="${report.reportNo}" />&templateNo=<c:out value="${template.templateNo}" />"> <c:out value="${template.desc}"/> </a>
	       							</ul>
								</logic:iterate>
							</logic:iterate>
						</ul>
					</ul>
				</logic:iterate>
				<% request.setAttribute("str",str); %>
				<input type="hidden" name="chkDel" value='<c:out value="${str}"></c:out>' />
			</td>
		</tr>
	</table>
	</div>
</td></tr>
</table>
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
</body>
</html>