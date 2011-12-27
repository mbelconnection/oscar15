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

<%-- edoc imports --%>
<%@ page import="java.util.*, oscar.dms.*"%>

<%-- eform inports --%>
<%@ page import="oscar.eform.*"%>
<%

	String strMrn = request.getParameter("mrn");
	if(strMrn == null || strMrn.equals("")) {
		response.sendRedirect("error.jsp?msg=No Patient Context present. Please contact system administrator.");
	}

	ClientDao clientDao = (ClientDao)SpringUtils.getBean("clientDao");
	List<Demographic> clientList = clientDao.getClientsByChartNo(strMrn);
	if(clientList.size() == 0) {
		response.sendRedirect("error.jsp?mrn=" + request.getParameter("mrn") + "&msg=Patient not found in OSCAR. Please contact system administrator.");		
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
	
	//demographic_no
	int demographic_no=demographic.getDemographicNo();
	
	//allergies
	AllergyDAO allergyDao = (AllergyDAO)SpringUtils.getBean("AllergyDAO");
	@SuppressWarnings("unchecked")
	List<Allergy> allergies = allergyDao.getAllergies(String.valueOf(demographic.getDemographicNo()));
	System.out.println(allergies);
	
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
	List<Measurements> spls = measurementsDao.getMeasurementsByDemographicAndType(demographic.getDemographicNo(),"SPLS");
	List<Measurements> wc = measurementsDao.getMeasurementsByDemographicAndType(demographic.getDemographicNo(),"WC");
	
	//medications
	CaseManagementManager caseManagementManager = (CaseManagementManager) SpringUtils.getBean("caseManagementManager");
	List<Drug> prescriptDrugs = caseManagementManager.getPrescriptions(demographic.getDemographicNo(), true);
        
	//labs
	CommonLabResultData comLab = new CommonLabResultData();
    ArrayList labs = comLab.populateLabResultsData("",String.valueOf(demographic.getDemographicNo()), "", "","","U");
    Collections.sort(labs);
	System.out.println("# of labs="+labs.size()); 

	//eforms
	String orderByRequest = request.getParameter("orderby");
	String orderBy = "";
	if (orderByRequest == null) orderBy = EFormUtil.DATE;
	else if (orderByRequest.equals("form_subject")) orderBy = EFormUtil.SUBJECT;
	else if (orderByRequest.equals("form_name")) orderBy = EFormUtil.NAME;
	
	String groupView = request.getParameter("group_view");
	if (groupView == null) {
	    groupView = "";
	}	
	
	//edocuments
	String user_no = (String) request.getParameter("providerNo");

	for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
	    String name = (String)e.nextElement();
	    System.out.println("oscarFacesheet: " + name + " -> " + request.getParameter(name));
	}
	    
	//view  - tabs
	String edoc_view = "all";
	if (request.getParameter("edoc_view") != null) {
		edoc_view = (String) request.getParameter("edoc_view");
	} else if (request.getAttribute("edoc_view") != null) {
		edoc_view = (String) request.getAttribute("edoc_view");
	}
	
	
	// "Module" and "function" is the same thing (old dms module)
	String module = "demographic";
	String moduleid = String.valueOf(demographic.getDemographicNo());
	
	/*if (request.getParameter("function") != null) {
	    module = request.getParameter("function");
	    moduleid = request.getParameter("functionid");
	} else if (request.getAttribute("function") != null) {
	    module = (String) request.getAttribute("function");
	    moduleid = (String) request.getAttribute("functionid");
	}*/
	
	String moduleName = EDocUtil.getModuleName(module, moduleid);
	
	
	//sorting
	String sort = EDocUtil.SORT_OBSERVATIONDATE;
	String sortRequest = request.getParameter("sort");
	if (sortRequest != null) {
	    if (sortRequest.equals("description")) sort = EDocUtil.SORT_DESCRIPTION;
	    else if (sortRequest.equals("type")) sort = EDocUtil.SORT_DOCTYPE;
	    else if (sortRequest.equals("contenttype")) sort = EDocUtil.SORT_CONTENTTYPE;
	    else if (sortRequest.equals("creator")) sort = EDocUtil.SORT_CREATOR;
	    else if (sortRequest.equals("uploaddate")) sort = EDocUtil.SORT_DATE;
	    else if (sortRequest.equals("observationdate")) sort = EDocUtil.SORT_OBSERVATIONDATE;
	}
	
	ArrayList doctypes = EDocUtil.getDoctypes(module);
	
	   
	//for now view status will only be active so just setting it to active - John Wilson
	String viewstatus = "active";

	 
%>


<%
//String[] navArray={"Patient List","Allergies","Consultations","Current Issues","Treatments","History","Measurements","Medications","Exams","Labs","Risk Factors","Tests","Hospitalizations","Resources"};

String[] navArray={"Allergies","History","Measurements","Medications","Labs", "eForms", "eDocuments"};



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

<title>OSCAR - Portal Integration</title>

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

table.allergy_legend{
border:0;
padding-left:20px;
}

table.allergy_legend td{
font-size:8;
padding-right:6;
}

table.colour_codes{
width:8px;
height:10px;
border:1px solid #999999;
}
</style>

<script type="text/javascript" language="javascript"> 
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
	
	function popupPage(varpage, windowname) {
	    var page = "" + varpage;
	    windowprops = "height=700,width=800,location=no,"
	    + "scrollbars=yes,menubars=no,status=yes,toolbars=no,resizable=yes,top=10,left=200";
	    var popup = window.open(page, windowname, windowprops);
	    if (popup != null) {
	       if (popup.opener == null) {
	          popup.opener = self;
	       }
	       popup.focus();
	    }
	}
	
	//edocument popup script
	function popup1(height, width, url, windowName){   
	  var page = url;  
	  windowprops = "height="+height+",width="+width+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes,screenX=0,screenY=0,top=0,left=0";  
	  var popup=window.open(url, windowName, windowprops);  
	  if (popup != null){  
	    if (popup.opener == null){  
	      popup.opener = self;  
	    }  
	  }  
	  popup.focus();  
	  
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
			<td align="left">
			<font color="#333333" size="3"><b>Patient: <%=demographic.getFormattedName().toUpperCase()%> </b></font>
			</td>		
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
				<td>MRN: <span class="patient_record_text"><%=demographic.getChartNo() %></span></td> <td>Sex: <span class="patient_record_text"><%=demographic.getSex()%></span></td> <td>Age: <span class="patient_record_text"><%=demographic.getAge() %></span></td> <td>DOB: <span class="patient_record_text"><%=demographic.getFormattedDob()%></span></td> <td>HIN: <span class="patient_record_text"><%=demographic.getHin()%></span></td> <td></td>
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
	<%
	//Display alert only when there is one
	if(alert.length()!=0){%>
	<table width="100%" cellspacing="0" cellpadding="0" bgcolor="#F8EF8B">
		<tr>
			<td class="padding_body">
				<div class="ALERT">
					<img src="images/bookmark.gif" border="0" alt="Alert"><b>Alert:</b> <%=alert %>
				</div>
			</td>
		</tr>
	</table>		
	<%} %>
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
					
					<table  width="340" bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr class="patient_list_head">
					<td>Type</td><td> 	Measurement</td><td> 	Date</td>
					</tr>
					<%
					SimpleDateFormat measFormatter = new SimpleDateFormat("dd-MMM-yyyy");
					if(bp.size()>0) {
						Measurements latestBp = bp.get(0);					
					%>
					<tr class="patient_list_results">
						<td>Blood Pressure</td>
						<td><%=latestBp.getDataField() %></td>
						<td><%=measFormatter.format(latestBp.getDateObserved()) %></td>
					</tr>					
					<% } else {%>
					<tr class="patient_list_results">
						<td>Blood Pressure</td>
						<td><i>No Recorded Date</i></td>
						<td><i>N/A</i></td>
					</tr>		
					<%} %>
					
					<%
					if(spls.size()>0) {
						Measurements latestSpls = spls.get(0);					
					%>
					<tr class="patient_list_results">
						<td>Pulse</td>
						<td><%=latestSpls.getDataField() %></td>
						<td><%=measFormatter.format(latestSpls.getDateObserved()) %></td>
					</tr>					
					<% } else {%>
					<tr class="patient_list_results">
						<td>Pulse</td>
						<td><i>No Recorded Date</i></td>
						<td><i>N/A</i></td>
					</tr>		
					<%} %>					
					<%
					if(wt.size()>0) {
						Measurements latestWt = wt.get(0);					
					%>
					<tr class="patient_list_results">
						<td>Weight (kg)</td>
						<td><%=latestWt.getDataField() %> kg</td>
						<td><%=measFormatter.format(latestWt.getDateObserved()) %></td>
					</tr>					
					<% } else {%>
					<tr class="patient_list_results">
						<td>Weight (kg)</td>
						<td><i>No Recorded Date</i></td>
						<td><i>N/A</i></td>
					</tr>		
					<%} %>					
					<%
					if(ht.size()>0) {
						Measurements latestHt = ht.get(0);					
					%>
					<tr class="patient_list_results">
						<td>Height (cm)</td>
						<td><%=latestHt.getDataField() %> cm</td>
						<td><%=measFormatter.format(latestHt.getDateObserved()) %></td>
					</tr>					
					<% } else {%>
					<tr class="patient_list_results">
						<td>Height (cm)</td>
						<td><i>No Recorded Date</i></td>
						<td><i>N/A</i></td>
					</tr>		
					<%} %>
					<%
					if(bmi.size()>0) {
						Measurements latestBmi = bmi.get(0);					
					%>
					<tr class="patient_list_results">
						<td>Body Mass Index (BMI)</td>
						<td><%=latestBmi.getDataField() %></td>
						<td><%=measFormatter.format(latestBmi.getDateObserved()) %></td>
					</tr>					
					<% } else {%>
					<tr class="patient_list_results">
						<td>Body Mass Index (BMI)</td>
						<td><i>No Recorded Date</i></td>
						<td><i>N/A</i></td>
					</tr>		
					<%} %>
					<%
					if(wc.size()>0) {
						Measurements latestWc = wc.get(0);					
					%>
					<tr class="patient_list_results">
						<td>Wasit Circ (cm)</td>
						<td><%=latestWc.getDataField() %> cm</td>
						<td><%=measFormatter.format(latestWc.getDateObserved()) %></td>
					</tr>					
					<% } else {%>
					<tr class="patient_list_results">
						<td>Wasit Circ (cm)</td>
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
					if(labs.size()!=0){
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
					
					<%}
					}else{ 
					%>
					<tr  class="patient_list_results">
						<td colspan="5" width="100%">No lab results available.</td>
					</tr>
					<%}%>
					</table>
					</div>
					
					<div id="eForms" style="display:none;">
				<table  width="600">
				<tr >
				<td align="right">
				<font size="2"><b><font color="red">Note:</font></b> eForms presented here are READ ONLY. Any changes you make will not be saved.</font>
				</td>
				</tr>
				</table>


				<table  width="600" bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr  class="patient_list_head">
						<td>eForm</td> 	<td>Modified Date</td> 	
					</tr>
			<%
			//set eform_data_id to read only for all eforms
        	session.setAttribute("eform_data_id", "r");
			
 			ArrayList eForms;

     		String str_demographic_no= Integer.toString(demographic_no); 
			eForms = EFormUtil.listPatientEForms(orderBy, EFormUtil.CURRENT, str_demographic_no);
      
			  for (int f=0; f< eForms.size(); f++) {
			        Hashtable curform = (Hashtable) eForms.get(f);
			%>
					<tr class="patient_list_results" bgcolor="<%= ((f%2) == 1)?"#F2F2F2":"white"%>">
						<td><a href="#"
							ONCLICK="popupPage('../eform/efmshowform_data.jsp?fdid=<%= curform.get("fdid")%>', '<%="ReadOnly" + f%>'); return false;"
							TITLE="<bean:message key="eform.showmyform.msgViewFrm"/>" 
							onmouseover="window.status='<bean:message key="eform.showmyform.msgViewFrm"/>'; return true"><%=curform.get("formName")%></a></td>
						
						<td align='center'><%=curform.get("formDate")%></td>
						
					</tr>
			<%
  				}
			 if (eForms.size() <= 0) {
			%>
						<tr>
							<td align='center' colspan='5'>no eforms</td>
						</tr>
						<%
			  }
			%>
		</table>
		            </div>	
					
					<div id="eDocuments" style="display:none;">
					

					<table >
					<tr>
						<td  colspan="2" valign="top">
		
					<%-- STUFF TO DISPLAY --%> 
					<%
					
						ArrayList categories = new ArrayList();
		                ArrayList categoryKeys = new ArrayList();
		                ArrayList privatedocs = new ArrayList();
		                
		                privatedocs = EDocUtil.listDocs(module, moduleid, edoc_view, EDocUtil.PRIVATE, sort, viewstatus);
		
		                categories.add(privatedocs);
		                categoryKeys.add(moduleName);
		                if (module.equals("provider")) {
		                    ArrayList publicdocs = new ArrayList();
		                    publicdocs = EDocUtil.listDocs(module, moduleid, edoc_view, EDocUtil.PUBLIC, sort, viewstatus);
		                    categories.add(publicdocs);
		                    categoryKeys.add("Public Documents");
		                }
		                
		                
		                for (int d=0; d<categories.size();d++) {
		                    String currentkey = (String) categoryKeys.get(d);
		                    ArrayList category = (ArrayList) categories.get(d);
		             %>

					<%-- order edoc_view goes here will continue with this development when SJHH CI decides they want to 
					keep eDocuments in the oscarFacesheet viewer- John Wilson--%>
	
					<table id="privateDocs" width="<%=tblWidth%>"  bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
						<tr class="patient_list_head">
							<td ><bean:message key="dms.documentReport.msgDocDesc" /></td>
							<td ><bean:message key="dms.documentReport.msgContent"/></td>
							<td ><bean:message key="dms.documentReport.msgType"/></td>
							<td ><bean:message key="dms.documentReport.msgCreator" /></td>
							<td ><bean:message key="dms.documentReport.msgDate"/></td>		
						</tr>

					<%
	                for (int i2=0; i2<category.size(); i2++) {
	                    EDoc curdoc = (EDoc) category.get(i2);
	                    //content type (take everything following '/')
	                    int slash = 0;
	                    String contentType = "";
	                    if ((slash = curdoc.getContentType().indexOf('/')) != -1) {
	                        contentType = curdoc.getContentType().substring(slash+1);
	                    } else {
						contentType = curdoc.getContentType();
			    		}
	                    
	            	%>
					<tr  class="patient_list_results">
						<td>
						<%                   
	                      String url = "../dms/ManageDocument.do?method=display&doc_no="+curdoc.getDocId()+"&providerNo="+user_no;
	                              
	                      if (curdoc.getStatus() == 'H') { %> 
	                      	<a
							<%=curdoc.getStatus() == 'D' ? "style='text-decoration:line-through'" : ""%>
							href="<%=url%>" target="_blank"> 
							
						 <% } else { %> 
							
							<a
							<%=curdoc.getStatus() == 'D' ? "style='text-decoration:line-through'" : ""%>
							href="javascript:popup1(480, 480, '<%=url%>', 'edoc<%=i2%>')">
						<% } %> 
						<%=curdoc.getDescription()%></a></td>
						<td><%=contentType%></td>
						<td><%=curdoc.getType()%></td>
						<td><%=curdoc.getCreatorName()%></td>
						<td><%=curdoc.getObservationDate()%></td>				
					</tr>
	
					<%}
	            if (category.size() == 0) {%>
					<tr>
						<td colspan="6"><bean:message key="dms.documentReport.msgNoDocumentsToDisplay"/></td>
					</tr>
				<%}%>
				</table>
	
				<%}%>

					</td>
				</tr>
			</table>



					</div>
														
					<div id="Allergies" >
									
					<%
					
					 //1 mild 2 moderate 3 severe 4 unknown
					 
					 String[] ColourCodesArray=new String[5];
					 ColourCodesArray[1]="#F5F5F5"; // Mild Was set to yellow (#FFFF33) SJHH requested not to flag mild
					 ColourCodesArray[2]="#FF6600"; // Moderate
					 ColourCodesArray[3]="#CC0000"; // Severe
					 ColourCodesArray[4]="#E0E0E0"; // unknown
					 
					 String allergy_colour_codes = "<table width='"+tblWidth+"'><td align='right'><table class='allergy_legend' cellspacing='0'><tr><td><b>Legend:</b></td> <td > <table class='colour_codes' bgcolor='"+ColourCodesArray[1]+"'><td> </td></table></td> <td >Mild</td> <td > <table class='colour_codes' bgcolor='"+ColourCodesArray[2]+"'><td> </td></table></td> <td >Moderate</td><td > <table class='colour_codes' bgcolor='"+ColourCodesArray[3]+"'><td> </td></table></td> <td >Severe</td> </tr></table></td></table>";
					 out.print(allergy_colour_codes);
					%>
				
						<!--Table alloted for Legend-->
						<!-- 
						<table width="<%=tblWidth%>"><td align="right"><img src="images/notes.gif" border="0" width="10" height="12" alt="Annotation"><font size="1"> = Annotation</font></td></table>
						-->
						
						<table width="<%=tblWidth%>"  bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
							<tr  class="patient_list_head">
							<td>Entry Date</td> 	<td>Description</td> 	<!--  <td>Allergy Type</td>--> 	<td>Severity</td> 	<td>Onset of Reaction</td> 	<td>Reaction</td> 	<td>Start Date</td> <!-- <td width="18" align="center">	<img src="images/notes.gif" border="0" alt="Annotation"> </td> -->
							</tr>
	
							<%if(allergies.size()!=0){
								SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
								for(int x=0;x<allergies.size();x++) {
									Allergy allergy = allergies.get(x);
									
									
									String sevColour;
									// Mild Moderate=2 Severe=3 Unknown=4
									String strSOR=allergy.getSeverityDesc();
								    if(strSOR.equals("Mild")){
								    	sevColour=ColourCodesArray[1]; 
								    }else if(strSOR.equals("Moderate")){
								    	sevColour=ColourCodesArray[2]; 	
								    }else if(strSOR.equals("Severe")){
								    	sevColour=ColourCodesArray[3]; 	
								    }else if(strSOR.equals("Unknown")){
								    	sevColour=ColourCodesArray[4]; 	
								    }else{
								    	
								    sevColour="#ffffff"; //clearing severity bgcolor
								    
								    }   
							%>
									<tr class="patient_list_results">
										<td><%=formatter.format(allergy.getEntry_date()) %></td>
										<td><%=allergy.getDescription()%></td>
										<!--Hiding for now on reequest from the SJHH Clinical Team  <td><%//=allergy.getTypeDesc() %></td>-->
										<td bgcolor="<%=sevColour%>"><%=allergy.getSeverityDesc() %></td>
										<td><%=allergy.getOnsetDesc() %></td>
										<td><%=allergy.getReaction()%></td>
										<td><%if(allergy.getStart_date()!=null){out.print(formatter.format(allergy.getStart_date())); } %></td>
										<!-- 
										<td align="center"><a href="#"><img src="images/notes.gif" border="0" alt="Annotation"></a></td>
										-->
									</tr>
							
							<%}
							}else{ 
							%>
							<tr  class="patient_list_results">
								<td colspan="7" width="100%">No Allergy data available.</td>
							</tr>
							<%}%>						
						</table>			
					</div>
					
	

					
					<!--START Paging Table
					
					<table width="" align="left" cellspacing="1" cellpadding="1">
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

