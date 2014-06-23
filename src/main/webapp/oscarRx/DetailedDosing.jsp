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
<%@page import="org.oscarehr.util.MiscUtils,oscar.oscarRx.util.RxUtil"%>
<%@page import="oscar.oscarDemographic.data.*,org.oscarehr.common.model.Demographic,org.oscarehr.util.MiscUtils"%>
<%@page import="oscar.oscarEncounter.oscarMeasurements.bean.EctMeasurementsDataBeanHandler,java.util.*,oscar.oscarRx.util.*" %>
<%@page import="oscar.oscarLab.ca.on.*,oscar.util.*,oscar.oscarLab.*,org.oscarehr.common.dao.DrugDao,org.oscarehr.common.model.Drug,org.oscarehr.util.SpringUtils" %>
<%

DrugDao drugDao = (DrugDao) SpringUtils.getBean("drugDao");

String atc = request.getParameter("atcCode");
String demographicNo = request.getParameter("demographicNo");

MiscUtils.getLogger().error("in detailed dosing atc "+atc);

if(!atc.equals("N07BC02")){
	return ;
}

DemographicData demoData = new DemographicData();
Demographic demographic = demoData.getDemographic(demographicNo);

int age = demographic.getAgeInYears();
boolean female = DemographicData.isFemale(demographic);

List<Drug> drugs = drugDao.findByDemographicIdSimilarDrugOrderByDate(demographic.getDemographicNo(), null, null,null, atc);

if( drugs == null || drugs.size() == 0){
	return;
}

//Todo: create Struts Action for above
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

<script src="${pageContext.request.contextPath}/js/jquery-1.9.1.js" language="javascript" type="text/javascript"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/js/jqplot/jquery.jqplot.min.css" />
<link href="${pageContext.request.contextPath}/library/bootstrap/3.0.0/css/bootstrap.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/jquery-ui-1.10.2.custom.min.js"  language="javascript" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/jqplot/jquery.jqplot.min.js" language="javascript" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/jqplot/jqplot.dateAxisRenderer.min.js" type="text/javascript" ></script>

</head>
<body>
<div style="padding-left:0px; padding-right:0px; margin-left:0px; margin-right: 0px;" class="container" >
	<div class="col-xs-12" style="padding-left:0px;">
	<h5>Recent Dose History<%=drugs.size() %><small><a href="javascript: function myFunction() {return false; }" onclick="pymChild.sendHeightToParent();console.log(document.getElementsByTagName('body')[0].offsetHeight.toString());">Refresh</a></small></h5>
	</div>
	<div class="col-xs-5" style="padding-left:0px;">
    	<table class="table table-striped table-condensed">
	        <tr class="heading">
	            <th>Date</th>
	            <th>TDD</th>
	            <th>Duration</th>
	        </tr>
       
			<%
			StringBuilder line1 = new StringBuilder("[");
			boolean additional = false;
		
		
			for (Drug drug : drugs){
				if(additional) { line1.append(",");}
				 Date date = drug.getRxDate();
				 Date endDate = drug.getEndDate();
				 line1.append("[['"+date+"',"+getDailyDose(drug)+"], ['"+DateUtils.format("yyyy-MM-dd", endDate)+"',"+getDailyDose(drug)+"]]");
				 additional = true;
			%>
	        <tr>
				<td><%=drug.getRxDate() %></td>
	            <td title="<%=drug.getDosage() %> <%=drug.getDosageDisplay() %> <%=drug.getFreqCode() %>"><%=getDailyDose(drug) %>  <%=drug.getUnit() %></td>
	            <td><%=RxUtil.findNDays(drug.getDurUnit()) * Float.parseFloat(drug.getDuration()) %>   </td>
	        </tr>
			<%}
			line1.append("]");
			%>
	    </table> 
	</div>
	<div class="col-xs-7">
    	<div style="padding-left:0px;margin-left:0px;width:350px;height:150px;  border:1px solid black" id="chart1"></div>
	</div>
</div>
<br/>
<script>
	jQuery(document).ready(function(){
  		<%-- var line1=[['2008-09-30 4:00PM',4], ['2008-10-30 4:00PM',6.5], ['2008-11-30 4:00PM',5.7], ['2008-12-30 4:00PM',9], ['2009-01-30 4:00PM',8.2]]; 
  		var line1=[['2008-09-30',4], ['2008-10-30',6.5], ['2008-11-30',5.7], ['2008-12-30',9], ['2009-01-30',8.2]]; --%>
  		//var line1=[[['2007-09-30',4], ['2007-10-30',6.5]], [['2008-09-30',4], ['2008-10-30',6.5], ['2008-11-30',5.7]],[['2008-12-30',9], ['2009-01-30',8.2]]];
  		
  		var line1= <%=line1.toString() %>;
  		var plot1 = jQuery.jqplot('chart1', line1, {
    		
    		seriesColors: [ "#4bb2c5" ],
    		seriesDefaults: { lineWidth:2 , showMarker: false, pointLabels: { show: true } },
    		axes:{xaxis:{renderer:jQuery.jqplot.DateAxisRenderer,tickInterval:'1 month',min:'2014-01-01',max:'2014-08-01',tickOptions:{formatString:'%F'}}}
    		
  			});
  		
  		var height = document.getElementsByTagName('body')[0].offsetHeight.toString();
console.log('responsivechild ' + pymChild.id + ' '+ height);
console.log(pymChild);
        // Send the height to the parent.
        window.parent.postMessage('responsivechild ' + pymChild.id + ' '+ height, '*');
  		//pymChild.sendHeightToParent(); 
	});
       
       </script>
<script src="<%=request.getContextPath() %>/library/pym.js"></script>
<script>
    var pymChild = new pym.Child();
    
</script>
</body>
</html>
<%!
/**
Total Daily dose is strength of med X quantity of med X daily frequency 
ie  take 2 5mg pills 3 times daily would be 
      5 X 2 X 3 = 30 mg TDD
**/
double getDailyDose(Drug drug){
	//get Strength of the pill  ( remove unit from dosage, the parse to float) 
	float strength = Float.parseFloat(drug.getDosage().split(" ")[0]); //hack way for right now.
	//get takemax (parse to float)
	float takemax = drug.getTakeMax();
	//convert frequency to a float
	double dailyFrequency = RxUtil.findNPerDay(drug.getFreqCode());
	
	return (strength * takemax * dailyFrequency);
}

%>