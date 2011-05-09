<%@ page language="java" info="Provider Portal Integration" %>
<%@ include file="/taglibs.jsp"%>

<%@page import="org.oscarehr.common.model.Demographic"%>
<%@page import="org.oscarehr.common.model.DemographicCust"%>
<%@page import="org.oscarehr.common.dao.DemographicCustDao"%>
<%@page import="org.oscarehr.util.SpringUtils"%>
<%@page import="org.oscarehr.util.MiscUtils"%>
<%@page import="org.oscarehr.PMmodule.dao.ClientDao"%>
<%@page import="java.util.List"%>
<%@page import="oscar.util.StringUtils"%>

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
text-decoration: none; color: #003162; font-size:12px;
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
				
				%>if(name == '<%=navArray[x]%>') {document.getElementById('<%=navArray[x]%>').style.display='block'; document.getElementById('main_title').innerHTML='<%=navArray[x]%>';}<%
				out.println();
				%>else {document.getElementById('<%=navArray[x]%>').style.display='none';}<%
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
					//create the navigation options and underline and bold if item is selected
					if (navArray[i].equals(view)) {
						out.print("<span class='noLink'><b><u>"+navArray[i]+"</u></b></span> | ");		
					
					}else{
						out.print("<a href='#' onclick=\"changeView('"+navArray[i]+"');return false;\" class='"+LinkParam+"'>");
							out.print(navArray[i]);
						out.print("</a> | ");	
					}
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
							<tr><td bgcolor="#996633" height="16"> </td></tr>
							<tr><td bgcolor="#ffffff">
							<font size="2"><b>Documentation Date: 05-Aug-2010 14:57</b><br />
							<i>Signed by oscartrain, oscartrain</i>
						
							

							<p><font size="2">
							On ODSP<br />
							lives alone<br />
							minimal family supports<br />
							</p>

							</font>
							
							</td></tr>
						</table>
							
					</td>
					<td>
					<table width="300" bgcolor="#8D8D69" cellspacing="1" cellpadding="1" align="left">
							<tr><td bgcolor="#993333" height="16"> </td></tr>
							
							<tr><td bgcolor="#ffffff">
							<font size="2"><b>Documentation Date: 05-Aug-2010 14:57</b><br />
							<i>Signed by oscartrain, oscartrain</i>
							
							
							
							

							<p><font size="2">
							On ODSP<br />
							lives alone<br />
							minimal family supports<br />
							</p>

							</font>
							
							</td></tr>
						</table>
						
						
					</td>
					
					<td>
					<table width="300" bgcolor="#8D8D69" cellspacing="1" cellpadding="1" align="left">
							<tr><td bgcolor="#006600" height="16"> </td></tr>
							<tr><td bgcolor="#ffffff">
							<font size="2"><b>Documentation Date: 05-Aug-2010 14:57</b><br />
							<i>Signed by oscartrain, oscartrain</i>
							
							
							
							
	
							<p><font size="2">
							On ODSP<br />
							lives alone<br />
							minimal family supports<br />
							</p>

							</font>
							
							</td></tr>
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
					<tr class="patient_list_results"><td>BP</td><td>200/105</td><td>13-Oct-2011</td></tr>					
					<tr class="patient_list_results"><td>HT</td><td>164 cm</td><td>26-Nov-2011</td></tr>
					<tr class="patient_list_results"><td>WT</td><td>164 kg</td><td>26-Nov-2011</td></tr>
					<tr class="patient_list_results"><td>BMI</td><td>25.84</td><td>26-Nov-2011</td></tr>
					</table>
					</div>
					
					<div id="Medications" style="display:none;">
					<!--Table alloted for Legend-->
					<table width="<%=tblWidth%>"><td align="right"><img src="images/notes.gif" border="0" width="10" height="12" alt="rxAnnotation"><font size="1"> = rxAnnotation</font></td></table>
					
					<table width="<%=tblWidth%>"  bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr  class="patient_list_head">
					<td>Rx Date </td><td>	Days to Exp</td><td> 	LT Med </td><td>	Prescription </td><td width="18" align="center">	<img src="images/notes.gif" border="0" alt="rxAnnotation"> </td><td> 	Location Prescribed </td>
					</tr>
					<tr class="patient_list_results"><td>2011-04-25 </td><td>	25</td><td> 	L </td><td>LIPITOR 40MG TABLETS 1 OD Qty:30 Repeats:3 </td><td align="center"> <a href="#" ><img src="images/notes.gif" border="0" alt="rxAnnotation"> </td><td> 	local </td></tr>					
					
					<tr class="patient_list_results"><td>2011-04-25 </td><td>	115</td><td> 	L </td><td>NOVOLIN GE TORONTO INJ 100U/ML 15-20-20-0 for 3 months Qty:12 cartridges Repeats:3 </td><td align="center">	<a href="#"   ><img src="images/notes.gif" border="0" alt="rxAnnotation"> </td><td> 	local </td></tr>		
					
					<tr class="patient_list_results"><td>2011-04-25 </td><td>	355</td><td> 	L </td><td>AVALIDE 150/12.5 MG 1 OD Qty:30 Repeats:3 </td><td align="center">	<a href="#" "><a href="#" alt="rxAnnotation" ><img src="images/notes.gif" border="0" alt="rxAnnotation"></td><td> 	local </td></tr>		
					
					<tr class="patient_list_results"><td>2011-04-25 </td><td>	1165</td><td> 	L </td><td>LANTUS -(CARTRIDGE) SC Hs as directed: for 3 months Qty:2 boxes Repeats:12 </td><td align="center">	<a href="#"   ><img src="images/notes.gif" border="0" alt="rxAnnotation"> </td><td> 	local </td></tr>		
					</table>
					</div>
					
					<div id="Labs" style="display:none;">
					<!--Table alloted for Legend-->
					<table width="<%=tblWidth%>"><td align="right"> &nbsp;</td></table>
					
					<table width="<%=tblWidth%>"  bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr  class="patient_list_head">
					<td>Discipline</td><td> 	Date of Test </td><td>	Requesting Client </td><td>	Result Status </td><td>	Report Status</td>
					</tr>
					<tr  class="patient_list_results"><td>CHEMISTRY </td><td>2010-11-29 21:43:32 </td><td>H.D. FULLER </td><td>Abnormal </td><td>Final</td></tr>					
					<tr  class="patient_list_results"><td>CHEMISTRY </td><td>2010-09-30 22:28:15  </td><td>H.D. FULLER </td><td> </td><td>Final</td></tr>					
					</table>
					</div>
					
					<div id="Allergies">
					<!--Table alloted for Legend-->
					<table width="<%=tblWidth%>"><td align="right"><img src="images/notes.gif" border="0" width="10" height="12" alt="Annotation"><font size="1"> = Annotation</font></td></table>
					
					<table width="<%=tblWidth%>"  bgcolor="#8D8D69" cellspacing="1" cellpadding="1">
					<tr  class="patient_list_head">
					<td>Entry Date</td> 	<td>Description</td> 	<td>Allergy Type</td> 	<td>Severity</td> 	<td>Onset of Reaction</td> 	<td>Reaction</td> 	<td>Start Date</td> <td width="18" align="center">	<img src="images/notes.gif" border="0" alt="Annotation"> </td>
					</tr>
					<tr  class="patient_list_results"><td>2010-12-30</td> 	<td>METFORMIN</td> 	<td>ATC Class </td> 	<td>Moderate</td> 	<td>Immediate</td> 	<td></td> 	<td></td> <td align="center"><a href="#"><img src="images/notes.gif" border="0" alt="Annotation"></a></td></tr>
					<tr  class="patient_list_results"><td>2011-04-25</td> 	<td>PEANUT OIL</td> 	<td>Generic Name </td> 	<td>Moderate</td> 	<td>Immediate</td> 	<td>Itchy throat</td> 	<td></td> <td align="center"><a href="#"><img src="images/notes.gif" border="0" alt="Annotation"></a></td></tr>
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

