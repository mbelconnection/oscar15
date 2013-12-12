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


       <div class="col-lg-8">
  <button type="button" class="btn btn-primary">Save</button>
       
       <div class="btn-group">
  
  

  <button type="button" class="btn btn-default">Print Label</button>

  <div class="btn-group">
  <button type="button" class="btn btn-default">Print PDF</button>
  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
    <span class="caret"></span>
    <span class="sr-only">Toggle Dropdown</span>
  </button>
  <ul class="dropdown-menu" role="menu">
    <li><a href="#">PDF Address</a></li>
    <li><a href="#">Another action</a></li>
    <li><a href="#">Something else here</a></li>
    <li class="divider"></li>
    <li><a href="#">Separated link</a></li>
  </ul>
</div>

</div>
<div class="btn-group">

  <div class="btn-group">
    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
      Integrator
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
      <li><a href="#">Compare with Integrator</a></li>
      <li><a href="#">Update from Integrator</a></li>
      <li><a href="#">Send Note Integrator</a></li>
    </ul>
  </div>
  <div class="btn-group">
    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
      More
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
      <li><a href="#">Export to CDS</a></li>
      <li><a href="#">Export to CCD</a></li>
      <li><a href="#">Export to XPHR</a></li>
    </ul>
  </div>
  
  
  
  
</div>
        <fieldset>
        	<legend>
        		Demographic
        		<div class="btn-group pull-right">
        			<button class="btn view-edit" rel="demographic">View/Edit</button>
        		</div>
        		<div class="btn-group pull-right demographic" style="display:none;">
        			<button class="btn btn-primary save" rel="demographic">Save</button>&nbsp;
        		</div>
        	</legend>
        	<div class="form-group demographic">
        		<div class="col-xs-10 form-inline">
		        	<label class="col-xs-1 control-label">Title</label>
		        	<div class="form-group col-xs-2">
		        		Mr.
		            </div>
		            <label class="col-xs-1 control-label">Name</label>
		            <div class="form-group">
		                Yin
		            </div>
		            <div class="form-group">
		                Hank
		            </div>
		        </div>
		        <div class="col-xs-10 form-inline">
		        	<label class="col-xs-1 control-label">Sex</label>
		        	<div class="form-group col-xs-2">
		        		Male
		            </div>
		            <label class="col-xs-1 control-label">DOB</label>
		            <div class="form-group">
		                January 01, 1970
		            </div>
		            <div class="form-group">
		                Hank
		            </div>
		        </div>
        	</div>
        	
		  	<div class="form-group demographic" style="display: none;">
			    <div class="col-xs-10">
			        <div class="form-inline">
			        	<label class="col-xs-1 control-label">Title</label>
			        	<div class="form-group col-xs-2">
			        		<select class="form-control">
							  <option>Mr.</option>
							  <option>Mrs.</option>
							  <option>Ms.</option>
							  <option>Master</option>  
							</select>
			            </div>
			            <label class="col-xs-1 control-label">Name</label>
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="lastname"/>
			            </div>
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="firstname"/>
			            </div>
			        </div>
			    </div>
			    <div class="col-xs-10">
			        <div class="form-inline">
			        	<label for="birthday" class="col-xs-1 control-label">Sex</label>
			        	<div class="form-group col-xs-2">
			        		<select class="form-control">
							  <option>Male</option>
							  <option>Female</option>
							  <option>Unknown</option>  
							</select>
			            </div>
			            <label for="birthday" class="col-xs-1 control-label">DOB</label>
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="Year"/>
			            </div>
			            <div class="form-group">
			                <select class="form-control col-xs-2">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>  
								<option>5</option>  
								<option>6</option>  
								<option>7</option>  
								<option>8</option>  
								<option>9</option>  
								<option>10</option>  
								<option>11</option>  
								<option>12</option>  
							</select>
			            </div>
			            <div class="form-group">
			                <select class="form-control col-xs-2">
							  	<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
								<option>11</option>
								<option>12</option>
								<option>13</option>
								<option>14</option>
								<option>15</option>
								<option>16</option>
								<option>17</option>
								<option>18</option>
								<option>19</option>
								<option>20</option>
								<option>21</option>
								<option>22</option>
								<option>23</option>
								<option>24</option>
								<option>25</option>
								<option>26</option>
								<option>27</option>
								<option>28</option>
								<option>29</option>
								<option>30</option>
								<option>31</option>
							</select>
			            </div>
			        </div>
			    </div>
			</div>	
		</fieldset>
        
        <fieldset>
        	<legend>Contact Info</legend>
		  	<div class="form-group">
    			<label for="birthday" class="col-xs-2 control-label">Name</label>
			    <div class="col-xs-10">
			        <div class="form-inline">
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="lastname"/>
			            </div>
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="firstname"/>
			            </div>
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="suffix"/>
			            </div>
			        </div>
			    </div>
			</div>	
		</fieldset>
        
         <fieldset>
        	<legend>Insurance</legend>
		  	<div class="form-group">
    			<label for="birthday" class="col-xs-2 control-label">Name</label>
			    <div class="col-xs-10">
			        <div class="form-inline">
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="lastname"/>
			            </div>
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="firstname"/>
			            </div>
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="suffix"/>
			            </div>
			        </div>
			    </div>
			</div>	
		</fieldset>
		
		<fieldset>
        	<legend>Care Team</legend>
		  	<div class="form-group">
    			<label for="birthday" class="col-xs-2 control-label">Name</label>
			    <div class="col-xs-10">
			        <div class="form-inline">
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="lastname"/>
			            </div>
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="firstname"/>
			            </div>
			            <div class="form-group">
			                <input type="text" class="form-control" placeholder="suffix"/>
			            </div>
			        </div>
			    </div>
			</div>	
		</fieldset>
        
        </div>
        
      <div class="col-lg-4">
      <img src="https://localhost:8081/oscar/images/defaultR_img.jpg" />
      <br/>
        
      
      
      
      
      
      
      <fieldset>
        	<legend>Alerts</legend>
        	<textarea class="form-control" rows="3" style="color:red;">Don't release info to family</textarea>
      </fieldset>  		
      
      <fieldset>
        	<legend>Notes</legend>
        	<textarea class="form-control" rows="3" >Need version code on health card old: GH</textarea>
      </fieldset>  	
      <fieldset>
        	<legend>Contacts</legend>
        	<ul class="list-group">
					<li class="list-group-item">Bob Hooper <span class="pull-right">Brother EC</span></li>
				    <li class="list-group-item">Cathy Dickenson <span class="pull-right">Mother</span></li>
	   		</ul>
        	
        	
      </fieldset>  		
      
      <fieldset>
        	<legend>Professional Contacts</legend>
        			<h5>Ringo Starr<small>(Drummer)</small><span class="pull-right">905-555-1111</span></h5>
				    <h5>Tyler Stufferson<small>(IP Lawyer)</small><span class="pull-right">905-555-2222</span></h5>
	   		
      </fieldset>    		
</div>
<script type="text/javascript">
$(document).ready(function(){
	$(".view-edit").click(function() {
		$("."+$(this).attr("rel")).toggle();
	});
	
	$(".save").click(function() {
		$("."+$(this).attr("rel")).toggle();
	});
});
</script>       