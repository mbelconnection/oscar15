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
	<div class="col-lg-3">
       <fieldset ng-repeat="mod in page.columnOne.modules">
       		<legend style="margin-bottom:0px;">{{mod.displayName}}</legend>
        	<ul style="padding-left:12px;">
        	<li ng-repeat="item in mod.summaryItem" ng-show="$index < mod.displaySize"  ><a href="{{item.action}}">{{item.displayName}}<small ng-show="item.type">({{item.type}})</small></a> <span class="pull-right">{{item.date}}</span></li> 
        	</ul>
       </fieldset>   
    </div>
    
    <div class="col-lg-6" id="middleSpace">
        	<ul class="nav nav-tabs">
			  <li class="active"><a data-target="#all" role="tab" data-toggle="tab">All</a></li>
			  <li><a data-target="#myNotes" ng-click="changeNoteFilter(0)" role="tab" data-toggle="tab">Just My Notes</a></li>
			  <li><a data-target="#justNotes" role="tab" data-toggle="tab">Just Notes</a></li>
			  <li><a data-target="#tracker" role="tab" data-toggle="tab">Tracker</a></li>
			</ul>
			
    		<div class="tab-content">
			  <div class="tab-pane active" id="all">
			          	<dl >
			    				<dt ng-style="setColor(note)" ng-repeat-start="note in page.notes.notelist" >{{note.observationDate | date : 'dd-MMM-yyyy'}} {{firstLine(note)}} </dt>
			    				<dd ng-repeat-end><pre class="pre-scrollable" ng-show="showNote(note)">{{note.note}}</pre></dd>
			    								
			    				<%--   dt>30-Jun-2012 document </dt -->
			    				<dt style="background-color:#DFF0D8;">30-Jun-2012 lab RIA/CHEMISTRY/HEMATOLOGY/IMMUNOCHEMISTRY <a ng-click="changeTab(12)" class="pull-right" style="margin-right:5px;">view</a></dt>
				
			    				<dt>30-Jun-2012 eform filled out</dt>
			    				<dd><pre class="pre-scrollable">CTC form</pre></dd> --%>
			    		</dl>
			    		<%-- img ng-hide="notesList" src="tracker2.png" width="800px"/ --%>
			  </div>
			  <div class="tab-pane" id="myNotes">My Notes</div>
			  <div class="tab-pane" id="justNotes">Just My Notes</div>
			  <div class="tab-pane" id="tracker">
			  <iframe 
			  	id="trackerSlim" 
			  	scrolling="No" 
			  	frameborder="0" 
			  	ng-src="{{getTrackerUrl(demographicNo)}}" 
			  	width="720px" 
			  	height="2000px" 
			  	onload="resizeIframe(this)"
			  	></iframe>
			   
			  </div>
			</div><!-- tab content -->
    			
	</div>