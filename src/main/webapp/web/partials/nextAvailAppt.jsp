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
	$(function(){
		/*JSON data*/
		var data = [
		  { label: "anders", category: "" },
		  { label: "andreas", category: "" },
		  { label: "antal", category: "", id:"1" },
		  { label: "annhhx10", category: "Products" },
		  { label: "annk K12", category: "Products" },
		  { label: "annttop C13", category: "Products" },
		  { label: "anders andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "anders andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "anders andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "anders andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "anders andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "anders andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "anders andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "anders andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "andreas andersson", category: "People" },
		  { label: "andreas johnson", category: "People" }
		];
		
		var days = {"0":"Sunday", "1":"Monday", "2":"Tuesday", "3":"Wednesday", "4":"Thursday", "5":"Friday", "6":"Saturday"};
		
		var naa_json_appType = {"echart":"E-Chart", "intake":"Intake form", "billing":"Billing", "rx":"RX"};
		
		var searchData= [
			{"date":"01-Feb-2014", "time":"11:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"10-Mar-2014", "time":"15:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"09-Mar-2014", "time":"12:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"31-Jan-2014", "time":"17:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]}
		];
		
		var naa_json_docs = [
		  { label: "Dr. Oscardoc", category: "", id:"1" },
		  { label: "Dr. Doe", category: "", id:"2"  },
		  { label: "Dr. Hilts", category: "", id:"3"  },
		  { label: "Dr. Yarwick", category: "", id:"4"  },
		  { label: "Dr. Michelle Dietician", category: "", id:"5"  },
		  { label: "Dr. Alison Smith", category: "", id:"6"  },
		  { label: "Dr. Rand Paul", category: "", id:"7"  }
		];
		
		var naa_json_time = {"8_00":"08:00", "8_15":"08:15", "8_30":"08:30", "8_45":"08:45", "9_00":"09:00", "9_15":"09:15", "9_30":"09:30", "9_45":"09:45", "10_00":"10:00", "10_15":"10:15", "10_30":"10:30", "10_45":"10:45", "11_00":"11:00", "11_15":"11:15", "11_30":"11:30", "11_45":"11:45", "12_00":"12:00", "12_15":"12:15", "12_30":"12:30", "12_45":"12:45", "13_00":"13:00", "13_15":"13:15", "13_30":"13:30", "13_45":"13:45", "14_00":"14:00", "14_15":"14:15", "14_30":"14:30", "14_45":"14:45", "15_00":"15:00", "15_15":"15:15", "15_30":"15:30", "15_45":"15:45", "16_00":"16:00", "16_15":"16:15", "16_30":"16:30", "16_45":"16:45", "17_00":"17:00", "17_15":"17:15", "17_30":"17:30", "17_45":"17:45", "18_00":"18:00", "18_15":"18:15", "18_30":"18:30", "18_45":"18:45", "19_00":"19:00", "19_15":"19:15", "19_30":"19:30", "19_45":"19:45", "20_00":"20:00", "20_15":"20:15", "20_30":"20:30", "20_45":"20:45", "21_00":"21:00", "21_15":"21:15", "21_30":"21:30", "21_45":"21:45", "22_00":"22:00", "22_15":"22:15", "22_30":"22:30", "22_45":"22:45"};
		var naa_prov_id = "";
		var naa_prov_type = "";
		var naa_providers_list;
		
		/*JSON data end*/
		
		naa_json_fn = {
			getDays: function(){
				return days;
			},
			getSearchData: function(){
				 var resultData;
				var formData = {};			
				formData['prov_type'] = naa_prov_type;
				formData['provId'] = naa_prov_id;
				formData['apptType'] = $('#naa_appt_format').val();
				formData['apptDuration'] = $('#naa_dura_format').val();
				formData['dayOfWeek'] = $('#dayOfWeek').val();
				formData['startTime'] = $('#naa_time_of_day').val().replace(/_/g,":");
				formData['endTime'] = $('#naa_time_of_day1').val().replace(/_/g,":");
				formData['resultCount'] = $('#results').val();
				//console.log(formData);
				var apptData = JSON.stringify(formData);
				$.ajax({
					url : "../ws/rs/demographics/nextAvaAppt",
					type : "post",
					data : apptData,
					async: false,
					contentType : 'application/json',
					success : function(result) {
						resultData = result;
					},
					error : function(jqxhr) {
						var msg = JSON.parse(jqxhr.responseText);
						alert(msg['message']);

					}
				});
				return resultData;
				/*return searchData;*/
			},
			getDocsData: function(){
				return naa_json_docs;
			},getAttptStatus: function(){
				return naa_json_appType;
			},getTimeSlot: function(){
				return naa_json_time;
			},
			loadProviders : function() {
				var pat_dtls = $.ajax({
					url : "../ws/rs/providerService/aaa/list",
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
				var jObj = JSON.parse(pat_dtls);
				naa_providers_list = jObj.providers;
			},
		};
		
		/*General functions*/
		naa_fn = {
			 validateForm: function() {
				return true;
			 },
			 setValNote: function(msg){
				$(".naa_valNote").html("* "+msg);
			 },
			 
			 loadDayOfWeek: function(){
				var _days = naa_json_fn.getDays();
				$.each(_days, function(key, val){
					$("#dayOfWeek").append(new Option(val, key));
				});
			 },			 
			 loadTimeSlot: function(){
				var _data = naa_json_fn.getTimeSlot();
				$.each(_data, function(key, val){
					$("#naa_time_of_day").append(new Option(val, key));
					$("#naa_time_of_day1").append(new Option(val, key));
				});				
			 },	
			 loadApptType : function() {
					$.ajax({
						url : "../ws/rs/patient/type/list/1",
						type : "get",
						contentType : 'application/json',
						success : function(result) {
							$("#naa_appt_format" ).empty();
							$("#naa_appt_format").append(new Option("Any", ""));
							//add_app_fn.loadOptsType(result.appointmentTypes, "naa_appt_format");
							$.each(result.appointmentTypes, function(key, val) {
								$("#naa_appt_format" ).append(new Option(val.name, val.id));
							});
							
						},
						error : function(jqxhr) {
							var msg = JSON.parse(jqxhr.responseText);
							alert(msg['message']);
							$("#result").html('There is error while submit');
						}
					});
				},
			 
			
			 /*loadApptType: function(){
				var _days = naa_json_fn.getAttptStatus();
				$.each(_days, function(key, val){
					$("#naa_appt_format").append(new Option(val, key));
				});
			 },*/
			 
			 search: function(){
				var _data = naa_json_fn.getSearchData();
				$("#naa_users tr:gt(0)").remove();
				$.each(_data, function(i,val){
						if(i>($('#results').val() - 1))
							return false;
						var me = this;
						var myObject = JSON.stringify(me);
						$("#naa_users tbody").append("<tr>" +
                                "<td>" + me.appointmentDate+ "</td>" +
                                "<td>" + me.startTime + "</td>" +
                                //"<td>" + naa_fn.appendProviders(me.name) + "</td>" +
                                "<td>" +me.name + "</td>" +
								"<td> <div class='naa_roundbox' style='cursor:pointer;' onclick='naa_fn.gotoAddAppointment("+myObject+")'> Schedule appt.</div> </td>" +
                                //"<td> <div class='naa_roundbox' style='cursor:pointer;' onclick='sch.editAppt(\""+nextAvailId+"\",\"\")'> Schedule appt.</div> </td>" +
								"</tr>");
					
				});
			 },
			 
			 appendProviders: function(providerData){
				var _docs = "";
				$.each(providerData, function(){
					if(_docs == "")
						_docs = this.docName;
					else
						_docs += "; "+this.docName;
				});
				return _docs;
			 },
			 gotoAddAppointment: function(myObject){
			 nextAailObject = myObject;
			 globalObj.id = myObject.id+"_"+myObject.startTime;
			 console.log(nextAailObject);
			 //var validDate = sch.valid_date(myObject.date);
			 //1490:08_30
			 var sx = myObject.startTime.split(":");
				$("#next_app_form").dialog("close");
				$("#add_appt_form").dialog("open")
				//setTimeout(' ',1000); /* Added by Schedular Team */
			 //if(validDate){
				 /* $("#dialog-edit").dialog({
					autoOpen : false,
					resizable : true,
					minHeight : 150,
					height : 150,
					width : 300,
					modal : true,
					title: 'Edit Appointment'
				});
			 $("#dialog-edit").dialog("open");
			$(".ui-dialog-titlebar").show();
			$(".ui-dialog-titlebar-close").hide();
			
			$("#sch_info_but_edit1").on("click", function() {
				$("#dialog-edit").dialog("close");
				$("#add_appt_form").dialog("open");
				
			});
			
			$("#sch_info_but_cancel1").on("click", function() {
				$("#dialog-edit").dialog("close");
			}); */
			 }
		}
		naa_fn.loadDayOfWeek();
		naa_fn.loadApptType();
		naa_fn.loadTimeSlot();
		
		/* General functions end*/ 

		/*Element event bindings*/
		$("#create-user").button().click(function () {
				sch.clearForm("#next_app_form");
				$("#next_app_form").dialog("open");
         }); 

		 $("#naa_cancel").button().click(function () {
			$('#naa_form')[0].reset();			
			sch.clearForm("#next_app_form");
			$("#next_app_form").dialog("close");
            return false;
         });
		
		 $("#naa_search").button().click(function () {
			$("#naa_search").text("Search Again");
			$("#naa_search").attr("style","font-size:12px !important;font-family:verdana, sans-serif; padding: 3px 8px 5px 8px;");
			var formData = {};			
			formData['prov_type'] = naa_prov_type;
			formData['id'] = naa_prov_id;
			formData['appt_type'] = $('#naa_appt_format').val();
			formData['appt_dur'] = $('#naa_dura_format').val();
			formData['day'] = $('#dayOfWeek').val();
			formData['time'] = $('#naa_time_of_day').val();
			formData['no_results'] = $('#results').val();
			//console.log(formData);
			naa_fn.search();
            return false;
         });

		 $(":radio.na_pro").on("click",function(){
			if($(this).val() == "multi"){
				$("#naa_s_provider").attr("disabled",true);
				$("#naa_m_provider").attr("disabled",false);
				$("#naa_s_provider").val("");
			}else{
				$("#naa_m_provider").attr("disabled",true);
				$("#naa_s_provider").attr("disabled",false);
				$("#naa_m_provider").val("");
			}

		 });

		 $(":radio.na_format").on("click",function(){
			if($(this).val() == "appt"){
				$("#naa_appt_format").attr("disabled",false);
				$("#naa_dura_format").attr("disabled",true);
				$("#naa_dura_format").val("");
			}else{
				$("#naa_dura_format").attr("disabled",false);
				$("#naa_appt_format").attr("disabled",true);
				$("#naa_appt_format").val("");
			}
		 });

		/*Element event bindings end*/
	
		 /* $("#users tbody").append("<tr>" +
                                "<td>" + name.val() + "</td>" +
                                "<td>" + email.val() + "</td>" +
                                "<td>" + password.val() + "</td>" +
                                "</tr>");
                            $(this).dialog("close");*/
		/* Dialog init*/
		 $("#next_app_form").dialog({
                autoOpen: false,
                height: 550,
                width: 620,
                modal: true,
				open:function(){
					$('#naa_provider_0').prop('checked', true);
					$('#naa_format_0').prop('checked', true);
					$('#naa_search').focus();
				}
                
            });

		$(".ui-dialog-titlebar").hide();
		//Open dailog
		//$("#next_app_form").dialog("open");
		
		//auto complete widget init	
		$.widget( "custom.mycatcomplete", $.ui.autocomplete, {
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

		//configure auto complete functionality to elements
		/*$( "#naa_s_provider" ).catcomplete({
			  delay: 0,
			  source: data,
			  select: function( event, ui ) {
				alert(ui.item.id);
			  }
		});

		$( "#naa_m_provider" ).catcomplete({
			  delay: 0,
			  source: data,
			  select: function( event, ui ) {
				alert(ui.item.id);
			  }
		});*/
		
		/*bind provider name*/
		$( "#naa_s_provider" ).catcomplete({
					minLength: 0,
					source: function( request, response ) {
						// delegate back to autocomplete, but extract the last term
						if(naa_providers_list == null)
							naa_json_fn.loadProviders();
						//response( add_appt_providers_list );	
						var term = request.term;
						var matches = $.grep(naa_providers_list, function(item, index) {
							var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex(term), "i");
							return matcher.test(item.label);
						});
						response(matches);
					  },
					focus: function( event, ui ) {
						//$( "#add_appt_pat_name" ).val( ui.item.label );
						return false;
					},
					select: function( event, ui ) {	
						naa_prov_type = "S";
						naa_prov_id  = ui.item.id;
					}
				});
		
		/*$( "#naa_s_provider" )
		.mycatcomplete({
		  delay: 0,
		  minLength : 3,
		  source: function( request, response ) {
			// delegate back to autocomplete, but extract the last term
			var data = naa_json_fn.getDocsData();			
			response( data );			
		  },		  
		  select: function( event, ui ) {
			naa_prov_type = "S";
			naa_prov_id  = ui.item.id;
		  },    
		  _search: function(event, ui) {
			return false;
		  }

		});*/
		
		
		$( "#naa_m_provider" )
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
				if(naa_providers_list == null)
					naa_json_fn.loadProviders();
				//response( add_appt_providers_list );	
				var term = request.term;
				term = term.split(';');
				term = term[term.length -1].trim();
				//console.log(term[term.length -1]);
				var matches = $.grep(naa_providers_list, function(item, index) {
					var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex(term), "i");
					return matcher.test(item.label);
				});
				response(matches);
			},
			focus: function() {
			// prevent value inserted on focus
			return false;
			},
			select: function( event, ui ) {
				//console.log(ui.item.id);
				var terms = split( this.value );
				// remove the current input
				//terms.pop();
				// add the selected item
				//terms.push( ui.item.value );
				// add placeholder to get the comma-and-space at the end
				//terms.push( "" );
				//this.value = terms.join( "; " );
				
				terms.push( ui.item.value );
				// add placeholder to get the comma-and-space at the end
				terms.push( "" );
				var input = removeLastInput(this.value);
				
				if(input != "")
					this.value = input + "; " + ui.item.value +"; ";
				else
					this.value = ui.item.value +"; ";
				
				naa_prov_type = "M";
				//add_appt_fld_prv_id += ui.item.id+",";
				naa_prov_id += ui.item.id+",";
				//console.log(add_appt_fld_prv_id);
				return false;
			}
		});
			
		function split( val ) {
			return val.split( /,\s*/ );
		}
		function extractLast( term ) {
			return split( term ).pop();
		}  		
		
			
	});//end of document ready function


	


  


</script>
<style>
	
	.na_form{
		font-family:Verdana,Arial,sans-serif;
		font-size:0.6em;
	}

	
        .na_form_inputtext {
            margin-bottom: 2px;
            width: 150px;
            padding: .3em;
			border-bottom-right-radius: 4px;
			border-bottom-left-radius: 4px;
			border-top-right-radius: 4px;
			border-top-left-radius: 4px;
			border:1px solid #AAAAAA;
        }

		.na_form_select {
            margin-bottom: 2px;
            width: 158px;
			height:22px;
			margin-left:0.05em;
			border-bottom-right-radius: 4px;
			border-bottom-left-radius: 4px;
			border-top-right-radius: 4px;
			border-top-left-radius: 4px;
			border:1px solid #AAAAAA;
        }

		.na_form_fieldset {           
			border-bottom-right-radius: 4px;
			border-bottom-left-radius: 4px;
			border-top-right-radius: 4px;
			border-top-left-radius: 4px;
			border:1px solid #AAAAAA;
			min-height:150px;
        }
		
		.appt_round {           
			border-bottom-right-radius: 4px;border-bottom-left-radius: 4px;border-top-right-radius: 4px;border-top-left-radius: 4px;border:1px solid #AAAAAA;
        }


		.na_table{
			border:1;
			border-collapse:collapse;
			cellPadding:0px;
			cellSpacing:0px;
		}

		div#naa_users-contain {
            width: 550px;
            margin: 50px;
			text-align:center;
        }
        div#naa_users-contain table {
            margin-left: 10px;
			margin-top: 5px;
            border-collapse: collapse;
            width: 100%;
        }
        div#naa_users-contain table td,
        div#naa_users-contain table th {
            border: 1px solid #eee;
            padding: .3em 10px;
            text-align: left;
        }

		.ui-button-text {
			display: block;
			line-height: normal;
			font-family:Verdana,Arial,sans-serif;
			font-size:0.8em;
		}

		.naa_mainheading12{
			margin-left:10px;padding:5px;font-size:14px;font-weight:300;color:#000000;
		}

		.naa_subheading{
			padding-bottom:5px;
			font-size:11px;
			color:#CD853F;
		}

		.naa_valNote{
			color:red;
			width:60%;
		}
		
		.naa_roundbox{
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
		
		.na_form_button{
			font-family:Verdana,Arial,sans-serif;font-size:18px !important;
			padding-left:3px;
			padding-right:3px;
		}
		
		.ui-widget-content {
			background: url("js_up/images/ui-bg_flat_75_ffffff_40x100.png") repeat-x scroll 50% 50% #FFFFFF;
			border: 1px solid #AAAAAA;
			color: #222222;
			font-size:11px;
		}

		.ui-autocomplete {
			max-height: 250px;
			overflow-y: auto;
			/* prevent horizontal scrollbar */
			overflow-x: hidden;
		}
		
		
		.naa_button_grd{
			border:1px solid #7d99ca;-webkit-box-shadow: #ACADAD 4px 4px 4px  ;-moz-box-shadow: #ACADAD 4px 4px 4px ; box-shadow: #ACADAD 4px 4px 4px  ; -webkit-border-radius: 3px; -moz-border-radius: 3px;border-radius: 3px;font-size:12px !important;font-family:verdana, sans-serif; padding: 3px 8px 5px 8px; text-decoration:none; display:inline-block;text-shadow: -1px -1px 0 rgba(0,0,0,0.3);font-weight:bold; color: #FFFFFF;
			 background-color: #a5b8da; background-image: -webkit-gradient(linear, left top, left bottom, from(#a5b8da), to(#7089b3));
			 background-image: -webkit-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: -moz-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: -ms-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: -o-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: linear-gradient(to bottom, #a5b8da, #7089b3);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#a5b8da, endColorstr=#7089b3);
			 cursor:pointer !important;
		}
		
		.sch_button_cancel{
			 border:1px solid #C7C5C5;-webkit-box-shadow: #C7C5C5 4px 4px 4px  ;-moz-box-shadow: #C7C5C5 4px 4px 4px ; box-shadow: #C7C5C5 4px 4px 4px  ; -webkit-border-radius: 3px; -moz-border-radius: 3px;border-radius: 3px;font-size:12px !important;font-family:verdana, sans-serif; padding: 5px 8px 5px 8px; text-decoration:none; display:inline-block;text-shadow: -1px -1px 0 rgba(0,0,0,0.3); color: #000000;
			 background-color: #C7C5C5; background-image: -webkit-gradient(linear, left top, left bottom, from(#C7C5C5), to(#C7C5C5));
			 background-image: -webkit-linear-gradient(top, #C7C5C5, #C7C5C5);
			 background-image: -moz-linear-gradient(top, #C7C5C5, #C7C5C5);
			 background-image: -ms-linear-gradient(top, #C7C5C5, #C7C5C5);
			 background-image: -o-linear-gradient(top, #C7C5C5, #C7C5C5);
			 background-image: linear-gradient(to bottom, #C7C5C5, #C7C5C5);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#C7C5C5, endColorstr=#7089b3);
		}

		.naa_button_grd:hover{
			 border:1px solid #5d7fbc;
			 background-color: #819bcb; background-image: -webkit-gradient(linear, left top, left bottom, from(#819bcb), to(#536f9d));
			 background-image: -webkit-linear-gradient(top, #819bcb, #536f9d);
			 background-image: -moz-linear-gradient(top, #819bcb, #536f9d);
			 background-image: -ms-linear-gradient(top, #819bcb, #536f9d);
			 background-image: -o-linear-gradient(top, #819bcb, #536f9d);
			 cursor:pointer !important;
			 background-image: linear-gradient(to bottom, #819bcb, #536f9d);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#819bcb, endColorstr=#536f9d);
		}
		
		.naa_close:hover{
			 cursor:pointer !important;
		}
       
</style>

<!-- Next available appt dailog box start-->
<div id="next_app_form" title="Create new user" class="na_form" style="padding:0px;width:100%">
	<table border="0" width="100%">
		<tr>
			<td><p style='margin-left:10px;padding:5px;font-size:18px;font-weight:300;color:#000000;'>Search for next available appointment</p></td>
			<td valign="middle" align="right"><div class="naa_close" onClick='$("#next_app_form").dialog("close");'><img src="js_up/images/close_icon.png" height=20 width=20></img></div></td>
		</tr>
	</table>
	<form class="ui-dialog-buttonpane ui-widget-content ui-helper-clearfix" id="naa_form">
		<table class="na_table" width="97%" border="0" style="margin-left:10px;margin-right:10px">
			<tr>
				<td colspan="2" style="color:#808080;">APPOINTMENT DETAILS</td>
			</tr>
			<tr>
				<td width="20%">Provider(s)</td>
				<td width="80%" >
					<table>
						<tr>
							<td>
								<input type="radio" checked="checked" id="naa_provider_0" name="naa_provider" class="na_pro" value="single" style="margin-bottom: -3px;"/>&nbsp;Single provider appt.
							</td>
							<td style="padding-left:5px;">
								<input id="naa_s_provider" class="form-control na_form_inputtext" style="height:25px;" placeholder="Any"/>
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
							<td>	
								<input type="radio" name="naa_provider" class="na_pro" value="multi" style="margin-bottom: -3px;"/>&nbsp;Multi provider appt.
							</td>
							<td style="padding-left:14px;">
								<input id="naa_m_provider" class="form-control na_form_inputtext" disabled style="height:25px;" placeholder="Specify providers"/>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td height="5" colspan="2"></td>
			</tr>
			<tr>
				<td>Format</td>
				<td>
					<table>
						<tr>
							<td>
								<input type="radio" id="naa_format_0" name="naa_format" checked class="na_format" value="appt" style="margin-bottom: -3px;" checked/>&nbsp;By appt. type
							</td>
							<td style="padding-left:5px;">
								
								<select class="form-control na_form_select" id="naa_appt_format" style="padding:0px;width:150px;">
									<option value="">Any</option>
								</select>
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
							<td>
								<input type="radio" name="naa_format" class="na_format" value="duration" style="margin-bottom: -3px;"/>&nbsp;By duration
							</td>
							<td style="padding-left:16px;">								
								<select class="form-control na_form_select" disabled id="naa_dura_format" style="padding:0px;width:150px;">
									<option value="">--min</option>
									<option value="15">15 min</option>
									<option value="30">30 min</option>
									<option value="45">45 min</option>
									<option value="60">60 min</option>
									<option value="75">75 min</option>
								</select>
							</td>
						</tr>
					</table>					
				</td>
			</tr>
			<tr>
				<td height="5" colspan="2"></td>
			</tr>
			<tr>
				<td>Day of week</td>
				<td><select class="form-control na_form_select" id="dayOfWeek" style="padding:0px;">
						<option value="">Any</option>
					</select>
				</td>
			</tr>
			<tr>
				<td >Time of day</td>
				<td style="padding-top:5px;"><table><tr><td>
					<select class="form-control na_form_select" id="naa_time_of_day" style="padding:0px;width:100px;">						
					<option value="">Any</option>
					</select>
				</td><td>&nbsp;&nbsp;to&nbsp;&nbsp;	</td>
				<td>
					<select class="form-control na_form_select" id="naa_time_of_day1" style="padding:0px;width:100px;">						
					<option value="">Any</option>
					</select>
				</td></tr></table>	
				</td>
			</tr>
			<tr>
				<td># of results</td>
				<td style="padding-top:5px;"><select class="form-control na_form_select" id="results"  style="padding:0px;">
						<option>5</option>
						<option>10</option>
						<option>15</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="naa_valNote">
				</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:right;" class="na_form_button">
					<button id="naa_cancel" class="sch_button_cancel" style="background-color: #080808 !important;">Cancel</button>
					<button id="naa_search" class="naa_button_grd">Search</button>
					<button type="reset" value="Reset" style="display:none">Reset</button>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color:#808080;">APPOINTMENT SEARCH RESULTS</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:center;"> 
					<div style="overflow-y:auto;overflow-x:hidden;height:200px;">
					<fieldset style="" class="na_form_fieldset">
					<div id="naa_users-contain" class="ui-widget" style="padding:0px;margin:0px;">
						<table id="naa_users" class="ui-widget ui-widget-content">
							<thead>
								<tr class="ui-widget-header ">
									<th>Date</th>
									<th>Time</th>
									<th>Provider(s)</th>
									<th></th>
								</tr>
							</thead>
							<tbody>

							</tbody>
						</table>
						</div>
						</fieldset>
					</div>
				</td>
			</tr>
		</table>
		<!--<label for="name">Name</label>
		<input type="text" name="name" id="name" class="na_form_inputtext">
		<label for="email">Email</label>
		<input type="text" name="email" id="email" value="" class="na_form_inputtext">
		<label for="password">Password</label>
		<input type="password" name="password" id="password" value="" class="na_form_inputtext">-->
	</form>
</div>
<!--  Next available appt dailog box end -->
