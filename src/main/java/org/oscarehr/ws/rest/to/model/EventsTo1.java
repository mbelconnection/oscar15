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

public class EventsTo1 implements Serializable {

    private static final long serialVersionUID = 1L;
    
	private String apptId;
	private String docId;
	private String patientName;
	private String fromTime;
	private String duration;
	private String appointStatus;
	private String isCritical;
	private String noOfPat;
	private String goTo;
	private String reason;
	private String notes;
	
	@XmlElement(name="appt_id")
	public String getApptId() {
		return apptId;
	}
	public void setApptId(String apptId) {
		this.apptId = apptId;
	}
	
	@XmlElement(name="doc_id")
	public String getDocId() {
		return docId;
	}
	public void setDocId(String docId) {
		this.docId = docId;
	}
	
	@XmlElement(name="patient_name")
	public String getPatientName() {
		return patientName;
	}
	public void setPatientName(String patientName) {
		this.patientName = patientName;
	}
	
	@XmlElement(name="from_time")
	public String getFromTime() {
		return fromTime;
	}
	public void setFromTime(String fromTime) {
		this.fromTime = fromTime;
	}
	
	@XmlElement(name="duration")
	public String getDuration() {
		return duration;
	}
	public void setDuration(String duration) {
		this.duration = duration;
	}
	
	@XmlElement(name="appoint_status")
	public String getAppointStatus() {
		return appointStatus;
	}
	public void setAppointStatus(String appointStatus) {
		this.appointStatus = appointStatus;
	}
	
	@XmlElement(name="is_critical")
	public String getIsCritical() {
		return isCritical;
	}
	public void setIsCritical(String isCritical) {
		this.isCritical = isCritical;
	}
	
	@XmlElement(name="no_of_pat")
	public String getNoOfPat() {
		return noOfPat;
	}
	public void setNoOfPat(String noOfPat) {
		this.noOfPat = noOfPat;
	}
	
	@XmlElement(name="go_to")
	public String getGoTo() {
		return goTo;
	}
	public void setGoTo(String goTo) {
		this.goTo = goTo;
	}
	
	@XmlElement(name="reason")
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	
	@XmlElement(name="notes")
	public String getNotes() {
		return notes;
	}
	public void setNotes(String notes) {
		this.notes = notes;
	}
	
	
}
