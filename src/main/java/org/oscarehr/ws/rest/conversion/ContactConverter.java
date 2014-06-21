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

import org.oscarehr.common.model.Contact;
import org.oscarehr.ws.rest.to.model.ContactTo1;
import org.springframework.stereotype.Component;

@Component
public class ContactConverter extends AbstractConverter<Contact, ContactTo1> {

	@Override
	public Contact getAsDomainObject(ContactTo1 t) throws ConversionException {
		Contact d = new Contact();

		d.setId(t.getId());
		d.setFirstName(t.getFirstName());
		d.setLastName(t.getLastName());
		d.setAddress(t.getAddress());
		d.setAddress2(t.getAddress2());
		d.setCellPhone(t.getCellPhone());
		d.setCity(t.getCity());
		d.setCountry(t.getCountry());
		d.setDeleted(t.isDeleted());
		d.setEmail(t.getEmail());
		d.setFax(t.getFax());
		d.setNote(t.getNote());
		d.setPostal(t.getPostal());
		d.setProvince(t.getProvince());
		d.setResidencePhone(t.getResidencePhone());
		d.setUpdateDate(t.getUpdateDate());
		d.setWorkPhone(t.getWorkPhone());
		d.setWorkPhoneExtension(t.getWorkPhoneExtension());
		return d;
	}

	@Override
	public ContactTo1 getAsTransferObject(Contact d) throws ConversionException {
		ContactTo1 t = new ContactTo1();

		t.setId(d.getId());
		t.setFirstName(d.getFirstName());
		t.setLastName(d.getLastName());
		t.setAddress(d.getAddress());
		t.setAddress2(d.getAddress2());
		t.setCellPhone(d.getCellPhone());
		t.setCity(d.getCity());
		t.setCountry(d.getCountry());
		t.setDeleted(d.isDeleted());
		t.setEmail(d.getEmail());
		t.setFax(d.getFax());
		t.setNote(d.getNote());
		t.setPostal(d.getPostal());
		t.setProvince(d.getProvince());
		t.setResidencePhone(d.getResidencePhone());
		t.setUpdateDate(d.getUpdateDate());
		t.setWorkPhone(d.getWorkPhone());
		t.setWorkPhoneExtension(d.getWorkPhoneExtension());
		return t;
	}

}
