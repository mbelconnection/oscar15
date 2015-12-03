ALTER TABLE functionalCentreAdmission ADD COLUMN dischargeReason varchar(200);

ALTER TABLE CdsClientForm ADD COLUMN serviceInitiationDate date;


alter table CdsClientForm add new_fca_id int;
update CdsClientForm set new_fca_id=0;
alter table CdsClientForm add new_admission_id int;
update CdsClientForm set new_admission_id=0;

update CdsClientForm set new_fca_id=(select p.functionalCentreId from admission a join program p on a.program_id=p.id where a.am_id=CdsClientForm.admissionId ) where new_fca_id=0;

update CdsClientForm set new_fca_id=0 where new_fca_id is null;

update CdsClientForm set new_admission_id=(select id from functionalCentreAdmission where demographicNo=CdsClientForm.clientId and functionalCentreId=CdsClientForm.new_fca_id limit 1) where new_admission_id=0;

update CdsClientForm set admissionId=new_fca_id;

alter table CdsClientForm drop column new_fca_id;
alter table CdsClientForm drop column new_admission_id;

