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

package org.oscarehr.ws.rest.bo;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.to.model.EventsTo1;
import org.oscarehr.ws.rest.to.model.ProviderAndEventSearchResults;
import org.oscarehr.ws.rest.to.model.ProvidersTo1;
import org.oscarehr.ws.rest.util.DateUtils;

public class ScheduleBO {
	
	private static Logger log = MiscUtils.getLogger();
	
	/**
	 * Copies data from source bean to destination bean.
	 * 
	 * @param src		source
	 * @param dest		destination
	 * @param day		day
	 * @return			bean
	 */
	public static ProviderAndEventSearchResults setProvidersAndEvents(List<ProvidersTo1> providersTo, List<EventsTo1> eventsTo, String day) {
		log.debug("ScheduleBO.setProvidersAndEvents() starts");
		ProviderAndEventSearchResults results = new ProviderAndEventSearchResults();
		results.setProviders(providersTo);
		results.setEvents(eventsTo);
		results.setDay(day);
		log.debug("ScheduleBO.setProvidersAndEvents() ends");
		return results;
	}
	
	/**
	 * Copies data from source bean to destination bean.
	 * 
	 * @param src		source
	 * @param dest		destination
	 * @param day		day
	 * @return			bean
	 */
	public static ProviderAndEventSearchResults setProvidersAndEventsForWeek(String startDay, String endDay,
			List<ProvidersTo1> providers, List<EventsTo1> events) throws Exception {
		log.debug("ScheduleBO.setProvidersAndEventsForWeek() starts");
		ProviderAndEventSearchResults results = new ProviderAndEventSearchResults();
		List<String> weekDays = new ArrayList<String>();
		Date endDate = DateUtils.formatDate(endDay);
		Date startDate = DateUtils.formatDate(startDay);
		int days =(int)( (endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24));
		days = days+1;
		Calendar cal = Calendar.getInstance();
		cal.setTime(startDate);
		for (int i = 0; i < days; i++) {
			weekDays.add(DateUtils.convertDateToString(cal.getTime()));
			cal.add(Calendar.DATE, 1);
		}
		results.setDays(weekDays);
		results.setEvents(events);
		results.setProviders(providers);
		log.debug("ScheduleBO.setProvidersAndEventsForWeek() ends");
		return results;
	}

}
