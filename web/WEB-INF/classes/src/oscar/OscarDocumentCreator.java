package oscar;

import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JRResultSetDataSource;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.JRCsvExporter;
public class OscarDocumentCreator {
  public static final String PDF = "pdf";
  public static final String CSV = "csv";

  public OscarDocumentCreator() {

  }

  public InputStream getDocumentStream(String path) {
    InputStream reportInstream = null;
    reportInstream = getClass().getClassLoader().getResourceAsStream(path);
    return reportInstream;
  }

  public void fillDocumentStream(HashMap parameters, OutputStream sos,
                                 String docType, InputStream xmlDesign,
                                 Object dataSrc) {
    try {
      JasperReport jasperReport = null;
      JasperPrint print = null;
      jasperReport = getJasperReport(xmlDesign);
      if (dataSrc instanceof List) {
        JRDataSource ds = new JRBeanCollectionDataSource( (List) dataSrc);
        print = JasperFillManager.fillReport(jasperReport, parameters,
                                             ds);
      }
      else if (dataSrc instanceof java.sql.Connection) {
        print = JasperFillManager.fillReport(jasperReport, parameters,
                                             (Connection) dataSrc);
      }
      else if (dataSrc instanceof ResultSet) {
        JRDataSource ds = new JRResultSetDataSource( (ResultSet) dataSrc);
        print = JasperFillManager.fillReport(jasperReport, parameters,
                                             ds);
      }
      else
      {
          JRDataSource ds = (JRDataSource)dataSrc;
          print = JasperFillManager.fillReport(jasperReport, parameters,ds);
      }
      if (docType.equals(this.PDF)) {
        JasperExportManager.exportReportToPdfStream(print, sos);
      }
      else if (docType.equals(this.CSV)) {
        this.exportReportToCSVStream(print, sos);

      }

      //System.err.println(sos);
    }
    catch (JRException ex) {
      ex.printStackTrace();
    }
  }

  /**
   * Returns a JasperReport instance reprepesenting the supplied InputStream
   * @param xmlDesign InputStream
   * @return JasperReport
   */
  public JasperReport getJasperReport(InputStream xmlDesign) {
    JasperReport jasperReport = null;
    try {
      jasperReport = JasperCompileManager.compileReport(
          xmlDesign);
    }
    catch (JRException ex) {
      ex.printStackTrace();
    }
    return jasperReport;
  }

  /**
   * Fills a servletoutout stream with data from a JasperReport
   * @param jasperPrint JasperPrint
   * @param sos ServletOutputStream
   * @throws JRException
   */
  private void exportReportToCSVStream(JasperPrint jasperPrint,
                                       OutputStream sos) throws
      JRException {
    JRCsvExporter exp = new JRCsvExporter();
    exp.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
    exp.setParameter(JRExporterParameter.OUTPUT_STREAM, sos);
    exp.exportReport();
  }

}