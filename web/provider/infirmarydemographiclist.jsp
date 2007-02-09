<logic:equal name="infirmaryView_isOscar" value="false">
<%	
	session.setAttribute("case_program_id", session.getAttribute("infirmaryView_programId"));
	java.util.Date todayDate=new java.util.Date();
	todayDate.setHours(23);
	todayDate.setMinutes(59);
	todayDate.setSeconds(59);
	//System.out.println(todayDate);
	//System.out.println((java.util.Date) session.getAttribute("infirmaryView_date"));
	if (((String)session.getAttribute("infirmaryView_programId")).equalsIgnoreCase("0"))
	{%>
	<p><b>No Assigned Program.</b></p>
	<%}else
	if (session.getAttribute("infirmaryView_date")!=null && todayDate.before((java.util.Date) session.getAttribute("infirmaryView_date")))
	{ %>
	<p><b>Future clients list is unavailable.</b></p>
	<%}
	else{
	if (((java.util.List) session.getAttribute("infirmaryView_demographicBeans")).size()==0)
	{ %>
		<p><b>no client in this program.</b></p>
	<%}else{
	int k=0;

	%>
<table border="1" cellpadding="0" bgcolor="<%=userAvail?"#486ebd":"silver"%>" cellspacing="0" width="100%">
<%if(session.getAttribute("archiveView")==null || session.getAttribute("archiveView")=="false") { %>
<a href="<html:rewrite action="/ArchiveView.do"/>">Archive View</a>
<%} else {%>
You are in the archive view !
<%} %>
<logic:iterate id="de" name="infirmaryView_demographicBeans" type="org.apache.struts.util.LabelValueBean">
<tr>
	<td width='1'  title='null'><font color='white'></font></td>
<% k++;
java.util.Date apptime=new java.util.Date();
int demographic_no = (new Integer(de.getValue())).intValue();
String demographic_name=de.getLabel();
param[0]=curProvider_no[nProvider];
param[1]=year+"-"+month+"-"+day;//e.g."2001-02-02";
//rs = apptMainBean.queryResults(param, strsearchappointmentday);
//System.out.println(param[0]+"::"+param[1]+"::"+rs);
//original oscar code for demographic table
paramTickler[0]=String.valueOf(demographic_no);
paramTickler[1]=strDate; //year+"-"+month+"-"+day;//e.g."2001-02-02";
rsTickler = null;
Object[] rss = apptMainBean.queryResultsCaisi(paramTickler, "search_tickler");
rsTickler = (java.sql.ResultSet)rss[0];
tickler_no = "";
tickler_note="";
while (rsTickler.next()){
    tickler_no = rsTickler.getString("tickler_no");
    tickler_note = rsTickler.getString("message")==null?tickler_note:tickler_note + "\n" + rsTickler.getString("message");
}
((java.sql.Statement)rss[1]).close();


rsDemo = null;
ver = "";
roster = "";
rss = apptMainBean.queryResultsCaisi(demographic_no, "search_demograph");
rsDemo = (java.sql.ResultSet) rss[0];
if(rsDemo.next()){
	  ver = (rsDemo.getString("ver")==null)? "" : rsDemo.getString("ver");
	  roster = (rsDemo.getString("roster_status")==null) ? "": rsDemo.getString("roster_status");
	  int intMob = rsDemo.getInt("month_of_birth");
	  int intDob = rsDemo.getInt("date_of_birth");
	mob = String.valueOf(intMob);
	  dob = String.valueOf(intDob);
	  demBday = mob + "-" + dob;

	  if (roster == null || !roster.equalsIgnoreCase("FS")) {
	      roster = "";
	  }
}
((java.sql.Statement)rss[1]).close();
rsDemo = null;

study_no = new StringBuffer("");
study_link = new StringBuffer("");
studyDescription = new StringBuffer("");
rsStudy = null;
rss = apptMainBean.queryResultsCaisi(demographic_no, "search_studycount");
rsStudy = (java.sql.ResultSet) rss[0];
int numStudy = 0;
if (rsStudy.next()) numStudy =  rsStudy.getInt(1);
if (numStudy == 1) {
	((java.sql.Statement)rss[1]).close();
    rsStudy = null;
    rss = apptMainBean.queryResultsCaisi(demographic_no, "search_study");
    rsStudy = (java.sql.ResultSet) rss[0];
    while (rsStudy.next()){
        study_no = new StringBuffer(rsStudy.getString("s.study_no"));
        study_link = new StringBuffer(rsStudy.getString("s.study_link"));
        studyDescription = new StringBuffer(rsStudy.getString("s.description"));
    }
} else if (numStudy > 1) {
    study_no = new StringBuffer("0");
    study_link = new StringBuffer("formstudy.jsp");
    studyDescription = new StringBuffer("Form Studies");
}
((java.sql.Statement)rss[1]).close();
rsStudy=null;

String reason ="";
String notes = "";
String status = "T";
bFirstTimeRs=true;
as.setApptStatus(status);

String rsAppointNO="0";
	if ((k/2)*2==k){
	%>  
	<td bgcolor='#FDFEC7' rowspan="1"  nowrap>
	<%}else{ %>
	<td bgcolor='#FFBBFF' rowspan="1"  nowrap>
	<%}%>
	<img src="../images/todo.gif" border="0" height="10" title="appointment">
	<%
   	if(demographic_no==0) {
		if (tickler_no.compareTo("") != 0) {
%>	
		<caisi:isModuleLoad moduleName="ticklerplus" reverse="true">
			<a href="#" onClick="popupPage(700,1000, '../tickler/ticklerDemoMain.jsp?demoview=0');return false;" title="<bean:message key="provider.appointmentProviderAdminDay.ticklerMsg"/>: <%=UtilMisc.htmlEscape(tickler_note)%>"><font color="red">!</font></a>
		</caisi:isModuleLoad>
    	<caisi:isModuleLoad moduleName="ticklerplus">
    		<a href="#" onClick="popupPage(700,1000, '../ticklerPlus/index.jsp?demoview=0');return false;" title="<bean:message key="provider.appointmentProviderAdminDay.ticklerMsg"/>: <%=UtilMisc.htmlEscape(tickler_note)%>"><font color="red">!</font></a>
    	</caisi:isModuleLoad>
<%		} %>
		<b>.<%=de.getLabel()%></b>
        <%
      } else {
        			  //System.out.println(name+" / " +demographic_no);
    %>
	<% 
		if (tickler_no.compareTo("") != 0) {
%>		<caisi:isModuleLoad moduleName="ticklerplus" reverse="true">	
			<a href="#" onClick="popupPage(700,1000, '../tickler/ticklerDemoMain.jsp?demoview=<%=demographic_no%>');return false;" title="<bean:message key="provider.appointmentProviderAdminDay.ticklerMsg"/>: <%=UtilMisc.htmlEscape(tickler_note)%>">
			<font color="red">!</font></a>
		</caisi:isModuleLoad>
    	<caisi:isModuleLoad moduleName="ticklerplus">
    		<a href="#"onClick="popupPage(700,1000, '../Tickler.do?method=filter&filter.client=<%=demographic_no %>');return false;" title="<bean:message key="provider.appointmentProviderAdminDay.ticklerMsg"/>: <%=UtilMisc.htmlEscape(tickler_note)%>"><font color="red">!</font></a>
    	</caisi:isModuleLoad>
<%		} %>
<!-- doctor code block -->
		<% if(bShowDocLink) { %>
<!-- security:oscarSec roleName="<%--=roleName$--%>" objectName="_appointment.doctorLink" rights="r" -->
		<% if (study_no.toString().compareTo("") != 0) {%>	<a href="#" onClick="popupPage(700,1000, '../form/study/forwardstudyname.jsp?study_link=<%=study_link.toString()%>&demographic_no=<%=demographic_no%>&study_no=<%=study_no%>');return false;" title="<bean:message key="provider.appointmentProviderAdminDay.study"/>: <%=UtilMisc.htmlEscape(studyDescription.toString())%>"><%="<font color='"+studyColor+"'>"+studySymbol+"</font>"%></a><%} %>
		<% if (ver.toString().compareTo("##") == 0){%><a href="#" title="<bean:message key="provider.appointmentProviderAdminDay.versionMsg"/> <%=UtilMisc.htmlEscape(ver)%>"> <font color="red">*</font><%}%>
		<% if (roster.equalsIgnoreCase("FS")){%> <a href="#" title="<bean:message key="provider.appointmentProviderAdminDay.rosterMsg"/> <%=UtilMisc.htmlEscape(roster)%>"><font color="red">$</font><%}%>
<!-- /security:oscarSec -->
		<% } %>
<!-- doctor code block -->
		<a href="#" onclick="location.href='../PMmodule/ClientManager.do?id=<%=demographic_no%>'"
		>	<%=de.getLabel()%></a>
		
<!-- doctor code block -->

<% if(bShowEncounterLink) { %>
		<% String  eURL = "../oscarEncounter/IncomingEncounter.do?providerNo="+curUser_no+"&appointmentNo="+rsAppointNO+"&demographicNo="+demographic_no+"&curProviderNo="+curProvider_no[nProvider]+"&reason="+URLEncoder.encode(reason)+"&userName="+URLEncoder.encode( userfirstname+" "+userlastname)+"&curDate="+curYear+"-"+curMonth+"-"+curDay+"&appointmentDate="+year+"-"+month+"-"+day+"&startTime="+apptime.getHours()+":"+apptime.getMinutes()+"&status="+status;%>
		<a href=# onClick="popupPage(700,980,'../oscarSurveillance/CheckSurveillance.do?demographicNo=<%=demographic_no%>&proceed=<%=URLEncoder.encode(eURL)%>');return false;" title="<bean:message key="global.encounter"/>">
            |<bean:message key="provider.appointmentProviderAdminDay.btnE"/></a>
<% 		} %>

<!-- billing code block -->
	  <security:oscarSec roleName="<%=roleName$%>" objectName="_billing" rights="r">

            <%= bShortcutForm?"<a href=# onClick='popupPage2( \"../form/forwardshortcutname.jsp?formname="+formName+"&demographic_no="+demographic_no+"\")' title='form'>|"+formNameShort+"</a>" : ""%>
            <%= bShortcutForm2?"<a href=# onClick='popupPage2( \"../form/forwardshortcutname.jsp?formname="+formName2+"&demographic_no="+demographic_no+"\")' title='form'>|"+formName2Short+"</a>" : ""%>
             <% if(status.indexOf('B')==-1) {
                //java.util.Locale vLocale =(java.util.Locale)session.getAttribute(org.apache.struts.action.Action.LOCALE_KEY);
                if (vLocale.getCountry().equals("BR")) { %>
               <a href=# onClick='popupPage(700,1000, "../oscar/billing/procedimentoRealizado/init.do?appId=<%=rsAppointNO%>");return false;' title="Faturamento">|FAT|</a>
             <% } else {%>
	       		<a href=# onClick='popupPage(700,1000, "../billing.do?billRegion=<%=URLEncoder.encode(prov)%>&billForm=<%=URLEncoder.encode(oscarVariables.getProperty("default_view"))%>&hotclick=<%=URLEncoder.encode("")%>&appointment_no=<%=rsAppointNO%>&demographic_name=<%=URLEncoder.encode(de.getLabel())%>&status=<%=status%>&demographic_no=<%=demographic_no%>&providerview=<%=curProvider_no[nProvider]%>&user_no=<%=curUser_no%>&apptProvider_no=<%=curProvider_no[nProvider]%>&appointment_date=<%=year+"-"+month+"-"+day%>&start_time=<%=apptime.getHours()+":"+apptime.getMinutes()%>&bNewForm=1");return false;' title="<bean:message key="global.billing"/>">|<bean:message key="provider.appointmentProviderAdminDay.btnB"/></a>

             <%} } %>
<!--/security:oscarSec-->
	  </security:oscarSec>
<!-- billing code block -->
	<security:oscarSec roleName="<%=roleName$%>" objectName="_masterLink" rights="r">     
<% if (vLocale.getCountry().equals("BR")) {%>
    	<a href=# onClick="popupPage2('../demographic/demographiccontrol.jsp?demographic_no=<%=demographic_no%>&displaymode=edit&dboperation=search_detail_ptbr');return false;"
    	title="<bean:message key="provider.appointmentProviderAdminDay.msgMasterFile"/>"><bean:message key="provider.appointmentProviderAdminDay.btnM"/></a>
    <%}else{%>
    	<a href=# onClick="popupPage2('../demographic/demographiccontrol.jsp?demographic_no=<%=demographic_no%>&displaymode=edit&dboperation=search_detail');return false;"
    	title="<bean:message key="provider.appointmentProviderAdminDay.msgMasterFile"/>">|<bean:message key="provider.appointmentProviderAdminDay.btnM"/></a>
    <%}%>
	</security:oscarSec>

     <% if (!vLocale.getCountry().equals("BR")) { %>
<!-- doctor code block -->
	  	<security:oscarSec roleName="<%=roleName$%>" objectName="_appointment.doctorLink" rights="r">
      		<a href=# onClick="popupOscarRx(700,960,'../oscarRx/choosePatient.do?providerNo=<%=curUser_no%>&demographicNo=<%=demographic_no%>')">|<bean:message key="global.rx"/></a><oscar:oscarPropertiesCheck property="SHOW_APPT_REASON" value="yes">| <b><%=reason%></b></oscar:oscarPropertiesCheck>
	  	</security:oscarSec>
	  <%} %>
<!-- doctor code block -->  
<%} %>

	<td width='1'></td>
</tr>
</logic:iterate>
</table>
<%
	}
}%>
</logic:equal>
