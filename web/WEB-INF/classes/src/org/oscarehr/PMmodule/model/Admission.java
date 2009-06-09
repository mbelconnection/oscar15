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
import java.text.SimpleDateFormat;
import java.util.Calendar;
import oscar.MyDateFormat;
import java.util.Date;

public class Admission implements Serializable, Cloneable {

	private static final long serialVersionUID = 1L;

	private Integer id;
	private Integer clientId;
	private boolean familyMember;  //for family admission discharge jsp page
	private Integer programId;
	private String providerNo;
	private String issuedBy;
	private String providerName;
	private java.util.Calendar admissionDate;
	private String admissionDateTxt;
	private String admissionStatus;
	private String dischargeNotes;
	private Calendar dischargeDate;
	private boolean automaticDischarge=false;

	private Integer intakeId;
//	private Integer facilityId;
	private String programName;
	private String programType;

	private String communityProgramCode;
	private String communityProgramDesc;
	private String transportationType;
	private String transportationTypeDesc;

	private String dischargeReason;
	
	private String residentStatus;
	private String primaryWorker;
	private String lockerNo;
	private String noOfBags;
	private String nextKinName;
	private String nextKinRelationship;
	private String nextKinTelephone;
	private String nextKinNumber;
	private String nextKinStreet;
	private String nextKinCity;
	private String nextKinProvince;
	private String nextKinPostal;
	private String nextKinCountry;
	private Calendar ovPassStartDate;
	private String ovPassStartDateTxt;
	private Calendar ovPassEndDate;
	private String ovPassEndDateTxt;
    private String notSignReason;
    private String admissionNotes;
    private Calendar lastUpdateDate;
    
    private Integer intakeHeadId;

    public String getAdmissionDateStr() {
		if(admissionDate==null) return "";
		return MyDateFormat.getStandardDate(admissionDate);
	}

    public String getAdmissionDateTxt() {
		return admissionDateTxt;
	}
    public void setAdmissionDateTxt(String admissionDateTxt) {
    	this.admissionDateTxt=admissionDateTxt;
    }
    public java.util.Calendar getAdmissionDate() {
		return admissionDate;
	}
	public void setAdmissionDate(java.util.Calendar admissionDate) {
		this.admissionDate = admissionDate;
	}
	public String getAdmissionStatus() {
		return admissionStatus;
	}
	public void setAdmissionStatus(String admissionStatus) {
		if(admissionStatus!=null)
		  this.admissionStatus = admissionStatus.trim();
		else
		  this.admissionStatus = admissionStatus;
	}
	public Integer getClientId() {
		return clientId;
	}
	public void setClientId(Integer clientId) {
		this.clientId = clientId;
	}
/*	
	public Integer getFacilityId() {
		return facilityId;
	}
	public void setFacilityId(Integer shelterId) {
		this.facilityId = facilityId;
	}
*/	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getIntakeId() {
		return intakeId;
	}
	public void setIntakeId(Integer intakeId) {
		this.intakeId = intakeId;
	}
	public String getLockerNo() {
		return lockerNo;
	}
	public void setLockerNo(String lockerNo) {
		if(lockerNo!=null)
		  this.lockerNo = lockerNo.trim();
		else
		  this.lockerNo = lockerNo;
	}
	public String getNextKinCity() {
		return nextKinCity;
	}
	public void setNextKinCity(String nextKinCity) {
		if(nextKinCity!=null)
		  this.nextKinCity = nextKinCity.trim();
		else
		  this.nextKinCity = nextKinCity;
	}
	public String getNextKinName() {
		return nextKinName;
	}
	public void setNextKinName(String nextKinName) {
		if(nextKinName!=null)
		  this.nextKinName = nextKinName.trim();
		else
		  this.nextKinName = nextKinName;
	}
	public String getNextKinNumber() {
		return nextKinNumber;
	}
	public void setNextKinNumber(String nextKinNumber) {
		if(nextKinNumber!=null)
		  this.nextKinNumber = nextKinNumber.trim();
		else
		  this.nextKinNumber = nextKinNumber;
	}
	public String getNextKinPostal() {
		return nextKinPostal;
	}
	public void setNextKinPostal(String nextKinPostal) {
		if(nextKinPostal!=null)
  		  this.nextKinPostal = nextKinPostal.trim();
		else
		  this.nextKinPostal = nextKinPostal;
	}
	public String getNextKinProvince() {
		return nextKinProvince;
	}
	public void setNextKinProvince(String nextKinProvince) {
		this.nextKinProvince = nextKinProvince;
	}
	public String getNextKinRelationship() {
		return nextKinRelationship;
	}
	public void setNextKinRelationship(String nextKinRelationship) {
		if(nextKinRelationship!=null)
		  this.nextKinRelationship = nextKinRelationship.trim();
		else
		  this.nextKinRelationship = nextKinRelationship;
	}
	public String getNextKinStreet() {
		return nextKinStreet;
	}
	public void setNextKinStreet(String nextKinStreet) {
		this.nextKinStreet = nextKinStreet;
	}
	public String getNextKinTelephone() {
		return nextKinTelephone;
	}
	public void setNextKinTelephone(String nextKinTelephone) {
		if(nextKinTelephone!=null)
		  this.nextKinTelephone = nextKinTelephone.trim();
		else
		  this.nextKinTelephone = nextKinTelephone;
	}
	public String getNoOfBags() {
		return noOfBags;
	}
	public void setNoOfBags(String noOfBags) {
		this.noOfBags = noOfBags;
	}
	public String getNotSignReason() {
		return notSignReason;
	}
	public void setNotSignReason(String notSignReason) {
		this.notSignReason = notSignReason;
	}
	public Calendar getOvPassEndDate() {
		return ovPassEndDate;
	}
	public void setOvPassEndDate(Calendar ovPassEndDate) {
		this.ovPassEndDate = ovPassEndDate;
	}
	public Calendar getOvPassStartDate() {
		return ovPassStartDate;
	}
	public void setOvPassStartDate(Calendar ovPassStartDate) {
		this.ovPassStartDate = ovPassStartDate;
	}
	public String getPrimaryWorker() {
		return primaryWorker;
	}
	public void setPrimaryWorker(String primaryWorker) {
		this.primaryWorker = primaryWorker;
	}
	public Integer getProgramId() {
		return programId;
	}
	public void setProgramId(Integer programId) {
		this.programId = programId;
	}
	public String getProgramName() {
		return programName;
	}
	public void setProgramName(String programName) {
		this.programName = programName;
	}
	public String getProgramType() {
		return programType;
	}
	public void setProgramType(String programType) {
		this.programType = programType;
	}
	public String getProviderNo() {
		return providerNo;
	}
	public void setProviderNo(String providerNo) {
		this.providerNo = providerNo;
	}
	public String getResidentStatus() {
		return residentStatus;
	}
	public void setResidentStatus(String residentStatus) {
		this.residentStatus = residentStatus;
	}
	public Calendar getDischargeDate() {
		return dischargeDate;
	}
	public void setDischargeDate(Calendar dischargeDate) {
		this.dischargeDate = dischargeDate;
	}
	public String getDischargeNotes() {
		return dischargeNotes;
	}
	public void setDischargeNotes(String dischargeNotes) {
		this.dischargeNotes = dischargeNotes;
	}
	public String getOvPassEndDateTxt() {
		return ovPassEndDateTxt;
	}
	public void setOvPassEndDateTxt(String ovPassEndDateTxt) {
		this.ovPassEndDateTxt = ovPassEndDateTxt;
	}
	public String getOvPassStartDateTxt() {
		return ovPassStartDateTxt;
	}
	public void setOvPassStartDateTxt(String ovPassStartDateTxt) {
		this.ovPassStartDateTxt = ovPassStartDateTxt;
	}

	public boolean isAutomaticDischarge() {
		return automaticDischarge;
	}

	public void setAutomaticDischarge(boolean automaticDischarge) {
		this.automaticDischarge = automaticDischarge;
	}

	public String getCommunityProgramCode() {
		return communityProgramCode;
	}

	public void setCommunityProgramCode(String communityProgramCode) {
		this.communityProgramCode = communityProgramCode;
	}


	public String getCommunityProgramDesc() {
		return communityProgramDesc;
	}

	public void setCommunityProgramDesc(String communityProgramDesc) {
		this.communityProgramDesc = communityProgramDesc;
	}

	public String getTransportationType() {
		return transportationType;
	}

	public void setTransportationType(String transportationType) {
		this.transportationType = transportationType;
	}

	public String getTransportationTypeDesc() {
		return transportationTypeDesc;
	}

	public void setTransportationTypeDesc(String transportationTypeDesc) {
		this.transportationTypeDesc = transportationTypeDesc;
	}

	public String getDischargeReason() {
		return dischargeReason;
	}

	public void setDischargeReason(String dischargeReason) {
		this.dischargeReason = dischargeReason;
	}

	public Object clone() {
      try {
          return super.clone();
      } catch (CloneNotSupportedException e) {
          throw new Error("This should not occur since we implement Cloneable");
      }
    }

	public String getAdmissionNotes() {
		return admissionNotes;
	}

	public void setAdmissionNotes(String admissionNotes) {
		this.admissionNotes = admissionNotes;
	}
		
	public boolean isFamilyMember() {
		return familyMember;
	}

	public void setFamilyMember(boolean familyMember) {
		this.familyMember = familyMember;
	}

	public Integer getIntakeHeadId() {
		return intakeHeadId;
	}

	public void setIntakeHeadId(Integer intakeHeadId) {
		this.intakeHeadId = intakeHeadId;
	}

	public Calendar getLastUpdateDate() {
		return lastUpdateDate;
	}

	public void setLastUpdateDate(Calendar lastUpdateDate) {
		this.lastUpdateDate = lastUpdateDate;
	}

	public String getProviderName() {
		return providerName;
	}

	public void setProviderName(String providerName) {
		this.providerName = providerName;
	}

	public Integer getDaysInProgram(){
		Date admissionDate = getAdmissionDate().getTime();
		Date dischargeDate = getDischargeDate() != null ? getDischargeDate().getTime() : new Date();
			
		long diff = dischargeDate.getTime() - admissionDate.getTime();
		diff = diff / 1000; // seconds
		diff = diff / 60; // minutes
		diff = diff / 60; // hours
		diff = diff / 24; // days

		return new Integer((int)diff);
	}

	public String getNextKinCountry() {
		return nextKinCountry;
	}

	public void setNextKinCountry(String nextKinCountry) {
		this.nextKinCountry = nextKinCountry;
	}

	public String getIssuedBy() {
		return issuedBy;
	}

	public void setIssuedBy(String issuedBy) {
		this.issuedBy = issuedBy;
	}

}
