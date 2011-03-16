/**
 * Copyright (c) 2007-2009. CAISI, Toronto. All Rights Reserved.
 * This software is published under the GPL GNU General Public License. 
 * This program is free software; you can redistribute it and/or 
 * modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation; either version 2 
 * of the License, or (at your option) any later version. * 
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
 * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
 * along with this program; if not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
 * 
 * This software was written for 
 * CAISI, 
 * Toronto, Ontario, Canada 
 */

package org.oscarehr.common.dao;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Query;

import org.oscarehr.common.model.Preference;
import org.springframework.stereotype.Repository;

@Repository
public class PreferenceDao extends AbstractDao<Preference> {

	public PreferenceDao() {
		super(Preference.class);
	}
	
	
	public Preference findPreferenceByProviderNo(String providerNo) {

		String sqlCommand = "select * from preference where provider_no=?1 limit 1";

		Query query = entityManager.createNativeQuery(sqlCommand, modelClass);
		query.setParameter(1, providerNo);
		
				
		return getSingleResultOrNull(query);
	}

	
}
