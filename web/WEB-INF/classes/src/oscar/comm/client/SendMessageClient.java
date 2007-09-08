/*
 * 
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
 * <OSCAR TEAM>
 * 
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster Unviersity 
 * Hamilton 
 * Ontario, Canada 
 */
package oscar.comm.client;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import oscar.oscarDB.DBHandler;
import oscar.util.UtilXML;

public class SendMessageClient {
    public boolean sendMessage(String databaseURL, String databaseName, String messageXML)
            throws OscarCommClientException, java.sql.SQLException {
        boolean ret = false;
        DBHandler db = null;
        String wsURL = null;
        WebServiceClient client = null;

        try {
            db = new DBHandler(databaseURL, databaseName);

            //System.out.println("");
            String sql = "SELECT remoteServerURL FROM oscarcommlocations WHERE current1 = 1";
            ResultSet rs = db.GetSQL(sql);
            if(rs.next()) {
                wsURL = rs.getString("remoteServerURL");
            }
            rs.close();
        } catch (Exception ex) {
            throw new OscarCommClientException("Could not connect to database: " + databaseURL + databaseName, ex);
        }

        client = new WebServiceClient(wsURL);

        try {
            String s = UtilXML.toXML(client.callSendMessage(createRequest(db, messageXML)));
            ret = (s.indexOf("<response/>") > -1);
        } catch (Exception ex) {
            throw new OscarCommClientException("Send Message failed.", ex);
        }

        db.CloseConn();
        return ret;
    }

    private Element createRequest(DBHandler db, String messageXML) throws SQLException {
        Document doc = UtilXML.newDocument();
        Element root = UtilXML.addNode(doc, "sendMessage");
        root.appendChild(new Location(db).getLocal(doc));

        Element message = (Element)doc.importNode(UtilXML.parseXML(messageXML).getDocumentElement(), true);
        root.appendChild(message);

        return root;
    }
}