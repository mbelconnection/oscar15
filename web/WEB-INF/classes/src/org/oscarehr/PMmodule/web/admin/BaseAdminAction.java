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
package org.oscarehr.PMmodule.web.admin;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import org.oscarehr.PMmodule.web.BaseAction;

import com.quatro.common.KeyConstants;
import com.quatro.model.security.NoAccessException;
import com.quatro.service.security.SecurityManager;

public class BaseAdminAction extends BaseAction {    
	protected String getAccess(HttpServletRequest request,String functionName) throws NoAccessException
	{
		try {
			SecurityManager sec = super.getSecurityManager(request);
			String acc = sec.GetAccess(functionName, "");
			if (acc.equals(KeyConstants.ACCESS_NONE)) throw new NoAccessException();
			return acc;
		}
	   catch(SQLException e)
	   {
			throw new NoAccessException();
	   }

	}
	protected String getAccess(HttpServletRequest request,String functionName, String rights) throws NoAccessException
	{
		try {
			SecurityManager sec = super.getSecurityManager(request);
			String acc = sec.GetAccess(functionName, "");
			if (acc.compareTo(rights) < 0) throw new NoAccessException();
			return acc;
		}
	   catch(SQLException e)
	   {
			throw new NoAccessException();
	   }
	}
	public boolean isReadOnly(HttpServletRequest request,String funName) throws NoAccessException{
		boolean readOnly =false;
		try {
		SecurityManager sec = getSecurityManager(request);
		String r = sec.GetAccess(funName, null); 
		if (r.compareTo(KeyConstants.ACCESS_READ) < 0) throw new NoAccessException(); 
		if (r.compareTo(KeyConstants.ACCESS_READ) == 0) readOnly=true;
		return readOnly;
		}
	   catch(SQLException e)
	   {
			throw new NoAccessException();
	   }
	}

}
