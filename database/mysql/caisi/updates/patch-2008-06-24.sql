alter table facility add column useQuickConsent tinyint(1) not null;
update facility set useQuickConsent=1;

update bed set facility_id=1 where facility_id=0;
update room set facility_id=1 where facility_id=0;
update intake set facility_id=1 where facility_id is NULL;
update room set occupancy=20 where occupancy=0;
update custom_filter set end_date='8888-12-30' where end_date='0000-00-00';

insert into provider_facility select provider_no, "1" from provider;
insert into room_demographic select b.room_id,bd.demographic_no,bd.provider_no,reservation_start,reservation_end,'' from bed_demographic bd, bed b where bd.bed_id=b.bed_id; 

insert into `secObjectName` (`objectName`) values ('_pmm.eidtor');
insert into `secObjPrivilege` values('admin','_pmm.editor','x',0,999998);

update access_type set name="read ticklers assigned to a doctor" where name="read doctor ticklers";
update access_type set name="read ticklers assigned to a nurse" where name="read nurse ticklers";
update access_type set name="read ticklers assigned to a counsellor" where name="read counsellor ticklers";
update access_type set name="read ticklers assigned to a CSW" where name="read csw ticklers";
