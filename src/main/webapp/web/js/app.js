var oscarApp = angular.module('oscarProviderViewModule', ['ngRoute']);

oscarApp.config(['$routeProvider',
                    function($routeProvider) {
                    	$routeProvider.when('/dashboard', {
		                    templateUrl: 'partials/dashboard.html',
		                    controller: 'DashboardCtrl'
		                }).
	                    when('/inbox', {
		                    templateUrl: 'partials/inbox.html',
		                    controller: 'InboxCtrl'
	                    }).
	                    when('/report', {
		                    templateUrl: 'partials/report.html',
		                    controller: 'ReportCtrl'
	                    }).
	                    otherwise({
	                    	redirectTo: '/dashboard'
	                    });
                    }
]);





//for dev - just to keep the cache clear
oscarApp.run(function($rootScope, $templateCache) {
	   $rootScope.$on('$viewContentLoaded', function() {
	      $templateCache.removeAll();
	   });
	});


oscarApp.run( function($rootScope, $location) {

   // register listener to watch route changes
   $rootScope.$on( "$routeChangeStart", function(event, next, current) {
	   console.log(JSON.stringify(next, null, 4));
   });
});
