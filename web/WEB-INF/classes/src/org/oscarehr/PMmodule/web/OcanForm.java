package org.oscarehr.PMmodule.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.oscarehr.PMmodule.dao.AdmissionDao;
import org.oscarehr.PMmodule.model.Admission;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.OcanClientFormDao;
import org.oscarehr.common.dao.OcanClientFormDataDao;
import org.oscarehr.common.dao.OcanFormOptionDao;
import org.oscarehr.common.dao.OcanStaffFormDao;
import org.oscarehr.common.dao.OcanStaffFormDataDao;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.OcanClientForm;
import org.oscarehr.common.model.OcanClientFormData;
import org.oscarehr.common.model.OcanFormOption;
import org.oscarehr.common.model.OcanStaffForm;
import org.oscarehr.common.model.OcanStaffFormData;
import org.oscarehr.util.LoggedInInfo;
import org.oscarehr.util.SpringUtils;

public class OcanForm {
	
	public static final int PRE_POPULATION_LEVEL_ALL 			= 3;
	public static final int PRE_POPULATION_LEVEL_DEMOGRAPHIC 	= 2;
	public static final int PRE_POPULATION_LEVEL_NONE 			= 1;
	
	private static AdmissionDao admissionDao = (AdmissionDao) SpringUtils.getBean("admissionDao");
	private static DemographicDao demographicDao = (DemographicDao) SpringUtils.getBean("demographicDao");
	private static OcanFormOptionDao ocanFormOptionDao = (OcanFormOptionDao) SpringUtils.getBean("ocanFormOptionDao");
	private static OcanStaffFormDao ocanStaffFormDao = (OcanStaffFormDao) SpringUtils.getBean("ocanStaffFormDao");
	private static OcanStaffFormDataDao ocanStaffFormDataDao = (OcanStaffFormDataDao) SpringUtils.getBean("ocanStaffFormDataDao");	
	private static OcanClientFormDao ocanClientFormDao = (OcanClientFormDao) SpringUtils.getBean("ocanClientFormDao");
	private static OcanClientFormDataDao ocanClientFormDataDao = (OcanClientFormDataDao) SpringUtils.getBean("ocanClientFormDataDao");
	
	
	public static Demographic getDemographic(String demographicId)
	{
		return demographicDao.getDemographic(demographicId);
	}
	
	public static OcanStaffForm getOcanStaffForm(Integer ocanStaffFormId) {
		OcanStaffForm ocanStaffForm = null;
		ocanStaffForm = ocanStaffFormDao.findOcanStaffFormById(ocanStaffFormId);
		return ocanStaffForm;
	}
	
	public static OcanStaffForm getOcanStaffForm(Integer clientId, int prepopulationLevel)
	{
		LoggedInInfo loggedInInfo=LoggedInInfo.loggedInInfo.get();
		
		OcanStaffForm ocanStaffForm=null;
		
		if(prepopulationLevel != OcanForm.PRE_POPULATION_LEVEL_NONE) {
			ocanStaffForm=ocanStaffFormDao.findLatestByFacilityClient(loggedInInfo.currentFacility.getId(), clientId);
		}

		if (ocanStaffForm==null)
		{
			ocanStaffForm=new OcanStaffForm();
			ocanStaffForm.setAddressLine2("");
			
			if(prepopulationLevel != OcanForm.PRE_POPULATION_LEVEL_NONE) {
				Demographic demographic=demographicDao.getDemographicById(clientId);		
				ocanStaffForm.setLastName(demographic.getLastName());
				ocanStaffForm.setFirstName(demographic.getFirstName());	
				ocanStaffForm.setAddressLine1(demographic.getAddress());
				ocanStaffForm.setCity(demographic.getCity());
				ocanStaffForm.setProvince(demographic.getProvince());
				ocanStaffForm.setPostalCode(demographic.getPostal());
				ocanStaffForm.setPhoneNumber(demographic.getPhone());
				ocanStaffForm.setEmail(demographic.getEmail());
				ocanStaffForm.setHcNumber(demographic.getHin());
				ocanStaffForm.setHcVersion(demographic.getVer());
				ocanStaffForm.setDateOfBirth(demographic.getFormattedDob());
				ocanStaffForm.setGender(convertGender(demographic.getSex()));
			}				             
		}
		
		return(ocanStaffForm);
	}
	
	/**
	 * input is ""/M/F/T/O
	 * 
	 * returns M/F/OTH/UNK/CDA
	 */
	public static String convertGender(String oscarGender) {
		if(oscarGender == null || oscarGender.equals("")) {
			return "UNK";
		}
		if(oscarGender.equals("T") || oscarGender.equals("O")) {
			return "OTH";
		}
		if(oscarGender.equals("M")) {
			return "M";
		}
		if(oscarGender.equals("F")) {
			return "F";
		}
		return "UNK";
	}
	
	public static List<OcanFormOption> getOcanFormOptions(String category)
	{
		List<OcanFormOption> results=ocanFormOptionDao.findByVersionAndCategory("1.2", category);
		return(results);
	}
	
	private static List<OcanStaffFormData> getStaffAnswers(Integer ocanStaffFormId, String question, int prepopulationLevel)
	{
		if(prepopulationLevel != OcanForm.PRE_POPULATION_LEVEL_ALL) {
			return(new ArrayList<OcanStaffFormData>()); 
		}
		if (ocanStaffFormId==null) return(new ArrayList<OcanStaffFormData>()); 
			
		return(ocanStaffFormDataDao.findByQuestion(ocanStaffFormId, question));
	}
	
	private static List<OcanClientFormData> getClientAnswers(Integer ocanClientFormId, String question, int prepopulationLevel)
	{
		if(prepopulationLevel != OcanForm.PRE_POPULATION_LEVEL_ALL) {
			return(new ArrayList<OcanClientFormData>()); 
		}
		
		if (ocanClientFormId==null) return(new ArrayList<OcanClientFormData>()); 
			
		return(ocanClientFormDataDao.findByQuestion(ocanClientFormId, question));
	}
	
	public static String renderAsDate(Integer ocanStaffFormId, String question, boolean required, int prepopulationLevel)
	{
		return renderAsDate(ocanStaffFormId,question,required, prepopulationLevel, false);
	}
	
	/**
	 * This method is meant to return a bunch of html <option> tags for each list element.
	 */
	public static String renderAsDate(Integer ocanStaffFormId, String question, boolean required, int prepopulationLevel, boolean clientForm)
	{
		String value="", className="";
		if(!clientForm) {
			List<OcanStaffFormData> existingAnswers=getStaffAnswers(ocanStaffFormId, question, prepopulationLevel);
			if(existingAnswers.size()>0) {value = existingAnswers.get(0).getAnswer();}
		} else {
			List<OcanClientFormData> existingAnswers=getClientAnswers(ocanStaffFormId, question, prepopulationLevel);
			if(existingAnswers.size()>0) {value = existingAnswers.get(0).getAnswer();}
		}
		if(required) {className="{validate: {required:true}}";}
		return "<input type=\"text\" value=\"" + value + "\" id=\""+question+"\" name=\""+question+"\" onfocus=\"this.blur()\" readonly=\"readonly\" class=\""+className+"\"/> <img title=\"Calendar\" id=\"cal_"+question+"\" src=\"../../images/cal.gif\" alt=\"Calendar\" border=\"0\"><script type=\"text/javascript\">Calendar.setup({inputField:'"+question+"',ifFormat :'%Y-%m-%d',button :'cal_"+question+"',align :'cr',singleClick :true,firstDay :1});</script><img src=\"../../images/icon_clear.gif\" border=\"0\"/ onclick=\"clearDate('"+question+"');\">";
	}
	
	public static String renderAsDate(Integer ocanStaffFormId, String question, boolean required, String defaultValue , int prepopulationLevel)
	{
		return renderAsDate(ocanStaffFormId, question, required, defaultValue,prepopulationLevel,false);
	}
	
	public static String renderAsDate(Integer ocanStaffFormId, String question, boolean required, String defaultValue, int prepopulationLevel, boolean clientForm)
	{
		List<OcanStaffFormData> existingAnswers=getStaffAnswers(ocanStaffFormId, question, prepopulationLevel);
		String value="", className="";
		if(existingAnswers.size()>0) {value = existingAnswers.get(0).getAnswer();}
		if(value.equals("")) {value =defaultValue;}
		if(required) {className="{validate: {required:true}}";}
		return "<input type=\"text\" value=\"" + value + "\" id=\""+question+"\" name=\""+question+"\" onfocus=\"this.blur()\" readonly=\"readonly\" class=\""+className+"\"/> <img title=\"Calendar\" id=\"cal_"+question+"\" src=\"../../images/cal.gif\" alt=\"Calendar\" border=\"0\"><script type=\"text/javascript\">Calendar.setup({inputField:'"+question+"',ifFormat :'%Y-%m-%d',button :'cal_"+question+"',align :'cr',singleClick :true,firstDay :1});</script>";
	}	
	
	public static List<Admission> getAdmissions(Integer clientId) {
		LoggedInInfo loggedInInfo=LoggedInInfo.loggedInInfo.get();
		
		return(admissionDao.getAdmissionsByFacility(clientId, loggedInInfo.currentFacility.getId()));
	}
	
	public static String getEscapedAdmissionSelectionDisplay(Admission admission)
	{
		StringBuilder sb=new StringBuilder();
		
		sb.append(admission.getProgramName());
		sb.append(" ( ");
		sb.append(DateFormatUtils.ISO_DATE_FORMAT.format(admission.getAdmissionDate()));
		sb.append(" - ");
		if (admission.getDischargeDate()==null) sb.append("current");
		else sb.append(DateFormatUtils.ISO_DATE_FORMAT.format(admission.getDischargeDate()));
		sb.append(" )");
		
		return(StringEscapeUtils.escapeHtml(sb.toString()));
	}
	
	
	public static String renderAsSelectOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel)
	{
		return renderAsSelectOptions(ocanStaffFormId,question, options, prepopulationLevel, false);
	}
	/**
	 * This method is meant to return a bunch of html <option> tags for each list element.
	 */
	public static String renderAsSelectOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel, boolean clientForm)
	{
		List<OcanStaffFormData> existingStaffAnswers=null;
		List<OcanClientFormData> existingClientAnswers=null;
		if(!clientForm)
			existingStaffAnswers = getStaffAnswers(ocanStaffFormId, question, prepopulationLevel);
		else
			existingClientAnswers = getClientAnswers(ocanStaffFormId, question, prepopulationLevel);

		StringBuilder sb=new StringBuilder();

		sb.append("<option value=\"\">Select an answer</option>");
		for (OcanFormOption option : options)
		{
			String htmlEscapedName=StringEscapeUtils.escapeHtml(option.getOcanDataCategoryName());
			//String lengthLimitedEscapedName=limitLengthAndEscape(option.getOcanDataCategoryName());
			String selected=null;
			if(!clientForm)
				selected=(OcanStaffFormData.containsAnswer(existingStaffAnswers, option.getOcanDataCategoryValue())?"selected=\"selected\"":"");
			else
				selected=(OcanClientFormData.containsAnswer(existingClientAnswers, option.getOcanDataCategoryValue())?"selected=\"selected\"":"");
			
			sb.append("<option "+selected+" value=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"\" title=\""+htmlEscapedName+"\">"+htmlEscapedName+"</option>");
		}
		
		return(sb.toString());
	}
	
	public static String renderAsProvinceSelectOptions(OcanStaffForm ocanStaffForm)
	{
		String province = ocanStaffForm.getProvince();
		if(province==null) province = "ON";
		List<OcanFormOption> options = getOcanFormOptions("Province List");
		
		StringBuilder sb=new StringBuilder();

		for (OcanFormOption option : options)
		{
			String htmlEscapedName=StringEscapeUtils.escapeHtml(option.getOcanDataCategoryName());
			//String lengthLimitedEscapedName=limitLengthAndEscape(option.getOcanDataCategoryName());
			String selected=province.equals(option.getOcanDataCategoryValue())?"selected=\"selected\"":"";

			sb.append("<option "+selected+" value=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"\" title=\""+htmlEscapedName+"\">"+htmlEscapedName+"</option>");
		}
		
		return(sb.toString());
	}
	public static String renderAsDomainSelectOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, String[] valuesToInclude, int prepopulationLevel)
	{
		List<OcanStaffFormData> existingAnswers=getStaffAnswers(ocanStaffFormId, question ,prepopulationLevel);

		StringBuilder sb=new StringBuilder();

		for (OcanFormOption option : options)
		{
			if(valuesToInclude !=null && valuesToInclude.length>0) {
				boolean include=false;
				for(String inclValue:valuesToInclude) {
					if(option.getOcanDataCategoryValue().equals(inclValue)) {
						include=true;
						break;
					}
				}
				if(!include) {
					continue;
				}
			}
			
			String htmlEscapedName=StringEscapeUtils.escapeHtml(option.getOcanDataCategoryName());
			//String lengthLimitedEscapedName=limitLengthAndEscape(option.getOcanDataCategoryName());
			String selected=(OcanStaffFormData.containsAnswer(existingAnswers, option.getOcanDataCategoryValue())?"selected=\"selected\"":"");

			sb.append("<option "+selected+" value=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"\" title=\""+htmlEscapedName+"\">"+htmlEscapedName+"</option>");
		}
		
		return(sb.toString());
	}
	
	public static String renderAsSelectOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, String defaultValue, int prepopulationLevel)
	{
		return renderAsSelectOptions(ocanStaffFormId, question, options, defaultValue, prepopulationLevel, false);
	}
	/**
	 * This method is meant to return a bunch of html <option> tags for each list element.
	 */
	public static String renderAsSelectOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, String defaultValue, int prepopulationLevel, boolean clientForm)
	{
		List<OcanStaffFormData> existingAnswers=getStaffAnswers(ocanStaffFormId, question, prepopulationLevel);
		boolean useDefaultValue=false;
		if(existingAnswers.size()==0) {
			useDefaultValue=true;
		}
		StringBuilder sb=new StringBuilder();

		for (OcanFormOption option : options)
		{
			String htmlEscapedName=StringEscapeUtils.escapeHtml(option.getOcanDataCategoryName());
			//String lengthLimitedEscapedName=limitLengthAndEscape(option.getOcanDataCategoryName());
			String selected="";
			if(!useDefaultValue)
				selected=(OcanStaffFormData.containsAnswer(existingAnswers, option.getOcanDataCategoryValue())?"selected=\"selected\"":"");
			else {
				if(option.getOcanDataCategoryValue().equals(defaultValue)) {
					selected="selected=\"selected\"";
				}
			}

			sb.append("<option "+selected+" value=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"\" title=\""+htmlEscapedName+"\">"+htmlEscapedName+"</option>");
		}
		
		return(sb.toString());
	}	
	
	public static String renderAsTextArea(Integer ocanStaffFormId, String question, int rows, int cols, int prepopulationLevel)
	{
		return renderAsTextArea(ocanStaffFormId, question, rows, cols, prepopulationLevel, false);
	}
	
	public static String renderAsTextArea(Integer ocanStaffFormId, String question, int rows, int cols, int prepopulationLevel, boolean clientForm)
	{
		List<OcanStaffFormData> existingAnswers= null;
		List<OcanClientFormData> existingClientAnswers=null;

		StringBuilder sb=new StringBuilder();

		sb.append("<textarea name=\""+question+"\" id=\""+question+"\" rows=\"" + rows + "\" cols=\"" + cols + "\">");

		if(!clientForm) {
			existingAnswers=getStaffAnswers(ocanStaffFormId, question, prepopulationLevel);
			if(existingAnswers.size()>0) {
				sb.append(existingAnswers.get(0).getAnswer());
			}	
		} else { 
			existingClientAnswers=getClientAnswers(ocanStaffFormId, question, prepopulationLevel);
			if(existingClientAnswers.size()>0) {
				sb.append(existingClientAnswers.get(0).getAnswer());
			}	
		}
		
		
		sb.append("</textarea>");
		return(sb.toString());
	}
	
	public static String renderAsSoATextArea(Integer ocanStaffFormId, String question, int rows, int cols, int prepopulationLevel)
	{
		List<OcanStaffFormData> existingAnswers=getStaffAnswers(ocanStaffFormId, question,prepopulationLevel);

		StringBuilder sb=new StringBuilder();

		sb.append("<textarea name=\""+question+"\" id=\""+question+"\" rows=\"" + rows + "\" cols=\"" + cols + "\" readonly=\"readonly\" onfocus=\"this.blur()\">");
		if(existingAnswers.size()>0) {
			sb.append(existingAnswers.get(0).getAnswer());
		}
		sb.append("</textarea>");
		return(sb.toString());
	}
	
	public static String renderAsTextField(Integer ocanStaffFormId, String question, int size, int prepopulationLevel)
	{
		return renderAsTextField(ocanStaffFormId, question, size, prepopulationLevel, false);
	}
	
	public static String renderAsTextField(Integer ocanStaffFormId, String question, int size, int prepopulationLevel, boolean clientForm)
	{
		List<OcanStaffFormData> existingAnswers=getStaffAnswers(ocanStaffFormId, question, prepopulationLevel);

		String value = "";
		if(existingAnswers.size()>0) {
			value = existingAnswers.get(0).getAnswer();
		}
		StringBuilder sb=new StringBuilder();

		sb.append("<input type=\"text\" name=\""+question+"\" id=\""+question+"\" size=\"" + size + "\" value=\""+value+"\"/>");
		
		return(sb.toString());
	}
	
	public static String renderAsCheckBoxOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel)
	{
		return renderAsCheckBoxOptions(ocanStaffFormId, question,options,prepopulationLevel, false);
	}
	
	public static String renderAsCheckBoxOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel, boolean clientForm)
	{
		List<OcanStaffFormData> existingAnswers=getStaffAnswers(ocanStaffFormId, question, prepopulationLevel);
 
		StringBuilder sb=new StringBuilder();

		for (OcanFormOption option : options)
		{
			String htmlEscapedName=StringEscapeUtils.escapeHtml(option.getOcanDataCategoryName());
			//String lengthLimitedEscapedName=limitLengthAndEscape(option.getOcanDataCategoryName());
			String checked=(OcanStaffFormData.containsAnswer(existingAnswers, option.getOcanDataCategoryValue())?"checked=\"checked\"":"");
				
			sb.append("<div title=\""+htmlEscapedName+"\"><input type=\"checkBox\" "+checked+" name=\""+question+"\" value=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"\" /> "+htmlEscapedName+"</div>");
		}
		
		return(sb.toString());
	}
	
	public static String renderLegalStatusOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel, boolean clientForm)
	{
		List<OcanStaffFormData> existingAnswers=getStaffAnswers(ocanStaffFormId, question, prepopulationLevel);
 
		StringBuilder sb=new StringBuilder();

		Map<String,OcanFormOption> optionMap = new HashMap<String,OcanFormOption>();
		for (OcanFormOption option : options)
		{
			optionMap.put(option.getOcanDataCategoryValue(), option);
		}
		
		
		sb.append("<h4>Pre-Charge</h4>");
		renderSingleCheckbox(optionMap.get("013-01"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-02"),sb,question,existingAnswers);
		sb.append("<h4>Pre-Trial</h4>");
		renderSingleCheckbox(optionMap.get("013-03"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-04"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-05"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-06"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-07"),sb,question,existingAnswers);
		sb.append("<h4>Custody Status</h4>");
		renderSingleCheckbox(optionMap.get("013-17"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-18"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-19"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-20"),sb,question,existingAnswers);
		sb.append("<h4>Outcomes</h4>");
		renderSingleCheckbox(optionMap.get("013-08"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-09"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-10"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-11"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-12"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-13"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-14"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-15"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("013-16"),sb,question,existingAnswers);
		sb.append("<h4>Other</h4>");
		renderSingleCheckbox(optionMap.get("013-21"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("UNK"),sb,question,existingAnswers);
		renderSingleCheckbox(optionMap.get("CDA"),sb,question,existingAnswers);
		
		
		return(sb.toString());
	}
	
	public static void renderSingleCheckbox(OcanFormOption option,StringBuilder sb, String question, List<OcanStaffFormData> existingAnswers) {
		String htmlEscapedName=StringEscapeUtils.escapeHtml(option.getOcanDataCategoryName());			
		String checked=(OcanStaffFormData.containsAnswer(existingAnswers, option.getOcanDataCategoryValue())?"checked=\"checked\"":"");
			
		sb.append("<div title=\""+htmlEscapedName+"\"><input type=\"checkBox\" "+checked+" name=\""+question+"\" value=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"\" /> "+htmlEscapedName+"</div>");
	}
	
	public static String renderAsHiddenField(Integer ocanStaffFormId, String question, int prepopulationLevel)
	{
		return renderAsHiddenField(ocanStaffFormId, question, prepopulationLevel, false);
	}
	
	public static String renderAsHiddenField(Integer ocanStaffFormId, String question, int prepopulationLevel, boolean clientForm)
	{
		List<OcanStaffFormData> existingAnswers=getStaffAnswers(ocanStaffFormId, question, prepopulationLevel);

		String value = "";
		if(existingAnswers.size()>0) {
			value = existingAnswers.get(0).getAnswer();
		}
		StringBuilder sb=new StringBuilder();

		sb.append("<input type=\"hidden\" name=\""+question+"\" id=\""+question+"\" value=\""+value+"\"/>");
		
		return(sb.toString());
	}
	
	
	
	
	///client form//////
	
	public static OcanClientForm getOcanClientForm(Integer clientId, int prepopulationLevel)
	{
		LoggedInInfo loggedInInfo=LoggedInInfo.loggedInInfo.get();
		
		OcanClientForm ocanClientForm=null;
		
		if(prepopulationLevel != OcanForm.PRE_POPULATION_LEVEL_NONE) {
			ocanClientForm = ocanClientFormDao.findLatestByFacilityClient(loggedInInfo.currentFacility.getId(), clientId);
		}

		if (ocanClientForm==null)
		{
			ocanClientForm=new OcanClientForm();

			if(prepopulationLevel != OcanForm.PRE_POPULATION_LEVEL_NONE) {
				Demographic demographic=demographicDao.getDemographicById(clientId);
				ocanClientForm.setLastName(demographic.getLastName());
				ocanClientForm.setFirstName(demographic.getFirstName());				
				ocanClientForm.setDateOfBirth(demographic.getFormattedDob());
			}
		}
		
		return(ocanClientForm);
	}
	
	/*
	public static String renderAsDrugUseCheckBoxOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel)
	{
		return renderAsDrugUseCheckBoxOptions(ocanStaffFormId, question,options,prepopulationLevel, false);
	}
	
	public static String renderAsDrugUseCheckBoxOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel, boolean clientForm)
	{
		 
		StringBuilder sb=new StringBuilder();
		sb.append("<table width=\"100%\">");
		sb.append("<tr><td></td><td>Past 6 Months</td><td>Ever</td></tr>");
		for (OcanFormOption option : options)
		{
			String htmlEscapedName=StringEscapeUtils.escapeHtml(option.getOcanDataCategoryName());
			String value = option.getOcanDataCategoryValue(); //drug id
			
			List<OcanStaffFormData> freqMnthAnswer = getStaffAnswers(ocanStaffFormId, value+"_freq_6months", prepopulationLevel);
			List<OcanStaffFormData> freqEverAnswer = getStaffAnswers(ocanStaffFormId, value+"_freq_ever", prepopulationLevel);
			
			String checked2=((freqMnthAnswer.size()>0)?"checked=\"checked\"":"");
			String checked3=((freqEverAnswer.size()>0)?"checked=\"checked\"":"");
				
			sb.append("<tr><td>"+htmlEscapedName+"</td><td><input drugfreq=\"true\" type=\"checkBox\" "+checked2+" name=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"_freq_6months\" value=\"true\" /></td><td><input drugfreq=\"true\" type=\"checkBox\" "+checked3+" name=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"_freq_ever\" value=\true\" /></td></tr>");
		}
		
		sb.append(renderAsDrugInjectionCheckBoxOptions(ocanStaffFormId,question,options,prepopulationLevel,clientForm));
		sb.append("</table>");
		return(sb.toString());
	}

	
	public static String renderAsDrugInjectionCheckBoxOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel, boolean clientForm)
	{
		 
		StringBuilder sb=new StringBuilder();
		
	
		List<OcanStaffFormData> freqMnthAnswer = getStaffAnswers(ocanStaffFormId, "drug_injection_freq_6months", prepopulationLevel);
		List<OcanStaffFormData> freqEverAnswer = getStaffAnswers(ocanStaffFormId, "drug_injection_freq_ever", prepopulationLevel);
		
		String checked2=((freqMnthAnswer.size()>0)?"checked=\"checked\"":"");
		String checked3=((freqEverAnswer.size()>0)?"checked=\"checked\"":"");
			
		sb.append("<tr><td>Has the substance been injected?</td><td><input druginjection=\"true\" type=\"checkBox\" "+checked2+" name=\"drug_injection_freq_6months\" value=\"true\" /></td><td><input druginjection=\"true\" type=\"checkBox\" "+checked3+" name=\"drug_injection_freq_ever\" value=\true\" /></td></tr>");
	
		
		return(sb.toString());
	}
	*/
	
	public static String renderAsDrugUseCheckBoxOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel)
	{
		return renderAsDrugUseCheckBoxOptions(ocanStaffFormId, question,options,prepopulationLevel, false);
	}
	
	public static String renderAsDrugUseCheckBoxOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel, boolean clientForm)
	{
		 
		StringBuilder sb=new StringBuilder();
		sb.append("<table width=\"100%\">");
		sb.append("<tr><td></td><td>Past 6 Months</td><td>Ever</td></tr>");
		for (OcanFormOption option : options)
		{
			String htmlEscapedName=StringEscapeUtils.escapeHtml(option.getOcanDataCategoryName());
			String value = option.getOcanDataCategoryValue(); //drug id
			
			List<OcanStaffFormData> freqMnthAnswer = getStaffAnswers(ocanStaffFormId, value+"_freq_6months", prepopulationLevel);
			List<OcanStaffFormData> freqEverAnswer = getStaffAnswers(ocanStaffFormId, value+"_freq_ever", prepopulationLevel);
			
			String checked2=((freqMnthAnswer.size()>0)?"checked=\"checked\"":"");
			String checked3=((freqEverAnswer.size()>0)?"checked=\"checked\"":"");
			/*
			List<OcanStaffFormData> freqAnswer = getStaffAnswers(ocanStaffFormId, value+"_DrugUseFreq", prepopulationLevel);
			Iterator it = freqAnswer.iterator();
			while(it.hasNext()) {
				OcanStaffFormData data = (OcanStaffFormData)it.next();
				checked2=((data.getAnswer().equals("5"))?"checked":"");
				checked3=((data.getAnswer().equals("6"))?"checked":"");
			}	
			*/
			sb.append("<tr><td>"+htmlEscapedName+"</td><td><input type=\"checkbox\" "+checked2+" id=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"_freq_6months\" name=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"_freq_6months\" value=\"5\" /></td><td><input type=\"checkbox\" "+checked3+" id=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"_freq_ever\" name=\""+StringEscapeUtils.escapeHtml(option.getOcanDataCategoryValue())+"_freq_ever\" value=\"6\" /></td></tr>");
		}
		
		sb.append(renderAsDrugInjectionCheckBoxOptions(ocanStaffFormId,question,options,prepopulationLevel,clientForm));
		sb.append("</table>");
		return(sb.toString());
	}

	
	public static String renderAsDrugInjectionCheckBoxOptions(Integer ocanStaffFormId, String question, List<OcanFormOption> options, int prepopulationLevel, boolean clientForm)
	{
		 
		StringBuilder sb=new StringBuilder();
		/*
		String checked2 = null;
		String checked3 = null;
		
		List<OcanStaffFormData> freqAnswer = getStaffAnswers(ocanStaffFormId, "drug_injection_freq", prepopulationLevel);
		Iterator it = freqAnswer.iterator();
		while(it.hasNext()) {
			OcanStaffFormData data = (OcanStaffFormData) it.next();
			checked2=((data.getAnswer().equals("5"))?"checked":"");
			checked3=((data.getAnswer().equals("6"))?"checked":"");
		}
		*/
		List<OcanStaffFormData> freqMnthAnswer = getStaffAnswers(ocanStaffFormId, "drug_injection_freq_6months", prepopulationLevel);
		List<OcanStaffFormData> freqEverAnswer = getStaffAnswers(ocanStaffFormId, "drug_injection_freq_ever", prepopulationLevel);
		
		String checked2=((freqMnthAnswer.size()>0)?"checked=\"checked\"":"");
		String checked3=((freqEverAnswer.size()>0)?"checked=\"checked\"":"");
		
		sb.append("<tr><td>Has the substance been injected?</td><td><input type=\"checkbox\" "+checked2+" id=\"drug_injection_freq_6months\" name=\"drug_injection_freq_6months\" value=\"5\" /></td><td><input type=\"checkbox\" "+checked3+" id=\"drug_injection_freq_ever\" name=\"drug_injection_freq_ever\" value=\"6\" /></td></tr>");
	
		
		return(sb.toString());
	}


}
