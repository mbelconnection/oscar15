package org.oscarehr.util;

import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.caisi_integrator.CaisiIntegratorUpdateTask;

import oscar.OscarProperties;

public class ContextStartupListener implements javax.servlet.ServletContextListener {
	private static final Logger logger = MiscUtils.getLogger();
	private static String contextPath = null;

	@Override
	public void contextInitialized(javax.servlet.ServletContextEvent sce) {
		try {
			// ensure cxf uses log4j
			System.setProperty("org.apache.cxf.Logger", "org.apache.cxf.common.logging.Log4jLogger");

			// need tc6 for this?
			// String contextPath=sce.getServletContext().getContextPath();

			// hack to get context path until tc6 is our standard.
			// /data/cvs/caisi_utils/apache-tomcat-5.5.27/webapps/oscar
			contextPath = sce.getServletContext().getRealPath("");
			int lastSlash = contextPath.lastIndexOf('/');
			contextPath = contextPath.substring(lastSlash + 1);

			logger.info("Server processes starting. context=" + contextPath);

			MiscUtils.addLoggingOverrideConfiguration(contextPath);

			OscarProperties properties = OscarProperties.getInstance();
			String vmstatLoggingPeriod = properties.getProperty("VMSTAT_LOGGING_PERIOD");
			VMStat.startContinuousLogging(Long.parseLong(vmstatLoggingPeriod));

			MiscUtils.setShutdownSignaled(false);
			MiscUtils.registerShutdownHook();

			CaisiIntegratorUpdateTask.startTask();

			logger.info("Server processes starting completed. context=" + contextPath);
		} catch (Exception e) {
			logger.error("Unexpected error.", e);
			throw (new RuntimeException(e));
		}
	}

	@Override
    public void contextDestroyed(javax.servlet.ServletContextEvent sce) {
		// need tc6 for this?
		// logger.info("Server processes stopping. context=" + sce.getServletContext().getContextPath());
		logger.info("Server processes stopping. context=" + contextPath);

		CaisiIntegratorUpdateTask.stopTask();
		VMStat.stopContinuousLogging();

		try {
			MiscUtils.checkShutdownSignaled();
			MiscUtils.deregisterShutdownHook();
			MiscUtils.setShutdownSignaled(true);
		} catch (ShutdownException e) {
			// do nothing it's okay.
		}
	}
}