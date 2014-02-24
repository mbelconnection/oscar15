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
		var data = {"show":[
			{ provName: "Dr. Oscardoc", provId:"1", role: "Doctor" },
			{ provName: "Dr. Doe", provId:"2", role: "Doctor" },
			{ provName: "Dr. Hilts", provId:"3", role: "Doctor" },
			{ provName: "Dr. Yarwick", provId:"4", role: "Doctor" },
			{ provName: "Michelle Dietician", provId:"5", role: "Doctor" },
			{ provName: "Jason Andrighetti", provId:"6", role: "Nurse" },
			{ provName: "Tobey Ziegler", provId:"7", role: "Admin" },
			{ provName: "Dr. Hwang", provId:"8", role: "Doctor" }
			
		  ],
		  "hide":[
			{ provName: "Horatio Sans", provId:"9", role: "Admin" },
			{ provName: "Alfred Cybella", provId:"10", role: "Nurse" },
			{ provName: "Dr. Wexford", provId:"11", role: "Doctor" },
			{ provName: "Korban Dallas", provId:"12", role: "Admin" }
		  ]};
		
		var days = {"sunday":"Sunday", "monday":"Monday", "tuesday":"Tuesday", "wednesday":"Wednesday", "thursday":"Thursday", "friday":"Friday", "saturday":"Saturday"};
		
		var searchData= [
			{"date":"2013-Dec-9", "time":"11:00", "provider":[{"docName":"Oscardoc. Dr.","docID":"1"},{"docName":"Yarwich. Dr.","docID":"2"}]},
			{"date":"2013-Dec-13", "time":"15:00", "provider":[{"docName":"Oscardoc. Dr.","docID":"1"},{"docName":"Yarwich. Dr.","docID":"2"}]},
			{"date":"2013-Dec-20", "time":"12:00", "provider":[{"docName":"Oscardoc. Dr.","docID":"1"},{"docName":"Yarwich. Dr.","docID":"2"}]},
			{"date":"2013-Dec-24", "time":"17:00", "provider":[{"docName":"Oscardoc. Dr.","docID":"1"},{"docName":"Yarwich. Dr.","docID":"2"}]},
			{"date":"2013-Dec-4", "time":"14:00", "provider":[{"docName":"Oscardoc. Dr.","docID":"1"},{"docName":"Yarwich. Dr.","docID":"2"}]}
		];
		

		
		/*JSON data end*/
		
		grp_mng_json_fn = {
			getData: function(){
				return data;
			},
			getSearchData: function(){
				return searchData;
			}
		};
		
		/*General functions*/
		grp_mng_fn = {
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
			 
			 loadPage: function(){
				var _data = grp_mng_json_fn.getData();
				$("#grp_man_leftPane li").remove();
				var showData = _data.show;
				$.each(showData, function(){
					$("#grp_man_leftPane").append(grp_mng_fn.getLI(this));
					
				});

				$("#grp_man_rightPane li").remove();
				var hideData = _data.hide;
				$.each(hideData, function(){
					$("#grp_man_rightPane").append(grp_mng_fn.getLI(this));
					
				});
				
				
			 },
			 getLI: function(data){
				var htmlData = '<li class="ui-state-default grp_man_li_roundbox" val="'+data.provId+'" style="padding:0;padding-left:5px;width:250px;">';
				htmlData += '<table class="grp_man_li_table"><tr><td width="70%">'+data.provName+'</td><td style="border-left: 1px solid #AAAAAA;padding-left:5px;">'+data.role+'</td></tr></table></li>';
				return htmlData;
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
			 }
		}
		
		
		/* General functions end*/ 

		/*Element event bindings*/
		$("#manageGroup").button().click(function () {
               $("#manageGroupForm").dialog("open");
         }); 

		 $("#grp_mng_but_cancel").button().click(function () {
			$("#manageGroupForm").dialog("close");
            return false;
         });
		 
		 $("#grp_mng_but_save").button().click(function () {
			var s = $("#grp_man_leftPane li");
			//console.log($("#sortable1 li").length);
			$('#grp_man_leftPane li').each(function(){
			   console.log($(this).attr('val')); // This is your rel value
			});
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
		 $("#manageGroupForm").dialog({
                autoOpen: false,
                height: 370,
                width: 620,
                modal: true
                
            });

		$(".ui-dialog-titlebar").hide();
		//Open dailog
		//$("#next_app_form").dialog("open");
		
		//auto complete widget init	
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
		/*drag and drop functionality*/
		$( "#grp_man_leftPane, #grp_man_rightPane" ).sortable({
			connectWith: ".connectedSortable",
			receive: function(event, ui) {
				$(ui.item).css('border', '1px solid #AAAAAA');
				$(ui.item).css('box-shadow', '0 0px 0px #AAAAAA');
			}
		}).disableSelection();
		
	});//end of document ready function

grp_mng_fn.loadPage();

function getDraggedVal(){
  var s = $("#sortable1 li");
  console.log(s[1])
  console.log($("#sortable1 li").length);
  //console.log($("#sortable1 li").text());
  //console.log($("#sortable1 li").attr('val'));
  $('#sortable1 li').each(function()
	{
	   console.log($(this).attr('val')); // This is your rel value
	});
  
  }
  
  /*bootstrap effect*/
  $(function() {
   $('.grp_man_li_roundbox').hover( function(){
      //$(this).css('background-color', '#D5D5D5');  
	  $(this).css('border', '1px solid #6A5ACD');
	  $(this).css('box-shadow', '0px 2px 4px 1px #3F3F3F');  
	  
   },
   function(){
      $(this).css('border', '1px solid #AAAAAA');
	  $(this).css('box-shadow', '0 0px 0px #AAAAAA');  
   });
});

  
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
		}

		.naa_button_grd:hover{
			 border:1px solid #5d7fbc;
			 background-color: #819bcb; background-image: -webkit-gradient(linear, left top, left bottom, from(#819bcb), to(#536f9d));
			 background-image: -webkit-linear-gradient(top, #819bcb, #536f9d);
			 background-image: -moz-linear-gradient(top, #819bcb, #536f9d);
			 background-image: -ms-linear-gradient(top, #819bcb, #536f9d);
			 background-image: -o-linear-gradient(top, #819bcb, #536f9d);
			 background-image: linear-gradient(to bottom, #819bcb, #536f9d);filter:progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#819bcb, endColorstr=#536f9d);
		}
		
		
		#grp_man_leftPane, #grp_man_rightPane { list-style-type: none; margin: 0; padding: 0 0 2.5em; float: left; margin-right: 10px; }
		#grp_man_leftPane li, #grp_man_rightPane li { margin: 0 5px 5px 5px; padding: 5px; font-size: 1.2em; width: 120px; }

		.grp_man_li_roundbox{           
			border-bottom-right-radius: 4px;
			border-bottom-left-radius: 4px;
			border-top-right-radius: 4px;
			border-top-left-radius: 4px;
			border:1px solid #AAAAAA;
			width:150px;
			font-family:calibri;
			font-size:13px;
			padding-left:5px;
			cursor:pointer;
			
			
					
		}
		
		.grp_man_li_roundbox ul li:hover {
			border: 2px dotted #ff0000; /*Red 2 pix dotted line border*/
		}
		
		.grp_man_li_table{
			border-collapse:collapse;height:20px;width:100%
		}

     
       
</style>

<!-- Next available appt dailog box start-->
<div id="manageGroupForm" title="Manage Group" class="na_form" style="padding:0px;width:100%">
	
	<table width="100%" border="0" style="border-collapse:collapse;">
		<tr>
				<td colspan="2" style="height:50px;"> 
					<p class="naa_mainheading">Manage schedule layout: Team A</p>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:right;border-top: 1px solid #AAAAAA; padding-top:10px;"> 
					
				</td>
			</tr>
			<tr>
				<td width="50%">
					<!-- basic details -->
					<table width="100%">
						<tr>
							<td colspan="2">
								<table>
									<t>
										<td class="naa_subheading">DISPLAY IN DAY VIEW</td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td style='color:blue;padding-left:10px;width:65%'>Provider</td>
							<td style='color:blue;'>Role</td>
						</tr>
						<tr>
							<td colspan="2">
									<div style="overflow-y:auto;overflow-x:hidden;height:200px;">
										<ul id="grp_man_leftPane" class="connectedSortable" style="min-height:150px;">
										  
										  <li class="ui-state-default grp_man_li_roundbox" val="proId2">Item2</li>
										  <li class="ui-state-default grp_man_li_roundbox" val="proId3">Item3</li>
										  <li class="ui-state-default grp_man_li_roundbox" val="proId4">Item4</li>
										  <li class="ui-state-default grp_man_li_roundbox" val="proId5">Item5</li>  
										  
										  
										</ul>
									</div>
							</td>
						</tr>
					</table>
				</td>
				<td width="50%" style="border-left: 1px solid #AAAAAA;padding-left:5px;display: table-cell; vertical-align: top; " >
					<!-- more details -->
					<table width="100%">
						<tr>
							<td colspan="2">
								<table>
									<tr>
										<td class="naa_subheading">HIDE FROM DAY VIEW</td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td style='color:blue;color:blue;padding-left:10px;width:70%'>Provider</td>
							<td style='color:blue;'>Role</td>
						</tr>
						<tr>
							<td colspan="2">
								<div style="overflow-y:auto;overflow-x:hidden;height:200px;">
									<ul id="grp_man_rightPane" class="connectedSortable">
									  <li class="ui-state-highlight grp_man_li_roundbox" val="proId6">Item 1</li>
									  <li class="ui-state-highlight grp_man_li_roundbox" val="proId7">Item 2</li>
									  <li class="ui-state-highlight grp_man_li_roundbox" val="proId8">Item 3</li>
									  <li class="ui-state-highlight grp_man_li_roundbox" val="proId9">Item 4</li>
									  <li class="ui-state-highlight grp_man_li_roundbox" val="proId0">Item 5</li>
									</ul>
								</div>
							</td>
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
				<td colspan="2" style="text-align:right;border-top: 1px solid #AAAAAA; padding-top:10px;padding-right:10px;"> 
					<button id="grp_mng_but_cancel" class="naa_button_grd" style="width:80px;cursor:pointer;">Cancel</button>&nbsp;&nbsp;
					<button id="grp_mng_but_save" class="naa_button_grd" style="width:80px;cursor:pointer;">Save</button>
				</td>
			</tr>
		</table>
</div>
<!--  Next available appt dailog box end -->
