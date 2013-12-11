oscarApp.controller('ScheduleCtrl', function ($scope,$http) {
	//load static models from web to inject 
	$http({
	    url: 'json/schedule.json',
	    dataType: 'json',
	    method: 'GET',
	    headers: {
	        "Content-Type": "application/json"
	    }

	}).success(function(response){
		$scope.title = response.title;
	   
	}).error(function(error){
	    $scope.error = error;
	});	
	
});
