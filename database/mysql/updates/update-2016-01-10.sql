alter table admission add newAdmissionId int(11);
alter table admission add fc varchar(20);

update admission set fc="";
update admission set fc = (select p.functionalCentreId from program p where p.id=admission.program_id) where fc="";

update admission set newAdmissionId=0;
update admission set newAdmissionId=(select id from functionalCentreAdmission where demographicNo=admission.client_id and functionalCentreId=admission.fc limit 1) where newAdmissionId=0;
update admission set newAdmissionId=0 where newAdmissionId is null;

insert into functionalCentreAdmission select distinct null , o.clientId, p.functionalCentreId, o.initialContactDate, o.assessmentDate, o.serviceInitiationDate, NULL, 0, o.providerNo, o.created, NULL from CdsClientForm o, admission a , program p where o.admissionId=a.am_id and a.program_id=p.id and p.functionalCentreId is not null and p.functionalCentreId!="" and a.newAdmissionId=0 and a.fc is not null group by clientId, functionalCentreId;

update admission set newAdmissionId=(select id from functionalCentreAdmission where demographicNo=admission.client_id and functionalCentreId=admission.fc ) where newAdmissionId=0;

update admission set newAdmissionId=0 where newAdmissionId is null;

-- cds form
alter table CdsClientForm add new_fca_id int;

update CdsClientForm set new_fca_id=0;

update CdsClientForm set new_fca_id=(select newAdmissionId from admission where am_id=CdsClientForm.admissionId and client_id=CdsClientForm.clientId limit 1) where new_fca_id=0;

update CdsClientForm set admissionId=new_fca_id ;

update functionalCentreAdmission set admissionDate=(select admission_date from admission where newAdmissionId=functionalCentreAdmission.id and client_id=functionalCentreAdmission.demographicNo limit 1) where admissionDate is null;

-- cbi form
-- alter table OcanStaffForm add new_fca_id int;
-- update OcanStaffForm set new_fca_id=0;
-- update OcanStaffForm set new_fca_id=(select newAdmissionId from admission where am_id=OcanStaffForm.admissionId and client_id=OcanStaffForm.clientId limit 1) where new_fca_id=0;
-- update OcanStaffForm set admissionId=new_fca_id ;


-- remove columns for merging
-- alter table OcanStaffForm drop column new_fca_id;
alter table CdsClientForm drop column new_fca_id;
alter table admission drop column fc;
alter table admission drop column newAdmissionId;

