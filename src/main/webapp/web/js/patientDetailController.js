oscarApp.controller('PatientDetailCtrl', function ($scope,$http) {
	
	//load static models from web to inject 
	$http({
	    url: 'json/details.json',
	    dataType: 'json',
	    method: 'GET',
	    headers: {
	        "Content-Type": "application/json"
	    }

	}).success(function(response){
		$scope.demographic = response.demographic;
	    $scope.demographicNo = response.demographicNo;
	}).error(function(error){
	    $scope.error = error;
	});	
	
	//HARD CODED FOR NOW
	$scope.recordtabs =
	    [ {id: 0, name: 'Detail', url: 'partials/master.jsp'}
	    , {id: 1, name: 'Summary', url: 'partials/summary.html'}
	    , {id: 4, name: 'Trackers', url: 'partials/tracker.jsp'}
	    , {id: 9, name: 'MyOscar', url: 'partials/blank.jsp'}
	   ];
	$scope.currenttab = $scope.recordtabs[0];
	
	$scope.isActive = function(temp){
    	//console.log(temp+" === "+$scope.recordtabs.index+"  == "+ (temp === $scope.currenttab)  );
    	return temp === $scope.currenttab.id;
    }
	
	$scope.changeTab = function(temp){
    	console.log("tepm "+ temp);
    	$scope.currenttab = $scope.recordtabs[temp];
    }	 
	
});

