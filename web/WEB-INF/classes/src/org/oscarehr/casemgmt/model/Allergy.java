
/*
* 
* Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
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
* This software was written for 
* Centre for Research on Inner City Health, St. Michael's Hospital, 
* Toronto, Ontario, Canada 
*/


package org.oscarehr.casemgmt.model;

import java.util.Date;

import org.caisi.model.BaseObject;

public class Allergy extends BaseObject {
	
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -1534944824801618333L;
	private Long allergyid;
	private String demographic_no;
	private Date entry_date;
	private String description;
	private String reaction;
	private String archived;
	private Date start_date;
	private int severity;
	private int onset;
	private int type;
	
	
	
	public String getArchived() {
		return archived;
	}
	public void setArchived(String archived) {
		this.archived = archived;
	}
	public Long getAllergyid() {
		return allergyid;
	}
	public void setAllergyid(Long allergyid) {
		this.allergyid = allergyid;
	}
	public String getDemographic_no() {
		return demographic_no;
	}
	public void setDemographic_no(String demographic_no) {
		this.demographic_no = demographic_no;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Date getEntry_date() {
		return entry_date;
	}
	public void setEntry_date(Date entry_date) {
		this.entry_date = entry_date;
	}
	public String getReaction()
	{
		return reaction;
	}
	public void setReaction(String reaction)
	{
		this.reaction = reaction;
	}
	public Date getStart_date() {
		return start_date;
	}
	public void setStart_date(Date start_date) {
		this.start_date = start_date;
	}
	public int getSeverity() {
		return severity;
	}
	public void setSeverity(int severity) {
		this.severity = severity;
	}
	public int getOnset() {
		return onset;
	}
	public void setOnset(int onset) {
		this.onset = onset;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	
	
    public String getTypeDesc() {
        String s;
        /** 6 |  1 | generic
            7 |  2 | compound
            8 |  3 | brandname
            9 |  4 | ther_class
           10 |  5 | chem_class
           13 |  6 | ingredient
        **/
        switch(this.type) {
            /*
            *|  8 | anatomical class
            *|  9 | chemical class
            *| 10 | therapeutic class
            *| 11 | generic
            *| 12 | composite generic
            *| 13 | branded product
            *| 14 | ingredient
            */
            case 11:
                s = "Generic Name";
                break;                
            case 12:
                s = "Compound";
                break;
            case 13:
                s = "Brand Name";
                break;
            case 8:
                s = "ATC Class";
                break;
            case 10:
                s = "AHFS Class";
                break;
            case 14:
                s = "Ingredient";
                break;
            default:
                s = "";
        }
        return s;
    }
    
    public String getSeverityDesc() {
    	switch(severity) {
    	case 1: return "Mild";
    	case 2: return "Moderate";
    	case 3: return "Severe";
    	default: return "Unknown";
    	}
    }
    
    public String getOnsetDesc() {
    	switch(onset) {
    	case 1: return "Immediate";
    	case 2: return "Gradual";
    	case 3: return "Slow";
    	default: return "Unknown";
    	}
    }
}
