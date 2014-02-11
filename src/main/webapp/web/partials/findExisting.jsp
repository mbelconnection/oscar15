<script>
	$(function(){
		/*JSON data*/
		var existing_p_data = [
		  { label: "Team A", category: "Group",id:"1" },
		  { label: "Team B", category: "Group",id:"1" },
		  { label: "Team C", category: "Group",id:"1" },
		  { label: "Team D", category: "Group",id:"1" },
		  { label: "Andrighetti, Jason", category: "Individual",id:"1" },
		  { label: "Cybela, Alfred", category: "Individual",id:"1" },
		  { label: "Dallas, Korben", category: "Individual",id:"1" },
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
			{"name":"Chan. John", "dob":"2013-Dec-9", "hin":"1234-334-345-GI", "appts":[{"date":"2014-Mar-10","time":"11:00","provider":"Dr.Oscardoc", "pid":"1"}, {"date":"2012-May-07","time":"12:00","provider":"Dr.Oscardoc", "pid":"1"}, {"date":"2012-Feb-25","time":"14:00","provider":"Dr.Oscardoc", "pid":"1"}]},
			{"name":"Chan. John", "dob":"1986-Dec-13", "hin":"1111-444-987-GX", "appts":[{"date":"2014-Mar-10","time":"11:00","provider":"Dr.Yarwick", "pid":"1"}, {"date":"2012-May-07","time":"12:00","provider":"Dr.Yarwick", "pid":"1"}, {"date":"2012-Feb-25","time":"14:00","provider":"Dr.Yarwick", "pid":"1"}]},
			{"name":"Chan. John", "dob":"1982-Oct-2", "hin":"1234-999-321", "appts":[{"date":"2014-Mar-10","time":"11:00","provider":"Dr.Oscardoc", "pid":"1"}, {"date":"2012-May-07","time":"12:00","provider":"Dr.Chow", "pid":"1"}, {"date":"2012-Feb-25","time":"14:00","provider":"Dr.Chow", "pid":"1"}]},
			{"name":"Chan. John", "dob":"1976-Mar-11", "hin":"1234-334-345-GI", "appts":[{"date":"2014-Mar-10","time":"11:00","provider":"Dr.Davidson", "pid":"1"}, {"date":"2012-May-07","time":"12:00","provider":"Dr.Davidson", "pid":"1"}, {"date":"2012-Feb-25","time":"14:00","provider":"Dr.Davidson", "pid":"1"}]}
			
		];
				
		/*JSON data end*/
		
		fex_json_fn = {
			getSearchData: function(patientName){
				return fex_sea_data;
			}
		};
		
		/*General functions*/
		fex_fn = { 
			 
			 loadSearchDtls: function(patientName){
				var _data = fex_json_fn.getSearchData(patientName);
				$("#fex_users tr:gt(0)").remove();
				var _html = "";
				$.each(_data, function(){
					var me = this;
					var findObject = JSON.stringify(me);
						_html += "<tr> <td rowspan='3'>" + this.name + "<br>" + this.dob + "<br>" + this.hin + "</td>";
						
						var len = this.appts.length;
						var clickFn = function(id){
							alert('aaa');
						}
						$.each(this.appts, function(i){
							_html += "<td>" + this.date + "</td>";
							_html += "<td>" + this.time + "</td>";
							_html += "<td>" + this.provider + "</td>";
							_html += "<td> <div class='fex_roundbox_edit' style='cursor:pointer;' onclick='fex_fn.gotoAddAppointment("+findObject+")'> Edit</div> </td>";
						
							if(i != (len-1))
								_html += "</tr><tr>";
							else
								_html += "</tr>";
						});
					
				});
				$("#fex_users tbody").append(_html);
			 },
			 gotoAddAppointment: function(findObject){
			 findAvailObject = findObject;
					console.log(findObject);
			 //if(myObject.date==$("#inputField").val()){
			 $( "#dialog-edit" ).dialog({
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
				});
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
                height: 500,
                width: 640,
                modal: true,
				buttons:{
				"send":{
				  text:'Cancel',
				  class:'sch_button_grd',
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
		$( "#fex_find_input" ).catcomplete({
			  delay: 0,
			  source: existing_p_data,
			  select: function( event, ui ) {
				//alert(ui.item.id);
				$("#fex_app_form").dialog("open");
				fex_fn.loadSearchDtls(ui.item.label);
			  }
		});
	
		
		
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
			border:1;
			border-collapse:collapse;
			cellPadding:0px;
			cellSpacing:0px;
		}

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
        div#fex_users-contain table td,
        div#fex_users-contain table th {
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

		.fex_mainheading{
			margin-left:10px;
			padding:5px;
			font-size:14px;
			font-weight:600;
			color:#6495ED;
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
		
		.sch_button_grd{
			border:1px solid #7d99ca;-webkit-box-shadow: #ACADAD 4px 4px 4px  ;-moz-box-shadow: #ACADAD 4px 4px 4px ; box-shadow: #ACADAD 4px 4px 4px  ; -webkit-border-radius: 3px; -moz-border-radius: 3px;border-radius: 3px;font-size:12px !important;font-family:verdana, sans-serif; padding: 5px 8px 5px 8px; text-decoration:none; display:inline-block;text-shadow: -1px -1px 0 rgba(0,0,0,0.3);font-weight:bold; color: #FFFFFF;
			 background-color: #a5b8da; background-image: -webkit-gradient(linear, left top, left bottom, from(#a5b8da), to(#7089b3));
			 background-image: -webkit-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: -moz-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: -ms-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: -o-linear-gradient(top, #a5b8da, #7089b3);
			 background-image: linear-gradient(to bottom, #a5b8da, #7089b3);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#a5b8da, endColorstr=#7089b3);
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
		


     
       
</style>

<!-- Next available appt dailog box start-->
<div id="fex_app_form" class="fex_form" style="padding:0px;width:100%">
	<p class="fex_mainheading">Find an existing appointment</p>
	<form class="ui-dialog-buttonpane ui-widget-content ui-helper-clearfix">	
		<table class="fex_table" width="97%" border="0" style="margin-left:10px;margin-right:10px" align="center">			
			<tr>	
				<td colspan="2" class="fex_subheading">APPOINTMENT SEARCH RESULTS</td>
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
<!--  Next available appt dailog box end -->
