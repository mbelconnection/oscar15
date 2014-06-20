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
<form name="ClinicDashboard">
	<div class="row">
		<div class="col-lg-12">
		<h3>Clinic Management Dashboard</h3></div>
	</div>
	<div class="row">
		<div class="col-lg-12">
		<div>
			Interval:
			<select>
				<option>Monthly</option>
				<option>Weekly</option>
				<option>Quarterly</option>
				<option>YTD</option>
				<option>Yearly</option>
			</select>
			<select>
				<option>1 January 2013 - 31 January 2013</option>
				<option>1 February 2013 - 28 February 2013</option>
				<option>1 March 2013 - 31 March 2013</option>
				<option>1 April 2013 - 30 April 2013</option>
				<option>1 May 2013 - 31 May 2013</option>
				<option>1 June 2013 - 30 June 2013</option>
				<option selected>1 July 2013 - 31 July 2013</option>
				<option>1 August 2013 - 31 August 2013</option>
				<option>1 September 2013 - 30 September 2013</option>
				<option>1 October 2013 - 31 October 2013</option>
				<option>1 November 2013 - 30 November 2013</option>
				<option>1 December 2013 - 31 December 2013</option>
			</select>
		</div>
		</div>
	</div>

	<div class="row">
		<div class="col-lg-12"><h3>Clinic Case Load</h3></div>
	</div>
	
	<div class="row">
		<div class="col-lg-6">
			<table class="table table-bordered framed table-striped column">
			<tr>
				<th>Patient Enrollment</th>
				<th class="w60 t-right">Male</th>
				<th class="w60 t-right">Female</th>
				<th class="w60 t-right">Total</th>
			</tr>
			<tr>
				<td>Pre-existing Patients at beginning of reporting period</td>
				<td>239</td><td>9</td><td>248</td>
			</tr>
			<tr>
				<td>New Admissions</td>
				<td>7</td><td>1</td><td>8</td>
			</tr>
			<tr>
				<td>Dropouts</td>
				<td>4</td><td>1</td><td>5</td>
			</tr>
			<tr>
				<td>Caseload at end of reporting period</td>
				<td>242</td><td>9</td><td>251</td>
			</tr>
			<tr>
				<td>Waiting list for admission</td>
				<td>7</td><td>2</td><td>9</td>
			</tr>
			<tr style="border-top: solid 3px;">
				<td>Average Length of Stay (LOS)</td>
				<td>14</td><td>11</td><td>13</td>
			</tr>
			<tr>
				<td>Average LOS for drop-out</td>
				<td>12</td><td>12</td><td>12</td>
			</tr>
			<tr style="border-top: solid 3px;">
				<td>0-6 months</td>
				<td>0</td><td>0</td><td>0</td>
			</tr>
			<tr>
				<td>7-12 months</td>
				<td>2</td><td>1</td><td>3</td>
			</tr>
			<tr>
				<td>13-24 months</td>
				<td>2</td><td>0</td><td>2</td>
			</tr>
			<tr>
				<td>&gt;24 months</td>
				<td>0</td><td>0</td><td>0</td>
			</tr>
			</table>
		</div>
		<div class="col-lg-6">
			<select>
				<option>Pre-existing Patients at beginning of reporting period</option>
				<option>New Admissions</option>
				<option>Dropouts</option>
				<option>Caseload at end of reporting period</option>
				<option>Waiting list for admission</option>
				<option>Average Length of Stay (LOS)</option>
				<option>Average LOS for drop-out</option>
			</select>
			<select>
				<option>Total</option>
				<option>Male</option>
				<option>Female</option>
			</select>
			<br/>
			<img src="clinicDashboard/images/clinic_graph1.png"/>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12"><h3>Methadone</h3></div>

		<div class="col-lg-6">
			<table class="table table-bordered table-striped column w400" >
			<tr>
				<th>Methadone Dispensing</th>
				<th class="w60 t-right">Value</th>
			</tr>
			<tr>
				<td>Number of patients</td><td class="t-right">248</td>
			</tr>
			<tr>
				<td>Average dose (mg/day)</td><td class="t-right">92</td>
			</tr>
			<tr>
				<td>Median dose (mg/day)</td><td class="t-right">85</td>
			</tr>
			<tr>
				<td>Low dose (mg/day)</td><td class="t-right">24</td>
			</tr>
			<tr>
				<td>High dose (mg/day)</td><td class="t-right">210</td>
			</tr>
			<tr style="border-top: solid 3px;">
				<td>Number of patients missing dose</td><td class="t-right">5</td>
			</tr>
			<tr>
				<td>Number of missed dosing days</td><td class="t-right">22</td>
			</tr>
			</table>
		</div>
		<div class="col-lg-6">
			<select>
				<option>Number of patients</option>
				<option>Average dose (mg/day)</option>
				<option>Median dose (mg/day)</option>
				<option>Low dose (mg/day)</option>
				<option>High dose (mg/day)</option>
				<option>Number of patients missing dose</option>
				<option>Number of missed dosing days</option>
			</select>		
			<br/>
			<img src="clinicDashboard/images/clinic_graph2.png"/>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12"><h3>Clinic Case Load</h3></div>

		<div class="col-lg-6">
			<table class="table table-bordered framed table-striped column">
			<tr>
				<th>Drug Tested</th>
				<th class="w100 t-right"># of Patients Tested</th>
				<th class="w100 t-right"># of Patients Positive (%)</th>
				<th class="w100 t-right"># of Tests</th>
				<th class="w100 t-right"># of Tests Positive (%)</th>
			</tr>
			<tr>
				<td>Opioid (total)</td>
				<td class="t-right">190</td>
				<td class="t-right">19(10%)</td>
				<td class="t-right">238</td>
				<td class="t-right">24(10%)</td>
			</tr>
			<tr>
				<td style="padding-left: 20px;">0-6 months</td>
				<td class="t-right">50</td>
				<td class="t-right">8</td>
				<td class="t-right">78</td>
				<td class="t-right">13</td>
			</tr>
			<tr>
				<td style="padding-left: 20px;">7-12 months</td>
				<td class="t-right">85</td>
				<td class="t-right">6</td>
				<td class="t-right">82</td>
				<td class="t-right">7</td>
			</tr>
			<tr>
				<td style="padding-left: 20px;">&gt;12 months</td>
				<td class="t-right">55</td>
				<td class="t-right">5</td>
				<td class="t-right">78</td>
				<td class="t-right"><4/td>
			</tr>
			<tr>
				<td>Methamphetamine (total)</td>
				<td class="t-right">30</td>
				<td class="t-right">15(50%)</td>
				<td class="t-right">40</td>
				<td class="t-right">30(75%)</td>
			</tr>
			<tr>
				<td style="padding-left: 20px;">0-6 months</td>
				<td class="t-right">8</td>
				<td class="t-right">3</td>
				<td class="t-right">12</td>
				<td class="t-right">6</td>
			</tr>
			<tr>
				<td style="padding-left: 20px;">7-12 months</td>
				<td class="t-right">14</td>
				<td class="t-right">5</td>
				<td class="t-right">14</td>
				<td class="t-right">11</td>
			</tr>
			<tr>
				<td style="padding-left: 20px;">&gt;12 months</td>
				<td class="t-right">8</td>
				<td class="t-right">7</td>
				<td class="t-right">14</td>
				<td class="t-right">13</td>
			</tr>
			<tr>
				<td>Benzodiazepine</td>
				<td class="t-right">0</td>
				<td class="t-right">0</td>
				<td class="t-right">0</td>
				<td class="t-right">0</td>
			</tr>
			<tr>
				<td>Marijuana/Cannabis</td>
				<td class="t-right">0</td>
				<td class="t-right">0</td>
				<td class="t-right">0</td>
				<td class="t-right">0</td>
			</tr>
			<tr>
				<td>Other</td>
				<td class="t-right">0</td>
				<td class="t-right">0</td>
				<td class="t-right">0</td>
				<td class="t-right">0</td>
			</tr>
			</table>
		</div>
	<div class="col-lg-6">
		<select>
			<option>Opioid</option>
			<option>Methamphetamine</option>
			<option>Benzodiazepine</option>
			<option>Marijuana/Cannabis</option>
			<option>Other</option>
		</select>
		<select>
			<option>0-6 months</option>
			<option>7-12 months</option>
			<option>&gt;12 months</option>
		</select>
		<br/>
		<img src="clinicDashboard/images/clinic_graph3.png"/>
	</div>
</div>
	

	<div class="center DoNotPrint">
		<input id="print" type="button" value="Print" style="width: 150px; height: 50px" class="btn btn-primary" onclick="window.print()">
	</div>

</form>

