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
<%@page import="org.oscarehr.common.dao.SiteDao"%>
<%@page import="org.oscarehr.common.model.Site"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.oscarehr.PMmodule.caisi_integrator.IntegratorFallBackManager" %>
<%@page import="org.oscarehr.util.MiscUtils" %>
<%!
	private List<Site> sites = new ArrayList<Site>();
	private HashMap<String,String[]> siteBgColor = new HashMap<String,String[]>();
%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="oscar.util.DateUtils"%>
<%@page import="org.oscarehr.caisi_integrator.ws.DemographicWs"%>
<%
if (org.oscarehr.common.IsPropertiesOn.isMultisitesEnable()) {
	SiteDao siteDao = (SiteDao)WebApplicationContextUtils.getWebApplicationContext(application).getBean("siteDao");
	sites = siteDao.getAllActiveSites(); 
	//get all sites bgColors
	for (Site st : sites) {
		siteBgColor.put(st.getName(), new String[]{st.getBgColor(), st.getShortName()});
	}
}

  String curProvider_no = (String) session.getAttribute("user");
  String demographic_no = request.getParameter("demographic_no");
  String strLimit1="0";
  String strLimit2="50";
  if(request.getParameter("limit1")!=null) strLimit1 = request.getParameter("limit1");
  if(request.getParameter("limit2")!=null) strLimit2 = request.getParameter("limit2");
  String demolastname = request.getParameter("last_name")==null?"":request.getParameter("last_name");
  String demofirstname = request.getParameter("first_name")==null?"":request.getParameter("first_name");
  String deepColor = "#CCCCFF" , weakColor = "#EEEEFF" ;
  String showDeleted = request.getParameter("deleted");
  String orderby="";
  if(request.getParameter("orderby")!=null) orderby=request.getParameter("orderby");
%>
<%@ page
	import="java.util.*, java.sql.*, java.net.*, oscar.*, oscar.oscarDB.*"
	errorPage="errorpage.jsp"%>
<%@ page import="org.oscarehr.PMmodule.caisi_integrator.CaisiIntegratorManager, org.oscarehr.caisi_integrator.ws.CachedAppointment, org.oscarehr.caisi_integrator.ws.CachedProvider, org.oscarehr.util.LoggedInInfo" %>
<%@page import="org.oscarehr.caisi_integrator.ws.*"%>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean"
	scope="session" />
<%
	String country = request.getLocale().getCountry();
%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="http://www.caisi.ca/plugin-tag" prefix="plugin" %>
<%@ taglib uri="/WEB-INF/caisi-tag.tld" prefix="caisi" %>
<%@ taglib uri="/WEB-INF/special_tag.tld" prefix="special" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/oscar-tag.tld" prefix="oscar"%>
<html:html locale="true">

<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.js"></script> 
   <script>
     jQuery.noConflict();
   </script>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<script>
	var ctx = '<%=request.getContextPath()%>';
</script>

<oscar:customInterface section="appthistory"/>
   
<title><bean:message
	key="demographic.demographicappthistory.title" /></title>
<link rel="stylesheet" type="text/css"
	href="../share/css/OscarStandardLayout.css">
<script type="text/javascript">
<!--

function popupPageNew(vheight,vwidth,varpage) {
  var page = "" + varpage;
  windowprops = "height="+vheight+",width="+vwidth+",location=no,scrollbars=yes,menubars=no,toolbars=no,resizable=yes";
  var popup=window.open(page, "demographicprofile", windowprops);
  if (popup != null) {
    if (popup.opener == null) {
      popup.opener = self;
    }
  }
}
  

//-->


</script>

<script>
	function printVisit() {
		printVisit('');               
	}
	
	function printVisit(cpp) {
		var sels = document.getElementsByName('sel');
		var ids = "";
		for(var x=0;x<sels.length;x++) {
			if(sels[x].checked) {
				if(ids.length>0)
					ids+= ",";
				ids += sels[x].value;
			}
		}		
		location.href=ctx+"/eyeform/Eyeform.do?method=print&apptNos="+ids+"&cpp="+cpp;                
	}
	
	function selectAllCheckboxes() {
		jQuery("input[name='sel']").each(function(){
			jQuery(this).attr('checked',true);
		});
	}
	
	function deselectAllCheckboxes() {
		jQuery("input[name='sel']").each(function(){
			jQuery(this).attr('checked',false);
		});
	}

	function toggleShowDeleted(value) {
		if(value) {
			//show deleted
			//appt_history_w_deleted
			location.href='<%=request.getContextPath()%>/demographic/demographiccontrol.jsp?demographic_no=<%=demographic_no%>&last_name=<%=demolastname%>&first_name=<%=demofirstname%>&orderby=<%=orderby%>&displaymode=appt_history&dboperation=appt_history_w_deleted&limit1=<%=strLimit1%>&limit2=<%=strLimit2%>&deleted=true';
		} else {
			//don't show deleted
			location.href='<%=request.getContextPath()%>/demographic/demographiccontrol.jsp?demographic_no=<%=demographic_no%>&last_name=<%=demolastname%>&first_name=<%=demofirstname%>&orderby=<%=orderby%>&displaymode=appt_history&dboperation=appt_history&limit1=<%=strLimit1%>&limit2=<%=strLimit2%>';
		}
	}
	
	jQuery(document).ready(function(){
		<%if(showDeleted != null && showDeleted.equals("true")) { %>
		jQuery("#showDeleted").attr('checked',true);
		<% } else {%>
		jQuery("#showDeleted").attr('checked',false);
		<%} %>
	});
</script>

<link rel="stylesheet" type="text/css" media="all" href="../share/css/extractedFromPages.css"  />
</head>

<body class="BodyStyle"
	demographic.demographicappthistory.msgTitle=vlink=
	"#0000FF" onLoad="setValues()">
<!--  -->
<table class="MainTable" id="scrollNumber1" name="encounterTable">
	<tr class="MainTableTopRow">
		<td class="MainTableTopRowLeftColumn"><bean:message
			key="demographic.demographicappthistory.msgHistory" /></td>
		<td class="MainTableTopRowRightColumn">
		<table class="TopStatusBar">
			<tr>
				<td><bean:message
					key="demographic.demographicappthistory.msgResults" />: <%=demolastname%>,<%=demofirstname%>
				(<%=request.getParameter("demographic_no")%>)</td>
				<td>&nbsp;</td>
				<td style="text-align: right"><oscar:help keywords="appointment history" key="app.top1"/> | <a
					href="javascript:popupStart(300,400,'About.jsp')"><bean:message
					key="global.about" /></a> | <a
					href="javascript:popupStart(300,400,'License.jsp')"><bean:message
					key="global.license" /></a></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="MainTableLeftColumn" valign="top"><a
			href="javascript:history.go(-1)"
			onMouseOver="self.status=document.referrer;return true"><bean:message
			key="global.btnBack" /></a> 
			<br/>
			<input type="checkbox" name="showDeleted" id="showDeleted" onChange="toggleShowDeleted(this.checked);"/><bean:message key="demographic.demographicappthistory.msgShowDeleted" />
			</td>
		<td class="MainTableRightColumn">
		<table width="95%" border="0" bgcolor="#ffffff" id="apptHistoryTbl">
			<tr  bgcolor="<%=deepColor%>">				
				<TH width="10%"><b><bean:message
					key="demographic.demographicappthistory.msgApptDate" /></b></TH>
				<TH width="10%"><b><bean:message
					key="demographic.demographicappthistory.msgFrom" /></b></TH>
				<TH width="10%"><b><bean:message
					key="demographic.demographicappthistory.msgTo" /></b></TH>
					<TH width="10%"><b><bean:message
					key="demographic.demographicappthistory.msgStatus" /></b></TH>
					<TH width="10%"><b><bean:message
					key="demographic.demographicappthistory.msgType" /></b></TH>
				<TH width="15%"><b><bean:message
					key="demographic.demographicappthistory.msgReason" /></b></TH>
				<TH width="15%"><b><bean:message
					key="demographic.demographicappthistory.msgProvider" /></b></TH>
				<plugin:hideWhenCompExists componentName="specialencounterComp" reverse="true">
				<special:SpecialEncounterTag moduleName="eyeform">   
					<TH width="5%"><b>EYE FORM</b></TH>
				</special:SpecialEncounterTag>
				</plugin:hideWhenCompExists>
				<TH><b><bean:message key="demographic.demographicappthistory.msgComments" /></b></TH>
				
				<% if (org.oscarehr.common.IsPropertiesOn.isMultisitesEnable()) { %>
					<TH width="5%">Location</TH>
				<% } %>
				
			</tr>
			<%
  int iRSOffSet=0;
  int iPageSize=10;
  int iRow=0;
  if(request.getParameter("limit1")!=null) iRSOffSet= Integer.parseInt(request.getParameter("limit1"));
  if(request.getParameter("limit2")!=null) iPageSize = Integer.parseInt(request.getParameter("limit2"));

  ResultSet rs=null ;
  DBPreparedHandlerParam[] params;
  if("appt_history_w_deleted".equals(request.getParameter("dboperation"))) {
	  params = new DBPreparedHandlerParam[2];
	  params[0]= new DBPreparedHandlerParam(Integer.parseInt(request.getParameter("demographic_no")));
	  params[1]= new DBPreparedHandlerParam(Integer.parseInt(request.getParameter("demographic_no")));
  } else {
  	params = new DBPreparedHandlerParam[1];
  	params[0]= new DBPreparedHandlerParam(Integer.parseInt(request.getParameter("demographic_no")));
  }
  
  rs = apptMainBean.queryResults_paged(params, request.getParameter("dboperation"), iRSOffSet);

  boolean bodd=false;
  int nItems=0;
  
  List<CachedAppointment> cachedAppointments = null;
  if (LoggedInInfo.loggedInInfo.get().currentFacility.isIntegratorEnabled()){
		int demographicNo = Integer.parseInt(request.getParameter("demographic_no"));
		try {
			if (!CaisiIntegratorManager.isIntegratorOffline()){
				cachedAppointments = CaisiIntegratorManager.getDemographicWs().getLinkedCachedAppointments(demographicNo);
			}
		} catch (Exception e) {
			MiscUtils.getLogger().error("Unexpected error.", e);
			CaisiIntegratorManager.checkForConnectionError(e);
		}
		
		if(CaisiIntegratorManager.isIntegratorOffline()){
			cachedAppointments = IntegratorFallBackManager.getRemoteAppointments(demographicNo);	
		}	
		
		
  }
  
  if (cachedAppointments != null) {
	  for (CachedAppointment a : cachedAppointments) {
		  bodd=bodd?false:true;
		  iRow++;
		  nItems++;
		  FacilityIdStringCompositePk providerPk=new FacilityIdStringCompositePk();
		  providerPk.setIntegratorFacilityId(a.getFacilityIdIntegerCompositePk().getIntegratorFacilityId());
		  providerPk.setCaisiItemId(a.getCaisiProviderId());
		  CachedProvider p = CaisiIntegratorManager.getProvider(providerPk);
		  oscar.appt.ApptStatusData as = new oscar.appt.ApptStatusData();
		  as.setApptStatus(a.getStatus());
		  
		  %>
		  <tr bgcolor="<%=bodd?weakColor:"white"%>">
      <td align="center"><%=DateUtils.formatDate(a.getAppointmentDate(), request.getLocale())%></td>
      <td align="center"><%=DateUtils.formatTime(a.getStartTime(), request.getLocale())%></td>
      <td align="center"><%=DateUtils.formatTime(a.getEndTime(), request.getLocale())%></td>
      <td><%=as.getTitle() %></td>
      <td><%=a.getType() %></td>
      <td><%=StringUtils.trimToEmpty(a.getReason())%></td>
      <td>
      	<%=(p != null ? p.getLastName() +","+ p.getFirstName() : "") %> (remote)</td>
      <td>&nbsp;<%=a.getStatus()==null?"":(a.getStatus().contains("N")?"No Show":(a.getStatus().equals("C")?"Cancelled":"") ) %></td>
</tr>
		  <%
		  
	  }
  }
  
  if(rs==null) {
    out.println("failed!!!");
  } else {
	 Map<String,Boolean> apptsDisplayed = new HashMap<String,Boolean>();
	 
	
    while (rs.next()) {
    	
    	String style="";
    	boolean deleted=false;
    	
    	if(showDeleted != null && showDeleted.equals("true")) {
    		if(apptsDisplayed.get(rs.getString("appointment_no")) != null) {
    			continue;
    		}
    	}
    	apptsDisplayed.put(rs.getString("appointment_no"),true);
    	
    	try {
	    	if("archive".equals(rs.getString("archive"))) {
	    		deleted=true;
	    		style=" style='text-decoration: line-through' ";
	    		
	    	}
    	}catch(Exception e) {
    		//ignore..just means it's not deleted
    	}
    	
      iRow ++;
      if(iRow>iPageSize) break;
      bodd=bodd?false:true; //for the color of rows
      nItems++; //to calculate if it is the end of records
      oscar.appt.ApptStatusData as = new oscar.appt.ApptStatusData();
	  as.setApptStatus(apptMainBean.getString(rs,"status"));
	  String statusDescr = as.getTitle();
	  
%> 
<tr  bgcolor="<%=bodd?weakColor:"white"%>" appt_no="<%=rs.getString("appointment_no")%>" demographic_no="<%=request.getParameter("demographic_no")%>">	  
      <td <%=style%> align="center"><a href=# onClick ="popupPageNew(360,680,'../appointment/appointmentcontrol.jsp?appointment_no=<%=apptMainBean.getString(rs,"appointment_no")%>&displaymode=edit&dboperation=search');return false;" ><%=apptMainBean.getString(rs,"appointment_date")%></a></td>
      <td <%=style%> align="center"><%=apptMainBean.getString(rs,"start_time")%></td>
      <td <%=style%> align="center"><%=apptMainBean.getString(rs,"end_time")%></td>
      <td <%=style%>>
      <%if(statusDescr != null && statusDescr.length()>0 && !statusDescr.equals("desc")) {%>
      <bean:message	key="<%=statusDescr %>" />
      <% } %>
      </td>
      <td <%=style%>><%=apptMainBean.getString(rs,"type") %></td>
      <td <%=style%>><%=apptMainBean.getString(rs,"reason")%></td>
      <td<%=style%> ><%=apptMainBean.getString(rs,"last_name")+","+apptMainBean.getString(rs,"first_name")%></td>
      <plugin:hideWhenCompExists componentName="specialencounterComp" reverse="true">
      <special:SpecialEncounterTag moduleName="eyeform">      
      <td <%=style%>><a href="#" onclick="popupPage(800,1000,'<%=request.getContextPath()%>/mod/specialencounterComp/EyeForm.do?method=view&appHis=true&demographicNo=<%=request.getParameter("demographic_no")%>&appNo=<%=rs.getString("appointment_no")%>')">eyeform</a></td>
      </special:SpecialEncounterTag>
      </plugin:hideWhenCompExists>

      <% String remarks = apptMainBean.getString(rs,"remarks");
         String comments = "";
         boolean newline = false;
         if (apptMainBean.getString(rs,"remarks") == null){
            remarks = "";
         }

         if (apptMainBean.getString(rs,"status")!=null) {
            if(apptMainBean.getString(rs,"status").contains("N")) {
               comments = "No Show";
            }
            else if (apptMainBean.getString(rs,"status").equals("C")) {
               comments = "Cancelled";
            } else if(deleted) {
            	comments= "Deleted";
            	style="";
            }
        }

        if (!remarks.isEmpty() && !comments.isEmpty()) {
              newline=true;
         }
      %>
      <td>&nbsp;<%=remarks%><% if(newline){%><br/>&nbsp;<%}%><%=comments%></td>
      <% if (org.oscarehr.common.IsPropertiesOn.isMultisitesEnable()) { 
	String[] sbc = siteBgColor.get(apptMainBean.getString(rs,"location")); 
      %>      
	<td style='background-color:<%= sbc[0] %>'><%= sbc[1] %></td>
      <% } %>      

</tr>
<%
    }
  }
  
%>
		</table>
		<br>
		<%
  int nPrevPage=0,nNextPage=0;
  nNextPage=Integer.parseInt(strLimit2)+Integer.parseInt(strLimit1);
  nPrevPage=Integer.parseInt(strLimit1)-Integer.parseInt(strLimit2);
  if(nPrevPage>=0) {
%> <a
			href="demographiccontrol.jsp?demographic_no=<%=request.getParameter("demographic_no")%>&last_name=<%=URLEncoder.encode(demolastname,"UTF-8")%>&first_name=<%=URLEncoder.encode(demofirstname,"UTF-8")%>&displaymode=<%=request.getParameter("displaymode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=<%=request.getParameter("orderby")%>&limit1=<%=nPrevPage%>&limit2=<%=strLimit2%>"><bean:message
			key="demographic.demographicappthistory.btnPrevPage" /></a> <%
  }
  if(nItems==Integer.parseInt(strLimit2)) {
%> <a
			href="demographiccontrol.jsp?demographic_no=<%=request.getParameter("demographic_no")%>&last_name=<%=URLEncoder.encode(demolastname,"UTF-8")%>&first_name=<%=URLEncoder.encode(demofirstname,"UTF-8")%>&displaymode=<%=request.getParameter("displaymode")%>&dboperation=<%=request.getParameter("dboperation")%>&orderby=<%=request.getParameter("orderby")%>&limit1=<%=nNextPage%>&limit2=<%=strLimit2%>">
		<bean:message key="demographic.demographicappthistory.btnNextPage" /></a>
		<%
}
%>
		<p>
		</td>
	</tr>
	<tr>
		<td class="MainTableBottomRowLeftColumn"></td>
		<td class="MainTableBottomRowRightColumn"></td>
	</tr>
</table>
</body>
</html:html>
