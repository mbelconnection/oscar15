<%@ page import="java.sql.*, java.util.*, oscar.util.SqlUtils, oscar.oscarWaitingList.WaitingList, oscar.oscarWaitingList.util.WLWaitingListUtil, oscar.oscarDemographic.data.*" errorPage="errorpage.jsp" %> 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<jsp:useBean id="apptMainBean" class="oscar.AppointmentMainBean" scope="session" />
<jsp:useBean id="oscarVariables" class="java.util.Properties" scope="session" />
<!--  
/*
 * 
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
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
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster Unviersity 
 * Hamilton 
 * Ontario, Canada 
 */
-->
<%
    if(session.getValue("user") == null) response.sendRedirect("../../logout.jsp");
    response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", 0); //prevents caching at the proxy 
%>
<html:html locale="true"> 
<head></head>

<body>
  <center>
    <table border="0" cellspacing="0" cellpadding="0" width="100%" >
      <tr bgcolor="#486ebd"> 
            <th align="CENTER"><font face="Helvetica" color="#FFFFFF">
            UPDATE demographic RECORD</font></th>
      </tr>
    </table>
<%
  ResultSet rs = null;
  java.util.Locale vLocale =(java.util.Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);

  //if action is good, then give me the result
    String[] param =new String[27];
	  param[0]=request.getParameter("last_name");
	  param[1]=request.getParameter("first_name");
	  param[2]=request.getParameter("address");
	  param[3]=request.getParameter("city");
	  param[4]=request.getParameter("province");
	  param[5]=request.getParameter("postal");
	  param[6]=request.getParameter("phone");
	  param[7]=request.getParameter("phone2");
	  param[8]=request.getParameter("email");
	  param[9]=request.getParameter("pin");
	  param[10]=request.getParameter("year_of_birth");

	  param[11]=request.getParameter("month_of_birth")!=null && request.getParameter("month_of_birth").length()==1 ? "0"+request.getParameter("month_of_birth") : request.getParameter("month_of_birth");
	  param[12]=request.getParameter("date_of_birth")!=null && request.getParameter("date_of_birth").length()==1 ? "0"+request.getParameter("date_of_birth") : request.getParameter("date_of_birth");
	  param[13]=request.getParameter("hin");
	  param[14]=request.getParameter("ver");
	  param[15]=request.getParameter("roster_status");
	  param[16]=request.getParameter("patient_status");
	  //param[17]=request.getParameter("date_joined_year")+"-"+request.getParameter("date_joined_month")+"-"+request.getParameter("date_joined_date");
	  param[17]=request.getParameter("date_joined_date")+"-"+SqlUtils.getStringMonth(Integer.valueOf(request.getParameter("date_joined_month")).intValue())+"-"+request.getParameter("date_joined_year");
	 
	  param[18]=request.getParameter("chart_no");
	  param[19]=request.getParameter("provider_no");
	  param[20]=request.getParameter("sex");
	 
	  //param[21]=request.getParameter("end_date_year")+"-"+request.getParameter("end_date_month")+"-"+request.getParameter("end_date_date");
	  param[21]=request.getParameter("end_date_date")+"-"+SqlUtils.getStringMonth(Integer.valueOf(request.getParameter("end_date_month")).intValue())+"-"+request.getParameter("end_date_year");
	  
	//param[22]=request.getParameter("eff_date_year")+"-"+request.getParameter("eff_date_month")+"-"+request.getParameter("eff_date_date");
	 param[22]=request.getParameter("eff_date_date")+"-"+SqlUtils.getStringMonth(Integer.valueOf(request.getParameter("eff_date_month")).intValue())+"-"+request.getParameter("eff_date_year");
	  
	 param[23]=request.getParameter("pcn_indicator");
	  param[24]=request.getParameter("hc_type");
	 
	 // param[25]=request.getParameter("hc_renew_date_year")+"-"+request.getParameter("hc_renew_date_month")+"-"+request.getParameter("hc_renew_date_date");
	param[25]=request.getParameter("hc_renew_date_date")+"-"+SqlUtils.getStringMonth(Integer.valueOf(request.getParameter("hc_renew_date_month")).intValue())+"-"+request.getParameter("hc_renew_date_year");
	
	  param[26]="<rdohip>" + request.getParameter("r_doctor_ohip") + "</rdohip><rd>" + request.getParameter("r_doctor") + "</rd>" + (request.getParameter("family_doc")!=null? ("<family_doc>" + request.getParameter("family_doc") + "</family_doc>") : "") ;
	/*
	  for(int ii=0; ii<=26; ii++) {
		  if("".equals(param[ii]) || "null".equals(param[ii])) {
			  param[ii]="' '";
		  }
	  }
	*/
	  int []intparam=new int[] {Integer.parseInt(request.getParameter("demographic_no"))};

          
  	//DemographicExt
     DemographicExt dExt = new DemographicExt();
     String proNo = (String) session.getValue("user");
     dExt.addKey(proNo,request.getParameter("demographic_no") ,"language",request.getParameter("language"),request.getParameter("languageOrig") );
     dExt.addKey(proNo,request.getParameter("demographic_no") ,"demo_cell",request.getParameter("demo_cell"),request.getParameter("demo_cellOrig") );
     dExt.addKey(proNo,request.getParameter("demographic_no") ,"hPhoneExt",request.getParameter("hPhoneExt"),request.getParameter("hPhoneExtOrig") );
     dExt.addKey(proNo,request.getParameter("demographic_no") ,"wPhoneExt",request.getParameter("wPhoneExt"),request.getParameter("wPhoneExtOrig") );
     dExt.addKey(proNo,request.getParameter("demographic_no") ,"cytolNum",request.getParameter("cytolNum"),request.getParameter("cytolNumOrig") );
     // customized key
     if(oscarVariables.getProperty("demographicExt") != null) {
	       String [] propDemoExt = oscarVariables.getProperty("demographicExt","").split("\\|");
		   //System.out.println("propDemoExt:" + propDemoExt[0] );
	       for(int k=0; k<propDemoExt.length; k++) {
	           dExt.addKey(proNo,request.getParameter("demographic_no"),propDemoExt[k].replace(' ','_'),request.getParameter(propDemoExt[k].replace(' ','_')),request.getParameter(propDemoExt[k].replace(' ','_')+"Orig"));
	       }
     }
     // customized key
  //DemographicExt


     
     // added check to see if patient has a bc health card and has a version code of 66, in this case you are aloud to have dup hin
     boolean hinDupCheckException = false;
     String hcType = request.getParameter("hc_type");
     String ver  = request.getParameter("ver");
     if (hcType != null && ver != null && hcType.equals("BC") && ver.equals("66")){
        hinDupCheckException = true;    
     }
     
     if(request.getParameter("hin")!=null && request.getParameter("hin").length()>5 && !hinDupCheckException) {
            //oscar.oscarBilling.ca.on.data.BillingONDataHelp dbObj = new oscar.oscarBilling.ca.on.data.BillingONDataHelp();
            //String sql = "select demographic_no from demographic where hin=? and year_of_birth=? and month_of_birth=? and date_of_birth=?";
            String paramNameHin =new String();
            paramNameHin=request.getParameter("hin").trim();
        ResultSet rsHin = apptMainBean.queryResults(paramNameHin, "search_hin");
        while (rsHin.next()) { 
           
            if (!(rsHin.getString("demographic_no").equals(request.getParameter("demographic_no")))) { 
                if (rsHin.getString("ver") != null && !rsHin.getString("ver").equals("66")){%>
                ***<font color='red'><bean:message key="demographic.demographicaddarecord.msgDuplicatedHIN"/></font>***<br>
                <br><a href=# onClick="history.go(-1);return false;"><b>&lt;-<bean:message key="global.btnBack"/></b></a>
          
                <% return;
                }
            }
        }
    }

  int rowsAffected = apptMainBean.queryExecuteUpdate(param, intparam,  request.getParameter("dboperation"));
  if (rowsAffected ==1) {
    //find the democust record for update
    try{  
    DemographicNameAgeString nameAgeString  = DemographicNameAgeString.getInstance();
    nameAgeString.resetDemographic(request.getParameter("demographic_no"));   
    }catch(Exception nameAgeEx){
        nameAgeEx.printStackTrace();
        System.out.println("ERROR RESETTING NAME AGE ");
    }
    rs = apptMainBean.queryResults(request.getParameter("demographic_no"), "search_custrecordno");
    if(rs.next() ) { //update
      String[] param1 =new String[6];
	    param1[0]=request.getParameter("resident");
	    param1[1]=request.getParameter("nurse");
	    param1[2]=request.getParameter("alert");
            param1[3]=request.getParameter("midwife");
	    param1[4]="<unotes>"+ request.getParameter("notes")+"</unotes>";
	    param1[5]=request.getParameter("demographic_no");
        rowsAffected = apptMainBean.queryExecuteUpdate(param1, "update_custrecord");
        
    } else { //add
	    String[] param2 =new String[6];
	    param2[0]=request.getParameter("demographic_no");
	    param2[1]=request.getParameter("resident");
	    param2[2]=request.getParameter("nurse");
	    param2[3]=request.getParameter("alert");
	    param2[4]=request.getParameter("midwife");
	    param2[5]="<unotes>"+ request.getParameter("notes")+"</unotes>";
        rowsAffected = apptMainBean.queryExecuteUpdate(param2, "add_custrecord");
    }    
    
    if (vLocale.getCountry().equals("BR")) {
	    //find the demographic_ptbr record for update
	    rs = apptMainBean.queryResults(request.getParameter("demographic_no"),"search_demographic_ptbr");
	    if(rs.next() ) { //update
	  	 	String[] parametros = new String[13];
  	  	
	  	  	parametros[0]=request.getParameter("cpf");
	  	  	parametros[1]=request.getParameter("rg");
	  	  	parametros[2]=request.getParameter("chart_address");
	  	  	parametros[3]=request.getParameter("marriage_certificate");
	  	  	parametros[4]=request.getParameter("birth_certificate");
	  	  	parametros[5]=request.getParameter("marital_state");
	  	  	parametros[6]=request.getParameter("partner_name");
	  	  	parametros[7]=request.getParameter("father_name");
	  	  	parametros[8]=request.getParameter("mother_name");
	  	  	parametros[9]=request.getParameter("district");
	  	  	parametros[10]=request.getParameter("address_no")==null || request.getParameter("address_no").trim().equals("")?"0":request.getParameter("address_no");
	  	  	parametros[11]=request.getParameter("complementary_address");
	  	  	parametros[12]=request.getParameter("demographic_no");
  	
	  		rowsAffected = apptMainBean.queryExecuteUpdate(parametros,"update_record_ptbr");
    
	    }else{//add
	 	 	String[] parametros = new String[13];
	  	  	
	  	  	parametros[0]=request.getParameter("demographic_no");
	  	  	parametros[1]=request.getParameter("cpf");
	  	  	parametros[2]=request.getParameter("rg");
	  	  	parametros[3]=request.getParameter("chart_address");
	  	  	parametros[4]=request.getParameter("marriage_certificate");
	  	  	parametros[5]=request.getParameter("birth_certificate");
	  	  	parametros[6]=request.getParameter("marital_state");
	  	  	parametros[7]=request.getParameter("partner_name");
	  	  	parametros[8]=request.getParameter("father_name");
	  	  	parametros[9]=request.getParameter("mother_name");
	  	  	parametros[10]=request.getParameter("district");
	  	  	parametros[11]=request.getParameter("address_no")==null || request.getParameter("address_no").trim().equals("")?"0":request.getParameter("address_no");
	  	  	parametros[12]=request.getParameter("complementary_address");
  	
  	
	  		rowsAffected = apptMainBean.queryExecuteUpdate(parametros,"add_record_ptbr");
	    }
	}
    //add to waiting list if the waiting_list parameter in the property file is set to true
   
    WaitingList wL = WaitingList.getInstance();
    if(wL.getFound()){
        //Use  WLWaitingListUtil.updateWaitingListRecord()  instead of the original approach  
 	 
 	  WLWaitingListUtil.updateWaitingListRecord( 
 	  request.getParameter("list_id"), request.getParameter("waiting_list_note"),  
 	  request.getParameter("demographic_no"), request.getParameter("waiting_list_referral_date")); 
 	 
        %>
        <form name="add2WLFrm" action="../oscarWaitingList/Add2WaitingList.jsp"> 
            <input type="hidden" name="listId" value="<%=request.getParameter("list_id")%>"/>
            <input type="hidden" name="demographicNo" value="<%=request.getParameter("demographic_no")%>"/>        
            <input type="hidden" name="demographic_no" value="<%=request.getParameter("demographic_no")%>"/>        
            <input type="hidden" name="waitingListNote" value="<%=request.getParameter("waiting_list_note")%>"/>  
            <input type="hidden" name="onListSince" value="<%=request.getParameter("waiting_list_referral_date")%>"/> 
            <input type="hidden" name="displaymode" value="edit"/>
            <input type="hidden" name="dboperation" value="search_detail"/>
        <%
        if(!request.getParameter("list_id").equalsIgnoreCase("0")){
            String[] paramWLChk = new String[2];
            paramWLChk[0] = request.getParameter("demographic_no");
            paramWLChk[1] = request.getParameter("list_id");    
            //check if patient has already added to the waiting list and check if the patient already has an appointment in the future
            rs = apptMainBean.queryResults(paramWLChk, "search_demo_waiting_list");

            if(!rs.next()){
                System.out.println("not on the selected waiting list");
                ResultSet rsAppt = apptMainBean.queryResults(paramWLChk[0], "search_future_appt");
                if(rsAppt.next()){                
                    System.out.println("has appointment in the future");
            %>                                              
                    <script language="JavaScript">                    
                    var add2List = confirm("The patient already has an appointment, do you still want to add him/her to the waiting list?");                
                    if(add2List){                       
                        document.add2WLFrm.action = "../oscarWaitingList/Add2WaitingList.jsp?demographicNo=<%=request.getParameter("demographic_no")%>&listId=<%=request.getParameter("list_id")%>&waitingListNote=<%=request.getParameter("waiting_list_note")==null?"":request.getParameter("waiting_list_note")%>&onListSince=<%=request.getParameter("waiting_list_referral_date")==null?"":request.getParameter("waiting_list_referral_date")%>"; 
                    }
                    else{
                        document.add2WLFrm.action ="demographiccontrol.jsp?demographic_no=<%=request.getParameter("demographic_no")%>&displaymode=edit&dboperation=search_detail";
                    }                    
                    document.add2WLFrm.submit();  
                    </script>
                   
                <%}            
                else{%>
                <script language="JavaScript">
                   document.add2WLFrm.action = "../oscarWaitingList/Add2WaitingList.jsp?demographicNo=<%=request.getParameter("demographic_no")%>&listId=<%=request.getParameter("list_id")%>&waitingListNote=<%=request.getParameter("waiting_list_note")==null?"":request.getParameter("waiting_list_note")%>&onListSince=<%=request.getParameter("waiting_list_referral_date")==null?"":request.getParameter("waiting_list_referral_date")%>";                         
                    document.add2WLFrm.submit();  
                </script> 

                <%}
            }
            else{
                response.sendRedirect("demographiccontrol.jsp?demographic_no=" + request.getParameter("demographic_no") + "&displaymode=edit&dboperation=search_detail");
            }
        }
        else{
            response.sendRedirect("demographiccontrol.jsp?demographic_no=" + request.getParameter("demographic_no") + "&displaymode=edit&dboperation=search_detail");
        }
        %>
    </form><%
    }
    else{
        response.sendRedirect("demographiccontrol.jsp?demographic_no=" + request.getParameter("demographic_no") + "&displaymode=edit&dboperation=search_detail");
    }
%>
  <h2> Update a Provider Record Successfully ! 
  <p><a href="demographiccontrol.jsp?demographic_no=<%=request.getParameter("demographic_no")%>&displaymode=edit&dboperation=search_detail"><%= request.getParameter("demographic_no") %></a></p>
  </h2>
<%--
<script LANGUAGE="JavaScript">
     	self.opener.refresh();
      //self.close();
</script>
--%>
<%  
    //response.sendRedirect("demographiccontrol.jsp?demographic_no=" + request.getParameter("demographic_no") + "&displaymode=edit&dboperation=search_detail");
    //response.sendRedirect("search.jsp");
  } else {
%>
  <h1>Sorry, fail to update !!! <%= request.getParameter("demographic_no") %>.</h1>
<%  
  }
  apptMainBean.closePstmtConn(); 
%>
  <p></p>

  </center>
</body>
</html:html>
