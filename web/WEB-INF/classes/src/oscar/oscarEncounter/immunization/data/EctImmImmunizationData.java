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
package oscar.oscarEncounter.immunization.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import oscar.OscarProperties;
import oscar.oscarDB.DBHandler;

public class EctImmImmunizationData
{

    public String getImmunizations(String demographicNo)
        throws SQLException
    {
        String sRet = null;
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        String sql = String.valueOf(String.valueOf((new StringBuffer("SELECT * FROM immunizations WHERE demographic_no = ")).append(demographicNo).append(" AND archived=0")));
        ResultSet rs = db.GetSQL(sql);
        if(rs.next())
            sRet = db.getString(rs,"immunizations");
        rs.close();
        return sRet;
    }
    
    public static boolean hasImmunizations(String demographicNo)
        throws SQLException
    {        
        boolean retval = false;
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        String sql = String.valueOf(String.valueOf((new StringBuffer("SELECT * FROM immunizations WHERE demographic_no = ")).append(demographicNo).append(" AND archived=0")));
        ResultSet rs = db.GetSQL(sql);
        if(rs.next()) {
            retval = true;
        }         
        rs.close();
        return retval;
    }

    public void saveImmunizations(String demographicNo, String providerNo, String immunizations)
        throws SQLException
    {
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        System.out.println(String.valueOf(String.valueOf((new StringBuffer(String.valueOf(String.valueOf(demographicNo)))).append(" ").append(providerNo).append(" ").append(immunizations))));
        String sql = String.valueOf(String.valueOf((new StringBuffer("INSERT INTO immunizations (demographic_no, provider_no, immunizations, save_date, archived) VALUES (")).append(demographicNo).append(", '").append(providerNo).append("', '").append(immunizations).append("', CURRENT_DATE, 0)")));
        db.RunSQL(sql);
	//select the specific database function:
	String db_type = OscarProperties.getInstance().getProperty("db_type", "mysql");
	db_type.trim();
	String proper_func = "";
	if (db_type.equalsIgnoreCase("mysql")) proper_func = "LAST_INSERT_ID()";
        else if (db_type.equalsIgnoreCase("postgresql")) proper_func = "SELECT CURRVAL('immunizations_numeric_seq')";
	else throw new java.sql.SQLException("ERROR: Database " + db_type + " unrecognized");
	
        sql = "UPDATE immunizations SET archived = 1 WHERE demographic_no = " + demographicNo + 
              " AND ID <>" + proper_func;
        db.RunSQL(sql);
    }

    public String[] getProviders()
        throws SQLException
    {
        Vector vRet = new Vector();
        DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
        String sql = "SELECT provider_no, CONCAT(last_name, ', ', first_name) AS namer FROM provider WHERE status = 1 ORDER BY last_name, first_name";
        ResultSet rs;
        String s;
        for(rs = db.GetSQL(sql); rs.next(); vRet.add(s))
        {
            s = String.valueOf(String.valueOf((new StringBuffer(String.valueOf(String.valueOf(db.getString(rs,"provider_no"))))).append("/").append(db.getString(rs,"namer"))));
            System.out.println(s);
        }

        rs.close();
        String ret[] = new String[0];
        ret = (String[])vRet.toArray(ret);
        return ret;
    }
}