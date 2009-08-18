<%@ include file="../taglibs.jsp"%>

<%@ page import="org.oscarehr.casemgmt.model.*"%>
<%@ page import="org.oscarehr.casemgmt.web.formbeans.*"%>
<%@ page import="org.springframework.web.context.WebApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="org.caisi.service.Version"%>
<%@ page import="oscar.OscarProperties"%>

<%
response.setHeader("Cache-Control", "no-cache");
%>
<%@page import="com.quatro.common.KeyConstants"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"	scope="request" } />
<script type="text/javascript">

	function submitForm(methodValue)
	{
		if (!trimInputBox()) return false;
		if(!isDateValid) return;
		if(!validate()) {
			inRefreshing = false;
			return false;
		}
		document.forms[0].method.value=methodValue;
		document.forms[0].submit();
	}
	function validate() {
		var form = document.caseManagementViewForm;
		var stdt = form.elements['searchStartDate'].value;
		var endt = form.elements['searchEndDate'].value;
		if (endt != "" && stdt != "") {
			if(isBefore(endt,stdt)) {
				alert ("From date should not be after the To date");
				return false;
			}
		}
		return true;
	}
	function resetClientFields() {
		var form = document.caseManagementViewForm;
		form.elements['searchProviderNo'].value='';
		form.elements['searchServiceComponent'].value='';
		form.elements['searchCaseStatus'].value='';
		form.elements['searchStartDate'].value='';
		form.elements['searchEndDate'].value='';
		form.elements['searchProviderNo'].selectedIndex = 0;
		form.elements['searchCaseStatus'].selectedIndex = 0;
//		form.elements['searchCaseWorker'].selectedIndex = 0;
	}
	
	function clickTab(name) {
		document.caseManagementViewForm.tab.value=name;
		document.caseManagementViewForm.submit();
	}
	function popupNotePage(varpage) {
        var page = "" + varpage;
        windowprops = "height=800,width=800,location=no,"
          + "scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=50,screenY=50,top=0,left=0";
       var popup = window.open(page, "editNote", windowprops);
       if (popup != null) {
    		if (popup.opener == null) {
      		popup.opener = self;
    		}
    		popup.focus();
  		}
    }
    
    function popupHistoryPage(varpage) {
        var page = "" + varpage;
        windowprops = "location=no,"
          + "scrollbars=yes,menubars=no,toolbars=no,resizable=yes,top=0,left=0";
        window.open(page, "", windowprops);
    }
    
	function popupUploadPage(varpage,dn) {
        var page = "" + varpage+"?demographicNo="+dn;
        windowprops = "height=500,width=500,location=no,"
          + "scrollbars=no,menubars=no,toolbars=no,resizable=yes,top=50,left=50";
         var popup=window.open(page, "", windowprops);
         popup.focus();
        
    }
        
	function delay(time){
		var str="document.getElementById('ci').src='<c:out value="${ctx}"/>/images/default_img.jpg'";
		setTimeout(str,time);
	}
    
</script>

<html:form action="/CaseManagementView2">
	<html:hidden property="demographicNo" />	
	<input type="hidden" name="method" value="view" />	
	<table width="100%" height="100%">
	<tr>
	<td>
		<table width="100%">
			<tr>
				<th class="pageTitle" width="100%">Case Management Encounter</th>
			</tr>
			<tr>
				<td class="simple" style="background: lavender"><%@ include file="/PMmodule/ClientInfo.jsp" %></td>
			</tr>
			<tr>
				<td align="left" class="buttonBar2">
				<html:link action="/CaseManagementView2.do?method=close" style="color:Navy;text-decoration:none;">
				<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/Back16.png"/> />&nbsp;Back to Client Search&nbsp;&nbsp;|</html:link>

				<html:link	action="/CaseManagementView2.do?note_view=summary" paramId="clientId" paramName="clientId"	style="color:Navy;text-decoration:none;">
					&nbsp;Case Summary&nbsp;&nbsp;|
				</html:link> 
				<html:link action="/CaseManagementView2.do?note_view=detailed"  paramId="clientId" paramName="clientId"	style="color:Navy;text-decoration:none;">&nbsp;Case Detailed&nbsp;
				</html:link>
			    <c:if test="${currentIntakeProgramId>0}">
				<security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTCASE %>" orgCd='<%=((Integer) request.getSession().getAttribute("currentIntakeProgramId")).toString()%>' rights="<%=KeyConstants.ACCESS_WRITE %>">
					<html:link	action="/CaseManagementEntry2.do?method=edit&note_edit=new&from=casemgmt" style="color:Navy;text-decoration:none;">
						 |<img style="vertical-align: middle" border=0 src=<html:rewrite page="/images/New16.png"/> />&nbsp;New Note&nbsp;
					</html:link> 
				</security:oscarSec>
				</c:if>				
				</td>
			</tr>
		</table>
	</td></tr>
	<tr>
	<td>
			<div class="axial">
				<table border="0" cellspacing="1" cellpadding="3" width="100%">
					<tr>
						<th width="35%"><bean-el:message key="CaseSearch.dateRangeFrom"	bundle="pmm" nowrap /></th>
						<td width="15%"><quatro:datePickerTag property="searchStartDate" openerForm="caseManagementViewForm" width="120px"></quatro:datePickerTag></td>
						<th width="35%"><bean-el:message key="CaseSearch.dateRangeTo" 	bundle="pmm" /></th>
						<td><quatro:datePickerTag property="searchEndDate" width="120px" openerForm="caseManagementViewForm"></quatro:datePickerTag></td>
					</tr>
			
					<tr>
						<th><bean-el:message key="CaseSearch.provider" bundle="pmm"	nowrap /></th>
						<td>
							<html:select property="searchProviderNo">								
								<html:option value="">Any</html:option>
								<html:options collection="caseWorkers" property="code"	labelProperty="description" />
							</html:select>						
						</td>
						<th><bean-el:message key="CaseSearch.caseStatus" bundle="pmm"		nowrap /></th>
						<td>
							<html:select property="searchCaseStatus">
								<html:option value="">	</html:option>
								<html:options collection="caseStatusList" property="code"	labelProperty="description" nowrap />
							</html:select>
						</td>
					</tr>
					<tr>
						<th><bean-el:message key="CaseSearch.componentsOfService"	bundle="pmm" nowrap /></th>
						<td>
							<html:select property="searchServiceComponent">
								<html:option value="">	</html:option>
								<html:options collection="issues" property="code"	labelProperty="description" />
							</html:select>
						</td>
						<th>&nbsp;</th>						
						<td>
							<input type="button" name="search"	value="search" onclick="return deferedSubmit('search')" />&nbsp; 
							<input	type="button" name="reset" value="reset"	onclick="resetClientFields()" />
						</td>
					</tr>
				</table>
			</div>
	</td>
	</tr>
	<tr height="100%">
		<td>
		<div	style="color: Black; background-color: White; border-width: 1px; border-style: Ridge;   height: 100%; width: 100%; overflow: auto;" id="scrollBar">
			<c:if test="${note_view!='detailed'}">
						<display:table class="simple" cellspacing="2" cellpadding="3" id="note" name="Notes"  requestURI="/CaseManagementView2.do" >
							<display:setProperty name="paging.banner.placement" value="bottom" />
							<display:setProperty name="basic.msg.empty_list" value="No notes available" />
							<display:column>
										<c:choose>				
											<c:when test="${(!note.signed)}">
											 <security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTCASE %>" rights="<%=KeyConstants.ACCESS_READ %>">
												<a	href="<html:rewrite  action="/CaseManagementEntry2.do?method=edit&from=casemgmt"/>
													&noteId=<c:out value="${note.id}"/>&forceNote=true" style="color:Navy;text-decoration:none;">
												<img border="0" src="<c:out value="${ctx}"/>/images/edit_white.png" title="Edit/Sign Note" /> </a>
											</security:oscarSec>
											</c:when>			
											<c:when test="${note.signed  and (note.caseStatusId!=1 and note.locked !=true)}">
												 <security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTCASE %>" rights="<%=KeyConstants.ACCESS_READ %>">
													<a	href="<html:rewrite   action="/CaseManagementEntry2.do?method=edit&from=casemgmt"/>
														&noteId=<c:out value="${note.id}"/>&forceNote=true" style="color:Navy;text-decoration:none;">
													<img border="0" src="<c:out value="${ctx}"/>/images/edit_white.png" title="Edit/Sign Note" /> </a>
												</security:oscarSec>
											</c:when>
											<c:otherwise>
												<img src="<c:out value="${ctx}"/>/images/transparent_icon.gif" title=""/>
											</c:otherwise>	
										</c:choose>
										<c:choose>				
											<c:when test="${note.hasHistory or (note.signed and (note.caseStatusId ==1))}">
												<a	href="<html:rewrite  action="/CaseManagementEntry2.do?method=history&from=casemgmt" />
													&noteId=<c:out value="${note.id}"/>" 
													 style="color:Navy;text-decoration:none;" >
													<img border="0" src="<c:out value="${ctx}"/>/images/history.gif"	title="Note History" /> 
												</a>												
											</c:when>
											<c:otherwise>
												<img src="<c:out value="${ctx}"/>/images/transparent_icon.gif" title=""/>
											</c:otherwise>	
										</c:choose>
										<c:choose>
											<c:when test="${note.locked}">
												<a style="color:Navy;text-decoration:none;"	href='<html:rewrite action="/CaseManagementView2.do"/>?method=unlock&noteId=<c:out value="${note.id}"/>'> 
													<img border="0" src='<c:out value="${ctx}"/>/images/ulock.gif'	title="Unlock"  />
												</a>
											</c:when>
											<c:otherwise>
												<img src="<c:out value="${ctx}"/>/images/transparent_icon.gif" title=""/>
											</c:otherwise>	
										</c:choose>
	
							</display:column>
							<display:column property="observation_date" format="{0, date, yyyy/MM/dd}" sortable="true" title="Date" />
							<display:column property="id" sortable="true" title="Note ID" />
							<display:column property="providerName" sortable="true" title="Staff" />
							<display:column property="status" sortable="true" title="Status" />
						    <display:column property="programName" sortable="true" title="Program" />
						</display:table>
				</c:if>
				<c:if test="${note_view=='detailed'}">
					<c:if test="${not empty Notes}">
 						<table id="test" width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#C0C0C0">
							<%
								int index1 = 0;
								String bgcolor1 = "white";
							%>
							
							<c:forEach var="note" items="${Notes}">
								<%
									if (index1++ % 2 != 0) {
										bgcolor1 = "white";
									} else {
										bgcolor1 = "#EEEEFF";
									}
									java.util.List noteList = (java.util.List) request.getAttribute("Notes");
									String noteId = ((CaseManagementNote) noteList.get(index1 - 1)).getId().toString();
									request.setAttribute("noteId", noteId);
								%>
								<tr>
									<td>
									<table width="100%" border="0">
										<tr bgcolor="<%=bgcolor1 %>">
											<td width="7%">Provider</td>
											<td width="93%">
												<c:out	value="${note.provider.formattedName }" />
											</td>
										</tr>
										<tr bgcolor="<%=bgcolor1 %>">
											<td width="7%">Date</td>
											<td width="93%"><fmt:formatDate	pattern="yyyy-MM-dd hh:mm a" value="${note.observation_date}" /></td>
										</tr>
										<tr bgcolor="<%=bgcolor1 %>">
											<td width="7%">Status</td>
											<td width="93%"><c:out value="${note.status}" /></td>
										</tr>
										<tr bgcolor="<%=bgcolor1 %>">
											<td width="7%">Action</td>
											<td width="93%">
												<c:if test="${(!note.signed)}">
													<a href="<html:rewrite action="/CaseManagementEntry2.do?method=edit&from=casemgmt"/>
													&noteId=<c:out value="${note.id}"/>" >							
													Edit and Sign
												</a>
												</c:if>
												<c:if test="${note.signed  and (note.caseStatusId!=1 and note.locked !=true)}">
													 <security:oscarSec objectName="<%=KeyConstants.FUN_CLIENTCASE %>" rights="<%=KeyConstants.ACCESS_READ %>">
													<a href="<html:rewrite  action="/CaseManagementEntry2.do?method=edit&from=casemgmt"/>
														&noteId=<c:out value="${note.id}"/>" >	Edit and Sign
													</a>
													</security:oscarSec>
												</c:if>																								
												<c:if test="${note.hasHistory or (note.signed and (note.caseStatusId eq 1))}">
													<a	href="<html:rewrite   action="/CaseManagementEntry2.do?method=history&from=casemgmt" />
															&noteId=<c:out value="${note.id}"/>" 
															 style="color:Navy;text-decoration:none;" >
														<img border="0" src="<c:out value="${ctx}"/>/images/history.gif"
														title="Note History" /> 
													</a>
												</c:if>
												<c:if test="${note.locked}">
													<a href="<html:rewrite action="/CaseManagementEntry2.do?method=unlock"/>&noteId=<c:out value="${noteId}"/> ">Unlock
													</a>			
												</c:if>
										</td>
										</tr>
										<tr bgcolor="<%=bgcolor1 %>">
											<td width="7%">Note</td>
											<td width="93%">
												<c:choose>
												<c:when test="${note.locked}">
													<span style="color:red"><i>Contents Hidden</i></span>
												</c:when>
												<c:otherwise>
													<pre><c:out value="${note.note }" /></pre>
												</c:otherwise>
											</c:choose></td>
										</tr>
									</table>
									</td>
								</tr>
							</c:forEach>				
						</table>						
					</c:if>
				</c:if>
			</div>
		</td>
	</tr>
	</table>		
<input type="hidden" name="token" value="<c:out value="${sessionScope.token}"/>" /></html:form>
