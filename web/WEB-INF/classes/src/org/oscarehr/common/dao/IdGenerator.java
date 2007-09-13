package org.oscarehr.common.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.oscarehr.util.DbConnectionFilter;

import oscar.util.SqlUtils;

public class IdGenerator {
    public static final String GENERIC_SEQUENCE="HIBERNATE_SEQUENCE";
    
    public static int getNextIdFromGenericSequence() throws SQLException
    {
        return(getNextId(DbConnectionFilter.getThreadLocalDbConnection(), GENERIC_SEQUENCE));
    }
    
    public static int getNextIdFromGenericSequence(Connection c) throws SQLException
    {
        return(getNextId(c, GENERIC_SEQUENCE));
    }
    
    public static int getNextId(Connection c, String sequenceName) throws SQLException
    {
        PreparedStatement ps=c.prepareStatement("select "+sequenceName+".nextval from dual");
        ResultSet rs=null;
        try
        {
            rs=ps.executeQuery();
            rs.next();
            return(rs.getInt(1));
        }
        finally
        {
            SqlUtils.closeResources(ps, rs);
        }
    }
}
