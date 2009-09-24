/*******************************************************************************
 * Copyright (c) 2008, 2009 Quatro Group Inc. and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU General Public License
 * which accompanies this distribution, and is available at
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Contributors:
 *     <Quatro Group Software Systems inc.>  <OSCAR Team>
 *******************************************************************************/
package org.oscarehr.PMmodule.model;

import java.io.Serializable;
import java.util.Calendar;

import oscar.MyDateFormat;

public class QuatroIntake implements Serializable,Cloneable {
    private Integer id;// fields
    private Integer clientId;
    private String staffId;
    private String m_staffDesc;
    private Calendar createdOn;
    private String createdOnTxt;    
    private String intakeStatus;
    private Integer currentProgramId;
    private Integer programId;
    private String programType;
    private String programName;
    private Calendar endDate;
    private String endDateTxt;
	private String referredBy;
    private String contactName;
    private String contactNumber;
    private String contactEmail;

    private String language;
    private String youth;
    private String aboriginal;
    private String aboriginalOther;
    private String VAW;
    private String curSleepArrangement;
    private String inShelterBefore;
    private String lengthOfHomeless;
    private String reasonForHomeless;
    private String reasonForService;
    
    private String pregnant;
    private String disclosedAbuse;
    private String disability;
    private String observedAbuse;
    private String disclosedMentalIssue;
    private String poorHygiene;
    private String observedMentalIssue;
    private String disclosedAlcoholAbuse;
    private String observedAlcoholAbuse;

    private String birthCertificate;
    private String birthCertificateYN;
    private String SIN;
    private String SINYN;
    private String healthCardNo;
    private String healthCardNoYN;
    private String driverLicenseNo;
    private String driverLicenseNoYN;
    private String citizenCardNo;
    private String citizenCardNoYN;
    private String nativeReserveNo;
    private String nativeReserveNoYN;
    private String veteranNo;
    private String veteranNoYN;
    private String recordLanding;
    private String recordLandingYN;
    private String libraryCard;
    private String libraryCardYN;
    private String idOther;

//    private String sourceIncome;
    private String[] sourceIncome ={};
    private String income;
    private String incomeWorkerName1;
    private String incomeWorkerPhone1;
    private String incomeWorkerEmail1;
    private String incomeWorkerName2;
    private String incomeWorkerPhone2;
    private String incomeWorkerEmail2;
    private String incomeWorkerName3;
    private String incomeWorkerPhone3;
    private String incomeWorkerEmail3;
    
    private String livedBefore;
    private String livedBeforeOther;
    private String statusInCanada;
    private String originalCountry;
    private String referredTo;
    private String reasonNoAdmit; 
    private String nerverExpiry;
    private String sdmtBenUnitStatus; 
    private String sdmtOffice; 
    private String sdmtLastBenMonth;
    private String completionNotes;
    private String rejectionReasonDesc;

    private String comments;
    private String lastUpdateUserId;
    private String m_lastUpdateUserName;
    
    public String getLastUpdateUserId() {
		return lastUpdateUserId;
	}
    public void setLastUpdateUserId(String lastUpdateUserId)
    {
    	this.lastUpdateUserId = lastUpdateUserId;
    }
	public String getLastUpdateUserName() {
		return m_lastUpdateUserName;
	}
	public void setLastUpdateUserName(String lastUpdateUserName) {
		this.m_lastUpdateUserName = lastUpdateUserName;
	}
//    private Integer referralId;
//    private Integer queueId;
    private Calendar lastUpdateDate;

    public Calendar getLastUpdateDate() {
		return lastUpdateDate;
	}
	public void setLastUpdateDate(Calendar lastUpdateDate) {
		this.lastUpdateDate = lastUpdateDate;
	}
	public String getLastUpdateDateTxt()
	{
		return MyDateFormat.getStandardDate(this.lastUpdateDate);
	}
	public String getAboriginal() {
		return aboriginal;
	}
	public void setAboriginal(String aboriginal) {
		this.aboriginal = aboriginal;
	}
	public String getAboriginalOther() {
		return aboriginalOther;
	}
	public void setAboriginalOther(String aboriginalOther) {
		this.aboriginalOther = aboriginalOther;
	}
	public String getBirthCertificate() {
		return birthCertificate;
	}
	public void setBirthCertificate(String birthCertificate) {
		this.birthCertificate = birthCertificate;
	}
	public String getBirthCertificateYN() {
		return birthCertificateYN;
	}
	public void setBirthCertificateYN(String birthCertificateYN) {
		this.birthCertificateYN = birthCertificateYN;
	}
	public String getCitizenCardNo() {
		return citizenCardNo;
	}
	public void setCitizenCardNo(String citizenCardNo) {
		this.citizenCardNo = citizenCardNo;
	}
	public String getCitizenCardNoYN() {
		return citizenCardNoYN;
	}
	public void setCitizenCardNoYN(String citizenCardNoYN) {
		this.citizenCardNoYN = citizenCardNoYN;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	public String getContactEmail() {
		return contactEmail;
	}
	public void setContactEmail(String contactEmail) {
		this.contactEmail = contactEmail;
	}
	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}
	public String getContactNumber() {
		return contactNumber;
	}
	public void setContactNumber(String contactNumber) {
		this.contactNumber = contactNumber;
	}
	public String getCurSleepArrangement() {
		return curSleepArrangement;
	}
	public void setCurSleepArrangement(String curSleepArrangement) {
		this.curSleepArrangement = curSleepArrangement;
	}
	public String getDisability() {
		return disability;
	}
	public void setDisability(String disability) {
		this.disability = disability;
	}
	public String getDisclosedAbuse() {
		return disclosedAbuse;
	}
	public void setDisclosedAbuse(String disclosedAbuse) {
		this.disclosedAbuse = disclosedAbuse;
	}
	public String getDisclosedAlcoholAbuse() {
		return disclosedAlcoholAbuse;
	}
	public void setDisclosedAlcoholAbuse(String disclosedAlcoholAbuse) {
		this.disclosedAlcoholAbuse = disclosedAlcoholAbuse;
	}
	public String getDisclosedMentalIssue() {
		return disclosedMentalIssue;
	}
	public void setDisclosedMentalIssue(String disclosedMentalIssue) {
		this.disclosedMentalIssue = disclosedMentalIssue;
	}
	public String getDriverLicenseNo() {
		return driverLicenseNo;
	}
	public void setDriverLicenseNo(String driverLicenseNo) {
		this.driverLicenseNo = driverLicenseNo;
	}
	public String getDriverLicenseNoYN() {
		return driverLicenseNoYN;
	}
	public void setDriverLicenseNoYN(String driverLicenseNoYN) {
		this.driverLicenseNoYN = driverLicenseNoYN;
	}
	public String getHealthCardNo() {
		return healthCardNo;
	}
	public void setHealthCardNo(String healthCardNo) {
		this.healthCardNo = healthCardNo;
	}
	public String getHealthCardNoYN() {
		return healthCardNoYN;
	}
	public void setHealthCardNoYN(String healthCardNoYN) {
		this.healthCardNoYN = healthCardNoYN;
	}
	public String getIdOther() {
		return idOther;
	}
	public void setIdOther(String idOther) {
		this.idOther = idOther;
	}
	public String getIncome() {
		return income;
	}
	public void setIncome(String income) {
		this.income = income;
	}
	public String getIncomeWorkerEmail1() {
		return incomeWorkerEmail1;
	}
	public void setIncomeWorkerEmail1(String incomeWorkerEmail1) {
		this.incomeWorkerEmail1 = incomeWorkerEmail1;
	}
	public String getIncomeWorkerEmail2() {
		return incomeWorkerEmail2;
	}
	public void setIncomeWorkerEmail2(String incomeWorkerEmail2) {
		this.incomeWorkerEmail2 = incomeWorkerEmail2;
	}
	public String getIncomeWorkerEmail3() {
		return incomeWorkerEmail3;
	}
	public void setIncomeWorkerEmail3(String incomeWorkerEmail3) {
		this.incomeWorkerEmail3 = incomeWorkerEmail3;
	}
	public String getIncomeWorkerName1() {
		return incomeWorkerName1;
	}
	public void setIncomeWorkerName1(String incomeWorkerName1) {
		this.incomeWorkerName1 = incomeWorkerName1;
	}
	public String getIncomeWorkerName2() {
		return incomeWorkerName2;
	}
	public void setIncomeWorkerName2(String incomeWorkerName2) {
		this.incomeWorkerName2 = incomeWorkerName2;
	}
	public String getIncomeWorkerName3() {
		return incomeWorkerName3;
	}
	public void setIncomeWorkerName3(String incomeWorkerName3) {
		this.incomeWorkerName3 = incomeWorkerName3;
	}
	public String getIncomeWorkerPhone1() {
		return incomeWorkerPhone1;
	}
	public void setIncomeWorkerPhone1(String incomeWorkerPhone1) {
		this.incomeWorkerPhone1 = incomeWorkerPhone1;
	}
	public String getIncomeWorkerPhone2() {
		return incomeWorkerPhone2;
	}
	public void setIncomeWorkerPhone2(String incomeWorkerPhone2) {
		this.incomeWorkerPhone2 = incomeWorkerPhone2;
	}
	public String getIncomeWorkerPhone3() {
		return incomeWorkerPhone3;
	}
	public void setIncomeWorkerPhone3(String incomeWorkerPhone3) {
		this.incomeWorkerPhone3 = incomeWorkerPhone3;
	}
	public String getInShelterBefore() {
		return inShelterBefore;
	}
	public void setInShelterBefore(String inShelterBefore) {
		this.inShelterBefore = inShelterBefore;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String getLengthOfHomeless() {
		return lengthOfHomeless;
	}
	public void setLengthOfHomeless(String lengthOfHomeless) {
		this.lengthOfHomeless = lengthOfHomeless;
	}
	public String getLibraryCard() {
		return libraryCard;
	}
	public void setLibraryCard(String libraryCard) {
		this.libraryCard = libraryCard;
	}
	public String getLibraryCardYN() {
		return libraryCardYN;
	}
	public void setLibraryCardYN(String libraryCardYN) {
		this.libraryCardYN = libraryCardYN;
	}
	public String getLivedBefore() {
		return livedBefore;
	}
	public void setLivedBefore(String livedBefore) {
		this.livedBefore = livedBefore;
	}
	public String getLivedBeforeOther() {
		return livedBeforeOther;
	}
	public void setLivedBeforeOther(String livedBeforeOther) {
		this.livedBeforeOther = livedBeforeOther;
	}
	public String getNativeReserveNo() {
		return nativeReserveNo;
	}
	public void setNativeReserveNo(String nativeReserveNo) {
		this.nativeReserveNo = nativeReserveNo;
	}
	public String getNativeReserveNoYN() {
		return nativeReserveNoYN;
	}
	public void setNativeReserveNoYN(String nativeReserveNoYN) {
		this.nativeReserveNoYN = nativeReserveNoYN;
	}
	public String getObservedAbuse() {
		return observedAbuse;
	}
	public void setObservedAbuse(String observedAbuse) {
		this.observedAbuse = observedAbuse;
	}
	public String getObservedAlcoholAbuse() {
		return observedAlcoholAbuse;
	}
	public void setObservedAlcoholAbuse(String observedAlcoholAbuse) {
		this.observedAlcoholAbuse = observedAlcoholAbuse;
	}
	public String getObservedMentalIssue() {
		return observedMentalIssue;
	}
	public void setObservedMentalIssue(String observedMentalIssue) {
		this.observedMentalIssue = observedMentalIssue;
	}
	public String getOriginalCountry() {
		return originalCountry;
	}
	public void setOriginalCountry(String originalCountry) {
		this.originalCountry = originalCountry;
	}
	public String getPoorHygiene() {
		return poorHygiene;
	}
	public void setPoorHygiene(String poorHygiene) {
		this.poorHygiene = poorHygiene;
	}
	public String getPregnant() {
		return pregnant;
	}
	public void setPregnant(String pregnant) {
		this.pregnant = pregnant;
	}
	public String getReasonForHomeless() {
		return reasonForHomeless;
	}
	public void setReasonForHomeless(String reasonForHomeless) {
		this.reasonForHomeless = reasonForHomeless;
	}
	public String getReasonNoAdmit() {
		return reasonNoAdmit;
	}
	public void setReasonNoAdmit(String reasonNoAdmit) {
		this.reasonNoAdmit = reasonNoAdmit;
	}
	public String getRecordLanding() {
		return recordLanding;
	}
	public void setRecordLanding(String recordLanding) {
		this.recordLanding = recordLanding;
	}
	public String getRecordLandingYN() {
		return recordLandingYN;
	}
	public void setRecordLandingYN(String recordLandingYN) {
		this.recordLandingYN = recordLandingYN;
	}
	public String getReferredBy() {
		return referredBy;
	}
	public void setReferredBy(String referredBy) {
		this.referredBy = referredBy;
	}
	public String getReferredTo() {
		return referredTo;
	}
	public void setReferredTo(String referredTo) {
		this.referredTo = referredTo;
	}
	public String getSIN() {
		return SIN;
	}
	public void setSIN(String sin) {
		SIN = sin;
	}
	public String getSINYN() {
		return SINYN;
	}
	public void setSINYN(String sinyn) {
		SINYN = sinyn;
	}
	public String[] getSourceIncome() {
		return sourceIncome;
	}
	public void setSourceIncome(String[] sourceIncome) {
		this.sourceIncome = sourceIncome;
	}
	public String getStatusInCanada() {
		return statusInCanada;
	}
	public void setStatusInCanada(String statusInCanada) {
		this.statusInCanada = statusInCanada;
	}
	public String getVAW() {
		return VAW;
	}
	public void setVAW(String vaw) {
		VAW = vaw;
	}
	public String getVeteranNo() {
		return veteranNo;
	}
	public void setVeteranNo(String veteranNo) {
		this.veteranNo = veteranNo;
	}
	public String getVeteranNoYN() {
		return veteranNoYN;
	}
	public void setVeteranNoYN(String veteranNoYN) {
		this.veteranNoYN = veteranNoYN;
	}
	public String getYouth() {
		return youth;
	}
	public void setYouth(String youth) {
		this.youth = youth;
	}
	public Integer getClientId() {
		return clientId;
	}
	public void setClientId(Integer clientId) {
		this.clientId = clientId;
	}
	public Calendar getCreatedOn() {
		return createdOn;
	}
	public void setCreatedOn(Calendar createdOn) {
		this.createdOn = createdOn;
	}
	public Calendar getEndDate() {
		return endDate;
	}
	public void setEndDate(Calendar endDate) {
		this.endDate = endDate;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getIntakeStatus() {
		return intakeStatus;
	}
	public void setIntakeStatus(String intakeStatus) {
		this.intakeStatus = intakeStatus;
	}
	public Integer getProgramId() {
		return programId;
	}
	public void setProgramId(Integer programId) {
		this.programId = programId;
	}
	public String getStaffId() {
		return staffId;
	}
	public void setStaffId(String staffId) {
		this.staffId = staffId;
	}
	public String getCreatedOnTxt() {
		return createdOnTxt;
	}
	public void setCreatedOnTxt(String createdOnTxt) {
		this.createdOnTxt = createdOnTxt;
	}
	public String getEndDateTxt() {
		return endDateTxt;
	}
	public void setEndDateTxt(String endDateTxt) {
		this.endDateTxt = endDateTxt;
	}

	public String getProgramType() {
		return programType;
	}
	public void setProgramType(String programType) {
		this.programType = programType;
	}
/*	
	public Integer getQueueId() {
		return queueId;
	}
	public void setQueueId(Integer queueId) {
		this.queueId = queueId;
	}
	public Integer getReferralId() {
		return referralId;
	}
	public void setReferralId(Integer referralId) {
		this.referralId = referralId;
	}
*/	
	public Integer getCurrentProgramId() {
		return currentProgramId;
	}
	public void setCurrentProgramId(Integer currentProgramId) {
		this.currentProgramId = currentProgramId;
	}
	public String getProgramName() {
		return programName;
	}
	public void setProgramName(String programName) {
		this.programName = programName;
	}
	public String getReasonForService() {
		return reasonForService;
	}
	public void setReasonForService(String reasonForService) {
		this.reasonForService = reasonForService;
	}
	public String getNerverExpiry() {
		return nerverExpiry;
	}
	public void setNerverExpiry(String nerverExpiry) {
		this.nerverExpiry = nerverExpiry;
	}
	public String getSdmtBenUnitStatus() {
		return sdmtBenUnitStatus;
	}
	public void setSdmtBenUnitStatus(String sdmtBenUnitStatus) {
		this.sdmtBenUnitStatus = sdmtBenUnitStatus;
	}
	public String getSdmtLastBenMonth() {
		return sdmtLastBenMonth;
	}
	public void setSdmtLastBenMonth(String sdmtLastBenMonth) {
		this.sdmtLastBenMonth = sdmtLastBenMonth;
	}
	public String getSdmtOffice() {
		return sdmtOffice;
	}
	public void setSdmtOffice(String sdmtOffice) {
		this.sdmtOffice = sdmtOffice;
	}
	public String getStaffDesc() {
		return m_staffDesc;
	}
	public void setStaffDesc(String staffDesc) {
		this.m_staffDesc = staffDesc;
	}
	public String getCompletionNotes() {
		return completionNotes;
	}
	public void setCompletionNotes(String completionNotes) {
		this.completionNotes = completionNotes;
	}
	public String getRejectionReasonDesc() {
		return rejectionReasonDesc;
	}
	public void setRejectionReasonDesc(String rejectionReasonDesc) {
		this.rejectionReasonDesc = rejectionReasonDesc;
	}
}
