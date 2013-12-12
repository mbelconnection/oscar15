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
	                    when('/schedule', {
		                    templateUrl: 'partials/schedule.jsp',
		                    controller: 'ScheduleCtrl'
	                    }).
	                    when('/consults', {
		                    templateUrl: 'partials/consultList.jsp',
		                    controller: 'ConsultListCtrl'
	                    }).
	                    when('/billing', {
		                    templateUrl: 'partials/billing.jsp',
		                    controller: 'BillingCtrl'
	                    }).
	                    when('/ticklers', {
		                    templateUrl: 'partials/ticklerList.jsp',
		                    controller: 'TicklerListCtrl'
	                    }).
	                    when('/patient/:id', {
		                    templateUrl: 'partials/patient/index.jsp',
		                    controller: 'PatientDetailCtrl'
	                    }).
	                    when('/report', {
		                    templateUrl: 'partials/report.html',
		                    controller: 'ReportCtrl'
	                    }).
	                    when('/settings', {
		                    templateUrl: 'partials/settings.jsp',
		                    controller: 'SettingsCtrl'
	                    }).
	                    when('/support', {
		                    templateUrl: 'partials/support.jsp',
		                    controller: 'SupportCtrl'
	                    }).
	                    when('/help', {
		                    templateUrl: 'partials/help.jsp',
		                    controller: 'HelpCtrl'
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
