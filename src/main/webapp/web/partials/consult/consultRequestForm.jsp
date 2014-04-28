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
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="oscar.util.StringUtils"%>
<%@ page import="oscar.OscarProperties"%>
<%@ page import="org.oscarehr.util.LoggedInInfo"%>
<%@ page import="org.oscarehr.util.DigitalSignatureUtils"%>
<%@ page import="org.oscarehr.ui.servlet.ImageRenderingServlet"%>
<%@ page import="oscar.oscarEncounter.oscarConsultationRequest.pageUtil.EctConsultationFormRequestUtil"%>
<%@ page import="org.oscarehr.casemgmt.service.CaseManagementManager"%>
<%@ page import="org.springframework.web.context.WebApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="oscar.util.UtilDateUtilities"%>
<%@ page import="org.oscarehr.casemgmt.model.Issue"%>
<%@ page import="org.oscarehr.casemgmt.model.CaseManagementNote"%>
<%@ page import="org.oscarehr.common.model.UserProperty"%>
<%@ page import="org.oscarehr.common.dao.UserPropertyDAO"%>

<%@ taglib uri="/WEB-INF/security.tld" prefix="security"%>

<!DOCTYPE html>
<!-- ng* attributes are references into AngularJS framework -->
<html lang="en" ng-app="oscarProviderViewModule">
<head>
<title>Consult Request Form</title>
<meta name="viewport" content="width=device-width, user-scalable=false;">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/library/bootstrap/3.0.0/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/library/bootstrap/3.0.0/assets/css/DT_bootstrap.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/datepicker.css">

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/library/bootstrap/3.0.0/assets/js/DT_bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/check_hin.js"></script>

<script src="<%=request.getContextPath()%>/library/bootstrap/3.0.0/js/bootstrap.min.js"></script>
<script src="<%=request.getContextPath()%>/library/hogan-2.0.0.js"></script>
<script src="<%=request.getContextPath()%>/library/typeahead.js/typeahead.min.js"></script>
<script src="<%=request.getContextPath()%>/library/angular.min.js"></script>
<script src="<%=request.getContextPath()%>/library/angular-route.min.js"></script>
<script src="<%=request.getContextPath()%>/library/angular-resource.min.js"></script>

<!-- we'll combine/minify later -->
<script src="<%=request.getContextPath()%>/web/js/app.js"></script>
<script src="<%=request.getContextPath()%>/web/js/consultDetailController.js"></script>
<style>
	.datepicker {z-index: 9999;}
	.date-input {width: 80px;}
	.hidden {display: none;}
	.clear {clear: both;}
	.inline {display: inline;}
	.right {float: right;}
	.dialog {width: 60%; height: 50%; background-color: white; margin: 0 auto; overflow-y: none;}
	.btn-large {padding: 11px 19px; font-size: 17.5px;}
	body {padding-bottom: 50px;}
	.wrapper-action {
	    background-color: #FFFFFF;
	    border: 1px solid #FFFFFF;
	    bottom: 0;
	    opacity: 0.4;
	    padding-bottom: 4px;
	    padding-top: 4px;
	    position: fixed;
	    text-align: center;
	    width: 100%;
	    z-index: 999;
	}
	.wrapper-action:hover{
		background-color:#f5f5f5;
		border: 1px solid #E3E3E3;
		box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05) inset;
		opacity:1;
		filter:alpha(opacity=100); /* For IE8 and earlier */
	}
	#scrollToTop{
	   display:none;
	   position: absolute;
	   right: 10px;
	}
	#scrollToTop a{
		text-decoration:none;
		color:#333;
		opacity:0.6;
		filter:alpha(opacity=60); /* For IE8 and earlier */
	}
	#scrollToTop a:hover{
		text-decoration:none;
		opacity:1.0;
		filter:alpha(opacity=100); /* For IE8 and earlier */
	}
	input.ng-invalid, select.ng-invalid, textarea.ng-invalid {
		border: 1px solid red;
	}
</style>
<script type="text/javascript">
function printPreview(id) {
	var prtContent = document.getElementById(id);
	var printWindow = window.open('', '', 'letf=0,top=0,width=1200,height=800,toolbar=0,scrollbars=0,status=0');
	
	printWindow.document.write('<head>');
	printWindow.document.write('<title>Consult Request Form</title>');
	printWindow.document.write('<meta name="viewport" content="width=device-width, user-scalable=false;">');
	printWindow.document.write('<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/library/bootstrap/3.0.0/css/bootstrap.min.css">');
	
	printWindow.document.write('<style>');
	printWindow.document.write('.datepicker {z-index: 9999;}');
	printWindow.document.write('.date-input {width: 80px;}');
	printWindow.document.write('.clear {clear: both;}');
	printWindow.document.write('.inline {display: inline;}');
	printWindow.document.write('.right {float: right;}');
	printWindow.document.write('.btn-large {padding: 11px 19px; font-size: 17.5px;}');
	printWindow.document.write('</style>');
	printWindow.document.write('</head>');
	printWindow.document.write('<body>');
	printWindow.document.write(prtContent.innerHTML);
	printWindow.document.write('</body>');
	printWindow.document.close();
	printWindow.focus();
	printWindow.print();
	printWindow.close();
}
</script>
<noscript>Your browser either does not support JavaScript, or has it turned off.</noscript>
</head>

<body id="consultRequestForm" ng-controller="ConsultDetailCtrl as detailController">
<%
// String providerNo = (String) session.getAttribute("user");
String providerNo = request.getParameter("providerNo");
String demo = request.getParameter("demographicNo");
String date = UtilDateUtilities.getToday("yyyy-MM-dd");
// Signature
String signatureRequestId=DigitalSignatureUtils.generateSignatureRequestId(LoggedInInfo.loggedInInfo.get().loggedInProvider.getProviderNo());
String imageUrl=request.getContextPath()+"/imageRenderingServlet?source="+ImageRenderingServlet.Source.signature_preview.name()+"&"+DigitalSignatureUtils.SIGNATURE_REQUEST_ID_KEY+"="+signatureRequestId;
String storedImgUrl=request.getContextPath()+"/imageRenderingServlet?source="+ImageRenderingServlet.Source.signature_stored.name()+"&digitalSignatureId=";

// User Agent
String userAgent = request.getHeader("User-Agent");
String browserType = "";
if (userAgent != null) {
	if (userAgent.toLowerCase().indexOf("ipad") > -1) {
		browserType = "IPAD";
	} else {
		browserType = "ALL";
	}
}

ArrayList<String> users = (ArrayList<String>)session.getServletContext().getAttribute("CaseMgmtUsers");
boolean useNewCmgmt = false;
WebApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
CaseManagementManager cmgmtMgr = null;
if (users != null && users.size() > 0 && (users.get(0).equalsIgnoreCase("all") || Collections.binarySearch(users, providerNo) >= 0))
{
	useNewCmgmt = true;
	cmgmtMgr = (CaseManagementManager)ctx.getBean("caseManagementManager");
}
UserPropertyDAO userPropertyDAO = (UserPropertyDAO)ctx.getBean("UserPropertyDAO");
UserProperty fmtProperty = userPropertyDAO.getProp(providerNo, UserProperty.CONSULTATION_REQ_PASTE_FMT);
String pasteFmt = fmtProperty != null?fmtProperty.getValue():null;

%>
<div class="col-md-12">
	<h1>Consultation Details</h1>
</div>
<form name="consultRequestForm" action="consultRequestAction.jsp" method="post">
	<input type="hidden" ng-model="consult.id"/>
	<input type="hidden" name="consult.providerNo" value="<%=providerNo %>" />
	
	<div id="left_pane" class="col-md-2">
		<h3>Patient Details</h3>
		<div class="demographic">
			<p>{{demographic.lastName}}, {{demographic.firstName}} ({{demographic.title}})</p>
			<p>DOB: {{demographic.dateOfBirth | date:'yyyy-MM-dd'}} ({{demographic.age}})</p> 		
			<p>Sex: {{demographic.sexDesc}}</p> 
			<p>HIN: {{demographic.hin}} - {{demographic.ver}}</p> 
			<p>Address:</p> 
			<address>
			{{demographic.address.address}}<br/>
			{{demographic.address.city}}, {{demographic.address.province}}, {{demographic.address.postal}}<br>
			</address>
			<p>Phone (H): {{demographic.phone}}</p>
			<p>Phone (W): {{demographic.alternativePhone}}</p>
			<p>Email: {{demographic.email}}</p>
			<p>MRP: {{demographic.provider.firstName}}, {{demographic.provider.lastName}}</p>
		</div>
		<div class="demographic" style="display: none;">
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Last Name" ng-model="demographic.lastName" ng-required="true"/>
			</div>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="First Name" ng-model="demographic.firstName" ng-required="true"/>
			</div>
			<div class="form-group">
				<select class="form-control" ng-model="demographic.title" style="width: 45%; display: inline-block;">
					<option value="{{title.value}}" ng-repeat="title in titles">{{title.name}}</option>
				</select>
				<select class="form-control" ng-model="demographic.sex" style="width: 45%; display:inline-block;">
					<option value="{{gender.value}}" ng-repeat="gender in genders">{{gender.name}}</option>
				</select>
			</div>
			<label class="control-label">DOB:</label>
			<input id="dp-dateOfBirth" type="text" class="form-control" ng-model="demographic.dateOfBirth" data-date-format="yyyy-mm-dd" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$" placeholder="Date Of Birth" ng-required="true"/>
			<label class="control-label">HIN:</label>
			<div class="form-group">
				<input id="hin" type="text" class="form-control" placeholder="HIN" ng-model="demographic.hin" />
			</div>
			<label class="control-label">HIN Version:</label>
			<div class="form-group">
				<input id="ver" type="text" class="form-control" placeholder="Version" ng-model="demographic.ver" />
			</div>
			<label class="control-label">Address:</label>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Address" ng-model="demographic.address.address" />
				<input type="text" class="form-control" placeholder="City" ng-model="demographic.address.city" />
				<select id="province" class="form-control" ng-model="demographic.address.province">
					<option value="{{province.value}}" ng-repeat="province in provinces">{{province.name}}</option>
				</select>
				<input type="text" class="form-control" placeholder="Postcode" ng-model="demographic.address.postal" />
			</div>
			<label class="control-label">Phone:</label>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Home Phone" ng-model="demographic.phone" />
				<input type="text" class="form-control" placeholder="Work Phone" ng-model="demographic.alternativePhone" />
			</div>
			<label class="control-label">Email:</label>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Email" ng-model="demographic.email" />
			</div>
			<label class="control-label">MRP:</label>
			<div class="form-group">
				MRP: {{demographic.provider.firstName}}, {{demographic.provider.lastName}}
			</div>
		</div>
		<p><button id="changeDemographic" type="button" class="btn btn-small toggle" rel="demographic"><i class="icon-edit-sign"></i> Change</button></p>
		<label class="control-label">Consultation Status</label>
		<div class="form-group">
			<select class="form-control" ng-model="consult.status" ng-required="true">
				<option value="{{status.value}}" ng-repeat="status in statuses">{{status.name}}</option>
			</select>
		</div>
		<p><button type="button" class="btn btn-small btn-primary action" rel="attachmentModal"><i class="icon-edit-sign"></i>Attachments</button></p>
		<div class="well well-small clinical-module" id="Master Record" rel="<%=request.getContextPath() %>/demographic/demographiccontrol.jsp?demographic_no=1&displaymode=edit">
			Master Record
		</div>	
		<div class="well well-small clinical-module" id="Encounter" rel="<%=request.getContextPath() %>/casemgmt/forward.jsp?action=view&demographicNo=1">
			Encounter
		</div>
		<div class="well well-small clinical-module" id="Referral History" rel="<%=request.getContextPath() %>/">
			Referral History
		</div>
	</div><!-- Left pane End -->
	<div id="right_pane" class="col-md-10"><!-- Right pane -->
		<div class="col-md-6"><!-- Letterhead -->
			<div class="well">
				<h4>Letterhead</h4>
				<div>
					<select name="letterhead" class="form-control" 
							ng-model="consult.letterheadName" 
							ng-options="letterhead.id as letterhead.name for letterhead in consult.letterheads"
							ng-change="changeLetterhead()">
					</select>
				</div>
				<p class="letterheadDetails">
					<address>
						<strong>Facility Name:</strong> {{consult.letterheadAddress}}<br/>
						<strong>Phone:</strong> {{consult.letterheadPhone}} <br/>
						<strong>Fax:</strong> {{consult.letterheadFax}}<br />
					</address>
				</p>
			</div>
		</div><!-- Letterhead End-->
		<div class="col-md-6"><!-- Specialty -->
			<div class="well">
				<h4>Specialty</h4>
				<div>
					<select name="serviceId" class="form-control inline" style="width: 35%;" 
							ng-model="consult.serviceId" 
							ng-options="service.id as service.description for service in consult.services"
							ng-change="changeService()"
							ng-required="true">
					</select>
					<select name="specialtyId" class="form-control inline" style="width: 50%;"
							ng-model="consult.specId" 
							ng-options="specialty.id as [specialty.firstName, specialty.lastName] for specialty in consult.specialties"
							ng-change="changeSpecialty()">
					</select>
				</div>
				<p class="specialtyDetails">
					<address>
						<strong>Facility Name:</strong> {{consult.specialtyAddress}}<br/>
						<strong>Phone:</strong> {{consult.specialtyPhone}} <br/>
						<strong>Fax:</strong> {{consult.specialtyFax}}<br />
					</address>
				</p>
			</div>
		</div>
		<div class="clear"></div>
		<div class="col-md-12"><!-- Referral -->
			<div class="well">
				<h4>Referral Details</h4>
				<div class="col-md-4">
					<label class="control-label">Referral Date:</label>
					<input id="dp-referralDate" type="text" class="form-control" ng-model="consult.referralDate" data-date-format="yyyy-mm-dd" placeholder="Referral Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$"/>
					<label class="control-label">Urgency:</label>
					<div class="form-group">
						<select name="urgency" class="form-control" ng-model="consult.urgency" ng-required="true">
							<option value="{{urgency.value}}" ng-repeat="urgency in urgencies" ng-selected="{{urgency.value == consult.urgency || urgency.value == '2'}}">{{urgency.name}}</option>
						</select>
					</div>
					<label class="control-label">Send To:</label>
					<div class="form-group">
						<select name="urgency" class="form-control" ng-model="consult.sendTo" ng-required="true">
							<option value="{{sendTo.value}}" ng-repeat="sendTo in consult.sendTos" ng-selected="{{sendTo.value == consult.sendTo || urgency.value == '-1'}}">{{sendTo.name}}</option>
						</select>
					</div>
				</div>
				<div class="col-md-8">
					<label class="control-label">Referrer Instructions:</label>
					<div class="form-group">
						<textarea cols="80" rows="4" class="form-control" readOnly>{{consult.specialtyAnnotation}}</textarea>
					</div>
				</div>
				<div class="clear"></div>
			</div>
		</div><!-- Referral End -->

		<div class="col-md-12"><!-- Appointment -->
			<div class="well" id="appointmentDetail">
				<h4>Appointment Details</h4>
				<div class="col-md-4">
					<label class="control-label">Appointment Date:</label>
					<input id="dp-appointmentDate" type="text" class="form-control" ng-model="consult.appointmentDate" data-date-format="yyyy-mm-dd" placeholder="Appointment Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$"/>
					<label class="control-label">Appointment Time:</label>
					<div class="form-group">
						<select class="form-control" style="display: inline; width: 25%;" 
								ng-model="consult.appointmentHour"
								ng-options="hour as hour for hour in hours">
						</select> : 
						<select class="form-control" style="display: inline; width:25%;" 
								ng-model="consult.appointmentMinute"
								ng-options="minute as minute for minute in minutes">
						</select>
					</div>
					<label class="control-label">Last Follow-up Date:</label>
					<td><input id="dp-followUpDate" type="text" class="form-control" ng-model="consult.followUpDate" data-date-format="yyyy-mm-dd" placeholder="Follow Up Date"/></td>
				</div>
				<div class="col-md-8">
					<div>
						<label class="control-label"><input type="checkbox" id="willBook" ng-model="consult.patientWillBook"/> Patient Will Book</label>
					</div>
					<label class="control-label">Appointment Notes:</label>
					<div class="form-group">
						<textarea cols="80" rows="6" class="form-control" ng-model="consult.statusText"></textarea>
					</div>
				</div>
				<div class="clear"></div>
				<div class="col-md-12">
					<label class="control-label"><h4>Reason for Consultation</h4></label>
					<div class="form-group">
						<textarea cols="120" rows="4" class="form-control" ng-model="consult.reasonForReferral"></textarea>
					</div>
				</div>
				<div class="clear"></div>
			</div>
		</div><!-- Appointment End -->	
		
		<div id="clinical-note" class="col-md-6"><!-- Clinic Notes -->
			<div>
				<h4>Create Clinical Notes <i class="icon-question-sign icon-large" rel="popover" data-html="true" data-content="Clinical notes are so you can add a reason for consultation, include detailed data from the patients echart or simply create a custom note that you would like added to the conslultation." data-original-title="What is a Clinical Note?" data-trigger="hover"></i></h4>
				<div class="well">
					<div>
						<textarea id="clinicalInfo" cols="80" rows="6" class="form-control" placeholder="When creating a note use the Medical Summaries below to help you create the note with data from the patients chart."
							ng-model="consult.clinicalInfo"></textarea>
					</div>
				</div>
				<div>
					<p>Medical Summary: <small>add chart data to note</small></p>
					<p>				
						<button type="button" class="btn btn-tags btn-success" onclick="importFromEnct('FamilyHistory','clinicalInfo');">Family History</button>&nbsp;
						<button type="button" class="btn btn-tags btn-success" onclick="importFromEnct('MedicalHistory','clinicalInfo');">Medical History</button>&nbsp;
						<button type="button" class="btn btn-tags btn-success" onclick="importFromEnct('ongoingConcerns','clinicalInfo');">Ongoing Concerns</button>
					</p>
					<p>
						<button type="button" class="btn btn-tags btn-success" onclick="importFromEnct('OtherMeds','clinicalInfo');">Other Meds</button>&nbsp;
						<button type="button" class="btn btn-tags btn-success" onclick="importFromEnct('Reminders','clinicalInfo');">Reminders</button>
					</p>					
				</div>
				<div class="clear"></div>
			</div>
		</div>
		
		<div id="concurrent-problem" class="col-md-6"><!-- Concurrent Problem -->
			<div>
				<h4>Significant Concurrent Problems: <i class="icon-question-sign icon-large" rel="popover" data-html="true" data-content="Clinical notes are so you can add a reason for consultation, include detailed data from the patients echart or simply create a custom note that you would like added to the conslultation." data-original-title="What is a Clinical Note?" data-trigger="hover"></i></h4>
				<div class="well">
					<div>
						<textarea id="concurrentProblems" cols="80" rows="6" class="form-control" placeholder="When creating a note use the Medical Summaries below to help you create the note with data from the patients chart."
							ng-model="consult.concurrentProblems"></textarea>
					</div>
				</div>
				<div>
					<p>Medical Summary: <small>add chart data to note</small></p>
					<p>				
						<button type="button" class="btn btn-tags btn-success" onclick="importFromEnct('FamilyHistory','concurrentProblems');">Family History</button>&nbsp;
						<button type="button" class="btn btn-tags btn-success" onclick="importFromEnct('MedicalHistory','concurrentProblems');">Medical History</button>&nbsp;
						<button type="button" class="btn btn-tags btn-success" onclick="importFromEnct('ongoingConcerns','concurrentProblems');">Ongoing Concerns</button>
					</p>
					<p>
						<button type="button" class="btn btn-tags btn-success" onclick="importFromEnct('OtherMeds','concurrentProblems');">Other Meds</button>&nbsp;
						<button type="button" class="btn btn-tags btn-success" onclick="importFromEnct('Reminders','concurrentProblems');">Reminders</button>
					</p>						
				</div>
				<div class="clear"></div>
			</div>
		</div>
		<div class="clear"></div>
		<div class="col-md-6"><!-- Alergies / Current Medications -->
			<h4>Allergies:</h4>
			<div class="well">
				<textarea cols="80" rows="6" class="form-control" ng-model="consult.allergies"></textarea>
			</div>
		</div><!-- Alergies End -->	
		<div class="col-md-6">
			<h4>Current Medications:</h4>
			<div class="well">
				<textarea cols="80" rows="6" class="form-control" ng-model="consult.currentMeds"></textarea>
			</div>
		</div><!-- Current Medications End -->	
		<div class="clear"></div>
	</div>
	<div class="clear"></div>
	<div class="wrapper-action"><!-- Action Buttons -->
		<button type="button" class="btn btn-large btn-warning action" rel="previewModal">Preview</button>&nbsp;
		<button type="button" class="btn btn-large btn-primary action" rel="saveModal">Save</button>&nbsp;
		<button type="button" class="btn btn-large btn-danger action" rel="deleteModal">Delete</button>&nbsp; 
		<button type="button" class="btn btn-large action" rel="cancelModal">Cancel</button>
		<div class="inline">
			<span id="scrollToTop" class="DoNotPrint" title="scroll to top"><a href="#consultRequestForm" class="DoNotPrint right"><i class="icon-circle-arrow-up icon-3x"></i></a></span>
		</div>		
	</div>
</form>
	
<!--Modal Dialog -->
<div id="saveModal" class="modal fade dialog" style="display: none;" tabindex="-1" role="dialog" aria-labelledby="confirmModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
		<h3 id="saveModalLabel">Are you sure?</h3>
	</div>
	<div class="modal-body">
		<p><i class="icon-warning-sign icon-large"></i> Please confirm that you would like to save this Consultaion Request!</p>
	</div>
	<div class="modal-footer">
		<button id="saveCancel" class="btn" data-dismiss="modal" aria-hidden="true">No, continue editing</button>
		<button id="saveSubmit" type="button" class="btn btn-primary" ng-click="saveConsult(consultRequestForm,saveModal)">Yes, save</button>
	</div>
</div>
<div id="deleteModal" class="modal fade dialog" style="display: none;" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
		<h3 id="deleteModalLabel">Are you sure?</h3>
	</div>
	<div class="modal-body">
		<p><i class="icon-warning-sign icon-large"></i> Please confirm that you would like to DELETE this Consultaion Request!</p>
	</div>
	<div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">No, continue editing</button>
		<button class="btn btn-danger" data-dismiss="modal" aria-hidden="true" ng-click="remove()">Yes, Delete</button>
	</div>
</div>
<div id="cancelModal" class="modal fade dialog" style="display: none;" tabindex="-1" role="dialog" aria-labelledby="cancelModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
		<h3 id="cancelModalLabel">Are you sure?</h3>
	</div>
	<div class="modal-body">
		<p><i class="icon-warning-sign icon-large"></i> Please confirm that you would like to <strong>CANCEL</strong> this Consultaion Request!</p>
	</div>
	<div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">No, continue editing</button>
		<button type="button" class="btn btn-primary" data-dismiss="modal" aria-hidden="true" onclick="javascript:window.close();">Yes, Exit</button>
	</div>
</div>
<div id="letterheadModal" class="modal fade dialog" style="display: none;" tabindex="-1" role="dialog" aria-labelledby="cancelModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
		<h3 id="cancelModalLabel">Letterhead List</h3>
	</div>
	<div class="modal-body">
		<table>
			<thead>
				<th>Name</th><th>Address</th><th>Phone</th><th>Fax</th>
			</thead>
		</table>
	</div>
	<div class="modal-footer">
		<button type="button" class="btn btn-primary" data-dismiss="modal" aria-hidden="true" onclick="javascript:window.close();">Close</button>
	</div>
</div>
<div id="attachmentModal" class="modal fade dialog" style="display: none;" tabindex="-1" role="dialog" aria-labelledby="cancelModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
		<h3 id="noteModalLabel">Documents for {{demographic.lastName}}, {{demographic.firstName}}</h3>
	</div>
	<div class="modal-body">
		<div class="col-md-5">
			<select name="detach" class="form-control" multiple="multiple" size="8">
				<option value="{{attachment.attachmentNo}}" ng-repeat="attachment in consult.allAttachments" title="{{attachment.fileName}}">{{attachment.description}}</option>
			</select>
		</div>
		<div class="col-md-1">
			<p><button id="attach" class="btn">&gt;&gt;</button></p>
			<p><button id="detach" class="btn">&lt;&lt;</button></p>
		</div>
		<div class="col-md-5">
			<select name="attach" class="form-control" multiple="multiple" size="8">
				<option value="{{attachment.attachmentNo}}" ng-repeat="attachment in consult.attachments" title="{{attachment.fileName}}">{{attachment.description}}</option>
			</select>
		</div>
		<div class="clear"></div>
	</div>
	<div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
		<button class="btn btn-primary" data-dismiss="modal" aria-hidden="true" ng-click="print()">Print</button>
	</div>
</div>
<div id="previewModal" class="modal fade dialog" style="display: none; height: 100%; width: 100%;" tabindex="-1" role="dialog" aria-labelledby="cancelModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
		<h3>Consultation for {{demographic.lastName}}, {{demographic.firstName}}</h3>
	</div>
	<div id="printArea" class="modal-body">
		<div class="col-md-2">
			<h3>Patient Details</h3>
			<div class="demographic">
				<p>{{demographic.lastName}}, {{demographic.firstName}} ({{demographic.title}})</p>
				<p>DOB: {{demographic.dateOfBirth | date:'yyyy-MM-dd'}} ({{demographic.age}})</p> 		
				<p>Sex: {{demographic.sexDesc}}</p> 
				<p>HIN: {{demographic.hin}} - {{demographic.ver}}</p> 
				<p>Address:</p> 
				<address>
				{{demographic.address.address}}<br/>
				{{demographic.address.city}}, {{demographic.address.province}}, {{demographic.address.postal}}<br>
				</address>
				<p>Phone (H): {{demographic.phone}}</p>
				<p>Phone (W): {{demographic.alternativePhone}}</p>
				<p>Email: {{demographic.email}}</p>
				<p>MRP: {{demographic.provider.firstName}}, {{demographic.provider.lastName}}</p>
				<p>Status: {{consult.status}}</p>
				<p>Attachment:</p>
				<select class="form-control" multiple="multiple" disabled="true">
					<option value="{{attachment.attachmentNo}}" ng-repeat="attachment in consult.attachments" title="{{attachment.fileName}}">{{attachment.description}}</option>
				</select>
			</select>
			</div>
		</div><!-- Left pane End -->
		<div class="col-md-10"><!-- Right pane -->
			<div class="col-md-6"><!-- Letterhead -->
				<div class="well">
					<h4>Letterhead</h4>
					<p class="letterheadDetails">
						<address>
							<strong>Facility Name:</strong> {{consult.letterheadAddress}}<br/>
							<strong>Phone:</strong> {{consult.letterheadPhone}} <br/>
							<strong>Fax:</strong> {{consult.letterheadFax}}<br />
						</address>
					</p>
				</div>
			</div><!-- Letterhead End-->
			<div class="col-md-6"><!-- Specialty -->
				<div class="well">
					<h4>Specialty</h4>
					<p class="specialtyDetails">
						<address>
							<strong>Facility Name:</strong> {{consult.specialtyAddress}}<br/>
							<strong>Phone:</strong> {{consult.specialtyPhone}} <br/>
							<strong>Fax:</strong> {{consult.specialtyFax}}<br />
						</address>
					</p>
				</div>
			</div>
			<div class="clear"></div>
			<div class="col-md-12"><!-- Referral -->
				<div class="well">
					<h4>Referral Details</h4>
					<div class="col-md-4">
						<label class="control-label">Referral Date:</label>
						<div class="form-group">
							{{consult.referralDate}}
						</div>
						<label class="control-label">Urgency:</label>
						<div class="form-group">
							{{consult.urgency}}
						</div>
						<label class="control-label">Send To:</label>
						<div class="form-group">
							{{consult.sendTo}}
						</div>
					</div>
					<div class="col-md-8">
						<label class="control-label">Referrer Instructions:</label>
						<div class="form-group">
							<textarea cols="80" rows="4" class="form-control" readOnly>{{consult.specialtyAnnotation}}</textarea>
						</div>
					</div>
					<div class="clear"></div>
				</div>
			</div><!-- Referral End -->
	
			<div class="col-md-12"><!-- Appointment -->
				<div class="well" id="appointmentDetail">
					<h4>Appointment Details</h4>
					<div class="col-md-4">
						<label class="control-label">Appointment Date:</label>
						<div class="form-group">
							{{consult.appointmentDate}}
						</div>
						<label class="control-label">Appointment Time:</label>
						<div class="form-group">
							{{consult.appointmentHour}} : {{consult.appointmentMinute}}
						</div>
						<label class="control-label">Last Follow-up Date:</label>
						<div>
							{{consult.followUpDate}}
						</div>
					</div>
					<div class="col-md-8">
						<div>
							<label class="control-label"><input type="checkbox" ng-model="consult.patientWillBook" disabled="true"/> Patient Will Book</label>
						</div>
						<label class="control-label">Appointment Notes:</label>
						<div class="form-group">
							<textarea cols="80" rows="6" class="form-control" ng-model="consult.statusText" disabled="true"></textarea>
						</div>
					</div>
					<div class="clear"></div>
					<div class="col-md-12">
						<label class="control-label"><h4>Reason for Consultation</h4></label>
						<div class="form-group">
							<textarea cols="120" rows="4" class="form-control" ng-model="consult.reasonForReferral" disabled="true"></textarea>
						</div>
					</div>
					<div class="clear"></div>
				</div>
			</div><!-- Appointment End -->	
			
			<div id="clinical-note" class="col-md-6"><!-- Clinic Notes -->
				<div>
					<h4>Create Clinical Notes <i class="icon-question-sign icon-large" rel="popover" data-html="true" data-trigger="hover"></i></h4>
					<div class="well">
						<div>
							<textarea id="clinicalInfo" cols="80" rows="6" class="form-control" ng-model="consult.clinicalInfo" disabled="true"></textarea>
						</div>
					</div>
				</div>
			</div>
			
			<div id="concurrent-problem" class="col-md-6"><!-- Concurrent Problem -->
				<div>
					<h4>Significant Concurrent Problems: <i class="icon-question-sign icon-large" rel="popover" data-html="true" data-trigger="hover"></i></h4>
					<div class="well">
						<div>
							<textarea id="concurrentProblems" cols="80" rows="6" class="form-control" ng-model="consult.concurrentProblems" disabled="true"></textarea>
						</div>
					</div>
				</div>
			</div>
			<div class="clear"></div>
			<div class="col-md-6"><!-- Alergies / Current Medications -->
				<h4>Allergies:</h4>
				<div class="well">
					<textarea cols="80" rows="6" class="form-control" ng-model="consult.allergies" disabled="true"></textarea>
				</div>
			</div><!-- Alergies End -->
			<div class="col-md-6">
				<h4>Current Medications:</h4>
				<div class="well">
					<textarea cols="80" rows="6" class="form-control" ng-model="consult.currentMeds" disabled="true"></textarea>
				</div>
			</div><!-- Current Medications End -->
			<div class="clear"></div>
		</div>
		<div class="clear"></div>
	</div>
	<div class="modal-footer wrapper-action">
		<button class="btn btn-large btn-primary" data-dismiss="modal" aria-hidden="true" onClick="printPreview('printArea');">Print</button>
		<button class="btn btn-large" data-dismiss="modal" aria-hidden="true">Cancel</button>
		<div class="inline">
			<span id="scrollToTop" class="DoNotPrint" title="scroll to top"><a href="#consultRequestForm" class="DoNotPrint right"><i class="icon-circle-arrow-up icon-3x"></i></a></span>
		</div>		
	</div>
</div>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/DT_bootstrap.js"></script>

<script type="text/javascript">
$(function (){
	$("[rel=popover]").popover({});  
	$('[id^=dp-]').datepicker({
		format: 'yyyy-mm-dd'
	}).on("changeDate", function(event) {
		$(this).trigger("change");
	});
	
	$('.clinical-module').click(function(event) {
	    event.preventDefault();
	    window.open($(this).attr("rel"), $(this).attr("id"), "width=1100,height=800,scrollbars=yes");
	});
	$(document).scroll(function () {
	    var y = $(this).scrollTop();
	    if (y > 40) {
	        $('#scrollToTop').fadeIn();
	    } else {
	        $('#scrollToTop').fadeOut();
	    }
	});
	$('.typeahead').typeahead();
	$('.toggle').click(function() {
		var $me = $(this);
		var rel = $me.attr("rel");
		$("." + rel).toggle();
	});
	$(".noteShow").click(function(){
		$("#noteHideOut").toggle();
	});
	$(".btn-tags1").click(function(){
		// $('#noteModal').modal('toggle');
		var id = $(this).attr("id");
		if ($(this).hasClass('btn-success active')) {
			$(this).removeClass('btn-success active');
	    } else { 
	    	$(this).addClass('btn-success active');
	    } 
	});
	$(".checkNote").change(validate).keyup(validate);
	$(".action").click(function() {
		$("#" + $(this).attr("rel")).modal("toggle");
	});
	$("#changeDemographic").click(function() {
	});
	$("#attach").click(function() {
		swap("detach", "attach");
		$("select[name='attach']").trigger("change");
	});
	$("#detach").click(function() {
		swap("attach", "detach");
		$("select[name='attach']").trigger("change");
	});
});

function validate() {
	var v = $(this).val();
	var id = $(this).attr("id");
	if (v!="") {
        $('.'+ id+"-label").addClass('label-success');
    } else {
        $('.'+ id+"-label").removeClass('label-success');
    } 
}

function importFromEnct(reqInfo,txtArea) {
    var info = "";
    switch(reqInfo) {
        case "MedicalHistory":
            <%String value = "";
				if (demo != null) {
					if (useNewCmgmt) {
						value = listNotes(cmgmtMgr, "MedHistory", providerNo, demo);
					} else {
						oscar.oscarDemographic.data.EctInformation EctInfo = new oscar.oscarDemographic.data.EctInformation(demo);
						value = EctInfo.getMedicalHistory();
					}
					if (pasteFmt == null || pasteFmt.equalsIgnoreCase("single")) {
						value = StringUtils.lineBreaks(value);
					}
					value = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(value);
					out.println("info = '" + value + "'");
				}%>
             break;
          case "ongoingConcerns":
             <%if (demo != null) {
					if (useNewCmgmt) {
						value = listNotes(cmgmtMgr, "Concerns", providerNo, demo);
					} else {
						oscar.oscarDemographic.data.EctInformation EctInfo = new oscar.oscarDemographic.data.EctInformation(demo);
						value = EctInfo.getOngoingConcerns();
					}
					if (pasteFmt == null || pasteFmt.equalsIgnoreCase("single")) {
						value = StringUtils.lineBreaks(value);
					}
					value = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(value);
					out.println("info = '" + value + "'");
				}%>
             break;
           case "FamilyHistory":
              <%if (demo != null) {
					if (OscarProperties.getInstance().getBooleanProperty("caisi", "on")) {
						oscar.oscarDemographic.data.EctInformation EctInfo = new oscar.oscarDemographic.data.EctInformation(demo);
						value = EctInfo.getFamilyHistory();
					} else {
						if (useNewCmgmt) {
							value = listNotes(cmgmtMgr, "FamHistory", providerNo, demo);
						} else {
							oscar.oscarDemographic.data.EctInformation EctInfo = new oscar.oscarDemographic.data.EctInformation(demo);
							value = EctInfo.getFamilyHistory();
						}
					}
					if (pasteFmt == null || pasteFmt.equalsIgnoreCase("single")) {
						value = StringUtils.lineBreaks(value);
					}
					value = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(value);
					out.println("info = '" + value + "'");
				}%>
              break;
            case "OtherMeds":
              <%if (demo != null) {
					if (OscarProperties.getInstance().getBooleanProperty("caisi", "on")) {
						value = "";
					} else {
						if (useNewCmgmt) {
							value = listNotes(cmgmtMgr, "OMeds", providerNo, demo);
						} else {
							//family history was used as bucket for Other Meds in old encounter
							oscar.oscarDemographic.data.EctInformation EctInfo = new oscar.oscarDemographic.data.EctInformation(demo);
							value = EctInfo.getFamilyHistory();
						}
					}
					if (pasteFmt == null || pasteFmt.equalsIgnoreCase("single")) {
						value = StringUtils.lineBreaks(value);
					}
					value = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(value);
					out.println("info = '" + value + "'");
				}%>
                break;
            case "Reminders":
              <%if (demo != null) {
					if (useNewCmgmt) {
						value = listNotes(cmgmtMgr, "Reminders", providerNo, demo);
					} else {
						oscar.oscarDemographic.data.EctInformation EctInfo = new oscar.oscarDemographic.data.EctInformation(demo);
						value = EctInfo.getReminders();
					}
					if (pasteFmt == null || pasteFmt.equalsIgnoreCase("single")) {
						value = StringUtils.lineBreaks(value);
					}
					value = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(value);
					out.println("info = '" + value + "'");
					//}
				}%>
	} //end switch
	var content = $("#" + txtArea).val();
	$("#" + txtArea).val(content + "\n------" + reqInfo + "------\n" + info);
	$("#" + txtArea).trigger("input");
}

function swap(srcName, dstName) {	
	var srcElement = document.getElementsByName(srcName); 
	var src = srcElement[0];
	var dstElement = document.getElementsByName(dstName); 
	var dst = dstElement[0];
	var opt;
	//if nothing or dummy is being transfered do nothing
	if (src.selectedIndex == -1 || src.options[0].value == "0") {
		return;
	}
	//if dst has dummy clobber it with new options
	if (dst.options[0].value == "0") {
		dst.remove(0);
	}
	for ( var idx = src.options.length - 1; idx >= 0; --idx) {
		if (src.options[idx].selected) {
			opt = document.createElement("option");
			try { //ie method of adding option
				dst.add(opt);
				dst.options[dst.options.length - 1].text = src.options[idx].text;
				dst.options[dst.options.length - 1].value = src.options[idx].value;
				dst.options[dst.options.length - 1].className = src.options[idx].className;
				src.remove(idx);
			} catch (e) { //firefox method of adding option
				dst.add(src.options[idx], null);
				dst.options[dst.options.length - 1].selected = false;
			}
		}

	} //end for
	if (src.options.length == 0) {
		// setEmpty(src);
	}
}
function setEmpty(selectbox) {
	var emptyTxt = "<bean:message key="oscarEncounter.oscarConsultationRequest.AttachDocPopup.empty"/>";
	var emptyVal = "0";
	var op = document.createElement("option");
	try {
		selectbox.add(op);
	} catch (e) {
		selectbox.add(op, null);
	}
	selectbox.options[0].text = emptyTxt;
	selectbox.options[0].value = emptyVal;
}
</script>
</body>
</html>
<%!protected String listNotes(CaseManagementManager cmgmtMgr, String code, String providerNo, String demoNo) {
	// filter the notes by the checked issues
	List<Issue> issues = cmgmtMgr.getIssueInfoByCode(providerNo, code);
	String[] issueIds = new String[issues.size()];
	int idx = 0;
	for (Issue issue : issues) {
		issueIds[idx] = String.valueOf(issue.getId());
	}
	// need to apply issue filter
	List<CaseManagementNote> notes = cmgmtMgr.getNotes(demoNo, issueIds);
	StringBuilder noteStr = new StringBuilder();
	for (CaseManagementNote n : notes) {
		if (!n.isLocked()) noteStr.append(n.getNote() + "\n");
	}
	return noteStr.toString();
}%>
	