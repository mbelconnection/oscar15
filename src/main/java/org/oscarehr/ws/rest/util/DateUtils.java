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

package org.oscarehr.ws.rest.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
	
	public static String DATE_FORMAT_1 = "dd-MMM-yyyy";
	
	/**
	 * Converts date from string to desired format.
	 * 
	 * @param fromDate			date to be converted
	 * @return					converted date
	 * @throws ParseException	when error occurs
	 */
	public static Date formatDate(String fromDate) throws ParseException {
		SimpleDateFormat f = new SimpleDateFormat(DATE_FORMAT_1);
		Date toDate = f.parse(fromDate);
		return toDate;
	}
	
	/**
	 * Converts date from date to string in desired format.
	 * 
	 * @param date				date to be converted
	 * @return					converted date
	 * @throws ParseException	when error occurs
	 */
	public static String convertDateToString(Date date) throws ParseException {
		SimpleDateFormat f = new SimpleDateFormat(DATE_FORMAT_1);
		return f.format(date);
	}

}
