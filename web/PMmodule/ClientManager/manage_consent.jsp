<%@page import="org.oscarehr.util.SessionConstants"%>
<%@page import="org.oscarehr.common.dao.*"%>
<%@page import="org.oscarehr.common.model.*"%>
<%@page import="org.oscarehr.common.model.IntegratorConsent.ConsentStatus"%>
<%@page import="org.oscarehr.util.SpringUtils"%>
<%@page import="org.oscarehr.PMmodule.web.ManageConsent"%>
<%@page import="org.oscarehr.caisi_integrator.ws.CachedFacility"%>
<%@page import="org.oscarehr.caisi_integrator.ws.DemographicTransfer"%>
<%@page import="org.oscarehr.util.LoggedInInfo"%>
<%@page import="org.oscarehr.util.DigitalSignatureUtils"%>
<%@page import="org.oscarehr.ui.servlet.ImageRenderingServlet"%>

<%@include file="/layouts/caisi_html_top2.jspf"%>
<script>
	String.prototype.trim = function() { return this.replace(/^\s+|\s+$|\n$/g, ''); };
</script>
<%
	int currentDemographicId=Integer.parseInt(request.getParameter("demographicId"));
	
	ManageConsent manageConsent=new ManageConsent(currentDemographicId);

	String viewConsentId=request.getParameter("viewConsentId");
	manageConsent.setViewConsentId(viewConsentId);
	
	String signatureRequestId = null;
%>

<h3><%=viewConsentId!=null?"View Consent":"Manage Consent"%></h3>
<hr />
<div style="border:solid black 1px">
	<%@include file="manage_consent_text.jspf" %>
</div>
<hr />


<form action="manage_consent_action.jsp">
	<input type="hidden" name="demographicId" value="<%=currentDemographicId%>" />
	<input type="hidden" name="signature_status" id="signature_status" value="NOT_FOUND"/>
	<div style="font-weight:bold">Client consent</div>
	<table style="background-color:#ccccff">
		<tr>
			<td><input type="radio" name="consentStatus" <%=manageConsent.disableEdit()?"disabled=\"disabled\"":""%> value="<%=ConsentStatus.GIVEN%>" <%=manageConsent.displayAsSelectedConsentStatus(ConsentStatus.GIVEN)?"checked=\"on\"":""%> /></td>
			<td>
				I understand the purpose of CAISI, and the benefits and risks associated with consenting to integrate my personal information, including personal health information, among the participating CAISI integrating agencies. I consent to the integration of my information for the purposes described above.
				<%-- removed until further notice
					<br /><br />
					<input type="checkbox" name="excludeMentalHealth" <%=manageConsent.displayAsCheckedExcludeMentalHealthData()?"checked=\"on\"":""%> <%=manageConsent.disableEdit()?"disabled=\"disabled\"":""%> /><span style="font-weight:bold">I choose to exclude my mental health record from the integration of my information.</span>
					<br /><br />
					I do not wish records from the following agencies to be seen in other agencies that provide me care.
					<br />
					Check to indicate which agencies to exclude
					<br />
					<%
						Collection<CachedFacility> facilitiesToDisplay=manageConsent.getAllFacilitiesToDisplay();
					
						if (facilitiesToDisplay!=null)
						{
							for (CachedFacility cachedFacility : facilitiesToDisplay)
							{
								int remoteFacilityId=cachedFacility.getIntegratorFacilityId();
								%>
									<input type="checkbox" name="consent.<%=remoteFacilityId%>.excludeShareData" <%=manageConsent.displayAsCheckedExcludeFacility(remoteFacilityId)?"checked=\"on\"":""%> <%=manageConsent.disableEdit()?"disabled=\"disabled\"":""%> /><%=cachedFacility.getName()%><br />
								<%
							}
						}
						else
						{
							%>
								<h3 style="color:red">System is unavailable.</h3>
							<%						
						}
					%>
					<br />	
				--%>	
			</td>
		</tr>
		<tr>
			<td><input type="radio" name="consentStatus" <%=manageConsent.disableEdit()?"disabled=\"disabled\"":""%> value="<%=ConsentStatus.REVOKED%>" <%=manageConsent.displayAsSelectedConsentStatus(ConsentStatus.REVOKED)?"checked=\"on\"":""%> /></td>
			<td>I do not consent to the integration of my information for the integration purposes described above.</td>
		</tr>
		<tr>
			<td><input type="radio" name="consentStatus" <%=manageConsent.disableEdit()?"disabled=\"disabled\"":""%> value="<%=ConsentStatus.DEFERRED_CONSIDER_LATER%>" <%=manageConsent.displayAsSelectedConsentStatus(ConsentStatus.DEFERRED_CONSIDER_LATER)?"checked=\"on\"":""%> /></td>
			<td>Deferred : client wishes to consider consent at a future date.</td>
		</tr>
		<tr>
			<td><input type="radio" name="consentStatus" <%=manageConsent.disableEdit()?"disabled=\"disabled\"":""%> value="<%=ConsentStatus.DEFERRED_NOT_APPROPRIATE%>" <%=manageConsent.displayAsSelectedConsentStatus(ConsentStatus.DEFERRED_NOT_APPROPRIATE)?"checked=\"on\"":""%> /></td>
			<td>Deferred : staff decided that collection of consent not appropriate at this time.</td>
		</tr>
		<tr>
			<td><input type="radio" name="consentStatus" <%=manageConsent.disableEdit()?"disabled=\"disabled\"":""%> value="<%=ConsentStatus.REFUSED_TO_SIGN%>" <%=manageConsent.displayAsSelectedConsentStatus(ConsentStatus.REFUSED_TO_SIGN)?"checked=\"on\"":""%> /></td>
			<td>Refused to sign : client is not interested in integration.</td>
		</tr>
	</table>
	<%--
	<br />
		<div style="font-weight:bold">Consent expiry : </div>
		<select name="consentExpiry" <%=manageConsent.disableEdit()?"disabled=\"disabled\"":""%>>
			<option <%=manageConsent.displayAsSelectedExpiry(-1)?"selected=\"selected\"":""%> value="-1">I do not wish this consent to expire at a predefined time</option>
			<option <%=manageConsent.displayAsSelectedExpiry(6)?"selected=\"selected\"":""%> value="6">I wish this consent to expire and require a new consent in 6 months.</option>
			<option <%=manageConsent.displayAsSelectedExpiry(12)?"selected=\"selected\"":""%> value="12">I wish this consent to expire and require a new consent in 12 months.</option>
			<option <%=manageConsent.displayAsSelectedExpiry(60)?"selected=\"selected\"":""%> value="60">I wish this consent to expire and require a new consent in 60 months.</option>
		</select>
	<br />
	--%>
	<%
		if (manageConsent.useDigitalSignatures())
		{
			signatureRequestId=DigitalSignatureUtils.generateSignatureRequestId(LoggedInInfo.loggedInInfo.get().loggedInProvider.getProviderNo());
			
			String imageUrl=null;
			String statusUrl=null;
			
			if (viewConsentId==null)
			{
				imageUrl=request.getContextPath()+"/imageRenderingServlet?source="+ImageRenderingServlet.Source.signature_preview.name()+"&"+DigitalSignatureUtils.SIGNATURE_REQUEST_ID_KEY+"="+signatureRequestId;
			}
			else
			{
				Integer previousDigitalSignatureId=manageConsent.getPreviousConsentDigitalSignatureId();
				if (previousDigitalSignatureId==null) imageUrl=request.getContextPath()+"/images/1x1.gif";
				else imageUrl=request.getContextPath()+"/imageRenderingServlet?source="+ImageRenderingServlet.Source.signature_stored.name()+"&digitalSignatureId="+previousDigitalSignatureId;
			}
			statusUrl = request.getContextPath()+"/PMmodule/ClientManager/check_signature_status.jsp?" + DigitalSignatureUtils.SIGNATURE_REQUEST_ID_KEY+"="+signatureRequestId;
			%>
				<br />
				<input type="hidden" name="<%=DigitalSignatureUtils.SIGNATURE_REQUEST_ID_KEY%>" value="<%=signatureRequestId%>" />
				Client Signature<br /><img style="border:solid gray 1px; width:500px; height:100px" id="signature" src="<%=imageUrl%>" alt="digital_signature" />
				<script type="text/javascript">
					var POLL_TIME=2500;
					var counter=0;

					function refreshImage()
					{
						counter=counter+1;
						var img=document.getElementById("signature");
						img.src='<%=imageUrl%>&rand='+counter;

						
                        var request = dojo.io.bind({
                            url: '<%=statusUrl%>',
                            method: "post",
                            mimetype: "text/html",
                            load: function(type, data, evt){   
                                	var x = data.trim();                                	
                                    document.getElementById('signature_status').value=x;                                   
                            }
                    });
						
					}
				</script>
				<br />
				<input type="button" value="Sign Signature" onclick="setInterval('refreshImage()', POLL_TIME); document.location='<%=request.getContextPath()%>/signature_pad/topaz_signature_pad.jnlp.jsp?<%=DigitalSignatureUtils.SIGNATURE_REQUEST_ID_KEY%>=<%=signatureRequestId%>'" <%=manageConsent.disableEdit()?"disabled=\"disabled\" style=\"display:none\"":""%> />
				<br />					
			<%								
		}
	%>
	<br />
	<%
		if (viewConsentId!=null)
		{
			%>
				Consent obtained by <%=manageConsent.getPreviousConsentProvider()%> on <%=manageConsent.getPreviousConsentDate()%> <br/>
			<%
		}
	%>
<script type="text/javascript">
function verifyRequiredSignature() {
	var currentStatus = document.getElementById('signature_status').value;
	if(currentStatus == 'FOUND') {
		return true;
	}
	alert('The client must sign the form to obtain consent');
	return false;
}

</script>
		
	<input type="submit" onclick="return verifyRequiredSignature()" value="sign save and exit" <%=manageConsent.disableEdit()?"disabled=\"disabled\" style=\"display:none\"":""%> /> &nbsp; <input type="button" value="Cancel" onclick="document.location='<%=request.getContextPath()%>/PMmodule/ClientManager.do?id=<%=currentDemographicId%>'"/>
</form>

<%@include file="/layouts/caisi_html_bottom2.jspf"%>
