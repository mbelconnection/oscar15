<script>
	$("a.topopup").click(function() {
			//$( "#toPopup" ).draggable();
			//var $tabs = $( "#tabsSch" ).tabs();
					
	return false;
	});
	/* event for close the popup */
	$("div.close").hover(
					function() {
						$('span.ecs_tooltip').show();
					},
					function () {
    					$('span.ecs_tooltip').hide();
  					}
				);
	
	$("div.close").click(function() {
		disablePopup();  // function close pop up
	});
	
	$(this).keyup(function(event) {
		if (event.which == 27) { // 27 is 'Ecs' in the keyboard
			disablePopup();  // function close pop up
		}  	
	});
	
	$("div#backgroundPopup").click(function() {
		disablePopup();  // function close pop up
	});
	
	$('a.livebox').click(function() {
		var appObj = new Object();
		console.log($("#apptType").val());
		appObj.patient_name = $("#search").val();
		appObj.reason = $("#reason").val();
		appObj.duration = $("#apptDuration").val();
		appObj.notes = $("#noteDetails").val();
		appObj.appoint_status = $("#apptStatus").val();
		appObj.go_to = $("#apptType").val();
		appObj.is_critical = $('input[name="criticalAppt"]:checked').val()=="on"?"Y":"N";
		sch.saveEvent(globalObj,appObj);
		disablePopup();
		return false;
	});
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

  $(function() {
    var data = [
      { label: "anders", category: "" },
      { label: "andreas", category: "" },
      { label: "anders andersson", category: "" },
      { label: "andreas andersson", category: "" },
      { label: "andreas johnson", category: "" }
    ];
 
    $( "#search" ).catcomplete({
      delay: 0,
      source: data
    });
  });
function setDate2(id){
	var s = new JsDatePick({
		useMode:2,
		disablePreDays:true,
		target:id,
		dateFormat:"%d-%M-%Y"

	});
	todayDate(id);
}
function getWeekDay(){
var currDay = document.getElementById("appDate").value;
var currDayArr = currDay.split("-");
var month;
	if(currDayArr[1] == "Jan"){
		month=0;
	}else if(currDayArr[1] == "Feb"){
		month=1;
	}else if(currDayArr[1] == "Mar"){
		month=2;
	}else if(currDayArr[1] == "Apr"){
		month=3;
	}else if(currDayArr[1] == "May"){
		month=4;
	}else if(currDayArr[1] == "Jun"){
		month=5;
	}else if(currDayArr[1] == "Jul"){
		month=6;
	}else if(currDayArr[1] == "Aug"){
		month=7;
	}else if(currDayArr[1] == "Sep"){
		month=8;
	}else if(currDayArr[1] == "Oct"){
		month=9;
	}else if(currDayArr[1] == "Nov"){
		month=10;
	}else if(currDayArr[1] == "Dec"){
		month=11;
	}

var myday = new Date(currDayArr[2],month,currDayArr[0]);

	var day = myday.getDate();        
	var month = myday.getMonth();        
	var year = myday.getYear();        
	if(year<=200)        {                
		year += 1900;        
	}        
	var days = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
	months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');        
	days_in_month = new Array(31,28,31,30,31,30,31,31,30,31,30,31);        
	if(year%4 == 0 && year!=1900)        {                
		days_in_month[1]=29;        
	}        
	return days[myday.getDay()];
}
function showRecData(id1,id2,id3){
	if(document.getElementById(id1).style.display=="inline"){
	document.getElementById(id1).style.display="none";
	document.getElementById(id2).innerHTML = "<input type=\"button\" value=\"Add recurrence\" onclick=\"showRecData('"+id1+"','"+id2+"','"+id3+"')\">";
	}else{
	document.getElementById(id1).style.display="inline";
	document.getElementById(id2).innerHTML = "<input type=\"button\" value=\"Edit recurrence\" onclick=\"showRecData('"+id1+"','"+id2+"','"+id3+"')\">";
	document.getElementById(id3).innerHTML = "Occurs every "+getWeekDay()+",effective "+document.getElementById("appDate").value;
	}
}

</script>

    <div id="toPopup" class="ui-widget-content">
        <div class="close"></div>
       	<span class="ecs_tooltip">Press Esc to close <span class="arrow"></span></span>
		<div id="tabsSch">
			<ul>
			<li><a href="#popup_content">Add appointment</a></li>
			<li><a href="#toPopup2">Block time</a></li>
			</ul>
		<div id="popup_content" > <!--your content start-->
           <div style="width:100%display:inline;font-family:Calibri,Times New Roman,Times,serif;height:100%">
				<div class="left">
					<div class="leftdiv"><img src="js_up/img/1.png"></img>&nbsp;<span style="color:#C0C0C0;">BASIC DETAILS(required)<span></div><br/>
					<div class="leftdiv"><label>Patient Name:</label><div class="wrapper"><input id="search"><button style="border-width: 0;   height: 20px;    margin-right: 0;    margin-top: -5px;    width: 35px;">Go</button></div>&nbsp;&nbsp;&nbsp;
					<input type="text" value="New Patient" style="display:inline; width: 140px;"></div><br/>
					<div class="leftdiv"><label>&nbsp;</label><input type="checkbox"><span>Send reminder to patient's email</span></input></div><br/>
					<div class="leftdiv">
					<div style="display:inline-block;"><label>provider(s)</label></div>
					<div style="display:inline;">
						<input type="radio" name="provider" id="name="singProviderRad" style="margin-left: -2px;">Single provider appt.</input></div>
					<div style="display:inline;width:100px;">
					<select id="singleProvidSel"></select>
					</div>
					</div><br/>
					<div class="leftdiv">
					<div style="display:inline-block;"><label>&nbsp;</label></div>
					<div style="display:inline;"><input type="radio" name="provider" id="multiProviderRad" style="margin-left: -2px;">Multi-provider appt.</input></div>
					<div ng-controller="MyCntrlSel" style="display:inline;width:100px;">
					<select id="multiProvidSel" multiple></select>
					</div>
					</div><br/>

					<div class="leftdiv">
					<div style="display:inline-block;width:100px;"><label>Date</label></div>
					<div style="display:inline;width:100px;"><input type="text" size="12" id="appDate"/></div>
					<div style="display:inline;width:100px;"><div id="changeButton" style="display:inline-block;width:100px;"><input type="button" value="Add recurrence" onclick="showRecData('showRecurrence','changeButton','showRecurrenceLbl')"></div></div>
					</div><br/>
					<div id="showRecurrence" style="display:none;" class="leftdiv">
					<div style="display:inline-block;"><label style="width: 100px;"><label>Recurrence</label></label></div>
					<div style="display:inline-block;"><label style="width: 260px;color: #C0C0C0;font-size:12px" id="showRecurrenceLbl">Occurs every friday,effective</label></div>
					<div style="display:inline;width:100px;"><input type="text" size="12" id="appDate2" ></input></div>
					</div>
					<div class="leftdiv">
					<div style="display:inline-block;width:100px;"><label>Time</label></div>
					<div style="display:inline;width:100px;"><select id="apptTime" name=""></select></div>
					<div style="display:inline-block;width:100px;"><label>Duration</label></div>
					<div style="display:inline;width:100px;">
					<select id="apptDuration" name="apptDuration">
					<option value="15">15 mins</option>
					<option value="30">30 mins</option>
					<option value="45">45 mins</option>
					<option value="60">60 mins</option>
					</select>
					</div>
					</div><br/>
					<div class="leftdiv">
					<table border="1">
					<tr><td>PATIENT DEMOGRAPHICS</td><td>APPOINTMENTS OVERVIEW</td></tr>
					<tr><td>DOB:XX_XX_XXXX</td><td>DDD</td></tr>
					<tr><td>ZZ</td><td>AA</td></tr>
					<tr><td>XX</td><td>CC</td></tr>
					</table>
					</div>
				</div>
				<div class="right" >
					<div class="leftdiv"><img src="js_up/img/2.png"></img>&nbsp;<span style="color:#C0C0C0;">MORE DETAILS(optional)<span></div><br/>
					<div class="leftdiv"><label>Appt. type</label><select name="apptType" id="apptType"></select>&nbsp;&nbsp;Critical appt.<input type="checkbox" name="criticalAppt" id="criticalAppt" ></div><br/>
					<div class="leftdiv"><label>Appt. status</label><select name="apptStatus" id="apptStatus"></select></div><br/>
					<div class="leftdiv">
					<div style="display:inline; "><label>Location</label><input type="text" name="moreLocation" id="moreLocation" style="width:80px;"></input></div>
					<div style="display:inline; margin-left: 40px;"><label style="width: 98px;">Resources</label><input type="text" name="moreResources" id="moreResources" style="width:80px;"></input></div>
					</div><br/>
					<div class="leftdiv">
					<div style="display:inline-block;width:100px;">Reason</div>
					<div style="display:inline;width:100px;"><select name="reason" id="reason">
					<option name="PRET">Pregnancy Test</option>
					<option name="BLDT">Blood Test</option>
					<option name="URIT">Urine Test</option>
					</select></div>
					</div>
<br/>
					<div class="leftdiv"><div style="display:inline-block;width:100px;">Reason details</div><div style="display:inline-block;width:100px;"><textarea name="reasonDetails" id="reasonDetails" rows="2" cols="40"></textarea></div></div><br/>
					<div class="leftdiv">
						<div style="display:inline-block;width:100px;">Note</div>
						<div style="display:inline;width:100px;"><textarea name="noteDetails" id="noteDetails" rows="2" cols="40"></textarea></div>
					</div><br/>
					
				</div>
			</div>
			<div style="width:100%">&nbsp;</div>
			<div style="width:100%;margin-left: -25px;">
				<div style="float:right;"><button id="apptCopy" style="display:none;">Copy</button><button id="apptPaste" style="display:none;">Paste</button><button id="apptCancel" style="padding-left:10px;">Cancel</button><button id="apptDelete" style="display:none;">Delete</button><button id="apptSave">Save</button></div>
			</div>
        </div> <!--your content end-->
		<div id="toPopup2">
		<div style="width:100%display:inline;font-family:Calibri,Times New Roman,Times,serif;height:100%">
				<div class="left">
					<div class="leftdiv"><img src="js_up/img/1.png"></img>&nbsp;<span style="color:#C0C0C0;">BASIC DETAILS(required)<span></div><br/>

					<div class="leftdiv">
					<div style="display:inline-block;width:100px;">provider(s)</div>
					<div style="display:inline;width:100px;">
						<input type="radio" name="providerBlock" id="singProviderRadBloc">Single provider appt.</input></div>
					<div style="display:inline;width:100px;">
					<select id="singleProvidSel"></select>
					</div>
					</div><br/>
					<div class="leftdiv">
					<div style="display:inline-block;width:100px;">&nbsp;&nbsp;&nbsp;&nbsp;</div>
					<div style="display:inline;width:100px;">
						<input type="radio" name="providerBlock" id="multiProviderRadBloc">Multi-provider appt.</input></div>
					<div ng-controller="MyCntrlSel" style="display:inline;width:100px;">
					<select id="multiProvidSel" multiple></select>
					</div>
					</div><br/>
					<div class="leftdiv">
					<div style="display:inline-block;width:100px;">&nbsp;&nbsp;&nbsp;&nbsp;</div>
					<div style="display:inline;width:100px;">
						<input type="radio" name="providerBlock" id="entireTeamRadBloc">Entire team block</input></div>
					<div style="display:inline;width:100px;">
					<select style="display:none;"></select>
					</div>
					</div><br/>
					
					<div class="leftdiv">
					<div style="display:inline-block;width:100px;">Date:</div>
					<div style="display:inline;width:100px;"><input type="text" size="12" id="appDate1"/></div>
					<div style="display:inline;width:100px;"><div id="changeButtonB" style="display:inline-block;width:100px;"><input type="button" value="Add recurrence" onclick="showRecData('showRecurrenceB','changeButtonB','showRecurrenceLblB');"></div></div>
					</div><br/>
					<div id="showRecurrenceB" style="display:none;" class="leftdiv">
					<div style="display:inline-block;"><label style="width: 100px;">Recurrence</label></div>
					<div style="display:inline-block;"><label style="width: 280px;color: #C0C0C0;font-size:12px" id="showRecurrenceLblB">Occurs every friday,effective</label></div>
					<div style="display:inline;width:100px;"><input type="text" size="12" id="appDate3" ></input></div>
					</div>
					<div class="leftdiv">
					<div style="display:inline-block;width:100px;">Time</div>
					<div style="display:inline;width:100px;"><select ng-model="color" ng-options="c.name for c in colors"></select></div>
					<div style="display:inline-block;width:100px;">Duration</div>
					<div style="display:inline;width:100px;"><select ng-model="color" ng-options="c.name for c in colors"></select></div>
					</div><br/>
					
				</div>
				<div class="right" >
					<div class="leftdiv"><img src="js_up/img/2.png"></img>&nbsp;<span style="color:#C0C0C0;">MORE DETAILS(optional)<span></div><br/>
					<div class="leftdiv">
					<div style="display:inline-block;width:100px;">Reason</div>
					<div style="display:inline;width:100px;"><select name="reason" id="reason">
					<option name="PRET">Pregnancy Test</option>
					<option name="BLDT">Blood Test</option>
					<option name="URIT">Urine Test</option>
					</select></div>
					</div>
<br/>
					
					<div class="leftdiv">
						<div style="display:inline-block;width:100px;">Note</div>
						<div style="display:inline;width:100px;"><textarea name="noteDetails" rows="2" cols="40"></textarea></div>
					</div><br/>
					
				</div>
			</div>
		
		</div>
		</div>
		
	</div>
    </div> <!--toPopup end-->
	<div class="loader"></div>
   	<div id="backgroundPopup"></div>
<div style="display:none;">
<script>
setDate2('appDate');setDate2('appDate1');setDate2('appDate2');setDate2('appDate3');
    $( "button" ).button();
	$( "#apptPaste" ).button("disable");
	$( "#apptCopy" ).click(function() {
	//console.log( $( "#apptCopy" ).button().text());
	//console.log($( "#apptPaste" ).button( "option", "disabled" ));
	//$( "#apptPaste" ).button( "option", "disabled", true );
	$( "#apptPaste" ).button("enable");
	});
	$( "#apptPaste" ).click(function( event, ui ) {
	});
	$( "#apptCancel" ).click(function( event, ui ) {
		disablePopup();
	});
	$( "#apptDelete" ).click(function( event, ui ) {
	//console.log( $( "#apptDelete" ).button().text());
		var appObj = new Object();
		appObj.patient_name = $("#search").val();
		appObj.reason = $("#reason").val();
		appObj.duration = $("#apptDuration").val();
		appObj.notes = $("#noteDetails").val();
		appObj.appoint_status = $("#apptStatus").val();
		appObj.go_to = $("#apptType").val();
		appObj.is_critical = $('input[name="criticalAppt"]:checked').val()=="on"?"Y":"N";
		sch.deleteEvent(globalObj,appObj);
		disablePopup();
		return false;
	});
	$( "#apptSave" ).click(function( event, ui ) {
		//console.log( $( "#apptSave" ).button().text());
		var appObj = new Object();
		//console.log($("#apptType").val());
		appObj.patient_name = $("#search").val();
		appObj.reason = $("#reason").val();
		appObj.duration = $("#apptDuration").val();
		appObj.notes = $("#noteDetails").val();
		appObj.appoint_status = $("#apptStatus").val();
		appObj.go_to = $("#apptType").val();
		appObj.is_critical = $('input[name="criticalAppt"]:checked').val()=="on"?"Y":"N";
		sch.saveEvent(globalObj,appObj);
		disablePopup();
		return false;
	});
</script>
</div>