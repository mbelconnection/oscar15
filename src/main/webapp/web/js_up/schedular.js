var globalObj=new Object();
var globalView=new Object();
var nextAailObject = new Object();
var weekDB = [
	{name: "Monday", id: "1"},
	{name: "Tuesday", id: "2"},
	{name: "Wednesday", id: "3"},
	{name: "Thursday", id: "4"},
	{name: "Friday", id: "5"},
	{name: "Saturday", id: "6"},
	{name: "Sunday", id: "7"}
];

/*flip days view start*/
var flipdays = [
	{date: "Monday,Nov11", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
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
	{date: "Saturday,Nov30", flipdata: [" "," "," "," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Sunday,Dec01", flipdata: [" "," "," "," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Monday,Dec02", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Thuseday,Dec03", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Wednesday,Dec04", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Thursday,Dec05", flipdata: ["-","-","-","-","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","C1","L1","L1","L1","L1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","P1","-","-","-","-"]},
	{date: "Friday,Dec06", flipdata: [" "," "," "," ","G2","G2","G2","G2","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Saturday,Dec07", flipdata: [" "," "," "," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]},
	{date: "Sunday,Dec08", flipdata: [" "," "," "," "," "," "," "," ","","","","","","","","","","","",""," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]}
];

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
Schedular.prototype.setEventsList = function(eventsList){
Schedular.config.eventsList = eventsList;
}
Schedular.prototype.getEventsList = function(){
return Schedular.config.eventsList;
}
Schedular.prototype.load = function(date){
	Schedular.prototype.ajaxMethod("js_up/intial_data.js",Schedular.prototype.setInitData,{"doc_dt":date});
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
	headData += '<div id="names" class="scrolldiv" style="width:'+scrollWid+'px;float:left;overflow-x:hidden;"><table id="testidd" class="Yscale" width="'+this.getPersonTabWidth()+'px" style="float: left;cellpadding:0;cellpadding:0;padding-bottom:0px !important;border-bottom: 0px !important;" >'+this.getXHeader()+'</table></div>';

	document.getElementById('head').innerHTML = headData;

	var scaleData = "<div style='display: inline-block;' class='scrolldiv2'><div id='abc' style='float:left'>"+data+"</div>"+"<div id='persondata' style='float:left;overflow-x:hidden;width:"+scrollWid+"px;' class='scrolldiv'>"+this.getXData()+"</div></div>";
	scaleData += "<div id='persondatadummy' class='scrolldiv' style='width:"+scrollWid+"px;height:20px;margin-left:30px;'><table  style='table-layout:auto;' id='xdummytab' width='2000px'><tr><td><div >ask fhasdl kfhas klh lkhas dflaksdhf asdfkalsdhf asdhfjka hsdfkljshad fjkasdl hfaksdj fhaksldjfh askldj fhasldkfjh asldkjfh askldfh aklsdhfkasdh fkshdfkl</div></td></tr></table></div>";
	document.getElementById('providerdiv').innerHTML = scaleData;	 

	document.getElementById('xdummytab').width = document.getElementById('testidd').offsetWidth;

	syncScrollBars();
	//$( "div.first" ).slideUp( 300 ).delay( 800 ).fadeIn( 400 );
	//setTimeout('Schedular.prototype.loadDayEvents(Schedular.config.eventsList)',1000);
	Schedular.prototype.loadDayEvents(Schedular.config.eventsList);
}

Schedular.prototype.getProvider = function(providerID){
	for(var i=0; i<Schedular.config.providersList.length; i++){
		if(Schedular.config.providersList[i].id == providerID){
			return Schedular.config.providersList[i];
		}
	}
	alert('Provider not found.');
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
	var wid = this.persons.length * 220;
	if(wid < 900)
		wid = '100%';
	var Xdata = '';
		Xdata +='<div style="position: relative;"><table class="Yscale" style="float: left;" width="'+wid+'px" id="persondatatab">';
	//Xdata += this.getXHeader() + this.getXScale();
	Xdata += this.getXScale();
	Xdata += '</table><div id="events" style="position:absolute"></div></div>';
	return Xdata;
}

Schedular.prototype.getPersonTabWidth = function(){
	var wid = this.persons.length * 220;
	if(wid < 900)
		wid = '100%';
	return wid;
}

Schedular.prototype.getXHeader = function(){
	var _XHeader = '';
	_XHeader += '<tr>';
	if(this.persons.length == 1)
		_XHeader += '<th style="text-align:center;display: inline-block;" ><div style="float:left;width:80%;text-align:center;" id="'+this.persons[0].id+'">'+this.persons[0].name+'</div></th>';
	else
		for(var i=0; i<this.persons.length; i++){
			if(this.view == 'day')
				_XHeader += '<th style="text-align:center;display: inline-block;" ><div style="float:left;width:80%;text-align:center;" >'+this.persons[i].name+'</div><div style="float:right;text-decoration:underline;cursor:pointer;width:18%;text-align:center;" id="'+this.persons[i].id+'" onclick="sch.zoom(this.id)">Zoom</div></th>';
			else
				_XHeader += '<th style="text-align:center;display: inline-block;" ><div style="float:left;width:170px;text-align:center;" >'+this.persons[i].name+'</div></th>';
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
			_XScale += '<td style="height:25px !important;width:220px !important;" class="'+style+'" position="'+i+'" ondblclick="sch.addEvent(this)" hour="'+_shour+'" min="'+temp_min+'" time="'+time+'" name="'+this.persons[i].name+'" pid="'+this.persons[i].id+'" id="'+this.persons[i].id+'_'+time+'"><div /></td>';
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
	var provider = this.getProvider(id);
	providers.push(provider);
	this.setProviders(providers);
	this.init('day',"from zoom");
}

Schedular.prototype.addEvent = function(obj){
	add_appt_appt_id = '';
	nextAailObject = new Object(); /* Added by Bhaskar for reset the data from next Appointment */
	add_app_fn.loadPatientDtls('');
	$("#add_appt_form").dialog("open");
	globalObj = obj;

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
	document.getElementById("events").innerHTML = this.getEventDiv(obj, "save");
	
	
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
	//console.log(apptObject);
	var s = $('div').find("#"+apptObject).text();
	var sObject = JSON.stringify(s);
	//console.log(sObject);
	$( "#dialog-info" ).dialog({
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
				});
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
	var left = obj.offWidth * pos + 5;

	var height = ((duration/15) * 20) + ((duration/15 -1) * 7)
	var colspan = 4;
	if(act=="delete"){
		var $back = $('div').find("#"+hr+'_'+min);
		 $back.remove();
	}else{
	html += '<div class="eventpop" style="height:'+height+'px;position: absolute;top:'+top+'px;left:'+left+'px;width:170px;" id='+obj.hr+'_'+obj.min+'>';
	html += '<table class="eventtab" style="width:100%;border-collapse:collapse;padding:0px;" id="tab"  cellspacing="0" >';
	html += '<tr class=""> <td class="gen_font '+stylecls+'" style="padding-left:5px;width:20px !important;"><div class="alertbox">'+obj.appoint_status+'</div></td>';
	html += '<td class="evtpop_td_ltline '+stylecls+'" style="text-align:center;width:12px;"><input type="image" src="js_up/images/smallDownArrow.gif"/></td>';
	if(obj.is_critical == "Y"){
		html += '<td class="evtpop_td_ltline '+stylecls+'" style="width:15px !important;text-align:center;"><div class="alertbox">!</div></td>';
		colspan++;
	}
	var j = obj.hr+'_'+obj.min;
	html += "<td class=\"evtpop_td_ltline\" style=\"color:#C35817;cursor:pointer;\" apptid=\""+obj.appt_id+"\" onclick='sch.editAppt(\""+j+"\")'>"+obj.patient_name+"</td>";
	if(obj.go_to != null){
		html += '<td class="evtpop_td_ltline '+stylecls+'" style="width:15px !important;text-align:center;" id="'+obj.id+'_echart">'+obj.go_to+'</td>';
		colspan++;
	}
	html += '<td class=" evtpop_td_ltline '+stylecls+'" style="width:15px !important;text-align:center;"><input type="image" src="js_up/images/smallDownArrow.gif"/></td>';
	html += '</tr>';
	if(duration > 15){
		html += "<tr>";
		html += "<td colspan='"+colspan+"' class='gen_font2'><span class='gen_font3'>Reason:</span> "+this.formatText(obj.reason, 40)+"</td>";
		html += "</tr>";
	}
	if(duration > 30){
		html += "<tr>";
		html += "<td colspan='"+colspan+"' class='gen_font2'><span class='gen_font3'>Notes:</span> "+this.formatText(obj.notes, 40)+"</td>";
		html += "</tr>";
	}
	html += '</table>';
	html += '</div>';
	
	}
	return document.getElementById("events").innerHTML + html;
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
		var objId = docId + "_" + event.hr+":"+event.min;
		event.offHeight = document.getElementById(objId).offsetHeight;
		event.offWidth = document.getElementById(objId).offsetWidth;
		
		document.getElementById("events").innerHTML = this.getEventDiv(event,"first");

	}
	}
	/*lert(obj.hr);
	alert(obj.min);
	alert(obj.pos);
	alert(obj.duration);
	alert(obj.offHeight);
	alert(obj.offWidth);*/

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
		  var result = params.data;
		  var variables = params.vars;
		  var toDat = document.getElementById("inputField").value;
		  Schedular.config.eventsList=[];
		  Schedular.config.providersList=[];
		  if(isEmpty(params.vars)){
		 $.each(result, function(i, obj){
		   if(i==toDat){
			  Schedular.config.eventsList = obj.eventsDB;
			  Schedular.config.providersList = obj.providersDB;
			  return false;
			}
		  });
		  }else{
		  //Schedular.config.eventsList=[];
		  //Schedular.config.providersList=[];
		  $.each(result, function(j, obj){
		   if(j == params.vars.doc_dt){
			  Schedular.config.eventsList = obj.eventsDB;
			  Schedular.config.providersList = obj.providersDB;
			  return false;
			}
		  });
		  }
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
			

