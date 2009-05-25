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
package com.quatro.dao;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.util.HashMap;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import java.util.ArrayList;

import com.quatro.common.KeyConstants;
import com.quatro.web.intake.IntakeConstant;

import org.apache.commons.lang.StringEscapeUtils;
import org.oscarehr.PMmodule.dao.MergeClientDao;
import org.oscarehr.PMmodule.dao.ProgramQueueDao;
import org.oscarehr.PMmodule.dao.ClientReferralDAO;

import org.oscarehr.PMmodule.model.ClientReferral;
import org.oscarehr.PMmodule.model.Demographic;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.ProgramClientInfo;
import org.oscarehr.PMmodule.model.ProgramQueue;
import org.oscarehr.PMmodule.model.QuatroIntakeAnswer;
import org.oscarehr.PMmodule.model.QuatroIntakeDB;
import org.oscarehr.PMmodule.model.QuatroIntake;
import org.oscarehr.PMmodule.model.QuatroIntakeFamily;
import org.oscarehr.PMmodule.model.QuatroIntakeHeader;
import org.oscarehr.PMmodule.web.formbean.ClientForm;

import oscar.MyDateFormat;

public class IntakeDao extends HibernateDaoSupport {

	private MergeClientDao mergeClientDao;
	
	private ProgramQueueDao programQueueDao;
    private ClientReferralDAO clientReferralDao;
    
	public List LoadOptionsList(boolean activeOnly) {
		String sSQL="from QuatroIntakeOptionValue s ";	
		if (activeOnly)
		{
			sSQL += " where s.active = 1 ";
		}
		sSQL += " order by s.prefix, s.displayOrder";
		return getHibernateTemplate().find(sSQL);
	}

	public List checkExistBedIntakeByPrograms(Integer clientId, Integer programId){
        //client Merge
        String clientIds=mergeClientDao.getMergedClientIds(clientId);
    	String sSQL="from QuatroIntakeDB i where i.clientId in " +clientIds+ 
		        " and i.programId=" + programId.toString() + 
		        " and (i.intakeStatus='" + KeyConstants.INTAKE_STATUS_ACTIVE + "'" +
		        " or i.intakeStatus='" + KeyConstants.INTAKE_STATUS_ADMITTED + "')";
		
    	List result = getHibernateTemplate().find(sSQL);
	    return result;
    }
	public QuatroIntakeDB findActiveQuatroIntakeDB(Integer clientId, Integer programId) {
		String clientIds=mergeClientDao.getMergedClientIds(clientId);
		List result = null;
		if (programId == null || programId.intValue() == 0) {
			result = getHibernateTemplate().find("from QuatroIntakeDB i where i.clientId in "+clientIds +
					" and i.intakeStatus='" + 
					KeyConstants.INTAKE_STATUS_ACTIVE + "'");
		}
		else
		{
			result = getHibernateTemplate().find("from QuatroIntakeDB i where i.clientId in "+clientIds +
					" and i.programId=? and i.intakeStatus='" + 
					KeyConstants.INTAKE_STATUS_ACTIVE + "'", programId);
		}
		if(result.size()>0)
		  return (QuatroIntakeDB)result.get(0);
		else
		  return null;
	}

	public List getActiveIntakeByProgramByClient(Integer clientId, Integer programId) {
		String clientIds=mergeClientDao.getMergedClientIds(clientId);
		List result = getHibernateTemplate().find("from QuatroIntakeHeader i where i.clientId in "+clientIds +
				" and i.programId = ?" + 
				" and i.intakeStatus in ('" + 
				KeyConstants.INTAKE_STATUS_ACTIVE + "','"+KeyConstants.INTAKE_STATUS_ADMITTED+"')", programId);
	    return result;
	}
	
	public List getActiveIntakeByProgram(Integer programId){
    	List result = getHibernateTemplate().find("from QuatroIntakeHeader i where i.programId = ?" +
				" and i.intakeStatus in ('" + 
				KeyConstants.INTAKE_STATUS_ACTIVE + "','"+KeyConstants.INTAKE_STATUS_ADMITTED+"')", programId);
    	return result;
    }
	public List getIntakesByProgram(Integer programId){
    	List result = getHibernateTemplate().find("from QuatroIntakeHeader i where i.programId = ?", programId);
    	return result;
    }

	//from queueId of family intake, you may get any family memebr's intakeId, then get family head's intakeId and return it.
	public QuatroIntakeDB getQuatroIntakeDBByReferralId(Integer referralId) {
		ClientReferral refer = clientReferralDao.getClientReferral(referralId);
		if(refer.getFromIntakeId()==null) return null;
		List result = getHibernateTemplate().find("from QuatroIntakeDB i where i.id = ?" +
					" and i.intakeStatus='" + 
					KeyConstants.INTAKE_STATUS_ACTIVE + "'", 
					new Object[] {refer.getFromIntakeId()});
		if(result.size()>0){
			QuatroIntakeDB qdb = (QuatroIntakeDB)result.get(0);
			Integer intakeId = qdb.getId(); 
			String sSQL="select a.intakeHeadId from QuatroIntakeFamily a WHERE a.intakeId = ?";
			List lst = getHibernateTemplate().find(sSQL, new Object[] {intakeId});
			
			if(lst.size()==0){
			   return qdb;  //not family intake
			}else{
			   Integer intakeHeadId=(Integer)lst.get(0);
			   List lst2 = getHibernateTemplate().find("from QuatroIntakeDB i where i.id = ?",
						new Object[] {intakeHeadId});
			   return (QuatroIntakeDB)lst2.get(0);
			}
		}else{
		  return null;
		}
		
	}
    
    public List getQuatroIntakeDBByIntakeIds(String intakeIds) {
        String[] split= intakeIds.split(",");
        StringBuffer sb = new StringBuffer();
        Object[] obj= new Integer[split.length];
        for(int i=0;i<split.length;i++){
           sb.append(",?");
           obj[i]=Integer.valueOf(split[i]);
        }

        List result = getHibernateTemplate().find("from QuatroIntakeDB i where i.id in (" +
				      sb.substring(1) + ")", obj);

		return result;
		
	}

    public QuatroIntakeDB getQuatroIntakeDBByIntakeId(Integer intakeId) {
		List result = getHibernateTemplate().find("from QuatroIntakeDB i where i.id = ?",
					new Object[] {intakeId});
		if(result.size()>0)
		  return (QuatroIntakeDB)result.get(0);
		else
		  return null;
		
	}
    
	public QuatroIntake getQuatroIntake(Integer intakeId) {
		List result = getHibernateTemplate().find("from QuatroIntakeDB i where i.id = ?",
			  new Object[] {intakeId});

		List result2 = getHibernateTemplate().find("select p.type, p.name " +
				" from QuatroIntakeDB i, Program p where i.id = ?" +
				" and p.id=i.programId",
				  new Object[] {intakeId});

		if(result.size()==0){
		  return null;
		}else{
/*			
			Object oo[] = (Object[]) result.get(0);
			QuatroIntakeDB intakeDb = new QuatroIntakeDB(); 
			intakeDb.setId((Integer)oo[0]);
			intakeDb.setClientId((Integer)oo[1]);
			intakeDb.setStaffId((String)oo[2]);
			intakeDb.setCreatedOn((Calendar)oo[3]);
			intakeDb.setIntakeStatus((String)oo[4]);
			intakeDb.setProgramType((String)oo[5]);
			intakeDb.setProgramId((Integer)oo[6]);
			intakeDb.setReferralId((Integer)oo[7]);
			intakeDb.setQueueId((Integer)oo[8]);
			intakeDb.setAnswers((Set)oo[9]);
*/
			QuatroIntakeDB intakeDb= (QuatroIntakeDB)result.get(0);
			Object oo[] = (Object[]) result2.get(0);
			intakeDb.setProgramType((String)oo[0]);
			
			QuatroIntake intake= new QuatroIntake();
			intake.setLastUpdateDate(intakeDb.getLastUpdateDate());
		    intake.setId(intakeDb.getId());
		    intake.setClientId(intakeDb.getClientId());
		    intake.setProgramId(intakeDb.getProgramId());
		    intake.setIntakeStatus(intakeDb.getIntakeStatus());
		    intake.setStaffId(intakeDb.getStaffId());
		    intake.setProgramType(intakeDb.getProgramType());
		    intake.setProgramName((String)oo[1]);
		    intake.setSdmtBenUnitStatus(intakeDb.getSdmtBenUnitStatus());
		    intake.setSdmtLastBenMonth(intakeDb.getSdmtLastBenMonth());
		    String strNerverExp="0";
		    if(intakeDb.isNerverExpiry()) strNerverExp="1";
		    intake.setNerverExpiry(strNerverExp);
		    Calendar edt = intakeDb.getEndDate();		    
		    intake.setEndDate(edt);
		    if (null != edt) {
		    	intake.setEndDateTxt(String.valueOf(edt.get(Calendar.YEAR)) + "/" +
  				  MyDateFormat.formatMonthDay(String.valueOf(edt.get(Calendar.MONTH)+1)) + "/" +  
  				MyDateFormat.formatMonthDay(String.valueOf(edt.get(Calendar.DATE))));
		    }
		    intake.setCreatedOn(intakeDb.getCreatedOn());
    	    Calendar cal= intakeDb.getCreatedOn();
    	    intake.setCreatedOnTxt(MyDateFormat.getStandardDateTime(cal));
            
    	    //intake for bed program, add/update referral and queue records.
			Iterator it = intakeDb.getAnswers().iterator();
    	    while(it.hasNext()){
    	    	QuatroIntakeAnswer obj = (QuatroIntakeAnswer)it.next();
    	    
	        	switch(obj.getIntakeNodeId().intValue()){
	        	   //Referered by
	        	   case IntakeConstant.REFERREDBY:
		        	 intake.setReferredBy(obj.getValue());  
		          	 break;
	        	   case IntakeConstant.CONTACTNAME:
		        	 intake.setContactName(obj.getValue());  
		          	 break;
	        	   case IntakeConstant.CONTACTNUMBER:
		        	 intake.setContactNumber(obj.getValue());  
		          	 break;
	        	   case IntakeConstant.CONTACTEMAIL:
		        	 intake.setContactEmail(obj.getValue());  
		          	 break;

	        	   //Other information
	        	   case IntakeConstant.LANGUAGE:
		        	 intake.setLanguage(obj.getValue());  
		          	 break;
	        	   case IntakeConstant.YOUTH:
		        	 intake.setYouth(obj.getValue());  
		          	 break;
	        	   case IntakeConstant.ABORIGINAL:
	        		 intake.setAboriginal(obj.getValue());  
	        		 break;
	        	   case IntakeConstant.ABORIGINALOTHER:
		        	 intake.setAboriginalOther(obj.getValue());  
		          	 break;
	        	   case IntakeConstant.VAW:
		        	 intake.setVAW(obj.getValue());  
		          	 break;
	        	   case IntakeConstant.CURSLEEPARRANGEMENT:
		        	 intake.setCurSleepArrangement(obj.getValue());  
		          	 break;
	        	   case IntakeConstant.INSHELTERBEFORE:
		        	 intake.setInShelterBefore(obj.getValue());  
		          	 break;
	        	   case IntakeConstant.LENGTHOFHOMELESS:
			         intake.setLengthOfHomeless(obj.getValue());  
			         break;
	        	   case IntakeConstant.REASONFORHOMELESS:
			         intake.setReasonForHomeless(obj.getValue());  
			         break;
	        	   case IntakeConstant.REASONFORSERVICE:
				     intake.setReasonForService(obj.getValue());  
				     break;
	          		 
	          	   //Presenting issues
	        	   case IntakeConstant.PREGNANT:
			         intake.setPregnant(obj.getValue());  
			         break;
	        	   case IntakeConstant.DISCLOSEDABUSE:
			         intake.setDisclosedAbuse(obj.getValue());  
			         break;
	        	   case IntakeConstant.DISABILITY:
			         intake.setDisability(obj.getValue());  
			         break;
	        	   case IntakeConstant.OBSERVEDABUSE:
			         intake.setObservedAbuse(obj.getValue());  
			         break;
	        	   case IntakeConstant.DISCLOSEDMENTALISSUE:
			         intake.setDisclosedMentalIssue(obj.getValue());  
			         break;
	        	   case IntakeConstant.POORHYGIENE:
			         intake.setPoorHygiene(obj.getValue());  
			         break;
	        	   case IntakeConstant.OBSERVEDMENTALISSUE:
			         intake.setObservedMentalIssue(obj.getValue());  
			         break;
	        	   case IntakeConstant.DISCLOSEDALCOHOLABUSE:
			         intake.setDisclosedAlcoholAbuse(obj.getValue());  
			         break;
	        	   case IntakeConstant.OBSERVEDALCOHOLABUSE:
			         intake.setObservedAlcoholAbuse(obj.getValue());  
			         break;

                   //Identification
	        	   case IntakeConstant.BIRTHCERTIFICATE:
			         intake.setBirthCertificate(obj.getValue());  
			         break;
	        	   case IntakeConstant.BIRTHCERTIFICATEYN:
			         intake.setBirthCertificateYN(obj.getValue());  
			         break;
	        	   case IntakeConstant.SIN:
			         intake.setSIN(obj.getValue());  
			         break;
	        	   case IntakeConstant.SINYN:
			         intake.setSINYN(obj.getValue());  
			         break;
	        	   case IntakeConstant.HEALTHCARDNO:
			         intake.setHealthCardNo(obj.getValue());  
			         break;
	        	   case IntakeConstant.HEALTHCARDNOYN:
			         intake.setHealthCardNoYN(obj.getValue());  
			         break;
	        	   case IntakeConstant.DRIVERLICENSENO:
			         intake.setDriverLicenseNo(obj.getValue());  
			         break;
	        	   case IntakeConstant.DRIVERLICENSENOYN:
			         intake.setDriverLicenseNoYN(obj.getValue());  
			         break;
	        	   case IntakeConstant.CITIZENCARDNO:
			         intake.setCitizenCardNo(obj.getValue());  
			         break;
	        	   case IntakeConstant.CITIZENCARDNOYN:
			         intake.setCitizenCardNoYN(obj.getValue());  
			         break;
	        	   case IntakeConstant.NATIVERESERVENO:
			         intake.setNativeReserveNo(obj.getValue());  
			         break;
	        	   case IntakeConstant.NATIVERESERVENOYN:
			         intake.setNativeReserveNoYN(obj.getValue());  
			         break;

	        	   case IntakeConstant.VETERANNO:
			         intake.setVeteranNo(obj.getValue());  
			         break;
	        	   case IntakeConstant.VETERANNOYN:
			         intake.setVeteranNoYN(obj.getValue());  
			         break;
	        	   case IntakeConstant.RECORDLANDING:
			         intake.setRecordLanding(obj.getValue());  
			         break;
	        	   case IntakeConstant.RECORDLANDINGYN:
			         intake.setRecordLandingYN(obj.getValue());  
			         break;
	        	   case IntakeConstant.LIBRARYCARD:
			         intake.setLibraryCard(obj.getValue());  
			         break;
	        	   case IntakeConstant.LIBRARYCARDYN:
			         intake.setLibraryCardYN(obj.getValue());  
			         break;
	        	   case IntakeConstant.IDOTHER:
			         intake.setIdOther(obj.getValue());  
			         break;
	        	   
	        	   //Additional information
			       case IntakeConstant.SOURCEINCOME:
			    	 if(obj.getValue()!=null){
			           intake.setSourceIncome(obj.getValue().split(","));
			    	 }else{
				       intake.setSourceIncome(new String[0]);
			    	 }
			         break;
	        	   case IntakeConstant.INCOME:
			         intake.setIncome(obj.getValue());  
			         break;

	        	   case IntakeConstant.INCOMEWORKERNAME1:
			         intake.setIncomeWorkerName1(obj.getValue());  
			         break;
	        	   case IntakeConstant.INCOMEWORKERPHONE1:
			         intake.setIncomeWorkerPhone1(obj.getValue());  
			         break;
	        	   case IntakeConstant.INCOMEWORKEREMAIL1:
			         intake.setIncomeWorkerEmail1(obj.getValue());  
			         break;
	        	   case IntakeConstant.INCOMEWORKERNAME2:
			         intake.setIncomeWorkerName2(obj.getValue());  
			         break;
	        	   case IntakeConstant.INCOMEWORKERPHONE2:
			         intake.setIncomeWorkerPhone2(obj.getValue());  
			         break;
	        	   case IntakeConstant.INCOMEWORKEREMAIL2:
			         intake.setIncomeWorkerEmail2(obj.getValue());  
			         break;
	        	   case IntakeConstant.INCOMEWORKERNAME3:
			         intake.setIncomeWorkerName3(obj.getValue());  
			         break;
	        	   case IntakeConstant.INCOMEWORKERPHONE3:
			         intake.setIncomeWorkerPhone3(obj.getValue());  
			         break;
	        	   case IntakeConstant.INCOMEWORKEREMAIL3:
			         intake.setIncomeWorkerEmail3(obj.getValue());  
			         break;
	        	   case IntakeConstant.LIVEDBEFORE:
			         intake.setLivedBefore(obj.getValue());  
			         break;
	        	   case IntakeConstant.LIVEDBEFOREOTHER:
			         intake.setLivedBeforeOther(obj.getValue());  
			         break;
	        	   case IntakeConstant.STATUSINCANADA:
			         intake.setStatusInCanada(obj.getValue());  
			         break;
	        	   case IntakeConstant.ORIGINALCOUNTRY:
			         intake.setOriginalCountry(obj.getValue());  
			         break;
	        	   case IntakeConstant.REFERREDTO:
			         intake.setReferredTo(obj.getValue());  
			         break;
	        	   case IntakeConstant.REASONNOADMIT:
			         intake.setReasonNoAdmit(obj.getValue());  
			         break;

	        	   //Program
//	        	   case IntakeConstant.PROGRAM:
//			         intake.setProgramId(Integer.valueOf(obj.getValue()));  
//			         break;
			         
			       //Comments
	        	   case IntakeConstant.COMMENTS:
			         intake.setComments(obj.getValue());  
			         break;
			         
	        	}
	        }
	        
	        return intake;
			
		}
		
	}
	
	//for Shelter program, family only exists when intake status is active or admitted,
	//for history report, family may be treated as existing for any intake status. 
	public List getQuatroIntakeHeaderList(Integer clientId, String programIds) {
        String[] split= programIds.split(",");
        StringBuffer sb = new StringBuffer();
        Object[] obj= new Object[split.length];
        obj[0]=Integer.valueOf(split[0]);
        sb.append("?");
        for(int i=1;i<split.length;i++){
           sb.append(",?");           
           obj[i]=Integer.valueOf(split[i]);
        }
        String clientIds =mergeClientDao.getMergedClientIds(clientId);

        String sSQL="from QuatroIntakeHeader i where i.clientId in " + clientIds+
        		" and i.programId in (" +
          sb.toString() + ") and (i.intakeStatus = '" + KeyConstants.INTAKE_STATUS_ACTIVE + "'" +
          " or i.intakeStatus='" +  KeyConstants.INTAKE_STATUS_ADMITTED + "')" +
          " order by i.intakeStatus desc, i.createdOn desc";
        
		List results = getHibernateTemplate().find(sSQL, obj);
		
		return results;
	}
	public Integer getProgramIdByProvider(Integer clientId, Integer shelterId, String providerNo){
		List intakes=getQuatroIntakeHeaderListByFacility(clientId, shelterId,providerNo);
		Integer progId=new Integer(0);
		if(!intakes.isEmpty()){
			progId =((QuatroIntakeHeader)intakes.get(0)).getProgramId();
		}
		return progId;
	}

	public List getQuatroIntakeHeaderListByFacility(Integer clientId, Integer shelterId, String providerNo) {

		List results = null;
		String clientIds=mergeClientDao.getMergedClientIds(clientId);
	    String progSQL = com.quatro.util.Utility.getUserOrgQueryString(providerNo, shelterId);

	    results = getHibernateTemplate().find("from QuatroIntakeHeader i where i.clientId in " + clientIds+" and i.programId in " + progSQL +
	            "  order by i.createdOn desc");
		return results;
	}
	public List getActiveQuatroIntakeHeaderListByFacility(Integer clientId, Integer shelterId, String providerNo) {

		List results = null;
		String clientIds=mergeClientDao.getMergedClientIds(clientId);
	    String progSQL = com.quatro.util.Utility.getUserOrgQueryString(providerNo, shelterId);

	    results = getHibernateTemplate().find("from QuatroIntakeHeader i where i.clientId in " + clientIds+" and i.programId in " + progSQL +
	    		" and i.intakeStatus in ('" + KeyConstants.INTAKE_STATUS_ACTIVE + "','" + KeyConstants.INTAKE_STATUS_ADMITTED + "')" +
	    	    " order by 6 desc, 13, 4 desc");
//	            "  order by i.intakeStatus desc, i.programType, i.createdOn desc");
		return results;
	}
	
	public Integer getIntakeFamilyHeadId(String intakeId){
		String sSQL="select a.intakeHeadId from QuatroIntakeFamily a " +
		  " WHERE a.intakeId = ?";

		List lst = getHibernateTemplate().find(sSQL, new Object[] {Integer.valueOf(intakeId)});
		if(lst.size()==0) return new Integer(0);
		
		return (Integer)lst.get(0);
	}

	public List getAdmittedIntakeIds(Integer clientId){
		String sSQL="select a.id from QuatroIntakeHeader a WHERE a.clientId = ? and " +
		"(a.intakeStatus='" + KeyConstants.INTAKE_STATUS_ADMITTED + "')" ;
//		" or a.intakeStatus='" + KeyConstants.INTAKE_STATUS_ADMITTED + "')";


		List lst = getHibernateTemplate().find(sSQL, new Object[] {clientId});
		return lst;
	}

	public List getClientIntakeFamily(String intakeId){
		String sSQL="select a.intakeHeadId from QuatroIntakeFamily a " +
		  " WHERE a.intakeId = ?";

		List lst = getHibernateTemplate().find(sSQL, new Object[] {Integer.valueOf(intakeId)});
		if(lst.size()==0) return new ArrayList();
		
		Integer intakeHeadId = (Integer)lst.get(0);
		String sSQL2="from QuatroIntakeFamily "+
		  " WHERE intakeHeadId = ?  order by relationship desc";

		List result = getHibernateTemplate().find(sSQL2, new Object[] {intakeHeadId});
		return result;
	}
	
	public List getClientIntakeFamilyHistory(Integer intakeHeadId){

		String sSQL2="from QuatroIntakeFamilyHis "+
		  " WHERE intakeHeadId = ?  order by joinFamilyDate, intakeId  desc";

		List result = getHibernateTemplate().find(sSQL2, new Object[] {intakeHeadId});
		return result;
	}
	
	//bFamilyMember=true for family member intake
	//bFamilyMember=false for individual person or family head intake
	public ArrayList saveQuatroIntake(QuatroIntake intake, Integer intakeHeadId, boolean bFamilyMember, Integer fromManualReferralId){
	    QuatroIntakeDB intakeDb= null;

	    boolean programChangedForFamily=false;  //for family member programId update
	    
		Set obj= new HashSet();//TreeSet();

	    HashMap hData= new HashMap();

		//Referred by
		hData.put(new Integer(IntakeConstant.REFERREDBY), intake.getReferredBy());
		hData.put(new Integer(IntakeConstant.CONTACTNAME), intake.getContactName());
		hData.put(new Integer(IntakeConstant.CONTACTNUMBER), intake.getContactNumber());
		hData.put(new Integer(IntakeConstant.CONTACTEMAIL), intake.getContactEmail());

  		//Other information
		hData.put(new Integer(IntakeConstant.LANGUAGE), intake.getLanguage());
		hData.put(new Integer(IntakeConstant.YOUTH), intake.getYouth());
		hData.put(new Integer(IntakeConstant.ABORIGINAL), intake.getAboriginal());
		hData.put(new Integer(IntakeConstant.ABORIGINALOTHER), intake.getAboriginalOther());
		hData.put(new Integer(IntakeConstant.VAW), intake.getVAW());
		hData.put(new Integer(IntakeConstant.CURSLEEPARRANGEMENT), intake.getCurSleepArrangement());
		hData.put(new Integer(IntakeConstant.INSHELTERBEFORE), intake.getInShelterBefore());
		hData.put(new Integer(IntakeConstant.LENGTHOFHOMELESS), intake.getLengthOfHomeless());
		hData.put(new Integer(IntakeConstant.REASONFORHOMELESS), intake.getReasonForHomeless());
		hData.put(new Integer(IntakeConstant.REASONFORSERVICE), intake.getReasonForService());

        //Presenting issues
		hData.put(new Integer(IntakeConstant.PREGNANT), intake.getPregnant());
		hData.put(new Integer(IntakeConstant.DISCLOSEDABUSE), intake.getDisclosedAbuse());
		hData.put(new Integer(IntakeConstant.DISABILITY), intake.getDisability());
		hData.put(new Integer(IntakeConstant.OBSERVEDABUSE), intake.getObservedAbuse());
		hData.put(new Integer(IntakeConstant.DISCLOSEDMENTALISSUE), intake.getDisclosedMentalIssue());
		hData.put(new Integer(IntakeConstant.POORHYGIENE), intake.getPoorHygiene());
		hData.put(new Integer(IntakeConstant.OBSERVEDMENTALISSUE), intake.getObservedMentalIssue());
		hData.put(new Integer(IntakeConstant.DISCLOSEDALCOHOLABUSE), intake.getDisclosedAlcoholAbuse());
		hData.put(new Integer(IntakeConstant.OBSERVEDALCOHOLABUSE), intake.getObservedAlcoholAbuse());
		
		//Identification
		hData.put(new Integer(IntakeConstant.BIRTHCERTIFICATE), intake.getBirthCertificate());
		hData.put(new Integer(IntakeConstant.BIRTHCERTIFICATEYN), intake.getBirthCertificateYN());
		hData.put(new Integer(IntakeConstant.SIN), intake.getSIN());
		hData.put(new Integer(IntakeConstant.SINYN), intake.getSINYN());
		hData.put(new Integer(IntakeConstant.HEALTHCARDNO), intake.getHealthCardNo());
		hData.put(new Integer(IntakeConstant.HEALTHCARDNOYN), intake.getHealthCardNoYN());
		hData.put(new Integer(IntakeConstant.DRIVERLICENSENO), intake.getDriverLicenseNo());
		hData.put(new Integer(IntakeConstant.DRIVERLICENSENOYN), intake.getDriverLicenseNoYN());
		hData.put(new Integer(IntakeConstant.CITIZENCARDNO), intake.getCitizenCardNo());
		hData.put(new Integer(IntakeConstant.CITIZENCARDNOYN), intake.getCitizenCardNoYN());
		hData.put(new Integer(IntakeConstant.NATIVERESERVENO), intake.getNativeReserveNo());
		hData.put(new Integer(IntakeConstant.NATIVERESERVENOYN), intake.getNativeReserveNoYN());
		hData.put(new Integer(IntakeConstant.VETERANNO), intake.getVeteranNo());
		hData.put(new Integer(IntakeConstant.VETERANNOYN), intake.getVeteranNoYN());
		hData.put(new Integer(IntakeConstant.RECORDLANDING), intake.getRecordLanding());
		hData.put(new Integer(IntakeConstant.RECORDLANDINGYN), intake.getRecordLandingYN());
		hData.put(new Integer(IntakeConstant.LIBRARYCARD), intake.getLibraryCard());
		hData.put(new Integer(IntakeConstant.LIBRARYCARDYN), intake.getLibraryCardYN());
		hData.put(new Integer(IntakeConstant.IDOTHER), intake.getIdOther());
		
		//Additional information
		String sSourceIncome="";
		for(int i=0;i<intake.getSourceIncome().length;i++){
			sSourceIncome = sSourceIncome + "," + intake.getSourceIncome()[i];
		}
		if(sSourceIncome.length()>0){
		   hData.put(new Integer(IntakeConstant.SOURCEINCOME), sSourceIncome.substring(1));
		}else{
		   hData.put(new Integer(IntakeConstant.SOURCEINCOME), "");
		}
		
		hData.put(new Integer(IntakeConstant.INCOME), intake.getIncome());
		hData.put(new Integer(IntakeConstant.INCOMEWORKERNAME1), intake.getIncomeWorkerName1());
		hData.put(new Integer(IntakeConstant.INCOMEWORKERPHONE1), intake.getIncomeWorkerPhone1());
		hData.put(new Integer(IntakeConstant.INCOMEWORKEREMAIL1), intake.getIncomeWorkerEmail1());
		hData.put(new Integer(IntakeConstant.INCOMEWORKERNAME2), intake.getIncomeWorkerName2());
		hData.put(new Integer(IntakeConstant.INCOMEWORKERPHONE2), intake.getIncomeWorkerPhone2());
		hData.put(new Integer(IntakeConstant.INCOMEWORKEREMAIL2), intake.getIncomeWorkerEmail2());
		hData.put(new Integer(IntakeConstant.INCOMEWORKERNAME3), intake.getIncomeWorkerName3());
		hData.put(new Integer(IntakeConstant.INCOMEWORKERPHONE3), intake.getIncomeWorkerPhone3());
		hData.put(new Integer(IntakeConstant.INCOMEWORKEREMAIL3), intake.getIncomeWorkerEmail3());
		hData.put(new Integer(IntakeConstant.LIVEDBEFORE), intake.getLivedBefore());
		hData.put(new Integer(IntakeConstant.LIVEDBEFOREOTHER), intake.getLivedBeforeOther());
		hData.put(new Integer(IntakeConstant.STATUSINCANADA), intake.getStatusInCanada());
		hData.put(new Integer(IntakeConstant.ORIGINALCOUNTRY), intake.getOriginalCountry());
		hData.put(new Integer(IntakeConstant.REFERREDTO), intake.getReferredTo());
		hData.put(new Integer(IntakeConstant.REASONNOADMIT), intake.getReasonNoAdmit());

		//Comments
		hData.put(new Integer(IntakeConstant.COMMENTS), intake.getComments());
		
        if(intake.getId().intValue()>0){
		  List result = getHibernateTemplate().find("from QuatroIntakeAnswer i where i.intake2.id = ?",
				  new Object[] {intake.getId()});
		  
		  for(int i=0;i<result.size();i++){
			  QuatroIntakeAnswer obj2=(QuatroIntakeAnswer)result.get(i);
		      obj2.setValue((String)hData.get(obj2.getIntakeNodeId()));
		      obj2.setLastUpdateDate(intake.getLastUpdateDate());
		      obj2.setLastUpdateUser(intake.getStaffId());
		      
		      if (i==0){
		    	intakeDb = obj2.getIntake2();
		    	if(intakeDb.getProgramId().intValue()!=intake.getProgramId().intValue()) programChangedForFamily=true;
			    intakeDb.setProgramId(intake.getProgramId());
			    intakeDb.setProgramType(intake.getProgramType());
			    intakeDb.setEndDate(intake.getEndDate());
			    intakeDb.setLastUpdateDate(intake.getLastUpdateDate());
			    intakeDb.setNerverExpiry("1".equals(intake.getNerverExpiry()));
		      }
		      obj.add(obj2);
	      }

		}else{
			intakeDb = new QuatroIntakeDB();
		    intakeDb.setId(intake.getId());
		    intakeDb.setIntakeStatus(intake.getIntakeStatus());
		    intakeDb.setClientId(intake.getClientId());
		    intakeDb.setCreatedOn(intake.getCreatedOn());
		    intakeDb.setEndDate(intake.getEndDate());
		    intakeDb.setNerverExpiry("1".equals(intake.getNerverExpiry()));
		    intakeDb.setLastUpdateDate(intake.getLastUpdateDate());
		    intakeDb.setProgramId(intake.getProgramId());
		    intakeDb.setStaffId(intake.getStaffId());

		    intakeDb.setProgramType(intake.getProgramType());
			
		   for(int i=1;i<IntakeConstant.TOTALITEMS;i++){
			 obj.add(new QuatroIntakeAnswer(i, (String)hData.get(new Integer(i))));
		   }
		}

        intakeDb.setAnswers(obj);

        ArrayList lst = new ArrayList();
        ProgramQueue programQueue=null;
        ClientReferral clientReferral=null;
        
        try{
        //existing intake
        if(intakeDb.getId().intValue()>0){
		  getHibernateTemplate().update(intakeDb);

		  clientReferral = clientReferralDao.getReferralAutoByIntakeId(intakeDb.getId());
          programQueue = programQueueDao.getProgramQueueByIntakeId(intakeDb.getId());
		  
		  //always update programId in referral and queue record in case program changed on intake_edit jsp page.
		  if(KeyConstants.INTAKE_STATUS_ACTIVE.equals(intakeDb.getIntakeStatus()))
		  { 
			if ( intakeDb.getProgramType().equals(KeyConstants.BED_PROGRAM_TYPE))
			{
		        if(clientReferral!=null){
	  		      clientReferral.setProgramId(intakeDb.getProgramId());	        	
		  		}
		        else
		        {
		  		  clientReferral =  createReferral(intake);	        	
		        }
			    clientReferralDao.saveClientReferral(clientReferral);
		        
	            if(programQueue!=null){
			      programQueue.setProgramId(intakeDb.getProgramId());
			    }
	            else
	            {
	            	programQueue = createProgramQueue(clientReferral);
	            }
			    programQueueDao.saveProgramQueue(programQueue);
			  }
			else
			{
				if(programQueue != null) programQueueDao.delete(programQueue);
				if(clientReferral != null) clientReferralDao.delete(clientReferral);
			}
		  }
         

		  //update family member programId if family head programId changed
          if(bFamilyMember && intakeHeadId.intValue()==intakeDb.getId().intValue() && programChangedForFamily==true){
        	  List  family = getClientIntakeFamily(intakeDb.getId().toString());
        	  for(int i=1;i<family.size();i++){
        		QuatroIntakeFamily qif = (QuatroIntakeFamily)family.get(i);
        		updateFamilyProgramId(qif.getIntakeId(), intakeDb.getProgramId());
        	  }
          }
		  
		//new intake
        }else{
		  getHibernateTemplate().save(intakeDb);
		  intake.setId(intakeDb.getId());
	      if(!bFamilyMember){
	    	  clientReferral = createReferral(intake);
	    	  programQueue = createProgramQueue(clientReferral);

	    	  //from manual referral
	    	  if(fromManualReferralId!=null){
	    		  getHibernateTemplate().bulkUpdate("update ClientReferral r set r.status='" + KeyConstants.STATUS_ACCEPTED + "' where r.Id=? and r.autoManual='" +  KeyConstants.MANUAL + "'", fromManualReferralId);
	    		  getHibernateTemplate().bulkUpdate("delete ProgramQueue q where q.ReferralId=?", fromManualReferralId);
	    		  if(!intakeDb.getProgramType().equals(KeyConstants.BED_PROGRAM_TYPE)){
	    			  ProgramQueue exist_programQueue = programQueueDao.getProgramQueueByIntakeId(intakeDb.getId());
	    			  if(exist_programQueue!=null) getHibernateTemplate().bulkUpdate("delete ProgramQueue q where q.Id=?", exist_programQueue.getId());
	    		  }
	    	//new intake not from manual referral
	    	}
		    
	    	if(intakeDb.getProgramType().equals(KeyConstants.BED_PROGRAM_TYPE)){
	    	   clientReferral.setFromIntakeId(intakeDb.getId());  
		       getHibernateTemplate().save(clientReferral);
		       programQueue.setReferralId(clientReferral.getId());
		       programQueue.setFromIntakeId(intakeDb.getId());
               getHibernateTemplate().save(programQueue);
	    	}
	      }
		  
		}
      
        if(!bFamilyMember){
          lst.add(intakeDb.getId());
          if(clientReferral!=null){ 
        	 lst.add(clientReferral.getId());
          }else{
         	 lst.add(null);
          }
          if(programQueue!=null){ 
            lst.add(programQueue.getId());
          }else{
         	lst.add(null);
          }
        }else{
            lst.add(intakeDb.getId());
            lst.add(null);
            lst.add(null);
        }
        }catch(Exception e){
        	String err =e.getMessage();
        }
        return lst;
	}
	private ClientReferral createReferral(QuatroIntake intake)
	{
		ClientReferral clientReferral = new ClientReferral();
        if(intake.getClientId()!=null) clientReferral.setClientId(intake.getClientId());
        clientReferral.setNotes("Intake Automated referral");
        if(intake.getProgramId()!=null) clientReferral.setProgramId(intake.getProgramId());
        clientReferral.setProviderNo(intake.getStaffId());
        clientReferral.setReferralDate(Calendar.getInstance()); 
        clientReferral.setStatus(KeyConstants.STATUS_PENDING);
        clientReferral.setAutoManual(KeyConstants.AUTOMATIC);
        clientReferral.setFromProgramId(intake.getProgramId());
        clientReferral.setFromIntakeId(intake.getId());
		return clientReferral;
	}
	private ProgramQueue createProgramQueue(ClientReferral clientReferral)
	{
		 ProgramQueue programQueue = new ProgramQueue(); 
	   	 programQueue.setClientId(clientReferral.getClientId());
		 programQueue.setNotes(clientReferral.getNotes());
		 programQueue.setProgramId(clientReferral.getProgramId());
		 programQueue.setProviderNo(Integer.valueOf(clientReferral.getProviderNo()));
		 programQueue.setReferralDate(clientReferral.getReferralDate().getTime());
		 programQueue.setReferralId(clientReferral.getId());
	     programQueue.setFromIntakeId(clientReferral.getFromIntakeId());
		 return programQueue;
	}
	public void saveQuatroIntakeFamilyRelation(QuatroIntakeFamily intakeFamily){
        getHibernateTemplate().saveOrUpdate(intakeFamily);
	}
	
	private void updateFamilyProgramId(Integer intakeId, Integer programId){
        String sSQL="update QuatroIntakeDB q set q.programId=? where q.id=?";
		getHibernateTemplate().bulkUpdate(sSQL, new Object[]{programId, intakeId});
	}
	
	public void deleteReferralIdQueueId(Integer referralId, Integer queueId){
        String sSQL="delete ProgramQueue q where q.Id=?";
		getHibernateTemplate().bulkUpdate(sSQL, new Object[]{queueId});
        sSQL="delete ClientReferral r where r.Id=?";
		getHibernateTemplate().bulkUpdate(sSQL, new Object[]{referralId});
	}
	
	public void removeInactiveIntakeFamilyMember(String sInactiveDependents){
        String[] split= sInactiveDependents.split(",");
        StringBuffer sb = new StringBuffer();
        Object[] obj= new Integer[split.length];
        for(int i=0;i<split.length;i++){
           sb.append(",?");
           obj[i]=Integer.valueOf(split[i]);
        }
        String sSQL="delete QuatroIntakeFamily p where p.intakeId in (" + sb.substring(1) + ")";
		getHibernateTemplate().bulkUpdate(sSQL, obj);
	}

	public void setIntakeStatusAdmitted(Integer intakeId){
        String sSQL="update QuatroIntakeDB q set q.intakeStatus='" + 
        KeyConstants.INTAKE_STATUS_ADMITTED + "' where q.id=?";
		getHibernateTemplate().bulkUpdate(sSQL, new Object[]{intakeId});
	}

	public void resetFamilyMemeberReferralIdQueueId(Integer intakeId, Integer referralId){
        String sSQL="update QuatroIntakeDB q set q.queueId=0, q.referralId=? where q.id=?";
		getHibernateTemplate().bulkUpdate(sSQL, new Object[]{referralId, intakeId});
	}

    public List getClientsListForServiceProgram(Program program, String firstName, 
			String lastName, String clientId){
    	Integer programId = program.getId();
    	
    	String queryStr = "SELECT a.createdOn, c.FirstName, c.LastName, a.clientId" 
    		+ " FROM QuatroIntakeDB a, Demographic c" 
    		+ " WHERE a.programId=?"
    		+ " AND a.intakeStatus='" + KeyConstants.INTAKE_STATUS_ACTIVE + "'"
    		+ " AND a.clientId = c.DemographicNo";

    	if(firstName != null && firstName.length()>0){
    		String fname = StringEscapeUtils.escapeSql(firstName).toLowerCase();
    		queryStr = queryStr + " AND lower(c.FirstName) like '%" + fname + "%'";
    	}
    	if(lastName != null && lastName.length()>0){
    		String lname = StringEscapeUtils.escapeSql(lastName).toLowerCase();
    		queryStr = queryStr + " AND lower(c.LastName) like '%" + lname + "%'";
    	}
    	if(clientId != null && clientId.length()>0){
    		String cId = StringEscapeUtils.escapeSql(clientId).toLowerCase();
    		queryStr = queryStr + " AND lower(a.clientId) like '%" + cId + "%'";
    	}
	    	
        List  lst= getHibernateTemplate().find(queryStr, new Object[] { programId});

        List clientsLst = new ArrayList();
    	Iterator it = lst.iterator();
    	while(it.hasNext()){
    		Object[] objLst = (Object[])it.next();
    		ProgramClientInfo pClient = new ProgramClientInfo();
    		if(objLst[0]!=null){
    			SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
    		    String admissionDate = formatter.format(((Calendar)objLst[0]).getTime());
    		    pClient.setAdmissionDate(admissionDate);
    		}
    		pClient.setFirstName((String)objLst[1]);
    		pClient.setLastName((String)objLst[2]);
    		pClient.setClientId(objLst[3].toString());
    		clientsLst.add(pClient);
    	}
    	return clientsLst;
    }

	public void setMergeClientDao(MergeClientDao mergeClientDao) {
		this.mergeClientDao = mergeClientDao;
	}

	public void setClientReferralDAO(ClientReferralDAO clientReferralDao) {
		this.clientReferralDao = clientReferralDao;
	}

	public void setProgramQueueDao(ProgramQueueDao programQueueDao) {
		this.programQueueDao = programQueueDao;
	}
	
}
