/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.oscarehr.decisionSupport.model;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.JDOMException;

/**
 *
 * @author apavel
 */
public abstract class DSGuideline {
    /*
    enum Status {
        ACTIVE('A'),
        INACTIVE('I'),
        FAILED('F');
        
        private char statusChar;
        private Status(char statusChar) { this.statusChar = statusChar; }
        private char getStatusChar() { return this.statusChar; }
    }*/

    protected static Log _log = LogFactory.getLog(DSGuideline.class);
    protected int id;
    protected String uuid;
    protected Integer version;
    protected String author;
    protected String xml;
    protected String source;
    protected String engine;
    protected Date dateStart;
    protected Date dateDecomissioned;
    protected char status;
    

    //following are populated by parsing
    private String title;
    private List<DSCondition> conditions;
    private List<DSConsequence> consequences;
    private boolean parsed = false;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public List<DSCondition> getConditions() {
        if (!parsed) this.tryParseFromXml();
        return conditions;
    }

    public void setConditions(List<DSCondition> conditions) {
        this.conditions = conditions;
    }

    public List<DSConsequence> getConsequences() {
        if (!parsed) this.tryParseFromXml();
        return consequences;
    }

    public void setConsequences(List<DSConsequence> consequences) {
        this.consequences = consequences;
    }

    public abstract List<DSConsequence> evaluate(String demographicNo) throws DecisionSupportException;

    public boolean evaluateBoolean(String demographicNo) throws DecisionSupportException {
        if (evaluate(demographicNo) == null) return false;
        return true;
    }

    private void tryParseFromXml() {
        try {
            this.parseFromXml();
        } catch (Exception e) {
            _log.error("Could not parse xml for guideline", e);
        }
    }

    //generally done automatically
    public void parseFromXml() throws JDOMException, DecisionSupportParseException, IOException {
        DSGuidelineFactory factory = new DSGuidelineFactory();
        DSGuideline newGuideline = factory.createGuidelineFromXml(getXml());
        setParsed(true);
        //copy over
        this.title = newGuideline.getTitle();
        this.conditions = newGuideline.getConditions();
        this.consequences = newGuideline.getConsequences();
        
    }

    public boolean isParsed() {
        return parsed;
    }

    public void setParsed(boolean parsed) {
        this.parsed = parsed;
    }

    /**
     * @return the id
     */
    public int getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * @return the uuid
     */
    public String getUuid() {
        return uuid;
    }

    /**
     * @param uuid the uuid to set
     */
    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the author
     */
    public String getAuthor() {
        return author;
    }

    /**
     * @param author the author to set
     */
    public void setAuthor(String author) {
        this.author = author;
    }

    /**
     * @return the xml
     */
    public String getXml() {
        return xml;
    }

    /**
     * @param xml the xml to set
     */
    public void setXml(String xml) {
        this.xml = xml;
    }

    /**
     * @return the source
     */
    public String getSource() {
        return source;
    }

    /**
     * @param source the source to set
     */
    public void setSource(String source) {
        this.source = source;
    }

    /**
     * @return the engine
     */
    public String getEngine() {
        return engine;
    }

    /**
     * @param engine the engine to set
     */
    public void setEngine(String engine) {
        this.engine = engine;
    }

    /**
     * @return the dateStart
     */
    public Date getDateStart() {
        return dateStart;
    }

    /**
     * @param dateStart the dateStart to set
     */
    public void setDateStart(Date dateStart) {
        this.dateStart = dateStart;
    }

    /**
     * @return the dateDecomissioned
     */
    public Date getDateDecomissioned() {
        return dateDecomissioned;
    }

    /**
     * @param dateDecomissioned the dateDecomissioned to set
     */
    public void setDateDecomissioned(Date dateDecomissioned) {
        this.dateDecomissioned = dateDecomissioned;
    }

    /**
     * @return the status
     */
    public char getStatus() {
        return status;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(char status) {
        this.status = status;
    }


}