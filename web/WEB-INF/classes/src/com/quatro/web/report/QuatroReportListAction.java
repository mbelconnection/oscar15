/*******************************************************************************
 * Copyright (c) 2005, 2009 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU General Public License
 * which accompanies this distribution, and is available at
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Contributors:
 *     <Quatro Group Software Systems inc.>  <OSCAR Team>
 *******************************************************************************/
package com.quatro.web.report;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.oscarehr.PMmodule.web.*;
import org.oscarehr.PMmodule.web.admin.BaseAdminAction;

import com.quatro.model.ReportTempValue;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.QuatroReportManager;
import com.quatro.util.Utility;
import com.quatro.common.KeyConstants;
public class QuatroReportListAction extends BaseAdminAction {
	
	private QuatroReportManager reportManager;
	public void setQuatroReportManager(QuatroReportManager reportManager) {
		this.reportManager = reportManager;
	}
	
	public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		return reportlist(mapping,form,request,response);
	}

	public ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
	throws NoAccessException {
		String right = super.getAccess(request, KeyConstants.FUN_REPORTS,KeyConstants.ACCESS_WRITE);
		String providerNo = (String) request.getSession().getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
		QuatroReportListForm myForm = (QuatroReportListForm) form;
		String chkNo= myForm.getChkDel();
		if(Utility.IsEmpty(chkNo) ) return reportlist(mapping,form,request,response);
		
		
		chkNo = chkNo.substring(1);
		StringBuffer str = new StringBuffer();
		String[] sArray = chkNo.split(","); 
		for(int i=0;i<sArray.length;i++){
		  String param = (String)request.getParameter("p" + sArray[i]);
		  if(param!=null) str.append("," + param);
		}

		if(str.toString()!=null){
		  String [] templateNos= str.toString().split(",");
		  for(int i=0; i<templateNos.length; i++) {
			  String templateNo = templateNos[i]; 
			  if(!"".equals(templateNo)){
				  boolean withXRights = false;
				  if ("x".equals(right)) withXRights = true;
				  if (reportManager.GetReportTemplate(Integer.valueOf(templateNo).intValue(), providerNo, withXRights) == null) throw new NoAccessException();
				  reportManager.DeleteReportTemplates(templateNo);
			  }
		  }
		}  
		return reportlist(mapping,form,request,response);
	}
	
	private ActionForward reportlist(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		try {
			String providerNo = (String)request.getSession(true).getAttribute("user");
			com.quatro.service.security.SecurityManager sm = (com.quatro.service.security.SecurityManager) request.getSession().getAttribute(KeyConstants.SESSION_KEY_SECURITY_MANAGER);
			boolean hasXRights = (sm.GetAccess(KeyConstants.FUN_REPORTS).compareTo(KeyConstants.ACCESS_ALL)>=0);
			List reports = reportManager.GetReportGroupList(providerNo, hasXRights);
			QuatroReportListForm qform = (QuatroReportListForm) form;
			qform.setReportGroups(reports);
			qform.setProvider(providerNo);
			super.setMenu(request,KeyConstants.MENU_REPORT);
			return mapping.findForward("reportlist");
    	}
    	catch(NoAccessException e)
    	{
    		return mapping.findForward("failure");
    	}
	}
}