function setStyle(id,style,value){    
	id.style[style] = value;
}

function opacity(el,opacity){        
	setStyle(el,"filter:","alpha(opacity="+opacity+")");        
	setStyle(el,"-moz-opacity",opacity/100);        
	setStyle(el,"-khtml-opacity",opacity/100);        
	setStyle(el,"opacity",opacity/100);
}
var _cur_mon;
/* Calendar display start */
function dateChange(param){
	if(globalView.view == "month"){		
		setMonthDates(param);
		return;
	}
	if(globalView.view == "flip"){
		setFlipDates(param);
		return;
	}
	
	if(globalView.view == "week"){
		setWeekDates(param);
		return;
	}
var currDay = document.getElementById("inputField").value;

var currDayArr = currDay.split("-");

var month;

	if(currDayArr[1] == "Jan" || currDayArr[1] == "JAN"){
		month = 0;
	}else if(currDayArr[1] == "Feb" || currDayArr[1] == "FEB"){
		month = 1;
	}else if(currDayArr[1] == "Mar" || currDayArr[1] == "MAR"){
		month=2;
	}else if(currDayArr[1] == "Apr" || currDayArr[1] == "APR"){
		month=3;
	}else if(currDayArr[1] == "May" || currDayArr[1] == "MAY"){
		month=4;
	}else if(currDayArr[1] == "Jun" || currDayArr[1] == "JUN"){
		month=5;
	}else if(currDayArr[1] == "Jul" || currDayArr[1] == "JUL"){
		month=6;
	}else if(currDayArr[1] == "Aug" || currDayArr[1] == "AUG"){
		month=7;
	}else if(currDayArr[1] == "Sep" || currDayArr[1] == "SEP"){
		month=8;
	}else if(currDayArr[1] == "Oct" || currDayArr[1] == "OCT"){
		month=9;
	}else if(currDayArr[1] == "Nov" || currDayArr[1] == "NOV"){
		month=10;
	}else if(currDayArr[1] == "Dec" || currDayArr[1] == "DEC"){
		month=11;
	}

	var myday = new Date(parseFloat(currDayArr[2]),parseFloat(month),parseFloat(currDayArr[0]));
	if(globalView.view == undefined){
	globalView.view ="day";
	}
	if(param == "inc"){
		myday.setDate(myday.getDate()+parseFloat(1));
	}else if(param == "dec"){
		myday.setDate(myday.getDate()-parseFloat(1));
	}

	/*Modified by Bhaskar for date differences between calender and system dates */
	var day = "";
	if(myday.getDate()<10)
	day = "0"+myday.getDate();
	else
	day = myday.getDate();
	/* ends here */
	var month = myday.getMonth();        
	var year = myday.getYear();        
	if(year<=200)        {                
		year += 1900;        
	}        

	months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'); 
	days_in_month = new Array(31,28,31,30,31,30,31,31,30,31,30,31);        
	if(year%4 == 0 && year!=1900)        {                
		days_in_month[1]=29;        
	}        
	total = days_in_month[month];        
	var changeDate = day+"-"+months[month]+"-"+year;
	document.getElementById("inputField").value = changeDate;
	globalDayViewDate = $("#inputField").val();
	//sch.load(document.getElementById("inputField").value);
	 var val1 =  $("#docava").val().split("_");
	sch.dayLoad(document.getElementById("inputField").value,val1[0]);
}

function setWeekDates(param){
	var output = "";
	var months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
	if(param == ""){
		var currDay = document.getElementById("inputField").value;
		var currDayArr = currDay.split("-");
		if(currDayArr.length != 3){
			currDay = globalDayViewDate;
			currDayArr = currDay.split("-");
		}
		//console.log(currDayArr);
		var current = new Date(parseFloat(currDayArr[2]), parseFloat(getMonthIndex(currDay)), parseFloat(currDayArr[0]));
		
		if(current.getDay() > 0)
			current.setDate(current.getDate() - current.getDay());
		/* Modified by Bhaskar for weekview
		* 
		* */var weekstart = current.getUTCDate();// - current.getDay() +1;    
		var weekend = weekstart + 6;       // end day is the first day + 6 
		var monday = new Date(current.setDate(weekstart));
		var sunday = new Date(current.setDate(weekend));
		
		if(parseInt(sunday.getDate()) < parseInt(monday.getDate())){
			sunday.setMonth(sunday.getMonth() + 1);
		}
				
		output =  monday.getDate() +"-"+months[monday.getMonth()] +"-"+ getHalfYear(monday)+" to ";
		output +=  sunday.getDate() +"-"+months[sunday.getMonth()] +"-"+ getHalfYear(sunday); 
		//output = current.getDate()+"-"+months[current.getMonth()]+"-"+ "20"+getHalfYear(current);
	}else{
		var tempDate = (document.getElementById("inputField").value).split("to ")[1];
		var tempDate = document.getElementById("inputField").value;
		var currDayArr = tempDate.split("-");
		
		var _date = parseFloat(currDayArr[0]) + parseFloat(1)
		var current = new Date(parseFloat(currDayArr[2]), parseFloat(getMonthIndex(tempDate)), parseFloat(currDayArr[0]) + 1);
		if(current.getDay() > 0)
			current.setDate(current.getDate() - current.getDay() + 8);
		
		/* Modified by Bhaskar for weekview
		* 
		**/var weekstart = current.getUTCDate();   
		var weekend = weekstart + 6;       // end day is the first day + 6 
		var monday = new Date(current.setDate(weekstart));
		var sunday = new Date(current.setDate(weekend));
				
		output =  monday.getDate() +"-"+months[monday.getMonth()] +"-"+ getHalfYear(monday)+" to ";
		output +=  sunday.getDate() +"-"+months[sunday.getMonth()] +"-"+ getHalfYear(sunday);
		//output = current.getDate()+"-"+months[current.getMonth()]+"-"+ current.getFullYear();
	}
	document.getElementById("inputField").value = output;
	//dt = document.getElementById("inputField").value;
	//var sq = sch.weekForCurrentDay(dt);
	var sq = sch.weekForCurrentDate(output);
	var temp = $("#docava").val()!=null?$("#docava").val():globalProviderId+"_Group";
	var sa = ""
	if(temp.split("_")[1]=="Group")
		sa = $("#weekDropId").val()!=null?$("#weekDropId").val():globalProviderId+"_Group";
		else
			sa = temp;
			
	var sw = sa.split("_");
	sch.weekLoad(sq,sw[0]);
}

function setMonthDates(param)
{
	var output = "";
	var months = new Array('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
	
	if(param == ""){
		var currDay = document.getElementById("inputField").value;
		var currDayArr = currDay.split("-");
		if(currDayArr.length != 3){
			currDay = globalDayViewDate;
			currDayArr = currDay.split("-");
		}
		var date = new Date(parseFloat(currDayArr[2]), parseFloat(getMonthIndex(currDay)), parseFloat(1));
		output = months[date.getMonth()]+" "+date.getFullYear();
	}
	else{
		var _selectedDateOpts = (document.getElementById("inputField").value).split(" ");
		var selectedMonth = _selectedDateOpts[0], selectedYear = _selectedDateOpts[1];
		
		var monthIndex = getMonthIndex("-"+selectedMonth);
		var date = new Date(parseFloat(selectedYear), parseFloat(monthIndex), parseFloat(1));
		if(param == "inc")
			date.setMonth(monthIndex + 1);
		else if(param == "dec")
			date.setMonth(monthIndex - 1);
		output = months[date.getMonth()]+" "+date.getFullYear();
	}
	document.getElementById("inputField").value = output;
	calendar();
}

function setFlipDates(param){
	var output = "";
	var months = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'); 
	
	if(param == ""){
		var currDay = document.getElementById("inputField").value;
		var currDayArr = currDay.split("-");
		if(currDayArr.length != 3){
			currDay = globalDayViewDate;
			currDayArr = currDay.split("-");
		}
		var month = getMonthIndex(currDay);
		var date = new Date(parseFloat(currDayArr[2]),parseFloat(month),parseFloat(currDayArr[0]));
		
		output = date.getDate() +"-"+months[date.getMonth()] +"-"+ getHalfYear(date)+" to "+date.getDate() +"-";	
		date.setMonth(date.getMonth() + 1);
		output += months[date.getMonth()] +"-"+ getHalfYear(date);	
	}
	else{
		var tempDate = new Date();
		var _selectedDateRange = (document.getElementById("inputField").value).split("to");		
		var _selectedDateOpts = _selectedDateRange[0].split('-');
		var selectedDate = _selectedDateOpts[0], selectedMonth = _selectedDateOpts[1].trim();
		
		var monthIndex = getMonthIndex("-"+selectedMonth);
		var date = new Date(parseFloat(tempDate.getFullYear()), parseFloat(monthIndex), parseFloat(selectedDate));
		if(param == "inc")
			date.setDate(date.getDate() + 1);
		else if(param == "dec")
			date.setDate(date.getDate() - 1);
		output = date.getDate() +"-"+months[date.getMonth()] +"-"+ getHalfYear(date) +" to ";
		
		//if(param == "inc")
			date.setMonth(date.getMonth() + 1);
		//else if(param == "dec")
			//date.setMonth(date.getMonth() - 1);
		output += date.getDate() +"-" +months[date.getMonth()] +"-"+ getHalfYear(date);	
	}
	document.getElementById("inputField").value = output;
	showdata(globalProviderId);
	
}

function getHalfYear(date){
	var year = ""+date.getFullYear();
	return year.substring(2);
	
}



function todayDate(){
	
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
	document.getElementById("inputField").value = date_today;
	sch.load(document.getElementById("inputField").value);
}
/* calendar display ends*/

function calendar(){      
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
	var date_today = days[date.getDay()]+", "+day+'&nbsp;'+months[month]+'&nbsp;'+year;        
	beg_j = date;        
	beg_j.setDate(1);        
	if(beg_j.getDate()==2)        {                
		beg_j=setDate(0);        
	}        
	beg_j = beg_j.getDay();        
	//<tr><th colspan="7">'+date_today+'</th></tr>
	var calendar = '';
	var calendarscrollHeight = window.innerHeight - 156;
	//var header = '<table class="sch_header" style=""><tr><td style="width:150px;">'+getLeftCtrl(date_today)+'</td><td>'+getMidCtrl()+'</td></tr></table>';
	//document.getElementById('header').innerHTML = header;
	calendar += "<table style='overflow:scroll;height:"
		+ (calendarscrollHeight)
		+ "px;' class='cal_calendar' onload='opacity"
		+ (document.getElementById("cal_body"),20)
		+ ";'><tbody id='cal_body'>";        
	calendar += '<tr class="cal_d_weeks"><th>Sunday</th><th>Monday</th><th>Tuesday</th><th>Wednesday</th><th>Thursday</th><th>Friday</th><th>Saturday</th></tr><tr>';        
	week = 0;  
	
	var cur_mon = month;
	var cur_year = year;
	
	var next_mon = month +1;
	var next_mon_year = cur_year;
	if(next_mon > 11){
		next_mon = 0;
		next_mon_year++;
	}
	
	var prev_mon = month - 1;
	var prev_mon_year = cur_year;
	
	if(prev_mon < 0){
		prev_mon = 11;
		prev_mon_year--;
	}
	
	var viewDates = getViewStEndDates();
	//console.log(getViewStEndDates());
	getMonthData(viewDates);
	for(i=1;i<= beg_j ;i++)    {   
		var temp_date = roundNumber(days_in_month[prev_mon]-beg_j+i)+ "-" + months[prev_mon] + "-" + prev_mon_year;
		calendar += '<td class="">'+createDateTab(days_in_month[prev_mon]-beg_j+i, temp_date, 'cal_days_bef_aft')+'</td>';                
		week++;        
	}        
	for(i=1;i<=total;i++)        {
		var temp_date = roundNumber(i)+ "-" + months[cur_mon] + "-" + cur_year;
		if(week==0)                {                        
			calendar += '<tr>';                
		}                
		if(day==i)                {                        
			calendar += '<td class="cal_today"><span style="text-align:left;vertical-align: top;">'+createDateTab(i, temp_date, 'cal_inner_td1', 'background-color: #fff3a1 !important;')+'</span></td>';                
		}                
		else                {                        
			calendar += '<td><span style="vertical-align: top;">'+createDateTab(i, temp_date,'cal_inner_td1')+'</span></td>';                
		}                
		week++;                
		if(week==7)                {                        
			calendar += '</tr>';                        
			week=0;                
		}        
	}        
	for(i=1; week!=0; i++)        {   
		var temp_date = roundNumber(i)+ "-" + months[next_mon] + "-" + next_mon_year;
		calendar += '<td class="cal_days_bef_aft">'+createDateTab(i, temp_date, 'cal_days_bef_aft')+'</td>';                
		week++;                
		if(week==7)                {                        
			calendar += '</tr>';                        
			week=0;                
		}        
	}        
	calendar += '</tbody></table>';        
	document.getElementById('monthview').innerHTML = calendar;
	opacity(document.getElementById('cal_body'),70);        
	return true;
}
var globalMonthData;
function getMonthData(viewDates){
	var groupIndividual = $("#docava").val();
	var seperate = groupIndividual.split("_");
	var tempVal="";
	if(seperate[1]=="Group"){
		tempVal=seperate[0]+"~G";
	}else{
		tempVal=seperate[0]+"~I";
	}
	//console.log(tempVal);
	var pat_dtls = $.ajax({
		url : "../ws/rs/appointment/"+ viewDates[0] +"/"+ viewDates[1]+"/"+ tempVal +"/fetchMonthly",
		type : "get",
		//contentType : 'application/json',
		dataType: "json" ,
		global: false,
		async:false,
		success : function(result) {
			//alert("data retrived");
		},
		error : function(jqxhr) {
			var msg = JSON.parse(jqxhr.responseText);
			alert(msg['message']);

		}
	}).responseText;
	var jObj = JSON.parse(pat_dtls);
	globalMonthData = jObj;
	//console.log(globalMonthData);
}

function getViewStEndDates(){
	var curDate = document.getElementById("inputField").value;
	var dateOpts = curDate.split(' ');
	var date = new Date();
	date.setMonth(getMonthIndex("-"+dateOpts[0]))
	date.setYear(dateOpts[1]);
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
	var date_today = days[date.getDay()]+", "+day+'&nbsp;'+months[month]+'&nbsp;'+year;        
	
	beg_j = date;        
	beg_j.setDate(1);        
	if(beg_j.getDate()==2)        {                
		beg_j=setDate(0);        
	}        
	beg_j = beg_j.getDay();        
	week = 0;  
	
	var cur_mon = month;
	var cur_year = year;
	
	var next_mon = month +1;
	var next_mon_year = cur_year;
	if(next_mon > 11){
		next_mon = 0;
		next_mon_year++;
	}
	
	var prev_mon = month - 1;
	var prev_mon_year = cur_year;
	
	if(prev_mon < 0){
		prev_mon = 11;
		prev_mon_year--;
	}
	
	var viewStDate = "";
	var viewEndDate = "";
	var viewTempEndDate = "";
	
	for(i=1;i<= beg_j ;i++)    {   
		var temp_date = prev_mon_year + "-" + roundNumber(prev_mon +1) + "-"+ roundNumber(days_in_month[prev_mon]-beg_j+i);
		if(i == 1)
			viewStDate = temp_date;
		week++;        
	}        
	for(i=1;i<=total;i++)        {
		var temp_date = cur_year + "-" + roundNumber(cur_mon +1) + "-" + roundNumber(i);
		if(viewStDate == null || viewStDate == ""){
			viewStDate = temp_date;
		}
		if( i == total)
			viewTempEndDate = temp_date;
		                
		week++;                
		if(week==7)                {                        
			week=0;                
		}        
	}        
	for(i=1; week!=0; i++)        {   
		var temp_date = next_mon_year + "-" + roundNumber(next_mon +1) + "-" + roundNumber(i);
		week++;                
		if(week==7)                {                        
			week=0;                
			viewEndDate = temp_date;
		}        
	}   
	
	if(viewEndDate == "")
		viewEndDate = viewTempEndDate;
	
	var viewDates = [];
	viewDates[0] = viewStDate;
	viewDates[1] = viewEndDate;
	return viewDates;
}
function roundNumber(num){
	if(num < 10)
		return "0"+num;
	else
		return num;	
}

function createDateTab(calday, fulldate, cls, style){
	var html = "<table width='99%' ><tr><td class='"+cls+"' style='"+style+"'>"+calday+"</td></tr>";	
	html += "<tr><td class='cal_inner_td2' style='"+style+";font-size:14px;cursor:pointer;padding-left:8px;' onclick='showDayView(\""+fulldate+"\")'>" +getCalProviders(fulldate)+ "</td></tr></table>";
	return html;
}

function getCalProviders(fulldate){
	var dayEvents = globalMonthData[fulldate];
	if(dayEvents == null || dayEvents == undefined)
		return "";
	var _data = "";
	var count = 0;
	var moreProvs = 0;
	$.each(dayEvents, function(index, item) {
		if(count >= 5){
			moreProvs++;
		}else{
			if(_data == "")
				_data = item.name;
			else
				_data += "<br>" + item.name;
		}
		count++;
	});
	if(moreProvs > 0)
		_data += "<br>And " + moreProvs +" more..";		
	return _data;
}
function showDayView(fulldate){

	document.getElementById("inputField").value = fulldate;
	showTabData('daydiv','flipview','monthdiv','daydivid',"103")
	sch.load(fulldate);
}

function getLeftCtrl(date){
	var htmldata = '<table class="sch_left_ctrl"><tr>';
	htmldata += '<td style="text-align:center;width:100px;"><input type="image" src="images/arrow_left.PNG"/></td>'
	htmldata += '<td style="text-align:center;width:500px !important;">'+date+'</td>'
	htmldata += '<td style="text-align:center;width:100px;"><input type="image" src="images/arrow_right.PNG"/></td>'
	htmldata += '</tr></table>';
	return htmldata;
}

function getMidCtrl(){
	var htmldata = '<table class="sch_left_ctrl"><tr>';
	htmldata += '<td style="text-align:center;width:100px;"><input type="button" value="persons" onclick="sch.init(\'day\',\'from tab1\');"></td>'
	htmldata += '<td style="text-align:center;width:100px;"><input type="button" value="Month" onclick="sch.setView(\'month\')"></td>'
	htmldata += '<td style="text-align:center;width:100px;"><input type="button" value="Week" onclick="sch.init(\'week\',\'from tab3\')"></td>'
	htmldata += '</tr></table>';
	return htmldata;
}

