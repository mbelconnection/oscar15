oscarApp.controller('PatientSearchCtrl', function ($scope,$http,$resource) {

	$scope.formData = {'active':1};
	
	$scope.reset = function() {
		$scope.formData = {'active':1};
		$scope.searchResults=null;
	}
	
	$scope.performSearch = function() {
		$scope.searchResults=null;
		
		var demographicWS = $resource('../ws/rs/demographics/advancedSearch',
				{searchQuery: "@search"},{advancedSearch: 
				{method:'POST', params:{searchQuery:$scope.formData}, isArray:false}
		});
		
		demographicWS.advancedSearch({}, {searchBean: $scope.formData}, function(response) {
			
			if(response.items == undefined) {
				return;
			}
			
			if (response.items instanceof Array) {
				$scope.searchResults = response.items;
			} else {
				var arr = new Array();
				arr[0] = response.items;
				$scope.searchResults = arr;
			}
			
		});

	};
});
