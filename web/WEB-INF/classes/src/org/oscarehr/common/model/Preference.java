package org.oscarehr.common.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PreRemove;
import javax.persistence.Table;


/**
 * This entity represents every time a provider fills out or updates a OCAN form.
 * Note that every row / entry represents a change, so as an example if 
 * one provider answers the first 4 questions, then saves it. It will make a entry.
 * If another provider then updates it to answer another 2 questions, this should
 * make a 2nd row. This allows us to track who changed what on the form and when. 
 * As a result, these entities are non delete/update able, the expectation is to
 * make a new entity instead of updating an existing one.
 */
@Entity
@Table(name="preference")

public class Preference extends AbstractModel<Integer> implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer preference_no;
 
	private String provider_no=null;
	private String start_hour=null;	
	private String end_hour = null;
	private String every_min = null;
	private String mygroup_no=null;
	private String color_template=null;
	private String new_tickler_warning_window=null;
	private String default_servicetype=null;
	private String default_caisi_pmm=null;
	private String default_new_oscar_cme=null;
	private boolean defaultDoNotDeleteBilling=false;
	private String defaultDxCode=null;
	
	
	public Preference() {		
	}
	
	@Override
	public Integer getId() {		
		return preference_no;
	}
	
	public Integer getPreference_no() {
		return preference_no;
	}


	public void setPreference_no(Integer preference_no) {
		this.preference_no = preference_no;
	}


	public String getProvider_no() {
		return provider_no;
	}


	public void setProvider_no(String provider_no) {
		this.provider_no = provider_no;
	}


	public String getStart_hour() {
		return start_hour;
	}


	public void setStart_hour(String start_hour) {
		this.start_hour = start_hour;
	}


	public String getEnd_hour() {
		return end_hour;
	}


	public void setEnd_hour(String end_hour) {
		this.end_hour = end_hour;
	}


	public String getEvery_min() {
		return every_min;
	}


	public void setEvery_min(String every_min) {
		this.every_min = every_min;
	}


	public String getMygroup_no() {
		return mygroup_no;
	}


	public void setMygroup_no(String mygroup_no) {
		this.mygroup_no = mygroup_no;
	}


	public String getColor_template() {
		return color_template;
	}


	public void setColor_template(String color_template) {
		this.color_template = color_template;
	}


	public String getNew_tickler_warning_window() {
		return new_tickler_warning_window;
	}


	public void setNew_tickler_warning_window(String new_tickler_warning_window) {
		this.new_tickler_warning_window = new_tickler_warning_window;
	}


	public String getDefault_servicetype() {
		return default_servicetype;
	}


	public void setDefault_servicetype(String default_servicetype) {
		this.default_servicetype = default_servicetype;
	}


	public String getDefault_caisi_pmm() {
		return default_caisi_pmm;
	}


	public void setDefault_caisi_pmm(String default_caisi_pmm) {
		this.default_caisi_pmm = default_caisi_pmm;
	}


	public String getDefault_new_oscar_cme() {
		return default_new_oscar_cme;
	}


	public void setDefault_new_oscar_cme(String default_new_oscar_cme) {
		this.default_new_oscar_cme = default_new_oscar_cme;
	}


	public boolean isDefaultDoNotDeleteBilling() {
		return defaultDoNotDeleteBilling;
	}


	public void setDefaultDoNotDeleteBilling(boolean defaultDoNotDeleteBilling) {
		this.defaultDoNotDeleteBilling = defaultDoNotDeleteBilling;
	}


	public String getDefaultDxCode() {
		return defaultDxCode;
	}


	public void setDefaultDxCode(String defaultDxCode) {
		this.defaultDxCode = defaultDxCode;
	}


	public boolean equals(Preference o) {
		try {
			return (preference_no != null && preference_no.intValue() == o.preference_no.intValue());
		} catch (Exception e) {
			return (false);
		}
	}

	public int hashCode() {
		return (preference_no != null ? preference_no.hashCode() : 0);
	}
	
	@PreRemove
	protected void jpaPreventDelete()
	{
		throw(new UnsupportedOperationException("Remove is not allowed for this type of item."));
	}
/*
	@PreUpdate
	protected void jpaPreventUpdate()
	{
		throw(new UnsupportedOperationException("Update is not allowed for this type of item."));
	}
*/


	
	
}
