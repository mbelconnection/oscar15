INSERT INTO SECOBJECTNAME T (OBJECTNAME)
  VALUES ('_reportRunner');
INSERT INTO SECOBJECTNAME T (OBJECTNAME)
  VALUES ('_reportWriter');
COMMIT;


INSERT INTO SECOBJPRIVILEGE T (ROLEUSERGROUP, OBJECTNAME, PRIVILEGE, PRIORITY, PROVIDER_NO)
  VALUES ('admin', '_reportRunner', '|*|', 0, '999998');
INSERT INTO SECOBJPRIVILEGE T (ROLEUSERGROUP, OBJECTNAME, PRIVILEGE, PRIORITY, PROVIDER_NO)
  VALUES ('admin', '_reportWriter', '|*|', 0, '999998');
INSERT INTO SECOBJPRIVILEGE T (ROLEUSERGROUP, OBJECTNAME, PRIVILEGE, PRIORITY, PROVIDER_NO)
  VALUES ('doctor', '_reportRunner', '|*|', 0, '999998');
INSERT INTO SECOBJPRIVILEGE T (ROLEUSERGROUP, OBJECTNAME, PRIVILEGE, PRIORITY, PROVIDER_NO)
  VALUES ('doctor', '_reportWriter', '|*|', 0, '999998');
COMMIT;

alter table APP_LOOKUPTABLE disable all triggers;
alter table APP_LOOKUPTABLE_FIELDS disable all triggers;
alter table APP_MODULE disable all triggers;

insert into APP_LOOKUPTABLE (TABLEID, MODULEID, TABLE_NAME, DESCRIPTION, ISTREE, TREECODE_LENGTH, ACTIVEYN)
values ('BTY', '1', 'BED_TYPE', 'Bed Type', 0, 0, 1);
insert into APP_LOOKUPTABLE (TABLEID, MODULEID, TABLE_NAME, DESCRIPTION, ISTREE, TREECODE_LENGTH, ACTIVEYN)
values ('ORG', '2', 'AGENCY', 'Organization', 0, 0, 1);
insert into APP_LOOKUPTABLE (TABLEID, MODULEID, TABLE_NAME, DESCRIPTION, ISTREE, TREECODE_LENGTH, ACTIVEYN)
values ('ROL', '4', 'SECROLE', 'System Role', 0, 0, 1);
insert into APP_LOOKUPTABLE (TABLEID, MODULEID, TABLE_NAME, DESCRIPTION, ISTREE, TREECODE_LENGTH, ACTIVEYN)
values ('QGV', '5', 'REPORT_QGVIEWSUMMARY', 'List of Views', 0, 0, 1);
insert into APP_LOOKUPTABLE (TABLEID, MODULEID, TABLE_NAME, DESCRIPTION, ISTREE, TREECODE_LENGTH, ACTIVEYN)
values ('RPG', '5', 'REPORT_LK_REPORTGROUP', 'Report Group', 0, 0, 1);
insert into APP_LOOKUPTABLE (TABLEID, MODULEID, TABLE_NAME, DESCRIPTION, ISTREE, TREECODE_LENGTH, ACTIVEYN)
values ('LKT', '4', 'APP_LOOKUPTABLE', 'Lookup fields in the system', 0, 0, 1);
insert into APP_LOOKUPTABLE (TABLEID, MODULEID, TABLE_NAME, DESCRIPTION, ISTREE, TREECODE_LENGTH, ACTIVEYN)
values ('ROC', '4', 'CAISI_ROLE', 'Program Management Role', 0, 0, 1);
insert into APP_LOOKUPTABLE (TABLEID, MODULEID, TABLE_NAME, DESCRIPTION, ISTREE, TREECODE_LENGTH, ACTIVEYN)
values ('ISS', '1', 'ISSUE', 'Issue', 0, 0, 1);
insert into APP_LOOKUPTABLE (TABLEID, MODULEID, TABLE_NAME, DESCRIPTION, ISTREE, TREECODE_LENGTH, ACTIVEYN)
values ('IGP', '1', 'ISSUEGROUP', 'Issue Group', 0, 0, 1);
insert into APP_LOOKUPTABLE (TABLEID, MODULEID, TABLE_NAME, DESCRIPTION, ISTREE, TREECODE_LENGTH, ACTIVEYN)
values ('RMT', '1', 'ROOM_TYPE', 'Room Type', 0, 0, 1);
commit;
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('BTY', 'BED_TYPE_ID', 'Bed Type Id', '0', 'N', null, 'BED_TYPE_ID', 1, 1);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('BTY', 'NAME', 'Description', '1', 'S', null, 'NAME', 2, 0);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('BTY', 'DFLT', 'Default Capacity', '1', 'N', null, 'DFLT', 3, 0);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('ISS', 'ISSUE_ID', 'Issue Id', '0', 'N', null, 'ISSUE_ID', 1, 1);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('ISS', 'CODE', 'Code', '1', 'S', null, 'CODE', 2, 1);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('ISS', 'DESCRIPTION', 'Description', '1', 'S', null, 'DESCRIPTION', 3, 0);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('ISS', 'ROLE', 'Role', '1', 'S', 'ROL', 'ROLE', 4, 0);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('ISS', 'UPDATE_DATE', 'Update Date', '1', 'D', null, 'UPDATE_DATE', 6, 0);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('ISS', 'PRIORITY', 'Priority', '1', 'S', null, 'PRIORITY', 5, 0);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('IGP', 'ID', 'Id', '0', 'N', null, 'ID', 1, 1);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('IGP', 'NAME', 'Name', '1', 'S', null, 'NAME', 2, 0);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('RMT', 'ROOM_TYPE_ID', 'Room Type Id', '0', 'S', null, 'ROOM_TYPE_ID', 1, 1);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('RMT', 'NAME', 'Name', '1', 'S', null, 'NAME', 2, 0);
insert into APP_LOOKUPTABLE_FIELDS (TABLEID, FIELDNAME, FIELDDESC, EDITYN, FIELDTYPE, LOOKUPTABLE, FIELDSQL, FIELDINDEX, UNIQUEYN)
values ('RMT', 'DFLT', 'Default', '1', 'N', null, 'DFLT', 3, 0);
commit;
insert into APP_MODULE (MODULE_ID, DESCRIPTION)
values (1, 'Client Management');
insert into APP_MODULE (MODULE_ID, DESCRIPTION)
values (2, 'Shelter Management');
insert into APP_MODULE (MODULE_ID, DESCRIPTION)
values (3, 'Case Management');
insert into APP_MODULE (MODULE_ID, DESCRIPTION)
values (4, 'System Administration');
insert into APP_MODULE (MODULE_ID, DESCRIPTION)
values (5, 'Reports');
commit;

alter table APP_LOOKUPTABLE enable all triggers;
alter table APP_LOOKUPTABLE_FIELDS enable all triggers;
alter table APP_MODULE enable all triggers;