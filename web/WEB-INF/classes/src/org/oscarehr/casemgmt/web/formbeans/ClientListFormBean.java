package org.oscarehr.casemgmt.web.formbeans;

import org.apache.struts.action.ActionForm;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 */
public class ClientListFormBean extends ActionForm {

    private String endDate;
    private String admissionDate;
    private Long programId;
    private String programClientStatusId;

    public ClientListFormBean() {
        super();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        this.admissionDate = formatter.format(new Date());
        this.endDate = formatter.format(new Date());
    }

    public String getAdmissionDate() {
        return admissionDate;
    }

    public void setAdmissionDate(String admissionDate) {
        this.admissionDate = admissionDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public Long getProgramId() {
        return programId;
    }

    public void setProgramId(Long programId) {
        this.programId = programId;
    }

    public String getProgramClientStatusId() {
        return programClientStatusId;
    }

    public void setProgramClientStatusId(String programClientStatusId) {
        this.programClientStatusId = programClientStatusId;
    }


}
