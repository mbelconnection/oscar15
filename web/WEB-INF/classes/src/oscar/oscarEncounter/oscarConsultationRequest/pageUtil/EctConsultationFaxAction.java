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
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */
package oscar.oscarEncounter.oscarConsultationRequest.pageUtil;

import java.io.IOException;
import java.io.PrintStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.http.*;
import org.apache.struts.action.*;
import oscar.oscarDB.DBHandler;
//import oscar.oscarEncounter.util.StringQuote;
import oscar.oscarEncounter.pageUtil.EctSessionBean;
import oscar.oscarFax.client.*;
import  oscar.oscarClinic.*;
import javax.xml.soap.*;
import java.net.URL;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import javax.mail.internet.*;

//import javax.xml.transform.*;
//import javax.xml.transform.stream.*;

import org.dom4j.*;
import java.awt.*;
import javax.xml.parsers.*;
import oscar.oscarFax.client.*;
import oscar.OscarProperties;

public class EctConsultationFaxAction extends Action {
   
   String replaceIllegalCharacters(String str){
      return str.replaceAll("&", "&amp;").replaceAll(">","&gt;").replaceAll("<","&lt;");
   }
   
   String replaceIllegalCharactersAmps(String str){
      return str.replaceAll("&", "&amp;");
   }
   
   public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
   throws ServletException, IOException {
      String curUser_no = (String) request.getSession().getAttribute("user");
      
      if(curUser_no == null){
         System.out.println("EJECTING");
         return mapping.findForward("eject");
      }
      
      OscarProperties props = OscarProperties.getInstance();
      
      FaxClientLog faxClientLog = new FaxClientLog(curUser_no);
      
      EctConsultationFaxForm frm = (EctConsultationFaxForm)form;
      System.out.println("Provider = "+curUser_no+" has requested to send a fax");
      String requestId          = frm.getRequestId();
      String sendingProvider    = curUser_no;
      String locationId         = getLocationId();
      String identifier         = props.getProperty("faxIdentifier", "zwf4t%8*9@s");
      String recipentsFaxNumber = frm.getRecipientsFaxNumber();
      String comments           = frm.getComments();
      String sendersFax         = frm.getSendersFax();
      String sendersPhone       = frm.getSendersPhone();
      String recipient          = frm.getRecipient();
      String from               = frm.getFrom();
      
      String appDate;
      String appTime;
      
      java.util.Calendar calender = java.util.Calendar.getInstance();
      String day =  Integer.toString(calender.get(java.util.Calendar.DAY_OF_MONTH));
      String mon =  Integer.toString(calender.get(java.util.Calendar.MONTH)+1);
      String year = Integer.toString(calender.get(java.util.Calendar.YEAR));
      String hourOfDay = Integer.toString(calender.get(java.util.Calendar.HOUR_OF_DAY));
      String minute = Integer.toString(calender.get(java.util.Calendar.MINUTE));
      String formattedDate = year+"/"+mon+"/"+day+"  "+hourOfDay+":"+minute;
      
      ClinicData clinic = new ClinicData();
      String SIMPLE_SAMPLE_URI = props.getProperty("faxURI", "https://67.69.12.117:14043/OSCARFaxWebService");
      
      System.setProperty("javax.net.ssl.trustStore", props.getProperty("faxKeystore", "/root/oscarFax/oscarFax.keystore"));
      HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {
         public boolean verify(String urlHostname, SSLSession a) {
            return true;
         }
      });
      
      oscar.oscarEncounter.oscarConsultationRequest.pageUtil.EctConsultationFormRequestUtil reqFrm;
      reqFrm = new oscar.oscarEncounter.oscarConsultationRequest.pageUtil.EctConsultationFormRequestUtil();
      reqFrm.estRequestFromId(requestId);
      
      try{
         if (Integer.parseInt(reqFrm.status) > 2 ){
            appDate = reqFrm.appointmentDay+"/"+reqFrm.appointmentMonth+"/"+reqFrm.appointmentYear+" (d/m/y) ";
         }else{
            appDate = "";
         }
      }catch(Exception dateExcp){ appDate = ""; }
      
      try{
         if (Integer.parseInt(reqFrm.status) > 2 ){
            appTime = reqFrm.appointmentHour+":"+reqFrm.appointmentMinute+" "+reqFrm.appointmentPm;
         }else{
            appTime = "";
         }
      }catch(Exception timeExcp){ appTime = ""; }
      
      if (reqFrm.specPhone == null || reqFrm.specPhone.equals("null")){ reqFrm.specPhone = new String(); }
      if (reqFrm.specFax == null || reqFrm.specFax.equals("null")){ reqFrm.specFax = new String(); }
      if (reqFrm.specAddr == null || reqFrm.specAddr.equals("null")){ reqFrm.specAddr = new String(); }
      
      try {
         //URL endpoint = null;
         javax.xml.messaging.URLEndpoint endpoint = null;
         
         //endpoint=new URL(SIMPLE_SAMPLE_URI);
         endpoint= new javax.xml.messaging.URLEndpoint(SIMPLE_SAMPLE_URI);
         
         
         OSCARFAXClient OSFc = new OSCARFAXClient();
         OSCARFAXSOAPMessage OFSm=  OSFc.createOSCARFAXSOAPMessage();
         
         OFSm.setSendingProvider(sendingProvider);
         OFSm.setLocationId(locationId);
         OFSm.setIdentifier(identifier);
         OFSm.setFaxType(OFSm.consultation);
         //OFSm.setRecipientFaxNumber("9055750779");
         OFSm.setRecipientFaxNumber(recipentsFaxNumber);
         
         OFSm.setCoverSheet(true);
         OFSm.setComments(comments);
         OFSm.setSendersFax(sendersFax);
         OFSm.setSendersPhone(sendersPhone);
         OFSm.setDateOfSending(formattedDate);
         OFSm.setRecipient(recipient);
         OFSm.setFrom(from);
         
         
         
         SOAPElement payloadEle = OFSm.getPayLoad();
         SOAPElement  conPacket;
         
         
         conPacket = payloadEle.addChildElement("conPacket");
         
         conPacket.addChildElement("clinicName").addTextNode(replaceIllegalCharacters( clinic.getClinicName() ) );
         conPacket.addChildElement("clinicAddress").addTextNode(replaceIllegalCharacters(clinic.getClinicAddress()+", "+clinic.getClinicCity()+", "+clinic.getClinicProvince()+" "+clinic.getClinicPostal() ));
         conPacket.addChildElement("clinicTelephone").addTextNode(replaceIllegalCharacters(sendersPhone));
         conPacket.addChildElement("clinicFax").addTextNode(replaceIllegalCharacters(sendersFax));
         
         conPacket.addChildElement("consultDate").addTextNode(replaceIllegalCharacters(reqFrm.referalDate));
         conPacket.addChildElement("status").addTextNode(replaceIllegalCharacters(urg(reqFrm.urgency)));
         conPacket.addChildElement("consultantName").addTextNode(replaceIllegalCharacters(reqFrm.getSpecailistsName(reqFrm.specialist)));
         conPacket.addChildElement("consultantService").addTextNode(replaceIllegalCharacters(reqFrm.getServiceName(reqFrm.service)));
         conPacket.addChildElement("consultantPhone").addTextNode(replaceIllegalCharacters(reqFrm.specPhone));
         conPacket.addChildElement("consultantFax").addTextNode(replaceIllegalCharacters(reqFrm.specFax));
         conPacket.addChildElement("consultantAddress").addTextNode(replaceIllegalCharactersAmps(reqFrm.specAddr));
         conPacket.addChildElement("patientName").addTextNode(replaceIllegalCharacters(reqFrm.patientName));
         conPacket.addChildElement("patientAddress").addTextNode(replaceIllegalCharactersAmps(reqFrm.patientAddress));
         conPacket.addChildElement("patientTelephone").addTextNode(replaceIllegalCharacters(reqFrm.patientPhone));
         conPacket.addChildElement("patientTelephone").addTextNode(replaceIllegalCharacters(reqFrm.patientWPhone));
         conPacket.addChildElement("patientBirthdate").addTextNode(replaceIllegalCharacters(reqFrm.patientDOB ));
         conPacket.addChildElement("healthCardNo").addTextNode(replaceIllegalCharacters(reqFrm.patientHealthNum+" "+reqFrm.patientHealthCardVersionCode+" "+reqFrm.patientHealthCardType));
         conPacket.addChildElement("appointmentDate").addTextNode(replaceIllegalCharacters(appDate));
         conPacket.addChildElement("appointmentTime").addTextNode(replaceIllegalCharacters(appTime));
         conPacket.addChildElement("chartNo").addTextNode(replaceIllegalCharacters(reqFrm.patientChartNo));
         conPacket.addChildElement("reasonForConsultation").addTextNode(replaceIllegalCharacters(reqFrm.reasonForConsultation));
         conPacket.addChildElement("pertinentClinicalInformation").addTextNode(replaceIllegalCharacters(reqFrm.clinicalInformation));
         conPacket.addChildElement("significantConcurrentProblems").addTextNode(replaceIllegalCharacters(reqFrm.concurrentProblems));
         conPacket.addChildElement("currentMedications").addTextNode(replaceIllegalCharacters(reqFrm.currentMedications));
         conPacket.addChildElement("allergies").addTextNode(replaceIllegalCharacters(reqFrm.allergies));
         conPacket.addChildElement("associatedWith").addTextNode(reqFrm.getProviderName(replaceIllegalCharacters(reqFrm.providerNo)));
         conPacket.addChildElement("familyDoctor").addTextNode(replaceIllegalCharacters(reqFrm.getFamilyDoctor()));
         
         OFSm.save();
         
         boolean reply = OSFc.sendMessage(OFSm, endpoint);
         
         try{
            if (reply){
               System.out.println("Job Id "+OSFc.getJobId());
               request.setAttribute("jobId",OSFc.getJobId());
               System.out.println("Request Id "+OSFc.getRequestId());
               request.setAttribute("requestId",OSFc.getRequestId());
               faxClientLog.setFaxRequestId(OSFc.getJobId(),OSFc.getRequestId());
            }else{
               System.out.println("Error Message "+OSFc.getErrorMessage());
               request.setAttribute("oscarFaxError",OSFc.getErrorMessage());
               faxClientLog.setResult(OSFc.getErrorMessage());
            }
         }catch(Exception e4){
            e4.printStackTrace();
            System.out.println("Fax Service has Returned a Fatal Error ");
            request.setAttribute("oscarFaxError","Fax Service Is currently not available, please contact your Oscar Fax Administrator");
            faxClientLog.setResult("FAX SERVICE RETURNED NULL");
         }
         
         
         
         
         
         
         
      } catch(Throwable e) {
         e.printStackTrace();
      }
      System.out.println("Client Has Finished Running");
      
      
      
      
      
      
      
      return mapping.findForward("success");
      
   }
   String getLocationId(){
      String retval = "";
      try {
         DBHandler db = new DBHandler(DBHandler.OSCAR_DATA);
         String sql = "select locationId from oscarcommlocations where current1 = '1' ";
         ResultSet rs = db.GetSQL(sql);
         if(rs.next())
            retval = rs.getString("locationId");
         db.CloseConn();
      }
      catch(SQLException e) {
         System.out.println(e.getMessage());
      }
      return retval;
   }
   public String urg(String str){
      String retval = "";
      if (str.equals("1")){
         retval = "Urgent";
      }else if(str.equals("2")){
         retval = "Non-Urgent";
      }else if (str.equals("3")){
         retval = "Return";
      }
      return retval;
   }
   
}
