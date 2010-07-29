alter table secRole modify role_name varchar(60) NOT NULL default '';
delete from program_provider where role_id is null;
update secRole set role_name="counsellor" where role_name="Counsellor";
alter table OcanStaffForm modify startDate date;
INSERT INTO `OcanFormOption` VALUES (1203,'1.2','Number Of Centres','5','5'), (1204,'1.2','Number Of Centres','6','6'),(1205,'1.2','Number Of Centres','7','7'),(1206,'1.2','Number Of Centres','8','8'),(1207,'1.2','Number Of Centres','9','9'),(1208,'1.2','Number Of Centres','10','10');