oscarApp.controller('PatientCtrl', function ($scope,$http,$routeParams,$resource) {
	$scope.demographicNo = $routeParams.demographicNo;

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
	
});

