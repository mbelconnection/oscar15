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
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.oscarehr.util.LoggedInInfo"%>
<%@ page import="org.oscarehr.util.DigitalSignatureUtils"%>
<%@ page import="org.oscarehr.ui.servlet.ImageRenderingServlet"%>
<%@ page import="oscar.oscarEncounter.oscarConsultationRequest.pageUtil.EctConsultationFormRequestUtil"%>

<%@ page import="oscar.util.UtilDateUtilities"%>
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

<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/library/bootstrap/3.0.0/assets/js/DT_bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/bootstrap-datepicker.js"></script>

<script src="<%=request.getContextPath()%>/library/bootstrap/3.0.0/js/bootstrap.js"></script>
<script src="<%=request.getContextPath()%>/library/hogan-2.0.0.js"></script>
<script src="<%=request.getContextPath()%>/library/typeahead.js/typeahead.js"></script>
<script src="<%=request.getContextPath()%>/library/angular.js"></script>
<script src="<%=request.getContextPath()%>/library/angular-route.js"></script>
<script src="<%=request.getContextPath()%>/library/angular-resource.js"></script>

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
	
	#wrapper-action {
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
	#wrapper-action:hover{
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
</style>
<noscript>Your browser either does not support JavaScript, or has it turned off.</noscript>
</head>

<body id="consultRequestForm" ng-controller="ConsultDetailCtrl as detailController">
<%
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
%>
<div class="col-md-12">
	<h1>Consultation Details</h1>
</div>
<form name="consultRequestForm" action="consultRequestAction.jsp" method="post">
	<div id="left_pane" class="col-md-2">
		<h3>Patient Details</h3>
		<div class="demographic">
			<p>{{demographic.lastName}}, {{demographic.firstName}} ({{demographic.title}})</p>
			<p>DOB: {{demographic.dateOfBirth}} ({{demographic.age}})</p> 		
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
		</div>
		<div class="demographic" style="display: none;">
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Last Name" ng-model="demographic.lastName" />
			</div>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="First Name" ng-model="demographic.firstName"/>
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
			<div class="form-group" id="dp-referralDate" data-date="{{demographic.dateOfBirth}}" data-date-format="yyyy-mm-dd" title="Referral Date">
				<input class="form-control" name="referralDate" id="referralDate" type="text" ng-model="demographic.dateOfBirth" placeholder="Enter Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$">
			</div>
			<label class="control-label">HIN:</label>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="HIN" ng-model="demographic.hin" />
			</div>
			<label class="control-label">Address:</label>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Address" ng-model="demographic.address.address" />
				<input type="text" class="form-control" placeholder="City" ng-model="demographic.address.city" />
				<select class="form-control" ng-model="demographic.address.province">
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
		</div>
		<p><button type="button" class="btn btn-small toggle" rel="demographic"><i class="icon-edit-sign"></i> Change</button></p>
		
		
		
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
							ng-change="changeService()">
					</select>
					<select name="specialtyId" ng-model="consult.specialtyId" class="form-control inline" style="width: 50%;"
							ng-model="consult.specialtyId" 
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
					<div class="form-group" id="dp-referralDate" data-date="<%=date%>" data-date-format="yyyy-mm-dd" title="Referral Date">
						<input style="display: inline-block;" class="form-control" name="referralDate" id="referralDate" type="text" value="<%=date%>" placeholder="Enter Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$">
					</div>
					<label class="control-label">Urgency:</label>
					<div class="form-group">
						<select name="urgency" class="form-control" ng-model="consult.urgency">
							<option value="{{urgency.value}}" ng-repeat="urgency in urgencies">{{urgency.name}}</option>
						</select>
					</div>
				</div>
				<div class="col-md-8">
					<label class="control-label">Referrer Instructions:</label>
					<div class="form-group">
						<textarea cols="80" rows="4" class="form-control"></textarea>
					</div>
				</div>
				<div class="clear"></div>
			</div>
		</div><!-- Referral End -->
		
		<div class="col-md-12"><!-- Appointment -->
			<div class="well">
				<h4>Appointment Details</h4>
				<div class="col-md-4">
					<label class="control-label">Appointment Date:</label>
					<div class="form-group" id="dp-appointmentDate" data-date="<%=date%>" data-date-format="yyyy-mm-dd" title="Appointment Date">
						<input style="display: inline-block;" class="form-control" name="appointmentDate" id="appointmentDate" type="text" value="<%=date%>" placeholder="Enter Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$">
					</div>
					<label class="control-label">Appointment Time:</label>
					<div class="form-group">
						<select name="hour" class="form-control" style="display: inline; width: 25%;" 
								ng-model="consult.appointmentHour"
								ng-options="hour as hour for hour in hours">
						</select> : 
						<select name="minute" class="form-control" style="display: inline; width:25%;" 
								ng-model="consult.appointmentMinute"
								ng-options="minute as minute for minute in minutes">
						</select>
					</div>
					<label class="control-label">Last Follow-up Date:</label>
					<div class="form-group" id="dp-lastFollowupDate" data-date="<%=date%>" data-date-format="yyyy-mm-dd" title="Last Follow-up Date">
						<input style="display: inline-block;" class="form-control" name="lastFollowupDate" id="lastFollowupDate" type="text" value="<%=date%>" placeholder="Enter Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$">
					</div>
				</div>
				<div class="col-md-8">
					<div>
						<label class="control-label"><input type="checkbox" name="willBook" ng-model="consult.patientWillBook"/> Patient Will Book</label>
					</div>
					<label class="control-label">Appointment Notes:</label>
					<div class="form-group">
						<textarea cols="80" rows="6" class="form-control" ng-model="consult.statusText"></textarea>
					</div>
				</div>
				<div class="clear"></div>
				<div class="col-md-12">
					<label class="control-label">Appointment Location <small>(if different from specialist address)</small></label>
					<select name="location" class="form-control">
						<option value="{{location.value}}" ng-repeat="location in locations">{{location.name}}</option>
					</select>
				</div>
				<div class="col-md-12">
					<label class="control-label"><h4>Reason for Consultation</h4></label>
					<div class="form-group">
						<textarea cols="120" rows="4" class="form-control" ng-model="consult.reasonForReferral"></textarea>
					</div>
				</div>
				<div class="clear"></div>
			</div>
		</div><!-- Appointment End -->	
		<div id="clinical-note" class="col-md-12"><!-- Clinic Notes -->
			<div>
				<h4>Create Clinical Notes <i class="icon-question-sign icon-large" rel="popover" data-html="true" data-content="Clinical notes are so you can add a reason for consultation, include detailed data from the patients echart or simply create a custom note that you would like added to the conslultation." data-original-title="What is a Clinical Note?" data-trigger="hover"></i></h4>
				<div class="col-md-6 well">
					<div>
						<label class="control-label"><span class="label badge">Step 1</span> Add a Title:</label>
						<input type="text" name="noteTitle" class="form-control" data-provide="typeahead" data-items="6" 
						data-source='["Reason for Consultation","Pertinent clinical information","Significant concurrent problems","Current Medications","Allergies"]' autocomplete="off" placeholder="Title">
					</div>
					<div>
						<label class="control-label"><span class="label badge">Step 2</span> Create Note:</label>
						<textarea name="noteBody" class="form-control" placeholder="When creating a note use the Medical Summaries to the right to help you create the note with data from the patients chart."
							ng-model="consult.clinicalInfo"></textarea>
					</div>
				</div>
				<div class="col-md-6">
					<p>Medical Summary: <small>add chart data to note</small></p>
					<p>				
						<button type="button" class="btn btn-tags one" id="one">Family History</button>&nbsp;
						<button type="button" class="btn btn-tags two" id="two">Medical History</button>&nbsp;
						<button type="button" class="btn btn-tags three" id="three">Ongoing Concerns</button>
					</p>
					<p>
						<button type="button" class="btn btn-tags four" id="four">Other Meds</button>&nbsp;
						<button type="button" class="btn btn-tags five" id="five">Reminders</button>&nbsp;
						<button type="button" class="btn btn-tags six" id="six">item 6</button>&nbsp;
						<button type="button" class="btn btn-tags seven" id="seven">item 7</button>&nbsp;
					</p>
				</div>
				<div class="clear"></div>
			</div>
		</div>
		
		<div id="concurrent-problem" class="col-md-12"><!-- Concurrent Problem -->
			<div>
				<h4>Significant Concurrent Problems: <i class="icon-question-sign icon-large" rel="popover" data-html="true" data-content="Clinical notes are so you can add a reason for consultation, include detailed data from the patients echart or simply create a custom note that you would like added to the conslultation." data-original-title="What is a Clinical Note?" data-trigger="hover"></i></h4>
				<div class="col-md-6 well">
					<div>
						<label class="control-label"><span class="label badge">Step 1</span> Add a Title:</label>
						<input type="text" name="noteTitle" class="form-control" data-provide="typeahead" data-items="6" 
						data-source='["Reason for Consultation","Pertinent clinical information","Significant concurrent problems","Current Medications","Allergies"]' autocomplete="off" placeholder="Title">
					</div>
					<div>
						<label class="control-label"><span class="label badge">Step 2</span> Create Note:</label>
						<textarea name="noteBody" class="form-control" placeholder="When creating a note use the Medical Summaries to the right to help you create the note with data from the patients chart."
							ng-model="consult.concurrentProblems"></textarea>
					</div>
				</div>
				<div class="col-md-6">
					<p>Medical Summary: <small>add chart data to note</small></p>
					<p>				
						<button type="button" class="btn btn-tags one" id="one">Family History</button>&nbsp;
						<button type="button" class="btn btn-tags two" id="two">Medical History</button>&nbsp;
						<button type="button" class="btn btn-tags three" id="three">Ongoing Concerns</button>
					</p>
					<p>
						<button type="button" class="btn btn-tags four" id="four">Other Meds</button>&nbsp;
						<button type="button" class="btn btn-tags five" id="five">Reminders</button>&nbsp;
						<button type="button" class="btn btn-tags six" id="six">Item 6</button>&nbsp;
						<button type="button" class="btn btn-tags seven" id="seven">Item 7</button>&nbsp;
					</p>
				</div>
				<div class="clear"></div>
			</div>
		</div>
		<div class="col-md-12"><!-- Alergies / Current Medications -->
			<div class="well">
				<div class="col-md-6">
					<h4>Allergies:</h4>
					<div class="form-group">
						<textarea cols="80" rows="4" class="form-control" ng-model="consult.allergies"></textarea>
					</div>
				</div>
				<div class="col-md-6">
					<h4>Current Medications:</h4>
					<div class="form-group">
						<textarea cols="80" rows="4" class="form-control" ng-model="consult.currentMeds"></textarea>
					</div>
				</div>
				<div class="clear"></div>
			</div>
		</div><!-- Alergies / Current Medications End -->			
		<div class="clear"></div>
	</div>
	<div id="wrapper-action"><!-- Action Buttons -->
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
		<button class="btn" data-dismiss="modal" aria-hidden="true">No, continue editing</button>
		<button type="button" class="btn btn-primary" ng-click="save()">Yes, save</button>
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
		<button type="button" class="btn btn-danger" data-dismiss="modal" aria-hidden="true" onclick="javascript:window.close();">Yes, Delete</button>
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
<div id="noteModal" class="modal fade dialog" style="display: none;" tabindex="-1" role="dialog" aria-labelledby="cancelModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
		<h3 id="noteModalLabel">Title</h3>
	</div>
	<div class="modal-body">
		<p>Display options from echart to select and add to note</p>
	</div>
	<div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
		<button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Add</button>
	</div>
</div>

<script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/DT_bootstrap.js"></script>   

<script type="text/javascript">
$(function (){
	$("[rel=popover]").popover({});  
	$('[id^=dp-]').datepicker();
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
	$(".btn-tags").click(function(){
		$('#noteModal').modal('toggle');
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
</script>

</body>
</html>
