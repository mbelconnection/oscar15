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
  
  String demographic_no = request.getParameter("demographic_no")!=null?request.getParameter("demographic_no"):("null") ;
  String form_no = request.getParameter("formId")!=null?request.getParameter("formId"):("0") ;
  String curUser_no = (String) session.getAttribute("user");
%>
<%@ page
	import="java.util.*, java.sql.*, oscar.*, java.text.*, java.lang.*,java.net.*,java.io.*"
	errorPage="../../appointment/errorpage.jsp"%>
<jsp:useBean id="plannerBean" class="oscar.AppointmentMainBean"
	scope="page" />
<jsp:useBean id="riskDataBean" class="java.util.Properties" scope="page" />
<jsp:useBean id="risks"
	class="oscar.decision.DesAntenatalPlannerRisks_99_12" scope="page" />
<jsp:useBean id="checklist"
	class="oscar.decision.DesAntenatalPlannerChecklist_99_12" scope="page" />
<%@ include file="../../admin/dbconnection.jsp"%>
<% 
String [][] dbQueries=new String[][] { 
{"search_formarrisk", "select * from formAR where ID = ?" }, 
{"search_desaprisk", "select * from desaprisk where form_no <= ? and demographic_no = ? order by form_no desc, desaprisk_date desc, desaprisk_time desc limit 1 " }, 
//{"save_desaprisk", "insert into desaprisk (desaprisk_date,desaprisk_time,provider_no,risk_content,checklist_content,demographic_no,form_no) values (?,?,?,?,?,?,? ) " }, 
};
plannerBean.doConfigure(dbQueries);
%>

<html>
<% response.setHeader("Cache-Control","no-cache");%>
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/js/global.js"></script>
<title>Antenatal Planner</title>
<link rel="stylesheet" type="text/css" media="all" href="../share/css/extractedFromPages.css"  />
<script type="text/javascript" language="Javascript">

</script>
</head>
<body bgproperties="fixed" topmargin="0" leftmargin="1" rightmargin="1">
<%-- @ include file="zgetarriskdata.jsp" --%>
<%
  //get the risk data from formAR1
  String finalEDB = null, wt=null, ht=null;
  String patientName = null;
  
  ResultSet rsdemo = null ;
  if(!form_no.equals("0")) {
	  rsdemo = plannerBean.queryResults(form_no, "search_formarrisk");
      ResultSetMetaData resultsetmetadata = rsdemo.getMetaData();
      while (rsdemo.next()) { 
          finalEDB = rsdemo.getString("c_finalEDB");
          patientName = rsdemo.getString("c_pName");
	      wt = rsdemo.getString("pg1_wt");
	      ht = rsdemo.getString("pg1_ht");
          for(int k = 1; k <= resultsetmetadata.getColumnCount(); k++) {
              //String name = resultsetmetadata.getColumnName(k);
              //String value = null;
              if(resultsetmetadata.getColumnTypeName(k).equalsIgnoreCase("TINY")) {
                  if(rsdemo.getInt(k) == 1) riskDataBean.setProperty(resultsetmetadata.getColumnName(k), "checked"); //"55", "risk_cinca"
              }
          }
      }
  }

  //get the risk data from table desaprisk for other risk factors
  String[] param2 = {form_no, demographic_no};
  rsdemo = plannerBean.queryResults(param2, "search_desaprisk");
  while (rsdemo.next()) { 
    String risk_content = rsdemo.getString("risk_content");
    String checklist_content = rsdemo.getString("checklist_content");
%>
<xml id="xml_list">
<planner>
<%=risk_content%>
<%=checklist_content%>
</planner>
</xml>
<%


    String riskFilePath = "../webapps/"+oscarVariables.getProperty("project_home")+"/decision/antenatal/desantenatalplannerrisks_99_12.xml";
    
    File file = new File(OscarProperties.getInstance().getProperty("DOCUMENT_DIR")+"desantenatalplannerrisks_99_12.xml");
    if(file.isFile() || file.canRead()) {
        riskFilePath = OscarProperties.getInstance().getProperty("DOCUMENT_DIR")+"desantenatalplannerrisks_99_12.xml";
    }


    //set the riskdata bean from xml file
    Properties savedar1risk1 = risks.getRiskName(riskFilePath); //risk_55    
  	StringBuffer tt; 

    for (Enumeration e = savedar1risk1.propertyNames() ; e.hasMoreElements() ;) {
      tt = new StringBuffer().append(e.nextElement());
      if(SxmlMisc.getXmlContent(risk_content, "risk_"+tt.toString())!= null) {
        riskDataBean.setProperty(tt.toString(), "checked");
	  }
    }
  }
  plannerBean.closePstmtConn();
%>
<table bgcolor='silver' width='100%' cellspacing=0 cellpadding=0>
	<tr>
		<td><font color='blue'><%=patientName%> | EDB: <%=finalEDB%></font></td>
		<td align="right"><input type="button" name="submit"
			value="Print" onclick="window.print();" /> <input type="button"
			value="  Exit  " onclick="javascript:window.close();" /></td>
	</tr>
</table>

<%
if(finalEDB==null || finalEDB=="") out.println("************No EDB, no check list!**************");
else {
  riskDataBean.setProperty("finalEDB", finalEDB);
    if (wt!= null && ht!= null && !wt.equals("") && !ht.equals("") ) {
	    boolean bNum = true;
	    for(int ii=0; ii<wt.length();ii++) {
        if (wt.charAt(ii) == '.') { ii++; continue; }
	  	  if ((wt.charAt(ii) < '0') || (wt.charAt(ii) > '9') ) {
		    	bNum = false;
			    break;
		    }
		  }
	    for(int ii=0; ii<ht.length();ii++) {
        if (ht.charAt(ii) == '.') { ii++; continue; }
		    if ((ht.charAt(ii) < '0') || (ht.charAt(ii) > '9') ) {
			    bNum = false;
			    break;
		    }
		  }
	    if(bNum) {
	      if(Float.parseFloat(wt)<=150 && Float.parseFloat(wt)>=40 && Float.parseFloat(ht)<=3 && Float.parseFloat(ht)>=1) {
          float bmi = Float.parseFloat(wt) / Float.parseFloat(ht) * Float.parseFloat(ht);
          if ((bmi > 0) && (bmi < 20)) { riskDataBean.setProperty("97", "checked"); }
          if ((bmi > 19) && (bmi < 26)) { riskDataBean.setProperty("98", "checked"); }
          if (bmi > 25) { riskDataBean.setProperty("99", "checked");  }
		    }
		  }
    }
  
    String checkListFilePath = "../webapps/"+oscarVariables.getProperty("project_home")+"/decision/antenatal/desantenatalplannerchecklist_99_12.xml";

    File file = new File(OscarProperties.getInstance().getProperty("DOCUMENT_DIR")+"desantenatalplannerchecklist_99_12.xml");
    if(file.isFile() || file.canRead()) {
        checkListFilePath = OscarProperties.getInstance().getProperty("DOCUMENT_DIR")+"desantenatalplannerchecklist_99_12.xml";
    }

  out.println(checklist.doStuff(new String(checkListFilePath), riskDataBean));

}
%>

</body>
</html>