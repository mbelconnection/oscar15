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

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement(name="appointmentTo")
public class AppointmentTo implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private String patientId;
	private String apptStartDate;
	private String apptTime;
	private String apptDuration;
	private String apptEndDate;
	private String patientName;
	private String providerType;
	private String provId;
	private String apptStatus;
	private String isCritical;
	private String apptResources;
	private String appRreason;
	private String apptReasonDtls;
	private String apptNotes;
	private String noOfPatient;
	private String id;
	private String sendMail;
	private String reoccranceDay;
	private String reoccuranceDate;
	private String goTo;
	private String apptReasonText;
	
	@XmlElement(name="appt_reason_text", nillable=true)
	public String getApptReasonText() {
		return apptReasonText;
	}

	public void setApptReasonText(String apptReasonText) {
		this.apptReasonText = apptReasonText;
	}

	@XmlElement(name="go_to", nillable=true)
	public String getGoTo() {
		return goTo;
	}

	public void setGoTo(String goTo) {
		this.goTo = goTo;
	}

	@XmlElement(name="recurrence_date", nillable=true)
	public String getReoccuranceDate() {
		return reoccuranceDate;
	}

	public void setReoccuranceDate(String reoccuranceDate) {
		this.reoccuranceDate = reoccuranceDate;
	}

	@XmlElement(name="recurrence_day", nillable=true)
	public String getReoccranceDay() {
		return reoccranceDay;
	}

	public void setReoccranceDay(String reoccranceDay) {
		this.reoccranceDay = reoccranceDay;
	}

	@XmlElement(name="send_mail", nillable=true)
	public String getSendMail() {
		return sendMail;
	}

	public void setSendMail(String sendMail) {
		this.sendMail = sendMail;
	}

	@XmlElement(name="id", nillable=true)
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	@XmlElement(name="no_of_pat", nillable=true)
	public String getNoOfPatient() {
		return noOfPatient;
	}

	public void setNoOfPatient(String noOfPatient) {
		this.noOfPatient = noOfPatient;
	}

	@XmlElement(name="patient_id", nillable=true)
	public String getPatientId() {
		return patientId;
	}
	
	public void setPatientId(String patientId) {
		this.patientId = patientId;
	}
	
	@XmlElement(name="patient_name", nillable=true)
	public String getPatientName() {
		return patientName;
	}
	public void setPatientName(String patientName) {
		this.patientName = patientName;
	}
	
	@XmlElement(name="provider_type", nillable=true)
	public String getProviderType() {
		return providerType;
	}
	public void setProviderType(String providerType) {
		this.providerType = providerType;
	}
	
	@XmlElement(name="provider_id", nillable=true)
	public String getProvId() {
		return provId;
	}
	public void setProvId(String provId) {
		this.provId = provId;
	}
	
	@XmlElement(name="appt_status", nillable=true)
	public String getApptStatus() {
		return apptStatus;
	}
	public void setApptStatus(String apptStatus) {
		this.apptStatus = apptStatus;
	}
	
	@XmlElement(name="is_critical", nillable=true)
	public String getIsCritical() {
		return isCritical;
	}
	public void setIsCritical(String isCritical) {
		this.isCritical = isCritical;
	}
	
	@XmlElement(name="appt_resources", nillable=true)
	public String getApptResources() {
		return apptResources;
	}
	public void setApptResources(String apptResources) {
		this.apptResources = apptResources;
	}
	
	@XmlElement(name="appt_reason", nillable=true)
	public String getAppRreason() {
		return appRreason;
	}
	public void setAppRreason(String appRreason) {
		this.appRreason = appRreason;
	}
	
	@XmlElement(name="appt_reason_dtls", nillable=true)
	public String getApptReasonDtls() {
		return apptReasonDtls;
	}
	public void setApptReasonDtls(String apptReasonDtls) {
		this.apptReasonDtls = apptReasonDtls;
	}
	
	@XmlElement(name="appt_notes", nillable=true)
	public String getApptNotes() {
		return apptNotes;
	}
	public void setApptNotes(String apptNotes) {
		this.apptNotes = apptNotes;
	}
	
	@XmlElement(name="date", nillable=true)
	public String getApptStartDate() {
		return apptStartDate;
	}

	public void setApptStartDate(String apptStartDate) {
		this.apptStartDate = apptStartDate;
	}

	@XmlElement(name="time", nillable=true)
	public String getApptTime() {
		return apptTime;
	}

	public void setApptTime(String apptTime) {
		this.apptTime = apptTime;
	}

	@XmlElement(name="duration", nillable=true)
	public String getApptDuration() {
		return apptDuration;
	}

	public void setApptDuration(String apptDuration) {
		this.apptDuration = apptDuration;
	}

	@XmlElement(name="recurrence_endDate", nillable=true)
	public String getApptEndDate() {
		return apptEndDate;
	}

	public void setApptEndDate(String apptEndDate) {
		this.apptEndDate = apptEndDate;
	}
	
	
}


