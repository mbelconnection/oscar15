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
 * <OSCAR TEAM>
 *
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */
package oscar.oscarRx.pageUtil;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.http.HttpSession;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.MessageResources;

import org.oscarehr.casemgmt.model.CaseManagementNote;
import org.oscarehr.casemgmt.model.CaseManagementNoteLink;
import org.oscarehr.casemgmt.service.CaseManagementManager;
import org.oscarehr.common.dao.DrugDao;
import org.oscarehr.common.model.Drug;
import org.oscarehr.util.SpringUtils;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import oscar.dms.EDocUtil;
import oscar.log.LogAction;
import oscar.log.LogConst;
import oscar.oscarEncounter.data.EctProgram;


public final class RxDeleteRxAction extends DispatchAction {
    private DrugDao drugDao = (DrugDao) SpringUtils.getBean("drugDao");


    @Override
    public ActionForward unspecified(ActionMapping mapping,
    ActionForm form,
    HttpServletRequest request,
    HttpServletResponse response)
    throws IOException, ServletException {

      //  System.out.println("===========================RxDeleteRxAction========================");
        // Extract attributes we will need
        Locale locale = getLocale(request);
        MessageResources messages = getResources(request);
        // Setup variables
        RxSessionBean bean =(RxSessionBean)request.getSession().getAttribute("RxSessionBean");
        if(bean==null) {
            response.sendRedirect("error.html");
            return null;
        }
        String ip = request.getRemoteAddr();
        try {


            String drugList = ((RxDrugListForm)form).getDrugList();
       //     System.out.println("drugList="+drugList);
            String[] drugArr = drugList.split(",");
            int drugId;
            int i;

            for(i=0;i<drugArr.length;i++) {
                try {
                    drugId = Integer.parseInt(drugArr[i]);
               //     System.out.println("drugId="+drugId);
                } catch (Exception e) { break; }
                // get original drug
                Drug drug = drugDao.find(drugId);
                setDrugDelete(drug);
                drugDao.merge(drug);
                LogAction.addLog((String) request.getSession().getAttribute("user"), LogConst.DELETE, LogConst.CON_PRESCRIPTION, drugArr[i], ip,""+bean.getDemographicNo(), drug.getAuditString());
            }
        }
        catch (Exception e) {
            e.printStackTrace(System.out);
        }
           //   System.out.println("===========================END RxDeleteRxAction========================");
         return (mapping.findForward("success"));
    }

    private void setDrugDelete(Drug drug){
        drug.setArchived(true);
        drug.setArchivedDate(new Date());
        drug.setArchivedReason(Drug.DELETED);
    }

    public ActionForward Delete2(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response)
    throws IOException, ServletException {

        System.out.println("===========================Delete2 RxDeleteRxAction========================");
        // Extract attributes we will need
        Locale locale = getLocale(request);
        MessageResources messages = getResources(request);
        // Setup variables
        RxSessionBean bean = (RxSessionBean)request.getSession().getAttribute("RxSessionBean");
        if(bean==null) {
            response.sendRedirect("error.html");
            return null;
        }
        String ip = request.getRemoteAddr();
        try{
            String deleteRxId=(request.getParameter("deleteRxId").split("_"))[1];
         //   System.out.println("drugId="+ deleteRxId);
            Drug drug = drugDao.find(Integer.parseInt(deleteRxId));
            setDrugDelete(drug);
            drugDao.merge(drug);
            LogAction.addLog((String) request.getSession().getAttribute("user"), LogConst.DELETE, LogConst.CON_PRESCRIPTION, deleteRxId, ip,""+bean.getDemographicNo(), drug.getAuditString());
        }
        catch (Exception e) {
            e.printStackTrace();
        }
              System.out.println("===========================END Delete2 RxDeleteRxAction========================");
         return null;
    }
    public ActionForward DeleteRxOnCloseRxBox(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response)
    throws IOException, ServletException {

        System.out.println("===========================DeleteRxOnCloseRxBox RxDeleteRxAction========================");
        String randomId=request.getParameter("randomId");


        // Setup variables
        RxSessionBean bean = (RxSessionBean)request.getSession().getAttribute("RxSessionBean");
        if(bean==null) {
            response.sendRedirect("error.html");
            return null;
        }
       if(randomId!=null){
            HashMap rd=bean.getRandomIdDrugIdPair();
            Integer drugId=(Integer)rd.get(Long.parseLong(randomId));
            System.out.println("111drugId="+drugId+"--randomId="+randomId);
            if(drugId!=null){
                String ip = request.getRemoteAddr();
                try{                    
                    Drug drug = drugDao.find(drugId);
                    setDrugDelete(drug);
                    drugDao.merge(drug);
                    LogAction.addLog((String) request.getSession().getAttribute("user"), LogConst.DELETE, LogConst.CON_PRESCRIPTION, drugId.toString(), ip,""+bean.getDemographicNo(), drug.getAuditString());
                }
                catch (Exception e) {
                    e.printStackTrace();
                }
            }
            HashMap hm = new HashMap();
            hm.put("drugId", drugId);
            JSONObject jsonObject = JSONObject.fromObject(hm);
            System.out.println("jsonObject="+ jsonObject.toString());
            response.getOutputStream().write(jsonObject.toString().getBytes());
       }
        System.out.println("===========================END DeleteRxOnCloseRxBox RxDeleteRxAction========================");
         return null;
    }
public ActionForward clearStash(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response)
    throws IOException, ServletException {
        RxSessionBean bean = (RxSessionBean)request.getSession().getAttribute("RxSessionBean");
        if(bean==null) {
            response.sendRedirect("error.html");
            return null;
        }
        bean.clearStash();
        return mapping.findForward("successClearStash");
    }

   public ActionForward clearReRxDrugList(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response)
    throws IOException, ServletException {
        RxSessionBean bean = (RxSessionBean)request.getSession().getAttribute("RxSessionBean");
        if(bean==null) {
            response.sendRedirect("error.html");
            return null;
        }
        bean.clearReRxDrugIdList();
        //return mapping.findForward("successClearStash");
        return null;
    }

    /**
     * The action to discontinue a drug.
     *
     * first set discontinued boolean field to true.
     * Grab the end_date and log that this provider is changing (discontinuing) the drug and the old end date is this and the new end date is this.
     * set end_date = today
     * set reason
     * set annotation if needed.
     *
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws IOException
     * @throws ServletException
     */
    //STILL NEED TO SAVE REASON AND COMMENT "would like to create a summary note in the echart"
    public ActionForward Discontinue(ActionMapping mapping,ActionForm form,HttpServletRequest request,HttpServletResponse response)throws IOException, ServletException {
        String idStr = request.getParameter("drugId");
        int id = Integer.parseInt(idStr);

        String reason = request.getParameter("reason");
        //String comment = request.getParameter("comment"); //TODO: PUT this in a note

        String ip = request.getRemoteAddr();

        Drug drug = drugDao.find(id);

        Date date = new Date();
        String logStatement = drug+" Changing end date to :"+date;
        drug.setArchivedDate(date);
        //drug.setEndDate(drug.getArchivedDate());
        drug.setArchived(true);
        drug.setArchivedReason(reason);
        //System.out.println("");
        drugDao.merge(drug);
      /*  Enumeration em=request.getParameterNames();
        while(em.hasMoreElements()){
            String s=em.nextElement().toString();
            System.out.println("request.parameterName="+s);
            System.out.println("value="+request.getParameter(s));
        }
        em=request.getAttributeNames();
        while(em.hasMoreElements()){
            String s=em.nextElement().toString();
            System.out.println("request.attributeName="+s);
            System.out.println("value="+request.getAttribute(s));
        }
        em=request.getSession().getAttributeNames();
        while(em.hasMoreElements()){
            String s=em.nextElement().toString();
            System.out.println("request.attributeName in session="+s);
            System.out.println("value="+request.getSession().getAttribute(s));
        }*/
        try{
            createDiscontinueNote(request);
        }catch(Exception e){
            e.printStackTrace();
        }

        LogAction.addLog((String) request.getSession().getAttribute("user"), LogConst.DISCONTINUE, LogConst.CON_PRESCRIPTION,""+drug.getId(), ip,""+drug.getDemographicId(),logStatement);

        Hashtable d = new Hashtable();
        d.put("id",""+id);
        d.put("reason",reason);
        response.setContentType("text/x-json");
        JSONObject jsonArray = (JSONObject) JSONSerializer.toJSON( d );
        jsonArray.write(response.getWriter());

        return null;
    }

    private void createDiscontinueNote(HttpServletRequest request){
         //create a note and store this info in casemanagement_note table
        //note_id,update_date,observation_date,demographic_no,provider_no,note: ,signed,include_issue_innote,archived,position, uuid
        //signing_provider_no,encounter_type:  billing_code:  program_no,reporter_caisi_role,reporter_program_team,history, password, locked
        CaseManagementNote cmn=new CaseManagementNote();
        //get parameter values
        Date now=EDocUtil.getDmsDateTimeAsDate();
        String demoNo=request.getParameter("demoNo");
        String idStr = request.getParameter("drugId");
        String user=request.getSession().getAttribute("user").toString();
        String strNote=request.getParameter("drugSpecial")+"\nDiscontinued reason: "+request.getParameter("reason")+ "\nDiscontinued comment: "+request.getParameter("comment") ;
        HttpSession se = request.getSession();
        String prog_no = new EctProgram(se).getProgram(user);

        //set parameter values
        cmn.setUpdate_date(now);
        cmn.setObservation_date(now);
        cmn.setDemographic_no(demoNo);
        cmn.setProviderNo(user);
        cmn.setNote(strNote);
        cmn.setSigned(true);
        cmn.setSigning_provider_no(user);
        cmn.setProgram_no(prog_no);
        cmn.setReporter_caisi_role("1");//1 for doctor, 2 for nurse
        cmn.setReporter_program_team("0");
        cmn.setPassword("NULL");
        cmn.setLocked(false);
        cmn.setHistory(strNote);
        //cmn.setPosition(0);
        //save note
        WebApplicationContext  ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(se.getServletContext());
        CaseManagementManager cmm = (CaseManagementManager) ctx.getBean("caseManagementManager");
        cmm.saveNoteSimple(cmn);

        //create an entry in casemgmt note link
        CaseManagementNoteLink cmnl=new CaseManagementNoteLink();
        cmnl.setTableName(cmnl.DRUGS);
        cmnl.setTableId(Long.parseLong(idStr));//drug id
        cmnl.setNoteId(Long.parseLong(EDocUtil.getLastNoteId()));
      //  System.out.println("ValuesSavedInCaseManagementNoteLink: ");
      //  System.out.println(" last note id="+EDocUtil.getLastNoteId());
        EDocUtil.addCaseMgmtNoteLink(cmnl);
    }

}