oscarApp.controller('PatientCtrl', function ($scope,$http,$routeParams,$resource) {
	$scope.genders = [{value: "M", name: "Male"}, {value: "F", name: "Female"}, {value: "T", name: "Transgender"}, {value: "U", name: "Unknown"}];
	$scope.languages = [{value: 'English', name: 'English'}, {value: 'French', name: 'French'}];
	$scope.spokens= [{value: 'English', name: 'English'}, {value: 'French', name: 'French'}];
	$scope.newsletters= [{value: 'Unknown', name: 'Unknown'}, 
	                     {value: 'No', name: 'No'}, 
	                     {value: 'Paper', name: 'Paper'}, 
	                     {value: 'Electronic', name: 'Electronic'}];
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
	$scope.rosterStatus= [{value: 'RO', name: 'Rostered'}, 
	                      {value: 'NR', name: 'Not Rostered'}, 
	                      {value: 'TE', name: 'Terminated'}, 
	                      {value: 'FS', name: 'Fee for Service'}];
	$scope.patientStatus= [{value: 'AC', name: 'Active'}, 
	                       {value: 'IN', name: 'Inactive'}, 
	                       {value: 'DE', name: 'Deceased'}, 
	                       {value: 'MO', name: 'Moved'},
	                       {value: 'FI', name: 'Fired'}];
	
	$scope.demographicNo = $routeParams.demographicNo;
	
	var countryCodeRes = $resource('../ws/rs/demographics/countries',{}, {});
	var countries = countryCodeRes.get({},function(response) {
		$scope.countries=response.countries;
	});
	
	//set the demographic in scope for all the sub tabs
	var demographic = $resource('../ws/rs/demographics/detail/:demographicNo',{}, {});
	var patient = demographic.get({demographicNo: $scope.demographicNo},function() {
		$scope.demographic=patient;	
	});
	
	var nextAppts = $resource('../ws/rs/schedule/nextAppointments/:demographicNo',{}, {});
	var x = nextAppts.get({demographicNo: $scope.demographicNo},function() {
		if(x.content !== undefined && x.content.appointment !== undefined) {
			$scope.nextAppointmentDay = x.content.appointment[0].appointmentDate;
			$scope.nextAppointmentTime = x.content.appointment[0].startTime;
			//console.log(JSON.stringify(x.content.appointment[0]));
		}
	});
	
	//HARD CODED FOR NOW
	$scope.recordtabs =
	    [ {id: 0, name: 'Detail', url: 'partials/patient/details.jsp'}
	    , {id: 1, name: 'Summary', url: 'partials/patient/summary.jsp'}
	    , {id: 4, name: 'Trackers', url: 'partials/tracker.jsp'}
	    , {id: 9, name: 'MyOscar', url: 'partials/blank.jsp'}
	   ];
	$scope.currenttab = $scope.recordtabs[0];
	
	$scope.isActive = function(temp){
    	return temp === $scope.currenttab.id;
    }
	
	$scope.changeTab = function(temp){
    	$scope.currenttab = $scope.recordtabs[temp];
    }	 
	
	//display in years or months
	$scope.getAge = function(dateString) {
		console.log('getAge - ' + dateString);
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
	
	$scope.saveDemographic = function(form) {
		var demographicSave = $resource('../ws/rs/demographics',{demographicTo1: "@demographic"}, {
			post: {method:'POST'},
		    update: {method:'PUT'}
		});
		demographicSave.update({}, {demographicTo1: $scope.demographic}, function(response) {
			var result = response.result;
			if (result) {
				alert("Save demographic successfully!");
				window.location.reload();
			} else {
				alert(response.message);
			}
		});
	};	
	
});

