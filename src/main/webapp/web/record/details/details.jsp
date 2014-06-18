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
<div class="col-lg-8">
	<button type="button" class="btn btn-primary" ng-click="save()">Save</button>

	<div class="btn-group">
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

	<style>
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
		#photo {
			height: 150px;
			width: auto;
			cursor: pointer;
		}
	</style>
	<div class="form-group well">
		<table>
		<tr>
			<td style="width: 400px;">
				<div>
					<label>Family Name</label>
					<input type="text" name="family-name" class="form-control" placeholder="Family Name" ng-model="page.demo.lastName"/>
				</div>
				<div>
					<label>First Name</label>
					<input type="text" name="first-name" class="form-control" placeholder="First Name" ng-model="page.demo.firstName"/>
				</div>
				<div>
					<label>Admission Date</label>
					<input name="admission-date" type="text" class="form-control datepicker" placeholder="DD/MM/YYYY" />
				</div>
			</td>
			<td style="width: 350px;">
				<div>
					<label>ID Card Number</label>
					<input type="text" name="id-card" class="form-control" placeholder="ID Card Number" />
				</div>
				<div>
					<label>Issued Date</label>
					<input type="text" name="issue-date" class="form-control datepicker" placeholder="DD/MM/YYYY" />
				</div>
				<div>
					<label>Issuing Agency</label>
					<input type="text" name="issuing-agency" class="form-control"/>
				</div>			
			</td>
			<td>
				
			</td>
		</tr>
		</table>
	</div>
	<fieldset>
		<legend>
			Patient Information
		</legend>
	</fieldset>
	<div class="form-group well">
		<table>
		<tr>
			<td style="width: 400px;">
				<div>
					<label>Date of Birth</label>
					<input id="birthdayDay" type="text" placeholder="DD" class="form-control" style="width: 30px;" ng-model="page.birthdayDay"/>
					<input id="birthdayMonth" type="text" placeholder="MM" class="form-control" style="width: 30px;" ng-model="page.birthdayMonth"/>
					<input id="birthdayYear" type="text"placeholder="YYYY" class="form-control" style="width: 50px;" ng-model="page.birthdayYear"/>
					Age: <input id="age" type="text" readOnly="readOnly" class="form-control" style="width: 40px;" ng-model="page.age"/>
				</div>
				<div>
					<label>Gender</label>
					<select name="sex" class="form-control" ng-model="page.demo.sex">
						<option value="M">Male</option>
						<option value="F">Female</option>
					</select>
				</div>
				<div>
					<label>Ethnicity</label>
					<select name="ethincity" class="form-control">
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
				<div>
					<label>Marital Status</label>
					<select name="marital-status" class="form-control">
						<option value="Single">Single</option>
						<option value="Married">Married</option>
					</select>
				</div>
				<div>
					<label> No. of Children</label>
					<select name="children" class="form-control">
						<option value="0">0</option>
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="3+">3+</option>
					</select>
				</div>
				<div>
					<label>Mobile Phone</label>
					<input type="text" name="cell-phone" class="phone form-control" placeholder="Mobile Phone" ng-model="page.demo.alternativePhone"/>
				</div>
				<div>
					<label>Home Phone</label>
					<input type="text" name="home-phone" class="phone form-control" placeholder="Home Phone" ng-model="page.demo.phone"/>
				</div>
				<div>
					<label>Email</label>
					<input type="text" name="email" class="form-control" placeholder="Email" ng-model="page.demo.email"/>
				</div>
			</td>
			<td>
				<div>
					<label>Address</label>
					<textarea name="address" placeholder="Address" class="form-control" ng-model="page.demo.address.address" style="width: 300px;"></textarea>
				</div>
				<div>
					<label>City</label>
					<input type="text" name="city" class="form-control" placeholder="City" ng-model="page.demo.address.city"/>
				</div>			
				<div>
					<label>Province</label>
					<select name="province" class="form-control">
						<option value="">--</option>
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
				<div>
					<label>Country</label>
					<select name="country" class="form-control" ng-model="page.demo.address.country">
						<option value="CVNA">Vietnam</option>
						<option value="LA">Laos</option>
						<option value="TH">Thailand</option>
						<option value="KH">Cambodia</option>
						<option value="CN">China</option>
					</select>
				</div>
				<div>
					<label>Employment</label>
					<select name="employment" class="form-control">
						<option value="">--</option>
						<option value="Employed">Employed</option>
						<option value="Unemployed">Unemployed</option>
						<option value="Disabled">Disabled</option>
						<option value="Student">Student</option>
					</select>
				</div>
				<div>
					<label>Financial Status</label>
					<input type="text" name="financial-status" class="form-control number" placeholder="Monthly Income in VND" />
				</div>
				<div>
					<label>Education Level</label>
					<select name="education" class="form-control">
						<option value="Primary (1-5)">Primary (1-5)</option>
						<option value="Secondary (6-9)">Secondary (6-9)</option>
						<option value="High School (10-12)" selected>High School (10-12)</option>
						<option value="Technical School">Technical School</option>
						<option value="University">University</option>
						<option value="Post-Graduate">Post-Graduate</option>
					</select>
				</div>
			</td>
		</tr>
		</table>
	</div>
	<fieldset>
		<legend>
			Emergency Contact Names
		</legend>
	</fieldset>
	<div class="form-group well">
		<table>
		<tr>
			<td>
				<label>Father</label>
				<input type="text" name="father" class="form-control" placeholder="Name" />
			</td>
			<td>
				<label>Address</label>
				<input type="text" name="father-address" class="form-control" placeholder="Street" />
				<label>&nbsp;</label>
				<input type="text" name="father-city" class="form-control" placeholder="City" />
			</td>
			<td>
				<label>Telephone</label>
				<input type="text" name="father" class="form-control" placeholder="Telephone" />
				<label>Phone Type</label>
				<select name="father-phone-type" class="form-control">
					<option value="0">Mobile</option>
					<option value="1">Home</option>
					<option value="2">Work</option>
				</select>
			</td>
		</tr>
		</table>
	</div>
</div>

<div class="col-lg-4">
	<img id="photo" src="<%=request.getContextPath() %>/imageRenderingServlet?source=local_client&clientId={{page.demo.demographicNo}}"/>
	<br/>

	<fieldset>
		<legend>Alerts</legend>
		<textarea class="form-control" rows="3" style="color: red; width: 300px;">{{page.alert}}</textarea>
	</fieldset>

	<fieldset>
		<legend>Notes</legend>
		<textarea class="form-control" rows="3" style="width: 300px;">{{page.notes}}</textarea>
	</fieldset>
	<br/>
	
	<fieldset>
		<legend>Contacts</legend>
		<ul class="list-group">
			<li class="list-group-item" ng-repeat="contact in page.contacts">{{contact.name}} <span class="pull-right">{{contact.relation}}</span></li>
		</ul>
	</fieldset>

	<fieldset>
		<legend>Professional Contacts</legend>
		<h5 ng-repeat="contact in page.professionalContacts">{{contact.name}}<small>({{contact.profession}})</small><span class="pull-right">{{contact.phone}}</span></h5>
	</fieldset>
</div>