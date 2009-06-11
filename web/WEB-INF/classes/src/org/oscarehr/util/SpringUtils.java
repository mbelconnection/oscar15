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
package org.oscarehr.util;

import java.sql.Connection;
import java.sql.SQLException;

//import org.apache.commons.dbcp.BasicDataSource;
import javax.sql.DataSource;
import org.springframework.beans.factory.BeanFactory;

/**
 * This class holds utilities used to work with spring.
 * The main usage is probably the beanFactory singleton.
 */
public class SpringUtils {
    /**
     * This variable is populated by one of the context listeners.
     */
    public static BeanFactory beanFactory = null;

    public static Object getBean(String beanName)
    {
        return(beanFactory.getBean(beanName));
    }
    
    /**
     * This method should only be called by DbConnectionFilter, everyone else should use that to obtain a connection. 
     */
    public static Connection getDbConnection() throws SQLException {
//        BasicDataSource ds = (BasicDataSource)SpringUtils.getBean("dataSource");
    	DataSource ds = (DataSource)SpringUtils.getBean("dataSource");
        Connection c=ds.getConnection();
        c.setAutoCommit(true);
        return(c);
    }
}
