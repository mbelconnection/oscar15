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
* Toronto, Ontario, Canada  - UPDATED: Quatro Group 2008/2009
*/

package org.oscarehr.casemgmt.web;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionForm;
import org.oscarehr.PMmodule.model.Provider;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ProviderManager;
//import org.oscarehr.PMmodule.service.SurveyManager;
import org.oscarehr.casemgmt.model.CaseManagementCPP;
import org.oscarehr.casemgmt.model.CaseManagementIssue;
import org.oscarehr.casemgmt.service.CaseManagementManager;
import org.oscarehr.casemgmt.service.ClientImageManager;
import org.oscarehr.casemgmt.web.formbeans.CaseManagementEntryFormBean;

import com.quatro.common.KeyConstants;
import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;
import com.quatro.model.LookupCodeValue;
import com.quatro.util.*;
import org.oscarehr.PMmodule.web.BaseClientAction;

public class BaseCaseManagementEntryAction extends BaseClientAction {

	protected String relateIssueString = "Components of Service related to this note:";

	
	protected CaseManagementManager caseManagementMgr;
	protected ProgramManager programManager;	
	protected LookupManager lookupManager;
	protected ClientManager clientManager;
	protected ClientImageManager clientImageManager;
    protected ProviderManager providerManager;
    protected IntakeManager intakeManager;
	
	public void setIntakeManager(IntakeManager intakeManager) {
		this.intakeManager = intakeManager;
	}
	public IntakeManager getIntakeManager() {
		return this.intakeManager;
	}

	public void setClientManager(ClientManager clientManager) {
		this.clientManager = clientManager;
	}

	
	public void setLookupManager(LookupManager lookupMgr) {
		this.lookupManager = lookupMgr;
	}

	public void setProgramManager(ProgramManager pmMgr){
		this.programManager = pmMgr;
	}
	
        public void setProviderManager(ProviderManager pmgr ) {
            this.providerManager = pmgr;
        }
        
	public void setClientImageManager(ClientImageManager mgr) {
		this.clientImageManager = mgr;
	}
	
	public void setCaseManagementManager(CaseManagementManager caseManagementMgr) {
		this.caseManagementMgr = caseManagementMgr;
	}

	protected String getProviderNo(HttpServletRequest request) {
		String providerNo = request.getParameter("providerNo");
		if (Utility.IsEmpty(providerNo)) {
			providerNo = (String) request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_PROVIDERNO);
		}
		return providerNo;
	}
		
	protected String getProviderName(HttpServletRequest request) {
		String providerNo = getProviderNo(request);
		if (providerNo == null)	return "";
		return caseManagementMgr.getProviderName(providerNo);
	}
        
        protected Provider getProvider(HttpServletRequest request) {
		String providerNo = getProviderNo(request);
		if (providerNo == null)	return null;                
		return providerManager.getProvider(providerNo);
	}

		
	protected boolean inCaseIssue(LookupCodeValue iss, List issues) {
		Iterator itr = issues.iterator();
		while (itr.hasNext())
		{
			CaseManagementIssue cIss = (CaseManagementIssue) itr.next();
			if (iss.getCode().equals(cIss.getIssue_id()))
				return true;
		}
		return false;
	}
		
	protected void SetChecked(CheckBoxBean[] checkedlist, int id) {
		for (int i = 0; i < checkedlist.length; i++)
		{
			if (checkedlist[i].getIssue().getId().intValue() == id)
			{
				checkedlist[i].setChecked("on");
				break;
			}
		}
	}

	protected boolean inCheckList(Integer id, int[] list)	{
		boolean ret = false;
		for (int i = 0; i < list.length; i++) {
			if (list[i] == id.intValue())
				ret = true;
		}
		return ret;
	}
	
	
	/* remove related issue list from note */
	protected String removeCurrentIssue(String noteString) {

		noteString = noteString.replaceAll("\r\n", "\n");
		noteString = noteString.replaceAll("\r", "\n");
		String rt = noteString;
		int index = noteString.indexOf("\n[" + relateIssueString);
		if (index >= 0) {
			String begString = noteString.substring(0, index);
			String endString = noteString.substring(index);
			endString = endString.substring(endString.indexOf("]\n") + 2);
			rt = begString + endString;
		}
		return rt;
	}

	/* remove signiature string */
	protected String removeSignature(String note) {

		note = note.replaceAll("\r\n", "\n");
		note = note.replaceAll("\r", "\n");
		String rt = note;
		String subStr = "\n[[";
		int indexb = note.lastIndexOf(subStr);
		if (indexb >= 0) {
			String subNote = note.substring(indexb);
			int indexe = subNote.indexOf("]]\n");
			if (indexe < 0)
				return rt;
			String begNote = note.substring(0, indexb);
			String endNote = subNote.substring(indexe + 3);
			// String midNote = subNote.substring(subStr.length());
			// String[] sp = midNote.split(" ");
			// midNote = "[" + sp[0] + " " + sp[1] + "]";
			rt = begNote + endNote;
		}
		return rt;
	}

	/* create related issue string */
	protected String createIssueString(Set issuelist,Integer caseStatusId ) {
		try {
		if (issuelist.isEmpty())
			return "";
		String rt = "\n[" + relateIssueString;
		//Integer i=new Integer(0);
		Iterator itr = issuelist.iterator();
		while (itr.hasNext()) {
			CaseManagementIssue iss = (CaseManagementIssue) itr.next();
			rt = rt + "\t\t\n[" + lookupManager.GetLookupCode("ISS", iss.getIssue_id().toString()).getDescription()+"]";   // + "\t\t\n";			
		}
		String cs = lookupManager.GetLookupCode("CST", caseStatusId.toString()).getDescription();
		rt = rt+"]\t\t\n[Case Status of this note " + "[" + cs + "]\n";
		return rt+ "]\n";
		}
		catch(SQLException e)
		{
			return "";
		}

	}
        
        protected CaseManagementIssue newIssueToCIssue(String demoNo, LookupCodeValue iss, Integer programId,String providerNo) {
            	CaseManagementIssue cIssue = new CaseManagementIssue();
		// cIssue.setActive(true);
		cIssue.setAcute(false);
		cIssue.setCertain(false);
		cIssue.setDemographic_no(new Integer(demoNo));
		cIssue.setLastUpdateUser(providerNo);

		cIssue.setIssue_id(Integer.valueOf(iss.getCode()));

		//cIssue.setIssue(iss);
		cIssue.setMajor(false);
		// cIssue.setMedical_diagnosis(true);
		cIssue.setNotes(new HashSet());
		cIssue.setResolved(false);
		cIssue.setType("case");
		cIssue.setUpdate_date(new Date());
		cIssue.setWriteAccess(true);
		cIssue.setProgram_id(programId);
		// add it to database
		List uList = new ArrayList();
		uList.add(cIssue);
		caseManagementMgr.saveAndUpdateCaseIssues(uList);
		// add new issues to ongoing concern
		//caseManagementMgr.addNewIssueToConcern((String) cform.getDemoNo(), iss.getDescription());
		return cIssue;
        }

	/**
	 * @param programId is optional, can be null for none.
	 */
	protected CaseManagementIssue newIssueToCIssue(CaseManagementEntryFormBean cform, LookupCodeValue iss, Integer programId,String providerNo) {
            return newIssueToCIssue((String) cform.getDemoNo(),iss,programId,providerNo);
	}
	
	protected Map convertIssueListToMap(List issueList) {
		Map map = new HashMap();
		for(Iterator iter=issueList.iterator();iter.hasNext();) {
			CaseManagementIssue issue = (CaseManagementIssue)iter.next();
			map.put(issue.getIssue().getCode(), issue);
		}
		return map;
	}
	
	protected void updateIssueToConcern(ActionForm form) {
		CaseManagementEntryFormBean cform = (CaseManagementEntryFormBean) form;
		CheckBoxBean[] oldList = (CheckBoxBean[]) cform.getIssueCheckList();
		List caseiss = new ArrayList();
		for (int i = 0; i < oldList.length; i++) {
			if (!oldList[i].getIssue().isResolved())
				caseiss.add(oldList[i].getIssue());
		}
		String demoNo = (String) cform.getDemoNo();
		caseManagementMgr.updateCurrentIssueToCPP(demoNo, caseiss);
	}

	//TODO: update access model
	protected void setCPPMedicalHistory(CaseManagementCPP cpp, String providerNo,List accessRight)	{

		if (caseManagementMgr.greaterEqualLevel(3, providerNo))	{
			String mHis = cpp.getMedicalHistory();
			if(mHis!=null) {
				mHis = mHis.replaceAll("\r\n", "\n");
				mHis = mHis.replaceAll("\r", "\n");
			}
			//List allIssues = caseManagementMgr.getIssues(providerNo, cpp.getDemographic_no(),accessRight);
			List allIssues = caseManagementMgr.getIssues(providerNo, cpp.getDemographic_no());
			
			Iterator itr = allIssues.iterator();
			while (itr.hasNext()) {
				CaseManagementIssue cis = (CaseManagementIssue) itr.next();
				String issustring = cis.getIssue().getDescription();
				if (cis.isMajor() && cis.isResolved()) {
					if (mHis!=null && mHis.indexOf(issustring) < 0)
						mHis = mHis + issustring + ";\n";
				} else {

					if (mHis!=null && mHis.indexOf(issustring) >= 0)
						mHis = mHis.replaceAll(issustring + ";\n", "");
				}
			}
			if(mHis!=null) {
				mHis = mHis.replaceAll("\r\n", "\n");
				mHis = mHis.replaceAll("\r", "\n");
			}
			cpp.setMedicalHistory(mHis);
		}
	}

}
