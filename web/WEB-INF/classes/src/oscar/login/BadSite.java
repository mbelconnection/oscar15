/*
 *
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
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
 * <Quatro Group>
 *
 * This software was written for the
 * Department of Family Medicine
 * McMaster Unviersity
 * Hamilton
 * Ontario, Canada
 */
/*
 *
 */

package oscar.login;

import java.util.Calendar;

/**
 * Class LoginInfoBean : set login status when bWAN = true 2003-01-29
 */
public final class BadSite {
    private Calendar lastupdatetime = null;
    private int times = 0;
    private int status = 0; // 1 - over writed by admin, 0 - block out
    private String siteId;
    private String siteKey;
    private String ip;
    public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public BadSite() {
    }
    public void setLastUpdateTime(Calendar lastupdatetime1) {
        lastupdatetime = lastupdatetime1;
    }

    public String getStatusDesc()
    {
    	if (status ==0) return "No";
    	else return "Yes";
    }
    public void setStatus(int status1) {
        status = status1;
    }

    public Calendar getLastUpdateTime() {
        return (lastupdatetime);
    }

    public int getStatus() {
        return (status);
    }
	public String getSiteId() {
		return siteId;
	}
	public void setSiteId(String siteId) {
		this.siteId = siteId;
	}
	public String getSiteKey() {
		return siteKey;
	}
	public void setSiteKey(String siteKey) {
		this.siteKey = siteKey;
	}
	public int getTimes() {
		return times;
	}
	public void setTimes(int times) {
		this.times = times;
	}
}