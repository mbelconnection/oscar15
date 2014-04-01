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

    <table>
        <tr class="tableHeadings deep">
        
		
                <td class="demoIdSearch">
                    <a href="demographiccontrol.jsp?fromMessenger=false&keyword=&displaymode=Search&search_mode=search_name&dboperation=search_titlename&orderby=demographic_no&limit1=0&limit2=10">Demographic No.</a>
                </td>
		<td class="links">Module <!-- b><a href="demographiccontrol.jsp?fromMessenger=false&keyword=&displaymode=Search&search_mode=search_name&dboperation=search_titlename&orderby=demographic_no&limit1=0&limit2=10">Links<sup>*</sup></a></b --></td>

		
		<td class="name"><a
                    href="demographiccontrol.jsp?fromMessenger=false&keyword=&displaymode=Search&search_mode=search_name&dboperation=search_titlename&orderby=last_name&limit1=0&limit2=10">Name</a>
                </td>
		<td class="chartNo"><a
			href="demographiccontrol.jsp?fromMessenger=false&keyword=&displaymode=Search&search_mode=search_name&dboperation=search_titlename&orderby=chart_no&limit1=0&limit2=10">Chart No.</a>
                </td>
		<td class="sex"><a
			href="demographiccontrol.jsp?fromMessenger=false&keyword=&displaymode=Search&search_mode=search_name&dboperation=search_titlename&orderby=sex&limit1=0&limit2=10">Sex</a>
                </td>
		<td class="dob"><a
			href="demographiccontrol.jsp?fromMessenger=false&keyword=&displaymode=Search&search_mode=search_name&dboperation=search_titlename&orderby=dob&limit1=0&limit2=10">DOB  <span class="dateFormat">yyyy-mm-dd</span></a>
                </td>
		<td class="doctor"><a
			href="demographiccontrol.jsp?fromMessenger=false&keyword=&displaymode=Search&search_mode=search_name&dboperation=search_titlename&orderby=provider_no&limit1=0&limit2=10">Doctor</a>
                </td>
                <td class="rosterStatus"><a
			href="demographiccontrol.jsp?fromMessenger=false&keyword=&displaymode=Search&search_mode=search_name&dboperation=search_titlename&orderby=roster_status&limit1=0&limit2=10">Roster Status</a>
                </td>
		<td class="patientStatus"><a
			href="demographiccontrol.jsp?fromMessenger=false&keyword=&displaymode=Search&search_mode=search_name&dboperation=search_titlename&orderby=patient_status&limit1=0&limit2=10">Patient Status</a>
                </td>
                <td class="phone"><a
			href="demographiccontrol.jsp?fromMessenger=false&keyword=&displaymode=Search&search_mode=search_name&dboperation=search_titlename&orderby=phone&limit1=0&limit2=10">Phone</a>
                </td>
	</tr>
	
	<tr class="odd">
	<td class="demoIdSearch">

	
		<a title="Master Demographic File" href="#"  onclick="popup(700,1027,'demographiccontrol.jsp?demographic_no=1&displaymode=edit&dboperation=search_detail')" >1</a></td>
	
		<!-- Rights -->
		<td class="links">
			<a class="encounterBtn" title="Encounter" href="#"
				onclick="popupEChart(710,1024,'/oscar_ero/oscarEncounter/IncomingEncounter.do?providerNo=999998&appointmentNo=&demographicNo=1&curProviderNo=&reason=Tel-Progress+Notes&encType=&curDate=2014-3-26&appointmentDate=&startTime=&status=');return false;">E</a>
		 <!-- Rights --> 
			<a class="rxBtn" title="Prescriptions" href="#" onclick="popup(700,1027,'../oscarRx/choosePatient.do?providerNo=&demographicNo=1')">Rx</a>
		</td>

	
		
		<td class="name"><a href="#" onclick="location.href='/oscar_ero/PMmodule/ClientManager.do?id=1'">Smith, John</a></td>
		
		
		<td class="chartNo">00123</td>
		<td class="sex">M</td>
		<td class="dob">1987-06-15</td>
		<td class="doctor">_</td>
		<td class="rosterStatus">&nbsp;</td>
		<td class="patientStatus">AC</td>
		<td class="phone">905-555-5555</td>
	</tr>
	
	<tr class="even">
	<td class="demoIdSearch">

	
		<a title="Master Demographic File" href="#"  onclick="popup(700,1027,'demographiccontrol.jsp?demographic_no=2&displaymode=edit&dboperation=search_detail')" >2</a></td>
	
		<!-- Rights -->
		<td class="links">
			<a class="encounterBtn" title="Encounter" href="#"
				onclick="popupEChart(710,1024,'/oscar_ero/oscarEncounter/IncomingEncounter.do?providerNo=999998&appointmentNo=&demographicNo=2&curProviderNo=&reason=Tel-Progress+Notes&encType=&curDate=2014-3-26&appointmentDate=&startTime=&status=');return false;">E</a>
		 <!-- Rights --> 
			<a class="rxBtn" title="Prescriptions" href="#" onclick="popup(700,1027,'../oscarRx/choosePatient.do?providerNo=&demographicNo=2')">Rx</a>
		</td>

	
		
		<td class="name"><a href="#" onclick="location.href='/oscar_ero/PMmodule/ClientManager.do?id=2'">Smith, Jean</a></td>
		
		
		<td class="chartNo">00234</td>
		<td class="sex">F</td>
		<td class="dob">1954-01-05</td>
		<td class="doctor">_</td>
		<td class="rosterStatus">&nbsp;</td>
		<td class="patientStatus">AC</td>
		<td class="phone">905-444-4444</td>
	</tr>
	
	<tr class="odd">
	<td class="demoIdSearch">

	
		<a title="Master Demographic File" href="#"  onclick="popup(700,1027,'demographiccontrol.jsp?demographic_no=3&displaymode=edit&dboperation=search_detail')" >3</a></td>
	
		<!-- Rights -->
		<td class="links">
			<a class="encounterBtn" title="Encounter" href="#"
				onclick="popupEChart(710,1024,'/oscar_ero/oscarEncounter/IncomingEncounter.do?providerNo=999998&appointmentNo=&demographicNo=3&curProviderNo=&reason=Tel-Progress+Notes&encType=&curDate=2014-3-26&appointmentDate=&startTime=&status=');return false;">E</a>
		 <!-- Rights --> 
			<a class="rxBtn" title="Prescriptions" href="#" onclick="popup(700,1027,'../oscarRx/choosePatient.do?providerNo=&demographicNo=3')">Rx</a>
		</td>

	
		
		<td class="name"><a href="#" onclick="location.href='/oscar_ero/PMmodule/ClientManager.do?id=3'">Claus, Santa</a></td>
		
		
		<td class="chartNo">&nbsp;</td>
		<td class="sex">M</td>
		<td class="dob">1904-06-15</td>
		<td class="doctor">_</td>
		<td class="rosterStatus">&nbsp;</td>
		<td class="patientStatus">AC</td>
		<td class="phone">905-</td>
	</tr>
	
	<tr class="even">
	<td class="demoIdSearch">

	
		<a title="Master Demographic File" href="#"  onclick="popup(700,1027,'demographiccontrol.jsp?demographic_no=4&displaymode=edit&dboperation=search_detail')" >4</a></td>
	
		<!-- Rights -->
		<td class="links">
			<a class="encounterBtn" title="Encounter" href="#"
				onclick="popupEChart(710,1024,'/oscar_ero/oscarEncounter/IncomingEncounter.do?providerNo=999998&appointmentNo=&demographicNo=4&curProviderNo=&reason=Tel-Progress+Notes&encType=&curDate=2014-3-26&appointmentDate=&startTime=&status=');return false;">E</a>
		 <!-- Rights --> 
			<a class="rxBtn" title="Prescriptions" href="#" onclick="popup(700,1027,'../oscarRx/choosePatient.do?providerNo=&demographicNo=4')">Rx</a>
		</td>

	
		
		<td class="name"><a href="#" onclick="location.href='/oscar_ero/PMmodule/ClientManager.do?id=4'">Dumontier, Baby</a></td>
		
		
		<td class="chartNo">&nbsp;</td>
		<td class="sex">M</td>
		<td class="dob">2012-06-15</td>
		<td class="doctor">_</td>
		<td class="rosterStatus">&nbsp;</td>
		<td class="patientStatus">AC</td>
		<td class="phone">905-</td>
	</tr>
	
</table>