oscarApp.controller('ConsultListCtrl', function ($scope,$http,$resource) {
	$scope.init = function(value) {
		$scope.providerNo = value;
		var demographicWS = $resource('../ws/rs/demographics/list/:providerNo',{}, {});
		var demographic = demographicWS.get({providerNo: $scope.providerNo}, function(response) {
			$scope.demographics = response.demographics;
		});
	}
});
