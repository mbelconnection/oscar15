
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
package org.caisi.core.web;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.LabelValueBean;
import org.caisi.service.InfirmBedProgramManager;
import org.oscarehr.PMmodule.service.ProgramManager;

public class InfirmAction extends BaseAction
{
	private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger
			.getLogger(InfirmAction.class);

	public ActionForward showProgram(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception
	{
		logger.debug("====> inside showProgram action.");

		HttpSession se = request.getSession();	
		se.setAttribute("infirmaryView_initflag", "true");
		String providerNo=(String) se.getAttribute("user");				
				
		//clear memory for programbean
		//List memob=(List) se.getAttribute("infirmaryView_demographicBeans");
		//if (memob!=null) memob.clear();
		
		List programBean;
		String archiveView = (String)request.getSession().getAttribute("archiveView");
		/*
		if(archiveView != null && archiveView.equals("true")){
			
			ProgramManager manager = getProgramManager();
			programBean = manager.getProgramBeans(providerNo);	
			se.setAttribute("infirmaryView_programBeans",programBean );
		}
		else {
			InfirmBedProgramManager manager=getInfirmBedProgramManager();
			programBean=manager.getProgramBeans(providerNo);	
			se.setAttribute("infirmaryView_programBeans",programBean );
		}
		*/
		InfirmBedProgramManager manager=getInfirmBedProgramManager();
		programBean=manager.getProgramBeans(providerNo);	
		se.setAttribute("infirmaryView_programBeans",programBean );
				
		
		
		
		
		
		
		//set default program
		int defaultprogramId=getInfirmBedProgramManager().getDefaultProgramId(providerNo);
		boolean defaultInList=false;
		for (int i=0;i<programBean.size();i++){
			int id=new Integer(((LabelValueBean) programBean.get(i)).getValue()).intValue();
			if ( defaultprogramId == id ) defaultInList=true;
		}
		if (!defaultInList) defaultprogramId=0;
		int OriprogramId=0;
		if (programBean.size()>0) OriprogramId=new Integer(((LabelValueBean) programBean.get(0)).getValue()).intValue();
		int programId=0;
		if (defaultprogramId!=0 && OriprogramId!=0) programId=defaultprogramId;
		else {
			if (OriprogramId==0) programId=0;
			if (defaultprogramId==0 && OriprogramId!=0) programId=OriprogramId;
		}
		if (se.getAttribute("infirmaryView_programId")!=null){
			programId=Integer.valueOf((String)se.getAttribute("infirmaryView_programId")).intValue();
		}
		if (programId!=defaultprogramId) getInfirmBedProgramManager().setDefaultProgramId(providerNo,programId);
		
		se.setAttribute("infirmaryView_programId",String.valueOf(programId));
		if(programId != 0) {
			se.setAttribute("case_program_id",String.valueOf(programId));
		}
		
		
		String[] programInfo = getInfirmBedProgramManager().getProgramInformation(programId);
		if(programInfo[0] != null) {
			se.setAttribute("infirmaryView_programAddress",programInfo[0].replaceAll("\\n", "<br>"));
		} else {
			se.setAttribute("infirmaryView_programAddress","");
		}
		if(programInfo[1] != null) {
			se.setAttribute("infirmaryView_programTel",programInfo[1]);
		} else {
			se.setAttribute("infirmaryView_programTel","");
		}
		if(programInfo[2] != null) {
			se.setAttribute("infirmaryView_programFax",programInfo[2]);
		} else {
			se.setAttribute("infirmaryView_programFax","");
		}
		
		Date dt;

		if (se.getAttribute("infirmaryView_date")!=null)
		{
			dt=(Date) se.getAttribute("infirmaryView_date") ; //new Date(year,month-1,day);
		}else{
			dt=new Date();
		}
		
		//release memory
		//List memo=(List) se.getAttribute("infirmaryView_demographicBeans");
		//if (memo!=null) memo.clear();
		
		se.setAttribute("infirmaryView_demographicBeans",getInfirmBedProgramManager().getDemographicByBedProgramIdBeans(programId,dt,archiveView));
		
		/*java.util.Enumeration enu =  se.getAttributeNames();
		while (enu.hasMoreElements())
			logger.info(enu.nextElement()); 
		*/
//		response.sendRedirect(se.getAttribute("infirmaryView_OscarURL")+"?"+se.getAttribute("infirmaryView_OscarQue"));
		return null;
	}

	public ActionForward getSig(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception
	{
		logger.debug("====> inside getSig action.");
		String providerNo=request.getParameter("providerNo");
		if (providerNo==null) providerNo=(String) request.getSession().getAttribute("user");
		Boolean onsig=getInfirmBedProgramManager().getProviderSig(providerNo);
		request.getSession().setAttribute("signOnNote",onsig);
		return null;
	}
	
	public ActionForward toggleSig(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception
	{
		logger.debug("====> inside toggleSig action.");
		String providerNo=request.getParameter("providerNo");
		if (providerNo==null) providerNo=(String) request.getSession().getAttribute("user");
		Boolean onsig=getInfirmBedProgramManager().getProviderSig(providerNo);
		request.getSession().setAttribute("signOnNote",onsig);
		return null;
	}
	
}

