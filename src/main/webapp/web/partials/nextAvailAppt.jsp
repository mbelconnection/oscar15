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
		
		var days = {"sunday":"Sunday", "monday":"Monday", "tuesday":"Tuesday", "wednesday":"Wednesday", "thursday":"Thursday", "friday":"Friday", "saturday":"Saturday"};
		
		var searchData= [
			{"date":"01-Feb-2014", "time":"11:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"31-Jan-2014", "time":"15:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"02-Feb-2014", "time":"12:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"31-Jan-2014", "time":"17:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]},
			{"date":"30-Jan-2014", "time":"14:00", "provider":[{"docName":"Dr. Oscardoc","docID":"1"},{"docName":"Dr. Yarwich","docID":"4"}]}
		];

		
		/*JSON data end*/
		
		naa_json_fn = {
			getDays: function(){
				return days;
			},
			getSearchData: function(){
				return searchData;
			}
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
			 
			 search: function(){
				var _data = naa_json_fn.getSearchData();
				$("#naa_users tr:gt(0)").remove();
				$.each(_data, function(){
						var me = this;
						var myObject = JSON.stringify(me);
						$("#naa_users tbody").append("<tr>" +
                                "<td>" + me.date+ "</td>" +
                                "<td>" + me.time + "</td>" +
                                "<td>" + naa_fn.appendProviders(me.provider) + "</td>" +
								"<td> <div class='naa_roundbox' style='cursor:pointer;' onclick='naa_fn.gotoAddAppointment("+myObject+")'> Schedule appt.</div> </td>" +
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
			 //if(myObject.date==$("#inputField").val()){
			 $( "#dialog-edit" ).dialog({
				resizable: false,
				height:120,
				buttons: {
					"Edit": function(){
						 $("#next_app_form").dialog("close");
						 $( this ).dialog( "close" );
						 sch.clearForm("#add_appt_form");
						 $("#add_appt_form").dialog("open");
						 
						},
					"Cancel": function() {
						 $( this ).dialog( "close" );
						}
					}
				});
			 }
		}
		naa_fn.loadDayOfWeek();
		/* General functions end*/ 

		/*Element event bindings*/
		$("#create-user").button().click(function () {
				sch.clearForm("#next_app_form");
				$("#next_app_form").dialog("open");
         }); 

		 $("#naa_cancel").button().click(function () {
		 
			sch.clearForm("#next_app_form");
			$("#next_app_form").dialog("close");
            return false;
         });

		 $("#naa_search").button().click(function () {
			$("#naa_search").text("Search again");
			$("#naa_search").attr("style","font-size:12px !important;font-family:verdana, sans-serif; padding: 3px 8px 5px 8px;");
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
                height: 500,
                width: 620,
                modal: true
                
            });

		$(".ui-dialog-titlebar").hide();
		//Open dailog
		//$("#next_app_form").dialog("open");
		
		//auto complete widget init	
		$.widget( "custom.catcomplete", $.ui.autocomplete, {
			_renderMenu: function( ul, items ) {
			var me = this,
			currentCategory = "";
			$.each( items, function( index, item ) {
				  if ( item.category != currentCategory ) {
					ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
					currentCategory = item.category;
				  }
				  me._renderItemData( ul, item );
			  });
			}
		  });

		//configure auto complete functionality to elements
		$( "#naa_s_provider" ).catcomplete({
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
		});
		
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

		.naa_mainheading{
			margin-left:10px;
			padding:5px;
			font-size:14px;
			font-weight:600;
			color:#6495ED;
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
			background: url("images/ui-bg_flat_75_ffffff_40x100.png") repeat-x scroll 50% 50% #FFFFFF;
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



     
       
</style>

<!-- Next available appt dailog box start-->
<div id="next_app_form" title="Create new user" class="na_form" style="padding:0px;width:100%">
	<p class="naa_mainheading">Search for next available appointment</p>
	<form class="ui-dialog-buttonpane ui-widget-content ui-helper-clearfix">
		<table class="na_table" width="97%" border="0" style="margin-left:10px;margin-right:10px">
			<tr>
				<td colspan="2" class="naa_subheading">APPOINTMENT DETAILS</td>
			</tr>
			<tr>
				<td width="20%">Provider(s)</td>
				<td width="80%" >&nbsp;<input type="radio" name="naa_provider" class="na_pro" value="single" checked style="margin-bottom: -3px;"/>&nbsp;Single provider appt.&nbsp;
				<input id="naa_s_provider" class="na_form_inputtext"/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>&nbsp;<input type="radio" name="naa_provider" class="na_pro" value="multi" style="margin-bottom: -3px;"/>&nbsp;Multi provider appt.&nbsp;&nbsp;&nbsp;&nbsp;<input id="naa_m_provider" class="na_form_inputtext" disabled/></td>
			</tr>
			<tr>
				<td height="5" colspan="2"></td>
			</tr>
			<tr>
				<td>Format</td>
				<td>&nbsp;<input type="radio" name="naa_format" class="na_format" value="appt" style="margin-bottom: -3px;" checked/>&nbsp;By appt. type&nbsp;&nbsp;&nbsp;<input id="naa_appt_format" class="na_form_inputtext"/></td>
			</tr>
			<tr>
				<td></td>
				<td>&nbsp;<input type="radio" name="naa_format" class="na_format" value="duration" style="margin-bottom: -3px;"/>&nbsp;By duration&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="naa_dura_format" class="na_form_inputtext" disabled/></td>
			</tr>
			<tr>
				<td height="5" colspan="2"></td>
			</tr>
			<tr>
				<td>Day of week</td>
				<td>&nbsp;<select class="na_form_select" id="dayOfWeek">
						<option value="">Any</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>Time of day</td>
				<td>&nbsp;<input type="text" name="name" id="name" class="na_form_inputtext"></td>
			</tr>
			<tr>
				<td># of results</td>
				<td>&nbsp;<select class="na_form_select" id="results">
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
					<button id="naa_cancel" class="naa_button_grd">Cancel</button>
					<button id="naa_search" class="naa_button_grd">Search</button>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="naa_subheading">APPOINTMENT SEARCH RESULTS</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:center;"> 
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
