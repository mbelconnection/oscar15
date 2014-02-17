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
<script>
	
	$(function() {
		/*JSON data*/
		var add_appt_json_patients = [
		  { label: "anders", category: "", id:"1" },
		  { label: "andreas", category: "", id:"2"  },
		  { label: "anders andersson", category: "", id:"3"  },
		  { label: "andreas andersson", category: "", id:"4"  },
		  { label: "andreas johnson", category: "", id:"5"  }
		];
		var add_appt_json_docs = [
		  { label: "Dr. Oscardoc", category: "", id:"1" },
		  { label: "Dr. Doe", category: "", id:"2"  },
		  { label: "Dr. Hilts", category: "", id:"3"  },
		  { label: "Dr. Yarwick", category: "", id:"4"  },
		  { label: "Dr. Michelle Dietician", category: "", id:"5"  },
		  { label: "Dr. Alison Smith", category: "", id:"6"  },
		  { label: "Dr. Rand Paul", category: "", id:"7"  }
		];
		
		var add_appt_sample_appt_data = {"patientId":"4", "patientName":"Leo", "provType":"M", "provId":"4,5", "provName":"Dr. Hilt, Dr. Oscardoc"
			, "date":"16-Feb-2014", "time":"10", "duration":"30", "isrecurrence":"Y", "recurrence_date":"28-Jan-2014", "appttype":"billing"
			, "apptstatus":"DP", "isCritical":"Y", "apptresources":"Room 3", "apptreason":"BT", "apptreasondtls":"Physical Examination"
			, "apptnotes":"Noted complications since last year", "crtdby":"Eddie Collins", "crtddate":"12-Oct-2013", "lastedited":"n/a"
			, "patientinfo":{"dob":"10-Oct-1985", "sex":"F", "hin":"xxx-xxx-xxx", "address":"123 Sicamore Ave, Toronto, ON", "phone":"647-555-5595", "email":"jane.doe@gmail.com"}
			, "patapptinfo":[ {"date":"16-Apr-2011", "provider":"Thompson, Dr.", "starttime":"11:15 AM"},
								{"date":"7-May-2010", "provider":"Thompson, Dr.", "starttime":"07:45 AM"},
								{"date":"21-Jan-2010", "provider":"Thompson, Dr.", "starttime":"10:00 AM"},
								{"date":"10-Jun-2008", "provider":"Yarwick, Dr.", "starttime":"11:15 AM"}]
			};
		
		
		
		/*dropdown values*/
		var add_appt_json_appType = {"echart":"E-Chart", "intake":"Intake form", "billing":"Billing", "rx":"RX"};
		var add_appt_json_appStatus = {"TD":"TD - To do", "DP":"DP - Daysheet printed", "HR":"HR - Here", "EM":"EM - Empty room", "NS":"NS - No show", "CX":"CX - Cancelled", "NP":"NP - Ready for NP", "FT":"FT - Fast tack"};
		var add_appt_json_time = {"8_00":"08:00", "8_15":"08:15", "8_30":"08:30", "8_45":"08:45", "9_00":"09:00", "9_15":"09:15", "9_30":"09:30", "9_45":"09:45", "10_00":"10:00", "10_15":"10:15", "10_30":"10:30", "10_45":"10:45", "11_00":"11:00", "11_15":"11:15", "11_30":"11:30", "11_45":"11:45", "12_00":"12:00", "12_15":"12:15", "12_30":"12:30", "12_45":"12:45", "13_00":"13:00", "13_15":"13:15", "13_30":"13:30", "13_45":"13:45", "14_00":"14:00", "14_15":"14:15", "14_30":"14:30", "14_45":"14:45", "15_00":"15:00", "15_15":"15:15", "15_30":"15:30", "15_45":"15:45", "16_00":"16:00", "16_15":"16:15", "16_30":"16:30", "16_45":"16:45", "17_00":"17:00", "17_15":"17:15", "17_30":"17:30", "17_45":"17:45", "18_00":"18:00", "18_15":"18:15", "18_30":"18:30", "18_45":"18:45", "19_00":"19:00", "19_15":"19:15", "19_30":"19:30", "19_45":"19:45", "20_00":"20:00", "20_15":"20:15", "20_30":"20:30", "20_45":"20:45", "21_00":"21:00", "21_15":"21:15", "21_30":"21:30", "21_45":"21:45", "22_00":"22:00", "22_15":"22:15", "22_30":"22:30", "22_45":"22:45"};
		var add_appt_json_duration = {"15":"15 min", "30":"30 min", "45":"45 min", "60":"60 min"};
		var add_appt_json_reason = {"PT":"Pregnancy test","BT":"Blood test", "UT":"Urine test"};
				
		/*form values*/
		var add_appt_json_patientInfo = {"dob":"10-Oct-1985", "sex":"F", "hin":"xxx-xxx-xxx", "address":"123 Sicamore Ave, Toronto, ON", "phone":"647-555-5595", "email":"jane.doe@gmail.com"};
		var add_appt_json_patientApptInfo = [ {"date":"16-Apr-2011", "provider":"Dr. Thompson", "starttime":"11:15"},
								{"date":"7-May-2010", "provider":"Dr. Thompson", "starttime":"07:45"},
								{"date":"21-Jan-2010", "provider":"Dr. Thompson", "starttime":"10:00"},
								{"date":"10-Jun-2008", "provider":"Dr. Yarwick", "starttime":"11:15"}];
		
		var add_appt_patientFlds = {"appt_dob":"dob", "appt_sex":"sex", "appt_hin":"hin", "appt_add":"address", "appt_phone":"phone", "appt_email":"email"};
		
		var add_appt_form_flds = {"add_appt_pat_name":"patientName", "add_appt_date":"date", "add_appt_time":"time", "add_appt_duration":"duration", "add_appt_type":"appttype"
			, "add_appt_status":"appt_status", "add_appt_resources":"apptresources", "add_appt_reason":"apptreason", "add_appt_reason_dtls":"apptreasondtls"
			, "add_appt_notes":"apptnotes"};
		
		var add_appt_months = {"Jan":"0", "Feb":"1", "Mar":"2", "Apr":"3", "May":"4", "Jun":"5", "Jul":"6", "Aug":"7", "Sep":"8", "Oct":"9", "Nov":"10", "Dec":"11"};
		
		var add_appt_fld_prv_type = "";
		var add_appt_fld_prv_id = "";
		var add_appt_appt_id = "";
		var add_appt_fld_pat_id ="";
		/*JSON data end*/
		
		/*Ajax calls*/		
		add_app_ajax_fn = {
			getPatientsData: function(){
				return add_appt_json_patients;
			},getDocsData: function(){
				return add_appt_json_docs;
			},getAppType: function(){
				return add_appt_json_appType;
			},getAppStatus: function(){
				return add_appt_json_appStatus;
			},getPatientInfo: function(patientID){
				return add_appt_json_patientInfo;
			},getPatientApptInfo: function(patientID){
				return add_appt_json_patientApptInfo;
			},getTimeSlot: function(){
				return add_appt_json_time;
			},getDurationSlot: function(){
				return add_appt_json_duration;
			},getApptReason: function(){
				return add_appt_json_reason;
			},saveFormData: function(formData){
				/*Ajax call to save form data and return appointment ID*/
				return "APPT123";
			},getApptDtls: function(apptId){
				return add_appt_sample_appt_data;
			}
		};
		/*Ajax calls end*/
		
		
		var currentTab = 0;
		
		/*general function*/
		add_app_fn = {
			init: function(){
				/*init tabs*/
				$("#tabs").tabs();
				//$("#add_appt_form").dialog("open");
				$("#tabs").tabs("option", "active", 0);
				add_app_fn.loadApptType();
				add_app_fn.loadApptStatus();
				add_app_fn.loadTimeSlot();
				add_app_fn.loadDurationSlot();
				add_app_fn.loadApptReason();
				//add_app_fn.setValNote("hello");
			},
			chkDialogStatus: function(){
				if(add_appt_appt_id.length == 0){
					//add_app_fn.setApptDtls(add_appt_appt_id);
				}
			},
			setValNote: function(msg){
				$("#add_appt_valNote").show();
				$("#add_appt_valNote").html(msg);
			},
			hideValNote: function(msg){
				$("#add_appt_valNote").hide();
			},
			showTab: function(tab){
				$("#tabs").tabs("option", "active", 2);
			},
			loadOpts: function(_data, fldId){
				$.each(_data, function(key, val){
					$("#"+fldId).append(new Option(val, key));
				});
			},
			loadApptType: function(){
				var _data = add_app_ajax_fn.getAppType();
				add_app_fn.loadOpts(_data, "add_appt_type");
			},
			loadApptStatus: function(){
				var _data = add_app_ajax_fn.getAppStatus();
				add_app_fn.loadOpts(_data, "add_appt_status");
			},
			loadTimeSlot: function(){
				var _data = add_app_ajax_fn.getTimeSlot();
				add_app_fn.loadOpts(_data, "add_appt_time");
			},
			loadDurationSlot: function(){
				var _data = add_app_ajax_fn.getDurationSlot();
				add_app_fn.loadOpts(_data, "add_appt_duration");
			},
			loadApptReason: function(){
				var _data = add_app_ajax_fn.getApptReason();
				add_app_fn.loadOpts(_data, "add_appt_reason");
			},
			loadPatientDtls: function(patientID){
			var _data_pat_info = "";
			var _data_pat_appt_info = "";
			if(!isEmpty(patientID)){
				_data_pat_info = add_app_ajax_fn.getPatientInfo(patientID);
				add_app_fn.loadPatientInfo(_data_pat_info);
				_data_pat_appt_info = add_app_ajax_fn.getPatientApptInfo(patientID);
				add_app_fn.loadPatientApptInfo(_data_pat_appt_info);
				}else{
					add_app_fn.loadPatientInfo(_data_pat_appt_info);
					add_app_fn.loadPatientApptInfo(_data_pat_info);
				}
			},
			loadPatientInfo: function(_data){
			if(!isEmpty(_data)){
				$.each(add_appt_patientFlds, function(key, val){
					$("#"+key).html(_data[val]);
				});
			}else{
			$.each(add_appt_patientFlds, function(key, val){
					$("#"+key).html("");
				});
			}
			},
			loadPatientApptInfo: function(_data){
				$("#add_appt_overview tr:gt(1)").remove();
				if(!isEmpty(_data)){
				$.each(_data, function(){
					$("#add_appt_overview tbody").append("<tr>" +
							"<td>" + this.date+ "</td>" +
							"<td>" + this.provider + "</td>" +
							"<td>" + this.starttime + "</td>" +
							"</tr>");
				});
				}else{
				for(i=0;i<4;i++){
					$("#add_appt_overview tbody").append("<tr>" +
							"<td>&nbsp;&nbsp;&nbsp;</td>" +
							"<td>&nbsp;&nbsp;&nbsp;</td>" +
							"<td>&nbsp;&nbsp;&nbsp;</td>" +
							"</tr>");
				}
				}
			},
			getWeekDay: function(){
				var currDay = $("#add_appt_date").val();
				var currDayArr = currDay.split("-");
				var month = add_appt_months[currDayArr[1]];

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
			},
			showRecurrence: function(){
				var selected_date = $("#add_appt_date").val();
				if(selected_date == ""){
					add_app_fn.setValNote("Select date.");
					return false;;
				}else{
					add_app_fn.hideValNote();
				}
				if($("#add_appt_row_recur").css("display") == "none"){
					$("#add_appt_row_recur").show();
					$("#add_appt_but_recur").html("&nbsp;Remove recurrence&nbsp;");
					$("#add_appt_text_recur").html("&nbsp;Occures every "+ add_app_fn.getWeekDay() +", effective "+selected_date);
				}else{
					$("#add_appt_row_recur").hide();
					$("#add_appt_but_recur").html("&nbsp;Add recurrence&nbsp;");
				}				
			},
			validateForm: function(){	
				if($("#add_appt_pat_name").val() ==""){
					add_app_fn.setValNote("Select patient.");
					return;
				}				
				
				if($('input[name=add_appt_provider]:checked').val() == "single"){
					if($("#add_appt_s_provider").val() ==""){
						add_app_fn.setValNote("Select provider.");
						return;
					}
				}else{
					if($("#add_appt_m_provider").val() ==""){
						add_app_fn.setValNote("Select provider.");
						return;
					}
				}
				
				if($("#add_appt_date").val() ==""){
					add_app_fn.setValNote("Select date.");
					return;
				}else if($("#add_appt_time").val() ==""){
					add_app_fn.setValNote("Select time.");
					return;
				}else if($("#add_appt_duration").val() ==""){
					add_app_fn.setValNote("Select duration.");
					return;
				}
				
				add_app_fn.hideValNote();
				add_app_fn.captureFormData();
					
			},
			captureFormData: function(){
				var formData = {};
				/*Basic details
				*
				*From Next avaliable screen*/
				var s1 = nextAailObject.provider!= undefined ? nextAailObject.provider.pid_m.split(","): undefined;
				if(s1 != undefined){
				for(var i=0;i<s1.length-1;i++){
				globalObj.id=s1[i];
				formData['id'] = s1[i];
				formData['p_id'] = s1[i].split("_")[0];
				formData['patient_id'] 		= add_appt_fld_pat_id ;
				formData['patient_name']	= $("#add_appt_pat_name").val();
				formData['provider_type'] 	= add_appt_fld_prv_type;
				formData['provider_id'] 	= add_appt_fld_prv_id ;
				formData['date'] 			= $("#add_appt_date").val();
				formData['time'] 			= $("#add_appt_time").val();
				formData['duration'] 		= $("#add_appt_duration").val();
				formData['send_mail'] 		= "N";
				if($("#add_appt_sendemail").is(':checked'))
					formData['send_mail'] = "Y";
				formData['recurrence_day'] 	= add_app_fn.getWeekDay();
				formData['recurrence_date'] = $("#add_appt_date").val();
				/*More details*/
				formData['appt_type'] = $("#add_appt_type").val();
				formData['is_critical'] = "N";
				if($("#add_appt_critical").is(':checked'))
					formData['is_critical'] = "Y";
				formData['appt_status'] 	= $("#add_appt_status").val();
				formData['appt_resources'] 	= $("#add_appt_resources").val();
				formData['appt_reason'] 	= $("#add_appt_reason").val();
				formData['appt_reason_text'] = $("#add_appt_reason option:selected").text();
				formData['appt_reason_dtls'] = $("#add_appt_reason_dtls").val();
				formData['appt_notes'] 		= $("#add_appt_notes").val();
				/*save data into database*/
				var add_appt_appt_id = add_app_ajax_fn.saveFormData(formData);
				formData['appt_id'] = add_appt_appt_id;
				sch.saveEvent(globalObj,formData);
				}
				}else{
				/* From Double click */
				formData['id'] = globalObj.id;
				formData['p_id'] = globalObj.pid;
				formData['patient_id'] 		= add_appt_fld_pat_id ;
				formData['patient_name']	= $("#add_appt_pat_name").val();
				formData['provider_type'] 	= add_appt_fld_prv_type;
				formData['provider_id'] 	= add_appt_fld_prv_id ;
				formData['date'] 			= $("#add_appt_date").val();
				formData['time'] 			= $("#add_appt_time").val();
				formData['duration'] 		= $("#add_appt_duration").val();
				formData['send_mail'] 		= "N";
				if($("#add_appt_sendemail").is(':checked'))
					formData['send_mail'] = "Y";
				formData['recurrence_day'] 	= add_app_fn.getWeekDay();
				formData['recurrence_date'] = $("#add_appt_date").val();
				/*More details*/
				formData['appt_type'] = $("#add_appt_type").val();
				formData['is_critical'] = "N";
				if($("#add_appt_critical").is(':checked'))
					formData['is_critical'] = "Y";
				formData['appt_status'] 	= $("#add_appt_status").val();
				formData['appt_resources'] 	= $("#add_appt_resources").val();
				formData['appt_reason'] 	= $("#add_appt_reason").val();
				formData['appt_reason_text'] = $("#add_appt_reason option:selected").text();
				formData['appt_reason_dtls'] = $("#add_appt_reason_dtls").val();
				formData['appt_notes'] 		= $("#add_appt_notes").val();
				/*save data into database*/
				var add_appt_appt_id = add_app_ajax_fn.saveFormData(formData);
				
				formData['appt_id'] = add_appt_appt_id;
				//console.log(globalObj);
				sch.saveEvent(globalObj,formData);
				}
				$("#add_appt_form").dialog("close");
			},
			/*when edit case*/
			setApptDtls: function(apptId){
				var _data = add_app_ajax_fn.getApptDtls(apptId);
				$.each(add_appt_form_flds, function(key, val){
					$("#"+key).val(_data[val]);
				});
				
				var _data_pat_info = _data.patientinfo;
				add_app_fn.loadPatientInfo(_data_pat_info);
				
				var _data_pat_appt_info = _data.patapptinfo;
				add_app_fn.loadPatientApptInfo(_data_pat_appt_info);
			}
		};
		
		/*general functions end*/
		
		/*init dialog box*/
		$("#add_appt_form").dialog({
			autoOpen: false,
			minHeight: 475,
			width: 950,
			modal: true,
			open: function() {
				if(!isEmpty(nextAailObject)){
				sch.load(nextAailObject.date);
				//console.log(nextAailObject);
				$("#add_appt_time select").text(nextAailObject.time);
				$("select#add_appt_time option").filter(function() {
				return $(this).text() == nextAailObject.time; 
				}).prop('selected', true);
				var m_provider = "";
				var m_pid ="";
				if(nextAailObject.provider.length>1){
				$.each(nextAailObject.provider, function(key, val){
				m_provider += val.docName+",";
				m_pid +=val.docID+"_"+nextAailObject.time+",";
				//nextAailObject.provider.pid_m +=val.docID+",";
				});
				nextAailObject.provider.pid_m = m_pid;
				$("#add_appt_m_provider").val(m_provider);
				$("#add_appt_s_provider").attr("disabled",true);
				$("#add_appt_m_provider").attr("disabled",false);
				$('input:radio[name="add_appt_provider"]').filter('[value="multi"]').attr('checked', true);
				//$('input[name=add_appt_provider]').prop("checked","checked");
				}else{
				m_provider = nextAailObject.provider.docName;
				nextAailObject.provider.pid_s = val.docID;
				$("#add_appt_s_provider").val(m_provider);
				$("#add_appt_m_provider").attr("disabled",true);
				$("#add_appt_s_provider").attr("disabled",false);
				$('input:radio[name="add_appt_provider"]').filter('[value="single"]').attr('checked', true);
				}
				$("#add_appt_date").val(nextAailObject.date);
				//console.log(nextAailObject);
				}
				add_app_fn.chkDialogStatus();
			}
		});
		
		/*auto complete supporting fn*/
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
		 function split( val ) {
			return val.split( /,\s*/ );
			}
			function extractLast( term ) {
			return split( term ).pop();
			}  
		/**bind auto complete functionality*/
		/*bind patient name*/
		/*$( "#add_appt_pat_name" ).catcomplete({
		  delay: 0,
		  source: add_app_ajax_fn.getPatientsData(),
		  select: function( event, ui ) {
			//alert(ui.item.id);
			add_appt_fld_pat_id = ui.item.id;
			add_app_fn.loadPatientDtls(ui.item.id);
		  }
		});*/
		
		/*bind provider name*/
		$( "#add_appt_s_provider" )
		.catcomplete({
		  delay: 0,
		  source: add_app_ajax_fn.getDocsData(),
		  select: function( event, ui ) {		
			add_appt_fld_prv_type = "S";
			add_appt_fld_prv_id  = ui.item.id;
		  }
		});
		
		
		$( "#add_appt_m_provider" )
		.bind( "keydown", function( event ) {
			if ( event.keyCode === $.ui.keyCode.TAB &&
			$( this ).data( "ui-autocomplete" ).menu.active ) {
			event.preventDefault();
			}
		})
		 .autocomplete({
			minLength: 0,
			source: function( request, response ) {
			// delegate back to autocomplete, but extract the last term
			response( $.ui.autocomplete.filter(
			add_appt_json_docs, extractLast( request.term ) ) );
			},
			focus: function() {
			// prevent value inserted on focus
			return false;
			},
			select: function( event, ui ) {
			var terms = split( this.value );
			// remove the current input
			terms.pop();
			// add the selected item
			terms.push( ui.item.value );
			// add placeholder to get the comma-and-space at the end
			terms.push( "" );
			this.value = terms.join( ", " );
			add_appt_fld_prv_type = "M";
			add_appt_fld_prv_id += ui.item.id+",";
			//console.log(add_appt_fld_prv_id);
			return false;
			}
			})
		/*bind raiod button event*/
		$(":radio.add_appt_radio_pro").on("click",function(){
			if($(this).val() == "multi"){
				$("#add_appt_s_provider").attr("disabled",true);
				$("#add_appt_m_provider").attr("disabled",false);
				$("#add_appt_s_provider").val("");
			}else{
				$("#add_appt_m_provider").attr("disabled",true);
				$("#add_appt_s_provider").attr("disabled",false);
				$("#add_appt_m_provider").val("");
			}

		 });
		 
		 $("#appt_but_cancel").on("click",function(){
				$("#add_appt_form").dialog("close");
		 });
		 
		 $("#appt_but_save").on("click",function(){
				add_app_fn.validateForm();
		 }); 
		 
		 $("#add_appt_but_recur").on("click",function(){
				add_app_fn.showRecurrence();
		 });
		 
		 
		 
		/*bind input field to date object*/	
		new JsDatePick({
			useMode:2,
			target:"add_appt_date",
			disablePreDays:true,
			dateFormat:"%d-%M-%Y"

		});
		/*binding functions end*/
		add_app_fn.init();
		add_app_fn.loadPatientDtls('');
		
		
		
		var projects = [
			{
				id:"1",
				patName:"Doe, Jane",
				dob:"01-Oct-1987",
				hin:"1234-567-999-NN"				
			},
			{
				id:"2",
				patName:"Donaghy, Jane",
				dob:"17-Nov-1973",
				hin:"5987-783-001"				
			},
			{
				id:"3",
				patName:"Donahue, Jane",
				dob:"20-Apr-1992",
				hin:"3232-877-123-GX"				
			}
		];
		
		 $( "#add_appt_pat_name" ).autocomplete({
			minLength: 0,
			source: function(request, response) {				
				var term = request.term;
				//console.log(term);
				var matches = $.grep(projects, function(item, index) {
					var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex(term), "i");
					return matcher.test(item.patName || item.hin || item);
				});
				response(matches);
			},
			focus: function( event, ui ) {
				//$( "#add_appt_pat_name" ).val( ui.item.label );
				return false;
			},
			select: function( event, ui ) {
				$( "#add_appt_pat_name" ).val( ui.item.patName );
				$( "#add_appt_pat_name_sel_id" ).val( ui.item.id );		
				add_appt_fld_pat_id = ui.item.id;
				add_app_fn.loadPatientDtls(ui.item.id);				
				return false;
			}
		})
		.data( "ui-autocomplete" )._renderItem = function( ul, item ) {			
			return $( "<li>" )
			.append( "<a><b>" + item.patName + "</b><br>" + item.dob + "<br>" + item.hin + "</a>" )
			.appendTo( ul );
		};
		
	
		
		
	});
</script>

<head>
<title>jQuery UI Tabs - Default functionality</title>

<style>
	.ui-tabs .ui-tabs-nav li.ui-tabs-active {
		margin-bottom: -1px;
		padding-bottom: 1px;
		background-color:#FFFFFF;
	}
	.ui-tabs .ui-tabs-nav li.ui-tabs-active .ui-tabs-anchor,
	.ui-tabs .ui-tabs-nav li.ui-state-disabled .ui-tabs-anchor,
	.ui-tabs .ui-tabs-nav li.ui-tabs-loading .ui-tabs-anchor {
		cursor: text;
	}
	.ui-tabs-collapsible .ui-tabs-nav li.ui-tabs-active .ui-tabs-anchor {
		cursor: pointer;
	}

	.test{
		border: 0px!important;
	}
	.appt_tbl{
		border: 1px solid #AAAAAA;
		font-size:0.8em;
		border-collapse:collapse;
	}
	.appt_tbl td,
	.appt_tbl table th {
		border: 1px solid #AAAAAA;
		padding: .2em;
	}
	
	.appt_roundbox {           
		border-bottom-right-radius: 4px;
		border-bottom-left-radius: 4px;
		border-top-right-radius: 4px;
		border-top-left-radius: 4px;
		border:1px solid #AAAAAA;
		min-height:150px;
	}
</style>


</head>
<body>
<div id="add_appt_form" class="fex_form" style="padding:0px;width:100%">
<div id="tabs" class="test">
    <ul>
        <li><a href="#tabs-1">Add appointment</a></li>
        <li><a href="#tabs-2">Block time</a></li>        
    </ul>
	<!-- Add appointment tab -->
    <div id="tabs-1">
        <table width="100%" border="0" style="border-collapse:collapse;">
			<tr>
				<td width="55%">
					<!-- basic details -->
					<table width="100%">
						<tr>
							<td colspan="2">
								<table>
									<tr>
										<td><img src="js_up/img/1.png" style="width:30px;height:30px;"></img></td>
										<td class="naa_mainheading">BASIC DETAILS(required)
											<input type="hidden" id="add_appt_pat_name_sel_id">										
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td width="20%">Patient name</td>
							<td width="80%" >
								<table>
									<tr><td><input id="add_appt_pat_name" class="form-control na_form_inputtext" style="height:25px;"/></td>
										<td style="padding-left:10px;">New patient</td>
										</tr>
									</table>
							</td>
						</tr>
						<tr>
							<td width="20%"></td>
							<td width="80%" height="20px;"><input type="checkbox" id="add_appt_sendemail" class="add_appt_ckbox" value="" style="margin-bottom: -5px;margin-left:5px;"/>&nbsp;Send email reminder
							</td>
						</tr>
						<tr>
							<td height="5" colspan="2"></td>
						</tr>
						<tr>
							<td width="20%">Provider(s)</td>
							<td width="80%" >
								<table>
									<tr>
										<td>&nbsp;<input type="radio" name="add_appt_provider" class="add_appt_radio_pro" value="single" checked style="margin-bottom: -3px;"/>&nbsp;Single provider appt.&nbsp;&nbsp;
										</td>
										<td><input id="add_appt_s_provider" class="form-control na_form_inputtext" style="height:25px;"/>
										</td>
									</tr>
								</table>						
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<table>
									<tr>
										<td>&nbsp;<input type="radio" name="add_appt_provider" class="add_appt_radio_pro" value="multi" style="margin-bottom: -3px;"/>&nbsp;Multi provider appt.&nbsp;&nbsp;&nbsp;&nbsp;
										</td>
										<td>
											<input id="add_appt_m_provider" class="form-control na_form_inputtext" disabled  style="height:25px;"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td height="5" colspan="2"></td>
						</tr>
						<tr>
							<td width="20%">Date</td>
							<td width="80%" >
								<table>
									<tr>
										<td>&nbsp;<input id="add_appt_date" class="form-control na_form_inputtext" readonly style="width:90px;cursor:pointer;height:25px;"/></td>
										<td style="padding-top:10px;padding-left:10px;"><span id="add_appt_but_recur" class="appt_roundbox" style="padding:2px;cursor:pointer;height:25px;">&nbsp;Add recurrence&nbsp;</span></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr style="display:none" id="add_appt_row_recur">	
							<td width="20%">Recurrence</td>
							<td width="80%" >
								<span id="add_appt_text_recur" style="font-size:10px;"></span>
							</td>
						</tr>
						<tr>	
							<td height="5" colspan="2"></td>
						</tr>
						<tr>
							<td width="20%">Time</td>
							<td width="80%" >
								<table>
									<tr>
										<td><select class="form-control na_form_select" id="add_appt_time" style="width:100px;padding:0px;"/>
										</td>
										<td><span style="padding-left:5em;">Duration</span>
										</td>										
										<td style="padding-left:10px;"><select class="form-control na_form_select" id="add_appt_duration" style="width:100px;padding:0px;"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>	
							<td height="10" colspan="2"></td>
						</tr>
						<tr>
							<td colspan="2">
									<table width="98%" style="padding-top:5px;padding-bottom:5px;">
										<tr>
											<td width="45%">
												<table id="addApp_naa_users" class="appt_tbl " width="100%" style="">
													<thead>
														<tr class="ui-widget-header">
															<th colspan="2" height="18px;" style="text-align:center;">PATIENT DEMOGRAPHICS</th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<td width="65%">DOB:&nbsp;<span id="appt_dob"></span></td>
															<td width="35%">Sex:&nbsp;<span id="appt_sex"></span></td>
														</tr>
														<tr>
															<td colspan="2">HIN:&nbsp;<span id="appt_hin"></span></td>
														</tr>
														<tr>
															<td colspan="2">Address:&nbsp;<span id="appt_add"></span></td>
														</tr>
														<tr>
															<td colspan="2">Phone:&nbsp;<span id="appt_phone"></span></td>
														</tr>
														<tr>
															<td colspan="2">Email:&nbsp;<span id="appt_email"></span></td>
														</tr>
														
													</tbody>
												</table>
																					
											</td>
											<td width="55%" style='padding-left:2px;'>
												<table id="add_appt_overview" class="appt_tbl" width="100%">
													<thead>
														<tr class="ui-widget-header" height="18px;">
															<th colspan="3" style="text-align:center;">APPOINTMENTS OVERVIEW</th>
														</tr>
														<tr>
															<td>Date</td>
															<td>Provider</td>
															<td>Start time</td>
														</tr>
													</thead>
													<tbody>
														<tr>
															<td>&nbsp;</td>
															<td></td>
															<td></td>
														</tr>
														<tr>
															<td>&nbsp;</td>
															<td></td>
															<td></td>
														</tr>
														<tr>
															<td>&nbsp;</td>
															<td></td>
															<td></td>
														</tr>
														<tr>
															<td>&nbsp;</td>
															<td></td>
															<td></td>
														</tr>
													</tbody>
												</table>
											</td>
										</tr>
									</table>
							</td>
						</tr>
						<tr>
							<td colspan="2" height="10px;"></td>
						</tr>
					</table>
				</td>
				<td width="45%" style="border-left: 1px solid #AAAAAA;padding-left:5px;display: table-cell; vertical-align: top;">
					<!-- more details -->
					<table style="width:100%">
						<tr>
							<td colspan="2">
								<table>
									<tr>
										<td><img src="js_up/img/2.png" style="width:30px;height:30px;"></img></td>
										<td class="naa_mainheading">MORE DETAILS(optional)</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>Appt.type</td>
							<td>
								<table>
									<tr>
										<td>
											<select class="form-control na_form_select" id="add_appt_type" style="padding:0px;">
													<option value="">Select</option>
											</select>
										</td>
										<td>
											<span style="padding-left:15px;">Critical appt.</span>
										</td>
										<td>
											<input type="checkbox" id="add_appt_critical" class="na_pro" value="" style="margin-bottom: -5px;margin-left:5px;"/>
										</td>
									</tr>
								</table>								
							</td>
						</tr>
						<tr >
							<td style="height:35px;">Appt.status</td>
							<td>
								<select class="na_form_select form-control" id="add_appt_status" style="padding:0px;">																									
								</select>
							</td>
						</tr>
						<tr>
							<td>Location</td>
							<td>
								<table>
									<tr>
										<td>
											<input id="add_appt_location" class="form-control na_form_inputtext" style="height:25px;"/>
										</td>
										<td>
											<span style="padding-left:15px;">Resources.</span>
										</td>
										<td>
											<input id="add_appt_resources" class="form-control na_form_inputtext" style="width:60px;height:25px;"/>
										</td>
									</tr>
								</table>							
							</td>
						</tr>
						<tr>
							<td style="height:35px;">Reason</td>
							<td>
								<select class="form-control na_form_select" id="add_appt_reason" style="padding:0px;">								
										<option value="">Select</option>
									</select>
							</td>
						</tr>
						<tr>
							<td style="height:35px;">Reason details</td>
							<td>
								<textarea id="add_appt_reason_dtls" rows="3" cols="15" class="form-control na_form_inputtext"/>				
							</td>
						</tr>
						<tr>
							<td style="height:35px;">Notes</td>
							<td style="padding-top:5px;"><textarea id="add_appt_notes" rows="3" cols="15" class="form-control na_form_inputtext"/>
							</td>
						</tr>
						<tr>
							<td height="45px;"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="font-size:15px;font-weight:bold;padding:5px;background-color:#FFF0F5;display:none;" id="add_appt_valNote">
						
				</td>
			</tr>
			<tr>
				<td colspan="2" height="5px;">
				</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:right;border-top: 1px solid #AAAAAA; padding-top:10px;"> 
					<button id="appt_but_cancel" class="naa_button_grd" style="width:80px;cursor:pointer;">Cancel</button>&nbsp;&nbsp;
					<button id="appt_but_save" class="naa_button_grd" style="width:80px;cursor:pointer;">Save</button>
				</td>
			</tr>
		</table>
    </div>
	
	
	
	
	
	<!-- Block time tab -->
    <div id="tabs-2">
		<table width="100%" border="0" style="border-collapse:collapse;">
			<tr>
				<td width="55%">
					<!-- basic details -->
					<table>
						<tr>
							<td colspan="2">
								<table>
									<tr>
										<td><img src="js_up/img/1.png" style="width:30px;height:30px;"></img></td>
										<td class="naa_mainheading">BASIC DETAILS(required)</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td width="20%">Provider(s)</td>
							<td width="80%" style="padding-left:5px">
								<table >
									<tr>
										<td>
											<input type="radio" name="blk_appt_provider" class="na_pro" value="single" checked style="margin-bottom: -3px;"/>&nbsp;Single provider appt.&nbsp;
										</td>
										<td>
											<input id="naa_s_provider" class="form-control na_form_inputtext" style="height:25px;"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td></td>
							<td style="padding-left:5px">
								<table>
									<tr>
										<td>
											<input type="radio" name="blk_appt_provider" class="na_pro" value="multi" style="margin-bottom: -3px;"/>&nbsp;Multi provider appt.
										</td>
										<td style="padding-left:13px;">
											<input id="naa_m_provider" class="form-control na_form_inputtext" disabled style="height:25px;"/>
										</td>
									</tr>
								</table>
							
							</td>
						</tr>
						<tr>
							<td></td>
							<td>&nbsp;<input type="radio" name="blk_appt_provider" class="na_pro" value="multi" style="margin-bottom: -3px;"/>&nbsp;Entire team block
						</tr>
						<tr>
							<td height="5" colspan="2"></td>
						</tr>
						<tr>
							<td width="20%">Date</td>
							<td width="80%" style="padding-left:5px">
								<table>
									<tr>
										<td>
											<input id="blk_appt_date" class="form-control na_form_inputtext" style="height:25px"/>
										</td>
										<td>
											Add recurrence
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td width="20%">Time</td>
							<td width="80%" style="padding-left:5px">
								<table>
									<tr>
										<td>
											<input id="blk_appt_time" class="form-control na_form_inputtext" style="width:80px;height:25px"/>
										</td>
										<td>
											<span style="padding-left:5em;">Duration</span>
										</td>
										<td>
											<input id="blk_appt_duration" class="form-control na_form_inputtext" style="width:80px;height:25px"/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td width="20%"></td>
							<td width="80%" style="padding-left:5px">
								Ends at 1:00 PM
							</td>
						</tr>
						<tr>
							<td width="20%"></td>
							<td width="80%" style="padding-left:5px">
								<input type="checkbox" name="blk_appt_allday" class="na_pro" value="" style="margin-bottom: -5px;margin-left:5px;"/><span style="padding-left:2px;">All Day</span>
							</td>
						</tr>
						<tr>
							<td colspan="2" height="120px;"></td>
						</tr>
					</table>
				</td>
				<td width="45%" style="border-left: 1px solid #AAAAAA;padding-left:5px;">
					<!-- more details -->
					<table>
						<tr>
							<td colspan="2">
								<table>
									<tr>
										<td><img src="js_up/img/2.png" style="width:30px;height:30px;"></img></td>
										<td class="naa_mainheading">MORE DETAILS(optional)</td>
									</tr>
								</table>
							</td>
						</tr>		
						<tr>
							<td>Reason</td>
							<td>
								<input id="blk_appt_reason" class="form-control na_form_inputtext" style="height:25px"/>
							</td>
						</tr>		
						<tr>
							<td>Notes</td>
							<td>
								<textarea name="blk_appt_notes" rows="3" cols="15" class="form-control na_form_inputtext"/>
							</td>
						</tr>
						<tr>
							<td height="177px"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:right;border-top: 1px solid #AAAAAA;"> hello</td>
			</tr>
		</table>        
    </div>    
</div>
</div>
</body>
