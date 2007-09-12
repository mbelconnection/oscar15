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
 * Jason Gallagher
 *
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada   Creates a new instance of LabTag
 *
 *
 * TicklerTag.java
 *
 * Created on May 4, 2005, 11:15 AM
 */

package oscar.oscarTickler.tld;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import org.oscarehr.util.DbConnectionFilter;

import oscar.oscarDB.DBHandler;
import oscar.util.SqlUtils;

/**
 *
 * @author Jay Gallagher
 */
public class TicklerTag extends TagSupport {

    public TicklerTag() {
        numNewLabs = 0;
    }

    public int doStartTag() throws JspException {
        Connection c=null;
        ResultSet rs=null;
        try {
            c=DbConnectionFilter.getThreadLocalDbConnection();
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);

            String sql = new String("select count(*) from tickler where status = 'A' and service_date <= sysdate and task_assigned_to  = '" + providerNo + "' ");
            rs = db.GetSQL(c, sql);
            while (rs.next()) {
                numNewLabs = (rs.getInt(1));
            }
        }
        catch (SQLException e) {
            e.printStackTrace(System.out);
        }
        finally
        {
            SqlUtils.closeResources(c, null, rs);
        }
        try {
            JspWriter out = super.pageContext.getOut();
            if (numNewLabs > 0) out.print("<span class='tabalert'>  ");
            else out.print("<span>  ");
        }
        catch (Exception p) {
            p.printStackTrace(System.out);
        }
        return(EVAL_BODY_INCLUDE);
    }

    public void setProviderNo(String providerNo1) {
        providerNo = providerNo1;
    }

    public String getProviderNo() {
        return providerNo;
    }

    public int doEndTag() throws JspException {
        try {
            JspWriter out = super.pageContext.getOut();
            if (numNewLabs > 0) out.print("<sup>" + numNewLabs + "</sup></span>");
            else out.print("</span>");
        }
        catch (Exception p) {
            p.printStackTrace(System.out);
        }
        return EVAL_PAGE;
    }

    private String providerNo;
    private int numNewLabs;
}
