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
 * McMaster Unviersity 
 * Hamilton 
 * Ontario, Canada 
 */
package oscar.billing.popup;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import oscar.billing.cad.model.CadProcedimentos;


public class ProcedimentoForm extends ActionForm {
    private String dispatch;
    private int strutsAction;
    private String strutsButton = "";
    private List procedimentos;
    private String codigoProc;
    private String descProc;

    public ProcedimentoForm() {
        this.procedimentos = new ArrayList();
    }

    public int getStrutsAction() {
        return strutsAction;
    }

    public void setStrutsAction(int strutsAction) {
        this.strutsAction = strutsAction;
    }

    public void setStrutsButton(String strutsButton) {
        this.strutsButton = strutsButton;
    }

    public String getStrutsButton() {
        return strutsButton;
    }

    public ActionErrors validate(ActionMapping mapping,
        javax.servlet.http.HttpServletRequest request) {
        ActionErrors errors = super.validate(mapping, request);

        return errors;
    }

    public void clear() {
        procedimentos.clear();
        dispatch = "";
        codigoProc = "";
        descProc = "";
    }

    /**
     * Returns the dispatch.
     * @return String
     */
    public String getDispatch() {
        return dispatch;
    }

    /**
     * Sets the dispatch.
     * @param dispatch The dispatch to set
     */
    public void setDispatch(String dispatch) {
        this.dispatch = dispatch;
    }

    /**
     * @see org.apache.struts.action.ActionForm#reset(ActionMapping, HttpServletRequest)
     */
    public void reset(ActionMapping arg0, HttpServletRequest arg1) {
        super.reset(arg0, arg1);
    }

    public CadProcedimentos getProcedimento(int i) {
        return (CadProcedimentos) this.procedimentos.get(i);
    }

    /**
     * @return
     */
    public String getCodigoProc() {
        return codigoProc;
    }

    /**
     * @return
     */
    public String getDescProc() {
        return descProc;
    }

    /**
     * @return
     */
    public List getProcedimentos() {
        return procedimentos;
    }

    /**
     * @param string
     */
    public void setCodigoProc(String string) {
        codigoProc = string;
    }

    /**
     * @param string
     */
    public void setDescProc(String string) {
        descProc = string;
    }

    /**
     * @param list
     */
    public void setProcedimentos(List list) {
        procedimentos = list;
    }
}