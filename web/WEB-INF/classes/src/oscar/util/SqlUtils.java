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
 * McMaster Unviersity
 * Hamilton
 * Ontario, Canada
 */

package oscar.util;

import java.io.*;
import java.lang.reflect.*;
import java.sql.*;
import java.sql.Date;
import java.text.*;
import java.util.*;
import java.util.logging.Level;

import org.apache.commons.lang.WordUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.*;
import org.hibernate.Session;
import org.oscarehr.PMmodule.web.ClientSearchAction2;

import oscar.oscarDB.*;

public class SqlUtils {
    private static Log logger = LogFactory.getLog(SqlUtils.class);

    static Category cat = Category.getInstance(SqlUtils.class.getName());

    Connection conn = null;

    public SqlUtils() {
    }

    public boolean executeUpdate(String[] param) {
        boolean result = false;
        if (prepareSQL()) {
            if (executeUpdateSQL(param)) {
                result = true;
            }
            unPrepareSQL();
        }
        return result;
    }

    public boolean executeUpdate(String param) {
        boolean result = false;
        if (prepareSQL()) {
            if (executeUpdateSQL(param)) {
                result = true;
            }
            unPrepareSQL();
        }
        return result;
    }

    public ArrayList executeSelect(String param) {
        ArrayList result = null;
        if (prepareSQL()) {
            result = executeSelectSQL(param);
            unPrepareSQL();
        }
        return result;
    }

    public static ArrayList executeSelect(String param, Connection conn) {
        ArrayList result = null;
        if (conn != null) {
            result = executeSelectSQL(param, conn);
        }
        return result;
    }

    private boolean prepareSQL() {
        conn = SqlUtils.getConnection();
        if (conn == null) {
            cat.fatal("Sem conexao.");
            return false;
        }
        return true;
    }

    private boolean unPrepareSQL() {
        if (conn != null) {
            SqlUtils.freeConnection(conn);
            return false;
        }
        return true;
    }

    private boolean executeUpdateSQL(String[] sqlCommands) {
        Statement stmt = null;
        try {
            conn.setAutoCommit(false);
            if (sqlCommands != null) {
                for (int i = 0; i < sqlCommands.length; i++) {
                    cat.debug(sqlCommands[i]);
                    stmt = conn.createStatement();
                    stmt.executeUpdate(sqlCommands[i]);
                    stmt.close();
                    stmt = null;
                }
                conn.commit();
            }
            return true;
        }
        catch (Exception e) {
            try {
                conn.rollback();
            }
            catch (Exception e2) {
                return false;
            }
            cat.error("Transacao nao executada.", e);
            return false;
        }
        finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
                conn.setAutoCommit(true);
            }
            catch (Exception e3) {
            };
        }
    }

    private boolean executeUpdateSQL(String sqlCommand) {
        Statement stmt = null;
        try {
            stmt = conn.createStatement();
            stmt.executeUpdate(sqlCommand);
            stmt.close();
            stmt = null;
            cat.debug(sqlCommand);
            return true;
        }
        catch (Exception e) {
            cat.error("Comando no ejecutado.", e);
            cat.debug(sqlCommand);
            return false;
        }
        finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
            }
            catch (Exception e3) {
            };
        }
    }

    private ArrayList executeSelectSQL(String sqlCommand) {
        Statement stmt = null;
        ResultSet rset = null;
        ArrayList records = new ArrayList();
        try {
            cat.debug("vai executar select");
            stmt = conn.createStatement();
            rset = stmt.executeQuery(sqlCommand);
            int cols = rset.getMetaData().getColumnCount();
            while (rset.next()) {
                String[] record = new String[cols];
                for (int i = 0; i < cols; i++) {
                    record[i] = rset.getString(i + 1);
                }
                records.add(record);
            }
            stmt.close();
            stmt = null;
            rset.close();
            rset = null;
            cat.debug(sqlCommand);
            return records;
        }
        catch (Exception e) {
            cat.error("Comando no ejecutado.", e);
            cat.debug(sqlCommand);
            return null;
        }
        finally {
            try {
                if (rset != null) {
                    rset.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
            }
            catch (Exception e3) {
            };
        }
    }

    private static ArrayList executeSelectSQL(String sqlCommand, Connection conn) {
        Statement stmt = null;
        ResultSet rset = null;
        ArrayList records = new ArrayList();
        try {
            cat.debug("vai executar select");
            stmt = conn.createStatement();
            rset = stmt.executeQuery(sqlCommand);
            int cols = rset.getMetaData().getColumnCount();
            while (rset.next()) {
                String[] record = new String[cols];
                for (int i = 0; i < cols; i++) {
                    record[i] = rset.getString(i + 1);
                }
                records.add(record);
            }
            stmt.close();
            stmt = null;
            rset.close();
            rset = null;
            cat.debug(sqlCommand);
            return records;
        }
        catch (Exception e) {
            cat.error("Comando no ejecutado.", e);
            cat.debug(sqlCommand);
            return null;
        }
        finally {
            try {
                if (rset != null) {
                    rset.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
            }
            catch (Exception e3) {
            };
        }
    }

    public static Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection("jdbc:protomatter:pool:postgresPool");
            cat.debug("conexao obtida");
        }
        catch (SQLException e) {
            cat.error("Nao foi possivel obter a conexao do pool ", e);
        }
        if (conn == null) {
            return null;
        }
        else {
            return conn;
        }
    }

    public static void freeConnection(Connection conn) {
        try {
            if (conn != null) {
                conn.close();
                cat.debug("conexao devolvida");
            }
        }
        catch (SQLException e) {
            cat.error("Nao foi possivel obter a conexao do pool ", e);
        }
    }

    public static String getLastIdInserted(String noSeq, Connection conn) {
        if (noSeq == null) {
            cat.debug("[SqlUtils] - sequence nula");
            return null;
        }
        ArrayList sqlArray = SqlUtils.executeSelect("select currval('" + noSeq + "')", conn);
        if (sqlArray != null) {
            if (sqlArray.size() == 1) {
                String[] recordValue = (String[])sqlArray.get(0);
                return recordValue[0];
            }
            else {
                cat.debug("[SqlUtils] - select currval('" + noSeq + "') retornou mais q um registro.");
            }
        }
        else {
            cat.debug("[SqlUtils] - select currval('" + noSeq + "') nao foi executado.");
        }
        return null;
    }

    private static java.sql.Date createAppropriateDate(Object value) {
        if (value == null) {
            return null;
        }
        String valueStr = ((String)value).trim();
        if (valueStr.length() == 0) {
            return null;
        }
        SimpleDateFormat sdf = DateUtils.getDateFormatter();
        Date result = null;
        try {
            result = new java.sql.Date(sdf.parse(valueStr).getTime());
        }
        catch (Exception exc) {
            result = null;
        }
        if (result == null) {
            // Maybe date has been returned as a timestamp?
            try {
                result = new java.sql.Date(java.sql.Timestamp.valueOf(valueStr).getTime());
            }
            catch (java.lang.IllegalArgumentException ex) {
                // Try date
                cat.info("date = " + valueStr);
                result = java.sql.Date.valueOf(valueStr);
            }
        }
        return result;
    }

    private static java.math.BigDecimal createAppropriateNumeric(Object value) {
        if (value == null) {
            return null;
        }
        String valueStr = ((String)value).trim();
        if (valueStr.length() == 0) {
            return null;
        }
        return new java.math.BigDecimal(valueStr);
    }

    /**
     this utility-method assigns a particular value to a place holder of a PreparedStatement.
     it tries to find the correct setXxx() value, accoring to the field-type information
     represented by "fieldType".
     quality: this method is bloody alpha (as you migth see :=)
     */
    public static void fillPreparedStatement(PreparedStatement ps, int col, Object val, int fieldType) throws SQLException {
        try {
            cat.info("fillPreparedStatement( ps, " + col + ", " + val + ", " + fieldType + ")...");
            Object value = null;
            //Check for hard-coded NULL
            if (!("$null$".equals(val))) {
                value = val;
            }
            if (value != null) {
                switch (fieldType) {
                    case FieldTypes.INTEGER:
                        ps.setInt(col, Integer.parseInt((String)value));
                    break;
                    case FieldTypes.NUMERIC:
                        ps.setBigDecimal(col, createAppropriateNumeric(value));
                    break;
                    case FieldTypes.CHAR:
                        ps.setString(col, (String)value);
                    break;
                    case FieldTypes.DATE:
                        ps.setDate(col, createAppropriateDate(value));
                    break; //#checkme
                    case FieldTypes.TIMESTAMP:
                        ps.setTimestamp(col, java.sql.Timestamp.valueOf((String)value));
                    break;
                    case FieldTypes.DOUBLE:
                        ps.setDouble(col, Double.valueOf((String)value).doubleValue());
                    break;
                    case FieldTypes.FLOAT:
                        ps.setFloat(col, Float.valueOf((String)value).floatValue());
                    break;
                    case FieldTypes.LONG:
                        ps.setLong(col, Long.parseLong(String.valueOf(value)));
                    break;
                    case FieldTypes.BLOB:
                        FileHolder fileHolder = (FileHolder)value;
                        try {
                            ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
                            ObjectOutputStream out = new ObjectOutputStream(byteOut);
                            out.writeObject(fileHolder);
                            out.flush();
                            byte[] buf = byteOut.toByteArray();
                            byteOut.close();
                            out.close();
                            ByteArrayInputStream bytein = new ByteArrayInputStream(buf);
                            int byteLength = buf.length;
                            ps.setBinaryStream(col, bytein, byteLength);
                            // store fileHolder as a whole (this way we don't lose file meta-info!)
                        }
                        catch (IOException ioe) {
                            ioe.printStackTrace();
                            cat.info(ioe.toString());
                            throw new SQLException("error storing BLOB in database - " + ioe.toString(), null, 2);
                        }
                    break;
                    case FieldTypes.DISKBLOB:
                        ps.setString(col, (String)value);
                    break;
                    default:
                        ps.setObject(col, value); //#checkme
                }
            }
            else {
                switch (fieldType) {
                    case FieldTypes.INTEGER:
                        ps.setNull(col, java.sql.Types.INTEGER);
                    break;
                    case FieldTypes.NUMERIC:
                        ps.setNull(col, java.sql.Types.NUMERIC);
                    break;
                    case FieldTypes.CHAR:
                        ps.setNull(col, java.sql.Types.CHAR);
                    break;
                    case FieldTypes.DATE:
                        ps.setNull(col, java.sql.Types.DATE);
                    break;
                    case FieldTypes.TIMESTAMP:
                        ps.setNull(col, java.sql.Types.TIMESTAMP);
                    break;
                    case FieldTypes.DOUBLE:
                        ps.setNull(col, java.sql.Types.DOUBLE);
                    break;
                    case FieldTypes.FLOAT:
                        ps.setNull(col, java.sql.Types.FLOAT);
                    break;
                    case FieldTypes.BLOB:
                        ps.setNull(col, java.sql.Types.BLOB);
                    case FieldTypes.DISKBLOB:
                        ps.setNull(col, java.sql.Types.CHAR);
                    default:
                        ps.setNull(col, java.sql.Types.OTHER);
                }
            }
        }
        catch (Exception e) {
            throw new SQLException("Field type seems to be incorrect - " + e.toString(), null, 1);
        }
    }

    /**
     * A simple and convenient method for retrieving object by criteria from the database.
     * The ActiveRecord pattern is assumed whereby and object represents a row in the database.<p>
     *
     * @param qry String
     * @param classType Class
     * @return List
     */
    public static List getBeanList(String qry, Class classType) {
        ArrayList rec = new ArrayList();
        int colCount = 0;
        ResultSet rs = null;
        DBHandler db = null;
        try {
            db = new DBHandler(DBHandler.OSCAR_DATA);
            rs = (ResultSet)db.GetSQL(qry);
            ResultSetMetaData rsmd = rs.getMetaData();
            colCount = rsmd.getColumnCount();

            while (rs.next()) {
                int recordCount = 0; //used to check if an objects methods have been determined
                Object obj = null;
                Method method[] = null;
                Hashtable methodNameMap = new Hashtable(colCount);
                obj = classType.newInstance();
                Class cls = obj.getClass();
                method = cls.getDeclaredMethods();
                //iterate through each field in record and set data in the appropriate
                //object field. Each matching method name is to be placed in a list of method names
                //to be used in subsequent iterations. This will reduce the overhead in having to search those names needlessly
                for (int i = 0; i < colCount; i++) {
                    String colName = rsmd.getColumnName(i + 1);
                    Object value = getNewType(rs, i + 1);

                    //if  this is the first record, get list of method names in object
                    // and perform method invocation

                    if (recordCount == 0) {
                        for (int j = 0; j < method.length; j++) {
                            String methodName = method[j].getName();
                            char[] b = {'_'};
                            String columnCase = WordUtils.capitalize(colName, b);
                            columnCase = org.apache.commons.lang.StringUtils.remove(columnCase, '_');
                            columnCase = org.apache.commons.lang.StringUtils.capitalize(columnCase);

                            if (methodName.equalsIgnoreCase("set" + colName)) {
                                method[j].invoke(obj, new Object[] {value});
                                methodNameMap.put(new Integer(j), methodName);
                            }
                            else if (methodName.equalsIgnoreCase("set" + columnCase)) {
                                method[j].invoke(obj, new Object[] {value});
                                methodNameMap.put(new Integer(j), methodName);
                            }
                        }
                    }
                    //else method names have been determined so perform invocations based on list
                    else {
                        for (Enumeration keys = methodNameMap.keys(); keys.hasMoreElements();) {
                            Integer key = (Integer)keys.nextElement();
                            System.out.println(method[key.intValue()].getName() + " value  " + value.getClass().getName());
                            method[key.intValue()].invoke(obj, new Object[] {value});
                        }
                    }
                }
                rec.add(obj);
                recordCount++;
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
        catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        catch (InstantiationException e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (db != null) {
                    db.CloseConn();
                }

                if (rs != null) {
                    rs.close();
                }
            }
            catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return rec;
    }

    private static Object getNewType(ResultSet rs, int colNum) {
        int type = 0;
        try {
            type = rs.getMetaData().getColumnType(colNum);
            switch (type) {
                case Types.LONGVARCHAR:
                case Types.CHAR:
                case Types.VARCHAR:
                    return rs.getString(colNum);
                case Types.TINYINT:
                case Types.SMALLINT:
                case Types.INTEGER:
                    return new Integer(rs.getInt(colNum));
                case Types.BIGINT:
                    return new Long(rs.getLong(colNum));
                case Types.FLOAT:
                case Types.DECIMAL:
                case Types.REAL:
                case Types.DOUBLE:
                case Types.NUMERIC:
                    return new Double(rs.getDouble(colNum));
                    // case Types.B
                case Types.BIT:
                    return new Boolean(rs.getBoolean(colNum));
                case Types.TIMESTAMP:
                case Types.DATE:
                case Types.TIME:
                    return rs.getDate(colNum);
                default:
                    return rs.getObject(colNum);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Returns a List of String[] which contain the results of the specified arbitrary query.
     *
     * @param qry String - The String SQL Query
     * @return List - The List of Srting[] results or null if no results were yielded
     */
    public static List getQueryResultsList(String qry) {
        ArrayList records = null;
        ResultSet rs = null;
        DBHandler db = null;
        try {
            records = new ArrayList();
            db = new DBHandler(DBHandler.OSCAR_DATA);
            rs = (ResultSet)db.GetSQL(qry);
            int cols = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                String[] record = new String[cols];
                for (int i = 0; i < cols; i++) {
                    record[i] = rs.getString(i + 1);
                }
                records.add(record);
            }
        }
        catch (SQLException e) {
            records = null;
            e.printStackTrace();
        }
        finally {
            if (db != null) {
                try {
                    db.CloseConn();
                }
                catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            if (rs != null) {
                try {
                    rs.close();
                }
                catch (SQLException ex1) {
                    ex1.printStackTrace();
                }
            }
            if (records != null) {
                records = records.isEmpty()?null:records;
            }
            return records;
        }
    }

    /**
     * Returns a single row(the first row) from a quesry result
     * Generally should only be used with queries that return a single result
     * Returns null if there is no result
     * @param qry String
     * @return String[]
     */
    public static String[] getRow(String qry) {
        String ret[] = null;
        List list = getQueryResultsList(qry);
        if (list != null) {
            ret = (String[])list.get(0);
        }
        return ret;
    }

    /**
     * Returns a List of Map objects which contain the results of the specified arbitrary query.
     *The key contains the field names of the table and the value, the field value of the record
     * @param qry String - The String SQL Query
     * @return List - The List of String Map results or null if no results were yielded
     */
    public static List getQueryResultsMapList(String qry) {
        List records = null;
        ResultSet rs = null;
        DBHandler db = null;
        try {
            records = new ArrayList();
            db = new DBHandler(DBHandler.OSCAR_DATA);
            rs = (ResultSet)db.GetSQL(qry);
            int cols = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                Properties record = new Properties();
                for (int i = 0; i < cols; i++) {
                    String columnName = rs.getMetaData().getColumnName(i + 1);
                    String cellValue = rs.getString(i + 1);
                    if (columnName != null && !"".equals(columnName)) {

                        cellValue = cellValue == null?"":cellValue;
                        record.setProperty(columnName, cellValue);
                    }
                    else {
                        System.out.println("Empty key for value: " + cellValue);
                    }
                }
                records.add(record);
            }
        }
        catch (SQLException e) {
            records = null;
            e.printStackTrace();
        }
        finally {
            if (db != null) {
                try {
                    db.CloseConn();
                }
                catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            if (rs != null) {
                try {
                    rs.close();
                }
                catch (SQLException ex1) {
                    ex1.printStackTrace();
                }
            }

            return records;
        }
    }

    /**
     * Creates an 'in' clause segment of an sql query.
     * This is handy in cases where the criteria of a query is dynamic/unknown
     * @param criteria String[] - he string array of criteria used to construct the query segment
     * @param type int - a value of true indicates that the clause components are enclosed in quotes
     * @return String - The constructed sql 'in' clause String
     */
    public static String constructInClauseString(String[] criteria, boolean useQuotes) {
        StringBuffer ret = new StringBuffer();
        String quote = useQuotes == true?"'":"";
        if (criteria.length != 0) {
            ret.append("in (");
            for (int i = 0; i < criteria.length; i++) {
                ret.append(quote + criteria[i] + quote);
                if (i < criteria.length - 1) {
                    ret.append(",");
                }
            }
        }
        ret.append(")");
        return ret.toString();
    }

    /**
     * This method will return a string similar 
     * to "(?,?,?,?)". The intent is that this 
     * method will be used to build "in clauses"
     * like select * from foo where x in (?,?,?)
     * for prepared statements.
     */
    public static String constructInClauseForPreparedStatements(int numberOfParameters) {
        if (numberOfParameters <= 0) throw (new IllegalArgumentException("Don't call this method if the numberOfParameters is <1 it doesn't make sense."));

        StringBuilder sb = new StringBuilder();
        sb.append('(');

        for (int i = 0; i < numberOfParameters; i++) {
            if (i > 0) sb.append(',');
            sb.append('?');
        }

        sb.append(')');
        return(sb.toString());
    }

    /**
     * This method will close the resources passed in.
     * Pass in null for anything you don't want closed.
     * All exceptions will be logged at WARN level but not 
     * rethrown. Note that if you retrieved the connection
     * from something like hibernate/jpa you should 
     * not close the connection, let the entityManager / sessionManager do that, 
     * just close the statement and resultset.
     */
    public static void closeResources(Connection c, Statement s, ResultSet rs) {
        closeResources(s, rs);

        if (c != null) {
            try {
                c.close();
            }
            catch (Exception e) {
                if (e.getMessage().toLowerCase().indexOf("closed") >= 0) {
                    // I don't care.
                }
                else {
                    logger.warn("Error closing Connection.", e);
                }
            }
        }
    }

    public static void closeResources(Session session, Statement s, ResultSet rs) {
        closeResources(s, rs);

        if (session != null) {
            session.close();
        }
    }

    public static void closeResources(Statement s, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            }
            catch (SQLException e) {
                logger.warn("Error closing ResultSet.", e);
            }
        }

        if (s != null) {
            try {
                s.close();
            }
            catch (SQLException e) {
                logger.warn("Error closing Statement.", e);
            }
        }
    }
    
    public static String isoToOracleDate(String isoDate) throws ParseException
    {
        SimpleDateFormat isoFormat=new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date date=isoFormat.parse(isoDate);
        
        SimpleDateFormat oracleFormat=new SimpleDateFormat("dd-MMM-yyyy");
        return(oracleFormat.format(date));
    }
    
    public static void main(String... argv) throws Exception
    {
        String x="2006-05-04";
        
        System.err.println(isoToOracleDate(x));
    }
}
