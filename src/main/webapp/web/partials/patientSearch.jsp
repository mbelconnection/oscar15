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
<style>
.flag-column {
	width:10px
}
</style>


<div class="row">

<div class="col-md-9" ng-controller="PatientSearchCtrl">


<div class="form-group">

<form name="myform">
<input type="hidden" name="method" value="search"/>
    
<fieldset>
    <legend>Search Patients</legend>
    <div class='row'>
        <div class='col-sm-4'>    
            <div class='form-group'>
                <input class="form-control" ng-model="formData.lastName" size="30" type="text"  placeholder="Last Name"/>
            </div>
        </div>
        <div class='col-sm-4'>
            <div class='form-group'>
                <input class="form-control" ng-model="formData.firstName" size="30" type="text"  placeholder="First Name"/>
            </div>
        </div>
        <div class='col-sm-4'>
            <div class='form-group'>
                 <input class="form-control" ng-model="formData.dob" size="30" type="text"  placeholder="Date of Birth"/>
            </div>
        </div>
    </div>

    <div class='row'>
  	  <div class='col-sm-4'>
            <div class='form-group'>
                <input class="form-control" ng-model="formData.healthCardNumber" size="30" type="text"  placeholder="Health Card #"/>
            </div>
        </div>
        <div class='col-sm-4'>    
            <div class='form-group'>
                    <select class="form-control"  ng-model="formData.gender" size="1">
				    	<option value="">All Genders</option>
				    	<option value="M">Male</option>
				    	<option value="F">Female</option>
				    	<option value="T">Transgendered</option>
				    	<option value="U">Unknown</option>
				    </select>
            </div>
        </div>
        <div class='col-sm-4'>
            <div class='form-group'>
                <input class="form-control" ng-model="formData.chartNo" size="30" type="text"  placeholder="Chart No"/>
            </div>
        </div>
    </div>    
     <div class='row'>
        <div class='col-sm-6'>    
            <div class='form-group'>
                <label for="user_firstname">Demographic No</label>
                <input class="form-control" ng-model="formData.demographicNo" size="30" type="text"  placeholder="Demographic #"/>
            </div>
        </div>
        <div class='col-sm-6'>
            <div class='form-group'>
                <label for="user_firstname">Active</label>
                <select class="form-control"  ng-model="formData.active" size="1">
				    	<option value="1">Yes</option>
				    	<option value="0">No</option>
				    	
				    </select>
            </div>
        </div>
    </div>    
</fieldset>

   
     <!-- soundex? bed program, search outside program domain, admission date from/to -->
     <button class="btn" ng-click="performSearch()">Search</button>
     <button class="btn" ng-click="reset()">Reset</button>
</form>
</div>

<table class="table" ng-show="searchResults">
	<thead>
		<tr>
			<th>Demographic #</th>
			<th>HIN</th>
			<th>Chart #</th>
			<th>Gender</th>
			<th>Date of Birth</th>
			<th>MRP</th>
			<th>Roster Status</th>
			<th>Patient Status</th>
			<th>Phone #</th>
		</tr>
	</thead>
	<tbody>
		<tr ng-repeat="item in searchResults">
			<td>{{item.id}} - {{item.name}}</td>
			<td>{{item.hin}}</td>
			<td>{{item.chartNo}}</td>
			<td>{{item.gender}}</td>
			<td>{{item.dobString}}</td>
			<td>{{item.mrp}}</td>
			<td>{{item.rosterStatus}}</td>
			<td>{{item.patientStatus}}</td>
			<td>{{item.phone}}</td>
		</tr>
	</tbody>
</table>

<pre>
	{{formData}}
</pre>
<br/>
<pre>
	{{searchResults}}
</pre>


</div>


	

<!-- 

	<form class="form-horizontal">
	<div class="form-group">
		<label class="control-label">Last Name</label>
		<input type="text" class="form-control" placeholder="Last Name" />
		
		<label class="control-label">First Name</label>
		<input type="text" class="form-control" placeholder="First Name" />
		
		<label class="control-label">Patient Id</label>
		<div class="form-group">
			<input type="text" class="form-control" placeholder="Demographic No" />
		</div>
		
		<label class="control-label">Date of Birth</label>
		<div class="form-group">
			<input type="text" class="form-control" placeholder="Date of Birth" />
		</div>
	</div>
	</form>
	-->
</div>
</div>
