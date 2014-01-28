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
%>
<div class="col-md-12">
	<h1>Consultation Details</h1>
</div>
<form name="consultRequestForm" action="consultRequestAction.jsp" method="post">
	<div id="left_pane" class="col-md-2">
		<h3>Patient Details</h3>
		<div class="patient">
			<p>{{patient.lastName}}, {{patient.firstName}} ({{patient.title}})</p>
			<p>DOB: {{patient.dob}} ({{patient.age}})</p> 		
			<p>Sex: {{patient.sex}}</p> 
			<p>HIN: {{patient.hin}}</p> 
			<p>Address:</p> 
			<address>
			{{patient.address}}<br/>
			{{patient.city}}, {{patient.province}} {{patient.postcode}}<br>
			{{patient.country}}
			</address>
			<p>Phone (C): {{patient.cellPhone}}</p>
			<p>Phone (H): {{patient.homePhone}}</p>
			<p>Phone (W): {{patient.workPhone}}</p>
			<p>Email: {{patient.email}}</p>
		</div>
		<div class="patient" style="display: none;">
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Last Name" ng-model="patient.lastName" />
			</div>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="First Name" ng-model="patient.firstName"/>
			</div>
			<div class="form-group">
				<select class="form-control" ng-model="patient.title" style="width: 45%; display: inline-block;">
					<option ng-repeat="title in titles">{{title}}</option>
				</select>
				<select class="form-control" ng-model="patient.sex" style="width: 45%; display:inline-block;">
					<option ng-repeat="gender in genders">{{gender}}</option>
				</select>
			</div>
			<label class="control-label">DOB:</label>
			<div class="form-group" id="dp-referralDate" data-date="<%=date%>" data-date-format="yyyy-mm-dd" title="Referral Date">
				<input class="form-control" name="referralDate" id="referralDate" type="text" ng-model="patient.dob" placeholder="Enter Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$">
			</div>
			<label class="control-label">HIN:</label>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="HIN" ng-model="patient.hin" />
			</div>
			<label class="control-label">Address:</label>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Address" ng-model="patient.address" />
				<input type="text" class="form-control" placeholder="City" ng-model="patient.city" />
				<select class="form-control" ng-model="patient.province">
					<option value="{{province.value}}" ng-repeat="province in provinces">{{province.name}}</option>
				</select>
				<input type="text" class="form-control" placeholder="Country" ng-model="patient.country" />
				<input type="text" class="form-control" placeholder="Postcode" ng-model="patient.postcode" />
			</div>
			<label class="control-label">Phone:</label>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Cell Phone" ng-model="patient.cellPhone" />
				<input type="text" class="form-control" placeholder="Home Phone" ng-model="patient.homePhone" />
				<input type="text" class="form-control" placeholder="Work Phone" ng-model="patient.workPhone" />
			</div>
			<label class="control-label">Email:</label>
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Email" ng-model="patient.email" />
			</div>
		</div>
		<p><button type="button" class="btn btn-small toggle" rel="patient"><i class="icon-edit-sign"></i> Change</button></p>
		
		
		
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
				<p class="head-lead muted" id="head-letterHeader" data-original="Please select a letterhead" data-success-msg="Letterhead">Please select a letterhead</p>
				<div id="letterHeaderFind" class="landingOptions">
				    <input class="input-xlarge edit-btn-large finder form-control col-md-4 inline" style="width: 70%;" id="letterHeader" name="letterheadName" rel="letterHeader" type="text" data-provide="typeahead" data-items="4" data-source='{{letterheaderSource}}' autocomplete="on" placeholder="Find Letterhead">&nbsp; 
				    <button type="button" class="btn btn-primary modalShow">View List</button>
				</div><!--letterHeaderFind-->
	
				<div id="letterHeaderSelected" class="landingOptions hide">
				<!--I am for the selected letterhead option to display-->
				</div><!--letterHeaderSelected-->	
				<div class="changeControl change" id="letterHeaderChange">
					<button type="button" class="btn btn-change" rel="letterHeader"><i class="icon-edit-sign icon-large"></i> Change</button>
				</div><!--changeControl-->
			</div>
		</div><!-- Letterhead End-->
		<div class="col-md-6"><!-- Specialty -->
			<div class="well">
				<h4>Specialty</h4>
				<p class="head-lead muted" id="head-specialist" data-original="Find a specialist to send this request" data-success-msg="Specialist">Find a specialist to send this request</p>
				<div id="specialistFind" class="landingOptions">		
					<div class="input-append" style="text-align:left">
						<i class="icon-question-sign icon-large" rel="popover" data-html="true" data-content="Adding a specialty will help refine the specialist list to the right to make it quicker for you to find the specialist you are looking for." data-original-title="Why add a specialty?" data-trigger="hover"></i> 					
						<select name="specialty" class="specialty form-control inline" style="width: 35%;">
							<option value="{{specialty.value}}" ng-repeat="specialty in specialties">{{specialty.name}}</option>
						</select>
					    <input class="input-xlarge edit-btn-large finder form-control inline" style="width: 35%;" name="specialist" id="specialist" rel="specialist" type="text" data-provide="typeahead" data-items="4" 
						data-source='{{specialtySource}}' autocomplete="off" placeholder="Find Specialist">&nbsp;
					    <button class="btn btn-primary modalShow" type="button">View List</button>
					</div>
				</div><!--specialistSelect-->
				<div id="specialistSelected" class="hide">
					<div class="toDetails">				
						<p>
							Consultant: <span class="muted">{{consult.title}} {{consult.firstName}} {{consult.lastName}}</span>
						</p>
						<p>
							Service: <span class="muted">Cardiology</span>
						</p>
					</div>				
					<div class="toDetails">
						Address:<br>
						<span class="muted">
						<address>
							{{consult.address}}<br>
							{{consult.city}} {{consult.province}} {{consult.postcode}}<br>
							<abbr title='Phone'>Phone:</abbr>{{consult.phone}}<br>
							<abbr title='Fax'>Fax:</abbr>{{consult.fax}}<br>
						</address>
						</span>
					</div>				
				</div><!--specialistSelected-->				
				<div class="changeControl change" id="specialistChange">
					<button type="button" class="btn btn-change" rel="specialist"><i class="icon-edit-sign icon-large"></i> Change</button>
				</div><!--changeControl-->
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
						<select name="urgency" class="form-control">
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
						<select name="hour" class="form-control" style="display: inline; width: 85px;">
							<option value="{{hour}}" ng-repeat="hour in hours">{{hour}}</option>
						</select>
						<select name="minute" class="form-control" style="display: inline; width: 85px;">
							<option value="{{minute}}" ng-repeat="minute in minutes">{{minute}}</option>
						</select>
						<select name="ampm" class="form-control" style="display: inline; width: 85px;">
							<option value="{{ampm}}" ng-repeat="ampm in ampms">{{ampm}}</option>
						</select>
					</div>
					<label class="control-label">Last Follow-up Date:</label>
					<div class="form-group" id="dp-lastFollowupDate" data-date="<%=date%>" data-date-format="yyyy-mm-dd" title="Last Follow-up Date">
						<input style="display: inline-block;" class="form-control" name="lastFollowupDate" id="lastFollowupDate" type="text" value="<%=date%>" placeholder="Enter Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$">
					</div>
				</div>
				<div class="col-md-8">
					<div>
						<label class="control-label"><input type="checkbox" name="willBook"/> Patient Will Book</label>
					</div>
					<label class="control-label">Appointment Notes:</label>
					<div class="form-group">
						<textarea cols="80" rows="6" class="form-control"></textarea>
					</div>
				</div>
				<div class="clear"></div>
				<div class="col-md-12">
					<label class="control-label">Appointment Location <small>(if different from specialist address)</small></label>
					<select name="location" class="form-control">
						<option value="{{location.value}}" ng-repeat="location in locations">{{location.name}}</option>
					</select>
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
						<textarea name="noteBody" class="form-control" placeholder="When creating a note use the Medical Summaries to the right to help you create the note with data from the patients chart."></textarea>
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
						<textarea name="noteBody" class="form-control" placeholder="When creating a note use the Medical Summaries to the right to help you create the note with data from the patients chart."></textarea>
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
		<button type="submit" class="btn btn-primary"  onclick="javascript:window.close();">Yes, save</button>
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
	$('.change').hide(); // hide change button initially
	$('.toggle').click(function() {
		var $me = $(this);
		var rel = $me.attr("rel");
		$("." + rel).toggle();
	});
	$(".finder").change(function(){
		var rel = $(this).attr("rel");
		var id = $(this).attr("id");
		$("#"+rel+"Find").hide();
		$('#head-'+rel).html("<i class='icon-ok-sign'></i> " + $('#head-'+rel).attr('data-success-msg'));
		if(rel=="letterHeader"){
			//this is a static example but these address values should be dynamic-->
			$("#letterHeaderSelected").html("<div class='fromName'><h1>" + $(this).val() + "</h1><p class='lead'>Consultation Request</p> </div> <div class='fromAddress'><address><strong>Facility Name</strong> <br> 26 Hamilton St. <br>Hamilton Ontario L0R 4K3 <br><abbr title='Phone'>P:</abbr> 555-555-5555 <br><abbr title='Fax'>F:</abbr> 555-555-5552<br></address></div>");
			// $("#letterHeaderSelected").removeClass("hide");
		}
		$("#"+rel+"Selected").show();
		$("#"+rel+"Change").show();
		//$("#"+$(this).attr("rel")).addClass("alert-success"); <----don't add color yet until you know that there will be no indicators with colors
	});
	$(".btn-change").click(function(){
		var rel = $(this).attr("rel");
		$("#"+rel+"Find").toggle();
		$("#"+rel+"Selected").toggle();
		$("#"+rel+"Change").toggle();
		$("#"+rel).val("");
		$('#head-'+rel).html($('#head-'+rel).attr('data-original'));
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
