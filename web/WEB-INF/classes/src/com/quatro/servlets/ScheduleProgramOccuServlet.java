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
package com.quatro.servlets;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.sql.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.dao.ProgramOccupancyDao;
import org.oscarehr.PMmodule.model.FieldDefinition;
import org.oscarehr.PMmodule.model.SdmtIn;
import org.oscarehr.PMmodule.model.SdmtOut;
import org.oscarehr.PMmodule.service.ProgramOccupancyManager;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.quatro.common.KeyConstants;
import com.quatro.util.Utility;

import oscar.MyDateFormat;
import oscar.OscarProperties;
import oscar.util.BeanUtilHlp;

public class ScheduleProgramOccuServlet extends HttpServlet {
	 
	  private static final Logger logger = LogManager.getLogger(ScheduleProgramOccuServlet.class);

	    private static final Timer programOccuTimer = new Timer(true);
	    private static final Timer intakeTimer = new Timer(true);
	    private static ProgramOccuTimerTask programOccuTimerTask = null;
	    private static IntakeTimerTask intakeTimerTask = null;
	    private static boolean runAsPrevousDay = true;
	    private static ProgramOccupancyManager programOccupancyManager = null;
	    private static String path= "";
	    private static int batchNo=0;
	    public static class ProgramOccuTimerTask extends TimerTask {
	    	String providerNo="1111";
	        public void run() {
	            logger.debug("ProgramOccuTimerTask timerTask started.");	
	            try {
	            	Calendar dt = Calendar.getInstance();
	            	if(runAsPrevousDay) dt.add(Calendar.DATE, -1);

	            	
	            	// delete old redirect entries if any	            	
	                programOccupancyManager.deleteProgramOccupancy(dt);
	                programOccupancyManager.insertProgramOccupancy(providerNo, dt);

	            	// READ INPUT FROM SDMT
	                inputSDMT(path);
	                
	                // WRITE OUTPUT FOR SDMT
	                programOccupancyManager.insertSdmtOut();
	                outputSDMT(path, programOccupancyManager.getSdmtOutList(dt, true));
	                if(batchNo>0) programOccupancyManager.updateSdmtOut(batchNo);

	                programOccuTimerTask.cancel();
	                scheduleNextRun();
	            }
	            catch (Exception e) {
	                logger.error("Error to generate the occupancy records. Re-scheduled to run in 5 minutes", e);
	                Calendar cal = Calendar.getInstance();
	                cal.add(Calendar.MINUTE, 5);
	                scheduleNextRun(cal);
	            }
	            logger.debug("ProgramOccuTimerTask timerTask completed.");
	        }
	       protected static void inputSDMT(String pathLoc){	        	
				String filename = "";	
				String inPath =StringUtils.trimToNull(OscarProperties.getInstance().getProperty("SDMT_IN_PATH"));
				String archivePath =StringUtils.trimToNull(OscarProperties.getInstance().getProperty("SDMT_IN_ARCHIVE_PATH"));
				File dir = new File(inPath);
			    String[] list = dir.list();
			    if(list == null) return;
			    for (int i = 0; i < list.length; i++) {
			        if(list[i].indexOf(".txt")>0) 
			        {
			        	filename =list[i];
			    
					    if(Utility.IsEmpty(filename)) continue;
						BeanUtilHlp buHlp = new BeanUtilHlp();
						FileReader fstream = null;
						try {
							fstream = new FileReader(inPath + filename);
						}
						catch(java.io.FileNotFoundException e)
						{
							continue;
						}
						BufferedReader in = new BufferedReader(fstream);
						try {
							// java.io.FileOutputStream os = new java.io.FileOutputStream(path +
							// "/out/" + filename);
							//StringBuffer sb = new StringBuffer();
							
							ArrayList tempLst = Utility.getTemplate(pathLoc, "/in/template/","sdmt_in_template.txt");
							String rStr="";
							SdmtIn sdVal = new SdmtIn();
							while((rStr=in.readLine())!=null) {
								String [] fds = rStr.split(";");
								for (int j = 0; j < tempLst.size(); j++) {
									FieldDefinition fd = (FieldDefinition) tempLst.get(j);
									String value = "";
									if (fds.length > 1) {
										value = fds[j];
										if(value.length() > fd.getFieldLength().intValue()) {
											value = value.substring(0,fd.getFieldLength().intValue());
										}
									}
									else
									{
										value =  rStr.substring(fd.getFieldStartIndex().intValue()-1,fd.getFieldLength().intValue()+fd.getFieldStartIndex().intValue()-1).trim();
									}
									buHlp.setPropertyValue(sdVal, fd.getFieldName(),fd.getFieldType(),fd.getDateFormatStr(), value);
								}	
								sdVal.setRecordId(new Integer(0));
								sdVal.setLastUpdateUser("1111");
								sdVal.setLastUpdateDate(Calendar.getInstance());
								programOccupancyManager.insertSdmtIn(sdVal);
							}
						}
				        catch (Exception e) {
				        	logger.error("Sdmt import: " + e.getMessage());
							System.out.println("Sdmt in:" +e.getMessage());
				        }
				        finally
				        {
				        	try 
				        	{
				        		in.close();
				        	}
				        	catch(IOException e)
				        	{
				        		;
				        	}
				        }
				        try 
				        {
							File file = new File(inPath + filename);
							Calendar now = Calendar.getInstance();
							File toFile = new File(archivePath + filename + "." + Utility.FormatDate(now.getTime(), "yyyyMMddHHmmss"));
							file.renameTo(toFile);
						}
				        catch(Exception e)
				        {
				        	;
				        }
			        }
			    }
	        }

	       protected static void outputSDMT(String pathLoc, List clientInfo) {				
				int year = Calendar.getInstance().get(Calendar.YEAR);
				int month = Calendar.getInstance().get(Calendar.MONTH)+1;
				int day = Calendar.getInstance().get(Calendar.DATE);
				int hour = Calendar.getInstance().get(Calendar.HOUR);
				int min = Calendar.getInstance().get(Calendar.MINUTE);
				String filename = Utility.FormatIntNoWithZero(year, 4)+ Utility.FormatIntNoWithZero(month,2) + Utility.FormatIntNoWithZero(day,2) + Utility.FormatIntNoWithZero(hour,2) + Utility.FormatIntNoWithZero(min,2) + ".out";
				BeanUtilHlp buHlp = new BeanUtilHlp();
				try {
					// java.io.FileOutputStream os = new java.io.FileOutputStream(path +
					// "/out/" + filename);
					FileWriter fstream = new FileWriter(StringUtils.trimToNull(OscarProperties.getInstance().getProperty("SDMT_OUT_PATH")) + filename);
					BufferedWriter out = new BufferedWriter(fstream);
					//StringBuffer sb = new StringBuffer();
					
					ArrayList tempLst = Utility.getTemplate(pathLoc, "/out/template/","sdmt_out_template.txt");
					for (int i = 0; i < clientInfo.size(); i++) {
						SdmtOut sdVal = (SdmtOut) clientInfo.get(i);
						String outStr="";
						for (int j = 0; j < tempLst.size(); j++) {
							FieldDefinition fd = (FieldDefinition) tempLst.get(j);
							Object value = buHlp.getPropertyValue(sdVal, fd.getFieldName());
							String val1 =  Utility.FormatString("", fd.getFieldLength().intValue());
							if (value != null)
							{
								if("batchNumber".equals(fd.getFieldName())) 
									{
										batchNo=Integer.valueOf(value.toString()).intValue();								
									}							
								if("S".equals(fd.getFieldType())) val1=Utility.FormatString((String)value, fd.getFieldLength().intValue());
								else if("N".equals(fd.getFieldType())) val1=Utility.FormatNumber(value.toString(), fd.getFieldLength().intValue());
								else 
									val1 = Utility.FormatDate(((Calendar)value).getTime(), fd.getDateFormatStr());
							}
							outStr+=val1;
						}	
						out.write(outStr);
						out.newLine(); 						
					}					
					out.close();
				} catch (Exception e) {
					String err=e.getMessage();
				}

			}
	    }

	    public static class IntakeTimerTask extends TimerTask {
	    	String providerNo="1111";
	        public void run() {
	            logger.debug("IntakeTimerTask timerTask started.");	
	            try {
	            	Calendar dt = Calendar.getInstance();
	                
	                DeactiveBedIntake();
	                DeactiveServiceIntake();
	                intakeTimerTask.cancel();
	                scheduleNextRunIntake();
	            }
	            catch (Exception e) {
	                logger.error("Error to deactivate intakes. Re-scheduled to run in 5 minutes", e);
	                Calendar cal = Calendar.getInstance();
	                cal.add(Calendar.MINUTE, 5);
	                scheduleNextRunIntake(cal);
	            }
	            logger.debug("intakeTimerTask timerTask completed.");
	        }
	        protected static void DeactiveServiceIntake(){
	        	try{
	        		programOccupancyManager.DeactiveServiceIntake();	        	
		        	logger.info("Deactivating Service Intake completed");
	        	}catch (Exception e) {
		        	logger.error("Deactivating Service Intake Error: " + e.getMessage());
		        }
	        }
			protected static void DeactiveBedIntake(){
				try{
	        		programOccupancyManager.DeactiveBedIntake();	        	
		        	logger.info("Deactivating Bed Intake completed");
	        	}catch (Exception e) {
		        	logger.error("Deactivating Bed Intake: " + e.getMessage());
					System.out.println("Deactivating Bed Intake:" +e.getMessage());
		        }
			}

	    }	    
	    private static long getDelayTime(String startTime){
	    	long delayTime=0;
	    	Integer hr=Integer.valueOf(startTime.substring(0,2));
        	Integer min=Integer.valueOf(startTime.substring(2));
        	Calendar now=Calendar.getInstance();
        	Calendar start = Calendar.getInstance();
        	start.set(Calendar.HOUR_OF_DAY,hr.intValue());
        	start.set(Calendar.MINUTE, min.intValue());
        	if(start.after(now)) delayTime=start.getTimeInMillis()-now.getTimeInMillis();
        	else{
        		 delayTime=now.getTimeInMillis()-start.getTimeInMillis()+24*60*60*1000;
        	}
	    	return delayTime;
	    }
	    public void init(ServletConfig servletConfig) throws ServletException {
	        super.init(servletConfig);
	        // yes I know I'm setting static variables in an instance method but it's okay.
	        WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletConfig.getServletContext());	       
	        programOccupancyManager  = (ProgramOccupancyManager)webApplicationContext.getBean("programOccupancyManager");
	        try {
	        	path=getServletContext().getResource("/").getPath();
	        }
	        catch(Exception e)
	        {
	        	;
	        }
	        scheduleNextRun();
	        scheduleNextRunIntake();
	    }

	    public void destroy() {
	        programOccuTimer.cancel();
	        super.destroy();
	    }

	    /**
	     */
	    public void doGet(HttpServletRequest request, HttpServletResponse response) throws java.io.IOException, javax.servlet.ServletException {
	        try {
		       
	           //Calendar dt = Calendar.getInstance();
               //dt.add(Calendar.DATE, -2);
	           //IntakeTimerTask.DeactiveServiceIntake();
		       //IntakeTimerTask.DeactiveBedIntake();
               //programOccupancyManager.insertSdmtOut();
	           //ProgramOccuTimerTask.outputSDMT(path, programOccupancyManager.getSdmtOutList(Calendar.getInstance(), true));
	           //ProgramOccuTimerTask.inputSDMT(path);
	           return;
	           
	        }
	        catch (Exception e) {
	            logger.error("Error processing request. " + request.getRequestURL() + ", " + e.getMessage());
	            logger.debug(e);
	            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
	            return;
	        }
	    }
	    
	    private static void scheduleNextRun()
	    {
	        String sTime = StringUtils.trimToNull(OscarProperties.getInstance().getProperty("PROGRAM_OCCUPANCY_STARTTIME"));
	        String previousDay = StringUtils.trimToNull(OscarProperties.getInstance().getProperty("PROGRAM_OCCUPANCY_PREVIOUSDAY"));
	        if (sTime == null) return;
	        runAsPrevousDay = previousDay.toLowerCase().startsWith("y");
	        // dataRetentionTimeMillis = this.getDelayTime(temp);
	        String sHr = "";
	        String sMi = "";
	        if(sTime.indexOf(':')>0) {
	        	sHr=sTime.substring(0,2);
	        	sMi = sTime.substring(3);
	        }
	        else
	        {
	        	sHr=sTime.substring(0,2);
	        	sMi = sTime.substring(2);
	        }
            Calendar sDt = Calendar.getInstance();
        	sDt.set(Calendar.HOUR_OF_DAY,Integer.valueOf(sHr).intValue());
        	sDt.set(Calendar.MINUTE, Integer.valueOf(sMi).intValue());
        	sDt.set(Calendar.SECOND, 0);
        	sDt.set(Calendar.MILLISECOND, 0);
        	Calendar now = Calendar.getInstance();
        	if ((now.getTimeInMillis() - sDt.getTimeInMillis()) > 0) {
        		sDt.add(Calendar.DATE, 1);
        	}
            	
	        programOccuTimerTask = new ProgramOccuTimerTask();		
	        programOccuTimer.schedule(programOccuTimerTask,sDt.getTime());
	    }
	    private static void scheduleNextRun(Calendar startDate)
	    {
	        programOccuTimerTask = new ProgramOccuTimerTask();		
	        programOccuTimer.schedule(programOccuTimerTask,startDate.getTime());
	    }
	   
	    private static void scheduleNextRunIntake()
	    {
	        String sTime = StringUtils.trimToNull(OscarProperties.getInstance().getProperty("DEACTIVE_INTAKE_START_TIME"));
	        if (sTime == null) return;
	        String sHr = "";
	        String sMi = "";
	        if(sTime.indexOf(':')>0) {
	        	sHr=sTime.substring(0,2);
	        	sMi = sTime.substring(3);
	        }
	        else
	        {
	        	sHr=sTime.substring(0,2);
	        	sMi = sTime.substring(2);
	        }
            Calendar sDt = Calendar.getInstance();
        	sDt.set(Calendar.HOUR_OF_DAY,Integer.valueOf(sHr).intValue());
        	sDt.set(Calendar.MINUTE, Integer.valueOf(sMi).intValue());
        	sDt.set(Calendar.SECOND, 0);
        	sDt.set(Calendar.MILLISECOND, 0);
        	Calendar now = Calendar.getInstance();
        	if ((now.getTimeInMillis() - sDt.getTimeInMillis()) > 0) {
        		sDt.add(Calendar.DATE, 1);
        	}
            	
	        intakeTimerTask = new IntakeTimerTask();		
	        intakeTimer.schedule(intakeTimerTask,sDt.getTime());
	    }
	    private static void scheduleNextRunIntake(Calendar startDate)
	    {
	        intakeTimerTask = new IntakeTimerTask();		
	        intakeTimer.schedule(intakeTimerTask,startDate.getTime());
	    }
}
