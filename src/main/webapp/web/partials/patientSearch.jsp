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
<div class="col-md-9">


<div class="col-md-5">
<p class="lead">Search Patients</p>

<div class="form-group">

<form method="post" action="../PMmodule/ClientSearch2.do">
    Last Name: <input name="criteria.lastName" type="text" class="form-control" placeholder="Last Name"/>
    First Name:<input name="criteria.firstName" type="text" class="form-control" placeholder="First Name"/>
    Date of Birth:<input name="criteria.dob" type="text" class="form-control" placeholder="Date of Birth"/>
    HIN:<input type="text" class="form-control" size="10" placeholder="HIN"/>
    Gender:
    <select class="form-control" name="criteria.gender">
    	<option value="">Any</option>
    	<option value="M">Male</option>
    	<option value="F">Female</option>
    	<option value="T">Transgendered</option>
    	<option value="U">Unknown</option>
    </select>
     Chart No:<input name="criteria.chartNo" type="text" class="form-control" placeholder="Chart no"/>
     Demographic No:<input type="text" class="form-control" placeholder="Demographic No"/>
     
    Active:<input name="criteria.active" type="checkbox" class="form-control" name="active" />
     
     <!-- soundex? bed program, search outside program domain, admission date from/to -->
     <button class="btn">Search</button>
     <button class="btn">Reset</button>
</form>

</div>
</div>
<div class="col-md-4">
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
