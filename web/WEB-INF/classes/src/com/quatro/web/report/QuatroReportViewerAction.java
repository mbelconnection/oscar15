/*******************************************************************************
 * Copyright (c) 2005, 2009 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU General Public License
 * which accompanies this distribution, and is available at
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Contributors:
 *     <Quatro Group Software Systems inc.>  <OSCAR Team>
 *******************************************************************************/
package com.quatro.web.report;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.ActionMessage;
import org.oscarehr.PMmodule.web.BaseAction;


import com.crystaldecisions.report.htmlrender.DatabaseLogonRenderer;
import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.reports.reportengineinterface.JPEReportSourceFactory;
import com.crystaldecisions.reports.sdk.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.ConnectionInfo;
import com.crystaldecisions.sdk.occa.report.data.ConnectionInfos;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.data.IConnectionInfo;
import com.crystaldecisions.sdk.occa.report.data.IDatabase;
import com.crystaldecisions.sdk.occa.report.data.ITable;
import com.crystaldecisions.sdk.occa.report.data.ParameterField;
import com.crystaldecisions.sdk.occa.report.data.ParameterFieldDiscreteValue;
import com.crystaldecisions.sdk.occa.report.data.Values;
import com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat;
import com.crystaldecisions.sdk.occa.report.lib.PropertyBag;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKException;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;
import com.crystaldecisions.sdk.occa.report.reportsource.IReportSource;
import com.crystaldecisions.sdk.occa.report.reportsource.IReportSourceFactory2;
import com.quatro.common.KeyConstants;
import com.crystaldecisions.report.web.viewer.ReportExportControl;
import com.crystaldecisions.sdk.occa.report.exportoptions.ExportOptions;
import com.crystaldecisions.sdk.occa.report.exportoptions.TextExportFormatOptions;

import com.quatro.model.DataViews;
import com.quatro.model.LookupCodeValue;
import com.quatro.model.ReportFilterValue;
import com.quatro.model.ReportOptionValue;
import com.quatro.model.ReportTempCriValue;
import com.quatro.model.ReportTempValue;
import com.quatro.model.ReportValue;
import com.quatro.service.QuatroReportManager;
import com.quatro.util.Utility;

public class QuatroReportViewerAction extends BaseAction {
	ReportValue _rptValue;
    ReportOptionValue _rptOption;
    private QuatroReportManager reportManager;
	public void setQuatroReportManager(QuatroReportManager reportManager) {
		this.reportManager = reportManager;
	}

//	protected CrystalDecisions.CrystalReports.Engine.ReportDocument reportDocument1;
    String _dateRangeDis = "";
	public ActionForward unspecified(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)  
	{
		QuatroReportRunnerForm myForm = (QuatroReportRunnerForm)form;
		try {
			String fwd =  Refresh(myForm, request, response);
			if ("".equals(fwd)) return null;
			else
				return mapping.findForward("view");
		}
		catch(Exception e)
		{
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage(
					"errors.viewer.report", request.getContextPath(), e.getMessage()));
			saveMessages(request, messages);
			return mapping.findForward("error");
		}
	}
	
	protected String Refresh(QuatroReportRunnerForm myForm, HttpServletRequest request, HttpServletResponse response) throws Exception
	{
	    _rptValue = (ReportValue)request.getSession(true).getAttribute(DataViews.REPORT);
	    _rptOption = (ReportOptionValue)request.getSession(true).getAttribute(DataViews.REPORT_OPTION);
	    /*
	    if(request.getParameter("ini") == null) {
	    	ViewReport(request,response);
	    	return;
	    }
	    */
	    try{
			ReportTempValue rptTemp = _rptValue.getReportTemp();
	        int reportNo = rptTemp.getReportNo();
	        String datepartDis = "Date ";
	        if ("M".equals(_rptValue.getDatePart()))
	           datepartDis = "Month ";
	        else if ("Y".equals(_rptValue.getDatePart()))
	           datepartDis = "Year ";

			int templateNo = rptTemp.getTemplateNo();
			//prepare to run the report
 
            //1. get he report Value bean and date filter
            Date startDate = rptTemp.getStartDate();
            Date endDate = rptTemp.getEndDate();
            String dateRangeDis = "";
            if (!Utility.IsEmpty(_rptValue.getDateOption()))
                dateRangeDis = Utility.FormatDate(startDate);
            else
                dateRangeDis = Utility.FormatDate(startDate) + " - " + Utility.FormatDate(endDate);

            if (!"".equals(dateRangeDis)) dateRangeDis = datepartDis + dateRangeDis;

            String startPayPeriod = rptTemp.getStartPayPeriod();
			String endPayPeriod = rptTemp.getEndPayPeriod();
			String sPP = "";	

			if (!Utility.IsEmpty(startPayPeriod)  || !Utility.IsEmpty(endPayPeriod)){ 
				sPP = startPayPeriod + " - " + endPayPeriod;
			}else if (Utility.IsEmpty(startPayPeriod) && Utility.IsEmpty(endPayPeriod)){ 
				// do nothing
			}else if (Utility.IsEmpty(startPayPeriod)){
				sPP =  " - " + endPayPeriod;
			}else if (Utility.IsEmpty(endPayPeriod)){ 
				sPP = startPayPeriod + " - ";
			}
			
			if (!Utility.IsEmpty(sPP)) dateRangeDis = datepartDis + sPP;
			
			String optionId = String.valueOf(rptTemp.getReportOptionID());

			//2. get the org filter
	        String orgDis = "";
            String orgs = "";
            if (_rptValue.isOrgApplicable()) {
            	ArrayList orgLst = constructOrgStringCrysatal(request);
            	orgs = (String) orgLst.get(0);
            	orgDis = (String) orgLst.get(1);
            }
	                
            //3. Construct Criteria String
			String criteriaDis="";
			ArrayList lst=ConstructCriteriaStringCrystal(reportNo, criteriaDis);
			String criteria="";
			if(lst!=null){
			   criteria =(String)lst.get(0); 
			   criteriaDis=(String)lst.get(1);
			}
			
			//4. Build criteria string
			
			String dateSql = "";
			if ("D".equals(_rptValue.getDatePart())){
				dateSql = getDateSql(startDate, endDate);
				reportManager.SetReportDate(request.getSession(true).getId(), startDate, endDate);
			}
			else
			{
				dateSql = getDateSql(startPayPeriod, endPayPeriod);
				reportManager.SetReportDate(request.getSession(true).getId(), startPayPeriod, endPayPeriod);
			}
			criteria = appendCriteria("AND", dateSql,criteria);
			
			//5. append criteria in the report def if any
			criteria = appendCriteria("AND",_rptOption.getDbsqlWhere(), criteria);

			//6. Append ORG filter
			
			if(!Utility.IsEmpty(orgs))orgs = "(" + orgs + ")";
			criteria = appendCriteria("AND",orgs, criteria);
			
			// 7. Paint the report
			return PaintReport(request, response, criteria, orgDis, criteriaDis);
			
	    }catch(Exception e){
	    	throw e;
		}

	}
    private ArrayList constructOrgStringCrysatal(HttpServletRequest request)
    {
        ReportTempValue rptTemp = _rptValue.getReportTemp();
        String fieldName = "{" + _rptValue.getTableName() + ".ORGCD}";
        String orgDis = "";
        ArrayList selectedOrgs = rptTemp.getOrgCodes();
        ArrayList filterOrgs = new ArrayList();
        for(int i=0; i<selectedOrgs.size(); i++)
        {
        	LookupCodeValue org = (LookupCodeValue) selectedOrgs.get(i);
            filterOrgs.add(org.getCode());
            orgDis += org.getCode() + " - " + org.getDescription() + "\n";
        }
        String orgFilter = getOrgFilterString(fieldName, filterOrgs);
        filterOrgs.clear();
        com.quatro.service.security.SecurityManager sm = (com.quatro.service.security.SecurityManager) request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_SECURITY_MANAGER);
        ArrayList orgAccessList = (ArrayList) sm.getUserOrgAccessList();
        for(int i=0; i<orgAccessList.size();i++)
        {
        	String orgcd = (String) orgAccessList.get(i);
            filterOrgs.add(orgcd);
        }
        String orgSecFilter = getOrgFilterString(fieldName, filterOrgs);

        ArrayList retVal = new ArrayList();
        retVal.add(appendCriteria("AND", orgFilter,orgSecFilter));
        retVal.add(orgDis);
        return retVal;
    }
    private String appendCriteria(String op, String filter1, String filter2)
    {
    	if(Utility.IsEmpty(filter1)) return filter2;
    	if(Utility.IsEmpty(filter2)) return filter1;
    	return "(" + filter1  + " " + op + " " + filter2 + ")";
    }
    private String getOrgFilterString(String fieldName, ArrayList orgs)
    {
        if (orgs == null || orgs.size() == 0) return "";
        String orgStr = "(" + fieldName;
        orgStr += " LIKE '*" + (String)orgs.get(0) + "*'";
        for (int i = 1; i < orgs.size(); i++)
        {
            String orgcd = (String)orgs.get(i);
            orgStr += " OR " + fieldName + " LIKE '*" + orgcd + "*'";
        }
        orgStr += ")";
        return orgStr;
    }

    private ArrayList ConstructCriteriaStringCrystal(int reportNo,  String criteriaDis) throws Exception
    {
        ReportTempValue rptTemp = _rptValue.getReportTemp();
        if(rptTemp==null) return null;
        ArrayList criterias = rptTemp.getTemplateCriteria();
        if (criterias.size() == 0) return null;

        String tableName = _rptValue.getTableName() + ".";
        String r_criteriaDis = "";
        
        ReportTempCriValue rptCri = (ReportTempCriValue)criterias.get(0);

        String criteriaSQL = "(";
        r_criteriaDis="(\n"; 

        String err = "";
        for (int i = 0; i < criterias.size(); i++)
        {
            rptCri = (ReportTempCriValue)criterias.get(i);
            String relation = rptCri.getRelation();
            int fieldNo = rptCri.getFieldNo();
            String op = rptCri.getOp();
            String val = rptCri.getVal();
            String valDesc = rptCri.getValDesc();
            if (Utility.IsEmpty(valDesc)) valDesc = val;

            if (!Utility.IsEmpty(relation))
            {
                if ("(".equals(criteriaSQL))
                {
                    if (relation.equals("("))
                    {
                        criteriaSQL += " " + relation + " ";
                    }
                    else
                    {
                        err += "Syntax Error detected, wrong relation at line " + String.valueOf(i + 1) + "<br>";
                    }
                }
                else
                {
                    criteriaSQL += " " + relation + " ";
                }
                r_criteriaDis += " " + relation + " ";
            }
            if (fieldNo > 0)
            {
                if (Utility.IsEmpty(relation) && !"(".equals(criteriaSQL))
                {
                    err += "Missing relations at line " + String.valueOf(i + 1) + "<br>";
                }
                if (Utility.IsEmpty(op))
                {
                    err += "Missing Operator at line " + String.valueOf(i + 1) + "<br>";
                }
                if (Utility.IsEmpty(val))
                {
                    err += "Missing Values at line " + String.valueOf(i + 1) + "<br>";
                }
                ReportFilterValue filter = reportManager.GetFilterField(reportNo, fieldNo);
                String FieldType = filter.getFieldType();
                if ("S".equals(FieldType)) {
                	criteriaSQL += "UpperCase({" + tableName + filter.getFieldSQL() + "})";
                }
                else
                {
                    criteriaSQL += "{" + tableName + filter.getFieldSQL() + "}";
                	
                }
                r_criteriaDis += filter.getFieldDesc();

                criteriaSQL += " " + op + " ";
                r_criteriaDis += " " + op + " ";

                if ("IN".equals(op))
                {
                	try {
                    criteriaSQL += GetValueListCrystal(val, FieldType);
                    r_criteriaDis += "(" + valDesc + ")";
                	}
                	catch(Exception ex)
                	{
                        err += ex.getMessage() + " at line " + String.valueOf(i + 1) + "<br>";
                	}
                }
                else if ("LIKE".equals(op))
                {
                    criteriaSQL += "\"*" + val + "*\"";
                    r_criteriaDis +=  valDesc;
                }
                else
                {
                    if ("D".equals(FieldType))
                    {
                        Date dateValue = Calendar.getInstance().getTime();
                        if ("TODAY".equals(val))
                        {
                            dateValue = new Date();
                        }
                        else
                        {
                        	try {
                        		dateValue = Utility.GetSysDate(val);
                        	}
                        	catch (Exception ex)
                        	{
                                err += ex.getMessage() + " at line " + String.valueOf(i + 1) + "<br>";
                        	}
                        	
                        }
                    	Calendar c1 = Calendar.getInstance();
                    	c1.setTime(dateValue);
                    	criteriaSQL += "CDATE(" + String.valueOf(c1.get(Calendar.YEAR)) + "," + String.valueOf(c1.get(Calendar.MONTH)+1) + "," + c1.get(Calendar.DAY_OF_MONTH) + ")";

                        r_criteriaDis += Utility.FormatDate(dateValue);
                    }
                    else if ("S".equals(FieldType))
                    {
                        criteriaSQL += "\"" + val.toUpperCase() + "\"";
                        r_criteriaDis += "\"" + valDesc + "\"";
                    }
                    else
                    {
                    	if (!Utility.IsNUmber(val)) {
                            err += "A numeric value is expected at line " + String.valueOf(i + 1) + "<br>";
                    	}
                        criteriaSQL += val;
                        r_criteriaDis += valDesc;
                    }
                }
                r_criteriaDis += "\n";      // end of line
            }
        }

        criteriaSQL += ")";
        r_criteriaDis += ")";

        //are parenthes paired correctly?
        int nLeft = 0;
        for (int i = 0; i < criteriaSQL.length(); i++)
        {
            String c = criteriaSQL.substring(i, i+1);
            if ("(".equals(c)) nLeft++;
            if (")".equals(c)) nLeft--;
            if (nLeft < 0)
            {
                break;
            }
        }
        if (nLeft != 0)
        {
            err += "Syntax Error detected, right parenthes not match left parenthes";
        }

        if (!"".equals(err))
        {
            throw new Exception(err);
        }

        if (r_criteriaDis.equals("()")) r_criteriaDis = "None";
        if (criteriaSQL.equals("()")) criteriaSQL = "";

        ArrayList lst= new ArrayList();
        lst.add(criteriaSQL);
        lst.add(r_criteriaDis);
        return lst;
    }
	
    private String GetValueListCrystal(String sValue, String sFieldType) throws Exception
    {
        StringBuffer sResult = new StringBuffer();
        sResult.append("[");
        String[] sVals = sValue.split(",");
        for (int i = 0; i < sVals.length; i++)
        {
            if (i > 0) sResult.append(",");
            String s = sVals[i].trim();
            if ("D".equals(sFieldType))
            {
//                s = CRDate(Utility.GetSysDate(s), false);
            		Date dt=Utility.GetSysDate(s);
//                s = "CDATE(" + String.valueOf(dt.getYear()) + "," + String.valueOf(dt.getMonth()) + "," + String.valueOf(dt.getDay()) + ")";
	            	Calendar c1 = Calendar.getInstance();
	            	c1.setTime(dt);
	            	s = "CDATE(" + String.valueOf(c1.get(Calendar.YEAR)) + "," + String.valueOf(c1.get(Calendar.MONTH)+1) + "," + c1.get(Calendar.DAY_OF_MONTH) + ")";
            	
            }
            else if ("S".equals(sFieldType))
            {
                s = "\"" + s + "\"";
            }
            sResult.append(s);
        }
        sResult.append("]");
        return sResult.toString();
    }

    private String CRDate(Date dt,boolean isDateFieldString)
    {
        String sDt;
        if (isDateFieldString)
        {
            sDt = "'" + Utility.FormatDate(dt, "yyyy-mm-dd") + "'";
        }
        else
        {
        	Calendar c1 = Calendar.getInstance();
        	c1.setTime(dt);
        	sDt = "CDATE(" + String.valueOf(c1.get(Calendar.YEAR)) + "," + String.valueOf(c1.get(Calendar.MONTH)+1) + "," + c1.get(Calendar.DAY_OF_MONTH) + ")";
        }
        return sDt;
    }
    
    private String PaintReport(HttpServletRequest request, HttpServletResponse response, String criteriaString,  String orgDis, String criteriaDis)
    throws Exception {
	    	String loginId = (String)request.getSession(true).getAttribute("user");
	    	String sessionId = request.getSession(true).getId();
	    	
	        ReportClientDocument reportDocument1 = new ReportClientDocument();
	        String jspPath="";
		    try{
		         jspPath = getServlet().getServletContext().getResource("/").getPath();
		    }catch(Exception ex){
		    	  ;
		    }
		    String path1 =  "PMmodule/reports/RptFiles/" + _rptOption.getRptFileName();
		    String path=jspPath  + path1;
		    if(path.substring(2, 3).equals(":")){  //for Windows System
		      	path=path.substring(1);
		    }
	      
		    try{
		    	reportManager.DownloadRptFile(path, _rptOption.getRptFileNo());
		    }catch(Exception ex){
	       	  	System.out.print(ex.getMessage());
	       	  	System.out.print("loading rpt from " + path1);
	       	  	System.out.print("download rpt to " + path);
	       	    throw ex;
		    }
	      
		    try{
//		    	viewRpt(path1,request, response);
	    	
		    	reportDocument1.open(path1,0);
		    	if (!Utility.IsEmpty(criteriaString))  reportDocument1.setRecordSelectionFormula(criteriaString);
		    	if (_rptValue.getExportFormatType()==ReportExportFormat._PDF)
		    	{
		    		ExportReport(request, response, reportDocument1,orgDis, criteriaDis);
		    		return "";
		    	}
		    	else
		    	{
		    		ViewReport(request, response, reportDocument1,orgDis, criteriaDis);
		    		return "view";
		    	}
	      }catch(ReportSDKException ex){
		      throw new Exception(ex.getMessage());
	      }
	      catch(ReportSDKExceptionBase ex)
	      {
	    	  throw new Exception(ex);
	      }	
   }
        
	private Fields getParameterFieldValues(ReportClientDocument reportDocument1, String loginId,String sessionId, String orgDis, String criteriaDis) throws ReportSDKException
	{
	      String userName = _rptValue.getAuthor();
	  	  com.crystaldecisions.reports.sdk.DataDefController ddf = reportDocument1.getDataDefController();
	  	  
		  Fields fields = ddf.getDataDefinition().getParameterFields();
		  Fields fields2 = new Fields();
		  
		  for (Iterator it = fields.iterator(); it.hasNext();){
			ParameterField pfield = (ParameterField)it.next();
			String fieldName = pfield.getName();
		    
	 	    ParameterField pfield2 = new ParameterField();
	 	    pfield2.setName(fieldName);
	 	    
	 	    ParameterFieldDiscreteValue pfieldDV = new ParameterFieldDiscreteValue();
		    fieldName=fieldName.toLowerCase();
			if(fieldName.equals("daterange")){
			    pfieldDV.setValue(_dateRangeDis);
		    }else if(fieldName.equals("organization")){
			    pfieldDV.setValue(orgDis);
		    }else if(fieldName.equals("criteria")){
			    pfieldDV.setValue(criteriaDis);
		    }else if(fieldName.equals("username")){
			    pfieldDV.setValue(userName);
		    }else if(fieldName.equals("userid")){
			    pfieldDV.setValue(loginId);
		    }else if(fieldName.equals("reporttitle")){
			    pfieldDV.setValue(_rptValue.getTitle());
		    }else if(fieldName.equals("reporttitle2")){
			    pfieldDV.setValue(_rptOption.getOptionTitle());
		    }else if(fieldName.equals("reporttitle3")){
		 	    if(_rptValue.getReportTemp()!=null){
			       if(_rptValue.getReportTemp().getDesc()!=null)
		 	    	 pfieldDV.setValue(_rptValue.getReportTemp().getDesc());
			       else
		   	         pfieldDV.setValue("");
		 	    }else{
		 	       pfieldDV.setValue("");
		 	    }
		    }else if(fieldName.equals("sessionid")){
			    pfieldDV.setValue(sessionId);
		    }
		    else
		    {
			    pfieldDV.setValue("");
		    }
	 	    Values vals = new Values();
	 	    vals.add(pfieldDV);
	 	    pfield2.setCurrentValues(vals);
	 	    fields2.add(pfield2);
		}
		return fields2;
	}
	private void ExportReport(HttpServletRequest request, HttpServletResponse response,ReportClientDocument reportDocument1, String orgDis, String criteriaDis)throws ReportSDKExceptionBase 
	{
	      /* export using the ReportExportControl */
		  ReportExportControl exportControl = new ReportExportControl();
    	  String loginId = (String)request.getSession(true).getAttribute("user");
    	  String sessionId = request.getSession(true).getId();
    	  String userName = (String)request.getSession(true).getAttribute(KeyConstants.SESSION_KEY_PROVIDERNAME);
    	  _rptValue.setAuthor(userName);
    	  exportControl.setReportSource(reportDocument1.getReportSource());
          exportControl.setParameterFields(getParameterFieldValues(reportDocument1, loginId, sessionId, orgDis, criteriaDis));
  		  ExportOptions expOpts = new ExportOptions();
          switch (_rptValue.getExportFormatType()){
            case ReportExportFormat._PDF:
        		  expOpts.setExportFormatType(ReportExportFormat.PDF);
               break;
            case ReportExportFormat._MSExcel:
        		  expOpts.setExportFormatType(ReportExportFormat.recordToMSExcel);
               break;
            case ReportExportFormat._MSWord:
        		  expOpts.setExportFormatType(ReportExportFormat.MSWord);
              break;
            case ReportExportFormat._text:
        		  expOpts.setExportFormatType(ReportExportFormat.tabSeparatedText);
        		  TextExportFormatOptions tOpts = new TextExportFormatOptions();
               break;
            default:
               break;
          }
    	  exportControl.setExportOptions(expOpts);
    	  exportControl.setExportAsAttachment(false);
    	  exportControl.processHttpRequest(request, response, getServlet().getServletContext(), null);
    	  exportControl.dispose(); 
	}
	private void viewRpt(String reportName,HttpServletRequest request,HttpServletResponse response)
	{

		try {

			IReportSourceFactory2 rptsrcFac=new JPEReportSourceFactory();
			IReportSource reportSource=(IReportSource)rptsrcFac.createReportSource(reportName,request.getLocale());
		
			ConnectionInfos connInfos = new ConnectionInfos();
			IConnectionInfo connInfo1 = new ConnectionInfo();
			String DBUSERNAME = "quatroshelter";
			String DBPASSWORD = "qsreader";
		
			String SERVER = "192.168.0.207";
			String CONNECTION_URL = "jdbc:oracle:thin:@192.168.0.207:1521:smisCL";
			String DATABASE_CLASSNAME = "oracle.jdbc.OracleDriver";
			String DATABASE_DLL = "crdb_jdbc.dll";
			String JDBC_CONNECTION_STRING = "Use JDBC=b(true);Connection URL=s(jdbc:oracle:thin:@192.168.0.207:smisCL);" +
			"Database Class Name=s(oracle.jdbc.driver.OracleDriver);Server=s(QGSHELTER) ;" +
			"User ID=;Password=;Database=s(dbname);Trusted_Connection=b(false) ;" +
			"JDBC Connection String=s(!oracle.jdbc.OracleDriver!jdbc:oracle:thin:@192.168.0.207:1521:smisCL;" +
			"DatabaseName={database};user={userid};password={password}!)";
		
		
			PropertyBag propertyBag = new PropertyBag();
			propertyBag.put("Use JDBC", "true");
//			propertyBag.put("Connection URL", CONNECTION_URL);
//			propertyBag.put("Database Class Name", DATABASE_CLASSNAME);
//			propertyBag.put("Database DLL", DATABASE_DLL);
			propertyBag.put("Server Type", "JDBC (JNDI)");
//			propertyBag.put("Server", SERVER);
			propertyBag.put("Trusted_Connection", "False");
//			propertyBag.put("JDBC Connection String", JDBC_CONNECTION_STRING);
//			propertyBag.put("JDBC Connection JNDI Connection Name", "java:QGSHELTER");
		
			connInfo1.setUserName(DBUSERNAME);
			connInfo1.setPassword(DBPASSWORD);
		
		
			connInfo1.setAttributes(propertyBag);
			connInfos.add(connInfo1);

			/*		
			Fields fields=new Fields();
			ParameterField paramfield=new ParameterField();
			Values vals=new Values();
			ParameterFieldDiscreteValue val=new ParameterFieldDiscreteValue();
			paramfield.setName("pop");
			val.setValue(pop);
			vals.add(val);
			paramfield.setCurrentValues(vals);
			fields.add(paramfield);
*/		
			CrystalReportViewer viewer=new CrystalReportViewer();
			viewer.refresh();
			viewer.setDatabaseLogonInfos(connInfos);
			viewer.setReportSource(reportSource);
//			viewer.setParameterFields(fields);
			viewer.setReuseParameterValuesOnRefresh(true);
			viewer.setHasPageBottomToolbar(false);
			viewer.setHasLogo(false);
			viewer.setOwnPage(true);
			viewer.setOwnForm(true);
			viewer.setEnableLogonPrompt(false);
			viewer.processHttpRequest(request, response, getServlet().getServletContext(), null);
			viewer.getReportSource().dispose();
			viewer.dispose();
		
		}
		catch(ReportSDKExceptionBase e) {
			System.out.print("ERROR in the connection"+e);
	
		}

	}
    private void ViewReport(HttpServletRequest request, HttpServletResponse response, ReportClientDocument reportDocument1, String orgDis, String criteriaDis)
    throws Exception {
    	CrystalReportViewer crystalReportViewer = new CrystalReportViewer();
        try{
			String loginId = (String)request.getSession(true).getAttribute("user");
			String sessionId = request.getSession(true).getId();
        	Fields fields = getParameterFieldValues(reportDocument1, loginId, sessionId, orgDis, criteriaDis);
			IReportSource reportSource = reportDocument1.getReportSource();
			request.getSession().setAttribute("reportSource", reportSource);
			request.getSession().setAttribute("paramFields", fields);
			
			Hashtable actionParam = new Hashtable();
			actionParam.put("method", "showReport");
			request.setAttribute("actionParam",actionParam);
		} catch(Exception ex2) {
         System.out.println(ex2.toString());
      }    
   }

   private String getDateSql(String startPeriod, String endPeriod)
   {
		String sDateSQL = "";
		
		String sDateField = "{" + _rptValue.getTableName() + "." + _rptOption.getDateFieldName() + "}";
		String sDateFieldDesc = _rptOption.getDateFieldDesc();
		if ("D".equals(_rptOption.getDateFieldType())){
		  if ("M".equals(_rptValue.getDatePart()))
		    sDateField = "CSTR(" + sDateField + ",\"yyyyMM\")";
		  else if ("Y".equals(_rptValue.getDatePart()))
		    sDateField = "CSTR(" + sDateField + ",\"yyyy\")";
		}
		
		if(_rptValue.getDateOption().equals("A")){
		   _dateRangeDis = sDateFieldDesc + " As of : " + startPeriod;
		   sDateSQL = sDateField + " = \"" + startPeriod + "\"";
		}else if(_rptValue.getDateOption().equals("G")){  // greater than
		   _dateRangeDis = sDateFieldDesc + " Since : " + startPeriod;
		   sDateSQL = sDateField + " >= \"" + startPeriod + "\"";
		}else if(_rptValue.getDateOption().equals("L")){
		   _dateRangeDis = sDateFieldDesc + " Upto : " + startPeriod;
		   sDateSQL = sDateField + " <= \"" + startPeriod + "\"";
		}else if(_rptValue.getDateOption().equals("B")){
		   _dateRangeDis = sDateFieldDesc + " Range : " + startPeriod + " - " + endPeriod;
		   sDateSQL = sDateField + " IN \"" + startPeriod + "\"";
		   sDateSQL = sDateSQL + " TO " + "\"" + endPeriod + "\"";
		}
		return sDateSQL;
   	}
    private String getDateSql(Date startDate, Date endDate)
    {
        String sStartDate = Utility.FormatDate(startDate);
		String sEndDate = Utility.FormatDate(endDate);

		String sDateField = "{" + _rptValue.getTableName() + "." + _rptOption.getDateFieldName() + "}";
        String sDateFieldDesc = _rptOption.getDateFieldDesc();
        
        String sDateSQL = "";
        boolean  isDateFieldString = "S".equals(_rptOption.getDateFieldType());
        String sDateOption=_rptValue.getDateOption();
        if(sDateOption.equals("A")){
           _dateRangeDis = sDateFieldDesc + " As of : " + sStartDate;
           sDateSQL = sDateField + " = " + CRDate(startDate,isDateFieldString);
        }
        else if(sDateOption.equals("G")){  // greater than
           _dateRangeDis = sDateFieldDesc + " Since : " + sStartDate;
           sDateSQL = sDateField + " >= " + CRDate(startDate,isDateFieldString);
        }
        else if(sDateOption.equals("L")){
           _dateRangeDis = sDateFieldDesc + " Upto : " + sStartDate;
           sDateSQL = sDateField + " <= " + CRDate(startDate,isDateFieldString);
        }
        else if(sDateOption.equals("B")){
           if(startDate!=null && endDate!=null){
        	 _dateRangeDis = sDateFieldDesc + " Range : " + sStartDate + " - " + sEndDate;
             sDateSQL = sDateField + " IN " + CRDate(startDate,isDateFieldString);
             sDateSQL = sDateSQL + " TO " + CRDate(endDate,isDateFieldString);
           }
        }
        return sDateSQL;
    }
}
