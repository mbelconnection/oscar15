alter table issue add sortOrderId int;
alter table billing_on_cheader1 modify demographic_name varchar(60) default NULL;
alter table ctl_billingservice modify service_group_name varchar(30) default NULL;
alter table ctl_billingservice modify service_group varchar(30) default NULL;
