
package oscar.oscarDemographic;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.oscarehr.util.DbConnectionFilter;
import org.oscarehr.util.MiscUtils;

import oscar.OscarAction;
import oscar.OscarDocumentCreator;
import oscar.OscarProperties;

public class PrintDemoLabelAction extends OscarAction {
    
    private static Logger logger = MiscUtils.getLogger();
	
    public PrintDemoLabelAction() {
    }

    public ActionForward execute(ActionMapping actionMapping, ActionForm actionForm, HttpServletRequest request, HttpServletResponse response) {
        //patient
        String classpath = (String)request.getSession().getServletContext().getAttribute("org.apache.catalina.jsp_classpath");
        if (classpath==null) classpath = (String)request.getSession().getServletContext().getAttribute("com.ibm.websphere.servlet.application.classpath");
        
        System.setProperty("jasper.reports.compile.class.path", classpath);

        HashMap<String,String> parameters = new HashMap<String,String>();
        parameters.put("demo", request.getParameter("demographic_no"));

        Integer apptNo = null;
        try {
            apptNo = Integer.parseInt(request.getParameter("appointment_no"));
        }catch(NumberFormatException e) {}

        String defaultLabelPath = System.getProperty("user.home") + "/label.xml";       
        String labelPath = OscarProperties.getInstance().getProperty("pdfLabelMRP",defaultLabelPath);
        String apptProviderLabelPath = OscarProperties.getInstance().getProperty("pdfLabelApptProvider","");

        if (apptNo != null && !apptProviderLabelPath.isEmpty()) {
            parameters.put("appt", String.valueOf(apptNo));
            labelPath = apptProviderLabelPath;
        }

        ServletOutputStream sos = null;
        InputStream ins = null;
        
        
        logger.debug("user home: " + System.getProperty("user.home"));
        try {
            ins = new FileInputStream(labelPath);
            logger.debug("loading from :" + labelPath + " " + ins);
        }
        catch (FileNotFoundException ex1) {
            logger.warn("label xml file not found at " + labelPath + " using default instead");
        }
        if (ins == null){
            try {
                ServletContext context = getServlet().getServletContext();
                ins = getClass().getResourceAsStream("/oscar/oscarDemographic/label.xml");
                logger.debug("loading from : /oscar/oscarDemographic/label.xml " + ins);
            }
            catch (Exception ex1) {MiscUtils.getLogger().error("Error", ex1);
            }
        }

        try {
            sos = response.getOutputStream();
        }
        catch (IOException ex) {MiscUtils.getLogger().error("Error", ex);
        }

        response.setHeader("Content-disposition", getHeader(response).toString());
        OscarDocumentCreator osc = new OscarDocumentCreator();
        try {
            osc.fillDocumentStream(parameters, sos, "pdf", ins, DbConnectionFilter.getThreadLocalDbConnection());
        }
        catch (SQLException e) {
            MiscUtils.getLogger().error("Error", e);
        }

        return actionMapping.findForward(this.target);
    }

    private StringBuilder getHeader(HttpServletResponse response) {
        StringBuilder strHeader = new StringBuilder();
        strHeader.append("label_");
        strHeader.append(".pdf");
        response.setHeader("Cache-Control", "max-age=0");
        response.setDateHeader("Expires", 0);
        response.setContentType("application/pdf");
        StringBuilder sbContentDispValue = new StringBuilder();
        sbContentDispValue.append("inline; filename="); //inline - display
        sbContentDispValue.append(strHeader);
        return sbContentDispValue;
    }
}
