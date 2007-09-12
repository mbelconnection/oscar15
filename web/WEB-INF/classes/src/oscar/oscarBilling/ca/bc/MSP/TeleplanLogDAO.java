/*
 *  Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
 *  This software is published under the GPL GNU General Public License.
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 *  Jason Gallagher
 *
 *  This software was written for the
 *  Department of Family Medicine
 *  McMaster University
 *  Hamilton
 *  Ontario, Canada
 *
 * TeleplanLogDAO.java
 *
 * Created on January 27, 2007, 1:07 PM
 *
 */

package oscar.oscarBilling.ca.bc.MSP;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import org.oscarehr.util.DbConnectionFilter;

import oscar.util.SqlUtils;

/**
 +------------------+---------+------+-----+---------+----------------+
 | Field            | Type    | Null | Key | Default | Extra          |
 +------------------+---------+------+-----+---------+----------------+
 | log_no           | int(10) |      | PRI | NULL    | auto_increment |
 | claim            | blob    | YES  |     | NULL    |                |
 | sequence_no      | int(10) | YES  |     | NULL    |                |
 | billingmaster_no | int(10) | YES  |     | NULL    |                |
 +------------------+---------+------+-----+---------+----------------+

 * @author jay
 */

public class TeleplanLogDAO {

    /** Creates a new instance of TeleplanLogDAO */
    public TeleplanLogDAO() {
    }

    String nsql = "insert into log_teleplantx (sequence_no, claim,billingmaster_no) values (?,?,?)";

    public void save(TeleplanLog tl) throws SQLException {
        Connection c = DbConnectionFilter.getThreadLocalDbConnection();
        PreparedStatement ps = null;
        try {
            ps = c.prepareStatement(nsql);
            ps.setInt(1, tl.getSequenceNo());
            ps.setString(2, tl.getClaim());
            ps.setInt(3, tl.getBillingmasterNo());
            ps.executeUpdate();
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        finally {
            SqlUtils.closeResources(c, ps, null);
        }

    }

    public void save(List list) throws SQLException {
        Connection c = DbConnectionFilter.getThreadLocalDbConnection();
        PreparedStatement ps = null;
        try {
            ps = c.prepareStatement(nsql);
            System.out.println("LOG LIST SIZE" + list.size());
            for (int i = 0; i < list.size(); i++) {
                TeleplanLog tl = (TeleplanLog)list.get(i);
                ps.setInt(1, tl.getSequenceNo());
                ps.setString(2, tl.getClaim());
                ps.setInt(3, tl.getBillingmasterNo());
                ps.executeUpdate();
            }
        }
        catch (SQLException e) {
            System.out.append("LOG LIST NULL?" + list);
            e.printStackTrace();
        }
        finally {
            SqlUtils.closeResources(c, ps, null);
        }

    }
}
