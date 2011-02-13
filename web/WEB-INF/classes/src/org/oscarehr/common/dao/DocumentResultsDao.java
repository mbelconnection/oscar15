/*
 * Hl7textResultsData.java
 *
 * Created on June 19, 2007, 10:33 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package org.oscarehr.common.dao;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.Query;
import org.apache.log4j.Logger;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.Document;
import org.oscarehr.common.model.ProviderInboxItem;
import org.oscarehr.document.dao.DocumentDAO;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;
import org.springframework.stereotype.Repository;

import oscar.oscarLab.ca.on.CommonLabResultData;
import oscar.oscarLab.ca.on.LabResultData;

/**
 *
 * @author jackson
 */
@Repository
public class DocumentResultsDao extends AbstractDao<Document>{
    
    Logger logger = Logger.getLogger(DocumentResultsDao.class);
    
    public DocumentResultsDao() {
        super(Document.class);
    }
        
    public boolean isSentToValidProvider(String docNo){//check if document attached to any existing provider
        if(docNo!=null){
            int dn=Integer.parseInt(docNo.trim());
            String sql="select p from ProviderInboxItem p where p.labType='DOC' and p.labNo="+dn;
            try{
                Query query=entityManager.createQuery(sql);
                List<ProviderInboxItem> r=query.getResultList();
                if(r!=null && r.size()>0){
                    ProviderInboxItem pii=r.get(r.size()-1);
                    String pns=pii.getProviderNo();
                    if(pns.equals("000000"))//takes care of case when a provider number is 000000
                        return true;
                    else if (pns.equalsIgnoreCase("null"))
                        return false;
                    else{
                        int pn = Integer.parseInt(pns);
                        if(pn>0){
                            return true;
                        }else
                            return false;
                        }
                }
                else return false;
            }catch(Exception e){
                e.printStackTrace();
                return false;
            }
        }else return false;
    }
    public boolean isSentToProvider(String docNo, String providerNo){
        if(docNo!=null && providerNo!=null){
            int dn=Integer.parseInt(docNo.trim());
            providerNo=providerNo.trim();
            String sql="select p from ProviderInboxItem p where p.labType='DOC' and p.labNo="+dn+" and p.providerNo='"+providerNo+"'";
            try{
                Query query=entityManager.createQuery(sql);
                List<ProviderInboxItem> r=query.getResultList();
                if(r!=null && r.size()>0){
                    return true;
                }else
                    return false;
            }catch(Exception e){
                MiscUtils.getLogger().error("Error", e);
                return false;
            }
        }else{
            return false;
        }
    }

    public ArrayList populateDocumentResultsDataOfAllProviders(String providerNo, String demographicNo,
            String patientFirstName, String patientLastName, String patientHealthNumber, String status) {

        if ( providerNo == null) { providerNo = ""; }
        if ( patientFirstName == null) { patientFirstName = ""; }
        if ( patientLastName == null) { patientLastName = ""; }
        if ( patientHealthNumber == null) { patientHealthNumber = ""; }
        if ( status == null ) { status = ""; }


        ArrayList labResults =  new ArrayList();
        String sql = "";
        try {
            //
            if ( demographicNo == null) {
                sql="select d from Document d, ProviderInboxItem p where d.documentNo=p.labNo and p.status like '%"+status+"%' "+
                        " and p.labType='DOC' order by d.documentNo DESC";
            } else {
                return labResults;
            }

            logger.debug(sql);
            Query query=entityManager.createQuery(sql);
            List<Document> result=query.getResultList();
            for(Document d:result){
                LabResultData lbData = new LabResultData(LabResultData.DOCUMENT);
                lbData.labType = LabResultData.DOCUMENT;
                lbData.segmentID = d.getDocumentNo().toString();
                //ocument_no | doctype | docdesc  | docxml | docfilename              | doccreator | program_id | updatedatetime      | status | contenttype | public1 | observationdate |




                if (demographicNo == null && !providerNo.equals("0")) {
                    lbData.acknowledgedStatus = Character.toString(d.getStatus());
                } else {
                    lbData.acknowledgedStatus ="U";
                }

                lbData.healthNumber = "";
                lbData.patientName = "Not, Assigned";//change to use internationalization
                lbData.sex = "";


                //BAD!!!! CODING APROACHING
                //DBHandler dbh = new DBHandler();
                //String sqlcd = "select * from ctl_document cd, demographic d where cd.module = 'demographic' and cd.module_id != '-1' and cd.module_id = d.demographic_no and cd.document_no = '"+lbData.segmentID+"'";
                DocumentDAO documentDAO=(DocumentDAO) SpringUtils.getBean("documentDAO");
                Demographic demo =documentDAO.getDemoFromDocNo(lbData.segmentID);
                //ResultSet rscd= dbh.GetSQL(sqlcd);
                lbData.isMatchedToPatient = false;
                if(demo!=null){
                     lbData.patientName = demo.getLastName()+ ", "+demo.getFirstName();
                     lbData.healthNumber = demo.getHin();
                     lbData.sex = demo.getSex();
                     lbData.isMatchedToPatient = true;
                     lbData.setLabPatientId(Integer.toString(demo.getDemographicNo()));
                }
                if(lbData.getPatientName().equalsIgnoreCase("Not, Assigned"))
                    lbData.setLabPatientId("-1");
                logger.debug("DOCU<ENT "+lbData.isMatchedToPatient());
                lbData.accessionNumber = "";//oscar.Misc.getString(rs,"accessionNum");

                lbData.resultStatus = "N";//;oscar.Misc.getString(rs,"result_status");
                if (lbData.resultStatus.equals("A"))
                    lbData.abn = true;

                lbData.dateTime = d.getObservationdate().toString();//oscar.Misc.getString(rs,"observationdate");
                lbData.setDateObj(d.getObservationdate());

                //priority
                String priority = "";

                if(priority != null && !priority.equals("")){
                    switch ( priority.charAt(0) ) {
                        case 'C' : lbData.priority = "Critical"; break;
                        case 'S' : lbData.priority = "Stat/Urgent"; break;
                        case 'U' : lbData.priority = "Unclaimed"; break;
                        case 'A' : lbData.priority = "ASAP"; break;
                        case 'L' : lbData.priority = "Alert"; break;
                        default: lbData.priority = "Routine"; break;
                    }
                }else{
                    lbData.priority = "----";
                }

                lbData.requestingClient = "";//oscar.Misc.getString(rs,"requesting_client");
                lbData.reportStatus =  "F";//oscar.Misc.getString(rs,"report_status");

                // the "C" is for corrected excelleris labs
                if (lbData.reportStatus != null && (lbData.reportStatus.equals("F") || lbData.reportStatus.equals("C"))){
                    lbData.finalRes = true;
                }else{
                    lbData.finalRes = false;
                }

                lbData.discipline = d.getDoctype();
                if (lbData.discipline.trim().equals("")){
                    lbData.discipline = null;
                }

                lbData.finalResultsCount = 0;//rs.getInt("final_result_count");
                labResults.add(lbData);
            }
            //rs.close();
            //db.CloseConn();
        }catch(Exception e){
            logger.error("exception in DOCPopulate:", e);
        }
        return labResults;
    }

    //retrieve all documents from database
    public ArrayList populateDocumentResultsData(String providerNo, String demographicNo,
            String patientFirstName, String patientLastName, String patientHealthNumber, String status) {
        
        if ( providerNo == null) { providerNo = ""; }
        if ( patientFirstName == null) { patientFirstName = ""; }
        if ( patientLastName == null) { patientLastName = ""; }
        if ( patientHealthNumber == null) { patientHealthNumber = ""; }
        if ( status == null ) { status = ""; }


        ArrayList labResults =  new ArrayList();
        String sql = "";
        try {
            //
            if ( demographicNo == null) {
                sql="select d from Document d, ProviderInboxItem p where d.documentNo=p.labNo and p.status like '%"+status+"%' and (p.providerNo like '"+
                        (providerNo.equals("")?"%":providerNo)+"'"+" or p.providerNo='"+CommonLabResultData.NOT_ASSIGNED_PROVIDER_NO+"' ) "+
                        " and p.labType='DOC' order by d.documentNo DESC";
            } else {
                return labResults;
            }

            logger.debug(sql);
            Query query=entityManager.createQuery(sql);
            List<Document> result=query.getResultList();
            for(Document d:result){
                LabResultData lbData = new LabResultData(LabResultData.DOCUMENT);
                lbData.labType = LabResultData.DOCUMENT;
                lbData.segmentID = d.getDocumentNo().toString();
                //ocument_no | doctype | docdesc  | docxml | docfilename              | doccreator | program_id | updatedatetime      | status | contenttype | public1 | observationdate |


                

                if (demographicNo == null && !providerNo.equals("0")) {
                    lbData.acknowledgedStatus = Character.toString(d.getStatus());
                } else {
                    lbData.acknowledgedStatus ="U";
                }

                lbData.healthNumber = "";
                lbData.patientName = "Not, Assigned";//change to use internationalization
                lbData.sex = "";


                //BAD!!!! CODING APROACHING
                //DBHandler dbh = new DBHandler();
                //String sqlcd = "select * from ctl_document cd, demographic d where cd.module = 'demographic' and cd.module_id != '-1' and cd.module_id = d.demographic_no and cd.document_no = '"+lbData.segmentID+"'";
                DocumentDAO documentDAO=(DocumentDAO) SpringUtils.getBean("documentDAO");
                Demographic demo =documentDAO.getDemoFromDocNo(lbData.segmentID);
                //ResultSet rscd= dbh.GetSQL(sqlcd);
                lbData.isMatchedToPatient = false;
                if(demo!=null){
                     lbData.patientName = demo.getLastName()+ ", "+demo.getFirstName();
                     lbData.healthNumber = demo.getHin();
                     lbData.sex = demo.getSex();
                     lbData.isMatchedToPatient = true;
                     lbData.setLabPatientId(Integer.toString(demo.getDemographicNo()));
                }
                if(lbData.getPatientName().equalsIgnoreCase("Not, Assigned"))
                    lbData.setLabPatientId("-1");
                logger.debug("DOCU<ENT "+lbData.isMatchedToPatient());
                lbData.accessionNumber = "";//db.getString(rs,"accessionNum");

                lbData.resultStatus = "N";//;db.getString(rs,"result_status");
                if (lbData.resultStatus.equals("A"))
                    lbData.abn = true;

                lbData.dateTime = d.getObservationdate().toString();//db.getString(rs,"observationdate");
                lbData.setDateObj(d.getObservationdate());

                //priority
                String priority = "";

                if(priority != null && !priority.equals("")){
                    switch ( priority.charAt(0) ) {
                        case 'C' : lbData.priority = "Critical"; break;
                        case 'S' : lbData.priority = "Stat/Urgent"; break;
                        case 'U' : lbData.priority = "Unclaimed"; break;
                        case 'A' : lbData.priority = "ASAP"; break;
                        case 'L' : lbData.priority = "Alert"; break;
                        default: lbData.priority = "Routine"; break;
                    }
                }else{
                    lbData.priority = "----";
                }

                lbData.requestingClient = "";//db.getString(rs,"requesting_client");
                lbData.reportStatus =  "F";//db.getString(rs,"report_status");

                // the "C" is for corrected excelleris labs
                if (lbData.reportStatus != null && (lbData.reportStatus.equals("F") || lbData.reportStatus.equals("C"))){
                    lbData.finalRes = true;
                }else{
                    lbData.finalRes = false;
                }

                lbData.discipline = d.getDoctype();
                if (lbData.discipline.trim().equals("")){
                    lbData.discipline = null;
                }

                lbData.finalResultsCount = 0;//rs.getInt("final_result_count");
                labResults.add(lbData);
            }
            //rs.close();
            //db.CloseConn();
        }catch(Exception e){
            logger.error("exception in DOCPopulate:", e);
        }
        return labResults;
    } 
}
