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

package oscar.oscarBilling.ca.bc.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.oscarehr.util.DbConnectionFilter;

import oscar.oscarDB.DBHandler;
import oscar.util.SqlUtils;

/**
 * <p>Description: </p>
 * Some Procedures are automatically associated with certain tray fees
 * SupServiceCodeAssocDAO is responsible for performing CRUD operations on
 * Billing Procedure/Tray Fee Associations.
 * @author not attributable
 * @version 1.0
 */
public class SupServiceCodeAssocDAO {
    public static final int VALUE_BY_CODE = 1;
    public static final int VALUE_BY_ID = 2;

    public SupServiceCodeAssocDAO() {
    }

    /**
     * Returns a List of available procedure code/tray fee code associations in the form of a HashMap
     * @return List
     */
    public List getServiceCodeAssociactions() {
        //select billingServiceNo,billingServiceTrayNo,billingServiceNo as associationStatus from billing_trayfees");
        List list = SqlUtils.getQueryResultsList("select id,billingServiceNo,billingServiceTrayNo from billing_trayfees");
        List ret = new ArrayList();

        if (list != null) {
            for (Iterator iter = list.iterator(); iter.hasNext();) {
                String[] item = (String[])iter.next();
                if (item != null && item.length > 0) {
                    HashMap map = new HashMap();
                    map.put("id", item[0]);
                    map.put("billingServiceNo", this.getBillingServiceValue(item[1], this.VALUE_BY_ID));
                    map.put("billingServiceTrayNo", this.getBillingServiceValue(item[2], this.VALUE_BY_ID));
                    map.put("associationStatus", "");
                    ret.add(map);
                }
            }
        }
        return ret;
    }

    /**
     * Returns a Map of ServiceCode associations
     * Key = Service Code
     * Value = Tray Fee
     * @return Map
     */
    public Map getAssociationKeyValues() {
        //
        List list = SqlUtils.getQueryResultsList("select billingServiceNo,billingServiceTrayNo from billing_trayfees");
        HashMap ret = new HashMap();
        if (list != null) {
            for (Iterator iter = list.iterator(); iter.hasNext();) {
                String[] item = (String[])iter.next();
                if (item != null && item.length > 0) {
                    ret.put(this.getBillingServiceValue(item[0], this.VALUE_BY_ID), this.getBillingServiceValue(item[1], this.VALUE_BY_ID));
                }
            }
        }
        return ret;
    }

    /**
     * Saves or updates(if exists) a procedure/tray fee association
     * @param primaryCode String
     * @param secondaryCode String
     * @throws SQLException 
     */
    public void saveOrUpdateServiceCodeAssociation(String primaryCode, String secondaryCode) throws SQLException {
        ResultSet rs = null;
        PreparedStatement ps = null;

        String primaryCodeId = this.getBillingServiceValue(primaryCode, this.VALUE_BY_CODE);
        String secondaryCodeId = this.getBillingServiceValue(secondaryCode, this.VALUE_BY_CODE);

        Connection c=DbConnectionFilter.getThreadLocalDbConnection();
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            rs = db.GetSQL(c, "select billingServiceNo,billingServiceTrayNo from billing_trayfees where billingServiceNo = " + primaryCodeId);

            //Record exists so perform an update
            if (rs.next()) {
                ps = c.prepareStatement("update billing_trayfees set billingServiceTrayNo = ? where billingServiceNo=?");
                ps.setString(1, secondaryCodeId);
                ps.setString(2, primaryCodeId);
            }
            else {
                //create a new record
                ps = c.prepareStatement("insert into billing_trayfees(billingServiceNo,billingServiceTrayNo) " + "values(?,?)");
                ps.setString(1, primaryCodeId);
                ps.setString(2, secondaryCodeId);
            }
            ps.execute();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            SqlUtils.closeResources(c, ps, rs);
        }
    }

    /**
     * Returns the monetary value of the specified service code
     *
     * @param primaryCode String - The Service Code
     * @param type int - The type of query to perform using either the billingservice_no or service_code fields
     * as criterion for searching the code value
     * @return String
     */
    private String getBillingServiceValue(String code, int type) {
        String ret = "";
        String criteria = type == this.VALUE_BY_CODE?"service_code":"billingservice_no";
        String select = type == this.VALUE_BY_CODE?"billingservice_no":"service_code";
        List results = SqlUtils.getQueryResultsList("select " + select + " from billingservice where " + criteria + "= '" + code + "'");
        if (results != null && !results.isEmpty()) {
            String[] strArr = (String[])results.get(0);
            if (strArr.length > 0) {
                ret = strArr[0];
            }
        }
        return ret;
    }

    /**
     * Removes a service code association
     * @param id String - The id of the service code
     */
    public void deleteServiceCodeAssociation(String id) {
        String qry = "delete from billing_trayfees where id = " + id;
        DBHandler db = null;
        try {
            db = new DBHandler(DBHandler.OSCAR_DATA);
            db.RunSQL(qry);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (db != null) {
                    db.CloseConn();
                }
            }
            catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
