<!DOCTYPE html>
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
<%@page import="org.oscarehr.util.LoggedInInfo"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/security.tld" prefix="security"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/caisi-tag.tld" prefix="caisi" %>
<%@ taglib uri="/WEB-INF/oscar-tag.tld" prefix="oscar" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
  LoggedInInfo loggedInInfo=LoggedInInfo.loggedInInfo.get();
  String providerNo=loggedInInfo.loggedInProvider.getProviderNo();

  String roleName$ = (String)session.getAttribute("userrole") + "," + (String) session.getAttribute("user");
%>
<html>
  <head>
    <title>Preferences</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap -->
    <link href="<%=request.getContextPath() %>/library/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet" media="screen">

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="<%=request.getContextPath() %>/library/bootstrap/3.0.0/assets/js/html5shiv.js"></script>
      <script src="<%=request.getContextPath() %>/library/bootstrap/3.0.0/assets/js/respond.min.js"></script>
    <![endif]-->

<style>
body.modal-open {margin-right: 0px} /*needed hack when using the new modal because the right scroll is added*/


.accordion-heading{background-color:#fff;border-bottom:thin solid #C6C6C6;}

.accordion-heading:hover{background-color:#e6e6e6;}
.accordion-heading a:hover{text-decoration:none;}

.glyphicon-chevron-right{opacity:0.3;}

.accordion-heading{ cursor: pointer; cursor: hand; }


.accordion-heading a{   
display: block;
height: 100%;
width: 100%;
text-decoration: none;
}

.accordion-heading:hover > a:link{ }

.accordion-heading:hover > a >.glyphicon-chevron-right{opacity: 1 !important;}


.selected-heading{background-color:#e6e6e6;}


.accordion-inner{background-color:#f2f2f2;border-bottom:thin solid #C6C6C6;}

.accordion-inner a{color:#424242;}
.accordion-inner a:hover{text-decoration:none;color:#000; cursor: pointer; cursor: hand;}

.accordion-inner li{border-bottom: thin solid #c6c6c6;padding:2px 0px 2px 20px;}



#adminNav{
margin-right:10px;
margin-bottom:20px
}

#adminNav a{
color:#333;
text-decoration: none;
}

/*
#adminNav a:hover{
color:#0088cc;
}
*/

#adminNav{
-webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.065);
-moz-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.065);
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.065);
}

#adminNav ul{
	padding: 0px;
	margin: 0px;
	list-style-type: none;
}

 
/* this is to stop the left shift when content loaded into dynamic-content */
@media (min-width: 768px) and (max-width: 1400px) { 
	html {
	overflow: -moz-scrollbars-vertical; 
	overflow-y: scroll;
	}
}
</style>

  </head>
  <body>



<!-- <div class="container">-->

	<div class="row">

        <div class="col-lg-3">
            
<!--//--------------------------------------------------->



<div class="accordion" id="adminNav">		
<div class="accordion-group nav nav-tabs">
			
			<div class="accordion-heading well-sm">
			<span class="glyphicon glyphicon-cog"></span> Preferences
			</div>


				<!-- #Billing -->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseBilling">
				Billing
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseBilling" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					
						<li><a href="javascript:void(0);" class="xlink" rel='<%=request.getContextPath() %>/provider/providerDefaultDxCode.jsp?provider_no=<%=request.getParameter("provider_no") %>'>Edit Default Billing Diagnostic Code</a></li>
					
					
						<security:oscarSec roleName="<%=roleName$%>" objectName="_billing" rights="r">
						<li>
						<a href="javascript:void(0);"><bean:message key="provider.btnBillPreference"/></a>
						</li>
						</security:oscarSec>
					</ul>
				</div>
				</div><!-- #Billing -->



				<!-- #Consultations -->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseConsultations">
				Consultations
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseConsultations" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					

						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewConsultationRequestCuffOffDate"><bean:message key="provider.btnSetConsultationCutoffTimePeriod"/></a></li>

						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewConsultationRequestTeamWarning"><bean:message key="provider.btnSetConsultationTeam"/></a></li>

						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewConsultPasteFmt"><bean:message key="provider.btnSetConsultPasteFmt"/></a></li>

					</ul>
				</div>
				</div><!-- #Consultations -->




				<!-- #Documents -->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseDocuments">
				Documents
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseDocuments" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewEDocBrowserInDocumentReport"><bean:message key="provider.btnSetEDocBrowserInDocumentReport"/></a></li>
					
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/admin/displayDocumentDescriptionTemplate.jsp"><bean:message key="provider.btnSetDocumentDescriptionTemplate"/></a></li>
					</ul>
				</div>
				</div><!-- #Documents -->


				<!-- #eForms -->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseeForms">
				eForms
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseeForms" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewFavouriteEformGroup"><bean:message key="provider.btnSetEformGroup"/></a></li>

					</ul>
				</div>
				</div><!-- #eForms -->



				<!-- #Encounter -->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseEncounter">
				Encounter
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseEncounter" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/provider/providerColourPicker.jsp"><bean:message key="provider.btnEditColour"/></a></li>
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewCppSingleLine"><bean:message key="provider.btnSetCppSingleLine"/></a></li>

						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=view&provider_no=<%=providerNo%>"><bean:message key="provider.btnEditStaleDate"/></a></li>

						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/provider/../provider/CppPreferences.do"><bean:message key="provider.cppPrefs" /></a></li>

						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewEncounterWindowSize"><bean:message key="provider.btnEditDefaultEncounterWindowSize"/></a></li>

						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewQuickChartSize"><bean:message key="provider.btnEditDefaultQuickChartSize"/></a></li>

					</ul>
				</div>
				</div><!-- #Encounter -->




				<!-- #Inbox-->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseInbox">
				Inbox
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseInbox" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewCommentLab"><bean:message key="provider.btnDisableAckCommentLab"/></a></li>
					
					</ul>
				</div>
				</div><!-- #Inbox -->

				<!-- #Integration -->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseIntegration">
				Integration
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseIntegration" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/provider/../provider/OlisPreferences.do"><bean:message key="provider.olisPrefs" /></a></li>
					
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/provider/clients.jsp"><bean:message key="provider.btnEditClients"/></a></li>
					</ul>
				</div>
				</div><!-- #Integration-->



				<!-- #Master Demographic -->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseMasterDemographic">
				Master Demographic
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseMasterDemographic" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewDefaultSex"><bean:message key="provider.btnSetDefaultSex" /></a></li>
					
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewHCType"><bean:message key="provider.btnSetHCType" /></a></li>

						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewEDocBrowserInMasterFile"><bean:message key="provider.btnSetEDocBrowserInMasterFile"/></a></li>
					</ul>
				</div>
				</div><!-- #Master Demographic -->




				<!-- #Profile -->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseProfile">
				Profile
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseProfile" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/provider/providerchangepassword.jsp"><bean:message key="provider.btnChangePassword"/></a></li>
					
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/provider/providerAddress.jsp"><bean:message key="provider.btnEditAddress"/></a></li>
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/provider/providerPhone.jsp"><bean:message key="provider.btnEditPhoneNumber"/></a></li>
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/provider/providerFax.jsp"><bean:message key="provider.btnEditFaxNumber"/></a></li>
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewMyDrugrefId"><bean:message key="provider.btnSetmyDrugrefID"/></a></li>
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewWorkLoadManagement"><bean:message key="provider.btnSetWorkLoadManagement"/></a></li>
					</ul>
				</div>
				</div><!-- #Profile -->

				<!-- #Rx -->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseRx">
				Rx
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseRx" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					
						<li><a href="#">QR Codes</a></li>
					
						<li><a href="#"><bean:message key="provider.providerpreference.rxInteractionWarningLevel" /></a></li>
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/provider/providerSignature.jsp"><bean:message key="provider.btnEditSignature"/></a></li>
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewRxPageSize"><bean:message key="provider.btnSetRxPageSize"/></a></li>
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewUseRx3"><bean:message key="provider.btnSetRx3"/></a></li>
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewDefaultQuantity"><bean:message key="provider.SetDefaultPrescriptionQuantity"/></a></li>
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewShowPatientDOB"><bean:message key="provider.btnSetShowPatientDOB"/></a></li>
					</ul>
				</div>
				</div><!-- #Rx -->



				<!-- #Schedule -->
				<div class="accordion-heading well-sm">
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#adminNav" data-target="#collapseSchedule">
				Schedule
				<span class="glyphicon glyphicon-chevron-right pull-right"></span> 
				</a>
				</div>
				<div id="collapseSchedule" class="accordion-body collapse">
				<div class="accordion-inner">
					<ul>					
						<li>1</li>
					
					
						<li><a href="javascript:void(0);" class="xlink" rel="<%=request.getContextPath() %>/setProviderStaleDate.do?method=viewPatientNameLength"><bean:message key="provider.btnEditSetPatientNameLength"/></a></li>
					</ul>
				</div>
				</div><!-- #Schedule -->






</div> <!-- ACCORDION GROUP END -->	
</div> <!-- ACCORDION END -->

<!--//-------------------------------------------------->
        </div>
        <div class="col-lg-8"  id="dynamic-content">
            
            
        </div>

	</div><!--row-->
<!-- </div><!-- /.container -->


    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="<%=request.getContextPath() %>/js/jquery-1.9.1.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="<%=request.getContextPath() %>/library/bootstrap/3.0.0/js/bootstrap.min.js"></script>

<script>

//this will load the iframe into the dynamic-content div when lick is clicked
$(".xlink").click(function(e) {
	var source = $(this).attr('rel');

	$("#dynamic-content").html('<iframe id="myFrame" name="myFrame" frameborder="0" width="800" height="1000" src="'+source+'">');
});


</script>
  </body>
</html>
