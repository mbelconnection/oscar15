<%@ include file="/taglibs.jsp"%>
<%@page import="org.oscarehr.eyeform.web.EyeformAction"%>
<%
	request.setAttribute("sections",EyeformAction.getMeasurementSections());
	request.setAttribute("headers",EyeformAction.getMeasurementHeaders());
	request.setAttribute("providers",EyeformAction.getActiveProviders());
%>
<tr>	
            <td colspan=2 class="tite4">
            <table width="100%">
                    <tr>
                        <td width="30%" class="tite4">
                           Ocular Examination:
                        </td>
                        <td>
                        <!-- 
                            <input type="button" class="btn" value="current hx" onclick="currentProAdd('cHis','ext_specialProblem');" />&nbsp;
                            <input type="button" class="btn" value="past ocular hx" onclick="currentProAdd('pHis','ext_specialProblem');" />&nbsp;
                            <input type="button" class="btn" value="ocular meds" onclick="currentProAdd('oMeds','ext_specialProblem');" />&nbsp;

                            <input type="button" class="btn" value="diagnostic notes" onclick="currentProAdd('dTest','ext_specialProblem');" />&nbsp;
                            <input type="button" class="btn" value="past ocular proc" onclick="currentProAdd('oProc','ext_specialProblem');" />&nbsp;
                            <input type="button" class="btn" value="specs hx" onclick="currentProAdd('specs','ext_specialProblem');" />&nbsp;

                            <input type="button" class="btn" value="impression" onclick="currentProAdd('impress','ext_specialProblem');" />&nbsp;
                         
                            <input type="button" class="btn" value="follow-up" onclick="currentProAdd('followup','ext_specialProblem');" />&nbsp;
                            <input type="button" class="btn" value="proc" onclick="currentProAdd('probooking','ext_specialProblem');" />
                           <input type="button" class="btn" value="test" onclick="currentProAdd('testbooking','ext_specialProblem');" />&nbsp;
                           -->

                         </td>
                    </tr>
                </table>
            </td>
       </tr>
       
       <tr>
            <td colspan="2">
                <table>
                	<tr>
                		<td>
                			<select name="fromlist1" multiple="multiple" size="9" ondblclick="addSection(document.EctConsultationFormRequestForm.elements['fromlist1'],document.EctConsultationFormRequestForm.elements['fromlist2']);">                				
                				<c:forEach var="item" items="${sections}">
                					<option value="<c:out value="${item.value}"/>"><c:out value="${item.label}"/></option>
                				</c:forEach>
                			</select>
                		</td>
                		<td valign="middle">
                			<input type="button" value=">>" onclick="addSection(document.EctConsultationFormRequestForm.elements['fromlist1'],document.EctConsultationFormRequestForm.elements['fromlist2']);"/>
                		</td>
                		<td>
                			<select id="fromlist2" name="fromlist2" multiple="multiple" size="9" ondblclick="addExam(ctx,'fromlist2',document.EctConsultationFormRequestForm.elements['ext_specialProblem'],appointmentNo);">
                				<c:forEach var="item" items="${headers}">
                					<option value="<c:out value="${item.value}"/>"><c:out value="${item.label}"/></option>
                				</c:forEach>
                			</select>                			
							<input style="vertical-align: middle;" type="button" value="add" onclick="addExam(ctx,'fromlist2',document.EctConsultationFormRequestForm.elements['ext_specialProblem'],appointmentNo);">
						</td>                		
                	</tr>
                </table>
            </td>
       </tr>
       
       <tr>
            <td colspan="2">
                <table>
                	<tr>                		
               			 <td>
                			<textarea cols="90" rows="8" id="ext_specialProblem" name="ext_specialProblem"></textarea>
                		</td>
                	</tr>
                </table>
            </td>
       </tr>
       
       
       <tr>
	       <td colspan=2 class="tite4">
	            <table width="100%">
	                    <tr>
	                        <td width="30%" class="tite4">
	                           Send ticker:
	                        </td>
	                     </tr>
	            </table>
	        </td>
        </tr>

        <tr>
        	<td colspan="2">
        		<table>
        			<tr>
       					<td><input type="checkbox" name="ackdoc" checked> remind me to complete it</td>
					    <td>
					    	<input type="checkbox" name="ackfront" checked>remind
						    <select name="providerl">  
						    	<c:forEach var="item" items="${providers}">
						    		<option value="<c:out value="${item.providerNo}"/>"><c:out value="${item.formattedName}"/></option>
						    	</c:forEach>     
       						</select>
					      to arrange it
       					</td>
				       <td><input type="button" name="sendtickler" value="send tickler" onclick="sendConRequestTickler(ctx,demoNo);"></td>
       				</tr>
       			</table>
      		 </td>
       </tr>

                        
                        