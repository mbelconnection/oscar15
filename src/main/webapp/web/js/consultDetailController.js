oscarApp.controller('ConsultDetailCtrl', function ($scope,$http,$routeParams,$resource) {
	// Datasource
	$scope.letterheaderSource = ["McMaster Hospital","Wilson, John","Someother, Guy"];
	$scope.specialtySource = ["McMaster Hospital","Wilson, John","Someother, Guy"];
	$scope.locations = [{value: 1, name: 'Dr. James Dean - 1158 StreetName St., Hamilton Ontario L0R 4K3'},
	                    {value: 2, name: 'Dr. James Dean - Hospital 50 StreetName St., Hamilton Ontario L8h 0X0'}]
	// Dropdowns
	$scope.specialties = [{value: 0, name: 'Specialty'}, {value: 1, name: 'Cardiology'}, {value: 2, name: 'Dermatology'}, {value: 3, name: 'Neurology'}, {value: 4, name: 'Radiology'}];
	$scope.urgencies = [{value: 1, name: 'Urgent'}, {value: 2, name: 'Non-Urgent'}, {value: 3, name: 'Return'}, {value: 5, name: 'Semi-Urgent'}];
	$scope.hours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
	$scope.minutes = [00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 
	                  10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
	                  20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 
	                  30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 
	                  40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 
	                  50, 51, 52, 53, 54, 55, 56, 57, 58, 59];
	$scope.ampms =  ['AM', 'PM'];
	$scope.titles = ["Mr.", "Mrs.", "Ms.", "Dr."];
	$scope.genders = ["Male", "Female", "Unknown"];
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
	$http({
	    url: '../../json/consultDetail.json',
	    dataType: 'json',
	    method: 'GET',
	    headers: {
	        "Content-Type": "application/json"
	    }
	}).success(function(response) {
		$scope.patient = response.patient;
		$scope.consult = response.consult;
	}).error(function(error){
	    $scope.error = error;
	});	
});