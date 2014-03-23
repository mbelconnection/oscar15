oscarApp.controller('ConsultDetailCtrl', function ($scope,$http,$routeParams,$resource) {
	// Datasource
	$scope.hours = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
	                12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
	$scope.minutes = [00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 
	                  10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
	                  20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 
	                  30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 
	                  40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 
	                  50, 51, 52, 53, 54, 55, 56, 57, 58, 59];
	$scope.ampms =  ['AM', 'PM'];
	$scope.titles = [{value: "DR", name: "DR"},
	                 {value: "MS", name: "MS"},
	                 {value: "MISS", name: "MISS"},
	                 {value: "MRS", name: "MRS"},
	                 {value: "MR", name: "MR"},
	                 {value: "MSSR", name: "MSSR"},
	                 {value: "PROF", name: "PROF"},
	                 {value: "REEVE", name: "REEVE"},
	                 {value: "REV", name: "REV"},
	                 {value: "RT_HON", name: "RT_HON"},
	                 {value: "SEN", name: "SEN"},
	                 {value: "SGT", name: "SGT"},
	                 {value: "SR", name: "SR"}];	
	$scope.genders = [{value: "M", name: "Male"}, {value: "F", name: "Female"}, {value: "U", name: "Unknown"}];
	$scope.provinces = [{value: 'AB', name: 'AB-Alberta'}, 
						{value: 'BC', name: 'BC-British Columbia'}, 
						{value: 'MB', name: 'MB-Manitoba'}, 
						{value: 'NB', name: 'NB-New Brunswick'}, 
						{value: 'NL', name: 'NL-Newfoundland Labrador'}, 
						{value: 'NT', name: 'NT-Northwest Territory'}, 
						{value: 'NS', name: 'NS-Nova Scotia'}, 
						{value: 'NU', name: 'NU-Nunavut'}, 
						{value: 'ON', name: 'ON-Ontario'}, 
						{value: 'PE', name: 'PE-Prince Edward Island'}, 
						{value: 'QC', name: 'QC-Quebec'}, 
						{value: 'SK', name: 'SK-Saskatchewan'}, 
						{value: 'YT', name: 'YT-Yukon'}, 
						{value: 'US', name: 'US resident'}, 
						{value: 'US-AK', name: 'US-AK-Alaska'}, 
						{value: 'US-AL', name: 'US-AL-Alabama'}, 
						{value: 'US-AR', name: 'US-AR-Arkansas'}, 
						{value: 'US-AZ', name: 'US-AZ-Arizona'}, 
						{value: 'US-CA', name: 'US-CA-California'}, 
						{value: 'US-CO', name: 'US-CO-Colorado'}, 
						{value: 'US-CT', name: 'US-CT-Connecticut'}, 
						{value: 'US-CZ', name: 'US-CZ-Canal Zone'}, 
						{value: 'US-DC', name: 'US-DC-District Of Columbia'}, 
						{value: 'US-DE', name: 'US-DE-Delaware'}, 
						{value: 'US-FL', name: 'US-FL-Florida'}, 
						{value: 'US-GA', name: 'US-GA-Georgia'}, 
						{value: 'US-GU', name: 'US-GU-Guam'}, 
						{value: 'US-HI', name: 'US-HI-Hawaii'}, 
						{value: 'US-IA', name: 'US-IA-Iowa'}, 
						{value: 'US-ID', name: 'US-ID-Idaho'}, 
						{value: 'US-IL', name: 'US-IL-Illinois'}, 
						{value: 'US-IN', name: 'US-IN-Indiana'}, 
						{value: 'US-KS', name: 'US-KS-Kansas'}, 
						{value: 'US-KY', name: 'US-KY-Kentucky'}, 
						{value: 'US-LA', name: 'US-LA-Louisiana'}, 
						{value: 'US-MA', name: 'US-MA-Massachusetts'}, 
						{value: 'US-MD', name: 'US-MD-Maryland'}, 
						{value: 'US-ME', name: 'US-ME-Maine'}, 
						{value: 'US-MI', name: 'US-MI-Michigan'}, 
						{value: 'US-MN', name: 'US-MN-Minnesota'}, 
						{value: 'US-MO', name: 'US-MO-Missouri'}, 
						{value: 'US-MS', name: 'US-MS-Mississippi'}, 
						{value: 'US-MT', name: 'US-MT-Montana'}, 
						{value: 'US-NC', name: 'US-NC-North Carolina'}, 
						{value: 'US-ND', name: 'US-ND-North Dakota'}, 
						{value: 'US-NE', name: 'US-NE-Nebraska'}, 
						{value: 'US-NH', name: 'US-NH-New Hampshire'}, 
						{value: 'US-NJ', name: 'US-NJ-New Jersey'}, 
						{value: 'US-NM', name: 'US-NM-New Mexico'}, 
						{value: 'US-NU', name: 'US-NU-Nunavut'}, 
						{value: 'US-NV', name: 'US-NV-Nevada'}, 
						{value: 'US-NY', name: 'US-NY-New York'}, 
						{value: 'US-OH', name: 'US-OH-Ohio'}, 
						{value: 'US-OK', name: 'US-OK-Oklahoma'}, 
						{value: 'US-OR', name: 'US-OR-Oregon'}, 
						{value: 'US-PA', name: 'US-PA-Pennsylvania'}, 
						{value: 'US-PR', name: 'US-PR-Puerto Rico'}, 
						{value: 'US-RI', name: 'US-RI-Rhode Island'}, 
						{value: 'US-SC', name: 'US-SC-South Carolina'}, 
						{value: 'US-SD', name: 'US-SD-South Dakota'}, 
						{value: 'US-TN', name: 'US-TN-Tennessee'}, 
						{value: 'US-TX', name: 'US-TX-Texas'}, 
						{value: 'US-UT', name: 'US-UT-Utah'}, 
						{value: 'US-VA', name: 'US-VA-Virginia'}, 
						{value: 'US-VI', name: 'US-VI-Virgin Islands'}, 
						{value: 'US-VT', name: 'US-VT-Vermont'}, 
						{value: 'US-WA', name: 'US-WA-Washington'}, 
						{value: 'US-WI', name: 'US-WI-Wisconsin'}, 
						{value: 'US-WV', name: 'US-WV-West Virginia'}, 
						{value: 'US-WY', name: 'US-WY-Wyoming'}];
	$scope.locations = [{value: 1, name: 'Dr. James Dean - 1158 StreetName St., Hamilton Ontario L0R 4K3'},
	                    {value: 2, name: 'Dr. James Dean - Hospital 50 StreetName St., Hamilton Ontario L8h 0X0'}];
	$scope.urgencies = [{value: 1, name: 'Urgent'}, {value: 2, name: 'Non-Urgent'}, {value: 3, name: 'Return'}, {value: 5, name: 'Semi-Urgent'}];
	$scope.status=[{value: 1, name: 'Nothing'}, {value: 2, name: 'Pending Specialist Callback'}, {value: 3, name: 'Pending Patient Callback'}, {value: 4, name: 'Completed'}];
	
	var requestId = getQueryStrings()['requestId'];
	var demographicNo = getQueryStrings()['demographicNo'];
	var providerNo = getQueryStrings()['providerNo'];
	
	if (requestId != null) {
		//set the demographic in scope for all the sub tabs
		var consultDetailWS = $resource('../../../ws/rs/consult/detail/:requestId',{}, {});
		var consult = consultDetailWS.get({requestId: requestId}, function(response) {
			$scope.consult = response;
			$scope.consult.appointmentDate = getDate($scope.consult.appointmentDate);
			$scope.consult.referralDate = getDate($scope.consult.referralDate);
			$scope.consult.followUpDate = getDate($scope.consult.followUpDate);
			$scope.consult.specialties = new Array();
			for (var i = 0; i < $scope.consult.services.length; i++) {
				if ($scope.consult.services[i].id == $scope.consult.serviceId) {
					$scope.consult.specialties.push($scope.consult.services[i].specialties);	
				}
			}
			for (var i = 0; i < $scope.consult.specialties.length; i++) {
				if ($scope.consult.specialties[i].id == $scope.consult.specialtyId) {
					$scope.consult.specialtyAddress = $scope.consult.specialties[i].address;
					$scope.consult.specialtyPhone = $scope.consult.specialties[i].phone;
					$scope.consult.specialtyFax = $scope.consult.specialties[i].fax;
				}
			}
			$scope.consult.appointmentHour = getHour($scope.consult.appointmentTime);
			$scope.consult.appointmentMinute = getMinute($scope.consult.appointmentTime);
			$scope.consult.providerNo = providerNo;
			
			// Demographic		
			demographicNo = response.demographicId;
			var demographicWS = $resource('../../../ws/rs/demographics/detail/:demographicNo',{}, {});
			var demographic = demographicWS.get({demographicNo: demographicNo}, function(response) {
				$scope.demographic = response;
				$scope.demographic.age = getAge($scope.demographic.dateOfBirth);
				$scope.demographic.dateOfBirth = getDate($scope.demographic.dateOfBirth);
			});
		});
	} else {
		var demographicWS = $resource('../../../ws/rs/demographics/detail/:demographicNo',{}, {});
		var demographic = demographicWS.get({demographicNo: demographicNo}, function(response) {
			$scope.demographic = response;
			$scope.demographic.age = getAge($scope.demographic.dateOfBirth);
			$scope.demographic.dateOfBirth = getDate($scope.demographic.dateOfBirth);
		});
		
		var consultDetailWS = $resource('../../../ws/rs/consult/detail/:requestId',{}, {});
		var consult = consultDetailWS.get({requestId: -1}, function(response) {
			$scope.consult = response;
			$scope.consult.appointmentDate = getDate(new Date());
			$scope.consult.providerNo = providerNo;
			$scope.consult.specialties = new Array();
			for (var i = 0; i < $scope.consult.services.length; i++) {
				if ($scope.consult.services[i].id == $scope.consult.serviceId) {
					$scope.consult.specialties.push($scope.consult.services[i].specialties);	
				}
			}
			for (var i = 0; i < $scope.consult.specialties.length; i++) {
				if ($scope.consult.specialties[i].id == $scope.consult.specialtyId) {
					$scope.consult.specialtyAddress = $scope.consult.specialties[i].address;
					$scope.consult.specialtyPhone = $scope.consult.specialties[i].phone;
					$scope.consult.specialtyFax = $scope.consult.specialties[i].fax;
				}
			}
		});
	}
	
	$scope.saveConsult = function(form,dialog) {
		if (!form.$valid) {
			alert("Please correct the invalid field(s).");
			return false;
		}
		var consultWS = $resource('../../../ws/rs/consult',{consultationRequestTo: "@consult"}, {});
		$scope.consult.demographic = $scope.demographic;
		$scope.consult.demographicId = $scope.demographic.demographicNo;
		$scope.consult.appointmentTime = new Date("1970", "01", "01", $scope.consult.appointmentHour, $scope.consult.appointmentMinute, "00");
		consultWS.save({}, {consultationRequestTo: $scope.consult}, function(response) {
			var result = response.result;
			if (result) {
				alert("Save consultation successfully!");
				window.opener.location.reload(false);
				window.close();
			} else {
				alert(response.message);
			}
		});
	};
	
	$scope.remove = function() {
		var consultDetailWS = $resource('../../../ws/rs/consult/delete/:requestId',{}, {});
		consultDetailWS.remove({requestId: $scope.consult.id}, function(response) {
			var result = response.result;
			if (result) {
				alert("Delete consultation successfully!");
				window.close();
			} else {
				alert(response.message);
			}
		});
	};
	
	$scope.changeLetterhead = function() {
		var letterheadName = consult.letterheadName;
		for (var i = 0; i < $scope.consult.letterheads.length; i++) {
			if ($scope.consult.letterheads[i].name == letterheadName) {
				$scope.consult.letterheadName = letterheadName;
				$scope.consult.letterheadAddress = $scope.consult.letterheads[i].address;
				$scope.consult.letterheadPhone = $scope.consult.letterheads[i].phone;
				$scope.consult.letterheadFax = $scope.consult.letterheads[i].ax;
			}
		}
	};
	
	$scope.changeService = function() {
		var selected = consult.serviceId;
		for (var i = 0; i < $scope.consult.services.length; i++) {
			if ($scope.consult.services[i].id == selected) {
				$scope.consult.specialties = new Array();
				if ($scope.consult.services[i].specialties != null) {
					$scope.consult.specialties.push($scope.consult.services[i].specialties);
				}
			}
		}
		$scope.consult.specialtyAddress = "";
		$scope.consult.specialtyPhone = "";
		$scope.consult.specialtyFax = "";
	}
	
	$scope.changeSpecialty = function() {
		var selected = consult.specialtyId;
		for (var i = 0; i < $scope.consult.specialties.length; i++) {
			if ($scope.consult.specialties[i].id == selected) {
				$scope.consult.specialtyAddress = $scope.consult.specialties[i].address;
				$scope.consult.specialtyPhone = $scope.consult.specialties[i].phone;
				$scope.consult.specialtyFax = $scope.consult.specialties[i].fax;
			}
		}
	}
});

function getAge(dateString) {
	var age;
	var today = new Date();
	var birthDate = new Date(dateString);
	age = today.getFullYear() - birthDate.getFullYear();
	var m = today.getMonth() - birthDate.getMonth();
	if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
		age--;
	}
	if(age < 2) {
		m = m + (age*12);
		return m + 'm';
	} else {
		return age + 'y';	
	}
}

function getDate(dateString) {
	var date = new Date(dateString);
	var month = date.getMonth() + 1;
	var day = date.getDate();
	return date.getFullYear() + "-" + (month < 10 ? "0" + month : month) + "-" + (day < 10 ? "0" + day : day);
}

function getHour(dateString) {
	var date = new Date(dateString);
	return date.getHours();
}

function getMinute(dateString) {
	var date = new Date(dateString);
	return date.getMinutes();
}


function getQueryStrings() {
    //Holds key:value pairs
    var queryStringColl = null;            
    //Get querystring from url
    var requestUrl = window.location.search.toString();
    if (requestUrl != '') {
        //window.location.search returns the part of the URL 
        //that follows the ? symbol, including the ? symbol
        requestUrl = requestUrl.substring(1);
        queryStringColl = new Array();
        //Get key:value pairs from querystring
        var kvPairs = requestUrl.split('&');
        for (var i = 0; i < kvPairs.length; i++) {
            var kvPair = kvPairs[i].split('=');
            queryStringColl[kvPair[0]] = kvPair[1];
        }
    }
    return queryStringColl;
}