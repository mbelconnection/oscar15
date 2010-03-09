-- backup secRole, secObjPrivilege, caisi_role, access_type and default_role_access before you run this script file.

insert into `secRole` (role_name, description) values('psychiatrist', 'psychiatrist');
insert into `secRole` (role_name, description) values('RN', 'Registered Nurse');
insert into `secRole` (role_name, description) values('RPN', 'Registered Practical Nurse');
insert into `secRole` (role_name, description) values('Nurse Manager', 'Nurse Manager');
insert into `secRole` (role_name, description) values('Clinical Social Worker','Clinical Social Worker');
insert into `secRole` (role_name, description) values('Clinical Case Manager','Clinical Case Manager');
insert into `secRole` (role_name, description) values('Medical Secretary', 'Medical Secretary');
insert into `secRole` (role_name, description) values('Clinical Assistant', 'Clinical Assistant');
insert into `secRole` (role_name, description) values('secretary', 'secretary');
insert into `secRole` (role_name, description) values('counsellor', 'counsellor');
insert into `secRole` (role_name, description) values('Case Manager', 'Case Manager');
insert into `secRole` (role_name, description) values('Housing Worker', 'Housing Worker');
insert into `secRole` (role_name, description) values('Support Worker', 'Support Worker');
insert into `secRole` (role_name, description) values('Client Service Worker', 'Client Service Worker');

delete from secObjPrivilege;

insert into `secObjPrivilege` values('admin', '_admin', 'x', 0, '999998');
insert into `secObjPrivilege` values('admin','_admin.caisi','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.cookieRevolver','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.facilityMessage','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.issueEditor','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.lookupFieldEditor','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.provider','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.reporting','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.security','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.securityLogReport','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.systemMessage','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.unlockAccount','x',0,'999998');
insert into `secObjPrivilege` values('admin','_admin.userCreatedForms','x',0,'999998');
insert into `secObjPrivilege` values('admin','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('admin','_appointment.doctorLink','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm.addProgram','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm.globalRoleAccess','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm.manageFacilities','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm.programList','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm.staffList','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm_editProgram.access','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm_editProgram.bedCheck','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm_editProgram.clients','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm_editProgram.clientStatus','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm_editProgram.functionUser','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm_editProgram.general','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm_editProgram.queue','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm_editProgram.serviceRestrictions','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm_editProgram.staff','x',0,'999998');
insert into `secObjPrivilege` values('admin','_pmm_editProgram.teams','x',0,'999998');

insert into `secObjPrivilege` values('doctor','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_appointment.doctorLink','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_billing','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_pmm.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_rx','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_tasks','x',0,'999998');

insert into `secObjPrivilege` values('psychiatrist','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_appointment.doctorLink','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_billing','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_pmm.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_rx','x',0,'999998');
insert into `secObjPrivilege` values('psychiatrist','_tasks','x',0,'999998');


insert into `secObjPrivilege` values('nurse','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_pmm.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_tasks','x',0,'999998');



insert into `secObjPrivilege` values('RN','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('RN','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('RN','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('RN','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('RN','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('RN','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('RN','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('RN','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('RN','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('RN','_pmm.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('RN','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('RN','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('RN','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('RN','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('RN','_tasks','x',0,'999998');



insert into `secObjPrivilege` values('RPN','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_pmm.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('RPN','_tasks','x',0,'999998');




insert into `secObjPrivilege` values('Nurse Manager','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_pmm.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('Nurse Manager','_tasks','x',0,'999998');


insert into `secObjPrivilege` values('Clinical Social Worker','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Social Worker','_tasks','x',0,'999998');


insert into `secObjPrivilege` values('Clinical Case Manager','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Case Manager','_tasks','x',0,'999998');



insert into `secObjPrivilege` values('counsellor','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('counsellor','_tasks','x',0,'999998');


insert into `secObjPrivilege` values('Case Manager','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('Case Manager','_tasks','x',0,'999998');


insert into `secObjPrivilege` values('Housing Worker','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_flowsheet','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('Housing Worker','_tasks','x',0,'999998');


insert into `secObjPrivilege` values('Medical Secretary','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_pmm.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('Medical Secretary','_tasks','x',0,'999998');


insert into `secObjPrivilege` values('Clinical Assistant','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_pmm.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('Clinical Assistant','_tasks','x',0,'999998');


insert into `secObjPrivilege` values('secretary','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_pmm.caisiRoles','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_pmm.mergeRecords','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('secretary','_tasks','x',0,'999998');

insert into `secObjPrivilege` values('Support Worker','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('Support Worker','_tasks','x',0,'999998');

insert into `secObjPrivilege` values('Client Service Worker','_appointment','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_casemgmt.issues','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_casemgmt.notes','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_demographic','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_eChart','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_eChart.verifyButton','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_masterLink','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_pmm.agencyInformation','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_pmm.caseManagement','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_pmm.clientSearch','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_pmm.newClient','x',0,'999998');
insert into `secObjPrivilege` values('Client Service Worker','_tasks','x',0,'999998');




insert into caisi_role (name,userDefined,oscar_name,update_date) values('psychiatrist', 1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('RN', 1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('RPN',1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('Nurse Manager', 1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('Clinical Social Worker',1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('Clinical Case Manager',1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('Medical Secretary', 1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('Clinical Assistant', 1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('secretary', 1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('Case Manager',1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('Housing Worker', 1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('Support Worker', 1,'',now());
insert into caisi_role (name,userDefined,oscar_name,update_date) values('Client Service Worker', 1,'',now());


insert into access_type (name, type) values("read ticklers assigned to a doctor","access");

insert into access_type (name, type) values("read ticklers assigned to a psychiatrist","access");
insert into access_type (name, type) values("write psychiatrist issues","access");
insert into access_type (name, type) values("read psychiatrist issues","access");
insert into access_type (name, type) values("read psychiatrist notes","access");

insert into access_type (name, type) values("read ticklers assigned to a RN","access");
insert into access_type (name, type) values("write RN issues","access");
insert into access_type (name, type) values("read RN issues","access");
insert into access_type (name, type) values("read RN notes","access");

insert into access_type (name, type) values("read ticklers assigned to a RPN","access");
insert into access_type (name, type) values("write RPN issues","access");
insert into access_type (name, type) values("read RPN issues","access");
insert into access_type (name, type) values("read RPN notes","access");


insert into access_type (name, type) values("read ticklers assigned to a Nurse Manager","access");
insert into access_type (name, type) values("write Nurse Manager issues","access");
insert into access_type (name, type) values("read Nurse Manager issues","access");
insert into access_type (name, type) values("read Nurse Manager notes","access");


insert into access_type (name, type) values("read ticklers assigned to a Clinical Social Worker","access");
insert into access_type (name, type) values("write Clinical Social Worker issues","access");
insert into access_type (name, type) values("read Clinical Social Worker issues","access");
insert into access_type (name, type) values("read Clinical Social Worker notes","access");



insert into access_type (name, type) values("read ticklers assigned to a Clinical Case Manager","access");
insert into access_type (name, type) values("write Clinical Case Manager issues","access");
insert into access_type (name, type) values("read Clinical Case Manager issues","access");
insert into access_type (name, type) values("read Clinical Case Manager notes","access");



insert into access_type (name, type) values("read ticklers assigned to a counsellor","access");

insert into access_type (name, type) values("read ticklers assigned to a Case Manager","access");
insert into access_type (name, type) values("write Case Manager issues","access");
insert into access_type (name, type) values("read Case Manager issues","access");
insert into access_type (name, type) values("read Case Manager notes","access");


insert into access_type (name, type) values("read ticklers assigned to a Housing Worker","access");
insert into access_type (name, type) values("write Housing Worker issues","access");
insert into access_type (name, type) values("read Housing Worker issues","access");
insert into access_type (name, type) values("read Housing Worker notes","access");


insert into access_type (name, type) values("read ticklers assigned to a Medical Secretary","access");
insert into access_type (name, type) values("write Medical Secretary issues","access");
insert into access_type (name, type) values("read Medical Secretary issues","access");
insert into access_type (name, type) values("read Medical Secretary notes","access");


insert into access_type (name, type) values("read ticklers assigned to a Clinical Assistant","access");
insert into access_type (name, type) values("write Clinical Assistant issues","access");
insert into access_type (name, type) values("read Clinical Assistant issues","access");
insert into access_type (name, type) values("read Clinical Assistant notes","access");


insert into access_type (name, type) values("read ticklers assigned to a secretary","access");
insert into access_type (name, type) values("write secretary issues","access");
insert into access_type (name, type) values("read secretary issues","access");
insert into access_type (name, type) values("read secretary notes","access");

insert into access_type (name, type) values("read ticklers assigned to a Support Worker","access");
insert into access_type (name, type) values("write Support Worker issues","access");
insert into access_type (name, type) values("read Support Worker issues","access");
insert into access_type (name, type) values("read Support Worker notes","access");

insert into access_type (name, type) values("read ticklers assigned to a Client Service Worker","access");
insert into access_type (name, type) values("write Client Service Worker issues","access");
insert into access_type (name, type) values("read Client Service Worker issues","access");
insert into access_type (name, type) values("read Client Service Worker notes","access");


delete from default_role_access;

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a doctor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read doctor notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a psychiatrist'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read psychiatrist notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a RN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read RN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a RPN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read RPN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a Nurse Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Nurse Manager notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a Clinical Social Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Clinical Social Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a Clinical Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Clinical Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a counsellor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read counsellor notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a Housing Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Housing Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Clinical Assistant notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read secretary notes'));


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
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='print bed rosters and reports'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read nurse issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write nurse issues'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a doctor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read doctor notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a psychiatrist'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read psychiatrist notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a RN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read RN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a RPN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read RPN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a Nurse Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Nurse Manager notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a Clinical Social Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Clinical Social Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a Clinical Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Clinical Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a counsellor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read counsellor notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a Housing Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Housing Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Clinical Assistant notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='prescription Write'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='billing'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='medical encounter'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='immunization'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='prevention'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='disease registry'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='lab'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='prescription Read'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='print bed rosters and reports'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read nurse issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write nurse issues'));



insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a doctor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read doctor notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a psychiatrist'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read psychiatrist notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a RN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read RN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a RPN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read RPN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a Nurse Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Nurse Manager notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a Clinical Social Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Clinical Social Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a Clinical Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Clinical Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a counsellor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read counsellor notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a Housing Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Housing Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Clinical Assistant notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='immunization'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='prevention'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='disease registry'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='prescription Read'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='print bed rosters and reports'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read nurse issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write nurse issues'));







insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a doctor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read doctor notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a psychiatrist'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read psychiatrist notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a RN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read RN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a RPN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read RPN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a Nurse Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Nurse Manager notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a Clinical Social Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Clinical Social Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a Clinical Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Clinical Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a counsellor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read counsellor notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a Housing Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Housing Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Clinical Assistant notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='immunization'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='prevention'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='disease registry'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='prescription Read'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='print bed rosters and reports'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read nurse issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write nurse issues'));







insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a doctor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read doctor notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a psychiatrist'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read psychiatrist notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a RN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read RN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a RPN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read RPN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a Nurse Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Nurse Manager notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a Clinical Social Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Clinical Social Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a Clinical Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Clinical Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a counsellor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read counsellor notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a Housing Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Housing Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Clinical Assistant notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='immunization'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='prevention'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='disease registry'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='prescription Read'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='print bed rosters and reports'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read nurse issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write nurse issues'));






insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a doctor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read doctor notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a psychiatrist'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read psychiatrist notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a RN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read RN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a RPN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read RPN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a Nurse Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Nurse Manager notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a Clinical Social Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Clinical Social Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a Clinical Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Clinical Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a counsellor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read counsellor notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a Housing Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Housing Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read Clinical Assistant notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='immunization'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='prevention'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='disease registry'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='prescription Read'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Social Worker'),(select access_id from access_type where name='print bed rosters and reports'));










insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a doctor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write doctor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read doctor notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a psychiatrist'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write psychiatrist issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read psychiatrist notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a RN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write RN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read RN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a RPN'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write RPN issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read RPN notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Nurse Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write Nurse Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Nurse Manager notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Clinical Social Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write Clinical Social Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Clinical Social Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Clinical Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write Clinical Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Clinical Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a counsellor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read counsellor notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Case Manager notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Housing Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Housing Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read Clinical Assistant notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='immunization'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='prevention'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='disease registry'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='prescription Read'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Case Manager'),(select access_id from access_type where name='print bed rosters and reports'));










insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read ticklers assigned to a counsellor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='write counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read counsellor notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read ticklers assigned to a Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='write Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Case Manager notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read ticklers assigned to a Housing Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='write Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Housing Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Clinical Assistant notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read secretary notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='print bed rosters and reports'));





insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read ticklers assigned to a counsellor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='write counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read counsellor notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='write Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Case Manager notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Housing Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='write Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Housing Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Clinical Assistant notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read secretary notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='print bed rosters and reports'));





insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read ticklers assigned to a counsellor'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='write counsellor issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read counsellor notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read ticklers assigned to a Case Manager'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='write Case Manager issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Case Manager notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read ticklers assigned to a Housing Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='write Housing Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Housing Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Clinical Assistant notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read secretary notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='print bed rosters and reports'));





insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='read Clinical Assistant notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='read secretary notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Medical Secretary'),(select access_id from access_type where name='print bed rosters and reports'));











insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='read ticklers assigned to a Medical Secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='read Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='write Medical Secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='read Medical Secretary notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='read ticklers assigned to a Clinical Assistant'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='read Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='write Clinical Assistant issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='read Clinical Assistant notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='read secretary notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Clinical Assistant'),(select access_id from access_type where name='print bed rosters and reports'));






insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='read secretary notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='medical form'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='eform'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='secretary'),(select access_id from access_type where name='perform bed assignments'));

###############################
#### additional adding....



insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='read ticklers assigned to a Support Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='read Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='write Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='read Support Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='read ticklers assigned to a Client Service Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='read Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='write Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='read Client Service Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='read secretary notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Support Worker'),(select access_id from access_type where name='print bed rosters and reports'));




insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='read ticklers assigned to a Support Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='read Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='write Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='read Support Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='read ticklers assigned to a Client Service Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='read Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='write Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='read Client Service Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='read ticklers assigned to a secretary'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='read secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='write secretary issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='read secretary notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='Write Ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='oscarcomm'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='measurements'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='master file'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='read ticklers'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='Perform program registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='perform registration intake'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='perform admissions'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='perform discharges'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='perform bed assignments'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Client Service Worker'),(select access_id from access_type where name='print bed rosters and reports'));




insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a Support Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Support Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a Client Service Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='write Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read Client Service Worker notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a Support Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Support Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a Client Service Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='write Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read Client Service Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a Support Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Support Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a Client Service Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='write Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read Client Service Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a Support Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Support Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a Client Service Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='write Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read Client Service Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a Support Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Support Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a Client Service Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='write Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read Client Service Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read ticklers assigned to a Support Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='write Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Support Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read ticklers assigned to a Client Service Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='write Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='counsellor'),(select access_id from access_type where name='read Client Service Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Support Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='write Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Support Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read ticklers assigned to a Client Service Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='write Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Case Manager'),(select access_id from access_type where name='read Client Service Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read ticklers assigned to a Support Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='write Support Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Support Worker notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read ticklers assigned to a Client Service Worker'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='write Client Service Worker issues'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Housing Worker'),(select access_id from access_type where name='read Client Service Worker notes'));






