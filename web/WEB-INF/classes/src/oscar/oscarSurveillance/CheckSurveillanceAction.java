/*
 * 
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
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
 * Jason Gallagher
 * 
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster University 
 * Hamilton 
 * Ontario, Canada 
 */ 


/*
 * checkSurveillanceAction.java
 *
 * Created on September 10, 2004, 11:37 AM
 */

package oscar.oscarSurveillance;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;


/**
 *
 * @author  Jay Gallagher
 */
public class CheckSurveillanceAction extends Action {
   private static Log log = LogFactory.getLog(CheckSurveillanceAction.class);
   
   /** Creates a new instance of checkSurveillanceAction */
   public CheckSurveillanceAction() {
   }
   
  
   public ActionForward execute(ActionMapping mapping,
				ActionForm form,
				HttpServletRequest request,
				HttpServletResponse response) throws IOException, ServletException {
      
                             
      long startTime = System.currentTimeMillis();                                   
      CheckSurveillanceForm frm = (CheckSurveillanceForm) form;
         
      ActionForward forward = mapping.findForward("close");
      String proceed = frm.getProceed();
      String forwardPath = null;
      if (proceed != null && !proceed.trim().equals("")){
         String proceedURL = URLDecoder.decode(proceed, "UTF-8");
         forward = new ActionForward();
            forward.setPath(proceedURL);
            forward.setRedirect(true);
            forwardPath = forward.getPath();
      }                                      
      SurveillanceMaster sMaster = SurveillanceMaster.getInstance();
      log.debug("Number of surveys "+sMaster.numSurveys());
      if(!sMaster.surveysEmpty()){              
         ArrayList surveys = sMaster.getCurrentSurveys();
      
         String demographic_no = frm.getDemographicNo();
         if (demographic_no == null){
             demographic_no = (String) request.getAttribute("demoNo");
         }
         
         log.debug("getting demog num "+demographic_no);
         String provider_no = (String) request.getSession().getAttribute("user");
         int i = 0;
         if ( request.getAttribute("currentSurveyNum") != null ){
            i = Integer.parseInt( ((String) request.getAttribute("currentSurveyNum")) );
            //log.debug("survey starting from "+i);
         }
         
         for (    ;  i < surveys.size() ; i++){
            Survey survey = (Survey) surveys.get(i);
            request.setAttribute("survey", survey);
            request.setAttribute("proceedURL", proceed);
            request.setAttribute("demographic_no", demographic_no);            

            if (survey.isInSurvey(demographic_no,provider_no)){
               forward = mapping.findForward("survey");
               request.setAttribute("currSurveyNum", new Integer(i+ 1));
               i = surveys.size();
            }                     
         }
      }           
      long endTime = System.currentTimeMillis();
      log.debug("Surveillance took "+ (endTime - startTime) +" milli-seconds forwarding to: "+forwardPath);
      
      return forward;                                
   }
   
   
   
}