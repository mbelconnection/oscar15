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
<form name="form-demo">
<div class="col-lg-8">
	<button type="button" class="btn btn-primary" ng-click="saveDemographic(form-demo)">Save</button>
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
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Last Name</label>
					<div class="form-group col-xs-3">{{demographic.lastName}}</div>
					<label class="col-xs-2 control-label">First Name</label>
					<div class="form-group col-xs-3">{{demographic.firstName}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Title</label>
					<div class="form-group col-xs-3">{{demographic.title}}</div>
					<label class="col-xs-2 control-label">Sex</label>
					<div class="form-group col-xs-3">{{demographic.sexDesc}}</div>
					
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Date of Birth</label>
					<div class="form-group col-xs-3">{{demographic.dob}}</div>
					<label class="col-xs-2 control-label">SIN</label>
					<div class="form-group col-xs-3">{{demographic.sin}}</div>
					
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Aboriginal</label>
					<div class="form-group col-xs-3">{{demographic.aboriginal}}</div>
					<label class="col-xs-2 control-label">Cytology</label>
					<div class="form-group col-xs-3">{{demographic.cytology}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Language</label>
					<div class="form-group col-xs-3">{{demographic.language}}</div>
					<label class="col-xs-2 control-label">Spoken</label>
					<div class="form-group col-xs-3">{{demographic.spokenLanguage}}</div>
				</div>
			</div>			
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Newsletter</label>
					<div class="form-group col-xs-3">{{demographic.newsletter}}</div>
					<label class="col-xs-2 control-label">MyOscar UserName</label>
					<div class="form-group col-xs-3">{{demographic.myOscarUserName}}</div>
				</div>
			</div>
		</div>
		<div class="form-group demographic" style="display: none;">
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Last Name</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="lastname" ng-model="demographic.lastName"/>
					</div>
					<label class="col-xs-2 control-label">First Name</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="firstname" ng-model="demographic.firstName"/>
					</div>
				</div>
			</div>		
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Title</label>
					<div class="form-group col-xs-3">
						<select class="form-control" ng-model="demographic.title">
							<option value="title.value" ng-repeat="title in titles">{{title.name}}</option>
						</select>
					</div>
					<label class="col-xs-2 control-label">Sex</label>
					<div class="form-group col-xs-3">
						<select class="form-control" ng-model="demographic.sex">
							<option value="{{sex.value}}" ng-repeat="sex in genders">{{sex.name}}</option>
						</select>
					</div>
				</div>
			</div>			
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Date of Birth</label>
					<div class="form-group col-xs-3">
						<input id="dp-birthday" type="text" class="form-control" placeholder="Date of Birth" ng-model="demographic.dob" />
					</div>
					<label class="col-xs-2 control-label">SIN</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="SIN" ng-model="demographic.sin" />
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Language</label>
					<div class="form-group col-xs-3">
						<select class="form-control" ng-model="demographic.officialLanguage">
							<option value="{{language.value}}" ng-repeat="language in languages">{{language.name}}</option>
						</select>
					</div>
					<label class="col-xs-2 control-label">Spoken</label>
					<div class="form-group col-xs-3">
						<select class="form-control" ng-model="demographic.spokenLanguage">
							<option value="{{spoken.value}}" ng-repeat="spoken in spokens">{{spoken.name}}</option>
						</select>
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Aboriginal</label>
					<div class="form-group col-xs-3">
						<select class="form-control" ng-model="demographic.aboriginal">
							<option value="{{aboriginal.value}}" ng-repeat="aboriginal in aboriginals">{{aboriginal.name}}</option>
						</select>
					</div>
					<label class="col-xs-2 control-label">Cytology</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Cytology" ng-model="demographic.cytology" />
					</div>
				</div>
			</div>			
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Newsletter</label>
					<div class="form-group col-xs-3">
						<select class="form-control" ng-model="demographic.newsletter">
							<option value="{{newsletter.value}}" ng-repeat="newsletter in newsletters">{{newsletter.name}}</option>
						</select>
					</div>
					<label class="col-xs-2 control-label">MyOscar UserName</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="MyOscar UserName" ng-model="demographic.myOscarUserName" />
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
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Phone(H)</label>
					<div class="form-group col-xs-3">{{demographic.phone}}</div>
					<label class="col-xs-2 control-label">Address</label>
					<div class="form-group col-xs-3">{{demographic.address.address}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Phone(W)</label>
					<div class="form-group col-xs-3">{{demographic.alternativePhone}}</div>
					<label class="col-xs-2 control-label">City</label>
					<div class="form-group col-xs-3">{{demographic.address.city}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Phone(C)</label>
					<div class="form-group col-xs-3">{{demographic.cellPhone}}</div>
					<label class="col-xs-2 control-label">Province</label>
					<div class="form-group col-xs-3">{{demographic.address.province}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Comments</label>
					<div class="form-group col-xs-3">{{demographic.phoneComment}}</div>
					<label class="col-xs-2 control-label">Postal Code</label>
					<div class="form-group col-xs-3">{{demographic.address.postal}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Email</label>
					<div class="form-group col-xs-3">{{demographic.email}}</div>
					<label class="col-xs-2 control-label">Country of Origin</label>
					<div class="form-group col-xs-3">{{demographic.countryOfOrigin}}</div>
				</div>
			</div>
		</div>
		<div class="form-group contact" style="display: none;">
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Phone(H)</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Home Phone" ng-model="demographic.phone" />
					</div>
					<label class="col-xs-2 control-label">Address</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Address" ng-model="demographic.address.address" />
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Phone(W)</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Work Phone" ng-model="demographic.alternativePhone" />
					</div>
					<label class="col-xs-2 control-label">City</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="City" ng-model="demographic.city" />
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Phone(C)</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Cell Phone" ng-model="demographic.cellPhone" />
					</div>
					<label class="col-xs-2 control-label">Province</label>
					<div class="form-group col-xs-3">
						<select class="form-control col-xs-4" ng-model="demographic.province">
							<option value="{{province.value}}" ng-repeat="province in provinces">{{province.name}}</option>
						</select>
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Comments</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Phone Comments" ng-model="demographic.phoneComment" />
					</div>
					<label class="col-xs-2 control-label">Postal Code</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Postcode" ng-model="demographic.postcode" />
					</div>
				</div>
			</div>		
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Email</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Email" ng-model="demographic.email" />
					</div>
					<label class="col-xs-2 control-label">Country of Origin</label>
					<div class="form-group col-xs-3">
						<select class="form-control" ng-model="demographic.countryOfOrigin">
							<option value="{{country.countryId}}" ng-repeat="country in countries">{{country.countryName}}</option>
						</select>
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
					<div class="form-group col-xs-3">{{demographic.hin}} - {{demographic.ver}}</div>
					<label class="col-xs-2 control-label">HC Type</label>
					<div class="form-group col-xs-3">{{demographic.hcType}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">EFF Date</label>
					<div class="form-group col-xs-3">{{demographic.effDate | date:'yyyy-MM-dd'}}</div>
					<label class="col-xs-2 control-label">Renew Date</label>
					<div class="form-group col-xs-3">{{demographic.hcRenewDate| date:'yyyy-MM-dd'}}</div>
				</div>
			</div>
		</div>
		<div class="form-group insurance" style="display: none;">
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Insurance#</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Health Insurance#" ng-model="demographic.hin" style="width: 73%;"/>
						<input type="text" class="form-control" placeholder="Ver" ng-model="demographic.ver" style="width: 24%;"/>
					</div>
					<label class="col-xs-2 control-label">HC Type</label>
					<div class="form-group col-xs-3">
						<select class="form-control col-xs-4" ng-model="demographic.hcType">
							<option value="{{hcType.value}}" ng-repeat="hcType in provinces">{{hcType.name}}</option>
						</select>
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">EFF Date</label>
					<div class="form-group col-xs-3">
						<input id="dp-effDate" type="text" class="form-control" placeholder="Effective Date" data-date-format="yyyy-mm-dd" ng-model="demographic.effDate" />
					</div>
					<label class="col-xs-2 control-label">Renew Date</label>
					<div class="form-group col-xs-3">
						<input id="dp-renewDate" type="text" class="form-control" placeholder="Renew Date" data-date-format="yyyy-mm-dd" ng-model="demographic.hcRenewDate" />
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
					<div class="form-group col-xs-3">{{demographic.doctor}}</div>
					<label class="col-xs-2 control-label">Nurse</label>
					<div class="form-group col-xs-3">{{demographic.nurse}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Midwife</label>
					<div class="form-group col-xs-3">{{demographic.midwife}}</div>
					<label class="col-xs-2 control-label">Resident</label>
					<div class="form-group col-xs-3">{{demographic.resident}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Referral Doctor</label>
					<div class="form-group col-xs-3">{{demographic.referralDoctor}}</div>
					<label class="col-xs-2 control-label">Referral Doctor#</label>
					<div class="form-group col-xs-3">{{demographic.referralDoctorNo}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Roster Status:</label>
					<div class="form-group col-xs-3">{{demographic.rosterStatus}}</div>
					<label class="col-xs-2 control-label">Date Rostered:</label>
					<div class="form-group col-xs-3">{{demographic.rosterDate  | date:'yyyy-MM-dd'}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Patient Status:</label>
					<div class="form-group col-xs-3">{{demographic.patientStatus}}</div>
					<label class="col-xs-2 control-label">Chart No:</label>
					<div class="form-group col-xs-3">{{demographic.chartNo}}</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Date Joined</label>
					<div class="form-group col-xs-3">{{demographic.dateJoined | date:'yyyy-MM-dd'}}</div>
					<label class="col-xs-2 control-label">End Date</label>
					<div class="form-group col-xs-3">{{demographic.endDate | date:'yyyy-MM-dd'}}</div>
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
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Roster Status:</label>
					<div class="form-group col-xs-3">
						<select class="form-control" ng-model="demographic.rosterStatus">
							<option value="{{status.value}}" ng-repeat="status in rosterStatus">{{status.name}}</option>
						</select>
					</div>
					<label class="col-xs-2 control-label">Date Rostered:</label>
					<div class="form-group col-xs-3">
						<input id="effDate" type="text" class="form-control" placeholder="Rostered Date" data-date-format="yyyy-mm-dd" ng-model="demographic.rosterDate" />
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Patient Status:</label>
					<div class="form-group col-xs-3">
						<select class="form-control" ng-model="demographic.patientStatus">
							<option value="{{status.value}}" ng-repeat="status in patientStatus">{{status.name}}</option>
						</select>
					</div>
					<label class="col-xs-2 control-label">Chart No:</label>
					<div class="form-group col-xs-3">
						<input type="text" class="form-control" placeholder="Chart No." ng-model="demographic.chartNo" />
					</div>
				</div>
			</div>
			<div class="col-xs-10">
				<div class="form-inline">
					<label class="col-xs-2 control-label">Date Joined</label>
					<div class="form-group col-xs-3">
						<input id="dp-dateJoined" type="text" class="form-control" placeholder="Date Joined" data-date-format="yyyy-mm-dd" ng-model="demographic.dateJoined" />
					</div>
					<label class="col-xs-2 control-label">End Date</label>
					<div class="form-group col-xs-3">
						<input id="dp-endDate" type="text" class="form-control" placeholder="Renew Date" data-date-format="yyyy-mm-dd" ng-model="demographic.endDate" />
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
</form>
<link href="<%=request.getContextPath() %>/css/datepicker.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap-datepicker.js"></script>
<script type="text/javascript">
	var birthday = $("[id^=dp-]").datepicker({
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
