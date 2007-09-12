/**
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
 * Jason Gallagher
 * 
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada   Creates a new instance of CPPData
 *
 *
 * CPPData.java
 *
 * Created on July 19, 2005, 9:06 AM
 */

package oscar.oscarEncounter.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import org.oscarehr.util.DbConnectionFilter;

import oscar.oscarDB.DBHandler;
import oscar.util.SqlUtils;
import oscar.util.UtilDateUtilities;

/**
 *
 * @author Jay Gallagher
 */
public class CPPData {

    public CPPData() {
    }

    String socialFamVal = null;
    String ongoingConVal = null;
    String medHistVal = null;
    String reminderVal = null;
    String riskfactorVal = null;
    String otherMedVal = null;
    String otherAllerVal = null;

    String medsList = null;
    String[] medsArrList = null;
    String allegryList = null;
    ArrayList allergyArrList = null;
    String divArr = null;
    ArrayList divArrList = null;

    public String[] getArrFromString(String s) {
        String[] arr = null;
        if (s != null) {
            arr = s.split(",");
        }
        return arr;
    }

    public static List getListFromString(String s) {
        String[] arr = null;
        List alist = null;
        if (s != null) {
            arr = s.split(",");
        }
        if (arr != null) {
            alist = Arrays.asList(arr);
        }
        else {
            alist = new ArrayList();
        }

        return alist;
    }

    /*
     create table cpp(
     id int(10) auto_increment primary key,  
     demographic_no int(10),
     provider_no varchar(6),
     
     socialFam text,
     ongoingCon text,
     medHist text,
     reminder text,
     riskfactor text,
     otherMed text,
     otherAller text,
     medsList text,
     allergyList text,
     divArr text,
     created datetime
     )
     */
    public void addCPPData(String demoNo, String provNo, String socialFamVal, String ongoingConVal, String medHistVal, String reminderVal, String riskfactorVal, String otherMedVal, String otherAllerVal, String medsList, String allergyList, String divArr) throws SQLException {
        String sql = "insert into cpp (demographic_no,provider_no,socialFam,ongoingCon,medHist,reminder,riskfactor,otherMed,otherAller,medsList,allergyList,divArr,created) values (?,?,?,?,?,?,?,?,?,?,?,?,?) ";

        Connection c = DbConnectionFilter.getThreadLocalDbConnection();
        PreparedStatement ps = null;
        try {
            ps = c.prepareStatement(sql);
            ps.setString(1, demoNo);
            ps.setString(2, provNo);
            ps.setString(3, socialFamVal);
            ps.setString(4, ongoingConVal);
            ps.setString(5, medHistVal);
            ps.setString(6, reminderVal);
            ps.setString(7, riskfactorVal);
            ps.setString(8, otherMedVal);
            ps.setString(9, otherAllerVal);
            ps.setString(10, medsList);
            ps.setString(11, allergyList);
            ps.setString(12, divArr);
            ps.setDate(13, new java.sql.Date(UtilDateUtilities.Today().getTime()));
            ps.execute();
        }
        catch (Exception e) {
            e.printStackTrace();
            //inserted = false;
        }
        finally {
            SqlUtils.closeResources(c, ps, null);
        }
    }

    public HashMap getCPPData(String demoNo) {
        HashMap hm = new HashMap();
        String sql = "select * from cpp  where demographic_no = '" + demoNo + "' order by id desc limit 1";
        System.out.println(sql);
        try {
            DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
            ResultSet rs = db.GetSQL(sql);
            if (rs.next()) {

                String providerNo = rs.getString("provider_no");
                String socialFam = rs.getString("socialFam");
                String ongoingCon = rs.getString("ongoingCon");
                String medHist = rs.getString("medHist");
                String reminder = rs.getString("reminder");
                String riskfactor = rs.getString("riskfactor");
                String otherMed = rs.getString("otherMed");
                String otherAller = rs.getString("otherAller");

                String medsList = rs.getString("medsList");
                String allegryList = rs.getString("allergyList");
                String divArr = rs.getString("divArr");
                String created = rs.getString("created");

                hm.put("providerNo", providerNo);
                hm.put("socialFam", socialFam);
                hm.put("ongoingCon", ongoingCon);
                hm.put("medHist", medHist);
                hm.put("reminder", reminder);
                hm.put("riskfactor", riskfactor);
                hm.put("otherMed", otherMed);
                hm.put("otherAller", otherAller);

                hm.put("medsList", getListFromString(medsList));
                hm.put("allergyList", getListFromString(allegryList));
                hm.put("divList", getListFromString(divArr));
                hm.put("created", created);

            }

            db.CloseConn();
        }
        catch (Exception e) {
            e.printStackTrace();
            //inserted = false;
        }
        return hm;
    }

}
