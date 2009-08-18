<!-- 

Source:web/PMmodule/Admin/ProgramView/incident.jsp 

-->
<!--
/*
*
* Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
* This software is published under the GPL GNU General Public License.
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version. *
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details. * * You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *
*
* <OSCAR TEAM>
*
* This software was written for
* Centre for Research on Inner City Health, St. Michael's Hospital,
* Toronto, Ontario, Canada
*/
-->
<%@ include file="/taglibs.jsp"%>
<logic-el:present name="incidents">
	<jsp:include page='<%="/PMmodule/Admin/ProgramView/incidentList.jsp"%>' />
</logic-el:present>
<logic-el:notPresent name="incidents">
	<jsp:include page='<%="/PMmodule/Admin/ProgramView/incidentEdit.jsp"%>' />
</logic-el:notPresent>

<script type="text/javascript">
<!--
	function resetForm(){

		//document.forms[0].reset();
		document.getElementsByName("incidentForm.clientId")[0].value = ""; 
		document.getElementsByName("incidentForm.clientName")[0].value = "";
		document.getElementsByName("incidentForm.incDateStr")[0].value = "";
	}
	
	function removeSel(str) {
	    var elSel = document.getElementsByName(str)[0]; 
	    if(elSel.selectedIndex >= 0){
	      elSel.remove(elSel.selectedIndex);
	    }else{
	      alert("Please select one item to remove.");
	    } 
	}
	function getList(){
	
		var elSel= document.getElementsByName("incidentForm.lstStaff")[0];
		var txtKey= document.getElementsByName("incidentForm.txtStaffKeys")[0]; 
		var txtValue= document.getElementsByName("incidentForm.txtStaffValues")[0]; 
		txtKey.value="";
		txtValue.value="";
	
		for(var i=0; i < elSel.options.length; i++){
			if(txtKey.value==""){
			   txtKey.value = elSel.options[i].value;
			}else{  
			   txtKey.value = txtKey.value + ":" + elSel.options[i].value;
			}
			
			if(txtValue.value==""){
			   txtValue.value = elSel.options[i].text;
			}else{  
			   txtValue.value = txtValue.value + ":" + elSel.options[i].text;
			}
		}
		
		var elSel2= document.getElementsByName("incidentForm.lstClient")[0]; 
		var txtKey2= document.getElementsByName("incidentForm.txtClientKeys")[0]; 
		var txtValue2= document.getElementsByName("incidentForm.txtClientValues")[0]; 
		txtKey2.value="";
		txtValue2.value="";
	
		for(var i=0; i < elSel2.options.length; i++){
			if(txtKey2.value==""){
			   txtKey2.value = elSel2.options[i].value;
			}else{  
			   txtKey2.value = txtKey2.value + ":" + elSel2.options[i].value;
			}
			
			if(txtValue2.value==""){
			   txtValue2.value = elSel2.options[i].text;
			}else{  
			   txtValue2.value = txtValue2.value + ":" + elSel2.options[i].text;
			}
		}
		
		return true;
	}
	
	function submitForm( mthd){
		var flag = true;
		if(!isDateValid) return;
		if(mthd == "save"){
			getList();
			var txtKey= document.getElementsByName("incidentForm.txtStaffKeys")[0];
			var txtKey2= document.getElementsByName("incidentForm.txtClientKeys")[0];
			if(txtKey2.value.length == 0){
				alert("Please add client in 'Clients Involved' field");
				return;
			}
			if(txtKey.value.length == 0){
				alert("Please add staff in 'Staff Involved' field.");
				return;
			}
			
			if(noChanges()) 
			{
				alert("There are no changes detected to save");
				return;
			}
		}

		var	id;
		if(mthd == "new"){
			id = 0;
		}else{
			id = document.getElementById("incidentId").value;
		}
		
		obj = document.getElementsByName("incidentForm.incidentDateStr")[0];
	    if(obj!=null)
	    {
		    if(obj.value.trim()==""){
		      alert("Incident Date is empty.");
		      obj.value="";
		      obj.focus();
		      return; 
		    }
			if(mthd == "save") {
				var hr = document.getElementsByName("incidentForm.hour")[0].value;
				var min = document.getElementsByName("incidentForm.minute")[0].value;
				var pm = document.getElementsByName("incidentForm.ampm")[1];
				if(hr == " ") hr = "0";
				var hrs = parseInt(hr);
				var mins = parseInt(min);
				if(!pm.checked){
					if (hrs == 12) hrs = 0;
				}
				else
				{	
					if(hrs < 12) hrs += 12;
				}
			    if(isBeforeNowxMin(obj.value,hrs,mins,-1)==false){
//			    	alert(obj.value + hrs.toString() + mins.toString());
//			    	alert(obj.value + hr + min);
			       alert("Incident Date should be before now");
			       obj.focus();
			       return;
			    }
		    }
		    else
		    {
		    	if (isBeforeOrEqualToday(obj.value))
		    	{
		    		alert ("Incident Date should be not later than today");
		    		return;
		    	}
		    }
	    }
	        
		invDt = document.getElementsByName("incidentForm.investigationDateStr")[0];
	    if(invDt!=null)
	    {
		    if(invDt.value.trim()!=""){
			    if(isBefore(invDt.value,obj.value)){
			       alert("Investigation date should be later than incident date");
			       invDt.focus();
			       return;
		    	}
	    	}
	    }
		followupDt = document.getElementsByName("incidentForm.followupDateStr")[0];
	    if(followupDt!=null)
	    {
		    if(followupDt.value.trim()!=""){
			    if(isBefore(followupDt.value,obj.value)){
			       alert("Follow up date should be later than incident date");
			       invDt.focus();
			       return;
		    	}
	    	}
	    }

	    
		document.programManagerViewForm.action = document.programManagerViewForm.action + "?incidentId=" + id + "&mthd=" + mthd;
		//alert(document.programManagerViewForm.action);
		document.programManagerViewForm.tab.value = "Incidents";
		document.programManagerViewForm.submit();
	
	
	}
	function editIncident2(id, mthd){
		var flag = true;
		if(mthd == "save"){
			getList();
		}
		
		document.programManagerViewForm.action = document.programManagerViewForm.action + "?incidentId=" + id + "&mthd=" + mthd;
		
		document.programManagerViewForm.tab.value = "Incidents";
		document.programManagerViewForm.submit();
	
	
	}
	
	function txtAreaLenChecker(obj, maxLen) {
	   //counting each end of line as two characters
	   
		var v = obj.value;
		var len = v.length;
		
		if(len > maxLen){
			alert("Length of this field can not exceed " + maxLen + " characters.");
			obj.value = v.substr(0, maxLen);
	   }
	
	}
	
	function searchIncident(){
		if (!trimInputBox()) return false;
		document.programManagerViewForm.action = document.programManagerViewForm.action + "?mthd=search";
		//alert(document.programManagerViewForm.action);
		document.programManagerViewForm.tab.value = "Incidents";
		document.programManagerViewForm.submit();
	
	}
	
	function checkHour(obj){
			
		if(isNaN(obj.value)){
			obj.value="";
			alert("Please enter digital characters only.");
			return false;
		}  
	
		if(obj.value > 0 && obj.value <= 12){
			if(obj.value.indexOf(".") >= 0){
		       	obj.value="";
		       	alert("Please enter integer characters only.");
		       	return false;
			}
			if(obj.value < 10){
				obj.value = "0" + obj.value;
			}
		}else{
			obj.value="";
			alert("Hour must be between 1 and 12 for standard time.");
			return false;
		}
	}
	 	
	function checkMinute(obj){
				
		if(isNaN(obj.value)){
	        obj.value="";
			alert("Please enter digital characters only.");
			return false;
		}  
	
		if(obj.value >= 0 && obj.value < 60){
	        if(obj.value.indexOf(".") >= 0){
				obj.value="";
				alert("Please enter integer characters only.");
				return false;
			}
			if(obj.value < 10){
				obj.value = "0" + obj.value;
			}
		}else{
			obj.value="";
			alert("Minute must be between 0 and 59 for standard time.");
	        return false;
	    }
	        	
	}
	
	

//-->
</script>
