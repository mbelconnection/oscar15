/*
 * PATHL7Handler.java
 *
 * Created on May 23, 2007, 4:33 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package oscar.oscarLab.ca.all.upload.handlers;

import java.io.FileInputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import oscar.oscarLab.ca.all.upload.MessageUploader;

/**
 *
 * @author wrighd
 */
public class PATHL7Handler implements MessageHandler  {

    Logger logger = Logger.getLogger(PATHL7Handler.class);
    
    public String parse(String fileName,int fileId){
        Document doc = null;
        try{
            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
            doc = docBuilder.parse(new FileInputStream(fileName));
        }catch(Exception e){
            logger.error("Could not parse PATHL7 message", e);
        }
        
        if (doc != null){
            int i = 0;
            MessageUploader uploader = new MessageUploader();
            try{
                Node messageSpec = doc.getFirstChild();
                NodeList messages = messageSpec.getChildNodes();
                for (i=0; i<messages.getLength(); i++){
                    
                    String hl7Body = messages.item(i).getFirstChild().getTextContent();
                    uploader.routeReport("PATHL7", hl7Body,fileId);
                    
                }
            }catch(Exception e){
                logger.error("Could not upload PATHL7 message", e);
                e.printStackTrace();
                uploader.clean(fileId);
                return null;
            }
            return("success");
        }else{
            return null;
        }
        
    }
      
}