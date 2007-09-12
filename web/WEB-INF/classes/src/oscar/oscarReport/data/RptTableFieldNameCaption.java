/*
 * Created on 2005-7-25
 */
package oscar.oscarReport.data;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Vector;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.oscarehr.util.DbConnectionFilter;

import oscar.login.DBHelp;

/**
 * @author yilee18
 */
public class RptTableFieldNameCaption {
    private static final Logger _logger = Logger.getLogger(RptTableFieldNameCaption.class);

    String table_name;
    String name;
    String caption;
    DBHelp dbObj = new DBHelp();

    public boolean insertOrUpdateRecord() throws SQLException {
        Connection c = DbConnectionFilter.getThreadLocalDbConnection();
        try {
            boolean ret = false;
            String sql = "select id from reportTableFieldCaption where table_name = '" + StringEscapeUtils.escapeSql(table_name) + "' and name='" + StringEscapeUtils.escapeSql(name) + "'";
            try {
                ResultSet rs = dbObj.searchDBRecord(c, sql);
                if (rs.next()) {
                    ret = insertRecord();
                }
                else {
                    ret = updateRecord();
                }
                rs.close();
            }
            catch (SQLException e) {
                _logger.error("insertOrUpdateRecord() : sql = " + sql);
            }
            return false;
        }
        finally {
            c.close();
        }
    }

    //`id` int(7) NOT NULL auto_increment,
    //`table_name` varchar(80) NOT NULL default '',
    //`name` varchar(80) NOT NULL default '',
    //`caption` varchar(80) NOT NULL default '',

    public boolean insertRecord() {
        boolean ret = false;
        String sql = "insert into reportTableFieldCaption (table_name, name, caption) values ('" + StringEscapeUtils.escapeSql(table_name) + "', '" + StringEscapeUtils.escapeSql(name) + "', '" + StringEscapeUtils.escapeSql(caption) + "')";
        try {
            ret = dbObj.updateDBRecord(sql);
        }
        catch (SQLException e) {
            _logger.error("insertRecord() : sql = " + sql);
        }
        return ret;
    }

    public boolean updateRecord() {
        boolean ret = false;
        String sql = "update reportTableFieldCaption set caption = '" + StringEscapeUtils.escapeSql(caption) + "' where table_name='" + StringEscapeUtils.escapeSql(table_name) + "' and name = '" + StringEscapeUtils.escapeSql(name) + "'";
        try {
            ret = dbObj.updateDBRecord(sql);
        }
        catch (SQLException e) {
            _logger.error("updateRecord() : sql = " + sql);
        }
        return ret;
    }

    // combine a table meta list and caption from table reportTableFieldCaption
    public Vector getTableNameCaption(String tableName) throws SQLException {
        Vector ret = new Vector();
        Vector vec = getMetaNameList(tableName);
        Properties prop = getNameCaptionProp(tableName);
        String temp = "";
        String tempName = "";
        for (int i = 0; i < vec.size(); i++) {
            tempName = (String)vec.get(i);
            if (tempName.matches(RptTableShadowFieldConst.fieldName)) {
                //System.out.println(rs.getString("name"));
                continue;
            }
            temp = prop.getProperty(tempName, "");
            temp += " |" + tempName;
            ret.add(temp);
        }
        return ret;
    }

    public Properties getNameCaptionProp(String tableName) throws SQLException {
        Connection c = DbConnectionFilter.getThreadLocalDbConnection();
        try {
            Properties ret = new Properties();
            String sql = "select name, caption from reportTableFieldCaption where table_name = '" + StringEscapeUtils.escapeSql(tableName) + "'";
            try {
                ResultSet rs = dbObj.searchDBRecord(c, sql);
                while (rs.next()) {
                    ret.setProperty(rs.getString("name"), rs.getString("caption"));
                }
                rs.close();
            }
            catch (SQLException e) {
                _logger.error("getNameCaptionProp() : sql = " + sql);
            }
            return ret;
        }
        finally {
            c.close();
        }
    }

    public Vector getMetaNameList(String tableName) throws SQLException {
        Connection c = DbConnectionFilter.getThreadLocalDbConnection();
        try {
            Vector ret = new Vector();
            String sql = "select * from " + tableName + " limit 1";
            try {
                ResultSet rs = dbObj.searchDBRecord(c, sql);
                ResultSetMetaData md = rs.getMetaData();
                for (int i = 1; i <= md.getColumnCount(); i++) {
                    ret.add(md.getColumnName(i));
                }
                rs.close();
            }
            catch (SQLException e) {
                _logger.error("getMetaNameList() : sql = " + sql);
            }
            return ret;
        }
        finally {
            c.close();
        }
    }

    public Vector getFormTableNameList() throws SQLException {
        Connection c = DbConnectionFilter.getThreadLocalDbConnection();
        try {
            Vector ret = new Vector();
            String sql = "select * from encounterForm where hidden != 0 order by form_name";
            ResultSet rs = dbObj.searchDBRecord(c, sql);
            while (rs.next()) {
                ret.add(rs.getString("form_name"));
                ret.add(rs.getString("form_table"));
            }
            rs.close();
            return ret;
        }
        finally {
            c.close();
        }
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTable_name() {
        return table_name;
    }

    public void setTable_name(String table_name) {
        this.table_name = table_name;
    }
}
