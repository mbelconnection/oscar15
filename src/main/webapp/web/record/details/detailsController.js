/*

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

*/
oscarApp.controller('DetailsCtrl', function ($scope,$http,$location,$stateParams,demographicService,demo,$state) {
	console.log("details ctrl ",$stateParams,$state,demo);
	
	$scope.page = {};
	$scope.page.demo = demo;
	$scope.page.contact = {};
	$scope.page.extras = {};

	//show dob
	var dob = demo.dateOfBirth.substring(0, demo.dateOfBirth.indexOf("T"));
	var dobpart = dob.split("-");
	$scope.page.birthdayYear = dobpart[0];
	$scope.page.birthdayMonth = dobpart[1];
	$scope.page.birthdayDay = dobpart[2];
	
	//calculate age
	var birthDate = new Date(dobpart[0], dobpart[1]-1, dobpart[2]);
	var todayDate = new Date();
	var diffInMonth = todayDate.getMonth() - birthDate.getMonth();
	var diffInDay = todayDate.getDate() - birthDate.getDate();
	
	var age = todayDate.getFullYear() - birthDate.getFullYear();
	if (diffInMonth<0 || (diffInMonth==0 && diffInDay<0)) {
		age -= 1;
	}
	$scope.page.age = age;
	
	//show admission date
	if (demo.dateJoined!=null && demo.dateJoined!="") {
		var date = demo.dateJoined.substring(0, demo.dateJoined.indexOf("T"));
		var datepart = date.split("-");
		demo.dateJoined = datepart[2] + "/" + datepart[1] + "/" + datepart[0];
	} 
	
	//show ID card issued date
	if (demo.effDate!=null && demo.effDate!="") {
		var date = demo.effDate.substring(0, demo.effDate.indexOf("T"));
		var datepart = date.split("-");
		demo.effDate = datepart[2] + "/" + datepart[1] + "/" + datepart[0];
	}
	
	//show vietnam province next to photo
	$scope.page.province = vnprovince[demo.address.province];
	
	//upload photo
	$scope.launchPhoto = function(){
		var url = "https://localhost:8081/oscar/casemgmt/uploadimage.jsp?demographicNo="+demo.demographicNo;
		window.open(url, "uploadWin", "width=500, height=300");
	}
	
	//show extras
	if (demo.extras!=null) { //no extras
		if (demo.extras.key!=null) { //only 1 extras
			showDemoExtras(demo.extras, $scope.page.extras);
		}
		else { //more than 1 extras
			for (var i in demo.extras) {
				showDemoExtras(demo.extras[i], $scope.page.extras);
			}
		}
	}
	if ($scope.page.extras.ethnicity==null) $scope.page.extras.ethnicity = "Kinh"; //default 
	
	$scope.save = function(){
		//format dob
		var dobYear = $scope.page.birthdayYear;
		var dobMonth = $scope.page.birthdayMonth;
		var dobDay = $scope.page.birthdayDay;
		if (dobYear!=null && dobMonth!=null && dobDay!=null && dobYear!="" && dobMonth!="" && dobDay!="") {
			demo.dateOfBirth = dobYear + "-" + dobMonth + "-" + dobDay;
		}
		
		//format admission date
		if (demo.dateJoined!=null && demo.dateJoined!="") {
			var admDate = demo.dateJoined.split("/");
			demo.dateJoined = admDate[2] + "-" + admDate[1] + "-" + admDate[0];
		}
		
		//format ID card issued date
		if (demo.effDate!=null && demo.effDate!="") {
			var issDate = demo.effDate.split("/");
			demo.effDate = issDate[2] + "-" + issDate[1] + "-" + issDate[0];
		}
		
		//save extras
		demo.extras = [];
		if ($scope.page.extras.issuing_agency!=null) {
			demo.extras.push({"key":"issuing_agency", "value":$scope.page.extras.issuing_agency});
		}
		if ($scope.page.extras.ethnicity!=null) {
			demo.extras.push({"key":"ethnicity", "value":$scope.page.extras.ethnicity});
		}
		if ($scope.page.extras.marital_status!=null) {
			demo.extras.push({"key":"marital_status", "value":$scope.page.extras.marital_status});
		}
		if ($scope.page.extras.children!=null) {
			demo.extras.push({"key":"children", "value":$scope.page.extras.children});
		}
		if ($scope.page.extras.employment!=null) {
			demo.extras.push({"key":"employment", "value":$scope.page.extras.employment});
		}
		if ($scope.page.extras.financial_status!=null) {
			demo.extras.push({"key":"financial_status", "value":$scope.page.extras.financial_status});
		}
		if ($scope.page.extras.education!=null) {
			demo.extras.push({"key":"education", "value":$scope.page.extras.education});
		}
		
		//save contacts
		if ($scope.page.contact!=null && $scope.page.contact.role!=null) {
			var dccList = demo.demoContactAndContacts;
			var newDcc = {};
			var newDemoContact = {};
			var newContact = {};

			newDcc.demoContact = newDemoContact;
			newDcc.contact = newContact;
			newDemoContact.role = $scope.page.contact.role;
			newDemoContact.type = 2; //external: for mmt_demo only
			newDemoContact.demographicNo = demo.demographicNo;
			
			alert(newDemoContact.role);

			newContact.lastName = $scope.page.contact.lastName;
			newContact.firstName = $scope.page.contact.firstName;
			newContact.residencePhone = $scope.page.contact.residencePhone;
			newContact.address = $scope.page.contact.address;
			newContact.city = $scope.page.contact.city;
			
			alert(newContact.firstName);
			
			dccList.push(newDcc);
		}
		demographicService.updateDemographic(demo);
	}
});

function showDemoExtras(demoExtra, pageExtras) {
	var key = demoExtra.key;
	var value = demoExtra.value;
	
	if (key=="issuing_agency") pageExtras.issuing_agency = value;
	else if (key=="ethnicity") pageExtras.ethnicity = value;
	else if (key=="marital_status") pageExtras.marital_status = value;
	else if (key=="children") pageExtras.children = value;
	else if (key=="employment") pageExtras.employment = value;
	else if (key=="financial_status") pageExtras.financial_status = value;
	else if (key=="education") pageExtras.education = value;
}

var vnprovince = [];
vnprovince["VN.AG"] = "An Giang";
vnprovince["VN.BV"] = "Bà Rịa-Vũng Tàu";
vnprovince["VN.BG"] = "Bắc Giang";
vnprovince["VN.BK"] = "Bắc Kạn";
vnprovince["VN.BL"] = "Bạc Liêu";
vnprovince["VN.BN"] = "Bắc Ninh";
vnprovince["VN.BR"] = "Bến Tre";
vnprovince["VN.BD"] = "Bình Định";
vnprovince["VN.BI"] = "Bình Dương";
vnprovince["VN.BP"] = "Bình Phước";
vnprovince["VN.BU"] = "Bình Thuận";
vnprovince["VN.CM"] = "Cà Mau";
vnprovince["VN.CN"] = "Cần Thơ";
vnprovince["VN.CB"] = "Cao Bằng";
vnprovince["VN.DA"] = "Đà Nẵng";
vnprovince["VN.DC"] = "Đắk Lắk";
vnprovince["VN.DO"] = "Đắk Nông";
vnprovince["VN.DB"] = "Điện Biên";
vnprovince["VN.DN"] = "Đồng Nai";
vnprovince["VN.DT"] = "Đồng Tháp";
vnprovince["VN.GL"] = "Gia Lai";
vnprovince["VN.HG"] = "Hà Giang";
vnprovince["VN.HM"] = "Hà Nam";
vnprovince["VN.HI"] = "Hà Nội";
vnprovince["VN.HT"] = "Hà Tĩnh";
vnprovince["VN.HD"] = "Hải Dương";
vnprovince["VN.HP"] = "Hải Phòng";
vnprovince["VN.HU"] = "Hậu Giang";
vnprovince["VN.HC"] = "Hồ Chí Minh";
vnprovince["VN.HO"] = "Hòa Bình";
vnprovince["VN.HY"] = "Hưng Yên";
vnprovince["VN.KH"] = "Khánh Hòa";
vnprovince["VN.KG"] = "Kiên Giang";
vnprovince["VN.KT"] = "Kon Tum";
vnprovince["VN.LI"] = "Lai Châu";
vnprovince["VN.LD"] = "Lâm Đồng";
vnprovince["VN.LS"] = "Lạng Sơn";
vnprovince["VN.LO"] = "Lào Cai";
vnprovince["VN.LA"] = "Long An";
vnprovince["VN.ND"] = "Nam Định";
vnprovince["VN.NA"] = "Nghệ An";
vnprovince["VN.NB"] = "Ninh Bình";
vnprovince["VN.NT"] = "Ninh Thuận";
vnprovince["VN.PT"] = "Phú Thọ";
vnprovince["VN.PY"] = "Phú Yên";
vnprovince["VN.QB"] = "Quảng Bình";
vnprovince["VN.QM"] = "Quảng Nam ";
vnprovince["VN.QG"] = "Quảng Ngãi";
vnprovince["VN.QN"] = "Quảng Ninh";
vnprovince["VN.QT"] = "Quảng Trị";
vnprovince["VN.ST"] = "Sóc Trăng";
vnprovince["VN.SL"] = "Sơn La";
vnprovince["VN.TN"] = "Tây Ninh";
vnprovince["VN.TB"] = "Thái Bình";
vnprovince["VN.TY"] = "Thái Nguyên";
vnprovince["VN.TH"] = "Thanh Hóa";
vnprovince["VN.TT"] = "Thừa Thiên-Huế";
vnprovince["VN.TG"] = "Tiền Giang";
vnprovince["VN.TV"] = "Trà Vinh";
vnprovince["VN.TQ"] = "Tuyên Quang";
vnprovince["VN.VL"] = "Vĩnh Long";
vnprovince["VN.VC"] = "Vĩnh Phúc";
vnprovince["VN.YB"] = "Yên Bái";
