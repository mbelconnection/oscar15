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

package org.oscarehr.ws.rest.to.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class ConsultationRequestTo implements Serializable {
	private static final long serialVersionUID = 3842541954969260619L;
	private Integer id;
	private Date referralDate;
	private Integer serviceId;
	private Date appointmentDate;
	private Date appointmentTime;
	private String reasonForReferral;
	private String clinicalInfo;
	private String currentMeds;
	private String allergies;
	private String providerNo;
	private Integer demographicId;
	private String status;
	private String statusText;
	private String sendTo;
	private String concurrentProblems;
	private String urgency;
	private boolean patientWillBook;
	private String siteName;
	private Date followUpDate;
	private String signatureImg;
	private String letterheadName;
	private String letterheadAddress;
	private String letterheadPhone;
	private String letterheadFax;
	private Integer specId;

	private List<LetterheadTo> letterheads = new ArrayList<LetterheadTo>();
	private List<ConsultationServiceTo> services = new ArrayList<ConsultationServiceTo>();
	private List<String> teams = new ArrayList<String>();

	private DemographicTo1 demographic;

	public List<String> getTeams() {
		return teams;
	}

	public void setTeams(List<String> teams) {
		this.teams = teams;
	}

	public DemographicTo1 getDemographic() {
		return demographic;
	}

	public void setDemographic(DemographicTo1 demographic) {
		this.demographic = demographic;
	}

	public Integer getSpecId() {
		return specId;
	}

	public void setSpecId(Integer specId) {
		this.specId = specId;
	}

	public List<ConsultationServiceTo> getServices() {
		return services;
	}

	public void setServices(List<ConsultationServiceTo> services) {
		this.services = services;
	}

	public List<LetterheadTo> getLetterheads() {
		return letterheads;
	}

	public void setLetterheads(List<LetterheadTo> letterheads) {
		this.letterheads = letterheads;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Date getReferralDate() {
		return referralDate;
	}

	public void setReferralDate(Date referralDate) {
		this.referralDate = referralDate;
	}

	public Integer getServiceId() {
		return serviceId;
	}

	public void setServiceId(Integer serviceId) {
		this.serviceId = serviceId;
	}

	public Date getAppointmentDate() {
		return appointmentDate;
	}

	public void setAppointmentDate(Date appointmentDate) {
		this.appointmentDate = appointmentDate;
	}

	public Date getAppointmentTime() {
		return appointmentTime;
	}

	public void setAppointmentTime(Date appointmentTime) {
		this.appointmentTime = appointmentTime;
	}

	public String getReasonForReferral() {
		return reasonForReferral;
	}

	public void setReasonForReferral(String reasonForReferral) {
		this.reasonForReferral = reasonForReferral;
	}

	public String getClinicalInfo() {
		return clinicalInfo;
	}

	public void setClinicalInfo(String clinicalInfo) {
		this.clinicalInfo = clinicalInfo;
	}

	public String getCurrentMeds() {
		return currentMeds;
	}

	public void setCurrentMeds(String currentMeds) {
		this.currentMeds = currentMeds;
	}

	public String getAllergies() {
		return allergies;
	}

	public void setAllergies(String allergies) {
		this.allergies = allergies;
	}

	public String getProviderNo() {
		return providerNo;
	}

	public void setProviderNo(String providerNo) {
		this.providerNo = providerNo;
	}

	public Integer getDemographicId() {
		return demographicId;
	}

	public void setDemographicId(Integer demographicId) {
		this.demographicId = demographicId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStatusText() {
		return statusText;
	}

	public void setStatusText(String statusText) {
		this.statusText = statusText;
	}

	public String getSendTo() {
		return sendTo;
	}

	public void setSendTo(String sendTo) {
		this.sendTo = sendTo;
	}

	public String getConcurrentProblems() {
		return concurrentProblems;
	}

	public void setConcurrentProblems(String concurrentProblems) {
		this.concurrentProblems = concurrentProblems;
	}

	public String getUrgency() {
		return urgency;
	}

	public void setUrgency(String urgency) {
		this.urgency = urgency;
	}

	public boolean isPatientWillBook() {
		return patientWillBook;
	}

	public void setPatientWillBook(boolean patientWillBook) {
		this.patientWillBook = patientWillBook;
	}

	public String getSiteName() {
		return siteName;
	}

	public void setSiteName(String siteName) {
		this.siteName = siteName;
	}

	public Date getFollowUpDate() {
		return followUpDate;
	}

	public void setFollowUpDate(Date followUpDate) {
		this.followUpDate = followUpDate;
	}

	public String getSignatureImg() {
		return signatureImg;
	}

	public void setSignatureImg(String signatureImg) {
		this.signatureImg = signatureImg;
	}

	public String getLetterheadName() {
		return letterheadName;
	}

	public void setLetterheadName(String letterheadName) {
		this.letterheadName = letterheadName;
	}

	public String getLetterheadAddress() {
		return letterheadAddress;
	}

	public void setLetterheadAddress(String letterheadAddress) {
		this.letterheadAddress = letterheadAddress;
	}

	public String getLetterheadPhone() {
		return letterheadPhone;
	}

	public void setLetterheadPhone(String letterheadPhone) {
		this.letterheadPhone = letterheadPhone;
	}

	public String getLetterheadFax() {
		return letterheadFax;
	}

	public void setLetterheadFax(String letterheadFax) {
		this.letterheadFax = letterheadFax;
	}

}
