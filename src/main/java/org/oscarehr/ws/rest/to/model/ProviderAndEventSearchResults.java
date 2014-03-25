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
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class ProviderAndEventSearchResults implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@XmlElement(name="day")
	public String getDay() {
		return day;
	}

	public void setDay(String day) {
		this.day = day;
	}

	private String day;

	private List<EventsTo1> events = new ArrayList<EventsTo1>();

	private List<ProvidersTo1> providers = new ArrayList<ProvidersTo1>();

	@XmlElement(name="eventsDB")
	public  List<EventsTo1> getEvents() {
		return events;
	}

	public void setEvents( List<EventsTo1> events) {
		this.events = events;
	}

	@XmlElement(name="providersDB")
	public  List<ProvidersTo1> getProviders() {
		return providers;
	}

	public void setProviders( List<ProvidersTo1> providers) {
		this.providers = providers;
	}

	
}
