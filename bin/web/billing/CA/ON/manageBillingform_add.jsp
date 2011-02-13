<%--  
/*
 * 
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
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
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */
--%>

<form name="servicetypeform" method="post">
<table width="90%" border="0" height="285">
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="30%" valign="top">
		<table width="100%" border="0">
			<tr>
				<th colspan="2" class="white"><bean:message
					key="billing.manageBillingform_add.msgAdd" /></th>
			</tr>
			<tr>
				<td width="50%" class="white"><bean:message
					key="billing.manageBillingform_add.formServiceID" /> :</td>
				<td width="50%" class="white"><input type="text" name="typeid"
					maxlength="3"></td>
			</tr>
			<tr>
				<td class="white"><bean:message
					key="billing.manageBillingform_add.formServiceName" /> :</td>
				<td class="white"><input type="text" name="type"
					value='<bean:message key="billing.manageBillingform_add.formServiceName"/>'>
				</td>
			</tr>
			<tr>
				<td class="white"><bean:message
					key="billing.manageBillingform_add.formGroup1Name" /> :</td>
				<td class="white"><input type="text" name="group1"
					value='<bean:message key="billing.manageBillingform_add.formGroup1Name"/>'>
				</td>
			</tr>
			<tr>
				<td class="white"><bean:message
					key="billing.manageBillingform_add.formGroup2Name" /> :</td>
				<td class="white"><input type="text" name="group2"
					value='<bean:message key="billing.manageBillingform_add.formGroup2Name"/>'>
				</td>
			</tr>
			<tr>
				<td class="white"><bean:message
					key="billing.manageBillingform_add.formGroup3Name" /> :</td>
				<td class="white"><input type="text" name="group3"
					value='<bean:message key="billing.manageBillingform_add.formGroup3Name"/>'>
				</td>
			</tr>
			<tr>
				<td colspan=2>&nbsp;</td>
			</tr>
			<tr>
				<td class="white"><bean:message
					key="billing.manageBillingform_add.formDefaultBillType" /> :</td>
				<td class="white"><select name="billtype">
					<option value="no" selected>-- no --</option>
					<option value="ODP">Bill OHIP</option>
					<option value="WCB">WSIB</option>
					<option value="NOT">Do Not Bill</option>
					<option value="IFH">IFH</option>
					<option value="PAT">3rd Party</option>
					<option value="OCF">-OCF</option>
					<option value="ODS">-ODSP</option>
					<option value="CPP">-CPP</option>
					<option value="STD">-STD/LTD</option>
				</select></td>
			</tr>
			<tr>
				<td class="white"><input type="button" name="addForm"
					value="<bean:message key="billing.manageBillingform_add.btnAdd"/>"
					onClick="valid(this.form)"></td>
				<td class="white">&nbsp;</td>
			</tr>
		</table>
		</td>

		<td width="30%" valign="middle" align="right">
		<div id="manage_type"></div>
		</td>

		<td width="25%" bgcolor="#336699" valign="top">
		<table width="100%" border="0">
			<tr>
				<th colspan="2" valign="top" bgcolor="white"><bean:message
					key="billing.manageBillingform_add.msgExistType" /></th>
			</tr>

			<% 
	ResultSet rs=null ;
	ResultSet rs2=null ;

	rs = apptMainBean.queryResults("%", "search_ctlbillservice");
	int rCount = 0;
	boolean bodd=false;

	if(rs==null) {
		out.println("failed!!!"); 
	} else {
		while (rs.next()) {
%>

			<tr>
				<td width="30%" valign="top" class="black"><a href=#
					onClick='manageType("<%=rs.getString("servicetype")%>","<%=rs.getString("servicetype_name")%>");return false;'
					title="Manage Billing Form"><%=rs.getString("servicetype")%></a> <!--		<a href=# onClick='onUnbilled("dbManageBillingform_delete.jsp?servicetype=<%=rs.getString("servicetype")%>");return false;' title="Delete Billing Form"><%=rs.getString("servicetype")%></a> -->
				</td>
				<td class="black"><a href=#
					onClick='manageType("<%=rs.getString("servicetype")%>","<%=rs.getString("servicetype_name")%>");return false;'
					title="Manage Billing Form"><%=rs.getString("servicetype_name")%></a>
				<!--		<a href=# onClick='onUnbilled("dbManageBillingform_delete.jsp?servicetype=<%=rs.getString("servicetype")%>");return false;' title="Delete Billing Form"><%=rs.getString("servicetype_name")%></a> -->
				</td>
			</tr>
			<%
	}
}
%>

		</table>

		</td>
	</tr>
</table>
</form>
