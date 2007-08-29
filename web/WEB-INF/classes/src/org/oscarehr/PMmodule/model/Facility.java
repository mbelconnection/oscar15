package org.oscarehr.PMmodule.model;

import java.io.Serializable;

/**
 * Represents a facility, i.e. bricks and mortar.  Each facility has a number of rooms.
 */
public class Facility implements Serializable {
    private Integer id;
    private Integer agencyId;
    private String name;
    private String description;
    private boolean disabled;

    public Facility() {
    }

    public Facility(Integer agencyId, String name, String description) {
        this.agencyId = agencyId;
        this.name = name;
        this.description = description;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getAgencyId() {
        return agencyId;
    }

    public void setAgencyId(Integer agencyId) {
        this.agencyId = agencyId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

        Facility facility = (Facility) o;

        if (id != null ? !id.equals(facility.id) : facility.id != null) return false;

        return true;
    }

    public int hashCode() {
        return (id != null ? id.hashCode() : 0);
    }
}
