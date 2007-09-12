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
 * BillActivityDAO.java
 *
 * Created on January 25, 2007, 12:10 PM
 *
 */

package oscar.oscarBilling.ca.bc.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.oscarehr.util.DbConnectionFilter;

import oscar.entities.Billactivity;
import oscar.util.SqlUtils;

/**
 *
 alter table billactivity add column id int(10) NOT NULL auto_increment
 primary key;
 *
 * @author jay
 */
public class BillActivityDAO {

    /** Creates a new instance of BillActivityDAO */
    public BillActivityDAO() {
    }

    public String getMonthCode() {
        return getMonthCode(new Date());
    }

    public String getMonthCode(Date d) {
        GregorianCalendar now = new GregorianCalendar();
        now.setTime(d);
        int curMonth = (now.get(Calendar.MONTH) + 1);
        String monthCode = "";
        if (curMonth == 1) monthCode = "A";
        else if (curMonth == 2) monthCode = "B";
        else if (curMonth == 3) monthCode = "C";
        else if (curMonth == 4) monthCode = "D";
        else if (curMonth == 5) monthCode = "E";
        else if (curMonth == 6) monthCode = "F";
        else if (curMonth == 7) monthCode = "G";
        else if (curMonth == 8) monthCode = "H";
        else if (curMonth == 9) monthCode = "I";
        else if (curMonth == 10) monthCode = "J";
        else if (curMonth == 11) monthCode = "K";
        else if (curMonth == 12) monthCode = "L";
        return monthCode;
    }

    public String getNextMonthlySequence(String billinggroup_no) throws SQLException {
        return getNextMonthlySequence(new Date(), billinggroup_no);
    }

    public String getNextMonthlySequence(Date d, String billinggroup_no) throws SQLException {
        String batchCount = "0";
        GregorianCalendar now = new GregorianCalendar();
        now.setTime(d);
        int curYear = now.get(Calendar.YEAR);

        Calendar beginningOfYear = Calendar.getInstance();
        beginningOfYear.set(Calendar.YEAR, curYear);
        //beginningOfYear.set(Calendar.MONTH,0);
        beginningOfYear.set(Calendar.DAY_OF_YEAR, 1);
        /////
        Connection c = DbConnectionFilter.getThreadLocalDbConnection();
        PreparedStatement ps=null;
        ResultSet rs=null;
        try {
            String s = "select * from billactivity where monthCode=? and groupno=? and updatedatetime > ? and status <> 'D' order by batchcount";
            ps = c.prepareStatement(s);
            ps.setString(1, getMonthCode(d));
            ps.setString(2, billinggroup_no);
            ps.setDate(3, new java.sql.Date(beginningOfYear.getTime().getTime()));

            rs = ps.executeQuery();
            while (rs.next()) {
                batchCount = rs.getString("batchcount");
            }
            int fileCount = Integer.parseInt(batchCount) + 1;
            batchCount = String.valueOf(fileCount);
        }
        catch (SQLException sqlexception) {
            System.out.println(sqlexception.getMessage());
        }
        finally
        {
            SqlUtils.closeResources(c, ps, rs);
        }
        return batchCount;
    }

    /*
     +----------------+-------------+------+-----+---------+-------+
     | Field          | Type        | Null | Key | Default | Extra |
     +----------------+-------------+------+-----+---------+-------+
     | monthCode      | char(1)     | YES  |     | NULL    |       |
     | batchcount     | int(3)      | YES  |     | NULL    |       |
     | htmlfilename   | varchar(50) | YES  |     | NULL    |       |
     | ohipfilename   | varchar(50) | YES  |     | NULL    |       |
     | providerohipno | varchar(6)  | YES  |     | NULL    |       |
     | groupno        | varchar(6)  | YES  |     | NULL    |       |
     | creator        | varchar(6)  | YES  |     | NULL    |       |
     | htmlcontext    | mediumtext  | YES  |     | NULL    |       |
     | ohipcontext    | mediumtext  | YES  |     | NULL    |       |
     | claimrecord    | varchar(10) | YES  |     | NULL    |       |
     | updatedatetime | datetime    | YES  |     | NULL    |       |
     | status         | char(1)     | YES  |     | NULL    |       |
     | total          | varchar(20) | YES  |     | NULL    |       |
     +----------------+-------------+------+-----+---------+-------+
     */
    public int saveBillactivity(String monthCode, String batchCount, String htmlFilename, String mspFilename, String providerNo, String htmlFile, String mspFile, Date date, int records, String fileTotal) throws SQLException {
        int id = 0;
        ////
        Connection c=DbConnectionFilter.getThreadLocalDbConnection();
        PreparedStatement ps=null;
        ResultSet rs=null;
        try {
            //1 2 3 4 5 6 7 8 9 0 1 2 3     
            String query = "insert into billactivity (monthCode,batchcount,htmlfilename,ohipfilename,providerohipno,groupno,creator,htmlcontext,ohipcontext,claimrecord,updatedatetime,status,total ) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";

            ps = c.prepareStatement(query);

            ps.setString(1, monthCode);
            ps.setString(2, batchCount);
            ps.setString(3, htmlFilename);//"H" + monthCode + proOHIP + "_" + Misc.forwardZero(batchCount,3) + ".htm");
            ps.setString(4, mspFilename);// "H" + monthCode + billinggroup_no + "." + Misc.forwardZero(batchCount,3));
            ps.setString(5, "");//proOHIP);
            ps.setString(6, "");//billinggroup_no);
            ps.setString(7, providerNo);
            ps.setString(8, htmlFile);
            ps.setString(9, mspFile);
            ps.setString(10, "" + records);
            ps.setDate(11, new java.sql.Date(date.getTime()));
            ps.setString(12, "A");
            ps.setString(13, fileTotal);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                id = rs.getInt(1);
            }
        }
        catch (SQLException sqlexception) {
            System.out.println(sqlexception.getMessage());
        }
        finally
        {
            SqlUtils.closeResources(c, ps, rs);
        }
        ////
        return id;
    }

    public List getBillactivityByYear(int year) {
        String startDate = year + "-01-01";
        String endDate = year + "/12/31 23:59:59";
        String query = "select * from billactivity where updatedatetime >= '" + startDate + "' and updatedatetime <= '" + endDate + "' and status <> 'D' order by updatedatetime desc";
        return getBillactivity(query);
    }

    public List getBillactivityByID(String id) {
        String query = "select * from billactivity where id='" + id + "'";
        return getBillactivity(query);
    }

    private List getBillactivity(String qry) {
        List res = SqlUtils.getBeanList(qry, Billactivity.class);
        return res;
    }

}
