oscarApp.controller('PatientCtrl', function ($scope,$http,$routeParams,$resource) {
	$scope.genders = [{value: "M", name: "Male"}, {value: "F", name: "Female"}, {value: "T", name: "Transgender"}, {value: "U", name: "Unknown"}];
	$scope.languages = [{value: 'English', name: 'English'}, {value: 'French', name: 'French'}];
	$scope.spokens= [{value: 'English', name: 'English'}, {value: 'French', name: 'French'}];
	$scope.newsletters= [{value: 'Unknown', name: 'Unknown'}, 
	                     {value: 'No', name: 'No'}, 
	                     {value: 'Paper', name: 'Paper'}, 
	                     {value: 'Electronic', name: 'Electronic'}];
	$scope.aboriginals= [{value: 'Unknown', name: 'Unknown'}, 
	                     {value: 'No', name: 'No'}, 
	                     {value: 'Yes', name: 'Yes'}];
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
	$scope.ethnicities = [{value: '-1', name: 'Not Set'}, 
	                      {value: '1', name: 'Status On-reserve'}, 
	                      {value: '2', name: 'Status Off-reserve'}, 
	                      {value: '3', name: 'Non-status on-reserve'},
	                      {value: '4', name: 'Non-status off-reserve'},
	                      {value: '5', name: 'Metis'}, 
	                      {value: '6', name: 'Inuit'}, 
	                      {value: '7', name: 'Asian'}, 
	                      {value: '8', name: 'Caucasian'},
	                      {value: '9', name: 'Hispanic'},
	                      {value: '10', name: 'Black'},
	                      {value: '11', name: 'Other'}];	
	$scope.areas = [{value:'-1', name:'Not Set'},
					{value:'1' , name:'CHA1'},
					{value:'2' , name:'CHA2'},
					{value:'3' , name:'CHA3'},
					{value:'4' , name:'CHA4'},
					{value:'5' , name:'CHA5'},
					{value:'6' , name:'CHA6'},
					{value:'7' , name:'Richmond'},
					{value:'8' , name:'North or West Vancouver'},
					{value:'9' , name:'Surrey'},
					{value:'10', name:'On-Reserve'},
					{value:'14', name:'Off-Reserve'},
					{value:'11', name:'Homeless'},
					{value:'12', name:'Out of Country Residents'},
					{value:'13', name:'Other'}];
	
	$scope.demographicNo = $routeParams.demographicNo;
	
	var countryCodeRes = $resource('../ws/rs/demographics/countries',{}, {});
	var countries = countryCodeRes.get({},function(response) {
		$scope.countries=response.countries;
	});
	
	//set the demographic in scope for all the sub tabs
	var demographic = $resource('../ws/rs/demographics/detail/:demographicNo',{}, {});
	var patient = demographic.get({demographicNo: $scope.demographicNo},function() {
		$scope.demographic=patient;	
		$scope.demographic.dateOfBirth = getDate($scope.demographic.dateOfBirth);
		$scope.demographic.effDate = getDate($scope.demographic.effDate);
		$scope.demographic.hcRenewDate = getDate($scope.demographic.hcRenewDate);
		$scope.demographic.rosterDate = getDate($scope.demographic.rosterDate);
		$scope.demographic.dateJoined = getDate($scope.demographic.dateJoined);
		$scope.demographic.endDate = getDate($scope.demographic.endDate);
		$scope.demographic.referralDoctor = getReferralDoctor($scope.demographic.familyDoctor);
		$scope.demographic.referralDoctorNo = getReferralDoctorNo($scope.demographic.familyDoctor);
		$scope.demographic.notes = getNotes($scope.demographic.notes);
	});
	
	var nextAppts = $resource('../ws/rs/schedule/nextAppointments/:demographicNo',{}, {});
	var x = nextAppts.get({demographicNo: $scope.demographicNo},function() {
		if(x.content !== undefined && x.content.appointment !== undefined) {
			$scope.nextAppointmentDay = x.content.appointment[0].appointmentDate;
			$scope.nextAppointmentTime = x.content.appointment[0].startTime;
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

function getDate(dateString) {
	if (dateString == null) {
		return '';
	}
	var date = new Date(dateString);
	var month = date.getMonth() + 1;
	var day = date.getDate();
	return date.getFullYear() + "-" + (month < 10 ? "0" + month : month) + "-" + (day < 10 ? "0" + day : day);
}

function getReferralDoctorNo(familyDoctor) {
	var begin = "<rdohip>".length;
	var end = familyDoctor.indexOf("</rdohip>");
	return familyDoctor.substr(begin, end - begin);
}

function getReferralDoctor(familyDoctor) {
	var begin = familyDoctor.indexOf("<rd>") + "<rd>".length;
	var end = familyDoctor.indexOf("</rd>");
	return familyDoctor.substr(begin, end - begin);
}

function getNotes(notes) {
	var begin = "<unotes>".length;
	var end = notes.indexOf("</unotes>");
	return notes.substr(begin, end - begin);
}