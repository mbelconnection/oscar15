delete from secObjectName where objectName="_pmm.eidtor";
insert into `secObjectName` (`objectName`,`description`,`orgapplicable`) values ('_pmm.editor','Caisi Intake Editor',0);

delete from secObjPrivilege where objectName="_pmm.eidtor";
delete from secObjPrivilege where objectName="_pmm.editor" and roleUserGroup="admin";
insert into `secObjPrivilege` values('admin','_pmm.editor','x',0,999998);

alter table OcanStaffFormData modify answer text not null;