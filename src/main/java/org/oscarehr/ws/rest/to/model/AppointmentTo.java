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

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;
@XmlRootElement(name="appointmentTo")
@XmlAccessorType(XmlAccessType.PROPERTY)
@JsonIgnoreProperties(ignoreUnknown = true)
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
	private String appReason;
	private String apptReasonDtls;
	private String apptNotes;
	private String noOfPatient;
	private String id;
	private String sendMail;
	private String reoccranceDay;
	private String reoccuranceDate;
	private String goTo;
	private String apptReasonText;
	private String location;
	private String providerName;
	private String apptType;
	// for next avalibility
	private String dayOfWeek;
	
	private String creator;
	private String createDateTime;
	private String updateDateTime;
	private String lastUpdateUser;
	
	private String programId;
	
	private String multiApptId;
	private String roomId;
	private String recurrenceId;
	
	private String frequency;
	private String startDate;
	private String endDate;
	private String isRecUpdate;
	private String newPatients;
	private String newPatNames;
	/**
	 * @return the programId
	 */
	public String getProgramId() {
		return programId;
	}

	/**
	 * @param programId the programId to set
	 */
	public void setProgramId(String programId) {
		this.programId = programId;
	}

	/**
	 * @return the creator
	 */
	public String getCreator() {
		return creator;
	}

	/**
	 * @param creator the creator to set
	 */
	public void setCreator(String creator) {
		this.creator = creator;
	}

	/**
	 * @return the createDateTime
	 */
	public String getCreateDateTime() {
		return createDateTime;
	}

	/**
	 * @param createDateTime the createDateTime to set
	 */
	public void setCreateDateTime(String createDateTime) {
		this.createDateTime = createDateTime;
	}

	/**
	 * @return the updateDateTime
	 */
	public String getUpdateDateTime() {
		return updateDateTime;
	}

	/**
	 * @param updateDateTime the updateDateTime to set
	 */
	public void setUpdateDateTime(String updateDateTime) {
		this.updateDateTime = updateDateTime;
	}

	/**
	 * @return the lastUpdateUser
	 */
	public String getLastUpdateUser() {
		return lastUpdateUser;
	}

	/**
	 * @param lastUpdateUser the lastUpdateUser to set
	 */
	public void setLastUpdateUser(String lastUpdateUser) {
		this.lastUpdateUser = lastUpdateUser;
	}

	/**
	 * @return the dayOfWeek
	 */
	public String getDayOfWeek() {
		return dayOfWeek;
	}

	/**
	 * @param dayOfWeek the dayOfWeek to set
	 */
	public void setDayOfWeek(String dayOfWeek) {
		this.dayOfWeek = dayOfWeek;
	}

	/**
	 * @return the startTime
	 */
	public String getStartTime() {
		return startTime;
	}

	/**
	 * @param startTime the startTime to set
	 */
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	/**
	 * @return the endTime
	 */
	public String getEndTime() {
		return endTime;
	}

	/**
	 * @param endTime the endTime to set
	 */
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	/**
	 * @return the resultCount
	 */
	public String getResultCount() {
		return resultCount;
	}

	/**
	 * @param resultCount the resultCount to set
	 */
	public void setResultCount(String resultCount) {
		this.resultCount = resultCount;
	}

	private String startTime;
	private String endTime;
	private String resultCount;
	
	/**
	 * @return the apptType
	 */
	public String getApptType() {
		return apptType;
	}

	/**
	 * @param apptType the apptType to set
	 */
	public void setApptType(String apptType) {
		this.apptType = apptType;
	}

	@XmlElement(name="add_appt_location", nillable=true)
	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

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
	public String getAppReason() {
		return appReason;
	}
	public void setAppReason(String appReason) {
		this.appReason = appReason;
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

	public String getProviderName() {
		return providerName;
	}

	public void setProviderName(String providerName) {
		this.providerName = providerName;
	}

	/**
	 * @return the multiApptId
	 */
	public String getMultiApptId() {
		return multiApptId;
	}

	/**
	 * @param multiApptId the multiApptId to set
	 */
	public void setMultiApptId(String multiApptId) {
		this.multiApptId = multiApptId;
	}

	/**
	 * @return the roomId
	 */
	public String getRoomId() {
		return roomId;
	}

	/**
	 * @param roomId the roomId to set
	 */
	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}

	/**
	 * @return the recurrenceId
	 */
	public String getRecurrenceId() {
		return recurrenceId;
	}

	/**
	 * @param recurrenceId the recurrenceId to set
	 */
	public void setRecurrenceId(String recurrenceId) {
		this.recurrenceId = recurrenceId;
	}

	/**
	 * @return the frequency
	 */
	public String getFrequency() {
		return frequency;
	}

	/**
	 * @param frequency the frequency to set
	 */
	public void setFrequency(String frequency) {
		this.frequency = frequency;
	}

	/**
	 * @return the startDate
	 */
	public String getStartDate() {
		return startDate;
	}

	/**
	 * @param startDate the startDate to set
	 */
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	/**
	 * @return the endDate
	 */
	public String getEndDate() {
		return endDate;
	}

	/**
	 * @param endDate the endDate to set
	 */
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	/**
	 * @return the isRecUpdate
	 */
	public String getIsRecUpdate() {
		return isRecUpdate;
	}

	/**
	 * @param isRecUpdate the isRecUpdate to set
	 */
	public void setIsRecUpdate(String isRecUpdate) {
		this.isRecUpdate = isRecUpdate;
	}

	/**
	 * @return the newPatients
	 */
	public String getNewPatients() {
		return newPatients;
	}

	/**
	 * @param newPatients the newPatients to set
	 */
	public void setNewPatients(String newPatients) {
		this.newPatients = newPatients;
	}

	/**
	 * @return the newPatNames
	 */
	public String getNewPatNames() {
		return newPatNames;
	}

	/**
	 * @param newPatNames the newPatNames to set
	 */
	public void setNewPatNames(String newPatNames) {
		this.newPatNames = newPatNames;
	}
	
	
	
	
}


