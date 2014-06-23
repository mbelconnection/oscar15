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
<%@page contentType="text/html; charset=UTF-8" %>
<div class="col-lg-8">
	

	<div class="btn-group">
		<button type="button" class="btn btn-primary" ng-click="save()">Save</button>
		<button type="button" class="btn btn-default">Print Label</button>
		<div class="btn-group">
			<button type="button" class="btn btn-default">Print PDF</button>
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				<span class="caret"></span> <span class="sr-only">Toggle Dropdown</span>
			</button>
			<ul class="dropdown-menu" role="menu">
				<li><a href="#">PDF Address</a></li>
				<li class="divider"></li>
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

	<%--style>
		div {
			margin-bottom: 5px;
		}
		label {
			width: 120px;
		}
		a:hover {
			text-decoration: none;
			cursor: pointer;
		}
		.well {
			padding-top: 10px;
			padding-bottom: 10px;
		}
		.form-control {
			display: inline;
			height: initial;
			width: initial;
			padding: 2px;
		}
		.form-group .form-control {
			width: 180px;
		}
		--%>
		<style>
		#photo {
			height: 150px;
			width: auto;
			cursor: pointer;
		}
	</style>
	
	<fieldset>
		<legend>
			
		</legend>
	
		<div class="form-group">
			<div class="col-sm-2">
			    <label for="demotitle">Title</label>
			    <select name="title" class="form-control" id="demotitle" ng-model="page.demo.title" >
						<option value="">-Not Set-</option>
						<option value="DR">DR</option>
					    <option value="MS">MS</option>
					    <option selected="" value="MISS">MISS</option>
					    <option value="MRS">MRS</option>
					    <option value="MR">MR</option>
					    <option value="MSSR">MSSR</option>
					    <option value="PROF">PROF</option>
					    <option value="REEVE">REEVE</option>
					    <option value="REV">REV</option>
					    <option value="RT_HON">RT_HON</option>
					    <option value="SEN">SEN</option>
					    <option value="SGT">SGT</option>
					    <option value="SR">SR</option>
					    <option value="DR">DR</option>
				</select>
	  		</div>
	  		<div class="col-sm-5">
			    <label for="demofirstName">First Name</label>
			    <input type="text" class="form-control" id="demofirstName" placeholder="First Name" ng-model="page.demo.firstName">
			</div>
			<div class="col-sm-5">
			    <label for="demolastName">Last Name</label>
			    <input type="text" class="form-control" id="demolastName" placeholder="Last Name" ng-model="page.demo.lastName">
			</div>
	  	</div>
	  	
	  	<div class="form-group">
	  		<div class="col-sm-2">
					<label>Gender</label>
					<select name="sex" class="form-control" ng-model="page.demo.sex">
						<option value="M">Male</option>
						<option value="F">Female</option>
					</select>
			</div>
	  		<div  class="col-sm-6">
					<label>Date of Birth, Age: {{page.age}}</label>
					<div class="row">
						<div class="col-xs-4">
							<input type="text"placeholder="YYYY" class="form-control" ng-model="page.birthdayYear"/>
						</div>
						<div class="col-xs-3">
							<input type="text" placeholder="MM" class="form-control" ng-model="page.birthdayMonth"/>
						</div>
						<div class="col-xs-3">
							<input type="text" placeholder="DD" class="form-control" ng-model="page.birthdayDay"/>
						</div>
					</div>
			</div>
		</div>
	  	
  </fieldset>
	
	
	<fieldset>
		<legend>
			Address
		</legend>
		
		<div class="form-group">
					<div class="col-xs-12">
					<label>Street</label>
					<input type="text" name="address" placeholder="Address" class="form-control" ng-model="page.demo.address.address" />
					</div>
					<div class="col-xs-6">
						<label>City</label>
						<input type="text" name="city" class="form-control" placeholder="City" ng-model="page.demo.address.city"/>
					</div>
					<div class="col-xs-6">
						<label>Province</label>
						<select name="province" class="form-control" ng-model="page.demo.address.province">
							<option value="VN.AG">An Giang</option>
							<option value="VN.BV">Bà Rịa-Vũng Tàu</option>
							<option value="VN.BG">Bắc Giang</option>
							<option value="VN.BK">Bắc Kạn</option>
							<option value="VN.BL">Bạc Liêu</option>
							<option value="VN.BN">Bắc Ninh</option>
							<option value="VN.BR">Bến Tre</option>
							<option value="VN.BD">Bình Định</option>
							<option value="VN.BI">Bình Dương</option>
							<option value="VN.BP">Bình Phước</option>
							<option value="VN.BU">Bình Thuận</option>
							<option value="VN.CM">Cà Mau</option>
							<option value="VN.CN">Cần Thơ</option>
							<option value="VN.CB">Cao Bằng</option>
							<option value="VN.DA">Đà Nẵng</option>
							<option value="VN.DC">Đắk Lắk</option>
							<option value="VN.DO">Đắk Nông</option>
							<option value="VN.DB">Điện Biên</option>
							<option value="VN.DN">Đồng Nai</option>
							<option value="VN.DT">Đồng Tháp</option>
							<option value="VN.GL">Gia Lai</option>
							<option value="VN.HG">Hà Giang</option>
							<option value="VN.HM">Hà Nam</option>
							<option value="VN.HI">Hà Nội</option>
							<option value="VN.HT">Hà Tĩnh</option>
							<option value="VN.HD">Hải Dương</option>
							<option value="VN.HP">Hải Phòng</option>
							<option value="VN.HU">Hậu Giang</option>
							<option value="VN.HC">Hồ Chí Minh</option>
							<option value="VN.HO">Hòa Bình</option>
							<option value="VN.HY">Hưng Yên</option>
							<option value="VN.KH">Khánh Hòa</option>
							<option value="VN.KG">Kiên Giang</option>
							<option value="VN.KT">Kon Tum</option>
							<option value="VN.LI">Lai Châu</option>
							<option value="VN.LD">Lâm Đồng</option>
							<option value="VN.LS">Lạng Sơn</option>
							<option value="VN.LO">Lào Cai</option>
							<option value="VN.LA">Long An</option>
							<option value="VN.ND">Nam Định</option>
							<option value="VN.NA">Nghệ An</option>
							<option value="VN.NB">Ninh Bình</option>
							<option value="VN.NT">Ninh Thuận</option>
							<option value="VN.PT">Phú Thọ</option>
							<option value="VN.PY">Phú Yên</option>
							<option value="VN.QB">Quảng Bình</option>
							<option value="VN.QM">Quảng Nam </option>
							<option value="VN.QG">Quảng Ngãi</option>
							<option value="VN.QN">Quảng Ninh</option>
							<option value="VN.QT">Quảng Trị</option>
							<option value="VN.ST">Sóc Trăng</option>
							<option value="VN.SL">Sơn La</option>
							<option value="VN.TN">Tây Ninh</option>
							<option value="VN.TB">Thái Bình</option>
							<option value="VN.TY">Thái Nguyên</option>
							<option value="VN.TH">Thanh Hóa</option>
							<option value="VN.TT">Thừa Thiên-Huế</option>
							<option value="VN.TG">Tiền Giang</option>
							<option value="VN.TV">Trà Vinh</option>
							<option value="VN.TQ">Tuyên Quang</option>
							<option value="VN.VL">Vĩnh Long</option>
							<option value="VN.VC">Vĩnh Phúc</option>
							<option value="VN.YB">Yên Bái</option>
						</select>
					</div>
					<div class="col-xs-6">
						<label>Postal Code</label>
						<input type="text" name="postal" class="form-control" placeholder="Postal Code" ng-model="page.demo.address.postal"/>
					</div>
					<div class="col-xs-6">
						<label>Country</label>
						<select name="country" class="form-control" ng-model="page.demo.countryOfOrigin">
							<option value="CVNA">Vietnam</option>
							<option value="LA">Laos</option>
							<option value="TH">Thailand</option>
							<option value="KH">Cambodia</option>
							<option value="CN">China</option>
						</select>
					</div>
		</div>
		
	
	<div class="form-group">

				
				
				<div class="col-xs-6">
					<label>Home Phone</label>
					<input type="text" name="home-phone" class="phone form-control" placeholder="Home Phone" ng-model="page.demo.phone"/>
				</div>
				<div class="col-xs-6">
					<label>Mobile Phone</label>
					<input type="text" name="work-phone" class="phone form-control" placeholder="Mobile Phone" ng-model="page.demo.alternativePhone"/>
				</div>
				<div class="col-xs-6">
					<label>Email</label>
					<input type="text" name="email" class="form-control" placeholder="Email" ng-model="page.demo.email"/>
				</div>

				

	</div>
	</fieldset>
	
	<fieldset>
		<legend>Other Information</legend>
		<div class="form-group">
			<div class="col-xs-6">
				<label>Admission Date</label>
				<input type="text" class="form-control" placeholder="DD/MM/YYYY" ng-model="page.demo.dateJoined"/>
			</div>
			<div class="col-xs-6">
				<label>ID Card Number</label>
				<input type="text" class="form-control" placeholder="ID Card Number" ng-model="page.demo.hin"/>
			</div>
			<div class="col-xs-6">
				<label>Issued Date</label>
				<input type="text" class="form-control" placeholder="DD/MM/YYYY" ng-model="page.demo.effDate"/>
			</div>
			<div class="col-xs-6">
				<label>Issuing Agency</label>
				<input type="text" ng-model="page.extras.issuing_agency" class="form-control" placeholder="Issuing Agency"/>
			</div>
			<div class="col-xs-6">
				<label>Marital Status</label>
				<select ng-model="page.extras.marital_status" class="form-control">
					<option value="Single">Single</option>
					<option value="Married">Married</option>
				</select>
			</div>
			<div class="col-xs-6">
				<label> No. of Children</label>
				<select ng-model="page.extras.children" class="form-control">
					<option value="0">0</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="3+">3+</option>
				</select>
			</div>
			<div class="col-xs-6">
				<label>Employment</label>
				<select ng-model="page.extras.employment" class="form-control">
					<option value="">--</option>
					<option value="Employed">Employed</option>
					<option value="Unemployed">Unemployed</option>
					<option value="Disabled">Disabled</option>
					<option value="Student">Student</option>
				</select>
			</div>
			<div class="col-xs-6">
				<label>Financial Status</label>
				<input type="text" ng-model="page.extras.financial_status" class="form-control" placeholder="Monthly Income in VND"/>
			</div>
			<div class="col-xs-6">
				<label>Education Level</label>
				<select ng-model="page.extras.education" class="form-control">
					<option value="Primary (1-5)">Primary (1-5)</option>
					<option value="Secondary (6-9)">Secondary (6-9)</option>
					<option value="High School (10-12)" selected>High School (10-12)</option>
					<option value="Technical School">Technical School</option>
					<option value="University">University</option>
					<option value="Post-Graduate">Post-Graduate</option>
				</select>
			</div>
			<div class="col-xs-6">
				<label>Ethnicity</label>
				<select ng-model="page.extras.ethnicity" class="form-control">
					<option value="Kinh">Kinh</option>
					<option value="">----------------------</option>
					<option value="Hmong">Hmong</option>
					<option value="Hoa">Hoa</option>
					<option value="Khmer Krom">Khmer Krom</option>
					<option value="Mường">Mường</option>
					<option value="Nùng">Nùng</option>
					<option value="Tay">Tay</option>
					<option value="">----------------------</option>
					<option value="Other">Other</option>
				</select>
			</div>
		</div>
	</fieldset>
</div>

<div class="col-lg-4">
	<div class="clearfix">
	<img class="pull-left" id="photo" ng-click="launchPhoto()" src="<%=request.getContextPath() %>/imageRenderingServlet?source=local_client&clientId={{page.demo.demographicNo}}"/>
	<address class="pull-left" style="margin-left:5px;">
  		<strong>{{page.demo.lastName}}, {{page.demo.firstName}}</strong><br>
  		{{page.demo.address.address}}<br>
  		{{page.demo.address.city}}, {{page.province}} {{page.demo.address.postal}}<br>
  		<abbr title="Phone">P:</abbr> {{page.demo.phone}}
	</address>
	<br  />
</div>
<div>
	<fieldset >
		<legend>Alerts</legend>
		<textarea ng-model="page.demo.alert" class="form-control" rows="3" style="color: red;"></textarea>
	</fieldset>

	<fieldset>
		<legend>Notes</legend>
		<textarea ng-model="page.notes" class="form-control" rows="3" ></textarea>
	</fieldset>
	<br/>
	
	<fieldset>
		<legend>Contacts</legend>
		<div class="form-group" ng-repeat="dcc in page.demo.demoContactAndContacts">
			<div>
				<select ng-model="dcc.demoContact.role" class="form-control" style="width: 110px; display: inline-block;">
					<option value="">Relation:</option>
					<option value="Father">Father</option>
					<option value="Mother">Mother</option>
					<option value="Husband">Husband</option>
					<option value="Wife">Wife</option>
					<option value="Son">Son</option>
					<option value="Daughter">Daughter</option>
					<option value="Brother">Brother</option>
					<option value="Sister">Sister</option>
					<option value="Other">Other</option>
				</select>
				<input type="text" ng-model="dcc.contact.lastName" placeholder="Family Name" class="form-control" style="width: 100px; display: inline-block;"/>
				<input type="text" ng-model="dcc.contact.firstName" placeholder="First Name" class="form-control" style="width: 100px; display: inline-block;"/>
				<input type="text" ng-model="dcc.contact.residencePhone" placeholder="Phone" class="form-control" style="width: 120px; display: inline-block;"/>
			</div>
			<div>
				<input type="text" ng-model="dcc.contact.address" placeholder="Address" class="form-control" style="width: 300px; display: inline-block;"/>
				<input type="text" ng-model="dcc.contact.city" placeholder="City" class="form-control" style="width: 130px; display: inline-block;"/>
			</div>
		</div>
		<div class="form-group">
			<label>Add New</label>
			<div>
				<select ng-model="page.contact.role" class="form-control" style="width: 110px; display: inline-block;">
					<option value="">Relation:</option>
					<option value="Father">Father</option>
					<option value="Mother">Mother</option>
					<option value="Husband">Husband</option>
					<option value="Wife">Wife</option>
					<option value="Son">Son</option>
					<option value="Daughter">Daughter</option>
					<option value="Brother">Brother</option>
					<option value="Sister">Sister</option>
					<option value="Other">Other</option>
				</select>
				<input type="text" ng-model="page.contact.lastName" placeholder="Family Name" class="form-control" style="width: 100px; display: inline-block;"/>
				<input type="text" ng-model="page.contact.firstName" placeholder="First Name" class="form-control" style="width: 100px; display: inline-block;"/>
				<input type="text" ng-model="page.contact.residencePhone" placeholder="Phone" class="form-control" style="width: 120px; display: inline-block;"/>
			</div>
			<div>
				<input type="text" ng-model="page.contact.address" placeholder="Address" class="form-control" style="width: 300px; display: inline-block;"/>
				<input type="text" ng-model="page.contact.city" placeholder="City" class="form-control" style="width: 130px; display: inline-block;"/>
			</div>
		</div>
	</fieldset>

<!-- 
	<fieldset>
		<legend>Professional Contacts</legend>
		<h5 ng-repeat="contact in page.professionalContacts">{{contact.name}}<small>({{contact.profession}})</small><span class="pull-right">{{contact.phone}}</span></h5>
	</fieldset>
 -->
	</div>
</div>
