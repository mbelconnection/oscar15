/*
 *  Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
 *  This software is published under the GPL GNU General Public License.
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version. *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details. * * You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *
 *
 *  Jason Gallagher
 *
 *  This software was written for the
 *  Department of Family Medicine
 *  McMaster University
 *  Hamilton
 *  Ontario, Canada   Creates a new instance of Prevention
 *
 * CombinePDFAction.java
 *
 * Created on July 29, 2006, 8:35 PM
 *
 */

package oscar.dms.actions;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import oscar.OscarProperties;
import oscar.dms.EDocUtil;
import oscar.util.ConcatPDF;
import oscar.util.UtilDateUtilities;

/**
 *
 * @author jay
 */
public class CombinePDFAction extends Action {
    
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        String[] files = request.getParameterValues("docNo");
        ArrayList alist = new ArrayList();
        if (files != null){
            System.out.println("size = "+files.length);
            EDocUtil docData = new EDocUtil();
            for (int i =0 ; i < files.length ; i++){
               String path = OscarProperties.getInstance().getProperty("DOCUMENT_DIR");
               String filename =  docData.getDocumentName(files[i]);
                     alist.add(path+filename);
            }
            if (alist.size() > 0 ){
                response.setContentType("application/pdf");  //octet-stream
                response.setHeader("Content-Disposition", "attachment; filename=\"combinedPDF-"+UtilDateUtilities.getToday("yyyy-MM-dd.hh.mm.ss")+".pdf\"");
                try {
                    ConcatPDF.concat(alist,response.getOutputStream());            
                } catch (IOException ex) {
                    ex.printStackTrace();
                }            
                return null;
            }
        }  
        return mapping.findForward("success");
    }
    
    /** Creates a new instance of CombinePDFAction */
    public CombinePDFAction() {
    }
    
}