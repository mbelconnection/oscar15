/*
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

package oscar.dms.actions;

import java.io.*;
import org.apache.struts.action.*;
import org.apache.struts.upload.*;
import javax.servlet.http.*;
import oscar.dms.data.*;
import java.util.*;
import oscar.util.*;
import oscar.dms.*;

public class AddEditHtmlAction extends Action {
    
    /** Creates a new instance of AddLinkAction */
    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response) {
        AddEditDocumentForm fm = (AddEditDocumentForm) form;
        Hashtable errors = new Hashtable();
        String fileName = "";
        if ((fm.getDocDesc().length() == 0) || (fm.getDocDesc().equals("Enter Title"))) {
             errors.put("descmissing", "dms.error.descriptionInvalid");
             request.setAttribute("linkhtmlerrors", errors);
             request.setAttribute("completedForm", fm);
             request.setAttribute("function", request.getParameter("function"));
             request.setAttribute("functionid", request.getParameter("functionid"));
             request.setAttribute("editDocumentNo", fm.getMode());
             return mapping.findForward("failed");
        }
        if (fm.getDocType().length() == 0) {
             errors.put("typemissing", "dms.error.typeMissing");
             request.setAttribute("linkhtmlerrors", errors);
             request.setAttribute("completedForm", fm);
             request.setAttribute("function", request.getParameter("function"));
             request.setAttribute("functionid", request.getParameter("functionid"));
             request.setAttribute("editDocumentNo", fm.getMode());
             return mapping.findForward("failed");
        }
        if (fm.getHtml().length() == 0) {
             errors.put("urlmissing", "dms.error.htmlMissing");
             request.setAttribute("linkhtmlerrors", errors);
             request.setAttribute("completedForm", fm);
             request.setAttribute("function", request.getParameter("function"));
             request.setAttribute("functionid", request.getParameter("functionid"));

             return mapping.findForward("failed");
        }
        if (fm.getMode().equals("addLink")) {
            //the 'html' variable is the url
            //checks for http://
            String html = fm.getHtml();
            if (html.indexOf("http://") == -1) {
                html = "http://" + html;
            }
            html = "<script type=\"text/javascript\" language=\"Javascript\">\n" +
                    "window.location='" + html + "'\n" +
                    "</script>";
            fm.setDocDesc(fm.getDocDesc() + " (link)");
            fm.setHtml(html);
            fileName = "link";
        } else if (fm.getMode().equals("addHtml")) {
            fileName = "html";
        } else {
        }
        EDoc currentDoc;
        System.out.println("mode: " + fm.getMode());
        try {
        if (fm.getMode().indexOf("add") != -1) {
            currentDoc = new EDoc(fm.getDocDesc(), fm.getDocType(), fileName, org.apache.commons.lang.StringEscapeUtils.escapeJava(fm.getHtml()), fm.getDocCreator(), 'H', fm.getObservationDate(), fm.getFunction(), fm.getFunctionId());
            currentDoc.setContentType("text/html");
            currentDoc.setDocPublic(fm.getDocPublic());
            EDocUtil.addDocumentSQL(currentDoc);
        } else {
            currentDoc = new EDoc(fm.getDocDesc(), fm.getDocType(), "", org.apache.commons.lang.StringEscapeUtils.escapeJava(fm.getHtml()), fm.getDocCreator(), 'H', fm.getObservationDate(), fm.getFunction(), fm.getFunctionId());
            currentDoc.setDocId(fm.getMode());
            currentDoc.setContentType("text/html");
            currentDoc.setDocPublic(fm.getDocPublic());
            EDocUtil.editDocumentSQL(currentDoc);
        }
        } catch (Exception e) {
        	e.printStackTrace();
        }
        ActionRedirect redirect = new ActionRedirect(mapping.findForward("success"));
        redirect.addParameter("function", request.getParameter("function"));
        redirect.addParameter("functionid", request.getParameter("functionid"));
        return redirect;
    }
    
}
