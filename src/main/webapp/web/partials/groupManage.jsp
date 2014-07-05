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
				//console.log(globalGroup);
				var data1 = $.ajax({
					url : "../ws/rs/providerService/"+globalGroup+"/groupProvList",
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
				var jObj = JSON.parse(data1);
				return jObj;
			},
			getSearchData: function(){
				return searchData;
			},
			getProvidersData : function(providersArray){
				var data1 = $.ajax({
					url : "../ws/rs/providerService/saveGroupProvList",
					type : "post",
					data : JSON.stringify(providersArray),
					async: false,
					contentType : 'application/json',
					success : function(result) {
					},
					error : function(jqxhr) {
						var msg = JSON.parse(jqxhr.responseText);
						alert(msg['message']);

					}
				}).responseText;
				var jObj = JSON.parse(data1);
				return jObj;
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
			 /*Refered from the Schdule.jsp getGroupIndi() as well to load the 
			 	details whenever a change in the group value*/
			 loadPage: function(){
				 /* To change the title for Manage group layout */
				 $("#groupTitle").html("Manage schedule layout: "+globalGroup);
				
				 /*To set the globalGroup value to docava select drop Starts here*/
					var tempGroup = globalProviderId+"_Individual";
					
					$("#docava option").filter(function() {
					       return $(this).attr('value') == tempGroup;
					   }).attr('selected', true);
					
					$("#docava").select2().on('select', tempGroup);
					if($("#docava").val().split("_")[1]=="Individual"){
				 	$("#placeText").show();
					$("#placeText").html("Individual : ");
					}
				 //getGroupIndi("docava");
				 /*ends here */
				 var _data = grp_mng_json_fn.getData();
				//console.log(_data);
				var showData = _data.active;
				//if(showData.length>0)
				$("#grp_man_leftPane li").remove();
				$.each(showData, function(){
					$("#grp_man_leftPane").append(grp_mng_fn.getLI(this));
					
				});
				var hideData = _data.inActive;
				//if(hideData.length>0)
				$("#grp_man_rightPane li").remove();
				$.each(hideData, function(){
					$("#grp_man_rightPane").append(grp_mng_fn.getLI(this));
					
				});
			 },
			 getLI: function(data){
				var htmlData = '<li class="ui-state-default grp_man_li_roundbox" val="'+data.providerNo+'" style="padding:0 5px;width:250px;">';
				htmlData += '<table class="grp_man_li_table"><tr><td width="70%" calss="dummy"><img src="js_up/images/arrow.png"/>'+data.firstName+'</td><td style="border-left: 1px solid #AAAAAA;padding-left:5px;">'+data.providerType+'</td></tr></table></li>';
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
			 },
			 loadProviders: function(providersArray){
					var _data = new Object
					_data.data = grp_mng_json_fn.getProvidersData(providersArray);
					Schedular.prototype.setInitData(_data);
					setTimeout('sch.init(\''+globalView.view+'\',\'from groupMangae\')', 1000);
				}
		},
		
		
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
			var providerNoArr = new Array();
			$('#grp_man_leftPane li').each(function(){
			   var temp = new Object();
			   temp.providerNo = $(this).attr('val');
			   temp.enabled = true;
			   providerNoArr.push(temp);
			});
			var providerNoArr1 = new Array();
			$('#grp_man_rightPane li').each(function(){
				   var temp = new Object();
				   temp.providerNo = $(this).attr('val');
				   temp.enabled = false;
				   providerNoArr.push(temp);
				});
			if($('#grp_man_leftPane li').length>0){
				grp_mng_fn.loadProviders(providerNoArr);
				$("#manageGroupForm").dialog("close");
			}else{
				alert("At least one provider to be in Day view");
			}
			
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
		//$("#manageGroupHTML").show();
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
		$( "ul.droptrue" ).sortable({
			connectWith: "ul",
			revert: true,
			receive: function(event, ui) {
				if($('#grp_man_leftPane li').length==0){
					alert("At least one provider in Day view");
					$( "ul.droptrue" ).sortable( "cancel" );
				}
					
			}
		}).disableSelection();
		grp_mng_fn.loadPage();
		
	});//end of document ready function



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
		table {
		    max-width: 100%;
		}
		.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default {
	    background: none repeat-x scroll 50% 50% #FFFFFF;
	    border: 1px solid #D3D3D3;
	    color: #555555;
	    font-weight: normal;
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
		
#grp_man_leftPane, #grp_man_rightPane {
    /*background: none repeat scroll 0 0 #EFEFEF;*/
    float: left;
    list-style-type: none;
    margin: 0 10px 0 0;
    padding: 5px;
    width: 100%;
    height:100%;
}
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

		.grp_man_close:hover{
			 cursor:pointer !important;
		}     
       
</style>

<!-- Next available appt dailog box start-->
<div id="manageGroupForm" title="Manage Group" class="na_form" style="padding:0px;width:100%">
	
	<table width="100%" border="0" style="border-collapse:collapse;">
		<tr>
				<td colspan="2" style="height:50px;"> 
					<p style="color:#6E6E6E;font-size:16px;font-weight:bold;" id="groupTitle" >Manage schedule layout: Group A</p>
				</td>
				<td colspan="2" style="height:50px;" align="right" valign="top"> 
					<div class="grp_man_close" onClick='$("#manageGroupForm").dialog("close");'><img src="js_up/images/close_icon.png" height=20 width=20></img></div>
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
										<td style="color:#848484;">DISPLAY IN DAY VIEW</td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td style='padding-left:10px;width:65%' class="naa_mainheading">Provider</td>
							<td class="naa_mainheading">Role</td>
						</tr>
						<tr>
							<td colspan="2">
									<div style="overflow-y:auto;overflow-x:hidden;height:200px;">
										<ul id="grp_man_leftPane" class="droptrue" style="min-height:150px;" >
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
										<td class="naa_subheading" style="color:#848484;">HIDE FROM DAY VIEW</td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td style='padding-left:10px;width:70%' class="naa_mainheading">Provider</td>
							<td class="naa_mainheading">Role</td>
						</tr>
						<tr>
							<td colspan="2">
								<div style="overflow-y:auto;overflow-x:hidden;height:200px;">
									<ul id="grp_man_rightPane" class="droptrue">
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
					<div class="btn-group" style="padding-right:15px;">
					  	<button type="button" id="grp_mng_but_cancel" class="btn" style="background-color:lightgray;font-size:12px;">Cancel</button>
				  	</div>	 
				  				  	
				  	<div class="btn-group" style="padding-right:15px;">
					  <button type="button"  id="grp_mng_but_save" class="btn btn-primary" style="font-size:12px;" >Save</button>
				  	</div>	
				</td>
			</tr>
		</table>
</div>
<!--  Next available appt dailog box end -->
