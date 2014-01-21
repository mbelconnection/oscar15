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
<!doctype html>
<head>
		<link rel="stylesheet"  type="text/css" href="css_up/calendar.css" />
		
<!-- pop up script links -->
		<link rel="stylesheet" href="css_up/jquery-ui.css">
		<link rel="stylesheet" type="text/css" media="all" href="css_up/jsDatePick_ltr.min.css" />
		
<link href="css_up/style.css" rel="stylesheet" type="text/css" media="all" />
<style>
.tabs_underline{
	border-bottom: #cecece 1px solid;
}
.tabs li {
	list-style:none;
	display:inline;
}

.tabs a {
	padding:5px 2px;				
	text-align:center;
	display:inline-block;				
	text-decoration:none;				
	vertical-align:bottom;
	color:#000;
	font-weight:700;
	font-family:calibri;
	font-size:14px;
}

.tabs a.active {
	background: #3B9C9C;
	color: #fff;
	border: #cecece 1px solid;
	border-bottom: 0px !important;
	font-weight:700;
	font-family:calibri;
	font-size:14px;
}
	.leftdiv{
width:45%;
padding:3 0 4 4;
display: inline;
}
.rightdiv{
width:35%;
}
.wrapper {
    border:1px solid #C0C0C0;
    display:inline;
	width:50px;
}
.left{
float:left;
display:inline-block;
width:47%;
height: 100%;
}
.right{
border-left: 1px solid #0C0C0C;
display: inline-block;
float: right;
padding-left: 49px;
width: 47%;
height: 100%;
}
h4{
margin:0;
}
.ui-widget-content {
    background: url("img/ui-bg_flat_75_ffffff_40x100.png") repeat-x scroll 50% 50% #FFFFFF;
    border: 0px solid #AAAAAA;
    color: #222222;
    height: 80%;
}
.ui-tabs .ui-tabs-panel {
    background: none repeat scroll 0 0 rgba(0, 0, 0, 0);
    border-width: 0;
    display: block;
    padding: 1em 1.4em;
}

.ui-autocomplete-category {
    font-weight: bold;
    padding: .2em .4em;
    margin: .8em 0 .2em;
    line-height: 1.5;
  }
select{
width:150px;
}
label{
width: 140px;
display: inline-block;
}
.ui-button-text-only .ui-button-text {
    padding: 2px;
}

#backgroundPopup { 
	z-index:1;
	position: fixed;
	display:none;
	height:100%;
	width:100%;
	background:#000000;	
	top:0px;  
	left:0px;
}
#toPopup {
	font-family: "lucida grande",tahoma,verdana,arial,sans-serif;
    background: none repeat scroll 0 0 #FFFFFF;
    border: 10px solid #ccc;
    border-radius: 3px 3px 3px 3px;
    color: #333333;
    display: none;
	font-size: 14px;
    left: 35%;
    margin-left: -402px;
    position: fixed;
    top: 15%;
    width: 75%;
    z-index: 2;
}
div.loader {
    background: url("js_up/img/loader.gif") no-repeat scroll 0 0 transparent;
    height: 32px;
    width: 32px;
	display: none;
	z-index: 9999;
	top: 40%;
	left: 50%;
	position: absolute;
	margin-left: -10px;
}
div.close {
    background: url("js_up/img/closebox.png") no-repeat scroll 0 0 transparent;
    bottom: 24px;
    cursor: pointer;
    float: right;
    height: 30px;
    left: 27px;
    position: relative;
    width: 30px;
}
span.ecs_tooltip {
    background: none repeat scroll 0 0 #000000;
    border-radius: 2px 2px 2px 2px;
    color: #FFFFFF;
    display: none;
    font-size: 11px;
    height: 16px;
    opacity: 0.7;
    padding: 4px 3px 2px 5px;
    position: absolute;
    right: -62px;
    text-align: center;
    top: -51px;
    width: 93px;
}
span.arrow {
    border-left: 5px solid transparent;
    border-right: 5px solid transparent;
    border-top: 7px solid #000000;
    display: block;
    height: 1px;
    left: 40px;
    position: relative;
    top: 3px;
    width: 1px;
}
div#popup_content {
    margin: 4px 7px;
	width: 100%;
}
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default {
    background: url("js_up/images/ui-bg_glass_75_e6e6e6_1x400.png") repeat-x scroll 50% 50% #E6E6E6;
    border: 1px solid #D3D3D3;
    color: #555555;
    font-weight: normal;
}
.ui-widget .ui-widget {
    font-size: 1em;
}
.ui-widget input, .ui-widget select, .ui-widget textarea, .ui-widget button {
    font-family: Verdana,Arial,sans-serif;
    font-size: 1em;
}
.ui-corner-all, .ui-corner-bottom, .ui-corner-right, .ui-corner-br {
    border-bottom-right-radius: 4px;
}
.ui-corner-all, .ui-corner-bottom, .ui-corner-left, .ui-corner-bl {
    border-bottom-left-radius: 4px;
}
.ui-corner-all, .ui-corner-top, .ui-corner-right, .ui-corner-tr {
    border-top-right-radius: 4px;
}
.ui-corner-all, .ui-corner-top, .ui-corner-left, .ui-corner-tl {
    border-top-left-radius: 4px;
}
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default {
    background: url("images/ui-bg_glass_75_e6e6e6_1x400.png") repeat-x scroll 50% 50% #E6E6E6;
    border: 1px solid #D3D3D3;
    color: #555555;
    font-weight: normal;
}
.ui-widget {
    font-family: Verdana,Arial,sans-serif;
    font-size: 1.1em;
}
.ui-button, .ui-button:link, .ui-button:visited, .ui-button:hover, .ui-button:active {
    text-decoration: none;
}
.ui-button {
    cursor: pointer;
    display: inline-block;
    line-height: normal;
    margin-right: 0.1em;
    overflow: visible;
    padding: 0;
    position: relative;
    text-align: center;
    vertical-align: middle;
}
button, input, select[multiple], textarea {
 background-image: url("images/ui-bg_glass_75_e6e6e6_1x400.png") repeat-x scroll 50% 50% #E6E6E6;
}
input, button, select, textarea {

}
</style>
		<script>
		function setDate(){
			new JsDatePick({
				useMode:2,
				target:"inputField",
				dateFormat:"%d-%M-%Y"

			});
			todayDate();
		}
//function page_init(){
//	jQuery("#testcode").load("addAppointment.html");
//}

function showTabData(id1,id2,id3){
	
	
	if(id1 == 'weekdivid'){
		sch.init('week');
		document.getElementById('daydiv').style.display = "block";
		document.getElementById(id2).style.display = "none";
		document.getElementById(id3).style.display = "none";
	}else if(id1 == 'daydiv'){
		sch.init('day');
		document.getElementById(id1).style.display = "block";
		document.getElementById(id2).style.display = "none";
		document.getElementById(id3).style.display = "none";
	}else{
		document.getElementById(id1).style.display = "block";
		document.getElementById(id2).style.display = "none";
		document.getElementById(id3).style.display = "none";
	}
	if(id1 == 'flipview'){
		showdata();
	}
	
}

$.widget( "custom.catcomplete", $.ui.autocomplete, {
    _renderMenu: function( ul, items ) {
      var that = this,
        currentCategory = "";
      $.each( items, function( index, item ) {
        if ( item.category != currentCategory ) {
          ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
          currentCategory = item.category;
        }
        that._renderItemData( ul, item );
      });
    }
  });

$(function() {
    var data = [
      { label: "Dr.Tony", category: "individual" },
      { label: "Dr.Tom", category: "individual" },
      { label: "Dr.Jackson", category: "individual" },
      { label: "Dr.Kate", category: "individual" },
      { label: "Dr.Smith", category: "individual" },
      { label: "groupA", category: "group" },
      { label: "groupB", category: "group" },
      { label: "groupC", category: "group" }
    ];
 
    $( "#docava" ).catcomplete({
      delay: 0,
      source: data
    });
  });
  
</script>
		<table  width="100%" class="headertable" id="secNav">
			<tr>
				<td class='tabs_underline' style="padding:5px;width:160px;">
					<div class="date_selector" >
						<table class="eventtab" style="width:100%;border-collapse:collapse;padding:0px;" id="tab"  cellspacing="0" >
							<tr class=""> 
								<td class="date_selector_td_left_right"><input type="image" src="js_up/images/arrow_left.png" onclick="dateChange('dec')"/></td>
								<td class="date_selector_td_ltline date_selector_td_mid" style="text-align:center;" ><input type="text" size="12" id="inputField" readonly="readonly" class="input1" /></</td>
								<td class="date_selector_td_ltline date_selector_td_left_right"><input type="image" src="js_up/images/arrow_right.png" onclick="dateChange('inc')"/></td>
							</tr>
						</table>
					</div>
				</td>			
				<td class='tabs_underline' style='vertical-align:bottom;width:300px;'>
					<ul class='tabs' style='width:300px !important;'>				
						<li style='margin-left:5px;'><a style='width:50px;' id='daydivid' onclick="showTabData('daydiv','flipview','monthdiv')">Day</a></li>
						<li><a style='width:80px;' id='flipdivid' onclick="showTabData('flipview','daydiv','monthdiv');">Flip Days</a></li>
						<li><a style='width:50px;' onclick="showTabData('weekdivid','flipview','monthdiv')" id='weekdivid'>Week</a></li>
						<li><a style='width:60px;' onclick="showTabData('monthdiv','flipview','daydiv')" id='mondivid'>Month</a></li>
					</ul>
				</td>
				<td>
					<table>
						<tr>
							<td style='border-left:1px solid #cecece;padding-left:5px;width:80px;' class='gen_font'>
								Appointments:
							</td>
							<td style='width:110px;'>
								<div class='box_nextavail' style='cursor:pointer;'> +&nbsp;Next available</div>
							</td>
							<td style='width:110px;'>
								<div class='box_nextavail' style='cursor:pointer;'> Find existing</div>
								<div id="testcode">old content</div>
							</td>
						</tr>
					</table>
				</td>
				<td style='border-left:1px solid #cecece;padding-left:5px;' class='gen_font'>
					<input id="docava">
				</td>
				
			</tr>
		</table>	

		
		
		<!-- Day and week view-->
		<div id='daydiv' style='padding-top:5px;display:block'>
			<div id='dayview'>
				<table style='border-collapse:collapse;padding:0px;float: left;display: inline-block;' cellpadding="0" cellspacing="0" border="0">
					<tr><td id='head' style="border-bottom: 0px !important;"></td></tr>
					<tr><td id='providerdiv'></td></tr>
				</table>
			</div>
		</div>
		<!-- Flip days view-->
		<div id='tab2' style='padding-top:5px;font-family:calibri;'>
			<div id='flipview' style='display:none;'></div>
		</div>	
		<!-- Month view-->
		<div id='monthdiv' style='padding-top:5px;display:none;'>
			<div id='header'></div>
			<div id='monthview'></div>
			
			<!--<div id='weekview' style='display:none;'>
				<table style='border-collapse:collapse;padding:0px;float: left;display: inline-block;' cellpadding="0" cellspacing="0" border="0">
					<tr><td id='weekheader' style="border-bottom: 0px !important;"></td></tr>
					<tr><td id='weekdiv'></td></tr>
				</table>
			</div> -->
		</div>
<script>
function syncScrollBars(){
	$("#persondata").scroll(function () { 
			$("#persondatadummy").scrollTop($("#persondata").scrollTop());
			$("#persondatadummy").scrollLeft($("#persondata").scrollLeft());
		});
	$("#persondatadummy").scroll(function () { 
			$("#persondata").scrollTop($("#persondatadummy").scrollTop());
			$("#persondata").scrollLeft($("#persondatadummy").scrollLeft());
		});

	$("#names").scroll(function () { 
			$("#persondatadummy").scrollTop($("#names").scrollTop());
			$("#persondatadummy").scrollLeft($("#names").scrollLeft());
		});
	$("#persondatadummy").scroll(function () { 
			$("#names").scrollTop($("#persondatadummy").scrollTop());
			$("#names").scrollLeft($("#persondatadummy").scrollLeft());
		});
}

var sch = new Schedular();

/* 
	author: istockphp.com
*/
$(function() {
	
	 

	/************** end: functions. **************/
}); // jQuery End




/************** start: functions. **************/
	function loading() {
		$("div.loader").show();
	}
	function closeloading() {
		$("div.loader").fadeOut('normal');  
	}
	
	var popupStatus = 0; // set value
	
	function loadPopup() { 
		
		if(popupStatus == 0) { // if value is 0, show popup
			closeloading(); // fadeout loading
			$("#toPopup").fadeIn(0500); // fadein popup div
			$("#backgroundPopup").css("opacity", "0.7"); // css opacity, supports IE7, IE8
			$("#backgroundPopup").fadeIn(0001);
			loadFieldData();
			popupStatus = 1; // and set value to 1
		}
	}
	function loadPopupEdit() { 
		if(popupStatus == 0) { // if value is 0, show popup
			closeloading(); // fadeout loading
			$("#toPopup").fadeIn(0500); // fadein popup div
			$("#backgroundPopup").css("opacity", "0.7"); // css opacity, supports IE7, IE8
			$("#backgroundPopup").fadeIn(0001);
			loadFieldData();
			popupStatus = 1; // and set value to 1
		}
	}
		
	function disablePopup() {
		if(popupStatus == 1) { // if value is 1, close popup
			$("#toPopup").fadeOut("normal");  
			$("#backgroundPopup").fadeOut("normal");  
			popupStatus = 0;  // and set value to 0
		}
	}
	function loadFieldData(){
    $.getJSON("js_up/demo_ajax_json.js",function(result){
	  $.each(result, function(i, obj){
		  if(i=="generalInfo"){
		for(key in obj){
				$("#singleProvidSel").append("<option value='"+key+ "'>"+obj[key]['firstName']+""+" "+obj[key]['lastName']+"</option>");
				$("#multiProvidSel").append("<option value='"+key+ "'>"+obj[key]['firstName']+""+" "+obj[key]['lastName']+"</option>");
		}}else if(i=="appointmentType"){
			for(key in obj){
				$("#apptType").append("<option value='"+obj[key]['id']+ "'>"+obj[key]['val']+"</option>");
			}
		}else if(i=="appointmentStatus"){
			for(key in obj){
				//console.log(obj[key]['id']);
				$("#apptStatus").append("<option value='"+obj[key]['id']+ "'>"+obj[key]['id']+""+" - "+obj[key]['val']+"</option>");
			}
		}else if(i=="appTime"){
			for(key in obj){
				$("#apptTime").append("<option value='"+obj[key]['id']+ "'>"+obj[key]['val']+"</option>");
			}
		}
      }); 
    });
	}
// Speed up calls to hasOwnProperty
var hasOwnProperty = Object.prototype.hasOwnProperty;

function isEmpty(obj) {

    // null and undefined are "empty"
    if (obj == null) return true;

    // Assume if it has a length property with a non-zero value
    // that that property is correct.
    if (obj.length > 0)    return false;
    if (obj.length === 0)  return true;

    // Otherwise, does it have any properties of its own?
    // Note that this doesn't handle
    // toString and toValue enumeration bugs in IE < 9
    for (var key in obj) {
        if (hasOwnProperty.call(obj, key)) return false;
    }

    return true;
}
	function setDate(){
		new JsDatePick({
			useMode:2,
			target:"inputField",
			dateFormat:"%d-%M-%Y"

		});
		todayDate('inputField');
	}
	
	function todayDate(id){
		
		var date = new Date();        
		var day = date.getDate();        
		var month = date.getMonth();
		var year = date.getYear();        
		if(year<=200)        {                
			year += 1900;        
		}        
		var days = new Array('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
		months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');        
		days_in_month = new Array(31,28,31,30,31,30,31,31,30,31,30,31);        
		if(year%4 == 0 && year!=1900)        {                
			days_in_month[1]=29;        
		}        
		total = days_in_month[month];        
		var date_today = day+"-"+months[month]+"-"+year;
		document.getElementById(id).value = date_today;
	}
function page_init(){
$("#testcode").load("partials/addAppointment.jsp");
}


var sch = new Schedular();
sch.init('day');
setDate();
page_init();

</script>
