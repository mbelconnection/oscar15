<%@page import="org.oscarehr.common.model.OcanStaffForm"%>
<%@page import="org.oscarehr.PMmodule.model.Admission"%>
<%@page import="org.oscarehr.common.model.Demographic"%>
<%@page import="org.oscarehr.PMmodule.web.OcanForm"%>
<%@page import="org.oscarehr.util.LoggedInInfo"%>

<%@include file="/layouts/caisi_html_top-jquery.jspf"%>


<%
	int currentDemographicId=Integer.parseInt(request.getParameter("demographicId"));	
	int prepopulationLevel = OcanForm.PRE_POPULATION_LEVEL_ALL;
	
	OcanStaffForm ocanStaffForm=OcanForm.getOcanStaffForm(currentDemographicId,prepopulationLevel);		
	
	boolean printOnly=request.getParameter("print")!=null;
	if (printOnly) request.setAttribute("noMenus", true);
	
%>


<script type="text/javascript" src="<%=request.getContextPath()%>/PMmodule/ClientManager/ocan_staff_form_validation.js"></script>

<script type="text/javascript">
function clearDate(el)
{
	$("#"+el).val("");
}
</script>		

<script>
//setup validation plugin
$("document").ready(function() {	
	$("#ocan_staff_form").validate({meta: "validate"});
		
	$.validator.addMethod('postalCode', function (value) { 
	    return /^((\d{5}-\d{4})|(\d{5})|()|([A-Z]\d[A-Z]\s\d[A-Z]\d))$/.test(value); 
	}, 'Please enter a valid US or Canadian postal code.');
	
});


</script>


<script type="text/javascript">

$('document').ready(function(){
	//we want to load initial meds
	var demographicId='<%=currentDemographicId%>';
	var medCount = $("#medications_count").val();
	for(var x=1;x<=medCount;x++) {
		$.get('ocan_form_medication.jsp?demographicId='+demographicId+'&medication_num='+x, function(data) {
			  $("#medication_block").append(data);					 
			});				
	} 
});

</script>

<script type="text/javascript">

$('document').ready(function() {
	//load mental health centres
	var demographicId='<%=currentDemographicId%>';
	var cenCount = $("#center_count").val();
	for(var x=1;x<=cenCount;x++) {
		$.get('ocan_form_mentalHealthCenter.jsp?demographicId='+demographicId+'&center_num='+x, function(data) {
			  $("#center_block").append(data);					 
			});				
	} 
});

</script>

<script>
function changeOrgLHIN(selectBox) {
	//annie
		var newCount = $("#center_count").val(); 

		var selectBoxId = selectBox.id;
		var priority = selectBoxId.charAt(selectBoxId.length-1);
		var selectBoxValue = selectBox.options[selectBox.selectedIndex].value;
		
		var demographicId='<%=currentDemographicId%>';

		//do we need to add..loop through existing blocks, and see if we need more...create on the way.
			
			if(document.getElementById("serviceUseRecord_orgName" + priority) == null) {
				$.get('ocan_form_getOrgName.jsp?demographicId='+demographicId+'&center_num='+priority+'&lhin_num='+selectBoxValue, function(data) {
					  $("#center_block_orgName"+priority).append(data);					 
					});														
			}

		//do we need to remove. If there's any blocks > newCount..we need to delete them.
			if(document.getElementById("serviceUseRecord_orgName" + priority) != null) {
				$("#center_block_orgName"+priority).remove();
			}
}

function changeNumberOfMedications() {
	var newCount = $("#medications_count").val(); 

	var demographicId='<%=currentDemographicId%>';

	//do we need to add..loop through existing blocks, and see if we need more...create on the way.
	for(var x=1;x<=newCount;x++) {		
		if(document.getElementById("medication_" + x) == null) {
			$.get('ocan_form_medication.jsp?demographicId='+demographicId+'&medication_num='+x, function(data) {
				  $("#medication_block").append(data);					 
				});														
		}
	}

	//do we need to remove. If there's any blocks > newCount..we need to delete them.
	for(var x=(Number(newCount)+1);x<=25;x++) {			
		if(document.getElementById("medication_" + x) != null) {
			$("#medication_"+x).remove();
		}
	}
}
</script>

<script type="text/javascript">
function changeNumberOfcentres() {
	var newCount = $("#center_count").val(); 

	var demographicId='<%=currentDemographicId%>';

	//do we need to add..loop through existing blocks, and see if we need more...create on the way.
	for(var x=1;x<=newCount;x++) {		
		if(document.getElementById("center_" + x) == null) {
			$.get('ocan_form_mentalHealthCenter.jsp?demographicId='+demographicId+'&center_num='+x, function(data) {
				  $("#center_block").append(data);					 
				});														
		}
	}

	//do we need to remove. If there's any blocks > newCount..we need to delete them.
	for(var x=(Number(newCount)+1);x<=25;x++) {			
		if(document.getElementById("center_" + x) != null) {
			$("#center_"+x).remove();
		}
	}
}



</script>

<script>
$("document").ready(function() {

	$("#generate_summary_of_actions").click(function(){
		$("#summary_of_actions_block").innerHTML='';
		var count=0;
		var domains = '';
		
		for(var x=1;x<=24;x++) {
			var actionVal = $("#"+x+"_actions").val();			
			if(actionVal.length > 0) {
				count++;
				if(domains.length>0) {
					domains += ',';
				} 	
				domains += x;
			}
		}		
		$("#summary_of_actions_count").val(count);
		$("#summary_of_actions_domains").val(domains);
		var demographicId='<%=currentDemographicId%>';
		$.get('ocan_form_summary_of_actions.jsp?demographicId='+demographicId+'&size='+count+'&domains='+domains, function(data) {
			  $("#summary_of_actions_block").innerHTML=data;					 
			});		
	});
	
});

function suaChangeDomain(selectBox)
{
	var selectBoxId = selectBox.id;
	var priority = selectBoxId.substring(0,selectBoxId.indexOf('_'));

	var selectBoxValue = selectBox.options[selectBox.selectedIndex].value;
	
	$("#" + priority + "_summary_of_actions_action").val($("#"+selectBoxValue+ "_actions").val());	
}

$("document").ready(function(){

	var summaryOfActionsCount = $("#summary_of_actions_count").val();
	var summaryOfActionsDomains = $("#summary_of_actions_domains").val();
	var demographicId='<%=currentDemographicId%>';
	
	$.get('ocan_form_summary_of_actions.jsp?demographicId='+demographicId+'&size='+summaryOfActionsCount+'&domains='+summaryOfActionsDomains, function(data) {
		  $("#summary_of_actions_block").append(data);					 
		});		
	
});
</script>

<script>

$('document').ready(function(){
	//we want to load initial meds
	var demographicId='<%=currentDemographicId%>';
	var medCount = $("#referrals_count").val();
	for(var x=1;x<=medCount;x++) {
		$.get('ocan_form_referral.jsp?demographicId='+demographicId+'&referral_num='+x, function(data) {
			  $("#referral_block").append(data);					 
			});				
	} 
});

function changeNumberOfReferrals() {
	var newCount = $("#referrals_count").val(); 

	var demographicId='<%=currentDemographicId%>';

	//do we need to add..loop through existing blocks, and see if we need more...create on the way.
	for(var x=1;x<=newCount;x++) {		
		if(document.getElementById("referral_" + x) == null) {
			$.get('ocan_form_referral.jsp?demographicId='+demographicId+'&referral_num='+x, function(data) {
				  $("#referral_block").append(data);					 
				});														
		}
	}

	//do we need to remove. If there's any blocks > newCount..we need to delete them.
	for(var x=(Number(newCount)+1);x<=25;x++) {			
		if(document.getElementById("referral_" + x) != null) {
			$("#referral_"+x).remove();
		}
	}
}




</script>

<script>
$("document").ready(function(){
	$("select[domain1='true']").change(function(){
		var curId = $(this).attr("id");
		var domainNumber = curId.substring(0,curId.indexOf("_"));
		var value = $(this).val();
		if(value == '0' || value == '9') {
			//blank out 2,3a,3b
			$("#"+domainNumber+"_2").attr("disabled","disabled");
			$("#"+domainNumber+"_3a").attr("disabled","disabled");
			$("#"+domainNumber+"_3b").attr("disabled","disabled");
		} else {
			$("#"+domainNumber+"_2").attr("disabled","");
			$("#"+domainNumber+"_3a").attr("disabled","");
			$("#"+domainNumber+"_3b").attr("disabled","");
		}
	});

	$("select[domain1='true']").each(function(){
		var curId = $(this).attr("id");
		var domainNumber = curId.substring(0,curId.indexOf("_"));
		var value = $(this).val();
		if(value == '0' || value == '9') {
			//blank out 2,3a,3b
			$("#"+domainNumber+"_2").attr("disabled","disabled");
			$("#"+domainNumber+"_3a").attr("disabled","disabled");
			$("#"+domainNumber+"_3b").attr("disabled","disabled");
		} else {
			$("#"+domainNumber+"_2").attr("disabled","");
			$("#"+domainNumber+"_3a").attr("disabled","");
			$("#"+domainNumber+"_3b").attr("disabled","");
		}
	});

	//autism
	$("input[name='6_medical_conditions'][value='408856003']").change(function(){
		if($(this).attr("checked")) {
			$("#6_medical_conditions_autism").attr("disabled","");
		} else {
			$("#6_medical_conditions_autism").attr("disabled","disabled");
			$("#6_medical_conditions_autism").val("");
		}
		
	});

	if($("input[name='6_medical_conditions'][value='408856003']").attr("checked")) {	
		$("#6_medical_conditions_autism").attr("disabled","");
	} else {
		$("#6_medical_conditions_autism").attr("disabled","disabled");
		$("#6_medical_conditions_autism").val("");
	}

	//phys health - other
	//410515003
	$("input[name='6_medical_conditions'][value='OTH']").change(function(){
		if($(this).attr("checked")) {
			$("#6_medical_conditions_other").attr("disabled","");
		} else {
			$("#6_medical_conditions_other").attr("disabled","disabled");
			$("#6_medical_conditions_other").val("");
		}
		
	});
	
	if($("input[name='6_medical_conditions'][value='OTH']").attr("checked")) {	
		$("#6_medical_conditions_other").attr("disabled","");
	} else {
		$("#6_medical_conditions_other").attr("disabled","disabled");
		$("#6_medical_conditions_other").val("");
	}
});

</script>

<style>
.error {color:red;}
</style>


<form id="ocan_staff_form" name="ocan_staff_form" action="ocan_form_action.jsp" method="post" onsubmit="return submitOcanForm()">
	<input type="hidden" id="assessment_status" name="assessment_status" value=""/>
	<h3>OCAN Staff Assessment (v2.0)</h3>

	<br />
	
	<table style="margin-left:auto;margin-right:auto;background-color:#f0f0f0;border-collapse:collapse">
		<tr>
			<td class="genericTableHeader">Start Date</td>
			<td class="genericTableData">
				<input id="startDate" name="startDate" onfocus="this.blur()" readonly="readonly" class="{validate: {required:true}}" type="text" value="<%=ocanStaffForm.getFormattedStartDate()%>"> <img title="Calendar" id="cal_startDate" src="../../images/cal.gif" alt="Calendar" border="0"><script type="text/javascript">Calendar.setup({inputField:'startDate',ifFormat :'%Y-%m-%d',button :'cal_startDate',align :'cr',singleClick :true,firstDay :1});</script>		
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Completion Date</td>
			<td class="genericTableData">
				<input id="completionDate" name="completionDate" onfocus="this.blur()" readonly="readonly" class="{validate: {required:true}}" type="text" value="<%=ocanStaffForm.getFormattedCompletionDate()%>"> <img title="Calendar" id="cal_completionDate" src="../../images/cal.gif" alt="Calendar" border="0"><script type="text/javascript">Calendar.setup({inputField:'completionDate',ifFormat :'%Y-%m-%d',button :'cal_completionDate',align :'cr',singleClick :true,firstDay :1});</script>					
			</td>
		</tr>
		<tr>
			<td colspan="2">OCAN Lead Assessment</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Was this OCAN completed by OCAN Lead?</td>
			<td class="genericTableData">
				<select name="completedByOCANLead">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "completedByOCANLead", OcanForm.getOcanFormOptions("OCAN Lead Assessment"),prepopulationLevel)%>
				</select>					
			</td>			
		</tr>
		
		<tr>
			<td colspan="2">Reason for OCAN</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Reason for OCAN</td>
			<td class="genericTableData">
				<select name="reasonForAssessment" id="reasonForAssessment" class="{validate: {required:true}}">
					<option value="">Select an answer</option>
					<%
						for (org.oscarehr.common.model.OcanFormOption option : OcanForm.getOcanFormOptions("Reason for OCAN"))
						{
							String selected="";
							
							if (ocanStaffForm.getReasonForAssessment()!=null && ocanStaffForm.getReasonForAssessment().equals(option.getOcanDataCategoryValue())) selected="selected=\"selected\"";
							
							%>
								<option <%=selected%> value="<%=option.getOcanDataCategoryValue()%>"><%=option.getOcanDataCategoryName()%></option>
							<%
						}
					%>
										
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">If Other, Specify</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"reason_for_assessment_other",5,30, prepopulationLevel)%>
			</td>
		</tr>
		
		<tr>
			<td colspan="2">Consumer Self Assessment Completion</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Was Consumer Self-Assessment Completed?</td>
			<td class="genericTableData">
				<select name="consumerSelfAxCompleted" id="consumerSelfAxCompleted" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "consumerSelfAxCompleted", OcanForm.getOcanFormOptions("Consumer Self-Assessment completed"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">If the Consumer Self-Assessment was not completed, why not? (select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "reasonConsumerSelfAxNotCompletedList", OcanForm.getOcanFormOptions("Consumer Self-Assessment incompleted"),prepopulationLevel)%>						
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Consumer Self-Assessment Completed by Consumer - Other</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"otherReason",5,30, prepopulationLevel)%>
			</td>
		</tr>
				
		
		<tr>
			<td colspan="2">Consumer Information</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Last Name</td>
			<td class="genericTableData">
				<input type="text" name="lastName" id="lastName" value="<%=ocanStaffForm.getLastName()%>" class="{validate: {required:true}}"/>
			</td>			
		</tr>
		<tr>
			<td class="genericTableHeader">Middle Initial</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"middle",1,30, prepopulationLevel)%>
			</td>			
		</tr>
		<tr>
			<td class="genericTableHeader">First Name</td>
			<td class="genericTableData">
				<input type="text" name="firstName" id="firstName" value="<%=ocanStaffForm.getFirstName()%>" class="{validate: {required:true}}"/>
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Preferred Name</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"preferred",1,30, prepopulationLevel)%>
			</td>
		</tr>			
		<tr>
			<td class="genericTableHeader">Address Line 1</td>
			<td class="genericTableData">
				<input type="text" name="addressLine1" id="addressLine1" value="<%=ocanStaffForm.getAddressLine1()%>" />
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 2</td>
			<td class="genericTableData">
				<input type="text" name="addressLine2" id="addressLine2" value="<%=ocanStaffForm.getAddressLine2()%>" />
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">City</td>
			<td class="genericTableData">
				<input type="text" name="city" id="city" value="<%=ocanStaffForm.getCity()%>" />
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">Province</td>
			<td class="genericTableData">
				<select name="province">
					<%=OcanForm.renderAsProvinceSelectOptions(ocanStaffForm)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Postal Code</td>
			<td class="genericTableData">
				<input type="text" name="postalCode" id="postalCode" value="<%=ocanStaffForm.getPostalCode()%>" class="{validate: {postalCode:true}}"/>
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">Phone Number</td>
			<td class="genericTableData">
				<input type="text" name="phoneNumber" id="phoneNumber" value="<%=ocanStaffForm.getPhoneNumber()%>" />
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Ext: </td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"extension",1,30, prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Email address</td>
			<td class="genericTableData">
				<input type="text" name="email" id="email" value="<%=ocanStaffForm.getEmail()%>" />
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Date of Birth (YYYY-MM-DD)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "date_of_birth",false,prepopulationLevel)%>				
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Date of Birth</td>
			<td class="genericTableData">
				<select name="clientDOBType" id="clientDOBType" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "clientDOBType", OcanForm.getOcanFormOptions("client DOB Type"),prepopulationLevel)%>
				</select>	
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Health Card # and Version Code</td>
			<td class="genericTableData">
				<input type="text" name="hcNumber" id="hcNumber" value="<%=ocanStaffForm.getHcNumber()%>" />
				<input type="text" name="hcVersion" id="hcVersion" value="<%=ocanStaffForm.getHcVersion()%>" />
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Issuing Territory</td>
			<td class="genericTableData">
				<select name="issuingTerritory">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "issuingTerritory", OcanForm.getOcanFormOptions("Province List"),prepopulationLevel)%>
				</select>				
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Service Recipient Location</td>
			<td class="genericTableData">
				<select name="service_recipient_location" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "service_recipient_location", OcanForm.getOcanFormOptions("Recipient Location"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">LHIN Consumer Resides in</td>
			<td class="genericTableData">
				<select name="service_recipient_lhin" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "service_recipient_lhin", OcanForm.getOcanFormOptions("LHIN code"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		
		<tr>
			<td class="genericTableHeader">Gender</td>
			<td class="genericTableData">
				<select name="gender" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "gender", OcanForm.getOcanFormOptions("Administrative Gender"),ocanStaffForm.getGender(),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">Marital Status</td>
			<td class="genericTableData">
				<select name="marital_status">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "marital_status", OcanForm.getOcanFormOptions("Marital Status"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		<tr>
			<td colspan="2">Mental Health Functional Centre Use (for the last 6 Months)</td>
		</tr>
		
		
		
		
		
		
		
		
		
		<tr>
			<td class="genericTableHeader">Number of Mental Health Functional Centres?</td>
			<td class="genericTableData">
				<select name="center_count" id="center_count" onchange="changeNumberOfcentres();" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "center_count", OcanForm.getOcanFormOptions("Number Of Centres"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
			
		<tr>
			<td colspan="2">				
				<div id="center_block">
					<!-- results from adding/removing mental health functional centre will go into this block -->
				</div>
			</td>
		</tr>	
		
			
		<tr>
			<td colspan="2"></td>
		</tr>
		<tr>
			<td class="genericTableHeader">Family Doctor Information</td>
			<td class="genericTableData">
				<select name="familyDoctor">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "familyDoctor", OcanForm.getOcanFormOptions("Doctor Psychiatrist"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Name</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"familyDoctorName",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 1</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"familyDoctorAddress1",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 2</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"familyDoctorAddress2",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">City</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"familyDoctorCity",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Province</td>
			<td class="genericTableData">
				<select name="familyDoctorProvince">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "familyDoctorProvince", OcanForm.getOcanFormOptions("Province List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Postal Code</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"familyDoctorPostalCode",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Phone Number</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"familyDoctorPhoneNumber",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"familyDoctorPhoneNumberExt",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Email Address</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"familyDoctorEmail",1,30,prepopulationLevel)%>
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Family Doctor - Last Seen</td>
			<td class="genericTableData">
				<select name="famliyDoctorLastSeen">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "famliyDoctorLastSeen", OcanForm.getOcanFormOptions("Last Seen"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td colspan="2"></td>
		</tr>
		<tr>
			<td class="genericTableHeader">Psychiatrist Information</td>
			<td class="genericTableData">
				<select name="psychiatrist">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "psychiatrist", OcanForm.getOcanFormOptions("Doctor Psychiatrist"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Name</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"psychiatristName",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 1</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"psychiatristAddress1",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 2</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"psychiatristAddress2",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">City</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"psychiatristCity",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Province</td>
			<td class="genericTableData">
				<select name="psychiatristProvince">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "psychiatristProvince", OcanForm.getOcanFormOptions("Province List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Postal Code</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"psychiatristPostalCode",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Phone Number</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"psychiatristPhoneNumber",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"psychiatristPhoneNumberExt",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Email Address</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"psychiatristEmail",1,30,prepopulationLevel)%>
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">Psychiatrist - Last Seen</td>
			<td class="genericTableData">
				<select name="psychiatristLastSeen">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "psychiatristLastSeen", OcanForm.getOcanFormOptions("Last Seen"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td colspan="2"></td>
		</tr>
		<tr>
			<td class="genericTableHeader">Other Contact</td>
			<td class="genericTableData">
				<select name="otherContact" id="otherContact" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "otherContact", OcanForm.getOcanFormOptions("Other Contacts Agency"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
		<tr>
			<td class="genericTableHeader">Contact Type</td>
			<td class="genericTableData">
				<select name="1_otherContactType" id="1_otherContactType" >
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_otherContactType", OcanForm.getOcanFormOptions("Practioner List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Name</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherContactName",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 1</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherContactAddress1",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 2</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherContactAddress2",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">City</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherContactCity",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Province</td>
			<td class="genericTableData">
				<select name="1_otherContactProvince" id="1_otherContactProvince">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_otherContactProvince", OcanForm.getOcanFormOptions("Province List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Postal Code</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherContactPostalCode",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Phone Number</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherContactPhoneNumber",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherContactPhoneNumberExt",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Email Address</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherContactEmail",1,30,prepopulationLevel)%>
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">Other Contact - Last Seen</td>
			<td class="genericTableData">
				<select name="1_otherContactLastSeen" id="1_otherContactLastSeen">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_otherContactLastSeen", OcanForm.getOcanFormOptions("Last Seen"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Contact Type</td>
			<td class="genericTableData">
				<select name="2_otherContactType" id="2_otherContactType">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "2_otherContactType", OcanForm.getOcanFormOptions("Practioner List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Name</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherContactName",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 1</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherContactAddress1",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 2</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherContactAddress2",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">City</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherContactCity",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Province</td>
			<td class="genericTableData">
				<select name="2_otherContactProvince" id="2_otherContactProvince">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "2_otherContactProvince", OcanForm.getOcanFormOptions("Province List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Postal Code</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherContactPostalCode",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Phone Number</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherContactPhoneNumber",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherContactPhoneNumberExt",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Email Address</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherContactEmail",1,30,prepopulationLevel)%>
			</td>
		</tr>			
		<tr>
			<td class="genericTableHeader">Other Contact - Last Seen</td>
			<td class="genericTableData">
				<select name="2_otherContactLastSeen" id="2_otherContactLastSeen">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "2_otherContactLastSeen", OcanForm.getOcanFormOptions("Last Seen"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>		
		
		<tr>
			<td colspan="2"></td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Contact Type</td>
			<td class="genericTableData">
				<select name="3_otherContactType" id="3_otherContactType">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "3_otherContactType", OcanForm.getOcanFormOptions("Practioner List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Name</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherContactName",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 1</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherContactAddress1",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 2</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherContactAddress2",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">City</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherContactCity",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Province</td>
			<td class="genericTableData">
				<select name="3_otherContactProvince" id="3_otherContactProvince">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "3_otherContactProvince", OcanForm.getOcanFormOptions("Province List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Postal Code</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherContactPostalCode",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Phone Number</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherContactPhoneNumber",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherContactPhoneNumberExt",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Email Address</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherContactEmail",1,30,prepopulationLevel)%>
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">Other Contact - Last Seen</td>
			<td class="genericTableData">
				<select name="3_otherContactLastSeen" id="3_otherContactLastSeen">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "3_otherContactLastSeen", OcanForm.getOcanFormOptions("Last Seen"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
						
		<tr>
			<td class="genericTableHeader">Other Agency</td>
			<td class="genericTableData">
				<select name="otherAgency" id="otherAgency" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "otherAgency", OcanForm.getOcanFormOptions("Other Contacts Agency"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
		<tr>
			<td class="genericTableHeader">Name</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherAgencyName",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 1</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherAgencyAddress1",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 2</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherAgencyAddress2",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">City</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherAgencyCity",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Province</td>
			<td class="genericTableData">
				<select name="1_otherAgencyProvince" id="1_otherAgencyProvince">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_otherAgencyProvince", OcanForm.getOcanFormOptions("Province List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Postal Code</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherAgencyPostalCode",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Phone Number</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherAgencyPhoneNumber",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherAgencyPhoneNumberExt",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Email Address</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_otherAgencyEmail",1,30,prepopulationLevel)%>
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Other Agency - Last Seen</td>
			<td class="genericTableData">
				<select name="1_otherAgencyLastSeen" id="1_otherAgencyLastSeen">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_otherAgencyLastSeen", OcanForm.getOcanFormOptions("Last Seen"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
			
		
		<tr>
			<td class="genericTableHeader">Name</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherAgencyName",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 1</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherAgencyAddress1",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 2</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherAgencyAddress2",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">City</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherAgencyCity",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Province</td>
			<td class="genericTableData">
				<select name="2_otherAgencyProvince" id="2_otherAgencyProvince">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "2_otherAgencyProvince", OcanForm.getOcanFormOptions("Province List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Postal Code</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherAgencyPostalCode",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Phone Number</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherAgencyPhoneNumber",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherAgencyPhoneNumberExt",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Email Address</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_otherAgencyEmail",1,30,prepopulationLevel)%>
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Other Agency - Last Seen</td>
			<td class="genericTableData">
				<select name="2_otherAgencyLastSeen" id="2_otherAgencyLastSeen">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "2_otherAgencyLastSeen", OcanForm.getOcanFormOptions("Last Seen"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Name</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherAgencyName",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 1</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherAgencyAddress1",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Address Line 2</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherAgencyAddress2",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">City</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherAgencyCity",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Province</td>
			<td class="genericTableData">
				<select name="3_otherAgencyProvince" id="3_otherAgencyProvince">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "3_otherAgencyProvince", OcanForm.getOcanFormOptions("Province List"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Postal Code</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherAgencyPostalCode",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Phone Number</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherAgencyPhoneNumber",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherAgencyPhoneNumberExt",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Email Address</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_otherAgencyEmail",1,30,prepopulationLevel)%>
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Other Agency - Last Seen</td>
			<td class="genericTableData">
				<select name="3_otherAgencyLastSeen" id="3_otherAgencyLastSeen">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "3_otherAgencyLastSeen", OcanForm.getOcanFormOptions("Last Seen"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
		
			
		
		<tr>
			<td colspan="2">Client Capacity</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Power of Attorney for Property</td>
			<td class="genericTableData">
				<select name="power_attorney_property" id="power_attorney_property">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "power_attorney_property", OcanForm.getOcanFormOptions("Client Capacity"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Power of Attorney</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"power_attorney_property_name",1,30,prepopulationLevel)%>
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Address (Power of Attorney)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"power_attorney_property_address",1,30,prepopulationLevel)%>
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Phone (Power of Attorney)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"power_attorney_property_phone",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext: </td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"power_attorney_property_phoneExt",1,30,prepopulationLevel)%>
			</td>
		</tr>		
		
		<tr>
			<td class="genericTableHeader">Power of Attorney for Personal Care</td>
			<td class="genericTableData">
				<select name="power_attorney_personal_care" id="power_attorney_personal_care">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "power_attorney_personal_care", OcanForm.getOcanFormOptions("Client Capacity"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>			
		<tr>
			<td class="genericTableHeader">Power of Attorney or SDM Name (Personal Care)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"power_attorney_personal_care_name",1,30,prepopulationLevel)%>
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Address (Personal Care)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"power_attorney_personal_care_address",1,30,prepopulationLevel)%>
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Phone (Personal Care)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"power_attorney_personal_care_phone",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext: </td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"power_attorney_personal_care_phoneExt",1,30,prepopulationLevel)%>
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Guardian</td>
			<td class="genericTableData">
				<select name="court_appointed_guardian" id="court_appointed_guardian">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "court_appointed_guardian", OcanForm.getOcanFormOptions("Client Capacity"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Name (Guardian)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"guardian_name",1,30,prepopulationLevel)%>
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Address (Guardian)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"guardian_address",1,30,prepopulationLevel)%>
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Phone (Guardian)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"guardian_phone",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Ext: </td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"guardian_phoneExt",1,30,prepopulationLevel)%>
			</td>
		</tr>
		
		<tr>
			<td colspan="2"> Areas of Concern</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Finance/Property</td>
			<td class="genericTableData">
				<select name="financeProperty" id="financeProperty">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "financeProperty", OcanForm.getOcanFormOptions("Areas Of Concern"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Treatment Decisions</td>
			<td class="genericTableData">
				<select name="treatmentDecisions" id="treatmentDecisions">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "treatmentDecisions", OcanForm.getOcanFormOptions("Areas Of Concern"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Age in Years for Onset of Mental Illness </td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"ageOnsetMental_year",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<!-- duplication? removed. 
		<tr>
			<td class="genericTableHeader">Age in Months for Onset of Mental Illness </td>
			<td class="genericTableData">
				<select name="ageOnsetMental_month" id="ageOnsetMental_month">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "ageOnsetMental_month", OcanForm.getOcanFormOptions("Age in Months"),prepopulationLevel)%>
				</select>	
			</td>
		</tr>
		-->
		<tr>
			<td class="genericTableHeader">Age in Years for Onset of Mental Illness</td>
			<td class="genericTableData">
				<select name="ageTypeOnsetMental" id="ageTypeOnsetMental">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "ageTypeOnsetMental", OcanForm.getOcanFormOptions("Age of Onset"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Age of first Psychiatric Hospitalization </td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"ageHospitalization_year",1,30,prepopulationLevel)%>
			</td>
		</tr>
		<!-- duplication? removed.
		<tr>
			<td class="genericTableHeader">Age in Months for Psychiatric Hospitalization </td>
			<td class="genericTableData">
				<select name="ageHospitalization_month" id="ageHospitalization_month">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "ageHospitalization_month", OcanForm.getOcanFormOptions("Age in Months"),prepopulationLevel)%>
				</select>	
			</td>
		</tr>
		 -->
		<tr>
			<td class="genericTableHeader">Age of first Psychiatric Hospitalization</td>
			<td class="genericTableData">
				<select name="ageTypeHospitalization" id="ageTypeHospitalization">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "ageTypeHospitalization", OcanForm.getOcanFormOptions("Age of Onset"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Date (YYYY-MM) when Consumer first entered your Organization</td>
			<td class="genericTableData">
			Year: 
				<select name="year_firstEntryDate">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "year_firstEntryDate", OcanForm.getOcanFormOptions("Year of First Entry Date"),prepopulationLevel)%>
				</select>
			&nbsp;&nbsp;
			Month:
				<select name="month_firstEntryDate">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "month_firstEntryDate", OcanForm.getOcanFormOptions("Month of First Entry Date"),prepopulationLevel)%>
				</select>		
			</td>
			
			
		</tr>	
		<tr>
			<td class="genericTableHeader">Date (YYYY-MM) when Consumer first entered your Organization</td>
			<td class="genericTableData">
				<select name="firstEntryDateType" id="firstEntryDateType">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "firstEntryDateType", OcanForm.getOcanFormOptions("Age of Entry To Org"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">What culture do you (Consumer) identify with?</td>
			<td class="genericTableData">
				<select name="culture">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "culture", OcanForm.getOcanFormOptions("Ethniticity"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Aboriginal Origin?</td>
			<td class="genericTableData">
				<select name="aboriginal" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "aboriginal", OcanForm.getOcanFormOptions("Aboriginal Origin"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>		

		<tr>
			<td class="genericTableHeader">Citizenship Status?</td>
			<td class="genericTableData">
				<select name="citizenship_status">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "citizenship_status", OcanForm.getOcanFormOptions("Citizenship Status"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Length of time lived in Canada?</td>
			<td class="genericTableData">
			Years: 
				<select name="years_in_canada">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "years_in_canada", OcanForm.getOcanFormOptions("Years in Canada"),prepopulationLevel)%>
				</select>
			&nbsp;&nbsp;
			Months:
				<select name="months_in_canada">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "months_in_canada", OcanForm.getOcanFormOptions("Months in Canada"),prepopulationLevel)%>
				</select>		
			</td>
		</tr>				
		<tr>
			<td class="genericTableHeader">Can you tell me about your immigration experience?</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"immigration_experience",5,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Do you have any issues with your immigration experience? (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "immigration_issues", OcanForm.getOcanFormOptions("Immigration Experience"),prepopulationLevel)%>						
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Immigration Issues - Other</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"immigration_issues_other",5,30,prepopulationLevel)%>
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Do you have any experience of discrimination? (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "discrimination", OcanForm.getOcanFormOptions("Discrimination Experience"),prepopulationLevel)%>						
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Discrimination - Other</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"discrimination_other",5,30,prepopulationLevel)%>
			</td>
		</tr>						
		
		<tr>
			<td class="genericTableHeader">Service recipient preferred language?</td>
			<td class="genericTableData">
				<select name="preferred_language" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "preferred_language", OcanForm.getOcanFormOptions("Language"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Language of Service Provision?</td>
			<td class="genericTableData">
				<select name="language_service_provision" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "language_service_provision", OcanForm.getOcanFormOptions("Language"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
	 	
		<tr>
			<td class="genericTableHeader">Do you currently have any legal issues</td>
			<td class="genericTableData">
				<select name="legal_issues">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "legal_issues", OcanForm.getOcanFormOptions("Legal Issues"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		 												
		<tr>
			<td class="genericTableHeader">Current legal status (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderLegalStatusOptions(ocanStaffForm.getId(), "legal_status", OcanForm.getOcanFormOptions("Legal History Type"),prepopulationLevel,false)%>						
			</td>
		</tr>		
	  
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"commments",5,30,prepopulationLevel)%>
			</td>
		</tr>						
	 	
		<tr>
			<td colspan="2">1. Accommodation</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person lack a current place to stay?</td>
			<td class="genericTableData">
				<select name="1_1" id="1_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with accommodation does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="1_2" id="1_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with accommodation does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="1_3a" id="1_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with accommodation does the person need from local services?</td>
			<td class="genericTableData">
				<select name="1_3b" id="1_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"1_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "1_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "1_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Where do you live?</td>
			<td class="genericTableData">
				<select name="1_where_live" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_where_live", OcanForm.getOcanFormOptions("Residence Type"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>		
		
		<tr>
			<td class="genericTableHeader">Where do you live - Other</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "1_where_live_other", 25,prepopulationLevel)%>						
			</td>
		</tr>	
				
		<tr>
			<td class="genericTableHeader">Do you receive any support?</td>
			<td class="genericTableData">
				<select name="1_any_support" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_any_support", OcanForm.getOcanFormOptions("Residential Support"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Do you live with anyone?</td>
			<td class="genericTableData">
				<select name="1_live_with_anyone" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "1_live_with_anyone", OcanForm.getOcanFormOptions("Living Arrangement Type"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>				
	
		<tr>
			<td colspan="2">2. Food</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have difficulty in getting enough to eat?</td>
			<td class="genericTableData">
				<select name="2_1" id="2_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "2_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with getting enough to eat does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="2_2" id="2_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "2_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with getting enough to eat does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="2_3a" id="2_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "2_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with getting enough to eat does the person need from local services?</td>
			<td class="genericTableData">
				<select name="2_3b" id="2_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "2_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"2_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "2_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "2_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>							
	
	
		<tr>
			<td colspan="2">3. Looking after the home</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have difficulty looking after the home?</td>
			<td class="genericTableData">
				<select name="3_1" id="3_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "3_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with looking after the home does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="3_2" id="3_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "3_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with looking after the home does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="3_3a" id="3_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "3_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with looking after the home does the person need from local services?</td>
			<td class="genericTableData">
				<select name="3_3b" id="3_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "3_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"3_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "3_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "3_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>			
	
		<tr>
			<td colspan="2">4. Self-care</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have difficulty with self-care?</td>
			<td class="genericTableData">
				<select name="4_1" id="4_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "4_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with self-care does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="4_2" id="4_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "4_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with self-care does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="4_3a" id="4_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "4_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with self-care does the person need from local services?</td>
			<td class="genericTableData">
				<select name="4_3b" id="4_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "4_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"4_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"4_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "4_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "4_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>			
		
	
		<tr>
			<td colspan="2">5. Daytime activities</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have difficulty with regular, appropriate daytime activities?</td>
			<td class="genericTableData">
				<select name="5_1" id="5_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "5_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help does the person receive from friends or relatives in finding and keeping regular and appropriate daytime activities?</td>
			<td class="genericTableData">
				<select name="5_2" id="5_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "5_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services in finding and keeping regular and appropriate daytime activities?</td>
			<td class="genericTableData">
				<select name="5_3a" id="5_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "5_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help does the person need from local services in finding and keeping regular and appropriate daytime activities?</td>
			<td class="genericTableData">
				<select name="5_3b" id="5_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "5_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"5_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"5_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "5_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "5_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>		
	
		<tr>
			<td class="genericTableHeader">What is your current employment status?</td>
			<td class="genericTableData">
				<select name="5_current_employment_status" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "5_current_employment_status", OcanForm.getOcanFormOptions("Employment Status"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Are you currently in school?</td>
			<td class="genericTableData">
				<select name="5_education_program_status" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "5_education_program_status", OcanForm.getOcanFormOptions("Education Program Status"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Are you currently in school - Other</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(), "5_education_program_status_other", 3,50,prepopulationLevel)%>						
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Barriers in finding and/or maintaining a work/volunteer/education role (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "5_barriersFindingWork", OcanForm.getOcanFormOptions("Barriers"),prepopulationLevel)%>						
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Barriers - Other</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(), "5_barriersFindingWork_Other", 3,50,prepopulationLevel)%>						
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Barriers - Comments</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(), "5_barriersFindingWork_Comments", 3,50,prepopulationLevel)%>						
			</td>
		</tr>
		
	
		<tr>
			<td colspan="2">6. Physical health</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have any physical disability or any physical illness?</td>
			<td class="genericTableData">
				<select name="6_1" id="6_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "6_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help does the person receive from friends or relatives for physical health problems?</td>
			<td class="genericTableData">
				<select name="6_2" id="6_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "6_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services for physical health problems?</td>
			<td class="genericTableData">
				<select name="6_3a" id="6_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "6_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help does the person need from local services for physical health problems?</td>
			<td class="genericTableData">
				<select name="6_3b" id="6_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "6_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"6_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"6_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "6_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "6_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>						
				
		<tr>
			<td class="genericTableHeader">Medical Conditions? (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "6_medical_conditions", OcanForm.getOcanFormOptions("Medical Conditions"),prepopulationLevel)%>						
			</td>
		</tr>					
		<tr>
			<td class="genericTableHeader">Medical Conditions - Specify (Autism)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"6_medical_conditions_autism",5,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Medical Conditions - Other</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"6_medical_conditions_other",5,30,prepopulationLevel)%>
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Medical Conditions - Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"6_medical_conditions_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>					
		<tr>
			<td class="genericTableHeader">Do you have any concerns about your physical health?</td>
			<td class="genericTableData">
				<select name="6_3b" id="6_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "6_physical_health_concerns", OcanForm.getOcanFormOptions("Physical Health Concerns"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>			
		<tr>
			<td class="genericTableHeader">If Yes, please indicate the areas where you have concerns (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "6_physical_health_details", OcanForm.getOcanFormOptions("Concerns Detail"),prepopulationLevel)%>						
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">If Yes, please indicate the areas where you have concerns - Other</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"6_physical_health_details_other",5,30,prepopulationLevel)%>
			</td>
		</tr>								
	
		<tr>
			<td colspan="2">
<p>List of all current medications (including prescribed and alternative/over the counter medication)
This information is collected from a variety of sources, including self-report, and should be confirmed by a qualified prescribing practitioner.
</p>
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">Medications - Additional Information</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"medications_additionalInfo",5,30,prepopulationLevel)%>
			</td>
		</tr>	

		<tr>
			<td class="genericTableHeader">Number of Medications?</td>
			<td class="genericTableData">
				<select name="medications_count" id="medications_count" onchange="changeNumberOfMedications();">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "medications_count", OcanForm.getOcanFormOptions("Years in Canada"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		<tr>
			<td colspan="2">				
				<div id="medication_block">
					<!-- results from adding/removing medication will go into this block -->
				</div>
			</td>
		</tr>		 
			
		<tr>
			<td colspan="2">7. Psychotic Symptoms</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have any psychotic symptoms?</td>
			<td class="genericTableData">
				<select name="7_1"  id="7_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "7_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2.  How much help does the person receive from friends or relatives for these psychotic symptoms?</td>
			<td class="genericTableData">
				<select name="7_2" id="7_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "7_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services for these psychotic symptoms?</td>
			<td class="genericTableData">
				<select name="7_3a" id="7_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "7_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b.  How much help does the person need from local services for these psychotic symptoms?</td>
			<td class="genericTableData">
				<select name="7_3b" id="7_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "7_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"7_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"7_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "7_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "7_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>	
		
		<tr>
			<td colspan="2">Psychiatric History</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Have you been hospitalized due to your mental health during the past two years?</td>
			<td class="genericTableData">
				<select name="hospitalized_mental_illness" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "hospitalized_mental_illness", OcanForm.getOcanFormOptions("Hospitalized Mental Illness"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>			
		<tr>
			<td class="genericTableHeader">If Yes, Total Number of Admissions for Mental Health Reasons</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "hospitalized_mental_illness_admissions", 25,prepopulationLevel)%>						
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">If Yes, Total Number of Hospitalization Days for Mental Health Reasons</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "hospitalized_mental_illness_days", 25,prepopulationLevel)%>						
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">How many times did you visit an Emergency Department in the last 6 months for Mental Health Reasons?</td>
			<td class="genericTableData">
				<select name="visitEmergencyDepartment" id="visitEmergencyDepartment" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "visitEmergencyDepartment", OcanForm.getOcanFormOptions("Emergency Department"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>		
				
		<tr>
			<td class="genericTableHeader">Community Treatment Orders</td>
			<td class="genericTableData">
				<select name="community_treatment_orders" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "community_treatment_orders", OcanForm.getOcanFormOptions("Community Treatment Orders"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Psychiatric History - Additional Information</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"7_psychiatric_history_addl_info",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		<tr>
			<td class="genericTableHeader">Symptoms (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "symptom_checklist", OcanForm.getOcanFormOptions("Symptoms Checklist"),prepopulationLevel)%>						
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Symptom Checklist - Other</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"symptom_checklist_other",5,30,prepopulationLevel)%>
			</td>
		</tr>										



		<tr>
			<td colspan="2">8. Information on condition and treatment</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Has the person had clear verbal or written information about condition and treatment?</td>
			<td class="genericTableData">
				<select name="8_1" id="8_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "8_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help does the person receive from friends or relatives in obtaining such information?</td>
			<td class="genericTableData">
				<select name="8_2" id="8_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "8_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services in obtaining such information? </td>
			<td class="genericTableData">
				<select name="8_3a" id="8_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "8_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b.  How much help does the person need from local services in obtaining such information?</td>
			<td class="genericTableData">
				<select name="8_3b" id="8_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "8_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"8_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"8_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "8_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "8_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>	

		<tr>
			<td class="genericTableHeader">Diagnostic Categories (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "diagnostic_categories", OcanForm.getOcanFormOptions("Diagnostic Categories"),prepopulationLevel)%>						
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Other Illness Information (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "other_illness", OcanForm.getOcanFormOptions("Diagnostic - Other Illness"),prepopulationLevel)%>						
			</td>
		</tr>		



		<tr>
			<td colspan="2">9. Psychological Distress</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person suffer from current psychological distress?</td>
			<td class="genericTableData">
				<select name="9_1"  id="9_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "9_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help does the person receive from friends or relatives for this distress?</td>
			<td class="genericTableData">
				<select name="9_2" id="9_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "9_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services for this distress?</td>
			<td class="genericTableData">
				<select name="9_3a" id="9_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "9_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help does the person need from local services for this distress?</td>
			<td class="genericTableData">
				<select name="9_3b" id="9_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "9_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"9_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"9_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "9_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "9_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>	


		
		<tr>
			<td colspan="2">10. Safefy to self</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Is the person a danger to him- or herself?</td>
			<td class="genericTableData">
				<select name="10_1" id="10_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "10_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2.  How much help does the person receive from friends or relatives to reduce the risk of self-harm?</td>
			<td class="genericTableData">
				<select name="10_2" id="10_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "10_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services to reduce the risk of self-harm?</td>
			<td class="genericTableData">
				<select name="10_3a" id="10_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "10_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help does the person need from local services to reduce the risk of self-harm?</td>
			<td class="genericTableData">
				<select name="10_3b" id="10_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "10_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"10_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"10_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "10_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "10_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>


		<tr>
			<td class="genericTableHeader">Have you attempted suicide in the past?</td>
			<td class="genericTableData">
				<select name="suicide_past">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "suicide_past", OcanForm.getOcanFormOptions("Suicide in Past"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>					
		
		<tr>
			<td class="genericTableHeader">Do you have any concerns for your own safety?</td>
			<td class="genericTableData">
				<select name="safety_concerns">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "safety_concerns", OcanForm.getOcanFormOptions("Own Safety Concerns"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Do you currently have suicidal thoughts?</td>
			<td class="genericTableData">
				<select name="suicidal_thoughts">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "suicidal_thoughts", OcanForm.getOcanFormOptions("Suicidal Thoughts"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>														
		<tr>
			<td class="genericTableHeader">Risks (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "risks", OcanForm.getOcanFormOptions("Risks List"),prepopulationLevel)%>						
			</td>
		</tr>		
		<tr>
			<td class="genericTableHeader">Risks - Other</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"risks_other",5,30,prepopulationLevel)%>
			</td>
		</tr>			
					
					
					
		<tr>
			<td colspan="2">11. Safefy to others</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Is the person a current or potential risk to other's people safety?</td>
			<td class="genericTableData">
				<select name="11_1" id="11_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "11_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help does the person receive from friends or relatives to reduce the risk that he or she might harm someone else? </td>
			<td class="genericTableData">
				<select name="11_2" id="11_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "11_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a.  How much help does the person receive from local services to reduce the risk that he or she might harm someone else?</td>
			<td class="genericTableData">
				<select name="11_3a" id="11_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "11_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help does the person need from local services to reduce the risk that he or she might harm someone else?</td>
			<td class="genericTableData">
				<select name="11_3b" id="11_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "11_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"11_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"11_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "11_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "11_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>					


					
					
		<tr>
			<td colspan="2">12. Alcohol</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1.  Does the person drink excessively, or have a problem controlling his or her drinking?</td>
			<td class="genericTableData">
				<select name="12_1" id="12_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "12_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help does the person receive from friends or relatives for this drinking?</td>
			<td class="genericTableData">
				<select name="12_2" id="12_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "12_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services for this drinking?</td>
			<td class="genericTableData">
				<select name="12_3a" id="12_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "12_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help does the person need from local services for this drinking?</td>
			<td class="genericTableData">
				<select name="12_3b" id="12_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "12_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"12_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"12_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "12_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "12_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>					
					
		<tr>
			<td class="genericTableHeader">Number of Drinks</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "num_drinks", 25,prepopulationLevel)%>						
			</td>
		</tr>							
					
		<tr>
			<td class="genericTableHeader">How often do you drink alcohol?</td>
			<td class="genericTableData">
				<select name="frequency_alcohol">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "frequency_alcohol", OcanForm.getOcanFormOptions("Frequency of Alcohol Use"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Indicate the stage of change client is at - Optional</td>
			<td class="genericTableData">
				<select name="state_of_change_alcohol">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "state_of_change_alcohol", OcanForm.getOcanFormOptions("Stage of Change - Alcohol"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>								
		<tr>
			<td class="genericTableHeader">How has drinking had an impact on your life?</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"drinking_impact",5,30,prepopulationLevel)%>
			</td>
		</tr>				
					
		<tr>
			<td colspan="2">13. Drugs</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have problems with drug misuse?</td>
			<td class="genericTableData">
				<select name="13_1" id="13_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "13_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with drug misuse does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="13_2" id="13_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "13_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with drug misuse does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="13_3a" id="13_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "13_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with drug misuse does the person need from local services?</td>
			<td class="genericTableData">
				<select name="13_3b" id="13_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "13_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"13_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"13_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "13_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "13_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>					
							
		<tr>
			<td class="genericTableHeader">Which of the following drugs have you used? (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDrugUseCheckBoxOptions(ocanStaffForm.getId(), "drug_list", OcanForm.getOcanFormOptions("Drug List"),prepopulationLevel)%>						
			</td>
		</tr>	
					
		<tr>
			<td class="genericTableHeader">Which of the following drugs have you used? - Frequency</td>
			<td class="genericTableData">
				<select name="drugUse_frequency">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "drugUse_frequency", OcanForm.getOcanFormOptions("Frequency of Drug Use"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">Has the substance been injected?</td>
			<td class="genericTableData">
				<select name="drugUse_rejected">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "drugUse_rejected", OcanForm.getOcanFormOptions("Frequency of Drug Use"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">Indicate the stage of change client is at - Optional</td>
			<td class="genericTableData">
				<select name="state_of_change_addiction">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "state_of_change_addiction", OcanForm.getOcanFormOptions("Stage of Change - Alcohol"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>			
										
		<tr>
			<td class="genericTableHeader">How has the substance(s) of choice had an impact on your life?</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"drug_impact",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
			
		<tr>
			<td colspan="2">14. Other Addictions</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have problems with addictions?</td>
			<td class="genericTableData">
				<select name="14_1" id="14_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "14_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with addictions does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="14_2" id="14_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "14_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a.How much help with addictions does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="14_3a"  id="14_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "14_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with addictions does the person need from local services?</td>
			<td class="genericTableData">
				<select name="14_3b" id="14_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "14_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"14_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"14_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "14_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "14_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>			
		<tr>
			<td class="genericTableHeader">Type of Addiction (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "addiction_type", OcanForm.getOcanFormOptions("Addiction Type"),prepopulationLevel)%>						
			</td>
		</tr>	
		<tr>
			<td class="genericTableHeader">Type of Addiction - Other</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"addiction_type_other",5,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Indicate the stage of change client is at - Optional</td>
			<td class="genericTableData">
				<select name="state_of_change_addiction">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "14_state_of_change", OcanForm.getOcanFormOptions("Stage of Change - Alcohol"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>			
										
		<tr>
			<td class="genericTableHeader">How has the addiction had an impact on your life?</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"addiction_impact",5,30,prepopulationLevel)%>
			</td>
		</tr>			
								
		
		
		
		<tr>
			<td colspan="2">15. Company</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1.  Does the person need help with social contact?</td>
			<td class="genericTableData">
				<select name="15_1" id="15_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "15_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with social contact does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="15_2" id="15_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "15_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services in organizing social contact?</td>
			<td class="genericTableData">
				<select name="15_3a" id="15_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "15_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help does the person need from local services in organizing social contact?</td>
			<td class="genericTableData">
				<select name="15_3b" id="15_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "15_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"15_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"15_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "15_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "15_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Have there been any changes to your social patterns recently?</td>
			<td class="genericTableData">
				<select name="social_patterns">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "social_patterns", OcanForm.getOcanFormOptions("Social Patterns Changes"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>			
		
		<tr>
			<td colspan="2">16. Intimate relationships</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1.  Does the person have any difficulty in finding a partner or in maintaining a close relationship?</td>
			<td class="genericTableData">
				<select name="16_1" id="16_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "16_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with forming and maintaining close relationships does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="16_2" id="16_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "16_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with forming and maintaining close relationships does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="16_3a" id="16_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "16_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with forming and maintaining close relationships does the person need from local services?</td>
			<td class="genericTableData">
				<select name="16_3b" id="16_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "16_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"16_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"16_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "16_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "16_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>		
		
			
		<tr>
			<td colspan="2">17. Sexual Expression</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have problems with his or her sex life?</td>
			<td class="genericTableData">
				<select name="17_1" id="17_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "17_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with problems in his or her sex life does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="17_2" id="17_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "17_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with problems in his or her sex life does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="17_3a" id="17_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "17_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with problems in his or her sex life does the person need from local services?</td>
			<td class="genericTableData">
				<select name="17_3b" id="17_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "17_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"17_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"17_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "17_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "17_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>	
		
		
		<tr>
			<td colspan="2">18. Child care</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have difficulty looking after his or her children?</td>
			<td class="genericTableData">
				<select name="18_1" id="18_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "18_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with looking after the children does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="18_2" id="18_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "18_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with looking after the children does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="18_3a" id="18_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "18_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with looking after the children does the person need from local services?</td>
			<td class="genericTableData">
				<select name="18_3b" id="18_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "18_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"18_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"18_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "18_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "18_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>			


		<tr>
			<td colspan="2">19. Other dependents</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have difficulty looking after other dependents?</td>
			<td class="genericTableData">
				<select name="19_1" id="19_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "19_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with looking after other dependants does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="19_2" id="19_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "19_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with looking after other dependents does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="19_3a" id="19_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "19_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with looking after other dependents does the person need from local services?</td>
			<td class="genericTableData">
				<select name="19_3b" id="19_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "19_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"19_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"19_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "19_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "19_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>


		<tr>
			<td colspan="2">20. Basic education</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person lack basic skills in numeracy and literacy?</td>
			<td class="genericTableData">
				<select name="20_1" id="20_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "20_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with numeracy and literacy does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="20_2" id="20_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "20_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with numeracy and literacy does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="20_3a" id="20_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "20_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with numeracy and literacy does the person need from local services?</td>
			<td class="genericTableData">
				<select name="20_3b" id="20_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "20_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"20_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"20_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "20_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "20_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>	
		
		<tr>
			<td class="genericTableHeader">What is your highest level of education?</td>
			<td class="genericTableData">
				<select name="level_of_education" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "level_of_education", OcanForm.getOcanFormOptions("Education Level"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		
		
		<tr>
			<td colspan="2">21. Telephone</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person lack basic skills in getting access to or using a telephone?</td>
			<td class="genericTableData">
				<select name="21_1" id="21_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "21_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help does the person receive from friends or relatives to make telephone calls?</td>
			<td class="genericTableData">
				<select name="21_2" id="21_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "21_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services to make telephone calls?</td>
			<td class="genericTableData">
				<select name="21_3a" id="21_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "21_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help does the person need from local services to make telephone calls?</td>
			<td class="genericTableData">
				<select name="21_3b" id="21_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "21_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"21_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"21_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "21_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "21_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>		
		
							
							
		<tr>
			<td colspan="2">22. Transport</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have any problems using public transport?</td>
			<td class="genericTableData">
				<select name="22_1" id="22_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "22_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help with traveling does the person receive from friends or relatives?</td>
			<td class="genericTableData">
				<select name="22_2" id="22_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "22_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help with traveling does the person receive from local services?</td>
			<td class="genericTableData">
				<select name="22_3a" id="22_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "22_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help with traveling does the person need from local services?</td>
			<td class="genericTableData">
				<select name="22_3b" id="22_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "22_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"22_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"22_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "22_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "22_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>
		
		
		
		<tr>
			<td colspan="2">23. Money</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1. Does the person have problems budgeting his or her money?</td>
			<td class="genericTableData">
				<select name="23_1" id="23_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "23_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help does the person receive from friends or relatives in managing his or her money?</td>
			<td class="genericTableData">
				<select name="23_2" id="23_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "23_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services in managing his or her money?</td>
			<td class="genericTableData">
				<select name="23_3a" id="23_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "23_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help does the person need from local services in managing his or her money?</td>
			<td class="genericTableData">
				<select name="23_3b" id="23_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "23_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"23_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"23_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "23_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "23_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>		

		<tr>
			<td class="genericTableHeader">What is your primary source of income?</td>
			<td class="genericTableData">
				<select name="income_source_type" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "income_source_type", OcanForm.getOcanFormOptions("Income Source Type"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">What is your primary source of income - Other</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"income_source_type_other",5,30,prepopulationLevel)%>
			</td>
		</tr>
		
		<tr>
			<td colspan="2">24. Benefits</td>
		</tr>			

		<tr>
			<td class="genericTableHeader">1.  Is the person definitely receiving all the benefits that he or she is entitled to?</td>
			<td class="genericTableData">
				<select name="24_1" id="24_1" domain1="true" class="{validate: {required:true}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "24_1", OcanForm.getOcanFormOptions("Camberwell Need"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>

		<tr>
			<td class="genericTableHeader">2. How much help does the person receive from friends or relatives in obtaining the full benefit entitlement?</td>
			<td class="genericTableData">
				<select name="24_2" id="24_2" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "24_2", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3a. How much help does the person receive from local services in obtaining the full benefit entitlement?</td>
			<td class="genericTableData">
				<select name="24_3a" id="24_3a" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "24_3a", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">3b. How much help does the person need from local services in obtaining the full benefit entitlement?</td>
			<td class="genericTableData">
				<select name="24_3b" id="24_3b" class="{validate: {required:function(element){return checkForRequired(element.id);}}}">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "24_3b", OcanForm.getOcanFormOptions("Camberwell Help"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>						
		<tr>
			<td class="genericTableHeader">Comments</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"24_comments",5,30,prepopulationLevel)%>
			</td>
		</tr>			
		
		<tr>
			<td class="genericTableHeader">Action(s)</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"24_actions",5,30,prepopulationLevel)%>
			</td>
		</tr>					
			
		<tr>
			<td class="genericTableHeader">By Whom?</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsTextField(ocanStaffForm.getId(), "24_by_whom", 25,prepopulationLevel)%>						
			</td>
		</tr>				
		
		<tr>
			<td class="genericTableHeader">Review Date</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsDate(ocanStaffForm.getId(), "24_review_date",false,prepopulationLevel)%>				
			</td>
		</tr>		
		
		<tr>
			<td colspan="2" vheight="4"></td>
		</tr>
		
		
		<tr>
			<td class="genericTableHeader">What are your hopes for the future?</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"hopes_future",5,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">What do you think you need in order to get there?</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"hope_future_need",5,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">How do you view your mental health?</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"view_mental_health",5,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Is spirituality an important part of your life?</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"sprituality",5,30,prepopulationLevel)%>
			</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Is culture (heritage) an important part of your life?</td>
			<td class="genericTableData">
						<%=OcanForm.renderAsTextArea(ocanStaffForm.getId(),"culture_heritage",5,30,prepopulationLevel)%>
			</td>
		</tr>
		
		<tr>
			<td class="genericTableHeader">Presenting Issues (Select all that apply)</td>
			<td class="genericTableData">
				<%=OcanForm.renderAsCheckBoxOptions(ocanStaffForm.getId(), "presenting_issues", OcanForm.getOcanFormOptions("Presenting Issues"),prepopulationLevel)%>						
			</td>
		</tr>
			
		<tr>
			<td colspan="2" vheight="4"></td>
		</tr>
		<tr>
			<td colspan="2">Summary of Actions</td>
		</tr>	
		<tr>
			<td colspan="2"><input type="button" value="Generate Summary" name="generate_summary_of_actions" id="generate_summary_of_actions"/></td>
			<%=OcanForm.renderAsHiddenField(ocanStaffForm.getId(), "summary_of_actions_count",prepopulationLevel)%>
			<%=OcanForm.renderAsHiddenField(ocanStaffForm.getId(), "summary_of_actions_domains",prepopulationLevel)%>		
		</tr>
		<tr>
			<td colspan="2">			
				<div id="summary_of_actions_block">
							
							
				
				</div>
			</td>
		</tr>

		<tr>
			<td colspan="2" vheight="4"></td>
		</tr>
		<tr>
			<td colspan="2">Summary of Referrals</td>
		</tr>
		<tr>
			<td class="genericTableHeader">Number of Referrals?</td>
			<td class="genericTableData">
				<select name="referrals_count" id="referrals_count" onchange="changeNumberOfReferrals();">
					<%=OcanForm.renderAsSelectOptions(ocanStaffForm.getId(), "referrals_count", OcanForm.getOcanFormOptions("Years in Canada"),prepopulationLevel)%>
				</select>					
			</td>
		</tr>													
		<tr>
			<td colspan="2">
				<div id="referral_block">
						
				</div>
			</td>
		</tr>
		<tr style="background-color:white">
			<td colspan="2">
				<br />
				<input type="hidden" name="clientId" value="<%=currentDemographicId%>" />
				Sign <input type="checkbox" name="signed" />
				&nbsp;&nbsp;&nbsp;&nbsp;
				<%
					if (!printOnly)
					{
						%>
				<input type="submit" name="submit" value="Submit"  onclick="document.getElementById('assessment_status').value='Complete';"/>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="submit" name="submit" value="Save Draft"  onclick="document.getElementById('assessment_status').value='Active'; document.getElementById('completionDate').value=''"/>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<%
					}
				%>
				<input type="button" value="Cancel" onclick="history.go(-1)" />
				<%
					if (printOnly)
					{
						%>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="button" name="print" value="Print" onclick="window.print()">
						<%
					}
				%>
			</td>
		</tr>		
	</table>
	<%
		if (printOnly)
		{
			%>
				<script>
					setEnabledAll(document.ocan_staff_form, false);

					document.getElementsByName('cancel')[0].disabled=false;
					document.getElementsByName('print')[0].disabled=false;
				</script>
			<%
		}
	%>

</form>


<%@include file="/layouts/caisi_html_bottom2.jspf"%>
