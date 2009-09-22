// -----------------------------------------------------------------------------------------------------------------------
// *
// *
// * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
// * This software is published under the GPL GNU General Public License. 
// * This program is free software; you can redistribute it and/or 
// * modify it under the terms of the GNU General Public License 
// * as published by the Free Software Foundation; either version 2 
// * of the License, or (at your option) any later version. * 
// * This program is distributed in the hope that it will be useful, 
// * but WITHOUT ANY WARRANTY; without even the implied warranty of 
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
// * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
// * along with this program; if not, write to the Free Software 
// * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
// * 
// * <OSCAR TEAM>
// * This software was written for the 
// * Department of Family Medicine 
// * McMaster Unviersity 
// * Hamilton 
// * Ontario, Canada 
// *
// -----------------------------------------------------------------------------------------------------------------------

package oscar.oscarEncounter.pageUtil;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.struts.util.MessageResources;
import org.oscarehr.util.SessionConstants;

import oscar.dms.EDoc;
import oscar.dms.EDocUtil;
import oscar.util.DateUtils;
import oscar.util.StringUtils;

//import oscar.oscarSecurity.CookieSecurity;

public class EctDisplayDocsAction extends EctDisplayAction {
    //private static final String BGCOLOUR = "476BB3";
    private static final String cmd = "docs";
    
 public boolean getInfo(EctSessionBean bean, HttpServletRequest request, NavBarDisplayDAO Dao, MessageResources messages) {
        
    //set lefthand module heading and link
    String winName = "docs" + bean.demographicNo;
    String url = "popupPage(500,1115,'" + winName + "', '" + request.getContextPath() + "/dms/documentReport.jsp?" + 
            "function=demographic&doctype=lab&functionid=" + bean.demographicNo + "&curUser=" + bean.providerNo + "')";        

    Dao.setLeftHeading(messages.getMessage(request.getLocale(), "oscarEncounter.Index.msgDocuments"));
    Dao.setLeftURL(url);
    
    
    //set the right hand heading link to call addDocument in index jsp
    winName = "addDoc" + bean.demographicNo;    
    url = "popupPage(500,1115,'" + winName + "','" + request.getContextPath() + "/dms/documentReport.jsp?" + 
            "function=demographic&doctype=lab&functionid=" + bean.demographicNo + "&curUser=" + bean.providerNo + "&mode=add" + 
            "&parentAjaxId=" + cmd + "');return false;";            
        
    Dao.setRightURL(url);
    Dao.setRightHeadingID(cmd); //no menu so set div id to unique id for this action
  
    StringBuffer javascript = new StringBuffer("<script type=\"text/javascript\">");    
    String js = "";
    Integer currentFacilityId=(Integer)request.getSession().getAttribute(SessionConstants.CURRENT_FACILITY_ID);
    ArrayList docList = EDocUtil.listDocs("demographic", bean.demographicNo, null, EDocUtil.PRIVATE, EDocUtil.SORT_OBSERVATIONDATE, "active", currentFacilityId);
    String dbFormat = "yyyy-MM-dd";
    String serviceDateStr = "";    
    String key;
    String title;
    int hash;
    String BGCOLOUR = request.getParameter("hC");
    Date date;
    for (int i=0; i< docList.size(); i++) {
        EDoc curDoc = (EDoc) docList.get(i);
        String dispFilename = curDoc.getFileName();
        String dispStatus   = String.valueOf(curDoc.getStatus());
        
        if( dispStatus.equals("A") )
            dispStatus = "active";
         else if( dispStatus.equals("H") )
            dispStatus="html";
                    
        String dispDocNo    = curDoc.getDocId();        
        title = StringUtils.maxLenString(curDoc.getDescription(), MAX_LEN_TITLE, CROP_LEN_TITLE, ELLIPSES);
        
        DateFormat formatter = new SimpleDateFormat(dbFormat);
        String dateStr = curDoc.getObservationDate();
        NavBarDisplayDAO.Item item = Dao.Item();                        
        try {
            date = (Date)formatter.parse(dateStr);
            serviceDateStr = DateUtils.getDate(date, dateFormat, request.getLocale());            
        }
        catch(ParseException ex ) {
            System.out.println("EctDisplayDocsAction: Error creating date " + ex.getMessage());
            serviceDateStr = "Error";
            date = null;
        }        

        String user = (String) request.getSession().getAttribute("user");
        item.setDate(date);
        hash = Math.abs(winName.hashCode());
        url = "popupPage(700,800,'" + hash + "', '" + request.getContextPath() + "/dms/ManageDocument.do?method=display&doc_no="+dispDocNo+"&providerNo="+user+ "');";
        item.setLinkTitle(title + serviceDateStr);
        item.setTitle(title);
        key = StringUtils.maxLenString(curDoc.getDescription(), MAX_LEN_KEY, CROP_LEN_KEY, ELLIPSES) + "(" + serviceDateStr + ")";
        key = StringEscapeUtils.escapeJavaScript(key);
        js = "itemColours['" + key + "'] = '" + BGCOLOUR + "'; autoCompleted['" + key + "'] = \"" + url + "\"; autoCompList.push('" + key + "');";        
        javascript.append(js);
        url += "return false;";
        item.setURL(url);        
        Dao.addItem(item);

    }                                
    javascript.append("</script>");
    
    Dao.setJavaScript(javascript.toString());
    return true;
        
  }
 
 public String getCmd() {
     return cmd;
 }
}
