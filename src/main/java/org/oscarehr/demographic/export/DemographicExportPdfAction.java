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
package org.oscarehr.demographic.export;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;
import org.oscarehr.util.WebUtils;

import oscar.oscarDemographic.pageUtil.DemographicExportPdfForm;

public class DemographicExportPdfAction extends Action {

	Logger logger = MiscUtils.getLogger();
	DemographicDao demographicDao = (DemographicDao) SpringUtils.getBean(DemographicDao.class);

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {

		DemographicExportPdfForm defrm = (DemographicExportPdfForm) form;
		String demographicNo = defrm.getDemographicNo();

		boolean includeAllergies = WebUtils.isChecked(request, "incAllergies");
		boolean includeProblems = WebUtils.isChecked(request, "incProblems");
		boolean includeCPP = WebUtils.isChecked(request, "incCPP");
		boolean includeIssues = WebUtils.isChecked(request, "incIssues");
		boolean includeMeds = WebUtils.isChecked(request, "incMeds");
		boolean includeMeasurements = WebUtils.isChecked(request, "incMeasurements");
		boolean includeNotes = WebUtils.isChecked(request, "incNotes");
		boolean includeEForms = WebUtils.isChecked(request, "incEForms");
		
		logger.info("export a PDF of the record");

		Demographic demographic = demographicDao.getDemographic(demographicNo);

		if (demographic == null) {
			logger.warn("Demographic not found (id=" + demographicNo + ")");
			return null;
		}

		response.setContentType("application/pdf"); // octet-stream
		response.setHeader("Content-Disposition", "attachment; filename=\"" + demographicNo + ".pdf\"");

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		
		PatientChartPDFGenerator printer = new PatientChartPDFGenerator(request, baos);
		printer.setDemographic(demographic);
		printer.setNewPage(true);
		printer.printDocHeaderFooter();

		printer.printMasterRecord();
		printer.setNewPage(true);

		if(includeAllergies) {
			printer.printAllergies();
		}

		if(includeCPP) {
			printer.printCPP();
		}

		if(includeProblems) {
			printer.printProblems();
		}

		if(includeIssues) {
			printer.printIssues();
		}

		if(includeMeds) {
			printer.printMeds();
		}

		if(includeMeasurements) {
			printer.printMeasurements();
		}

		if(includeNotes) {
			printer.printCaseNotes();
		}

		printer.finish();

		File theFile = File.createTempFile("chart_print", ".pdf");
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(theFile);
			fos.write(baos.toByteArray());
		} finally {
			IOUtils.closeQuietly(fos);
		}
		
		logger.info("wrote PDF to " + theFile.getAbsolutePath());

		if(includeEForms) {
			File theFile2 = File.createTempFile("chart_print", ".pdf");
			printer.addEForms(request,theFile2,theFile);
			FileUtils.copyFile(theFile2, response.getOutputStream());
			
		} else {
			FileUtils.copyFile(theFile, response.getOutputStream());
		}
		
		return null;
	}
}
