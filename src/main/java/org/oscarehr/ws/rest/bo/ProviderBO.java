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

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.oscarehr.common.dao.ScheduleDateDao;
import org.oscarehr.common.dao.ScheduleTemplateDao;
import org.oscarehr.common.model.Provider;
import org.oscarehr.common.model.ScheduleDate;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.to.model.EventsTo1;
import org.oscarehr.ws.rest.to.model.ProviderTo;
import org.oscarehr.ws.rest.to.model.ProvidersTo1;
import org.oscarehr.ws.rest.util.DateUtils;

public class ProviderBO {
	
	private static Logger log = MiscUtils.getLogger();
	
	/**
	 * Copies data from source bean to destination bean.
	 * 
	 * @param src		source
	 * @param dest		destination
	 * @return			bean
	 */
	public static List<ProviderTo> copy(List<Provider> src, List<ProviderTo> dest, String searchType) {
		log.debug("ProviderBO.copy() starts");
		if (null != src && !src.isEmpty()) {
			dest = new ArrayList<ProviderTo>(src.size());
			ProviderTo providerTo = null;
			for (Provider provider : src) {
				providerTo = new ProviderTo();
				providerTo.setId(provider.getProviderNo());
				if ("FN".equals(searchType)) {
					providerTo.setLabel(provider.getFirstName() + ", " + provider.getLastName());
				} else {
					providerTo.setLabel(provider.getLastName() + ", " + provider.getFirstName());
				}
				providerTo.setCategory("");
				dest.add(providerTo);
			}
		}
		log.debug("ProviderBO.copy() ends");
		return dest;
	}
	
	/**
	 * Copies data from source bean to destination bean.
	 * 
	 * @param src		source
	 * @param dest		destination
	 * @return			bean
	 */
	public static List<ProvidersTo1> copyProviders(List<Provider> src, List<ProvidersTo1> dest,ScheduleDateDao scheduleDao,ScheduleTemplateDao scheduleTempDao,String sDate) {
		log.debug("ProviderBO.copyProviders() starts");
		ScheduleDate itemsLst=null;
		if (null != src && !src.isEmpty()) {
			dest = new ArrayList<ProvidersTo1>(src.size());
			ProvidersTo1 providerTo1 = null;
			for (Provider provider : src) {
				providerTo1 = new ProvidersTo1();
				providerTo1.setId(provider.getProviderNo());
				providerTo1.setName((null == provider.getTitle() ? "" : provider.getTitle()) + provider.getFirstName() + " " + provider.getLastName());
				providerTo1.setGroup(provider.getTeam());
				
				itemsLst = new ScheduleDate();
				try {
	                itemsLst = scheduleDao.findByProviderNoAndDate(provider.getProviderNo(), DateUtils.formatDate(sDate));
                } catch (ParseException e) {
	                // TODO Auto-generated catch block
                	log.error("copyProviders " + e);
                }
				if(itemsLst!=null){
					String template =  scheduleTempDao.findByName(itemsLst.getHour().trim(),itemsLst.getProviderNo());
					providerTo1.setFlipData(template);
				}
				dest.add(providerTo1);
			}
		}
		log.debug("ProviderBO.copyProviders() ends");
		return dest;
	}
	
	
	/**
	 * Copies data from source bean to destination bean.
	 * 
	 * @param src		source
	 * @param dest		destination
	 * @return			bean
	 */
	public static List<ProvidersTo1> copyProviders(List<Provider> src, List<ProvidersTo1> dest) {
		log.debug("ProviderBO.copyProviders() starts");
		
		if (null != src && !src.isEmpty()) {
			dest = new ArrayList<ProvidersTo1>(src.size());
			ProvidersTo1 providerTo1 = null;
			for (Provider provider : src) {
				providerTo1 = new ProvidersTo1();
				providerTo1.setId(provider.getProviderNo());
				providerTo1.setName((null == provider.getTitle() ? "" : provider.getTitle()) + provider.getFirstName() + " " + provider.getLastName());
				providerTo1.setGroup(provider.getTeam());
				
				dest.add(providerTo1);
			}
		}
		log.debug("ProviderBO.copyProviders() ends");
		return dest;
	}
	
	/**
	 * Returns provider numbers.
	 * 
	 * @param events		source to get provider numbers
	 * @return				provider numbers
	 */
	public static Object []getUniqueProviders(List<EventsTo1> events) {
		log.debug("ProviderBO.getUniqueProviders() starts");
		Set<String> uniqueProviders = new HashSet<String>();
		for (EventsTo1 event : events) {
			uniqueProviders.add(event.getDocId());
		}
		log.debug("ProviderBO.getUniqueProviders() ends");
		return uniqueProviders.toArray();
	}

}
