/*
* 
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

import org.apache.commons.lang.builder.ToStringBuilder;

import java.io.Serializable;

public class BedType implements Serializable {

    private static final long serialVersionUID = 1L;
    public static String REF = "BedType";
    public static String PROP_DEFAULT = "default";
    public static String PROP_NAME = "name";
    public static String PROP_ID = "id";
    private int hashCode = Integer.MIN_VALUE;// primary key
    private Integer id;// fields
    private String name;
    private boolean m_default;

    // constructors
    public BedType () {
        initialize();
    }

    /**
     * Constructor for primary key
     */
    public BedType (java.lang.Integer id) {
        this.setId(id);
        initialize();
    }

    /**
     * Constructor for required fields
     */
    public BedType (
            java.lang.Integer id,
            java.lang.String name,
            boolean m_default) {

        this.setId(id);
        this.setName(name);
        this.setDefault(m_default);
        initialize();
    }


    /* [CONSTRUCTOR MARKER END] */

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

    protected void initialize () {}

    /**
     * Return the unique identifier of this class
     * @hibernate.id
     *  generator-class="native"
     *  column="bed_type_id"
     */
    public Integer getId () {
        return id;
    }

    /**
     * Set the unique identifier of this class
     * @param id the new ID
     */
    public void setId (Integer id) {
        this.id = id;
        this.hashCode = Integer.MIN_VALUE;
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
     * Return the value associated with the column: dflt
     */
    public boolean isDefault () {
        return m_default;
    }

    /**
     * Set the value related to the column: dflt
     * @param m_default the dflt value
     */
    public void setDefault (boolean m_default) {
        this.m_default = m_default;
    }

    public boolean equals (Object obj) {
        if (null == obj) return false;
        if (!(obj instanceof BedType)) return false;
        else {
            BedType bedType = (BedType) obj;
            if (null == this.getId() || null == bedType.getId()) return false;
            else return (this.getId().equals(bedType.getId()));
        }
    }

    public int hashCode () {
        if (Integer.MIN_VALUE == this.hashCode) {
            if (null == this.getId()) return super.hashCode();
            else {
                String hashStr = this.getClass().getName() + ":" + this.getId().hashCode();
                this.hashCode = hashStr.hashCode();
            }
        }
        return this.hashCode;
    }
}