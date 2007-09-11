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

import oscar.oscarDB.DBHandler;
import oscar.oscarDB.DBPreparedHandler;

import java.sql.*;
import java.util.Properties;


public class DAO {
    private DBHandler dBHandler;
    private DBPreparedHandler dBPreparedHandler;
    private Properties pvar;

    public DAO(Properties pvar) throws SQLException {
		this.pvar = pvar;
		oscar.oscarDB.DBHandler.init(pvar.getProperty("db_name"),pvar.getProperty("db_driver"),pvar.getProperty("db_uri"),pvar.getProperty("db_username"),pvar.getProperty("db_password")  ) ;
		
    }

    protected void close(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
            }

            rs = null;
        }
    }

    protected void close(PreparedStatement pstmt) {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
            }

            pstmt = null;
        }
    }

    protected void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }

            conn = null;
        }
    }

    protected void rollback(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }

            conn = null;
        }
    }

    /**
     * @return
     */
    public DBHandler getDb() throws SQLException {
		return dBHandler = new DBHandler(DBHandler.OSCAR_DATA);
    }

    /**
     * @param handler
     */
    public void setDb(DBHandler handler) {
        dBHandler = handler;
    }

    /**
     * @return
     */
    public DBPreparedHandler getDBPreparedHandler() throws SQLException {
        return new DBPreparedHandler(pvar.getProperty("db_driver"),pvar.getProperty("db_uri") + pvar.getProperty("db_name"),pvar.getProperty("db_username"),pvar.getProperty("db_password"));
    }

    /**
     * @param handler
     */
    public void setDBPreparedHandler(DBPreparedHandler handler) {
        dBPreparedHandler = handler;
    }

    protected String getStrIn(String[] ids) {
        String id = "";

        for (int i = 0; i < ids.length; i++) {
            if (i == 0) {
                id = ids[i];
            } else {
                id = id + "," + ids[i];
            }
        }

        return id;
    }
}
