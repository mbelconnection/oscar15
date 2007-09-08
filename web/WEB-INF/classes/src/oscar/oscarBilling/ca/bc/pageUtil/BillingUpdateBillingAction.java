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
// * McMaster University
// * Hamilton
// * Ontario, Canada
// *
// -----------------------------------------------------------------------------------------------------------------------

/*
 * BillingUpdateBillingAction.java
 *
 * Created on August 30, 2004, 1:52 PM
 */

package oscar.oscarBilling.ca.bc.pageUtil;

import java.io.*;
import java.sql.SQLException;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.struts.action.*;
import oscar.oscarBilling.ca.bc.MSP.*;
import oscar.oscarBilling.ca.bc.data.*;

/**
 *
 * @author  root
 */
public final class BillingUpdateBillingAction
    extends Action {
  HttpServletRequest request;
  public ActionForward execute(ActionMapping mapping,
                               ActionForm form,
                               HttpServletRequest request,
                               HttpServletResponse response) throws IOException,
      ServletException {
    BillingViewForm frm = (BillingViewForm)form;
    String creator = (String) request.getSession().getAttribute("user");

    BillRecipient recip = new BillRecipient();
    recip.setName(frm.getRecipientName());
    recip.setAddress(frm.getRecipientAddress());
    recip.setCity(frm.getRecipientCity());
    recip.setProvince(frm.getRecipientProvince());
    recip.setPostal(frm.getRecipientPostal());
    MSPReconcile msprec = new MSPReconcile();
    BillingViewBean bean = new BillingViewBean();
    bean.updateBill(frm.getBillingNo(),request.getParameter("billingProvider"));
    try {
        msprec.saveOrUpdateBillRecipient(recip);
    }
    catch (SQLException e1) {
        // TODO Auto-generated catch block
        e1.printStackTrace();
    }
    BillingNote n = new BillingNote();
    try {
      n.addNoteFromBillingNo(frm.getBillingNo(), creator, frm.getMessageNotes());
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    return mapping.findForward("success");
  }

  /** Creates a new instance of BillingUpdateBillingAction */
  public BillingUpdateBillingAction() {
  }

}
