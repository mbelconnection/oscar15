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
<%@ page import="oscar.util.*, oscar.form.*, oscar.form.data.*,java.util.List"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ page import="org.oscarehr.util.SpringUtils" %>
<%@ page import="org.oscarehr.util.LoggedInInfo" %>
<%@ page import="org.oscarehr.common.model.Clinic" %>
<%@ page import="org.oscarehr.common.dao.ClinicDAO" %>
<%@ page import="org.oscarehr.common.model.Demographic" %>
<%@ page import="org.oscarehr.common.dao.DemographicDao" %>
<%@ page import="org.oscarehr.common.model.Allergy" %>
<%@ page import="org.oscarehr.common.dao.AllergyDao" %>
<%@ page import="org.oscarehr.common.model.Provider" %>
<%@ page import="org.oscarehr.PMmodule.dao.ProviderDao" %>
<%@ page import="org.oscarehr.common.model.Appointment" %>
<%@ page import="org.oscarehr.common.dao.OscarAppointmentDao" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>

<%
    String formClass = "CostQuestionnaire";
    String formLink = "formcostquestionnaire.jsp";
	String underline="_____________________";
    int demoNo = Integer.parseInt(request.getParameter("demographic_no"));
    int formId = Integer.parseInt(request.getParameter("formId"));
    int provNo = Integer.parseInt((String) session.getAttribute("user"));
    
    ClinicDAO clinicDao = SpringUtils.getBean(ClinicDAO.class);
    DemographicDao demographicDao = SpringUtils.getBean(DemographicDao.class);
    AllergyDao allergyDao = SpringUtils.getBean(AllergyDao.class);
    ProviderDao providerDao = SpringUtils.getBean(ProviderDao.class);
    OscarAppointmentDao appointmentDao = SpringUtils.getBean(OscarAppointmentDao.class);
    
    Clinic clinic = clinicDao.getClinic();
    Demographic demographic = demographicDao.getDemographicById(demoNo);
    StringBuilder allergyString = new StringBuilder();
    List<Allergy> allergies = allergyDao.findActiveAllergies(demoNo);
	
	    for(int x=0;x<allergies.size();x++) {
			Allergy allergy = allergies.get(x);
			if(x>0)
				allergyString.append(", ");
	    	allergyString.append(allergy.getDescription());
	    }
		
	

    String providerName = providerDao.getProvider(demographic.getProviderNo()).getFormattedName();
    String referralContent = demographic.getFamilyDoctor();
    String referralName = new String();
    String elementString = "<rd>";
   	int begin = referralContent.indexOf(elementString);
   	int end = referralContent.indexOf("</rd>");
   	if(begin != -1 && end != -1){
   		referralName = referralContent.substring(begin + elementString.length(), end);
   	}
    
   	SimpleDateFormat dateFormatter =new SimpleDateFormat("dd-MMM-yyyy");
    SimpleDateFormat dobFormatter = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeFormatter =new SimpleDateFormat("HH:mm");
    String bdayString =null;
    Date dob =null;
    if( (bdayString = demographic.getBirthDayAsString())!= null	){
    	try{
    	dob = dobFormatter.parse(bdayString);
    	}catch(	ParseException e){
    		//do nothing dob is already null
    	}
    }
   	
   	
   	
    Appointment appt = null;
    String apptParam = request.getParameter("appointmentNo") ;
    String apptDate,apptType,apptReason;
    apptDate=apptType=apptReason = new String();
    if(apptParam != null && apptParam.compareTo("") != 0){
    	
    	appt = appointmentDao.find(Integer.parseInt(request.getParameter("appointmentNo")));
    	apptDate = dateFormatter.format(appt.getAppointmentDate()) + " " + timeFormatter.format(appt.getStartTime());
		apptType= appt.getType();
		apptReason= appt.getReason();
    }
    
    
    /* Doctor Signature
    If the patient encounter sheet is accessed from the appointment
    	then display the doctor's name the appointment belongs too.
    If the patient encounte sheet is not accessed from an appointment then
    	Then display the doctor the patient is assigned too.
    */
    String signingPhysician= null;
    if(appt != null){
    	String providerNo = appt.getProviderNo();
    	if(providerNo != null){
    		Provider provider = providerDao.getProvider(providerNo);
    		if(provider != null){
    			signingPhysician = provider.getFormattedName();
    		}
    	}
    }else{
    	signingPhysician = providerName;
    }
    
   
    
    //get a few things we need.
    //family doc
    //referring doc
    //allergies
    //clinic info
    
    
   // FrmRecord rec = (new FrmRecordFactory()).factory(formClass);
   //java.util.Properties props = rec.getFormRecord(demoNo, formId);

    //FrmData fd = new FrmData();    String resource = fd.getResource(); resource = resource + "ob/riskinfo/";

    //get project_home
    String project_home = request.getContextPath().substring(1);	
%>
<%
  boolean bView = false;
  if (request.getParameter("view") != null && request.getParameter("view").equals("1")) bView = true; 
%>
<html:html locale="true">
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<title>Patient Encounter Worksheet</title>
<html:base />
<link rel="stylesheet" type="text/css" media="all" href="../share/css/extractedFromPages.css"  />
</head>


<script type="text/javascript" src="formScripts.js">          
</script>



<body bgproperties="fixed" topmargin="0" leftmargin="0" rightmargin="0">



	<h4 style="padding-top:8px; font-weight:bold;font-size:21px;text-align:center">Patient Encounter Worksheet</h4>

	<div align="center">
	<form action="../form/createpdf" method="POST">
	<input type="hidden" name="demographic_no" value="<%=request.getParameter("demographic_no") %>" />
	<input type="hidden" name="form_id" value="<%=request.getParameter("form_id") %>" />
	<input type="hidden" name="__title" value="PatientEcounterWorksheet" />
	<input type="hidden" name="__cfgfile" value="patientEncounterWorksheetCfg" />
	<input type="hidden" name="__template" value="patientEncounterWorksheet" />

	<table border="1" cellspacing="1" cellpadding="1" width="90%" >
		<tr>
			<td valign="top" colspan="2">
			<table class="Head" class="hidePrint" height="5%" border="0">
				<tr>
					<td align="left">
					<input class="noPrint" type="button" value="Exit" onclick="javascript:return onExit();" /> 
					<input class="noPrint" type="submit" value="Print" /></td>
					</td>
				</tr>
				
			</table>
			</td>
		</tr>
		<tr>
			<td valign="top" width="50%">
				<table border="0" cellspacing="2" cellpadding="2">
				<input type="hidden" name="clinic_name" value="<%=clinic.getClinicName() %>"/>
				<input type="hidden" name="clinic_address1" value="<%=clinic.getClinicAddress() %>"/>
				<input type="hidden" name="clinic_address2" value="<%=clinic.getClinicCity() + ", " + clinic.getClinicProvince() + ", " + clinic.getClinicPostal() %>"/>
				<input type="hidden" name="clinic_phone" value="<%=clinic.getClinicPhone() %>"/>
				<input type="hidden" name="clinic_fax" value="<%=clinic.getClinicFax() %>"/>
					<tr>
						<td valign="top"><b>Office:</b></td>
						<td valign="top">
						<%=clinic.getClinicName() %>
						<br/>
						<%=clinic.getClinicAddress() %>
						<br/>
						<%=clinic.getClinicCity() %>, <%=clinic.getClinicProvince() %>, <%=clinic.getClinicPostal() %>
						</td>
					</tr>
					<tr>
						<td align=right>Phone:</td>
						<td><%=clinic.getClinicPhone() %></td>
					</tr>
					<tr>
						<td align=right>Fax:</td>
						<td><%=clinic.getClinicFax() %></td>
					</tr>
				</table>
			</td>
			<td valign="top" width="50%">
				<table border="0" cellspacing="2" cellpadding="2">
					<input type="hidden" name="demo_name" value="<%=demographic.getFormattedName() + " (" + demographic.getSex().toUpperCase()  + ")" %>"/>
					<input type="hidden" name="demo_address1" value="<%=demographic.getAddress() %>"/>
					<input type="hidden" name="demo_address2" value="<%=demographic.getCity() + ", " + demographic.getProvince() + ", " + demographic.getPostal() %>"/>
					<input type="hidden" name="demo_id" value="<%=demographic.getDemographicNo() %>"/>
					<input type="hidden" name="demo_bday" value="<%=(dob != null)?dateFormatter.format(dob) + " (" + demographic.getAgeInYears() + ")":"" %>"/>
					<input type="hidden" name="demo_hin" value="<%=demographic.getHin() + " (" + demographic.getHcType() + ")" %>"/>
					<input type="hidden" name="demo_phone" value="<%=demographic.getPhone() %>"/>
					<tr>
						<td valign="top"><b>Patient:</b></td>
						<td colspan=3 width=100% >
						<%=demographic.getFormattedName() %> (<%=demographic.getSex().toUpperCase() %>)<br/>
						<%=demographic.getAddress() %><br/>
						<%=demographic.getCity() %>, <%=demographic.getProvince() %>, <%=demographic.getPostal() %>
						</td>
					</tr>
					<!-- 
						PAT ID  DOB
						PHONE	HC
					 -->
					<tr>
						<td align=right>Pat ID:</td>
						<td><%=demographic.getDemographicNo() %></td>
						<td align=right>DOB:</td>
						<td><%=(dob !=null)?dateFormatter.format(dob)+"(" +  demographic.getAgeInYears() +")":"" %></td>
					</tr>
					
					<tr>
						<td align=right>Ph (H):</td>
						<td><%=demographic.getPhone() %></td>
						<td align=right>HC #:</td>
						<td><%=demographic.getHin() %> (<%=demographic.getHcType() %>)</td>
					</tr>
					
				</table>
			</td>
		</tr>
		
		
		<tr>
			<td valign="top" width="50%">
				<table border="0" cellspacing="2" cellpadding="2">
					<input type="hidden" name="mrp_provider" value="<%=signingPhysician %>"/>
					<input type="hidden" name="ref_provider" value="<%=referralName %>"/>
					<tr>
						<td align=right>Physician:</td>
						<td><%=signingPhysician %></td>
					</tr>
					<!-- Family doctor is no longer required -->
				<!--  	<tr>
						<td>Family Doctor:</td>
						<td>Smith, John</td>
					</tr>
					-->
					<tr>
						<td align=right>Ref Doctor:</td>
						<td><%=referralName %></td>
					</tr>
				</table>
			</td>
			<td valign="top" width="50%">
				<table border="0" cellspacing="2" cellpadding="2">
					<input type="hidden" name="appt_date" value="<%=apptDate %>"/>
					<input type="hidden" name="appt_type" value="<%=apptType %>"/>
					<input type="hidden" name="appt_reason" value="<%=apptReason %>"/>
					
					<tr>
						<td align=right>Appt. Date:</td>
						<td><%=apptDate %></td>
					</tr>
					<tr>
						<td align=right>Appt. Type:</td>
						<td><%=apptType %></td>
					</tr>
					<tr>
						<td align=right>Reason:</td>
						<td><%=apptReason %></td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<input type="hidden" name="allergies" value="<%=allergyString.toString() %>"/>
		 <td style="padding-left:6px" valign="top" colspan="2">
			 Allergies:<br/>
			<%=allergyString.toString() %>
		 </td>
		</tr>
		
		<tr>
		
		 <td style="padding-left:6px; height:700px; vertical-align:top;" colspan="2">
			 Encounter Notes:<br/>
			  <!-- <textarea disabled="disabled" cols="138" rows="50" name="encounter_notes"></textarea> -->
		 </td>
		</tr>
		
		<tr>
		 <td colspan="2">
			<table border="0" cellspacing="2" cellpadding="2">
				
					<tr>
						<td>Diagnosis:</td>
						<td><%=underline %> <!--  <input name="diagnosis" type="text" value=""/>--><td>
					</tr>
					<tr>
						<td>Signature:</td>
						<td><%=underline %> <!--  <input name="signature" type="text" value=""/>--></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<input type="hidden" name="provider_sign" value="<%=signingPhysician %>"/>
						<td><%=signingPhysician %></td>
					</tr>
				</table>
		 </td>
		</tr>
		
		
		
	</table>
	</form>	
	</div>

</body>
</html:html>

