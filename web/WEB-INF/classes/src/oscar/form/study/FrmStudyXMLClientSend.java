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
// javac -classpath .;C:\jakarta-tomcat-4.0.6\common\lib;%CLASSPATH% SAClient.java
/*activation.jar
commons-logging.jar
dom.jar
dom4j.jar
jaxm-api.jar
jaxm-runtime.jar
jaxp-api.jar
mail.jar
sax.jar
saaj-api.jar
saaj-ri.jar
xalan.jar
xercesImpl.jar
xsltc.jar
javac -d . FrmStudyXMLClientSend.java
java -classpath .:%CLASSPATH% oscar.form.study.FrmStudyXMLClientSend /root/oscar_sfhc.properties https://67.69.12.115:8443/OscarComm/DummyReceiver
java -classpath .:%CLASSPATH% oscar.form.study.FrmStudyXMLClientSend /root/oscar_sfhc.properties https://192.168.42.180:15000/ /root/oscarComm/oscarComm.keystore

java -classpath .:%CLASSPATH% oscar.form.study.FrmStudyXMLClientSend /root/oscar_sfhc.properties https://130.113.150.203:15501/ /root/oscarComm/enleague.keystore
java -classpath .:%CLASSPATH% oscar.form.study.FrmStudyXMLClientSend /root/oscar_sfhc.properties https://192.168.42.180:15000/ /root/oscarComm/compete.keystore
java oscar.form.study.FrmStudyXMLClientSend c:\\root\\oscar_sfhc.properties https://67.69.12.115:8443/OscarComm/DummyReceiver
*/

package oscar.form.study;

import java.io.FileInputStream;
import java.sql.ResultSet;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Properties;
import java.util.Vector;

import javax.xml.messaging.URLEndpoint;
import javax.xml.soap.AttachmentPart;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPHeaderElement;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;

import oscar.oscarDB.DBHandler;


public class FrmStudyXMLClientSend {
//	private String DBName = null;
	private String URLService = null;

	Properties param = new Properties();
	Vector studyContent = new Vector();
	Vector studyNo = new Vector();
	DBHandler db = null; 
	String sql = null; 
	ResultSet rs = null; 

//	Properties studyTableName = null;
	String dateYesterday = null;
	String dateTomorrow = null;

	public static void main (String[] args) throws java.sql.SQLException, java.io.IOException  {
		if (args.length != 3) {
			System.out.println("Please run: java path/FrmStudyXMLClient dbname WebServiceUrl");
			return; 
		}
		FrmStudyXMLClientSend aStudy = new FrmStudyXMLClientSend();

		//initial
		aStudy.init(args[0], args[1]);
		aStudy.getStudyContent();
		if (aStudy.studyContent.size() == 0) {return;}

		//loop for each content record
		for (int i = 0; i < aStudy.studyContent.size() ; i++ )	{
			aStudy.sendJaxmMsg((String)aStudy.studyContent.get(i), args[2]);
			aStudy.updateStatus((String)aStudy.studyNo.get(i));
		}

	}

	private synchronized void init (String file, String url) throws java.sql.SQLException, java.io.IOException  {
		URLService = url;
		param.load(new FileInputStream(file)); 
        db = new DBHandler(DBHandler.OSCAR_DATA);

		GregorianCalendar now=new GregorianCalendar();
		now.add(now.DATE, -1);
		dateYesterday = now.get(Calendar.YEAR) +"-" +(now.get(Calendar.MONTH)+1) +"-"+now.get(Calendar.DAY_OF_MONTH) ;
		now.add(now.DATE, +2);
		dateTomorrow = now.get(Calendar.YEAR) +"-" +(now.get(Calendar.MONTH)+1) +"-"+now.get(Calendar.DAY_OF_MONTH) ;
	}

	private synchronized void getStudyContent () throws java.sql.SQLException  {
        sql = "SELECT studydata_no, content from studydata where timestamp > '" + dateYesterday + "' and timestamp < '" + dateTomorrow + "' and status='ready' order by studydata_no";
        rs = db.GetSQL(sql);
        while(rs.next()) {
			studyContent.add(db.getString(rs,"content")); 
			studyNo.add(db.getString(rs,"studydata_no")); 
		}
        rs.close();
	}

	private synchronized void updateStatus (String studyDataNo) throws java.sql.SQLException  {
        sql = "update studydata set status='sent' where studydata_no=" + studyDataNo ;
		if (db.RunSQL(sql)) throw new java.sql.SQLException();
        rs.close();
	}


	private void sendJaxmMsg (String aMsg, String u) throws java.sql.SQLException  {
		try	{
			//System.setProperty("javax.net.ssl.trustStore", "c:\\root\\oscarComm\\oscarComm.keystore");
			//System.setProperty("javax.net.ssl.trustStore", "/root/oscarComm/compete.keystore");
			System.setProperty("javax.net.ssl.trustStore", u);
            //System.setProperty("javax.net.debug", "ssl,handshake,trustmanager");

			//URL endPoint = new URL (" https://67.69.12.115:8443");
			//javax.xml.soap.SOAPConnectionFactory=com.sun.xml.messaging.saaj.client.p2p.HttpSOAPConnectionFactory
			SOAPConnectionFactory scf = SOAPConnectionFactory.newInstance();
			SOAPConnection connection = scf.createConnection();

			MessageFactory mf = MessageFactory.newInstance();
		    SOAPMessage message = mf.createMessage();

			SOAPPart sp = message.getSOAPPart();
		    SOAPEnvelope envelope = sp.getEnvelope();

			SOAPHeader header = envelope.getHeader();
		    SOAPBody body = envelope.getBody();

			SOAPHeaderElement headerElement = header.addHeaderElement(envelope.createName("OSCAR", "DT", "http://www.oscarhome.org/"));
		    headerElement.addTextNode("header");
			//SOAPBodyElement bodyElement = body.addBodyElement(envelope.createName("Text", "jaxm", "http://java.sun.com/jaxm"));

			SOAPBodyElement bodyElement = body.addBodyElement(envelope.createName("Service"));
		    bodyElement.addTextNode("compete");

			AttachmentPart ap1 = message.createAttachmentPart();
			ap1.setContent(aMsg, "text/plain");
			//DOMSource aSource = new DOMSource(UtilXML.parseXML(aMsg) );
			//ap1.setContent(aSource, "text/xml");
		    //URL url = new URL("../../../../webapps/oscar_sfhc/images/sfhc.jpg");
		    //AttachmentPart ap1 = message.createAttachmentPart(new DataHandler(url));
		    //message.addAttachmentPart(ap1);

			message.addAttachmentPart(ap1);

			//AttachmentPart ap2 = message.createAttachmentPart("hello", "text/plain; charset=ISO-8859-1");	//message.addAttachmentPart(ap2);
			
			URLEndpoint endPoint = new URLEndpoint (URLService);  //"https://67.69.12.115:8443/OscarComm/DummyReceiver");
			SOAPMessage reply = connection.call(message, endPoint);
//			message.writeTo(System.out);
			connection.close();
		} catch (Throwable e)	{
			e.printStackTrace();
		}
	}
}