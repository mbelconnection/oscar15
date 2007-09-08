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

package oscar.oscarBilling.ca.bc.pageUtil;

import java.sql.SQLException;

import javax.servlet.http.*;

import org.apache.struts.action.*;
import oscar.oscarBilling.ca.bc.data.*;

public class SupServiceCodeAssocAction
    extends Action {
  public ActionForward execute(ActionMapping actionMapping,
                               ActionForm actionForm,
                               HttpServletRequest servletRequest,
                               HttpServletResponse servletResponse) {
    SupServiceCodeAssocActionForm frm = (
        SupServiceCodeAssocActionForm) actionForm;

    SupServiceCodeAssocDAO dao = new SupServiceCodeAssocDAO();
    ActionForward fwd = actionMapping.findForward("success");
    if (!frm.MODE_VIEW.equals(frm.getActionMode())) {
      ActionMessages errors = frm.validate(actionMapping, servletRequest);
      if (!errors.isEmpty()) {
        this.saveErrors(servletRequest,errors);
        fwd = actionMapping.getInputForward();
      }
      else {
        if (frm.MODE_DELETE.equals(frm.getActionMode())) {
          dao.deleteServiceCodeAssociation(frm.getId());
        }
        else if (frm.MODE_EDIT.equals(frm.getActionMode())) {
          try {
            dao.saveOrUpdateServiceCodeAssociation(frm.getPrimaryCode(),
                                                     frm.getSecondaryCode());
        }
        catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        }
      }
    }

    servletRequest.setAttribute("list", dao.getServiceCodeAssociactions());
    return fwd;
  }
}
