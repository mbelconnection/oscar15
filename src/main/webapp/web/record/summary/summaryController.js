/*

    Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
    This software is published under the GPL GNU General Public License.
    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

    This software was written for the
    Department of Family Medicine
    McMaster University
    Hamilton
    Ontario, Canada

*/
oscarApp.controller('SummaryCtrl', function ($scope,$http,$location,$stateParams,$state,summaryService,noteService) {
	console.log("in summary Ctrl ",$stateParams);
	
	$scope.page = {};
	$scope.page.columnOne = {};
	$scope.page.columnOne.modules = {};
	$scope.page.notes = {};
	
	function getLeftItems(){
		summaryService.left($stateParams.demographicNo).then(function(data){
			  console.log("left",data);
			  //console.log($scope.page.columnOne);
			  //console.log($scope.page.columnOne.modules);
		      $scope.page.columnOne.modules = data;
		      fillItems($scope.page.columnOne.modules);
	    	},
	    	function(errorMessage){
		       console.log("left"+errorMessage);
		       $scope.error=errorMessage;
	    	}
		);
    };
		 
    getLeftItems();
    
    noteService.getAllNotes($stateParams.demographicNo).then(function(data) {
        console.debug('whats the data',data);
        $scope.page.notes = data;
        if(data.notelist instanceof Array){
			console.log("ok its in an array");
        }else{
			$scope.page.notes.notelist = [data.notelist];
		}
    },
	function(errorMessage){
	       console.log("notes:"+errorMessage);
	       $scope.error=errorMessage;
 	}
    );
    
    
    $scope.setColor = function(note){
    	//console.log("note",note.eformData)
    	if(note.eformData){
    		return { 'background-color': '#DFF0D8' }
    	}	
    }
    
    $scope.showNote = function(note){
    	if(note.eformData){
    		return false;
    	}
    	return true;
    }
    
    
    $scope.firstLine = function(note){
    	var firstL = note.note.trim().split('\n')[0];

    	return firstL
    }
    
    $scope.changeContent = function(mod){
    	console.log(mod);
    	$state.go('record.forms.existing',{demographicNo:$stateParams.demographicNo, type: 'eform' ,id:'5'});
    }
    
    function fillItems(itemsToFill){
    	for (var i = 0; i < itemsToFill.length; i++) {
    		 console.log(itemsToFill[i].summaryCode);
    		 
    		 
    		 
    		 summaryService.getFullSummary($stateParams.demographicNo,itemsToFill[i].summaryCode).then(function(data){
    		 console.log("FullSummary returned ",data);
    		 		for (var j = 0; j < $scope.page.columnOne.modules.length; j++) {
    		 			//console.log($scope.page.columnOne.modules[j].summaryCode,data.summaryCode);
    		 			if($scope.page.columnOne.modules[j].summaryCode == data.summaryCode){
    		 				console.log("match on "+$scope.page.columnOne.modules[j].summaryCode ,data);
    		 				if(data.summaryItem instanceof Array){
    		 				$scope.page.columnOne.modules[j].summaryItem = data.summaryItem;
    		 				}else{
    		 					$scope.page.columnOne.modules[j].summaryItem = [data.summaryItem];
    		 				}
    		 			}
    		 			//if($scope.page.columnOne.modules[j] == 
    		 		}
    			 
    			 
    		 },
	    		 function(errorMessage){
	    			 console.log("fillItems"+errorMessage); 
	    		 }
    				 
    		 );
    	}
    }
	 
    $scope.getTrackerUrl = function(demographicNo) {
    
    url = 'http://localhost:8080/oscar/oscarEncounter/oscarMeasurements/HealthTrackerSlim.jspf?template=tracker&demographic_no='+ demographicNo;
  	
    return url;  
    
    }
	
});


//for demo will resolve 
function resizeIframe(iframe) {
	
	var h = iframe.contentWindow.document.body.scrollHeight;
	if(h>0){
    iframe.height =  h + "px";
    //alert("h > 0");
	}
    //alert("h" + h);
  }
