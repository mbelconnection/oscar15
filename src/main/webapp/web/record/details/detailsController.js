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

	//show dob
	var dob = demo.dateOfBirth;
	dob = dob.substring(0, dob.indexOf("T"));
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
	
	//show vietnam province next to photo
	$scope.page.province = vnprovince[demo.address.province];
	
	//upload photo
	$scope.launchPhoto = function(){
		var url = "https://localhost:8081/oscar/casemgmt/uploadimage.jsp?demographicNo="+demo.demographicNo;
		window.open(url, "uploadWin", "width=500, height=300");
	}
	
	$scope.save = function(){
		updateExtras();
		demographicService.updateDemographic($scope.page.demo);
	}
});

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

