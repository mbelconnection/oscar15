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

package oscar.util;

import java.util.Timer;
import java.util.TimerTask;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.oscarehr.util.DbConnectionFilter;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.ShutdownException;

/**
 *
 * <p>Title:AlertTimer </p>
 *
 * <p>Description: </p>
 * AlertTimer is responsible for managing the execution Schedule of the CDM Reminders(or any other future alerts)
 * at regular intervals.
 * @author not Joel Legris
 * @version 1.0
 */
public class AlertTimer {
	private static Logger logger=LogManager.getLogger(AlertTimer.class);
	
	private static AlertTimer alerts = null;
    private static Timer timer;
    String alertCodes[] = null;
    oscar.oscarBilling.ca.bc.MSP.CDMReminderHlp hlp = null;

    private AlertTimer(String[] codes, long interval) {
        timer = new Timer("AlertTimer", true);
        alertCodes = codes;
        hlp = new oscar.oscarBilling.ca.bc.MSP.CDMReminderHlp();
        //triggers alerts 5 seconds after instantiation
        timer.scheduleAtFixedRate(new ReminderClass(), 5000, interval);
    }

    public static AlertTimer getInstance(String[] codes, long interval) {
        if (alerts == null) {
            alerts = new AlertTimer(codes, interval);
        }
        return alerts;
    }

    /**
     * The helper class which is responsible for triggering the alerts
     */
    class ReminderClass extends TimerTask {
        public void run() {
    		LoggedInInfo.setLoggedInInfoToCurrentClassAndMethod();
            try {
                hlp.manageCDMTicklers(alertCodes);
            }
            catch (ShutdownException e) {
            	logger.debug("AlertTimer noticed shutdown signaled.");
            }
            catch (Exception e) {
                logger.error("unexpected error", e);
            }
            finally {
        		LoggedInInfo.loggedInInfo.remove();
                DbConnectionFilter.releaseAllThreadDbResources();
            }
        }
    }

}