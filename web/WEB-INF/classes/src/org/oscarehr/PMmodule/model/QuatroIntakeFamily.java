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

public class QuatroIntakeFamily implements Serializable{
	private static final long serialVersionUID = 1L;
    private int hashCode = Integer.MIN_VALUE;

    private Integer intakeHeadId;
    private Integer intakeId;
    private Integer admissionId;
    private Integer programId;
    private String memberStatus;
    private String relationship;
    private String relationshipDesc;
    private Calendar joinFamilyDate;
    private String joinFamilyDateTxt;
    private Calendar leaveFamilyDate;
//    private Calendar dateOfBirth;
    private String firstName;
    private String lastName;
    private String sex;
    private String sexDesc;
    private String alias;    

    private Integer clientId;
    private String dob;
    private String select;
    
    private String statusMsg;
    //hidden field in family intake page, to be compatible with single person intake.

    //a flag in each line of family intake page. 
    private String newClientChecked;
    private String duplicateClient;
    private String serviceRestriction;

    private String effDate;
    private Calendar lastUpdateDate;
    private String lastUpdateUser;
    
    public Calendar getLastUpdateDate() {
		return lastUpdateDate;
	}

	public void setLastUpdateDate(Calendar lastUpdateDate) {
		this.lastUpdateDate = lastUpdateDate;
	}

	public String getLastUpdateUser() {
		return lastUpdateUser;
	}

	public void setLastUpdateUser(String lastUpdateUser) {
		this.lastUpdateUser = lastUpdateUser;
	}

	public QuatroIntakeFamily(){
    	this.select="sel";
    }

    public QuatroIntakeFamily(Integer clientId, Integer intakeHeadId, 
    		Integer intakeId, Integer admissionId, String relationship, Calendar joinFamilyDate)
    {
       this.clientId = clientId;
       this.intakeHeadId = intakeHeadId;
       this.intakeId = intakeId;
       this.admissionId = admissionId;
       this.relationship = relationship;
       this.joinFamilyDate=joinFamilyDate;
   	   this.select="sel";
    }
    
    public Integer getIntakeHeadId() {
		return intakeHeadId;
	}
	public void setIntakeHeadId(Integer intakeHeadId) {
		this.intakeHeadId = intakeHeadId;
	}
	public Integer getIntakeId() {
		return intakeId;
	}
	public void setIntakeId(Integer intakeId) {
		this.intakeId = intakeId;
	}
	public Calendar getJoinFamilyDate() {
		return joinFamilyDate;
	}
	public void setJoinFamilyDate(Calendar joinFamilyDate) {
		this.joinFamilyDate = joinFamilyDate;
	}
	public Calendar getLeaveFamilyDate() {
		return leaveFamilyDate;
	}
	public void setLeaveFamilyDate(Calendar leaveFamilyDate) {
		this.leaveFamilyDate = leaveFamilyDate;
	}
	public String getMemberStatus() {
		return memberStatus;
	}
	public void setMemberStatus(String memberStatus) {
		this.memberStatus = memberStatus;
	}
	public String getRelationship() {
		return relationship;
	}
	public void setRelationship(String relationship) {
		this.relationship = relationship;
	}
	
    public boolean equals(Object obj) {
        if (null == obj)
            return false;
        if (!(obj instanceof QuatroIntakeFamily))
            return false;
        else {
        	QuatroIntakeFamily intakeFamily = (QuatroIntakeFamily) obj;
        	
           if (null == this.getIntakeHeadId() || null == intakeFamily.getIntakeHeadId() 
        	   || null == this.getIntakeId() || null == intakeFamily.getIntakeId())
              return false;
           else
              return (this.getIntakeHeadId().equals(intakeFamily.getIntakeHeadId()) &&
            		  this.getIntakeId().equals(intakeFamily.getIntakeId()));
              
        }
        
    }

    public int hashCode() {
        if (Integer.MIN_VALUE == this.hashCode) {
            if (null == this.getIntakeHeadId() || null == this.getIntakeId())
                return super.hashCode();
            else {
                String hashStr = this.getClass().getName() + ":" + this.getIntakeHeadId().hashCode() +
                                 ":" + this.getIntakeId().hashCode();
                this.hashCode = hashStr.hashCode();
            }
        }
        return this.hashCode;
    }
	public String getAlias() {
		return alias;
	}
	public void setAlias(String alias) {
		this.alias = alias;
	}
/*	
	public Calendar getDateOfBirth() {
		return dateOfBirth;
	}
	public void setDateOfBirth(Calendar dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}
*/	
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public int getHashCode() {
		return hashCode;
	}
	public void setHashCode(int hashCode) {
		this.hashCode = hashCode;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public Integer getClientId() {
		return clientId;
	}
	public void setClientId(Integer clientId) {
		this.clientId = clientId;
	}

	public String getSelect() {
		return select;
	}

	public void setSelect(String select) {
		this.select = select;
	}

	public String getSexDesc() {
		return sexDesc;
	}

	public void setSexDesc(String sexDesc) {
		this.sexDesc = sexDesc;
	}

	public String getServiceRestriction() {
		return serviceRestriction;
	}

	public void setServiceRestriction(String serviceRestriction) {
		this.serviceRestriction = serviceRestriction;
	}

	public String getRelationshipDesc() {
		return relationshipDesc;
	}

	public void setRelationshipDesc(String relationshipDesc) {
		this.relationshipDesc = relationshipDesc;
	}

	public String getStatusMsg() {
		return statusMsg;
	}

	public void setStatusMsg(String statusMsg) {
		this.statusMsg = statusMsg;
	}

	public String getNewClientChecked() {
		return newClientChecked;
	}

	public void setNewClientChecked(String newClientChecked) {
		this.newClientChecked = newClientChecked;
	}

	public String getDuplicateClient() {
		return this.duplicateClient;
	}

	public void setDuplicateClient(String duplicateClient) {
		this.duplicateClient = duplicateClient;
	}

	public String getEffDate() {
		return effDate;
	}

	public void setEffDate(String effDate) {
		this.effDate = effDate;
	}

	public String getJoinFamilyDateTxt() {
		return joinFamilyDateTxt;
	}
	public void setJoinFamilyDateTxt(String joinFamilyDateTxt) {
		this.joinFamilyDateTxt = joinFamilyDateTxt;
	}

	public String getDob() {
		return dob;
	}

	public void setDob(String dob) {
		this.dob = dob;
	}

	public Integer getAdmissionId() {
		return admissionId;
	}

	public void setAdmissionId(Integer admissionId) {
		this.admissionId = admissionId;
	}

	public Integer getProgramId() {
		return programId;
	}

	public void setProgramId(Integer programId) {
		this.programId = programId;
	}

}
