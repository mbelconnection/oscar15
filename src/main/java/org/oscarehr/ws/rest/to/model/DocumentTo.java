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
import java.util.Date;

public class DocumentTo implements Serializable {
    private static final long serialVersionUID = -4579336574144505070L;
    
	private String docId;
	private Integer remoteFacilityId;
	private String description;
	private String dateTimeStamp;
	private Date dateTimeStampAsDate;
	private String type;
	private String docClass;
	private String docSubClass;
	private String fileName;
	private String html;
	private String creatorId;
	private String responsibleId;
	private String source;
	private String sourceFacility;
	private Integer programId = -1;
	private char status;
	private String module;
	private String moduleId;
	private String docPublic = "0";
	private String contentType;
	private Date contentDateTime;
	private String observationDate;
	private String reviewerId;
	private String reviewDateTime;
	private Date reviewDateTimeDate;
	private String indivoIdx;
	private boolean indivoRegistered;
	private int numberOfPages;
	private Integer appointmentNo = -1;

	public String getDocId() {
		return docId;
	}

	public void setDocId(String docId) {
		this.docId = docId;
	}

	public Integer getRemoteFacilityId() {
		return remoteFacilityId;
	}

	public void setRemoteFacilityId(Integer remoteFacilityId) {
		this.remoteFacilityId = remoteFacilityId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDateTimeStamp() {
		return dateTimeStamp;
	}

	public void setDateTimeStamp(String dateTimeStamp) {
		this.dateTimeStamp = dateTimeStamp;
	}

	public Date getDateTimeStampAsDate() {
		return dateTimeStampAsDate;
	}

	public void setDateTimeStampAsDate(Date dateTimeStampAsDate) {
		this.dateTimeStampAsDate = dateTimeStampAsDate;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDocClass() {
		return docClass;
	}

	public void setDocClass(String docClass) {
		this.docClass = docClass;
	}

	public String getDocSubClass() {
		return docSubClass;
	}

	public void setDocSubClass(String docSubClass) {
		this.docSubClass = docSubClass;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getHtml() {
		return html;
	}

	public void setHtml(String html) {
		this.html = html;
	}

	public String getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(String creatorId) {
		this.creatorId = creatorId;
	}

	public String getResponsibleId() {
		return responsibleId;
	}

	public void setResponsibleId(String responsibleId) {
		this.responsibleId = responsibleId;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getSourceFacility() {
		return sourceFacility;
	}

	public void setSourceFacility(String sourceFacility) {
		this.sourceFacility = sourceFacility;
	}

	public Integer getProgramId() {
		return programId;
	}

	public void setProgramId(Integer programId) {
		this.programId = programId;
	}

	public char getStatus() {
		return status;
	}

	public void setStatus(char status) {
		this.status = status;
	}

	public String getModule() {
		return module;
	}

	public void setModule(String module) {
		this.module = module;
	}

	public String getModuleId() {
		return moduleId;
	}

	public void setModuleId(String moduleId) {
		this.moduleId = moduleId;
	}

	public String getDocPublic() {
		return docPublic;
	}

	public void setDocPublic(String docPublic) {
		this.docPublic = docPublic;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public Date getContentDateTime() {
		return contentDateTime;
	}

	public void setContentDateTime(Date contentDateTime) {
		this.contentDateTime = contentDateTime;
	}

	public String getObservationDate() {
		return observationDate;
	}

	public void setObservationDate(String observationDate) {
		this.observationDate = observationDate;
	}

	public String getReviewerId() {
		return reviewerId;
	}

	public void setReviewerId(String reviewerId) {
		this.reviewerId = reviewerId;
	}

	public String getReviewDateTime() {
		return reviewDateTime;
	}

	public void setReviewDateTime(String reviewDateTime) {
		this.reviewDateTime = reviewDateTime;
	}

	public Date getReviewDateTimeDate() {
		return reviewDateTimeDate;
	}

	public void setReviewDateTimeDate(Date reviewDateTimeDate) {
		this.reviewDateTimeDate = reviewDateTimeDate;
	}

	public String getIndivoIdx() {
		return indivoIdx;
	}

	public void setIndivoIdx(String indivoIdx) {
		this.indivoIdx = indivoIdx;
	}

	public boolean isIndivoRegistered() {
		return indivoRegistered;
	}

	public void setIndivoRegistered(boolean indivoRegistered) {
		this.indivoRegistered = indivoRegistered;
	}

	public int getNumberOfPages() {
		return numberOfPages;
	}

	public void setNumberOfPages(int numberOfPages) {
		this.numberOfPages = numberOfPages;
	}

	public Integer getAppointmentNo() {
		return appointmentNo;
	}

	public void setAppointmentNo(Integer appointmentNo) {
		this.appointmentNo = appointmentNo;
	}

}
