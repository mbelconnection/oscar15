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
// * McMaster Unviersity 
// * Hamilton 
// * Ontario, Canada 
// *
// -----------------------------------------------------------------------------------------------------------------------
package oscar.oscarDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;

import org.oscarehr.util.DbConnectionFilter;

import oscar.util.SqlUtils;

public class DBPreparedHandler {

    String connDriver = null; //"org.gjt.mm.mysql.Driver";
    String connURL = null; //"jdbc:mysql://";
    String connUser = null; //"mysql";
    String connPwd = null; //"oscar";
//    DBHandler db = null;

//    ResultSet rs = null;
//    Statement stmt = null;
//    PreparedStatement preparedStmt = null;

    public DBPreparedHandler(String dbDriver, String dbName, String dbUser, String dbPwd) throws SQLException {
//        try {
//            init(dbDriver, dbName, dbUser, dbPwd);
//        }
//        catch (Exception e) {
//            e.printStackTrace(System.out); // dump to the log file for debugging purposes
//            if (e.getClass().getName().equals("java.sql.SQLException")) {
//                throw new SQLException(e.getMessage());
//            }
//            else {
//                throw new SQLException(e.toString()); // cast all exceptions to SQLExceptions because having this function throw and Exception breaks too much code
//            }
//        }
    }

    private static Connection getConnection() throws SQLException
    {
        return(DbConnectionFilter.getThreadLocalDbConnection());
    }
    
//    public void init(String dbDriver, String dbUrl, String dbUser, String dbPwd) throws Exception, SQLException {
//        connDriver = dbDriver;
//        connURL = dbUrl;
//        connUser = dbUser;
//        connPwd = dbPwd;
//        OpenConn(connDriver, connURL, connUser, connPwd);
//    }

//    private void OpenConn(String dbDriver, String dbUrl, String dbUser, String dbPwd) throws Exception, SQLException {
//
//        //Class.forName(dbDriver);
//        //conn = DriverManager.getConnection(dbUrl, dbUser, dbPwd);         
//
//        if (!DBHandler.isInit()) {
//            //init(String db_name, String db_driver, String db_uri,String db_username, String db_password) {
//            DBHandler.init("", dbDriver, dbUrl, dbUser, dbPwd);
//        }
//        db = new DBHandler(DBHandler.OSCAR_DATA);
//
//        conn = db.GetConnection();
//
//    }

    synchronized public void queryExecute(String preparedSQL, String[] param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+Arrays.toString(param));
        Connection c=getConnection();
        PreparedStatement ps=null;
        try
        {
            ps = c.prepareStatement(preparedSQL);
            for (int i = 0; i < param.length; i++) {
                ps.setString((i + 1), param[i]);
                //System.out.println(param[i]);
            }
            ps.execute();
        }
        finally
        {
            SqlUtils.closeResources(c, ps, null);
        }
    }

    synchronized public int queryExecuteUpdate(String preparedSQL, String[] param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+Arrays.toString(param));
        Connection c=getConnection();
        PreparedStatement ps=null;
        try
        {
            ps = c.prepareStatement(preparedSQL);
            for (int i = 0; i < param.length; i++) {
                ps.setString((i + 1), param[i]);
                //System.out.println(param[i]);
            }
            return(ps.executeUpdate());
        }
        finally
        {
            SqlUtils.closeResources(c, ps, null);
        }
    }

    synchronized public int queryExecuteUpdate(String preparedSQL, int[] param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+Arrays.toString(param));
        Connection c=getConnection();
        PreparedStatement ps=null;
        try
        {
            ps = c.prepareStatement(preparedSQL);
            for (int i = 0; i < param.length; i++) {
                ps.setInt((i + 1), param[i]);
            }
            return(ps.executeUpdate());
        }
        finally
        {
            SqlUtils.closeResources(c, ps, null);
        }
    }

    synchronized public int queryExecuteUpdate(String preparedSQL, String[] param, int[] intparam) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+Arrays.toString(param));
        Connection c=getConnection();
        PreparedStatement ps=null;
        try
        {
            ps = c.prepareStatement(preparedSQL);
            for (int i = 0; i < param.length; i++) {
                ps.setString((i + 1), param[i]);
            }
            for (int i = 0; i < intparam.length; i++) {
                ps.setInt((param.length + i + 1), intparam[i]);
            }
            return(ps.executeUpdate());
        }
        finally
        {
            SqlUtils.closeResources(c, ps, null);
        }
    }

    synchronized public int queryExecuteUpdate(String preparedSQL, int[] intparam, String[] param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+Arrays.toString(param));
        Connection c=getConnection();
        PreparedStatement ps=null;
        try
        {
            ps = c.prepareStatement(preparedSQL);
            int i = 0;
            for (i = 0; i < intparam.length; i++) {
                ps.setInt((i + 1), intparam[i]);
            }
            for (i = 0; i < param.length; i++) {
                ps.setString((intparam.length + i + 1), param[i]);
            }
            return(ps.executeUpdate());
        }
        finally
        {
            SqlUtils.closeResources(c, ps, null);
        }
    }

    synchronized public ResultSet queryResults(String preparedSQL, String[] param, int[] intparam) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+Arrays.toString(param));
        int i = 0;
        PreparedStatement preparedStmt = getConnection().prepareStatement(preparedSQL);
        for (i = 0; i < param.length; i++) {
            preparedStmt.setString((i + 1), param[i]);
        }
        for (i = 0; i < intparam.length; i++) {
            preparedStmt.setInt((param.length + i + 1), intparam[i]);
        }
        return preparedStmt.executeQuery();
    }

    synchronized public ResultSet queryResults( String preparedSQL, int param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+param);
        PreparedStatement preparedStmt = getConnection().prepareStatement(preparedSQL);
        preparedStmt.setInt(1, param);
        return preparedStmt.executeQuery();
    }

    synchronized public ResultSet queryResults( String preparedSQL, int[] param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+Arrays.toString(param));
        PreparedStatement preparedStmt = getConnection().prepareStatement(preparedSQL);
        for (int i = 0; i < param.length; i++) {
            preparedStmt.setInt((i + 1), param[i]);
        }
        return(preparedStmt.executeQuery());
    }

    synchronized public ResultSet queryResults( String preparedSQL, String param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+param);
        PreparedStatement preparedStmt = getConnection().prepareStatement(preparedSQL);
        preparedStmt.setString(1, param);
        return preparedStmt.executeQuery();
    }

    synchronized public ResultSet queryResults( String preparedSQL, String[] param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+Arrays.toString(param));
        PreparedStatement preparedStmt = getConnection().prepareStatement(preparedSQL);
        for (int i = 0; i < param.length; i++) {
            preparedStmt.setString((i + 1), param[i]);
        }
        return preparedStmt.executeQuery();
    }

    synchronized public Object[] queryResultsCaisi( String preparedSQL, int param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+param);
        PreparedStatement preparedStmt = getConnection().prepareStatement(preparedSQL);
        preparedStmt.setInt(1, param);
        return new Object[] {preparedStmt.executeQuery(), preparedStmt};
    }

    synchronized public Object[] queryResultsCaisi( String preparedSQL, String param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+param);
        PreparedStatement preparedStmt = getConnection().prepareStatement(preparedSQL);
        preparedStmt.setString(1, param);
        return new Object[] {preparedStmt.executeQuery(), preparedStmt};
    }

    synchronized public Object[] queryResultsCaisi( String preparedSQL, String[] param) throws SQLException {
System.err.println("Query:"+preparedSQL);
System.err.println("Params:"+Arrays.toString(param));
        PreparedStatement preparedStmt = getConnection().prepareStatement(preparedSQL);
        for (int i = 0; i < param.length; i++) {
            preparedStmt.setString((i + 1), param[i]);
        }
        return new Object[] {preparedStmt.executeQuery(), preparedStmt};
    }

    synchronized public Object[] queryResultsCaisi( String preparedSQL) throws SQLException {
System.err.println("Query:"+preparedSQL);
        Statement stmt = getConnection().createStatement();
        return new Object[] {stmt.executeQuery(preparedSQL), stmt};
    }

    synchronized public ResultSet queryResults( String preparedSQL) throws SQLException {
System.err.println("Query:"+preparedSQL);
        Statement stmt = getConnection().createStatement();
        return stmt.executeQuery(preparedSQL);
    }

    // Don't forget to clean up!
    public void closePstmt() throws SQLException {
//        if (stmt != null) {
//            stmt.close();
//            stmt = null;
//        }
//        else {
//            preparedStmt.close();
//            preparedStmt = null;
//        }
    }

    /**
     * Returns a Connection instance
     * @return Connection
     * @throws SQLException 
     */
    public Connection getConn() throws SQLException {
        return getConnection();
    }

    public void closeConn() throws SQLException {
        //conn.close();
//        db.CloseConn();
//        conn = null;
    }

}
