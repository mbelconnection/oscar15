-- default agency
insert into agency (id) values (0);

-- default facility
INSERT INTO Facility (name, description, lastUpdated) VALUES ('Default Facility', 'Default facility, please modify with a more appropriate name and description', now());

insert into provider_facility values (999998, (select id from Facility where name='Default Facility' ));

-- default roles
INSERT INTO `caisi_role` VALUES (1,'doctor',0,'',now()),(2,'nurse',0,'',now()),(3,'counsellor',0,'',now()),(4,'csw',0,'',now());

INSERT INTO `access_type` VALUES (1,'write doctor issues','access'),(2,'read doctor issues','access'),(3,'read doctor notes','access'),(4,'read doctor ticklers','access'),
(5,'write nurse issues','access'),(6,'read nurse issues','access'),(7,'read nurse notes','access'),(8,'read nurse ticklers','access'),
(9,'write counsellor issues','access'),(10,'read counsellor issues','access'),(11,'read counsellor notes','access'),(12,'read counsellor ticklers','access'),
(13,'write csw issues','access'),(14,'read csw issues','access'),(15,'read csw notes','access'),(16,'read csw ticklers','access')
;

-- access types
INSERT INTO `access_type` (name,type) VALUES ('Write Ticklers','Action'),('prescription Write','access'),('billing','access'),('medical encounter','access'),('immunization','access'),('prevention','access'),('oscarcomm','access'),('disease registry','access'),('medical form','access'),('measurements','access'),('eform','access'),('lab','access'),('prescription Read','access'),('read ticklers','access'),('master file','access'),('Service restriction override on referral','access'),('Service restriction override on admission','access'),('Create service restriction','access'),('Disable service restriction','access');

-- access types for quatro shelter
insert into access_type (name, type) values("Sex restriction override on referral","access");
insert into access_type (name, type) values("Sex restriction override on admission","access");
insert into access_type (name, type) values("Gender restriction override on referral","access");
insert into access_type (name, type) values("Gender restriction override on admission","access");
insert into access_type (name, type) values("Age restriction override on referral","access");
insert into access_type (name, type) values("Age restriction override on admission","access");
insert into access_type (name, type) values("Allow duplicate client merge","access");
insert into access_type (name, type) values("Perform program registration intake","access");
insert into access_type (name, type) values("perform registration intake","access");
insert into access_type (name, type) values("perform admissions","access");
insert into access_type (name, type) values("perform discharges","access");
insert into access_type (name, type) values("perform bed assignments","access");
insert into access_type (name, type) values("print bed rosters and reports","access");
insert into access_type	(name, type) values("Run Report Runner","access");
insert into access_type	(name, type) values("Design Reports","access");

-- default role access (global) (doctor gets all)
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='prescription Write'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='billing'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='medical encounter'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='immunization'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='prevention'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='disease registry'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='lab'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='prescription Read'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='Run Report Runner'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='Design Reports'));



INSERT INTO issue (code,description,role,update_date,type) values('CTCMM1000','Safety','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM2000','Health','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM3000','Personal ID','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM4000','Financial','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM5000','Legal','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM6000','Housing','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM7000','Education','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM8000','Employment','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM9000','Family','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM10000','Community Support','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM11000','Psycho-social concerns','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM12000','Client feedback / suggestions','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM13000','Physical Health','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM14000','Mental Health','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM15000','Addictions','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM16000','Social Support','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM17000','Respite','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM18000','Counselling Support','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM19000','Recovery/Healing','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM20000','Wellness Program','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM21000','Medication','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM22000','Hygiene/Clothing','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM23000','Increase Community Supports','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM24000','Discharge Planning','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM25000','Re- Admission Update','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM26000','Drug Card','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM27000','Suicidal Tendencies','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM28000','Incident Report','counsellor',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('CTCMM29000','Immigration','counsellor',Now(),'userDefined');

INSERT INTO issue (code,description,role,update_date,type) values('ICSW100','program-client conflict','CSW',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('ICSW200','difficulties with hygeine','CSW',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('ICSW300','difficulties with eating','CSW',Now(),'userDefined');
INSERT INTO issue (code,description,role,update_date,type) values('ICSW301','anorexia, loss of apetite','CSW',Now(),'userDefined');

-- community programs
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10001,1,'Subsidized Housing','Subsidized Housing','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10002,1,'Private Market Housing','Private Market Housing','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10003,1,'Returned to Previous Address','Returned to Previous Address','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10004,1,'Returned To Partner','Returned To Partner','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10005,1,'Returned to Parents','Returned to Parents','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10006,1,'Moved in with Friends or Relatives','Moved in with Friends or Relatives','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10007,1,'Continued at Another Hospital or Treatment','Continued at Another Hospital or Treatment','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10008,1,'Left the City','Left the City','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10009,1,'Whereabouts Unknown (AWOL)','Whereabouts Unknown (AWOL)','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10010,1,'Community, unknown destination','Community, unknown destination','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10011,1,'Incarcerated','Incarcerated','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10012,1,'Deceased','Deceased','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10013,1,'Community Shelter','Community Shelter','','','','','','','community','',99999,0,0,0,0,'active',1);
INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,userDefined) VALUES (10014,1,'Other','Other','','','','','','','community','',99999,0,0,0,0,'active',1);

INSERT INTO `program` (id,facilityId,name,description,address,phone,fax,url,email,emergencyNumber,type,location,maxAllowed,holdingTank,allowBatchAdmission,allowBatchDischarge,hic,programStatus,exclusiveView,defaultServiceRestrictionDays,userDefined) VALUES (10015,1,'Outside on Street','Outside on Street','','','','','','','community','',99999,0,0,0,0,'active','no',30,1);

-- DEFAULT BED TYPE
INSERT INTO `bed_type` VALUES (1, 'N/A', 1);

-- DEFAULT ROOM TYPES
INSERT INTO `room_type` VALUES (1, 'N/A', 1);

-- DEFAULT BED DEMOGRAPHIC STATUSES
INSERT INTO `bed_demographic_status` VALUES (1, 'N/A', 0, 1);

-- SYSTEM PROVIDER
insert into `provider` (`provider_no`, `last_name`, `first_name`, `provider_type`, `specialty`, `sex`, `status`) values (-1, 'system', 'system', 'system', 'system', 's', 1);

--
-- Populate intake node labels
--
INSERT INTO `intake_node_label` VALUES
	(1, ''),
	(2, 'Registration Intake'),
	(3, 'Follow-up Intake'), 
	(4, 'Page'),
	(5, 'Section'),
	(6, 'Question'),
	(7, 'Compound Answer'),
	(8, 'Boolean'),
	(9, 'String'),
	(10, 'Date'),
	(11, 'Integer'),
	(12, 'Email'),
	(13, 'Phone'),
	(14, 'Note'),
	(15, 'Program Intake');
		
--
-- Populate intake node types
--
INSERT INTO `intake_node_type` VALUES
	(1, 'intake'),
	(2, 'page'),
	(3, 'section'),
	(4, 'question'),
	(5, 'answer compound'),
	(6, 'answer scalar choice'),
	(7, 'answer scalar text'),
	(8, 'answer scalar note'),
	(9,'answer date');

--
-- Populate intake node templates
--
INSERT INTO `intake_node_template` VALUES
	(1, 1, 1, 2),
	(2, 2, 1, 3),
	(3, 3, 2, 4),
	(4, 4, 3, 5),
	(5, 5, 4, 6),
	(6, 6, 5, 7),
	(7, 7, 6, 8),
	(8, 8, 7, 9),
	(9, 9, 7, 10),
	(10, 10, 7, 11),
	(11, 11, 7, 12),
	(12, 12, 7, 13),
	(13, 13, 8, 14),
	(14, 14, 1, 15),
	(15, 15, 6, 8),
	(16,16,9,10);

--
-- Populate intake answer validation
--
INSERT INTO `intake_answer_validation` VALUES
	(1, 'date'),
	(2, 'integer'),
	(3, 'email'),
	(4, 'phone');

--
-- Populate intake answer element
--
INSERT INTO `intake_answer_element` VALUES
	(1, 7, NULL, 0, 'T', ''),
	(2, 7, NULL, 1, 'F', ''),
	(3, 8, NULL, 0, '', ''),
	(4, 9, 1, 0, '', ''),
	(5, 10, 2, 0, '', ''),
	(6, 11, 3, 0, '', ''),
	(7, 12, 4, 0, '', ''),
	(8, 13, NULL, 0, '', '');

--
-- Populate intake node
--
INSERT INTO `intake_node` VALUES
	(1, 1, NULL, 0, NULL, false, 1, 1, NULL, NULL,NULL,1,0,NULL),
	(2, 2, NULL, 0, NULL, false, 2, 1, NULL, NULL,NULL,2,0,NULL);

--
-- Cookie Revolver Init
--
INSERT INTO cr_policy (policy_id, static_ip, ip, remote_access, generate_super_certs, administrate_policies, administrate_questions, remove_bans, user_id, role_id, priority, usage_times_before_reverify, max_time_between_usage, expire_cookie, ip_filter, certs_max, certs_current, default_answer)
VALUES ('admin-policy', 0, null, 1, 1, 1, 1, 1, null, 'admin', 10, 10000000, 2592000, 315360000, null, 1000000, 1, null);

INSERT INTO cr_policy (policy_id, static_ip, ip, remote_access, generate_super_certs, administrate_policies, administrate_questions, remove_bans, user_id, role_id, priority, usage_times_before_reverify, max_time_between_usage, expire_cookie, ip_filter, certs_max, certs_current, default_answer)
VALUES ('doctor-policy', 0, null, 1, 0, 0, 0, 0, null, 'doctor', 10, 10000000, 2592000, 315360000, null, 1000000, 1, null);

INSERT INTO cr_policy (policy_id, static_ip, ip, remote_access, generate_super_certs, administrate_policies, administrate_questions, remove_bans, user_id, role_id, priority, usage_times_before_reverify, max_time_between_usage, expire_cookie, ip_filter, certs_max, certs_current, default_answer)
VALUES ('nurse-policy', 0, null, 1, 0, 0, 0, 0, null, 'nurse', 10, 10000000, 2592000, 315360000, null, 1000000, 1, null);

INSERT INTO cr_policy (policy_id, static_ip, ip, remote_access, generate_super_certs, administrate_policies, administrate_questions, remove_bans, user_id, role_id, priority, usage_times_before_reverify, max_time_between_usage, expire_cookie, ip_filter, certs_max, certs_current, default_answer)
VALUES ('remote-access-policy', 0, null, 1, 0, 0, 0, 0, null, 'remote_access', 10, 10000000, 2592000, 315360000, null, 1000000, 1, null);

INSERT INTO cr_policy (policy_id, static_ip, ip, remote_access, generate_super_certs, administrate_policies, administrate_questions, remove_bans, user_id, role_id, priority, usage_times_before_reverify, max_time_between_usage, expire_cookie, ip_filter, certs_max, certs_current, default_answer)
VALUES ('default', 0, null, 1, 0, 0, 0, 0, null, null, 10, 10000000, 2592000, 315360000, null, 1000000, 1, null);

INSERT INTO secRole (role_name) 
VALUES ('remote_access');



--
-- Sherbourne Summary Discharge Form
--
insert into encounterForm values("Discharge Summary","../form/formDischargeSummary.jsp?demographic_no=","formDischargeSummary",1);



-- RFQ: secObjectName
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.clientSearch', 'Client - Search', 0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.newClient', 'Client - New Client',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.mergeRecords', 'Client - Merge Records',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.caseManagement','PMM - Case Management',0);

-- PMM administration part

insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.provider', 'Administration - Provider',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.security', 'Administration - Security',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.securityLogReport', 'Administration - Security Log Report',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.unlockAccount', 'Administration - Unlock Account',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.cookieRevolver', 'Administration - Cookie Revolver',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.caisi', 'Administration - Caisi',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.lookupFieldEditor', 'Administration - Lookup Field Editor',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.issueEditor', 'Administration - Issue Editor',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.caisiRoles', 'Administration - Manage Caisi Roles',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.userCreatedForms', 'Administration - User Created Forms',0);

insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.facilityMessage', 'Administration - Facility Message',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_admin.systemMessage', 'Administration - System Message',0);

insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.agencyInformation','Program - Agency Information',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.manageFacilities','Program - Manage Facilities',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.staffList','Program - Staff List',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.programList','Program - Program List',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.addProgram','Program - Add Program',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.globalRoleAccess','Program - Global Role Access',0);
-- insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm.caisiRoles','Program - Caisi Roles',0);

insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm_editProgram.general','Program - General',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm_editProgram.staff','Program - Staff',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm_editProgram.functionUser','Program - User',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm_editProgram.teams', 'Program - Team', 0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm_editProgram.clients', 'Program - Clients',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm_editProgram.queue', 'Program - Queue',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm_editProgram.access', 'Program - Access',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm_editProgram.bedCheck', 'Program - Bed Check',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm_editProgram.clientStatus', 'Program - Client Status',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_pmm_editProgram.serviceRestrictions', 'Program - Service Restrictions',0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values ('_pmm.eidtor','Caisi Intake Editor',0);

-- Quatro Group Report
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_reportRunner', 'Report Runner', 0);
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values('_reportWriter', 'Report Writer', 0);

-- 
insert into `secObjPrivilege` values('doctor','_admin.facilityMessage','x',0,999998);
insert into `secObjPrivilege` values('doctor','_admin.systemMessage','x',0,999998);

insert into `secObjPrivilege` values('doctor','_admin.provider','x',0,999998);
insert into `secObjPrivilege` values('doctor','_admin.security','x',0,999998);
insert into `secObjPrivilege` values('doctor','_admin.securityLogReport','x',0,999998);
insert into `secObjPrivilege` values('doctor','_admin.unlockAccount','x',0,999998);
insert into `secObjPrivilege` values('doctor','_admin.cookieRevolver','x',0,999998);
insert into `secObjPrivilege` values('doctor','_admin.caisi','x',0,999998);
insert into `secObjPrivilege` values('doctor','_admin.lookupFieldEditor','x',0,999998);
insert into `secObjPrivilege` values('doctor','_admin.issueEditor','x',0,999998);
insert into `secObjPrivilege` values('doctor','_admin.caisiRoles','x',0,999998);
insert into `secObjPrivilege` values('doctor','_admin.userCreatedForms','x',0,999998);

insert into `secObjPrivilege` values('doctor','_pmm.clientSearch','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm.newClient','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm.mergeRecords','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm.caseManagement','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm.agencyInformation','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm.manageFacilities','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm.staffList','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm.programList','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm.addProgram','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm.globalRoleAccess','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm.caisiRoles','x',0,999998);

insert into `secObjPrivilege` values('doctor','_pmm_editProgram.general','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm_editProgram.staff','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm_editProgram.functionUser','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm_editProgram.teams','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm_editProgram.clients','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm_editProgram.queue','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm_editProgram.access','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm_editProgram.bedCheck','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm_editProgram.clientStatus','x',0,999998);
insert into `secObjPrivilege` values('doctor','_pmm_editProgram.serviceRestrictions','x',0,999998);
insert into `secObjPrivilege` values('admin','_pmm.editor','x',0,999998);

INSERT INTO secObjPrivilege (roleUserGroup, objectName, privilege, priority, provider_no)
	VALUES ('admin', '_reportRunner', 'x', 0, '999998');
INSERT INTO secObjPrivilege (roleUserGroup, objectName, privilege, priority, provider_no)
	VALUES ('admin', '_reportWriter', 'x', 0, '999998');
INSERT INTO secObjPrivilege (roleUserGroup, objectName, privilege, priority, provider_no)
	VALUES ('doctor', '_reportRunner', 'x', 0, '999998');
INSERT INTO secObjPrivilege (roleUserGroup, objectName, privilege, priority, provider_no)
	VALUES ('doctor', '_reportWriter', 'x', 0, '999998');


-- quatro group's report runner
insert into lst_gender (code,description,isactive,displayorder) values ('M','Male',1,2);
insert into lst_gender (code,description,isactive,displayorder) values ('F','Female',1,1);
insert into lst_gender (code,description,isactive,displayorder) values ('T','Transgender',1,3);

insert into lst_sector (id,description,isactive,displayorder) values (1,'Men',1,1);
insert into lst_sector (id,description,isactive,displayorder) values (2,'Women',1,2);
insert into lst_sector (id,description,isactive,displayorder) values (3,'Families',1,3);
insert into lst_sector (id,description,isactive,displayorder) values (4,'Youth',1,4);

insert into lst_organization (id,description,isactive,displayorder) values (1,'City of Toronto',1,1);
insert into lst_organization (id,description,isactive,displayorder) values (2,'Salvation Army',1,2);
insert into lst_organization (id,description,isactive,displayorder) values (3,'Fred Victor',1,3);

insert into lst_discharge_reason (id,description,needsecondary,isactive,displayorder) 
values (1,'Service restriction',0,1,10);
insert into lst_discharge_reason (id,description,needsecondary,isactive,displayorder) 
values (2,'Client Self Discharge',0,1,10);
insert into lst_discharge_reason (id,description,needsecondary,isactive,displayorder) 
values (3,'Other Program more appropriate',0,1,10);

insert into lst_field_category (id, description,isactive,displayorder)
values(1,'Agency',	1,	10);
insert into lst_field_category (id, description,isactive,displayorder)
values(2,'Client',  1, 20);
insert into lst_field_category (id, description,isactive,displayorder)
values(3,'Intake',	1,	30);
insert into lst_field_category (id, description,isactive,displayorder)
values(4,'Program', 1, 40);

insert into lst_service_restriction(id,description,isactive,displayorder)
values (1,'Assault of client',1,10);    
insert into lst_service_restriction(id,description,isactive,displayorder)
values (2,'Assault of staff',1,20);    
insert into lst_service_restriction(id,description,isactive,displayorder)
values (3,'Other',1,30);    

insert into lst_admission_status(code,description, isactive, displayorder)
values ('current','Current', 1, 10);
insert into lst_admission_status(code,description, isactive, displayorder)
values ('discharged','Discharged', 1, 20);

insert into lst_program_type values('01','BED',1,1);
insert into lst_program_type values('02','SERVICE',1,2);
insert into lst_program_type values('03','EXTERNAL',1,3);

insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('ORG', '1', 'lst_orgcd', 'Org Chart', 1, 8, 1);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('BTY', '4', 'bed_type', 'Bed Type', 0, 0, 0);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('GEN', '4', 'lst_gender', 'Gender', 0, 0, 1);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('SEC', '2', 'lst_sector', 'Sector', 0, 0, 1);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('OGN', '2', 'lst_organization', 'Organization', 0, 0, 1);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('DRN', '5', 'lst_discharge_reason', 'Discharge Reason', 0, 0, 1);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('SRT', '3', 'lst_service_restriction', 'Service Restriction', 0, 0, 1);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('LKT', '1', 'app_lookuptable', 'Available Fields', 0, 0, 1);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('FCT', '1', 'lst_field_category', 'Field Category', 0, 0, 1);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('PRO', '5', 'program', 'Program', 0, 0, 0);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('FAC', '5', 'facility', 'Facility', 0, 0, 0);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('AST', '5', 'lst_admission_status', 'Admission Status', 0, 0, 0);
insert into app_lookuptable (tableid, moduleid, table_name, description, istree, treecode_length, activeyn)
values ('PTY', '5', 'lst_program_type', 'Program Type', 0, 0, 0);
commit;

insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('ORG', 'code', 'CODE', '1', 'S', null, 'code', 1, 1, 1, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('ORG', 'description', 'DESCRIPTION', '1', 'S', null, 'description', 2, 0, 2, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('ORG', 'activeyn', 'ACTIVEYN', '1', 'N', null, 'activeyn', 3, 0, 3, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('ORG', 'orderbyindex', 'ORDERBYINDEX', '1', 'N', null, 'orderbyindex', 4, 0, 4, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('ORG', 'codetree', 'CODETREE', '1', 'S', null, 'codetree', 5, 0, 7, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('FCT', 'ID', 'Id', '0', 'N', null, 'id', 1, 1, 1, 1);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('FCT', 'DESCRIPTION', 'Description', '1', 'S', null, 'description', 2, 0, 2, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('FCT', 'ISACTIVE', 'Active?', '1', 'B', null, 'isactive', 3, 0, 3, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('FCT', 'DISPLAYORDER', 'Dispaly Order', '1', 'N', null, 'displayorder', 4, 0, 4, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('BTY', 'BED_TYPE_ID', 'Id', '0', 'N', null, 'bed_type_id', 1, 1, 1, 1);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('BTY', 'NAME', 'Name', '1', 'S', null, 'name', 2, 0, 2, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('BTY', 'DFLT', 'Default Capacity', '1', 'N', null, 'dflt', 3, 0, 6, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('LKT', 'TABLEID', 'Id', '0', 'S', null, 'tableid', 1, 1, 1, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('LKT', 'MODULEID', 'Category', '1', 'S', 'FCT', 'moduleid', 2, 0, 5, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('LKT', 'TABLE_NAME', 'Table Name', '1', 'S', null, 'table_name', 3, 0, 6, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('LKT', 'DESCRIPTION', 'Description', '1', 'S', null, 'description', 4, 0, 2, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('LKT', 'ISTREE', 'Is Tree Structured?', '1', 'B', null, 'istree', 5, 0, 0, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('LKT', 'TREECODE_LENGTH', 'Tree Code Length (if is tree)', '1', 'N', null, 'treecode_length', 6, 0, 0, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('LKT', 'ACTIVEYN', 'Active?', '1', 'B', null, 'activeyn', 7, 0, 3, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('GEN', 'CODE', 'Code', '1', 'S', null, 'code', 1, 1, 1, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('GEN', 'DESCRIPTION', 'Description', '1', 'S', null, 'description', 2, 0, 2, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('GEN', 'ISACTIVE', 'Active?', '1', 'B', null, 'isactive', 3, 0, 3, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('GEN', 'DISPLAYORDER', 'Dispaly Order', '1', 'N', null, 'displayorder', 4, 0, 4, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('SEC', 'ID', 'Id', '0', 'N', null, 'id', 1, 1, 1, 1);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('SEC', 'DESCRIPTION', 'Description', '1', 'S', null, 'description', 2, 0, 2, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('SEC', 'ISACTIVE', 'Active?', '1', 'B', null, 'isactive', 3, 0, 3, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('SEC', 'DISPLAYORDER', 'Dispaly Order', '1', 'N', null, 'displayorder', 4, 0, 4, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('OGN', 'ID', 'Id', '0', 'N', null, 'id', 1, 1, 1, 1);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('OGN', 'DESCRIPTION', 'Description', '1', 'S', null, 'description', 2, 0, 2, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('OGN', 'ISACTIVE', 'Active?', '1', 'B', null, 'isactive', 3, 0, 3, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('OGN', 'DISPLAYORDER', 'Dispaly Order', '1', 'N', null, 'displayorder', 4, 0, 4, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('DRN', 'ID', 'Id', '0', 'N', null, 'id', 1, 1, 1, 1);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('DRN', 'DESCRIPTION', 'Description', '1', 'S', null, 'description', 2, 0, 2, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('DRN', 'NEEDSECONDARY', 'Has Associated Secondary Reason?', '1', 'N', null, 'needsecondary', 3, 0, 6, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('DRN', 'ISACTIVE', 'Active?', '1', 'B', null, 'isactive', 4, 0, 3, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('DRN', 'DISPLAYORDER', 'Dispaly Order', '1', 'N', null, 'displayorder', 5, 0, 4, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('SRT', 'ID', 'Id', '0', 'N', null, 'id', 1, 1, 1, 1);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('SRT', 'DESCRIPTION', 'Description', '1', 'S', null, 'description', 2, 0, 2, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('SRT', 'ISACTIVE', 'Active?', '1', 'B', null, 'isactive', 3, 0, 3, 0);
insert into app_lookuptable_fields (tableid, fieldname, fielddesc, edityn, fieldtype, lookuptable, fieldsql, fieldindex, uniqueyn, genericiDX, AUTOYN)
values ('SRT', 'DISPLAYORDER', 'Dispaly Order', '1', 'N', null, 'displayorder', 4, 0, 4, 0);
commit;

insert into app_module (module_id, description)
values (1, 'Client Management');
insert into app_module (module_id, description)
values (2, 'Shelter Management');
insert into app_module (module_id, description)
values (3, 'Case Management');
insert into app_module (module_id, description)
values (4, 'System Administration');
insert into app_module (module_id, description)
values (5, 'Reports');


insert into report (reportno, title, description, orgapplicable, reporttype, dateoption, datepart, reportgroup, notes, tablename, updatedby, updateddate, sptorun)
values (81, 'Shelter Bed Logs', 'Bed Logs in a given shelter on given dates ', 1, 'RPT', 'B', 'D', 15, null, 'V_REP_BEDLOG', 'oscardoc', '2007-12-07 09:37:47', null);
insert into report (reportno, title, description, orgapplicable, reporttype, dateoption, datepart, reportgroup, notes, tablename, updatedby, updateddate, sptorun)
values (82, 'Client List', 'Under designing, please do not test', 1, 'RPT', 'N', null, 5, null, null, 'mespina', '2007-12-07 09:37:47', null);
insert into report (reportno, title, description, orgapplicable, reporttype, dateoption, datepart, reportgroup, notes, tablename, updatedby, updateddate, sptorun)
values (83, 'Case List', 'Under designing, please do not test', 1, 'RPT', 'N', null, 10, null, null, 'mespina', '2007-12-07 09:37:47', null);
insert into report (reportno, title, description, orgapplicable, reporttype, dateoption, datepart, reportgroup, notes, tablename, updatedby, updateddate, sptorun)
values (200594, 'User List', 'List of Users', 1, 'RPT', 'L', 'M', 90, null, 'V_REP_USERLIST', 'oscardoc', '2008-02-22 23:19:44', null);


insert into report_date_sp (reportno, startdate, enddate, asofdate, startdate_s, enddate_s, asofdate_s, sptorun)
values (88, '2007-12-06', '2008-02-08', '2007-12-06', '20071206', '20080208', '20071206', 'sp_cr_insert_empreghrs_tbl');

insert into report_document (docid, subject, privacycd, ownerid, checkoutyn, checkoutuserid, checkoutdate, doctype, filename, moduleid, refno, filetype, viewid, viewrefno, revdatetime)
values (200696, 'List Of Users', 'P', 'oscardoc', '0', null, null, 'RPT', 'CR_USER_LIST.rpt', 'REPORT', null, null, null, null, '2008-02-27 14:36:13');

insert into report_filter (reportno, fieldno, fieldname, fielddesc, fieldtype, lookup_table, iscrosstabheaders, operator, lookup_tree, fieldsql, lookup_script, note, valueformat)
values (200594, 200618, 'ROLE_NAME', null, 'S', 'ROL', null, 'C', null, 'ROLE_NAME', null, null, null);
insert into report_filter (reportno, fieldno, fieldname, fielddesc, fieldtype, lookup_table, iscrosstabheaders, operator, lookup_tree, fieldsql, lookup_script, note, valueformat)
values (200594, 200599, 'FIRST_NAME', null, 'S', null, null, 'CL', null, 'FIRST_NAME', null, null, null);
insert into report_filter (reportno, fieldno, fieldname, fielddesc, fieldtype, lookup_table, iscrosstabheaders, operator, lookup_tree, fieldsql, lookup_script, note, valueformat)
values (200594, 200600, 'Last Name', null, 'S', null, null, 'CL', null, 'LAST_NAME', null, null, null);
insert into report_filter (reportno, fieldno, fieldname, fielddesc, fieldtype, lookup_table, iscrosstabheaders, operator, lookup_tree, fieldsql, lookup_script, note, valueformat)
values (81, 1, 'Last Name', 'Client Last Name', 'S', 'BED', 'N', 'CL', null, 'LAST_NAME', null, null, null);
insert into report_filter (reportno, fieldno, fieldname, fielddesc, fieldtype, lookup_table, iscrosstabheaders, operator, lookup_tree, fieldsql, lookup_script, note, valueformat)
values (81, 2, 'First Name', 'Client First Name', 'S', 'BED', 'N', 'CL', null, 'FIRST_NAME', null, null, null);
insert into report_filter (reportno, fieldno, fieldname, fielddesc, fieldtype, lookup_table, iscrosstabheaders, operator, lookup_tree, fieldsql, lookup_script, note, valueformat)
values (81, 3, 'Room Name', 'Room Name', 'S', null, 'N', 'CL', null, 'ROOM_NAME', null, null, null);

insert into report_lk_reportgroup (id, description, shortdesc, activeyn, orderbyindex, note)
values (90, 'System Reserved', 'System', 'Y', 1500, 'This code is reserved for QGView use');
insert into report_lk_reportgroup (id, description, shortdesc, activeyn, orderbyindex, note)
values (5, 'Client Management', 'Client', 'Y', 1240, null);
insert into report_lk_reportgroup (id, description, shortdesc, activeyn, orderbyindex, note)
values (10, 'Case Management', 'Case', 'Y', 1241, null);
insert into report_lk_reportgroup (id, description, shortdesc, activeyn, orderbyindex, note)
values (15, 'Facility Management', 'Facility', 'Y', 1246, null);

insert into report_option (reportno, reportoptionid, optiontitle, longdesc, activeyn, defaultyn, datefield, datefielddesc, sqlwhere, sqlorderby, rptfilename, rptfileno, rptversion, datefieldtype)
values (81, 2, 'Bed log by data not works', 'Bed Log by data not works', 1, 0, 'ADMISSION_DATE', 'Admission Date', null, null, 'CR_SHEL_BEDLOG.rpt', 0, null, null);
insert into report_option (reportno, reportoptionid, optiontitle, longdesc, activeyn, defaultyn, datefield, datefielddesc, sqlwhere, sqlorderby, rptfilename, rptfileno, rptversion, datefieldtype)
values (81, 1, 'Bed log by date', 'Bed Log by date', 1, 1, 'ADMISSION_DATE', 'Admission Date', null, null, 'CR_SHEL_BEDLOG.rpt', 0, null, null);
insert into report_option (reportno, reportoptionid, optiontitle, longdesc, activeyn, defaultyn, datefield, datefielddesc, sqlwhere, sqlorderby, rptfilename, rptfileno, rptversion, datefieldtype)
values (200594, 200595, 'List Of Users', 'List f Users', 1, 1, 'PROVIDER_NO', null, null, null, 'CR_USER_LIST.rpt', 200696, null, null);

insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'CLIENT_ID', 1, null, 'N', null, null, 'CLIENT_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'ADMISSION_DATE', 2, null, 'D', null, null, 'ADMISSION_DATE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'DISCHARGE_DATE', 3, null, 'D', null, null, 'DISCHARGE_DATE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'PROGRAM_NAME', 4, null, 'S', null, null, 'PROGRAM_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'PROGRAM_DESCRIPTION', 5, null, 'S', null, null, 'PROGRAM_DESCRIPTION', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'BED_ID', 6, null, 'N', null, null, 'BED_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'BED_NAME', 7, null, 'S', null, null, 'BED_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'ROOM_ID', 8, null, 'N', null, null, 'ROOM_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'ROOM_NAME', 9, null, 'S', null, null, 'ROOM_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'CLIENT_PROG_ST_NAME', 10, null, 'S', null, null, 'CLIENT_PROG_ST_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'LAST_NAME', 11, null, 'S', null, null, 'LAST_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'FIRST_NAME', 12, null, 'S', null, null, 'FIRST_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200549, 'ORGCD', 13, null, 'N', null, null, 'ORGCD', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200554, 'PROVIDER_NO', 1, null, 'S', null, 0, 'PROVIDER.PROVIDER_NO', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200554, 'LAST_NAME', 2, 'Last Name', 'S', null, 0, 'PROVIDER.LAST_NAME', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200554, 'FIRST_NAME', 3, null, 'S', null, 0, 'PROVIDER.FIRST_NAME', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200554, 'ROLE_NAME', 4, null, 'S', null, 0, 'SECUSERROLE.ROLE_NAME', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'PROVIDER_NO', 1, null, 'S', null, null, 'PROVIDER_NO', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'LAST_NAME', 2, null, 'S', null, null, 'LAST_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'FIRST_NAME', 3, null, 'S', null, null, 'FIRST_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'PROVIDER_TYPE', 4, null, 'S', null, null, 'PROVIDER_TYPE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'SPECIALTY', 5, null, 'S', null, null, 'SPECIALTY', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'TEAM', 6, null, 'S', null, null, 'TEAM', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'SEX', 7, null, 'S', null, null, 'SEX', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'DOB', 8, null, 'D', null, null, 'DOB', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'ADDRESS', 9, null, 'S', null, null, 'ADDRESS', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'PHONE', 10, null, 'S', null, null, 'PHONE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'WORK_PHONE', 11, null, 'S', null, null, 'WORK_PHONE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'OHIP_NO', 12, null, 'S', null, null, 'OHIP_NO', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'RMA_NO', 13, null, 'S', null, null, 'RMA_NO', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'BILLING_NO', 14, null, 'S', null, null, 'BILLING_NO', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'HSO_NO', 15, null, 'S', null, null, 'HSO_NO', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'STATUS', 16, null, 'S', null, null, 'STATUS', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'COMMENTS', 17, null, 'S', null, null, 'COMMENTS', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200555, 'PROVIDER_ACTIVITY', 18, null, 'S', null, null, 'PROVIDER_ACTIVITY', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200556, 'PROVIDER_NO', 1, null, 'S', null, null, 'PROVIDER_NO', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200556, 'ROLE_NAME', 2, null, 'S', null, null, 'ROLE_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'LAST_NAME', 1, null, 'S', null, 0, 'DEMOGRAPHIC.LAST_NAME', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'FIRST_NAME', 2, null, 'S', null, 0, 'DEMOGRAPHIC.FIRST_NAME', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'ADDRESS', 3, null, 'S', null, 0, 'DEMOGRAPHIC.ADDRESS', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'CITY', 4, null, 'S', null, 0, 'DEMOGRAPHIC.CITY', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'PROVINCE', 5, null, 'S', null, 0, 'DEMOGRAPHIC.PROVINCE', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'POSTAL', 6, null, 'S', null, 0, 'DEMOGRAPHIC.POSTAL', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'ALIAS', 7, null, 'S', null, 0, 'DEMOGRAPHIC.ALIAS', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'INTAKE_ID', 8, null, 'N', null, 0, 'INTAKE.INTAKE_ID', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'CLIENT_ID', 9, null, 'N', null, 0, 'INTAKE.CLIENT_ID', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'STAFF_ID', 10, null, 'S', null, 0, 'INTAKE.STAFF_ID', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200611, 'CREATION_DATE', 11, null, 'D', null, 0, 'INTAKE.CREATION_DATE', null, 0, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'DEMOGRAPHIC_NO', 1, null, 'N', null, null, 'DEMOGRAPHIC_NO', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'LAST_NAME', 2, null, 'S', null, null, 'LAST_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'FIRST_NAME', 3, null, 'S', null, null, 'FIRST_NAME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'ADDRESS', 4, null, 'S', null, null, 'ADDRESS', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'CITY', 5, null, 'S', null, null, 'CITY', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'PROVINCE', 6, null, 'S', null, null, 'PROVINCE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'POSTAL', 7, null, 'S', null, null, 'POSTAL', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'PHONE', 8, null, 'S', null, null, 'PHONE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'PHONE2', 9, null, 'S', null, null, 'PHONE2', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'EMAIL', 10, null, 'S', null, null, 'EMAIL', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'PIN', 11, null, 'S', null, null, 'PIN', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'YEAR_OF_BIRTH', 12, null, 'S', null, null, 'YEAR_OF_BIRTH', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'MONTH_OF_BIRTH', 13, null, 'S', null, null, 'MONTH_OF_BIRTH', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'DATE_OF_BIRTH', 14, null, 'S', null, null, 'DATE_OF_BIRTH', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'HIN', 15, null, 'S', null, null, 'HIN', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'VER', 16, null, 'S', null, null, 'VER', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'ROSTER_STATUS', 17, null, 'S', null, null, 'ROSTER_STATUS', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'PATIENT_STATUS', 18, null, 'S', null, null, 'PATIENT_STATUS', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'DATE_JOINED', 19, null, 'D', null, null, 'DATE_JOINED', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'CHART_NO', 20, null, 'S', null, null, 'CHART_NO', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'PROVIDER_NO', 21, null, 'S', null, null, 'PROVIDER_NO', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'SEX', 22, null, 'S', null, null, 'SEX', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'END_DATE', 23, null, 'D', null, null, 'END_DATE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'EFF_DATE', 24, null, 'D', null, null, 'EFF_DATE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'PCN_INDICATOR', 25, null, 'S', null, null, 'PCN_INDICATOR', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'HC_TYPE', 26, null, 'S', null, null, 'HC_TYPE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'HC_RENEW_DATE', 27, null, 'D', null, null, 'HC_RENEW_DATE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'FAMILY_DOCTOR', 28, null, 'S', null, null, 'FAMILY_DOCTOR', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'ALIAS', 29, null, 'S', null, null, 'ALIAS', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'PREVIOUSADDRESS', 30, null, 'S', null, null, 'PREVIOUSADDRESS', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'CHILDREN', 31, null, 'S', null, null, 'CHILDREN', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'SOURCEOFINCOME', 32, null, 'S', null, null, 'SOURCEOFINCOME', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'CITIZENSHIP', 33, null, 'S', null, null, 'CITIZENSHIP', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200615, 'SIN', 34, null, 'S', null, null, 'SIN', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200616, 'INTAKE_ID', 1, null, 'N', null, null, 'INTAKE_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200616, 'INTAKE_NODE_ID', 2, null, 'N', null, null, 'INTAKE_NODE_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200616, 'CLIENT_ID', 3, null, 'N', null, null, 'CLIENT_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200616, 'STAFF_ID', 4, null, 'S', null, null, 'STAFF_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200616, 'CREATION_DATE', 5, null, 'D', null, null, 'CREATION_DATE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'AM_ID', 1, null, 'N', null, null, 'AM_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'CLIENT_ID', 2, null, 'N', null, null, 'CLIENT_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'PROGRAM_ID', 3, null, 'N', null, null, 'PROGRAM_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'PROVIDER_NO', 4, null, 'S', null, null, 'PROVIDER_NO', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'ADMISSION_DATE', 5, null, 'D', null, null, 'ADMISSION_DATE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'ADMISSION_NOTES', 6, null, 'S', null, null, 'ADMISSION_NOTES', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'TEMP_ADMISSION', 7, null, 'S', null, null, 'TEMP_ADMISSION', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'DISCHARGE_DATE', 8, null, 'D', null, null, 'DISCHARGE_DATE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'DISCHARGE_NOTES', 9, null, 'S', null, null, 'DISCHARGE_NOTES', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'TEMP_ADMIT_DISCHARGE', 10, null, 'S', null, null, 'TEMP_ADMIT_DISCHARGE', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'ADMISSION_STATUS', 11, null, 'S', null, null, 'ADMISSION_STATUS', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'TEAM_ID', 12, null, 'N', null, null, 'TEAM_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'TEMPORARY_ADMISSION_FLAG', 13, null, 'N', null, null, 'TEMPORARY_ADMISSION_FLAG', 'initial set up', null, null);


insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'AGENCY_ID', 14, null, 'N', null, null, 'AGENCY_ID', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'RADIODISCHARGEREASON', 15, null, 'S', null, null, 'RADIODISCHARGEREASON', 'initial set up', null, null);
insert into report_qgviewfield (qgviewno, fieldname, fieldno, description, fieldtypecode, numbermask, fieldlength, sourcetxt, note, grouprank, lookuptable)
values (200617, 'CLIENTSTATUS_ID', 16, null, 'N', null, null, 'CLIENTSTATUS_ID', 'initial set up', null, null);

insert into report_qgviewsummary (qgviewno, qgviewcode, description, groupcode, mastertype, updatedby, updateddate, note, activeyn, secureyn, dbentity, refviews, relations, filters, object_type, distinctyn)
values (200615, 'DEMOGRAPHIC', null, '90', 'M', 'oscardoc', '2008-02-22 21:13:31', 'intial setup', '1', '0', 'DEMOGRAPHIC', 'DEMOGRAPHIC', null, null, 'TABLE', null);
insert into report_qgviewsummary (qgviewno, qgviewcode, description, groupcode, mastertype, updatedby, updateddate, note, activeyn, secureyn, dbentity, refviews, relations, filters, object_type, distinctyn)
values (200616, 'INTAKE', null, '90', 'M', 'oscardoc', '2008-02-22', 'intial setup', '1', '0', 'INTAKE', 'INTAKE', null, null, 'TABLE', null);
insert into report_qgviewsummary (qgviewno, qgviewcode, description, groupcode, mastertype, updatedby, updateddate, note, activeyn, secureyn, dbentity, refviews, relations, filters, object_type, distinctyn)
values (200617, 'ADMISSION', null, '90', 'M', 'oscardoc', '2008-02-22', 'intial setup', '1', '0', 'ADMISSION', 'ADMISSION', null, null, 'TABLE', null);
insert into report_qgviewsummary (qgviewno, qgviewcode, description, groupcode, mastertype, updatedby, updateddate, note, activeyn, secureyn, dbentity, refviews, relations, filters, object_type, distinctyn)
values (200549, 'V_REP_BEDLOG', null, '90', 'M', 'oscardoc', '2008-02-20 14:19:40', 'intial setup', '1', '0', 'V_REP_BEDLOG', 'V_REP_BEDLOG', null, null, 'VIEW', null);
insert into report_qgviewsummary (qgviewno, qgviewcode, description, groupcode, mastertype, updatedby, updateddate, note, activeyn, secureyn, dbentity, refviews, relations, filters, object_type, distinctyn)
values (200554, 'V_REP_USERLIST', 'User List', '90', 'N', 'oscardoc', '2008-02-21 15:37:41', null, '0', '0', 'V_REP_USERLIST', 'PROVIDER,SECUSERROLE', 'PROVIDER INNER JOIN SECUSERROLE ON PROVIDER.PROVIDER_NO=SECUSERROLE.PROVIDER_NO', null, 'VIEW', '1');
insert into report_qgviewsummary (qgviewno, qgviewcode, description, groupcode, mastertype, updatedby, updateddate, note, activeyn, secureyn, dbentity, refviews, relations, filters, object_type, distinctyn)
values (200611, 'V_REP_CLIENT', 'List of clients', '5', 'N', 'oscardoc', '2008-02-22 23:00:16', 'This is a master view for clients', '0', '0', 'V_REP_CLIENT', 'DEMOGRAPHIC,INTAKE', 'INTAKE INNER JOIN DEMOGRAPHIC ON INTAKE.CLIENT_ID=DEMOGRAPHIC.DEMOGRAPHIC_NO', null, 'VIEW', null);
insert into report_qgviewsummary (qgviewno, qgviewcode, description, groupcode, mastertype, updatedby, updateddate, note, activeyn, secureyn, dbentity, refviews, relations, filters, object_type, distinctyn)
values (200555, 'PROVIDER', null, '90', 'M', 'oscardoc', '2008-02-21', 'intial setup', '1', '0', 'PROVIDER', 'PROVIDER', null, null, 'TABLE', null);
insert into report_qgviewsummary (qgviewno, qgviewcode, description, groupcode, mastertype, updatedby, updateddate, note, activeyn, secureyn, dbentity, refviews, relations, filters, object_type, distinctyn)
values (200556, 'SECUSERROLE', null, '90', 'M', 'oscardoc', '2008-02-21 12:59:53', 'intial setup', '1', '0', 'SECUSERROLE', 'SECUSERROLE', null, null, 'TABLE', null);


insert into report_role (reportno, rolecode, access_type)
values (82, 'doctor', '1');
insert into report_role (reportno, rolecode, access_type)
values (81, 'doctor', '1');
insert into report_role (reportno, rolecode, access_type)
values (83, 'doctor', '1');
insert into report_role (reportno, rolecode, access_type)
values (200594, 'doctor', '1');
insert into report_role (reportno, rolecode, access_type)
values (200594, 'admin', '1');

insert into report_template (templateno, reportno, reportoptionid, description, startdate, enddate, startpayperiod, endpayperiod, loginid, updatedate, privateyn)
values (200682, 81, 2, 'asdfgh', '2008-02-04', '2008-02-22', null, null, '999998', null, 0);
insert into report_template (templateno, reportno, reportoptionid, description, startdate, enddate, startpayperiod, endpayperiod, loginid, updatedate, privateyn)
values (200686, 81, 1, 'qwert', '2008-02-01', '2008-02-28', null, null, '999998', null, 0);
insert into report_template (templateno, reportno, reportoptionid, description, startdate, enddate, startpayperiod, endpayperiod, loginid, updatedate, privateyn)
values (200622, 200594, 200595, 'List of doctors', '1899-12-30', '1899-12-30', null, null, '999998', '2008-02-22 21:37:02', 0);
insert into report_template (templateno, reportno, reportoptionid, description, startdate, enddate, startpayperiod, endpayperiod, loginid, updatedate, privateyn)
values (313, 83, 7, 'Incident Cost Exception Report - Estimated Costs =$0', '1899-12-30', '1899-12-30', null, null, '999998', '2007-11-07 10:34:00', 0);
insert into report_template (templateno, reportno, reportoptionid, description, startdate, enddate, startpayperiod, endpayperiod, loginid, updatedate, privateyn)
values (312, 83, 6, 'Fatal Public Electrical Incidents', '1899-12-30', '1899-12-30', null, null, '999998', '2007-07-10 15:32:56', 0);



insert into report_template_criteria (counter, templateno, relation, fieldno, operator, operators, val, valdesc, required)
values (200688, 200686, null, 2, '=', null, '200284', 'Bed 10', 0);
insert into report_template_criteria (counter, templateno, relation, fieldno, operator, operators, val, valdesc, required)
values (1, 200622, null, 200618, '=', 'C', 'doctor', 'doctor', 0);
insert into report_template_criteria (counter, templateno, relation, fieldno, operator, operators, val, valdesc, required)
values (1, 200605, null, 200599, 'Like', 'CL', '*doc*', null, 0);
insert into report_template_criteria (counter, templateno, relation, fieldno, operator, operators, val, valdesc, required)
values (1, 200606, null, 200599, 'Like', 'CL', '*doc*', null, 0);
insert into report_template_criteria (counter, templateno, relation, fieldno, operator, operators, val, valdesc, required)
values (200694, 200682, null, 2, '=', null, '200267', 'Bed 1', 0);
insert into report_template_criteria (counter, templateno, relation, fieldno, operator, operators, val, valdesc, required)
values (200695, 200682, 'AND', 1, '<=', null, '200268', 'Bed 2', 0);


insert into report_template_org (counter, templateno, orgcd)
values (200687, 200686, '0');
insert into report_template_org (counter, templateno, orgcd)
values (1, 200622, 'ORG');
insert into report_template_org (counter, templateno, orgcd)
values (200693, 200682, '0');

-- set cpp issues
insert into issue (`code`,`description`,`role`,`update_date`,`type`) Values('OMeds','Other Meds as part of cpp', 'nurse', now(), 'system');
insert into issue (`code`,`description`,`role`,`update_date`,`type`) Values('SocHistory','Social History as part of cpp', 'nurse', now(), 'system');
insert into issue (`code`,`description`,`role`,`update_date`,`type`) Values('MedHistory','Medical History as part of cpp', 'nurse', now(), 'system');
insert into issue (`code`,`description`,`role`,`update_date`,`type`) Values('Concerns','Ongoing Concerns as part of cpp', 'nurse', now(), 'system');
insert into issue (`code`,`description`,`role`,`update_date`,`type`) Values('Reminders','Reminders as part of cpp', 'nurse', now(), 'system');
insert into issue (`code`,`description`,`role`,`update_date`,`type`) Values('FamHistory','Family History as part of cpp', 'nurse', now(), 'system');
insert into issue (`code`,`description`,`role`,`update_date`,`type`) Values('RiskFactors','Risk Factors as part of cpp', 'nurse', now(), 'system');

INSERT INTO encounterForm VALUES("Mental Health Form1","../form/formMentalHealthForm1.jsp?demographic_no=","formMentalHealthForm1",0);
INSERT INTO encounterForm VALUES("Mental Health Form14","../form/formMentalHealthForm14.jsp?demographic_no=","formMentalHealthForm14",0);
insert into encounterForm values("Mental Health Form42","../form/formMentalHealthForm42.jsp?demographic_no=","formMentalHealthForm42",0);

source init_cds_form_4_options.sql;
