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
package oscar.oscarEncounter.oscarMeasurements.bean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.Vector;

import oscar.oscarDB.DBHandler;

public class EctStyleSheetBeanHandler {
    
    Vector styleSheetNameVector = new Vector();
 
    public EctStyleSheetBeanHandler() {
        init();
    }
    
    public boolean init() {
        
        boolean verdict = true;
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            String sql = "SELECT * from measurementCSSLocation ORDER BY cssID";
            System.out.println("Sql Statement: " + sql);
            ResultSet rs;
            for(rs = db.GetSQL(sql); rs.next(); )
            {
                EctStyleSheetBean location = new EctStyleSheetBean(db.getString(rs,"location"), rs.getInt("cssID"));
                styleSheetNameVector.add(location);
            }

            rs.close();
        }
        catch(SQLException e) {
            System.out.println(e.getMessage());
            verdict = false;
        }
        return verdict;
    }

    public Collection getStyleSheetNameVector(){
        return styleSheetNameVector;
    }
}
