<%@ page language="java" info="Provider Portal Integration" %>
<%@ include file="/taglibs.jsp"%>

<%@page import="org.oscarehr.common.model.Demographic"%>
<%@page import="org.oscarehr.common.model.DemographicCust"%>
<%@page import="org.oscarehr.common.dao.DemographicCustDao"%>
<%@page import="org.oscarehr.util.SpringUtils"%>
<%@page import="org.oscarehr.util.MiscUtils"%>
<%@page import="org.oscarehr.PMmodule.dao.ClientDao"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="oscar.util.StringUtils"%>
<%@page import="org.oscarehr.casemgmt.dao.AllergyDAO" %>
<%@page import="org.oscarehr.casemgmt.model.Allergy" %>
<%@page import="org.oscarehr.casemgmt.dao.CaseManagementNoteDAO" %>
<%@page import="org.oscarehr.casemgmt.model.CaseManagementNote" %>
<%@page import="oscar.oscarEncounter.oscarMeasurements.dao.MeasurementsDao" %>
<%@page import="oscar.oscarEncounter.oscarMeasurements.model.Measurements" %>
<%@page import="org.oscarehr.casemgmt.service.CaseManagementManager" %>
<%@page import="org.oscarehr.common.model.Drug"%>
<%@page import="oscar.oscarLab.ca.on.CommonLabResultData" %>
<%@page import="oscar.oscarLab.ca.on.LabResultData" %>
<%@page import="org.oscarehr.PMmodule.dao.ProviderDao" %>
<%@page import="org.oscarehr.common.model.Provider" %>

<%
	String strMrn = request.getParameter("mrn");
	if(strMrn == null || strMrn.equals("")) {
		response.sendRedirect("error.jsp?msg=No Patient Context present. Please contact system administrator.");
	}

	ClientDao clientDao = (ClientDao)SpringUtils.getBean("clientDao");
	List<Demographic> clientList = clientDao.getClientsByChartNo(strMrn);
	if(clientList.size() == 0) {
		response.sendRedirect("error.jsp?msg=Patient not found in OSCAR. Please contact system administrator.");		
	}
	
	if(clientList.size() > 1) {
		MiscUtils.getLogger().warn("Multiple patients found with MRN #"  + strMrn);
	}
	
	Demographic demographic = clientList.get(0);
	
	DemographicCustDao demographicCustDao = (DemographicCustDao)SpringUtils.getBean("demographicCustDao");
	DemographicCust demographicCust = demographicCustDao.find(demographic.getDemographicNo());
	String alert = new String();
	if(demographicCust!=null) {
		alert = demographicCust.getCust3();
	}
	
	//allergies
	AllergyDAO allergyDao = (AllergyDAO)SpringUtils.getBean("AllergyDAO");
	@SuppressWarnings("unchecked")
	List<Allergy> allergies = allergyDao.getAllergies(String.valueOf(demographic.getDemographicNo()));

	//history
	ProviderDao providerDao = (ProviderDao)SpringUtils.getBean("providerDao");
	CaseManagementNoteDAO caseManagementNoteDao = (CaseManagementNoteDAO)SpringUtils.getBean("CaseManagementNoteDAO");
	Collection<CaseManagementNote> socialHistory = caseManagementNoteDao.findNotesByDemographicAndIssueCode(demographic.getDemographicNo(),new String[] {"SocHistory"});
	Collection<CaseManagementNote> medicalHistory = caseManagementNoteDao.findNotesByDemographicAndIssueCode(demographic.getDemographicNo(),new String[] {"MedHistory"});
	Collection<CaseManagementNote> familyHistory = caseManagementNoteDao.findNotesByDemographicAndIssueCode(demographic.getDemographicNo(),new String[] {"FamHistory"});

	//measurements
	MeasurementsDao measurementsDao = (MeasurementsDao)SpringUtils.getBean("measurementsDao");
	List<Measurements> bp = measurementsDao.getMeasurementsByDemographicAndType(demographic.getDemographicNo(),"BP");
	List<Measurements> ht = measurementsDao.getMeasurementsByDemographicAndType(demographic.getDemographicNo(),"HT");
	List<Measurements> wt = measurementsDao.getMeasurementsByDemographicAndType(demographic.getDemographicNo(),"WT");
	List<Measurements> bmi = measurementsDao.getMeasurementsByDemographicAndType(demographic.getDemographicNo(),"BMI");
	
	//medications
	CaseManagementManager caseManagementManager = (CaseManagementManager) SpringUtils.getBean("caseManagementManager");
	List<Drug> prescriptDrugs = caseManagementManager.getPrescriptions(demographic.getDemographicNo(), true);
        
	//labs
	CommonLabResultData comLab = new CommonLabResultData();
    ArrayList labs = comLab.populateLabResultsData("",String.valueOf(demographic.getDemographicNo()), "", "","","U");
    Collections.sort(labs);
	System.out.println("# of labs="+labs.size());    
 
%>


<%
//String[] navArray={"Patient List","Allergies","Consultations","Current Issues","Treatments","History","Measurements","Medications","Exams","Labs","Risk Factors","Tests","Hospitalizations","Resources"};

String[] navArray={"Allergies","History","Measurements","Medications","Labs"};


//table width
int tblWidth_main=980; //main wrapper table
int tblWidth=960; //sub tables

//-- Switch Control --
String view = request.getParameter("view");
if(view == null || view.equals("")) {
	view=navArray[0];
}
String LinkParam="NavMenu";
			
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<title>Oscar - Portal Integration</title>

<STYLE type="text/css" >
body{
font-family: Arial;
margin-top: 0px; 
margin-right: 0px; 
margin-bottom: 0px; 
margin-left: 0px;
}


table.patient_record{
font-family: Arial;
color: #E0E0D1;
font-size: 13px;

border-bottom: 1px solid #8D8D69;
}

.patient_record_text{
font-size: 13px;
font-weight: bold;
padding-right: 30px;
}

.noLink{
text-decoration: none; color: #003162; font-size:12px; font-weight:bold; text-decoration:underline;
}

a.NavMenu:link {text-decoration: none; color: #003162; font-size:12px;}
a.NavMenu:visited {text-decoration: none; color: #003162; font-size:12px;}
a.NavMenu:active {text-decoration: none; color: #003162; font-size:12px;}
a.NavMenu:hover {text-decoration: underline; color: #003162; font-size:12px;}

a.Patient:link {text-decoration: underline; color: #3737FF; font-size:12px;}
a.Patient:visited {text-decoration: underline; color: #3737FF; font-size:12px;}
a.Patient:active {text-decoration: underline; color: #3737FF; font-size:12px;}
a.Patient:hover {text-decoration: underline; color: #003162; font-size:12px;font-style: italic;}


.ALERT{
color: #000000;
font-size: 12px;
}

.MAIN_TITLE{
color: #333333;
font-size: 20px;
font-weight: bold;

border-left: 1px solid #8D8D69;
border-bottom: 1px solid #8D8D69;

padding-right:1cm
}

tr.patient_list_head{
color: #003162;
font-size: 14px;
font-weight: bold;
background-color:#BABA97;
}

tr.patient_list_results{
font-size: 13px;
background-color: #ffffff;
}

.OSCAR_FOOTER{
color: #000000;
font-size: 13px;
}

.title_border{
border-left: 1px solid #8D8D69;
border-bottom: 1px solid #8D8D69;
}

td.padding_body{
padding-left:5px;
}
</style>

<script>
	function changeView(name) {		
		<%
			for(int x=0;x<navArray.length;x++) {
				
				%>if(name == '<%=navArray[x]%>') {document.getElementById('<%=navArray[x]%>').style.display='block'; document.getElementById('main_title').innerHTML='<%=navArray[x]%>';document.getElementById('nav_<%=navArray[x]%>').className='noLink';}<%
				out.println();
				%>else {document.getElementById('<%=navArray[x]%>').style.display='none';;document.getElementById('nav_<%=navArray[x]%>').className='';}<%
				out.println();
			}
		%>		
	}
</script>
</head>

<body bgcolor="#F7F7EC">

<!--main wrapper table -->
<table cellpadding="0" cellspacing="0" width="980">	
	<td>
	
	<!--start of search table-->
	<table width="100%" cellspacing='0' cellpadding="1" bgcolor="#BABA97" border="0" >
		<tr >			
			<td align="right">
				<font color="#333333" size="5"><b>OSCAR</b></font>
			</td>
		</tr>		
	</table>
	
	<!--end of search table-->	
	
	<!--start of patient record table-->
	<table width="100%" bgcolor="#333333">
		<td>

			<table  class="patient_record" >
				<td>Patient Name: <span class="patient_record_text"><%=demographic.getFormattedName()%></span></td> <td>Sex: <span class="patient_record_text"><%=demographic.getSex()%></span></td> <td>Age: <span class="patient_record_text"><%=demographic.getAge() %></span></td> <td>DOB: <span class="patient_record_text"><%=demographic.getFormattedDob()%></span></td> <td>HIN: <span class="patient_record_text"><%=demographic.getHin()%></span></td> <td></td>
			</table>

			<table  class="patient_record" >
				<td>Address: <span class="patient_record_text"><%=demographic.getAddress()%></span></td> <td>City: <span class="patient_record_text"><%=demographic.getCity()%></span></td> <td>Province: <span class="patient_record_text"><%=demographic.getProvince()%></span></td> <td>Postal Code: <span class="patient_record_text"><%=demographic.getPostal()%></span></td> <td></td> 
			</table>

			<table  class="patient_record" >
				<td>Phone: <span class="patient_record_text"><%=demographic.getPhone()%></span></td> <td>Cell: <span class="patient_record_text"><%=demographic.getPhone2() %></span></td> <td>Email: <span class="patient_record_text"><%=StringUtils.transformNullInOtherString(demographic.getEmail(),"")%></span></td> 
			</table>
		</td>	
	</table>
	
	
	<!--end of patient record table-->
	
	<!--start of navigation menu table-->
	<table width="100%" cellspacing="0" cellpadding="0" bgcolor="#D1DEF2">
		<tr>
			<td class="padding_body">			
			 	<%
				 int i=0;
				 for(i=0;i<navArray.length;i++)
				 { 
					 String className = (navArray[i].equals(view))?"noLink":"";
					//create the navigation options and underline and bold if item is selected
					
						out.print("<span id='nav_"+navArray[i]+"' class='"+className+"'><a href='#' onclick=\"changeView('"+navArray[i]+"');return false;\" class='"+LinkParam+"'>");
							out.print(navArray[i]);
						out.print("</a></span> | ");	
					
				 }
				%>			
			</td>
		</tr>
	</table>	
	<!--end of navigation menu table-->
		
	<!--start of alert table-->
	<!--This table will only appear if there is an alert in the patients master file-->
	<table width="100%" cellspacing="0" cellpadding="0" bgcolor="#F8EF8B">
		<tr>
			<td class="padding_body">
				<div class="ALERT">
					<img src="images/bookmark.gif" border="0" alt="Alert"><b>Alert:</b> <%=alert %>
				</div>
			</td>
		</tr>
	</table>		
	<!--end of alert table-->
	
	
<!--start of MAIN_BODY table**********************************************************************-->			
	<table cellspacing="0" cellpadding="0" >
		<tr>
			<td height="20">
			</td>
		</tr>
		<tr>		
			<td  valign="bottom" class="padding_body">
				
				<div class="MAIN_TITLE" id="main_title"><%=view%></div>
				
			</td>
		</tr>
	</table>
	
	<table width="100%"  height="0" cellspacing="2" cellpadding="4" >
		<tr>	
			<td valign="top">
			<%
				String patient_results="<font size='2'>No <b>"+view+" Results</b> available for this patient.</font><br/>";							
			%>
						
					<div id="History" style="display:none;">			
					<table width="540"  cellspacing="1" cellpadding="1">
					<tr>
					<!--History Navigation-->
					
						<td><i><font color="#996633" size="2">Social</i> <b>History</b></font></td>
						<td><i><font color="#993333" size="2">Medical</i> <b>History</b></font></td>
						<td><i><font color="#006600" size="2">Family</i> <b>History</b></font></td>
						
					
					</tr>
					<tr><td valign="top" >
						<table width="300" bgcolor="#8D8D69" cellspacing="1" cellpadding="1" align="left">
							<%
								SimpleDateFormat noteFormatter = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
								Iterator<CaseManagementNote> iter = socialHistory.iterator();
								while(iter.hasNext()) {
									CaseManagementNote note = iter.next();											
							%>
							<tr>
								<td bgcolor="#996633" height="16"> </td>
							</tr>
							<tr>
								<td bgcolor="#ffffff">
									<font size="2"><b>Documentation Date: <%=noteFormatter.format(note.getUpdate_date()) %></b>
									<br />
									<i>Signed by <%=providerDao.getProvider(note.getSigning_provider_no()).getFormattedName() %></i>
									<p><font size="2">
									<%=note.getNote()%>									
									</font></p></font>							
								</td>
							</tr>
							<% } %>
						</table>
							
					</td>
					<td valign="top">
					<table width="300" bgcolor="#8D8D69" cellspacing="1" cellpadding="1" align="left">
							<%
							iter = medicalHistory.iterator();
							while(iter.hasNext()) {
								CaseManagementNote note = iter.next();	
							%>
							<tr><td bgcolor="#993333" height="16"> </td></tr>
							
							<tr><td bgcolor="#ffffff">
							<font size="2"><b>Documentation Date: <%=noteFormatter.format(note.getUpdate_date()) %></b><br />
							<i>Signed by <%=providerDao.getProvider(note.getSigning_provider_no()).getFormattedName() %></i>

							<p><font size="2">
							<%=note.getNote() %>
							</font>
							</p>

							</font>
							
							</td></tr>
							<% } %>
						</table>
						
						
					</td>
					
					<td valign="top">
					<table width="300" bgcolor="#8D8D69" cellspacing="1" cellpadding="1" align="left">
							<%
							iter = familyHistory.iterator();
							while(iter.hasNext()) {
								CaseManagementNote note = iter.next();	
							%>
							<tr><td bgcolor="#006600" height="16"> </td></tr>
							<tr><td bgcolor="#ffffff">
							<font size="2"><b>Documentation Date: <%=noteFormatter.format(note.getUpdate_date()) %></b><br />
							<i>Signed by <%=providerDao.getProvider(note.getSigning_provider_no()).getFormattedName() %></i>
														
							<p><font size="2">
							<%=note.getNote() %>
							</font>
							</p>

							</font>
							
							</td></tr>
							<% } %>
						</table>
					</td>
					</tr>
					</table>
					</div>
					
					<div id="Measurements" style="display:none;">
					<!--Table alloted for Legend-->
					<table width="<%=tblWidth%>"><td align="right">&nbsp;</td></table>
					
					<table  width="260" bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr class="patient_list_head">
					<td>Type</td><td> 	Measurement</td><td> 	Date</td>
					</tr>
					<%
					SimpleDateFormat measFormatter = new SimpleDateFormat("dd-MMM-yyyy");
					if(bp.size()>0) {
						Measurements latestBp = bp.get(0);					
					%>
					<tr class="patient_list_results">
						<td>BP</td>
						<td><%=latestBp.getDataField() %></td>
						<td><%=measFormatter.format(latestBp.getDateObserved()) %></td>
					</tr>					
					<% } else {%>
					<tr class="patient_list_results">
						<td>BP</td>
						<td><i>No Recorded Date</i></td>
						<td><i>N/A</i></td>
					</tr>		
					<%} %>
					
					<%
					if(ht.size()>0) {
						Measurements latestBp = ht.get(0);					
					%>
					<tr class="patient_list_results">
						<td>HT</td>
						<td><%=latestBp.getDataField() %> cm</td>
						<td><%=measFormatter.format(latestBp.getDateObserved()) %></td>
					</tr>					
					<% } else {%>
					<tr class="patient_list_results">
						<td>HT</td>
						<td><i>No Recorded Date</i></td>
						<td><i>N/A</i></td>
					</tr>		
					<%} %>
					<%
					if(wt.size()>0) {
						Measurements latestBp = wt.get(0);					
					%>
					<tr class="patient_list_results">
						<td>WT</td>
						<td><%=latestBp.getDataField() %> kg</td>
						<td><%=measFormatter.format(latestBp.getDateObserved()) %></td>
					</tr>					
					<% } else {%>
					<tr class="patient_list_results">
						<td>WT</td>
						<td><i>No Recorded Date</i></td>
						<td><i>N/A</i></td>
					</tr>		
					<%} %>
					<%
					if(bmi.size()>0) {
						Measurements latestBp = bmi.get(0);					
					%>
					<tr class="patient_list_results">
						<td>BMI</td>
						<td><%=latestBp.getDataField() %></td>
						<td><%=measFormatter.format(latestBp.getDateObserved()) %></td>
					</tr>					
					<% } else {%>
					<tr class="patient_list_results">
						<td>BMI</td>
						<td><i>No Recorded Date</i></td>
						<td><i>N/A</i></td>
					</tr>		
					<%} %>
					
					
					</table>
					</div>
					
					<div id="Medications" style="display:none;">
					<!--Table alloted for Legend-->
					<!-- 
					<table width="<%=tblWidth%>"><td align="right"><img src="images/notes.gif" border="0" width="10" height="12" alt="rxAnnotation"><font size="1"> = rxAnnotation</font></td></table>
					-->
					<table width="<%=tblWidth%>"  bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr  class="patient_list_head">
					<td>Rx Date </td><td>	Days to Exp</td><td> 	LT Med </td><td>	Prescription </td><td> 	Location Prescribed </td>
					</tr>
					<%
					SimpleDateFormat rxFormatter = new SimpleDateFormat("yyyy-MM-dd");
					for (Drug prescriptDrug : prescriptDrugs) {
					
				        if( prescriptDrug.isArchived() )
				            continue;
				    
				        boolean longTerm = prescriptDrug.getLongTerm();
				        String lt = "No";
				        if(longTerm) {
				        	lt = "Yes";
				        }
				     
				        
					%>
					<tr class="patient_list_results">
						<td><%=rxFormatter.format(prescriptDrug.getRxDate()) %></td>
						<td><%=prescriptDrug.daysToExpire()%></td>
						<td><%=lt%></td>
						<td><%=prescriptDrug.getSpecial()%></td>
						<td>
						<%
			                if (prescriptDrug.getRemoteFacilityName() != null){ %>
			                    <%=prescriptDrug.getRemoteFacilityName()%>
			                <%}else if(  prescriptDrug.getOutsideProviderName() !=null && !prescriptDrug.getOutsideProviderName().equals("")  ){%>
			                    <%=prescriptDrug.getOutsideProviderName()%>
			                <%}else{%>
			                    local
			                <%}%>
						</td>
					</tr>					
					
					<% } %>
					
					</table>
					</div>
					
					<div id="Labs" style="display:none;">
					<!--Table alloted for Legend-->
					<table width="<%=tblWidth%>"><td align="right"> &nbsp;</td></table>
					
					<table width="<%=tblWidth%>"  bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr  class="patient_list_head">
					<td>Discipline</td><td> 	Date of Test </td><td>	Requesting Client </td><td>	Result Status </td><td>	Report Status</td>
					</tr>
					<%
						SimpleDateFormat labFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						for(int x=0;x<labs.size();x++) {
							LabResultData lab = (LabResultData)labs.get(x);	
							String resultStatus = lab.isAbnormal()?"Abnormal":"";
					%>
					<tr  class="patient_list_results">
						<td><%=lab.getDiscipline() %></td>
						<td><%=lab.getDateTime() %></td>
						<td><%=lab.getRequestingClient() %></td>
						<td><%=resultStatus%></td>
						<td><%= ( (String) ( lab.isFinal() ? "Final" : "Partial") )%></td>
					</tr>					
					
					<%} %>
					</table>
					</div>
					
					<div id="Allergies">
						<!--Table alloted for Legend-->
						<!-- 
						<table width="<%=tblWidth%>"><td align="right"><img src="images/notes.gif" border="0" width="10" height="12" alt="Annotation"><font size="1"> = Annotation</font></td></table>
						-->
						<table width="<%=tblWidth%>"  bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
							<tr  class="patient_list_head">
							<td>Entry Date</td> 	<td>Description</td> 	<td>Allergy Type</td> 	<td>Severity</td> 	<td>Onset of Reaction</td> 	<td>Reaction</td> 	<td>Start Date</td> <!-- <td width="18" align="center">	<img src="images/notes.gif" border="0" alt="Annotation"> </td> -->
							</tr>
	
							<%
								SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
								for(int x=0;x<allergies.size();x++) {
									Allergy allergy = allergies.get(x);
							%>
									<tr class="patient_list_results">
										<td><%=formatter.format(allergy.getEntry_date()) %></td>
										<td><%=allergy.getDescription()%></td>
										<td><%=allergy.getTypeDesc() %></td>
										<td><%=allergy.getSeverityDesc() %></td>
										<td><%=allergy.getOnsetDesc() %></td>
										<td><%=allergy.getReaction()%></td>
										<td><%=formatter.format(allergy.getStart_date()) %></td>
										<!-- 
										<td align="center"><a href="#"><img src="images/notes.gif" border="0" alt="Annotation"></a></td>
										-->
									</tr>
							
							<% 	} %>							
						</table>			
					</div>		

					
					<!--START Paging Table
					<table width="<%=tblWidth%>" align="left" cellspacing="1" cellpadding="1">
						<td align="right">
						<font size="2"> 1 of 1 </font>
						</td>
					</table>
					END Paging Table-->		
										
					
			
			</td>
		</tr>	
	</table>	
<!--end of MAIN_BODY table**********************************************************************-->
	
	<!--start of OSCAR_FOOTER table-->
	<table width="100%" HEIGHT="100" cellspacing="0" cellpadding="0">
	<tr>
		<td align="right">
			<div class="OSCAR_FOOTER">
			Created by: OSCAR The open-source EMR <a href="http://www.oscarcanada.org" target="_blank" class='NavMenu'>www.oscarcanada.org</a> <a href="http://www.oscarmanual.org/oscar-emr" target="_blank"><img src="images/oscar_footer_logo.gif" border="0"></a>
			</div>
		</td>
	</tr>
	</table>
	<!--end of OSCAR_FOOTER table-->
	
	</td>
</table>
<!--main wrapper table end-->


</body>

</html>

