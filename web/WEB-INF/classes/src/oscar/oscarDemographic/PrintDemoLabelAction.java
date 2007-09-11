package oscar.oscarDemographic;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.oscarehr.util.SpringUtils;

import oscar.OscarAction;
import oscar.OscarDocumentCreator;
import oscar.util.SqlUtils;

public class PrintDemoLabelAction
    extends OscarAction {
  public PrintDemoLabelAction() {}

  public ActionForward execute(ActionMapping actionMapping,
                               ActionForm actionForm,
                               HttpServletRequest request,
                               HttpServletResponse response) {
    //patient
    String classpath = (String) request.getSession().getServletContext().
        getAttribute("org.apache.catalina.jsp_classpath");

    System.setProperty("jasper.reports.compile.class.path", classpath);

    HashMap parameters = new HashMap();
    parameters.put("demo", request.getParameter("demographic_no"));
    ServletOutputStream sos = null;
    FileInputStream ins = null;
    System.err.println("ROOT: " + System.getProperty("user.home"));
    try {
      ins = new FileInputStream(System.getProperty("user.home") + "/label.xml");
    }
    catch (FileNotFoundException ex1) {
      ex1.printStackTrace();
    }

      try {
        sos = response.getOutputStream();
      }
      catch (IOException ex) {
        ex.printStackTrace();
      }

    response.setHeader("Content-disposition", getHeader(response).toString());
    OscarDocumentCreator osc = new OscarDocumentCreator();
    
    Connection c=null;
    try
    {
        c=SpringUtils.getDbConnection();
        osc.fillDocumentStream(parameters, sos, "pdf",ins,c);
    }
    catch (SQLException e)
    {
        e.printStackTrace();
    }
    finally
    {
        SqlUtils.closeResources(c, null , null);
    }
    
    return actionMapping.findForward(this.target);
  }

  private StringBuffer getHeader(HttpServletResponse response) {
    StringBuffer strHeader = new StringBuffer();
    strHeader.append("label_");
    strHeader.append(".pdf");
    response.setHeader("Cache-Control", "max-age=0");
    response.setDateHeader("Expires", 0);
    response.setContentType("application/pdf");
    StringBuffer sbContentDispValue = new StringBuffer();
    sbContentDispValue.append("inline; filename="); //inline - display
    sbContentDispValue.append(strHeader);
    return sbContentDispValue;
  }
}
