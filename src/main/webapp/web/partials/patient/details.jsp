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

<div class="col-lg-8" ng-controller="PatientDetailCtrl as detailController">
	<button type="button" class="btn btn-primary">Save</button>
	<div class="btn-group">
		<button type="button" class="btn btn-default">Print Label</button>
		<div class="btn-group">
			<button type="button" class="btn btn-default">Print PDF</button>
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				<span class="caret"></span> <span class="sr-only">Toggle Dropdown</span>
			</button>
			<ul class="dropdown-menu" role="menu">
				<li><a href="#">PDF Address</a></li>
				<li><a href="#">Another action</a></li>
				<li><a href="#">Something else here</a></li>
				<li class="divider"></li>
				<li><a href="#">Separated link</a></li>
			</ul>
		</div>
	</div>
	<div class="btn-group">
		<div class="btn-group">
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				Integrator <span class="caret"></span>
			</button>
			<ul class="dropdown-menu">
				<li><a href="#">Compare with Integrator</a></li>
				<li><a href="#">Update from Integrator</a></li>
				<li><a href="#">Send Note Integrator</a></li>
			</ul>
		</div>
		<div class="btn-group">
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				More <span class="caret"></span>
			</button>
			<ul class="dropdown-menu">
				<li><a href="#">Export to CDS</a></li>
				<li><a href="#">Export to CCD</a></li>
				<li><a href="#">Export to XPHR</a></li>
			</ul>
		</div>
	</div>
	<fieldset>
		<legend>
			Demographic
			<div class="btn-group pull-right">
				<button class="btn view-edit" rel="demographic">View/Edit</button>
			</div>
		</legend>
		<div class="form-group demographic">
			<div class="col-xs-10 form-inline">
				<label class="col-xs-1 control-label">Title</label>
				<div class="form-group col-xs-2">{{demographic.title}}</div>
				<label class="col-xs-2 control-label">Name</label>
				<div class="form-group">{{demographic.lastName}}</div>
				<div class="form-group">{{demographic.firstName}}</div>
			</div>
			<div class="col-xs-10 form-inline">
				<label class="col-xs-1 control-label">Sex</label>
				<div class="form-group col-xs-2">{{demographic.sex}}</div>
				<label class="col-xs-2 control-label">DOB</label>
				<div class="form-group">{{demographic.dob}}</div>
			</div>
			<div class="col-xs-10 form-inline">
				<label class="col-xs-1 control-label">Age</label>
				<div class="form-group col-xs-2">{{demographic.age}}</div>
				<label class="col-xs-2 control-label">Language</label>
				<div class="form-group">{{demographic.language}}</div>
			</div>
		</div>
		<div class="form-group demographic" style="display: none;">
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-1 control-label">Title</label>
					<div class="form-group col-xs-2">
						<select class="form-control" ng-model="demographic.title">
							<option ng-repeat="title in detailController.titles">{{title}}</option>
						</select>
					</div>
					<label class="col-xs-2 control-label">Name</label>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="lastname" ng-model="demographic.lastName" />
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="firstname" ng-model="demographic.firstName" />
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label for="birthday" class="col-xs-1 control-label">Sex</label>
					<div class="form-group col-xs-2">
						<select class="form-control" ng-model="demographic.sex">
							<option ng-repeat="sex in detailController.genders">{{sex}}</option>
						</select>
					</div>
					<label for="birthday" class="col-xs-2 control-label">DOB</label>
					<div class="form-group">
						<input id="birthday" type="text" class="form-control" placeholder="Date of Birth" ng-model="demographic.dob" />
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-1 control-label">Age</label>
					<div class="form-group col-xs-2">
						<input type="text" class="form-control" placeholder="Age" ng-model="demographic.age" />
					</div>
					<label class="col-xs-2 control-label">Language</label>
					<div class="form-group">
						<select class="form-control col-xs-4" ng-model="demographic.language">
							<option ng-repeat="language in detailController.languages">{{language}}</option>
						</select>
					</div>
				</div>
			</div>
		</div>
	</fieldset>
	<fieldset>
		<legend>
			Contact Info
			<div class="btn-group pull-right">
				<button class="btn view-edit" rel="contact">View/Edit</button>
			</div>
		</legend>
		<div class="form-group contact">
			<div class="col-xs-5">
				<div>
					<label class="col-xs-3 control-label">Phone(H)</label>
					<div class="form-group">{{demographic.homePhone}}</div>
				</div>
				<div>
					<label class="col-xs-3 control-label">Phone(W)</label>
					<div class="form-group">{{demographic.workPhone}}</div>
				</div>
				<div>
					<label class="col-xs-3 control-label">Phone(C)</label>
					<div class="form-group">{{demographic.cellPhone}}</div>
				</div>
				<div>
					<label class="col-xs-3 control-label">Comments</label>
					<div class="form-group">{{demographic.phoneComment}}</div>
				</div>
			</div>
			<div class="col-xs-5">
				<div>
					<label class="col-xs-3 control-label">Address</label>
					<div class="form-group">{{demographic.address}}</div>
				</div>
				<div>
					<label class="col-xs-3 control-label">City</label>
					<div class="form-group">{{demographic.city}}</div>
				</div>
				<div>
					<label class="col-xs-3 control-label">Province</label>
					<div class="form-group">{{demographic.province}}</div>
				</div>
				<div>
					<label class="col-xs-3 control-label">Postcode</label>
					<div class="form-group">{{demographic.postcode}}</div>
				</div>
				<div>
					<label class="col-xs-3 control-label">Email</label>
					<div class="form-group">{{demographic.email}}</div>
				</div>
				<div>
					<label class="col-xs-3 control-label">Newsletter</label>
					<div class="form-group">{{demographic.newsletter}}</div>
				</div>
			</div>
		</div>
		<div class="form-group contact" style="display: none;">
			<div class="col-xs-5">
				<div class="form-inline">
					<label class="col-xs-3 control-label">Phone(H)</label>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="Home Phone" ng-model="demographic.homePhone" />
					</div>
				</div>
				<div class="form-inline">
					<label class="col-xs-3 control-label">Phone(W)</label>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="Work Phone" ng-model="demographic.workPhone" />
					</div>
				</div>
				<div class="form-inline">
					<label class="col-xs-3 control-label">Phone(C)</label>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="Cell Phone" ng-model="demographic.cellPhone" />
					</div>
				</div>
				<div class="form-inline">
					<label class="col-xs-3 control-label">Comments</label>
					<div class="form-group">
						<textarea class="form-control" placeholder="Phone Comments" rows="3" cols="17">{{demographic.phoneComment}}</textarea>
					</div>
				</div>
			</div>
			<div class="col-xs-5">
				<div class="form-inline">
					<label class="col-xs-3 control-label">Address</label>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="Address" ng-model="demographic.address" />
					</div>
				</div>
				<div class="form-inline">
					<label class="col-xs-3 control-label">City</label>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="City" ng-model="demographic.city" />
					</div>
				</div>
				<div class="form-inline">
					<label class="col-xs-3 control-label">Province</label>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="Province" ng-model="demographic.province" />
					</div>
				</div>
				<div class="form-inline">
					<label class="col-xs-3 control-label">Postcode</label>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="Postcode" ng-model="demographic.postcode" />
					</div>
				</div>
				<div class="form-inline">
					<label class="col-xs-3 control-label">Email</label>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="Email" ng-model="demographic.email" />
					</div>
				</div>
				<div class="form-inline">
					<label class="col-xs-3 control-label">Newsletter</label>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="Newsletter" ng-model="demographic.newsletter" />
					</div>
				</div>
			</div>
		</div>
	</fieldset>
	<fieldset>
		<legend>
			Health Insurance
			<div class="btn-group pull-right">
				<button class="btn view-edit" rel="insurance">View/Edit</button>
			</div>
		</legend>
		<div class="form-group insurance">
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Insurance#</label>
					<div class="form-group col-xs-3">123 456 789</div>
					<label class="col-xs-2 control-label">HC Type</label>
					<div class="form-group col-xs-3">OT</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">EFF Date</label>
					<div class="form-group col-xs-3">{{demographic.effDate}}</div>
					<label class="col-xs-2 control-label">Renew Date</label>
					<div class="form-group col-xs-3">{{demographic.renewDate}}</div>
				</div>
			</div>
		</div>
		<div class="form-group insurance" style="display: none;">
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Insurance#</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Health Insurance#" value="123 456 789" />
					</div>
					<label class="col-xs-2 control-label">HC Type</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="HC Type" value="OT" />
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">EFF Date</label>
					<div class="form-group col-xs-3">
						<input id="effDate" type="text" class="form-control" placeholder="Effective Date" data-date-format="yyyy-mm-dd" ng-model="demographic.effDate" />
					</div>
					<label class="col-xs-2 control-label">Renew Date</label>
					<div class="form-group col-xs-3">
						<input id="renewDate" type="text" class="form-control" placeholder="Renew Date" data-date-format="yyyy-mm-dd" ng-model="demographic.renewDate" />
					</div>
				</div>
			</div>
		</div>
	</fieldset>
	<fieldset>
		<legend>
			Care Team
			<div class="btn-group pull-right">
				<button class="btn view-edit" rel="care-team">View/Edit</button>
			</div>
		</legend>
		<div class="form-group care-team">
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Doctor</label>
					<div class="form-group col-xs-3">
						{{demographic.doctor}}
					</div>
					<label class="col-xs-2 control-label">Nurse</label>
					<div class="form-group col-xs-3">
						{{demographic.nurse}}
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Midwife</label>
					<div class="form-group col-xs-3">
						{{demographic.midwife}}
					</div>
					<label class="col-xs-2 control-label">Resident</label>
					<div class="form-group col-xs-3">
						{{demographic.resident}}
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Referral Doctor</label>
					<div class="form-group col-xs-3">
						{{demographic.referralDoctor}}
					</div>
					<label class="col-xs-2 control-label">Referral Doctor#</label>
					<div class="form-group col-xs-3">
						{{demographic.referralDoctorNo}}
					</div>
				</div>
			</div>
		</div>		
		<div class="form-group care-team" style="display: none;">
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Doctor</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Doctor" ng-model="demographic.doctor" />
					</div>
					<label class="col-xs-2 control-label">Nurse</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Nurse" ng-model="demographic.nurse" />
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Midwife</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Midwife" ng-model="demographic.midwife" />
					</div>
					<label class="col-xs-2 control-label">Resident</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Resident" ng-model="demographic.resident" />
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Referral Doctor</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Referral Doctor" ng-model="demographic.referralDoctor" />
					</div>
					<label class="col-xs-2 control-label">Referral Doctor#</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Referral Doctor" ng-model="demographic.referralDoctorNo" />
					</div>
				</div>
			</div>
		</div>
	</fieldset>
</div>
<div class="col-lg-4">
	<img src="https://localhost:8081/oscar/images/defaultR_img.jpg" /> <br />
	<fieldset>
		<legend>Alerts</legend>
		<textarea class="form-control" rows="3" style="color: red;">Don't release info to family</textarea>
	</fieldset>

	<fieldset>
		<legend>Notes</legend>
		<textarea class="form-control" rows="3">Need version code on health card old: GH</textarea>
	</fieldset>
	<fieldset>
		<legend>Contacts</legend>
		<ul class="list-group">
			<li class="list-group-item">Bob Hooper <span class="pull-right">Brother EC</span></li>
			<li class="list-group-item">Cathy Dickenson <span class="pull-right">Mother</span></li>
		</ul>
	</fieldset>
	<fieldset>
		<legend>Professional Contacts</legend>
		<h5>
			Ringo Starr<small>(Drummer)</small><span class="pull-right">905-555-1111</span>
		</h5>
		<h5>
			Tyler Stufferson<small>(IP Lawyer)</small><span class="pull-right">905-555-2222</span>
		</h5>
	</fieldset>
</div>
<link href="<%=request.getContextPath() %>/css/datepicker.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap-datepicker.js"></script>
<script type="text/javascript">
	var birthday = $("#birthday").datepicker({
		format : "yyyy-mm-dd"
	}).on("changeDate", function(event) {
		birthday.hide();
	}).data('datepicker');

	var effDate = $("#effDate").datepicker({
		format : "yyyy-mm-dd",
		viewMode : "days",
		minViewMode : "days"
	}).on("changeDate", function(event) {
		effDate.hide();
	}).data('datepicker');
	
	var renewDate = $("#renewDate").datepicker({
		format : "yyyy-mm-dd",
		viewMode : "days",
		minViewMode : "days"
	}).on("changeDate", function(event) {
		renewDate.hide();
	}).data('datepicker');

	$(document).ready(function() {
		$(".view-edit").click(function() {
			$("." + $(this).attr("rel")).toggle();
		});
	});
</script>
