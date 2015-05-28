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

import java.awt.Color;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.WordUtils;
import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.casemgmt.common.EChartNoteEntry;
import org.oscarehr.casemgmt.dao.CaseManagementIssueDAO;
import org.oscarehr.casemgmt.dao.CaseManagementNoteDAO;
import org.oscarehr.casemgmt.model.CaseManagementIssue;
import org.oscarehr.casemgmt.model.CaseManagementNote;
import org.oscarehr.common.dao.AbstractCodeSystemDao;
import org.oscarehr.common.dao.AllergyDao;
import org.oscarehr.common.dao.DemographicCustDao;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.DemographicExtDao;
import org.oscarehr.common.dao.DrugDao;
import org.oscarehr.common.dao.DxresearchDAO;
import org.oscarehr.common.dao.EFormDataDao;
import org.oscarehr.common.dao.MeasurementDao;
import org.oscarehr.common.dao.PrescriptionDao;
import org.oscarehr.common.model.AbstractCodeSystemModel;
import org.oscarehr.common.model.Allergy;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.DemographicCust;
import org.oscarehr.common.model.DemographicExt;
import org.oscarehr.common.model.Drug;
import org.oscarehr.common.model.Dxresearch;
import org.oscarehr.common.model.EFormData;
import org.oscarehr.common.model.Measurement;
import org.oscarehr.common.model.Provider;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;
import org.oscarehr.util.WKHtmlToPdfUtils;

import oscar.OscarProperties;
import oscar.SxmlMisc;
import oscar.oscarDemographic.data.DemographicRelationship;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.HeaderFooter;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfCopy;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfPageEventHelper;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.PdfWriter;

public class PatientChartPDFGenerator {

	//this is to filter out cpp notes from regular ones 
	static String[] cppIssues = { "MedHistory", "OMeds", "SocHistory", "FamHistory", "Reminders", "Concerns", "RiskFactors" };

	private static Logger logger = MiscUtils.getLogger();

	public final int LINESPACING = 1;
	public final float LEADING = 12;
	public final float FONTSIZE = 10;
	public final int NUMCOLS = 2;

	private SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	private Demographic demographic;

	private PdfWriter writer;

	private Document document;
	private BaseFont bf;
	private Font font, boldFont;
	boolean newPage;

	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	private SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm");

	private ProviderDao providerDao = (ProviderDao) SpringUtils.getBean("providerDao");
	private DemographicCustDao demographicCustDao = (DemographicCustDao) SpringUtils.getBean("demographicCustDao");
	private DemographicDao demographicDao = (DemographicDao) SpringUtils.getBean("demographicDao");
	private DemographicExtDao demographicExtDao = SpringUtils.getBean(DemographicExtDao.class);
	//private DemographicMerged merged = 
	private AllergyDao allergyDao = SpringUtils.getBean(AllergyDao.class);
	private CaseManagementNoteDAO caseManagementNoteDao = SpringUtils.getBean(CaseManagementNoteDAO.class);
	private DxresearchDAO dxResearchDao = SpringUtils.getBean(DxresearchDAO.class);
	private CaseManagementIssueDAO caseManagementIssueDao = SpringUtils.getBean(CaseManagementIssueDAO.class);
	private DrugDao drugDao = SpringUtils.getBean(DrugDao.class);
	private PrescriptionDao prescriptionDao = SpringUtils.getBean(PrescriptionDao.class);
	private MeasurementDao measurementDao = SpringUtils.getBean(MeasurementDao.class);
	private EFormDataDao eformDataDao = (EFormDataDao) SpringUtils.getBean("EFormDataDao");

	public PatientChartPDFGenerator() {
	}

	public PatientChartPDFGenerator(HttpServletRequest request, OutputStream os) throws DocumentException, IOException {
		this();

		document = new Document();
		writer = PdfWriter.getInstance(document, os);
		writer.setPageEvent(new EndPage());
		document.setPageSize(PageSize.LETTER);
		document.open();
		//Create the font we are going to print to
		bf = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);

		font = new Font(bf, FONTSIZE, Font.NORMAL);
		boldFont = new Font(bf, FONTSIZE, Font.BOLD);
	}

	public BaseFont getBaseFont() {
		return bf;
	}

	public Document getDocument() {
		return document;
	}

	public Font getFont() {
		return font;
	}

	private Paragraph getParagraph(String value) {
		Paragraph p = new Paragraph(value, font);
		return p;
	}

	private Paragraph getParagraph(String value, Font thisFont) {
		Paragraph p = new Paragraph(value, thisFont);
		return p;
	}

	public void finish() {
		document.close();
	}

	public void printDocHeaderFooter() throws DocumentException {
		String headerTitle = demographic.getTitle() + " " + demographic.getFirstName() + " " + demographic.getLastName() + "(" + demographic.getFormattedDob() + ")";

		document.newPage();
		if (newPage) {
			newPage = false;
		}

		//Header will be printed at top of every page beginning with p2
		Phrase headerPhrase = new Phrase(LEADING, headerTitle, boldFont);
		HeaderFooter header = new HeaderFooter(headerPhrase, false);
		header.setAlignment(HeaderFooter.ALIGN_CENTER);
		document.setHeader(header);

		//make the first page header here

		/*
		try {
			
			byte[] bytes = IOUtils.toByteArray(getClass().getResourceAsStream(
			        "/logo2.jpg"));
			
		 Image image1 = Image.getInstance(bytes);
		    document.add(image1);
		} catch(IOException e) {
			logger.error(e.getMessage(),e);
		}
		*/
		getDocument().add(headerPhrase);
		getDocument().add(new Phrase("\n"));
	}

	/*
	 * all signed notes
	 */
	public void printCaseNotes() throws DocumentException {
		if (newPage) {
			document.newPage();
			newPage = false;
		}

		//-----------Notes
		PdfPTable table = new PdfPTable(2);
		table.setKeepTogether(true);
		table.setWidthPercentage(98f);
		table.setWidths(new int[] { 20, 80 });
		table.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
		addTableHeader(table, "Case Notes", 2);

		List<CaseManagementNote> notes = loadNotes(demographic.getDemographicNo().toString());
		notes = filterOutCpp(notes);

		for (CaseManagementNote note : notes) {
			if (note.isSigned()) {
				add1ColumnRow(table, dateFormatter.format(note.getUpdate_date()), note.getNote(), true);
			}
		}

		document.add(table);

	}

	private List<CaseManagementNote> loadNotes(String demoNo) {
		List<EChartNoteEntry> entries = new ArrayList<EChartNoteEntry>();

		//Gets some of the note data, no relationships, not the note/history..just enough
		List<Map<String, Object>> notes = this.caseManagementNoteDao.getRawNoteInfoMapByDemographic(demoNo);
		Map<String, Object> filteredNotes = new LinkedHashMap<String, Object>();

		//This gets rid of old revisions (better than left join on a computed subset of itself
		Integer programNo;
		for (Map<String, Object> note : notes) {
			if (filteredNotes.get(note.get("uuid")) != null) continue;
			filteredNotes.put((String) note.get("uuid"), true);
			EChartNoteEntry e = new EChartNoteEntry();
			e.setId(note.get("id"));
			e.setDate((Date) note.get("observation_date"));
			e.setProviderNo((String) note.get("providerNo"));

			programNo = note.get("program_no").equals("") ? null : Integer.parseInt((String) note.get("program_no"));
			e.setProgramId(programNo);
			e.setRole((String) note.get("reporter_caisi_role"));
			e.setType("local_note");
			entries.add(e);
		}
		Collections.sort(entries, EChartNoteEntry.getDateComparatorDesc());
		//entries = caseManagementMgr.filterNotes1(entries, programId);

		List<Long> localNoteIds = new ArrayList<Long>();

		for (EChartNoteEntry entry : entries) {
			localNoteIds.add((Long) entry.getId());
		}

		List<CaseManagementNote> localNotes = caseManagementNoteDao.getNotes(localNoteIds);

		return localNotes;
	}

	private List<CaseManagementNote> filterOutCpp(Collection<CaseManagementNote> notes) {
		List<CaseManagementNote> filteredNotes = new ArrayList<CaseManagementNote>();
		for (CaseManagementNote note : notes) {
			boolean skip = false;
			for (CaseManagementIssue issue : note.getIssues()) {
				for (int x = 0; x < cppIssues.length; x++) {
					if (issue.getIssue().getCode().equals(cppIssues[x])) {
						skip = true;
					}
				}
			}
			if (!skip) {
				filteredNotes.add(note);
			}
		}
		return filteredNotes;
	}

	public void printMeasurements() throws DocumentException {
		if (newPage) {
			document.newPage();
			newPage = false;
		}

		//-----------Measurements
		PdfPTable table = new PdfPTable(5);
		table.setKeepTogether(true);
		table.setWidthPercentage(98f);
		table.setWidths(new int[] { 20, 10, 10, 20, 60 });
		table.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
		addTableHeader(table, "Measurements", 5);

		//show only the latest of each type
		Map<String, Boolean> seenMap = new HashMap<String, Boolean>();
		List<Measurement> measurements = measurementDao.findByDemographicId(demographic.getDemographicNo());
		for (Measurement measurement : measurements) {
			if (seenMap.get(measurement.getType()) == null) {
				seenMap.put(measurement.getType(), true);
				printMeasurementItem(table, measurement.getType(), dateFormatter.format(measurement.getDateObserved()), measurement.getDataField(), measurement.getMeasuringInstruction(), measurement.getComments(), true);
			}
		}

		document.add(table);

		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
	}

	public void printMeasurementItem(PdfPTable table, String type, String dateObserved, String value, String instructions, String comments, boolean last) {

		PdfPCell cell1 = new PdfPCell(getParagraph(type));
		cell1.setBorder((last) ? PdfPCell.LEFT | PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.LEFT | PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(value));
		cell1.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(instructions));
		cell1.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(dateObserved));
		cell1.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(comments));
		cell1.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

	}

	public void printMeds() throws DocumentException {
		if (newPage) {
			document.newPage();
			newPage = false;
		}

		//-----------Meds
		PdfPTable table = new PdfPTable(4);
		table.setKeepTogether(true);
		table.setWidthPercentage(98f);
		table.setWidths(new int[] { 20, 30, 40, 10 });
		table.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
		addTableHeader(table, "Medication List", 4);

		List<Drug> drugs = drugDao.findByDemographicId(demographic.getDemographicNo(), false);

		List<Drug> filteredDrugs = new ArrayList<Drug>();
		for (Drug drug : drugs) {
			if (!drug.isExpired() || drug.isLongTerm()) {
				filteredDrugs.add(drug);
			}
		}
		drugs = null;

		for (int x = 0; x < filteredDrugs.size(); x++) {
			Drug drug = filteredDrugs.get(x);

			String name = drug.getCustomName();
			if (name == null) {
				name = drug.getBrandName();
			}
			if (name == null) {
				name = drug.getGenericName();
			}

			if (name == null) {
				continue;
			}
			printMedItem(table, dateFormatter.format(drug.getRxDate()), name, drug.getSpecial(), drug.isLongTerm(), true);

		}

		document.add(table);

		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
	}

	public void printMedItem(PdfPTable table, String startDate, String drugName, String instructions, boolean longTerm, boolean last) {

		PdfPCell cell1 = new PdfPCell(getParagraph(startDate));
		cell1.setBorder((last) ? PdfPCell.LEFT | PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.LEFT | PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(drugName));
		cell1.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(instructions));
		cell1.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph((longTerm) ? "Long Term" : ""));
		cell1.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

	}

	public void printIssues() throws DocumentException {
		if (newPage) {
			document.newPage();
			newPage = false;
		}

		//-----------Issues
		PdfPTable table = new PdfPTable(3);
		table.setKeepTogether(true);
		table.setWidthPercentage(98f);
		table.setWidths(new int[] { 20, 60, 20 });
		table.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
		addTableHeader(table, "Issues", 3);

		List<CaseManagementIssue> issues = caseManagementIssueDao.getIssuesByDemographic(demographic.getDemographicNo().toString());

		for (int x = 0; x < issues.size(); x++) {
			CaseManagementIssue cmIssue = issues.get(x);
			String issueDescr = "N/A";
			String code = null;
			if (cmIssue.getIssue() != null) {
				issueDescr = cmIssue.getIssue().getDescription();
				code = cmIssue.getIssue().getCode();
			}

			boolean skip = false;
			if (code != null) {
				for (int y = 0; y < cppIssues.length; y++) {
					if (code.equals(cppIssues[y])) {
						skip = true;
						break;
					}
				}
			}

			if (skip) {
				continue;
			}
			printIssueItem(table, dateFormatter.format(cmIssue.getUpdate_date()), issueDescr, "", x == (issues.size() - 1));
		}

		document.add(table);

		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
	}

	public void printIssueItem(PdfPTable table, String label, String value, String status, boolean last) {

		PdfPCell cell1 = new PdfPCell(getParagraph((StringUtils.isEmpty(label) ? "" : label + ":")));
		cell1.setBorder((last) ? PdfPCell.LEFT | PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.LEFT | PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(value));
		cell1.setBorder((last) ? PdfPCell.BOTTOM | PdfPCell.RIGHT : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(status));
		cell1.setBorder((last) ? PdfPCell.BOTTOM | PdfPCell.RIGHT : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);
	}

	public void printProblems() throws DocumentException {
		if (newPage) {
			document.newPage();
			newPage = false;
		}

		//-----------Problems
		PdfPTable table = new PdfPTable(2);
		table.setKeepTogether(true);
		table.setWidthPercentage(98f);
		table.setWidths(new int[] { 20, 80 });
		table.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
		addTableHeader(table, "Problem List", 2);

		List<Dxresearch> problems = dxResearchDao.getByDemographicNo(demographic.getDemographicNo());

		for (int x = 0; x < problems.size(); x++) {
			Dxresearch dx = problems.get(x);
			AbstractCodeSystemDao dao = (AbstractCodeSystemDao) SpringUtils.getBean(WordUtils.uncapitalize(dx.getCodingSystem()) + "Dao");
			String codeDescr = "N/A";
			if (dao != null) {
				AbstractCodeSystemModel r = dao.findByCode(dx.getDxresearchCode());
				if (r != null) {
					codeDescr = r.getDescription();
				}
			}
			add1ColumnRow(table, dateFormatter.format(dx.getStartDate()), codeDescr, x == (problems.size() - 1));
		}

		document.add(table);

		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
	}

	public void printCPP() throws DocumentException {
		if (newPage) {
			document.newPage();
			newPage = false;
		}

		//-----------CPP
		PdfPTable table = new PdfPTable(4);
		table.setKeepTogether(true);
		table.setWidthPercentage(98f);
		table.setWidths(new int[] { 20, 30, 20, 30 });
		table.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
		addTableHeader(table, "Cummulative Patient Profile", 4);

		printCPPSubHeader(table, "Medical History", "Family History");

		List<CaseManagementNote> medicalHistory = new ArrayList<CaseManagementNote>(caseManagementNoteDao.findNotesByDemographicAndIssueCode(demographic.getDemographicNo(), new String[] { "MedHistory" }));
		List<CaseManagementNote> familyHistory = new ArrayList<CaseManagementNote>(caseManagementNoteDao.findNotesByDemographicAndIssueCode(demographic.getDemographicNo(), new String[] { "FamHistory" }));

		for (int x = 0; x < Math.max(medicalHistory.size(), familyHistory.size()); x++) {
			CaseManagementNote left = null, right = null;
			String leftDate = "", leftNote = "", rightDate = "", rightNote = "";
			if (x < medicalHistory.size()) {
				left = medicalHistory.get(x);
				leftDate = dateFormatter.format(left.getUpdate_date());
				leftNote = left.getNote();
			}
			if (x < familyHistory.size()) {
				right = familyHistory.get(x);
				rightDate = dateFormatter.format(right.getUpdate_date());
				rightNote = right.getNote();
			}

			add2ColumnRow(table, leftDate, leftNote, rightDate, rightNote, x == (Math.max(medicalHistory.size(), familyHistory.size()) - 1));

		}

		printCPPSubHeader(table, "Other Meds", "Ongoing Concerns");

		List<CaseManagementNote> otherMeds = new ArrayList<CaseManagementNote>(caseManagementNoteDao.findNotesByDemographicAndIssueCode(demographic.getDemographicNo(), new String[] { "OMeds" }));
		List<CaseManagementNote> ongoingConcerns = new ArrayList<CaseManagementNote>(caseManagementNoteDao.findNotesByDemographicAndIssueCode(demographic.getDemographicNo(), new String[] { "Concerns" }));

		for (int x = 0; x < Math.max(otherMeds.size(), ongoingConcerns.size()); x++) {
			CaseManagementNote left = null, right = null;
			String leftDate = "", leftNote = "", rightDate = "", rightNote = "";
			if (x < otherMeds.size()) {
				left = otherMeds.get(x);
				leftDate = dateFormatter.format(left.getUpdate_date());
				leftNote = left.getNote();
			}
			if (x < ongoingConcerns.size()) {
				right = ongoingConcerns.get(x);
				rightDate = dateFormatter.format(right.getUpdate_date());
				rightNote = right.getNote();
			}

			add2ColumnRow(table, leftDate, leftNote, rightDate, rightNote, x == (Math.max(otherMeds.size(), ongoingConcerns.size()) - 1));

		}

		document.add(table);

		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
	}

	private void printCPPSubHeader(PdfPTable table, String label1, String label2) {
		Color color = Color.getHSBColor(60, 5, 90);

		PdfPCell cell1 = new PdfPCell(getParagraph(label1));
		cell1.setBorder(PdfPCell.LEFT | PdfPCell.BOTTOM | PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell1.setBackgroundColor(color);
		cell1.setColspan(2);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(label2));
		cell1.setBorder(PdfPCell.RIGHT | PdfPCell.BOTTOM);
		cell1.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell1.setBackgroundColor(color);
		cell1.setColspan(2);
		table.addCell(cell1);

	}

	public void printAllergies() throws DocumentException {
		if (newPage) {
			document.newPage();
			newPage = false;
		}

		//------------DEMOGRAPHIC INFORMATION
		PdfPTable table = new PdfPTable(4);
		table.setKeepTogether(true);
		table.setWidthPercentage(98f);
		table.setWidths(new int[] { 30, 50, 10, 10 });
		table.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
		addTableHeader(table, "Allergies", 4);

		printAllergySubHeader(table);

		List<Allergy> allergies = allergyDao.findActiveAllergies(demographic.getDemographicNo());

		for (int x = 0; x < allergies.size(); x++) {
			Allergy allergy = allergies.get(x);
			printAllergyItem(table, allergy, (x == (allergies.size() - 1)));
		}

		document.add(table);

		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
	}

	private void printAllergyItem(PdfPTable table, Allergy allergy, boolean last) {
		PdfPCell cell1 = new PdfPCell(getParagraph(allergy.getDescription()));
		cell1.setBorder((last) ? PdfPCell.LEFT | PdfPCell.BOTTOM | PdfPCell.RIGHT : PdfPCell.LEFT | PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(allergy.getReaction()));
		cell1.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(allergy.getSeverityOfReactionDesc()));
		cell1.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph(allergy.getOnSetOfReactionDesc()));
		cell1.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
		table.addCell(cell1);
	}

	private void printAllergySubHeader(PdfPTable table) {
		Color color = Color.getHSBColor(60, 5, 90);

		PdfPCell cell1 = new PdfPCell(getParagraph("Allergen"));
		cell1.setBorder(PdfPCell.LEFT | PdfPCell.BOTTOM | PdfPCell.RIGHT);
		cell1.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell1.setBackgroundColor(color);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph("Reaction"));
		cell1.setBorder(PdfPCell.RIGHT | PdfPCell.BOTTOM);
		cell1.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell1.setBackgroundColor(color);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph("Severity"));
		cell1.setBorder(PdfPCell.RIGHT | PdfPCell.BOTTOM);
		cell1.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell1.setBackgroundColor(color);
		table.addCell(cell1);

		cell1 = new PdfPCell(getParagraph("Onset"));
		cell1.setBorder(PdfPCell.RIGHT | PdfPCell.BOTTOM);
		cell1.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell1.setBackgroundColor(color);
		table.addCell(cell1);

	}

	public void printMasterRecord() throws DocumentException {
		List<DemographicExt> exts = demographicExtDao.getDemographicExtByDemographicNo(demographic.getDemographicNo());
		String phoneExt = null;
		String cell = null;
		for (DemographicExt ext : exts) {
			if (ext.getKey().equals("wPhoneExt")) {
				phoneExt = ext.getValue();
			}
			if (ext.getKey().equals("demo_cell")) {
				cell = ext.getValue();
			}
		}

		DemographicCust demographicCust = demographicCustDao.find(demographic.getDemographicNo());
		if (demographicCust == null) {
			demographicCust = new DemographicCust();
		}

		DemographicRelationship demoRel = new DemographicRelationship();

		ArrayList<HashMap<String, String>> demoR = demoRel.getDemographicRelationships(String.valueOf(demographic.getDemographicNo()));

		if (newPage) {
			document.newPage();
			newPage = false;
		}

		//------------DEMOGRAPHIC INFORMATION
		PdfPTable table = new PdfPTable(4);
		table.setKeepTogether(true);
		table.setWidthPercentage(98f);
		table.setWidths(new int[] { 20, 30, 20, 30 });
		table.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
		addTableHeader(table, "Demographic Information", 4);

		add2ColumnRow(table, "Title", demographic.getTitle(), "Address", demographic.getAddress());
		add2ColumnRow(table, "Name", demographic.getFormattedName(), "City", demographic.getCity());
		add2ColumnRow(table, "Gender", demographic.getSex(), "Province", demographic.getProvince());
		add2ColumnRow(table, "Date of Birth", demographic.getFormattedDob(), "Postal Code", demographic.getPostal());
		add2ColumnRow(table, "Official Language", demographic.getOfficialLanguage(), "Email", demographic.getEmail());
		add2ColumnRow(table, "Spoken Language", demographic.getSpokenLanguage(), "Phone", demographic.getPhone());
		add2ColumnRow(table, "Chart No", demographic.getChartNo(), "Work Phone", demographic.getPhone2() + ((phoneExt != null) ? (" ext:" + phoneExt) : ""));
		add2ColumnRow(table, "", "", "Cell Phone", cell, true);
		add2ColumnRow(table, "Health Insurance #", demographic.getHin() + " " + demographic.getVer(), "Effective Date", (demographic.getEffDate() != null) ? formatter.format(demographic.getEffDate()) : "");
		add2ColumnRow(table, "HC province", demographic.getHcType(), "HC Renew Date", (demographic.getHcRenewDate() != null) ? formatter.format(demographic.getHcRenewDate()) : "", true);
		add2ColumnRow(table, "Roster Status", demographic.getRosterStatus(), "Date Rostered", (demographic.getRosterDate() != null) ? formatter.format(demographic.getRosterDate()) : "");
		add2ColumnRow(table, "Patient Status", demographic.getPatientStatus(), "PT Status Date", (demographic.getPatientStatusDate() != null) ? formatter.format(demographic.getPatientStatusDate()) : "", true);
		add2ColumnRow(table, "Date Joined", (demographic.getDateJoined() != null) ? formatter.format(demographic.getDateJoined()) : "", "End Date", (demographic.getEndDate() != null) ? formatter.format(demographic.getEndDate()) : "", true);

		add2ColumnRow_1Field(table, "Alerts", demographicCust.getAlert());
		add2ColumnRow_1Field(table, "Notes", SxmlMisc.getXmlContent(demographicCust.getNotes(), "unotes"), true);

		document.add(table);

		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));

		//------------HEALTH CARE TEAM

		table = new PdfPTable(2);
		table.setKeepTogether(true);
		table.setWidthPercentage(98f);
		table.setWidths(new int[] { 20, 80 });
		table.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

		addTableHeader(table, "Health Care Team", 2);
		add1ColumnRow(table, "Doctor", getProviderName(demographic.getProviderNo()));
		add1ColumnRow(table, "Referral Doctor", getReferralDoctor(demographic.getFamilyDoctor()), true);
		if (demographicCust != null) {
			if (!StringUtils.isEmpty(demographicCust.getNurse())) {
				add1ColumnRow(table, "Nurse", getProviderName(demographicCust.getNurse()));
			}
			if (!StringUtils.isEmpty(demographicCust.getNurse())) {
				add1ColumnRow(table, "Midwife", getProviderName(demographicCust.getMidwife()));
			}
			if (!StringUtils.isEmpty(demographicCust.getNurse())) {
				add1ColumnRow(table, "Resident", getProviderName(demographicCust.getResident()));
			}
		}
		document.add(table);

		document.add(new Paragraph(new Phrase(LEADING, "\n", font)));

		if (demoR.size() > 0) {
			//------------RELATIONSHIPS
			table = new PdfPTable(2);
			table.setKeepTogether(true);
			table.setWidthPercentage(98f);
			table.setWidths(new int[] { 20, 80 });
			table.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
			addTableHeader(table, "Relationships", 2);

			for (int j = 0; j < demoR.size(); j++) {
				HashMap<String, String> r = demoR.get(j);
				String relationDemographicNo = r.get("demographic_no");
				Demographic relationDemographic = demographicDao.getClientByDemographicNo(Integer.parseInt(relationDemographicNo));
				String relation = r.get("relation");
				String subDecisionMaker = r.get("sub_decision_maker");
				String emergencyContact = r.get("emergency_contact");
				String notes = r.get("notes");
				String extra = "";
				if (subDecisionMaker != null && "1".equals(subDecisionMaker)) {
					extra = extra + " /SDM";
				}
				if (emergencyContact != null && "1".equals(emergencyContact)) {
					extra = extra + " /EC";
				}
				if (!StringUtils.isEmpty(notes)) {
					extra = extra + " (" + notes + ")";
				}
				add1ColumnRow(table, relation, relationDemographic.getFormattedName() + extra, (j == demoR.size() - 1) ? true : false);

			}

			document.add(table);
			document.add(new Paragraph(new Phrase(LEADING, "\n", font)));
		}

	}

	public void setDemographic(Demographic demographic) {
		this.demographic = demographic;
	}

	private void add2ColumnRow(PdfPTable table, String label, String value, String label2, String value2) {
		add2ColumnRow(table, label, value, label2, value2, false, false);
	}

	private void add2ColumnRow(PdfPTable table, String label, String value, String label2, String value2, boolean last) {
		add2ColumnRow(table, label, value, label2, value2, last, false);
	}

	private void add2ColumnRow(PdfPTable table, String label, String value, String label2, String value2, boolean last, boolean stretchLeft) {
		PdfPCell cell1 = new PdfPCell(getParagraph((StringUtils.isEmpty(label) ? "" : label + ":")));
		cell1.setBorder((last) ? PdfPCell.LEFT | PdfPCell.BOTTOM : PdfPCell.LEFT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);

		PdfPCell cell2 = new PdfPCell(getParagraph(value));

		cell2.setBorder(((last) ? ((stretchLeft) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.BOTTOM) : ((stretchLeft) ? PdfPCell.RIGHT : PdfPCell.NO_BORDER)));
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
		if (stretchLeft) {
			cell2.setColspan(3);
		}
		table.addCell(cell1);
		table.addCell(cell2);

		if (!stretchLeft) {
			PdfPCell cell3 = new PdfPCell(getParagraph((StringUtils.isEmpty(label2) ? "" : label2 + ":")));
			cell3.setBorder((last) ? PdfPCell.LEFT | PdfPCell.BOTTOM : PdfPCell.LEFT);
			cell3.setHorizontalAlignment(Element.ALIGN_LEFT);

			PdfPCell cell4 = new PdfPCell(getParagraph(value2));
			cell4.setBorder((last) ? PdfPCell.RIGHT | PdfPCell.BOTTOM : PdfPCell.RIGHT);
			cell4.setHorizontalAlignment(Element.ALIGN_LEFT);
			table.addCell(cell3);
			table.addCell(cell4);
		}

	}

	private void add1ColumnRow(PdfPTable table, String label, String value) {
		add1ColumnRow(table, label, value, false);
	}

	private void add2ColumnRow_1Field(PdfPTable table, String label, String value) {
		add2ColumnRow(table, label, value, null, null, false, true);
	}

	private void add2ColumnRow_1Field(PdfPTable table, String label, String value, boolean last) {
		add2ColumnRow(table, label, value, null, null, last, true);
	}

	private void add1ColumnRow(PdfPTable table, String label, String value, boolean last) {
		PdfPCell cell1 = new PdfPCell(getParagraph((StringUtils.isEmpty(label) ? "" : label + ":")));
		cell1.setBorder((last) ? PdfPCell.LEFT | PdfPCell.BOTTOM : PdfPCell.LEFT);
		cell1.setHorizontalAlignment(Element.ALIGN_LEFT);

		PdfPCell cell2 = new PdfPCell(getParagraph(value));

		cell2.setBorder((last) ? PdfPCell.BOTTOM | PdfPCell.RIGHT : PdfPCell.RIGHT);
		cell2.setHorizontalAlignment(Element.ALIGN_LEFT);

		table.addCell(cell1);
		table.addCell(cell2);

	}

	private void addTableHeader(PdfPTable table, String label, int colspan) {
		PdfPCell cell1 = new PdfPCell(getParagraph(label, boldFont));
		Color color = Color.LIGHT_GRAY;
		cell1.setBackgroundColor(color);
		cell1.setBorder(PdfPCell.NO_BORDER);
		cell1.setHorizontalAlignment(Element.ALIGN_CENTER);
		cell1.setNoWrap(true);
		cell1.setColspan(colspan);
		cell1.setBorder(PdfPCell.TOP | PdfPCell.LEFT | PdfPCell.RIGHT | PdfPCell.BOTTOM);
		table.addCell(cell1);

	}

	public boolean getNewPage() {
		return newPage;
	}

	public void setNewPage(boolean b) {
		this.newPage = b;
	}

	private String getReferralDoctor(String field) {
		if (field != null && field.length() > 0) {
			return SxmlMisc.getXmlContent(field, "rd");
		}
		return "";
	}

	private String getProviderName(String providerNo) {
		if (providerNo == null || providerNo.length() == 0) {
			return "";
		}
		Provider p = providerDao.getProvider(providerNo);
		if (p != null) {
			return p.getFormattedName();
		}
		return "";
	}

	/*
	*Used to print footers on each page
	*/
	class EndPage extends PdfPageEventHelper {
		private Date now;
		private String promoTxt;

		public EndPage() {
			now = new Date();
			promoTxt = OscarProperties.getInstance().getProperty("FORMS_PROMOTEXT");
			if (promoTxt == null) {
				promoTxt = new String();
			}
		}

		public void onEndPage(PdfWriter writer, Document document) {
			//Footer contains page numbers and date printed on all pages
			PdfContentByte cb = writer.getDirectContent();
			cb.saveState();

			String strFooter = promoTxt + " " + formatter.format(now);

			float textBase = document.bottom();
			cb.beginText();
			cb.setFontAndSize(font.getBaseFont(), FONTSIZE);
			Rectangle page = document.getPageSize();
			float width = page.getWidth();

			cb.showTextAligned(PdfContentByte.ALIGN_CENTER, strFooter, (width / 2.0f), textBase - 20, 0);

			strFooter = "-" + writer.getPageNumber() + "-";
			cb.showTextAligned(PdfContentByte.ALIGN_CENTER, strFooter, (width / 2.0f), textBase - 10, 0);

			cb.endText();
			cb.restoreState();
		}
	}

	private File generateEformPdf(HttpServletRequest request, int fdid) throws IOException {
		String localUri = getEformRequestUrl(request);

		File tempFile = File.createTempFile("EForm." + fdid, ".pdf");
		//tempFile.deleteOnExit();

		// convert to PDF
		String viewUri = localUri + fdid;
		WKHtmlToPdfUtils.convertToPdf(viewUri, tempFile);
		logger.info("Writing EFORM pdf to : " + tempFile.getCanonicalPath());

		return tempFile;
	}

	private String getEformRequestUrl(HttpServletRequest request) {
		StringBuilder url = new StringBuilder();
		String scheme = request.getScheme();
		Integer port;
		try {
			port = new Integer(OscarProperties.getInstance().getProperty("oscar_port"));
		} catch (Exception e) {
			port = 8443;
		}
		if (port < 0) port = 80; // Work around java.net.URL bug

		url.append(scheme);
		url.append("://");
		//url.append(request.getServerName());
		url.append("127.0.0.1");

		if ((scheme.equals("http") && (port != 80)) || (scheme.equals("https") && (port != 443))) {
			url.append(':');
			url.append(port);
		}
		url.append(request.getContextPath());
		url.append("/EFormViewForPdfGenerationServlet?parentAjaxId=eforms&prepareForFax=true&providerId=");
		url.append(LoggedInInfo.loggedInInfo.get().loggedInProvider.getProviderNo());
		url.append("&fdid=");

		return (url.toString());
	}

	public void addEForms(HttpServletRequest request, File outputFile, File original) throws Exception {
		List<String> fileNamesToConcatenate = new ArrayList<String>();
		fileNamesToConcatenate.add(original.getAbsolutePath());

		List<EFormData> eforms = eformDataDao.findByDemographicId(demographic.getDemographicNo());
		for (EFormData form : eforms) {
			File tmpFile = generateEformPdf(request, form.getId());
			if (tmpFile != null) {
				fileNamesToConcatenate.add(tmpFile.getAbsolutePath());
			}
		}
		concatenateFiles(outputFile, fileNamesToConcatenate);
	}

	public void concatenateFiles(File outputFile, List<String> files) throws IOException, DocumentException {

		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(outputFile);
			Document document = new Document();
			// step 2
			PdfCopy copy = new PdfCopy(document, fos);
			// step 3
			document.open();
			// step 4
			PdfReader reader;
			int n;
			// loop over the documents you want to concatenate
			for (int i = 0; i < files.size(); i++) {
				reader = new PdfReader(files.get(i));
				// loop over the pages in that document
				n = reader.getNumberOfPages();
				for (int page = 0; page < n;) {
					copy.addPage(copy.getImportedPage(reader, ++page));
				}
				copy.freeReader(reader);
				reader.close();
			}
			// step 5
			document.close();
		}finally {
			IOUtils.closeQuietly(fos);
		}
	}
}
