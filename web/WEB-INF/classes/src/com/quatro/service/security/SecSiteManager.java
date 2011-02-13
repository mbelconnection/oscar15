/*******************************************************************************
 * Copyright (c) 2008, 2009 Quatro Group Inc. and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU General Public License
 * which accompanies this distribution, and is available at
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Contributors:
 *     <Quatro Group Software Systems inc.>  <OSCAR Team>
 *******************************************************************************/
package com.quatro.service.security;
import java.util.*;
import com.quatro.model.security.SecSiteValue;
import com.quatro.dao.security.SecSiteDao;
import com.quatro.util.Utility;
public class SecSiteManager {
	SecSiteDao _dao = null;
	
	public void setSecSiteDao(SecSiteDao dao)
	{
		_dao = dao;
	}
	
	public void setSiteKey(String siteId, int siteKey)
	{
		SecSiteValue ssv = _dao.getSecSiteValue(siteId);
		if (ssv == null) {
			ssv = new SecSiteValue();
			ssv.setActive(true);
			ssv.setCreatedDate(Calendar.getInstance().getTime());
			ssv.setLastAccessed(ssv.getCreatedDate());
			ssv.setSiteId(siteId);
			ssv.setSiteKey(siteKey);
		}
		ssv.setSiteId(siteId);
		ssv.setSiteKey(siteKey);
		
		_dao.Save(ssv);
	}
	
	public boolean isKeyValid(String siteId, int siteKey)
	{
		boolean isValid = false;
		SecSiteValue ssv = _dao.getSecSiteValue(siteId);
		if (ssv != null)
		{
			if (ssv.isActive()  && siteKey == ssv.getSiteKey())
			{
				isValid = true;
			}
		}
		return isValid;
	}
	public int generateNewKey()
	{
		Random rnd = new Random(Calendar.getInstance().getTimeInMillis());
		double d = rnd.nextDouble();
		while (d < 0.1)
		{
			d = rnd.nextDouble();
		}
		return (int) Math.ceil(d*1000000);
	}
	public boolean isSiteExempted(String ip)
	{
		return false;
	}
}
