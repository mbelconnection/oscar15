/*
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

package oscar.dms;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.oscarehr.common.dao.IdGenerator;
import org.oscarehr.util.DbConnectionFilter;

import oscar.OscarProperties;
import oscar.util.SqlUtilBaseS;
import oscar.util.SqlUtils;
import oscar.util.UtilDateUtilities;

//all SQL statements here
public class EDocUtil extends SqlUtilBaseS {
    static Log log = LogFactory.getLog(EDocUtil.class);
    
    public static final String PUBLIC = "public";
    public static final String PRIVATE = "private";
    public static final String SORT_DATE = "d.updatedatetime DESC, d.updatedatetime DESC";
    public static final String SORT_DESCRIPTION = "d.docdesc, d.updatedatetime DESC";
    public static final String SORT_DOCTYPE = "d.doctype, d.updatedatetime DESC";
    public static final String SORT_CREATOR = "d.doccreator, d.updatedatetime DESC";
    public static final String SORT_OBSERVATIONDATE = "d.observationdate DESC, d.updatedatetime DESC";
    public static final String SORT_CONTENTTYPE = "d.contenttype, d.updatedatetime DESC";
    public static final boolean ATTACHED = true;
    public static final boolean UNATTACHED = false;
    
    public static final String DMS_DATE_FORMAT = "yyyy/MM/dd";

    
    public static ArrayList getCurrentDocs(String tag) {
        //return TagUtil.getObjects(tag, "EDoc");
        return new ArrayList();
    }
    
    public static String getModuleName(String module, String moduleid) {
        String sql = "SELECT * FROM " + module + " WHERE " + module + "_no LIKE '" + moduleid + "'";
        Connection c=null;
        ResultSet rs = null;
        String moduleName = "";
        try {
            c=DbConnectionFilter.getThreadLocalDbConnection();
            rs = getSQL(c, sql);
            
            if (rs.next()) {
                moduleName = rs.getString("first_name") + ", " + rs.getString("last_name");
            }
        } catch (SQLException sqe) {
            SqlUtils.closeResources(c, null, rs);
            sqe.printStackTrace();
        }
        return moduleName;
    }
    
    public static ArrayList getDoctypes(String module) {
        String sql = "SELECT * FROM ctl_doctype WHERE (status = 'A' OR status='H') AND module = '" + module + "'";
        System.out.println("...... getDocTypes sql: " + sql);
        Connection c=null;
        ResultSet rs = null;
        ArrayList doctypes = new ArrayList();
        String doctype = "";
        try {
            c=DbConnectionFilter.getThreadLocalDbConnection();
            rs = getSQL(c, sql);
            while (rs.next()) {
                doctype = rs.getString("doctype");
                doctypes.add(doctype);
            }
        } catch (SQLException sqe) {
            SqlUtils.closeResources(c, null, rs);
            sqe.printStackTrace();
        }
        return doctypes;
    }
    
    public static void addDocumentSQL(EDoc newDocument) throws SQLException {    	    	
    	Connection c = null;
    	try {
    		c = DbConnectionFilter.getThreadLocalDbConnection();
    		int doc_id = IdGenerator.getNextIdFromGenericSequence(c);
           	String documentSql = "INSERT INTO document (document_no, doctype, docdesc, docxml, docfilename, doccreator, updatedatetime, status, contenttype, public_no, observationdate) " +
                "VALUES ("+doc_id+ ", '" + org.apache.commons.lang.StringEscapeUtils.escapeSql(newDocument.getType()) + "', '" + org.apache.commons.lang.StringEscapeUtils.escapeSql(newDocument.getDescription()) + 
                "', '" + org.apache.commons.lang.StringEscapeUtils.escapeSql(newDocument.getHtml()) + "', '" + org.apache.commons.lang.StringEscapeUtils.escapeSql(newDocument.getFileName()) + "', '" + newDocument.getCreatorId() + 
                "', '" + SqlUtils.isoToOracleDate3(newDocument.getDateTimeStamp()) + "', '" + newDocument.getStatus() + "', '" + newDocument.getContentType() + "', '" + newDocument.getDocPublic() + "', '" + SqlUtils.isoToOracleDate2(newDocument.getObservationDate()) + "')";
           	
           	//String document_no = runSQLinsert(documentSql);
           	runSQL(documentSql);
           	System.out.println("addDoc: " + documentSql);               
           	String ctlDocumentSql = "INSERT INTO ctl_document VALUES ('" + newDocument.getModule() + "', " + newDocument.getModuleId() + ", " + doc_id + ", '" + newDocument.getStatus() + "')";
           	runSQL(ctlDocumentSql);
        } catch (Exception e){ 
        	e.printStackTrace();        	
        }
        finally {
        	c.close();
        }
    }
    
    public static void detachDocConsult(String docNo, String consultId) {
        String sql = "UPDATE consultdocs SET deleted = 'Y' WHERE requestId = " + consultId + " AND document_no = " + docNo + " AND doctype = 'D'";
        System.out.println("detachDoc: " + sql);
        runSQL(sql);
    }
    
    public static void attachDocConsult(String providerNo, String docNo, String consultId) {
        String sql = "INSERT INTO consultdocs (requestId,document_no,doctype,attach_date, provider_no) VALUES(" + consultId + "," + docNo + ",'D', now(), '" + providerNo + "')";
        System.out.println("attachDoc: " + sql);
        runSQL(sql);
    }
    
    public static void editDocumentSQL(EDoc newDocument) {
       String doctype = org.apache.commons.lang.StringEscapeUtils.escapeSql(newDocument.getType());
       String docDescription = org.apache.commons.lang.StringEscapeUtils.escapeSql(newDocument.getDescription());
       String docFileName = org.apache.commons.lang.StringEscapeUtils.escapeSql(newDocument.getFileName());
       String html = org.apache.commons.lang.StringEscapeUtils.escapeSql(newDocument.getHtml());
       String contentType = newDocument.getContentType();
       System.out.println("obs date: " + newDocument.getObservationDate());
       
       try{
       String editDocSql = "UPDATE document SET doctype='" + doctype + "', docdesc='" + docDescription + "', updatedatetime='" + SqlUtils.isoToOracleDate3(getDmsDateTime()) + "', public_no='" + newDocument.getDocPublic() + "', observationdate='" + SqlUtils.isoToOracleDate2(newDocument.getObservationDate()) + "', docxml='" + html + "'";
       if (docFileName.length() > 0) {
           editDocSql = editDocSql + ", docfilename='" + docFileName + "', contenttype='" + newDocument.getContentType() + "'";
       }
       editDocSql = editDocSql + " WHERE document_no=" + newDocument.getDocId();
       System.out.println("doceditSQL: " + editDocSql);
       runSQL(editDocSql);
       } catch (Exception e) {
    	   e.printStackTrace();
       }
       
    }
       
    public static void indivoRegister( EDoc doc ) {
        StringBuffer sql= new StringBuffer("INSERT INTO indivoDocs (oscarDocNo, indivoDocIdx, docType, dateSent, `update`) VALUES(" +
                doc.getDocId() + ",'" + doc.getIndivoIdx() + "','document',now(),");
        
        if( doc.isInIndivo() ) 
            sql.append("'U')");
        else
            sql.append("'I')");                 
        
        runSQL(sql.toString());
    }
    
/*
 document
+----------------+--------------+------+-----+---------+----------------+
| Field          | Type         | Null | Key | Default | Extra          |
+----------------+--------------+------+-----+---------+----------------+
| document_no    | int(6)       |      | PRI | NULL    | auto_increment |
| doctype        | varchar(20)  | YES  |     | NULL    |                |
| docdesc        | varchar(255) |      |     |         |                |
| docxml         | text         | YES  |     | NULL    |                |
| docfilename    | varchar(255) |      |     |         |                |
| doccreator     | varchar(30)  |      |     |         |                |
| updatedatetime | datetime     | YES  |     | NULL    |                |
| status         | char(1)      |      |     |         |                |
+----------------+--------------+------+-----+---------+----------------+

 *ctl_document
+-------------+-------------+------+-----+---------+-------+
| Field       | Type        | Null | Key | Default | Extra |
+-------------+-------------+------+-----+---------+-------+
| module      | varchar(30) |      |     |         |       |
| module_id   | int(6)      |      |     | 0       |       |
| document_no | int(6)      |      |     | 0       |       |
| status      | char(1)     | YES  |     | NULL    |       |
+-------------+-------------+------+-----+---------+-------+ 
 */
   
   /**
    *Fetches all consult docs attached to specific consultation
    */
    public static ArrayList listDocs(String demoNo, String consultationId, boolean attached) {
        String sql = "SELECT DISTINCT d.document_no, d.doccreator, d.doctype, d.docdesc, d.observationdate, d.status, d.docfilename, d.contenttype FROM document d, ctl_document c " + 
                  "WHERE d.status=c.status AND d.status != 'D' AND c.document_no=d.document_no AND " + 
                  "c.module='demographic' AND c.module_id = " + demoNo;
        
        String attachQuery = "SELECT d.document_no, d.doccreator, d.doctype, d.docdesc, d.observationdate, d.status, d.docfilename, d.contenttype FROM document d, consultdocs cd WHERE d.document_no = cd.document_no AND " +
                            "cd.requestId = " + consultationId + " AND cd.doctype = 'D' AND cd.deleted IS NULL";                                                                    
                      
        ArrayList resultDocs = new ArrayList(); 
        ArrayList attachedDocs = new ArrayList();
        
        Connection c=null;
        ResultSet rs = null;
        try {            
            c=DbConnectionFilter.getThreadLocalDbConnection();
            rs = getSQL(c, attachQuery);
            while (rs.next()) {
                EDoc currentdoc = new EDoc();
                currentdoc.setDocId(rsGetString(rs, "document_no"));
                currentdoc.setDescription(rsGetString(rs, "docdesc"));
                currentdoc.setFileName(rsGetString(rs, "docfilename"));
                currentdoc.setContentType(rsGetString(rs,"contenttype"));
                currentdoc.setCreatorId(rsGetString(rs, "doccreator"));
                currentdoc.setType(rsGetString(rs, "doctype"));
                currentdoc.setStatus(rsGetString(rs, "status").charAt(0));
                currentdoc.setObservationDate(rsGetString(rs, "observationdate"));                
                attachedDocs.add(currentdoc);
            }
            rs.close();
            
            if( !attached ) {
                rs = getSQL(c, sql);
                while (rs.next()) {
                    EDoc currentdoc = new EDoc();
                    currentdoc.setDocId(rsGetString(rs, "document_no"));
                    currentdoc.setDescription(rsGetString(rs, "docdesc"));
                    currentdoc.setFileName(rsGetString(rs, "docfilename"));
                    currentdoc.setContentType(rsGetString(rs,"contenttype"));
                    currentdoc.setCreatorId(rsGetString(rs, "doccreator"));
                    currentdoc.setType(rsGetString(rs, "doctype"));
                    currentdoc.setStatus(rsGetString(rs, "status").charAt(0));
                    currentdoc.setObservationDate(rsGetString(rs, "observationdate"));
                    
                    if( !attachedDocs.contains(currentdoc))
                        resultDocs.add(currentdoc);
                }
            }
            else
                resultDocs = attachedDocs;
            
        } catch (SQLException sqe) {
            SqlUtils.closeResources(c, null, rs);
            sqe.printStackTrace();
        }
        
        return resultDocs;
    }
    
    public static ArrayList listDocs(String module, String moduleid, String docType, String publicDoc, String sort) {
        //sort must be not null
        //docType = null or = "all"  to show all doctypes
        //select publicDoc and sorting from static variables for this class i.e. sort=EDocUtil.SORT_OBSERVATIONDATE
        //sql base (prefix) to avoid repetition in the if-statements
        String sql = "SELECT DISTINCT c.module, c.module_id, d.doccreator, d.status, d.docdesc, d.docfilename, d.doctype, d.document_no, d.updatedatetime, d.contenttype, d.observationdate FROM document d, ctl_document c WHERE d.status=c.status AND d.status != 'D' AND c.document_no=d.document_no AND c.module='" + module + "'";
        //if-statements to select the where condition (suffix)
        if (publicDoc.equals(PUBLIC)) {
            if ((docType == null) || (docType.equals("all")) || (docType.equals("")))
                sql = sql + " AND d.public_no=1";
            else
                sql = sql + " AND d.public_no=1 AND d.doctype='" + docType + "'";
        } else {
            if ((docType == null) || (docType.equals("all")) || (docType.equals("")))
                sql = sql + " AND c.module_id='" + moduleid + "' AND d.public_no=0";
            else
                sql = sql + " AND c.module_id='" + moduleid + "' AND d.public_no=0 AND d.doctype='" + docType + "'";
        }
        sql = sql + " ORDER BY " + sort;
        log.debug("sql list: " + sql);
        Connection c=null;
        ResultSet rs = null;
        ArrayList resultDocs = new ArrayList();
        try {
            c=DbConnectionFilter.getThreadLocalDbConnection();
            rs = getSQL(c, sql);
            while (rs.next()) {
                EDoc currentdoc = new EDoc();
                currentdoc.setModule(rsGetString(rs, "module"));
                currentdoc.setModuleId(rsGetString(rs, "module_id"));
                currentdoc.setDocId(rsGetString(rs, "document_no"));
                currentdoc.setDescription(rsGetString(rs, "docdesc"));
                currentdoc.setType(rsGetString(rs, "doctype"));
                currentdoc.setCreatorId(rsGetString(rs, "doccreator"));
                currentdoc.setDateTimeStamp(rsGetString(rs, "updatedatetime"));
                currentdoc.setFileName(rsGetString(rs, "docfilename"));
                currentdoc.setStatus(rsGetString(rs, "status").charAt(0));
                currentdoc.setContentType(rsGetString(rs,"contenttype"));
                currentdoc.setObservationDate(rsGetString(rs, "observationdate"));
                resultDocs.add(currentdoc);
            }
        } catch (SQLException sqe) {
            SqlUtils.closeResources(c, null, rs);
            sqe.printStackTrace();
        }

        return resultDocs;
    }
    
    
    public static ArrayList listModules() {
        String sql = "SELECT DISTINCT module FROM ctl_doctype";
        Connection c=null;
        ResultSet rs = null;
        ArrayList modules = new ArrayList();
        try {
            c=DbConnectionFilter.getThreadLocalDbConnection();
            rs = getSQL(c, sql);
            while (rs.next()) {
                modules.add(rsGetString(rs, "module"));
            }
        } catch (SQLException sqe) {
            SqlUtils.closeResources(c, null, rs);
            sqe.printStackTrace();
        }
        return modules;
    }       
    
    public static EDoc getDoc(String documentNo) {
        //get rid of DISTINCT for oracle
    	String sql = "SELECT c.module, c.module_id, d.* FROM document d, ctl_document c WHERE d.status=c.status AND d.status != 'D' AND " + 
                "c.document_no=d.document_no AND c.document_no='" + documentNo + "' ORDER BY d.updatedatetime DESC";
        
        String indivoSql = "SELECT indivoDocIdx FROM indivoDocs i WHERE i.oscarDocNo = ? and i.docType = 'document' limit 1";
        boolean myOscarEnabled = OscarProperties.getInstance().getProperty("MY_OSCAR", "").trim().equalsIgnoreCase("YES");
        Connection c=null;
        ResultSet rs = null;
        ResultSet rs2=null;
        
        EDoc currentdoc = new EDoc();
        try {
            c=DbConnectionFilter.getThreadLocalDbConnection();
            rs = getSQL(c, sql);
            if(rs!=null) {
            while (rs.next()) {
                currentdoc.setModule(rsGetString(rs, "module"));
                currentdoc.setModuleId(rsGetString(rs, "module_id"));
                currentdoc.setDocId(rsGetString(rs, "document_no"));
                currentdoc.setDescription(rsGetString(rs, "docdesc"));
                currentdoc.setType(rsGetString(rs, "doctype"));
                currentdoc.setCreatorId(rsGetString(rs, "doccreator"));
                currentdoc.setDateTimeStamp(rsGetString(rs, "updatedatetime"));
                currentdoc.setFileName(rsGetString(rs, "docfilename"));
                currentdoc.setDocPublic(rsGetString(rs, "public_no"));
                currentdoc.setObservationDate(rs.getDate("observationdate"));
                currentdoc.setHtml(rsGetString(rs, "docxml"));
                currentdoc.setStatus(rsGetString(rs, "status").charAt(0));
                currentdoc.setContentType(rsGetString(rs, "contenttype"));
                
                if( myOscarEnabled ) {
                    String tmp = indivoSql.replaceFirst("\\?", rs.getString("document_no"));
                    rs2 = getSQL(c, tmp);

                    if( rs2.next() ) { 
                       currentdoc.setIndivoIdx(rsGetString(rs2, "indivoDocIdx"));
                       if(currentdoc.getIndivoIdx().length() > 0 )
                            currentdoc.registerIndivo();
                    }
                    rs2.close();
                }
                
                break;
            }
            }
        } catch (SQLException sqe) {
            SqlUtils.closeResources(c, null, rs);
            sqe.printStackTrace();
        }
        return currentdoc;
    }
        
    public String getDocumentName(String id){
       String filename = null;
       Connection c=null;
       ResultSet rs = null;
       try {
          String sql = "select docfilename from document where document_no = '"+id+"'";
          c=DbConnectionFilter.getThreadLocalDbConnection();
          rs = getSQL(c, sql);
          if (rs.next()){
              filename = rs.getString("docfilename");
          }
       }catch(SQLException e) { 
           SqlUtils.closeResources(c, null, rs);
           e.printStackTrace(); 
       }
       return filename;
    }
        
        
    
    public static void deleteDocument(String documentNo) {
        String nowDate = getDmsDateTime();
        try {
        	String sql = "UPDATE document SET status='D', updatedatetime='" + SqlUtils.isoToOracleDate3(nowDate) + "' WHERE document_no=" + documentNo;
        	runSQL(sql); 
        } catch (Exception e) {
        	e.printStackTrace();
        }
        
    }

    public static String getDmsDateTime() {
        String nowDateR = UtilDateUtilities.DateToString(UtilDateUtilities.now(), "yyyy/MM/dd");
        String nowTimeR = UtilDateUtilities.DateToString(UtilDateUtilities.now(), "HH:mm:ss");
        String dateTimeStamp = nowDateR + " " + nowTimeR;
        return dateTimeStamp;
    }
    
    public byte[] getFile(String fpath) {
        byte[] fdata = null;
        try {
            //first we get length of file and allocate mem for file
            File file = new File(fpath);
            long length = file.length();
            fdata = new byte[(int)length];
            //System.out.println("Size of file is " + length);

            //now we read file into array buffer
            FileInputStream fis = new FileInputStream(file);
            fis.read(fdata);
            fis.close();

        }
        catch( NullPointerException ex ) {
            ex.printStackTrace();
        }
        catch( FileNotFoundException ex ) {
            ex.printStackTrace();
        }
        catch( IOException ex ) {
             ex.printStackTrace();
        }

        return fdata;
    }

}
