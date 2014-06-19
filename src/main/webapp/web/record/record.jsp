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
<div class="page-header" style="margin-top: 0px; margin-bottom: 0px;">
		<h1 style="margin-top: 0px;" ng-cloak>
			<b>{{demographic.lastName}}, {{demographic.firstName}}</b> ({{demographic.title}}) <small class="pull-right"> <i>Born:</i>
				<b>{{demographic.dateOfBirth | date:'yyyy-MM-dd'}}</b> (<b>42y</b>) &nbsp;&nbsp; <i>Sex:</i> <b>{{demographic.sex}}</b>
				<i> &nbsp;&nbsp; Hin:</i> <b>{{demographicNo}}</b> <span
				class="glyphicon glyphicon-new-window"></span>
			</small>

		</h1>
</div>

			
	<nav class="navbar navbar-default" role="navigation"
		style="padding-top: 0px;margin-bottom:3px;">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target=".navbar-ex1-collapse">
				<span class="sr-only">Toggle navigation</span> <span
					class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand navbar-toggle pull-left" href="#">Select Module</a>
		</div>

		<!-- Collect the nav links, forms, and other content for toggling   removed data-toggle="tab"  from a ngclick changeTab3 -->
		<div class="collapse navbar-collapse navbar-ex1-collapse"
			style="padding-left: 0px;">
			<ul class="nav navbar-nav" id="myTabs">
				<li ng-repeat="tab in recordtabs2" ng-class="isTabActive(tab)">
				<a ng-click="changeTab(tab.id)" >{{tab.displayName}}</a>
				</li>
			</ul>
		</div>
		<!-- /.navbar-collapse -->
	</nav>
			<!-- -->
	<div class="row">
        <div class="include-record-peice" ui-view></div>
    </div>
    
    <div class="row">
    	<div id="noteInput2" class="center-block well col-md-4 col-md-offset-3 text-center" style="padding:0px;" ng-click="toggleNote();"  >
    		<span class="glyphicon glyphicon-chevron-up"></span><span class="glyphicon glyphicon-chevron-up"></span><span class="glyphicon glyphicon-chevron-up"></span>
    	</div>
    	<div id="noteInput" class="center-block well col-md-4 col-md-offset-3" ng-show="hideNote">
			<div class="col-xs-4">
			    <input type="text" class="form-control" placeholder="Type Command">
		    </div>
			<div class="col-xs-3 text-center" style="padding:0px;line-height:1;font-size:14px;" ng-click="toggleNote();"  >
			<span class="glyphicon glyphicon-chevron-down"></span><span class="glyphicon glyphicon-chevron-down"></span><span class="glyphicon glyphicon-chevron-down"></span>
			
			</div>
			<div class="col-xs-4 " >
			    <input type="text" class="form-control" placeholder="Search">
			</div>
    		
    		<input type="hidden" ng-model="page.encounterNote.observ"/>
    		<textarea class="form-control input-lg col-lg-4" rows="6" ng-model="page.encounterNote.note">[22-Jan-2014:F/up Cholesterol]</textarea>
			<div class="pull-left"><input type="text" class="form-control" placeholder="Assign Issue"></div>
    		<div class="btn-group btn-group-sm pull-right">
    		
			  <button type="button" class="btn btn-default" ng-click="saveNote()">Save</button>
			  <button type="button" class="btn btn-default">Sign & Save</button>
			  <button type="button" class="btn btn-default">Sign, Save & Bill</button>
			</div>
    		
    	</div>
    </div>