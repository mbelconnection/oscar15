package com.quatro.web.report;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.oscarehr.PMmodule.web.BaseAction;

import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.reportsource.IReportSource;

public class QuatroReportShowAction  extends BaseAction
{
    //View catched version of the report for crystal export/print
    public ActionForward unspecified(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)  
	{
    	CrystalReportViewer crystalReportViewer = new CrystalReportViewer();
        try{
			Fields fields = (Fields) request.getSession().getAttribute("paramFields");
			IReportSource reportSource = (IReportSource) request.getSession().getAttribute("reportSource");

        	crystalReportViewer.setReportSource(reportSource);
	    	crystalReportViewer.setParameterFields(fields);
        	crystalReportViewer.setOwnPage(true);
	    	crystalReportViewer.setOwnForm(true);
	    	crystalReportViewer.setDisplayGroupTree(true);
	    	crystalReportViewer.setGroupTreeWidth(50);
	    	crystalReportViewer.setHasExportButton(true);
	    	crystalReportViewer.setHasSearchButton(false);
	    	crystalReportViewer.setHasPageBottomToolbar(false);
	    	crystalReportViewer.setHasRefreshButton(true);
	    	crystalReportViewer.setHasToggleGroupTreeButton(false);
	    	crystalReportViewer.setHasZoomFactorList(true);
	    	crystalReportViewer.setHasLogo(false);
	    	crystalReportViewer.setEnableDrillDown(true);
	    	crystalReportViewer.setEnableParameterPrompt(true);
//	    	crystalReportViewer.setRenderAsHTML32(true);
           	crystalReportViewer.processHttpRequest(request, response, getServlet().getServletContext(), null);
           	return null;
		} catch(Exception ex2) {
			System.out.println(ex2.toString());
			return null;
      }    
   }
}
