  
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
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */
package oscar.oscarRx.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.oscarehr.util.MiscUtils;

import oscar.oscarDB.DBHandler;

public class RxCodesData {
    public Disease getDisease(String ICD9) {
        return new Disease(ICD9);
    }
    
    public FrequencyCode[] getFrequencyCodes() {
        FrequencyCode[] arr = {};
        ArrayList lst = new ArrayList();
        
        try {
            
            ResultSet rs;
            String sql = "SELECT * FROM ctl_frequency";
            
            rs = DBHandler.GetSQL(sql);
            
            while (rs.next()) {
                lst.add(new FrequencyCode(rs.getInt("freqid"), oscar.Misc.getString(rs, "freqcode"), oscar.Misc.getString(rs, "dailymin"), oscar.Misc.getString(rs, "dailymax")));
            }
            
            rs.close();
            arr = (FrequencyCode[])lst.toArray(arr);
            
        } catch (SQLException e) {
            MiscUtils.getLogger().error("Error", e);
        }
        
        return arr;
    }
    
    public String[] getSpecialInstructions() {
        String[] arr = {};
        ArrayList lst = new ArrayList();
        
        try {
            
            ResultSet rs;
            String sql = "SELECT * FROM ctl_specialinstructions";
            
            rs = DBHandler.GetSQL(sql);
            
            while (rs.next()) {
                lst.add(oscar.Misc.getString(rs, "description"));
            }
            
            rs.close();
            arr = (String[])lst.toArray(arr);
        } catch (SQLException e) {
            MiscUtils.getLogger().error("Error", e);
        }
        
        return arr;
    }
    
    public class Disease {
        String ICD9;
        String diseaseName;
        
        public Disease(String ICD9) {
            this.ICD9 = ICD9;
        }
        
        public String getICD9() {
            return this.ICD9;
        }
    }
 
        public class FrequencyCode {
            int freqId;
            String freqCode;
            String dailyMin;
            String dailyMax;
            
            public FrequencyCode(int freqId, String freqCode, int dailyMin, int dailyMax) {
                this.freqId=freqId;
                this.freqCode=freqCode;
                this.dailyMin= Integer.toString(dailyMin);
                this.dailyMax= Integer.toString(dailyMax);
            }
            
            public FrequencyCode(int freqId, String freqCode, String dailyMin, String dailyMax) {
                this.freqId=freqId;
                this.freqCode=freqCode;
                this.dailyMin= dailyMin;
                this.dailyMax= dailyMax;
            }
                                    
            public int getFreqId() {
                return this.freqId;
            }
            
            public String getFreqCode() {
                return this.freqCode;
            }
            
            public String getDailyMin() {
                return this.dailyMin;
            }
            
            public String getDailyMax() {
                return this.dailyMax;
            }
        }
}