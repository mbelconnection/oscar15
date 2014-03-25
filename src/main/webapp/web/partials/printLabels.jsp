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
<html>
	<head>
	<script src="../../library/bootstrap/3.0.0/js/bootstrap.min.js"></script>
	<link href="../../library/bootstrap/3.0.0/css/bootstrap.css" rel="stylesheet">
		<script>
			function setPrintData(){
				document.getElementById("date").innerHTML = window.opener.printLable_date;
				document.getElementById("time").innerHTML = window.opener.printLable_time;
				document.getElementById("provider").innerHTML = window.opener.printLable_provName;
			}
			
			function printPage(){
				document.getElementById("print_but").style.display = "none";				
				window.print();
			}
		</script>
		<style>
			.appt_tbl {
				border: 1px solid #AAAAAA;
				font-size: 0.8em;
				border-collapse: collapse;
			}
			
			.appt_tbl td {
				border: 1px solid #AAAAAA;
				padding: 0.5em;
				font-weight:normal;
			}
			
			.title_bold_font {
				border: 1px solid #AAAAAA;
				padding: 0.5em;
				font-weight: bold;
			}
		</style>
	</head>
	<body onload="setPrintData()">
			
		 <div style="text-align:center;padding-top:30px;width:100%;" >
			<table class="appt_tbl" width="500px" align="center">
				<tr>
					<td width="100px">
						<b>Date</b>
					</td>
					<td width="100px">
						<b>Start Time</b>
					</td>
					<td width="300px">
						<b>Provider</b>
					</td>
				</tr>
				<tr>
					<td>
						<span id="date"></span>
					</td>
					<td>
						<span id="time"></span>
					</td>
					<td>
						<span id="provider"></span>
					</td>
				</tr>				
			</table>
		</div>
		<div style="text-align:center;padding-top:50px;">			
		  	
		  	<div class="btn-group" style="padding-right:15px;" id="">
			  <button type="button"  class="btn btn-info" style="font-size:12px;" onclick="self.close();"><b>Close</b></button>
		  	</div>
		  	
		  	<div class="btn-group" style="padding-right:15px;" id="print_but">
			  <button type="button"  class="btn btn-primary" style="font-size:12px;" onclick="printPage();"><b>Print</b></button>
		  	</div>
		</div>
	</body>
	
</html>