/**
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
 *
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada   Creates a new instance of EctConsultationFormRequestPrintAction
 */

/*
 * EctConsultationFormRequestPrintAction.java
 *
 * Created on November 19, 2007, 4:05 PM
 */

package oscar.oscarEncounter.oscarConsultationRequest.pageUtil;


import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.lowagie.text.DocumentException;

/**
 *
 * Convert submitted preventions into pdf and return file
 */
public class EctConsultationFormRequestPrintAction extends Action {
    
    Logger logger = Logger.getLogger(EctConsultationFormRequestAction.class);
    
    public EctConsultationFormRequestPrintAction() {
    }
    
    public ActionForward execute(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response){
        
        try {
            EctConsultationFormRequestPrintPdf pdf = new EctConsultationFormRequestPrintPdf(request, response);
            pdf.printPdf();
        }catch(DocumentException de) {
            logger.error("DocumentException occured insided EctConsultationFormRequestPrintAction", de);
            request.setAttribute("printError", new Boolean(true));
            return mapping.findForward("error");
        }catch(IOException ioe) {
            logger.error("IOException occured insided EctConsultationFormRequestPrintAction", ioe);
            request.setAttribute("printError", new Boolean(true));
            return mapping.findForward("error");
        }
        
        return null;
        
    }
}