/**
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
 * This software is published under the GPL GNU General Public License.
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version. *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *
 *
 *
 * Created on 2005-6-1
 *
 */
package oscar.log;

import java.sql.SQLException;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;

import oscar.oscarDB.DBPreparedHandler;

/**
 * @author yilee18
 */
public class LogAction {
    private static final Logger _logger = Logger.getLogger(LogAction.class);

    public static boolean addLog(String userId, String provider_no, String action, String content, String contentId, String ip) {
        boolean ret = false;
        DBPreparedHandler db = new DBPreparedHandler();
        String sql = "insert into log (provider_no,action,content,contentId, ip,user_name) values('" + provider_no;
        sql += "', '" + action + "','" + StringEscapeUtils.escapeSql(content) + "','" + contentId + "','" + ip + "','" + userId + "')";
        try {
            db.queryExecuteUpdate(sql);
            ret = true;
        } catch (SQLException e) {
            _logger.error("failed to insert into logging table userId" + userId + "(" + provider_no + "), action " + action
                    + ", content " + content + ", contentId " + contentId + ", ip " + ip + " " + e.getMessage());
        }
        finally
        {
        	db.closeConn();
        }
        return ret;
    }
    public static boolean logAccess(String provider_no, String className, String method, String programId, String shelterId,String clientId,
    		String queryStr,String sessionId,long timeSpan, String ex, int result) {
        boolean ret = false;
        DBPreparedHandler db = new DBPreparedHandler();
        String sql = "insert into access_log (Id,provider_no,ACTIONCLASS,METHOD,QUERYSTRING,PROGRAMID,SHELTERID,CLIENTID,TIMESPAN,EXCEPTION,RESULT, SESSIONID)";
        sql += " values(seq_accesslog_id.nextval,'" + provider_no + "', '" + className + "','" + method + "'," ; 
        sql += "'" + queryStr + "'," + programId + "," + shelterId + "," + clientId + "," + String.valueOf(timeSpan) + ",'" + ex + "'," + result + ",'" + sessionId + "')";
        try {
            db.queryExecuteUpdate(sql);
            ret = true;
        } catch (SQLException e) {
        	//e.printStackTrace();
        }
        finally
        {
        	db.closeConn();
        }
        return ret;
    }
}
