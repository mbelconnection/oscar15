

oscarApp.controller('NavBarCtrl', function ($scope,$http,$location) {
	
	//load static models from web to inject 
	$http({
	    url: 'json/navBar.json',
	    dataType: 'json',
	    method: 'GET',
	    headers: {
	        "Content-Type": "application/json"
	    }

	}).success(function(response){
		$scope.userName = response.userName;
	    $scope.menuItems = response.menuItems;
	    $scope.moreMenuItems = response.moreMenuItems;
	    $scope.currentProgram = response.currentProgram;
	    $scope.counts = response.counts;
	    $scope.demographicSearchDropDownItems = response.demographicSearchDropDownItems;
	    $scope.programInfo = response.programInfo;
	    $scope.userMenuItems = response.userMenuItems;
	}).error(function(error){
	    $scope.error = error;
	});	
	
	//to help ng-clicks on buttons
	$scope.go = function ( path ) {
		$location.path( path );
	};
	
	$scope.isActive = function(temp){
		if($scope.currenttab === undefined || $scope.currenttab === null) {
			return false;
		}
		return temp === $scope.currenttab.id;
	}

	$scope.isMoreActive = function(temp){
		if($scope.currenttab === undefined || $scope.currenttab === null) {
			return false;
		}
		if($scope.currentmoretab=== null) {
			return false;
		}
		return temp === $scope.currentmoretab.id;
	}

	$scope.changeMoreTab = function(temp){
		console.log('changeMoreTab');
		var beforeChangeTab = $scope.currentmoretab;
		$scope.currentmoretab = $scope.moreMenuItems[temp];
		$scope.currenttab = null;
		//$location.path($scope.currentmoretab.url);
	}

	$scope.changeTab = function(temp){
		console.log("changetab "+ temp);
		$scope.currenttab = $scope.menuItems[temp];
		$scope.currentmoretab=null;
		//$location.path($scope.currenttab.url);
	}	 

	$scope.getMoreTabClass = function(id){ 
		if($scope.currentmoretab != null && id == $scope.currentmoretab.id) {
			return "more-tab-highlight";
		}
		return "";
	}
	
	$scope.goHome = function() {
		$scope.currenttab = null;
		$scope.currentmoretab = null;
		$location.path('#/inbox').replace();
	}
	
});
