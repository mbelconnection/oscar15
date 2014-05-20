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
import java.util.List;

import org.apache.log4j.Logger;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.ws.rest.to.model.DemographicTo;

public class PatientBO {
	
	private static Logger log = MiscUtils.getLogger();

	public static List<DemographicTo> copy(List<Demographic> src, List<DemographicTo> dest, String searchType) {
		log.debug("PatientBO.copy() starts");
		if (null != src && !src.isEmpty()) {
			dest = new ArrayList<DemographicTo>(src.size());
			DemographicTo demographicTo = null;
			for (Demographic demographic : src) {
				demographicTo = new DemographicTo();
				demographicTo.setDemographicNo(demographic.getDemographicNo().toString());
				if ("FN".equals(searchType)) {
					demographicTo.setName(demographic.getFirstName() + ", " + demographic.getLastName());
				} else {
					demographicTo.setName(demographic.getLastName() + ", " + demographic.getFirstName());
				}
				dest.add(demographicTo);
			}
		}
		log.debug("PatientBO.copy() ends");
		return dest;
	}

}
