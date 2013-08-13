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

<% String pageHeading = "marc-hi.affinityDomains.headers.affinityDomain"; %>
<%@ include file="../layouts/marc/header.jsp" %>
<%@ include file="../layouts/marc/affDomSidebar.jsp" %>

<form action="affinityDomainAction.jsp" method="POST" id="affinityDomainForm">
	<input type="hidden" name="action" value="add" />
	<fieldset>
		<legend><bean:message key="marc-hi.affinityDomains.affinityDomainInformation" /></legend>
		<label><bean:message key="marc-hi.affinityDomains.name" />:</label><input type="text" name="name" /><br />
		<label><bean:message key="marc-hi.affinityDomains.facilityName" />:</label><input type="text" name="facilityName" /><br />
		<label><bean:message key="marc-hi.affinityDomains.uniqueId" />:</label><input type="text" name="uniqueId" /><br />
		<label><bean:message key="marc-hi.affinityDomains.policyUrl" />:</label><input type="text" name="policyUrl" /><br />
	</fieldset>
	
	<fieldset>
		<legend><bean:message key="marc-hi.affinityDomains.affinityDomainActors" /></legend>
		<span id="addActor"><a href="#" title="Add New Actor"><bean:message key="marc-hi.affinityDomains.addActor" /></a></span>
		<div id="actors">
			<fieldset class="actor">
				<legend><bean:message key="marc-hi.affinityDomains.actor" /></legend>
				<!-- Actor Name -->
				<label><bean:message key="marc-hi.affinityDomains.actorName" />:</label><input type="text" name="actorName" /><br />
				<!-- Endpoint -->
				<label><bean:message key="marc-hi.affinityDomains.endPoint" />:</label><input type="text" name="endPoint" /><br /> 
				<!-- Actor Type -->
				<label><bean:message key="marc-hi.affinityDomains.actorType" />:</label>
				<select name="actorType">
					<option value="PAT_IDENTITY_X_REF_MGR">PAT_IDENTITY_X_REF_MGR</option>
					<option value="DOC_REPOSITORY">DOC_REPOSITORY</option>
					<option value="DOC_REGISTRY">DOC_REGISTRY</option>
					<option value="AUDIT_REPOSITORY">AUDIT_REPOSITORY</option>
					<option value="TS">TS</option>
				</select><br />
				<!-- Binary Only -->
				<label><bean:message key="marc-hi.affinityDomains.binaryFormat" /></label>
				<select name="binaryOnly">
					<option value="true"><bean:message key="marc-hi.affinityDomains.yes" /></option>
					<option value="false"><bean:message key="marc-hi.affinityDomains.no" /></option>
				</select><br />
				
				<!-- Local Identification -->
				<label><bean:message key="marc-hi.affinityDomains.localUniqueId" />:</label><input type="text" name="localUniqueId" /><br />
				<label><bean:message key="marc-hi.affinityDomains.localFacilityName" />:</label><input type="text" name="localFacilityName" /><br />
				
				<!-- Remote Identification -->
				<label><bean:message key="marc-hi.affinityDomains.remoteUniqueId" />:</label><input type="text" name="remoteUniqueId" /><br />
				<label><bean:message key="marc-hi.affinityDomains.remoteFacilityName" />:</label><input type="text" name="remoteFacilityName" /><br />
				
				<span class="removeActor"><a href="#" title="Remove Actor"><bean:message key="marc-hi.affinityDomains.remove" /></a></span><br />
			</fieldset>
		</div>
	</fieldset>
	
	<input type="submit" name="submit" value="<bean:message key="marc-hi.affinityDomains.save" />" />
</form>

<!-- 	Actor fieldset template (will be cloned and added to the DOM when the 'Add Actor' button is clicked
		It must be after the <form> because we don't want to submit it. -->
<fieldset class="actor" id="fieldSetTemplate">
	<legend><bean:message key="marc-hi.affinityDomains.actor" /></legend>
	<!-- Actor Name -->
	<label><bean:message key="marc-hi.affinityDomains.actorName" />:</label><input type="text" name="actorName" /><br />
	<!-- Endpoint -->
	<label><bean:message key="marc-hi.affinityDomains.endPoint" />:</label><input type="text" name="endPoint" /><br />
	<!-- Actor Type -->
	<label><bean:message key="marc-hi.affinityDomains.actorType" />:</label>
	<select name="actorType">
		<option value="PAT_IDENTITY_X_REF_MGR">PAT_IDENTITY_X_REF_MGR</option>
		<option value="DOC_REPOSITORY">DOC_REPOSITORY</option>
		<option value="DOC_REGISTRY">DOC_REGISTRY</option>
		<option value="AUDIT_REPOSITORY">AUDIT_REPOSITORY</option>
		<option value="TS">TS</option>
	</select><br />
	<!-- Binary Only -->
	<label><bean:message key="marc-hi.affinityDomains.binaryFormat" /></label>
	<select name="binaryOnly">
		<option value="true">YES</option>
		<option value="false">NO</option>
	</select><br />
	
	<!-- Local Identification -->
	<label><bean:message key="marc-hi.affinityDomains.localUniqueId" />:</label><input type="text" name="localUniqueId" /><br />
	<label><bean:message key="marc-hi.affinityDomains.localFacilityName" />:</label><input type="text" name="localFacilityName" /><br />
	
	<!-- Remote Identification -->
	<label><bean:message key="marc-hi.affinityDomains.remoteUniqueId" />:</label><input type="text" name="remoteUniqueId" /><br />
	<label><bean:message key="marc-hi.affinityDomains.remoteFacilityName" />:</label><input type="text" name="remoteFacilityName" /><br />
	
	<span class="removeActor"><a href="#" title="Remove Actor"><bean:message key="marc-hi.affinityDomains.remove" /></a></span><br />
</fieldset>

<script type="text/javascript">
$(document).ready(function() {

	// click events (add & remove)
	$('span#addActor').live('click', function() {
		// clone the hidden actor fieldset, unhide it, and add it to the DOM with animation
		var actorFieldset = $('fieldset#fieldSetTemplate.actor').clone().css('display', 'block').removeAttr('id').appendTo('div#actors').show('slow');
	});
	
	$('span.removeActor').live('click', function() {
		// destroy the parent (closest is superior) actor fieldset.
		$(this).closest('fieldset.actor').remove();
	});
	
});
</script>

<%@ include file="../layouts/marc/footer.jsp" %>
