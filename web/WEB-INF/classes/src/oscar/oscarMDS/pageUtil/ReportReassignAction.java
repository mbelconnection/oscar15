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
package oscar.oscarMDS.pageUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Hashtable;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import oscar.oscarLab.ca.on.CommonLabResultData;

public class ReportReassignAction extends Action {
    
    Logger logger = Logger.getLogger(ReportReassignAction.class);
    
    public ReportReassignAction() {
    }
    
    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        
        String providerNo = request.getParameter("providerNo");
        String searchProviderNo = request.getParameter("searchProviderNo");
        String status = request.getParameter("status");
        
        String[] flaggedLabs = request.getParameterValues("flaggedLabs");
        String selectedProviders = request.getParameter("selectedProviders");
        String labType = request.getParameter("labType");
        Hashtable htable = new Hashtable();
        String[] labTypes = CommonLabResultData.getLabTypes();
        ArrayList listFlaggedLabs = new ArrayList();
        
        if(flaggedLabs != null && labTypes != null){
            for (int i = 0; i < flaggedLabs.length; i++){
                for (int j = 0; j < labTypes.length; j++){
                    String s =  request.getParameter("labType"+flaggedLabs[i]+labTypes[j]);
                    
                    if (s != null){  //This means that the lab was of this type.
                        String[] la =  new String[] {flaggedLabs[i],labTypes[j]};
                        listFlaggedLabs.add(la);
                        j = labTypes.length;
                        
                    }
                    
                }
            }
        }
        
        String newURL = "";
        
        try {
            CommonLabResultData.updateLabRouting(listFlaggedLabs, selectedProviders);
            newURL = mapping.findForward("success").getPath();
            
            // the segmentID is needed when being called from a lab display
            newURL = newURL + "?providerNo="+providerNo+"&searchProviderNo="+searchProviderNo+"&status="+status+"&segmentID="+flaggedLabs[0];
            if (request.getParameter("lname") != null) { newURL = newURL + "&lname="+request.getParameter("lname"); }
            if (request.getParameter("fname") != null) { newURL = newURL + "&fname="+request.getParameter("fname"); }
            if (request.getParameter("hnum") != null) { newURL = newURL + "&hnum="+request.getParameter("hnum"); }
        } catch (Exception e) {
            logger.error("exception in ReportReassignAction", e);
            newURL = mapping.findForward("failure").getPath();
        }
        // System.out.println("In ReportReassignAction: newURL is: "+newURL);
        return (new ActionForward(newURL));
    }
}