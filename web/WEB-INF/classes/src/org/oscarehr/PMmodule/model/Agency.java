/*
 * Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
 * This software is published under the GPL GNU General Public License. 
 * This program is free software; you can redistribute it and/or 
 * modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation; either version 2 
 * of the License, or (at your option) any later version. * 
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
 * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License 
 * along with this program; if not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. * 
 * 
 * <OSCAR TEAM>
 * 
 * This software was written for 
 * Centre for Research on Inner City Health, St. Michael's Hospital, 
 * Toronto, Ontario, Canada 
 */
package org.oscarehr.PMmodule.model;

import java.util.Map;
import java.io.Serializable;

/**
 * This is the object class that relates to the agency table. Any customizations belong here.
 */
public class Agency implements Serializable {

	private static final long serialVersionUID = 1L;

	private static Agency localAgency;
	private static Map<?, ?> agencyMap;
    public static String REF = "Agency";
    public static String PROP_INTEGRATOR_USERNAME = "integratorUsername";
    public static String PROP_DESCRIPTION = "description";
    public static String PROP_LOCAL = "local";
    public static String PROP_CONTACT_NAME = "contactName";
    public static String PROP_INTAKE_QUICK_STATE = "intakeQuickState";
    public static String PROP_CONTACT_EMAIL = "contactEmail";
    public static String PROP_INTEGRATOR_JMS = "integratorJms";
    public static String PROP_CONTACT_PHONE = "contactPhone";
    public static String PROP_INTEGRATOR_ENABLED = "integratorEnabled";
    public static String PROP_INTEGRATOR_URL = "integratorUrl";
    public static String PROP_INTEGRATOR_PASSWORD = "integratorPassword";
    public static String PROP_NAME = "name";
    public static String PROP_HIC = "hic";
    public static String PROP_INTAKE_INDEPTH_STATE = "intakeIndepthState";
    public static String PROP_INTAKE_INDEPTH = "intakeIndepth";
    public static String PROP_INTAKE_QUICK = "intakeQuick";
    public static String PROP_ID = "id";

    private int hashCode = Integer.MIN_VALUE;// primary key

    private Long id;// fields

    private Integer intakeQuick;
    private String intakeQuickState;
    private Integer intakeIndepth;
    private String intakeIndepthState;
    private String name;
    private String description;
    private String contactName;
    private String contactEmail;
    private String contactPhone;
    private boolean local;
    private boolean integratorEnabled;
    private String integratorUrl;
    private String integratorJms;
    private String integratorUsername;
    private String integratorPassword;
    private boolean hic;
    private boolean disabled;

    // constructors
	public Agency () {
		initialize();
	}

	/**
	 * Constructor for primary key
	 */
	public Agency (java.lang.Long id) {
		this.setId(id);
		initialize();
	}

	/**
	 * Constructor for required fields
	 */
	public Agency (
		java.lang.Long id,
		java.lang.Integer intakeQuick,
		java.lang.String intakeQuickState,
		java.lang.String intakeIndepthState,
		java.lang.String name,
		boolean local,
		boolean integratorEnabled) {

		this.setId(id);
		this.setIntakeQuick(intakeQuick);
		this.setIntakeQuickState(intakeQuickState);
		this.setIntakeIndepthState(intakeIndepthState);
		this.setName(name);
		this.setLocal(local);
		this.setIntegratorEnabled(integratorEnabled);
		initialize();
	}

    public static Agency getLocalAgency() {
		return localAgency;
	}

	public static Map<?, ?> getAgencyMap() {
		return agencyMap;
	}

	public static void setLocalAgency(Agency agency) {
		localAgency = agency;
	}

	public static void setAgencyMap(Map<?, ?> map) {
		agencyMap = map;
	}

	public static String getAgencyName(Long agencyId) {
		if (agencyMap != null) {
			Agency agency = (Agency) agencyMap.get(agencyId);

			if (agency != null) {
				return agency.getName();
			}
		}

		return "Unknown (" + agencyId + ")";
	}


	public boolean areHousingProgramsVisible(String intakeType) {
		boolean visible = false;

		if (Intake.QUICK.equalsIgnoreCase(intakeType)) {
			visible = getIntakeQuickState().contains("H");
		} else if (Intake.INDEPTH.equalsIgnoreCase(intakeType)) {
			visible = getIntakeIndepthState().contains("H");
		}

		return visible;
	}

	public boolean areServiceProgramsVisible(String intakeType) {
		boolean visible = false;

		if (Intake.QUICK.equalsIgnoreCase(intakeType)) {
			visible = getIntakeQuickState().contains("S");
		} else if (Intake.INDEPTH.equalsIgnoreCase(intakeType)) {
			visible = getIntakeIndepthState().contains("S");
		}

		return visible;
	}

    protected void initialize () {}

    /**
	 * Return the unique identifier of this class
* @hibernate.id
*  generator-class="native"
*  column="id"
*/
    public Long getId () {
        return id;
    }

    /**
	 * Set the unique identifier of this class
     * @param id the new ID
     */
    public void setId (Long id) {
        this.id = id;
        this.hashCode = Integer.MIN_VALUE;
    }

    /**
	 * Return the value associated with the column: intake_quick
     */
    public Integer getIntakeQuick () {
        return intakeQuick;
    }

    /**
	 * Set the value related to the column: intake_quick
     * @param intakeQuick the intake_quick value
     */
    public void setIntakeQuick (Integer intakeQuick) {
        this.intakeQuick = intakeQuick;
    }

    /**
	 * Return the value associated with the column: intake_quick_state
     */
    public String getIntakeQuickState () {
        return intakeQuickState;
    }

    /**
	 * Set the value related to the column: intake_quick_state
     * @param intakeQuickState the intake_quick_state value
     */
    public void setIntakeQuickState (String intakeQuickState) {
        this.intakeQuickState = intakeQuickState;
    }

    /**
	 * Return the value associated with the column: intake_indepth
     */
    public Integer getIntakeIndepth () {
        return intakeIndepth;
    }

    /**
	 * Set the value related to the column: intake_indepth
     * @param intakeIndepth the intake_indepth value
     */
    public void setIntakeIndepth (Integer intakeIndepth) {
        this.intakeIndepth = intakeIndepth;
    }

    /**
	 * Return the value associated with the column: intake_indepth_state
     */
    public String getIntakeIndepthState () {
        return intakeIndepthState;
    }

    /**
	 * Set the value related to the column: intake_indepth_state
     * @param intakeIndepthState the intake_indepth_state value
     */
    public void setIntakeIndepthState (String intakeIndepthState) {
        this.intakeIndepthState = intakeIndepthState;
    }

    /**
	 * Return the value associated with the column: name
     */
    public String getName () {
        return name;
    }

    /**
	 * Set the value related to the column: name
     * @param name the name value
     */
    public void setName (String name) {
        this.name = name;
    }

    /**
	 * Return the value associated with the column: description
     */
    public String getDescription () {
        return description;
    }

    /**
	 * Set the value related to the column: description
     * @param description the description value
     */
    public void setDescription (String description) {
        this.description = description;
    }

    /**
	 * Return the value associated with the column: contact_name
     */
    public String getContactName () {
        return contactName;
    }

    /**
	 * Set the value related to the column: contact_name
     * @param contactName the contact_name value
     */
    public void setContactName (String contactName) {
        this.contactName = contactName;
    }

    /**
	 * Return the value associated with the column: contact_email
     */
    public String getContactEmail () {
        return contactEmail;
    }

    /**
	 * Set the value related to the column: contact_email
     * @param contactEmail the contact_email value
     */
    public void setContactEmail (String contactEmail) {
        this.contactEmail = contactEmail;
    }

    /**
	 * Return the value associated with the column: contact_phone
     */
    public String getContactPhone () {
        return contactPhone;
    }

    /**
	 * Set the value related to the column: contact_phone
     * @param contactPhone the contact_phone value
     */
    public void setContactPhone (String contactPhone) {
        this.contactPhone = contactPhone;
    }

    /**
	 * Return the value associated with the column: local
     */
    public boolean isLocal () {
        return local;
    }

    /**
	 * Set the value related to the column: local
     * @param local the local value
     */
    public void setLocal (boolean local) {
        this.local = local;
    }

    /**
	 * Return the value associated with the column: integrator_enabled
     */
    public boolean isIntegratorEnabled () {
        return integratorEnabled;
    }

    /**
	 * Set the value related to the column: integrator_enabled
     * @param integratorEnabled the integrator_enabled value
     */
    public void setIntegratorEnabled (boolean integratorEnabled) {
        this.integratorEnabled = integratorEnabled;
    }

    /**
	 * Return the value associated with the column: integrator_url
     */
    public String getIntegratorUrl () {
        return integratorUrl;
    }

    /**
	 * Set the value related to the column: integrator_url
     * @param integratorUrl the integrator_url value
     */
    public void setIntegratorUrl (String integratorUrl) {
        this.integratorUrl = integratorUrl;
    }

    /**
	 * Return the value associated with the column: integrator_jms
     */
    public String getIntegratorJms () {
        return integratorJms;
    }

    /**
	 * Set the value related to the column: integrator_jms
     * @param integratorJms the integrator_jms value
     */
    public void setIntegratorJms (String integratorJms) {
        this.integratorJms = integratorJms;
    }

    /**
	 * Return the value associated with the column: integrator_username
     */
    public String getIntegratorUsername () {
        return integratorUsername;
    }

    /**
	 * Set the value related to the column: integrator_username
     * @param integratorUsername the integrator_username value
     */
    public void setIntegratorUsername (String integratorUsername) {
        this.integratorUsername = integratorUsername;
    }

    /**
	 * Return the value associated with the column: integrator_password
     */
    public String getIntegratorPassword () {
        return integratorPassword;
    }

    /**
	 * Set the value related to the column: integrator_password
     * @param integratorPassword the integrator_password value
     */
    public void setIntegratorPassword (String integratorPassword) {
        this.integratorPassword = integratorPassword;
    }

    /**
	 * Return the value associated with the column: hic
     */
    public boolean isHic () {
        return hic;
    }

    /**
	 * Set the value related to the column: hic
     * @param hic the hic value
     */
    public void setHic (boolean hic) {
        this.hic = hic;
    }

    public boolean isDisabled() {
        return disabled;
    }

    public void setDisabled(boolean disabled) {
        this.disabled = disabled;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Agency agency = (Agency) o;

        if (id != null ? !id.equals(agency.id) : agency.id != null) return false;

        return true;
    }

    public int hashCode() {
        return (id != null ? id.hashCode() : 0);
    }

    public String toString () {
        return super.toString();
    }
}