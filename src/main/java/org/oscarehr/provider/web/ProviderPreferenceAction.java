/**
 *
 * Copyright (c) 2005-2012. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved.
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
 * This software was written for
 * Centre for Research on Inner City Health, St. Michael's Hospital,
 * Toronto, Ontario, Canada
 */
package org.oscarehr.provider.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.oscarehr.common.dao.ProviderPreferenceDao;
import org.oscarehr.common.model.Provider;
import org.oscarehr.common.model.ProviderPreference;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.SpringUtils;

public class ProviderPreferenceAction extends DispatchAction{
    
    private ProviderPreferenceDao providerPreferenceDao = (ProviderPreferenceDao) SpringUtils.getBean("providerPreferenceDao");
    
    public ActionForward switchViewSchedule(ActionMapping actionMapping, ActionForm actionForm,HttpServletRequest request,HttpServletResponse response) {
        
        LoggedInInfo loggedInInfo = LoggedInInfo.loggedInInfo.get();		
        Provider provider = loggedInInfo.loggedInProvider;

        ProviderPreference providerPreference = providerPreferenceDao.find(provider.getProviderNo());
        if (providerPreference == null) {
                providerPreference = new ProviderPreference();
                providerPreference.setProviderNo(provider.getProviderNo());
                providerPreferenceDao.persist(providerPreference);
        }
        
        String viewScheduleStr = request.getParameter("viewSchedule");
        Integer viewSchedule = ProviderPreference.VIEW_ALL;
        
        if (viewScheduleStr != null) {
            viewSchedule = Integer.parseInt(viewScheduleStr);
        }
        
        providerPreference.setViewSchedule(viewSchedule);                
        providerPreferenceDao.merge(providerPreference);

        return null;
    }
}
