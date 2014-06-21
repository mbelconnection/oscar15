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
package org.oscarehr.ws.rest.conversion;

import org.oscarehr.common.model.DemographicContact;
import org.oscarehr.ws.rest.to.model.DemographicContactTo1;
import org.springframework.stereotype.Component;

@Component
public class DemographicContactConverter extends AbstractConverter<DemographicContact, DemographicContactTo1> {

	@Override
	public DemographicContact getAsDomainObject(DemographicContactTo1 t) throws ConversionException {
		DemographicContact d = new DemographicContact();
		
		d.setId(t.getId());
		d.setContactId(t.getContactId());
		d.setContactName(t.getContactName());
		d.setActive(t.isActive());
		d.setCategory(t.getCategory());
		d.setConsentToContact(t.isConsentToContact());
		d.setCreated(t.getCreated());
		d.setCreator(t.getCreator());
		d.setDeleted(t.isDeleted());
		d.setDemographicNo(t.getDemographicNo());
		d.setEc(t.getEc());
		d.setFacilityId(t.getFacilityId());
		d.setNote(t.getNote());
		d.setRole(t.getRole());
		d.setSdm(t.getSdm());
		d.setType(t.getType());
		d.setUpdateDate(t.getUpdateDate());
		return d;
	}

	@Override
	public DemographicContactTo1 getAsTransferObject(DemographicContact d) throws ConversionException {
		DemographicContactTo1 t = new DemographicContactTo1();
		
		t.setId(d.getId());
		t.setContactId(d.getContactId());
		t.setContactName(d.getContactName());
		t.setActive(d.isActive());
		t.setCategory(d.getCategory());
		t.setConsentToContact(d.isConsentToContact());
		t.setCreated(d.getCreated());
		t.setCreator(d.getCreator());
		t.setDeleted(d.isDeleted());
		t.setDemographicNo(d.getDemographicNo());
		t.setEc(d.getEc());
		t.setFacilityId(d.getFacilityId());
		t.setNote(d.getNote());
		t.setRole(d.getRole());
		t.setSdm(d.getSdm());
		t.setType(d.getType());
		t.setUpdateDate(d.getUpdateDate());
		return t;
	}

}
