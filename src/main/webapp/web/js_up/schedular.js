var globalObj=new Object();
var globalView=new Object();
var nextAailObject = new Object();
var add_appt_pat_cnt_names = "";
var weekDB = [
	{name: "Monday", id: "1"},
	{name: "Tuesday", id: "2"},
	{name: "Wednesday", id: "3"},
	{name: "Thursday", id: "4"},
	{name: "Friday", id: "5"},
	{name: "Saturday", id: "6"},
	{name: "Sunday", id: "7"}
];



var appt_goto_data = [{"scode":"E", "desc":"E-chart"},
				{"scode":"I", "desc":"Intake form"},
				{"scode":"B", "desc":"Billing"},
				{"scode":"R", "desc":"Rx"}];

				
/*flip days view start*/
var flipdays = [
	{date: "Monday,Nov11", flipdata: ["-","-","C2","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Thuseday,Nov12", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Wednesday,Nov13", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Thursday,Nov14", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Friday,Nov15", flipdata: [" "," "," "," ","G2","G2","G2","G2","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Saturday,Nov16", flipdata: [" "," "," "," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Sunday,Nov17", flipdata: [" "," "," "," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Monday,Nov18", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Thuseday,Nov19", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Wednesday,Nov20", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Thursday,Nov21", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Friday,Nov22", flipdata: [" "," "," "," ","G2","G2","G2","G2","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Saturday,Nov23", flipdata: [" "," "," "," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Sunday,Nov24", flipdata: [" "," "," "," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Monday,Nov25", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Thuseday,Nov26", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Wednesday,Nov27", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Thursday,Nov28", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Friday,Nov29", flipdata: [" "," "," "," ","G2","G2","G2","G2","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Saturday,Nov30", flipdata: ["-","G2","G1"," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Sunday,Dec01", flipdata: ["-","C1","G2"," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Monday,Dec02", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Thuseday,Dec03", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Wednesday,Dec04", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Thursday,Dec05", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Friday,Dec06", flipdata: [" "," "," "," ","G2","G2","G2","G2","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Saturday,Dec07", flipdata: [" "," "," "," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Sunday,Dec08", flipdata: [" "," "," "," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]}
];

var appt_status_data = [{"scode":"TD", "desc":"To do", "color":"red"},
				{"scode":"DP", "desc":"Daysheet printed", "color":"blue"},
				{"scode":"HR", "desc":"Here", "color":"green"},
				{"scode":"EM", "desc":"Empty room", "color":"#848484"},
				{"scode":"NS", "desc":"No show", "color":"#6633CC"},
				{"scode":"CX", "desc":"Cancelled", "color":"#660033"},
				{"scode":"NP", "desc":"Ready for NP", "color":"#FF0066"},
				{"scode":"FT", "desc":"Fast track", "color":"#66CC00"}];

var mulPatDtls = {
	"0":{
			patName: "Abbey",
			apptSta: "HR",
			apptStaColor: "green",
			apptGoto: "B",
			apptRea:"Physical Examination.required",
			apptNote:"Noted complications since last year"
		},
	"1":{
			patName: "Adem",
			apptSta: "TD",
			apptStaColor: "red",
			apptGoto: "E",
			apptRea:"General checkup",
			apptNote:"n/a"
		},
	"2":{
			patName: "Doe, Jane",
			apptSta: "FT",
			apptStaColor: "#66CC00",
			apptGoto: "I",
			apptRea:"Annual check-up",
			apptNote:"Noted complications since last year"
		},
	"3":{
			patName: "Donaghy, Jane",
			apptSta: "NP",
			apptStaColor: "#FF0066",
			apptGoto: "R",
			apptRea:"Physical Examination.required",
			apptNote:"n/a"
		},
	"4":{
			patName: "Donahue, Jane",
			apptSta: "NS",
			apptStaColor: "#6633CC",
			apptGoto: "E",
			apptRea:"Half yearly check-up",
			apptNote:"Noted complications since last year"
		},
	"5":{
			patName: "Smith",
			apptSta: "EM",
			apptStaColor: "#848484",
			apptGoto: "B",
			apptRea:"General checkup",
			apptNote:"Full activity evaluation"
		}
}

function showdata(){
	var finalData = '<table class="xscale" style="border-right:1px solid #cecece !important;"><tr><td style="text-align:center;"><input type="image" src="js_up/images/icon_help_small.png"/>&nbsp;<input type="image" src="js_up/images/clock_small.gif"/></td>';

	var j=8;
	for(var i=0; i<10; i++){
		finalData += '<td style="text-align:center;">'+parseFloat(j+i)+'.00</td>'+'<td style="text-align:center;">'+parseFloat(j+i)+'.15</td>'+'<td style="text-align:center;">'+parseFloat(j+i)+'.30</td>'+'<td style="text-align:center;">'+parseFloat(j+i)+'.45</td>';
	}
	finalData=finalData+'</tr>';

	for(var a=0; a<this.flipdays.length; a++){
		finalData+='<tr><td >'+this.flipdays[a].date+'</td>';
		
		for(var b=0; b<this.flipdays[a].flipdata.length; b++){
			finalData+='<td style="text-align:center;">'+this.flipdays[a].flipdata[b]+'</td>'
		}
		finalData+='</tr>'
	}
	document.getElementById('flipview').innerHTML = finalData;
}
/* flip days view end*/

var Schedular = function(){}
Schedular.views = {month:'monthview', day:'dayview', week:'dayview'};
Schedular.config = {
	start_time:8, 
	end_time:20,
	increment:15,
	top_align:100,
	left_align:50,
	providersList:[],
	eventsList:[]
};

Schedular.prototype.setProviders = function(providers){
	Schedular.config.providersList = providers;
}
Schedular.prototype.setEvents = function(events){
	Schedular.config.eventsList = events;
}
Schedular.prototype.setEventsList = function(eventsList){
Schedular.config.eventsList = eventsList;
}
Schedular.prototype.getEventsList = function(){
return Schedular.config.eventsList;
}
Schedular.prototype.load = function(date){
	this.getApptStatusHTML();
	Schedular.prototype.ajaxMethod("../ws/rs/schedule/123/list",Schedular.prototype.setInitData,{"doc_dt":date});
	document.getElementById("inputField").value = date;
	setTimeout('Schedular.prototype.init(\'day\',\'from load\')',1000);
}
Schedular.prototype.init = function(view,from){
//console.log(view+"<<>>"+from);
	globalView.view =view;
	this.persons = Schedular.config.providersList;
	if(view == 'week')
		this.persons = weekDB;
	this.view = view;
	this.setView(view);
	/*Load calendar in month view*/
	calendar();
	var scrollWid = document.getElementById('secNav').offsetWidth - 80;
	//alert(scrollWid)
	var data = this.getYScale();
	var headData = '<div id="clock" style="float:left"><table class="xscale" style="float: left;cellpadding:0;cellpadding:0;padding-bottom:0px !important;border-bottom: 0px !important;" ><tr><td ><input type="image" src="js_up/images/clock_small.gif"/></td></tr></table>';
	headData += '<div id="names" class="scrolldiv" style="width:'+scrollWid+'px;float:left;overflow-x:hidden;"><table id="testidd" class="Yscale" width="'+this.getPersonTabWidth()+'px" style="table-layout:fixed;float: left;cellpadding:0;cellpadding:0;padding-bottom:0px !important;border-bottom: 0px !important;" >'+this.getXHeader()+'</table></div>';

	document.getElementById('head').innerHTML = headData;

	var scaleData = "<div style='display: inline-block;overflow-y:scroll;height:500px;' class='scrolldiv2'><div id='abc' style='float:left'>"+data+"</div>"+"<div id='persondata' style='float:left;overflow-x:hidden;width:"+scrollWid+"px;' class='scrolldiv'>"+this.getXData()+"</div></div>";
	scaleData += "<div id='persondatadummy' class='scrolldiv' style='width:"+scrollWid+"px;height:20px;margin-left:30px;overflow-x:scroll;'><table  style='table-layout:fixed;' id='xdummytab'><tr><td id='xdummytabtd'>ask fhasdl kfhas klh lkhas dflaksdhf asdfkalsdhf asdhfjka hsdfkljshad fjkasdl hfaksdj fhaksldjfh askldj fhasldkfjh asldkjfh askldfh aklsdhfkasdh fkshdfklsdfsdfsdf haksldjfh askldj fhasldkfjh asldkjfh askldfh aklsdhfkasdh fkshdfklsdfsdfsdfhaksldjfh askldj fhasldkfjh asldkjfh askldfh aklsdhfkasdh fkshdfklsdfsdfsdf haksldjfh askldj fhasldkfjh asldkjfh askldfh aklsdhfkasdh fkshdfklsdfsdfsdf</td></tr></table></div>";
	document.getElementById('providerdiv').innerHTML = scaleData;	 

	document.getElementById('xdummytab').width = document.getElementById('testidd').offsetWidth;

	syncScrollBars();
	//$( "div.first" ).slideUp( 300 ).delay( 800 ).fadeIn( 400 );
	//setTimeout('Schedular.prototype.loadDayEvents(Schedular.config.eventsList)',1000);
	Schedular.prototype.loadDayEvents(Schedular.config.eventsList);
}
Schedular.prototype.getProvider_z = function(providerID){
	for(var i=0; i<Schedular.config.providersList.length; i++){
		if(Schedular.config.providersList[i].id == providerID){
			return Schedular.config.providersList[i];
		}
	}
	alert('Provider not found.');
}
Schedular.prototype.getEvents_z = function(providerID){
var arrEvents  =[];
	for(var i=0; i<Schedular.config.eventsList.length; i++){
		if(Schedular.config.eventsList[i].doc_id == providerID){
			arrEvents.push(Schedular.config.eventsList[i]);
		}
	}
	return (arrEvents);
	//console.log('Events not found.');
}


Schedular.prototype.getProvider = function(providerID){
var foo = [];
var bar =[];
for(var i=0; i<Schedular.config.providersList.length; i++){
		bar.push(Schedular.config.providersList[i].id);
	}
var i = 0;
jQuery.grep(providerID, function(el) {
    if (jQuery.inArray(el.id, bar) == -1){
    }else{
     foo.push(el);
    }
    i++;

});
return foo;
	//for(var i=0; i<Schedular.config.providersList.length; i++){
	//	if(Schedular.config.providersList[i].id == providerID[i].id){
	//		return Schedular.config.providersList[i];
	//	}
	//}
	alert('Provider not found.');
}
Schedular.prototype.getEvents = function(providerID){
var arrEvents  =[];
	for(var i=0; i<Schedular.config.eventsList.length; i++){
	for(var j=0; j<providerID.length; j++){
		if(Schedular.config.eventsList[i].doc_id == providerID[j].id){
			arrEvents.push(Schedular.config.eventsList[i]);
		}
	}
	}
	return (arrEvents);
	//console.log('Events not found.');
}

Schedular.prototype.setView = function(view){
	//this.clearAllViews();
	//document.getElementById(Schedular.views[view]).style.display = "block";
}

Schedular.prototype.clearAllViews = function(){
	//for(key in Schedular.views)
		//document.getElementById(Schedular.views[key]).style.display = "none";
}

Schedular.prototype.getYScale = function(){
	var _YScale = '';
	var _shour = Schedular.config.start_time, _smin = 0;

	var time = '';
	_YScale += '<table class="xscale" style="float: left;">';
	//_YScale += '<tr><td><input type="image" src="images/clock_small.GIF"/></td></tr>';
	while(_shour < Schedular.config.end_time){
		if(_smin >= 60){
			_shour++;
			_smin -= 60;
			if(_shour == Schedular.config.end_time)
				break;
		}
		_YScale += '<tr><td>';
		time = this.round(_shour) + ":" + this.round(_smin);
		_smin += Schedular.config.increment; 
		

		_YScale += time;
		_YScale += '</td></tr>';
	}
	_YScale += '</table>';
	return _YScale;
}

Schedular.prototype.getXData = function(){
	var wid = this.persons.length * 300;
	//if(wid < 1400)
		//wid = '100%';
	var Xdata = '';
		Xdata +='<div style="position: relative;"><table class="Yscale" style="table-layout: fixed;float: left;" width="'+wid+'px" id="persondatatab">';
	//Xdata += this.getXHeader() + this.getXScale();
	Xdata += this.getXScale();
	Xdata += '</table><div id="events" style="position:absolute"></div></div>';
	return Xdata;
}

Schedular.prototype.getPersonTabWidth = function(){
	var wid = this.persons.length * 300;
	//if(wid < 1400)
		//wid = '100%';
	return wid;
}

Schedular.prototype.getXHeader = function(){
	var _XHeader = '';
	_XHeader += '<tr>';
	if(this.persons.length == 1)
		_XHeader += '<th style="width:300px !important;text-align:center;display: inline-block;" ><div style="float:left;width:80%;text-align:center;" id="'+this.persons[0].id+'">'+this.persons[0].name+'</div><div class="zoomIn" onclick="sch.zoom()">Zoom out</div></th>';
	else
		for(var i=0; i<this.persons.length; i++){
			if(this.view == 'day')
				_XHeader += '<th style="width:300px !important;text-align:center;display: inline-block;" ><div style="float:left;width:80%;text-align:center;" >'+this.persons[i].name+'</div><div class="zoomIn" id="'+this.persons[i].id+'" onclick="sch.zoom(this.id)">Zoom</div></th>';
			else
				_XHeader += '<th style="width:300px !important;text-align:center;display: inline-block;" ><div style="float:left;width:170px;text-align:center;" >'+this.persons[i].name+'</div></th>';
		}
	_XHeader += '</tr>';
	return _XHeader;
}

Schedular.prototype.getXScale = function(){
	var _XScale = '';
	var _shour = Schedular.config.start_time, _smin = 0, temp_min=0;;
	var style = 'withline';
	while(_shour < Schedular.config.end_time){

		if(_smin >= 60){
			style = 'withline';
			_shour++;
			_smin -= 60;
			if(_shour == Schedular.config.end_time)
				break;
		}
		
		

		_XScale += '<tr>';
		time = this.round(_shour) + ":" + this.round(_smin);
		temp_min = _smin;
		_smin += Schedular.config.increment; 
		for(var i=0; i<this.persons.length; i++){
			_XScale += "<td style=\"height:25px !important;width:300px !important;\" class=\""+style+"\" position=\""+i+"\" ondblclick='sch.addEvent(this)' hour=\""+_shour+"\" min=\""+temp_min+"\" time=\""+time+"\" name=\""+this.persons[i].name+"\" pid=\""+this.persons[i].id+"\" id=\""+this.persons[i].id+"_"+time+"\"><div style=\"border: 1px solid #CECECE;border-bottom: 0px;width:20px;height: 100%;\">C1</div></td>";
		}
		
		_XScale += '</tr>';
		style = 'noline';
	}
	return _XScale;
}

Schedular.prototype.round = function(time){
	if(parseInt(time) < 10)
		return '0'+time;
	
	return time;
}

Schedular.prototype.zoom = function(id){
	var providers = [];
	if(!isEmpty(id)){
	var provider = this.getProvider_z(id);
	var events_z = this.getEvents_z(id)
	providers.push(provider);
	this.setProviders(providers);
	this.setEvents(events_z);
	this.init('day',"from zoom");
	}else{
	this.load(document.getElementById("inputField").value);
	}
	
}

Schedular.prototype.addEvent = function(obj){
	add_appt_appt_id = '';
	nextAailObject = new Object(); /* Added by Bhaskar for reset the data from next Appointment */
	globalObj = obj;
	add_app_fn.loadPatientDtls('');
	$("#add_appt_form").dialog("open");
	

}
Schedular.prototype.editEvent = function(){
	//for(key in obj)
	loading(); // loading
	setTimeout(function(){ // then show popup, deley in .5 second
		loadPopupEdit(); // function show popup
	}, 500); // .5 second
	$( "#toPopup" ).draggable();
	var $tabs = $( "#tabsSch" ).tabs();
	//this.saveEvent(obj);

}

Schedular.prototype.saveEvent = function(obj,appObj){
	console.log("eneter every time");
	obj.offHeight = (obj.id != "" && document.getElementById(obj.id).offsetHeight!=null)?document.getElementById(obj.id).offsetHeight:100;
	obj.offWidth = (obj.id != "" && document.getElementById(obj.id).offsetWidth!=null)?document.getElementById(obj.id).offsetWidth:100;
	obj.patient_name = appObj.patient_name;
	obj.reason = appObj.appt_reason_text;
	obj.duration = appObj.duration;
	//obj.hr = appObj['time'];
	//obj.hr = document.getElementById(obj.id).getAttribute('hour');// From Khadaree
	//obj.min = document.getElementById(obj.id).getAttribute('min');
	obj.hr = this._getHour(appObj['time']);
	obj.min = this._getMin(appObj['time']);
	obj.pos = document.getElementById(obj.id).getAttribute('position');
	obj.notes = appObj.appt_notes;
	obj.appoint_status = appObj.appt_status;
	obj.go_to = appObj.go_to;
	obj.is_critical = appObj.is_critical;
	obj.appt_id = appObj.appt_id;
	obj.pat_sel_index = appObj.pat_sel_index;
	obj.no_of_pat = appObj.no_of_pat;
	console.log(obj);
	document.getElementById("events").innerHTML = this.getEventDiv(obj, "save");
	
	
	$('#'+obj.hr+'_'+obj.min).draggable().resizable();
	
}

Schedular.prototype.saveBlockEvent = function(obj,appObj){

	obj.offHeight = (obj.id != "" && document.getElementById(obj.id).offsetHeight!=null)?document.getElementById(obj.id).offsetHeight:100;
	obj.offWidth = (obj.id != "" && document.getElementById(obj.id).offsetWidth!=null)?document.getElementById(obj.id).offsetWidth:100;
	
	obj.reason = appObj.appt_reason;
	obj.duration = appObj.duration;
	//obj.hr = appObj['time'];
	//obj.hr = document.getElementById(obj.id).getAttribute('hour');// From Khadaree
	//obj.min = document.getElementById(obj.id).getAttribute('min');
	obj.hr = this._getHour(appObj['time']);
	obj.min = this._getMin(appObj['time']);
	obj.pos = document.getElementById(obj.id).getAttribute('position');
	obj.notes = appObj.appt_notes;
	
	obj.appt_id = appObj.appt_id;
	document.getElementById("events").innerHTML = this.getBlockEventDiv(obj, "save");
	
	
	$('#'+obj.hr+'_'+obj.min).draggable().resizable();
	
}



Schedular.prototype.deleteEvent = function(apptObject){
	//document.getElementById("events").innerHTML = this.getEventDiv(obj,"delete");
	var $back = $('div').find("#"+apptObject);
	$back.remove();
}
Schedular.prototype.editAppt = function(apptObject){
	/*set variable value in addAppt.jsp*/
	add_appt_appt_id = apptObject;
	globalObj.id =apptObject;
	var s = $('div').find("#"+apptObject).text();
	var sObject = JSON.stringify(s);
	//console.log(sObject);
	
	$("#dialog-info").dialog({
			minHeight: 150,
			height: 150,
			resizable: false,
			width: 300,
			modal: true
			});
	
	$("#dialog-delete").dialog({
			autoOpen: false,
			resizable: false,
			minHeight: 120,
			height: 120,
			width: 300,
			modal: true
			});
			
	$(".ui-dialog-titlebar").hide();
	
	$("#sch_info_but_edit").on("click",function(){
			$("#next_app_form").dialog("close");
			sch.clearForm("#add_appt_form");
			$("#add_appt_form").dialog("open");
			$("#dialog-info").dialog( "close" );
	});
	
	$("#sch_info_but_delete").on("click",function(){
			$("#dialog-info").dialog( "close" );
			$("#next_app_form").dialog("close");
			$("#dialog-delete").dialog("open");
	});
	
	$("#sch_del_but_delete").on("click",function(){
			sch.clearForm("#add_appt_form");
			sch.deleteEvent(apptObject);
			$("#dialog-delete").dialog( "close" );
			$("#dialog-info").dialog( "close" );
	});
	
	$("#sch_info_but_cancel").on("click",function(){
			$("#dialog-info").dialog( "close" );
	});
	
	$("#sch_del_but_cancel").on("click",function(){
			$("#dialog-delete").dialog( "close" );
	});
	
	/*$( "#dialog-info" ).dialog({
				resizable: false,
				height:120,
				buttons: {
				"Edit": function(){
					$("#next_app_form").dialog("close");
					sch.clearForm("#add_appt_form");
					$("#add_appt_form").dialog("open");
					$( this ).dialog( "close" );
					$("#dialog-info").dialog( "close" );
				},
				"Delete": function() {
				$("#next_app_form").dialog("close");
					$( "#dialog-delete" ).dialog({
						resizable: false,
						height:120,
						buttons: {
						"Delete": function() {
							sch.clearForm("#add_appt_form");
							sch.deleteEvent(apptObject);
							$( this ).dialog( "close" );
							$("#dialog-info").dialog( "close" );
						},
						"Cancel": function() {
							$( this ).dialog( "close" );
						}
						}
						});
				},
				"Cancel": function() {
					$( this ).dialog( "close" );
				}
				}
				});*/
}

var cnt = 0;
Schedular.prototype.getEventDiv = function(obj,act){
	var html = '';
	var duration = obj.duration;
	var hr = obj.hr ;
	var min = obj.min;
	var pos = obj.pos;
	var offHeight = obj.offHeight;

	hr = hr - Schedular.config.start_time;
	var top = hr * (offHeight *4);
	var top_add = ((min/15) * offHeight) + 2;
	top += top_add;
	var stylecls = '';
	
	if(duration/15 > 1)
		stylecls = 'evtpop_td_btm_line';
	var left = obj.offWidth * pos + 22;

	var height = ((duration/15) * 20) + ((duration/15 -1) * 7)
	if(duration == 15)
		height = 22;
	var colspan = 4;
	if(act=="delete"){
		var $back = $('div').find("#"+hr+'_'+min);
		 $back.remove();
	}else{
	
	if(obj.stauscolor == null)
		obj.stauscolor = "#5E5A80";

	html += '<div class="eventpop" style="height:'+height+'px;position: absolute;top:'+top+'px;left:'+left+'px;width:250px;" id='+obj.hr+'_'+obj.min+'>';
	html += '<table class="eventtab" style="width:100%;border-collapse:collapse;padding:0px;" id="tab"  cellspacing="0" >';
	html += '<tr class=""> <td class="gen_font '+stylecls+'" style="padding-left:5px;width:20px !important;" id="appt_sta_'+obj.appt_id+'"><div class="alertbox" style="background:'+obj.stauscolor+';">'+obj.appoint_status+'</div></td>';
	//html += '<td class="evtpop_td_ltline '+stylecls+'" style="text-align:center;width:12px;"><input type="image" src="js_up/images/smallDownArrow.gif"/></td>';
	//console.log(add_appt_pat_cnt_names);
	html += '<td class=" evtpop_td_ltline '+stylecls+'" style="width:10px !important;text-align:center;"><div class="dropdown btn-group" > <a class="btn dropdown-toggle" data-toggle="dropdown" style="height:20px;padding:0px;padding-left:6px;padding-right:6px;padding-top:0px;padding-bottom:0px;">   <span class="caret" style="padding:0px;"></span>    </a>    <ul class="dropdown-menu">        '+sch.getApptStatusHTML("appt_sta_"+obj.appt_id)+'    </ul></div></td>';
	if(obj.is_critical == "Y"){
		html += '<td class="evtpop_td_ltline '+stylecls+'" style="width:15px !important;text-align:center;"><div class="alertbox" style="background:#5E5A80;padding:0px;height:16px;">!</div></td>';
		colspan++;
	}
	if(obj.no_of_pat != null && obj.no_of_pat > 1){
		html += '<td class=" evtpop_td_ltline '+stylecls+'" style="width:50px !important;text-align:center;padding-top:2px;"><div style="display: inline-block;cursor:pointer;" onclick="sch.repeatMulPat(this);" apptid="'+obj.appt_id+'" index="0" totpat="'+(obj.no_of_pat)+'"><input type="image" style="" src="js_up/images/multi_p.png"><span style="position: relative; top: -5px;">'+(obj.no_of_pat)+'</span> <input type="image" style="width:12px;height:12px;" src="js_up/images/round_arrow.png"></div></td>';
	}
	var j = obj.hr+'_'+obj.min;
	html += "<td class=\"evtpop_td_pat_name evtpop_td_ltline\" style=\"color:#C35817;cursor:pointer;\" id='pat_name"+obj.appt_id+"' apptid=\""+obj.appt_id+"\" onclick='sch.editAppt(\""+j+"\")' >"+obj.patient_name+"</td>";
	if(obj.go_to != null){
		html += '<td class="evtpop_td_ltline '+stylecls+'" style="width:15px !important;text-align:center;" id="appt_goto_'+obj.appt_id+'">'+obj.go_to+'</td>';
		colspan++;
	}
	html += '<td class="evtpop_td_ltline '+stylecls+'" style="width:15px !important;text-align:center;"><div class="dropdown btn-group" > <a class="btn dropdown-toggle" data-toggle="dropdown" style="height:20px;padding:0px;padding-left:6px;padding-right:6px;padding-top:0px;padding-bottom:0px;">   <span class="caret" style="padding:0px;"></span>    </a>    <ul class="dropdown-menu">        '+sch.getApptGotoHTML('appt_goto_'+obj.appt_id)+'    </ul></div></td>';
	html += '</tr>';
	var reasonDis = "none";
	var notesDis = "none";
	if(duration > 15)
		reasonDis = "table-row";	
	if(duration > 30)
		notesDis = "table-row";
		
	html += "<tr style='display:"+reasonDis+"'>";
	html += "<td colspan='"+colspan+"' class='gen_font2' id='appt_rea"+obj.appt_id+"'><span class='gen_font3'>Reason:</span> "+this.formatText(obj.reason, 40)+"</td>";
	html += "</tr>";
	
	html += "<tr style='display:"+notesDis+"'>";
	html += "<td colspan='"+colspan+"' class='gen_font2' id='appt_note"+obj.appt_id+"'><span class='gen_font3'>Notes:</span> "+this.formatText(obj.notes, 40)+"</td>";
	html += "</tr>";
	
	html += '</table>';
	html += '</div>';
	
	}
	add_appt_pat_cnt_names="";
	console.log(obj);
	return document.getElementById("events").innerHTML + html;
}

Schedular.prototype.repeatMulPat = function(obj){
	var apptId = $(obj).attr('apptid');
	var index = $(obj).attr('index');
	var totpat = $(obj).attr('totpat');
	//console.log(index+" - "+totpat);
	if(index == (totpat-1)){
		index = 0;
	}else{
		index = ++index;
		}
	$(obj).attr('index', index);
	//console.log();
	//add_appt_pat_cnt_names="";
	//add_app_fn.validateForm(index);
	sch.setMulPatDtls(apptId, index);
	
	
	
	//console.log(apptId+" - "+index+" - "+add_appt_pat_cnt_names);
}

Schedular.prototype.setMulPatDtls = function(apptId, index){
	var _data = sch.getMulPatApptDtls(apptId, index);
	$("#pat_name"+apptId).html(this.formatText(_data["patName"], 10));
	sch.setApptStatus(_data["apptSta"], _data["apptStaColor"], "appt_sta_"+apptId);
	sch.setApptGoto(_data["apptGoto"], "appt_goto_"+apptId);
	
	$("#appt_rea"+apptId).html("<span class='gen_font3'>Reason:</span>&nbsp;"+ this.formatText(_data["apptRea"], 40));
	$("#appt_note"+apptId).html("<span class='gen_font3'>Notes:</span>&nbsp;"+ this.formatText(_data["apptNote"], 40));
}

Schedular.prototype.getMulPatApptDtls = function(apptId, index){
	//ajax code to save the apptstatus dtls
	return mulPatDtls[index];
}

Schedular.prototype.getApptStatusHTML = function(divID){
	
	var _html = "";
	$.each(appt_status_data, function(a, row){
		//console.log(row.scode);
		_html += "<li><a style='text-align:left;width:150px;' onclick='sch.setApptStatus(\""+row.scode+"\", \""+row.color+"\", \""+divID+"\")' code='"+row.scode+"' color='"+row.color+"'><span class='alertbox' style='background:"+row.color+";padding:1px;height:16px;width:40px !important;font-size:12px;'>"+row.scode+"</span>&nbsp;"+row.desc+"</a></li>";
		
	});
	return _html;
}

Schedular.prototype.setApptStatus = function(code, color, divID){
	sch.saveApptStatus(code);
	$("#"+divID).html('<div class="alertbox" style="background:'+color+';padding:0px;">'+code+'</div>');
}

Schedular.prototype.saveApptStatus = function(code){
	//ajax code to save the apptstatus dtls
}

Schedular.prototype.getApptGotoHTML = function(divID){
	
	var _html = "";
	$.each(appt_goto_data, function(a, row){
		
		_html += "<li><a style='text-align:left;width:150px;' onclick='sch.setApptGoto(\""+row.scode+"\", \""+divID+"\")'>"+row.desc+"</a></li>";
		
	});
	return _html;
}

Schedular.prototype.setApptGoto = function(code, divID){
	sch.saveApptStatus(code);
	$("#"+divID).html(code);
}

Schedular.prototype.saveApptGoto = function(code){
	//ajax code to save the apptstatus dtls
}


Schedular.prototype.formatText = function(text, length){
	if(text == null)
		return "";
	if(text.length > length)
		return text.substring(0,length)+"...";
	else
		return text;
}


Schedular.prototype.getPosition = function(doc_id){
	var providers = Schedular.config.providersList;
	for(var i=0; i<providers.length;i++ ){
		if(providers[i].id == doc_id)
			return i;
	}
}

Schedular.prototype.loadDayEvents = function(events){
	var obj = [];
	//console.log(events);
	if(events.length>0){
	for(var i=0; i<events.length;i++ ){
		obj = [];
		var event = events[i];
		var fromtime = event["from_time"];
		var docId = event["doc_id"];
		event.hr = this.getHour(fromtime);
		event.min = this.getMin(fromtime);
		event.pos = this.getPosition(docId);
		event.duration = events[i]["duration"]; 
		event.appt_id = events[i]["appt_id"]; 
		var objId = docId + "_" + event.hr+":"+event.min;
		event.offHeight = document.getElementById(objId).offsetHeight;
		event.offWidth = document.getElementById(objId).offsetWidth;
		
		document.getElementById("events").innerHTML = this.getEventDiv(event,"first");

	}
	}
	/*alert(obj.hr);
	alert(obj.min);
	alert(obj.pos);
	alert(obj.duration);
	alert(obj.offHeight);
	alert(obj.offWidth);*/
//Schedular.prototype.timerTab();
}

Schedular.prototype.getHour = function(time){
	var temp;
	if (time != null){
		temp = time.split(":");
	}
	var result = this.round(temp[0]);
	return result;
}

Schedular.prototype.getMin = function(time){
	var temp;
	if (time != null){
		temp = time.split(":");
	}
	return temp[1];
}


Schedular.prototype._getHour = function(time){
	var temp;
	if (time != null){
		temp = time.split("_");
	}
	var result = this.round(temp[0]);
	return result;
}

Schedular.prototype._getMin = function(time){
	var temp;
	if (time != null){
		temp = time.split("_");
	}
	return temp[1];
}
Schedular.prototype.objToString = function (obj) {
    var str = '';
    for (var p in obj) {
        if (obj.hasOwnProperty(p)) {
            str += p + '::' + obj[p] + '\n';
        }
    }
    return str;
}
Schedular.prototype.disablePopup1 = function() {
		if(popupStatus == 1) { // if value is 1, close popup
		//alert("in dis");
			$("#toPopup").fadeOut("normal");  
			$("#backgroundPopup").fadeOut("normal");  
			popupStatus = 0;  // and set value to 0
		}
	}
Schedular.prototype.setInitData = function(params){
		  var result = params.data['providerData'];
		  var variables = params.vars;
		  var toDat = document.getElementById("inputField").value;
		  Schedular.config.eventsList=[];
		  Schedular.config.providersList=[];
		  if(isEmpty(params.vars)){
		 $.each(result, function(i, obj){
			
		   if(obj['day'] == toDat){
			  Schedular.config.eventsList = obj['eventsDB'];
			  Schedular.config.providersList = obj['providersDB'];
			  return false;
			}
		  });
		  }else{
		 //Schedular.config.eventsList=[];
		  //Schedular.config.providersList=[];
		  $.each(result, function(j, obj){
		  if(obj['day'] == params.vars.doc_dt){
		   	Schedular.config.eventsList = obj['eventsDB'];
			Schedular.config.providersList = obj['providersDB'];
		  if(!isEmpty(params.vars.doc_list)){
		   var providers =[];

		   var provider = Schedular.prototype.getProvider(params.vars.doc_list);
			var events = Schedular.prototype.getEvents(params.vars.doc_list)
			//providers.push(provider);
			Schedular.prototype.setProviders(provider);
			Schedular.prototype.setEvents(events);
			}
			  return false;
			}
		 });
		  }
		 setTimeout(function(){
			//alert('jerer'+document.getElementById('testidd').offsetWidth);
			document.getElementById('xdummytabtd').width = document.getElementById('testidd').offsetWidth+"px";
		  }, 5000) 
}
Schedular.prototype.ajaxMethod = function(url, ORSCFuncName, variables){
		$.getJSON(url,function(result){
			var res=result;
			eval(ORSCFuncName)({data:res, vars:variables}); 
		});
}
Schedular.prototype.showTab = function(id){
	document.getElementById(id).click();
}
Schedular.prototype.timerTab = function(){
var timer="";
var    incrementTime = 1000*60*5, // Timer speed in milliseconds
        currentTime = 0, // Current time in hundredths of a second
        updateTimer = function() {
            currentTime += incrementTime / 10;
			Schedular.prototype.timerDisable();
        },
		init1 = function() {
			Schedular.prototype.timerDisable();
            timer = $.timer(updateTimer, incrementTime, true);
        };
	//timer = $.timer(function() {
	//Schedular.prototype.timerDisable();
	//},'900000', true);
	$(init1);
}
Schedular.prototype.timerDisable = function(){
//alert("in timer");

	var min15 =['00','15','30','45'];
	var today=new Date();
	var h=today.getHours();
	var m=today.getMinutes();
	var sec=today.getSeconds();
	if(h<10){
		h="0"+h;
	}else{
		h = h;
	}
	var x = (m/15);
	//console.log(h+":"+min15[Math.floor(x)]+":"+sec+">>>x:"+Math.floor(x));
	var s = $("td .noline,.withline");
	//console.log(s);
	for(i in s){
		if(s[i].id != undefined){
			var s0 = i>0?s[i-1].id.split("_"):"08:00";
			var s1 = s[i].id.split("_");
			//console.log($("#"+s[i].id).id); 1_08:00,2_09:45
			//console.log(s0[1]==h+":"+min15[Math.floor(x)]);
			//console.log(s1[1]==h+":"+min15[Math.floor(x)]);
			if((s0[1]==h+":"+min15[Math.floor(x)]) &&!(s1[1]==h+":"+min15[Math.floor(x)])){
				
				return;
			}else{
				$(s[i])
				.removeAttr( "ondblclick")
				.css("border-bottom", "")
				.css("background", "#BDBDBD")
				.fadeTo(250, 0.25);

				var s3 = s1[1].split(":");

				$("#"+s3[0]+"_"+s3[1])
				.removeAttr( "ondblclick")
				.removeAttr( "onclick")
				.fadeTo(250, 0.25);
				
				$("#"+s3[0]+"_"+s3[1]+" .evtpop_td_ltline")
				.removeAttr( "ondblclick")
				.removeAttr( "onclick")
				if(!(s0[1]==h+":"+min15[Math.floor(x)]) &&(s1[1]==h+":"+min15[Math.floor(x)])){
					$(s[i])
					.css("border-bottom", "3px solid green");
					}else if((s0[1]==h+":"+min15[Math.floor(x)]) &&(s1[1]==h+":"+min15[Math.floor(x)])){
					$(s[i])
					.css("border-bottom", "3px solid green");
					}
			}
		}
	}
}
 Schedular.prototype.clearForm = function (formId) {

    $(formId+' :input').each(function() {
      var type = this.type;
      var tag = this.tagName.toLowerCase(); // normalize case

      if (type == 'text' || type == 'password' || tag == 'textarea'){
        this.value = "";
      }else if (type == 'checkbox' || type == 'radio'){
        this.checked = false;
      }else if (tag == 'select'){
        this.selectedIndex = 0;
		}

		add_app_fn.loadPatientDtls('');
		$("#naa_search").text("Search");
    });
 }
Schedular.prototype.valid_date = function (dt) {
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
		var dt_arr = dt.split("-");
		if(dt_arr[2] >= year){
			if(months.indexOf(dt_arr[1]) >= month ){
				if(dt_arr[0] >= day ){
				return true;
				}else{
				alert("Date must be greater than or equal to current date!");
				return false;
				}
			}else{
			alert("Date must be greater than or equal to current date!");
			return false;
			}
		}else{
		alert("Date must be greater than or equal to current date!");
		return false;
		}
 }
 


