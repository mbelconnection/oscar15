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
<!-- Used File -->
<script>
	$(function(){
		/*JSON data*/
		var existing_p_data = [
		  { label: "Andrighetti, Jason", category: "Individual",id:"1" },
		  { label: "Cybela, Alfred", category: "Individual",id:"2" },
		  { label: "Dallas, Korben", category: "Individual",id:"2" },
		  { label: "Dietician, Michelle", category: "Individual",id:"1" },
		  { label: "Doe, Dr.", category: "Individual",id:"1" },
		  { label: "Hilts, Dr.", category: "Individual",id:"1" },
		  { label: "Hwang, Dr.", category: "Individual",id:"1" },
		  { label: "Oscardoc, Dr.", category: "Individual",id:"1" },
		  { label: "Sans, Horatio", category: "Individual",id:"1" },
		  { label: "Wexford, Dr.", category: "Individual",id:"1" },
		  { label: "Yarwick, Dr.", category: "Individual",id:"1" }
		  
		];
		
		var fex_sea_data= [
			{"name":"Name: Chan. John", "dob":"DOB: 2010-Jun-25", "hin":"HIN: 1234-334-345-GI", "appts":[{"date":"2014-Mar-10","time":"11:00","provider":"Dr.Oscardoc", "pid":"1"}, {"date":"2012-May-07","time":"12:00","provider":"Dr.Oscardoc", "pid":"1"}, {"date":"2012-Feb-25","time":"14:00","provider":"Dr.Oscardoc", "pid":"1"}]},
			{"name":"Name: Chan. John", "dob":"DOB: 1986-Dec-13", "hin":"HIN: 1111-444-987-GX", "appts":[{"date":"2014-Mar-10","time":"11:00","provider":"Dr.Yarwick", "pid":"1"}, {"date":"2012-May-07","time":"12:00","provider":"Dr.Yarwick", "pid":"1"}, {"date":"2012-Feb-25","time":"14:00","provider":"Dr.Yarwick", "pid":"1"}]},
			{"name":"Name: Chan. John", "dob":"DOB: 1982-Oct-2", "hin":"HIN: 1234-999-321", "appts":[{"date":"2014-Mar-10","time":"11:00","provider":"Dr.Oscardoc", "pid":"1"}, {"date":"2012-May-07","time":"12:00","provider":"Dr.Chow", "pid":"1"}, {"date":"2012-Feb-25","time":"14:00","provider":"Dr.Chow", "pid":"1"}]},
			{"name":"Name: Chan. John", "dob":"DOB: 1976-Mar-11", "hin":"HIN: 1234-334-345-GI", "appts":[{"date":"2014-Mar-10","time":"11:00","provider":"Dr.Davidson", "pid":"1"}, {"date":"2012-May-07","time":"12:00","provider":"Dr.Davidson", "pid":"1"}, {"date":"2012-Feb-25","time":"14:00","provider":"Dr.Davidson", "pid":"1"}]}
			
		];
		var fex_pat_list;		
		/*JSON data end*/
		
		fex_json_fn = {
				getSearchData: function(demoGraphicNo){
				var fex_sea_data="";
				$.ajax({
					url : "../ws/rs/demographics/"+demoGraphicNo+"/patientTotalDetails",
					type : "get",
					dataType:'json',				
					async:false,
					success : function(result) {
						fex_sea_data = result;
					},
					error : function(jqxhr) {
						var msg = JSON.parse(jqxhr.responseText);
						alert(msg['message']);
					}
				});
				//return appt_data;
			return fex_sea_data;
			},
			loadPatients : function() {
				var pat_dtls = $.ajax({
					url : "../ws/rs/patient/patlist",
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
				fex_pat_list = jObj.demographics;
			},
				/*getSearchData: function(patientName){
					return fex_sea_data;
				}*/
		};
		
		/*General functions*/
		fex_fn = {
			 
			 loadSearchDtls: function(patientName){
				 var _data = fex_json_fn.getSearchData(patientName);
				$("#fex_users tr:gt(0)").remove();
				var _html = "";
				//$.each(_data, function(){
					var me = this;
					var findObject = JSON.stringify(_data);
						_html += "<tr border='10'> <td rowspan='5'>" + (_data['demographic']).lastName+" "+_data['demographic'].firstName + "<br>" +  _data['demographic'].dob + "<br>" +  _data['demographic'].hin + "<div class='fex_viewFullHistory_link' style='cursor:pointer;' onclick='fex_fn.viewApptFullHistory("+findObject+")'><u style='color:blue;cursor:pointer;''>View Full appt. History</u></div></td>";
						
						var len = _data['appointmentsHistory'].length;
						var clickFn = function(id){
							alert('aaa');
						}
						$.each(_data['appointmentsHistory'], function(i){
							_html += "<td>" + this['appointmentDate'] + "</td>";
							_html += "<td>" + this['startTime'] + "</td>";
							_html += "<td>" + this['name'] + "</td>";
							_html += "<td> <div class='fex_roundbox_edit' style='cursor:pointer;' onclick='fex_fn.gotoAddAppointment("+findObject+","+this['id']+")'> Edit</div> </td>";
						
							if(i != (len-1))
								_html += "</tr><tr>";
							else
								_html += "</tr>";
						});
					
				//});
				$("#fex_users tbody").append(_html);
				
			 },
			 gotoAddAppointment: function(findObject,apptId){
				findAvailObject = findObject;
				console.log(findObject);
				globalApptId = ""+parseInt(apptId);
				nextAailObject = 1;
				$( "#fex_find_input" ).val("");
				sch.showDialogs();
				
				//sch.editAppt("pat_name"+apptId,"")
				//if(myObject.date==$("#inputField").val()){
			 /* $( "#dialog-info" ).dialog({
				resizable: false,
				height:120,
				buttons: {
					"Edit": function(){
						 $("#fex_app_form").dialog("close");
						 $( this ).dialog( "close" );
						 sch.clearForm("#add_appt_form");
						 $("#add_appt_form").dialog("open");
						 
						},
					"Cancel": function() {
						 $( this ).dialog( "close" );
						}
					}
				}); */
				//$('#dialog-edit_find').modal();
			 },
			 viewApptFullHistory: function(findObject){
				 findAvailObject = findObject;
				
				var url ="http://localhost:8080/oscar/demographic/demographiccontrol.jsp?demographic_no=5&last_name="+findObject['demographic'].lastName+"&first_name="+findObject['demographic'].firstName+"&orderby=appttime&displaymode=appt_history&dboperation=appt_history&limit1=0&limit2=25"
				//console.log(url);
						//if(myObject.date==$("#inputField").val()){
				 var myWindow = window.open(url, "", "width=800, height=300, top:20");
				
				/* $( "#view-full-appt-history" ).dialog({
					resizable: false,
					height:120,
					width:520,
					buttons: {
						"Cancel": function() {
							 $( this ).dialog( "close" );
							}
						}
					});*/
				 }
			 
		}
			 
		
			
		
		/* General functions end*/ 

		/*Element event bindings*/
		 //$("#fex_find").button().click(function () {
           //    $("#fex_app_form").dialog("open");
		//	   fex_fn.loadSearchDtls();
         //});

		/*Element event bindings end*/
	
		 /* $("#users tbody").append("<tr>" +
                                "<td>" + name.val() + "</td>" +
                                "<td>" + email.val() + "</td>" +
                                "<td>" + password.val() + "</td>" +
                                "</tr>");
                            $(this).dialog("close");*/
		/* Dialog init*/
		 $("#fex_app_form").dialog({
                autoOpen: false,
                height: 520,
                width: 640,
                modal: true,
				buttons:{
				"send":{
				  text:'Cancel',
				  class:'sch_button_cancel',
				  click: function(){
						$(this).dialog("close");
				  }
				}}
            });
		$(".ui-dialog-titlebar").hide();
		//Open dailog
		//$("#fex_app_form").dialog("open");
		
	
		/* auto complete widget is already loaded in nextAvailAppt.jsp script */
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
		  
		//configure auto complete functionality to elements
		/*$( "#fex_find_input" ).autocomplete({
			  delay: 0,
			  minLength:0,
			  class:"form-control",
			  source: existing_p_data,
			  select: function( event, ui ) {
				//alert(ui.item.id);
				$("#fex_app_form").dialog("open");
				fex_fn.loadSearchDtls(ui.item.id);
			  }
		});*/
		
		$( "#fex_find_input" ).autocomplete({
			minLength: 0,
			source: function(request, response) {
				var term = request.term;
				console.log(term);
				if(fex_pat_list == null)
					fex_json_fn.loadPatients();
				var matches = $.grep(fex_pat_list, function(item, index) {
					var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex(term), "i");
					var namearr = item.label.split(',');
					//return matcher.test(item.label) || matcher.test(item.dob);
					if(namearr.length >1)
							return matcher.test(namearr[0].trim()) || matcher.test(namearr[1].trim());  
						else 
							return matcher.test(item.label);
				});
				response(matches);
			},
			focus : function(event, ui) {
				//$( "#add_appt_pat_name" ).val( ui.item.label );
				return false;
			},
			select: function(event, ui) {
				
				$("#fex_app_form").dialog("open");
				fex_fn.loadSearchDtls(ui.item.id);
				ui.item.value="";
			}
		})
		.data( "ui-autocomplete" )._renderItem = function( ul, item ) {
			return $( "<li>" )
			.append( "<a><span style='color:#848484;'>Name&nbsp;</span> " + item.label + "<br><span style='color:#848484;'>DOB&nbsp;</span>" + item.dob + "<br><span style='color:#848484;'>HIN&nbsp;</span>" + item.hin + "</a>" )
			.appendTo( ul );
		};
		/*if(fex_pat_list == null)
			fex_json_fn.loadPatients();
		var x =new Array();
		for(var i=0;i<fex_pat_list.length;i++){
			x.push(fex_pat_list[i].label);
		}
		console.log(x);*/
		//{placement: 'top', title: "<div style=\"text-align:left;\">Reason: "+reason+"</div><div style=\"text-align:left;\">Notes: "+notes+"</div>",	html: true}
		//$('#fex_find_input').typeahead({data:fex_pat_list})
		//$('#fex_find_input').betterAutocomplete('init', x, {}, {});
		/*$( "#fex_find_input" ).typeahead({
		    source: function ( query, process ) {

		        //the "process" argument is a callback, expecting an array of values (strings) to display

		        //get the data to populate the typeahead (plus some) 
		        //from your api, wherever that may be
		        $.get('../ws/rs/patient/patlist', { q: query }, function ( data ) {

		            //reset these containers
		            users = {};
		            userLabels = [];

		            //for each item returned, if the display name is already included 
		            //(e.g. multiple "John Smith" records) then add a unique value to the end
		            //so that the user can tell them apart. Using underscore.js for a functional approach.  
		            _.each( data, function( item, ix, list ){
		                if ( _.contains( users, item.label ) ){
		                    item.label = item.label + ' #' + item.value;
		                }

		                //add the label to the display array
		                userLabels.push( item.label );

		                //also store a mapping to get from label back to ID
		                users[ item.label ] = item.value;
		            });

		            //return the display array
		            process( userLabels );
		        });
		    }
		    , updater: function (item) {
		        //save the id value into the hidden field   
		        $( "#userId" ).val( users[ item ] );

		        //return the string you want to go into the textbox (e.g. name)
		        return item;
		    }
		});
		*/
		
		
	});//end of document ready function


</script>

<style>
	
	.fex_form{
		font-family:Verdana,Arial,sans-serif;
		font-size:0.6em;
	}

	
        .fex_form_inputtext {
            margin-bottom: 2px;
            width: 150px;
            padding: .3em;
			border-bottom-right-radius: 4px;
			border-bottom-left-radius: 4px;
			border-top-right-radius: 4px;
			border-top-left-radius: 4px;
			border:1px solid #AAAAAA;
        }
		
		.fex_form_autocomp {
            margin-bottom: 2px;
            width: 150px;
            padding: .3em;
			height:23px;
			border-bottom-right-radius: 4px;
			border-bottom-left-radius: 4px;
			border-top-right-radius: 4px;
			border-top-left-radius: 4px;
			border:1px solid #AAAAAA;
        }

		.fex_form_select {
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

		.fex_form_fieldset {           
			border-bottom-right-radius: 4px;
			border-bottom-left-radius: 4px;
			border-top-right-radius: 4px;
			border-top-left-radius: 4px;
			border:1px solid #AAAAAA;
			min-height:150px;
        }


		.fex_table{
			border:0;
			border-collapse:collapse;
			cellPadding:0px;
			cellSpacing:0px;			
		}
		.fex_table tr {border:1;border-top:thin solid; border-color:black; height: 24px}
		div#fex_users-contain {
            width: 550px;
            margin: 50px;
			text-align:center;
        }
        div#fex_users-contain table {
            margin-left: 10px;
			margin-top: 5px;
            border-collapse: collapse;
            width: 100%;
        }

        div#fex_users-contain table th {
            border: 0px solid #eee;
            padding: .3em 10px;
            text-align: left;
        }


        div#fex_users-contain table tr {
            border: 2px solid black;
        }
        
        div#fex_users-contain table td {
        	border: 0px;
            padding: .3em 10px;
            text-align: left;
        }
		.ui-button-text {
			display: block;
			line-height: normal;
			font-family:Verdana,Arial,sans-serif;
			font-size:0.8em;
		}

		.fex_mainheading{
			margin-left:10px;
			padding:5px;
			font-size:14px;
			font-weight:600;
			color:#0C090A;
		}

		.fex_subheading{
			padding-bottom:5px;
			font-size:11px;
			color:#CD853F;
		}

		.fex_valNote{
			color:red;
			width:60%;
		}
		
		.fex_roundbox{
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
		
		.fex_roundbox_edit{
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
		
		.fex_form_button{
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
		
		.sch_button_grd{
			border:1px solid #7d99ca;-webkit-box-shadow: #ACADAD 4px 4px 4px  ;-moz-box-shadow: #ACADAD 4px 4px 4px ; box-shadow: #ACADAD 4px 4px 4px  ; -webkit-border-radius: 3px; -moz-border-radius: 3px;border-radius: 3px;font-size:12px !important;font-family:verdana, sans-serif; padding: 5px 8px 5px 8px; text-decoration:none; display:inline-block;text-shadow: -1px -1px 0 rgba(0,0,0,0.3);font-weight:bold; color: #FFFFFF;
			 background-color: #a5b8da; background-image: -webkit-gradient(linear, left top, left bottom, from(#a5b8da), to(#7089b3));
			 background-image: -webkit-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: -moz-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: -ms-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: -o-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: linear-gradient(to bottom, #a5b8da, #7089b3);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#a5b8da, endColorstr=#7089b3);
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

		.sch_button_grd:hover{
			 border:1px solid #5d7fbc;
			 background-color: #819bcb; background-image: -webkit-gradient(linear, left top, left bottom, from(#819bcb), to(#536f9d));
			 background-image: -webkit-linear-gradient(top, #819bcb, #536f9d);
			 background-image: -moz-linear-gradient(top, #819bcb, #536f9d);
			 background-image: -ms-linear-gradient(top, #819bcb, #536f9d);
			 background-image: -o-linear-gradient(top, #819bcb, #536f9d);
			 background-image: linear-gradient(to bottom, #819bcb, #536f9d);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#819bcb, endColorstr=#536f9d);
		}
		
		.fex_viewFullHistory_link{
			width:130px;
			height:20px;
			border:0px solid #cecece;
			padding:0px;
			text-align:left;
			-moz-border-radius:0px;
			-webkit-border-radius:0px;
			border-radius:0px;
			font-family:calibri;
			font-size:12px;
		}

.fex_close:hover{
	 cursor:pointer !important;
}
     
       
</style>

<!-- Next available appt dailog box start-->
<div id="fex_app_form" class="fex_form" style="padding:0px;width:100%">
	<table border="0" width="100%">
		<tr>
			<td><p class="fex_mainheading" style='font-name:Arial;font-size:16px;color:#0C090A;'>Find an existing appointment</p></td>
			<td align="right" valign="top"><div class="fex_close" onClick='$("#fex_app_form").dialog("close");'><img src="js_up/images/close_icon.png" height=20 width=20 ></img></div></td>
		</tr>
	</table>	
	<form class="ui-dialog-buttonpane ui-widget-content ui-helper-clearfix">	
		<table class="fex_table" width="97%" border="0" style="margin-left:10px;margin-right:10px" align="center">			
			<tr>
				<td colspan="2" style='padding-left:5px;width:80px;font-size:12px;color:#C7C5C5;'><b>APPOINTMENT SEARCH RESULTS<b></b></td>
			</tr>
			<tr>	
				<td colspan="2" style="text-align:center;"> 
					<fieldset style="" class="na_form_fieldset">
					<div id="fex_users-contain" class="ui-widget" style="padding:0px;margin:0px;">
					<table id="fex_users" class="ui-widget ui-widget-content">
						<thead>
							<tr class="ui-widget-header ">
								<th>Patient details</th>
								<th>Date</th>
								<th>Time</th>
								<th>Provider</th>
								<th>View on schedule</th>
							</tr>
						</thead>
						<tbody>

						</tbody>
					</table>
					</div>
					</fieldset>
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
		<div style="padding: 0px; display: none;" title="View Full appointment Details" id="view-full-appt-history">
		<b>Add Appointment History Here...</b>
		</div>
<!--  Next available appt dailog box end -->
<script>

$("#sch_info_but_edit_find").click(function (event) {

 $('#dialog-edit_find').modal('hide');
 $("#add_appt_form").dialog("open");
});
/* $(document).on('click','#sch_info_but_edit_find', function(e) {
//console.log(">>>>>>>>>>>>>>>>>>>>.");
//$("#fex_find_input").dialog("close");
e.stopPropagation();
$('#dialog-edit_find').modal('hide');
$("#add_appt_form").dialog("open");

}); */

</script>
