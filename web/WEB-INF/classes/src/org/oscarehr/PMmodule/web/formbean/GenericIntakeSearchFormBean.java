/**
 * Copyright (C) 2007.
 * Centre for Research on Inner City Health, St. Michael's Hospital, Toronto, Ontario, Canada.
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
package org.oscarehr.PMmodule.web.formbean;

import org.apache.struts.action.ActionForm;
import org.apache.struts.util.LabelValueBean;
import org.oscarehr.PMmodule.model.Demographic;

import java.util.Collection;
import java.util.List;

public class GenericIntakeSearchFormBean extends ActionForm {

	private static final long serialVersionUID = 1L;

	private LabelValueBean[] months;
	private LabelValueBean[] days;

	private String method;

	private String firstName;
	private String lastName;
	private String monthOfBirth;
	private String dayOfBirth;
	private String yearOfBirth;
	private String healthCardNumber;
	private String healthCardVersion;

	private boolean localMatch;
	private boolean remoteMatch;
	private Collection<Demographic> matches;

	private Integer clientId;
	private Long agencyId;

	public GenericIntakeSearchFormBean() {
		setMonths(GenericIntakeConstants.MONTHS);
		setDays(GenericIntakeConstants.DAYS);
	}

	public LabelValueBean[] getMonths() {
		return months;
	}

	public void setMonths(LabelValueBean[] months) {
		this.months = months;
	}

	public LabelValueBean[] getDays() {
		return days;
	}

	public void setDays(LabelValueBean[] days) {
		this.days = days;
	}

	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public String getFirstName() {
		return firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public String getMonthOfBirth() {
		return monthOfBirth;
	}

	public String getDayOfBirth() {
		return dayOfBirth;
	}

	public String getYearOfBirth() {
		return yearOfBirth;
	}

	public String getHealthCardNumber() {
		return healthCardNumber;
	}

	public String getHealthCardVersion() {
		return healthCardVersion;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setMonthOfBirth(String monthOfBirth) {
		this.monthOfBirth = monthOfBirth;
	}

	public void setDayOfBirth(String dayOfBirth) {
		this.dayOfBirth = dayOfBirth;
	}

	public void setYearOfBirth(String yearOfBirth) {
		this.yearOfBirth = yearOfBirth;
	}

	public void setHealthCardNumber(String healthCardNumber) {
		this.healthCardNumber = healthCardNumber;
	}

	public void setHealthCardVersion(String healthCardVersion) {
		this.healthCardVersion = healthCardVersion;
	}

	public boolean isLocalMatch() {
		return localMatch;
	}

	public boolean isRemoteMatch() {
		return remoteMatch;
	}

	public Collection<Demographic> getMatches() {
		return matches;
	}

	public String getMatchType() {
		return isRemoteMatch() ? "Integrator" : "Agency";
	}

	public void setLocalMatches(List<Demographic> matches) {
		if (matches != null && matches.size() > 0) {
			this.localMatch = true;

			this.matches = matches;
		}
	}

	public void setRemoteMatches(Collection<Demographic> matches) {
		if (matches != null && matches.size() > 0) {
			this.remoteMatch = true;
			this.matches = matches;
		}
	}

	public Integer getClientId() {
		return clientId;
	}

	public void setClientId(Integer clientId) {
		this.clientId = clientId;
	}

	public Long getAgencyId() {
		return agencyId;
	}

	public void setAgencyId(Long agencyId) {
		this.agencyId = agencyId;
	}

}