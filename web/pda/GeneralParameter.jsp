<!--  
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
 * McMaster Unviersity 
 * Hamilton 
 * Ontario, Canada 
 */
-->


<%  
  //operation available to the client - dboperation
  String [][] dbQueries=null;
if (org.oscarehr.common.IsPropertiesOn.isCaisiEnable() && org.oscarehr.common.IsPropertiesOn.isTicklerPlusEnable()){
  dbQueries=new String[][] {
    {"searchappointmentday", "select appointment_no,provider_no, start_time,end_time,name,demographic_no,reason,notes,status from appointment where provider_no=? and appointment_date=? order by start_time "}, 
    {"searchmygroupcount", "select count(provider_no) from mygroup where mygroup_no=? "}, 
    {"searchmygroupprovider", "select provider_no, last_name, first_name from mygroup where mygroup_no=? "}, 
    {"searchmygroupall", "select * from mygroup order by ?"}, 
    {"searchmygroupno", "select * from mygroup group by mygroup_no order by ?"}, 
    {"updateapptstatus", "update appointment set status=? where appointment_no=? "}, //provider_no=? and appointment_date=? and start_time=? and demographic_no=?"},
    {"updatepreference", "update preference set start_hour=?, end_hour=?, every_min=?, mygroup_no=?, color_template=?,new_tickler_warning_window=? where provider_no=? "},
    {"add_preference", "insert into preference values ('\\N',?, ?, ?, ?, ?, ?)"},
    {"search_demograph", "select *  from demographic where demographic_no=?"},
    {"search_encounter", "select * from encounter where demographic_no = ? order by encounter_date desc, encounter_time desc"},
    {"search_encountersingle", "select * from encounter where encounter_no = ?"},
    {"search_encounterform", "select * from encounterform where encounterform_name like ?"},
    {"search_form", "select * from form where form_no=? "}, //new?delete
    {"search_form_no", "select form_no, content from form where demographic_no=? and form_name like ? order by form_date desc, form_time desc,form_no limit 0, 1"}, //new?delete
    {"compare_form", "select form_no, form_name, content from form where demographic_no=? and form_name like ? order by form_date desc, form_time desc,form_no limit 0, 1"},
    {"save_form", "insert into form values('\\N',?,?,?,?,?,?)"},
    {"search_template", "select * from encountertemplate where encountertemplate_name like ?"},
    //{"search_templatevalue", "select * from encountertemplate where encountertemplate_name like ?"},
    {"add_encounter", "insert into encounter values('\\N',?,?,?,?,?,?,?)"},
    {"save_prescribe", "insert into prescribe values('\\N',?,?,?,?,?)"},
    {"search_prescribe", "select * from prescribe where prescribe_no= ?"},
    {"search_prescribe_no", "select prescribe_no from prescribe where demographic_no=?  order by prescribe_date desc, prescribe_time desc limit 0, 1"},
    {"search_demographicaccessory", "select * from demographicaccessory where demographic_no=?"},
    {"search_demographicaccessorycount", "select count(demographic_no) from demographicaccessory where demographic_no=?"},
    {"add_demographicaccessory", "insert into demographicaccessory values(?,?)"},
    {"update_demographicaccessory", "update demographicaccessory set content=? where demographic_no=?"},
    {"add_template", "insert into encountertemplate values(?,?,?,?)"},
    {"delete_template", "delete from encountertemplate where encountertemplate_name = ?"},
    {"search_templatename", "select encountertemplate_name from encountertemplate order by ?"},
    {"add_encounterform", "insert into encounterform values(?,?)"},
    {"delete_encounterform", "delete from encounterform where encounterform_name = ?"},
    {"search_encounterformname", "select encounterform_name from encounterform order by ?"},
    {"search_provider_slp", "select comments from provider where provider_no=?"},

    {"searchprovider", "select provider_no, last_name, first_name from provider where provider_type='doctor' order by ?"}, 
    {"search_scheduleholiday", "select * from scheduleholiday where sdate > ?" }, 
    {"search_scheduledate_datep", "select * from scheduledate where sdate between ? and ? order by sdate" }, 
    {"search_scheduledate_singlep", "select * from scheduledate where sdate between ? and ? and provider_no=? order by sdate" }, 
    {"search_scheduledate_single", "select * from scheduledate where sdate=? and provider_no=?" }, 
  };
}else {
	dbQueries=new String[][] {
    {"searchappointmentday", "select appointment_no,provider_no, start_time,end_time,name,demographic_no,reason,notes,status from appointment where provider_no=? and appointment_date=? order by start_time "}, 
    {"searchmygroupcount", "select count(provider_no) from mygroup where mygroup_no=? "}, 
    {"searchmygroupprovider", "select provider_no, last_name, first_name from mygroup where mygroup_no=? "}, 
    {"searchmygroupall", "select * from mygroup order by ?"}, 
    {"searchmygroupno", "select * from mygroup group by mygroup_no order by ?"}, 
    {"updateapptstatus", "update appointment set status=? where appointment_no=? "}, //provider_no=? and appointment_date=? and start_time=? and demographic_no=?"},
    {"updatepreference", "update preference set start_hour=?, end_hour=?, every_min=?, mygroup_no=?, color_template=? where provider_no=? "},
    {"add_preference", "insert into preference values ('\\N',?, ?, ?, ?, ?, ?)"},
    {"search_demograph", "select *  from demographic where demographic_no=?"},
    {"search_encounter", "select * from encounter where demographic_no = ? order by encounter_date desc, encounter_time desc"},
    {"search_encountersingle", "select * from encounter where encounter_no = ?"},
    {"search_encounterform", "select * from encounterform where encounterform_name like ?"},
    {"search_form", "select * from form where form_no=? "}, //new?delete
    {"search_form_no", "select form_no, content from form where demographic_no=? and form_name like ? order by form_date desc, form_time desc,form_no limit 0, 1"}, //new?delete
    {"compare_form", "select form_no, form_name, content from form where demographic_no=? and form_name like ? order by form_date desc, form_time desc,form_no limit 0, 1"},
    {"save_form", "insert into form values('\\N',?,?,?,?,?,?)"},
    {"search_template", "select * from encountertemplate where encountertemplate_name like ?"},
    //{"search_templatevalue", "select * from encountertemplate where encountertemplate_name like ?"},
    {"add_encounter", "insert into encounter values('\\N',?,?,?,?,?,?,?)"},
    {"save_prescribe", "insert into prescribe values('\\N',?,?,?,?,?)"},
    {"search_prescribe", "select * from prescribe where prescribe_no= ?"},
    {"search_prescribe_no", "select prescribe_no from prescribe where demographic_no=?  order by prescribe_date desc, prescribe_time desc limit 0, 1"},
    {"search_demographicaccessory", "select * from demographicaccessory where demographic_no=?"},
    {"search_demographicaccessorycount", "select count(demographic_no) from demographicaccessory where demographic_no=?"},
    {"add_demographicaccessory", "insert into demographicaccessory values(?,?)"},
    {"update_demographicaccessory", "update demographicaccessory set content=? where demographic_no=?"},
    {"add_template", "insert into encountertemplate values(?,?,?,?)"},
    {"delete_template", "delete from encountertemplate where encountertemplate_name = ?"},
    {"search_templatename", "select encountertemplate_name from encountertemplate order by ?"},
    {"add_encounterform", "insert into encounterform values(?,?)"},
    {"delete_encounterform", "delete from encounterform where encounterform_name = ?"},
    {"search_encounterformname", "select encounterform_name from encounterform order by ?"},
    {"search_provider_slp", "select comments from provider where provider_no=?"},

    {"searchprovider", "select provider_no, last_name, first_name from provider where provider_type='doctor' order by ?"}, 
    {"search_scheduleholiday", "select * from scheduleholiday where sdate > ?" }, 
    {"search_scheduledate_datep", "select * from scheduledate where sdate between ? and ? order by sdate" }, 
    {"search_scheduledate_singlep", "select * from scheduledate where sdate between ? and ? and provider_no=? order by sdate" }, 
    {"search_scheduledate_single", "select * from scheduledate where sdate=? and provider_no=?" }, 
  };

}  
  //associate each operation with an output JSP file - displaymode
  String[][] responseTargets=new String[][] {
    {"day" , "appointmentprovideradminday.jsp"},
    {"month" , "appointmentprovideradminmonth.jsp"},
    {"addstatus" , "provideraddstatus.jsp"},
    {"updatepreference" , "providerupdatepreference.jsp"},
    {"displaymygroup" , "providerdisplaymygroup.jsp"},
    {"encounter" , "providerencounter.jsp"},
    {"prescribe" , "providerprescribe.jsp"},
    {"encountersingle" , "providerencountersingle.jsp"},
    {"vary" , request.getParameter("displaymodevariable")==null?"":URLDecoder.decode(request.getParameter("displaymodevariable")) },
    {"saveform" , "providersaveform.jsp"},
    {"saveencounter" , "providersaveencounter.jsp"},
    {"savebill" , "providersavebill.jsp"},
    {"saveprescribe" , "providersaveprescribe.jsp"},
    {"savedemographicaccessory" , "providersavedemographicaccessory.jsp"},
    {"encounterhistory" , "providerencounterhistory.jsp"},
    {"savedeletetemplate" , "providertemplate.jsp"},
    {"savetemplate" , "providersavetemplate.jsp"},
    {"savedeleteform" , "providerform.jsp"},
    {"save_encounterform" , "providersaveencounterform.jsp"},
    {"ar1" , "formar1_99_12.jsp"},
    {"ar2" , "formar2_99_08.jsp"},
//    {"billingobstetric" , "billingobstetric.jsp"},

  };