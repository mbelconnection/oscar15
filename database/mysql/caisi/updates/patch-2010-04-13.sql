
insert into access_type (name, type) values("read ticklers assigned to a nurse","access");

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read ticklers assigned to a nurse'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='doctor'),(select access_id from access_type where name='read nurse notes'));


insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read ticklers assigned to a nurse'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='psychiatrist'),(select access_id from access_type where name='read nurse notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read ticklers assigned to a nurse'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RN'),(select access_id from access_type where name='read nurse notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read ticklers assigned to a nurse'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='RPN'),(select access_id from access_type where name='read nurse notes'));

insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read ticklers assigned to a nurse'));
insert into default_role_access (role_id,access_id) values ((select role_id from caisi_role where name='Nurse Manager'),(select access_id from access_type where name='read nurse notes'));

