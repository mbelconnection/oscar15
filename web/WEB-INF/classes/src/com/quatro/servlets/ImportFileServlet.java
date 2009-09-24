/*******************************************************************************
 * Copyright (c) 2008, 2009 Quatro Group Inc. and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU General Public License
 * which accompanies this distribution, and is available at
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Contributors:
 *     <Quatro Group Software Systems inc.>  <OSCAR Team>
 *******************************************************************************/
package com.quatro.servlets;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import org.oscarehr.PMmodule.model.FieldDefinition;
import org.oscarehr.PMmodule.model.SdmtIn;
import org.oscarehr.PMmodule.model.SdmtOut;
import org.oscarehr.PMmodule.service.ProgramOccupancyManager;

import org.oscarehr.util.SpringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import com.quatro.model.LookupCodeValue;
import oscar.OscarProperties;
import oscar.util.BeanUtilHlp;

import com.quatro.service.LookupManager;

public class ImportFileServlet extends HttpServlet {
	private static ProgramOccupancyManager programOccupancyManager = null;

	public void init(ServletConfig servletConfig) throws ServletException {
		super.init(servletConfig);
		WebApplicationContext webApplicationContext = WebApplicationContextUtils
				.getWebApplicationContext(servletConfig.getServletContext());
		programOccupancyManager = (ProgramOccupancyManager) webApplicationContext
				.getBean("programOccupancyManager");

	}

	public void destroy() {
		super.destroy();
	}

	/**
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws java.io.IOException, javax.servlet.ServletException {
		try {

			List list = programOccupancyManager.getSdmtOutList(Calendar
					.getInstance(), true);
			this.outputSDMT(request, list);
		} catch (Exception e) {

			response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
			return;
		}
	}

	protected ArrayList getTemplate(HttpServletRequest request, String dir,
			String filename) {
		FieldDefinition fDev = null; // clientImageMgr.getClientImage(demoNo);
		ArrayList list = new ArrayList();

		String path = request.getSession(true).getServletContext().getRealPath(
				"/");
		// String filename = "sdmt_out_template.txt";
		try {

			BufferedReader in = null;

			try {

				in = new BufferedReader(new FileReader(path + "/" + dir + "/"
						+ filename));
				String str;
				while ((str = in.readLine()) != null) {
					fDev = new FieldDefinition();
					fDev.setFieldName(str.substring(0, 30));
					fDev.setFieldLength(new Integer(str.substring(30, 35)));
					fDev.setFieldType(str.substring(35, 36));
					list.add(fDev);
				}
				in.close();

			} catch (IOException e) {
				// catch io errors from FileInputStream or readLine()
				System.out.println("Uh oh, got an IOException error!"
						+ e.getMessage());

			} finally {
				if (in != null)
					in.close();
			}

		} catch (Exception e) {
			// log.warn(e);
		}

		return list;
	}

	protected void outputSDMT(HttpServletRequest request, List clientInfo) {

		String path = request.getSession(true).getServletContext().getRealPath(
				"/");
		String year = (new Integer(Calendar.getInstance().YEAR)).toString();
		String month = (new Integer(Calendar.getInstance().MONTH)).toString();
		String day = (new Integer(Calendar.getInstance().DATE)).toString();
		String hour = (new Integer(Calendar.getInstance().HOUR)).toString();
		String min = (new Integer(Calendar.getInstance().MINUTE)).toString();
		String filename = year + month + day + hour + min + ".out";
		BeanUtilHlp buHlp = new BeanUtilHlp();
		try {
			// java.io.FileOutputStream os = new java.io.FileOutputStream(path +
			// "/out/" + filename);
			FileWriter fstream = new FileWriter(path + "/out/" + filename);
			BufferedWriter out = new BufferedWriter(fstream);
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < clientInfo.size(); i++) {
				SdmtOut sdVal = (SdmtOut) clientInfo.get(i);
				ArrayList tempLst = getTemplate(request, "/out/template/",
						"sdmt_out_template.txt");
				for (int j = 0; j < tempLst.size(); j++) {
					FieldDefinition fd = (FieldDefinition) tempLst.get(j);

					String value = buHlp.getPropertyValue(sdVal, fd
							.getFieldName()).toString();
					sb.append(value);
				}
				sb.append("\n");
			}
			out.write(sb.toString());
			out.close();
		} catch (Exception e) {
			// log.warn(e);
		}

	}

}
