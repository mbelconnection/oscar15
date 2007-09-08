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
 * TeleplanSequenceDAO.java
 *
 * Created on January 31, 2007, 12:01 AM
 *
 */

package oscar.oscarBilling.ca.bc.Teleplan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.oscarehr.util.SpringUtils;

import oscar.oscarDB.DBHandler;
import oscar.util.SqlUtils;

/**
 
 CREATE TABLE `teleplan_response_log` (
 `id` int(10) NOT NULL auto_increment,
 `transaction_no` varchar(255),
 `result` varchar(255),
 `filename` varchar(255),
 `real_filename` varchar(255),
 `msgs`  varchar(255),
 PRIMARY KEY  (`id`)
 ) ;
 
 *
 *  Deals with storing the teleplan sequence #
 * @author jay
 */
public class TeleplanResponseDAO {

    /** Creates a new instance of TeleplanSequenceDAO */
    public TeleplanResponseDAO() {
    }

    public void save(TeleplanResponse tr) throws SQLException {
        Connection c = SpringUtils.getDbConnection();
        PreparedStatement ps = null;
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String query = "insert into teleplan_response_log (transaction_no,result,filename,msgs,real_filename) values (?,?,?,?,?)";
            ps = c.prepareStatement(query);
            ps.setString(1, tr.getTransactionNo());
            ps.setString(2, tr.getResult());
            ps.setString(3, tr.getFilename());
            ps.setString(4, tr.getMsgs());
            ps.setString(5, tr.getRealFilename());
            ps.executeUpdate();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            SqlUtils.closeResources(c, ps, null);
        }
    }
}
