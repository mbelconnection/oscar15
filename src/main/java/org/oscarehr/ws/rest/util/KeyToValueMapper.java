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

import java.util.HashMap;
import java.util.Map;

public class KeyToValueMapper {
	
	public static Map<String, String> statusValues = new HashMap<String, String>();
	
	public static Map<String, String> typeValues = new HashMap<String, String>();
	
	public static String getStatusValue(String key) {
		if (null == key || "".equals(key)) {
			return "";
		}
		if (null == statusValues || statusValues.isEmpty()) {
			statusValues.put("t", "TD");
			statusValues.put("T", "DP");
			statusValues.put("H", "HR");
			statusValues.put("P", "PK");
			statusValues.put("E", "EM");
			statusValues.put("a", "C1");
			statusValues.put("b", "C2");
			statusValues.put("c", "C3");
			statusValues.put("d", "C4");
			statusValues.put("e", "C5");
			statusValues.put("N", "NS");
			statusValues.put("C", "CX");
			statusValues.put("B", "BL");
			statusValues.put("TD", "t");
			statusValues.put("DP", "T");
			statusValues.put("HR", "R");
			statusValues.put("PK", "P");
			statusValues.put("EM", "E");
			statusValues.put("C1", "a");
			statusValues.put("C2", "b");
			statusValues.put("C3", "c");
			statusValues.put("C4", "d");
			statusValues.put("C5", "e");
			statusValues.put("NS", "N");
			statusValues.put("CX", "C");
			statusValues.put("BL", "B");
		}
		return key;
		
	}
	
	public static String getTypeValue(String key) {
		if (null == key || "".equals(key)) {
			return "";
		}
		if (null == typeValues || typeValues.isEmpty()) {
			typeValues.put("1", "E");
			typeValues.put("2", "I");
			typeValues.put("3", "B");
			typeValues.put("4", "R");
			typeValues.put("E", "1");
			typeValues.put("I", "2");
			typeValues.put("B", "3");
			typeValues.put("R", "4");
		}
		return typeValues.get(key);
		
	}
	
}
