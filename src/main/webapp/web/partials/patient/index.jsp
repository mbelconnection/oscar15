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
			<b>{{demographic.lastName}}, {{demographic.firstName}}</b> ({{demographic.title}})
			
			<small class="pull-right"> <i>Born:</i>
				<b>{{demographic.dateOfBirth | date:'yyyy-MM-dd'}}</b> (<b>42y</b>) &nbsp;&nbsp; <i>Sex:</i> <b>{{demographic.sex}}</b>
				<i> &nbsp;&nbsp; Hin:</i> <b>{{demographic.hin}}</b> 
				<br/>
				<span  class="text-right"><i>Next Appointment: <b>2012-01-01 10:00am</b></i></span>
			</small>

		</h1>
	</div>
	
	<nav class="navbar navbar-default" role="navigation"
		style="padding-top: 0px;">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target=".navbar-ex1-collapse">
				<span class="sr-only">Toggle navigation</span> <span
					class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand navbar-toggle pull-left" href="#">Select
				Module</a>
		</div>

		<!-- Collect the nav links, forms, and other content for toggling -->
		<div class="collapse navbar-collapse navbar-ex1-collapse"
			style="padding-left: 0px;">
			<ul class="nav navbar-nav" id="myTabs">
	
			<li ng-repeat="tab in recordtabs" ng-class="{'active': isActive(tab.id)}">
			<a ng-click="changeTab(tab.id)" data-toggle="tab">{{tab.name}}</a>
			</li>
			<!-- 
				<li><a href="#/ws/echart/{{demographicNo}}/master" data-toggle="tab">Master</a></li>
				<li class="active"><a href="#home" data-toggle="tab">Summary</a></li>						
				<li><a href="#/ws/echart/{{demographicNo}}/lab" >Labs</a></li>
				 -->
				 
			<li class="dropdown"><a  class="dropdown-toggle"
						data-toggle="dropdown">Apps<b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li class="dropdown-header">Apps enabled for this patient</li>
							<li><a href="#">EntryPoint Shared Care Plan</a></li>
							<li><a href="#/tasklist">Clinical Connect Patient Launch</a></li>
							<li class="divider"></li>
							<li><a href="#">Apps Configuration </a></li>
						</ul></li>	 
			</ul>
		</div>
		<!-- /.navbar-collapse -->
	</nav>
	
	
	<div class="row">
        <div class="include-record-peice" ng-include="currenttab.url"></div>
    </div>
    