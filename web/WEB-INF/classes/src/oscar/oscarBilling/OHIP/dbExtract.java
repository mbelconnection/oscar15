// -----------------------------------------------------------------------------------------------------------------------
// *
// *
// * Copyright (c) 2001-2002. Department of Family Medicine, McMaster
// University. All Rights Reserved. *
// * This software is published under the GPL GNU General Public License.
// * This program is free software; you can redistribute it and/or
// * modify it under the terms of the GNU General Public License
// * as published by the Free Software Foundation; either version 2
// * of the License, or (at your option) any later version. *
// * This program is distributed in the hope that it will be useful,
// * but WITHOUT ANY WARRANTY; without even the implied warranty of
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// * GNU General Public License for more details. * * You should have received
// a copy of the GNU General Public License
// * along with this program; if not, write to the Free Software
// * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
// *
// *
// * <OSCAR TEAM>
// * This software was written for the
// * Department of Family Medicine
// * McMaster Unviersity
// * Hamilton
// * Ontario, Canada
// *
// -----------------------------------------------------------------------------------------------------------------------
package oscar.oscarBilling.OHIP;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.oscarehr.util.DbConnectionFilter;
public class dbExtract implements Serializable {
	private Connection con = null;
	private Statement stmt = null;
	private Statement stmt2 = null;
	private Statement stmt3 = null;
	private String surl;
	private String user;
	private String password;
	private String sdriver;
	private int numUpdate;
	private Statement prepStmt = null;
	private String updateString;
	PreparedStatement prep = null;
	ResultSet resultSet = null;
	ResultSet resultSet2 = null;
	ResultSet resultSet3 = null;
	public dbExtract() {
		//	try{
		//	 String userHomePath = System.getProperty("user.home", "user.dir");
		//    File pFile = new File(userHomePath, "oscar.prop");
		//  FileInputStream pStream = new FileInputStream(pFile.getPath());
		//Properties ap = new Properties();
		// ap.load(pStream);
		//  surl = ap.getProperty("DB_DRIVER");
		// user = ap.getProperty("DB_USERID");
		//  password = ap.getProperty("DB_PASSWORD");
		//  pStream.close();
		// }
		// catch (Exception ex) {
		//     System.out.println("Exception : " + ex);
		//   }
	}
	public void openConnection(String sd, String ur, String us, String ps)
			throws SQLException {
		sdriver = sd;
		surl = ur;
		us = user;
		password = ps;
		try {
			//Load the particular driver
			Class.forName(sdriver);
			//establish connection with the specified username, password and
			// url
			con = DbConnectionFilter.getThreadLocalDbConnection();
			// a statement that can execute a query
			stmt = con.createStatement();
			stmt2 = con.createStatement();
		} catch (SQLException e) {
			System.out.println("Cannot get connection ");
			System.out.println("Exception is: " + e);
		} catch (ClassNotFoundException e) {
			System.out.println("Class not found exception ");
			System.out.println("Exception is: " + e);
		}
	}
	public ResultSet executeQuery(String sql) throws SQLException {
		try {
			String SQLString = sql;
			// Execute sql
			// statement
			resultSet = stmt.executeQuery(SQLString);
			return resultSet;
		} catch (SQLException e) {
			System.out.println("Cannot get connection ");
			System.out.println("Exception is: " + e);
			return resultSet;
		}
	}
	public ResultSet executeQuery2(String sql) throws SQLException {
		try {
			String SQLString = sql;
			// Execute sql
			// statement
			resultSet2 = stmt2.executeQuery(SQLString);
			return resultSet2;
		} catch (SQLException e) {
			System.out.println("Cannot get connection ");
			System.out.println("Exception is: " + e);
			return resultSet2;
		}
	}
	public ResultSet executeQuery3(String sql) throws SQLException {
		try {
			String SQLString = sql;
			// Execute sql
			// statement
			resultSet3 = stmt3.executeQuery(SQLString);
			return resultSet3;
		} catch (SQLException e) {
			System.out.println("Cannot get connection ");
			System.out.println("Exception is: " + e);
			return resultSet3;
		}
	}
	public int executeUpdate() throws SQLException {
		try {
			String SQLup = getUpdateString();
			// System.out.println(SQLup);
			prepStmt = con.createStatement();
			numUpdate = prepStmt.executeUpdate(SQLup);
			con.commit();
			return numUpdate;
		} catch (SQLException e) {
			System.out.println("Cannot get connection ");
			System.out.println("Exception is: " + e);
			return numUpdate;
		}
	}
	public synchronized void setUpdateString(String newUpdateString) {
		updateString = newUpdateString;
	}
	public String getUpdateString() {
		return updateString;
	}
	public void closeConnection() throws SQLException {
		try {
			if ((con != null) && (stmt != null)) {
				con.close();
				stmt.close();
			}
		} catch (Exception e) {
			System.out.println("Error closing the database connection : "
					+ surl);
		}
	} //closeConnection ends
}
