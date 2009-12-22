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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.MessageResources;
import org.oscarehr.casemgmt.model.CaseManagementNote;
import org.oscarehr.casemgmt.model.CaseManagementNoteLink;
import org.oscarehr.casemgmt.service.CaseManagementManager;
import org.oscarehr.common.dao.UserPropertyDAO;
import org.oscarehr.common.model.UserProperty;
import org.oscarehr.util.MiscUtils;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import oscar.log.LogAction;
import oscar.log.LogConst;
import oscar.oscarRx.data.RxDrugData;
import oscar.oscarRx.data.RxPrescriptionData;
import oscar.oscarRx.util.RxUtil;

public final class RxWriteScriptAction extends DispatchAction {

    private static final Logger logger = MiscUtils.getLogger();
    private static UserPropertyDAO userPropertyDAO;

    public void p(String s) {
        System.out.println(s);
    }

    public void p(String s, String s1) {
        System.out.println(s + "=" + s1);
    }

    public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException, Exception {
        //    System.out.println("***===========IN unspecified RxWriteScriptAction.java");

        RxWriteScriptForm frm = (RxWriteScriptForm) form;
        String fwd = "refresh";
        oscar.oscarRx.pageUtil.RxSessionBean bean = (oscar.oscarRx.pageUtil.RxSessionBean) request.getSession().getAttribute("RxSessionBean");

        if (bean == null) {
            response.sendRedirect("error.html");
            return null;
        }

        if (frm.getAction().startsWith("update")) {

            RxDrugData drugData = new RxDrugData();
            RxPrescriptionData.Prescription rx = bean.getStashItem(bean.getStashIndex());
            RxPrescriptionData prescription = new RxPrescriptionData();

            if (frm.getGCN_SEQNO() != 0) { // not custom
                if (frm.getBrandName().equals(rx.getBrandName()) == false) {
                    rx.setBrandName(frm.getBrandName());
                } else {
                    rx.setGCN_SEQNO(frm.getGCN_SEQNO());
                }
            } else { // custom
                rx.setBrandName(null);
                rx.setGCN_SEQNO(0);
                rx.setCustomName(frm.getCustomName());
            }
            /*   p("frm.getRxDate()", frm.getRxDate());
            p("frm.getWrittenDate()", frm.getWrittenDate());
            p("frm.getTakeMinFloat()", Float.toString(frm.getTakeMinFloat()));
            p("frm.getTakeMaxFloat()", Float.toString(frm.getTakeMaxFloat()));
            p("frm.getFrequencyCode()", frm.getFrequencyCode());
            p("frm.getDuration()", frm.getDuration());
            p("frm.getRepeat()", Integer.toString(frm.getRepeat()));
            p("frm.getLastRefillDate()", frm.getLastRefillDate());
            p("frm.getSpecial()", frm.getSpecial());
            p("frm.getAtcCode()", frm.getAtcCode());
            p("frm.getRegionalIdentifier()", frm.getRegionalIdentifier());
            p("frm.getUnit()", frm.getUnit());
            p("frm.getUnitName()", frm.getUnitName());
            p("frm.getMethod()", frm.getMethod());
            p("frm.getRoute()", frm.getRoute());
            p("frm.getDosage()", frm.getDosage());
            p("frm.getBrandName()", frm.getBrandName());
            p("frm.getGenericName()", frm.getGenericName());
            p("rxdate before process", frm.getRxDate());
            p("rxdate after process", RxUtil.StringToDate(frm.getRxDate(), "yyyy-MM-dd").toString());
             */
            rx.setRxDate(RxUtil.StringToDate(frm.getRxDate(), "yyyy-MM-dd"));
            rx.setWrittenDate(RxUtil.StringToDate(frm.getWrittenDate(), "yyyy-MM-dd"));
            rx.setTakeMin(frm.getTakeMinFloat());
            rx.setTakeMax(frm.getTakeMaxFloat());
            rx.setFrequencyCode(frm.getFrequencyCode());
            rx.setDuration(frm.getDuration());
            rx.setDurationUnit(frm.getDurationUnit());
            rx.setQuantity(frm.getQuantity());
            rx.setRepeat(frm.getRepeat());
            rx.setLastRefillDate(RxUtil.StringToDate(frm.getLastRefillDate(), "yyyy-MM-dd"));
            rx.setNosubs(frm.getNosubs());
            rx.setPrn(frm.getPrn());
            rx.setSpecial(frm.getSpecial());
            rx.setAtcCode(frm.getAtcCode());
            rx.setRegionalIdentifier(frm.getRegionalIdentifier());
            rx.setUnit(frm.getUnit());
            rx.setUnitName(frm.getUnitName());
            rx.setMethod(frm.getMethod());
            rx.setRoute(frm.getRoute());
            rx.setCustomInstr(frm.getCustomInstr());
            rx.setDosage(frm.getDosage());
            rx.setOutsideProviderName(frm.getOutsideProviderName());
            rx.setOutsideProviderOhip(frm.getOutsideProviderOhip());
            rx.setLongTerm(frm.getLongTerm());
            rx.setPastMed(frm.getPastMed());
            rx.setPatientCompliance(frm.getPatientComplianceY(), frm.getPatientComplianceN());

            try {
                rx.setDrugForm(drugData.getDrugForm(String.valueOf(frm.getGCN_SEQNO())));
            } catch (Exception e) {
                logger.error("Unable to get DrugForm from drugref");
            }

            System.out.println("SAVING STASH " + rx.getCustomInstr());
            logger.debug("SAVING STASH " + rx.getCustomInstr());
            if (rx.getSpecial() == null) {
                logger.error("Drug.special is null : " + rx.getSpecial() + " : " + frm.getSpecial());
            } else if (rx.getSpecial().length() < 6) {
                logger.warn("Drug.special appears to be empty : " + rx.getSpecial() + " : " + frm.getSpecial());
            }

            String annotation_attrib = request.getParameter("annotation_attrib");
            if (annotation_attrib == null) {
                annotation_attrib = "";
            }
            //      System.out.println("SETTING ANNOTATE NAME '" + annotation_attrib + "'");
            //      System.out.println("SETTING StashIndex '" + "" + bean.getStashIndex() + "'");
            bean.addAttributeName(annotation_attrib, bean.getStashIndex());
            bean.setStashItem(bean.getStashIndex(), rx);
            //   p("bean.getStashIndex() in unspecified=" + "" + bean.getStashIndex());
            rx = null;

            if (frm.getAction().equals("update")) {
                fwd = "refresh";
            }
            if (frm.getAction().equals("updateAddAnother")) {
                fwd = "addAnother";
            }
            if (frm.getAction().equals("updateAndPrint")) {
                //SAVE THE DRUG
                int i;
                String scriptId = prescription.saveScript(bean);
                @SuppressWarnings("unchecked")
                ArrayList<String> attrib_names = bean.getAttributeNames();
                //      p("attrib_names", attrib_names.toString());
                StringBuffer auditStr = new StringBuffer();
                for (i = 0; i < bean.getStashSize(); i++) {
                    rx = bean.getStashItem(i);
                    // System.out.println("*** before rx.Save(" + scriptId.toString() + ")");
                    rx.Save(scriptId);
                    auditStr.append(rx.getAuditString());
                    auditStr.append("\n");
                    //    p("rx.getAuditString()", rx.getAuditString());
                    /* Save annotation */
                    HttpSession se = request.getSession();
                    WebApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(se.getServletContext());
                    CaseManagementManager cmm = (CaseManagementManager) ctx.getBean("caseManagementManager");
                    String attrib_name = attrib_names.get(i);
                    //   p("attrib_names.get(i)", attrib_names.get(i));
                    if (attrib_name != null) {
                        CaseManagementNote cmn = (CaseManagementNote) se.getAttribute(attrib_name);
                        if (cmn != null) {
                            cmm.saveNoteSimple(cmn);
                            CaseManagementNoteLink cml = new CaseManagementNoteLink();
                            cml.setTableName(CaseManagementNoteLink.DRUGS);
                            cml.setTableId((long) rx.getDrugId());
                            cml.setNoteId(cmn.getId());
                            cmm.saveNoteLink(cml);
                            se.removeAttribute(attrib_name);
                            LogAction.addLog(cmn.getProviderNo(), LogConst.ANNOTATE, CaseManagementNoteLink.DISP_PRESCRIP, scriptId, request.getRemoteAddr(), cmn.getDemographic_no(), cmn.getNote());
                        }
                    }
                    rx = null;
                }
                //   System.out.println("bean.getStashIndex() after update,print,save=" + bean.getStashIndex());
                fwd = "viewScript";
                String ip = request.getRemoteAddr();
                //    p("ip", ip);
                request.setAttribute("scriptId", scriptId);
                LogAction.addLog((String) request.getSession().getAttribute("user"), LogConst.ADD, LogConst.CON_PRESCRIPTION, scriptId, ip, "" + bean.getDemographicNo(), auditStr.toString());
            }
        }
        //   System.out.println("***===========End of unspecified RxWriteScriptAction.java");
        return mapping.findForward(fwd);
    }

    public ActionForward saveCustomName(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        //   p("=============Start  saveCustomName RxWriteScriptAction.java===============");
        oscar.oscarRx.pageUtil.RxSessionBean bean = (oscar.oscarRx.pageUtil.RxSessionBean) request.getSession().getAttribute("RxSessionBean");
        if (bean == null) {
            response.sendRedirect("error.html");
            return null;
        }
        try {
            String randomId = request.getParameter("randomId");
            String customName = request.getParameter("customName");
            //    p("randomId from request",randomId);
            p("customName from request", customName);
            RxPrescriptionData.Prescription rx = bean.getStashItem2(Integer.parseInt(randomId));
            if (rx == null) {
                logger.error("rx is null", new NullPointerException());
                return null;
            }
            rx.setCustomName(customName);
            rx.setBrandName(null);
            rx.setGenericName(null);
            //bean.addAttributeName(rx.getAtcCode() + "-" + String.valueOf(bean.getIndexFromRx(Integer.parseInt(randomId))));
            //  p("updateDrug parseIntr bean.getStashIndex()", Integer.toString(bean.getStashIndex()));
            bean.setStashItem(bean.getIndexFromRx(Integer.parseInt(randomId)), rx);
            RxUtil.printStashContent(bean);
            //check for most recent drug,
            p("rx.getCustomName in saveCustomName", rx.getCustomName());
            RxUtil.setSpecialQuantityRepeat(rx);
            HashMap hm = new HashMap();
            hm.put("instructions", rx.getSpecial());
            hm.put("quantity", rx.getQuantity());
            hm.put("repeat", rx.getRepeat());
            JSONObject jsonObject = JSONObject.fromObject(hm);
            //      p("jsonObject", jsonObject.toString());
            response.getOutputStream().write(jsonObject.toString().getBytes());
        } catch (Exception e) {
            e.printStackTrace();
        }

        //  p("=============END saveCustomName  RxWriteScriptAction.java===============");
        return null;
    }

    private void setDefaultQuantity(final HttpServletRequest request) {
        try {
            WebApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext());
            String provider = (String) request.getSession().getAttribute("user");
            //System.out.println("provider=" + provider);
            if (provider != null) {
                userPropertyDAO = (UserPropertyDAO) ctx.getBean("UserPropertyDAO");
                UserProperty prop = userPropertyDAO.getProp(provider, UserProperty.RX_DEFAULT_QUANTITY);
                //System.out.println("prop="+prop);
                RxUtil.setDefaultQuantity(prop.getValue());
            } else {
                logger.error("Provider is null", new NullPointerException());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ActionForward newCustomDrug(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        p("=============Start newCustomDrug RxWriteScriptAction.java===============");
        Locale locale = getLocale(request);
        MessageResources messages = getResources(request);
        //set default quantity;
        setDefaultQuantity(request);

        oscar.oscarRx.pageUtil.RxSessionBean bean = (oscar.oscarRx.pageUtil.RxSessionBean) request.getSession().getAttribute("RxSessionBean");
        if (bean == null) {
            response.sendRedirect("error.html");
            return null;
        }

        try {
            RxPrescriptionData rxData = new RxPrescriptionData();
            RxDrugData drugData = new RxDrugData();
            // create Prescription
            RxPrescriptionData.Prescription rx = rxData.newPrescription(bean.getProviderNo(), bean.getDemographicNo());
            String ra = request.getParameter("randomId");
            rx.setRandomId(Integer.parseInt(ra));
            rx.setGenericName(null);
            rx.setBrandName(null);
            rx.setDrugForm("");
            rx.setRoute("");
            rx.setDosage("");
            rx.setUnit("");
            rx.setGCN_SEQNO(0);
            rx.setRegionalIdentifier("");
            rx.setAtcCode("");
            RxUtil.setDefaultSpecialQuantityRepeat(rx);//1 OD, 20, 0;
            rx.setDuration(RxUtil.findDuration(rx));
            bean.addAttributeName(rx.getAtcCode() + "-" + String.valueOf(bean.getStashIndex()));
            List<RxPrescriptionData.Prescription> listRxDrugs = new ArrayList();

            if (RxUtil.isRxUniqueInStash(bean, rx)) {
                listRxDrugs.add(rx);
            }
            int rxStashIndex = bean.addStashItem(rx);
            bean.setStashIndex(rxStashIndex);

            //bean.setStashIndex(bean.addStashItem(rx));
            //    p("brandName of rx", rx.getBrandName());
            //    p("stash index it's set to", "" + bean.getStashIndex());

            String today = null;
            Calendar calendar = Calendar.getInstance();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            try {
                today = dateFormat.format(calendar.getTime());
                //      p("today's date", today);
            } catch (Exception e) {
                e.printStackTrace();
            }
            Date tod = RxUtil.StringToDate(today, "yyyy-MM-dd");
            rx.setRxDate(tod);
            rx.setWrittenDate(tod);


            request.setAttribute("listRxDrugs", listRxDrugs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        p("=============END newCustomDrug RxWriteScriptAction.java===============");
        return (mapping.findForward("newRx"));
    }

    public ActionForward createNewRx(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        p("=============Start createNewRx RxWriteScriptAction.java===============");
        //set default quantity
        setDefaultQuantity(request);
        //    System.out.println("***IN RxChooseDrugAction.java");
        // Extract attributes we will need

        oscar.oscarRx.pageUtil.RxSessionBean bean = (oscar.oscarRx.pageUtil.RxSessionBean) request.getSession().getAttribute("RxSessionBean");
        if (bean == null) {
            response.sendRedirect("error.html");
            return null;
        }

        try {
            RxPrescriptionData rxData = new RxPrescriptionData();
            RxDrugData drugData = new RxDrugData();

            // create Prescription
            RxPrescriptionData.Prescription rx = rxData.newPrescription(bean.getProviderNo(), bean.getDemographicNo());

            String ra = request.getParameter("randomId");
            int randomId = Integer.parseInt(ra);
            rx.setRandomId(randomId);
            String drugId = request.getParameter("drugId");
            String text = request.getParameter("text");

            //    p("drugId", drugId);
            //    p("text", text);

            //TODO: Is this to slow to do here?  It's possible to do this in ajax,  as in when this comes back launch an ajax request to fill in.
            RxDrugData.DrugMonograph dmono = drugData.getDrug2(drugId);

            String brandName = text;
            //String genericName = request.getParameter("drugName");

            //      p("BRAND = " + brandName);
            rx.setGenericName(dmono.name); //TODO: how was this done before?
            rx.setBrandName(brandName);

            rx.setDrugForm(dmono.drugForm);

            //TO DO: cache the most used route from the drugs table.
            //for now, check to see if ORAL present, if yes use that, if not use the first one.
            boolean oral = false;
            for (int i = 0; i < dmono.route.size(); i++) {
                if (((String) dmono.route.get(i)).equalsIgnoreCase("ORAL")) {
                    oral = true;
                }
            }
            if (oral) {
                rx.setRoute("ORAL");
            } else {
                if (dmono.route.size() > 0) {
                    rx.setRoute((String) dmono.route.get(0));
                }
            }
            //if user specified route in instructions, it'll be changed to the one specified.
            String dosage = "";
            String unit = "";
            Vector comps = (Vector) dmono.components;
            for (int i = 0; i < comps.size(); i++) {
                RxDrugData.DrugMonograph.DrugComponent drugComp = (RxDrugData.DrugMonograph.DrugComponent) comps.get(i);
                String strength = drugComp.strength;
                unit = drugComp.unit;
                dosage = dosage + " " + strength + " " + unit;//get drug dosage from strength and unit.
            }
            rx.setDosage(dosage);
            rx.setUnit(unit);
            //    p("set drug form to ",rx.getDrugForm());
            //    p("set dosage to ",rx.getDosage());
            //     p("set unit to ",rx.getUnit());
            //     p("set route to ",rx.getRoute());
            rx.setGCN_SEQNO(Integer.parseInt(drugId));
            rx.setRegionalIdentifier(dmono.regionalIdentifier);
            //     p("set regional identifier to ", rx.getRegionalIdentifier());
            String atcCode = dmono.atc;
            rx.setAtcCode(atcCode);
            RxUtil.setSpecialQuantityRepeat(rx);
            rx.setDuration(RxUtil.findDuration(rx));
            System.out.println("duration=" + rx.getDuration());
            //    p("set atc code to ", rx.getAtcCode());
            List<RxPrescriptionData.Prescription> listRxDrugs = new ArrayList();
            if (RxUtil.isRxUniqueInStash(bean, rx)) {
                listRxDrugs.add(rx);
            }
            bean.addAttributeName(rx.getAtcCode() + "-" + String.valueOf(bean.getStashIndex()));
            int rxStashIndex = bean.addStashItem(rx);
            bean.setStashIndex(rxStashIndex);

            //bean.setStashIndex(bean.addStashItem(rx));
            //     p("brandName of rx", rx.getBrandName());
            //    p("stash index it's set to", "" + bean.getStashIndex());

            String today = null;
            Calendar calendar = Calendar.getInstance();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            try {
                today = dateFormat.format(calendar.getTime());
                //        p("today's date", today);
            } catch (Exception e) {
                e.printStackTrace();
            }
            Date tod = RxUtil.StringToDate(today, "yyyy-MM-dd");
            rx.setRxDate(tod);
            rx.setWrittenDate(tod);
            rx.setDiscontinuedLatest(RxUtil.checkDiscontinuedBefore(rx));//check and set if rx was discontinued before.
            request.setAttribute("listRxDrugs", listRxDrugs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        p("=============END createNewRx RxWriteScriptAction.java===============");
        return (mapping.findForward("newRx"));
    }

    public ActionForward updateDrug(ActionMapping mapping, ActionForm aform, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        oscar.oscarRx.pageUtil.RxSessionBean bean = (oscar.oscarRx.pageUtil.RxSessionBean) request.getSession().getAttribute("RxSessionBean");
        if (bean == null) {
            response.sendRedirect("error.html");
            return null;
        }

        String action = request.getParameter("action");

        if (action != null && action.equals("parseInstructions")) {
            System.out.println("==========***### IN parseInstruction RxWriteScriptAction.java");
            try {
                String randomId = request.getParameter("randomId");
                //       p("randomId from request",randomId);
                RxPrescriptionData.Prescription rx = bean.getStashItem2(Integer.parseInt(randomId));
                if (rx == null) {
                    System.out.println("rx is null");
                    logger.error("rx is null", new NullPointerException());
                }
                //      p("IN updateDrug, atc=" + rx.getAtcCode() + "; regionalIdentifier=" + rx.getRegionalIdentifier());

                String instructions = request.getParameter("instruction");
                p("instruction", instructions);

                RxUtil.instrucParser(instructions, rx);
                //       p("before updateDrug parseIntr bean.getStashIndex()", Integer.toString(bean.getStashIndex()));
                // bean.addAttributeName(rx.getAtcCode() + "-" + String.valueOf(bean.getStashIndex()));
                bean.addAttributeName(rx.getAtcCode() + "-" + String.valueOf(bean.getIndexFromRx(Integer.parseInt(randomId))));
                //       p("updateDrug parseIntr bean.getStashIndex()", Integer.toString(bean.getStashIndex()));
                // bean.setStashIndex(bean.addStashItem(rx));
                bean.setStashItem(bean.getIndexFromRx(Integer.parseInt(randomId)), rx);
                RxUtil.printStashContent(bean);
                HashMap hm = new HashMap();

                if (rx.getRoute() == null || rx.getRoute().equalsIgnoreCase("null")) {
                    rx.setRoute("");
                }

                hm.put("method", rx.getMethod());
                hm.put("takeMin", rx.getTakeMin());
                hm.put("takeMax", rx.getTakeMax());
                hm.put("duration", rx.getDuration());
                hm.put("frequency", rx.getFrequencyCode());
                hm.put("route", rx.getRoute());
                hm.put("durationUnit", rx.getDurationUnit());
                hm.put("prn", rx.getPrn());
                hm.put("calQuantity", rx.getQuantity());
                JSONObject jsonObject = JSONObject.fromObject(hm);
                p("jsonObject", jsonObject.toString());
                response.getOutputStream().write(jsonObject.toString().getBytes());
            } catch (Exception e) {
                e.printStackTrace();
            }
            p("===================END parseInstruction RxWriteScriptAction.java======================");
            return null;
        } else if (action != null && action.equals("updateQty")) {
            //    System.out.println("==========***### IN updateQty RxWriteScriptAction.java");
            try {
                String quantity = request.getParameter("quantity");
                String randomId = request.getParameter("randomId");
                RxPrescriptionData.Prescription rx = bean.getStashItem2(Integer.parseInt(randomId));
                //get rx from randomId
                if (quantity == null) {
                    quantity = "";
                }
                //check if quantity is same as rx.getquantity(), if yes, do nothing.
                if (quantity.equals(rx.getQuantity())) {
                    //do nothing
                } else {
                    rx.setQuantity(quantity);
                    String frequency = rx.getFrequencyCode();
                    String takeMin = rx.getTakeMinString();
                    String takeMax = rx.getTakeMaxString();
                    String durationUnit = rx.getDurationUnit();
                    double nPerDay = 0d;
                    double nDays = 0d;
                    if (takeMin.equals("0") || takeMax.equals("0") || frequency.equals("")) {
                    } else {
                        if (durationUnit.equals("")) {
                            durationUnit = "D";
                        }

                        nPerDay = RxUtil.findNPerDay(frequency);
                        nDays = RxUtil.findNDays(durationUnit);
                        double qtyD = Double.parseDouble(quantity);
                        //quantity=takeMax * nDays * duration * nPerDay
                        double durD = qtyD / ((Double.parseDouble(takeMax)) * nPerDay * nDays);
                        int durI = (int) durD;
                        rx.setDuration(Integer.toString(durI));
                        rx.setDurationUnit(durationUnit);
                    }
                    //duration=quantity divide by no. of pills per duration period.
                    //if not, recalculate duration based on frequency if frequency is not empty
                    //if there is already a duration uni present, use that duration unit. if not, set duration unit to days, and output duration in days
                }
                //    p("before updateDrug parseIntr bean.getStashIndex()", Integer.toString(bean.getStashIndex()));
                bean.addAttributeName(rx.getAtcCode() + "-" + String.valueOf(bean.getIndexFromRx(Integer.parseInt(randomId))));
                //   p("updateDrug parseIntr bean.getStashIndex()", Integer.toString(bean.getStashIndex()));
                bean.setStashItem(bean.getIndexFromRx(Integer.parseInt(randomId)), rx);
                RxUtil.printStashContent(bean);
                if (rx.getRoute() == null) {
                    rx.setRoute("");
                }
                HashMap hm = new HashMap();
                hm.put("method", rx.getMethod());
                hm.put("takeMin", rx.getTakeMin());
                hm.put("takeMax", rx.getTakeMax());
                hm.put("duration", rx.getDuration());
                hm.put("frequency", rx.getFrequencyCode());
                hm.put("route", rx.getRoute());
                hm.put("durationUnit", rx.getDurationUnit());
                hm.put("prn", rx.getPrn());
                hm.put("calQuantity", rx.getQuantity());
                JSONObject jsonObject = JSONObject.fromObject(hm);
                //     p("jsonObject", jsonObject.toString());
                response.getOutputStream().write(jsonObject.toString().getBytes());
            } catch (Exception e) {
                e.printStackTrace();
            }
            //      p("===================END updateQty RxWriteScriptAction.java======================");
            return null;
        } else {
            return null;
        }
    }

    public ActionForward iterateStash(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException, Exception {
        oscar.oscarRx.pageUtil.RxSessionBean bean = (oscar.oscarRx.pageUtil.RxSessionBean) request.getSession().getAttribute("RxSessionBean");
        //System.out.println("iterateStash");
        //RxUtil.printStashContent(bean);
        List<RxPrescriptionData.Prescription> listP = Arrays.asList(bean.getStash());
        if (listP.size() == 0) {
            return null;
        } else {
            //System.out.println("size "+listP.size()+" ; "+listP.get(0));
            request.setAttribute("listRxDrugs", listP);
            return (mapping.findForward("newRx"));
        }

    }

    public ActionForward updateSaveAllDrugs(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException, Exception {
        System.out.println("==========***### start updaing drugs RxWriteScriptAction.java");
        oscar.oscarRx.pageUtil.RxSessionBean bean = (oscar.oscarRx.pageUtil.RxSessionBean) request.getSession().getAttribute("RxSessionBean");
        request.getSession().setAttribute("rePrint", null);//set to print.
        List<String> paramList = new ArrayList();
        Enumeration em = request.getParameterNames();
        List<String> randNum = new ArrayList();
        while (em.hasMoreElements()) {
            String ele = em.nextElement().toString();
            System.out.println("ele>" + ele);
            paramList.add(ele);
            if (ele.startsWith("drugName_")) {
                String rNum = ele.substring(9);
                System.out.println("rNum:" + rNum);
                if (!randNum.contains(rNum)) {
                    randNum.add(rNum);
                }
            }
        }
        //p("here2 ran num size " + randNum.size());
        //    p("bean.getStashSize()", Integer.toString(bean.getStashSize()));

        List<Integer> allIndex = new ArrayList();
        for (int i = 0; i < bean.getStashSize(); i++) {
            allIndex.add(i);
        }
        List<Integer> existingIndex = new ArrayList();

        for (String num : randNum) {
            //          p("num", num);
            int stashIndex = bean.getIndexFromRx(Integer.parseInt(num));
            existingIndex.add(stashIndex);
            RxPrescriptionData.Prescription rx = bean.getStashItem(stashIndex);

            boolean patientComplianceY = false;
            boolean patientComplianceN = false;
            boolean isOutsideProvider = false;
            boolean isLongTerm = false;
            boolean isPastMed = false;
            try {
                em = request.getParameterNames();
                while (em.hasMoreElements()) {
                    String elem = (String) em.nextElement();
                    String val = request.getParameter(elem);
                    System.out.println("paramName=" + elem + ", value=" + val);
                    if (elem.startsWith("drugName_" + num)) {
                        if (rx.isCustom()) {
                            rx.setCustomName(val);
                            rx.setBrandName(null);
                            rx.setGenericName(null);
                        } else {
                            rx.setBrandName(val);
                        }
                        ;
                    } else if (elem.equals("repeats_" + num)) {

                        if (val.equals("") || val == null) {
                            rx.setRepeat(0);
                        } else {
                            rx.setRepeat(Integer.parseInt(val));
                        }

                    } else if (elem.startsWith("instructions_" + num)) {
                        rx.setSpecial(val);
                    } else if (elem.equals("quantity_" + num)) {
                        if (val.equals("") || val == null) {
                            rx.setQuantity("0");
                        } else {
                            rx.setQuantity(val);
                        }
                    } else if (elem.equals("longTerm_" + num)) {
                        if (val.equals("on")) {
                            isLongTerm = true;
                        } else {
                            isLongTerm = false;
                        }
                    } else if (elem.equals("lastRefillDate_" + num)) {
                        rx.setLastRefillDate(RxUtil.StringToDate(val, "yyyy-MM-dd"));
                    } else if (elem.equals("outsideProviderName_" + num)) {
                        rx.setOutsideProviderName(val);
                    } else if (elem.equals("rxDate_" + num)) {
                        //     p("paramName is rxDate!!");
                        if ((val == null) || (val.equals(""))) {
                            rx.setRxDate(RxUtil.StringToDate("0000-00-00", "yyyy-MM-dd"));
                        } else {
                            rx.setRxDate(RxUtil.StringToDate(val, "yyyy-MM-dd"));
                        }
                    } else if (elem.equals("writtenDate_" + num)) {
                        if (val == null || (val.equals(""))) {
                            //     p("writtenDate is null");
                            rx.setWrittenDate(RxUtil.StringToDate("0000-00-00", "yyyy-MM-dd"));
                        } else {
                            rx.setWrittenDate(RxUtil.StringToDate(val, "yyyy-MM-dd"));
                        }

                    } else if (elem.equals("outsideProviderName_" + num)) {
                        rx.setOutsideProviderName(val);
                    } else if (elem.equals("outsideProviderOhip_" + num)) {
                        if (val.equals("") || val == null) {
                            rx.setOutsideProviderOhip("0");
                        } else {
                            rx.setOutsideProviderOhip(val);
                        }
                    } else if (elem.equals("ocheck_" + num)) {
                        if (val.equals("on")) {
                            isOutsideProvider = true;
                        } else {
                            isOutsideProvider = false;
                        }
                    } else if (elem.equals("pastMed_" + num)) {
                        if (val.equals("on")) {
                            isPastMed = true;
                        } else {
                            isPastMed = false;
                        }
                    } else if (elem.equals("patientComplianceY_" + num)) {
                        if (val.equals("on")) {
                            patientComplianceY = true;
                        } else {
                            patientComplianceY = false;
                        }
                    } else if (elem.equals("patientComplianceN_" + num)) {
                        if (val.equals("on")) {
                            patientComplianceN = true;
                        } else {
                            patientComplianceN = false;
                        }
                    }
                }

                if (!isOutsideProvider) {
                    rx.setOutsideProviderName("");
                    rx.setOutsideProviderOhip("");
                }
                rx.setPastMed(isPastMed);
                rx.setLongTerm(isLongTerm);
                String newline = System.getProperty("line.separator");
                rx.setPatientCompliance(patientComplianceY, patientComplianceN);
                String special;
                if (rx.isCustom()) {
                    special = rx.getCustomName() + newline + rx.getSpecial() + newline + "Qty:" + rx.getQuantity() + " Repeats:" + "" + rx.getRepeat();
                } else {
                    special = rx.getBrandName() + newline + rx.getSpecial() + newline + "Qty:" + rx.getQuantity() + " Repeats:" + "" + rx.getRepeat();
                }
                //     p("here222");
                rx.setSpecial(special.trim());
                System.out.println("SETTING SPECIAL TOO >" + special + "<");
                //         p("rx.getDuration()", rx.getDuration());
                int duration;
                if (rx.getDuration() == null || rx.getDuration().equals("")) {
                    duration = 0;
                } else {
                    duration = Integer.parseInt(rx.getDuration());
                }
                Calendar cal = Calendar.getInstance();
                cal.setTime(rx.getRxDate());
                DateFormat ft = new SimpleDateFormat("yyyy/MM/dd");
                //       p("cal", ft.format(cal.getTime()));
                cal.add(Calendar.DATE, duration);
                String end = ft.format(cal.getTime());
                //       p("after addition", end);
                Date endDate = (Date) ft.parse(end);
            } catch (Exception e) {
                e.printStackTrace();
            }


            //    p("the rxDate is in updateDrug", RxUtil.DateToString(rx.getRxDate()));
            //   p("duration after updated", rx.getDuration());

            bean.addAttributeName(rx.getAtcCode() + "-" + String.valueOf(stashIndex));
            //    p("before bean.getStashIndex()", Integer.toString(stashIndex));
            bean.setStashItem(stashIndex, rx);
            //    p("brand name of updated rx", rx.getBrandName());
            //    p("stash index of updated rx", Integer.toString(bean.getStashIndex()));

        }
        for (Integer n : existingIndex) {
            if (allIndex.contains(n)) {
                allIndex.remove(n);
            }
        }
        List<Integer> deletedIndex = allIndex;
        //remove closed Rx from stash

        for (Integer n : deletedIndex) {
            //    p("stash index of closed rx",""+n);
            bean.removeStashItem(n);
            //    p("bean.getStashIndex()",""+bean.getStashIndex());
            //   p("bean.getStashSize()",""+bean.getStashSize());
            if (bean.getStashIndex() >= bean.getStashSize()) {
                bean.setStashIndex(bean.getStashSize() - 1);
            }
        }

        System.out.println("***===========finish updating all drugs RxWriteScriptAction.java");
        saveDrug(request);
        //return mapping.findForward("viewScript");
        return null;
    }

    public void saveDrug(final HttpServletRequest request)
            throws IOException, ServletException, Exception {
        System.out.println("==========***### start save drug RxWriteScriptAction.java");
        oscar.oscarRx.pageUtil.RxSessionBean bean = (oscar.oscarRx.pageUtil.RxSessionBean) request.getSession().getAttribute("RxSessionBean");
        RxDrugData drugData = new RxDrugData();
        RxPrescriptionData.Prescription rx = null;
        RxPrescriptionData prescription = new RxPrescriptionData();
        String scriptId = prescription.saveScript(bean);
        StringBuffer auditStr = new StringBuffer();
        ArrayList<String> attrib_names = bean.getAttributeNames();
        //  System.out.println("here3");
        //   p("bean.getStashSize()", Integer.toString(bean.getStashSize()));
        for (int i = 0; i < bean.getStashSize(); i++) {
            try {
                rx = bean.getStashItem(i);
                //     p("before saving rx", rx.getGenericName());
                //      p(rx.getSpecial());
                //       p(rx.getQuantity());
                //      p("" + rx.getRepeat());
                //      p(rx.getAtcCode());
                //      p(rx.getRegionalIdentifier());
                // System.out.println("*** before rx.Save(" + scriptId.toString() + ")");
                rx.Save(scriptId);
                auditStr.append(rx.getAuditString());
                auditStr.append("\n");
            } catch (Exception e) {
                e.printStackTrace();
            }
            //   p("rx.getAuditString()", rx.getAuditString());
            // Save annotation
            HttpSession se = request.getSession();
            WebApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(se.getServletContext());
            CaseManagementManager cmm = (CaseManagementManager) ctx.getBean("caseManagementManager");
            String attrib_name = attrib_names.get(i);
            //   p("attrib_names.get(i)", attrib_names.get(i));
            if (attrib_name != null) {
                CaseManagementNote cmn = (CaseManagementNote) se.getAttribute(attrib_name);
                if (cmn != null) {
                    cmm.saveNoteSimple(cmn);
                    CaseManagementNoteLink cml = new CaseManagementNoteLink();
                    cml.setTableName(CaseManagementNoteLink.DRUGS);
                    cml.setTableId((long) rx.getDrugId());
                    cml.setNoteId(cmn.getId());
                    cmm.saveNoteLink(cml);
                    se.removeAttribute(attrib_name);
                    LogAction.addLog(cmn.getProviderNo(), LogConst.ANNOTATE, CaseManagementNoteLink.DISP_PRESCRIP, scriptId, request.getRemoteAddr(), cmn.getDemographic_no(), cmn.getNote());
                }
            }
            rx = null;
        }

        String ip = request.getRemoteAddr();
        request.setAttribute("scriptId", scriptId);
        LogAction.addLog((String) request.getSession().getAttribute("user"), LogConst.ADD, LogConst.CON_PRESCRIPTION, scriptId, ip, "" + bean.getDemographicNo(), auditStr.toString());

        System.out.println("***===========finish saving drugs RxWriteScriptAction.java");
        return;
    }
}
