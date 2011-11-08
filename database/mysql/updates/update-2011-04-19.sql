alter table other_id change table_id table_id varchar(30);
alter table program add siteSpecificField varchar(255);
alter table log add id bigint(20) not null auto_increment primary key;
alter table log change provider_no provider_no varchar(10);

