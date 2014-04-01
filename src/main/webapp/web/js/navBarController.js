

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
		$scope.demographicSearchDropDownItems = response.demographicSearchDropDownItems;
		$scope.menuItems = response.menuItems;
	    $scope.moreMenuItems = response.moreMenuItems;
	    $scope.userMenuItems = response.userMenuItems;
	}).error(function(error){
	    $scope.error = error;
	});	
	
	//from service
	$http({
	    url: '../ws/rs/persona/navbar',
	    dataType: 'json',
	    method: 'GET',
	    headers: {
	        "Content-Type": "application/json"
	    }

	}).success(function(response){
		$scope.currentProgram = response.currentProgram.program;
		if (response.programDomain.program instanceof Array) {
			$scope.programDomain = response.programDomain.program;
		} else {
			var arr = new Array();
			arr[0] = response.programDomain.program;
			$scope.programDomain = arr;
		}
		$scope.unreadMessagesCount = response.unreadMessagesCount;
		$scope.unreadPatientMessagesCount = response.unreadPatientMessagesCount;
		
	}).error(function(error){
	    $scope.error = error;
	});	
	
	
	//reload the navbar at any time..not sure why i can't call this form the controller.
	$scope.getNavbar = function () {
		$http({
		    url: '../ws/rs/persona/navbar',
		    dataType: 'json',
		    method: 'GET',
		    headers: {
		        "Content-Type": "application/json"
		    }

		}).success(function(response){
			$scope.currentProgram = response.currentProgram.program;
			if (response.programDomain.program instanceof Array) {
				$scope.programDomain = response.programDomain.program;
			} else {
				var arr = new Array();
				arr[0] = response.programDomain.program;
				$scope.programDomain = arr;
			}
			$scope.unreadMessagesCount = response.unreadMessagesCount;
			$scope.unreadPatientMessagesCount = response.unreadPatientMessagesCount;
		}).error(function(error){
		    $scope.error = error;
		});	
	}
	
	
	
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
		$(".ui-dialog-content").dialog("close"); /* Added by Schedular team */
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
		$window.location.href="index.jsp#/dashboard";
		$window.location.reload();
	}
	
	$scope.goToPatientSearch = function() {
		$scope.currenttab = null;
		$scope.currentmoretab = null;
		$window.location.href="index.jsp#/search";
		$window.location.reload();
	}
	
	$scope.changeProgram = function(temp){
		console.log("changeprogram "+ temp);
		
		$http({
		    url: '../ws/rs/program/setDefaultProgramInDomain?programId='+temp,
		    dataType: 'json',
		    method: 'GET',
		    headers: {
		        "Content-Type": "application/json"
		    }

		}).success(function(response){
			$scope.getNavbar();
		}).error(function(error){
		    $scope.error = error;
		});	
		
		//TODO: need an action called or something to update the session variable on the old oscar side
		
	}	 
	
});
