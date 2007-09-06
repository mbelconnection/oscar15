<!-- 
/*
* 
* Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
* This software is published under the GPL GNU General Public License. 
* This program is free software; you can redistribute it and/or 
* modify it under the terms of the GNU General Public License 
* as published by the Free Software Foundation; either version 2 
* of the License, or (at your option) any later version. * 
* This program is distributed in the hope that it will be useful, 
* but WITHOUT ANY WARRANTY; without even the implied warranty of 
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
* GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
* along with this program; if not, write to the Free Software 
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
* 
* <OSCAR TEAM>
* 
* This software was written for 
* Centre for Research on Inner City Health, St. Michael's Hospital, 
* Toronto, Ontario, Canada 
*/
 -->

<%@ include file="/casemgmt/taglibs.jsp" %>
<%@ taglib uri="/WEB-INF/caisi-tag.tld" prefix="caisi" %>
<%@ page import="org.oscarehr.casemgmt.model.*" %>
<%@ page import="org.oscarehr.casemgmt.web.formbeans.*" %>

<caisi:isModuleLoad moduleName="TORONTO_RFQ" reverse="true">
<table width="100%" border="0"  cellpadding="0" cellspacing="1" bgcolor="#C0C0C0">
<tr class="title">
	<td>Update date</td>
	<td>Allergy description</td>
	<td>Reaction</td>
</tr>
<c:forEach var="allergy" items="${Allergies}">
	<tr>
		<td bgcolor="white"><fmt:formatDate pattern="MM/dd/yy" value="${allergy.entry_date}"/></td>	
		<td bgcolor="white"><c:out value="${allergy.description}"/></td>
		<td bgcolor="white"><c:out value="${allergy.reaction}"/></td>
	</tr>	 
</c:forEach>
</table>
</caisi:isModuleLoad>

<caisi:isModuleLoad moduleName="TORONTO_RFQ" reverse="false">
<table width="100%" border="0"  cellpadding="0" cellspacing="1" bgcolor="#C0C0C0">
<tr class="title"><td>Allergy Description</td></tr>
<tr width="100%">	
	<td bgcolor="white"><html:textarea property="allergy.reaction" rows="4" cols="90"/></td>
</tr>
</table>
<html:submit value="Save" onclick="this.form.method.value='allergy_RFQ_save'"/>
</caisi:isModuleLoad>
