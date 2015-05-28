/**
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
 * This software is published under the GPL GNU General Public License.
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */
package oscar.oscarDemographic.pageUtil;

import org.apache.struts.action.ActionForm;

public class DemographicExportPdfForm extends ActionForm {

    String demographicNo;
     
    boolean incAllergies;
    boolean incProblems;
    boolean incCPP;
    boolean incIssues;
    boolean incMeds;
    boolean incMeasurements;
    boolean incNotes;
    boolean incEForms;
   
    
    public DemographicExportPdfForm() {
    }


	public String getDemographicNo() {
		return demographicNo;
	}


	public void setDemographicNo(String demographicNo) {
		this.demographicNo = demographicNo;
	}


	public boolean isIncAllergies() {
		return incAllergies;
	}


	public void setIncAllergies(boolean incAllergies) {
		this.incAllergies = incAllergies;
	}


	public boolean isIncProblems() {
		return incProblems;
	}


	public void setIncProblems(boolean incProblems) {
		this.incProblems = incProblems;
	}


	public boolean isIncCPP() {
		return incCPP;
	}


	public void setIncCPP(boolean incCPP) {
		this.incCPP = incCPP;
	}


	public boolean isIncIssues() {
		return incIssues;
	}


	public void setIncIssues(boolean incIssues) {
		this.incIssues = incIssues;
	}


	public boolean isIncMeds() {
		return incMeds;
	}


	public void setIncMeds(boolean incMeds) {
		this.incMeds = incMeds;
	}


	public boolean isIncMeasurements() {
		return incMeasurements;
	}


	public void setIncMeasurements(boolean incMeasurements) {
		this.incMeasurements = incMeasurements;
	}


	public boolean isIncNotes() {
		return incNotes;
	}


	public void setIncNotes(boolean incNotes) {
		this.incNotes = incNotes;
	}


	public boolean isIncEForms() {
		return incEForms;
	}


	public void setIncEForms(boolean incEForms) {
		this.incEForms = incEForms;
	}

}
