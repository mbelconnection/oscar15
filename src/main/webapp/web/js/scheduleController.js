oscarApp.controller('ScheduleCtrl', function ($scope,$http,$rootScope) {
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
	
	//hide the patient list
	$("#left_pane").removeClass("col-md-2");
	$("#left_pane").hide();
	$("#right_pane").removeClass("col-md-10");
	$("#right_pane").addClass("col-md-12");
	
});
