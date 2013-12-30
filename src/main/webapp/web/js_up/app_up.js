//'use strict';

/* App Module */

//var app = angular.module('oscarProviderViewModule', [ ]);

oscarApp.controller('MainSchedulerCtrl', function($scope) {
  $scope.events = [
    { id:1, text:"Schedule 1 in Jan",
      start_date: new Date(2014, 0, 7),
      end_date: new Date(2014, 0, 9) },
    { id:2, text:"Schedule 2 in Jan",
      start_date: new Date(2014, 0, 13 ),
      end_date: new Date(2014, 0, 15 ) }
  ];

  $scope.scheduler = { date : new Date(2014,0,7) };

});