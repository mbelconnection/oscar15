package org.oscarehr.common.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class OracleTest {
    public static void main(String... argv) throws Exception {
        DriverManager.registerDriver(new oracle.jdbc.OracleDriver());

        Connection c = DriverManager.getConnection("jdbc:oracle:thin:@192.168.0.11:1521:", "system", "dbpassword");
        Statement s=c.createStatement();
        
        s.executeUpdate("insert into foo values (null, 'test')");
        
        ResultSet rs=s.executeQuery("select * from foo");
        while (rs.next())
        {
            System.err.println(""+rs.getInt(1)+","+rs.getString(2));
        }
        
        rs.close();
        s.close();
        c.close();
    }
}
