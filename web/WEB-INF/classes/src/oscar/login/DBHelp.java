/*
 * Created on 2005-5-19
 *
 */
package oscar.login;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import oscar.oscarDB.DBHandler;

/**
 * @author yilee18
 */
public class DBHelp {
    private static final Logger _logger = Logger.getLogger(DBHelp.class);

    public synchronized boolean updateDBRecord(String sql) throws SQLException {
        boolean ret = false;
        DBHandler db = null;
        try {
            db = new DBHandler(DBHandler.OSCAR_DATA);
            ret = db.RunSQL(sql);
            ret = true;
        } catch (SQLException e) {
            e.printStackTrace();
            ret = false;
            System.out.println(e.getMessage());
        } finally {
            db.CloseConn();
        }
        return ret;
    }

    public synchronized ResultSet searchDBRecord(Connection c, String sql) throws SQLException {
        ResultSet ret = null;
        DBHandler db = null;

        db = new DBHandler(DBHandler.OSCAR_DATA);
           ret = db.GetSQL(c, sql);

           return ret;
    }

    public synchronized boolean updateDBRecord(String sql, String userId) throws SQLException {
        boolean ret = false;
        DBHandler db = null;
        try {
            db = new DBHandler(DBHandler.OSCAR_DATA);
            ret = db.RunSQL(sql);
            ret = true;
            _logger.info("updateDBRecord(sql = " + sql + ", userId = " + userId + ")");
        } catch (SQLException e) {
            e.printStackTrace();
            ret = false;
            _logger.error("updateDBRecord(sql = " + sql + ", userId = " + userId + ")");
        } finally {
            db.CloseConn();
        }
        return ret;
    }

    public synchronized ResultSet searchDBRecord(Connection c, String sql, String userId) throws SQLException {
        ResultSet ret = null;
        DBHandler db = null;
        try {
            db = new DBHandler(DBHandler.OSCAR_DATA);
            ret = db.GetSQL(c, sql);
            _logger.info("searchDBRecord(sql = " + sql + ", userId = " + userId + ")");
        } catch (SQLException e) {
            e.printStackTrace();
            _logger.error("searchDBRecord(sql = " + sql + ", userId = " + userId + ")");
        } finally {
            db.CloseConn();
        }
        return ret;
    }

}
