var globalObj = new Object();
var globalApptId = "";
var globalEventType = "";
var globalView = new Object();
var nextAailObject = new Object();
var globalPatName = new Object();
var providerListObj = new Object();
var add_appt_pat_cnt_names = "";
var globalGroup = "Group A"; /* To set the group name default in manage layout */
var globalProviderId = "103";
var countForlabeltext = 0;
var hideWeekEnds = false;
var flipWeekendHide = false;

var globalDayViewDate;
var fromZoomView = false;

var flipColorCodes;
var weekDB = [ {
	name : "Monday",
	id : "1"
}, {
	name : "Tuesday",
	id : "2"
}, {
	name : "Wednesday",
	id : "3"
}, {
	name : "Thursday",
	id : "4"
}, {
	name : "Friday",
	id : "5"
}, {
	name : "Saturday",
	id : "6"
}, {
	name : "Sunday",
	id : "7"
} ];
var weekDB_hideWeekEnds = [ {
	name : "Monday",
	id : "1"
}, {
	name : "Tuesday",
	id : "2"
}, {
	name : "Wednesday",
	id : "3"
}, {
	name : "Thursday",
	id : "4"
}, {
	name : "Friday",
	id : "5"
} ];

var appt_goto_data = $.ajax({ 
	url : "../ws/rs/patient/type/list/1",
	type : "get",
	contentType : 'application/json',
	global: false,
	async:false,
	success : function(result) {
	},
	error : function(jqxhr) {
		var msg = JSON.parse(jqxhr.responseText);
		alert(msg['message']);

	}
}).responseText;
var jObj = JSON.parse(appt_goto_data);
appt_goto_data = jObj.appointmentTypes;

var appt_status_data = $.ajax({
	url : "../ws/rs/patient/status/list/1",
	type : "get",
	contentType : 'application/json',
	global: false,
	async:false,
	success : function(result) {
	},
	error : function(jqxhr) {
		var msg = JSON.parse(jqxhr.responseText);
		alert(msg['message']);

	}
}).responseText;
var jObj = JSON.parse(appt_status_data);
appt_status_data = jObj.appointmentStatus;

var mulPatDtls = {
	"0" : {
		patName : "Abbey",
		apptSta : "HR",
		apptStaColor : "green",
		apptGoto : "B",
		apptRea : "Physical Examination.required",
		apptNote : "Noted complications since last year"
	},
	"1" : {
		patName : "Adem",
		apptSta : "TD",
		apptStaColor : "red",
		apptGoto : "E",
		apptRea : "General checkup",
		apptNote : "n/a"
	},
	"2" : {
		patName : "Doe, Jane",
		apptSta : "FT",
		apptStaColor : "#66CC00",
		apptGoto : "I",
		apptRea : "Annual check-up",
		apptNote : "Noted complications since last year"
	},
	"3" : {
		patName : "Donaghy, Jane",
		apptSta : "NP",
		apptStaColor : "#FF0066",
		apptGoto : "R",
		apptRea : "Physical Examination.required",
		apptNote : "n/a"
	},
	"4" : {
		patName : "Donahue, Jane",
		apptSta : "NS",
		apptStaColor : "#6633CC",
		apptGoto : "E",
		apptRea : "Half yearly check-up",
		apptNote : "Noted complications since last year"
	},
	"5" : {
		patName : "Smith",
		apptSta : "EM",
		apptStaColor : "#848484",
		apptGoto : "B",
		apptRea : "General checkup",
		apptNote : "Full activity evaluation"
	}
}

function setGlobalDayDate(){
	var date = $("#inputField").val();
	var temp = date.split('-');
	if(temp.length == 3){
		globalDayViewDate = $("#inputField").val();
//		console.log("date set");
	}
}

function openFlipViewHelp(){
	url = "./partials/FlipViewHelp.jsp";
	sch.openWindow(url, 1000,600);
}

function showdata(provId) {
	console.log(provId);
	var dates = getStartEndDates();
	var flipviewHeight = window.innerHeight - 146;
	var flipdayHeight = (flipviewHeight / 32) + 15;
	
	//console.log(dates);
	var finalData = '<div class="xscale"><div class="borderDiv" style="height:'+ flipdayHeight +'px"><img style="cursor:pointer;" onclick="openFlipViewHelp()" src="js_up/images/icon_help_small.png">&nbsp;'+sch.getViewDropDown()+'</div>';

	var j = 8;
	for (var i = 0; i < 10; i++) {
		finalData += '<div class="borderDivtitle" style="height:'
				+ flipdayHeight 
				+ 'px">' + parseFloat(j + i)
				+ '.00</div>' + '<div class="borderDiv" style="height:'
				+ flipdayHeight 
				+ 'px">' + parseFloat(j + i) 
				+ '.15</div>' + '<div class="borderDiv" style="height:'
				+ flipdayHeight 
				+ 'px">' + parseFloat(j + i)
				+ '.30</div>' + '<div class="borderDiv" style="height:'
				+ flipdayHeight 
				+ 'px">' + parseFloat(j + i) 
				+ '.45</div>';
	}
	finalData = finalData + '</div>';

	/*for (var a = 0; a < this.flipdays.length; a++) {
		finalData += '<tr><td >' + this.flipdays[a].date + '</td>';

		for (var b = 0; b < this.flipdays[a].flipdata.length; b++) {
			finalData += '<td style="text-align:center;">'
					+ this.flipdays[a].flipdata[b] + '</td>'
		}
		finalData += '</tr>'
	}*/
	if(flipColorCodes == null)
		flipColorCodes = getFlipColorCodes();
	getFlipColor('');
	if(provId == 0){
		if(flipWeekendHide)
			finalData += loadBlankFlipData_hide(dates[0], dates[1]);
		else
			finalData += loadBlankFlipData(dates[0], dates[1]);
	}else{
		var _data = getFlipData(provId, dates[0], dates[1]);
		if(flipWeekendHide)
			finalData += loadFlipData_hide(_data, dates[0], dates[1]);
		else
			finalData += loadFlipData(provId, _data, dates[0], dates[1]);
	}
	flipWeekendHide = false;
	
	document.getElementById('flipview').style="overflow-y:scroll; height:" + flipviewHeight + "px";
	document.getElementById('flipview').innerHTML = finalData;
}
function loadFlipData(provId, _data, startDate, endDate){
	var months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
	var finalData = "";
	var currDayArr = startDate.split('-');
	var days = getDiffInDays(startDate, endDate) +1;
	var myday = new Date(parseFloat(currDayArr[2]),parseFloat(getMonthIndex(startDate)),parseFloat(currDayArr[0]));
	var index = 32;
	var flipviewHeight = window.innerHeight - 146;
	var flipdayHeight = (flipviewHeight / 32) + 15;
	for (var a = 0; a < days; a++) {
		curDate = myday.getDate() +"-"+months[myday.getMonth()] +"-"+ myday.getFullYear();
			finalData += '<tr><td><div class="borderDivcursor" style="text-align:right;cursor:pointer;height:'+ flipdayHeight +'px;" onclick="goToDayView(\''+provId+'\', \''+curDate+'\')">' + getFlipDateFormat(myday) + '</div></td>';
			var formattedDate = getDateFormat(myday);
			var dayData = _data[formattedDate];
			
			//console.log(formattedDate);
			//console.log(dayData);
			if(dayData != null){
				var dayFlipData = dayData.split('');
				for (var b = 0; b < 40; b++) {
					finalData += '<td><div class="borderDiv" style="text-align:center;height:'+ flipdayHeight +'px;background-color:'+ getFlipColor(dayFlipData[index + b]) +';">' + dayFlipData[index + b]  + '</div></td>'
				}
			}else{
				for (var b = 0; b < 40; b++) {
					finalData += '<td><div class="borderDiv" style="height:'+ flipdayHeight +'px">&nbsp;</div></td>'
				}
			}
			finalData += '</tr>';
		myday.setDate(myday.getDate()+parseFloat(1));
		
	}
	return finalData;
}
function loadFlipData_hide(_data, startDate, endDate){
	var finalData = "";
	var currDayArr = startDate.split('-');
	var days = getDiffInDays(startDate, endDate) +1;
	var myday = new Date(parseFloat(currDayArr[0]),parseFloat(getMonthIndex(startDate)),parseFloat(currDayArr[0]));
	var index = 32;
	for (var a = 0; a < days; a++) {
		//console.log((myday.getDay()== 0 || myday.getDay()== 6));
		if(myday.getDay()== 0 || myday.getDay()== 6){
		
		}else{
			finalData += '<tr><td style="text-align:right;">' + getFlipDateFormat(myday) + '</td>';
			var formattedDate = getDateFormat(myday);
			var dayData = _data[formattedDate];
			
			//console.log(formattedDate);
			//console.log(dayData);
			if(dayData != null){
				var dayFlipData = dayData.split('');
				for (var b = 0; b < 40; b++) {
					finalData += '<td style="text-align:center;background-color:'+ getFlipColor(dayFlipData[index + b]) +';">' + dayFlipData[index + b]  + '</td>'
				}
			}else{
				for (var b = 0; b < 40; b++) {
					finalData += '<td style="text-align:center;">&nbsp;</td>'
				}
			}
			finalData += '</tr>';
		}
		myday.setDate(myday.getDate()+parseFloat(1));
		
	}
	return finalData;
}

function goToDayView(provId, date){
	//alert(provId);
	document.getElementById("daydiv").style.display = "block";
	document.getElementById("flipview").style.display = "none";
	document.getElementById("monthdiv").style.display = "none";
	//alert(1);
	Schedular.prototype.ajaxMethod("../ws/rs/schedule/" + date +"/"+provId+ "/list1",
			Schedular.prototype.setInitData, {
				"doc_dt" : date
			});
	globalView.view="day";
	$('#maintab a[id="daydivid"]').tab('show');
	
	$('#flipdivid').empty();
	$('#flipdivid').html("Flip Days");
	document.getElementById("inputField").value = date;
	setTimeout('Schedular.prototype.init(\'day\',\'from load\')', 1000);
	
}

function loadBlankFlipData(startDate, endDate){
	var finalData = "";
	var currDayArr = startDate.split('-');
	var days = getDiffInDays(startDate, endDate) +1;
	var myday = new Date(parseFloat(currDayArr[2]),parseFloat(getMonthIndex(startDate)),parseFloat(currDayArr[0]));
	for (var a = 0; a < days; a++) {
			finalData += '<tr><td style="text-align:right;">' + getFlipDateFormat(myday) + '</td>';
			for (var b = 0; b < 40; b++) {
				finalData += '<td style="text-align:center;">&nbsp;</td>'
			}
			finalData += '</tr>';
		myday.setDate(myday.getDate()+parseFloat(1));
	}
	return finalData;
}
function loadBlankFlipData_hide(startDate, endDate){
	var finalData = "";
	var currDayArr = startDate.split('-');
	var days = getDiffInDays(startDate, endDate) +1;
	var myday = new Date(parseFloat(currDayArr[2]),parseFloat(getMonthIndex(startDate)),parseFloat(currDayArr[0]));
	for (var a = 0; a < days; a++) {
		if(myday.getDay()== 0 || myday.getDay()== 6){
		
		}else {
			finalData += '<tr><td style="text-align:right;">' + getFlipDateFormat(myday) + '</td>';
			for (var b = 0; b < 40; b++) {
				finalData += '<td style="text-align:center;">&nbsp;</td>'
			}
			finalData += '</tr>';
		}
		myday.setDate(myday.getDate()+parseFloat(1));
	}
	return finalData;
}

function getFlipColor(flipCode){
//	console.log(flipColorCodes)
	//flipColorCodes;
	var color="";
	var row;
	for(i=0; i<flipColorCodes.length; i++){
		row = flipColorCodes[i];
		if(flipCode == row.code){
			color = row.color;
			break;
		}
	}
	return color;
}

function getFlipDateFormat(dateObj){
	var months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
	var days = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
	//console.log(days[dateObj.getDay()]);
	return days[dateObj.getDay()] + ",&nbsp;" + months[dateObj.getMonth()] + "&nbsp;" + dateObj.getDate()+"&nbsp;";
}

function getDateFormat(dateObj){
	var months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
	return dateObj.getDate() + "-" + months[dateObj.getMonth()] + "-" + dateObj.getFullYear();
}

function getDiffInDays(startDate, endDate){
	var stDateDtls = startDate.split('-');
	var endDateDtls = endDate.split('-');
	var date1 = new Date(parseFloat(stDateDtls[2]),parseFloat(getMonthIndex(startDate)),parseFloat(stDateDtls[0]));
	var date2 = new Date(parseFloat(endDateDtls[2]),parseFloat(getMonthIndex(endDate)),parseFloat(endDateDtls[0]));
	var timeDiff = Math.abs(date2.getTime() - date1.getTime());
	var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)); 
	return diffDays;
}
function getStartEndDates(){
	var months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'); 
	var date = document.getElementById("inputField").value;
	var stDate = date.split('to')[0];
	var date_opts = stDate.trim().split('-');
	var dates = new Array();
	dates[0] =  date_opts[0] + "-" +months[getMonthIndex(date)] + "-20" + date_opts[2];
	//var nextMonth = getMonthIndex(date) + 1;
	//console.log(date_opts);
	var year = "20" + date_opts[2];
	var date2 = new Date(parseFloat(year), parseFloat(getMonthIndex("-"+date_opts[1])),parseFloat(date_opts[0]));
	date2.setMonth(date2.getMonth() + 1);
	dates[1] = date2.getDate() + "-" +months[date2.getMonth()] + "-" + date2.getFullYear();
	//console.log(dates);
	return dates;
}

function getMonthIndex(date){
	var month;
	var currDayArr = date.split('-');
	if(currDayArr[1] == "Jan" || currDayArr[1] == "JAN" || currDayArr[1] == "January" || currDayArr[1] == "JANUARY"){
		month = 0;
	}else if(currDayArr[1] == "Feb" || currDayArr[1] == "FEB" || currDayArr[1] == "February" || currDayArr[1] == "FEBRUARY"){
		month = 1;
	}else if(currDayArr[1] == "Mar" || currDayArr[1] == "MAR" || currDayArr[1] == "March" || currDayArr[1] == "MARCH"){
		month=2;
	}else if(currDayArr[1] == "Apr" || currDayArr[1] == "APR" || currDayArr[1] == "April" || currDayArr[1] == "APRIL"){
		month=3;
	}else if(currDayArr[1] == "May" || currDayArr[1] == "MAY" || currDayArr[1] == "May" || currDayArr[1] == "MAY"){
		month=4;
	}else if(currDayArr[1] == "Jun" || currDayArr[1] == "JUN" || currDayArr[1] == "June" || currDayArr[1] == "JUNE"){
		month=5;
	}else if(currDayArr[1] == "Jul" || currDayArr[1] == "JUL" || currDayArr[1] == "July" || currDayArr[1] == "JULY"){
		month=6;
	}else if(currDayArr[1] == "Aug" || currDayArr[1] == "AUG" || currDayArr[1] == "August" || currDayArr[1] == "AUGUST"){
		month=7;
	}else if(currDayArr[1] == "Sep" || currDayArr[1] == "SEP" || currDayArr[1] == "September" || currDayArr[1] == "SEPTEMBER"){
		month=8;
	}else if(currDayArr[1] == "Oct" || currDayArr[1] == "OCT" || currDayArr[1] == "October" || currDayArr[1] == "OCTOBER"){
		month=9;
	}else if(currDayArr[1] == "Nov" || currDayArr[1] == "NOV" || currDayArr[1] == "November" || currDayArr[1] == "NOVEMBER"){
		month=10;
	}else if(currDayArr[1] == "Dec" || currDayArr[1] == "DEC" || currDayArr[1] == "December" || currDayArr[1] == "DECEMBER"){
		month=11;
	}
	return month;
}

function getFlipData(provId, startDate, endDate){
		var data = $.ajax({
			url : "../ws/rs/appointment/"+startDate+"/"+endDate+"/"+provId+"/fetchFlipView",
			type : "get",
			//contentType : 'application/json',
			dataType: "json" ,
			global: false,
			async:false,
			success : function(result) {
			},
			error : function(jqxhr) {
				var msg = JSON.parse(jqxhr.responseText);
				alert(msg['message']);

			}
		}).responseText;
		var jObj = JSON.parse(data);
		return jObj;
	
}

function getFlipColorCodes(){
	var data = $.ajax({
		url : "../ws/rs/patient/scheduleTempCode/get",
		type : "get",
		//contentType : 'application/json',
		dataType: "json" ,
		global: false,
		async:false,
		success : function(result) {
		},
		error : function(jqxhr) {
			var msg = JSON.parse(jqxhr.responseText);
			alert(msg['message']);

		}
	}).responseText;
	var jObj = JSON.parse(data);
	return jObj;

}
/* flip days view end */

var Schedular = function() {
}
Schedular.views = {
	month : 'monthview',
	day : 'dayview',
	week : 'dayview'
};
Schedular.config = {
	start_time : 8,
	end_time : 24,
	increment : 15,
	top_align : 100,
	left_align : 50,
	providersList : [],
	eventsList : [],
	weekDayList: []
};

Schedular.prototype.setProviders = function(providers) {
	Schedular.config.providersList = providers;
}
Schedular.prototype.setEvents = function(events) {
	Schedular.config.eventsList = events;
}
Schedular.prototype.setEventsList = function(eventsList) {
	Schedular.config.eventsList = eventsList;
}
Schedular.prototype.getEventsList = function() {
	return Schedular.config.eventsList;
}
Schedular.prototype.setWeekDayList = function(weekDayList) {
	Schedular.config.weekDayList = weekDayList;
}
Schedular.prototype.load = function(date) {
	// load appointment status
	this.getApptStatusHTML();
	if(globalView.view==null){
		globalView.view="day"
	}else{
		globalView.view = globalView.view;
	}
	if(globalView.view=="day"){
		if(globalProviderId != null && globalProviderId != '' && globalProviderId != '_')
		{
			Schedular.prototype.ajaxMethod("../ws/rs/schedule/" + date + "/" + globalProviderId + "/list1",
					Schedular.prototype.setInitData, {
						"doc_dt" : date
					});
		}
		else
		{
			Schedular.prototype.ajaxMethod("../ws/rs/schedule/" + date + "/list1",
					Schedular.prototype.setInitData, {
						"doc_dt" : date
					});
		}		
		
	}else {
		var sq = sch.weekForCurrentDate(date);
		/* Need to modify the 103 to dynamic value */
		var temp  = $("#weekDropId").val();
		var temp1 = temp!=null? temp.split("_"):"103_Group".split("_");
		//alert(3);
		Schedular.prototype.ajaxMethod("../ws/rs/schedule/"+sq+ "/"+temp1[0]+"/list",
				Schedular.prototype.setInitData, {
					"doc_dt" : date
				});
	}
	document.getElementById("inputField").value = date;
	setTimeout('sch.init(\''+globalView.view+'\',\'from load\')', 1000);
}
Schedular.prototype.dayLoad = function(date,providerNo,isgroup) {
	// load appointment status
	console.log("in day load @536"+providerNo+"isgroup>>>"+isgroup);
	this.getApptStatusHTML();
	if(providerNo.indexOf("group") > - 1){
		//alert(4);
		Schedular.prototype.ajaxMethod("../ws/rs/schedule/" + providerNo +"/"+date+ "/list33",
				Schedular.prototype.setInitData, {
					"doc_dt" : date
				});

	}else{
	
		if(isgroup == true){
			if(providerNo != "_")
			{
				Schedular.prototype.ajaxMethod("../ws/rs/providerService/" + date +"/"+providerNo+ "/fetchGroupAppointments",
						Schedular.prototype.setInitData, {
							"doc_dt" : date
						});
			}			
		}else{
			if(providerNo.length > 0)
			{
				Schedular.prototype.ajaxMethod("../ws/rs/schedule/" + date +"/"+providerNo+ "/list1",
						Schedular.prototype.setInitData, {
							"doc_dt" : date
						});				
			}			
		}
	}
	document.getElementById("inputField").value = date;
	setTimeout('Schedular.prototype.init(\'day\',\'from load\')', 1500);
}
Schedular.prototype.weekLoad = function(week,providerNo,isgroup) {
	this.getApptStatusHTML();
	var date = document.getElementById("inputField").value;
	//if(providerNo.indexOf("group") > -1){
	if(isgroup==true){
		//alert(6);
		Schedular.prototype.ajaxMethod("../ws/rs/schedule/" +providerNo  + "/"+week+"/grpwkevnts",
				Schedular.prototype.setInitData, {
					"doc_dt" : date
				});
	}else{
		//alert(7);
	Schedular.prototype.ajaxMethod("../ws/rs/schedule/" + week + "/"+providerNo+"/list",
			Schedular.prototype.setInitData, {
				"doc_dt" : date
			});
	}
	//document.getElementById("inputField").value = date;
	setTimeout('Schedular.prototype.init(\'week\',\'from load\')', 1000);
}
Schedular.prototype.callDayWeekMonth = function(view,selVal){

	var selDate = document.getElementById("inputField").value;
	var dropVal = $("#docava").val().split("_");
	console.log("in sch JS @ 591>>>>"+$("#docava").val().split("_")+">>>>>>selVal"+selVal);
	var isgroup = false;
	if(dropVal[1].length > 0 && selVal.length > 0)
	{
		if(dropVal[1].indexOf("Group") > -1)
		{
			isgroup = true;
		}	
		
		var locselVal = getMainGroupSelBoxVal1(selVal);
		globalProviderId = locselVal;
	}
	
	if(view =="day"){
		globalView.view="day";
		if(isgroup == true)
		{
			sch.dayLoad(selDate,locselVal,isgroup);
		}
		else
		{
			sch.dayLoad(selDate,globalProviderId,isgroup);
		}
	}else if(view =="week"){
		globalView.view="week";
		var sq = sch.weekForCurrentDate(selDate);		
		if(isgroup == true)
		{
			sch.weekLoad(sq,locselVal,isgroup);
		}
		else
		{
			sch.weekLoad(sq,globalProviderId,isgroup);
		}
	}else if(view =="month"){
		//alert("for month view");
		globalView.view="month";
		setMonthDates("");
		calendar();
	}else{
		
		globalView.view="flip";
		setFlipDates("");		
	}
	
}

function getScrollBarWidth () {
	  var inner = document.createElement('p');
	  inner.style.width = "100%";
	  inner.style.height = "200px";

	  var outer = document.createElement('div');
	  outer.style.position = "absolute";
	  outer.style.top = "0px";
	  outer.style.left = "0px";
	  outer.style.visibility = "hidden";
	  outer.style.width = "200px";
	  outer.style.height = "150px";
	  outer.style.overflow = "hidden";
	  outer.appendChild (inner);

	  document.body.appendChild (outer);
	  var w1 = inner.offsetWidth;
	  outer.style.overflow = 'scroll';
	  var w2 = inner.offsetWidth;
	  if (w1 == w2) w2 = outer.clientWidth;

	  document.body.removeChild (outer);

	  return (w1 - w2);
	};
	
Schedular.prototype.init = function(view, from) {
//	 console.log(view+"<<>>"+from);
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
	},1500);
    });
	globalView.view = view;
	this.persons = Schedular.config.providersList;
	if (view == 'week' && hideWeekEnds){
		this.persons = weekDB_hideWeekEnds;
		hideWeekEnds = false;
	}else if(view == 'week'){
		this.persons = weekDB
	}
	this.view = view;
	this.setView(view);
	/* Load calendar in month view */
	//calendar();
	
	var scrollWidth = getScrollBarWidth();
	var winWidth = document.getElementById('secNav').offsetWidth;
	var totalWidth = scrollWidth + 36;
	//alert(winWidth + " :- " + scrollWidth + " :- " + totalWidth);
	var scrollWid = winWidth - totalWidth;
	if(document.getElementById('secNav').offsetWidth < 1350)
	{
		scrollWid = document.getElementById('secNav').offsetWidth - 54;
	}
	
	var scrollHeight = window.innerHeight - 195;
	//var scrollWid = $("#secNav").width() - 60;
	//console.log(document.getElementById('secNav').offsetWidth);
	var data = this.getYScale();
	//var headData = '<div id="clock" style="float:left"><table class="xscale" style="float: left;cellpadding:0;cellpadding:0;padding-bottom:0px !important;border-bottom: 0px !important;" ><tr><td >'+sch.getViewDropDown()+'</td></tr></table>';
	var headData = '<div id="clock" style="float:left"><div class="xscale" style="float: left; width:3%; padding-bottom:4px !important;">'+sch.getViewDropDown()+'</div>';
	
	/*headData += '<div id="names" class="scrolldiv" style="width:'
			+ (scrollWid)
			+ 'px;float:left;overflow-x:hidden;"><table id="testidd" class="Yscale" width="'
			+ this.getPersonTabWidth()
			+ 'px" style="table-layout:fixed;float: left;cellpadding:0;cellpadding:0;padding-bottom:0px !important;border-bottom: 0px !important;" >'
			+ this.getXHeader() + '</table></div>';*/
	headData += '<div id="names" class="scrolldiv" style="width:'
		+ 96
		+ '%;float:left;overflow-x:hidden;"><table id="testidd" class="Yscale" width="'
		+ this.getPersonTabWidth()
		+ 'px" style="table-layout:fixed;float: left;cellpadding:0;cellpadding:0;padding-bottom:0px !important;" >'
		+ this.getXHeader() + '</table></div>';

	document.getElementById('head').innerHTML = headData;
	/*
	var scaleData = "<div style='display: inline-block;overflow-y:scroll;height:"
			+ (scrollHeight)
			+ "px;' class='scrolldiv2'><div id='abc' style='float:left'>"
			+ data
			+ "</div>"
			+ "<div id='persondata' style='overflow-x:hidden;float:left;width:"
			+ (scrollWid)
			+ "px;' class='scrolldiv'>"
			+ this.getXData()
			+ "</div></div>";
	*/
	
	var scaleData = "<div style='display: inline-block;overflow-y:scroll;height:"
		+ (scrollHeight)
		+ "px;' class='scrolldiv2'><div id='abc' style='float:left; width:3.1%;'>"
		+ data
		+ "</div>"
		+ "<div id='persondata' style='overflow-x:hidden;float:left;width:"
		+ 96.9
		+ "%;' class='scrolldiv'>"
		+ this.getXData()
		+ "</div></div>";
	
	scaleData += "<div id='persondatadummy' class='scrolldiv' style='width:"
			+ scrollWid
			+ "px;height:10px;margin-left:30px;'><table  style='table-layout:fixed;' id='xdummytab'><tr><td id='xdummytabtd'></td></tr></table></div>";
	//+ "px;height:10px;margin-left:30px;'><table  style='table-layout:fixed;' id='xdummytab'><tr><td id='xdummytabtd'>ask fhasdl kfhas klh lkhas dflaksdhf asdfkalsdhf asdhfjka hsdfkljshad fjkasdl hfaksdj fhaksldjfh askldj fhasldkfjh asldkjfh askldfh aklsdhfkasdh fkshdfkl</td></tr></table></div>";
	document.getElementById('providerdiv').innerHTML = scaleData;
	document.getElementById('xdummytab').style.width = document.getElementById('testidd').offsetWidth+"px";

	syncScrollBars();
	// $( "div.first" ).slideUp( 300 ).delay( 800 ).fadeIn( 400 );
	setTimeout('Schedular.prototype.loadDayEvents(Schedular.config.eventsList)',2000);
	//Schedular.prototype.loadDayEvents(Schedular.config.eventsList);
}

Schedular.prototype.getViewDropDown = function(){
//	console.log(globalView.view);
	var finalData = "";
	if(globalView.view=="day"){
		finalData += '<div class="dropdown btn-group" id="menuOptions"> ';
		finalData += '	<a class="btn dropdown-toggle" data-toggle="dropdown" style="height:20px;padding:0px;padding-left:6px;padding-right:6px;padding-top:0px;padding-bottom:0px;">';   
		finalData += '<span class="glyphicon glyphicon-list" style="padding:0px;"></span><span class="caret" style="padding:0px;"></span>  ';  
		finalData += '</a> ';   
		finalData += '<ul class="dropdown-menu">';
		finalData += '<li style="padding-left: 20px;color:#848484;">Group view options:</li>';
		finalData += '<li><a style="text-align:left;" id="showAllId" onclick="sch.showAll();"><span style="font-size: 20px;" >Show All</span><br><span style="color:#848484;">Show all providers in selected group</span></a></li>';
		finalData += '<li><a style="text-align:left;" id="showScheduledId" onclick="sch.showScheduled();"><span style="font-size: 20px;" >Show Scheduled</span><br><span style="color:#848484;">Show all providers in selected group with scheduled appts.</span></a></li>';
		finalData += '<li onclick="sch.openManageGroup();"><a style="text-align:left;"><span style="font-size: 20px;">Manage Layout</span><br><span style="color:#848484;">Re-order and fi lter provider columns</span></a></li></ul></div>';
		finalData += '<input style="display:none" id="clock_img" type="image" src="js_up/images/clock_small.gif"/>';
	}else if(globalView.view=="week"){
		finalData += '<div class="dropdown btn-group" id="menuOptions"> ';
		finalData += '	<a class="btn dropdown-toggle" data-toggle="dropdown" style="height:20px;padding:0px;padding-left:6px;padding-right:6px;padding-top:0px;padding-bottom:0px;">';   
		finalData += '<span class="glyphicon glyphicon-list" style="padding:0px;"></span><span class="caret" style="padding:0px;"></span>  ';  
		finalData += '</a> ';   
		finalData += '<ul class="dropdown-menu">';
		finalData += '<li onclick="sch.hideWeekends();"><a style="text-align:left;"><span style="font-size: 20px;">Hide Weekends</span><br><span style="color:#848484;">Hide week ends from the week view</span></a></li>';
		finalData += '<li onclick="sch.showWeekends();"><a style="text-align:left;"><span style="font-size: 20px;">Show Weekends</span><br><span style="color:#848484;">Show week ends from the week view</span></a></li></ul></div>';
		finalData += '<input style="display:none" id="clock_img" type="image" src="js_up/images/clock_small.gif"/>';
	}else if(globalView.view=="flip"){
		finalData += '<div class="dropdown btn-group" id="menuOptions"> ';
		finalData += '	<a class="btn dropdown-toggle" data-toggle="dropdown" style="height:20px;padding:0px;padding-left:6px;padding-right:6px;padding-top:0px;padding-bottom:0px;">';   
		finalData += '<span class="glyphicon glyphicon-list" style="padding:0px;"></span><span class="caret" style="padding:0px;"></span>  ';  
		finalData += '</a> ';   
		finalData += '<ul class="dropdown-menu">';
		finalData += '<li onclick="sch.flipHideWeekends();"><a style="text-align:left;"><span style="font-size: 20px;">Hide Weekends</span><br><span style="color:#848484;">Hide week ends from the flip view</span></a></li>';
		finalData += '<li onclick="sch.flipShowWeekends();"><a style="text-align:left;"><span style="font-size: 20px;">Show Weekends</span><br><span style="color:#848484;">Show week ends from the flip view</span></a></li></ul></div>';
		finalData += '<input style="display:none" id="clock_img" type="image" src="js_up/images/clock_small.gif"/>';
	}
	
	return finalData;
	
}

Schedular.prototype.openManageGroup = function(){
	$("#manageGroupForm").dialog("open");
}

Schedular.prototype.getProvider_z = function(providerID) {
	for (var i = 0; i < Schedular.config.providersList.length; i++) {
		if (Schedular.config.providersList[i].id == providerID) {
			return Schedular.config.providersList[i];
			//break;
		}
	}
	alert('Provider not found.');
}
Schedular.prototype.getEvents_z = function(providerID) {
	var arrEvents = [];
	for (var i = 0; i < Schedular.config.eventsList.length; i++) {
		if (Schedular.config.eventsList[i].docId == providerID) {
			arrEvents.push(Schedular.config.eventsList[i]);
			//break;
		}
	}
	return (arrEvents);
	// console.log('Events not found.');
}

Schedular.prototype.getProvider = function(providerID) {
	var foo = [];
	var bar = [];
	for (var i = 0; i < Schedular.config.providersList.length; i++) {
		bar.push(Schedular.config.providersList[i].id);
	}
	var i = 0;
	jQuery.grep(providerID, function(el) {
		if (jQuery.inArray(el.id, bar) == -1) {
		} else {
			foo.push(el);
		}
		i++;

	});
	return foo;
	// for(var i=0; i<Schedular.config.providersList.length; i++){
	// if(Schedular.config.providersList[i].id == providerID[i].id){
	// return Schedular.config.providersList[i];
	// }
	// }
	alert('Provider not found.');
}
Schedular.prototype.getEvents = function(providerID) {
	var arrEvents = [];
	for (var i = 0; i < Schedular.config.eventsList.length; i++) {
		for (var j = 0; j < providerID.length; j++) {
			if (Schedular.config.eventsList[i].docId == providerID[j].id) {
				arrEvents.push(Schedular.config.eventsList[i]);
				//alert("EventList : " + JSON.stringify(Schedular.config.eventsList[i]));
			}
		}
	}
	return (arrEvents);
	// console.log('Events not found.');
}

Schedular.prototype.setView = function(view) {
	// this.clearAllViews();
	// document.getElementById(Schedular.views[view]).style.display = "block";
}

Schedular.prototype.clearAllViews = function() {
	// for(key in Schedular.views)
	// document.getElementById(Schedular.views[key]).style.display = "none";
}

Schedular.prototype.getYScale = function() {
	var _YScale = '';
	var _shour = Schedular.config.start_time, _smin = 0;

	var time = '';
	var timeHeight = (window.innerHeight / 64) + 20;
	_YScale += '<table class="xscale" style="float: left;">';
	// _YScale += '<tr><td><input type="image"
	// src="images/clock_small.GIF"/></td></tr>';
	var count = -1;
	while (_shour < Schedular.config.end_time) {
		count++;
		if (_smin >= 60) {
			_shour++;
			_smin -= 60;
			if (_shour == Schedular.config.end_time)
				break;
		}
		_YScale += "<tr><td><div style='border-top: 1px solid #cecece; border-left: 1px solid #cecece; height:"
			+ (timeHeight)
			+ "px;'>";
		time = this.round(_shour) + ":" + this.round(_smin);
		_smin += Schedular.config.increment;
		if(count%4){
			_YScale += "<span style=\"color:#BDBDBD;\" >"+time+"</span>";
		}else{
			_YScale += time;
		}
		_YScale += '</div></td></tr>';
	}
	_YScale += '</table>';
	return _YScale;
}

Schedular.prototype.getXData = function() {
	var wid = this.persons.length * 300;
	if(wid < 1400) // Modified by Bhaskar
		wid = '100%';
	var Xdata = '';
	Xdata += '<div style="position: relative;"><table class="Yscale" style="table-layout: fixed;float: left;" width="'
			+ wid + 'px" id="persondatatab">';
	// Xdata += this.getXHeader() + this.getXScale();
	Xdata += this.getXScale();
	Xdata += '</table><div id="events" style="position:absolute"></div></div>';
	return Xdata;
}

Schedular.prototype.getPersonTabWidth = function() {
	var wid = this.persons.length * 300;
	if(wid < 1400)// Modified by Bhaskar
		wid = '100%';
	return wid;
}

Schedular.prototype.getXHeader = function() {
	var _XHeader = '';
	_XHeader += '<tr>';
	if(this.persons.length == 1){
		if(fromZoomView == true){
		_XHeader += '<th style="width:100% !important;text-align:center;display: inline-block;" ><div style="float:left;width:80%;text-align:center;overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" id="'+this.persons[0].id+'">'+this.persons[0].name+'</div>'+ sch.getZoomLinkView1("","Zoom Out")+'</th>';
		}
		else {
			_XHeader += '<th style="width:100% !important;text-align:center;display: inline-block;" ><div style="float:left;width:80%;text-align:center;" id="'+this.persons[0].id+'">'+this.persons[0].name+'</div></th>';	
		}
		
	}
		
	else
		for (var i = 0; i < this.persons.length; i++) {
			if (this.view == 'day')
				_XHeader += '<th style="text-align:center;display: inline-block;" ><div style="float:left;width:64%;text-align:center;overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" >'+this.persons[i].name+'</div>'+ sch.getZoomLinkView(this.persons[i].id,"ZOOM")+'</th>';// +'<div class="zoomIn" id="'+this.persons[i].id+'" onclick="sch.zoom(this.id)">Zoom</div></th>';
			else
				_XHeader += '<th style="text-align:center;display: inline-block;" ><div style="float:left;width:170px;text-align:center;" >'+ this.persons[i].name + '</div></th>';
		}
	_XHeader += '</tr>';
	return _XHeader;
}

Schedular.prototype.getLinkView = function(provId){
	var _html = "";
	_html += '<div class="btn-group btn-group-lg" style="width:19%;float:right;">';
	_html += '<button type="button" data-toggle="tooltip" title="Zoom view"onclick="sch.zoom(\''+provId+'\')" class="btn btn-default" style="height:22px;font-size:14px;padding-top:1px;padding-left:7px;padding-right:7px;">Z</button>';
	_html += '<button type="button" data-toggle="tooltip" title="Flip Days view" class="btn btn-default" style="height:22px;font-size:14px;padding-top:1px;padding-left:7px;padding-right:7px;">F</button>';
	_html += '<button type="button" data-toggle="tooltip" title="Week view"class="btn btn-default" style="height:22px;font-size:14px;padding-top:1px;padding-left:7px;padding-right:7px;">W</button>';
	_html += '</div>';
	return _html;
}

Schedular.prototype.getZoomLinkView1 = function(provId,zText){
	var _html = "";
	_html += '<div class="btn-group btn-group-lg" style="width:19%;float:right;margin-right: 2px;">';
	_html += '<button type="button" data-toggle="tooltip" title="Zoom view" onclick="sch.getNewZoomOutView()" id="grp_mng_but_save1" class="btn btn-default" style="height:22px;font-size:14px;padding-top:1px;padding-left:7px;padding-right:7px;float:right;">'+zText+'</button>';
	_html += '</div>';
	return _html;
}

/*$("#grp_mng_but_save1").button().click(*/Schedular.prototype.getNewZoomOutView = function () {
	//alert("Hello");
	$("#grp_mng_but_save").trigger("click");
	fromZoomView = false;
	/*var providerNoArr = new Array();
	$('#grp_man_leftPane li').each(function(){
	   var temp = new Object();
	   temp.providerNo = $(this).attr('val');
	   temp.enabled = true;
	   providerNoArr.push(temp);
	});
	var providerNoArr1 = new Array();
	$('#grp_man_rightPane li').each(function(){
		   var temp = new Object();
		   temp.providerNo = $(this).attr('val');
		   temp.enabled = false;
		   providerNoArr.push(temp);
		});
	if($('#grp_man_leftPane li').length>0){
		grp_mng_fn.loadProviders(providerNoArr);
		$("#manageGroupForm").dialog("close");
	}else{
		alert("At least one provider to be in Day view");
	}
	
    return false;*/
 }


Schedular.prototype.getZoomLinkView = function(provId,zText){
	var _html = "";
	_html += '<div class="btn-group btn-group-lg" style="width:19%;float:right;margin-right: 2px;">';
	_html += '<button type="button" data-toggle="tooltip" title="Zoom view"onclick="sch.zoom(\''+provId+'\')" class="btn btn-default" style="height:22px;font-size:14px;padding-top:1px;padding-left:7px;padding-right:7px;float:right;">'+zText+'</button>';
	_html += '</div>';
	return _html;
}

Schedular.prototype.getXScale = function() {
	var _XScale = '';
	var _shour = Schedular.config.start_time, _smin = 0, temp_min=0;
	var style = 'withline';
	var withlineHeight = (window.innerHeight / 64) + 20;
	
	if(flipColorCodes == null)
		flipColorCodes = getFlipColorCodes();
	
	while (_shour < Schedular.config.end_time) {

		if (_smin >= 60) {
			style = 'withline';
			_shour++;
			_smin -= 60;
			if (_shour == Schedular.config.end_time)
				break;
		}

		_XScale += '<tr>';
		time = this.round(_shour) + ":" + this.round(_smin);
		temp_min = _smin;
		_smin += Schedular.config.increment;
		
		for (var i = 0; i < this.persons.length; i++) {
			_XScale += "<td><div data-original-title= "+time+" style='height:"
					+ (withlineHeight)
					+ "px;' class=\"" 
					+ style
					+ "\" position=\""
					+ i
					+ "\" ondblclick='sch.addEvent(this)' hour=\""
					+ _shour
					+ "\" min=\""
					+ temp_min
					+ "\" time=\""
					+ time
					+ "\" name=\""
					+ this.persons[i].name
					+ "\" pid=\""
					+ this.persons[i].id
					+ "\" id=\""
					+ this.persons[i].id
					+ "_"
					+ time
					+ "\">";
			if(this.persons[i].flipData != null){
				//console.log(this.persons[i].flipData);
				//console.log(flipColorCodes);
				//getFlipColor
				var code = sch.getFlipData( this.persons[i].flipData, _shour, _smin);
				_XScale += "<div style=\"border: 1px solid grey;background-color:"+getFlipColor(code)+";font-size:12px;padding-left:2px;border-bottom: 0px;width:15px;height: 100%;\">"+code+"</div>";
			}
							
			 	_XScale += "</div></td>";
		}

		_XScale += '</tr>';
		style = 'noline';
	}
	return _XScale;
}

Schedular.prototype.getFlipData = function(data, hour, min) {
	if(data == null)
		return "&nbsp;";
	var flipdata = data.split('');
	var index = (hour * 4) - 1;
	if(min > 0)
		index += (min/15);
	var output = flipdata[index];
	return output.replace('_','-');
}

Schedular.prototype.round = function(time) {
	if (parseInt(time) < 10)
		return '0' + time;

	return time;
}

Schedular.prototype.zoom = function(id) {
	var providers = [];
	if (!isEmpty(id)) {
		var provider = this.getProvider_z(id);
		var events_z = this.getEvents_z(id);
		providers.push(provider);
		this.setProviders(providers);
		this.setEvents(events_z);
		this.init('day', "from zoom");
		$(".Yscale").css("width","100%");
		globalProviderId = id;
		this.load(document.getElementById("inputField").value);
		fromZoomView = true;
	} else {
		globalProviderId = '';
		this.load(document.getElementById("inputField").value);
		fromZoomView = false;
	}
	
}

function getMainGroupSelBoxVal1(groupvalue){
	var groupSelBox = groupvalue!=""?groupvalue.split("_"):"_";
	return groupSelBox[0];
}

Schedular.prototype.addEvent = function(obj) {
	add_appt_appt_id = '';
	nextAailObject = new Object(); /*
									 * Added by Bhaskar for reset the data from
									 * next Appointment
									 */
	globalObj = obj;
	add_app_fn.loadPatientDtls('');
	$("#add_appt_form").dialog("open");

}
Schedular.prototype.editEvent = function() {
	// for(key in obj)
	loading(); // loading
	setTimeout(function() { // then show popup, deley in .5 second
		loadPopupEdit(); // function show popup
	}, 500); // .5 second
	$("#toPopup").draggable();
	var $tabs = $("#tabsSch").tabs();
	// this.saveEvent(obj);

}

Schedular.prototype.saveEvent = function(obj, appObj, saveData) {
//	console.log(obj);
	obj.offHeight = (obj.id != "" && document.getElementById(obj.id).offsetHeight != null) ? document
			.getElementById(obj.id).offsetHeight
			: 100;
	obj.offWidth = (obj.id != "" && document.getElementById(obj.id).offsetWidth != null) ? document
			.getElementById(obj.id).offsetWidth
			: 100;
//	console.log( appObj.patientName);
	obj.patientName = appObj.patientName.split('^')[0];
	obj.patientId = appObj.patientId;
	obj.reason = appObj.apptReasonText;
	obj.duration = appObj.apptDuration;
	obj.hr = this._getHour(appObj.apptTime);
	obj.min = this._getMin(appObj.apptTime);
	var id = appObj.provId + "_" + this._getHour(appObj.apptTime) + ":"
			+ this._getMin(appObj.apptTime);
	obj.pos = document.getElementById(id).getAttribute('position');
	obj.providerName = appObj.providerName;
	obj.notes = appObj.apptNotes;
	obj.appointStatus = appObj.apptStatus;
	obj.goTo = appObj.goTo;
	obj.isCritical = appObj.isCritical;
	obj.apptId = appObj.apptId;
	obj.pat_sel_index = appObj.pat_sel_index;
	obj.noOfPat = appObj.noOfPatient;
	document.getElementById("events").innerHTML = this.getEventDiv(obj, "save");
	$('#' + obj.hr + '_' + obj.min).draggable().resizable();
}

Schedular.prototype.saveBlockEvent = function(obj, appObj) {

	obj.offHeight = (obj.id != "" && document.getElementById(obj.id).offsetHeight != null) ? document
			.getElementById(obj.id).offsetHeight
			: 100;
	obj.offWidth = (obj.id != "" && document.getElementById(obj.id).offsetWidth != null) ? document
			.getElementById(obj.id).offsetWidth
			: 100;

	obj.reason = appObj.appt_reason;
	obj.duration = appObj.duration;
	// obj.hr = appObj['time'];
	// obj.hr = document.getElementById(obj.id).getAttribute('hour');// From
	// Khadaree
	// obj.min = document.getElementById(obj.id).getAttribute('min');
	obj.hr = this._getHour(appObj['time']);
	obj.min = this._getMin(appObj['time']);
	obj.pos = document.getElementById(obj.id).getAttribute('position');
	obj.notes = appObj.appt_notes;
	obj.room = appObj.appt_room;

	obj.appt_id = appObj.appt_id;
	document.getElementById("events").innerHTML = this.getBlockEventDiv(obj,"save");

	$('#' + obj.hr + '_' + obj.min).draggable().resizable();

}

Schedular.prototype.deleteEvent = function(globalApptId, apptObject) {
	$.ajax({
		url : "../ws/rs/appointment/"
				+ globalApptId
				+ "/delete",
		type : "delete",
		contentType : 'application/json',
		success : function(patientsData) {
		},
		error : function(jqxhr) {
			var msg = JSON.parse(jqxhr.responseText);
			alert(msg['message']);
		}
	});
	//var $back = $('div').find("#" + apptObject);
	//$back.remove();
}
Schedular.prototype.createPopup = function(tdId,reason,notes, room,patName){
	//console.log(patName);
	reason = reason.replace(/_/g," ");
	notes = notes.replace(/_/g," ");
	patName = patName.replace(/_/g,", ");
	//console.log(tdId+"<<>>"+reason+"<<>>"+notes);
	tdId = tdId.replace(/,/g,'_');
	//$('.eventpop').tooltip({placement: 'top', title: "<div id=\"event_tt\" style=\"text-align:left;white-space:normal;\">Reason:"+reason+"</div><div style=\"text-align:left;white-space:normal;\">Notes: "+notes+"</div>",	html: true});
	$('.evtpop_td_pat_name').tooltip({placement: 'top', title: "<div id=\"event_tt\" style=\"text-align:left;width:150px;white-space:normal;\">Name:"+this.splitText(patName, 20)+"</div><div style=\"text-align:left;white-space:normal;\">Reason:"+this.formatText(reason, 18)+"</div><div style=\"text-align:left;white-space:normal;\">Notes: "+this.formatText(notes, 25)+"</div>",html: true});
	//$('.evtpop_td_ltline').tooltip({placement: 'top', title: "<div style=\"text-align:left;\">Reason: "+reason+"</div><div style=\"text-align:left;\">Notes: "+notes+"</div>",	html: true});
	//$('#2_10:45').tooltip({placement: 'top', title: "<div style=\"text-align:left;\">Reason: "+reason+"</div><div style=\"text-align:left;\">Notes: "+notes+"</div>",	html: true});
	$('.evtpop_td_pat_name')
	//.tooltip('hide')
	.attr('data-original-title', "<div id=\"event_tt\" style=\"text-align:left;width:150px;white-space:normal;\">Name:"+this.splitText(patName, 20)+"</div><div style=\"text-align:left;white-space:normal;\">Reason:"+this.formatText(reason, 18)+"</div><div style=\"text-align:left;white-space:normal;\">Notes: "+this.formatText(notes, 25)+"</div><div style=\"text-align:left;white-space:normal;\">Room: "+this.formatText(room.replace(/_/g,' '), 18)+"</div></div>")
    //.tooltip('fixTitle')
    //.tooltip('show');
}
Schedular.prototype.clearGlobalId = function(modelID) {
	$('#'+modelID).modal('hide');
	globalApptId = "";
}
Schedular.prototype.editAppt = function(apptObject, tdObj) {
	
	//console.log($("#"+apptObject).attr("curapptid"));
	//globalApptId =  apptObject.split(":")[0];
	globalApptId = $("#"+apptObject).attr("curapptid");
	globalEventType = $("#pat_name"+globalApptId).attr("eventType");
	//apptObject = "appt_" + apptObject.split(":")[0];
	add_appt_appt_id = apptObject;
	globalObj.id = apptObject;
	var s = $('div').find("#" + apptObject).text();
	var sObject = JSON.stringify(s);
	//console.log(sObject);
	//alert("editAppt : " + apptObject);

//	$("#dialog-info").dialog({
//		minHeight : 150,
//		height : 150,
//		resizable : false,
//		width : 300,
//		modal : true
//	});
	//$('#dialog-info').modal();
	
	sch.showDialogs();

}

Schedular.prototype.showDialogs = function(){
$('#dialog-edit').modal();
	
	
	$(".ui-dialog-titlebar").hide();

	$("#sch_info_but_edit").on("click", function() {
		$("#next_app_form").dialog("close");
		//$('#myModal').modal();
		$('#dialog-edit').modal();
		$(".ui-dialog-titlebar").show();
		$(".ui-dialog-titlebar-close").hide();
		$('#dialog-info').modal('hide');
		$("#fex_app_form").dialog( "close" );
	});
	$("#sch_info_but_edit1").on("click", function() {
		$('#dialog-edit').modal('hide');
		$("#add_appt_form").dialog("open");
		$("#fex_app_form").dialog( "close" );
	});

	$("#sch_info_but_delete").on("click", function() {
		$('#dialog-info').modal('hide');
		$("#next_app_form").dialog("close");
		$("#dialog-delete").modal();
	});

	$("#sch_del_but_delete").on("click", function() {
		sch.clearForm("#add_appt_form");
		sch.deleteEvent(globalApptId, "");
		dateChange("");
		$("#add_appt_form").dialog("close");
		$("#dialog-delete").modal('hide');
		$('#dialog-info').modal('hide');
	});

	$("#sch_info_but_cancel").on("click", function() {
		$('#dialog-info').modal('hide');
	});
	$("#sch_info_but_cancel1").on("click", function() {
		$('#dialog-edit').modal('hide');
	});
	$("#sch_del_but_cancel").on("click", function() {
		$("#dialog-delete").modal('hide');
	});
}

var cnt = 0;
Schedular.prototype.getEventDiv = function(obj, act) {
	//alert("getEventDiv" + JSON.stringify(obj.room)); //(Undefined at this point)
	var apptType = ["", "E", "I", "B", "R"];
	var html = '';
	var duration = obj.duration;
	var hr = obj.hr;
	var min = obj.min;
	var pos = obj.pos;
	var offHeight = obj.offHeight;
	
	obj.noOfPat = obj.patientId!=null?obj.patientId.split(',').length:0;

	hr = hr - Schedular.config.start_time;
	var top = hr * (offHeight * 4);
	var top_add = ((min / 15) * offHeight) + 2;
	top += top_add;
	var stylecls = '';

	if (duration / 15 > 1)
		stylecls = 'evtpop_td_btm_line';
	var left = obj.offWidth * pos + 1;

	/*var height = ((duration / 15) * 34) + ((duration / 15 - 1) * 7)
	if (duration == 15)
		height = 36;
	var colspan = 4;*/
	
	var durationHeight = (window.innerHeight / 64) + 14;
	var durationHeight2 = (window.innerHeight / 64) + 16;
	
	var height = ((duration / 15) * durationHeight) + ((duration / 15 - 1) * 7)
	if (duration == 15)
		height = durationHeight2;
	var colspan = 4;
	
	//alert(top);
	
	if (act == "delete") {
		//var back = $('div').find("#" + hr + '_' + min);
		//back.remove();
	} else {

		if (obj.stauscolor == null)
			obj.stauscolor = "#5E5A80";
		var zoomWidth = "";
		if(Schedular.config.providersList !=null && Schedular.config.providersList.length==2 && globalView.view=="day"){
			var scrollzoomWidth = (document.getElementById('persondata').offsetWidth / 2) -5;
			zoomWidth = scrollzoomWidth + "px ! important;";
			}
		else if(Schedular.config.providersList !=null && Schedular.config.providersList.length==3 && globalView.view=="day"){
			var scrollzoomWidth = (document.getElementById('persondata').offsetWidth / 3) -5;
			zoomWidth = scrollzoomWidth + "px ! important;";
			}
		else if(Schedular.config.providersList !=null && Schedular.config.providersList.length==4 && globalView.view=="day"){
			var scrollzoomWidth = (document.getElementById('persondata').offsetWidth / 4) -5;
			zoomWidth = scrollzoomWidth + "px ! important;";
			}
		else if(Schedular.config.providersList !=null && Schedular.config.providersList.length==5 && globalView.view=="day"){
			var scrollzoomWidth = (document.getElementById('persondata').offsetWidth / 5) -5;
			zoomWidth = scrollzoomWidth + "px ! important;";
			}
		else if(Schedular.config.providersList !=null && Schedular.config.providersList.length==6 && globalView.view=="day"){
			var scrollzoomWidth = (document.getElementById('persondata').offsetWidth / 6) -5;
			zoomWidth = scrollzoomWidth + "px ! important;";
			}
		else if(Schedular.config.providersList !=null && Schedular.config.providersList.length==7 && globalView.view=="day"){
			var scrollzoomWidth = (document.getElementById('persondata').offsetWidth / 7) -5;
			zoomWidth = scrollzoomWidth + "px ! important;";
			}
		else
			zoomWidth = "220px;";
		html += '<div class="eventpop" style="height:' + height
				+ 'px;position: absolute;top:' + top + 'px;left:' + left
				//+ 'px;width:250px;" id=' + obj.hr + '_' + obj.min + '>';
				+ 'px;width:'+zoomWidth+'" id=appt_' + obj.apptId + '>';
		html += '<table class="eventtab" style="width:100%; height: 100%; border-collapse:collapse;padding:0px;" id="tab"  cellspacing="0" >';
		
		var reasonDis = "none";
		var notesDis = "none";
		if (duration > 15)
			reasonDis = "table-row";
		if (duration > 30)
			notesDis = "table-row";
		var overPopup = "";
		//alert(JSON.stringify(obj));
		//if(obj.duration==15 || obj.duration==30){
		if(obj.duration>=15){
			var rs = obj.reason!=null?(obj.reason).replace(/ /g,"_"):"";
			var nt = obj.notes!=null?(obj.notes).replace(/ /g,"_"):"";
			
			//var room = obj.roomId!=null?(obj.roomId).replace(/ /g,"_"):"";
			var room;
			if(obj.roomName != null && obj.roomName != undefined){
				room = (obj.roomName).replace(/ /g,"_") + "";
			} 
			else if(obj.roomId != null && obj.roomId != undefined) 
			{
				room = (obj.roomId).replace(/ /g,"_") + "";
			}
			else{
				room = "";
			}
			
			
			//alert("Room" + JSON.stringify(obj.roomId));
			var patName = obj.patientName!=null?(obj.patientName).replace(/ /g,"_"):"";
			patName = patName.replace(/[,]/g,"");
			overPopup="onmouseover=sch.createPopup(\"pat_name"+obj.apptId+"\",\""+rs+"\",\""+nt+"\",\""+room+"\",\""+patName+"\")";
		}else{
			overPopup ="";
		}
		
		/*if it is add appointment*/
		if(obj.patientName != null && obj.patientName.length > 0){
			html += '<tr class=""> <td class="gen_font '
					+ stylecls
					+ '" style="padding-left:3px;width:20px !important;" id="appt_sta_'
					+ obj.apptId.replace(/,/g,'_') + '" curapptid="'+obj.apptId.split(',')[0]+'"><div class="alertbox" style="background:'
					+ obj.stauscolor + ';">' + obj.appointStatus + '</div></td>';
			html += '<td class=" evtpop_td_ltline '
					+ stylecls
					+ '" style="width:10px !important;text-align:center;padding: 0 2px;"><div class="dropdown btn-group" > <a class="btn dropdown-toggle" data-toggle="dropdown" style="height:20px;padding:0px;">   <span class="caret" style="padding:0px;"></span>    </a>    <ul class="dropdown-menu">        '
					+ sch.getApptStatusHTML("appt_sta_" + obj.apptId.replace(/,/g,'_'))
					+ '    </ul></div></td>';
			var patNameLength = 20;
			var criticalDisplay = "none";
			if (obj.isCritical == "Y") {
				patNameLength = 18;
				criticalDisplay = "table-cell";
			}
			html += '<td class="evtpop_td_ltline '
				+ stylecls
				+ '" style="width:15px !important;text-align:center;display:'+criticalDisplay+'" id="appt_critical_'
				+ obj.apptId.replace(/,/g,'_') + '" ><div class="alertbox" style="background:#5E5A80;padding:0px;height:16px;">!</div></td>';
			colspan++;
		
			if(obj.isCritical == "Y" && obj.noOfPat != null && obj.noOfPat > 1)
				patNameLength = 10;
				
			if (obj.noOfPat != null && obj.noOfPat > 1) {
				/*html += '<td class=" evtpop_td_ltline '
						+ stylecls
						+ '" style="width:50px !important;text-align:center;padding-top:2px;"><div style="display: inline-block;cursor:pointer;" onclick="sch.repeatMulPat(this);" apptid="'
						+ obj.apptId +'" id="mulpat'
						+ obj.apptId.replace(/,/g,'_')
						+ '" index="0" totpat="'
						+ (obj.noOfPat)
						+ '"><input type="image" style="" src="js_up/images/multi_p.png"><span style="position: relative; top: -5px;">'
						+ (obj.noOfPat)
						+ '</span> <input type="image" style="width:12px;height:12px;" src="js_up/images/round_arrow.png"></div></td>';*/
			html += '<td class=" evtpop_td_ltline '
					+ stylecls
					+ '" style="overflow: hidden;padding-left: 2px; padding-right: 2px; text-overflow: ellipsis; white-space: nowrap; width:26px !important;text-align:center;padding-top:2px;"><div style="display: inline-block;cursor:pointer;" onclick="sch.repeatMulPat(this);" apptid="'
					+ obj.apptId +'" id="mulpat'
					+ obj.apptId.replace(/,/g,'_')
					+ '" index="0" totpat="'
					+ (obj.noOfPat)
					+ '"><input type="image" style="" src="js_up/images/multi_p.png"><span style="position: relative; top: -5px;">'
					+ (obj.noOfPat)
					+ '</span></div></td>';
			
			}	
			
			
			
			var j = obj.apptId + ':' + obj.hr + '_' + obj.min;

			html += "<td class=\"evtpop_td_pat_name evtpop_td_ltline\" style=\"color:#3366FF;cursor:pointer;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;\" eventType='appointment' curapptid='"+obj.apptId.split(',')[0]+"' id='pat_name"
					+ obj.apptId.replace(/,/g,'_')
					+ "' apptid=\""
					+ obj.apptId
					+ "\" onclick='sch.editAppt(this.id,\""+ obj.id +"\")'"+overPopup+" >"
					+ this.formatText(obj.patientName, patNameLength) + "</td>";
			var tempToTo = apptType[obj.goTo];
			if(tempToTo == null || tempToTo == undefined)
				tempToTo = obj.goTo;
			
			var goToDisplay = "table-cell";
			if(obj.goTo == null)
				goToDisplay = "none";
			
			html += '<td class="evtpop_td_ltline '
					+ stylecls
					+ '" style="width:15px !important;text-align:center;display:'+goToDisplay+'" curapptid="'+obj.apptId.split(',')[0]+'" id="appt_goto_'
					+ obj.apptId.replace(/,/g,'_') + '">' + tempToTo + '</td>';
			colspan++;
			var _apptObject = JSON.stringify(obj);
			html += '<td class="evtpop_td_ltline '
					+ stylecls
					+ '" style="width:15px !important;text-align:center;padding: 0 2px;"><div class="dropdown btn-group" > <a class="btn dropdown-toggle" data-toggle="dropdown" style="height:20px;padding:0px;padding-left:3px;padding-right:3px;padding-top:0px;padding-bottom:0px;">   <span class="caret" style="padding:0px;"></span>    </a>    <ul class="dropdown-menu">        '
					+ sch.getApptGotoHTML('appt_goto_' + obj.apptId.replace(/,/g,'_'), obj.providerName, obj.startDate, obj.hr, obj.min,_apptObject)
					+ '    </ul></div></td>';
			html += '</tr>';
		
			
	
			html += "<tr style='display:" + reasonDis + "'>";
			html += "<td colspan='" + colspan + "' class='gen_font2' id='appt_rea"
					+ obj.apptId + "'><span class='gen_font3'>Reason:</span> "
					+ this.formatText(obj.reason, 40) + "</td>";
			html += "</tr>";
	
			html += "<tr style='display:" + notesDis + "'>";
			html += "<td colspan='" + colspan + "' class='gen_font2' id='appt_note"
					+ obj.apptId + "'><span class='gen_font3'>Notes:</span> "
					+ this.formatText(obj.notes, 40) + "</td>";
			html += "</tr>";
			
			//To Display Room field in appointment on Scheduler screen.
			
//			var room = obj.roomId!=null?(obj.roomName).replace(/ /g,"_"):"";
			
			var room;
			if(obj.roomName != null && obj.roomName != undefined){
				room = (obj.roomName).replace(/ /g,"_") + "";
			} else {
				room = (obj.roomId).replace(/ /g,"_") + "";
			}
			
			//var room = obj.roomId!=null?(obj.roomId).replace(/ /g,"_"):"";
			
			html += "<tr style='display:" + notesDis + "'>";
			html += "<td colspan='" + colspan + "' class='gen_font2' id='appt_room"
					+ obj.apptId + "'><span class='gen_font3'>Room:</span> "
					+ this.formatText(room, 18) + "</td>";
			html += "</tr>";
			
			
			
			
		}else{/* block time*/
			html += "<tr>";
			/*html += "<td class='gen_font2' id='appt_rea"

					+ obj.apptId + "'><span class='gen_font3'>"+ this.formatText(obj.reason, 40) +":</span> "
					+ obj.providerName + "</td>";*/
			var j = obj.apptId + ':' + obj.hr + '_' + obj.min;
			html += "<td class=\"evtpop_td_pat_name evtpop_td_ltline\" style=\"color:#3366FF;cursor:pointer;\"curapptid='"+obj.apptId+"' eventType='blocktime' id='pat_name"
				+ obj.apptId
				+ "' apptid=\""
				+ obj.apptId
				+ "\" onclick='sch.editAppt(this.id,\""+ obj.id +"\")'"+overPopup+" >"+ this.formatText(obj.reason, 40) +": &nbsp; "
				+ obj.providerName + "</td>";
			
			html += "</tr>";
	
			html += "<tr style='display:" + reasonDis + "'>";
			html += "<td colspan='" + colspan + "' class='gen_font2' id='appt_note"
					+ obj.apptId + "'>";
			
			if(obj.notes != "")
				html += "<span class='gen_font3'>Description:</span> " +  this.formatText(obj.notes, 40);
			html += "</td>";
			html += "</tr>";
		}

		html += '</table>';
		html += '</div>';

	}
	add_appt_pat_cnt_names = "";
	return document.getElementById("events").innerHTML + html;
}

Schedular.prototype.repeatMulPat = function(obj) {
	var apptId = $(obj).attr('apptid');
	var index = $(obj).attr('index');
	var totpat = $(obj).attr('totpat');
	// console.log(index+" - "+totpat);
	if (index == (totpat - 1)) {
		index = 0;
	} else {
		index = ++index;
	}
	$(obj).attr('index', index);
	// console.log();
	// add_appt_pat_cnt_names="";
	// add_app_fn.validateForm(index);
	sch.setMulPatDtls(apptId, index);

	// console.log(apptId+" - "+index+" - "+add_appt_pat_cnt_names);
}

Schedular.prototype.setMulPatDtls = function(apptId, index) {	
	var currentApptId = apptId.split(',')[index];
	var _data = sch.getMulPatApptDtls(currentApptId);
	apptId = apptId.replace(/,/g,'_');
	$("#pat_name" + apptId).html(this.formatText(_data["patientName"], 10));
//	console.log("#pat_name" + apptId);
	//sch.setApptStatus(_data["apptSta"], _data["appointStatus"], "appt_sta_"+ apptId);
	$("#appt_sta_" + apptId).attr("curapptid", currentApptId);
	$("#appt_sta_" + apptId).html('<div class="alertbox" style="background:#5E5A80;padding:0px;">' + _data["apptStatus"] + '</div>');
	//sch.setApptGoto(_data["apptGoto"], "appt_goto_" + apptId);
	var apptType = ["", "E", "I", "B", "R"];
//	console.log(currentApptId);
	$("#appt_goto_" + apptId).attr("curapptid", currentApptId);
	$("#pat_name" + apptId).attr("curapptid", currentApptId);
	if(_data["goTo"] != null){		
		if(isNaN(_data["goTo"]))
			$("#appt_goto_" + apptId).html( _data["goTo"]);
		else 
			$("#appt_goto_" + apptId).html( apptType[_data["goTo"]]);
		document.getElementById("appt_goto_" + apptId).style.display = "table-cell";
	}else{
		document.getElementById("appt_goto_" + apptId).style.display = "none";
	}
	
	if(_data["isCritical"] == "Y"){		
		document.getElementById("appt_critical_" + apptId).style.display = "table-cell";
	}else{
		document.getElementById("appt_critical_" + apptId).style.display = "none";
	}

	$("#appt_rea" + apptId).html("<span class='gen_font3'>Reason:</span>&nbsp;"	+ this.formatText(_data["apptRea"], 40));
	$("#appt_note" + apptId).html("<span class='gen_font3'>Notes:</span>&nbsp;"	+ this.formatText(_data["apptNotes"], 40));
}

Schedular.prototype.getMulPatApptDtls = function(apptId) {
	var appt_data =	$.ajax({
		url : "../ws/rs/patient/"+apptId+"/viewEdit",
		type : "get",
		contentType : 'application/json',
		Accept: 'application/json',					
		async:false,
		success : function(result) {
			//appt_data = result.appointments;
		},
		error : function(jqxhr) {
			var msg = JSON.parse(jqxhr.responseText);
			alert(msg['message']);
		}
	}).responseText;
	var jObj = JSON.parse(appt_data);
	return jObj.appointments;
}

Schedular.prototype.getApptStatusHTML = function(divID) {
	var _html = "";
	$
			.each(
					appt_status_data,
					function(a, row) {
						_html += "<li><a style='text-align:left;width:150px;' onclick='sch.setApptStatus(\""
								+ row.id
								+ "\", \""
								+ row.color
								+ "\", \""
								+ divID
								+ "\")' code='"
								+ row.id
								+ "' color='"
								+ row.color
								+ "'><span class='alertbox' style='background:"
								+ row.color
								+ ";padding:1px;height:16px;width:40px !important;font-size:12px;'>"
								+ row.id
								+ "</span>&nbsp;"
								+ row.name
								+ "</a></li>";

					});
	return _html;
}

Schedular.prototype.setApptStatus = function(code, color, divID) {
	var curApptId = $("#" + divID).attr("curapptid");
	//console.log(divID.split('_')[2]);
	var apptID = '';
	if(divID != null)
		apptID = divID.split('_')[2];
	sch.saveApptStatus(curApptId, code);
	$("#" + divID).html(
			'<div class="alertbox" style="background:' + color
					+ ';padding:0px;">' + code + '</div>');
}

Schedular.prototype.saveApptStatus = function(apptID, code) {
	$.ajax({
		url : "../ws/rs/appointment/"+ apptID +"/"+code+"/saveStatus",
		type : "get",
		//contentType : 'application/json',
		dataType: "json" ,
		global: false,
		async:false,
		success : function(result) {
			//alert('done');
		},
		error : function(jqxhr) {
			var msg = JSON.parse(jqxhr.responseText);
			alert(msg['message']);

		}
	});
}
var printLable_date;
var printLable_time;
var printLable_provName;
Schedular.prototype.printLables = function(provName, date, hour, min) {
	var AM_PM = " am";
	if(hour > 12){
		hour -= 12;
		AM_PM = " pm";
	}
	var time = hour+":"+min+ AM_PM;
	printLable_date = date;
	printLable_time = time;
	printLable_provName = provName;
	
	var w = 550;
	var h = 300;
	var left = (screen.width/2)-(w/2);
	var top = (screen.height/2)-(h/2) - 100;
	window.open("./partials/printLabels.jsp", "_blank", 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left, "window")
	
}
Schedular.prototype.getApptGotoHTML = function(divID, provName, date, hour, min, apptObj) {
	var _html = "";
	$
			.each(
					appt_goto_data,
					function(a, row) {
						_html += "<li><a style='text-align:left;width:150px;' onclick='sch.setApptGoto(\""+ row.id + "\", \"" + divID	+ "\","+	apptObj+"	)'>"
								+ row.name + "</a></li>";

					});
	_html += "<li><a style='text-align:left;width:150px;' onclick='sch.printLables(\""+provName+"\", \""+date+"\", \""+hour+"\", \""+min+"\")'>Print lables</a></li>";
	return _html;
}

Schedular.prototype.setApptGoto = function(code, divID, apptObj) {
	//var apptType = ["", "E", "I", "B", "R"];
	var apptID = '';
	var curApptId = $("#" + divID).attr("curapptid");
	if(divID != null)
		apptID = divID.split('_')[2];
	sch.saveApptGoto(curApptId, code);
	document.getElementById(divID).style.display = "table-cell";
	console.log(apptObj);
	//var msg = JSON.parse(apptObj);
	//console.log(apptObj.docId);
	$("#" + divID).html( code);
	sch.openQuickLink(curApptId, code, apptObj,divID);
}
Schedular.prototype.openQuickLink = function(curApptId, code, apptObj,divID) {
	var patId;
	if (apptObj.noOfPat != null && apptObj.noOfPat > 1) {
		var index = $("#mulpat" +apptObj.apptId.replace(/,/g,'_')).attr("index");
		console.log(apptObj.apptId.replace(/,/g,'_'));
		patId= apptObj.patientId.split(',')[index];
	}else{
		patId=apptObj.patientId;
	}
	
	var dateArr = apptObj.apptStartDate.split('-')
	var date = dateArr[2] + "-"+ (parseInt(getMonthIndex("-"+dateArr[1])) +1) +"-"+ dateArr[0];
	
	if(code == 'R'){
		url = "../oscarRx/choosePatient.do?providerNo="+apptObj.docId+"&demographicNo="+apptObj.docId;
		sch.openWindow(url, 1000,600);
	}else if(code == 'B'){
		var url = "../billing/CA/ON/billingOB.jsp?billRegion=ON&billForm=MFP&hotclick=&appointment_no="+curApptId+"&demographic_name=Lorraine+Kinsy%2CBrooks+Smithfields&status=TD&demographic_no="+patId+"&providerview="+apptObj.docId+"&user_no=999998&apptProvider_no="+apptObj.docId+"&appointment_date="+date+"&start_time="+apptObj.fromTime+":00&bNewForm=1";
		sch.openWindow(url, 1000,600);
	}else if(code == 'E'){
		
		
		var url = "../casemgmt/forward.jsp?action=view&demographicNo="+patId+"&providerNo=999998&providerName="+apptObj.providerName+"&appointmentNo="+curApptId+"&reason="+apptObj.reason+"&appointmentDate="+date+"&start_time="+apptObj.fromTime+":00&apptProvider="+apptObj.docId+"&providerview="+apptObj.docId;
		sch.openWindow(url, 1000,600);
	}
}

Schedular.prototype.openWindow = function(url, width, height) {
	var w = width;
	var h = height;
	var left = (screen.width/2)-(w/2);
	var top = (screen.height/2)-(h/2) - 100;
	window.open(url, "_blank", 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left, "window")
}

Schedular.prototype.saveApptGoto = function(apptID, code) {
	$.ajax({
		url : "../ws/rs/appointment/"+ apptID +"/"+code+"/saveType",
		type : "get",
		//contentType : 'application/json',
		dataType: "json" ,
		global: false,
		async:false,
		success : function(result) {
			//alert('done');
		},
		error : function(jqxhr) {
			var msg = JSON.parse(jqxhr.responseText);
			alert(msg['message']);

		}
	});
}

Schedular.prototype.formatText = function(text, length) {
	if (text == null)
		return "";
	if (text.length > length)
		return text.substring(0, length) + "...";
	else
		return text;
}

Schedular.prototype.splitText = function(text, length) {
	var l = text.length, lc = 0, chunks = [], c = 0, chunkSize = length;
	if (text == null)
		return "";
	if (text.length > length){
		
		for (; lc < l; c++) {
			if(c==0){
				chunks[c] = text.slice(lc, lc += chunkSize);
			}else{
				chunks[c] = text.slice(lc, lc += (chunkSize+5));
			}
		  
		}
		var temp ="";
		for(var i=0; i < chunks.length; i++){
			temp=temp+chunks[i]+"<br\>";
		}
		return temp;
	}
		
	else
		return text;
}

Schedular.prototype.getPosition = function(doc_id) {
	var providers = Schedular.config.providersList;
	for (var i = 0; i < providers.length; i++) {
		if (providers[i].id == doc_id)
			return i;
	}
}

Schedular.prototype.loadDayEvents = function(events) {
	var obj = [];
	if (events.length > 0) {
		//alert(events);
		for (var i = 0; i < events.length; i++) {
			obj = [];
			var event = events[i];
			if ((event["docId"] != "" && event["docId"] != null)&& isEmpty(Schedular.config.weekDayList)) {
				var fromtime = event["fromTime"];
				var docId = event["docId"];
				event.hr = this.getHour(fromtime);
				event.min = this.getMin(fromtime);
				event.pos = this.getPosition(docId);
				event.duration = events[i]["duration"];
				event.apptId = events[i]["apptId"];
				event.providerName = events[i]["providerName"];
				event.startDate = events[i]["apptStartDate"];
				event.noOfPat = events[i]["noOfPat"];
				var objId = docId + "_" + event.hr + ":" + event.min;
				event.offHeight = document.getElementById(objId)==null?25:document.getElementById(objId).offsetHeight;
				event.offWidth = document.getElementById(objId)==null?300:document.getElementById(objId).offsetWidth;
				document.getElementById("events").innerHTML = this.getEventDiv(event, "first");
				//alert("loadDayEvents : " + JSON.stringify(event));
			}else{		
				var fromtime = event["fromTime"];
				var docId = Schedular.config.weekDayList.indexOf(event["apptStartDate"]);
				event.docId = docId+1;
				event.hr = this.getHour(fromtime);
				event.min = this.getMin(fromtime);
				event.pos = docId;
				event.duration = events[i]["duration"];
				event.apptId = events[i]["apptId"];
				event.noOfPat = events[i]["noOfPat"];
				var objId = docId + "_" + event.hr + ":" + event.min;
				event.offHeight = document.getElementById(objId)==null?25:document.getElementById(objId).offsetHeight;
				event.offWidth = document.getElementById(objId)==null?300:document.getElementById(objId).offsetWidth;
				document.getElementById("events").innerHTML = this.getEventDiv(event, "first");
				//alert("loadDayEvents : " + JSON.stringify(event));
			}
		}
	}
	if(sch.valid_date(document.getElementById("inputField").value))
		setTimeout('Schedular.prototype.timerTab()', 100);
	if(globalView.view=="week"){
		$(".Yscale th").addClass("weekColor");
	}else{
		$(".Yscale th").removeClass("weekColor");
	}
	
}

Schedular.prototype.getHour = function(time) {
	var temp;
	if (time != null) {
		temp = time.split(":");
		return temp[0];
	}
	
}

Schedular.prototype.getMin = function(time) {
	var temp;
	if (time != null) {
		temp = time.split(":");
		return temp[1];
	}
	
}

Schedular.prototype._getHour = function(time) {
	var temp;
	if (time != null) {
		temp = time.split("_");
		var result = this.round(temp[0]);
		return result;
	}
	
}

Schedular.prototype._getMin = function(time) {
	var temp;
	if (time != null) {
		temp = time.split("_");
		return temp[1];
	}
	
}
Schedular.prototype.objToString = function(obj) {
	var str = '';
	for ( var p in obj) {
		if (obj.hasOwnProperty(p)) {
			str += p + '::' + obj[p] + '\n';
		}
	}
	return str;
}
Schedular.prototype.disablePopup1 = function() {
	if (popupStatus == 1) { // if value is 1, close popup
		// alert("in dis");
		$("#toPopup").fadeOut("normal");
		$("#backgroundPopup").fadeOut("normal");
		popupStatus = 0; // and set value to 0
	}
}
Schedular.prototype.setInitData = function(params) {
	//alert(JSON.stringify(params));
	
	var data = $.ajax({
		url : "../ws/rs/appointment/roomDetails/get",
		type : "get",
		dataType : 'application/json',
		global: false,
		async:false,
		success : function(result) {
		},
		error : function(jqxhr) {

		}
	}).responseText;
	
	var jObj = JSON.parse(data);
	
	//alert(JSON.stringify(jObj));
	
	
	var result = params.data['response'];
	var result_dt = (params.data['response'])['day'];
	var result_dts = (params.data['response'])['days'];
	if(result_dts != null && result_dts.length>0){
		
		weekDB= sch.setWeekDB(result_dts);
		weekDB_hideWeekEnds = sch.setHideWeekDB(result_dts);
	}
	var variables = params.vars;
	var toDat = document.getElementById("inputField").value;
	Schedular.config.eventsList = [];
	Schedular.config.providersList = [];
	if (isEmpty(params.vars)) {
			if (result_dt == toDat) {
				Schedular.config.eventsList = (params.data['response'])['events'];
				Schedular.config.providersList = (params.data['response'])['providers'];
				Schedular.config.weekDayList = [];
				//return false;
			}
	} else {
			if (result_dt == params.vars.doc_dt && result_dt != null) {
				Schedular.config.eventsList = (params.data['response'])['events'];
				Schedular.config.providersList = (params.data['response'])['providers'];
				Schedular.config.weekDayList = [];
				if (!isEmpty(params.vars.doc_list)) {
					var providers = [];
					var provider = Schedular.prototype.getProvider(params.vars.doc_list);
					var events = Schedular.prototype.getEvents(params.vars.doc_list);
					//alert("GetEvents : " + events);
					Schedular.prototype.setProviders(provider);
					Schedular.prototype.setEvents(events);
				}
				//return false;
			}else if(result_dts!=null){
				Schedular.config.eventsList = (params.data['response'])['events'];
				Schedular.config.providersList = (params.data['response'])['providers'];
				Schedular.config.weekDayList = result_dts;
			}
	}
	
	//alert("setInitData : " + JSON.stringify(Schedular.config.eventsList));
	
	//To get Room Field working in added appointment as well as popup
	for (var i = 0; i < Schedular.config.eventsList.length; i++) {
		var event = Schedular.config.eventsList[i];
		for (var j = 0; j < jObj.length; j++) 
		{
			if(event['roomId'] == jObj[j]['id'])
			{
				Schedular.config.eventsList[i]['roomName'] = jObj[j]['name'];
				break;
			}
		}
		
	}
	
	setTimeout(function() {
		document.getElementById('xdummytabtd').style.width = document.getElementById('testidd').offsetWidth+ "px";
	}, 4000);
	if(Schedular.config.providersList==null||(Schedular.config.providersList!=null && Schedular.config.providersList.length==1)){
		
	}else{
		providerListObj.providersList = Schedular.config.providersList; 
	}
}
Schedular.prototype.ajaxMethod = function(url, ORSCFuncName, variables) {
	$.getJSON(url, function(result) {
		var res = result;
		eval(ORSCFuncName)({
			data : res,
			vars : variables
		});
	});
}
Schedular.prototype.showTab = function(id) {
	document.getElementById(id).click();
}
Schedular.prototype.timerTab = function() {
	var timer = "";
	var incrementTime = 1000 * 60 * 5, // Timer speed in milliseconds
	currentTime = 0, // Current time in hundredths of a second
	updateTimer = function() {
		currentTime += incrementTime / 10;
		Schedular.prototype.timerDisable();
	}, 
	init1 = function() {
		//alert('Test!');
		Schedular.prototype.timerDisable();
		timer = $.timer(updateTimer, incrementTime, true);
	};
	init1();
}
Schedular.prototype.timerDisable = function() {
	var min15 = [ '00', '15', '30', '45' ];
	var today = new Date();
	var h = today.getHours();
	var m = today.getMinutes();
	var sec = today.getSeconds();
	//alert('Test!');
	if (h < 10) {
		h = "0" + h;
	} else {
		h = h;
		
	}
	var x = (m / 15);
	var s = $("td .noline,.withline");
	for (i in s) {
		if (s[i].id != undefined) {
			var s0 = i > 0 ? s[i - 1].id.split("_") : "08:00";
			var s1 = s[i].id.split("_");
			// console.log($("#"+s[i].id).id); 1_08:00,2_09:45
			// console.log(s0[1]==h+":"+min15[Math.floor(x)]);
			// console.log(s1[1]==h+":"+min15[Math.floor(x)]);
			if ((s0[1] == h + ":" + min15[Math.floor(x)])
					&& !(s1[1] == h + ":" + min15[Math.floor(x)])) {
				return;
			} else {
				//$(s[i]).removeAttr("ondblclick").css("border-bottom", "").css("background", "#BDBDBD").fadeTo(250, 0.25);
				$(s[i]).css("border-bottom", "").css("background", "#BDBDBD").fadeTo(250, 0.25);
				var s3 = s1[1].split(":");

				//$("#" + s3[0] + "_" + s3[1]).removeAttr("ondblclick")
						//.removeAttr("onclick").fadeTo(250, 0.25);
				/* Removed by Bhaskar for the maintaining the equality between
				 * appointments above and below the green line
				 */
				//$("#" + s3[0] + "_" + s3[1]).fadeTo(250, 0.25);  

				//$("#" + s3[0] + "_" + s3[1] + " .evtpop_td_ltline").removeAttr("ondblclick").removeAttr("onclick")
				if (!(s0[1] == h + ":" + min15[Math.floor(x)])
						&& (s1[1] == h + ":" + min15[Math.floor(x)])) {
					$(s[i]).css("border-bottom", "3px solid green");
				} else if ((s0[1] == h + ":" + min15[Math.floor(x)])
						&& (s1[1] == h + ":" + min15[Math.floor(x)])) {
					$(s[i]).css("border-bottom", "3px solid green");
				}
			}
		}
	}
}

Schedular.prototype.getDayViewFormat = function(date) {
	var week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
	var dateArr = date.split('-');
	var dateObj = new Date(parseFloat(dateArr[2]), parseFloat(getMonthIndex(dateArr[1])), parseFloat(dateArr[0]));
	return week[dateObj.getDay()]+", "+dateArr[1]+" "+dateArr[0];
}
Schedular.prototype.clearForm = function(formId) {

	$(formId + ' :input').each(function() {
		var type = this.type;
		var tag = this.tagName.toLowerCase(); // normalize case

		if (type == 'text' || type == 'password' || tag == 'textarea') {
			this.value = "";
		} else if (type == 'checkbox' || type == 'radio') {
			this.checked = false;
		} else if (tag == 'select') {
			this.selectedIndex = 0;
		}

		//add_app_fn.loadPatientDtls('');
		$("#naa_search").text("Search");
	});
}
Schedular.prototype.valid_date = function(dt) {
	var date = new Date();
	var day = "";
	if (date.getDate() < 10)
		day = "0" + date.getDate();/*
									 * Modified by Bhaskar for date differences
									 * between calender and system dates
									 */
	else
		day = date.getDate();
	var month = date.getMonth();
	var year = date.getYear();
	if (year <= 200) {
		year += 1900;
	}
	var days = new Array('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
	months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
			'Sep', 'Oct', 'Nov', 'Dec');
	days_in_month = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	if (year % 4 == 0 && year != 1900) {
		days_in_month[1] = 29;
	}
	total = days_in_month[month];
	var date_today = day + "-" + months[month] + "-" + year;
	var dt_arr = dt.split("-");
	if (dt_arr[2] == year) {
		if (months.indexOf(dt_arr[1]) == month) {
			if (dt_arr[0] == day) {
				return true;
			} else {
				//alert("Date must be greater than or equal to current date!");
				return false;
			}
		} else {
			//alert("Date must be greater than or equal to current date!");
			return false;
		}
	} else {
		//alert("Date must be greater than or equal to current date!");
		return false;
	}
}
Schedular.prototype.weekForCurrentDay = function (dt) {
	var sz = dt.split("-");
	var months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
	var a = months.indexOf(sz[1]);
	//a= a+1;
	if(a<10){
		a = "0"+a
	}else{
		a = a
	}
	//console.log(sz[2]+"-"+a+"-"+sz[0]);
	//var current = new Date(Date.UTC(year, month, day, hour, minute, second));     // get current date
	var current = new Date(Date.UTC(sz[2],a,sz[0],5,0,0));     // get current date
	//console.log(current);
	var s = Schedular.prototype.weekDay(current);
	var weekstart = current.getUTCDate() - current.getDay() +1;    
	var weekend = weekstart + 6;       // end day is the first day + 6 
	//console.log(current.getDate() +"<<>>"+ current.getDay());
	var monday = new Date(current.setDate(weekstart));
	var sunday = new Date(current.setDate(weekend));
	var s_start  =  Schedular.prototype.weekDay(monday);
	var s_end  =  Schedular.prototype.weekDay(sunday);
	return (s_start+","+s_end);
}
Schedular.prototype.weekForCurrentDate = function (dt) {
	var sz = dt.split(" to ");
	return sch.getFullDateFormat(sz[0]) +","+ sch.getFullDateFormat(sz[1]);
}

Schedular.prototype.getFullDateFormat = function(dt){
	var dtOpts = dt.split('-');
	return dtOpts[0] +"-"+ dtOpts[1] +"-20"+ dtOpts[2];
} 


Schedular.prototype.weekDay = function (date){
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
	return date_today;
}

Schedular.prototype.weekForCurrentDay_Offset = function (dt) {
	//console.log(dt);
	var sz = dt.split("-");
	var months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
	var a = months.indexOf(sz[1]);
	//a= a+1;
	if(a<10){
		a = "0"+a
	}else{
		a = a
	}
	//console.log(sz[2]+"-"+a+"-"+sz[0]);
	//var current = new Date(Date.UTC(year, month, day, hour, minute, second));     // get current date
	var current = new Date(Date.UTC(sz[0],sz[1],sz[2],5,0,0));     // get current date
	//console.log(current);
	var s = Schedular.prototype.weekDay(current);

	return s;
}
Schedular.prototype.showAll = function () {
	if(globalView.view=="day"){
	var _data = new Object
	_data.data = sch.showAllPrvidersData("fetchGroupAppointments");
//	console.log(_data.data);
	Schedular.prototype.setInitData(_data);
	setTimeout('sch.init(\''+globalView.view+'\',\'from Show All\')', 1000);
	}

}
Schedular.prototype.showScheduled = function () {
	if(globalView.view=="day"){
		var _data = new Object
		_data.data = sch.showAllPrvidersData("fetchGroupHavingEvents");
//		console.log(_data.data);
		Schedular.prototype.setInitData(_data);
		setTimeout('sch.init(\''+globalView.view+'\',\'from Show selected\')', 1000);
		}

}
Schedular.prototype.showAllPrvidersData = function (urlParam) {
	var dt = $("#inputField").val();
	var gr = $("#docava").val();
	var selGroup  = gr.split("_")[0];
//		console.log(selGroup);
	var data1 = $.ajax({
			url : "../ws/rs/providerService/"+dt+"/"+selGroup+"/"+urlParam,
			type : "get",
			async: false,
			contentType : 'application/json',
			success : function(result) {
			},
			error : function(jqxhr) {
				var msg = JSON.parse(jqxhr.responseText);
//				console.log(msg['message']);

			}
		}).responseText;
		var jObj = JSON.parse(data1);
		return jObj;
}
Schedular.prototype.hideWeekends = function () {
	hideWeekEnds = true;
	if(globalView.view=="week")
	sch.init("week","from hide week ends");
	setTimeout(function() {
		document.getElementById('xdummytabtd').style.width = document.getElementById('testidd').offsetWidth+ "px";
	}, 2000);
	
}
Schedular.prototype.showWeekends = function () {
	hideWeekEnds = false;
	if(globalView.view=="week")
	sch.init("week","from show week ends");
	setTimeout(function() {
		document.getElementById('xdummytabtd').style.width = document.getElementById('testidd').offsetWidth+ "px";
	}, 2000);
	
}
Schedular.prototype.flipHideWeekends = function () {
	flipWeekendHide = true;
	showdata(globalProviderId);
}
Schedular.prototype.flipShowWeekends = function () {
	flipWeekendHide = false;
	showdata(globalProviderId);
	
}
Schedular.prototype.setWeekDB = function (result_dts) {
	var tempWeekDB ="";
	tempWeekDB = [{
		name : "Monday, "+(result_dts[0].split("-"))[1]+" "+(result_dts[0].split("-"))[0],
		id : "1"
	}, {
		name : "Tuesday, "+(result_dts[1].split("-"))[1]+" "+(result_dts[1].split("-"))[0],
		id : "2"
	}, {
		name : "Wednesday, "+(result_dts[2].split("-"))[1]+" "+(result_dts[2].split("-"))[0],
		id : "3"
	}, {
		name : "Thursday, "+(result_dts[3].split("-"))[1]+" "+(result_dts[3].split("-"))[0],
		id : "4"
	}, {
		name : "Friday, "+(result_dts[4].split("-"))[1]+" "+(result_dts[4].split("-"))[0],
		id : "5"
	}, {
		name : "Saturday, "+(result_dts[5].split("-"))[1]+" "+(result_dts[5].split("-"))[0],
		id : "6"
	}, {
		name : "Sunday, "+(result_dts[6].split("-"))[1]+" "+(result_dts[6].split("-"))[0],
		id : "7"
	} ];
	return tempWeekDB;
}
Schedular.prototype.setHideWeekDB = function (result_dts) {
	var tempWeekDB ="";
	tempWeekDB = [{
		name : "Monday, "+(result_dts[0].split("-"))[1]+" "+(result_dts[0].split("-"))[0],
		id : "1"
	}, {
		name : "Tuesday, "+(result_dts[1].split("-"))[1]+" "+(result_dts[1].split("-"))[0],
		id : "2"
	}, {
		name : "Wednesday, "+(result_dts[2].split("-"))[1]+" "+(result_dts[2].split("-"))[0],
		id : "3"
	}, {
		name : "Thursday, "+(result_dts[3].split("-"))[1]+" "+(result_dts[3].split("-"))[0],
		id : "4"
	}, {
		name : "Friday, "+(result_dts[4].split("-"))[1]+" "+(result_dts[4].split("-"))[0],
		id : "5"
	}];
	return tempWeekDB;
}