/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.oscarehr.decisionSupport.model.impl.drools;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.drools.FactException;
import org.drools.RuleBase;
import org.drools.WorkingMemory;
import org.jdom.Element;
import org.jdom.Namespace;
import org.oscarehr.decisionSupport.model.DSCondition;
import org.oscarehr.decisionSupport.model.DSConsequence;
import org.oscarehr.decisionSupport.model.DSDemographicAccess;
import org.oscarehr.decisionSupport.model.DSGuideline;
import org.oscarehr.decisionSupport.model.DSParameter;
import org.oscarehr.decisionSupport.model.DecisionSupportException;
import org.oscarehr.util.MiscUtils;

import oscar.oscarEncounter.oscarMeasurements.util.RuleBaseCreator;


/**
 *
 * @author apavel
 */
public class DSGuidelineDrools extends DSGuideline {
    private static final Logger log=MiscUtils.getLogger();
    
    Namespace namespace = Namespace.getNamespace("http://drools.org/rules");
    Namespace javaNamespace = Namespace.getNamespace("java", "http://drools.org/semantics/java");
    Namespace xsNs = Namespace.getNamespace("xs", "http://www.w3.org/2001/XMLSchema-instance");
    
    
    private final String demographicAccessObjectClassPath =  "org.oscarehr.decisionSupport.model.DSDemographicAccess";


    private RuleBase _ruleBase = null;

    public List<DSConsequence> evaluate(String demographicNo) throws DecisionSupportException {
        if (_ruleBase == null)
            generateRuleBase();
        //at this point _ruleBase WILL be set or exception is thrown in generateRuleBase()
        WorkingMemory workingMemory = _ruleBase.newWorkingMemory( );
        DSDemographicAccess dsDemographicAccess = new DSDemographicAccess(demographicNo);
        //put "bob" in working memory
        try {





            workingMemory.assertObject(dsDemographicAccess);

            for(DSCondition dsc :this.getConditions()){
                if (dsc.getParam() != null && !dsc.getParam().isEmpty()){
                    log.debug("PARAM:"+dsc.getParam().toString());
                    workingMemory.assertObject(dsc.getParam());
                }
            }

            List<DSParameter> lDSP = this.getParameters();
            if (lDSP != null){
	            for( DSParameter dsp: lDSP ) {
	                Class clas = Class.forName(dsp.getStrClass());
	                Constructor constructor = clas.getConstructor();
	                Object obj = constructor.newInstance();
	
	                workingMemory.assertObject(obj);
	            }
            }

            workingMemory.fireAllRules();
            if (dsDemographicAccess.isPassedGuideline()) {
                List<DSConsequence> returnDsConsequences = new ArrayList();
                if (this.getConsequences() == null) return returnDsConsequences;
                else {
                    for (DSConsequence dsConsequence: this.getConsequences()) {
                        if (dsConsequence.getConsequenceType() != DSConsequence.ConsequenceType.java) {
                            returnDsConsequences.add(dsConsequence);
                    }
                        else if( dsConsequence.getConsequenceType() == DSConsequence.ConsequenceType.java ) {
                            List<Object> javaConsequences = workingMemory.getObjects();
                            dsConsequence.setObjConsequence(javaConsequences);
                            returnDsConsequences.add(dsConsequence);
                        }
                    }
                    return returnDsConsequences;
                }
            } else {
                return null;
            }
        } catch (FactException factException) {
            throw new DecisionSupportException("Unable to assert guideline", factException);
        } catch( ClassNotFoundException e ) {
            throw new DecisionSupportException("Unable to instantiate class", e);
        } catch( NoSuchMethodException e ) {
            throw new DecisionSupportException("Unable to instantiate class", e);
        } catch( InstantiationException e ) {
            throw new DecisionSupportException("Unable to instantiate class", e);
        } catch( IllegalAccessException e ) {
            throw new DecisionSupportException("Unable to instantiate class", e);
        } catch( InvocationTargetException e ) {
            throw new DecisionSupportException("Unable to instantiate class", e);
        }
    }

    public void generateRuleBase() throws DecisionSupportException {
        ArrayList<Element> rules = new ArrayList();
        ArrayList<Element> conditionElements = new ArrayList();
        ArrayList<Element> lParameterElements = new ArrayList();
        
        if(this.getParameters() != null){
	        for( DSParameter dsParameter: this.getParameters()) {
	            Element parameterElement = this.getDroolsParameter(dsParameter);
	            lParameterElements.add(parameterElement);
	        }
        }
        int paramCount=0;
       
        for (DSCondition condition: this.getConditions()) {
            if (condition.getParam() != null && !condition.getParam().isEmpty()){
                condition.setLabel("param"+paramCount);
                paramCount++;
            }
            Element conditionElement = getDroolsCondition(condition);
            conditionElements.add(conditionElement);
        }

        Element consequencesElement = this.getDroolsConsequences(this.getConsequences());

        rules.add(this.getRule(conditionElements, lParameterElements, consequencesElement));
        
        RuleBaseCreator ruleBaseCreator = new RuleBaseCreator();
        try {
            
            _ruleBase = ruleBaseCreator.getRuleBase(this.getTitle(), rules);
        } catch (Exception e) {
            throw new DecisionSupportException("Could not create a rule base for guideline '" + this.getTitle() + "'", e);
        }
    }

    private Element getRule(List<Element> conditionElements, List<Element> parameterElements, Element consequenceElement) {
        Element ruleElement = new Element("rule", namespace);
        ruleElement.setAttribute("name", this.getTitle());

        Element accessClassParameter = new Element("parameter", namespace);
        accessClassParameter.setAttribute("identifier", "a");
        Element accessClass = new Element("class", namespace);
        accessClass.addContent(demographicAccessObjectClassPath);
        accessClassParameter.addContent(accessClass);
        ruleElement.addContent(accessClassParameter);

        ruleElement.addContent(parameterElements);

        for (DSCondition condition: this.getConditions()) {
            if (condition.getParam() != null && !condition.getParam().isEmpty()){
                Element paramsHashEle = new Element("parameter", namespace);
                paramsHashEle.setAttribute("identifier", condition.getLabel());
                Element paramClass = new Element("class", namespace);
                paramClass.addContent("java.util.Hashtable");
                paramsHashEle.addContent(paramClass);
                ruleElement.addContent(paramsHashEle);
            }
        }

        ruleElement.addContent(conditionElements);
        ruleElement.addContent(consequenceElement);
        return ruleElement;
    }

    private Element getRule(List<Element> conditionElements, Element consequenceElement) {
        Element ruleElement = new Element("rule", namespace);
        ruleElement.setAttribute("name", this.getTitle());

        Element accessClassParameter = new Element("parameter", namespace);
        accessClassParameter.setAttribute("identifier", "a");
        Element accessClass = new Element("class", namespace);
        accessClass.addContent(demographicAccessObjectClassPath);
        accessClassParameter.addContent(accessClass);
        ruleElement.addContent(accessClassParameter);

        
        for (DSCondition condition: this.getConditions()) {
            if (condition.getParam() != null && !condition.getParam().isEmpty()){
                Element paramsHashEle = new Element("parameter", namespace);
                paramsHashEle.setAttribute("identifier", condition.getLabel());
                Element paramClass = new Element("class", namespace);
                paramClass.addContent("java.util.Hashtable");
                paramsHashEle.addContent(paramClass);
                ruleElement.addContent(paramsHashEle);   
            }
        }

        ruleElement.addContent(conditionElements);
        ruleElement.addContent(consequenceElement);
        return ruleElement;
    }

    private Element getRule(Element conditionElement, Element consequenceElement) {
        List<Element> conditionElements = new ArrayList();
        conditionElements.add(conditionElement);
        return getRule(conditionElements, consequenceElement);
    }
    
    //multiple conditions because to handle OR statements, need to have multiple 
    public Element getDroolsCondition(DSCondition condition) throws DecisionSupportException {
        String accessMethod = condition.getConditionType().getAccessMethod();
        Element javaCondition = new Element("condition", javaNamespace);
        String parameters = "\"" + StringUtils.join(condition.getValues(), ",") + "\"";
        accessMethod = accessMethod + StringUtils.capitalize(condition.getListOperator().name());
        String functionStr = "a." + accessMethod + "(" + parameters; // + ")";
        if( condition.getParam() != null && !condition.getParam().isEmpty()){
            //functionStr += ",\"" +condition.getParam().toString()+"\"";
            functionStr += ","+condition.getLabel();
        }
        functionStr += ")";

        javaCondition.addContent(functionStr);
        return javaCondition;
    }

    public Element getDroolsParameter(DSParameter dsParameter) throws DecisionSupportException {
        Element accessClassParameter = new Element("parameter", namespace);
        accessClassParameter.setAttribute("identifier", dsParameter.getStrAlias());
        Element accessClass = new Element("class", namespace);
        accessClass.addContent(dsParameter.getStrClass());
        accessClassParameter.addContent(accessClass);

        return accessClassParameter;
    }

    public Element getDroolsConsequences(List<DSConsequence> consequences) throws DecisionSupportException {
        Element javaElement = new Element("consequence", javaNamespace);
        String consequencesStr = "a.setPassedGuideline(true);";
        for (DSConsequence consequence: consequences) {
            if (consequence.getConsequenceType() == DSConsequence.ConsequenceType.java) {
                consequencesStr = consequencesStr + "\n" + consequence.getText();
            }
        }
        javaElement.addContent(consequencesStr);
        return javaElement;
    }

}