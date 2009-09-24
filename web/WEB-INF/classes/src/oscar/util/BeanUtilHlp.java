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
// -----------------------------------------------------------------------------------------------------------------------
// *
// *
// * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
// * This software is published under the GPL GNU General Public License.
// * This program is free software; you can redistribute it and/or
// * modify it under the terms of the GNU General Public License
// * as published by the Free Software Foundation; either version 2
// * of the License, or (at your option) any later version. *
// * This program is distributed in the hope that it will be useful,
// * but WITHOUT ANY WARRANTY; without even the implied warranty of
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License
// * along with this program; if not, write to the Free Software
// * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *
// *
// * <OSCAR TEAM>
// * This software was written for the
// * Department of Family Medicine
// * McMaster Unviersity
// * Hamilton
// * Ontario, Canada
// *
// -----------------------------------------------------------------------------------------------------------------------

package oscar.util;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;

import com.quatro.util.Utility;

import oscar.MyDateFormat;

/**
 * <p>Title:BeanUtil </p>
 *
 * <p>Description: BeanUtil Provides a simplified interface for dynamically manipulating a Java Bean via reflection</p>
 *
 * @author Joel Legris
 * @version 1.0
 */
public class BeanUtilHlp {
  public BeanUtilHlp() {
  }

  /**
 * A convenience method used to retrieve the field value of a specified JavaBean
 * @param bill Object
 * @param fieldName String
 * @return Object
 */
	public Object getPropertyValue(Object bean, String fieldName) {
		  Object value=null;
		  try {
		    value = PropertyUtils.getProperty(bean, fieldName);
		  }
		  catch (NoSuchMethodException ex) {
		    ex.printStackTrace();
		  }
		  catch (InvocationTargetException ex) {
		    ex.printStackTrace();
		  }
		  catch (IllegalAccessException ex) {
		    ex.printStackTrace();
		  }
		  return value;
	}
	
	public void setPropertyValue(Object bean,String fieldName,String fieldType,String dateFormat, String val){
		try {
			Object inputVal=null;
			if("D".equals(fieldType)) {
				inputVal=MyDateFormat.getCalendar(val,dateFormat);
			}
			else if("N".equals(fieldType)){
				if(val.indexOf(".")>0) inputVal = new Double(val);
				else if(Utility.IsEmpty(val)) inputVal = new Integer(0);
				else inputVal = new Integer(val);
			}
			else inputVal=val;			
			BeanUtils.setProperty(bean, fieldName, inputVal);
		}		  
		  catch (InvocationTargetException ex) {
		    ex.printStackTrace();
		  }
		  catch (IllegalAccessException ex) {
		    ex.printStackTrace();
		  }
	}

}
