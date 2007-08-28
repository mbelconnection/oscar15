package org.oscarehr.PMmodule.web.admin;

import org.apache.struts.action.ActionForm;
import org.oscarehr.PMmodule.model.Agency;

import java.util.List;

/**
 */
public class MultiAgencyManagerForm extends ActionForm {
    private Agency agency;

    public Agency getAgency() {
        return agency;
    }

    public void setAgency(Agency agency) {
        this.agency = agency;
    }
}
