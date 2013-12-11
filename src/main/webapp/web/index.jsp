<%--

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

--%>
<%
//Initialize some variables
String userName = org.oscarehr.util.LoggedInInfo.loggedInInfo.get().loggedInProvider.getFormattedName();

%>
<!DOCTYPE html>
<!-- ng* attributes are references into AngularJS framework -->
<html lang="en" ng-app="oscarProviderViewModule">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">
<link rel="shortcut icon" href="../images/Oscar.ico">

<title>OSCAR</title>

<link href="../library/bootstrap/3.0.0/css/bootstrap.css" rel="stylesheet">
<link href="../css/font-awesome.css" rel="stylesheet">

<!-- we'll combine/minify later -->
<link href="css/navbar-fixed-top.css" rel="stylesheet">
<link href="css/navbar-demo-search.css" rel="stylesheet">
<link href="css/patient-list.css" rel="stylesheet">

<style>

</style>

</head>

<body>

	<!-- Fixed navbar -->
	<div class="navbar navbar-default navbar-fixed-top" ng-controller="NavBarCtrl" ng-cloak>
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-collapse">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				
				<a href="../provider/providercontrol.jsp"><img src="../images/Logo.png" height="40px" title="OSCAR" border="0" style="padding-top:10px"/></a>
			</div>
			<div class="navbar-collapse collapse">
			      <form class="navbar-form navbar-left form-search" role="search">
					
				  <div class="input-group">

				    <input id="demographicQuickSearch" class="form-control" type="text" placeholder="Search Patients" autocomplete="off">
				    <div class="input-group-btn" id="btn_search_group">
				      <button type="button" class="btn btn-default" tabindex="-1"><span class="glyphicon glyphicon-search" id="nav_search"></span></button>

				      <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" tabindex="-1">
					<span class="caret"></span>
				      </button>

				      <ul class="dropdown-menu pull-right" role="menu">
					<li ng-repeat="item in demographicSearchDropDownItems"><a href="#">{{item.label}}</a></li>
				      </ul>
					<button type="button" class="btn btn-default" ng-click="goHome()">
						<span class="glyphicon glyphicon-home"></span>
					</button>

				    </div>

				  </div><!-- /.input-group -->

				</form>

				<ul class="nav navbar-nav">

					<li ng-repeat="item in menuItems"  ng-class="{'active': isActive(item.id)}">
						<a href="{{item.url}}" ng-click="changeTab(item.id)" data-toggle="tab">{{item.label}}
							<span ng-if="item.extra.length>0">({{item.extra}})</span>
						</a>
					</li>
					
					
					<li class="dropdown"><a href="void()" class="dropdown-toggle"
						data-toggle="dropdown">More<b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li ng-repeat="item in moreMenuItems">
								<a href="{{item.url}}" ng-class="getMoreTabClass(item.id)" ng-click="changeMoreTab(item.id)">{{item.label}}
								<span ng-if="item.extra.length>0" class="badge">{{item.extra}}</span></a>
							</li>
						</ul></li>
						
						
				</ul>
				
				
				<div class="navbar-text pull-right" style="line-height:20px">
					<a href="#" title="Scratchpad"><span class="glyphicon glyphicon-edit"></span></a>
					&nbsp;&nbsp;
					
					<a href="#" title="OSCAR Mail">
						<span  class="glyphicon glyphicon-envelope"></span> 
					</a>
						<span title="New OSCAR messages (demographic)">{{counts.oscarDemoMessages}}</span> |
						 <span title="Total new OSCAR Messages">{{counts.oscarMessages}}</span> |
						  <span title="New messages from patients">{{counts.myOscarMessages}}</span> 
						&nbsp; &nbsp;
						
						<span class="glyphicon glyphicon-globe"></span>
						<span class="dropdown">
						<span class="dropdown-toggle" data-toggle="dropdown"><u>{{currentProgram.name}}</u></span>
						<ul class="dropdown-menu" role="menu">
							<li ng-repeat="item in programInfo">
					    		<a href="#">
					    			<span ng-if="item.current === 'true'">&#10004;</span>
					    			<span ng-if="item.current === 'false'">&nbsp;&nbsp;</span>
					    			{{item.name}}
					    		</a>
					    	</li>
				 		 </ul>
				 	 </span>
						&nbsp;
				<span class="glyphicon glyphicon-user"></span>	
				<span class="dropdown-toggle" data-toggle="dropdown"><u>{{userName}}</u></span>
					<ul class="dropdown-menu" role="menu">
					<li ng-repeat="item in userMenuItems"><a href="{{item.url}}">{{item.name}}</a></li>
				  </ul>
				  
				<div class="btn-group pull-right" style="padding-left:10px">
					<a  href="../logout.jsp" title="Logout">
						<span class="glyphicon glyphicon-off"></span>
					</a>
				</div> <!-- btn-group -->
				
						
				</div>
			</div>
			<!--/.nav-collapse -->
		</div>
	</div>

	<!-- nav bar is done here -->

	 
	 <!-- Start patient List template -->

	<span ng-controller="PatientListCtrl">
	<div class="container-fluid">
		<div class="col-md-2">
			<ul class="nav nav-tabs">			
				<li ng-repeat="item in tabItems" ng-class="{'active': isActive(item.id)}">
					<a ng-click="changeTab(item.id)" data-toggle="tab">{{item.label}}</a>
				</li>
				<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown">More<b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li ng-repeat="item in moreTabItems">
							<a href="#" ng-class="getMoreTabClass(item.id)" ng-click="changeMoreTab(item.id)">{{item.label}}<span ng-if="item.extra.length>0" class="badge">{{item.extra}}</span></a></li>
						</ul>
				</li>
			</ul>
			<div class="list-group"  ng-cloak>
			<button type="button" class="btn btn-default">
 				 <span class="glyphicon glyphicon-arrow-left"></span> 
			</button>
			<button type="button" class="btn btn-default">
 				 <span class="glyphicon glyphicon-eject"></span> 
			</button>
			
			<span class="pull-right">
			<button type="button" class="btn btn-default">
 				 <span class="glyphicon glyphicon-refresh"></span> 
			</button>
			
			<button type="button" class="btn btn-default">
 				 <span class="glyphicon glyphicon-circle-arrow-up"></span> 
 		 
			</button>
			
			<button type="button" class="btn btn-default">
 				 <span class="glyphicon glyphicon-circle-arrow-down"></span> 
			</button>
			
			</span>
				<form class="form-search" role="search">
					<span class="form-group" class="twitter-typeahead">
						<input type="text"  class="form-control" placeholder="Filter" ng-model="query"/>
					</span>
				</form>
		<div ng-include="template"></div>
		
		</div>
		</div>
	</span>
	
	<!-- End patient List template -->
		
	<div class="col-md-10" ng-view ng-cloak></div>
	
	<!-- just for debugging -->
	<p class="text-warning" id="myinfo"></p>

	<!-- Bootstrap core JavaScript
    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script src="../js/jquery-1.9.1.min.js"></script>
	<script src="../library/bootstrap/3.0.0/js/bootstrap.min.js"></script>
	<script src="../library/hogan-2.0.0.js"></script>
	<script src="../library/typeahead.js/typeahead.min.js"></script>
	<script src="../library/angular.min.js"></script>
	<script src="../library/angular-route.min.js"></script>

	<!-- we'll combine/minify later -->
	<script src="js/app.js"></script>
	<script src="js/dashboardController.js"></script>
	<script src="js/inboxController.js"></script>
	<script src="js/navBarController.js"></script>
	<script src="js/patientListController.js"></script>
	<script src="js/providerViewController.js"></script>
	<script src="js/reportController.js"></script>
	<script src="js/scheduleController.js"></script>
	<script src="js/patientDetailController.js"></script>
	<script src="js/billingController.js"></script>
	<script src="js/ticklerController.js"></script>
	<script src="js/consultListController.js"></script>
<script>

$(document).ready(function(){
	$("#nav_search").bind('click',function(){
		 $("#myinfo").html("Patient Search Results");
	});
	
	
	$('#demographicQuickSearch').typeahead({
		name: 'patients',
		valueKey:'name',
		limit: 10,
		
		remote: {
	        url: '../ws/rs/demographics/search?query=%QUERY',
	        cache:false,
	        //I needed to override this to handle the differences in the JSON when it's a single result as opposed to multiple.
	        filter: function (parsedResponse) {
	        	var maxResults = 10;
	            retval = [];
	            if(parsedResponse.demographicSearchResults.items instanceof Array) {
	            	for (var i = 0;  i < parsedResponse.demographicSearchResults.items.length;  i++) {
	            		if(i > maxResults) {
	            			reval.push({'more':'true','numResults':parsedResponse.demographicSearchResults.items.length});
	            		} else {
	            			retval.push(parsedResponse.demographicSearchResults.items[i]);
	            		}
	                 }
	            } else {
	            	retval.push(parsedResponse.demographicSearchResults.items);
	            }
	            return retval;
	        }
	    },
	    
		//TODO:change this to an anonymous function which loads the template from somewhere else
		//that way we can inject the type formatting we want with results
		template: [
		        '<p class="demo-quick-name">{{name}}</p>',
		        '{{#hin}}<p class="demo-quick-hin">&nbsp;"{{hin}}"</p>{{/hin}}',
		       	'{{#dob}}<p class="demo-quick-dob">&nbsp;{{dobString}}</p>{{/dob}}'
		 ].join(''),
		       	engine: Hogan
		}).on('typeahead:selected', function (obj, datum) {
		    console.log('chose demographic ' + datum.id);
		    $("#myinfo").html("You chose " + datum.name + " with demographic id " + datum.id);
	});
	
});
</script>
</body>
</html>