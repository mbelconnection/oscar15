
/*
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
 * This software is published under the GPL GNU General Public License.
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details. You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * <Quatro Group>
 * This software was written for the
 * Department of Family Medicine
 * McMaster Unviersity
 * Hamilton
 * Ontario, Canada
 */
package oscar.oscarSecurity;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.net.URLDecoder;


/**
 * @author Dennis Langdeau
 */
public class XssFilter implements Filter {


	/*
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	public void init(FilterConfig config) throws ServletException {
//		CRFactory.getConfig().setProperty("cr.disabled", "true");
	}

	/*
	 * @see javax.servlet.Filter#destroy()
	 */
	public void destroy() {}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException  
	{
		String xssErrPage       = "/failure.jsp";
	//   String xssErrPage       = "http://www.turkcell.com.tr/";
	   String regexQueryString = "<IMG|<SCRIPT|SCRIPT|%3CSCRIPT%3CIMG|&lt;SCRIPT|&lt;IMG|&#60;SCRIPT|&#60;IMG|&#x3C;SCRIPT|&#x3C;IMG|%0D";
	   String regexGotoString  = "(http|https)://(\\w*\\.){1,3}turkcell\\.com\\.tr(\\:\\d+)?\\/.*|\\/amconsole.*";
	   
	   Pattern patternQueryString = Pattern.compile( regexQueryString, Pattern.CASE_INSENSITIVE );
	   Pattern patternGotoString  = Pattern.compile( regexGotoString, Pattern.CASE_INSENSITIVE );
	 
	   HttpServletRequest httpRequest = (HttpServletRequest) request;
	   HttpServletResponse httpResponse = (HttpServletResponse) response;
	   String contextPath = httpRequest.getContextPath();
	   xssErrPage = contextPath + xssErrPage;
	   
	   if ( httpRequest.getQueryString() != null )
	   {
	       String queryString;
	       queryString = httpRequest.getQueryString();
	       Matcher m = patternQueryString.matcher( queryString );
	       if ( m.find()  )
	       {
	    	   String g = m.group();
	    	   if (!(("script".equals(g) && queryString.indexOf("<script") < 0)))
	    	   {
	    		   httpResponse.sendRedirect(xssErrPage );
	    		   return;
	    	   }
	       }
	       try
	       {
	           queryString = URLDecoder.decode( httpRequest.getQueryString(), "US-ASCII" );
	       }
	       catch ( Exception ex )
	       {
	           httpResponse.sendRedirect(xssErrPage );
	           return;           
	       }
	       m = patternQueryString.matcher( queryString );
	       if ( m.find())
	       {
	    	   String g = m.group();
	    	   if (!(("script".equals(g) && queryString.indexOf("<script") < 0)))
	    	   {
	    		   httpResponse.sendRedirect(xssErrPage);
	    		   return;
	    	   }
	       }
	   }
	   
	   String gotoLinks[] = request.getParameterValues( "goto" );
	   if ( gotoLinks != null )
	   {
	       for ( int i=0; i<gotoLinks.length; i++ )
	       {
	           String link;
	           try
	           {
	               link = URLDecoder.decode( gotoLinks[i], "US-ASCII" );
	           }
	           catch ( Exception ex )
	           {
	               httpResponse.sendRedirect( xssErrPage );
	               return;           
	           }
	           if ( ! patternGotoString.matcher( URLDecoder.decode( link, "UTF-8" ) ).find() )
	           {
	               httpResponse.sendRedirect( xssErrPage );
	               return;
	           }
	       }
	   }
	   chain.doFilter(request, response);
	}
}