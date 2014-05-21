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
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;

@XmlRootElement
@JsonIgnoreProperties(ignoreUnknown = true)
@XmlAccessorType(XmlAccessType.PROPERTY)
public class OscarResponseTo implements Serializable {

    private static final long serialVersionUID = 1L;
    
	private List<ProviderTo> providers;
	
	private List<AppointmentStatusTo> appointmentStatus;
	
	private AppointmentTo appointments;
	
	private List<AppointmentReasonTo> appointmentReason;
	
	public List<AppointmentReasonTo> getAppointmentReason() {
		return appointmentReason;
	}

	public void setAppointmentReason(List<AppointmentReasonTo> appointmentReason) {
		this.appointmentReason = appointmentReason;
	}

	public AppointmentTo getAppointments() {
		return appointments;
	}

	public void setAppointments(AppointmentTo appointments) {
		this.appointments = appointments;
	}

	public List<AppointmentStatusTo> getAppointmentStatus() {
		return appointmentStatus;
	}

	public void setAppointmentStatus(List<AppointmentStatusTo> appointmentStatus) {
		this.appointmentStatus = appointmentStatus;
	}

	private List<AppointmentTypeTo> appointmentTypes;

	public List<AppointmentTypeTo> getAppointmentTypes() {
		return appointmentTypes;
	}

	public void setAppointmentTypes(List<AppointmentTypeTo> appointmentTypes) {
		this.appointmentTypes = appointmentTypes;
	}

	public List<ProviderTo> getProviders() {
		return providers;
	}

	public void setProviders(List<ProviderTo> providers) {
		this.providers = providers;
	}
	

	
}
