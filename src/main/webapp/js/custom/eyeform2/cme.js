 
   jQuery(document).ready(function(){
	   
	   //need to test this on IE. Would like to make this configurable somewhere in prefs.
	   window.resizeTo(screen.width,screen.height);
	  
	   //header	 
	   jQuery.ajax({url:ctx+"/eyeform/encounterHeader.jsp?appointmentNo="+appointmentNo,dataType: "html",success: function(data) {			
		   jQuery("#encounterHeader").html(data);      
	   }});
	   	          
	   //CPP
	   issueNoteUrls = {};	   
	   jQuery("#cppBoxes").html("");
	   jQuery.ajax({url:ctx+"/eyeform/cppmeasurements.jsp?demographicNo="+demographicNo+"&appointmentNo="+appointmentNo,dataType: "html",async:false,success: function(data) {
		   jQuery("#cppBoxes").append(data);
	   }});
	   
	   
     	//link save button       
		jQuery("#save_measurements").live('click',function(e){	
			e.preventDefault();
			touchColor();			
			
			//save all measurements
			var postData = "";			
			jQuery("input[measurement]").each(function() {					
				var className = jQuery(this).attr("class");
								
				
				if(className == 'examfieldwhite') {						
					if(postData.length > 0) {
						postData += "&";
					}
					var name = jQuery(this).attr("measurement");
					var value = jQuery(this).val();
					var data = name + "=" + encodeURIComponent(value);
					postData += data;
				}
			});
			jQuery("textarea[measurement]").each(function() {					
				var className = jQuery(this).attr("class");
				if(className == 'examfieldwhite') {				
					if(postData.length > 0) {
						postData += "&";
					}
					var name = jQuery(this).attr("measurement");
					var value = jQuery(this).val();
					var data = name + "=" + encodeURIComponent(value);
					postData += data;
				}
			});	
			jQuery.ajax({type:'POST',url:ctx+'/oscarEncounter/MeasurementData.do?action=saveValues&demographicNo='+demographicNo+'&appointmentNo='+appointmentNo,data:postData,success: function(){
				//alert('Saved.');
			}});
			
			jQuery("textarea[cpp]").each(function() {				
				var name = jQuery(this).attr("cpp");
				var value = jQuery(this).val();
				
				var url = ctx + "/CaseManagementEntry.do?method=issueNoteSave&demographicNo="+demographicNo+"&appointmentNo="+appointmentNo+"&noteId=" + jQuery(this).attr("note_id");
				var postData = "reloadUrl="+encodeURIComponent("issue_code="+name)+"&containerDiv=&issueChange=true&archived=false&value="+encodeURIComponent(value)+"&position=0&forward=none&issue_id=" + jQuery(this).attr("issue_id");
				
				var textArea = jQuery(this);
				jQuery.ajax({type:'POST',url:url,data:postData,async:false, success: function(data){
					textArea.attr('note_id',data);
				}});
				
			});					  
		});
		
		
       jQuery("#cppBoxes").append("<div id=\"measurements_div\" style=\"width:100%\"></div>");

     
       jQuery.ajax({url:ctx+"/eyeform/exam.jsp?demographic_no="+demographicNo+"&appointment_no="+appointmentNo,dataType: "html",success: function(data) {
			jQuery("#measurements_div").append(data);
			//create comma separated list of the measurement types (from attribute)
			var types='';
			jQuery("input[measurement]").each(function() {
				if(types.length > 0) {
					types += ',';
				}
				types += jQuery(this).attr("measurement");
			});
			jQuery("textarea[measurement]").each(function() {
				if(types.length > 0) {
					types += ',';
				}
				types += jQuery(this).attr("measurement");
			});

			//make a call to update the existing values
			jQuery.ajax({dataType: "script", url:ctx+"/oscarEncounter/MeasurementData.do?demographicNo="+demographicNo+"&types="+types+"&action=getLatestValues&appointmentNo="+appointmentNo + "&fresh=cpp_currentHis",async:false});
			//jQuery.ajax({dataType: "script", url:ctx+"/oscarEncounter/MeasurementData.do?demographicNo="+demographicNo+"&types="+cppTypes+"&action=getLatestCppValues&appointmentNo="+appointmentNo + "&fresh=cpp_currentHis",async:false});
			
			//expand the sections where there's a while field
			jQuery(".slideblock").each(function() { 
				var id = jQuery(this).attr('id');
				var expand=false;
				jQuery("#" + id + " [measurement]").each(function() {
					if(jQuery(this).val().trim().length>0) {
						expand=true;
					}
				});
				/*
				jQuery("#"+id+" .examfieldwhite").each(function(){
					expand=true;
				});
				*/
				if(expand == true) {
					togglediv(document.getElementById(id));
				}				
			});
						
       }});


       init();
       
       //left nav bar
       removeNavDiv('preventions'); 
       removeNavDiv('docs');
       addLeftNavDiv("docs");	  
       popColumn(ctx + "/oscarEncounter/displayDocuments.do?hC=476BB3&appointment_no="+appointmentNo+"&omit=photo","docs","docs", "leftNavBar", this);
       removeNavDiv('eforms');
       addLeftNavDiv("eforms");	  
       popColumn(ctx + "/oscarEncounter/displayEForms.do?hC=11CC00&appointment_no="+appointmentNo+"&omit=Ant+Segment,Retina,Eye+Saggital,Eye+Lid%2FNLD","eforms","eforms", "leftNavBar", this);       
      
       reorderNavBarElements('tickler','Dx');
       reorderNavBarElements('msgs','tickler');
       reorderNavBarElements('labs','msgs');       
	   addLeftNavDiv("diagrams");	      
       popColumn(ctx + "/oscarEncounter/displayDiagrams.do?hC=11CC00&appointment_no="+appointmentNo,"diagrams","diagrams", "leftNavBar", this);
       reorderNavBarElements('diagrams','eforms');
       reorderNavBarElements('docs','diagrams');
       addLeftNavDiv("photos");	      
       popColumn(ctx + "/oscarEncounter/displayPhotos.do?hC=476BB3&appointment_no="+appointmentNo,"photos","photos", "leftNavBar", this);
       reorderNavBarElements('photos','docs');
       addLeftNavDiv("appointmentHistory");	      
       popColumn(ctx + "/oscarEncounter/displayAppointmentHistory.do?hC=009999&cmd=appointmentHistory&cpp=measurements","appointmentHistory","appointmentHistory", "leftNavBar", this);              
       reorderNavBarElements('appointmentHistory','measurements');    
       reorderNavBarElements('consultations','appointmentHistory');           
       addLeftNavDiv("conReport");	      
       popColumn(ctx + "/oscarEncounter/displayConReport.do?hC=009999&cmd=conReport&appointment_no="+appointmentNo + "&cpp=measurements","conReport","conReport", "leftNavBar", this);
       reorderNavBarElements('conReport','consultation');
       addLeftNavDiv("Billing");	      
       popColumn(ctx + "/oscarEncounter/displayBilling.do?hC=009999&cmd=Billing&appointment_no="+appointmentNo,"Billing","Billing", "leftNavBar", this);
       reorderNavBarElements('Billing','conReport');
       addLeftNavDiv("macro");	      
       popColumn(ctx + "/oscarEncounter/displayMacro.do?hC=009999&appointment_no="+appointmentNo  +"&cpp=measurements","macro","macro", "leftNavBar", this);
       
       //right nav bar
       removeNavDiv('issues');
       removeNavDiv('Guidelines');
       removeNavDiv('RiskFactors');
       removeNavDiv('Rx');
       removeNavDiv('OMeds');
       removeNavDiv('FamHistory'); 
       addRightNavDiv("specshistory");	                         
       popColumn(ctx + "/oscarEncounter/displaySpecsHistory.do?hC=009999&appointment_no="+appointmentNo,"specshistory","specshistory", "rightNavBar", this);   
       addRightNavDiv("Rx");
       popColumn(ctx + "/oscarEncounter/displayRx.do?hC=C3C3C3&numToDisplay=12","Rx","Rx","rightNavBar",this);
       addRightNavDiv("OMeds");
       popColumn(ctx + "/CaseManagementView.do?hc=CCDDAA&method=listNotes&providerNo=" + providerNo + "&demographicNo=" + demographicNo + "&issue_code=OMeds&title=" + oMedsLabel + "&cmd=OMeds" + "&appointment_no="+appointmentNo,"OMeds","OMeds","rightNavBar",this);
       //var ocularMedsLabel = "oscarEncounter.NavBar.OcularMeds";
      // addRightNavDiv("OcularMedication");	
       //popColumn(ctx + "/CaseManagementView.do?hc=CCDDAA&method=listNotes&providerNo=" + providerNo + "&demographicNo=" + demographicNo + "&issue_code=OcularMedication&title="+ocularMedsLabel+"&cmd=OcularMedication&appointment_no="+appointmentNo +"&noheight=true","OcularMedication","OcularMedication", "rightNavBar", this);       
       addRightNavDiv("ocularprocedure");	                         
       popColumn(ctx + "/oscarEncounter/displayOcularProcedure.do?hC=009999&appointment_no="+appointmentNo,"ocularprocedure","ocularprocedure", "rightNavBar", this);
       addLeftNavDiv("examhistory");	                         
       popColumn(ctx + "/oscarEncounter/displayExaminationHistory.do?hC=009999&appointment_no="+appointmentNo,"examhistory","examhistory", "leftNavBar", this);   
       reorderNavBarElements('examhistory','photos');
       
       
       notifyIssueUpdate();         
       
       jQuery("form[name='caseManagementEntryForm']").append('<span submit_addon="save_measurements"></span>');

       jQuery("img[id^='quitImg']").each(function(){
    	   if(jQuery(this).attr('src').indexOf('/oscarEncounter/graphics/triangle_up.gif')!=-1) {
    		   var iid = jQuery(this).attr('id');
    		   //var noteId = iid.substring(7,iid.length);
    		   //shrink('n'+noteId,14);
    		   jQuery(this).trigger('click');

    	   }
       });
       
       jQuery("#newNoteImg").hide();
       jQuery("#imgPrintEncounter").removeAttr('onclick');
       jQuery("#imgPrintEncounter").live('click',function(e){
    	   e.preventDefault();
    	   location.href=ctx+'/eyeform/Eyeform.do?method=print&apptNos=' + appointmentNo + "&cpp=measurements";
       });
       jQuery("#assignIssueSection").html("<span>&nbsp;</span>");
       jQuery("#caseNote_note"+savedNoteId).css('height','10em');
     });

 
   
   function runMacro(macroId,appointmentNo) {
	   jQuery.ajax({ url: ctx+"/CaseManagementView.do?method=run_macro&id="+macroId+"&appointmentNo="+appointmentNo +"&noteId="+savedNoteId + "&demographicNo="+demographicNo, dataType:'script', async:false});
	   jQuery.ajax({url:ctx+"/eyeform/NoteData.do?method=getCurrentNoteData&demographicNo="+demographicNo+"&noteId="+savedNoteId+"&appointmentNo="+appointmentNo,dataType: "html",async:false, success: function(data) {
			jQuery("#current_note_addon").html(data);
      }});
	   jQuery.ajax({ url: ctx+"/CaseManagementView.do?method=run_macro_script&id="+macroId+"&appointmentNo="+appointmentNo +"&noteId="+savedNoteId + "&demographicNo="+demographicNo, dataType:'script', async:false});
	   
   }
  
   function runMacro2(macroId,macroName, appointmentNo,cpp) {
	   var c = confirm('Are you sure to execute macro ['+macroName+'] and sign this form?');
	   if(c == false) {return false;}
	   //potentially need admission date.	  
	   document.forms['caseManagementEntryForm'].sign.value='on';
	   jQuery("form[name='caseManagementEntryForm']").append("<input type=\"hidden\" name=\"macro.id\" value=\""+macroId+"\"/>");
	   var result =  savePage('runMacro', '');
	   return false;
   }


   function notifyIssueUpdate() {
	   var noteAddonUrl = ctx+"/eyeform/NoteData.do?method=getCurrentNoteData&demographicNo="+demographicNo+"&noteId="+savedNoteId+"&appointmentNo="+appointmentNo;	   
       jQuery.ajax({url:noteAddonUrl,dataType: "html",success: function(data) {
			jQuery("#current_note_addon").html(data);
       }});
   }
   
   function notifyDivLoaded(divId) {
	   jQuery("#"+divId + " .topLinks").each(function() {
		  jQuery(this).css("font-size","15px"); 
	   });
   }