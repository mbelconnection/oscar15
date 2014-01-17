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
package org.oscarehr.ticklers.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.oscarehr.common.dao.TicklerLinkDao;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.Tickler;
import org.oscarehr.common.model.Tickler.STATUS;
import org.oscarehr.common.model.TicklerComment;
import org.oscarehr.common.model.TicklerCommentData;
import org.oscarehr.common.model.TicklerData;
import org.oscarehr.common.model.TicklerLink;
import org.oscarehr.common.model.TicklerLinkData;
import org.oscarehr.ticklers.service.TicklerService;
import org.oscarehr.util.PaginationUtils;
import org.oscarehr.util.SpringUtils;

import oscar.OscarProperties;
import oscar.oscarLab.ca.on.LabResultData;

public class TicklerAction extends Action {
	private TicklerLinkDao ticklerLinkDao = (TicklerLinkDao) SpringUtils.getBean("ticklerLinkDao");
	private TicklerService ticklerService = (TicklerService) SpringUtils.getBean(TicklerService.class);
	private PaginationUtils paginationUtils = new PaginationUtils();

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
				
		//grab and execute query
		TicklerQuery query = buildTicklerQuery(request);
		
		//sort out the totals
		Map<String, Object> map = new HashMap<String, Object>();
		int total = ticklerService.getTicklersCount(query);
		map.put("iTotalRecords", total);
		map.put("iTotalDisplayRecords", total);
		
		//these are our display objects
		List<TicklerData> list = new ArrayList<TicklerData>();
		for (Tickler tickler : ticklerService.getTicklers(query)) {
			TicklerData data = convertToTicklerDataObject(tickler,request);
			list.add(data);
		}
		map.put("aaData", JSONArray.fromObject(list));

		//return as JSON
		JSONObject jsonObject = JSONObject.fromObject(map);
		PrintWriter out = null;
		try {
			if (null != jsonObject) {
				out = response.getWriter();
				response.getWriter().print(jsonObject.toString());
			}
		} catch (IOException e1) {

		} finally {
			if (null != out) {
				out.close();
			}
		}
		return null;
	}
	
	private TicklerQuery buildTicklerQuery(HttpServletRequest request) {
		
		TicklerQuery query = new TicklerQuery();
		this.paginationUtils.loadPaginationQuery(request, query);
		
		if(request.getParameter("startDate") == null || "".equals(request.getParameter("startDate"))) {
    	   query.setStartDateStr("1950-01-01");
    	   Calendar startDate = Calendar.getInstance();
    	   startDate.set(Calendar.DATE,1);
    	   startDate.set(Calendar.MONTH,1);
    	   startDate.set(Calendar.YEAR,1950);
    	   query.setStartDate(startDate.getTime());
		}else {
    	   query.setStartDate(parseDate(request.getParameter("startDate"),request.getLocale()));
       	   query.setStartDateStr(request.getParameter("startDate"));
       	}

       	if(request.getParameter("endDate") == null || "".equals(request.getParameter("endDate"))) {
       	   Calendar now=Calendar.getInstance();
    	   query.setEndDateStr(DateFormatUtils.format(now,"yyyy-MM-dd"));
    	   query.setEndDate(now.getTime());
       	}else {
     	   query.setEndDate(parseDate(request.getParameter("endDate"),request.getLocale()));
       	   query.setEndDateStr(request.getParameter("endDate"));
       	}
       	
       	if(request.getParameter("status") == null || "".equals(request.getParameter("status"))) {
       		query.setStatus(STATUS.A.toString());
       	} else {
       		query.setStatus(request.getParameter("status"));
       	}
		query.setWithOption(request.getParameter("withOption"));
		
       	if(request.getParameter("mrpIds") != null && !"".equals(request.getParameter("mrpIds"))) {
       		String[] mrps = request.getParameter("mrpIds").split(",");
       		query.setMrps(mrps);
       	}
		
       	if(request.getParameter("providerIds") != null && !"".equals(request.getParameter("providerIds"))) {
       		String[] providerIds = request.getParameter("providerIds").split(",");
       		query.setProviders(providerIds);
       	}
	
       	if(request.getParameter("siteIds") != null && !"".equals(request.getParameter("siteIds"))) {
       		String[] siteIds = request.getParameter("siteIds").split(",");
       		query.setSites(siteIds);
       	}

       	if(request.getParameter("assignedToIds") != null && !"".equals(request.getParameter("assignedToIds"))) {
       		String[] assignedToIds = request.getParameter("assignedToIds").split(",");
       		query.setAssignees(assignedToIds);
       	}
		
		return query;
	}
	
	private TicklerData convertToTicklerDataObject(Tickler t, HttpServletRequest request) {
		
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:ss:mm.SSS", request.getLocale());
	 	String userNo = (String) request.getSession().getAttribute("user");
		//get the data i need to support
		TicklerData data = new TicklerData();
		
        Demographic demo = t.getDemographic(); 
        
//        String vGrantdate = "1980-01-07 00:00:00.0";
//        vGrantdate = t.getServiceDate() + " 00:00:00.0";
//        Date grantdate = null;
//        try {
//	        grantdate = dateFormat.parse(vGrantdate);
//        } catch (ParseException e) {
//        }
//        java.util.Date toDate = new java.util.Date();
//        long millisDifference = toDate.getTime() - grantdate.getTime();
//
//        long ONE_DAY_IN_MS = (1000 * 60 * 60 * 24);                                                      
//        long daysDifference = millisDifference / (ONE_DAY_IN_MS);
//
//        String numDaysUntilWarn = OscarProperties.getInstance().getProperty("tickler_warn_period");
//        long ticklerWarnDays = Long.parseLong(numDaysUntilWarn);
//        boolean ignoreWarning = (ticklerWarnDays < 0);
        
        
        //Set the colour of the table cell 
//        String warnColour = "";
//        if (!ignoreWarning && (daysDifference >= ticklerWarnDays)){
//            warnColour = "Red";
//        }
//        String rowColour = "lilac";
//        if (rowColour.equals("lilac")){
//            rowColour = "white";
//        }else {
//            rowColour = "lilac";
//        }
        
//        String cellColour = rowColour + warnColour;
        
        data.setId(String.valueOf(t.getId()));
        data.setDemographicName(demo.getLastName() + "," + demo.getFirstName());
        data.setDemographicNo(String.valueOf(demo.getDemographicNo()));
        data.setProviderName(t.getProvider() == null ? "N/A" : t.getProvider().getFormattedName());  
        data.setServiceDate(DateFormatUtils.format(t.getServiceDate(),"yyyy-MM-dd hh:ss:mm.SSS"));       
        data.setUpdateDate(DateFormatUtils.format(t.getUpdateDate(),"yyyy-MM-dd hh:ss:mm.SSS"));
        data.setPriority(t.getPriority().name());
        data.setAssigneeName(t.getAssignee() != null ? t.getAssignee().getLastName() + ", " + t.getAssignee().getFirstName() : "N/A");
		data.setStatus(t.getStatusDesc(request.getLocale()));
		data.setMessage(t.getMessage());
		String href;
		TicklerLinkData ticklerLink;
		List<TicklerLink> linkList = ticklerLinkDao.getLinkByTickler(t.getId().intValue());
        if (linkList != null && linkList.size()>0){
    		List<String> links = new ArrayList<String>();
    		List<TicklerLinkData> ticklerLinkList = new ArrayList<TicklerLinkData>();
            for(TicklerLink tl : linkList){
                String type = tl.getTableName();	
                ticklerLink = new TicklerLinkData();
        		if ( LabResultData.isMDS(type) ){
        			href = "<a href=\"javascript:reportWindow('SegmentDisplay.jsp?segmentID=" + tl.getTableId() + "&providerNo=" + userNo + "&searchProviderNo=" + userNo + "&status=')\">ATT</a>";
//        			ticklerLink.setLinkName("ATT");
//        			ticklerLink.setTableId(String.valueOf(tl.getTableId()));
//        			ticklerLink.setTicklerNo(String.valueOf(tl.getTicklerNo()));
//        			ticklerLink.setLinkHref(href);
//        			ticklerLinkList.add(ticklerLink);
        			links.add(href);
        		}else if (LabResultData.isCML(type)){
        			href = "<a href=\"javascript:reportWindow('" + request.getContextPath() + "/lab/CA/ON/CMLDisplay.jsp?segmentID=" + tl.getTableId() + "&providerNo=" + userNo + "&searchProviderNo=" + userNo + "&status=')\">ATT</a>";
//        			ticklerLink.setLinkName("ATT");
//        			ticklerLink.setTableId(String.valueOf(tl.getTableId()));
//        			ticklerLink.setTicklerNo(String.valueOf(tl.getTicklerNo()));
//        			ticklerLink.setLinkHref(href);
//        			ticklerLinkList.add(ticklerLink);
        		
        			links.add(href);
        		
        		}else if (LabResultData.isHL7TEXT(type)){
        			href = "<a href=\"javascript:reportWindow('" + request.getContextPath() + "/lab/CA/ALL/labDisplay.jsp?segmentID=" + tl.getTableId() + "&providerNo=" + userNo + "&searchProviderNo=" + userNo + "&status=')\">ATT</a>";
//        			ticklerLink.setLinkName("ATT");
//        			ticklerLink.setTableId(String.valueOf(tl.getTableId()));
//        			ticklerLink.setTicklerNo(String.valueOf(tl.getTicklerNo()));
//        			ticklerLink.setLinkHref(href);
//        			ticklerLinkList.add(ticklerLink);
        		
        			links.add(href);
        		}else if (LabResultData.isDocument(type)){
        			href = "<a href=\"javascript:reportWindow('" + request.getContextPath() + "/dms/ManageDocument.do?method=display&doc_no=" + tl.getTableId() + "&providerNo=" + userNo + "&searchProviderNo=" + userNo + "&status=')\">ATT</a>";
//
//        			ticklerLink.setLinkName("ATT");
//        			ticklerLink.setTableId(String.valueOf(tl.getTableId()));
//        			ticklerLink.setTicklerNo(String.valueOf(tl.getTicklerNo()));
//        			ticklerLink.setLinkHref(href);
//        			ticklerLinkList.add(ticklerLink);
        			links.add(href);
        		}else {
        			href = "<a href=\"javascript:reportWindow('" + request.getContextPath() + "/lab/CA/BC/labDisplay.jsp?segmentID=" + tl.getTableId() + "&providerNo=" + userNo + "&searchProviderNo=" + userNo + "&status=')\">ATT</a>";
//        			ticklerLink.setLinkName("ATT");
//        			ticklerLink.setTableId(String.valueOf(tl.getTableId()));
//        			ticklerLink.setTicklerNo(String.valueOf(tl.getTicklerNo()));
//        			ticklerLink.setLinkHref(href);
//        			ticklerLinkList.add(ticklerLink);
        			links.add(href);
        		}
        		data.setTicklerHRefs(links);	
//        		data.setTicklerLinks(ticklerLinkList);

			}
            
		}
        
    	boolean ticklerEditEnabled = Boolean.parseBoolean(OscarProperties.getInstance().getProperty("tickler_edit_enabled")); 
    	ticklerEditEnabled = true;
        Set<TicklerComment> tcomments = t.getComments();
		TicklerCommentData ticklerComment;
		List<TicklerCommentData> ticklerComments = new ArrayList<TicklerCommentData>();
        
		if (ticklerEditEnabled && !tcomments.isEmpty()) {
			for(TicklerComment tc : tcomments) {
				ticklerComment = new TicklerCommentData();
				ticklerComment.setProviderName(tc.getProvider().getLastName() + "," + tc.getProvider().getFirstName());
				ticklerComment.setMessage(tc.getMessage());
				if (tc.isUpdateDateToday()) { 
					ticklerComment.setUpdateDateTime(tc.getUpdateTime(request.getLocale()));
				} else { 
					ticklerComment.setUpdateDateTime(tc.getUpdateDate(request.getLocale()));
				}
				ticklerComments.add(ticklerComment);
			}
			data.setTicklerComments(ticklerComments);
		}

		return data;
	}	
	
	
	
	private Date parseDate(String s, Locale locale) {
		
		if (s==null || s.trim().isEmpty()) {
			return null;
		}
		
		String dateFormatString = OscarProperties.getInstance().getProperty("DATE_FORMAT");	
		
		SimpleDateFormat dateFormatter=null;
		
		if (locale == null) {
			dateFormatter = new SimpleDateFormat(dateFormatString);
		}
		else {
			dateFormatter = new SimpleDateFormat(dateFormatString, locale);
		}

		try {
	        return (dateFormatter.parse(s));
        } catch (ParseException e) {
        	return null;
        }
	}	
}
