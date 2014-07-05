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
<link rel="stylesheet"  type="text/css" href="css_up/calendar.css" />
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
    opacity: 0.7;
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
}​
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
		$('#flipdivid').html("Flip Days&nbsp;<b class='caret' onclick='getDropDown(\"flipdivid\",\"flipDropId\",\"Flip Days\")'></b>");
		$('#weekdivid').html("Week&nbsp;<b class='caret' onclick='getDropDown(\"weekdivid\",\"weekDropId\",\"Week\")'></b>");
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
		$('#flipdivid').html("Flip Days&nbsp;<b class='caret' onclick='getDropDown(\"flipdivid\",\"flipDropId\",\"Flip Days\")'></b>");
		$('#weekdivid').html("Week&nbsp;<b class='caret' onclick='getDropDown(\"weekdivid\",\"weekDropId\",\"Week\")'></b>");
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
	var groupSelBox = $("#docava").val()!=""?$("#docava").val().split("_"):"_";
	return groupSelBox[0];
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
		$('#flipdivid').html("Flip Days&nbsp;<b class='caret' onclick='getDropDown(\"flipdivid\",\"flipDropId\",\"Flip Days\",\"\")'></b>");
		$('#weekdivid').html("Week&nbsp;<b class='caret' onclick='getDropDown(\"weekdivid\",\"weekDropId\",\"Week\",\"\")'></b>");
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

		<table  width="100%" class="headertable" id="secNav">
			<tr>
				<td class='tabs_underline' style="padding:5px;width:210px;">
					<div class="date_selector" style="width:100%;">
						<table class="eventtab" style="width:100%;border-collapse:collapse;padding:0px;" id="tab"  cellspacing="0" >
							<tr class=""> 
								<td class="date_selector_td_left_right" style="width:30px;"><input type="image" src="js_up/images/arrow_left.png" onclick="dateChange('dec')"/></td>
								<td class="date_selector_td_ltline date_selector_td_mid" style="text-align:center;width:150px;" ><input type="text" size="12" id="inputField" readonly="readonly" class="input1" style="width:145px;"/></</td>
								<td class="date_selector_td_ltline date_selector_td_left_right" style="width:30px;padding-top:5px;"><input type="image" src="js_up/images/arrow_right.png" onclick="dateChange('inc')"/></td>
							</tr>
							<!-- <tr class=""> 
								 <div class="week-picker"></div><br /><br />
    							<label>Week :</label> <span id="startDate"></span> - <span id="endDate"></span>
							</tr>-->
						</table>
					</div>
				</td>
				<td class='tabs_underline' style='vertical-align:bottom;width:530px;'>
					<ul class='nav nav-tabs' id='maintab' style='width:525px !important;border-bottom-width: 0px;'>
						<li class="active" style='margin-left:5px;'><a style='width:60px;padding:5px;font-family: calibri;' id='daydivid' onclick="showTabData('daydiv','flipview','monthdiv','daydivid','103')">Day</a></li>
						<li><a style='width:190px;padding:5px;font-family: calibri;' id='flipdivid' onclick="showTabData('flipview','daydiv','monthdiv','flipdivid','103')">Flip Days</a></li>
						<li><a style='width:190px;padding:5px;font-family: calibri;' id='weekdivid' onclick="showTabData('weekdivid','flipview','monthdiv','weekdivid','103')" id='weekdivid'>Week</a></li>
						<li><a style='width:60px;padding:5px;font-family: calibri;' id='monthdivid' onclick="showTabData('monthdiv','flipview','daydiv','monthdivid','103')" id='mondivid'>Month</a></li>
					</ul>
				</td>
				<td style='border-left:1px solid #cecece;padding-left:5px;'>
					<table>
						<tr>
							<td style='padding-left:5px;width:80px;font-size:14px;color:#C7C5C5;' class='gen_font'>
								&nbsp;&nbsp;Appointments:&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
							<td style='font-size:12px;'>
								<button type="button" id="create-user" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Search next available appointment" style="height:25px;width:115px;padding:0px;padding-left:5px;color:#C7C5C5;"> &nbsp;+ Next available&nbsp; </button>
							</td>
							<td style='width:110px;'>
								<table>
									<tr>
										<td style="padding-left:15px;">
											
											<div class="input-group" style='padding:2px;'>
													<span class="input-group-addon" style="font-size:14px;padding:0 5px 3px 7px;"><span class="glyphicon glyphicon-search"></span></span>
												  <input id="fex_find_input"  class="form-control na_form_inputtext" style="height:25px;width:220px !important;" placeholder='Find existing' rel='popover' data-placement='bottom' data-original-title='&lt;b&gt;Requests&lt;/b&gt;' data-content='My content goes here' />												  
												</div>
										</td>
										<td>
											<!-- add appointment dialog box includes here -->
											<div id="testcode"></div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
				<!--<td style='border-left:1px solid #cecece;padding-left:5px;text-align:center;' class='gen_font'>
					<button type="button" id="manageGroup" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Search next available appointment" style="height:25px;width:150px;padding:0px;padding-left:5px;color:#C7C5C5;"> &nbsp;Manage group&nbsp; </button>
				</td> -->
				<td style='border-left:1px solid #cecece;padding-left:5px;text-align:center;' >
					<span style="color:#AAAAAA;font-size:14px;display:none;" id="placeText"></span>
					<select placeholder="Select team/individual" style="width:170px;" id="docava" ></select>
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
			$("#backgroundPopup").css("opacity", "0.7"); // css opacity, supports IE7, IE8
			$("#backgroundPopup").fadeIn(0001);
			sch.ajaxMethod("js_up/demo_ajax_json.js",loadFieldData,{});
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
    setTimeout('sch.callDayWeekMonth(\''+globalView.view+'\',\''+globalProviderId+'\')',1000);
    });
</script>

</div>
