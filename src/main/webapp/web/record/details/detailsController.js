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
	
	//upload photo
	$scope.launchPhoto = function(){
		var url = "https://localhost:8081/oscar/casemgmt/uploadimage.jsp?demographicNo="+demo.demographicNo;
		window.open(url, "uploadWin", "width=500, height=300");
	}
	
	$scope.save = function(){
		demographicService.updateDemographic($scope.page.demo);
	}
});
