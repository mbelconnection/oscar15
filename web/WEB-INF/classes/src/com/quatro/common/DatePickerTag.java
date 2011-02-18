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
package com.quatro.common;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.jsp.JspException;

import org.apache.struts.taglib.TagUtils;
import org.apache.struts.taglib.html.BaseInputTag;
import org.apache.struts.taglib.html.TextTag;

import oscar.Misc;

public class DatePickerTag extends BaseInputTag{
	private TextTag dtTextTag = new TextTag();
	private String style=null;
	private String styleClass=null;
	private boolean indexed = false;
	private String width="100%";
	private String openerForm;
	private String openerElement;
	
	public void release() {
	   dtTextTag = null;
	   style=null;
	   styleClass=null;
	   indexed = false;
	   width=null;
	}
	
    public int doStartTag() throws JspException {
        TagUtils.getInstance().write(this.pageContext, this.renderInputElement1());

        return (EVAL_BODY_AGAIN);
    }

    public int doEndTag() throws JspException {
        dtTextTag.doEndTag();
		return EVAL_PAGE;
    }
    
    protected String renderInputElement1() throws JspException {
        String sRootPath="";
        try{
        	sRootPath=Misc.getApplicationName(pageContext.getServletContext().getResource("/").getPath());
	    } catch (Exception e) {}

	    StringBuffer results = new StringBuffer("<table");
        prepareAttribute(results, "cellpadding", "0");
        prepareAttribute(results, "style", "border:0px;");
        prepareAttribute(results, "cellspacing", "0");
       	prepareAttribute(results, "width", getWidth());
        results.append(this.getElementClose());
        results.append("<tr>");
        results.append("<td");
        prepareAttribute(results, "style", "border:0px;");
        results.append(this.getElementClose());

        results.append("<input");
        prepareAttribute(results, "style", "width:100%;");
        prepareAttribute(results, "type", "text");
        String sName=prepareName(property, name);
        prepareAttribute(results, "name", sName);
        prepareAttribute(results, "maxlength", "10");
        prepareAttribute(results, "tabindex", getTabindex());
        prepareAttribute(results, "onblur", "onCalBlur('" + sName + "');");        
        prepareAttribute(results, "onkeypress", "onCalKeyPress(event,'" + sName + "');");        
        prepareValue(results);
        results.append(this.prepareEventHandlers());
        results.append(this.prepareStyles());
        prepareOtherAttributes(results);
        results.append(this.getElementClose());
        results.append("</td>");

        results.append("<td");
        prepareAttribute(results, "style", "border:0px;display:none");
        prepareAttribute(results, "width", "1px");
        results.append(this.getElementClose());

        results.append("<input");
        prepareAttribute(results, "style", "width:1px;display:none");
        prepareAttribute(results, "type", "text");
        String sName1=prepareName(property, name) + "_cal1";
        prepareAttribute(results, "name", sName1);
        prepareAttribute(results, "maxlength", "1px");
        prepareAttribute(results, "tabindex", getTabindex());
        prepareValue(results);
        results.append(this.prepareEventHandlers());
        results.append(this.prepareStyles());
        prepareOtherAttributes(results);
        results.append(this.getElementClose());
        results.append("</td>");
        	       
        results.append("<td");
        prepareAttribute(results, "style", "border:0px");
        prepareAttribute(results, "width", "1px");
        results.append(this.getElementClose());
        results.append("<a href='javascript:void1();' ");

        Calendar rightNow = Calendar.getInstance();
		int year = rightNow.get(Calendar.YEAR);
		int month = rightNow.get(Calendar.MONTH) + 1;

        prepareAttribute(results, "onclick", "return openDatePickerCalendar('/" + sRootPath + "/calendar/CalendarPopup.jsp?" + 
          "openerForm="+ openerForm + "&openerElement=" + sName + "&year=" + year + 
          "&month=" + month +"');");        

        results.append(this.getElementClose());
        results.append("<img");
       	prepareAttribute(results, "src", "/" + sRootPath + "/images/timepicker.jpg");
       	prepareAttribute(results, "border", "0");
        results.append(this.prepareStyles());
        results.append(this.getElementClose());
        results.append("</a>");
        results.append("</td></tr></table>");

        return results.toString();
    }
    
    protected void prepareValue(StringBuffer results) throws JspException {
        results.append(" value=\"");
        if (value != null){
        	results.append(value);
        }else{
            Object value = TagUtils.getInstance().lookup(pageContext, name, property, null);
            results.append(this.formatValue(value));
        }
        results.append('"');
     }
     
     protected String prepareName(String property, String pre_name) throws JspException {
        if (property == null) return null;

        if (indexed) {
           StringBuffer results = new StringBuffer();
           prepareIndex(results, pre_name);
           results.append(property);
           return results.toString();
        }
        return property;
     }
    
     protected String formatValue(Object value) throws JspException {
        if (value == null) return "";

        String value2 = TagUtils.getInstance().filter(value.toString());
        return value2.replace('-','/');        
     }
     
	public TextTag getDtTextTag() {
		return dtTextTag;
	}
	public void setDtTextTag(TextTag dtTextTag) {
		this.dtTextTag = dtTextTag;
	}
	public boolean isIndexed() {
		return indexed;
	}
	public void setIndexed(boolean indexed) {
		this.indexed = indexed;
	}
	public String getStyle() {
		return style;
	}
	public void setStyle(String style) {
		this.style = style;
	}
	public String getStyleClass() {
		return styleClass;
	}
	public void setStyleClass(String styleClass) {
		this.styleClass = styleClass;
	}
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}

	public String getOpenerElement() {
		return openerElement;
	}

	public void setOpenerElement(String openerElement) {
		this.openerElement = openerElement;
	}

	public String getOpenerForm() {
		return openerForm;
	}

	public void setOpenerForm(String openerForm) {
		this.openerForm = openerForm;
	}

}
