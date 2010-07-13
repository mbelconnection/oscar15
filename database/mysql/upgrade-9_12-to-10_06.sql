-- Both regular and CAISI database updates from the 9.12 to 10.06 standard schema
-- From update-2010-02-01.sql to update-2010-6-29.sql for OSCAR
-- From patch-2010-01-18.sql to patch-2010-06-08.sql for CAISI

-- Note that to add the Rich Text Letter eForm, you need to merge the OscarDocument.war with the new one, ie
-- add the new support files from tomcat6/webapps/OscarDocument/oscar_mcmaster/eform/images/ to the existing ones
-- and run the following

-- INSERT INTO eform VALUES (1,'letter','','letter generator','2010-05-02','10:00:00',NULL,1,'<html><head>\r\n<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">\r\n\r\n<title>Rich Text Letter</title>\r\n<style type=\"text/css\">\r\n.butn {width: 140px;}\r\n</style>\r\n\r\n<style type=\"text/css\" media=\"print\">\r\n.DoNotPrint {display: none;}\r\n\r\n</style>\r\n\r\n<script language=\"javascript\">\r\nvar needToConfirm = false;\r\n\r\n//keypress events trigger dirty flag for the iFrame and the subject line\r\ndocument.onkeyup=setDirtyFlag\r\n\r\n\r\nfunction setDirtyFlag() {\r\n	needToConfirm = true; \r\n}\r\n\r\nfunction releaseDirtyFlag() {\r\n	needToConfirm = false; //Call this function if dosent requires an alert.\r\n	//this could be called when save button is clicked\r\n}\r\n\r\n\r\nwindow.onbeforeunload = confirmExit;\r\n\r\nfunction confirmExit() {\r\n	if (needToConfirm)\r\n	return \"You have attempted to leave this page. If you have made any changes without clicking the Submit button, your changes will be lost. Are you sure you want to exit this page?\";\r\n}\r\n\r\n</script>\r\n\r\n\r\n\r\n</head><body onload=\"Start()\" bgcolor=\"FFFFFF\">\r\n\r\n\r\n<!-- START OF EDITCONTROL CODE --> \r\n\r\n<script language=\"javascript\" type=\"text/javascript\" src=\"${oscar_image_path}editControl.js\"></script>\r\n      \r\n<script language=\"javascript\">\r\n\r\n    //put any of the optional configuration variables that you want here\r\n    cfg_width = \'640\';                    //editor control width in pixels\r\n    cfg_height = \'520\';                   //editor control height in pixels\r\n    cfg_editorname = \'edit\';                //the handle for the editor                  \r\n    cfg_isrc = \'${oscar_image_path}\';         //location of the button icon files\r\n    cfg_filesrc = \'${oscar_image_path}\';         //location of the html files\r\n    cfg_template = \'blank.html\';	    //default style and content template\r\n    cfg_formattemplate = \'<option value=\"\">&mdash; template &mdash;</option>  <option value=\"blank\">blank</option>  <option value=\"consult\">consult</option> <option value=\"certificate\">work note</option> <option value=\"narcotic\">narcotic contract</option> <option value=\"MissedAppointment\">missed appt</option> <option value=\"custom\">custom</option></select>\';\r\n    //cfg_layout = \'[all]\';             //adjust the format of the buttons here\r\n    cfg_layout = \r\n\'<table style=\"background-color:#ccccff; width:640px\"><tr id=control1><td>[bold][italic][underlined][strike][subscript][superscript]|[left][center][full][right]|[unordered][ordered][rule]|[undo][redo]|[indent][outdent][select-all][clean]|[table]</td></tr><tr id=control2><td>[select-block][select-face][select-size][select-template]|[image][clock][date][spell][help]</td></tr></table>[edit-area]\';\r\n    insertEditControl(); // Initialise the edit control and sets it at this point in the webpage\r\n\r\n    function Start() {\r\n        // set eventlistener for the iframe to flag changes in the text displayed \r\n	var agent=navigator.userAgent.toLowerCase(); //for non IE browsers\r\n        if ((agent.indexOf(\"msie\") == -1) || (agent.indexOf(\"opera\") != -1)){\r\n		document.getElementById(cfg_editorname).contentWindow.addEventListener(\'keypress\',setDirtyFlag, true);\r\n	}\r\n\r\n	if (document.getElementById(\'recent_rx\').value.length<1){\r\n		//document.RichTextLetter.RecentMedications.style.visibility=\"hidden\";\r\n		document.getElementById(\'RecentMedications\').style.display = \"none\";\r\n	}\r\n\r\n        // reformat values of multiline database values from \\n lines to <br>\r\n        htmlLine(\'label\');\r\n        htmlLine(\'reminders\');\r\n        htmlLine(\'ongoingconcerns\');\r\n        htmlLine(\'medical_history\');document.getElementById(\'allergies_des\').value\r\n        htmlLine(\'other_medications_history\');  //family history  ... don\'t ask\r\n        htmlLine(\'social_family_history\');  //social history\r\n        htmlLine(\'address\');\r\n        htmlLine(\'NameAddress\');\r\n        htmlLine(\'clinic_label\');\r\n        htmlLine(\'clinic_address\');\r\n        htmlLine(\'druglist_generic\');\r\n        htmlLine(\'druglist_trade\');\r\n        htmlLine(\'recent_rx\');\r\n\r\n	var gender=document.getElementById(\'sex\').value; \r\n	if (gender==\'F\'){\r\n		document.getElementById(\'he_she\').value=\'she\'; \r\n		document.getElementById(\'his_her\').value=\'her\';\r\n		document.getElementById(\'gender\').value=\'female\';\r\n	}\r\n	var mySplitResult = document.getElementById(\'referral_name\').value.toString().split(\',\'); \r\n	document.getElementById(\'referral_nameL\').value=mySplitResult[0];\r\n\r\n	document.getElementById(\'letterhead\').value= genericLetterhead();\r\n\r\n	\r\n        // set the HTML contents of this edit control from the value saved in Oscar (if any)\r\n	var contents=document.getElementById(\'Letter\').value\r\n	if (contents.length==0){\r\n		parseTemplate();\r\n	} else {\r\n		seteditControlContents(cfg_editorname,contents);\r\n	}\r\n    }\r\n \r\n    function htmlLine(theelement) { \r\n	var temp = new Array();\r\n	if (document.getElementById(theelement).value.length>0){\r\n		temp=document.getElementById(theelement).value.split(\'\\n\'); \r\n		contents=\'\';\r\n		var x;\r\n		for (x in temp) {\r\n			contents += temp[x]+\'<br>\';\r\n			}\r\n		document.getElementById(theelement).value=contents;\r\n		}\r\n    }\r\n\r\n    function genericLetterhead() {\r\n        // set the HTML contents of the letterhead\r\n	var address = \'<table border=0><tbody><tr><td><font size=6>\'+document.getElementById(\'clinic_name\').value+\'</font></td></tr><tr><td><font size=2>\'+ document.getElementById(\'clinic_addressLineFull\').value+ \' Fax: \'+document.getElementById(\'clinic_fax\').value+\' Phone: \'+document.getElementById(\'clinic_phone\').value+\'</font><hr></td></tr></tbody></table><br>\'\r\n	if ((document.getElementById(\'clinic_name\').value.toLowerCase()).indexOf(\'amily health team\',0)>-1){\r\n		address=fhtLetterhead();\r\n	}\r\n	return address;\r\n    }\r\n\r\n    function fhtLetterhead() {\r\n        // set the HTML contents of the letterhead using FHT colours\r\n	var address = document.getElementById(\'clinic_addressLineFull\').value+ \'<br>Fax:\'+document.getElementById(\'clinic_fax\').value+\' Phone:\'+document.getElementById(\'clinic_phone\').value ;\r\n	if (document.getElementById(\'doctor\').value.indexOf(\'zapski\')>0){address=\'293 Meridian Avenue, Haileybury, ON P0J 1K0<br> Tel 705-672-2442 Fax 705-672-2384\'};\r\n	address=\'<table style=\\\'text-align: right;\\\' border=\\\'0\\\'><tbody><tr style=\\\'font-style: italic; color: rgb(71, 127, 128);\\\'><td><font size=\\\'+2\\\'>\'+document.getElementById(\'clinic_name\').value+\'</font> <hr style=\\\'width: 100%; height: 3px; color: rgb(212, 118, 0); background-color: rgb(212, 118, 0);\\\'></td> </tr> <tr style=\\\'color: rgb(71, 127, 128);\\\'> <td><font size=\\\'+1\\\'>Family Health Team<br> &Eacute;quipe Sant&eacute; Familiale</font></td> </tr> <tr style=\\\'color: rgb(212, 118, 0); \\\'> <td><small>\'+address+\'</small></td> </tr> </tbody> </table>\';\r\n	return address;\r\n    }\r\n</script>\r\n\r\n<!-- END OF EDITCONTROL CODE -->\r\n\r\n\r\n<form method=\"post\" action=\"\" name=\"RichTextLetter\" >\r\n\r\n<!-- START OF DATABASE PLACEHOLDERS -->\r\n\r\n<input type=\"hidden\" name=\"clinic_name\" id=\"clinic_name\" oscarDB=clinic_name>\r\n<input type=\"hidden\" name=\"clinic_address\" id=\"clinic_address\" oscarDB=clinic_address>\r\n<input type=\"hidden\" name=\"clinic_addressLine\" id=\"clinic_addressLine\" oscarDB=clinic_addressLine>\r\n<input type=\"hidden\" name=\"clinic_addressLineFull\" id=\"clinic_addressLineFull\" oscarDB=clinic_addressLineFull>\r\n<input type=\"hidden\" name=\"clinic_label\" id=\"clinic_label\" oscarDB=clinic_label>\r\n<input type=\"hidden\" name=\"clinic_fax\" id=\"clinic_fax\" oscarDB=clinic_fax>\r\n<input type=\"hidden\" name=\"clinic_phone\" id=\"clinic_phone\" oscarDB=clinic_phone>\r\n<input type=\"hidden\" name=\"clinic_city\" id=\"clinic_city\" oscarDB=clinic_city>\r\n<input type=\"hidden\" name=\"clinic_province\" id=\"clinic_province\" oscarDB=clinic_province>\r\n<input type=\"hidden\" name=\"clinic_postal\" id=\"clinic_postal\" oscarDB=clinic_postal>\r\n\r\n<input type=\"hidden\" name=\"patient_name\" id=\"patient_name\" oscarDB=patient_name>\r\n<input type=\"hidden\" name=\"first_last_name\" id=\"first_last_name\" oscarDB=first_last_name>\r\n<input type=\"hidden\" name=\"patient_nameF\" id=\"patient_nameF\" oscarDB=patient_nameF >\r\n<input type=\"hidden\" name=\"patient_nameL\" id=\"patient_nameL\" oscarDB=patient_nameL >\r\n<input type=\"hidden\" name=\"label\" id=\"label\" oscarDB=label>\r\n<input type=\"hidden\" name=\"NameAddress\" id=\"NameAddress\" oscarDB=NameAddress>\r\n<input type=\"hidden\" name=\"address\" id=\"address\" oscarDB=address>\r\n<input type=\"hidden\" name=\"addressline\" id=\"addressline\" oscarDB=addressline>\r\n<input type=\"hidden\" name=\"phone\" id=\"phone\" oscarDB=phone>\r\n<input type=\"hidden\" name=\"phone2\" id=\"phone2\" oscarDB=phone2>\r\n<input type=\"hidden\" name=\"province\" id=\"province\" oscarDB=province>\r\n<input type=\"hidden\" name=\"city\" id=\"city\" oscarDB=city>\r\n<input type=\"hidden\" name=\"postal\" id=\"postal\" oscarDB=postal>\r\n<input type=\"hidden\" name=\"dob\" id=\"dob\" oscarDB=dob>\r\n<input type=\"hidden\" name=\"dobc\" id=\"dobc\" oscarDB=dobc>\r\n<input type=\"hidden\" name=\"dobc2\" id=\"dobc2\" oscarDB=dobc2>\r\n<input type=\"hidden\" name=\"hin\" id=\"hin\" oscarDB=hin>\r\n<input type=\"hidden\" name=\"hinc\" id=\"hinc\" oscarDB=hinc>\r\n<input type=\"hidden\" name=\"hinversion\" id=\"hinversion\" oscarDB=hinversion>\r\n<input type=\"hidden\" name=\"ageComplex\" id=\"ageComplex\" oscarDB=ageComplex >\r\n<input type=\"hidden\" name=\"age\" id=\"age\" oscarDB=age >\r\n<input type=\"hidden\" name=\"sex\" id=\"sex\" oscarDB=sex >\r\n<input type=\"hidden\" name=\"chartno\" id=\"chartno\" oscarDB=chartno >\r\n\r\n<input type=\"hidden\" name=\"medical_history\" id=\"medical_history\" oscarDB=medical_history>\r\n<input type=\"hidden\" name=\"recent_rx\" id=\"recent_rx\" oscarDB=recent_rx>\r\n<input type=\"hidden\" name=\"druglist_generic\" id=\"druglist_generic\" oscarDB=druglist_generic>\r\n<input type=\"hidden\" name=\"druglist_trade\" id=\"druglist_trade\" oscarDB=druglist_trade>\r\n<input type=\"hidden\" name=\"druglist_line\" id=\"druglist_line\" oscarDB=druglist_line>\r\n<input type=\"hidden\" name=\"social_family_history\" id=\"social_family_history\" oscarDB=social_family_history>\r\n<input type=\"hidden\" name=\"other_medications_history\" id=\"other_medications_history\" oscarDB=other_medications_history>\r\n<input type=\"hidden\" name=\"reminders\" id=\"reminders\" oscarDB=reminders>\r\n<input type=\"hidden\" name=\"ongoingconcerns\" id=\"ongoingconcerns\" oscarDB=ongoingconcerns >\r\n\r\n<input type=\"hidden\" name=\"provider_name_first_init\" id=\"provider_name_first_init\" oscarDB=provider_name_first_init >\r\n<input type=\"hidden\" name=\"current_user\" id=\"current_user\" oscarDB=current_user >\r\n<input type=\"hidden\" name=\"doctor_work_phone\" id=\"doctor_work_phone\" oscarDB=doctor_work_phone >\r\n<input type=\"hidden\" name=\"doctor\" id=\"doctor\" oscarDB=doctor >\r\n\r\n<input type=\"hidden\" name=\"today\" id=\"today\" oscarDB=today>\r\n\r\n<input type=\"hidden\" name=\"allergies_des\" id=\"allergies_des\" oscarDB=allergies_des >\r\n\r\n<!-- PLACE REFERRAL PLACEHOLDERS HERE WHEN BC APCONFIG FIXED -->\r\n<input type=\"hidden\" name=\"referral_name\" id=\"referral_name\" oscarDB=referral_name>\r\n<input type=\"hidden\" name=\"referral_address\" id=\"referral_address\" oscarDB=referral_address>\r\n<input type=\"hidden\" name=\"referral_phone\" id=\"referral_phone\" oscarDB=referral_phone>\r\n<input type=\"hidden\" name=\"referral_fax\" id=\"referral_fax\" oscarDB=referral_fax>\r\n\r\n<!-- END OF DATABASE PLACEHOLDERS -->\r\n\r\n\r\n<!-- START OF MEASUREMENTS PLACEHOLDERS -->\r\n\r\n<input type=\"hidden\" name=\"BP\" id=\"BP\" oscarDB=m$BP#value>\r\n<input type=\"hidden\" name=\"WT\" id=\"WT\" oscarDB=m$WT#value>\r\n<input type=\"hidden\" name=\"smoker\" id=\"smoker\" oscarDB=m$SMK#value>\r\n<input type=\"hidden\" name=\"dailySmokes\" id=\"dailySmokes\" oscarDB=m$NOSK#value>\r\n<input type=\"hidden\" name=\"A1C\" id=\"A1C\" oscarDB=m$A1C#value>\r\n\r\n<!-- END OF MEASUREMENTS PLACEHOLDERS -->\r\n\r\n\r\n<!-- START OF DERIVED PLACEHOLDERS -->\r\n\r\n<input type=\"hidden\" name=\"he_she\" id=\"he_she\" value=\"he\">\r\n<input type=\"hidden\" name=\"his_her\" id=\"his_her\" value=\"his\">\r\n<input type=\"hidden\" name=\"gender\" id=\"gender\" value=\"male\">\r\n<input type=\"hidden\" name=\"referral_nameL\" id=\"referral_nameL\" value=\"Referring Doctor\">\r\n<input type=\"hidden\" name=\"letterhead\" id=\"letterhead\" value=\"Letterhead\">\r\n\r\n<!-- END OF DERIVED PLACEHOLDERS -->\r\n\r\n\r\n<textarea name=\"Letter\" id=\"Letter\" style=\"width:600px; display: none;\"></textarea>\r\n\r\n<div class=\"DoNotPrint\" id=\"control3\" style=\"position:absolute; top:20px; left: 660px;\">\r\n<input type=\"button\" class=\"butn\" name=\"AddLetterhead\" id=\"AddLetterhead\" value=\"Letterhead\" \r\n	onclick=\"doHtml(document.getElementById(\'letterhead\').value);\">\r\n\r\n<br>\r\n<!--\r\n<input type=\"button\" class=\"butn\" name=\"certificate\" value=\"Work Note\" \r\n	onclick=\"document.RichTextLetter.AddLetterhead.click();\r\n 	doHtml(\'<p>\'+doDate()+\'<p>This is to certify that I have today examined <p>\');\r\n	document.RichTextLetter.AddLabel.click();\r\n	doHtml(\'In my opinion, \'+document.getElementById(\'he_she\').value+\' will be unfit for \'+document.getElementById(\'his_her\').value+\' normal work from today to * inclusive.\');\r\n	document.RichTextLetter.Closing.click();\">\r\n<br>\r\n\r\n<input type=\"button\" class=\"butn\" name=\"consult\" value=\"Consult Letter\" \r\n	onclick=\"  var ref=document.getElementById(\'referral_name\').value.toString(); var mySplitResult = ref.split(\',\');\r\n	var gender=document.getElementById(\'sex\').value; if (gender==\'M\'){gender=\'male\';}; if (gender==\'F\'){gender=\'female\';};\r\n	var years=document.getElementById(\'ageComplex\').value; if (years==\'\'){years=document.getElementById(\'age\').value + \'yo\';};\r\n	document.RichTextLetter.AddLetterhead.click();\r\n	doHtml(\'<p>\'+doDate()+\'<p>\');\r\n	document.RichTextLetter.AddReferral.click();\r\n	doHtml(\'<p>RE:&nbsp\');\r\n	document.RichTextLetter.AddLabel.click();\r\n	doHtml(\'<p>Dear Dr. \'+mySplitResult[0]+\'<p>Thank you for asking me to see this \'+years+ \' \' +gender);\r\n	document.RichTextLetter.Closing.click(); \">\r\n<br>\r\n-->\r\n<input type=\"button\" class=\"butn\" name=\"AddReferral\" id=\"AddReferral\" value=\"Referring Block\" \r\n	onclick=\"doHtml(document.getElementById(\'referral_name\').value+\'<br>\'+ document.getElementById(\'referral_address\').value +\'<br>CANADA<br> Tel: \'+ document.getElementById(\'referral_phone\').value+\'<br>Fax:  \'+document.getElementById(\'referral_fax\').value);\">\r\n\r\n<br>\r\n\r\n<input type=\"button\" class=\"butn\" name=\"AddLabel\" id=\"AddLabel\" value=\"Patient Block\" \r\n	onclick=\"doHtml(document.getElementById(\'label\').value);\">\r\n\r\n<br>\r\n\r\n<br>\r\n<input type=\"button\"  class=\"butn\" name=\"MedicalHistory\" value=\"Recent History\" width=30\r\n	onclick=\"var hist=parseText(document.getElementById(\'medical_history\').value); doHtml(hist);\">\r\n<br>\r\n<input type=\"button\"  class=\"butn\" name=\"AddMedicalHistory\" value=\"Full History\" width=30\r\n	onclick=\"doHtml(document.getElementById(\'medical_history\').value); \">\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"RecentMedications\" id=\"RecentMedications\" value=\"Recent Prescriptions\"\r\n	onclick=\"doHtml(document.getElementById(\'recent_rx\').value);\">\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"Medlist\" id=\"Medlist\" value=\"Medication List\"\r\n	onclick=\"doHtml(document.getElementById(\'druglist_trade\').value);\">\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"Allergies\" id=\"Allergies\" value=\"Meds & Allergies\"\r\n	onclick=\"var allergy=document.getElementById(\'allergies_des\').value; if (allergy.length>0){allergy=\'<br>Allergies: \'+allergy};doHtml(\'Medications: \'+document.getElementById(\'druglist_line\').value+allergy);\">\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"OtherMedicationsHistory\" value=\"Family History\"\r\n	onclick=\"var hist=parseText(document.getElementById(\'other_medications_history\').value); doHtml(hist);\">\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"AddOtherMedicationsHistory\" value=\"Full Family Hx\"\r\n	onclick=\"doHtml(document.getElementById(\'other_medications_history\').value); \">\r\n\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"AddSocialFamilyHistory\" value=\"Social History\" \r\n	onclick=\"var hist=parseText(document.getElementById(\'social_family_history\').value); doHtml(hist);\">\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"AddReminders\" value=\"Reminders\"\r\n	onclick=\"var hist=parseText(document.getElementById(\'reminders\').value); doHtml(hist);\">\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"AddOngoingConcerns\" value=\"Ongoing Concerns\"\r\n	onclick=\"var hist=parseText(document.getElementById(\'ongoingconcerns\').value); doHtml(hist);\">\r\n<br>\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"Patient\" value=\"Patient Name\"\r\n	onclick=\" doHtml(document.getElementById(\'first_last_name\').value);\">\r\n\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"PatientAge\" value=\"Patient Age\"\r\n	onclick=\"var hist=document.getElementById(\'ageComplex\').value; if (hist==\'\'){hist=document.getElementById(\'age\').value;}; doHtml(hist);\">\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"label\" value=\"Patient Label\"\r\n	onclick=\"var hist=document.getElementById(\'label\').value; doHtml(hist);\">\r\n\r\n\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"PatientSex\" value=\"Patient Gender\"\r\n	onclick=\"doHtml(document.getElementById(\'sex\').value);\">\r\n<br>\r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"Closing\" value=\"Closing Salutation\" \r\n	onclick=\" doHtml(\'<p>Yours Sincerely<p>&nbsp;<p>\'+ document.getElementById(\'provider_name_first_init\').value+\', MD\');\">\r\n \r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"User\" value=\"Current User\"\r\n	onclick=\"var hist=document.getElementById(\'current_user\').value; doHtml(hist);\">\r\n \r\n<br>\r\n<input type=\"button\" class=\"butn\" name=\"Doctor\" value=\"Attending Doctor\"\r\n	onclick=\"var hist=document.getElementById(\'doctor\').value; doHtml(hist);\">\r\n<br>\r\n<br>\r\n\r\n\r\n<br>\r\n</div>\r\n\r\n\r\n<div class=\"DoNotPrint\" >\r\n<input onclick=\"viewsource(this.checked)\" type=\"checkbox\">\r\nHTML Source\r\n<input onclick=\"usecss(this.checked)\" type=\"checkbox\">\r\nUse CSS\r\n	<table><tr><td>\r\n		 Subject: <input name=\"subject\" id=\"subject\" size=\"40\" type=\"text\">\r\n		 <input value=\"Submit\" name=\"SubmitButton\" type=\"submit\" onclick=\"needToConfirm=false;document.getElementById(\'Letter\').value=editControlContents(\'edit\');  document.RichTextLetter.submit()\">\r\n		 <input value=\"Reset\" name=\"ResetButton\" type=\"reset\">\r\n		 <input value=\"Print\" name=\"PrintButton\" type=\"button\" onclick=\"document.getElementById(\'edit\').contentWindow.print();\">\r\n		 <input value=\"Print & Save\" name=\"PrintSaveButton\" type=\"button\" onclick=\"document.getElementById(\'edit\').contentWindow.print();needToConfirm=false;document.getElementById(\'Letter\').value=editControlContents(\'edit\');  setTimeout(\'document.RichTextLetter.submit()\',1000);\">\r\n	 </td></tr></table>\r\n </div>\r\n </form>\r\n\r\n</body></html>\r\n',0);


-- -----------------------------------------------------------
-- OSCAR updates
-- -----------------------------------------------------------

ALTER TABLE drugs ADD COLUMN special_instruction TEXT DEFAULT NULL AFTER special;

insert into secObjectName values('_queue.1','default',0);

alter table demographic add column anonymous varchar(32);

create table IntegratorControl (
	id int primary key auto_increment,
	facilityId int not null, foreign key (facilityId) references Facility(id),
	control varchar(80),
	execute boolean);

alter table drugs add custom_note tinyint(1) after unitName;

delete from msgDemoMap where demographic_no = 0;

alter table eform add column patient_independent boolean;
alter table eform_data add column patient_independent boolean;

alter table document add number_of_pages int(6) not null default 0;

-- add new field '_newCasemgmt.templates to Assign Role/Right to Object
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.templates');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.templates','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.templates','x',0,'999998');

alter table professionalSpecialists add remoteHl7ReferralUrl varchar(255);
alter table professionalSpecialists add lastUpdated datetime not null;

update professionalSpecialists set lastUpdated=now();

alter table publicKeys change type type varchar(100) not null;

alter table professionalSpecialists drop remoteHl7ReferralUrl;
alter table professionalSpecialists add eReferralUrl varchar(255);
alter table professionalSpecialists add eReferralOscarKey varchar(1024);
alter table professionalSpecialists add eReferralServiceKey varchar(1024);

create table other_id (
	id int not null auto_increment primary key,
	table_name int not null,
	table_id int not null,
	other_key varchar(30) not null,
	other_id varchar(30) not null,
	deleted boolean not null
);

create table queue (id int(10) not null auto_increment,name varchar(40) not null ,primary key(id),unique (name) );
create table queue_provider_link (id int(10) not null auto_increment,queue_id int(10),provider_id varchar(6), primary key(id) );
create table queue_document_link (id int(10) not null auto_increment,queue_id int(10) not null, document_id int(10) not null,primary key (id));

update provider set dob=null where dob='0001-01-01';

update demographic set end_date=null where end_date='0001-01-01';
update demographic set eff_date=null where eff_date='0001-01-01';
update demographic set hc_renew_date=null where hc_renew_date='0001-01-01';

update scheduletemplatecode set confirm='Day' where code='s';
update scheduletemplatecode set confirm='Day' where code='S';
insert into scheduletemplatecode values('W','Same Week','15','FFF68F','Wk','1');

alter table professionalSpecialists add column eReferralServiceName varchar(255) after eReferralServiceKey;

alter table hl7TextInfo change accessionNum accessionNum varchar(20);

alter table publicKeys add column matchingProfessionalSpecialistId int;

alter table program add siteSpecificField varchar(255);

alter table hl7TextMessage change type type varchar(100) not null;
alter table hl7TextMessage add serviceName varchar(100) not null;
update hl7TextMessage set serviceName=type;
alter table hl7TextMessage add created datetime not null;
update hl7TextMessage set created=now();

alter table professionalSpecialists change eReferralUrl eDataUrl varchar(255);
alter table professionalSpecialists change eReferralOscarKey eDataOscarKey varchar(1024);
alter table professionalSpecialists change eReferralServiceKey eDataServiceKey varchar(1024);
alter table professionalSpecialists change eReferralServiceName eDataServiceName varchar(255);

alter table log change action action varchar(64);

alter table publicKeys add column privateKey text not null;
update publicKeys set privateKey='not available';

alter table gstControl add column id int auto_increment primary key;
alter table billingperclimit drop primary key;
alter table billingperclimit add column id integer auto_increment primary key;

insert into secObjectName values('_queue.1','default',0);


-- -----------------------------------------------------------
-- CAISI patches
-- -----------------------------------------------------------

alter table intake_answer_element add label varchar(255);

DROP TABLE IF EXISTS `intake_node_js`;
CREATE TABLE `intake_node_js` (
        `id` integer not null auto_increment,
        `question_id` varchar(255) not null,
        `location` varchar(255) not null,
        primary key(id)
);

ALTER TABLE `intake_node` add `common_list` boolean NOT NULL default false;

alter table Facility drop enableCdsForms;

create table CdsHospitalisationDays
(
	id int primary key auto_increment,
	clientId int not null,
	admitted date not null,
	discharged date
);

create table FunctionalCentre
(
	accountId varchar(64) primary key,
	description varchar(255) not null
);

insert into FunctionalCentre values ('7* 5 09 76','COM Case Management Mental Health');
insert into FunctionalCentre values ('7* 5 09 78 11','COM Case Management - Substance Abuse');
insert into FunctionalCentre values ('7* 5 09 78 12','COM Case Management - Problem Gambling');

alter table program add column functionalCentreId varchar(64) after description;

alter table Facility add `ocanServiceOrgNumber` int(10) not null default '0';
alter table Facility add enableOcanForms tinyint(1) not null;

create table OcanFormOption
(
        id int primary key auto_increment,
        ocanFormVersion varchar(16) not null,
        ocanDataCategory varchar(100) not null,
	ocanDataCategoryValue varchar(100) not null,
        ocanDataCategoryName varchar(255) not null
);

create table OcanStaffForm
(
        id int primary key auto_increment,
        ocanFormVersion varchar(16) not null,
        index(ocanFormVersion),
        providerNo varchar(6) not null,
        signed tinyint not null,
        index(signed),
        created datetime not null,
        facilityId int not null,
        clientId int not null,
        index(facilityId, clientId),
        admissionId int,
        index(admissionId),
        clientAge int,
        index(clientAge),
	lastName varchar(100),
	firstName varchar(100),
	addressLine1 varchar(100),
	addressLine2 varchar(100),
	city varchar(100),
	province varchar(10),
	postalCode varchar(100),
	phoneNumber varchar(100),
	email varchar(100),
	hcNumber varchar(100),
	hcVersion varchar(100),
	dateOfBirth varchar(100)
);

create table OcanStaffFormData
(
        id int primary key auto_increment,
        ocanStaffFormId int not null,
        index(ocanStaffFormId),
        question varchar(64) not null,
        index(question),
        answer varchar(16) not null
);

alter table OcanStaffForm add startDate date NOT NULL;
alter table OcanStaffForm add completionDate date;
alter table OcanStaffForm add reasonForAssessment varchar(100);
alter table OcanStaffForm add assessmentStatus varchar(40) NOT NULL;

create table OcanClientForm
(
        id int primary key auto_increment,
        ocanFormVersion varchar(16) not null,
        index(ocanFormVersion),
        providerNo varchar(6) not null,
        created datetime not null,
        facilityId int not null,
        clientId int not null,
        index(facilityId, clientId),
        lastName varchar(100),
        firstName varchar(100),
        dateOfBirth varchar(100)
);

create table OcanClientFormData
(
        id int primary key auto_increment,
        ocanClientFormId int not null,
        index(ocanClientFormId),
        question varchar(64) not null,
        index(question),
        answer varchar(16) not null
);

alter table OcanClientForm add startDate date NOT NULL;
alter table OcanClientForm add completionDate date;

delete from CdsFormOption where cdsDataCategory in ('032-01','032-02','032-03','032-04','036-01','036-02','036-03');

delete from CdsFormOption where cdsDataCategory like '006-%';
delete from CdsFormOption where cdsDataCategory ='018-07';

alter table CdsClientForm add column initialContactDate date, add column assessmentDate date;

alter table CdsClientForm drop column clientAge;

alter table Facility add enableAnonymous tinyint(1) not null;

alter table Facility add enableGroupNotes tinyint(1) not null;
alter table OcanClientForm add assessmentStatus varchar(50);
create table group_note_link (
        id int primary key auto_increment,
        created timestamp,
        noteId int(10) not null,
        demographicNo int(10) not null,
        key(noteId),
        key(demographicNo)
);

alter table OcanStaffForm add gender varchar(10) NOT NULL;

update OcanFormOption set ocanDataCategoryName="0 - No problem" where id=830;
update OcanFormOption set ocanDataCategoryName="1 - No/Moderate problem due to help" where id=831;
update OcanFormOption set ocanDataCategoryName="2 - Serious problem" where id=832;
update OcanFormOption set ocanDataCategoryName="9 - Not known" where id=833;
update OcanFormOption set ocanDataCategoryName="0 - None" where id=835;
update OcanFormOption set ocanDataCategoryName="1 - Low help" where id=836;
update OcanFormOption set ocanDataCategoryName="2 - Moderate help" where id=837;
update OcanFormOption set ocanDataCategoryName="3 - High help" where id=838;
update OcanFormOption set ocanDataCategoryName="9 - Unknown" where id=839;

delete from OcanFormOption where id in (834,840,899,900);
alter table OcanStaffForm add providerName varchar(100);
alter table OcanClientForm add providerName varchar(100);

#drop table group_note_link;
create table GroupNoteLink (
        id int primary key auto_increment,
        created timestamp,
        noteId int(10) not null,
        demographicNo int(10) not null,
	anonymous tinyint(1),
	active tinyint(1),
        key(noteId),
        key(demographicNo),
	key(anonymous),
	key(active)
);

alter table appointment add program_id int default 0 after demographic_no;

alter table OcanClientFormData modify answer text not null;
alter table OcanStaffFormData modify answer text not null;

alter table preference add default_new_oscar_cme varchar(10) default 'disabled';

insert into `secObjectName` (`objectName`) values ('_newCasemgmt.preventions');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.viewTickler');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.DxRegistry');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.forms');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.eForms');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.documents');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.labResult');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.oscarMsg');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.measurements');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.consultations');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.allergies');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.prescriptions');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.otherMeds');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.riskFactors');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.familyHistory');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.decisionSupportAlerts');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.medicalHistory');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.calculators');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.cpp');

insert into `secObjPrivilege` values('doctor','_newCasemgmt.preventions','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.viewTickler','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.DxRegistry','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.forms','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.eForms','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.documents','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.labResult','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.oscarMsg','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.measurements','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.consultations','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.allergies','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.prescriptions','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.otherMeds','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.riskFactors','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.familyHistory','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.decisionSupportAlerts','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.medicalHistory','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.calculators','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.cpp','x',0,'999998');

insert into `secObjPrivilege` values('admin','_newCasemgmt.preventions','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.viewTickler','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.DxRegistry','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.forms','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.eForms','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.documents','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.labResult','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.oscarMsg','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.measurements','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.consultations','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.allergies','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.prescriptions','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.otherMeds','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.riskFactors','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.familyHistory','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.decisionSupportAlerts','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.medicalHistory','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.calculators','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.cpp','x',0,'999998');


update OcanFormOption set ocanDataCategory="Reason for OCAN" where id=635;
update OcanFormOption set ocanDataCategoryName="Initial OCAN" where id=635;
update OcanFormOption set ocanDataCategory="Reason for OCAN" where id=636;
update OcanFormOption set ocanDataCategoryName="Reassessment" where id=636;
update OcanFormOption set ocanDataCategory="Reason for OCAN" where id=637;
update OcanFormOption set ocanDataCategory="Reason for OCAN" where id=638;
update OcanFormOption set ocanDataCategoryName="Other (e.g. consumer request)" where id=638;


INSERT INTO OcanFormOption VALUES (1000,'1.2','Reason for OCAN','SC','Significant Change');
INSERT INTO OcanFormOption VALUES (1001,'1.2','Reason for OCAN','REV','Review');
INSERT INTO OcanFormOption VALUES (1002,'1.2','Reason for OCAN','REK','Re-key');

INSERT INTO OcanFormOption VALUES (1003,'1.2','OCAN Lead Assessment','TRUE','Yes');
INSERT INTO OcanFormOption VALUES (1004,'1.2','OCAN Lead Assessment','FALSE','No');

INSERT INTO OcanFormOption VALUES (1005,'1.2','Consumer Self-Assessment completed','TRUE','Yes');
INSERT INTO OcanFormOption VALUES (1006,'1.2','Consumer Self-Assessment completed','FALSE','No');

INSERT INTO OcanFormOption VALUES (1007,'1.2','Consumer Self-Assessment incompleted','CMFLVL','Comfort Level');
INSERT INTO OcanFormOption VALUES (1008,'1.2','Consumer Self-Assessment incompleted','LOA','Length of Assessment');
INSERT INTO OcanFormOption VALUES (1009,'1.2','Consumer Self-Assessment incompleted','LIT','Literacy');
INSERT INTO OcanFormOption VALUES (1010,'1.2','Consumer Self-Assessment incompleted','MHC','Mental Health Condition');
INSERT INTO OcanFormOption VALUES (1011,'1.2','Consumer Self-Assessment incompleted','PYSCON','Physical Condition');
INSERT INTO OcanFormOption VALUES (1012,'1.2','Consumer Self-Assessment incompleted','LANG','Language Barrier');
INSERT INTO OcanFormOption VALUES (1013,'1.2','Consumer Self-Assessment incompleted','OTH','Other');

INSERT INTO OcanFormOption VALUES (1014,'1.2','client DOB Type','EST','Estimate');
INSERT INTO OcanFormOption VALUES (1015,'1.2','client DOB Type','UNK','Unknown');

INSERT INTO OcanFormOption VALUES (1016,'1.2','LHIN code','010-30','Out Of Province');
INSERT INTO OcanFormOption VALUES (1017,'1.2','LHIN code','010-52','Out of Country');
INSERT INTO OcanFormOption VALUES (1018,'1.2','LHIN code','UNK','Unknown');

update OcanFormOption set ocanDataCategoryName="Consumer Declined to answer" WHERE id=358;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to answer" WHERE id=536;

INSERT INTO OcanFormOption VALUES (1019,'1.2','MIS Functional Centre List','725 107 699','OTH - Other MH services not elsewhere classified');

update OcanFormOption set ocanDataCategory="OTH" where id=711;
INSERT INTO OcanFormOption VALUES (1020,'1.2','Referral Source','0AS','Abuse Services');
INSERT INTO OcanFormOption VALUES (1021,'1.2','Referral Source','0AB','Alternative Businesses');
INSERT INTO OcanFormOption VALUES (1022,'1.2','Referral Source','ACT','Assertive Community Treatment Teams');
INSERT INTO OcanFormOption VALUES (1023,'1.2','Referral Source','0CM','Case Management');
INSERT INTO OcanFormOption VALUES (1024,'1.2','Referral Source','CHI','Child/Adolescent');
INSERT INTO OcanFormOption VALUES (1025,'1.2','Referral Source','CLU','Clubhouses');
INSERT INTO OcanFormOption VALUES (1026,'1.2','Referral Source','0CD','Community Development');
INSERT INTO OcanFormOption VALUES (1027,'1.2','Referral Source','CMH ','Community Mental Health Clinic');
INSERT INTO OcanFormOption VALUES (1028,'1.2','Referral Source','0IR ','Community Service Information and Referral');
INSERT INTO OcanFormOption VALUES (1029,'1.2','Referral Source','CON','Concurrent Disorders');
INSERT INTO OcanFormOption VALUES (1030,'1.2','Referral Source','0CT','Counseling & Treatment');
INSERT INTO OcanFormOption VALUES (1031,'1.2','Referral Source','DCS','Diversion & Court Support');
INSERT INTO OcanFormOption VALUES (1032,'1.2','Referral Source','DDx ','Dual Diagnosis');
INSERT INTO OcanFormOption VALUES (1033,'1.2','Referral Source','EAR ','Early Intervention');
INSERT INTO OcanFormOption VALUES (1034,'1.2','Referral Source','EAT','Eating Disorder');
INSERT INTO OcanFormOption VALUES (1035,'1.2','Referral Source','0FI ','Family Initiatives');
INSERT INTO OcanFormOption VALUES (1036,'1.2','Referral Source','FOR','Forensic');
INSERT INTO OcanFormOption VALUES (1037,'1.2','Referral Source','HPA ','Health Promotion/Education - Awareness');
INSERT INTO OcanFormOption VALUES (1038,'1.2','Referral Source','HPW','Health Promotion/Education - Women\'s Health \(MH\)');
INSERT INTO OcanFormOption VALUES (1039,'1.2','Referral Source','HSC','Homes for Special Care');
INSERT INTO OcanFormOption VALUES (1040,'1.2','Referral Source','CRI ','Mental Health Crisis Intervention');
INSERT INTO OcanFormOption VALUES (1041,'1.2','Referral Source','PSH','Peer/Self-help Initiatives');
INSERT INTO OcanFormOption VALUES (1042,'1.2','Referral Source','0DN','Primary Day/Night Care');
INSERT INTO OcanFormOption VALUES (1043,'1.2','Referral Source','GER','Psycho-Geriatric');
INSERT INTO OcanFormOption VALUES (1044,'1.2','Referral Source','0SR','Social Rehabilitation/Recreation');
INSERT INTO OcanFormOption VALUES (1045,'1.2','Referral Source','0SH','Supports within Housing');
INSERT INTO OcanFormOption VALUES (1046,'1.2','Referral Source','EMP','Vocational/Employment');
INSERT INTO OcanFormOption VALUES (1047,'1.2','Referral Source','OMHS','Other Mental Health Services');
INSERT INTO OcanFormOption VALUES (1048,'1.2','Referral Source','OAS','Other Addiction Services');
INSERT INTO OcanFormOption VALUES (1049,'1.2','Referral Source','PSOR','Police');
INSERT INTO OcanFormOption VALUES (1050,'1.2','Referral Source','COLA','Courts (includes jails and detention centres)');
INSERT INTO OcanFormOption VALUES (1051,'1.2','Referral Source','CSOR','Correctional Facilities (includes jails and detention centres)');
INSERT INTO OcanFormOption VALUES (1052,'1.2','Referral Source','4155.1.PPOF','Probation/Parole Officers');
INSERT INTO OcanFormOption VALUES (1053,'1.2','Referral Source','CSB','Short Term Residential Crisis Support Beds');
INSERT INTO OcanFormOption VALUES (1054,'1.2','Referral Source','CJSS','Criminal Justice System Source breakdown not available (use this category if above detailed breakdown is not available)');


INSERT INTO OcanFormOption VALUES (1055,'1.2','Yes No','TRUE','Yes');
INSERT INTO OcanFormOption VALUES (1056,'1.2','Yes No','FALSE','No');

INSERT INTO OcanFormOption VALUES (1063,'1.2','Doctor Psychiatrist','CDA','Consumer declined to answer');
INSERT INTO OcanFormOption VALUES (1064,'1.2','Doctor Psychiatrist','UNK','Unknown');

INSERT INTO OcanFormOption VALUES (1065,'1.2','Other Contacts Agency','TRUE','Yes');
INSERT INTO OcanFormOption VALUES (1066,'1.2','Other Contacts Agency','FALSE','No');
INSERT INTO OcanFormOption VALUES (1067,'1.2','Other Contacts Agency','CDA','Consumer declined to answer');
INSERT INTO OcanFormOption VALUES (1068,'1.2','Other Contacts Agency','UNK','Unknown');

update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=133;

INSERT INTO OcanFormOption VALUES (1069,'1.2','Areas Of Concern','TRUE','Yes');
INSERT INTO OcanFormOption VALUES (1070,'1.2','Areas Of Concern','FALSE','No');
INSERT INTO OcanFormOption VALUES (1071,'1.2','Areas Of Concern','UNK','Unknown');

INSERT INTO OcanFormOption VALUES (1073,'1.2','Age of Onset','EST','Estimate');
INSERT INTO OcanFormOption VALUES (1074,'1.2','Age of Onset','CDA','Consumer declined to answer');
INSERT INTO OcanFormOption VALUES (1075,'1.2','Age of Onset','UNK','Unknown');
INSERT INTO OcanFormOption VALUES (1076,'1.2','Age of Onset','NA','N/A');

INSERT INTO OcanFormOption VALUES (1077,'1.2','Age of Entry To Org','EST','Estimate');
INSERT INTO OcanFormOption VALUES (1078,'1.2','Age of Entry To Org','CDA','Consumer declined to answer');
INSERT INTO OcanFormOption VALUES (1079,'1.2','Age of Entry To Org','UNK','Unknown');
INSERT INTO OcanFormOption VALUES (1080,'1.2','Age of Entry To Org','NA','N/A');

INSERT INTO OcanFormOption VALUES (1081,'1.2','Ethniticity','CDA','Consumer Declined to Answer');
INSERT INTO OcanFormOption VALUES (1082,'1.2','Ethniticity','UNK','Unknown');

update OcanFormOption set ocanDataCategoryValue="UNK" where id=63;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=64;
update OcanFormOption set ocanDataCategoryValue="CDA" where id=64;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=129;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=851;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=182;

INSERT INTO OcanFormOption VALUES (1083,'1.2','Language','CDA','Consumer Declined to Answer');
INSERT INTO OcanFormOption VALUES (1084,'1.2','Language','UNK','Unknown');

update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=505;

#
update OcanFormOption set ocanDataCategoryValue="UNK" where id=499;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=500;
update OcanFormOption set ocanDataCategoryValue="CDA" where id=500;

update OcanFormOption set ocanDataCategoryValue="OTH" where id=740;
update OcanFormOption set ocanDataCategoryValue="UNK" where id=741;
update OcanFormOption set ocanDataCategoryValue="CDA" where id=742;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=742;

update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=528;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=224;
update OcanFormOption set ocanDataCategoryValue="UNK" where id=223;

update OcanFormOption set ocanDataCategoryValue="OTH" where id=212;
update OcanFormOption set ocanDataCategoryValue="UNK" where id=213;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=214;

INSERT INTO OcanFormOption VALUES (1085,'1.2','Barriers','ADD','Addictions');
INSERT INTO OcanFormOption VALUES (1086,'1.2','Barriers','CAB','Cognitive Abilities');
INSERT INTO OcanFormOption VALUES (1087,'1.2','Barriers','CON','Confidence');
INSERT INTO OcanFormOption VALUES (1088,'1.2','Barriers','CTM','Contemplative');
INSERT INTO OcanFormOption VALUES (1089,'1.2','Barriers','DIS','Disclosure');
INSERT INTO OcanFormOption VALUES (1090,'1.2','Barriers','FOC','Financial ODSP cut off');
INSERT INTO OcanFormOption VALUES (1091,'1.2','Barriers','FFT','Funding for Training');
INSERT INTO OcanFormOption VALUES (1092,'1.2','Barriers','LOR','Lack of Resume');
INSERT INTO OcanFormOption VALUES (1093,'1.2','Barriers','LGC','Language Comprehension');
INSERT INTO OcanFormOption VALUES (1094,'1.2','Barriers','LIT','Literacy');
INSERT INTO OcanFormOption VALUES (1095,'1.2','Barriers','MSE','Medication Side Effects');
INSERT INTO OcanFormOption VALUES (1096,'1.2','Barriers','PHY','Physical Health');
INSERT INTO OcanFormOption VALUES (1097,'1.2','Barriers','PCO','Pre-contemplative');
INSERT INTO OcanFormOption VALUES (1098,'1.2','Barriers','STG','Stigma');
INSERT INTO OcanFormOption VALUES (1099,'1.2','Barriers','SYM','Symptoms');
INSERT INTO OcanFormOption VALUES (1100,'1.2','Barriers','TRN','Transportation');
INSERT INTO OcanFormOption VALUES (1101,'1.2','Barriers','OTH','Other');
INSERT INTO OcanFormOption VALUES (1102,'1.2','Barriers','CDA','Consumer declined to answer');

delete from OcanFormOption where ocanDataCategory="Unemployed Education Risk";

INSERT INTO OcanFormOption VALUES (1103,'1.2','Medical Conditions','26929004','Alzheimer\'s');
INSERT INTO OcanFormOption VALUES (1104,'1.2','Medical Conditions','424460009','Hepatitis D');
INSERT INTO OcanFormOption VALUES (1105,'1.2','Medical Conditions','44186003','Sleep Problems (e.g. Insomnia)');
update OcanFormOption set ocanDataCategoryName="Communicable disease" where id=543;
update OcanFormOption set ocanDataCategoryName="Sexually Transmitted Infection (STI)" where id=565;
delete from OcanFormOption where id=560;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=572;
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where id=898;

delete from OcanFormOption where ocanDataCategory="Side Effects Reported Ability";
delete from OcanFormOption where ocanDataCategory="Side Effects Description List";

INSERT INTO OcanFormOption VALUES (1106,'1.2','Source of Information','116154003','Consumer');
INSERT INTO OcanFormOption VALUES (1107,'1.2','Source of Information','HLTHP','Health Provider');
INSERT INTO OcanFormOption VALUES (1108,'1.2','Source of Information','42665001','Homes of the Aged');
INSERT INTO OcanFormOption VALUES (1109,'1.2','Source of Information','22232009','Hospital (at discharge or hospital record)');
INSERT INTO OcanFormOption VALUES (1110,'1.2','Source of Information','JUST','Justice (e.g. Probation Order)');
INSERT INTO OcanFormOption VALUES (1111,'1.2','Source of Information','LTCH','Long Term Care Home');
INSERT INTO OcanFormOption VALUES (1112,'1.2','Source of Information','264372000','Pharmacy');
INSERT INTO OcanFormOption VALUES (1113,'1.2','Source of Information','309343006','Physician');
INSERT INTO OcanFormOption VALUES (1114,'1.2','Source of Information','42120006','Significant Other');

INSERT INTO OcanFormOption VALUES (1115,'1.2','Emergency Department','None','None');
INSERT INTO OcanFormOption VALUES (1116,'1.2','Emergency Department','ED-1','1');
INSERT INTO OcanFormOption VALUES (1117,'1.2','Emergency Department','ED-2','2-5');
INSERT INTO OcanFormOption VALUES (1118,'1.2','Emergency Department','ED-6','6+');
INSERT INTO OcanFormOption VALUES (1119,'1.2','Emergency Department','CDA','Consumer Declined to Answer');
INSERT INTO OcanFormOption VALUES (1120,'1.2','Emergency Department','UNK','Unknown');

INSERT INTO OcanFormOption VALUES (1121,'1.2','Symptoms Checklist','24199005','Agitation');
INSERT INTO OcanFormOption VALUES (1122,'1.2','Symptoms Checklist','20602000','Apathy');
INSERT INTO OcanFormOption VALUES (1123,'1.2','Symptoms Checklist','424100000','Difficulty in Abstract Thinking');
INSERT INTO OcanFormOption VALUES (1124,'1.2','Symptoms Checklist','247640008','Disorganized Thinking');
INSERT INTO OcanFormOption VALUES (1125,'1.2','Symptoms Checklist','225652009','Emotional Unresponsiveness');
INSERT INTO OcanFormOption VALUES (1126,'1.2','Symptoms Checklist','79351003','Hostility');
INSERT INTO OcanFormOption VALUES (1127,'1.2','Symptoms Checklist','276306002','Lack of Drive or Initiative');
INSERT INTO OcanFormOption VALUES (1128,'1.2','Symptoms Checklist','247905005','Lack of Spontaneity');
INSERT INTO OcanFormOption VALUES (1129,'1.2','Symptoms Checklist','43994002','Physical Symptoms ');
INSERT INTO OcanFormOption VALUES (1130,'1.2','Symptoms Checklist','422517004','Poor Communication Skills');
INSERT INTO OcanFormOption VALUES (1131,'1.2','Symptoms Checklist','105411000','Social Withdrawal');
INSERT INTO OcanFormOption VALUES (1132,'1.2','Symptoms Checklist','78205008','Stereotype Thinking');
INSERT INTO OcanFormOption VALUES (1133,'1.2','Symptoms Checklist','22927000','Suspiciousness');


INSERT INTO OcanFormOption VALUES (1134,'1.2','Diagnostic Categories','228156007','Intellectual Disability or Impairment');
update OcanFormOption set ocanDataCategoryValue="SRD" where id=165;
update OcanFormOption set ocanDataCategoryValue="0DH" where id=166;
update OcanFormOption set ocanDataCategoryValue="UNK" where id=167;
update OcanFormOption set ocanDataCategoryName="Physical disabilities" where id=171;
update OcanFormOption set ocanDataCategoryValue="OTH" where id=747;
update OcanFormOption set ocanDataCategoryName="once a week" where id=350;
update OcanFormOption set ocanDataCategoryValue="OTH" where id=194;
update OcanFormOption set ocanDataCategoryValue="OTH" where id=119;
update OcanFormOption set ocanDataCategoryValue="224294005" where id=195;
update OcanFormOption set ocanDataCategoryValue="224295006" where id=197;
update OcanFormOption set ocanDataCategoryValue="224297003" where id=199;
update OcanFormOption set ocanDataCategoryValue="224302000" where id=201;
update OcanFormOption set ocanDataCategoryValue="UNK" where id=202;
update OcanFormOption set ocanDataCategoryValue="OTH" where id=374;
update OcanFormOption set ocanDataCategoryValue="UNK" where id=375;
update OcanFormOption set ocanDataCategoryValue="CDA" where id=376;
INSERT INTO OcanFormOption VALUES (1135,'1.2','Presenting Issues','TTS','Threat to Self');
update OcanFormOption set ocanDataCategoryValue="TTO" where id=610;
INSERT INTO OcanFormOption VALUES (1136,'1.2','Presenting Issues','ATMPS','Attempted Suicide');
update OcanFormOption set ocanDataCategoryValue="SEXAB" where id=612;
update OcanFormOption set ocanDataCategoryName="Sexual Abuse" where id=612;
INSERT INTO OcanFormOption VALUES (1137,'1.2','Presenting Issues','PHYSAB','Physical Abuse');
update OcanFormOption set ocanDataCategoryValue="PWSA" where id=619;
update OcanFormOption set ocanDataCategoryName="Problems with Substance Abuse" where id=619;
INSERT INTO OcanFormOption VALUES (1138,'1.2','Presenting Issues','PWA','Problems with Addictions');
update OcanFormOption set ocanDataCategoryValue="OTH" where id=621;

INSERT INTO OcanFormOption VALUES (1139,'1.2','Year of First Entry Date','2000','2000');
INSERT INTO OcanFormOption VALUES (1140,'1.2','Year of First Entry Date','2001','2001');
INSERT INTO OcanFormOption VALUES (1141,'1.2','Year of First Entry Date','2002','2002');
INSERT INTO OcanFormOption VALUES (1142,'1.2','Year of First Entry Date','2003','2003');
INSERT INTO OcanFormOption VALUES (1143,'1.2','Year of First Entry Date','2004','2004');
INSERT INTO OcanFormOption VALUES (1144,'1.2','Year of First Entry Date','2005','2005');
INSERT INTO OcanFormOption VALUES (1145,'1.2','Year of First Entry Date','2006','2006');
INSERT INTO OcanFormOption VALUES (1146,'1.2','Year of First Entry Date','2007','2007');
INSERT INTO OcanFormOption VALUES (1147,'1.2','Year of First Entry Date','2008','2008');
INSERT INTO OcanFormOption VALUES (1148,'1.2','Year of First Entry Date','2009','2009');
INSERT INTO OcanFormOption VALUES (1149,'1.2','Year of First Entry Date','2010','2010');
INSERT INTO OcanFormOption VALUES (1150,'1.2','Year of First Entry Date','2011','2011');
INSERT INTO OcanFormOption VALUES (1151,'1.2','Year of First Entry Date','2012','2012');
INSERT INTO OcanFormOption VALUES (1152,'1.2','Year of First Entry Date','2013','2013');
INSERT INTO OcanFormOption VALUES (1153,'1.2','Year of First Entry Date','2014','2014');
INSERT INTO OcanFormOption VALUES (1154,'1.2','Year of First Entry Date','2015','2015');
INSERT INTO OcanFormOption VALUES (1155,'1.2','Year of First Entry Date','2016','2016');
INSERT INTO OcanFormOption VALUES (1156,'1.2','Year of First Entry Date','2017','2017');
INSERT INTO OcanFormOption VALUES (1157,'1.2','Year of First Entry Date','2018','2018');
INSERT INTO OcanFormOption VALUES (1158,'1.2','Year of First Entry Date','2019','2019');
INSERT INTO OcanFormOption VALUES (1159,'1.2','Year of First Entry Date','2020','2020');
INSERT INTO OcanFormOption VALUES (1160,'1.2','Year of First Entry Date','2021','2021');
INSERT INTO OcanFormOption VALUES (1161,'1.2','Year of First Entry Date','2022','2022');
INSERT INTO OcanFormOption VALUES (1162,'1.2','Year of First Entry Date','2023','2023');
INSERT INTO OcanFormOption VALUES (1163,'1.2','Year of First Entry Date','2024','2024');
INSERT INTO OcanFormOption VALUES (1164,'1.2','Year of First Entry Date','2025','2025');
INSERT INTO OcanFormOption VALUES (1165,'1.2','Year of First Entry Date','2026','2026');
INSERT INTO OcanFormOption VALUES (1166,'1.2','Year of First Entry Date','2027','2027');
INSERT INTO OcanFormOption VALUES (1167,'1.2','Year of First Entry Date','2028','2028');
INSERT INTO OcanFormOption VALUES (1168,'1.2','Year of First Entry Date','2020','2029');
INSERT INTO OcanFormOption VALUES (1169,'1.2','Year of First Entry Date','2030','2030');

INSERT INTO OcanFormOption VALUES (1170,'1.2','Month of First Entry Date','01','01');
INSERT INTO OcanFormOption VALUES (1171,'1.2','Month of First Entry Date','02','02');
INSERT INTO OcanFormOption VALUES (1172,'1.2','Month of First Entry Date','03','03');
INSERT INTO OcanFormOption VALUES (1173,'1.2','Month of First Entry Date','04','04');
INSERT INTO OcanFormOption VALUES (1174,'1.2','Month of First Entry Date','05','05');
INSERT INTO OcanFormOption VALUES (1175,'1.2','Month of First Entry Date','06','06');
INSERT INTO OcanFormOption VALUES (1176,'1.2','Month of First Entry Date','07','07');
INSERT INTO OcanFormOption VALUES (1177,'1.2','Month of First Entry Date','08','08');
INSERT INTO OcanFormOption VALUES (1178,'1.2','Month of First Entry Date','09','09');
INSERT INTO OcanFormOption VALUES (1179,'1.2','Month of First Entry Date','10','10');
INSERT INTO OcanFormOption VALUES (1180,'1.2','Month of First Entry Date','11','11');
INSERT INTO OcanFormOption VALUES (1181,'1.2','Month of First Entry Date','12','12');

-- June 1, 2010
INSERT INTO OcanFormOption VALUES (1182,'1.2','Frequency of Drug Use','5','Past 6 months');
INSERT INTO OcanFormOption VALUES (1183,'1.2','Frequency of Drug Use','6','Ever');
INSERT INTO OcanFormOption VALUES (1184,'1.2','Number Of Centres','1','1');
INSERT INTO OcanFormOption VALUES (1185,'1.2','Number Of Centres','2','2');
INSERT INTO OcanFormOption VALUES (1186,'1.2','Number Of Centres','3','3');
INSERT INTO OcanFormOption VALUES (1187,'1.2','Number Of Centres','4','4');

INSERT INTO OcanFormOption VALUES (1188,'1.2','Age in Months','0','0');
INSERT INTO OcanFormOption VALUES (1189,'1.2','Age in Months','1','1');
INSERT INTO OcanFormOption VALUES (1190,'1.2','Age in Months','2','2');
INSERT INTO OcanFormOption VALUES (1191,'1.2','Age in Months','3','3');
INSERT INTO OcanFormOption VALUES (1192,'1.2','Age in Months','4','4');
INSERT INTO OcanFormOption VALUES (1193,'1.2','Age in Months','5','5');
INSERT INTO OcanFormOption VALUES (1194,'1.2','Age in Months','6','6');
INSERT INTO OcanFormOption VALUES (1195,'1.2','Age in Months','7','7');
INSERT INTO OcanFormOption VALUES (1196,'1.2','Age in Months','8','8');
INSERT INTO OcanFormOption VALUES (1197,'1.2','Age in Months','9','9');
INSERT INTO OcanFormOption VALUES (1198,'1.2','Age in Months','10','10');
INSERT INTO OcanFormOption VALUES (1199,'1.2','Age in Months','11','11');

INSERT INTO OcanFormOption VALUES (1200,'1.2','OCAN Type','CORE','CORE OCAN');
INSERT INTO OcanFormOption VALUES (1201,'1.2','OCAN Type','SELF','CORE + SELF OCAN');
INSERT INTO OcanFormOption VALUES (1202,'1.2','OCAN Type','FULL','FULL OCAN');

update OcanFormOption set ocanDataCategoryValue="OTH" where id=570;
update OcanFormOption set ocanDataCategoryValue="OTH" where id=711;
update OcanFormOption set ocanDataCategory="Referral Source" where id=711;
update OcanFormOption set ocanDataCategoryValue="OTH" where id=180;
update OcanFormOption set ocanDataCategoryValue="UNK" where id=181;

update OcanFormOption set ocanDataCategoryValue="OTH" where ocanDataCategoryName="Other";
update OcanFormOption set ocanDataCategoryValue="UNK" where ocanDataCategoryName="Unknown";


update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where ocanDataCategoryName="Client declined to answer";
update OcanFormOption set ocanDataCategoryName="Consumer Declined to Answer" where ocanDataCategoryName="Client Declined to Answer";


alter table secRole modify role_name varchar(60) NOT NULL default '';
delete from program_provider where role_id is null;
update secRole set role_name="counsellor" where role_name="Counsellor";