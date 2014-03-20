oscarApp.controller('DashboardCtrl', function ($scope,$http) {
	$scope.userFirstName='Marc';
	$scope.displayDate='December 6, 2013';
	
	$http({
	    url: '../ws/rs/tickler/mine?limit=6',
	    dataType: 'json',
	    method: 'GET',
	    headers: {
	        "Content-Type": "application/json"
	    }

	}).success(function(response){
		if (response.tickler instanceof Array) {
			$scope.ticklers = response.tickler;
		} else {
			var arr = new Array();
			arr[0] = response.tickler;
			$scope.ticklers = arr;
		}
		
	}).error(function(error){
	    $scope.error = error;
	});	
	
	
	$http({
	    url: '../ws/rs/messaging/unread?limit=6',
	    dataType: 'json',
	    method: 'GET',
	    headers: {
	        "Content-Type": "application/json"
	    }

	}).success(function(response){
		if (response.message instanceof Array) {
			$scope.messages = response.message;
		} else {
			var arr = new Array();
			arr[0] = response.message;
			$scope.messages = arr;
		}
	}).error(function(error){
	    $scope.error = error;
	});	
	
	
});
