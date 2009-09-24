/*
* 
* Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
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
* This software was written for 
* Centre for Research on Inner City Health, St. Michael's Hospital, 
* Toronto, Ontario, Canada  - UPDATED: Quatro Group 2008/2009
*/

package org.oscarehr.casemgmt.service;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.struts.util.LabelValueBean;
import org.oscarehr.PMmodule.dao.ClientDao;
import org.oscarehr.PMmodule.dao.ProviderDao;
import org.oscarehr.PMmodule.model.AccessType;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.Provider;
import org.oscarehr.PMmodule.model.QuatroIntakeFamily;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.service.ProgramManager;
import org.oscarehr.casemgmt.dao.AllergyDAO;
import org.oscarehr.casemgmt.dao.CaseManagementCPPDAO;
import org.oscarehr.casemgmt.dao.CaseManagementIssueDAO;
import org.oscarehr.casemgmt.dao.CaseManagementNoteDAO;
import org.oscarehr.casemgmt.dao.CaseManagementTmpSaveDAO;
import org.oscarehr.casemgmt.dao.ClientImageDAO;
//import org.oscarehr.casemgmt.dao.EchartDAO;
import org.oscarehr.casemgmt.dao.EncounterFormDAO;
//import org.oscarehr.casemgmt.dao.EncounterWindowDAO;
import org.oscarehr.casemgmt.dao.HashAuditDAO;
import org.oscarehr.casemgmt.dao.PrescriptionDAO;
import org.oscarehr.casemgmt.dao.ProviderSignitureDao;
import org.oscarehr.casemgmt.model.CaseManagementCPP;
import org.oscarehr.casemgmt.model.CaseManagementIssue;
import org.oscarehr.casemgmt.model.CaseManagementNote;
import org.oscarehr.casemgmt.model.CaseManagementSearchBean;
import org.oscarehr.casemgmt.model.CaseManagementTmpSave;
import org.oscarehr.casemgmt.model.EncounterWindow;
import org.oscarehr.casemgmt.model.HashAuditImpl;
import org.oscarehr.casemgmt.model.base.BaseHashAudit;
import org.oscarehr.common.dao.UserPropertyDAO;
import org.oscarehr.common.model.UserProperty;

import oscar.MyDateFormat;
import oscar.OscarProperties;

import com.quatro.dao.IntakeDao;
import com.quatro.dao.security.SecroleDao;
import com.quatro.dao.LookupDao;
import com.quatro.model.LookupCodeValue;
import com.quatro.model.security.Secrole;
import com.quatro.util.Utility;

public class CaseManagementManager {

    protected String issueAccessType = "access";
    protected CaseManagementNoteDAO caseManagementNoteDAO;
    protected CaseManagementIssueDAO caseManagementIssueDAO;
    protected CaseManagementCPPDAO caseManagementCPPDAO;
    protected AllergyDAO allergyDAO;
    protected PrescriptionDAO prescriptionDAO;
    protected EncounterFormDAO encounterFormDAO;
  //  protected EchartDAO echartDAO;
    protected ProviderDao providerDAO;
    protected ClientDao demographicDAO;
    protected ProviderSignitureDao providerSignitureDao;
    protected ClientImageDAO clientImageDAO;
//    protected RoleManager roleManager;
    protected CaseManagementTmpSaveDAO caseManagementTmpSaveDAO;    
    protected HashAuditDAO hashAuditDAO;
//    protected EncounterWindowDAO ectWindowDAO;
    protected UserPropertyDAO userPropertyDAO;
    protected IntakeDao intakeDao;
    protected SecroleDao secroleDao;  
    protected LookupDao lookupDao;
    
    /*
     *check to see if issue has been saved for this demo before
     *if it has return issue; else return null
     */
    public CaseManagementIssue getIssueById(String demo, String issue_id) {
        return this.caseManagementIssueDAO.getIssuebyId(demo,issue_id);
    }
    

    private ProgramManager programManager = null;
    public void setProgramManager(ProgramManager programManager) {
        this.programManager = programManager;
    }


    //retrieve list of providers who have edited specific note
    public void getEditors(CaseManagementNote note) {
        List providers;
        providers = this.caseManagementNoteDAO.getEditors(note);
        if( providers == null ) providers = new ArrayList();
        note.setEditors(providers);
    }
    
    //retrieves a list of providers that have been associated with each note
    //and stores this list in the coresponding note.
    public void getEditors(List notes) {
        Iterator iterator = notes.listIterator();
        List providers;
        while(iterator.hasNext()) {
            CaseManagementNote note = (CaseManagementNote)iterator.next();
            providers = this.caseManagementNoteDAO.getEditors(note);
            if( providers == null ) providers = new ArrayList();
            note.setEditors(providers);
        }
    }
    
    public UserProperty getUserProperty(String provider_no, String name) {
        return this.userPropertyDAO.getProp(provider_no, name);
    }
    
    public void saveUserProperty(UserProperty prop) {
        this.userPropertyDAO.saveProp(prop);
    }
/*    
    public void saveEctWin(EncounterWindow ectWin) {
        ectWindowDAO.saveWindowDimensions(ectWin);
    }
    
    public EncounterWindow getEctWin(String provider) {
        return this.ectWindowDAO.getWindow(provider);
    }
*/
    private String removeNoteAppend(String noteStr){
    	String newStr=noteStr;
    	int idx1 =noteStr.indexOf('[');
    	int idx2= noteStr.indexOf(']');    	
    	String tmpStr="";
    	if(idx2<idx1){
    		tmpStr=newStr.substring(0,idx2)+newStr.substring(idx2+1);    		
        	newStr=tmpStr;
        	return removeNoteAppend(newStr);
    	}
    	
    	if(idx1>0){
    		newStr =noteStr.substring(0,idx1)+noteStr.substring(idx2+1);
    		return removeNoteAppend(newStr);
    	}
    	else if(idx1==0){
    		newStr =noteStr.substring(idx2+1);
    		return removeNoteAppend(newStr);
    	}
    	else{
    		newStr=Utility.replace(newStr,"]", "");
    		newStr=Utility.replace(newStr,"[", "");
    	}
    	String[] lft = newStr.split("\n");
    	//remove \n from string
    	tmpStr="";
    	for(int i=0;i<lft.length;i++){
    		if(lft[i]!="" || !lft[i].startsWith("\t"))tmpStr+=lft[i]+"\n";
    	}
    	tmpStr=Utility.replace(tmpStr,"\t", "").trim();
    	return tmpStr;
    }
    public String saveNote(CaseManagementNote note, String cproviderNo, String lastStr) {
    	SimpleDateFormat dt = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    	Date now = new Date();
        String noteStr = note.getNote();
        String noteHistory = note.getHistory();     
        String userName=providerDAO.getProviderName(cproviderNo);
        // process noteStr, remove existing signed on string
        // noteStr = removeSignature(noteStr);
               /* formate the "/n" in noteStr */
        noteStr = noteStr.replaceAll("\r\n", "\n");
        noteStr = noteStr.replaceAll("\r", "\n");

        if (noteHistory == null) noteHistory = noteStr;
        else noteHistory = noteStr + "\n" + "   ----------------History Record----------------   \n" + noteHistory + "\n";

        //note.setNote(noteStr);
        //remove empty line 
        String tmpString ="";
        String[] his=noteHistory.split("\n");
        for(int i=0;i<his.length;i++){
        	if(his[i]!="" || !his[i].startsWith("\t")) tmpString+=his[i]+"\n";
        }        
        note.setHistory(tmpString);
        //remove automatically append for note
        note.setNote(removeNoteAppend(note.getNote()));
        caseManagementNoteDAO.saveNote(note);
        
        //if note is signed we hash it and save hash --N/A by Lillian
        /*
        if( note.isSigned() ) {
            HashAuditImpl hashAudit = new HashAuditImpl();
            hashAudit.setType(BaseHashAudit.NOTE);
            hashAudit.setId(note.getId().longValue());
            hashAudit.makeHash(note.getNote().getBytes());
            hashAuditDAO.saveHash(hashAudit);
        }
        */      
        return tmpString;       
    }
    
    /*
     *fetch notes for demographic
     *if date is set, fetch notes after specified date
     */
    public List getNotes(String demographic_no, UserProperty prop,Integer shelterId,String providerNo) {
        if( prop == null )
            return getNotes(demographic_no,providerNo,shelterId) ;
        
        String staleDate = prop.getValue();
        return caseManagementNoteDAO.getNotesByDemographic(Integer.valueOf(demographic_no), staleDate,shelterId,providerNo);
    }
    
    /*
     *fetch notes for demographic linked with specified issues
     *if date is set, fetch notes after specified date
     */
    public List getNotes(String demographic_no, String[] issues, UserProperty prop) {
        if( prop == null )
            return getNotes(demographic_no, issues);
                
        String staleDate = prop.getValue();
        return caseManagementNoteDAO.getNotesByDemographic(demographic_no, issues, staleDate);
    }

    public List getNotes(String demographic_no,String providerNo,Integer shelterId) {
        return caseManagementNoteDAO.getNotesByDemographic(Integer.valueOf(demographic_no),shelterId,providerNo);
    }

    public List getNotes(String demographic_no, String[] issues) {
        //List notesNoLocked = new ArrayList();
        List notes = caseManagementNoteDAO.getNotesByDemographic(demographic_no, issues);
        /*
        for(Iterator iter=notes.iterator();iter.hasNext();) {
        	CaseManagementNote note = (CaseManagementNote)iter.next();
        	if(!note.isLocked()) {
        		notesNoLocked.add(note);
        	}
        }
        return notesNoLocked;
        */
        return notes;
    }

    public List getIssues(String providerNo, String demographic_no) {
        return caseManagementIssueDAO.getIssuesByDemographicOrderActive(demographic_no);

    }

    public List getActiveIssues(String providerNo, String demographic_no) {
        return caseManagementIssueDAO.getActiveIssuesByDemographic(demographic_no);
    }
    public List getAllIssues(String demographic_no) {
        return caseManagementIssueDAO.getAllIssuesByDemographic(demographic_no);
    }
    
    public List getIssues(String providerNo, String demographic_no, List accessRight) {
        return getIssues(providerNo, demographic_no);
    }

    public List getActiveIssues(String providerNo, String demographic_no, List accessRight) {
        return getActiveIssues(providerNo, demographic_no);
    }

    /* return true if have the right to access issues */
    public boolean inAccessRight(String right, String issueAccessType, List accessRight) {
        boolean rt = false;
        if (accessRight == null) return rt;
        Iterator itr = accessRight.iterator();
        while (itr.hasNext()) {
            AccessType par = (AccessType)itr.next();
            if (right.equalsIgnoreCase(par.getName()) && issueAccessType.equalsIgnoreCase(par.getType())) return true;
        }
        return rt;
    }
    
    public LookupCodeValue getIssue(String issue_id) throws SQLException{
        return this.lookupDao.GetCode("ISS",issue_id);
    }

    public CaseManagementNote getNote(String note_id) {
        return this.caseManagementNoteDAO.getNote(Integer.valueOf(note_id));

    }

    public CaseManagementCPP getCPP(String demographic_no) {
        return this.caseManagementCPPDAO.getCPP(demographic_no);
    }
    
    public List getAllergies(String demographic_no) {
        return this.allergyDAO.getAllergies(demographic_no);
    }

    public List getPrescriptions(String demographic_no, boolean all) {
        if (all) {
            return this.prescriptionDAO.getPrescriptions(demographic_no);
        }
        return this.prescriptionDAO.getUniquePrescriptions(demographic_no);
    }

    public List getEncounterFormBeans() {
        return encounterFormDAO.getAllForms();
    }
    public void deleteIssueById(CaseManagementIssue issue) {
        caseManagementIssueDAO.deleteIssueById(issue);
    }

    public void saveAndUpdateCaseIssues(List issuelist) {
        caseManagementIssueDAO.saveAndUpdateCaseIssues(issuelist);
    }

    public void saveCaseIssue(CaseManagementIssue issue) {
        caseManagementIssueDAO.saveIssue(issue);
    }
    public void saveCPP(CaseManagementCPP cpp, String providerNo) {
        cpp.setProvider_no(providerNo);    // added because nothing else was setting providerNo; not sure this is the right place to do this -- rwd        
        caseManagementCPPDAO.saveCPP(cpp);
       // echartDAO.saveCPPIntoEchart(cpp, providerNo);
    }

    public void addNewIssueToConcern(String demoNo, String issueName) {
        CaseManagementCPP cpp = caseManagementCPPDAO.getCPP(demoNo);
        if (cpp == null) {
            cpp = new CaseManagementCPP();
            cpp.setDemographic_no(demoNo);
        }
        String ongoing = (cpp.getOngoingConcerns() == null)?"":cpp.getOngoingConcerns();
        ongoing = ongoing + issueName + "\n";
        cpp.setOngoingConcerns(ongoing);
        cpp.setUpdate_date(new Date());
        caseManagementCPPDAO.saveCPP(cpp);
       // echartDAO.updateEchartOngoing(cpp);

    }
    
    /**
     *substitue function for updateCurrentIssueToCPP
     *We don't want to clobber existing text in ongoing concerns
     *all we want to do is remove the issue description
     **/
    public void removeIssueFromCPP(String demoNo, CaseManagementIssue issue) {
        CaseManagementCPP cpp = caseManagementCPPDAO.getCPP(demoNo);
        
        String ongoing = cpp.getOngoingConcerns();
        String newOngoing;
        String description;       
        int idx;                       
        
        description = issue.getIssue().getDescription();
        Pattern pattern = Pattern.compile("^" + description + "$", Pattern.MULTILINE);
        Matcher matcher = pattern.matcher(ongoing);
        
        if( matcher.find() ) {
            newOngoing = matcher.replaceFirst("");
            
            cpp.setOngoingConcerns(newOngoing);
            cpp.setUpdate_date(new Date());
            caseManagementCPPDAO.saveCPP(cpp);
          //  echartDAO.updateEchartOngoing(cpp);
        }
    }

    /**
     *Substitute for updateCurrentIssueToCPP
     *we replace old issue with new without clobbering existing text
     **/
    public void changeIssueInCPP(String demoNo, CaseManagementIssue origIssue, CaseManagementIssue newIssue) {
        CaseManagementCPP cpp = caseManagementCPPDAO.getCPP(demoNo);
        
        String ongoing = cpp.getOngoingConcerns();
        String newOngoing;
        String description;       
        int idx;               
                
        description = origIssue.getIssue().getDescription();
        
        Pattern pattern = Pattern.compile("^" + description + "$", Pattern.MULTILINE);
        Matcher matcher = pattern.matcher(ongoing);
        
        if( matcher.find()) {            
            description = newIssue.getIssue().getDescription();        
            newOngoing = matcher.replaceFirst(description);
            cpp.setOngoingConcerns(newOngoing);
            cpp.setUpdate_date(new Date());
            caseManagementCPPDAO.saveCPP(cpp);
          //  echartDAO.updateEchartOngoing(cpp);
        }                
        
    }
    
    public void updateCurrentIssueToCPP(String demoNo, List issueList) {
        CaseManagementCPP cpp = caseManagementCPPDAO.getCPP(demoNo);
        if (cpp == null) {
            cpp = new CaseManagementCPP();
            cpp.setDemographic_no(demoNo);
        }
        String ongoing = "";
        Iterator itr = issueList.iterator();
        while (itr.hasNext()) {
            CaseManagementIssue iss = (CaseManagementIssue)itr.next();
            ongoing = ongoing + iss.getIssue().getDescription() + "\n";
        }
        
        cpp.setOngoingConcerns(ongoing);
        cpp.setUpdate_date(new Date());
        caseManagementCPPDAO.saveCPP(cpp);
      //  echartDAO.updateEchartOngoing(cpp);
    }

    /* get the filtered Notes by caisi role */
    public List getFilteredNotes(String providerNo, String demographic_no,Integer shelterId) {
        List allNotes = caseManagementNoteDAO.getNotesByDemographic(Integer.valueOf(demographic_no),shelterId,providerNo);
        return allNotes;
    }

    public boolean haveIssue(Integer issid, String demoNo,String providerNo,Integer shelterId) {
        List allNotes = caseManagementNoteDAO.getNotesByDemographic(Integer.valueOf(demoNo),shelterId,providerNo);
        Iterator itr = allNotes.iterator();
        while (itr.hasNext()) {
            CaseManagementNote note = (CaseManagementNote)itr.next();
            Set issues = note.getIssues();
            Iterator its = issues.iterator();
            while (its.hasNext()) {
                CaseManagementIssue iss = (CaseManagementIssue)its.next();
                if (iss.getId().intValue() == issid.intValue()) return true;
            }
        }
        return false;
    }

    public boolean greaterEqualLevel(int level, String providerNo) {
        if (level < 1 || level > 4) return false;
        List pcrList = secroleDao.getRoles();
        if (pcrList.size() == 0) return false;
        Iterator itr = pcrList.iterator();
        while (itr.hasNext()) {
            Secrole pcr = (Secrole)itr.next();
            String role = pcr.getRoleName();
            int secuL = 0, rtSecul = 0;
            if (role.equalsIgnoreCase("doctor")) secuL = 4;
            if (role.equalsIgnoreCase("nurse")) secuL = 3;
            if (role.equalsIgnoreCase("counsellor")) secuL = 2;
            if (role.equalsIgnoreCase("CSW")) secuL = 1;
            /* get provider's highest level */
            if (secuL > rtSecul) rtSecul = secuL;
            if (rtSecul >= level) return true;
        }
        return false;
    }

    public String getProviderName(String providerNo) {
        Provider pv = providerDAO.getProvider(providerNo);
        if (pv != null) return pv.getFirstName() + " " + pv.getLastName();
        return null;
    }

    public String getDemoName(String demoNo) {
       
        Demographic dg = demographicDAO.getClientByDemographicNo(new Integer(demoNo));
        if (dg == null) return "";
        else return dg.getFirstName() + " " + dg.getLastName();
    }

    public String getDemoGender(String demoNo) {
        String gender = "";
        
        Demographic demo = demographicDAO.getClientByDemographicNo(new Integer(demoNo));
        if (demo != null) {
            gender = demo.getSex();
        }

        return gender;
    }
    public String getDemoAge(String demoNo) {
        String age = "";

        Demographic demo = demographicDAO.getClientByDemographicNo(new Integer(demoNo));
        if (demo != null) {
            age = demo.getAge();
        }

        return age;
    }

    public String getDemoDOB(String demoNo) {
        Demographic dg = demographicDAO.getClientByDemographicNo(new Integer(demoNo));
        if (dg == null){
          return "";
        }else{ 
//          return dg.getYearOfBirth() + "/" + dg.getMonthOfBirth() + "/" + dg.getDateOfBirth();
          return MyDateFormat.getStandardDate(dg.getDateOfBirth());
        }
    }
/*
    public String getCaisiRoleById(String id) {
        //return providerCaisiRoleDAO.getCaisiRoleById(id);
        return roleManager.getRole(id).getName();
    }
*/
    public List search(CaseManagementSearchBean searchBean,Integer shelterId,String providerNo) {
        List lst = new ArrayList();
        List notes=this.caseManagementNoteDAO.search(searchBean);
        List ids=caseManagementNoteDAO.getNoteIdsByDemographic(Integer.valueOf(searchBean.getDemographicNo()), shelterId, providerNo);       
        Iterator it =notes.iterator();        
        while(it.hasNext()){
        	Object element = (Object)it.next();        
       	  	CaseManagementNote obj=(CaseManagementNote)element;       	  
       	  	Iterator it2 = ids.iterator();
       	  	while(it2.hasNext()){
       	  		Integer element2 = (Integer)it2.next();       	  		  
	       	    if(element2.intValue()==obj.getId().intValue()){
	        	  lst.add(obj);
	       	      break;
	       	    }
          }  
        }
        
        /*
        int i=0;
		while(idItem.hasNext()){
			Integer id =(Integer)ids.iterator().next();			
			noteIds[i]=id;
			i++;
		}
		CaseManagementNote[]  note= null; 
		i=0;
        if(notes.size()>0){
        	note=new CaseManagementNote[notes.size()+1];
        	while(notes.iterator().hasNext()){
        		note[i] = (CaseManagementNote)notes.iterator().next();
        		i++;
        	}        	
        }
        if(note!=null && note.length>0){
        	for(int j=0;j<note.length;j++){
        		if(null!=note[j]){
	        		Integer nId =note[j].getId();
	        		for(int k=0;k<noteIds.length;k++){
	        			if(nId.intValue()==noteIds[k].intValue()) lst.add(note[j]);
	        		}
        		}
        	}
        }
        */
    	return lst;
        
    }
    
    public void tmpSave(String providerNo, String demographicNo, String programId, String noteId, String note) {
            CaseManagementTmpSave tmp = new CaseManagementTmpSave();
            tmp.setProviderNo(providerNo);
            tmp.setDemographicNo(Integer.valueOf(demographicNo));
            tmp.setProgramId(Integer.valueOf(programId));
            if(noteId==null || "".equals(noteId)) {
            	noteId="0";
            }
            tmp.setNote_id(Integer.valueOf(noteId));
            tmp.setNote(note);
            tmp.setUpdate_date(new Date());
            caseManagementTmpSaveDAO.save(tmp);
    }
   

    public void deleteTmpSave(String providerNo, Integer demographicNo, Integer programId) {
        caseManagementTmpSaveDAO.delete(providerNo, demographicNo, programId);
    }
    /*
    public CaseManagementTmpSave restoreTmpSave(String providerNo, String demographicNo, String programId) {
        CaseManagementTmpSave obj = caseManagementTmpSaveDAO.load(providerNo, Integer.valueOf(demographicNo), Integer.valueOf(programId));
        return obj;
    }
   
    //we want to load a temp saved note only if it's more recent than date
    public CaseManagementTmpSave restoreTmpSave(String providerNo, String demographicNo, String programId, Date date) {
        CaseManagementTmpSave obj = caseManagementTmpSaveDAO.load(providerNo, Integer.valueOf(demographicNo), Integer.valueOf(programId), date);
        return obj;
    }
    */
    public List getHistory(String note_id) {
            CaseManagementNote note = caseManagementNoteDAO.getNote(Integer.valueOf(note_id));
            return this.caseManagementNoteDAO.getHistory(note);
    }

    /*
     * new search logic
     * filterNotes(filtered1, getProviderNo(request),currentFacilityId,caseForm.getSearchServiceComponent(),caseForm.getSearchCaseStatus());
     */
    //comment by Lillian
    /*
    public List filterNotes(List notes,String providerNo,Integer currentFacilityId,String issId,String caseStatus){
    	List filteredNotes = new ArrayList();
    	if(notes.isEmpty()) return notes;
    	
    	
        //iterate through the issue list
    	
        for (Iterator iter = notes.iterator(); iter.hasNext();) {
            CaseManagementNote cmNote = (CaseManagementNote)iter.next();
            filteredNotes.add(cmNote);
            }
        
    	
        if(Utility.IsEmpty(issId)) issId="0";
          if((Integer.valueOf(issId).intValue()>0) || !Utility.IsEmpty(caseStatus)){  
        	  filteredNotes = notesIssueFiltering(Integer.valueOf(issId),caseStatus, filteredNotes) ;
          }
        //no facility check comment by Lillian
        // filter notes based on facility
        /*  
        if (OscarProperties.getInstance().getBooleanProperty("FILTER_ON_FACILITY", "true")) {
            filteredNotes = notesFacilityFiltering(currentFacilityId, filteredNotes);
        }
        

    	return filteredNotes;
    }
*/

    private List issuesFacilityFiltering(Integer currentFacilityId, List issues) {
        ArrayList results = new ArrayList();
        
        Iterator it = issues.iterator();
        while(it.hasNext()){
        	CaseManagementIssue caseManagementIssue = (CaseManagementIssue)it.next();
        //for (CaseManagementIssue caseManagementIssue : issues) {
            Integer programId = caseManagementIssue.getProgram_id();
            if (programManager.hasAccessBasedOnFacility(currentFacilityId, programId)) results.add(caseManagementIssue);
        }

        return results;
    }

    private List notesFacilityFiltering(Integer currentFacilityId, List notes) {

        ArrayList results = new ArrayList();
        Iterator it = notes.iterator();
        while(it.hasNext()){
        	CaseManagementNote caseManagementNote = (CaseManagementNote)it.next();
        //for (CaseManagementNote caseManagementNote : notes) {
            Integer programId = caseManagementNote.getProgram_no();
            if (programId==null || programId.intValue()==0 || programManager.hasAccessBasedOnFacility(currentFacilityId, programId)) results.add(caseManagementNote);
        }

        return results;
    }
    private List notesIssueFiltering(Integer issueId,String caseStatus, List notes) {
    	ArrayList results = new ArrayList();
    	
    	Iterator it = notes.iterator();
        while(it.hasNext()){
        	CaseManagementNote caseManagementNote = (CaseManagementNote)it.next();
        //for (CaseManagementNote caseManagementNote : notes) {
            
        	Set issues = caseManagementNote.getIssues();
            Iterator its = issues.iterator();
            String resYN ="";
            while (its.hasNext()) {
                CaseManagementIssue iss = (CaseManagementIssue)its.next();
                if(issueId.intValue()>0 && !Utility.IsEmpty(caseStatus)){
                     resYN =iss.isResolved()?"1":"0";          
                     if (iss.getId().intValue() == issueId.intValue() && (resYN.equals(caseStatus))) {
                    	 results.add(caseManagementNote);
                     }
                }else if(issueId.intValue()>0 && Utility.IsEmpty(caseStatus)){
                	if (iss.getId().intValue() == issueId.intValue()) {
                   	 results.add(caseManagementNote);
                    }
                }else if(!Utility.IsEmpty(caseStatus)){
                	resYN =iss.isResolved()?"1":"0";          
                    if (resYN.equals(caseStatus)) {
                   	 results.add(caseManagementNote);
                    }
                }else{
                	results.add(caseManagementNote);
                }
            }        	 
        }
        
        return results;
    }
    
    public void saveNoteSimple(CaseManagementNote note) {
        this.caseManagementNoteDAO.saveNote(note);
    }
/*
    public boolean isClientInProgramDomain(Integer shelterId, String providerNo, String demographicNo) {

        List providerPrograms = programManager.getProgramsByProvider(facilityId, providerNo);
     
        List allIntakes = this.demographicDAO.getIntakeByFacility(Integer.valueOf(demographicNo), facilityId);

        for (int x = 0; x < providerPrograms.size(); x++) {
            Program pp = (Program)providerPrograms.get(x);
            Integer programId = pp.getId();

            for (int y = 0; y < allIntakes.size(); y++) {
            	QuatroIntakeHeader qih = (QuatroIntakeHeader)allIntakes.get(y);
                Integer intakeProgramId = qih.getProgramId();

                if (programId.intValue() == intakeProgramId.intValue()) {
                    return true;
                }
            }
        }

        return false;
    }
*/
    public boolean unlockNote(int noteId, String password) {
        CaseManagementNote note = this.caseManagementNoteDAO.getNote(new Integer(noteId));
        if (note != null) {
            if (note.isLocked() && note.getPassword().equals(password)) {
                return true;
            }
        }
        return false;
    }

    public void updateIssue(String demographicNo,Integer originalIssueId, Integer newIssueId) {
        List issues = this.caseManagementIssueDAO.getIssuesByDemographic(demographicNo);
        Iterator it = issues.iterator();
        while(it.hasNext()){
        	CaseManagementIssue issue = (CaseManagementIssue)it.next();
        //for (CaseManagementIssue issue : issues) {
            boolean save = false;
            if (issue.getIssue_id() == originalIssueId) {
                issue.setIssue_id(newIssueId);
                //issue.setIssue(null);
                save = true;
            }
            if (save) {
                this.caseManagementIssueDAO.saveIssue(issue);
            }
        }

        /*
        String[] issueIdList = new String[1];
        issueIdList[0] = String.valueOf(newIssueId);
        List notes = this.caseManagementNoteDAO.getNotesByDemographic(demographicNo);
        for(CaseManagementNote note:notes) {
        	Set issues = note.getIssues();
        	for(CaseManagementIssue issue:issues) {
        		if(issue.getIssue().getId().equals(originalIssueId)) {
        			//update this CaseManagementIssue
        			issue.setIssue(null);
        			issue.setIssue_id(newIssueId.longValue());
        		}
        	}
        	this.caseManagementNoteDAO.saveNote(note);
        }
        */
    }

    /*
    public void setEchartDAO(EchartDAO echartDAO) {
        this.echartDAO = echartDAO;
    }
    */

    public void setEncounterFormDAO(EncounterFormDAO dao) {
        this.encounterFormDAO = dao;
    }

    public void setCaseManagementNoteDAO(CaseManagementNoteDAO dao) {
        this.caseManagementNoteDAO = dao;
    }

    public void setCaseManagementIssueDAO(CaseManagementIssueDAO dao) {
        this.caseManagementIssueDAO = dao;
    }

    public void setLookupDao(LookupDao dao) {
        this.lookupDao = dao;
    }

    public void setCaseManagementCPPDAO(CaseManagementCPPDAO dao) {
        this.caseManagementCPPDAO = dao;
    }
    
    public void setAllergyDAO(AllergyDAO dao) {
        this.allergyDAO = dao;
    }

    public void setPrescriptionDAO(PrescriptionDAO dao) {
        this.prescriptionDAO = dao;
    }

    public void setClientImageDAO(ClientImageDAO dao) {
        this.clientImageDAO = dao;
    }
/*
    public void setRoleManager(RoleManager mgr) {
        this.roleManager = mgr;
    }
*/
    public void setProviderSignitureDao(ProviderSignitureDao providerSignitureDao) {
        this.providerSignitureDao = providerSignitureDao;
    }

    public void setDemographicDAO(ClientDao demographicDAO) {
        this.demographicDAO = demographicDAO;
    }

    public void setProviderDAO(ProviderDao providerDAO) {
        this.providerDAO = providerDAO;
    }

    public void setIntakeDAO(IntakeDao intakeDAO) {
        this.intakeDao = intakeDAO;
    }


    public void setCaseManagementTmpSaveDAO(CaseManagementTmpSaveDAO dao) {
        this.caseManagementTmpSaveDAO = dao;
    }

    protected String removeFirstSpace(String withSpaces) {
        int spaceIndex = withSpaces.indexOf(' '); //use lastIndexOf to remove last space
        if (spaceIndex < 0) { //no spaces!
            return withSpaces;
        }
        return withSpaces.substring(0, spaceIndex) + withSpaces.substring(spaceIndex + 1, withSpaces.length());
    }   
    
    public void setHashAuditDAO(HashAuditDAO dao) {
        this.hashAuditDAO = dao;
    }
/*    
    public void setEctWindowDAO(EncounterWindowDAO dao) {
        this.ectWindowDAO = dao;
    }
*/    
    public void setUserPropertyDAO( UserPropertyDAO dao) {
        this.userPropertyDAO = dao;
    }
    public void setSecroleDao( SecroleDao dao) {
        this.secroleDao = dao;
    }
}
