<%--

    Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
    This software is published under the GPL GNU General Public License.
    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

    This software was written for the
    Department of Family Medicine
    McMaster University
    Hamilton
    Ontario, Canada

--%>
<%@ include file="/taglibs.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="oscar.oscarEncounter.oscarConsultationRequest.pageUtil.EctConsultationFormRequestUtil"%>
<%@ page import="oscar.OscarProperties" %>
<%@ page import="org.oscarehr.util.SpringUtils" %>
<%@ page import="org.oscarehr.common.model.*"%>
<%@ page import="oscar.oscarLab.ca.on.*"%>
<%@ page import="org.oscarehr.ticklers.web.TicklersUtil"%>
<%@ page import="org.oscarehr.common.dao.ViewDao" %>
<%@ page import="org.oscarehr.common.model.View,org.oscarehr.util.LocaleUtils" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="oscar.MyDateFormat" %>
<%@ page import="oscar.OscarProperties" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ taglib uri="/WEB-INF/security.tld" prefix="security"%>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/library/bootstrap/3.0.0/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/library/bootstrap/3.0.0/assets/css/DT_bootstrap.css">

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/datepicker.css">


<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/library/bootstrap/3.0.0/assets/js/DT_bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/bootstrap-datepicker.js"></script>

<%
	String roleName$ = (String)session.getAttribute("userrole") + "," + (String) session.getAttribute("user");
%>
<security:oscarSec roleName="<%=roleName$%>" objectName="_tasks" rights="r" reverse="<%=true%>" >
<%
	response.sendRedirect("../noRights.html");
%>
</security:oscarSec>
<%
String labReqVer = oscar.OscarProperties.getInstance().getProperty("onare_labreqver","07");
if(labReqVer.equals("")) {labReqVer="07";}
%>

 <%
 	 String user_no;
     user_no = (String) session.getAttribute("user");
     int  nItems=0;
     String strLimit1="0";
     String strLimit2="5";
     if(request.getParameter("limit1")!=null) strLimit1 = request.getParameter("limit1");
     if(request.getParameter("limit2")!=null) strLimit2 = request.getParameter("limit2");


     ViewDao viewDao =  (ViewDao) SpringUtils.getBean("viewDao");
    

     String role = (String)request.getSession().getAttribute("userrole");

     View v;
     String providerview;
     String assignedTo;
     String mrpview;
     if( request.getParameter("providerview")==null ) {
             providerview = "all";
     } else {
         providerview = request.getParameter("providerview");
     }

     if( request.getParameter("assignedTo") == null ) {
             assignedTo = "all";
     }
     else {
         assignedTo = request.getParameter("assignedTo");
     }
     
     if( request.getParameter("mrpview") == null ) {
   	 	mrpview = "all";
     } else {
   	  	mrpview = request.getParameter("mrpview");
     }
 %>

<%
	Calendar now=Calendar.getInstance();
  int curYear = now.get(Calendar.YEAR);
  int curMonth = (now.get(Calendar.MONTH)+1);
  int curDay = now.get(Calendar.DAY_OF_MONTH);
%>
<%
   String ticklerview;
   if( request.getParameter("ticklerview") == null ) {
          ticklerview = "A";
  }
  else {
      ticklerview = request.getParameter("ticklerview");
  }


  String xml_vdate;
   if( request.getParameter("xml_vdate") == null ) {
          xml_vdate = "";
  }
  else {
      xml_vdate = request.getParameter("xml_vdate");
  }

  String xml_appointment_date;
   if( request.getParameter("xml_appointment_date") == null ) {
          xml_appointment_date = MyDateFormat.getMysqlStandardDate(curYear, curMonth, curDay);
  }
  else {
      xml_appointment_date = request.getParameter("xml_appointment_date");
  }


  java.util.Locale vLocale =(java.util.Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);

  String stActive = LocaleUtils.getMessage(request.getLocale(), "tickler.ticklerMain.stActive");
  String stComplete = LocaleUtils.getMessage(request.getLocale(), "tickler.ticklerMain.stComplete");
  String stDeleted = LocaleUtils.getMessage(request.getLocale(), "tickler.ticklerMain.stDeleted");
%>

<div id="tickler-list">
	<h4 style="display: inline">Tickler List</h4> 
	<br /> <br />
<%
	String curProvider_no = (String) session.getAttribute("user");
    String basePath = request.getContextPath();
	String userName = request.getParameter("userName");
	String providerNo = request.getParameter("providerNo");
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	String today = formatter.format(new Date());
%>

<%
	boolean ticklerEditEnabled = Boolean.parseBoolean(OscarProperties.getInstance().getProperty("tickler_edit_enabled")); 
%>


<style>
	.datepicker {z-index: 9999;}
	.date-input {width: 80px;}
	#ticklerList_length {display: inline-block !important;}
	.hidden {display: none;}
	#search-options{margin-left: 20px;}
	
	div.notallowed:hover {
    	background: none repeat scroll 0 0 rgba(255, 255, 255, 0);
    	border: 1px solid rgba(237, 237, 237, 0);
    	color: #6F289C;
	}	
	
	span.notallowed {
	    cursor: not-allowed;
	    opacity: 0.35;
	}	
	
	span.notallowed .ticklerbtn {
	    cursor: not-allowed;
	    opacity: 0.35;
	}	
	
	.ticklerbtn {
	    -moz-user-select: none;
	    cursor: pointer;
	    display: inline-block;
	    position: relative;
	    text-align: center;
	    vertical-align: middle;
	}	
</style>

<table class="table table-striped table-hover" id="ticklerList">
	<tfoot>
		<tr>
			<td colspan="5" class="white">
			</td>
			<td colspan="5">
				<div id="ticklerButtonsDivId" style="display:none;">
					<div>
						<span data-action='add tickler' title='<bean:message key="tickler.ticklerMain.btnAddTickler"/>' role='button' id='addTicklerId' class='ticklerbtn'> 
							<img class='icon-plus-sign' title='<bean:message key="tickler.ticklerMain.btnAddTickler"/>' border='0'/>
							<span id='deleteTicklerTextId'><bean:message key="tickler.ticklerMain.btnAddTickler"/></span> 
						</span>				
						<input type='hidden' name='submit_form' value=''>
						<span id="spanNotAllowedId" class="notallowed">
							<%if (ticklerview.compareTo("D") == 0){%>
								<span data-action='delete completely' title='<bean:message key="tickler.ticklerMain.btnEraseCompletely"/>' role='button' id='btnEraseCompletelyId' class='ticklerbtn'> 
									<img class='icon-trash' title='<bean:message key="tickler.ticklerMain.btnEraseCompletely"/>' border='0'/>
									<span id='deleteTicklerTextId'><bean:message key="tickler.ticklerMain.btnEraseCompletely"/></span> 
								</span>				
							<%} else{%>
								<span data-action='complete' title='<bean:message key="tickler.ticklerMain.btnComplete"/>' role='button' id='btnCompleteId' class='ticklerbtn'> 
									<img class='icon-ok' title='<bean:message key="tickler.ticklerMain.btnComplete"/>' border='0'/>
									<span id='completeTicklerTextId'><bean:message key="tickler.ticklerMain.btnComplete"/></span> 
								</span>				
								<span data-action='delete' title='<bean:message key="tickler.ticklerMain.btnDelete"/>' role='button' id='btnDeleteId' class='ticklerbtn'> 
									<img class='icon-trash' title='<bean:message key="tickler.ticklerMain.btnDelete"/>' border='0'/>
									<span id='deleteTicklerTextId'><bean:message key="tickler.ticklerMain.btnDelete"/></span> 
								</span>				
							<%}%>
						</span>
					</div>
				</div>
			</td>
		</tr>
	</tfoot>
</table>
</div>

<input type="hidden" id="userName" value="<%=userName%>" />
<input type="hidden" id="providerNo" value="<%=providerNo%>" />

<!-- Modal -->
<div id="searchModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="searchModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3 id="searchModalLabel"><bean:message key="ticklerList.searchOptions" /></h3>
	</div>
<table>
	<tbody>
		<tr>
			<td width="10%"></td>
			<td width="20%">    
				<div class="modal-body" style="text-align: center">
					<table>
						<tr>
							<td style="text-align: left"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#333333"><b><bean:message key="ticklerList.startDate" />:</b></font> </td>
							<td style="text-align: left">
								<div class="input-append date" id="date-start" data-date="<%=today%>" data-date-format="dd-mm-yyyy">
								<input size="16" type="text" class="date-input" name="startDate" id="startDate"> <span class="add-on"><i
									class="icon-calendar"></i></span>
								</div>
							</td>
						</tr>
						<tr>
							<td style="text-align: left">
								<font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#333333"><b><bean:message key="ticklerList.endDate" />:</b></font> 
							</td>
							<td style="text-align: left">
								<div class="input-append date" id="date-end" data-date="<%=today%>" data-date-format="dd-mm-yyyy">
									<input size="16" type="text" class="date-input" name="endDate" id="endDate"> <span class="add-on"><i class="icon-calendar"></i></span>
								</div>			
							</td>
						</tr>
						<tr>
							<td style="text-align: left">
								<font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#333333"><b><bean:message key="tickler.ticklerMain.formMoveTo"/> </b></font>
							</td>
							<td>
						        <select id="ticklerStatusId" name="ticklerStatus">
							        <option value="A" <%=ticklerview.equals("A")?"selected":""%>><bean:message key="tickler.ticklerMain.formActive"/></option>
							        <option value="C" <%=ticklerview.equals("C")?"selected":""%>><bean:message key="tickler.ticklerMain.formCompleted"/></option>
							        <option value="D" <%=ticklerview.equals("D")?"selected":""%>><bean:message key="tickler.ticklerMain.formDeleted"/></option>                   
						        </select>							
							</td>
						</tr>
						<tr>
							<td style="text-align: left">
								<font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#333333"><b>MRP:</b></font> 
							</td>
							<td>
					           <% 
					       		TicklersUtil ticklersUtil = new TicklersUtil();
					           	List<Provider> providersActive = ticklersUtil.getActiveProviders();
								if(providersActive != null && providersActive.size()>0) {%>
							        <select id="mrpId" name="mrp" size="4" multiple="multiple">
							        	<%--<option value="all" <%=mrpview.equals("all")?"selected":""%>><bean:message key="tickler.ticklerMain.formAllProviders"/></option> --%>
							        	<%
							            for (Provider p : providersActive) {%>
								        	<option value="<%=p.getProviderNo()%>" <%=mrpview.equals(p.getProviderNo())?"selected":""%>><%=p.getLastName()%>,<%=p.getFirstName()%></option>
								        <%}%>
							        </select>				
								<%}%>
							
							</td>
						</tr>
						<tr>
							<td style="text-align: left">
								<font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#333333"><b><bean:message key="tickler.ticklerMain.msgCreator"/>: </b></font>
							</td>
							<td>
								<%if(providersActive != null && providersActive.size()>0) {%>
							        <select id="providerId" name="provider" size="4" multiple="multiple">
							        	<%for (Provider p : providersActive) {%>
							        		<option value="<%=p.getProviderNo()%>" <%=providerview.equals(p.getProviderNo())?"selected":""%>><%=p.getLastName()%>,<%=p.getFirstName()%></option>
							        	<%}%>
							        </select>		
								<%}%>
							
							</td>
						</tr>
						<tr>
							<td style="text-align: left">
								<font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#333333"><b><bean:message key="tickler.ticklerMain.msgAssignedTo"/>:</b></font>
							</td>
							<td>
							<%
								if (org.oscarehr.common.IsPropertiesOn.isMultisitesEnable()) { 
								    List<Site> sites = ticklersUtil.getSites(user_no);
								    if(sites != null && sites.size()>0) {
									%>
							    	<script>
										var _providers = [];
										<%for (int i=0; i<sites.size(); i++) {%>
											_providers["<%=sites.get(i).getSiteId()%>"]="
											<%Iterator<Provider> iter = sites.get(i).getProviders().iterator();
											while (iter.hasNext()) {
												Provider p=iter.next();
												if ("1".equals(p.getStatus())) {%>
													<option value='<%=p.getProviderNo()%>'><%=p.getLastName()%>, <%=p.getFirstName()%>
													</option>
												<%}
											}%>";
										<%}%>
										function changeSite(sel) {
											sel.form.assignedTo.innerHTML=sel.value=="none"?"":_providers[sel.value];
										}
									</script>
								 	<select id="siteId" name="site" onchange="changeSite(this)" size="4" multiple="multiple">
						      			<%-- <option value="none">---select clinic---</option>--%>
							      		<% for (int i=0; i<sites.size(); i++) { %>
							      		 	<option value="<%=sites.get(i).getSiteId()%>" <%=sites.get(i).getSiteId().toString().equals(request.getParameter("site"))?"selected":""%>><%=sites.get(i).getName()%></option>
										<%}%>
							      	</select>
									<%	if (request.getParameter("assignedTo")!=null) {%>
								      		<script>
								     			changeSite(document.getElementById("siteId"));
								      			document.getElementById("assignedTo").value='<%=request.getParameter("assignedTo")%>';
								      		</script>
									<% }
								    }// multisite end ==========================================
								  } else {%>
									<%
									if(providersActive != null && providersActive.size()>0) {%>
								        <select id="assignedToId" name="assignedTo" size="4" multiple="multiple">
								       		<%-- <option value="all" <%=assignedTo.equals("all")?"selected":""%>><bean:message key="tickler.ticklerMain.formAllProviders"/></option>--%>
								        	 
								         	<%for (Provider p : providersActive) { %>
								        		<option value="<%=p.getProviderNo()%>" <%=assignedTo.equals(p.getProviderNo())?"selected":""%>><%=p.getLastName()%>, <%=p.getFirstName()%></option>
								        	<%}%>
								        </select>
								<%	}
								}%>			
						 	</td>
						 </tr>
					</table>
				</div>
			</td>
		</tr>
	</tbody>
</table>
	<div class="modal-footer">
		<input type="button" in="closeDiv" class="btn" data-dismiss="modal" aria-hidden="true" value="<bean:message key='global.close' />">
		<input id="search" type="button" in="closeDiv" class="btn btn-primary" data-dismiss="modal" aria-hidden="true" value="<bean:message key='global.search' />"/>
	</div>
</div>


 <div id="note-form" title="Tickler Note" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="noteModalLabel" aria-hidden="true">
 	<form>
		<input type="hidden" name="tickler_note_demographicNo" id="tickler_note_demographicNo" value=""/>	
		<input type="hidden" name="tickler_note_ticklerNo" id="tickler_note_ticklerNo" value=""/>	
		<input type="hidden" name="tickler_note_noteId" id="tickler_note_noteId" value=""/>	
	 	<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h4 id="noteModalLabel">Tickler Note</h4>
		</div>

		<div style="text-align: center;padding:2px" class="modal-body">
			<table width="100%">
				<tbody>
					<tr>
						<td>
							<textarea id="tickler_note" name="tickler_note" rows="8" cols="100" style="width:90%;height:80%"></textarea>		
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="modal-footer" style="padding: 5px 15px 0px">
		
			<table>
				<tr>
					<td align="left">
						<a href="javascript:void()" onclick="saveNoteDialog();return false;">
							<img src="<%=request.getContextPath()%>/oscarEncounter/graphics/note-save.png"/>
						</a>
						<a href="javascript:void()" in="closeDiv" class="btn" data-dismiss="modal" aria-hidden="true" onclick="closeNoteDialog();return false;">
							<img src="<%=request.getContextPath()%>/oscarEncounter/graphics/system-log-out.png"/>
						</a>
						
					</td>
					<td align="right" style="width:40%" nowrap="nowrap">
						Date: <span id="tickler_note_obsDate"></span> rev <a id="tickler_note_revision_url" href="javascript:void(0)" onClick=""><span id="tickler_note_revision"></span></a><br/>
						Editor: <span id="tickler_note_editor"></span>
					</td>
				</tr>
			</table>
		</div>	
	</form>	
</div>

<script type="text/javascript">
$(document).ready(function () {
	var withOption = false;
	var startDate, endDate, ticklerStatusId, mrpIds, providerIds, siteIds, assignedToIds;

	var dataTable= $('#ticklerList').dataTable({
		"bProcessing": true,
        "bServerSide": true,           
        "sAjaxSource": "<%=basePath%>/tickler2/Ticklers.do",
		"aLengthMenu": [ 10, 25, 50, 100 ],
		"bFilter": true,
        "aoColumns": [
			{"sTitle":"<input type='checkbox' id='selectAll' onclick='toggleChecks(this);' /> <span id='allNone'>All</span>","mData":null, "sWidth": "60px", "bSortable":false,"bSearchable":false,"mRender":function(data, type, row) {
				return "<input type='checkbox' name='ticklerIdChkbox' class='chk' value='" + row.id + "'/>";
			}, "sClass": "center" },
			{"sTitle":"<bean:message key='tickler.ticklerMain.msgDemographicName'/>","mData":"demographicName", "mRender":function(data, type, row) {
				return "<a href='#' onClick='popupOscarTicklerConfig(700,960,\"<%=request.getContextPath()%>/demographic/demographiccontrol.jsp?demographic_no=" + row.demographicNo + "&displaymode=edit&dboperation=search_detail\")'>" + row.demographicName + "</a>";
			}, "sClass": "center" },
			{ "sTitle": "<bean:message key='tickler.ticklerMain.msgCreator'/>", "mData": "providerName","mRender":function(data, type, row) {
				var returnVal = row.providerName;
 		    	
				if(row.ticklerComments.length>0) {
					for(var i=0;i<row.ticklerComments.length;i++) {
						returnVal = returnVal + "<br/>" + row.ticklerComments[i].providerName;
					}
				}
 		    	
 		    	return returnVal;
			}, "sClass": "center" },
 			{ "sTitle": "<bean:message key='tickler.ticklerMain.msgDate'/>", "mData": "serviceDate", "sClass": "center" },
 			{ "sTitle": "<bean:message key='tickler.ticklerMain.msgCreationDate'/>", "mData": "updateDate","mRender":function(data, type, row) {
				var returnVal = row.updateDate;
 		    	
				if(row.ticklerComments.length>0) {
					for(var i=0;i<row.ticklerComments.length;i++) {
						returnVal = returnVal + "<br/>" + row.ticklerComments[i].updateDateTime;
					}
				}
 		    	
 		    	return returnVal;
			}, "sClass": "center" },
 		    { "sTitle": "<bean:message key='tickler.ticklerMain.Priority'/>", "mData": "priority",  "sClass": "center" },
 		    { "sTitle": "<bean:message key='tickler.ticklerMain.taskAssignedTo'/>", "mData": "assigneeName",  "sClass": "center" },
 		    { "sTitle": "<bean:message key='tickler.ticklerMain.msgStatus'/>", "mData": "status",  "sClass": "center" },
 		    { "sTitle": "<bean:message key='tickler.ticklerMain.msgMessage'/>", "mData": "message", "mRender":function(data, type, row) {
				var returnVal = row.message;		    	
				if(row.ticklerHRefs.length>0) {
					for(var i=0;i<row.ticklerHRefs.length;i++) {
						returnVal = returnVal + "&nbsp;" + row.ticklerHRefs[i];
					}
				}

				if(row.ticklerComments.length>0) {
					for(var i=0;i<row.ticklerComments.length;i++) {
						returnVal = returnVal + "<br/>" + row.ticklerComments[i].message;
					}
				}
				
 		    	return returnVal;
			}, "sClass": "center" },
			{"sTitle":"<bean:message key='ticklerList.header.action' />","mData":null, "bSortable":false,"bSearchable":false,"mRender":function(data, type, row) {
	         <% if (ticklerEditEnabled || true) {%>
           		return	"<a href='#' onClick='popupOscarTicklerConfig(700,960,\"<%=request.getContextPath()%>/tickler/ticklerEdit.jsp?tickler_no=" + row.id + "&displaymode=edit&dboperation=search_detail\")'><img class='icon-edit' title='<bean:message key="ticklerList.editTickler" />' border='0'/></a>&nbsp;&nbsp;" +
           		"<a href='#' onClick='openNoteDialog(" + row.demographicNo + ","+ row.id +")'><img class='icon-comment' title='<bean:message key="ticklerList.addTicklerNote" />' border='0'/></a>";
        	<%} else {%>				
				return "<a href='#' onClick='openNoteDialog(" + row.demographicNo + ","+ row.id +")'><img class='icon-comment' title='<bean:message key="ticklerList.addTicklerNote" />' border='0'/></a>";
			<%}%>
			}, "sClass": "center" },		
		],
		"fnServerParams": function ( aoData ) {
			startDate = $("#startDate").val();
			endDate = $("#endDate").val();
			ticklerStatusId = $("#ticklerStatusId").val();
			mrpIds = $("#mrpId").val();
	        providerIds = $("#providerId").val();
		 	siteIds = $("#siteId").val();
	        assignedToIds = $("#assignedToId").val();
			
	        if(mrpIds == null || mrpIds === null || typeof mrpIds == 'undefined') {
	        	mrpIds = "";
	        } 
	        
	        if(providerIds == null || providerIds === null || typeof providerIds == 'undefined') {
	        	providerIds = "";
	        }

	        if(siteIds == null || siteIds === null || typeof siteIds == 'undefined') {
	        	siteIds = "";
	        }

	        if(assignedToIds == null || assignedToIds === null || typeof assignedToIds == 'undefined') {
	        	assignedToIds = "";
	        }
	        
			aoData.push( { "name": "startDate", "value": startDate } );
			aoData.push( { "name": "endDate", "value": endDate } );
			aoData.push( { "name": "status", "value": ticklerStatusId } );
			aoData.push( { "name": "mrpIds", "value": mrpIds } );
			aoData.push( { "name": "providerIds", "value": providerIds } );
			aoData.push( { "name": "siteIds", "value": siteIds } );
			aoData.push( { "name": "assignedToIds", "value": assignedToIds } );
			aoData.push( { "name": "withOption", "value": withOption } );
		}
	});

	//The patch Boot3/Datatables patch - insert after you initialise dataTable
	$('div.dataTables_filter label select').addClass('form-control');
	$('div.dataTables_filter label input').addClass('form-control').css({"width" : "200px","margin-right" : "0px"});
	//The patch Boot3/Datatables patch -end
	
	
	var options = $('<a href="#" class="btn btn-default" id="search-options" style="margin-left:0px">options <span class="caret"></span></a>');
	options.appendTo('div.dataTables_filter label');	
	$("#search-options").click(function() {
		$('#searchModal').modal('show');	
	});
	$('#date-start').datepicker({
		format: "yyyy-mm-dd"
	});
	$('#date-end').datepicker({
		format: "yyyy-mm-dd"
	});
	
	$("#search").on("click", function() {
		withOption = true;
		dataTable._fnAjaxUpdate();
	});	
	 
	$('#ticklerList_length').after($('#ticklerButtonsDivId').html());
	
	$("#btnCompleteId").on("click", function() {
		doAjaxPost("complete",dataTable);
	});	
	
	$("#btnDeleteId").on("click", function() {
		doAjaxPost("delete",dataTable);
	}); 
	
	$("#addTicklerId").on("click", function() {
		popupOscarTicklerConfig('400','600', '<%=request.getContextPath()%>/tickler/ticklerAdd.jsp');
	});	


	$('#ticklerList').on("click", ".chk", function (e) {
		var selected = $(this).is(':checked');
	    if($(this).is(':checked')) {
	    	$("#spanNotAllowedId").removeClass("notallowed");			
		} else {
			//alert($("#ticklerList input:checked").length);
		
			if($("#ticklerList input:checked").length == 0) {
	    		$("#spanNotAllowedId").removeClass("notallowed");
	    		$("#spanNotAllowedId").addClass("notallowed");	
			}				
		}
		
	});	
	
});

function toggleChecks(obj) {
    $('.chk').prop('checked', obj.checked);
    
    if(obj.checked) {
    	$("#allNone").text('None');
    	$("#spanNotAllowedId").removeClass("notallowed");
    }else {
    	$("#allNone").text('All');
    	$("#spanNotAllowedId").removeClass("notallowed");
    	$("#spanNotAllowedId").addClass("notallowed");
    }
}

function doAjaxPost(method,dataTable) {

    var selectedArray = [];
    $("#ticklerList input:checked").each(function(){
    	selectedArray.push("checkbox=" + $(this).val());
    });
    var data = selectedArray.join('&');
    data = data + "&method=" + method
    $.ajax({
        type: "POST",
        url: "<%=basePath%>/tickler2/TicklerMain.do",
        data: data,
        success: function(response){
            console.info("Success");
            dataTable._fnAjaxUpdate();
        },
        error: function(e){
            alert('Error: ' + e);
        }
    });
}

function reportWindow(page) {
    windowprops="height=660, width=960, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes, top=0, left=0";
    var popup = window.open(page, "labreport", windowprops);
    popup.focus();
}

function preview(id) {
	var url = '<%=basePath%>/oscarEncounter/ViewRequest.do?requestId='+id;
    var windowprops = "height=700,width=960,location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";
    window.open(url, "viwe", windowprops);
}

function popupOscarTicklerConfig(vheight,vwidth,varpage) { //open a new popup window
	var page = varpage;
	windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";
	var popup=window.open(varpage, "<bean:message key="oscarEncounter.oscarConsultationRequest.ViewConsultationRequests.msgConsConfig"/>", windowprops);
	if (popup != null) {
		if (popup.opener == null) {
	    	popup.opener = self;
	    }
  	}
}

function openNoteDialog(demographicNo, ticklerNo) {
	$("#tickler_note_demographicNo").val(demographicNo);
	$("#tickler_note_ticklerNo").val(ticklerNo);
	

	$("#tickler_note_noteId").val('');
	$("#tickler_note").val('');
	$("#tickler_note_revision").html('');
	$("#tickler_note_revision_url").attr('onclick','');
	$("#tickler_note_editor").html('');
	$("#tickler_note_obsDate").html('');
		
	//is there an existing note?
	$.ajax({url:'<%=basePath%>/CaseManagementEntry.do',
		data: { method: "ticklerGetNote", ticklerNo: jQuery('#tickler_note_ticklerNo').val()  },
		async:false, 
		dataType: 'json',
		success:function(data) {
			if(data != null) {
				$("#tickler_note_noteId").val(data.noteId);
				$("#tickler_note").val(data.note);
				$("#tickler_note_revision").html(data.revision);
				$("#tickler_note_revision_url").attr('onclick','window.open(\'<%=basePath%>/CaseManagementEntry.do?method=notehistory&noteId='+data.noteId+'\');return false;');
				$("#tickler_note_editor").html(data.editor);
				$("#tickler_note_obsDate").html(data.obsDate);
			}
		},
		error: function(jqXHR, textStatus, errorThrown ) {
			//alert(errorThrown);
		}
		});

	$("#note-form").modal('show');
}

function closeNoteDialog() {
	$("#note-form").modal('hide');
}
function saveNoteDialog() {
	//alert('not yet implemented');
	$.ajax({url:'<%=basePath%>/CaseManagementEntry.do',
		data: { method: "ticklerSaveNote", noteId: jQuery("#tickler_note_noteId").val(), value: jQuery('#tickler_note').val(), demographicNo: jQuery('#tickler_note_demographicNo').val(), ticklerNo: jQuery('#tickler_note_ticklerNo').val()  },
		async:false, 
		success:function(data) {
		 // alert('ok');		  
		},
		error: function(jqXHR, textStatus, errorThrown ) {
			alert(errorThrown);
		}
		});	
	
	$("#note-form").modal('hide');
}


</script>
