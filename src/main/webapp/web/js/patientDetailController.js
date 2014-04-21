oscarApp.controller('PatientDetailCtrl', function ($scope,$http,$routeParams,$resource) {
	$scope.demographicNo = $routeParams.chartId;
	
	console.log('detail controller');
	
	$scope.titles = ['Mr.','Mrs.'];
	
	$scope.genders = [{value: "M", name: "Male"}, {value: "F", name: "Female"}, {value: "T", name: "Transgender"}, {value: "U", name: "Unknown"}];
	
	$scope.languages = ['English','French'];

});

