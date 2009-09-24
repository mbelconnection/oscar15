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

import com.quatro.util.Utility;

public class SdmtOut implements Serializable {

	private static final long serialVersionUID = 1L;
	 private Integer batchNumber;
	 private Calendar batchDate;
	 private String firstName;
	 private String lastName;
	 private Calendar dob;
	 private String sin;
	 private String healthCardNo;	 
	 private Integer recordId;
	 private Integer sdmtId;
	 private Integer sdmtBenUnitId;
	 private Integer clientId;  //qs client id 
	 private Integer maxBatchNo;
	 private boolean sendOut;
	
	public boolean isSendOut() {
		return sendOut;
	}
	public void setSendOut(boolean sendOut) {
		this.sendOut = sendOut;
	}
	public Integer getMaxBatchNo() {
		return maxBatchNo;
	}
	public void setMaxBatchNo(Integer maxBatchNo) {
		this.maxBatchNo = maxBatchNo;
	}
	
	public Integer getClientId() {
		return clientId;
	}
	public void setClientId(Integer clientId) {
		this.clientId = clientId;
	}
	
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getHealthCardNo() {
		return healthCardNo;
	}
	public void setHealthCardNo(String healthCardNo) {
		this.healthCardNo = healthCardNo;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public Integer getRecordId() {
		return recordId;
	}
	public void setRecordId(Integer recordId) {
		this.recordId = recordId;
	}
	public Integer getSdmtBenUnitId() {
		return sdmtBenUnitId;
	}
	public void setSdmtBenUnitId(Integer sdmtBenUnitId) {
		this.sdmtBenUnitId = sdmtBenUnitId;
	}
	public Integer getSdmtId() {
		return sdmtId;
	}
	public void setSdmtId(Integer sdmtId) {
		this.sdmtId = sdmtId;
	}
	public String getSin() {
		return sin;
	}
	public void setSin(String sin) {
		this.sin = sin;
	}
	public Integer getBatchNumber() {
		return batchNumber;
	}
	public void setBatchNumber(Integer batchNumber) {
		this.batchNumber = batchNumber;
	}
	public Calendar getBatchDate() {
		return batchDate;
	}
	public void setBatchDate(Calendar batchDateStr) {
		this.batchDate = batchDateStr;
	}
	public Calendar getDob() {
		return dob;
	}
	public void setDob(Calendar dobStr) {
		this.dob = dobStr;
	}
	
}
