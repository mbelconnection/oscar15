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
package org.oscarehr.PMmodule.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.upload.FormFile;
import org.apache.struts.upload.MultipartRequestHandler;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.service.AdmissionManager;
import org.oscarehr.PMmodule.service.ClientManager;
import org.oscarehr.PMmodule.service.ProgramManager;

import com.quatro.common.KeyConstants;
import com.quatro.service.IntakeManager;
import com.quatro.service.LookupManager;
import com.quatro.service.UploadFileManager;
import com.quatro.util.Utility;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.GregorianCalendar;
import com.quatro.model.Attachment;
import com.quatro.model.AttachmentText;
import com.quatro.model.security.NoAccessException;

public class UploadFileAction extends BaseClientAction {
	
	 private static Log log = LogFactory.getLog(UploadFileAction.class);
	 private UploadFileManager uploadFileManager;
	 private LookupManager lookupManager;
	 protected AdmissionManager admissionManager;	
	 protected ClientManager clientManager;
	 protected ProgramManager programManager;
     private IntakeManager intakeManager;

	public void setClientManager(ClientManager clientManager) {
		this.clientManager = clientManager;
	}
	
	public void setAdmissionManager(AdmissionManager admMgr){
		this.admissionManager = admMgr;
	}
	
	public void setUploadFileManager(UploadFileManager uploadFileManager) {
		this.uploadFileManager = uploadFileManager;
	}

	 public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		 return list(mapping, form, request, response);
	 }
	 private ActionForward list(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
			//DynaActionForm accessForm = (DynaActionForm)form;
		 List atts=null;
		 try {
			 DynaActionForm myform = (DynaActionForm)form;
			 Integer clientId = super.getClientId(request);
			 HashMap actionParam = (HashMap) request.getAttribute("actionParam");
	         if(actionParam==null){
	    	  actionParam = new HashMap();
	          actionParam.put("clientId", clientId.toString()); 
	         }
		     request.setAttribute("actionParam", actionParam);
			 super.setScreenMode(request, KeyConstants.TAB_CLIENT_ATTCHMENT);
		     
			 Boolean exc = (Boolean) request.getAttribute(MultipartRequestHandler.ATTRIBUTE_MAX_LENGTH_EXCEEDED);
			 if(exc != null && exc.equals(Boolean.TRUE)) {
		    	   ActionMessages messages= new ActionMessages();
		    	   messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.save.attachment_toolarge", request.getContextPath()));
			        saveMessages(request,messages);
				   return edit(mapping,form,request,response);
			  }
			   Integer currentFacilityId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
				String providerNo=(String) request.getSession().getAttribute("user");
	
		    	// attachment only for client 
			    Integer moduleId = KeyConstants.MODULE_ID_CLIENT;
			    String refNo = clientId.toString();			   
			   // List lstProgram = programManager.getPrograms(providerNo, currentFacilityId);
				atts=uploadFileManager.getAttachment(moduleId, refNo,providerNo,currentFacilityId);
			    request.setAttribute("att_files", atts);
				return mapping.findForward("list");
		   }
		   catch(NoAccessException e)
		   {
			   return mapping.findForward("failure");
		   }catch(Exception ex){
		    	request.setAttribute("att_files", atts);
				return mapping.findForward("list");
		   }
	}
	 public ActionForward addNew(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		 try {
			 super.getAccess(request, KeyConstants.FUN_CLIENTDOCUMENT, null, KeyConstants.ACCESS_WRITE);
			 DynaActionForm attForm = (DynaActionForm) form;
			 attForm.set("clientId",super.getClientId(request).toString());
			 Attachment attObj =(Attachment)attForm.get("attachmentValue");
			 attObj.setId(null);
			 super.setScreenMode(request, KeyConstants.TAB_CLIENT_ATTCHMENT);
			 List lst = lookupManager.LoadCodeList("DCT", true, null, null);
			 request.setAttribute("lstDocType", lst);
			 ActionMessages messages= new ActionMessages();
			 Integer cId=super.getClientId(request);   
			 
			 Integer moduleId = (Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_CURRENT_MODULE);
			 if(null==moduleId) moduleId=KeyConstants.MODULE_ID_CLIENT; 
			 if(null==cId){
				 messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("message.attachment.errors",request.getContextPath()));		 
				 saveMessages(request,messages);
			 }
			 else{
				 attObj.setModuleId(moduleId);
				 attObj.setRefNo(cId.toString());
			 }
			 attForm.set("attachmentValue", attObj);
			 return mapping.findForward("edit");
		   }
		   catch(NoAccessException e)
		   {
			   return mapping.findForward("failure");
		    }
		   catch(SQLException e)
		   {
				return mapping.findForward("failure");
		   }
	 }
	 public ActionForward edit(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		 try {
			 DynaActionForm attForm = (DynaActionForm) form;
			 AttachmentText attTextObj =(AttachmentText)attForm.get("attachmentText");
			 Attachment attObj = (Attachment)attForm.get("attachmentValue");
			 Integer clientId = super.getClientId(request);
			 attForm.set("clientId",clientId.toString());
	
			 Integer aId = null;
			 if(null!=request.getParameter("id")) {
				 aId= new Integer(request.getParameter("id"));
				 if(aId.intValue()>0)
					 attObj = uploadFileManager.getAttachmentDetail(aId);
				 attForm.set("attachmentValue", attObj);
			 }
			 else
			 {
				 aId = attObj.getId();
			 }
			 attForm.set("attachmentText",attTextObj);
			 

			 super.setScreenMode(request, KeyConstants.TAB_CLIENT_ATTCHMENT);
			 ActionMessages messages= new ActionMessages();
			       
			 Integer moduleId =KeyConstants.MODULE_ID_CLIENT;  //(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_CURRENT_MODULE);

			 if(aId.intValue() == 0)
			 {
				Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
	 			String providerNo=(String) request.getSession().getAttribute("user");
	 			String programId = this.clientManager.getRecentProgramId(clientId, providerNo, shelterId).toString();
	 			if(programId == null) throw new NoAccessException();
		        super.getAccess(request, KeyConstants.FUN_CLIENTDOCUMENT, Integer.valueOf(programId),KeyConstants.ACCESS_WRITE);
			 }
			 else
			    super.getAccess(request, KeyConstants.FUN_CLIENTDOCUMENT, attObj.getRefProgramId(),KeyConstants.ACCESS_UPDATE);
				 
			 
			 List lst = lookupManager.LoadCodeList("DCT", true, null, null);
			 request.setAttribute("lstDocType", lst);
			 return mapping.findForward("edit");
		   }
		   catch(NoAccessException e)
		   {
			   return mapping.findForward("failure");
		   }
		   catch(SQLException e)
		   {
				return mapping.findForward("failure");
		   }
	 }
	 public ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException{
		 Integer aId = new Integer(request.getParameter("id"));
		 Attachment attObj=uploadFileManager.getAttachmentDetail(aId);
	     super.getAccess(request, KeyConstants.FUN_CLIENTDOCUMENT, attObj.getRefProgramId(),KeyConstants.ACCESS_WRITE);
	       
		 if(null!=aId)uploadFileManager.deleteAttachment(aId);
		 return list(mapping, form, request, response);
	    }
	 public ActionForward save(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws NoAccessException {
		 DynaActionForm attForm = (DynaActionForm) form;
		 Attachment attObj = (Attachment )attForm.get("attachmentValue");
		 AttachmentText attTextObj =(AttachmentText)attForm.get("attachmentText");		 
			 Integer cId= super.getClientId(request);
		 	ActionMessages messages = new ActionMessages();
	        String dupMessage ="";
			HttpSession session = request.getSession(true);	
			//only for client module 
			Integer moduleId = KeyConstants.MODULE_ID_CLIENT;
			Integer shelterId=(Integer)request.getSession().getAttribute(KeyConstants.SESSION_KEY_SHELTERID);
			String providerNo=(String) session.getAttribute("user");
	        Integer programId = this.clientManager.getRecentProgramId(cId, providerNo, shelterId);
	        if(programId == null) throw new NoAccessException();
	        super.getAccess(request, KeyConstants.FUN_CLIENTDOCUMENT, programId,KeyConstants.ACCESS_WRITE);
			log.info("attachment client upload id: id="  + cId);
			FormFile formFile = attTextObj.getImagefile();			
			String type = formFile.getFileName().substring(formFile.getFileName().lastIndexOf(".")+1).toLowerCase();
			int count=0;		
			log.info("extension = " + type);
			if(Utility.IsEmpty(formFile.getContentType()) || formFile.getFileSize()==0){
				messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("error.save.attachment", request.getContextPath()));
		        saveMessages(request,messages);
				//return mapping.findForward("edit");	
		        return edit(mapping,form,request,response);
			}
			try {
				byte[] imageData = formFile.getFileData();
				Byte[] imageData2 = new Byte[imageData.length];
				for(int x=0;x<imageData.length;x++) {
					imageData2[x] = new Byte(imageData[x]);
				}
				attTextObj.setAttData(imageData);
				attTextObj.setRevDate(new GregorianCalendar());
				attObj.setFileName(formFile.getFileName());
				attObj.setFileType(type);
				attObj.setModuleId(moduleId);			 
				attObj.setProviderNo((String) session.getAttribute("user"));
				attObj.setRefNo(cId.toString());
				attObj.setRefProgramId(programId);
				attObj.setRevDate(new GregorianCalendar());
				attObj.setFileSize(new Integer(formFile.getFileSize()));
				attObj.setAttText(attTextObj);
				if(attObj.getId().intValue()==0) attObj.setId(null);
				uploadFileManager.saveAttachment(attObj);				
				attForm.set("attachmentValue",attObj);
				attForm.set("attachmentText", attObj.getAttText());
			}catch(Exception e) {
				log.error(e);
				//post error to page
			}
			count=uploadFileManager.getAttachment(cId.toString(), formFile.getFileName(), formFile.getFileSize());
			if(count>1) {
				dupMessage="Duplicate file name detected";
				messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("message.save.attachment.success_dup", request.getContextPath(),dupMessage));
			}
			else
			{
				messages.add(ActionMessages.GLOBAL_MESSAGE,new ActionMessage("message.save.attachment.success", request.getContextPath()));
			}
	        saveMessages(request,messages);
			//return mapping.findForward("edit");	
	        return edit(mapping,form,request,response);

	    }
	 	public void setLookupManager(LookupManager lookupManager) {
		this.lookupManager = lookupManager;
	}
		public void setProgramManager(ProgramManager programManager) {
			this.programManager = programManager;
		}

		public void setIntakeManager(IntakeManager intakeManager) {
			this.intakeManager = intakeManager;
		}
		public IntakeManager getIntakeManager() {
			return this.intakeManager;
		}

}
