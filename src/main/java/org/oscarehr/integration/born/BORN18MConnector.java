/**
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
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
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */
package org.oscarehr.integration.born;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;
import org.apache.xmlbeans.XmlOptions;
import org.oscarehr.common.dao.BornTransmissionLogDao;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.EFormDao;
import org.oscarehr.common.dao.EFormDataDao;
import org.oscarehr.common.dao.EFormValueDao;
import org.oscarehr.common.model.BornTransmissionLog;
import org.oscarehr.common.model.EForm;
import org.oscarehr.common.model.EFormData;
import org.oscarehr.common.model.EFormValue;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;

import oscar.OscarProperties;
import oscar.util.UtilDateUtilities;

public class BORN18MConnector {
	private final String UPLOADED_TO_BORN = "uploaded_to_BORN";
	private final String VALUE_YES = "Yes";
	
	private final BornTransmissionLogDao logDao = SpringUtils.getBean(BornTransmissionLogDao.class);
	private final DemographicDao demographicDao = SpringUtils.getBean(DemographicDao.class);
	private final EFormDao eformDao = (EFormDao)SpringUtils.getBean("EFormDao");
	private final EFormDataDao eformDataDao = (EFormDataDao)SpringUtils.getBean("EFormDataDao");
	private final EFormValueDao eformValueDao = (EFormValueDao)SpringUtils.getBean("EFormValueDao");
	private final Logger logger = MiscUtils.getLogger();
	
	private final OscarProperties oscarProperties = OscarProperties.getInstance();
	private final String filenameStart = "BORN_" + oscarProperties.getProperty("born18m_orgcode", "") + "_18MEWBV_" + oscarProperties.getProperty("born18m_env", "T");
	
	
	public void updateBorn() {
    	String rourkeFormName = oscarProperties.getProperty("born18m_eform_rourke", "Rourke Baby Record");
    	String nddsFormName = oscarProperties.getProperty("born18m_eform_ndds", "Nipissing District Developmental Screen");
    	String rpt18mFormName = oscarProperties.getProperty("born18m_eform_report18m", "Summary Report: 18-month Well Baby Visit");
    	
		EForm rourkeForm = eformDao.findByName(rourkeFormName);
		EForm nddsForm = eformDao.findByName(nddsFormName);
		EForm rpt18mForm = eformDao.findByName(rpt18mFormName);

		List<Integer> rourkeFormDemoList = new ArrayList<Integer>();
		List<Integer> nddsFormDemoList = new ArrayList<Integer>();
		List<Integer> rpt18mFormDemoList = new ArrayList<Integer>();
		
		if (rourkeForm==null) logger.error(rourkeFormName+" form not found!");
		else buildDemoNos(rourkeForm, rourkeFormDemoList);
		if (nddsForm==null) logger.error(nddsFormName+" form not found!");
		else buildDemoNos(nddsForm, nddsFormDemoList);
		if (rpt18mForm==null) logger.error(rpt18mFormName+" form not found!");
		else buildDemoNos(rpt18mForm, rpt18mFormDemoList);
    	
		HashMap<Integer,Integer> rourkeFormDemoFdids = new HashMap<Integer,Integer>();
		HashMap<Integer,Integer> nddsFormDemoFdids = new HashMap<Integer,Integer>();
		HashMap<Integer,Integer> rpt18mFormDemoFdids = new HashMap<Integer,Integer>();
		
		for (Integer demoNo : rourkeFormDemoList) {
			Integer fdid = checkRourkeDone(rourkeFormName, demoNo);
			if (fdid!=null) rourkeFormDemoFdids.put(demoNo, fdid);
		}
		for (Integer demoNo : nddsFormDemoList) {
			Integer fdid = checkNddsDone(nddsFormName, demoNo);
			if (fdid!=null) nddsFormDemoFdids.put(demoNo, fdid);
		}
		for (Integer demoNo : rpt18mFormDemoList) {
			Integer fdid = checkReport18mDone(rpt18mFormName, demoNo);
			if (fdid!=null) rpt18mFormDemoFdids.put(demoNo, fdid);
		}

		//Upload to BORN repository
		for (Integer demoNo : rourkeFormDemoFdids.keySet()) {
			uploadToBorn(demoNo, rourkeFormDemoFdids.get(demoNo), nddsFormDemoFdids.get(demoNo), rpt18mFormDemoFdids.get(demoNo));
			nddsFormDemoFdids.remove(demoNo);
			rpt18mFormDemoFdids.remove(demoNo);
		}
		for (Integer demoNo : nddsFormDemoFdids.keySet()) {
			uploadToBorn(demoNo, null, nddsFormDemoFdids.get(demoNo), rpt18mFormDemoFdids.get(demoNo));
			rpt18mFormDemoFdids.remove(demoNo);
		}
		for (Integer demoNo : rpt18mFormDemoFdids.keySet()) {
			if (hasFormUploaded(rourkeFormName, demoNo) && hasFormUploaded(nddsFormName, demoNo)) {
				uploadToBorn(demoNo, null, null, rpt18mFormDemoFdids.get(demoNo));
			}
		}
	}
	

	
	private void uploadToBorn(Integer demographicNo, Integer rourkeFdid, Integer nddsFdid, Integer report18mFdid) {
		byte[] born18mXml = generateXml(demographicNo, rourkeFdid, nddsFdid, report18mFdid);
		if (born18mXml == null) return;
		
		BornTransmissionLog log = prepareLog();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String dt = sdf.format(new Date());
		String filename = filenameStart + "_" + dt + "_" + getFileSuffix(log.getId()) + ".xml";

		boolean uploadOk = uploadToBORN(born18mXml, filename);
		if (uploadOk) recordFormSent(demographicNo, rourkeFdid, nddsFdid, report18mFdid);

		//update log filename and status (success=true/false)
		log.setFilename(filename);
		log.setSuccess(uploadOk);
		logDao.merge(log);
		
		logger.info("Uploaded ["+filename+"]");
		return;
	}
	
	private void buildDemoNos(EForm eform, List<Integer> demoList) {
		List<EFormData> eformDataList = eformDataDao.findByFormId(eform.getId());
		for (EFormData eformData : eformDataList) {
			if (!demoList.contains(eformData.getDemographicId())) demoList.add(eformData.getDemographicId());
		}
	}
	
	private Integer checkRourkeDone(String rourkeFormName, Integer demographicNo) {
		Integer fdid = getMaxFdid(rourkeFormName, demographicNo);
		if (fdid==null) return null; //no un-uploaded form data
		
		EFormValue eformValue = eformValueDao.findByFormDataIdAndKey(fdid, "visit_date_18m");
		if (eformValue==null) return null;
		
		Date visitDate = UtilDateUtilities.StringToDate(eformValue.getVarValue(), "yyyy-MM-dd");
		if (!checkDate18m(visitDate, demographicNo)) return null;
		
		eformValue = eformValueDao.findByFormDataIdAndKey(fdid, "subject");
		if (eformValue==null) return null;
		
		if (eformValue.getVarValue()!=null && eformValue.getVarValue().toLowerCase().contains("draft")) {
			return null;
		}
		
		//check if the form is for 2-3y or 4-5y visit -> not uploading
		eformValue = eformValueDao.findByFormDataIdAndKey(fdid, "visit_date_2y");
		if (eformValue!=null && eformValue.getVarValue()!=null && !eformValue.getVarValue().trim().isEmpty()) {
			return null;
		}
		
		eformValue = eformValueDao.findByFormDataIdAndKey(fdid, "visit_date_4y");
		if (eformValue!=null && eformValue.getVarValue()!=null && !eformValue.getVarValue().trim().isEmpty()) {
			return null;
		}
		
		return fdid;
	}
	
	private Integer checkNddsDone(String nddsFormName, Integer demographicNo) {
		Integer fdid = getMaxFdid(nddsFormName, demographicNo);
		if (fdid==null) return null; //no un-uploaded form data
		
		EFormValue eformValue = eformValueDao.findByFormDataIdAndKey(fdid, "subject");
		if (eformValue==null) return null;
		
		if (eformValue.getVarValue()!=null && eformValue.getVarValue().toLowerCase().contains("draft")) {
			return null;
		}
		
		return fdid;
	}
	
	private Integer checkReport18mDone(String report18mFormName, Integer demographicNo) {
		Integer fdid = getMaxFdid(report18mFormName, demographicNo);
		if (fdid==null) return null; //no un-uploaded form data
		
		EFormValue eformValue = eformValueDao.findByFormDataIdAndKey(fdid, "subject");
		if (eformValue==null) return null;
		
		if (eformValue.getVarValue()!=null && eformValue.getVarValue().toLowerCase().contains("draft")) {
			return null;
		}
		
		return fdid;
	}
	
	private byte[] generateXml(Integer demographicNo, Integer rourkeFdid, Integer nddsFdid, Integer report18mFdid) {
		HashMap<String,String> suggestedPrefixes = new HashMap<String,String>();
		suggestedPrefixes.put("http://www.w3.org/2001/XMLSchema-instance","xsi");
		XmlOptions opts = new XmlOptions();
		opts.setSaveSuggestedPrefixes(suggestedPrefixes);
		opts.setSavePrettyPrint();
		opts.setSaveNoXmlDecl();
		opts.setUseDefaultNamespace();
		opts.setSaveNamespacesFirst();
		ByteArrayOutputStream os = null;
		PrintWriter pw = null;
		boolean xmlCreated = false;
		
		BORN18MFormToXML xml = new BORN18MFormToXML(demographicNo);
		try {
			os = new ByteArrayOutputStream();
			pw = new PrintWriter(os, true);
			pw.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
			xmlCreated = xml.addXmlToStream(pw, opts, rourkeFdid, nddsFdid, report18mFdid);
			
			pw.close();
			if (xmlCreated) return os.toByteArray();
		}
		catch(Exception e) {
			logger.warn("Unable to add record",e);
		}
		
		return null;
	}

	private BornTransmissionLog prepareLog() {
		BornTransmissionLog log = new BornTransmissionLog();
		log.setFilename(filenameStart);
		log.setSubmitDateTime(new Date());
		logDao.persist(log);
		
		return log;
	}

	private boolean uploadToBORN(byte[] xmlFile, String filename) {
		String documentDir = oscarProperties.getProperty("DOCUMENT_DIR");
		
		boolean success = false;
		if(documentDir != null && new File(documentDir).exists()) {
			FileOutputStream fos = null;
			try {
				File f = new File(documentDir + File.separator + filename);
				fos = new FileOutputStream(f);
	            fos.write(xmlFile);
				
				success = BornFtpManager.upload18MEWBVDataToRepository(xmlFile, filename);
            }
			catch (IOException e) {
				logger.warn("Unabled to backup file to document dir",e);
			}
			finally {
				try {
	                if (fos!=null) fos.close();
                } catch (IOException e) {
                	logger.warn("Fail to close file output stream",e);
            	}
			}
		} else {
			logger.warn("Cannot find DOCUMENT_DIR");
		}
		return success;
	}

	private void recordFormSent(Integer demographicNo, Integer rourkeFdid, Integer nddsFdid, Integer report18mFdid) {
		List<Integer> fdids = new ArrayList<Integer>();
		if (rourkeFdid!=null) fdids.add(rourkeFdid);
		if (nddsFdid!=null) fdids.add(nddsFdid);
		if (report18mFdid!=null) fdids.add(report18mFdid);
		
		for (Integer fdid : fdids) {
			Integer fid = eformDataDao.find(fdid).getFormId();
			EFormValue eformValue = new EFormValue();
			eformValue.setDemographicId(Integer.valueOf(demographicNo));
			eformValue.setFormDataId(fdid);
			eformValue.setFormId(fid);
			eformValue.setVarName(UPLOADED_TO_BORN);
			eformValue.setVarValue(VALUE_YES);
			eformValueDao.persist(eformValue);
		}
	}
	
	private boolean checkDate18m(Date formDate, Integer demographicNo) {
		Calendar babyBirthday = demographicDao.getDemographic(demographicNo.toString()).getBirthDay();
		
		if (UtilDateUtilities.getNumMonths(babyBirthday.getTime(), formDate)<18) {
			return false;
		}
		return true;
	}
	
	private Integer getMaxFdid(String formName, Integer demographicNo) {
		List<EFormData> eformDatas = eformDataDao.findByDemographicIdAndFormName(demographicNo, formName);
		if (eformDatas==null || eformDatas.isEmpty()) {
			logger.warn(formName+" form data not found for patient #"+demographicNo);
			return null;
		}
		
		Integer fdid = null;
		for (EFormData eformData : eformDatas) {
			if (fdid==null || fdid < eformData.getId()) {
				fdid = eformData.getId();
			}
		}
		if (!checkUploadedToBorn(fdid)) return fdid;
		else return null;
	}
	
	private boolean hasFormUploaded(String formName, Integer demographicNo) {
		List<EFormData> eformDatas = eformDataDao.findByDemographicIdAndFormName(demographicNo, formName);
		if (eformDatas==null || eformDatas.isEmpty()) {
			return false;
		}
		
		for (EFormData eformData : eformDatas) {
			if (checkUploadedToBorn(eformData.getId())) return true;
		}
		return false;
	}
	
	private boolean checkUploadedToBorn(Integer fdid) {
		EFormValue value = eformValueDao.findByFormDataIdAndKey(fdid, UPLOADED_TO_BORN);
		return (value!=null && value.getVarValue().equals(VALUE_YES));
	}
	
	private String getFileSuffix(Integer logId) {
		long num = logDao.getSeqNoToday(filenameStart, logId);
		String tmp = String.valueOf(num);
		while(tmp.length() <3) {tmp = "0"+tmp;}
		return tmp;
	}
}
