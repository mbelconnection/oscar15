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
package oscar.oscarEncounter.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import oscar.oscarDB.DBHandler;

public class EctRemoteAttachments
{

    public EctRemoteAttachments()
    {
        demoNo = null;
        messageIds = null;
        savedBys = null;
        dates = null;
    }

    public void estMessageIds(String demo)
    {
        demoNo = demo;
        messageIds = new ArrayList();
        savedBys = new ArrayList();
        dates = new ArrayList();
        try
        {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql ="Select * from remoteAttachments where demographic_no = '"+demoNo+"' order by date";
            System.out.println("sql message "+sql);
            rs = db.GetSQL(sql); 
            //for(rs = db.GetSQL(String.valueOf(String.valueOf((new StringBuffer("SELECT * FROM remoteAttachments WHERE demographic_no = '")).append(demoNo).append("' order by date ")))); rs.next(); dates.add(db.getString(rs,"date")))
            while(rs.next())
	    {
		dates.add(db.getString(rs,"date"));
                messageIds.add(db.getString(rs,"messageid"));
                savedBys.add(db.getString(rs,"savedBy"));
            }

            rs.close();
        }
        catch(SQLException e)
        {
            System.out.println("CrAsH");
        }
    }

    public ArrayList getFromLocation(String messId)
    {
        ArrayList retval = new ArrayList();
        try
        {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs;
            String sql = "select ocl.locationDesc, mess.thesubject from messagetbl mess, oscarcommlocations ocl where mess.sentByLocation = ocl.locationId and mess.messageid = '"+messId+"' ";
	    System.out.println("sql ="+sql);
	    rs = db.GetSQL(sql);
//            for(rs = db.GetSQL(String.valueOf(String.valueOf((new StringBuffer("SELECT ocl.locationDesc, mess.thesubject FROM messagetbl mess, oscarcommlocations ocl where mess.sentByLocation = ocl.locationId and mess.messageid = '")).append(messId).append("'"))));
             while ( rs.next()){
                 retval.add(db.getString(rs,"thesubject"));
                 retval.add(db.getString(rs,"locationDesc"));
 	     }
            rs.close();
        }
        catch(SQLException e)
        {
            System.out.println("CrAsH");
            e.printStackTrace();
        }
        return retval;
    }

    String demoNo;
    public ArrayList messageIds;
    public ArrayList savedBys;
    public ArrayList dates;
}