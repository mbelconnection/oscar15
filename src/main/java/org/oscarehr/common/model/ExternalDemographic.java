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


package org.oscarehr.common.model;

import java.io.Serializable;
import java.util.Comparator;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "ExternalDemographic")
public class ExternalDemographic extends AbstractModel<Integer> implements Serializable {

	/**
	 * This comparator sorts EForm ascending based on the id
	 */
	public static final Comparator<ExternalDemographic> FORM_NAME_COMPARATOR = new Comparator<ExternalDemographic>() {
		public int compare(ExternalDemographic firstExternalDemographic, ExternalDemographic secondExternalDemographic) {
			return (firstExternalDemographic.id.compareTo(secondExternalDemographic.id));
		}
	};

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "externalDemographicId")
	private Integer id;

	@Column(name = "demographic_no")
    private Integer demographic_no;

    @Column(name = "affinityDomain")
    private String affinityDomain;
    
    @Column(name = "updateEnabled")
    private Boolean updateEnabled;
    
    @Column(name = "active")
    private Boolean active;
    
    @Column(name = "createdUTC")
    @Temporal(TemporalType.DATE)
    private Date createdUTC = new Date();
    
    @Column(name = "lastDisabled")
    @Temporal(TemporalType.DATE)
    private Date lastDisabled = new Date();
    
    @Column(name = "lastEnabled")
    @Temporal(TemporalType.DATE)
    private Date lastEnabled = new Date();


    @Override
	public Integer getId() {
		return (id);
	}



	public String getAffinityDomain() {
	    return affinityDomain;
    }


	public void setAffinityDomain(String affinityDomain) {
	    this.affinityDomain = affinityDomain;
    }


	public Boolean isUpdateEnabled() {
	    return updateEnabled;
    }


	public void setUpdateEnabled(Boolean updateEnabled) {
	    this.updateEnabled = updateEnabled;
    }


	public Date getCreatedUTC() {
	    return createdUTC;
    }


	public void setCreatedUTC(Date createdUTC) {
	    this.createdUTC = createdUTC;
    }


	public Date getLastDisabled() {
	    return lastDisabled;
    }


	public void setLastDisabled(Date lastDisabled) {
	    this.lastDisabled = lastDisabled;
    }


	public Date getLastEnabled() {
	    return lastEnabled;
    }


	public void setLastEnabled(Date lastEnabled) {
	    this.lastEnabled = lastEnabled;
    }


	public Boolean isActive() {
	    return active;
    }


	public void setActive(Boolean active) {
	    this.active = active;
    }



	public Integer getDemographic_no() {
	    return demographic_no;
    }



	public void setDemographic_no(Integer demographic_no) {
	    this.demographic_no = demographic_no;
    }

}
