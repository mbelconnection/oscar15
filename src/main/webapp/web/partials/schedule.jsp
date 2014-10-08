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
<!-- link rel="stylesheet"  type="text/css" href="css_up/calendar.css" /> -->
<style>
body{ 
padding:50px 8px 0;
}
.clear {clear: both;}
.cal_calendar {
	border: #cecece 1px solid;
    padding: 1px;       
    width:100%;        
    margin:auto;        
    height:350px;        
	border-collapse:collapse;
	font-family:calibri;
    color:#362d26;
}

.cal_calendar th{        
    border:1px solid black;        
    width: 100px;
	height:25px;
	font-size:12px;
	font-weight:700;
	text-align:center !important;
	background-color: #F5F5DC;	
	border: #cecece 1px solid;
}.cal_calendar td {
    border: 1px solid black;
    background-color: #ffffff;
    text - align: center;
    width: 36px;
    height: 80px;
	border: #cecece 1px solid;	
	font-size:19px;
}.cal_today {
	background-color: #fff3a1 !important;
}.cal_days_bef_aft {
    color: #bbb; !important;
	height:20px !important;
	text-align:right;
	border:0px !important;
}

.cal_inner_table{
	text-align:right;height:20px !important;border:0px !important;
}

.cal_inner_td1{
	text-align:right;height:20px !important;border:0px !important;
}

.cal_inner_td2{
	border:0px !important;
	font-size:12px !important;
}

.sch_header {
	border: #cecece 1px solid;
    padding: 1px;       
    width:100%;        
    margin:auto;        
    height:20px;        
	border-collapse:collapse;
	font-family:calibri;
	color:#362d26;
	margin-bottom:10px !important;
	border: #FFFFFF 1px solid;
}

.sch_header th{        
    border:1px solid black;        
    width: 100px;
	height:25px;
	font-size:12px;
	font-weight:500;
	text-align:center !important;
	background-color: #F5F5DC;	
	border: #cecece 1px solid;
}

.sch_left_ctrl {
	border: #cecece 1px solid;
    padding: 1px;       
    margin:auto;   
	width:160px;
    height:25px !important;        
	border-collapse:collapse;
	font-family:calibri;
	color:#362d26;
	margin-bottom:10px !important;
}

.sch_left_ctrl tr{
	border: #cecece 1px solid;
    padding: 1px;       
    margin:auto;        
    height:105px !important;        
}

.sch_left_ctrl td{
	border: #cecece 1px solid;
    padding: 1px;       
    margin:auto;        
    height:25px !important;
	width:25px !important;
}


.xscale {
	
    padding: 1px;           
    margin:auto;        
	border-collapse:collapse;
	font-family:calibri;
	font-size:12px;
	color:#362d26;
	border-right: 0px !important;
	border-left: #cecece 1px solid;
	border-top: #cecece 1px solid;
	border-bottom: #cecece 1px solid;
}
.xscale td {
    border: 1px solid black;
    background-color: #ffffff;
    text - align: center;
    width: 36px;
    height: 25px;
	border: #cecece 1px solid;	
	border-left:0px #FFFFF;
	border-right: 0px !important;
}

.Yscale {
	border: #cecece 1px solid;
    padding: 1px;          
    margin:auto;        
	border-collapse:collapse;
	font-family:calibri;
	font-size:12px;
	color:#362d26;
}

.Yscale th {
    border: 1px solid black;
    background-color: #FFFFFF;
    text - align: center;
    width: 220px !important;
    height: 25px;
	border: #cecece 1px solid;	
	border-left:0px #FFFFF;
	display: table-cell !important;

}

.noline {
    /*background-color: #ffffff;*/
    text-align: center;
    /*width: 150Px !important;
    height: 25px;
	border-top: #FFFFFF 1px solid;	
	border-right: #cecece 1px solid;*/
	opacity: 0.25 !important;
	border-right-width:1px !important;
	border-right-style:solid !important;
	border-right-color:#000 !important;
}

.withline {
    background-color: #ffffff;
    text-align: center;
    /*width: 150px !important;
    height: 25px;
	border: #cecece 1px solid;
	border-width:1px 1px 0 0;
	border-left:0px;
	border-bottom:0px;*/
	opacity: 0.25 !important;
	border-top-width:1px !important;
	border-top-style:solid !important;
	border-top-color:#000 !important;
	border-right-width:1px !important;
	border-right-style:solid !important;
	border-right-color:#000 !important;
}


/*#999998_18:00 {background-color: #BDBDBD !important;}*/

.scrolldiv {
    overflow:scroll;
	width:1200px;
	overflow-y:hidden;
}

.scrolldiv2{
    overflow:scroll;
	height:100%;/* modified by Bhaskar */
	overflow-x:hidden;
}

.evtpop{-moz-border-radius:10px;-webkit-border-radius:5px;border-radius:5px;padding:0px;}
.evtpop_td{
	font-size:12px;height:19px;width:30px;text-align:center;
}
.evtpop_td_ltline{
	font-size:12px;height:19px;border-left: #cecece 1px solid;padding-left:3px;padding-right:3px;
}

.evtpop_td_btm_line{
	border-bottom: #cecece 1px solid;font-family:calibri;font-size:12px;
}

.eventpop{
	width:170px;height:19px;background-color:#fff;border:1px solid #cecece;padding:5px 5px 5px 10px;
	-moz-border-radius:10px;-webkit-border-radius:5px;border-radius:5px;padding:0px;
	position:relative;font-family:calibri;
}

.eventtab{	
	position:static;
}


* {padding:0; margin:0;}





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

.datetable_td{
	border: #cecece 1px solid;
}

.basictable{
	border:1;
	border-collapse:collapse;
	cellPadding:0px;
	cellSpacing:0px;
}
.table_round_corners{
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	border-radius: 6px;
	border: #cecece 1px solid;
}

.headertable{
	border: #cecece 1px solid;
	border-collapse:collapse;
	height:40px;
	width: 100% !important;
}
			


			
.date_selector_td{
	font-size:12px;height:20px;width:30px;text-align:center;
}
.date_selector_td_ltline{
	font-size:12px;height:24px;border-left: #cecece 1px solid;padding-left:0px;padding-right:0px;
}
.date_selector_td_left_right{
	width:18px;
	text-align:center;
	padding-top:1px;
}
.date_selector_td_mid{
	width:80px;
}

.date_selector{
	width:145px;
	height:25px;
	border:1px solid #cecece;
	padding:0px;
	-moz-border-radius:10px;
	-webkit-border-radius:5px;
	border-radius:5px;	
	font-family:calibri;
}

.box_nextavail{
	width:100px;
	height:20px;
	border:1px solid #cecece;
	padding:0px;
	text-align:center;
	-moz-border-radius:4px;
	-webkit-border-radius:4px;
	border-radius:4px;
	font-family:calibri;
	font-size:13px;
}

.gen_font{
	font-family:calibri;
	font-size:11px;
}

.gen_font1{
	font-family:calibri;
	font-size:12px;
}

.gen_font2{
	font-family:calibri;
	font-size:12px;
	line-height:98%;
	letter-spacing:0.02em;
	padding-top:1px;
}

.gen_font3{
	color:#000000;
	font-weight:bold;
}


.input1{
	border:0px;
	font-family:calibri;
	font-size: 14px;
	text-align:center;
	cursor:pointer;
	margin-bottom: 3px !important;
}

.alertbox{
	width:15px;
	height:14px;
	border:1px solid #5E5A80;
	background:#5E5A80;
	color:#fff;
	padding:0px;
	-moz-border-radius:3px;
	-webkit-border-radius:3px;
	border-radius:3px;	
	font-family:calibri;
	font-weight:bold;
}
.zoomIn{
float:right;text-decoration:underline;cursor:pointer;width:18%;text-align:right;
}
.nav > li > a{
	/*font-family: calibri;*/
	display: block;
    /*padding: 15px;*/
    position: relative;
}
</style>
 <style>
 .searchIcon {
    background:#FFFFFF url(js_up/images/search-icon.png) no-repeat 4px 4px;
    padding:4px 4px 4px 22px;
    height:18px;
}
 </style>
		
<!-- pop up script links -->
		
<link rel="stylesheet" type="text/css" media="all" href="css_up/jsDatePick_ltr.min.css" />
		
<link href="css_up/style.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/library/bootstrap/3.0.0/assets/js/DT_bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/bootstrap-datepicker.js"></script>
<!-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/jquery-ui.min.js"></script>
    <link rel="stylesheet" type="text/css" media="screen" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/themes/base/jquery-ui.css">-->

 <div id="consult-list" data-ng-init="init(1236)">
  <select id="demographicNo" class="form-control" style="display: none; width: 200px;" ng-model="demographicNo">
    	<option value="{{demographic.day}}" ng-repeat="demographic in demographics">{{demographic.day}}</option>
	</select>&nbsp;
<style>
.tabs_underline{
	border-bottom: #cecece 1px solid;
}
.tabs li {
	list-style:none;
	display:inline;
}
.weekColor{
color:	#6495ED;
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
    background: url("js_up/images/ui-bg_flat_75_ffffff_40x100.png") repeat-x scroll 50% 50% #FFFFFF;
    border: 0px solid #AAAAAA;
    color: #222222;
    height: 90%;
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
margin-left: -2px;
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
    opacity: 0.25;
    padding: 4px 3px 2px 5px;
    position: absolute;
    right: -62px;
    text-align: center;
    top: -51px;
    width: 93px;
}
.tooltip-inner{
max-width:200px;padding:3px 8px;color:#848484;text-align:center;text-decoration:none;background-color:#fff;border-radius:4px;border: 1px solid #848484;
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
    background: url("js_up/images/ui-bg_glass_75_e6e6e6_1x400.png") repeat-x scroll 50% 50% #E6E6E6;
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
 background-image: url("js_up/images/ui-bg_glass_75_e6e6e6_1x400.png") repeat-x scroll 50% 50% #E6E6E6;
}
input, button, select, textarea {

}

body .modal-sm {
    /* new custom width */
    width: 400px;
    /* must be half of the width, minus scrollbar on the left (30px) */
}â
</style>
<script>



function showTabData(id1,id2,id3,id4,selectDropVal){
	var id_a ="#"+id4;
	//$(".tabs li a").css('background-color', '#FFF');
	$(id_a).css('font-weight', 'bold');
	selectDropVal = globalProviderId; /* Added by Bhaskar for the default value dynamically from the dropdown*/
	var pAnch = document.getElementById(id4);
	var pLi = pAnch.parentNode;
	var allLis = $( "li" );
	$( "ul" ).find(allLis).removeClass("active");
	$( "ul" ).find(pLi).addClass("active");
	var dt = document.getElementById("inputField").value;
	if(id1 == 'weekdivid'){
		$("#clock_img").show();
		$("#menuOptions").hide();
		globalView.view="week";		
		setWeekDates("", selectDropVal);
		globalProviderId="103";
		countForlabeltext=0;
		/*Below line added by Bhaskar for week view for datachange */
		
		document.getElementById('daydiv').style.display = "block";
		document.getElementById(id2).style.display = "none";
		document.getElementById(id3).style.display = "none";
		var groupId = $("#docava").val()!=""?$("#docava").val().split("_"):"_";
		var groupId1 = groupId[1];
		if(groupId1!=null && groupId1.indexOf("Group")>-1){
		var sz = globalPatName!= null? globalPatName:new Object();
		var der = $("#weekDropId option[value='"+selectDropVal+"_Group']").text();
		globalPatName = new Object();
		globalPatName.id = (sz.id ==undefined?selectDropVal+"_Group":sz.id);
		globalPatName.name = (sz.name ==undefined?der:sz.name);
		getDropDown("weekdivid","weekDropId","Week",globalPatName.name);
		$("#s2id_flipDropId").remove();
		}
	}else if(id1 == 'daydiv'){
		$("#clock_img").hide();
		$("#menuOptions").show();
		globalView.view="day";
		setDate();
		globalDayViewDate = $("#inputField").val();
		/*if($("#inputField").val() == "")
			setDate();
		else
			sch.load($("#inputField").val());*/
		dateChange("");
			
		document.getElementById(id1).style.display = "block";
		document.getElementById(id2).style.display = "none";
		document.getElementById(id3).style.display = "none";
		var groupId = $("#docava").val()!=""?$("#docava").val().split("_"):"_";
		var groupId1 = groupId[1];
		if(groupId1!=null && groupId1.indexOf("Group")>-1){
		$("#s2id_weekDropId").remove();
		$("#s2id_flipDropId").remove();
		//$('#flipdivid').html("Flip Days&nbsp;<b class='caret' onclick='getDropDown(\"flipdivid\",\"flipDropId\",\"Flip Days\")'></b>");
		//$('#weekdivid').html("Week&nbsp;<b class='caret' onclick='getDropDown(\"weekdivid\",\"weekDropId\",\"Week\")'></b>");
		}
	}else {
		//alert('month view');
		$("#clock_img").show();
		$("#menuOptions").hide();
		
		
		if(id1 != 'flipview'){
			globalView.view="month";
			setMonthDates("");
			calendar();
		}
		document.getElementById(id1).style.display = "block";
		document.getElementById(id2).style.display = "none";
		document.getElementById(id3).style.display = "none";
		var groupId = $("#docava").val()!=""?$("#docava").val().split("_"):"_";
		var groupId1 = groupId[1];
		if(groupId1!=null && groupId1.indexOf("Group")>-1){
		$("#s2id_weekDropId").remove();
		$("#s2id_flipDropId").remove();
		//$('#flipdivid').html("Flip Days&nbsp;<b class='caret' onclick='getDropDown(\"flipdivid\",\"flipDropId\",\"Flip Days\")'></b>");
		//$('#weekdivid').html("Week&nbsp;<b class='caret' onclick='getDropDown(\"weekdivid\",\"weekDropId\",\"Week\")'></b>");
		}
	}
	if(id1 == 'flipview'){
		globalProviderId="103";
		globalView.view = "flip";
		var groupSelBox = $("#docava").val()!=""?$("#docava").val().split("_"):"_";
		if(groupSelBox[1]=="Individual"){
			globalProviderId = groupSelBox[0];
		}else{
			globalProviderId = selectDropVal;
		}
		setFlipDates("");
		countForlabeltext=0;
		//showdata(selectDropVal);
		
		var groupId = $("#docava").val()!=""?$("#docava").val().split("_"):"_";
		var groupId1 = groupId[1];
		if(groupId1!=null && groupId1.indexOf("Group")>-1){
		var sz = globalPatName!= null? globalPatName:new Object();
		var der = $("#flipDropId option[value='"+selectDropVal+"_Group']").text();
		globalPatName = new Object();
		globalPatName.id = (sz.id ==undefined?selectDropVal+"_Group":sz.id);
		globalPatName.name = (sz.name ==undefined?der:sz.name);
		getDropDown("flipdivid","flipDropId","Flip Days",globalPatName.name);
		$("#s2id_weekDropId").remove();
		
		
		
		}
	}
	
}

function isGroupSelected(){
	var groupSelBox = $("#docava").val()!=""?$("#docava").val().split("_"):"_";
	if(groupSelBox[1] == "Group")
		return true;
	else
		return false;
}

function getMainGroupSelBoxVal(){
	//var groupSelBox = $("#docava").val()!=""?$("#docava").val().split("_"):"_";
	//return groupSelBox[0];
	return $("#docava").val();
}

function getFlipSelBoxVal(){
	var groupSelBox = $("#flipDropId").val()!=""?$("#flipDropId").val().split("_"):"_";
	return groupSelBox[0];
}

function getWeekSelBoxVal(){
	var groupSelBox = $("#weekDropId").val()!=""?$("#weekDropId").val().split("_"):"_";
	return groupSelBox[0];
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

    var data = [];
    var data1 = Schedular.config.providersList;
    $.ajax({
		url : "../ws/rs/providerService/getteam",
		type : "get",
		//contentType : 'application/json',
		dataType: "json" ,
		global: false,
		async:false,
		success : function(result) {
			data = result;
			/* Added by Bhaskar for the default value dynamically from the dropdown*/
			if(data.length>0 && data[0].category=="Individual"){
			globalProviderId = data[0].id;
			}
			/*Added by Bhaskar for the default value Ends here*/
		},
		error : function(jqxhr) {
			var msg = JSON.parse(jqxhr.responseText);
			alert(msg['message']);

		}
	});
	
 $('<option>').val("").text("").appendTo('#docava');
	for(var i=0;i<data.length;i++){
		$('<option>').val(data[i].id+"_"+data[i].category).text(data[i].label).appendTo('#docava');
		}
	/* Added by Bhaskar for the default value dynamically from the dropdown*/
	var tem =[];
	for(var s in data){		
		if(data[s].category=="Group"){
			tem.push(data[s]);
		}
		
	}
	if(tem.length>0){
		globalGroup = tem[0].id;
	}
	/*Added by Bhaskar for the default value Ends here*/
 $("#docava").select2().on('change', function (e) {
			getGroupIndi("docava");
			//console.log(e);
		});

function getGroupIndi(selId){
	  var doc_dt = $("#inputField").val();
	  var val1 =  $("#"+selId).val().split("_");
	   var val = val1[1];
		//sch.getUpdateDoc(doc_dt,ui.item.id);
		//sch.ajaxMethod('../ws/rs/schedule/:providerNo/list', Schedular.prototype.setInitData,{"doc_dt":doc_dt,"doc_list":ui.item.list});
		//console.log(val1[0]);
		if(val1[0]!=null){
			globalGroup = val1[0]
		}else{
			globalGroup = globalGroup;
		}
		//count_schJsp= 0;
		setTimeout('sch.callDayWeekMonth(\''+globalView.view+'\',\''+val1[0]+'\')',1000);
		if(val.indexOf("Group")>-1){
		//$('#flipdivid').html("Flip Days&nbsp;<b class='caret' onclick='getDropDown(\"flipdivid\",\"flipDropId\",\"Flip Days\",\"\")'></b>");
		//$('#weekdivid').html("Week&nbsp;<b class='caret' onclick='getDropDown(\"weekdivid\",\"weekDropId\",\"Week\",\"\")'></b>");
		$("#placeText").show();
		$("#placeText").html("Group : ");
		/*To load the providers in Manage group layout */
		//grp_mng_json_fn.getData();
		grp_mng_fn.loadPage();
		}else{
		//alert("in individual");
		$("#placeText").show();
		$("#placeText").html("Individual : ");
		$('#flipdivid').empty();
		$('#flipdivid').html("Flip Days");
		$('#weekdivid').empty();
		$('#weekdivid').html("Week");
		//alert("in individual>>>>>>");
		}
		
	  }
function getDropDown(divId,dropId,placeText,der){
	var dataList  = providerListObj.providersList;
	var test = der!=""?" ("+der+")":""
	//$('#'+divId).html("<br/><select id='"+dropId+"' style='width:130px;dispaly:inline;' placeholder='Select individual'\"></select>");
	$('#'+divId).html("<span id='labelText_"+dropId+"'>"+placeText+test+"</span><br/><select id='"+dropId+"' style='width:130px;dispaly:inline;' placeholder='Select individual'\"></select>");
		$('<option>').val("").text("").appendTo('#'+dropId);
		for(var i=0;i<dataList.length;i++){
			$('<option>').val(dataList[i].id+"_Group").text(dataList[i].name).appendTo('#'+dropId);
			}
		$("#"+dropId).select2().on('change', function (e) {
			var selectDropVal = e.val.split("_");
				globalPatName = new Object();
				globalPatName.id = e.val;
				globalPatName.name = e.added.text;
			if(divId=="weekdivid"){
				showTabData('weekdivid','flipview','monthdiv','weekdivid',selectDropVal[0]);
			//$('#weekdivid').html("Week&nbsp; ("+e.added.text+")<b class='caret' onclick='getDropDown(\"weekdivid\",\"weekDropId\",\"Week\",\""+der+"\")'></b>");
			
			}else{
				showTabData('flipview','daydiv','monthdiv','flipdivid',selectDropVal[0]);
			//$('#flipdivid').html("Flip Days&nbsp; ("+e.added.text+")<b class='caret' onclick='getDropDown(\"flipdivid\",\"flipDropId\",\"Flip Days\",\""+der+"\")'></b>");
			}

			globalProviderId = e.val.split("_")[0];
			var tempGroup = globalProviderId+"_Group";
				 $("#"+dropId+" option").filter(function() {
				        return $(this).attr('value') == tempGroup;
				    }).attr('selected', true);
				 
				 $("#"+dropId).select2().on('select', tempGroup);
			$("#labelText_"+dropId).text(placeText+" ("+sch.formatText($("#"+dropId+" option[value='"+tempGroup+"']").text(),10)+")");
		});
		
		/*For setting labelText first time Starts here also refering from groupManage.jsp line no:128*/
		$("#"+dropId+" option").filter(function() {
				        return $(this).attr('value') == globalProviderId+"_Group";
				    }).attr('selected', true);
		 $("#"+dropId).select2().on('select', globalProviderId+"_Group");
		 
		 console.log(globalProviderId+"<<>>"+countForlabeltext);
		 if(countForlabeltext==0){
		 //$("#labelText_"+dropId).text("");
			 $("#labelText_"+dropId).text(placeText+" ("+sch.formatText($("#"+dropId+" option[value='"+globalProviderId+"_Group']").text(),10)+")");
			 countForlabeltext = 1;
		 }
		 /*For setting labelText first time ends here*/
		 //console.log(countForlabeltext);
//alert("oyeee");
}
</script>
 <style>
 .dateseltop {
    width:14% !important;
    margin: 6px 15px 0 5px;
    float: left;
}
.dateseltop input[type="image"] {width:15px; padding:7px 3px; float: left;}
.dateseltop .input1 { float: left; width: 83%;height: 23px;margin-bottom: 0 !important; border: 1px solid #cecece; border-width: 0 1px;}
.navseltop {
width:20% !important;
padding-top: 7px;
float: left;
}
.navseltop .nav-tabs {
    border-bottom: 1px solid #cecece;
}
.navseltop .nav-tabs > li {text-align: center; width: 25%;}
.navseltop .nav-tabs > li a {cursor: pointer; font-weight: normal !important;}
.col-md-12 {padding-left:0px !important; padding-right:0px !important;}
.placetext_individual {float: left; width:17% !important; margin-top:5px;}
.appointments_top {float: left; width:45% !important; border: 1px solid #cecece; border-width: 0 1px; padding: 7px 10px; margin: 0px 10px;}
.appointments_top label.label {float:left; width: 17% !important; color: #c7c5c5 !important; font-size: 90% !important; font-weight:normal !important; line-height: 1.5 !important; text-align: left !important; padding: 0.2em 0.6em 0.3em 0 !important; margin-bottom:0px !important;}
.appointments_top button.btn  {float:left; width: 20% !important;}
.appointments_top .input-group {float:left; width: 60%; margin-left:17px;}
.appointments_top .input-group .input-group-addon {padding: 3px 8px !important;}
.appointments_top .input-group .form-control {height: 25px !important;}
.navbar-form {width: 350px !important;}
.twitter-typeahead .tt-hint {width: 100% !important;}
#placeText {color: #c7c5c5; font-size: 90%; font-weight: normal;line-height: 1.5 ;}
.select2-container {width:70%;}

@media (min-width: 1018px) and (max-width: 1226px) {
  .dateseltop .input1 {width: 78%;}
  .navseltop {width:27% !important;}
  .appointments_top {width: 36% !important; margin: 0 5px; padding: 7px;}
  .appointments_top label.label {width:21% !important; font-size: 82% !important;}
  .appointments_top button.btn {width: 28% !important; line-height: 1.5; font-size: 12px; padding: 0 5px !important;}
  .appointments_top .input-group {margin-left: 10px; width: 47%;}
  .placetext_individual {width: 20% !important;}
  #placeText {font-size: 82%;}
}
@media (min-width: 1227px) and (max-width: 1310px) {
  .dateseltop .input1 {width:82%;}
  .navseltop {width:23% !important;}
  .appointments_top {width: 40% !important; margin: 0 5px; padding: 7px;}
  .appointments_top label.label {width:19% !important; font-size: 85% !important;}
  .appointments_top button.btn {width: 24% !important; padding: 0 5px !important;}
  .appointments_top .input-group {margin-left: 10px; width: 54%;}
  .placetext_individual {width: 19% !important;}
}
@media (min-width: 1680px) and (max-width: 1920px) {
  .dateseltop .input1 {width:87%;}
}
@media (min-width: 1921px) and (max-width: 2199px) {
  .dateseltop .input1 {width:88%;}
}
@media (min-width: 2200px) and (max-width: 2553px) {
  .dateseltop .input1 {width: 91%;}
}

.Yscale {width: 100%;}
.Yscale th {width: 14% !important;}
.Yscale td {width: 14% !important;}
.cal_calendar td {height: 14% !important;}
.ui-widget-overlay {z-index: 9999;}
.ui-widget-content {z-index: 10000;}
#flipview .xscale {width: 100%;}
#flipview .xscale td {width: inherit;}
.eventpop {width: 160px;}

#abc .xscale {float:none !important;margin:inherit !important; width: 100%; border: 0px none;}
#abc .xscale td {width:auto;}
#abc .xscale td, #persondata .Yscale {
	border: 0px none;
}
#clock .xscale {border: 0px none; border-top:1px solid #cecece; border-bottom:1px solid #cecece; padding-top: 1px;}
#clock .xscale td {border: 0px none; height: 26px;}

#names {border:1px solid #cecece;}
#names .Yscale {border: 0px none;}
#names .Yscale th {border: 0px none;}

/*#abc .xscale td {height: 40px;}
#persondata .Yscale td {height: 40px;}*/
#persondata {border:1px solid #cecece; border-width: 0px 0px 1px 1px;}
#abc {border:1px solid #cecece; border-width: 0px 0px 1px 0px;}
#clock {border:1px solid #cecece; border-width: 0px 0px 0px 1px;}
.eventpop .eventtab .evtpop_td_btm_line {height: 24px;}
.eventpop .eventtab .evtpop_td_ltline {height: 24px;}
.eventpop .eventtab .gen_font {height: 24px;}
/*@media (min-width: 320px) and (max-width: 1300px) {
#abc .xscale td {height: 25px;}
#persondata .Yscale td {height: 25px;}
.eventpop .eventtab .evtpop_td_btm_line {height: 25px;}
}*/
.headertable .collapse {display: block;}
@media (min-width: 320px) and (max-width: 1023px) {
.headertable .navbar-toggle {background-color:transparent; border: 1px solid transparent; border-radius: 4px; float: right; margin-bottom: 2px; margin-right: 8px; margin-top: 2px; padding: 9px 10px; position: relative; display: block;}
.headertable .navbar-toggle .icon-bar {border-radius: 1px; display: block; height: 2px; width: 22px;}
.headertable .navbar-toggle .icon-bar + .icon-bar {margin-top: 4px;}
.headertable .navbar-toggle {border-color: #dddddd;}
.headertable .navbar-toggle:hover, .headertable .navbar-toggle:focus {background-color: #dddddd;}
.headertable .navbar-toggle .icon-bar {background-color: #cccccc;}
.headertable .navbar-collapse, .headertable .navbar-form {border-color: #e6e6e6;}
.headertable .collapse {display: none;}
.navbar-default .navbar-toggle {background-color: transparent; border: 1px solid transparent; border-radius: 4px; float: right; margin-bottom: 8px; margin-right: 15px; margin-top: 8px; padding: 9px 10px; position: relative; display: block;}
.navbar-default .navbar-toggle .icon-bar {border-radius: 1px; display: block; height: 2px; width: 22px;}
.navbar-default .navbar-toggle .icon-bar + .icon-bar {margin-top: 4px;}
.navbar-default .navbar-toggle {border-color: #dddddd;}
.navbar-default .navbar-toggle:hover, .navbar-default .navbar-toggle:focus {background-color: #dddddd;}
.navbar-default .navbar-toggle .icon-bar {background-color: #cccccc;}
.navbar-default .navbar-collapse, .navbar-default .navbar-form {border-color: #e6e6e6;}
.navbar-default .collapse {display: none !important;}
.navbar-header {float:none;}
.dateseltop {float: none; width: 98% !important;}
.navseltop {float: none; width: 98% !important;}
.appointments_top {float: none; margin: 0; width: 100% !important; border: 0px none;}
.appointments_top label.label {width: 20% !important;}
.appointments_top button.btn {width: 25% !important;}
.appointments_top .input-group {width: 50%;}
.placetext_individual {float: none; width: 100% !important;}
.navbar-collaps {background: #fff; border: 1px solid #cecece; margin: -1px; padding: 10px 10px 20px; position: absolute; top: 39px; width: 100.5%; z-index: 10;}
.headertable {position: relative;}
.navseltop .nav-tabs {border-bottom: 0px none;}
.nav-tabs > li.active > a, .nav-tabs > li.active > a:hover, .nav-tabs > li.active > a:focus {background:#eeeeee; border: 0px;}
#clock .xscale {width: 7% !important;}
.scrolldiv {width: 93% !important;}
.scrolldiv2 #abc {width: 7% !important;}
.dateseltop {position: relative;}
.dateseltop span {position: initial !important;}
.dateseltop .input1 {width: 90%;}
.ui-widget-content {width: 430px !important;}
div#naa_users-contain {width: 385px !important;}
#next_app_form {width: 424px !important;}
#fex_app_form {width: 424px !important;}
#add_appt_form {width: 424px !important;}
#manageGroupForm {width: 424px !important;}
#fex_app_form .ui-widget-content {width: 424px !important;}
#yourtabs li a {padding: 10px 0 !important;}
#temp1 .tab-pane-left {float:none !important; width:100% !important;}
#temp1 .tab-pane-right {border-left: 0px none !important; padding-left:0px !important; float:none !important; width:100% !important; border-top: 1px solid #AAAAAA !important; padding-top:10px;}
#temp1 #add_appt_add_buttons {padding-right: 30px !important;}
#temp1 #add_appt_pat_name0 {width:175px !important;}
#temp1 #add_appt_prov_name0 {width:175px !important;}
#temp2 .tab-pane-left {float:none !important; width:100% !important;}
#temp2 .tab-pane-right {border-left: 0px none !important; padding-left:0px !important; float:none !important; width:100% !important; border-top: 1px solid #AAAAAA !important; padding-top:10px;}
#temp2 #block_add_buttons {padding-right: 30px !important;}
#add_appt_but_recur {padding: 4px 0 !important;}
#add_appt_but_recur span {padding: 0 0 0 4px !important;}
#blk_appt_but_recur {padding: 4px 0 !important;}
#blk_appt_but_recur span {padding: 0 0 0 4px !important;}
#temp1 #add_appt_edit_buttons .btn_group_edit_buttons {padding: 0px !important; margin-top:10px;}
#temp1 #add_appt_edit_buttons .btn_group_edit_buttons .btn {width: 130px !important;}
#manageGroupForm .tab-pane-left {float:none !important; width:100% !important;}
#manageGroupForm .tab-pane-right {border-left: 0px none !important; padding-left:0px !important; float:none !important; width:100% !important; border-top: 1px solid #AAAAAA !important; padding-top:10px;}
}
@media (min-width: 320px) and (max-width:480px) {
#clock .xscale {width: 13% !important;}
.scrolldiv {width: 87% !important;}
.scrolldiv2 #abc {width: 13% !important;}
.appointments_top button.btn {width: 50% !important;}
.appointments_top label.label {width: 50% !important;}
.appointments_top .input-group {clear: both;
    margin-left: 0 !important;
    padding-top: 7px;
    width: 100%;float: none;}
.dateseltop .input1 {width: 88%;}
}
#temp1 .tab-pane-left {float:left; width:55%;}
#temp1 .tab-pane-right {border-left: 1px solid #AAAAAA; padding-left: 5px; float:left; width:45%;}
#temp1 #add_appt_add_buttons {padding-top: 10px; padding-bottom: 60px; padding-right: 60px; text-align: right; border-top: 1px solid #AAAAAA;}
#temp1 #add_appt_edit_buttons {}
#temp1 #add_appt_pat_name0 {width:220px;}
#temp1 #add_appt_prov_name0 {width:220px;}
#temp2 .tab-pane-left {float:left; width:55%;}
#temp2 .tab-pane-right {border-left: 1px solid #AAAAAA; padding-left: 5px; float:left; width:45%;}
#temp2 #block_add_buttons {padding-top: 10px; padding-bottom: 60px; padding-right: 60px; text-align: right; border-top: 1px solid #AAAAAA;}
.Hading_group_Title {color: #000;border-bottom: 1px solid #aaaaaa;}
.Hading_group_Title #groupTitle {float: left;}
.Hading_group_Title .grp_man_close {float: right;}
#manageGroupForm .tab-pane-left {float:left; width:50%;}
#manageGroupForm .tab-pane-right {border-left: 1px solid #AAAAAA; padding-left: 5px; float:left; width:50%;}
#manageGroupForm .manage_Group_buttons {padding-top: 22px; padding-bottom: 25px; text-align: right; border-top: 1px solid #AAAAAA;}
 </style>

<div class="headertable" id="secNav">
<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-collaps">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
<div class="navbar-collaps collapse">
<div class="date_selector dateseltop" id="tab"><input type="image" src="js_up/images/arrow_left.png" onclick="dateChange('dec')"/><input type="text" size="24" id="inputField" readonly="readonly" class="input1"/><input type="image" src="js_up/images/arrow_right.png" onclick="dateChange('inc')"/><div class='clear'></div></div>
<div class="navseltop">
	<ul class='nav nav-tabs' id='maintab'>
		<li class="active"><a style='padding:5px;font-family: calibri;' id='daydivid' onclick="showTabData('daydiv','flipview','monthdiv','daydivid','103')">Day</a></li>
		<li><a style='padding:5px;font-family: calibri;' id='flipdivid' onclick="showTabData('flipview','daydiv','monthdiv','flipdivid','103')">Flip Days</a></li>
		<li><a style='padding:5px;font-family: calibri;' id='weekdivid' onclick="showTabData('weekdivid','flipview','monthdiv','weekdivid','103')" id='weekdivid'>Week</a></li>
		<li><a style='padding:5px;font-family: calibri;' id='monthdivid' onclick="showTabData('monthdiv','flipview','daydiv','monthdivid','103')" id='mondivid'>Month</a></li>
	</ul>
</div>
<div class="appointments_top">
	<label class="label">Appointments:</label>
	<button type="button" id="create-user" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Search next available appointment" style="height:25px;width:115px;padding:0px;padding-left:5px;color:#C7C5C5;">+ Next available</button>
	<div class="input-group">
		<span class="input-group-addon"><span class="glyphicon glyphicon-search"></span></span>
		<input id="fex_find_input"  class="form-control na_form_inputtext" placeholder='Find existing' rel='popover' data-placement='bottom' data-original-title='&lt;b&gt;Requests&lt;/b&gt;' data-content='My content goes here' />												  
	</div>
	<div class='clear'></div>
	<div id="testcode"></div>
</div>
<div class="placetext_individual"><span id="placeText"></span><select placeholder="Select team/individual" id="docava" ></select></div>
</div>
<div class='clear'></div>
</div>
		 <iframe id="frame" style="width:100%;height:0px;border: 0px;" ></iframe>
		
		<!-- Day and week view-->
		<div id='daydiv'>
			<div id='dayview'>
				<table id="dayviewTable" cellpadding="0" cellspacing="0" border="0">
					<tr style="width:100%;"><td id='head' style="border-bottom: 0px !important;width:100%;"></td></tr>
					<tr style="width:100%;"><td id='providerdiv' style="width:100%;"></td></tr>
				</table>
			</div>
		</div>
		<!-- Flip days view-->
		<div id='tab2' style='font-family:calibri;'>
			<div id='flipview' style='display:none;'></div>
		</div>
		<!-- Month view-->
		<div id='monthdiv' style='display:none;'>
			<div id='header'></div>
			<div id='monthview'></div>
			
			<!--<div id='weekview' style='display:none;'>
				<table style='border-collapse:collapse;padding:0px;float: left;display: inline-block;' cellpadding="0" cellspacing="0" border="0">
					<tr><td id='weekheader' style="border-bottom: 0px !important;"></td></tr>
					<tr><td id='weekdiv'></td></tr>
				</table>
			</div> -->
		</div>
		<!-- Next available appt dailog box start-->
		<div id="nextAvailAppt" style="display:none;">        
		</div>
		<!--  Next available appt dailog box end -->
		<!-- find existing dialog start-->
		<div id="findExisting" style="display:none;">        
		</div>
		<!--  Find existing dailog box end -->
		<div id="manageGroupHTML" style="display:none;"></div>
		<!-- <div style="padding: 0px; display: none;" title="Information" id="dialog-info">
			<table style="width:100%">
				<tr>
					<td style="width:40px;padding-left:10px;"><img src="js_up/images/info_alert.jpg" style="width:30px;height:30px;"></img></td>
					<td height="70px" style="padding-left:5px;">
						<b>Sure! you want to?</b>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align:right;border-top: 1px solid #AAAAAA; padding-top:10px;"> 
						<button id="sch_info_but_edit" class="naa_button_grd" style="width:80px;cursor:pointer;">Edit</button>&nbsp;&nbsp;
						<button id="sch_info_but_delete" class="naa_button_grd" style="width:80px;cursor:pointer;">Delete</button>&nbsp;&nbsp;
						<button id="sch_info_but_cancel" class="naa_button_grd" style="width:80px;cursor:pointer;">Cancel</button>&nbsp;&nbsp;
					</td>
				</tr>
			</table>
		</div> -->
		
		<div class="modal fade bs-example-modal-sm" id="" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      test
    </div>
  </div>
</div>
		<!-- info dialog -->
		<div class="modal fade bs-example-modal-sm" id="dialog-info" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-dialog modal-sm" style="padding-top:150px;">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		        <h4 class="modal-title" id="myModalLabel">Edit</h4>
		      </div>
		      <div class="modal-body">
		        Are you sure you want to delete this appointment?
		      </div>
		      <div class="modal-footer">
		      	<button type="button" id="sch_info_but_edit" class="btn btn-primary">Edit</button>
		      	<button type="button" id="sch_info_but_delete" class="btn btn-danger" data-dismiss="modal">Delete</button>
		        <button type="button" class="btn btn-default" onclick="sch.clearGlobalId('dialog-info')" data-dismiss="modal">Cancel</button>
		        
		      </div>
		    </div>
		  </div>
		</div>
		
		
		
		<!-- Edit confirmation -->
		<div class="modal fade bs-example-modal-sm" id="dialog-edit" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-dialog modal-sm" style="padding-top:150px;">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		        <h4 class="modal-title" id="myModalLabel">Edit appointment</h4>
		      </div>
		      <div class="modal-body">
		        Are you sure you want to change the appointment?
		      </div>
		      <div class="modal-footer">
		      	<button type="button" id="sch_info_but_edit1" class="btn btn-primary">Confirm</button>
		        <button type="button" class="btn btn-default" onclick="sch.clearGlobalId('dialog-edit')" data-dismiss="modal">No</button>
		        
		      </div>
		    </div>
		  </div>
		</div>
		
		<!-- Edit confirmation -->
		<div class="modal fade bs-example-modal-sm" id="dialog-edit_find" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-dialog modal-sm" style="padding-top:150px;">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		        <h4 class="modal-title" id="myModalLabel">Edit appointment</h4>
		      </div>
		      <div class="modal-body">
		        Are you sure you want to change the appointment?
		      </div>
		      <div class="modal-footer">
		      	<button type="button" id="sch_info_but_edit_find" class="btn btn-primary">Edit</button>
		        <button type="button" class="btn btn-default" onclick="sch.clearGlobalId('dialog-edit_find')" data-dismiss="modal">Cancel</button>
		        
		      </div>
		    </div>
		  </div>
		</div>
		
		<!-- Delete confirmation -->
		<div class="modal fade bs-example-modal-sm" id="dialog-delete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		  <div class="modal-dialog modal-sm" style="padding-top:150px;">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		        <h4 class="modal-title" id="myModalLabel">Delete appointment</h4>
		      </div>
		      <div class="modal-body">
		        Are you sure you want to delete this appointment?
		      </div>
		      <div class="modal-footer">
		      	<button type="button" id="sch_del_but_delete" class="btn btn-danger">Delete</button>
		        <button type="button" class="btn btn-default" onclick="sch.clearGlobalId('dialog-delete')" data-dismiss="modal">Cancel</button>
		        
		      </div>
		    </div>
		  </div>
		</div>
		
		
		<div style="padding: 0px; display: none;" title="Cancel appointment changes" id="dialog-cancel">
		<b>Sure! you want to cancel the changes.</b>
		</div>
		
<div style="display:none;width:1px,height:1px;">
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
			$("#backgroundPopup").css("opacity", "0.25"); // css opacity, supports IE7, IE8
			$("#backgroundPopup").fadeIn(0001);
			sch.ajaxMethod("js_up/demo_ajax_json.js",loadFieldData,{});
			popupStatus = 1; // and set value to 1
		}
	}
	function loadPopupEdit() { 
		if(popupStatus == 0) { // if value is 0, show popup
			closeloading(); // fadeout loading
			$("#toPopup").fadeIn(0500); // fadein popup div
			$("#backgroundPopup").css("opacity", "0.25"); // css opacity, supports IE7, IE8
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
	function loadFieldData(result){
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
				//(obj[key]['id']);
				$("#apptStatus").append("<option value='"+obj[key]['id']+ "'>"+obj[key]['id']+""+" - "+obj[key]['val']+"</option>");
			}
		}else if(i=="appTime"){
			for(key in obj){
				$("#apptTime").append("<option value='"+obj[key]['id']+ "'>"+obj[key]['val']+"</option>");
			}
		}
      });
    //});
	}
	
function showLoading(){
	$("#loadingDiv").dialog("open");
}

function hideLoading(){
	$("#loadingDiv").dialog("close");
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
		var day = "";
		if(date.getDate()<10)
		day = "0"+date.getDate();/*Modified by Bhaskar for date differences between calender and system dates */
		else
		day = date.getDate();
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
		
		sch.load(document.getElementById("inputField").value);
	}
function page_init(){
//$("#testcode").load("partials/addAppointment.jsp");

$("#nextAvailAppt").load("partials/nextAvailAppt.jsp");
$("#testcode").load("partials/addAppt.jspf");
$("#findExisting").load("partials/findExisting.jsp");
$("#manageGroupHTML").load("partials/groupManage.jsp");
}

var sch = new Schedular();
sch.showTab('daydivid');
//setDate(); Modified By Schedular Team (moved to showTabData() line no:264 )
page_init();
    $(document).ready(function() {
        setTimeout(function(){
		$(".noline").tooltip({
        placement : 'top',
        container:'.noline'
    });
	$(".withline").tooltip({
        placement : 'top',
		container:'.withline'
    });
    $(".eventpop").tooltip({
        placement : 'top',
		container:'.eventpop'
    });
    
	},1500);
        //$(window).trigger('zoom');
    	setTimeout('sch.callDayWeekMonth(\''+globalView.view+'\',\''+getMainGroupSelBoxVal()+'\')',1000);
    });
    
    var elFrame = $('#frame')[0];
    $(elFrame.contentWindow).resize(function() {
        $(window).trigger('zoom');
    });
	
    $(window).on('zoom', function() {
        //console.log('zoom', window.devicePixelRatio);
        console.log($(window).height());
        //$("#secNav").css("width", $(window).width());
        //setTimeout('$("#secNav").width($(window).width())',1000);
       // console.log("secNav>>>>"+$("#secNav").width());
        //console.log("daydiv>>>>"+$("#daydiv").width());
        
        	//alert("Else : " + window.devicePixelRatio);
        	$("#secNav").width(($(".container-fluid").width()-10));
        	//console.log("zoommm else"+$("#consult-list").width());
        	//console.log("zoommm else"+($("#consult-list").width()-100));
        	$("#dayviewTable").width($("#secNav").width());
        	if(window.devicePixelRatio<0.4){
        		setTimeout('$("#persondata").width(($("#consult-list").width()-550))',1000);
        	}else{
        	}
        	//setTimeout('sch.callDayWeekMonth(\''+globalView.view+'\',\''+getMainGroupSelBoxVal()+'\')',500);
        	setTimeout('sch.callDayWeekMonth(\''+globalView.view+'\',\'\')',500);
        	
        	//Earlier before : 2014.09.23
        	//setTimeout('sch.callDayWeekMonth(\''+globalView.view+'\',\''+globalProviderId+'\')',500);
        	
        	//setTimeout('$(".scrolldiv2").width($("#secNav").width())',1000);
        	//setTimeout('$( ".scrolldiv2" ).height(($( window ).height()-250))',1000);        	
       
    });
</script>
</div>
