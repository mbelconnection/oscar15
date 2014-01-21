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
	if(param == "inc"){
		myday.setDate(myday.getDate()+parseFloat(1));
	}else if(param == "dec"){
		myday.setDate(myday.getDate()-parseFloat(1));
	}


	var day = myday.getDate();        
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
document.getElementById("inputField").value = changeDate
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
	//var header = '<table class="sch_header" style=""><tr><td style="width:150px;">'+getLeftCtrl(date_today)+'</td><td>'+getMidCtrl()+'</td></tr></table>';
	//document.getElementById('header').innerHTML = header;
	calendar += '<table class="cal_calendar" onload="opacity(document.getElementById(\'cal_body\'),20);"><tbody id="cal_body">';        
	calendar += '<tr class="cal_d_weeks"><th>Sunday</th><th>Monday</th><th>Tuesday</th><th>Wednesday</th><th>Thursday</th><th>Friday</th><th>Saturday</th></tr><tr>';        
	week = 0;  
	var prev_mon = month - 1;
	if(prev_mon < 0)
		prev_mon = 11;
	for(i=1;i<=beg_j;i++)        {                
		calendar += '<td class="">'+createDateTab((days_in_month[prev_mon]-beg_j+i), 'cal_days_bef_aft')+'</td>';                
		week++;        
	}        
	for(i=1;i<=total;i++)        {                
		if(week==0)                {                        
			calendar += '<tr>';                
		}                
		if(day==i)                {                        
			calendar += '<td class="cal_today"><span style="text-align:right;vertical-align: top;">'+createDateTab(i, 'cal_inner_td1', 'background-color: #fff3a1 !important;')+'</span></td>';                
		}                
		else                {                        
			calendar += '<td><span style="vertical-align: top;">'+createDateTab(i,'cal_inner_td1')+'</span></td>';                
		}                
		week++;                
		if(week==7)                {                        
			calendar += '</tr>';                        
			week=0;                
		}        
	}        
	for(i=1;week!=0;i++)        {                
		calendar += '<td class="cal_days_bef_aft">'+createDateTab(i, 'cal_days_bef_aft')+'</td>';                
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

function createDateTab(date, cls, style){
	var html = "<table width='99%' ><tr><td class='"+cls+"' style='"+style+"'>"+date+"</td></tr>";	
	html += "<tr><td class='cal_inner_td2' style='"+style+"'>Oscardoc, Dr. P:Normal</td></tr></table>";
	return html;
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
	htmldata += '<td style="text-align:center;width:100px;"><input type="button" value="persons" onclick="sch.init(\'day\');"></td>'
	htmldata += '<td style="text-align:center;width:100px;"><input type="button" value="Month" onclick="sch.setView(\'month\')"></td>'
	htmldata += '<td style="text-align:center;width:100px;"><input type="button" value="Week" onclick="sch.init(\'week\')"></td>'
	htmldata += '</tr></table>';
	return htmldata;
}