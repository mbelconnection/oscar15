/**
 * Copyright (C) 2007.
 * Centre for Research on Inner City Health, St. Michael's Hospital, Toronto, Ontario, Canada.
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
package org.oscarehr.PMmodule.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Map.Entry;

import org.oscarehr.PMmodule.dao.AdmissionDao;
import org.oscarehr.PMmodule.dao.GenericIntakeDAO;
import org.oscarehr.PMmodule.dao.GenericIntakeNodeDAO;
import org.oscarehr.PMmodule.dao.ProgramDao;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.PMmodule.model.Agency;
import org.oscarehr.PMmodule.model.Intake;
import org.oscarehr.PMmodule.model.IntakeAnswer;
import org.oscarehr.PMmodule.model.IntakeNode;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.service.GenericIntakeManager;
import org.oscarehr.common.model.ReportStatistic;

public class GenericIntakeManagerImpl implements GenericIntakeManager {

	private GenericIntakeNodeDAO genericIntakeNodeDAO;
	private GenericIntakeDAO genericIntakeDAO;
	private ProgramDao programDAO;
	private AdmissionDao admissionDAO;

	public void setGenericIntakeNodeDAO(GenericIntakeNodeDAO genericIntakeNodeDAO) {
		this.genericIntakeNodeDAO = genericIntakeNodeDAO;
	}

	public void setGenericIntakeDAO(GenericIntakeDAO genericIntakeDAO) {
		this.genericIntakeDAO = genericIntakeDAO;
	}

	public void setProgramDAO(ProgramDao programDAO) {
		this.programDAO = programDAO;
	}

	public void setAdmissionDAO(AdmissionDao admissionDAO) {
		this.admissionDAO = admissionDAO;
	}

	// Copy

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#copyQuickIntake(java.lang.Integer, java.lang.String)
	 */
	public Intake copyQuickIntake(Integer clientId, String staffId) {
		return copyIntake(getQuickIntakeNode(), clientId, null, staffId);
	}

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#copyIndepthIntake(java.lang.Integer, java.lang.String)
	 */
	public Intake copyIndepthIntake(Integer clientId, String staffId) {
		return copyIntake(getIndepthIntakeNode(), clientId, null, staffId);
	}

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#copyProgramIntake(java.lang.Integer, java.lang.Integer, java.lang.String)
	 */
	public Intake copyProgramIntake(Integer clientId, Integer programId, String staffId) {
		return copyIntake(getProgramIntakeNode(programId), clientId, programId, staffId);
	}

	// Create

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#createQuickIntake(java.lang.String)
	 */
	public Intake createQuickIntake(String providerNo) {
		return createIntake(getQuickIntakeNode(), null, null, providerNo);
	}

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#createIndepthIntake(java.lang.String)
	 */
	public Intake createIndepthIntake(String providerNo) {
		return createIntake(getIndepthIntakeNode(), null, null, providerNo);
	}

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#createProgramIntake(java.lang.Integer, java.lang.String)
	 */
	public Intake createProgramIntake(Integer programId, String providerNo) {
		return createIntake(getProgramIntakeNode(programId), null, programId, providerNo);
	}

	// Get

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#getMostRecentQuickIntake(java.lang.Integer)
	 */
	public Intake getMostRecentQuickIntake(Integer clientId) {
		return genericIntakeDAO.getLatestIntake(getQuickIntakeNode(), clientId, null);
	}

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#getMostRecentIndepthIntake(java.lang.Integer)
	 */
	public Intake getMostRecentIndepthIntake(Integer clientId) {
		return genericIntakeDAO.getLatestIntake(getIndepthIntakeNode(), clientId, null);
	}

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#getMostRecentProgramIntake(java.lang.Integer, java.lang.Integer)
	 */
	public Intake getMostRecentProgramIntake(Integer clientId, Integer programId) {
		return genericIntakeDAO.getLatestIntake(getProgramIntakeNode(programId), clientId, programId);
	}

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#getQuickIntakes(java.lang.Integer)
	 */
	public List<Intake> getQuickIntakes(Integer clientId) {
		return genericIntakeDAO.getIntakes(getQuickIntakeNode(), clientId, null);
	}

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#getIndepthIntakes(java.lang.Integer)
	 */
	public List<Intake> getIndepthIntakes(Integer clientId) {
		return genericIntakeDAO.getIntakes(getIndepthIntakeNode(), clientId, null);
	}

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#getProgramIntakes(java.lang.Integer)
	 */
	public List<Intake> getProgramIntakes(Integer clientId) {
		List<Intake> programIntakes = new ArrayList<Intake>();

		for (Program program : getProgramsWithIntake(clientId)) {
			programIntakes.addAll(genericIntakeDAO.getIntakes(getProgramIntakeNode(program), clientId, program.getId()));
		}

		return programIntakes;
	}

	/**
	 * @see org.oscarehr.PMmodule.service.GenericIntakeManager#getProgramsWithIntake(java.lang.Integer)
	 */
	public List<Program> getProgramsWithIntake(Integer clientId) {
		List<Program> programsWithIntake = new ArrayList<Program>();

		List<?> serviceProgramAdmissions = admissionDAO.getCurrentServiceProgramAdmission(programDAO, clientId);
		if (serviceProgramAdmissions != null) {
			for (Object o : serviceProgramAdmissions) {
				Admission admission = (Admission) o;
				Program program = programDAO.getProgram(admission.getProgramId());

				if (program != null && program.getIntakeProgram() != null) {
					programsWithIntake.add(program);
				}
			}
		}

		return programsWithIntake;
	}

	// Save

	public Integer saveIntake(Intake intake) {
		return genericIntakeDAO.saveIntake(intake);
	}

	// Report

	public Map<String, SortedSet<ReportStatistic>> getQuestionStatistics(String intakeType, Integer programId, Date startDate, Date endDate) {
		Map<String, SortedSet<ReportStatistic>> questionStatistics = new LinkedHashMap<String, SortedSet<ReportStatistic>>();

		// get node
		IntakeNode node = null;

		if (Intake.QUICK.equalsIgnoreCase(intakeType)) {
			node = getQuickIntakeNode();
		} else if (Intake.INDEPTH.equalsIgnoreCase(intakeType)) {
			node = getIndepthIntakeNode();
		} else if (Intake.PROGRAM.equalsIgnoreCase(intakeType)) {
			node = getProgramIntakeNode(programId);
		}

		// get report statistics
		Set<Integer> choiceAnswerIds = node.getChoiceAnswerIds();
		SortedSet<Integer> latestIntakeIds = genericIntakeDAO.getLatestIntakeIds(node.getId(), startDate, endDate);
		SortedMap<Integer, SortedMap<String, ReportStatistic>> reportStatistics = genericIntakeDAO.getReportStatistics(choiceAnswerIds, latestIntakeIds);

		// populate map
		if (!reportStatistics.isEmpty()) {
			for (IntakeNode question : node.getQuestionsWithChoiceAnswers()) {
				SortedSet<ReportStatistic> statistics = new TreeSet<ReportStatistic>();

				for (IntakeNode answer : question.getChoiceAnswers()) {
					SortedMap<String, ReportStatistic> valueStatistics = reportStatistics.get(answer.getId());

					for (Entry<String, ReportStatistic> valueStatistic : valueStatistics.entrySet()) {
						ReportStatistic statistic = valueStatistic.getValue();

						statistic.setLabel(createStatisticLabel(answer.getLabelStr(), valueStatistic.getKey()));
						statistics.add(statistic);
					}
				}

				questionStatistics.put(question.getLabelStr(), statistics);
			}
		}

		return questionStatistics;
	}

	// Private

	private Intake copyIntake(IntakeNode node, Integer clientId, Integer programId, String staffId) {
		Intake source = genericIntakeDAO.getLatestIntake(node, clientId, programId);
		Intake dest = createIntake(node, clientId, programId, staffId);

		if (source != null) {
			for (IntakeAnswer answer : source.getAnswers()) {
				dest.getAnswerMapped(answer.getNode().getIdStr()).setValue(answer.getValue());
			}
		}

		return dest;
	}

	private Intake createIntake(IntakeNode node, Integer clientId, Integer programId, String staffId) {
		Intake intake = Intake.create(node, clientId, programId, staffId);
		createAnswers(intake, intake.getNode().getChildren());

		return intake;
	}

	private void createAnswers(Intake intake, List<IntakeNode> children) {
		for (IntakeNode child : children) {
			if (child.isAnswerScalar()) {
				intake.addToanswers(IntakeAnswer.create(child));
			}

			createAnswers(intake, child.getChildren());
		}
	}

	private IntakeNode getQuickIntakeNode() {
		Agency agency = Agency.getLocalAgency();
		Integer quickIntakeNodeId = (agency != null) ? agency.getIntakeQuick() : null;

		return getIntakeNode(quickIntakeNodeId);
	}

	private IntakeNode getIndepthIntakeNode() {
		Agency agency = Agency.getLocalAgency();
		Integer indepthIntakeNodeId = (agency != null) ? agency.getIntakeIndepth() : null;

		return getIntakeNode(indepthIntakeNodeId);
	}

	private IntakeNode getProgramIntakeNode(Integer programId) {
		return getProgramIntakeNode(programDAO.getProgram(programId));
	}

	private IntakeNode getProgramIntakeNode(Program program) {
		Integer programIntakeNodeId = (program != null) ? program.getIntakeProgram() : null;

		return getIntakeNode(programIntakeNodeId);
	}

	private IntakeNode getIntakeNode(Integer nodeId) {
		if (nodeId == null) {
			throw new IllegalArgumentException("Parameter nodeId must be non-null");
		}

		IntakeNode node = genericIntakeNodeDAO.getIntakeNode(nodeId);

		if (!node.isIntake()) {
			throw new IllegalStateException("node with id : " + nodeId + " is not an intake");
		}

		return node;
	}

	private String createStatisticLabel(String answerLabel, String answerElement) {
		StringBuilder builder = new StringBuilder();

		builder.append(answerLabel);

		if (builder.length() > 0) {
			builder.append(":");
		}

		builder.append(answerElement);

		return builder.toString();
	}

}