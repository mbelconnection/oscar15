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
package org.oscarehr.common.dao;

import static org.junit.Assert.assertNotNull;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.oscarehr.common.dao.utils.SchemaUtils;
import org.oscarehr.common.model.Billing;
import org.oscarehr.util.DateRange;
import org.oscarehr.util.SpringUtils;

public class BillingDaoTest extends DaoTestFixtures {

	private BillingDao dao = SpringUtils.getBean(BillingDao.class);

	@Before
	public void before() throws Exception {
		SchemaUtils.restoreTable("billing", "billingdetail","billingmaster");
	}

	@Test
	public void testFindBillings() {
		List<Object[]> billings = dao.findBillings(1, new ArrayList<String>());
		assertNotNull(billings);

		billings = dao.findBillings(1, Arrays.asList(new String[] { "BLIYSD", "GVNUIO" }));
		assertNotNull(billings);
	}

	@Test
	public void testFindOtherBillings() {
		List<Billing> bs = dao.findBillings(1, "STA", "01", new Date(), new Date());
		assertNotNull(bs);

		bs = dao.findBillings(1, "STA", "01", new Date(), new Date());
		assertNotNull(bs);

		bs = dao.findBillings(1, "STA", "01", null, new Date());
		assertNotNull(bs);

		bs = dao.findBillings(1, "STA", "01", new Date(), null);
		assertNotNull(bs);

		bs = dao.findBillings(1, "STA", null, new Date(), new Date());
		assertNotNull(bs);

		bs = dao.findBillings(null, "STA", null, null, null);
		assertNotNull(bs);
	}

	@Test
	public void testFindMoreBillings() {
		List<Object[]> bs = dao.findBillings(10);
		assertNotNull(bs);
	}
	
	@Test
	public void testFindByProviderStatusAndDates() {
		assertNotNull(dao.findByProviderStatusAndDates("100", new ArrayList<String>(), null));
		assertNotNull(dao.findByProviderStatusAndDates("100", new ArrayList<String>(), new DateRange(null, null)));
		assertNotNull(dao.findByProviderStatusAndDates("100", new ArrayList<String>(), new DateRange(new Date(), null)));
		assertNotNull(dao.findByProviderStatusAndDates("100", new ArrayList<String>(), new DateRange(null, new Date())));
		assertNotNull(dao.findByProviderStatusAndDates("100", Arrays.asList(new String[] {"A", "B", "C"}), null));
		
	}
	
	@Test
	public void testGetMyMagicBillings() {
		assertNotNull(dao.getMyMagicBillings());
	}
}