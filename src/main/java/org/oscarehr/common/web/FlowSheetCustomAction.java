package org.oscarehr.common.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.oscarehr.common.dao.FlowSheetCustomizerDAO;
import org.oscarehr.common.dao.FlowSheetUserCreatedDao;
import org.oscarehr.common.model.FlowSheetCustomization;
import org.oscarehr.common.model.FlowSheetUserCreated;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;

import oscar.oscarEncounter.oscarMeasurements.FlowSheetItem;
import oscar.oscarEncounter.oscarMeasurements.MeasurementFlowSheet;
import oscar.oscarEncounter.oscarMeasurements.MeasurementTemplateFlowSheetConfig;
import oscar.oscarEncounter.oscarMeasurements.util.Recommendation;
import oscar.oscarEncounter.oscarMeasurements.util.RecommendationCondition;
import oscar.oscarEncounter.oscarMeasurements.util.TargetColour;
import oscar.oscarEncounter.oscarMeasurements.util.TargetCondition;

public class FlowSheetCustomAction extends DispatchAction {
    private static final Logger logger = MiscUtils.getLogger();

    private FlowSheetCustomizerDAO flowSheetCustomizerDAO;
    private FlowSheetUserCreatedDao flowSheetUserCreatedDao = (FlowSheetUserCreatedDao) SpringUtils.getBean("flowSheetUserCreatedDao");

    public void setFlowSheetCustomizerDAO(FlowSheetCustomizerDAO flowSheetCustomizerDAO) {
        this.flowSheetCustomizerDAO = flowSheetCustomizerDAO;
    }

    @Override
    protected ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        logger.debug("AnnotationAction-unspec");
        //return setup(mapping, form, request, response);
        return null;
    }

    public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String flowsheet = request.getParameter("flowsheet");
        String demographicNo = request.getParameter("demographic");

        MeasurementTemplateFlowSheetConfig templateConfig = MeasurementTemplateFlowSheetConfig.getInstance();
        MeasurementFlowSheet mFlowsheet = templateConfig.getFlowSheet(flowsheet);

        if (request.getParameter("measurement") != null) {

            Hashtable<String,String> h = new Hashtable<String,String>();

            h.put("measurement_type", request.getParameter("measurement"));
            h.put("display_name", request.getParameter("display_name"));
            h.put("guideline", request.getParameter("guideline"));
            h.put("graphable", request.getParameter("graphable"));
            h.put("value_name", request.getParameter("value_name"));
            String prevItem = null;
            if (request.getParameter("count") != null) {
                int cou = Integer.parseInt(request.getParameter("count"));
                if (cou != 0) {
                    prevItem = (String) mFlowsheet.getMeasurementList().get(cou);
                }
            }

            @SuppressWarnings("unchecked")
            Enumeration<String> en = request.getParameterNames();

            List<Recommendation> ds = new ArrayList<Recommendation>();
            while (en.hasMoreElements()) {
                String s = en.nextElement();
                if (s.startsWith("monthrange")) {
                    String extrachar = s.replaceAll("monthrange", "").trim();
                    logger.debug("EXTRA CAH " + extrachar);
                    String mRange = request.getParameter("monthrange" + extrachar);
                    String strn = request.getParameter("strength" + extrachar);
                    String dsText = request.getParameter("text" + extrachar);
                    if (!mRange.trim().equals("")){
                       ds.add(new Recommendation("" + h.get("measurement_type"), mRange, strn, dsText));
                    }
                }
            }

            if (h.get("measurement_type") != null) {
                FlowSheetItem item = new FlowSheetItem(h);
                item.setRecommendations(ds);
                Element va = templateConfig.getItemFromObject(item);

                XMLOutputter outp = new XMLOutputter();
                outp.setFormat(Format.getPrettyFormat());

                FlowSheetCustomization cust = new FlowSheetCustomization();
                cust.setAction(FlowSheetCustomization.ADD);
                cust.setPayload(outp.outputString(va));
                cust.setFlowsheet(flowsheet);
                cust.setMeasurement(prevItem);//THIS THE MEASUREMENT TO SET THIS AFTER!
                cust.setProviderNo((String) request.getSession().getAttribute("user"));
                if (demographicNo==null){
                	demographicNo = "0";
                			
                }
                cust.setDemographicNo(demographicNo);
                cust.setCreateDate(new Date());
        
                logger.debug("SAVE "+cust);

                flowSheetCustomizerDAO.save(cust);

            }
        }
        request.setAttribute("demographic",demographicNo);
        request.setAttribute("flowsheet", flowsheet);
        return mapping.findForward("success");
    }

    public ActionForward update(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        MeasurementTemplateFlowSheetConfig templateConfig = MeasurementTemplateFlowSheetConfig.getInstance();

        String flowsheet = request.getParameter("flowsheet");
        String demographicNo = request.getParameter("demographic");
        
        logger.debug("UPDATING FOR demographic "+demographicNo);

        if (request.getParameter("updater") != null) {
            Hashtable<String,String> h = new Hashtable<String,String>();
            h.put("measurement_type", request.getParameter("measurement_type"));
            h.put("display_name", request.getParameter("display_name"));
            h.put("guideline", request.getParameter("guideline"));
            h.put("graphable", request.getParameter("graphable"));
            h.put("value_name", request.getParameter("value_name"));

            FlowSheetItem item = new FlowSheetItem(h);
            

            @SuppressWarnings("unchecked")
            Enumeration<String> en = request.getParameterNames();

            List<TargetColour> targets = new ArrayList<TargetColour>();
            List<Recommendation> recommendations = new ArrayList<Recommendation>();
            while (en.hasMoreElements()) {
                String s = en.nextElement();
                if (s.startsWith("strength")) {
                    String extrachar = s.replaceAll("strength", "").trim();
                    logger.debug("EXTRA CAH " + extrachar);
                    boolean go = true;
                    Recommendation rec = new Recommendation();
                    rec.setStrength(request.getParameter(s));
                    int targetCount = 1;
                    rec.setText(request.getParameter("text"+extrachar));
                    List<RecommendationCondition> conds = new ArrayList<RecommendationCondition>();
                    while(go){
                        String type = request.getParameter("type"+extrachar+"c"+targetCount);
                        if (type != null){
                            if (!type.equals("-1")){
                                String param = request.getParameter("param"+extrachar+"c"+targetCount);
                                String value = request.getParameter("value"+extrachar+"c"+targetCount);
                                RecommendationCondition cond = new RecommendationCondition();
                                cond.setType(type);
                                cond.setParam(param);
                                cond.setValue(value);
                                if (value != null && !value.trim().equals("")){
                                   conds.add(cond);
                                }
                            }
                        }else{
                            go = false;
                        }
                        targetCount++;
                    }
                    if (conds.size() > 0){
                        rec.setRecommendationCondition(conds);
                        recommendations.add(rec);
                    }
                    //////
                    /*  Strength:   <select name="strength<%=count%>">                      
                        Text: <input type="text" name="text<%=count%>" length="100"  value="<%=e.getText()%>" />    
                        <select name="type<%=count%>c<%=condCount%>" >   
                        Param: <input type="text" name="param<%=count%>c<%=condCount%>" value="<%=s(cond.getParam())%>" />
                        Value: <input type="text" name="value<%=count%>c<%=condCount%>" value="<%=cond.getValue()%>" />
                    */           
                    //////
                    
                    
                    
                    
                    
                    
//                    String mRange = request.getParameter("monthrange" + extrachar);
//                    String strn = request.getParameter("strength" + extrachar);
//                    String dsText = request.getParameter("text" + extrachar);
//                    if (!mRange.trim().equals("")){
//                       ds.add(new Recommendation("" + h.get("measurement_type"), mRange, strn, dsText));
//                    }
                }else if(s.startsWith("col")){
                    String extrachar = s.replaceAll("col", "").trim();
                    logger.debug("EXTRA CHA "+extrachar);
                    boolean go = true;
                    int targetCount = 1;
                    TargetColour tcolour = new TargetColour();
                    tcolour.setIndicationColor(request.getParameter(s));  
                    List<TargetCondition> conds = new ArrayList<TargetCondition>();
                    while(go){
                        String type = request.getParameter("targettype"+extrachar+"c"+targetCount);
                        if (type != null){
                            if (!type.equals("-1")){
                                String param = request.getParameter("targetparam"+extrachar+"c"+targetCount);
                                String value = request.getParameter("targetvalue"+extrachar+"c"+targetCount);
                                TargetCondition cond = new TargetCondition();
                                cond.setType(type);
                                cond.setParam(param);
                                cond.setValue(value);
                                if(value !=null && !value.trim().equals("")){
                                   conds.add(cond);
                                }
                            }
                        }else{
                            go = false;
                        }
                        targetCount++;
                    }
                    if (conds.size() > 0){
                        tcolour.setTargetConditions(conds);
                        targets.add(tcolour);
                    }
                }
            }
            item.setTargetColour(targets);
            item.setRecommendations(recommendations);
            
            
            
            
            
            //DEALING WITH TARGET DATA//////////
            
          /*                      
            <select name="type<%=targetCount%>c1"> 
               <option value="-1">Not Set</option>
                <option value="getDataAsDouble"       >Number Value</option>
                <option value="isMale"              > Is Male </option>
                <option value="isFemale"            > Is Female </option>
                <option value="getNumberFromSplit"  > Number Split </option>
                <option value="isDataEqualTo"       >  String </option>
           </select>

           Param: <input type="text" name="param<%=targetCount%>c1" value="" />
           Value: <input type="text" name="value<%=targetCount%>c1" value="" />

             */                              
                               
            
            ////////////


            
            Element va = templateConfig.getItemFromObject(item);

            XMLOutputter outp = new XMLOutputter();
            outp.setFormat(Format.getPrettyFormat());

            FlowSheetCustomization cust = new FlowSheetCustomization();
            cust.setAction(FlowSheetCustomization.UPDATE);
            cust.setPayload(outp.outputString(va));
            cust.setFlowsheet(flowsheet);
            if(demographicNo != null ){
               cust.setDemographicNo(demographicNo);
            }
            cust.setMeasurement(item.getItemName());//THIS THE MEASUREMENT TO SET THIS AFTER!
            cust.setProviderNo((String) request.getSession().getAttribute("user"));
            logger.debug("UPDATE "+cust);

            flowSheetCustomizerDAO.save(cust);

        }
        request.setAttribute("demographic",demographicNo);
        request.setAttribute("flowsheet", flowsheet);
        return mapping.findForward("success");
    }

    public ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        logger.debug("IN DELETE");
        String flowsheet = request.getParameter("flowsheet");
        String measurement = request.getParameter("measurement");
        String demographicNo = request.getParameter("demographic");
        
        FlowSheetCustomization cust = new FlowSheetCustomization();

        cust.setAction(FlowSheetCustomization.DELETE);
        cust.setFlowsheet(flowsheet);
        cust.setMeasurement(measurement);
        cust.setProviderNo((String) request.getSession().getAttribute("user"));
        cust.setDemographicNo(demographicNo);

        flowSheetCustomizerDAO.save(cust);
        logger.debug("DELETE "+cust);
        
        request.setAttribute("demographic",demographicNo);
        request.setAttribute("flowsheet", flowsheet);
        return mapping.findForward("success");
    }
    
    public ActionForward archiveMod(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        logger.debug("IN MOD");
        String id = request.getParameter("id");
        
        String flowsheet = request.getParameter("flowsheet");
        String demographicNo = request.getParameter("demographic");
        
        FlowSheetCustomization cust = flowSheetCustomizerDAO.getFlowSheetCustomization(id);
        cust.setArchived(true);
        cust.setArchivedDate(new Date());
        flowSheetCustomizerDAO.save(cust);
        logger.debug("archiveMod "+cust);
        
        request.setAttribute("demographic",demographicNo);
        request.setAttribute("flowsheet", flowsheet);
        return mapping.findForward("success");
    }
    
    
    /*first add it as a flowsheet into the current system.  The save it to the database so that it will be there on reboot */
    public ActionForward createNewFlowSheet(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        logger.debug("IN create new flowsheet");
        //String name let oscar create the name 
    	String dxcodeTriggers 		= request.getParameter("dxcodeTriggers");
    	String displayName 			= request.getParameter("displayName");
    	String warningColour 		= request.getParameter("warningColour");
    	String recommendationColour = request.getParameter("recommendationColour");
    	//String topHTML 				= request.getParameter("topHTML");  // Not supported yet

    	
    	/// NEW FLOWSHEET CODE 
    	MeasurementFlowSheet m = new MeasurementFlowSheet();
        m.parseDxTriggers(dxcodeTriggers);
        m.setDisplayName(displayName);
        m.setWarningColour(warningColour);
        m.setRecommendationColour(recommendationColour);
        
        //Im not sure if adding an initializing measurement is required yet
        /*
        Map<String,String> h = new HashMap<String,String>();
        h.put("measurement_type","WT");
        h.put("display_name","WT");
        h.put("value_name","WT");
        
        FlowSheetItem fsi = new FlowSheetItem( h);
        m.addListItem(fsi);
*/
        MeasurementTemplateFlowSheetConfig templateConfig = MeasurementTemplateFlowSheetConfig.getInstance();
        String name =  templateConfig.addFlowsheet( m );
        m.loadRuleBase();
    	/// END FLOWSHEET CODE
    	
        FlowSheetUserCreated fsuc = new FlowSheetUserCreated();
        fsuc.setName(name);
        fsuc.setDisplayName(displayName);
        fsuc.setDxcodeTriggers(dxcodeTriggers);
        fsuc.setWarningColour(warningColour);
        fsuc.setRecommendationColour(recommendationColour);     
        fsuc.setArchived(false);
        fsuc.setCreatedDate(new Date());
        flowSheetUserCreatedDao.persist(fsuc);
        
        return mapping.findForward("newflowsheet");
    }
    
    
    
    
    
}