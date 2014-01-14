/**
 * Copyright (c) 2013-2020. Department of Family Medicine, McMaster University. All Rights Reserved.
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
package org.oscarehr.common.model;

import java.io.Serializable;
import java.util.List;

public class TicklerData implements Serializable {
	
    private static final long serialVersionUID = 195843877390252842L;
	private String id;
	private String programId;
	private String message;
	private String status;
	private String updateDate;
	private String serviceDate;
	private String priority;
	private String demographicName;
	private String demographicNo;
	private String providerName;
	private String providerNo;
	private String assigneeName;
	private String assigneeNo;
	private String program;
	private String programNo;
	private String demographicWebName;
	private String taskAssignedToName;
	private boolean editable = false;
	private List<TicklerCommentData> ticklerComments;
	private List<String> ticklerHRefs;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getProgramId() {
		return programId;
	}
	public void setProgramId(String programId) {
		this.programId = programId;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public String getServiceDate() {
		return serviceDate;
	}
	public void setServiceDate(String serviceDate) {
		this.serviceDate = serviceDate;
	}
	public String getPriority() {
		return priority;
	}
	public void setPriority(String priority) {
		this.priority = priority;
	}
	public String getDemographicName() {
		return demographicName;
	}
	public void setDemographicName(String demographicName) {
		this.demographicName = demographicName;
	}
	public String getDemographicNo() {
		return demographicNo;
	}
	public void setDemographicNo(String demographicNo) {
		this.demographicNo = demographicNo;
	}
	public String getProviderName() {
		return providerName;
	}
	public void setProviderName(String providerName) {
		this.providerName = providerName;
	}
	public String getProviderNo() {
		return providerNo;
	}
	public void setProviderNo(String providerNo) {
		this.providerNo = providerNo;
	}
	public String getAssigneeName() {
		return assigneeName;
	}
	public void setAssigneeName(String assigneeName) {
		this.assigneeName = assigneeName;
	}
	public String getAssigneeNo() {
		return assigneeNo;
	}
	public void setAssigneeNo(String assigneeNo) {
		this.assigneeNo = assigneeNo;
	}
	public String getProgram() {
		return program;
	}
	public void setProgram(String program) {
		this.program = program;
	}
	public String getProgramNo() {
		return programNo;
	}
	public void setProgramNo(String programNo) {
		this.programNo = programNo;
	}
	public String getDemographicWebName() {
		return demographicWebName;
	}
	public void setDemographicWebName(String demographicWebName) {
		this.demographicWebName = demographicWebName;
	}
	public String getTaskAssignedToName() {
		return taskAssignedToName;
	}
	public void setTaskAssignedToName(String taskAssignedToName) {
		this.taskAssignedToName = taskAssignedToName;
	}
	public boolean isEditable() {
		return editable;
	}
	public void setEditable(boolean editable) {
		this.editable = editable;
	}
	public List<String> getTicklerHRefs() {
		return ticklerHRefs;
	}
	public void setTicklerHRefs(List<String> ticklerHRefs) {
		this.ticklerHRefs = ticklerHRefs;
	}
	public List<TicklerCommentData> getTicklerComments() {
		return ticklerComments;
	}
	public void setTicklerComments(List<TicklerCommentData> ticklerComments) {
		this.ticklerComments = ticklerComments;
	}
}

