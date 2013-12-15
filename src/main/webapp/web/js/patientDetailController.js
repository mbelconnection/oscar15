oscarApp.controller('PatientDetailCtrl', function ($scope,$http,$routeParams,$resource) {
	$scope.demographicNo = $routeParams.chartId;
	
	console.log('detail controller');
	
	$scope.titles = ['Mr.','Mrs.'];
	
	$scope.genders = ['Male','Female','Transgender','Unknown'];
	
	$scope.languages = ['English','French'];

});

