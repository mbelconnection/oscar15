/*
* Copyright (c) 2007-2008. CAISI, Toronto. All Rights Reserved.
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
* CAISI, 
* Toronto, Ontario, Canada 
*/

package org.oscarehr.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Map;
import java.util.WeakHashMap;

import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.commons.dbcp.BasicDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import oscar.util.SqlUtils;

public class DbConnectionFilter implements javax.servlet.Filter {
    private static ThreadLocal<Connection> dbConnection = new ThreadLocal<Connection>();

    /**
     * This map was added because not all the code was using hibernate/JDBC properly, once we 
     * fix the data access we should remove this map as it's a waste of cpu time and memory.
     */
    public static Map<Thread, StackTraceElement[]> debugMap = Collections.synchronizedMap(new WeakHashMap<Thread, StackTraceElement[]>());

    /**
     * deprecated we should stop using raw jdbc connections. Don't write new code using raw jdbc, use JPA and native queries instead.
     */
    public static Connection getThreadLocalDbConnection() throws SQLException {
        Connection c = dbConnection.get();
        if (c == null || c.isClosed()) {
            c = getDbConnection();
            dbConnection.set(c);
            Thread currentThread=Thread.currentThread();
            debugMap.put(currentThread, currentThread.getStackTrace());
        }

        return(c);
    }

    public void init(FilterConfig filterConfig) throws ServletException {
        // nothing
    }

    public void doFilter(ServletRequest tmpRequest, ServletResponse tmpResponse, FilterChain chain) throws IOException, ServletException {
		JpaTransactionManager txManager = (JpaTransactionManager) SpringUtils.getBean("txManager");
		TransactionStatus status = txManager.getTransaction(new DefaultTransactionDefinition(TransactionDefinition.PROPAGATION_REQUIRED));

        try {
            chain.doFilter(tmpRequest, tmpResponse);
			txManager.commit(status);
		} finally {
            releaseThreadLocalDbConnection();
			if (!status.isCompleted()) txManager.rollback(status);
        }
    }

    public static void releaseThreadLocalDbConnection() {
        Connection c = dbConnection.get();
        SqlUtils.closeResources(c, null, null);
        dbConnection.remove();
        debugMap.remove(Thread.currentThread());
    }

    /**
     * This method should only be called by DbConnectionFilter internally, everyone else should use getThreadLocalDbConnection to obtain a connection. 
     */
    private static Connection getDbConnection() throws SQLException {
        BasicDataSource ds = (BasicDataSource)SpringUtils.getBean("dataSource");
        Connection c=ds.getConnection();
        c.setAutoCommit(true);
        return(c);
    }

    public void destroy() {
        // can't think of anything to do right now.
    }
}
