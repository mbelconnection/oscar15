ALTER TABLE functionalCentreAdmission ADD COLUMN dischargeReason varchar(200);

ALTER TABLE CdsClientForm ADD COLUMN serviceInitiationDate date;

alter table admission add newAdmissionId int(11);
update admission set newAdmissionId=0;
update admission set newAdmissionId=(select id from functionalCentreAdmission where demographicNo=admission.client_id limit 1); 
update admission set newAdmissionId=0 where newAdmissionId is null;

insert into functionalCentreAdmission select distinct null , o.clientId, p.functionalCentreId, o.initialContactDate, o.assessmentDate, o.serviceInitiationDate, NULL, 0, o.providerNo, o.created, NULL from CdsClientForm o, admission a , program p where o.admissionId=a.am_id and a.program_id=p.id and p.functionalCentreId is not null and p.functionalCentreId!="" and  o.assessmentDate is not null and o.initialContactDate is not null and a.newAdmissionId=0 group by clientId, functionalCentreId;

alter table CdsClientForm add new_fca_id int;
update CdsClientForm set new_fca_id=0;
alter table CdsClientForm add new_admission_id int;
update CdsClientForm set new_admission_id=0;

update CdsClientForm set new_fca_id=(select p.functionalCentreId from admission a join program p on a.program_id=p.id where a.am_id=CdsClientForm.admissionId and p.functionalCentreId is not null ) where new_fca_id=0;

update CdsClientForm set new_fca_id=0 where new_fca_id is null;

update CdsClientForm set new_admission_id=(select id from functionalCentreAdmission where demographicNo=CdsClientForm.clientId and functionalCentreId=CdsClientForm.new_fca_id and id is not null order by id desc limit 1) where new_admission_id=0;

update CdsClientForm set admissionId=new_admission_id where new_admission_id is not null and new_admission_id > 0;

update functionalCentreAdmission set serviceInitiationDate=admissionDate where serviceInitiationDate is NULL;

alter table CdsClientForm drop column new_fca_id;
alter table CdsClientForm drop column new_admission_id;
alter table admission drop column newAdmissionId;



