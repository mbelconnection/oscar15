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
<%@page import="oscar.oscarLab.ca.on.LabResultData, oscar.oscarLab.LabRequestReportLink, oscar.oscarMDS.data.ReportStatus, org.apache.commons.codec.binary.Base64, oscar.log.*" %>
<%@page import="org.oscarehr.PMmodule.dao.ProviderDao" %>
<%@page import="org.oscarehr.common.model.Provider" %>
<%@ page import="oscar.dms.*"%>
<%@ page import="oscar.eform.*"%>
<%@ page import="java.util.*, java.sql.*, oscar.oscarDB.*, oscar.oscarLab.ca.all.*, oscar.oscarLab.ca.all.util.*, oscar.oscarLab.ca.all.parsers.* " %>


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
		
	//main start*******************************************************************************************
	
	Boolean errOnMrn = false; 
	
	
	/*if(strMrn != null ) {
			
		errOnMrn = true;
		
		if(!strMrn.equals("")) {
			errOnMrn = true; 
	*/		
			
	
	DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
	
	//---------------------------------------------------------------------------------------------------
	//get healthcard number and demographic_no
	String hin="";
	String demographicID="";
	
	String sqlHIN = "SELECT DISTINCT hin,demographic_no FROM demographic WHERE chart_no='" + strMrn + "';";
	ResultSet rsHIN = db.GetSQL(sqlHIN);
	
	while(rsHIN.next()){
	    hin = db.getString(rsHIN,"hin");
	    demographicID = db.getString(rsHIN,"demographic_no");
	}
	rsHIN.close();
	
	
	//---------------------------------------------------------------------------------------------------
	//get segmentID's which are the lab_no's
	String sqlLABS = "SELECT lab_no, date_format(obr_date, '%M %d, %Y')AS date FROM hl7TextInfo WHERE health_no='" + hin + "' ORDER BY lab_no DESC";
	ResultSet rsLABS = db.GetSQL(sqlLABS);
		
	ArrayList labArray=new ArrayList();
	
	ArrayList labDateArray=new ArrayList();
	
	
	while(rsLABS.next()){
		labArray.add(db.getString(rsLABS,"lab_no"));
		labDateArray.add(db.getString(rsLABS,"date"));
	}
	rsLABS.close();
	
	String segmentID = "";
	
	
	String sQueryCheck = request.getParameter("segmentID");
	
	if(sQueryCheck!=null ){ //here checking if the querystring exists
		
		//now if this executes then the qs exists but now need to determine if there is a actual value
		if(!sQueryCheck.equals("")){
			//since there is a value change the segmentID to the one being passed via qs
			segmentID = sQueryCheck;
		}else{
		
			//out.print("yes null no value for query string<br>");  //testing
			//default segmentID back to lastest found
			segmentID = labArray.get(0).toString();
		}
	
	}else{
		//grab the latest segmentID
		segmentID = labArray.get(0).toString();
	}
	
	
	//out.print("seg" + segmentID + "<br>");
	
	String test_link="<a href='index.jsp?view=Labs&mrn="+strMrn+"&segmentID=";
	
	//---------------------------------------------------------------------------------------------------
	
	Long reqIDL = LabRequestReportLink.getIdByReport("hl7TextMessage",Long.valueOf(segmentID));
	String reqID = reqIDL==null ? "" : String.valueOf(reqIDL);
	
	
	boolean ackFlag = false;
	AcknowledgementData ackData = new AcknowledgementData();
	ArrayList ackList = ackData.getAcknowledgements(segmentID);
	if (ackList != null){
	    for (int i=0; i < ackList.size(); i++){
	        ReportStatus reportStatus = (ReportStatus) ackList.get(i);
	        
	        /* //not collecting the providerNo
	        if ( reportStatus.getProviderNo().equals(providerNo) && reportStatus.getStatus().equals("A") ){
	            ackFlag = true;
	            break;
	        }
	        */
	    }
	}
	Factory f = new Factory();
	MessageHandler handler = f.getHandler(segmentID);
	Hl7textResultsData data = new Hl7textResultsData();
	String multiLabId = data.getMatchingLabs(segmentID);
	
	String hl7 = f.getHL7Body(segmentID);
	
	// check for errors printing
	if (request.getAttribute("printError") != null && (Boolean) request.getAttribute("printError")){
	%>
	<script language="JavaScript">
	    alert("The lab could not be printed due to an error. Please see the server logs for more detail.");
	</script>
	
<%} 
	/* removed since it error then page will be redirected
		}else{
			//some error - todo: make this a logger error
			out.print("MRN key is available but seems to be empty!");
		}

		
	}else{

		//some null error - todo: make this a logger error
		out.print("MRN appears to be missing.");
			
	}	
	
	*/
	
	//end of labs--------------------------------------------------------------------------------------------

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
int tblWidth=790; //sub tables

//-- Switch Control --
String view = request.getParameter("view");
if(view == null || view.equals("")) {
	view=navArray[0];
}
String LinkParam="NavMenu";
			


String patientName = demographic.getFormattedName().toUpperCase();

%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<title>oscarFacesheet - Portlet Integration</title>
<script language="javascript" type="text/javascript" src="../share/javascript/Oscar.js" ></script>

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


/*
.AbnormalRes {  font-size: 10pt; color: red; font-family: Arial, Verdana, Helvetica }
.AbnormalRes a:link { color: red }
.AbnormalRes a:hover { color: red }
.AbnormalRes a:visited { color: red }
.AbnormalRes a:active { color: red }

.NormalRes   { font-size: 10pt; color: black; font-family: Arial, Verdana, Helvetica }
.NormalRes a:link { color: black }
.NormalRes a:hover { color: black }
.NormalRes a:visited { color: black }
.NormalRes a:active { color: black }

.HiLoRes     {  font-size: 10pt; color: blue; font-family: Arial, Verdana, Helvetica }
.HiLoRes a:link { color: blue }
.HiLoRes a:hover { color: blue }
.HiLoRes a:visited { color: blue }
.HiLoRes a:active { color: blue }

.Field2      { font-weight: bold; font-size: 10pt; color: #003162; font-family: Arial, Verdana, Helvetica }


.Cell        { background-color: #BABA97; border-left: thin solid #DCDCCB; 
               border-right: thin solid #959579; 
               border-top: thin solid #DCDCCB; 
               border-bottom: thin solid #959579 }
*/


.RollRes     { font-weight: 700; font-size: 10px; color: white; font-family: 
               Verdana, Arial, Helvetica }
.RollRes a:link { color: white; font-size: 10px; }
.RollRes a:hover { color: white; font-size: 10px; }
.RollRes a:visited { color: white; font-size: 10px; }
.RollRes a:active { color: white; font-size: 10px; }
.AbnormalRollRes { font-weight: 700; font-size: 10px; color: red; font-family: 
               Verdana, Arial, Helvetica }
.AbnormalRollRes a:link { color: red; font-size: 10px; }
.AbnormalRollRes a:hover { color: red; font-size: 10px; }
.AbnormalRollRes a:visited { color: red; font-size: 10px; }
.AbnormalRollRes a:active { color: red; font-size: 10px; }
.CorrectedRollRes { font-weight: 700; font-size: 10px; color: yellow; font-family: 
               Verdana, Arial, Helvetica }
.CorrectedRollRes a:link { color: yellow; font-size: 10px; }
.CorrectedRollRes a:hover { color: yellow; font-size: 10px; }
.CorrectedRollRes a:visited { color: yellow; font-size: 10px; }
.CorrectedRollRes a:active { color: yellow; font-size: 10px; }
.AbnormalRes {  font-size: 10px; color: red; font-family: 
               Verdana, Arial, Helvetica }
.AbnormalRes a:link { color: red; font-size: 10px; }
.AbnormalRes a:hover { color: red; font-size: 10px; }
.AbnormalRes a:visited { color: red; font-size: 10px; }
.AbnormalRes a:active { color: red; font-size: 10px; }
.NormalRes   {  font-size: 10px; color: black; font-family: 
               Verdana, Arial, Helvetica }
.NormalRes a:link { color: black; font-size: 10px; }
.NormalRes a:hover { color: black; font-size: 10px; }
.NormalRes a:visited { color: black; font-size: 10px; }
.NormalRes a:active { color: black; font-size: 10px; }

.HiLoRes     {  font-size: 10px; color: blue; font-family: 
               Verdana, Arial, Helvetica }
.HiLoRes a:link { color: blue; font-size: 10px; }
.HiLoRes a:hover { color: blue; font-size: 10px; }
.HiLoRes a:visited { color: blue; font-size: 10px; }
.HiLoRes a:active { color: blue; font-size: 10px; }
.CorrectedRes {  font-size: 10px; color: #E000D0; font-family: 
               Verdana, Arial, Helvetica }
.CorrectedRes a:link { color: #6da997; font-size: 10px; }
.CorrectedRes a:hover { color: #6da997; font-size: 10px; }
.CorrectedRes a:visited { color: #6da997; font-size: 10px; }
.CorrectedRes a:active { color: #6da997; font-size: 10px; }


table.labStyle tr{background-color: #ffffff;}

.Header      { font-weight: bold; font-size: 14px; color: #000000; font-family: 
               Verdana, Arial, Helvetica }
               
.HeaderCell  { background-color: #BABA97; border-left: thin solid #CCCCCC; 
               border-right: thin solid #8D8D69; 
               border-top: thin solid #CCCCCC; 
               border-bottom: thin solid #8D8D69 }
               
.Title   	 { font-weight: 400; font-size: 12px; color: #000000; font-family: 
               Verdana, Arial, Helvetica }


</style>

<script type="text/javascript" language="javascript"> 
	function changeView(name) {		
		<%
			for(int x=0;x<navArray.length;x++) {
				
				%>if(name == '<%=navArray[x]%>') {document.getElementById('<%=navArray[x]%>').style.display='block'; document.getElementById('main_title').innerHTML='<%=navArray[x]%>';document.getElementById('nav_<%=navArray[x]%>').className='noLink';}<%
				out.println();
				%>else {document.getElementById('<%=navArray[x]%>').style.display='none';document.getElementById('nav_<%=navArray[x]%>').className='';}<%
				out.println();
			}
		%>		
	}
	
	function chaneViewOnload(){
		
		<%	
		//added this to hold the view for the labs but can be used for other sect
		String getView = request.getParameter("view");
		if(getView!=null){
			
			out.println("changeView('"+getView+"');");
			
		}else{
			//out.print("alert('error on load');");
		}
		%>
	}
	
    function popupStart(vheight,vwidth,varpage,windowname) {
        var page = varpage;
        windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes";
        var popup=window.open(varpage, windowname, windowprops);
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

<body bgcolor="#F7F7EC" onLoad="chaneViewOnload();">

<!--main wrapper table -->
<table cellpadding="0" cellspacing="0" width="980">	
	<td>
	
	<!--start of search table-->
	<table width="100%" cellspacing='0' cellpadding="1" bgcolor="#BABA97" border="0" >
		<tr >
			<td align="left">
			<font color="#333333" size="3"><b>Patient: <%=patientName%> </b></font>
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
								if(socialHistory.size()>0){
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
							<% } 
							
							}else{
								
							%>
							<tr>
								<td bgcolor="#996633" height="16"> </td>
							</tr>
							<tr>
								<td bgcolor="#ffffff">
									<font size="2"><b>No Social History found for this patient.</b>
									<br />
									<i></i>
									<p><font size="2">
																	
									</font></p></font>							
								</td>
							</tr>	
							<%
								}
							%>
						</table>
							
					</td>
					<td valign="top">
					<table width="300" bgcolor="#8D8D69" cellspacing="1" cellpadding="1" align="left">
							<%
							iter = medicalHistory.iterator();
							
							if(medicalHistory.size()>0){				
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
							<% } 
							
							}else{
							%>		
							<tr><td bgcolor="#993333" height="16"> </td></tr>
							
							<tr><td bgcolor="#ffffff">
							<font size="2"><b>No Medical History found for this patient.</b><br />
							<i></i>

							<p><font size="2">
							
							</font>
							</p>

							</font>
							
							</td></tr>								
								
								
							<%
							}	
							%>
						</table>
						
						
					</td>
					
					<td valign="top">
					<table width="300" bgcolor="#8D8D69" cellspacing="1" cellpadding="1" align="left">
							<%
							iter = familyHistory.iterator();
							
							if(familyHistory.size()>0){		
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
							<% } 
							
							}else{
							%>		
							<tr><td bgcolor="#006600" height="16"> </td></tr>
							<tr><td bgcolor="#ffffff">
							<font size="2"><b>No Family History found for this patient.</b><br />
							<i></i>
														
							<p><font size="2">
							
							</font>
							</p>

							</font>
							
							</td></tr>							
							
							<%	
							}
							
							%>
						</table>
					</td>
					</tr>
					</table>
					</div>
					
					<div id="Measurements" style="display:none;">
					<!--Table alloted for Legend-->
					<table width="<%=tblWidth%>"><td align="right">&nbsp;</td></table>
					
					<table width="340" bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr class="patient_list_head">
					<td>Type</td><td>Measurement</td><td>Date</td>
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
						<td>Waist Circ (cm)</td>
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
					<table width="<%=tblWidth%>"><td align="right"> &nbsp;</td></table>
					<!-- 
					<table width="<%=tblWidth%>"><td align="right"><img src="images/notes.gif" border="0" width="10" height="12" alt="rxAnnotation"><font size="1"> = rxAnnotation</font></td></table>
					-->
					<table width="<%=tblWidth%>"  bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr  class="patient_list_head">
					<td><bean:message key="SearchDrug.msgRxDate"/></td><td><bean:message key="SearchDrug.msgPrescription"/></td>
					</tr>
					<%
					SimpleDateFormat rxFormatter = new SimpleDateFormat("yyyy-MM-dd");
					
					if(prescriptDrugs.size()>0){
					for (Drug prescriptDrug : prescriptDrugs) {
					
				        if( prescriptDrug.isArchived() )
				            continue;		     
				        
					%>
					<tr class="patient_list_results">
						<td><%=rxFormatter.format(prescriptDrug.getRxDate()) %></td>
						<td><%=prescriptDrug.getSpecial()%></td>

					</tr>					
					
					<% } 
					
					}else{
					%>
					
					<tr class="patient_list_results"><td colspan="2"> No medication's found for patient: <i><%=patientName%></i>.</td></tr>
					<%} %>
					</table>
					</div>
					
					<div id="Labs" style="display:none;">
					<!--Table alloted for Legend-->
					<table width="970">
						<td align="right"> 		                            	
                        	<!-- 
                        	<input type="image" src="../images/Print16x16.gif" name="Print" title="Print" onClick="alert('Sorry the print option is still being tested.');printPDF()">
		            		-->
		            	</td>
		            </table>
<!-- 
Lab notes 
- need to add legend or clean way to describe flagging.
- clean up alignment
- think about the Field2 css
-->	
				  	
   	
<table cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top" width="170" >
		
		<table cellpadding="2" cellspacing="1" bgcolor="#000000">
		<tr>
			<td class="HeaderCell" align="left">
				<font size="2"><b title="Displaying all labs 365 days back."> Observation Dates: </b></font>
			</td>
		</tr>	
		<%		
		String strLabTitle="";
		
		for(int labs=0;labs < labArray.size();labs++){
			
			
			//if(labs==0){strLabTitle="Most Recent Lab: ";}else{strLabTitle="Past Lab: ";}
			if(labs==0){strLabTitle=" ";}else{strLabTitle=" ";} //probably remove - but for now leave it in as a reminder may be using for an image or style
				%>
				
				<tr >
				
				
				<%
				if(labArray.get(labs).toString().equals(segmentID)){
					out.print("<td valign='middle' width='155' height='18' bgcolor='#E0E0FF'>");
					//out.print(labArray.get(labs).toString() + " <font size='2' color='#336600'> <b> > "+strLabTitle + labDateArray.get(labs).toString() + "</b></font> <br>");
					out.print(" <font size='1' color='#000000'> <b> "+strLabTitle + labDateArray.get(labs).toString() + "</b></font> <br>");
				}else{
					out.print("<td valign='middle' width='130' height='18' bgcolor='#FFFFFF'>");
					//out.print(strLabTitle + labArray.get(labs).toString() + " " + test_link + labArray.get(labs).toString() + "'>"+labDateArray.get(labs).toString()+"</a> <br>");
					out.print(strLabTitle + " <font size='1'>" + test_link + labArray.get(labs).toString() + "'>"+labDateArray.get(labs).toString()+"</a></font> <br>");
				}
				%>
				</td>
				</tr>
				
				<%
		}
		%>
		</table>
		</td>
		<td valign="top">
                      <!-- oscar viewer table width is 980 -->
                        <table width="800" border="0" cellspacing="1" cellpadding="2" bgcolor="#000000" bordercolor="#9966FF" bordercolordark="#bfcbe3" name="tblDiscs" id="tblDiscs" class="labStyle">
                            <tr>
                            	<td colspan="8" class="HeaderCell">
	                            	<table width="100%" >
	                            	<tr>
		                            	<td width="140" bgcolor='#BABA97' valign="top" align="left">

		                            	<font size="4"><b>
		                            	<%if(handler.getPatientLocation().equals("J")){
		                            		out.print("HRLIS");	
		                            	}else{
		                            		out.print(handler.getPatientLocation());
		                            	}
		                            	%>
		                            	</b></font>
		                            	</td>
		                            	<td width="350" bgcolor='#BABA97'>
		                            	<font size="2"><b><bean:message key="oscarMDS.segmentDisplay.formRequestingClient"/>:</b> <%=handler.getDocName()%>
		                            	<br />
		                            	<b><bean:message key="oscarMDS.segmentDisplay.formClientRefer"/>:</b> <%= handler.getClientRef()%></font>
		                            	</td>
		                         		<td bgcolor='#BABA97'>
		                            	<font size="2"><b><bean:message key="oscarMDS.segmentDisplay.formDateService"/>:</b> <%= handler.getServiceDate() %> <br />
		                            	<b><bean:message key="oscarMDS.segmentDisplay.formAccession"/>:</b> <%= handler.getAccessionNum()%></font> 
		                            	</td>

	                            	</tr>
	                            	</table>
                            	</td>
                            </tr>	
                            
                            <%
                            if (multiLabId != null){
                                String[] multiID = multiLabId.split(",");
                                if (multiID.length > 1){
                                    %>
                                    <tr>
                                        <td  bgcolor='#D6D6C2' valign="middle" align="center" colspan="8">
                                            
                                                Version:&#160;&#160;
                                                <%
                                                for (int iML=0; iML < multiID.length; iML++){
                                                    if (multiID[iML].equals(segmentID)){
                                                        %>v<%= iML+1 %>&#160;<%
                                                    }else{
															//will need to correct this
                                                            %><a href="index.jsp?mrn=<%=strMrn%>&segmentID=<%=multiID[iML]%>&multiID=<%=multiLabId%>">v<%= iML+1 %></a>&#160;<%
                                                        
                                                    }
                                                }
                                                %>
                                            
                                        </td>
                                    </tr>
                                    <%
                                }
                            }
                            %>
                                                      
                       
                        <% int iHeadCount=0;
                        int j=0;
                        int k=0;
                        int l=0;
                        int linenum=0;
                        String highlight = "background-color:#E0E0FF";
                        
                        ArrayList headers = handler.getHeaders();
                        int OBRCount = handler.getOBRCount();
                        for(iHeadCount=0;iHeadCount<headers.size();iHeadCount++){
                           // linenum=0;
                        %>
                                                  
                            <tr class="Header">
                                <td colspan="8"  class="HeaderCell">
                                 <%
                                 String h = headers.get(iHeadCount).toString();
                                 //h=h.replaceAll("[^A-Za-z ]", "");
                                 out.print(h);
                                 %>
                                </td>
                            </tr>
                            
                            <tr class="Title">
                                <td width="25%" align="center" valign="bottom" bgcolor="#D6D6C2" ><bean:message key="oscarMDS.segmentDisplay.formTestName"/></td>
                                <td width="7%" align="center" valign="bottom" bgcolor="#D6D6C2"><bean:message key="oscarMDS.segmentDisplay.formResult"/></td>
                                <td width="4%" align="center" valign="bottom" bgcolor="#D6D6C2"><bean:message key="oscarMDS.segmentDisplay.formAbn"/></td>
                                <td width="10%" align="center" valign="bottom" bgcolor="#D6D6C2"><bean:message key="oscarMDS.segmentDisplay.formReferenceRange"/></td>
                                <td width="8%" align="center" valign="bottom" bgcolor="#D6D6C2"><bean:message key="oscarMDS.segmentDisplay.formUnits"/></td>
                                <td width="15%" align="center" valign="bottom" bgcolor="#D6D6C2"><bean:message key="oscarMDS.segmentDisplay.formDateTimeCompleted"/></td>
                                <td width="5%" align="center" valign="bottom" bgcolor="#D6D6C2"><bean:message key="oscarMDS.segmentDisplay.formNew"/></td>
                            </tr> 
                            <%

                            for ( j=0; j < OBRCount; j++){
                                
                                boolean obrFlag = false;
                                int obxCount = handler.getOBXCount(j);
                                for (k=0; k < obxCount; k++){ 
                                    String obxName = handler.getOBXName(j, k);
                                    if ( !handler.getOBXResultStatus(j, k).equals("DNS") && !obxName.equals("") && handler.getObservationHeader(j, k).equals(headers.get(iHeadCount))){ // <<--  DNS only needed for MDS messages
                                        String obrName = handler.getOBRName(j);
                                        if(!obrFlag && !obrName.equals("") && !(obxName.contains(obrName) && obxCount < 2)){%>
                                            <tr style="<%=( (linenum++) % 2 == 1 ? highlight : "")%>" >
                                                <td valign="top" align="left" colspan="7" style="font-size: 10px;">&nbsp; <%=obrName%></td>
                                                
                                            </tr>
                                            <%obrFlag = true;
                                        }
                                        
                                        String lineClass = "NormalRes";
                                        String abnormal = handler.getOBXAbnormalFlag(j, k);
                                        if ( abnormal != null && abnormal.startsWith("L")){
                                            lineClass = "HiLoRes";
                                        } else if ( abnormal != null && ( abnormal.equals("A") || abnormal.startsWith("H") || handler.isOBXAbnormal( j, k) ) ){
                                            lineClass = "AbnormalRes";
                                        }%>
                                        <%
                                        String imgComment="<img src='images/comment.png' border='0' title='Comment'>";
                                        String comment_bgcolor="";
                                        if(handler.getOBXCommentCount(j, k)>0){
                                        	comment_bgcolor=""; //was bgcolor='#EBD699' but was asked to take out the coloring
                                        }
                                        
                                        if(handler.getOBXValueType(j,k) != null &&  handler.getOBXValueType(j,k).equalsIgnoreCase("FT")){
                                            String[] dividedString  =divideStringAtFirstNewline(handler.getOBXResult( j, k));
                                            
                                            
                                            //determine if there is a Formatted Text Comment to display and if the expande control his displayed here or down below
                                            String comment_xpand="";
                                            if (handler.getObservationHeader(j, 0).equals(headers.get(iHeadCount)) && handler.getOBRCommentCount(j)>0 && !obrFlag &&  handler.getOBXName(j, 0).equals("")) {
                                            	comment_xpand=imgComment;
                                            }	
                                            %>
                                            
                                            <!--  row colour onclick=#FFFF66 -->
                                            <tr style="<%=( (linenum++) % 2 == 1 ? highlight : "")%>" class="<%=lineClass%>">
                                                <td valign="top" align="left"><table width="100%" ><tr style="<%=( linenum % 2 == 1 ? "" : highlight)%>"><td align="left"><%= obrFlag ? "&nbsp; &nbsp; &nbsp;" : "&nbsp;" %><a href="javascript:popupStart('660','900','../lab/CA/ON/labValues.jsp?testName=<%=obxName%>&demo=<%=demographicID%>&labType=HL7&identifier=<%= handler.getOBXIdentifier(j, k) %>')"><%=obxName %> </a></td><td align="right"> <%=comment_xpand%> </td></tr></table> </td>
                                                <td align="center"><%= dividedString[0] %></td>
                                                <td align="center" valign="top"><%= handler.getOBXAbnormalFlag(j, k)%></td>
                                                <td align="center" valign="top"><%=handler.getOBXReferenceRange( j, k)%></td>
                                                <td align="center" valign="top"><%=handler.getOBXUnits( j, k) %></td>
                                                <td align="center" valign="top"><%= handler.getTimeStamp(j, k) %></td>
                                                <td align="center" valign="top"><%= handler.getOBXResultStatus( j, k) %></td>
                                            </tr>
                                            <%if(dividedString[1] != null){ %>
                                            <tr>
                                                <td colspan="7" style="padding-left:10px;font-size: 10px;" ><%=dividedString[1]%></td>
                                            </tr>
                                            <%}%>
                                        <%}else{%>
                                        <!-- remember to remove comment_bg_color if it is not going to be used -->
                                        <tr style="<%=( (linenum++) % 2 == 1 ? highlight : "")%>" class="<%=lineClass%>" id="<%=obrName + j%>">
                                            <td valign="top" align="left" <%=comment_bgcolor%> ><table width="100%" ><tr style="<%=( linenum % 2 == 1 ? "" : highlight)%>"><td align="left" ><%= obrFlag ? "&nbsp; &nbsp; &nbsp;" : "&nbsp;" %><a href="javascript:popupStart('660','900','../lab/CA/ON/labValues.jsp?testName=<%=obxName%>&demo=<%=demographicID%>&labType=HL7&identifier=<%= handler.getOBXIdentifier(j, k) %>')"><%=obxName %> </a> </td> <td align="right" <%=comment_bgcolor%>> <%if(handler.getOBXCommentCount(j, k)>0){ %> <a href="javascript:void(0);" onclick="showHideItem('<%="comment_" + obxName + j%>')" ><%=imgComment %></a> <%}%></td></tr></table> </td>                                         
                                            <td align="center" <%=comment_bgcolor%> ><%= handler.getOBXResult( j, k) %></td>
                                            <td align="center" <%=comment_bgcolor%> ><%= handler.getOBXAbnormalFlag(j, k)%></td>
                                            <td align="center" <%=comment_bgcolor%> ><%=handler.getOBXReferenceRange( j, k)%></td>
                                            <td align="center" <%=comment_bgcolor%> ><%=handler.getOBXUnits( j, k) %></td>
                                            <td align="center" <%=comment_bgcolor%> ><%= handler.getTimeStamp(j, k) %></td>
                                            <td align="center" <%=comment_bgcolor%> ><%= handler.getOBXResultStatus( j, k) %></td>
                                        </tr>
                                        <%}%>
                                        <%
                                        //comment - Standard generated added notes(?)
                                        if(handler.getOBXCommentCount(j, k)>0){ %>
                                        <tr class="NormalRes" style="display:none;" id="comment_<%=obxName + j%>">
                                        	<td colspan="8" <%=comment_bgcolor%> >
                                        	<img src="images/branch.png" border="0">
                                        	<table width="100%" cellpadding="0" cellspacing="0">
                                        <%for (l=0; l < handler.getOBXCommentCount(j, k); l++){%>
                                            <tr >
                                                <td width="20"> </td><td valign="top" align="left" <%=comment_bgcolor%> style="font-size: 10px;"><%=handler.getOBXComment(j, k, l)%> <br /><br /></td>
                                            </tr>
                                        <%}%>
                                        	</table>
                                        	</td>
                                        </tr>
                                        	
                                    	<%
                                        }//if handler.getOBXCommentCount 
                                   }
                                }                                                             
 
                             if (handler.getObservationHeader(j, 0).equals(headers.get(iHeadCount))) {%>
                                <%for (k=0; k < handler.getOBRCommentCount(j); k++){				
                                    // the obrName should only be set if it has not been
                                    // set already which will only have occured if the
                                    // obx name is "" or if it is the same as the obr name
                                    if(!obrFlag && handler.getOBXName(j, 0).equals("")){%>
                                        <tr style="<%=( (linenum++) % 2 == 1 ? highlight : "")%>" >
                                            <td valign="top" align="left" colspan="7" style="font-size: 10px;">&nbsp; <%=handler.getOBRName(j)%> </td>
                                            
                                        </tr>
                                        <%obrFlag = true;
                                    }%>
                                    
                                                                      
                                <tr style="<%=( (linenum++) % 2 == 1 ? highlight : "")%>" class="NormalRes">
                                <%
                                //Free from type text or comment
                                ////HL7  [GDML - FT = Formatted Text] or [HRLIS - NTE] or [CML - NTE] or [MDS - ?ZMC ] %>
                                    <td valign="top" align="left" colspan="8"><pre  style="margin:0px 0px 0px 100px; font-size: 10px;" ><%=handler.getOBRComment(j, k)%> </pre></td>
                                </tr>
                                
                                <% if(handler.getOBXName(j,k).equals("")){
                                       String result = handler.getOBXResult(j, k);%>
                                        <tr style="<%=( (linenum++) % 2 == 1 ? highlight : "")%>" >
                                                <td colspan="7" valign="top"  align="left"><pre  style="margin:0px 0px 0px 100px; font-size: 10px;"><%=result%> </pre></td>
                                        </tr>
                                            <%
                            		}


                                }
                            }
                            }%>
                        
                        <% // end for headers
                        }  // for i=0... (headers) %>
                        </table> 
                    </td>
                </tr>
            </table>
            
            
			</td>
		</tr>
	</table>
	
	<form name="acknowledgeForm" method="post" action="../../../oscarMDS/UpdateStatus.do">
	    <input type="hidden" name="segmentID" value="<%= segmentID %>"/>
	    <input type="hidden" name="multiID" value="<%= multiLabId %>" />
	    
	    <!-- more future use(?) -->
	    <input type="hidden" name="status" value="A"/>
	    <input type="hidden" name="comment" value=""/>
	    <input type="hidden" name="labType" value="HL7"/>
	</form> 	             
   
<%!
    public String[] divideStringAtFirstNewline(String sx){
        int x = sx.indexOf("<br />");
        String[] ret  = new String[2];
        if(x == -1){
               ret[0] = new String(sx);
               ret[1] = null;
            }else{
               ret[0] = sx.substring(0,x);
               ret[1] = sx.substring(x+6);
            }
        return ret;
    }

//END OF LABS------------------------------------------------------------------------------------------- 
%>

					</div>
					
					<div id="eForms" style="display:none;">
				<table  width="550">
				<tr >
				<td align="right">
				<font size="2"><b><font color="red">Note:</font></b> eForms presented here are READ ONLY. Any changes you make will not be saved.</font>
				</td>
				</tr>
				</table>


				<table  width="550" bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr  class="patient_list_head">
						<td>Modified Date</td> 	<td>eForm</td> 
					</tr>
			<%
			//set eform_data_id to read only for all eforms
        	session.setAttribute("eform_data_id", "r");
			
 			ArrayList eForms;

     		String str_demographic_no= Integer.toString(demographic_no); 
			eForms = EFormUtil.listPatientEForms(orderBy, EFormUtil.CURRENT, str_demographic_no);
      
			  for (int ef=0; ef< eForms.size(); ef++) {
			        Hashtable curform = (Hashtable) eForms.get(ef);
			%>
					<tr class="patient_list_results" bgcolor="<%= ((ef%2) == 1)?"#F2F2F2":"white"%>">
						
						<td align='left' width="105"><%=curform.get("formDate")%></td>
						<td><a href="#"
							ONCLICK="popupPage('../eform/efmshowform_data.jsp?fdid=<%= curform.get("fdid")%>', '<%="ReadOnly" + ef%>'); return false;"
							TITLE="<bean:message key="eform.showmyform.msgViewFrm"/>" 
							onmouseover="window.status='<bean:message key="eform.showmyform.msgViewFrm"/>'; return true"><%=curform.get("formName")%></a></td>
						
						
						
					</tr>
			<%
  				}
			 if (eForms.size() <= 0) {
			%>
						<tr class="patient_list_results">
							<td colspan='5'>No eForms found for patient: <i><%=patientName%></i>. </td>
						</tr>
						<%
			  }
			%>
		</table>
		            </div>	
					
					<div id="eDocuments" style="display:none;">
					<!--Table alloted for Legend-->
					<table width="<%=tblWidth%>"><td align="right"> &nbsp;</td></table>
					
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
							<td width="105"><bean:message key="dms.documentReport.msgDate"/></td>	
							<td ><bean:message key="dms.documentReport.msgDocDesc" /></td>
							<td ><bean:message key="dms.documentReport.msgType"/></td>
							<td ><bean:message key="dms.documentReport.msgCreator" /></td>
								
						</tr>

					<%
	                for (int i2=0; i2<category.size(); i2++) {
	                    EDoc curdoc = (EDoc) category.get(i2);	                    
	            	%>
					<tr  class="patient_list_results">
						<td><%=curdoc.getObservationDate()%></td>	
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
						
						<td><%=curdoc.getType()%></td>
						<td><%=curdoc.getCreatorName()%></td>				
					</tr>
	
					<%}
	            if (category.size() == 0) {%>
					<tr class="patient_list_results">
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
								<td colspan="7" width="100%">No allergy data found for patient: <i><%=patientName%></i>.</td>
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

