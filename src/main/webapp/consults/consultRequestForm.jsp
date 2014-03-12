<!DOCTYPE html>
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
<%@ page import="oscar.util.UtilDateUtilities" %>
<%
String date = UtilDateUtilities.getToday("yyyy-MM-dd");
%>

<html lang="en">
<head>
<title>Consult Request Form</title>

<meta name="viewport" content="width=device-width, user-scalable=false;">



<script>

</script>

<noscript>Your browser either does not support JavaScript, or has it turned off.</noscript>



<link href="<%=request.getContextPath() %>/css/bootstrap.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath() %>/css/datepicker.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath() %>/css/DT_bootstrap.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath() %>/css/bootstrap-responsive.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/font-awesome.min.css">

<style type="text/css">
/*.span2{background-color:#333;}*/
.span8{

}

.patient-info{
position:fixed;
top:0px;
z-index:999;
}

#header-container{

}

.landingOptions{
   width:100%;
   text-align:center;
}

.head-lead{
   font-size:28px;
   margin-top:-14px;
   margin-left:-10px;
   font-family:"Helvetica", Tahoma, Arial;
}

.head-lead-small{
   margin-top:0px;
   font-size:18px;
}


.fromName{
   vertical-align:top;
   display:inline-block;
   text-align:left;
   margin:0px;
   padding:0px;
   width:70%;
}

.fromName h1{
   margin-bottom:0px;
}

.fromAddress{
   display:inline-block;
   text-align:left;
   margin:0px;
   padding:0px;
   width:20%;
}

.changeControl{
   display:none;
   width:100%;
   text-align:right;
   opacity:0.4;
   filter:alpha(opacity=40); /* For IE8 and earlier */
   margin-bottom:-10px;
}

.changeControl:hover{
   width:100%;
   text-align:right;
   opacity:1;
   filter:alpha(opacity=100); /* For IE8 and earlier */
}

.toDetails{
   display:inline-block;
   padding-right:10px;
   vertical-align:top;
   width:30%;
}

.toDetails span{
font-size:18px;
}

#patientDetails div{
   display:inline-block;
   padding-right:20px;
}



input.edit-btn-large {
   padding: 11px 19px;
   font-size: 17.5px;
}

.specialty {
   width:160px;
   padding-top: 10px ;
   font-size: 17.5px;

   height: 42px;
}


/*.modal-backdrop {background: none;}*/

.hide{ display:none; }

.time{width:60px;}


#scrollToTop{
   display:none;
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

#noteCreator{
display:none;
position:fixed;
top:0px;
z-index:999;
width:100%;
height:70%;
background-color:#333;
}

#noteCreator h2,h3{
font-weight:normal;
font-family:"Helvetica";
}

#noteCreator h2{
color:#333;
}

#noteCreator input{
width:400px;
padding:10px;
font-size:18px;
}

#noteCreator textarea{
width:410px;
height:160px;
font-size:18px;
}

#noteControls{
position:absolute;
bottom:10px;
width:100%;
height:60px;
background-color:#0088cc;
}

#noteControls div{
display:inline-block;
}

#noteControlLeft{
float:left;
}

#noteControlRight{
float:right;
text-align:right;
padding-top:10px;
padding-right:4px;
}


.btn-tags{
margin:2px;
}

.span2{
padding:6px;
opacity:0.6;
filter:alpha(opacity=60); /* For IE8 and earlier */
}

.span2:hover{
cursor: pointer; cursor: hand;
opacity:1;
filter:alpha(opacity=100); /* For IE8 and earlier */
}

.noteInputOk{
/*background-color:#62c462 !important;*/
color:#62c462 ;
opacity:1 !important;
filter:alpha(opacity=100) !important; /* For IE8 and earlier */
}


#noteHideOut{
display:none;
}

.noteTitle{
width:90%;
}

.noteBody{
width:90%;
height:110px;
}

#note-left-side{
width:40%;
}

#note-right-side{
width:55%;
}

.sidebyside{
display:inline-block;
vertical-align:top;
}


.icon-ok-sign{
color:#468847;
}

#patient-side{
position:fixed;
top:10px;
}

#patient-side h5{
margin-top:0px;
margin-bottom:0px;
}

.clinical-module{
margin-top:2px;
margin-bottom:0px;
}

.clinical-module:hover{
background-color:#333;
color:#f5f5f5;
}

.icon-question-sign{
cursor: help;
}

#clinical-note{
margin-bottom:40px;
}

#wrapper-action{
position:fixed; 
bottom:0px; 
width:100%; 
z-index:999; 
padding-top:4px;
padding-bottom:4px;
border: 1px solid #fff; 
background-color:#fff;
text-align:right;
opacity:0.4;
filter:alpha(opacity=60); /* For IE8 and earlier */
}

#wrapper-action:hover{
background-color:#f5f5f5;
border: 1px solid #E3E3E3;
box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05) inset;
opacity:1;
filter:alpha(opacity=100); /* For IE8 and earlier */
}
</style>

</head>

<body id="consultFormBody">

<form id="consultRequestForm" name="consultRequestForm" action="consultRequestAction.jsp" method="post">
<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2"><!--Left Sidebar content-->
		<div id="patient-side">
				<p class="head-lead head-lead-small muted">Patient Details</p>
				<h5>Lastname, Firstname (Mr)</h5>


				
					<small>
						DOB: 1976-06-15 (37y) 
					
						Sex: M<br>

						HIN: XXXXXXXXXXXX cn<br>
						
						<br> 
					
					Address:<br>
					<address>
					258 Sixth Road East,<br>
					Stoney Creek, ON L8J3V6<br>
					Canada<br>
					Phone: 905-555-5555<br><!--condition on mobile to add <a href="tel:+19055555555">905-555-5555</a>-->
					</address>

					</small>
					
				<div class="changeControl" style="display:block">
				
				<button type="button" class="btn btn-small"><i class="icon-edit-sign"></i> Change</button>
				</div><!--changeControl-->

<br><br>	

				<div class="well well-small clinical-module" id="Master Record" rel="<%=request.getContextPath() %>/demographic/demographiccontrol.jsp?demographic_no=1&displaymode=edit">
					Master Record
				</div>	
				<div class="well well-small clinical-module" id="Encounter" rel="<%=request.getContextPath() %>/casemgmt/forward.jsp?action=view&demographicNo=1">
					Encounter
				</div>
				<div class="well well-small clinical-module" id="Referral History" rel="<%=request.getContextPath() %>/">
					Referral History
				</div>

			</div>	

					
		</div><!--Left Sidebar content-->

			<div class="span8"><!--Body content-->


			
			<div class="well" id="header-container">		
				<p class="head-lead muted" id="head-letterHeader" data-original="Please select a letterhead" data-success-msg="Letterhead">Please select a letterhead</p>
				

				<div id="letterHeaderFind" class="landingOptions">

				    <div class="input-append" style="text-align:left">
				    <input class="input-xlarge edit-btn-large finder" id="letterHeader" name="letterheadName" rel="letterHeader" type="text" data-provide="typeahead" data-items="4" 
					data-source='["McMaster Hospital","Wilson, John","Someother, Guy"]' autocomplete="off">
				    <button class="btn btn-large" type="button">Select</button>
				    <button type="button" class="btn btn-large modalShow">View List</button>
				    </div>

				</div><!--letterHeaderFind-->

				<div id="letterHeaderSelected" class="landingOptions hide">
				<!--I am for the selected letterhead option to display-->
				</div><!--letterHeaderSelected-->

				<div class="changeControl" id="letterHeaderChange">
				<button type="button" class="btn btn-change" rel="letterHeader"><i class="icon-edit-sign icon-large"></i> Change</button>
				</div><!--changeControl-->


			</div><!--header-container-->


			<div class="well" id="specialist-container">		
				<p class="head-lead muted" id="head-specialist" data-original="Find a specialist to send this request" data-success-msg="Specialist">Find a specialist to send this request</p>

				<div id="specialistFind" class="landingOptions">

 				<!--<div class="input-append" style="text-align:left">
				    <input class="input-xlarge edit-btn-large finder" name="specialty" id="specialty" rel="specialty" type="text" data-provide="typeahead" data-items="4" 
					data-source='["Cardiology","Dermatology","Neurology","Radiology"]' autocomplete="off" placeholder="Select Specialty">
				    <button class="btn btn-large" type="button">Select</button>
				</div>-->

				<i class="icon-question-sign icon-large" rel="popover" data-html="true" data-content="Adding a specialty will help refine the specialist list to the right to make it quicker for you to find the specialist you are looking for." data-original-title="Why add a specialty?" data-trigger="hover"></i> 					
				<select name="specialty" class="specialty">
				<option value="0">Specialty</option>
				<option value="1">Cardiology</option>
				<option value="2">Dermatology</option>
				<option value="3">Neurology</option>
				<option value="4">Radiology</option>
				</select>

				    <div class="input-append" style="text-align:left">
				    <input class="input-xlarge edit-btn-large finder" name="specialist" id="specialist" rel="specialist" type="text" data-provide="typeahead" data-items="4" 
					data-source='["Oscardoc, Doctor","Wilson, John","Someother, Guy"]' autocomplete="off" placeholder="Find Specialist">
				    <button class="btn btn-large" type="button">Select</button>
				    <button class="btn btn-large modalShow" type="button">View List</button>
				    </div>
				</div><!--specialistSelect-->

				<div id="specialistSelected" class="hide">
				
<div class="toDetails">

<p>
Consultant:<br/> 
<span class="muted">Dr. James Dean</span>
</p>

<p>
Service: <br/>
<span class="muted">Cardiology</span>
</p>
</div>

<div class="toDetails">
Address:<br>

<span class="muted">
<address>
1158 StreetName St. <br>
Hamilton Ontario L0R 4K3 <br>
<abbr title='Phone'>P:</abbr> 905-555-5555 <br>
<abbr title='Fax'>F:</abbr> 905-555-5552<br>
</address>
</span>
</div>



<div class="toDetails">

</div>
		

				</div><!--specialistSelected-->



				<div class="changeControl" id="specialistChange">
				<button type="button" class="btn btn-change" rel="specialist"><i class="icon-edit-sign icon-large"></i> Change</button>
				</div><!--changeControl-->
			</div>

			<div class="well">		
				<p class="head-lead muted">Referral</p>



<div class="toDetails">
Referral Date: <br>
<div class="input-append date" id="dp-referralDate" data-date="<%=date%>" data-date-format="yyyy-mm-dd" title="Referral Date">
<input style="width:90px" name="referralDate" id="referralDate" size="16" type="text" value="<%=date%>" placeholder="Enter Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$">
<span class="add-on"><i class="icon-calendar"></i></span> 
</div>

<br/>
Urgency: <br>
<select name="urgency">
<option value="2">Non-Urgent</option>
<option value="1">Urgent</option>
<option value="3">Return</option>
</select>
</div>

<div class="toDetails">
Referrer Instructions:<br>
<textarea cols="80" rows="4" style="width:400px;height:80px;"></textarea>
</div>

</div>

			<div class="well">		
				<p class="head-lead muted">Appointment</p>

<div class="toDetails">
<p>
Patient Will Book: <input type="checkbox">
</p>

Appointment Date: <br>
<div class="input-append date" id="dp-appointmentDate" data-date="<%=date%>" data-date-format="yyyy-mm-dd" title="Appointment Date">
<input style="width:90px" name="appointmentDate" id="appointmentDate" size="16" type="text" value="" placeholder="Enter Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$">
<span class="add-on"><i class="icon-calendar"></i></span> 
</div>

<br/>

Appointment Time:<br/>
<select name="appointmentHour" class="time">
<option value="1">1</option>

<option value="2">2</option>

<option value="3">3</option>

<option value="4">4</option>

<option value="5">5</option>

<option value="6">6</option>

<option value="7">7</option>

<option value="8">8</option>

<option value="9">9</option>

<option value="10">10</option>

<option value="11">11</option>

<option value="12">12</option>
</select>

<select name="appointmentMinute" class="time">
<option value="0">00</option>

<option value="1">01</option>

<option value="2">02</option>

<option value="3">03</option>

<option value="4">04</option>

<option value="5">05</option>

<option value="6">06</option>

<option value="7">07</option>

<option value="8">08</option>

<option value="9">09</option>

<option value="10">10</option>

<option value="11">11</option>

<option value="12">12</option>

<option value="13">13</option>

<option value="14">14</option>

<option value="15">15</option>

<option value="16">16</option>

<option value="17">17</option>

<option value="18">18</option>

<option value="19">19</option>

<option value="20">20</option>

<option value="21">21</option>

<option value="22">22</option>

<option value="23">23</option>

<option value="24">24</option>

<option value="25">25</option>

<option value="26">26</option>

<option value="27">27</option>

<option value="28">28</option>

<option value="29">29</option>

<option value="30">30</option>

<option value="31">31</option>

<option value="32">32</option>

<option value="33">33</option>

<option value="34">34</option>

<option value="35">35</option>

<option value="36">36</option>

<option value="37">37</option>

<option value="38">38</option>

<option value="39">39</option>

<option value="40">40</option>

<option value="41">41</option>

<option value="42">42</option>

<option value="43">43</option>

<option value="44">44</option>

<option value="45">45</option>

<option value="46">46</option>

<option value="47">47</option>

<option value="48">48</option>

<option value="49">49</option>

<option value="50">50</option>

<option value="51">51</option>

<option value="52">52</option>

<option value="53">53</option>

<option value="54">54</option>

<option value="55">55</option>

<option value="56">56</option>

<option value="57">57</option>

<option value="58">58</option>

<option value="59">59</option>
</select>

<select name="appointmentPm" class="time">
<option value="AM">AM</option>
<option value="PM">PM</option>
</select>

</div>

<div class="toDetails">
Appointment Notes:<br/>
<textarea name="appointmentNotes" cols="80" rows="2" style="width:400px;height:50px;"></textarea><br/>

Last Follow Up Date:<br/> 
<div class="input-append date" id="dp-followUpDate" data-date="<%=date%>" data-date-format="yyyy-mm-dd" title="Follow Up Date">
<input style="width:90px" name="followUpDate" id="followUpDate" size="16" type="text" value="" placeholder="Enter Date" pattern="^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01])$">
<span class="add-on"><i class="icon-calendar"></i></span> 
</div>

</div>

<br>
Appointment Location <small>(if different from specialist address)</small><br>
<select name="appointmentLocation" class="span8">
<option value="1">Dr. James Dean - 1158 StreetName St., Hamilton Ontario L0R 4K3</option>
<option value="2">Dr. James Dean - Hospital 50 StreetName St., Hamilton Ontario L8h 0X0</option>
</select>
			</div>

			<div class="well" id="clinical-note">		
				<p class="head-lead muted" style="display:inline;">Create Clinical Notes </p> <i class="icon-question-sign icon-large" rel="popover" data-html="true" data-content="Clinical notes are so you can add a reason for consultation, include detailed data from the patients echart or simply create a custom note that you would like added to the conslultation." data-original-title="What is a Clinical Note?" data-trigger="hover"></i>


<div  id="noteHideOut">

<div id="note-left-side" class="sidebyside">
<span class="label noteTitle-label">Step 1</span> Add a Title:<br>
<input type="text" name="noteTitle" id="noteTitle" class="checkNote noteTitle" data-provide="typeahead" data-items="6" 
data-source='["Reason for Consultation","Pertinent clinical information","Significant concurrent problems","Current Medications","Allergies"]' autocomplete="off" placeholder="Title">
<br>
<span class="label noteBody-label">Step 2</span> Create Note:<br>
<textarea id="noteBody" class="checkNote noteBody" placeholder="When creating a note use the Medical Summaries to the right to help you create the note with data from the patients chart."></textarea>
</div><!--note-left-side-->

<div id="note-right-side" class="sidebyside">
Medical Summary: <small>add chart data to note</small><br>

<button type="button" class="btn btn-tags one" id="one">Family History</button> 
<button type="button" class="btn btn-tags two" id="two">Medical History</button> 
<button type="button" class="btn btn-tags three" id="three">Ongoing Concerns</button>
<button type="button" class="btn btn-tags four" id="four">Other Meds</button>
<button type="button" class="btn btn-tags five" id="five">Reminders</button>
<button type="button" class="btn btn-tags six" id="six">item 6</button>
<button type="button" class="btn btn-tags seven" id="seven">item 7</button>

</div>

<div style="display:none;" id="createdNoteSection">
notes after added will display here???
<button type="button" class="btn"><i class="icon-edit-sign icon-large"></i> Edit</button>
</div>

</div>
				<div class="changeControl" style="display:block">
				<button type="button" class="btn noteShow"><i class="icon-plus-sign-alt icon-large"></i> Add</button> 
				</div><!--changeControl-->				
			</div>

			</div><!--Body content-->

		<div class="span2"><!--Right Sidebar content-->
		
				
		</div><!--Right Sidebar content-->

	</div>
</div>


<!--modal campground-->

<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
<h3 id="myModalLabel">Select Option</h3>
</div>
<div class="modal-body">
<p>complete list</p>
</div>
<div class="modal-footer">
<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>

<!--<button class="btn btn-primary">Save changes</button>-->
</div>
</div>



<div id="confirmModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="confirmModalLabel" aria-hidden="true">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
<h3 id="confirmModalLabel">Are you sure?</h3>
</div>
<div class="modal-body">
<p><i class="icon-warning-sign icon-large"></i> Please confirm that you would like to save this Consultaion Request!</p>
</div>
<div class="modal-footer">
<button class="btn" data-dismiss="modal" aria-hidden="true">No, continue editing</button>
<button class="btn btn-primary" type="submit">Yes, save</button>
</div>
</div>

<div id="cancelModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="cancelModalLabel" aria-hidden="true">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
<h3 id="cancelModalLabel">Are you sure?</h3>
</div>
<div class="modal-body">
<p><i class="icon-warning-sign icon-large"></i> Please confirm that you would like to exit this Consultaion Request!</p>
</div>
<div class="modal-footer">
<button class="btn" data-dismiss="modal" aria-hidden="true">No, continue editing</button>
<a href="<%=request.getContextPath() %>/consult/" class="btn btn-primary">Yes, Exit</a>
</div>
</div>


<div id="deleteModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
<h3 id="deleteModalLabel">Are you sure?</h3>
</div>
<div class="modal-body">
<p><i class="icon-warning-sign icon-large"></i> Please confirm that you would like to DELETE this Consultaion Request!</p>
</div>
<div class="modal-footer">
<button class="btn" data-dismiss="modal" aria-hidden="true">No, continue editing</button>
<button class="btn" data-dismiss="modal" aria-hidden="true">class="btn btn-danger">Yes, Delete</button>
</div>
</div>


<div id="noteModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="noteModalLabel" aria-hidden="true">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
<h3 id="noteModalLabel">Title</h3>
</div>
<div class="modal-body" id="noteSelection">

display options from echart to select and add to note

</div>
<div class="modal-footer">
<button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
<button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Add</button>
</div>
</div>



<div id="wrapper-action">

			<div id="inner-action" style="display:inline; ">			
			<button type="button" class="btn btn-large confirmCancel">Cancel</button> 

			<% if(request.getParameter("id")!=null){%>
			<button type="button" class="btn btn-large btn-primary confirmSave">Update</button>
			<%}else{%>
			<button type="button" class="btn btn-large btn-primary confirmSave">Save</button>
			<%}%>
			

			<% if(request.getParameter("id")!=null){%>
			<button type="button" class="btn btn-large btn-danger confirmDelete">Delete</button>  
			<%}%>


			<div id="inner-scroll" style="display:inline-block;width:60px;margin-left:20px;margin-right:20px; text-align:center;vertical-align:bottom;">
			<span id="scrollToTop" class="DoNotPrint" title="scroll to top"><a href="#consultFormBody" class="DoNotPrint"><i class="icon-circle-arrow-up icon-3x"></i></a></span>
			</div>

			</div>


</div>

</form>
    
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/DT_bootstrap.js"></script>   


<script type="text/javascript">
$(function (){
	$("[rel=popover]").popover({});  
	$('[id^=dp-]').datepicker();
});

; 
$( document ).ready(function() {

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

$(".modalShow").click(function(){
	$('#myModal').modal('toggle');
});

$(".confirmSave").click(function(){
	$('#confirmModal').modal('toggle');
});

$(".confirmCancel").click(function(){
	$('#cancelModal').modal('toggle');
});


$('.typeahead').typeahead();


$(".finder").change(function(){

var rel = $(this).attr("rel");
var id = $(this).attr("id");

$("#"+rel+"Find").hide();

$('#head-'+rel).html("<i class='icon-ok-sign'></i> " + $('#head-'+rel).attr('data-success-msg'));

if(rel=="letterHeader"){
//this is a static example but these address values should be dynamic-->
$("#letterHeaderSelected").html("<div class='fromName'><h1>" + $(this).val() + "</h1><p class='lead'>Consultation Request</p> </div> <div class='fromAddress'><address><strong>Facility Name</strong> <br> 26 Hamilton St. <br>Hamilton Ontario L0R 4K3 <br><abbr title='Phone'>P:</abbr> 555-555-5555 <br><abbr title='Fax'>F:</abbr> 555-555-5552<br></address></div>");
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

//$("#noteCreator").toggle();
$("#noteHideOut").toggle();


});

$(".btn-tags").click(function(){

$('#noteModal').modal('toggle');

var id = $(this).attr("id");
if ($(this).hasClass('btn-success active')) {
        $('.'+ id).removeClass('btn-success active');
    } else { 
	$('.'+ id).addClass('btn-success active');
    } 
});

$(".checkNote").change(validate).keyup(validate);

function validate()
{
var v = $(this).val();
var id = $(this).attr("id");

if (v!="") {
        $('.'+ id+"-label").addClass('label-success');
    } else {
        $('.'+ id+"-label").removeClass('label-success');
    } 
}

});
</script>

</body>
</html>
