/**
 * Copyright (c) 2013. Department of Family Practice, University of British Columbia. All Rights Reserved.
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
 * Department of Family Practice
 * Faculty of Medicine
 * University of British Columbia
 * Vancouver, Canada
 */
package org.oscarehr.common.service;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.util.TimerTask;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.HttpHostConnectException;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.log4j.Logger;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.exports.e2e.E2EPatientExport;
import org.oscarehr.exports.e2e.E2EVelocityTemplate;
import org.oscarehr.util.DbConnectionFilter;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;

import oscar.OscarProperties;
import oscar.oscarDemographic.pageUtil.Util;

/**
 * An E2E scheduler object for periodically exporting all available patient summaries
 * This object extends the JDK TimerTask, but applicationContextE2E.xml uses Quartz scheduling instead
 * It will attempt to send the export via HTTP POST. If it fails, the record is saved in TMP_DIR
 * 
 * @author Marc Dumontier, Jeremy Ho
 */
public class E2ESchedulerJob extends TimerTask {
	private static final Logger logger = MiscUtils.getLogger();
	private String tmpDir = OscarProperties.getInstance().getProperty("TMP_DIR");
	private String e2eUrl = OscarProperties.getInstance().getProperty("E2E_URL");

	@Override
	public void run() {
		DemographicDao demographicDao = SpringUtils.getBean(DemographicDao.class);

		try {
			logger.info("Starting E2E export job");
			logger.info("E2E Target URL: ".concat(e2eUrl));

			boolean failedHTTPPOST = false;
			List<Integer> ids = demographicDao.getActiveDemographicIds();
			//ArrayList<File> files = new ArrayList<File>();
			StringBuilder exportLog = new StringBuilder();

			for(Integer id:ids) {
				// Select Template
				E2EVelocityTemplate t = new E2EVelocityTemplate();

				// Create and load Patient data
				E2EPatientExport patient = new E2EPatientExport();
				patient.setExAllTrue();

				// Load patient data and merge to template
				String output = "";
				boolean loadStatus = patient.loadPatient(id.toString());
				if(loadStatus && patient.isActive()) {
					output = t.export(patient);
					exportLog.append(t.getExportLog());
				} else if(loadStatus && !patient.isActive()) {
					String msg = "Patient ".concat(id.toString()).concat(" not active - skipping");
					logger.info(msg);
					t.addExportLogEntry(msg);
					exportLog.append(t.getExportLog());
					continue;
				} else {
					String msg = "Failed to load patient ".concat(id.toString());
					logger.error(msg);
					t.addExportLogEntry(msg);
					exportLog.append(t.getExportLog());
					continue;
				}

				// Export File to Temp Directory
				File file = null;
				try{
					File directory = new File(tmpDir);
					if(!directory.exists()){
						throw new Exception("Temporary Export Directory does not exist!");
					}

					//Standard format for xml exported file : PatientFN_PatientLN_PatientUniqueID_DOB (DOB: ddmmyyyy)
					String expFile = patient.getDemographic().getFirstName()+"_"+patient.getDemographic().getLastName()+"_"+id;
					expFile += "_"+patient.getDemographic().getDateOfBirth()+patient.getDemographic().getMonthOfBirth()+patient.getDemographic().getYearOfBirth()+".xml";
					file = new File(directory, expFile);
				} catch (Exception e){
					logger.error("Error", e);
				}
				BufferedWriter out = null;
				try {
					out = new BufferedWriter(new FileWriter(file));
					out.write(output);
				} catch (IOException e) {
					logger.error("Error", e);
					throw new Exception("Cannot write .xml file(s) to export directory.\nPlease check directory permissions.");
				} finally {
					try {
						out.close();
					} catch(Exception e) {
						//ignore
					}
				}

				// Attempt to perform HTTP POST request
				try {
					HttpClient httpclient = new DefaultHttpClient();
					HttpPost httpPost = new HttpPost(e2eUrl);

					FileBody fileBody = new FileBody(file, "text/xml");
					MultipartEntity reqEntity = new MultipartEntity();
					reqEntity.addPart("content", fileBody);
					httpPost.setEntity(reqEntity);

					HttpResponse response = httpclient.execute(httpPost);
					if(response != null && response.getStatusLine().getStatusCode() == 201) {
						Util.cleanFile(file);
					} else {
						logger.error(response.getStatusLine());
						failedHTTPPOST = true;
					}
				} catch (HttpHostConnectException e) {
					logger.error("Connection to ".concat(e2eUrl).concat(" refused"));
					failedHTTPPOST = true;
				} catch (Exception e) {
					logger.error("Error", e);
					failedHTTPPOST = true;
				}
			}

			// Create Export Log
			/*try {
				File exportLogFile = new File(files.get(0).getParentFile(), "ExportEvent.log");
				BufferedWriter out = new BufferedWriter(new FileWriter(exportLogFile));
				if(exportLog.toString().length() == 0) {
					out.write("Export contains no errors".concat(System.getProperty("line.separator")));
				} else {
					out.write(exportLog.toString());
				}
				out.close();

				files.add(exportLogFile);
			} catch (IOException e) {
				logger.error("Error", e);
				throw new Exception("Cannot write .xml file(s) to export directory.\nPlease check directory permissions.");
			}*/

			// Remove export files from temp dir
			//Util.cleanFiles(files);

			if(failedHTTPPOST) {
				logger.info("Check ".concat(tmpDir).concat(" for unsent export files"));
			}
			logger.info("Done E2E export job");
		} catch(Throwable e ) {
			logger.error("Error",e);
		} finally {
			DbConnectionFilter.releaseAllThreadDbResources();
		}
	}
}
