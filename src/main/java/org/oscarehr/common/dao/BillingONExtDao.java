/**
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
 * This software is published under the GPL GNU General Public License.
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version. 
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */

package org.oscarehr.common.dao;


import java.util.List;
import javax.persistence.Query;
import org.oscarehr.common.model.BillingONCHeader1;
import org.oscarehr.common.model.BillingONExt;
import org.oscarehr.common.model.BillingPaymentType;
import org.oscarehr.common.model.BillingONPayment;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;
import org.springframework.stereotype.Repository;
import java.math.BigDecimal;
/**
 *
 * @author mweston4
 */
@Repository
public class BillingONExtDao extends AbstractDao<BillingONExt>{
    
    public BillingONExtDao() {
        super(BillingONExt.class);
    }
            
    public String getPayMethodDesc(BillingONExt bExt) {
        BillingPaymentTypeDao payMethod = (BillingPaymentTypeDao) SpringUtils.getBean("billingPaymentDao");
        Integer payMethodId = Integer.parseInt(bExt.getValue());
        BillingPaymentType payMethodDesc= payMethod.find(payMethodId);
        return payMethodDesc.getPaymentType();
    }
    
    public BigDecimal getPayment(BillingONPayment paymentRecord) {
        
        String sql = "select bExt from BillingONExt bExt where paymentId=? and billingNo=? and status=? and keyVal=?";
        Query query = entityManager.createQuery(sql);
        query.setParameter(1, paymentRecord.getId());
        query.setParameter(2, paymentRecord.getBillingNo());
        query.setParameter(3, '1');
        query.setParameter(4, "payment");
         
        @SuppressWarnings("unchecked")
        List<BillingONExt> results = query.getResultList();
        
        BigDecimal amtPaid = null;
        if (results.size() > 1) {
            MiscUtils.getLogger().warn("Multiple payments found for Payment Id:" + paymentRecord.getId());
        }
        
        if (results.isEmpty()) {
            amtPaid = new BigDecimal("0.00");
        } 
        else {
            BillingONExt payment = results.get(0);
            try {
                amtPaid = new BigDecimal(payment.getValue());
            } catch (NumberFormatException e) {
                MiscUtils.getLogger().warn("Payment not a valid currency amount (" + payment.getValue() + ") for Payment Id:" + paymentRecord.getId());
                amtPaid = new BigDecimal("0.00");
            }
        }
        return amtPaid;
    }
    
    public BigDecimal getRefund(BillingONPayment paymentRecord) {
        String sql = "select bExt from BillingONExt bExt where paymentId=? and billingNo=? and status=? and keyVal=?";
        Query query = entityManager.createQuery(sql);
        query.setParameter(1, paymentRecord.getId());
        query.setParameter(2, paymentRecord.getBillingNo());
        query.setParameter(3, '1');
        query.setParameter(4, "refund");
         
        @SuppressWarnings("unchecked")
        List<BillingONExt> results = query.getResultList();
        
        BigDecimal amtRefunded = null;
        if (results.size() > 1) {
              MiscUtils.getLogger().warn("Multiple payments found for Payment Id:" + paymentRecord.getId());
        } 
        
        if (results.isEmpty()) {
            amtRefunded = new BigDecimal("0.00");
        } else {
            BillingONExt refund = results.get(0);
            try {
                amtRefunded = new BigDecimal(refund.getValue());
            } catch (NumberFormatException e) {
                MiscUtils.getLogger().warn("Refund not a valid currency amount (" + refund.getValue() + ") for Payment Id:" + paymentRecord.getId());
                amtRefunded = new BigDecimal("0.00");
            }
        }
        return amtRefunded;
    }
    
    public BillingONExt getRemitTo(BillingONCHeader1 bCh1) {
        BillingONExt bExt = null;
        
        String sql = "select bExt from BillingONExt bExt where billingNo=? and status=? and keyVal=?";
        Query query = entityManager.createQuery(sql);
        query.setParameter(1, bCh1.getId());
        query.setParameter(2, '1');
        query.setParameter(3, "remitTo");
         
        @SuppressWarnings("unchecked")
        List<BillingONExt> results = query.getResultList();
        
        if (results.size() > 1) {
            MiscUtils.getLogger().warn("More than one active remit to result for invoice number: " + bCh1.getId());
        }
        
        if (!results.isEmpty())
            bExt = results.get(0);
        return bExt;
    }
    
    public BillingONExt getBillTo(BillingONCHeader1 bCh1) {
        BillingONExt bExt = null;
        
        String sql = "select bExt from BillingONExt bExt where billingNo=? and status=? and keyVal=?";
        Query query = entityManager.createQuery(sql);
        query.setParameter(1, bCh1.getId());
        query.setParameter(2, '1');
        query.setParameter(3, "billTo");
         
        @SuppressWarnings("unchecked")
        List<BillingONExt> results = query.getResultList();
        
        if (results.size() > 1) {
            MiscUtils.getLogger().warn("More than one active bill to result for invoice number: " + bCh1.getId());
        }
        
        if (!results.isEmpty())
            bExt = results.get(0);
        return bExt;
    }
    
    public BillingONExt getBillToInactive(BillingONCHeader1 bCh1) {
        BillingONExt bExt = null;
        
        String sql = "select bExt from BillingONExt bExt where billingNo=? and status=? and keyVal=?";
        Query query = entityManager.createQuery(sql);
        query.setParameter(1, bCh1.getId());
        query.setParameter(2, '0');
        query.setParameter(3, "billTo");
         
        @SuppressWarnings("unchecked")
        List<BillingONExt> results = query.getResultList();
        
        if (results.size() > 1) {
            MiscUtils.getLogger().warn("More than one inactive bill to result for invoice number: " + bCh1.getId());
        }
        
        if (!results.isEmpty())
            bExt = results.get(0);
        return bExt;
    }           
}
