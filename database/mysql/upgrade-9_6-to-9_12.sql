-- Both regular and CAISI database updates from the 9.6 to 9.12 standards

-- For BC uncomment the following two lines

-- alter table billingmaster add column wcb_id int(10) default NULL;
-- create index billingmaster_wcb_id on billingmaster(wcb_id);

-- After this update migrate the data by logging in and going to oscar_mcmaster/billing/CA/BC/wcbMigrate.jsp  (Change oscar_mcmaster for your context name)


insert into `secObjPrivilege` values('doctor', '_casemgmt.issues', 'x', 0, '999998');
insert into `secObjPrivilege` values('doctor', '_casemgmt.notes', 'x', 0, '999998');

insert into `secObjPrivilege` values('admin', '_casemgmt.issues', 'x', 0, '999998');
insert into `secObjPrivilege` values('admin', '_casemgmt.notes', 'x', 0, '999998');

insert into `secObjPrivilege` values('locum', '_casemgmt.issues', 'x', 0, '999998');
insert into `secObjPrivilege` values('locum', '_casemgmt.notes', 'x', 0, '999998');

insert into `secObjPrivilege` values('receptionist', '_casemgmt.issues', 'x', 0, '999998');
insert into `secObjPrivilege` values('receptionist', '_casemgmt.notes', 'x', 0, '999998');

insert into `secObjPrivilege` values('nurse', '_casemgmt.issues', 'x', 0, '999998');
insert into `secObjPrivilege` values('nurse', '_casemgmt.notes', 'x', 0, '999998');

alter table provider add column signed_confidentiality date default '0001-01-01';

CREATE TABLE `dsGuidelines` (
  `id` int(11) NOT NULL auto_increment,
  `uuid` varchar(60) NOT NULL,
  `title` varchar(100) NOT NULL,
  `version` int(11) default NULL,
  `author` varchar(60) NOT NULL,
  `xml` text default NULL,
  `source` varchar(60) NOT NULL,
  `engine` varchar(60) NOT NULL,
  `dateStart` datetime DEFAULT NULL,
  `dateDecomissioned` datetime DEFAULT NULL,
  `status` varchar(1) DEFAULT 'A',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

CREATE TABLE `dsGuidelineProviderMap` (
  `mapid` int(11) NOT NULL auto_increment,
  `provider_no` varchar(11) NOT NULL,
  `guideline_uuid` varchar(60) NOT NULL,
  PRIMARY KEY (`mapid`)
) ENGINE=MyISAM;

CREATE TABLE `dx_associations` (
	`id` int primary key auto_increment,
	`dx_codetype` varchar(50) not null,
	`dx_code` varchar(50) not null,
	`codetype` varchar(50) not null,
	`code` varchar(50) not null,
	`update_date` timestamp not null
);

ALTER TABLE dxresearch ADD association tinyint(1) not null default 0;


CREATE TABLE `site` (
  `site_id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `short_name` varchar(10) NOT NULL default '',
  `phone` varchar(50) default '',
  `fax` varchar(50) default '',
  `bg_color` varchar(20) NOT NULL default '',
  `address` varchar(255) default '',
  `city` varchar(25) default '',
  `province` varchar(25) default '',
  `postal` varchar(10) default '',
  `status` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`site_id`),
  UNIQUE KEY `unique_name` (`name`),
  UNIQUE KEY `unique_shortname` (`short_name`)
) TYPE=MyISAM;


CREATE TABLE `providersite` (
  `provider_no` varchar(6) NOT NULL,
  `site_id` int(11) NOT NULL,
  PRIMARY KEY  (`provider_no`,`site_id`)
) TYPE=MyISAM;

-- add a clinic column to store the site when billing was made
ALTER TABLE `billing_on_cheader1` ADD `clinic` VARCHAR(30) NULL AFTER `timestamp1` ;

-- enlarge the column size to fix a bug that results from cutoff due to lengthy content --
ALTER TABLE `rschedule` CHANGE `avail_hour` `avail_hour` TEXT NULL  ;


INSERT INTO `secObjectName` (`objectName`, `description`, `orgapplicable`) VALUES ('_team_schedule_only', 'Restrict schedule to only login provider and his team', '0');
INSERT INTO `secObjectName` (`objectName`, `description`, `orgapplicable`) VALUES ('_team_billing_only', 'Restrict billing access to only login provider and his team', '0');

-- add index to improve performance
ALTER TABLE `appointment` ADD INDEX `location` (`location`) ;
ALTER TABLE `billing_on_cheader1` ADD INDEX `clinic` (`clinic`) ;

-- new columns to help manage meds in the drug profile.
alter table drugs add column archived_reason varchar(100) default 'deleted';
alter table drugs add column archived_date datetime;
alter table drugs add column hide_from_drug_profile tinyint(1) default '0';

drop table RedirectLink;
drop table RedirectLinkTracking;

alter table drugs alter column archived_reason set default '';
update drugs set drugs.archived_reason='' where drugs.archived_reason='deleted' and drugs.archived=0;
update drugs set drugs.archived_reason='deleted' where drugs.archived_reason='' and drugs.archived=1;

delete from lst_field_category;
alter table lst_field_category
add lastUpdateUser varchar(6),
add lastUpdateDate date;

create table lst_shelter (
        id int(10) not null auto_increment,
        name varchar(32) default '',
        description varchar(80) default '',
        contact_name varchar(255),
        active int(1),
        orgid int(10),
        type varchar(20),
        street_1 varchar(255),
        street_2 varchar(255),
        city varchar(32),
        province varchar(32),
        postal_code varchar(7),
        telephone varchar(32),
        fax varchar(32),
        lastUpdateUser varchar(6),
        lastUpdateDate date,
        primary key(`id`)
);


delete from app_module;
alter table `app_module`
add isActive integer,
add displayOrder integer,
add lastUpdateUser varchar(6),
add lastUpdateDate date;

create table lst_aboriginal (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_actions_content (
	code varchar(80) not null,
	description varchar(80)
);

delete from lst_admission_status;
alter table lst_admission_status 
add lastUpdateUser varchar(6),
add lastUpdateDate date;


create table lst_bed_type (
	bed_type_id int(10) not null,
	name varchar(45),
	isActive int(1) default 0,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(bed_type_id)
);


create table lst_casestatus (
        id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10),
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);

create table lst_complaint_method (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);

create table lst_complaint_outcome (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);

create table lst_complaint_section (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);

create table lst_complaint_source (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);


create table lst_complaint_subsection (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	sectionId int(10),
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);

create table lst_componentofservice (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);

create table lst_country (
	code varchar(3) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_cursleeparrangement (
	code int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);


drop table lst_discharge_reason;
create table lst_discharge_reason (
	code varchar(3) not null,
	description varchar(80),
	needSecondary int(1),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_documentcategory (
	code varchar(3) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);


create table lst_documenttype (
	code varchar(8) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	mime varchar(50),
	shortDesc varchar(10),
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_encounter_type (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);

create table lst_family_relationship (
	code varchar(2) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);


create table lst_fieldtype (
	code varchar(8) not null,
	description varchar(80),
	activeyn int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

delete from lst_gender;
alter table lst_gender 
add progDesc varchar(80),
add lastUpdateUser varchar(6),
add lastUpdateDate date;


create table lst_incident_clientissues (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);


create table lst_incident_disposition (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);

create table lst_incident_nature (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);


create table lst_incident_others (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);


create table lst_intake_reject_reason (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_language (
	code varchar(3) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_lengthofhomeless (
	code int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_livedbefore (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_message_type (
	code varchar(8) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_operator (
	code varchar(8) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

alter table lst_organization
add lastUpdateUser varchar(6),
add lastUpdateDate date;

delete from lst_program_type;
alter table lst_program_type
add lastUpdateUser varchar(6),
add lastUpdateDate date;

create table lst_province (
	code varchar(3) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_reasonforhomeless (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_reasonforservice (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_reasonnoadmit (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_reason_notsign (
	code varchar(3) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_referredby (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_referredto (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_room_type (
	room_type_id int(10) not null,
	name varchar(45),
	dflt int(10) default 0,
	isActive int(1) default 0,
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(room_type_id)
);

delete from lst_sector;
alter table lst_sector
add lastUpdateUser varchar(6),
add lastUpdateDate date;

delete from lst_service_restriction;
alter table lst_service_restriction
add lastUpdateUser varchar(6),
add lastUpdateDate date;

create table lst_shelter_standards (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	sectionId int(10),
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);

create table lst_sourceincome (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_statusincanada (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

create table lst_title (
	id int(10) not null auto_increment,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(id)
);

create table lst_transportation_type (
	code int(10) not null,
	description varchar(80),
	isActive int(1),
	displayOrder int(10) default 1,
	lastUpdateUser varchar(6),
	lastUpdateDate date,
	primary key(code)
);

alter table Facility drop column integratorLastPushTime;


insert into encounterForm values("Mental Health Form42","../form/formMentalHealthForm42.jsp?demographic_no=","formMentalHealthForm42",0);

create table formMentalHealthForm42(
	id int primary key auto_increment,
	demographic_no bigint(11) NOT NULL default 0,  
  	formCreated date default NULL,
  	formEdited timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,  
  	
  	
  	name varchar(60) default null,
	homeAddress varchar(255) default null,
	physician varchar(60) default null,
	dateOfExamination varchar(10) default null,
	
	chkThreatenedA tinyint(1) default 0,
	chkBehavedA tinyint(1) default 0,
	chkCompetenceA tinyint(1) default 0,
	chkHarmYourselfA tinyint(1) default 0,
	chkHarmAnotherA tinyint(1) default 0,
	chkImpairmentA tinyint(1) default 0,
	
	chkHarmYourselfB tinyint(1) default 0,
	chkHarmAnotherB tinyint(1) default 0,
	chkDeteriorationB tinyint(1) default 0,
	chkImpairmentB tinyint(1) default 0,
	
	chkHarmYourselfB2 tinyint(1) default 0,
	chkHarmAnotherB2 tinyint(1) default 0,
	chkDeteriorationB2 tinyint(1) default 0,
	chkImpairmentB2 tinyint(1) default 0,
	
	dateOfSign varchar(10) default 0,
	signPhysician varchar(60) default null,
	
	name2 varchar(60) default null,
	homeAddress2 varchar(255) default null,
	nameOfMinisterHealth varchar(255) default null,
	
	chkHarmYourself2 tinyint(1) default 0,
	chkHarmAnother2 tinyint(1) default 0,
	dateOfOrder varchar(10) default null,
	dateOfSign2 varchar(10) default null,
	signPhysician2 varchar(60) default null

);


CREATE TABLE `intake_node_js` (
	`id` integer not null auto_increment,
	`question_id` varchar(255) not null,
	`location` varchar(255) not null,
	primary key(id)
);

ALTER TABLE `intake_node` add `repeating` boolean NOT NULL default false;

ALTER TABLE `intake_answer` add idx integer not null default 0;

insert into intake_node_type values(9,'answer date');
insert into intake_node_template values(16,16,9,10);

alter table intake_node add validations varchar(255);

create table CdsFormOption
(
	id int primary key auto_increment,
	cdsFormVersion varchar(16) not null,
	cdsDataCategory varchar(16) not null,
	cdsDataCategoryName varchar(255) not null
);

insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','006-01','English');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','006-02','French');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','006-03','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','007-01','Unique individuals - admitted');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','007-02','Unique individuals - pre-admission');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','007-03','Individuals- not uniquely identified');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','007-04','Multiple Admission for Uniquely Identified Individuals');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','07a-01','Individuals Waiting for Initial Assessment');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','07a-02','Days Waited for Initial Assessment');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','07a-03','Individuals Waiting for Service Initiation');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','07a-04','Days Waited for Service Initiation');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','008-01','Male');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','008-02','Female');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','008-03','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','008-04','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-01','0-15');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-02','16-17');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-03','18-24');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-04','25-34');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-05','35-44');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-06','45-54');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-07','55-64');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-08','65-74');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-09','75-84');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-10','85 and over');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-11','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-12','Minimum Age');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-13','Maximum Age');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','009-14','Average Age');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-01','Algoma District');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-02','Brant');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-03','Bruce');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-04','Cochrane District');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-05','Dufferin');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-06','Durham');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-07','Elgin');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-08','Essex');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-09','Frontenac');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-10','Grey');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-11','Haldimand-Norfolk');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-12','Haliburton');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-13','Halton');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-14','Hamilton');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-15','Hastings');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-16','Huron');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-17','Kenora & Kenora P.P.');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-18','Chatham-Kent');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-19','Lambton');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-20','Lanark');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-21','Leeds & Grenville');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-22','Lennox & Addington');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-23','Manitoulin District');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-24','Middlesex');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-25','Muskoka District Mun');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-26','Niagara');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-27','Nipissing District');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-28','Northumberland');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-29','Ottawa');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-30','Out Of Province');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-31','Oxford');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-32','Parry Sound District');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-33','Peel');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-34','Perth');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-35','Peterborough');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-36','Prescott & Russell');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-37','Prince Edward');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-38','Rainy River District');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-39','Renfrew');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-40','Simcoe');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-41','Stormont, Dundas & Glengarry');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-42','Sudbury District');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-43','Sudbury Region');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-44','Thunder Bay District');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-45','Timiskaming District');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-46','Toronto');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-47','Unknown');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-48','Victoria Kawartha Lakes');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-49','Waterloo');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-50','Wellington');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-51','York');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','010-52','Out of Country');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-01','Central');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-02','Central East');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-03','Central West');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-04','Champlain');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-05','Erie-St.Clair');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-06','Hamilton Niagara Haldimand Brant');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-07','Mississauga Halton');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-08','North East');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-09','North Simcoe Muskoka');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-10','North West');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-11','South East');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-12','South West');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-13','Toronto Central');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-14','Waterloo Wellington');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-15','Out of Province');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10a-16','Other/Unknown');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-01','Central');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-02','Central East');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-03','Central West');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-04','Champlain');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-05','Erie-St.Clair');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-06','Hamilton Niagara Haldimand Brant');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-07','Mississauga Halton');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-08','North East');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-09','North Simcoe Muskoka');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-10','North West');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-11','South East');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-12','South West');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-13','Toronto Central');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-14','Waterloo Wellington');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-15','Out of Province');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','10b-16','Other/Unknown');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','011-01','Aboriginal');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','011-02','Non-aboriginal');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','011-03','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','012-01','English');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','012-02','French');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','012-03','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','012-04','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-01','Pre-charge Diversion');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-02','Court Diversion Program');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-03','Awaiting fitness assessment');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-04','Awaiting trial (with or without bail)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-05','Awaiting Criminal Responsibility Assessment (NCR)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-06','In community on own recognizance');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-07','Unfit to stand trial');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-08','Charges withdrawn');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-09','Stay of proceedings');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-10','Awaiting sentence');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-11','NCR');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-12','Conditional discharge');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-13','Conditional sentence');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-14','Restraining order');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-15','Peace bond');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-16','Suspended sentence');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-17','ORB detained- community access');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-18','ORB conditional discharge');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-19','On parole');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-20','On probation');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-21','No Legal Problems (includes absolute discharge and end of sentence)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','013-24','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-01','Pre-charge Diversion');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-02','Court Diversion Program');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-03','Awaiting fitness assessment');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-04','Awaiting trial (with or without bail)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-05','Awaiting Criminal Responsibility Assessment (NCR)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-06','In community on own recognizance');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-07','Unfit to stand trial');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-08','Charges withdrawn');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-09','Stay of proceedings');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-10','Awaiting sentence');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-11','NCR');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-12','Conditional discharge');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-13','Conditional sentence');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-14','Restraining order');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-15','Peace bond');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-16','Suspended sentence');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-17','ORB detained- community access');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-18','ORB conditional discharge');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-19','On parole');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-20','On probation');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-21','No Legal Problems (includes absolute discharge and end of sentence)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','014-24','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','015-01','Issued CTO');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','015-02','No CTO');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','015-03','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-01','Adjustment Disorders');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-02','Anxiety Disorder');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-03','Delirium, Dementia, and Amnestic and Cognitive Disorders');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-04','Disorder of Childhood/Adolescence');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-05','Dissociative Disorders');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-06','Eating Disorders');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-07','Factitious Disorders');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-08','Impulse Control Disorders not elsewhere classified');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-09','Mental Disorders due to General Medical Conditions');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-10','Mood Disorder');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-11','Personality Disorders');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-12','Schizophrenia and other Psychotic Disorder');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-13','Sexual and Gender Identity Disorders');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-14','Sleep Disorders');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-15','Somatoform Disorders');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-16','Substance Related Disorders');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-17','Developmental Handicap');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','016-18','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','16a-01','Concurrent Disorder (Substance Abuse)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','16a-02','Dual Diagnosis (Developmental Disability)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','16a-03','Other Chronic illnesses and/or physical disabilities');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-01','Threat to others/ attempted suicide');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-02','Specific symptom of Serious Mental Illness');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-03','Physical/ Sexual Abuse');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-04','Educational');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-05','Occupational/ Employment/ Vocational');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-06','Housing');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-07','Financial');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-08','Legal');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-09','Problems with Relationships');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-10','Problems with substance abuse/ addictions');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-11','Activities of daily living');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','017-12','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-01','General Hospital');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-02','Psychiatric Hospital');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-03','Other Institution');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-04','CMH&A - Case Management');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-05','CMH&A - ACT Teams');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-06','CMH&A - Counseling and Treatment');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-07','CMH&A - Diversion and Court Support (Enter in CJS subcategories) (Data no longer accepted)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-08','CMH&A - Early Intervention');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-09','CMH&A - Crisis Intervention');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-10','CMH&A - Supports within Housing');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-11','CMH&A - Short Term Residential Crisis Support Beds (Enter in CJS subcategory) (Data no longer accepted)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-12','CMH&A - Information and Referral');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-13','CMH&A - Other community mental health and addiction services');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-14','Other community agencies');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-15','Family Physicians');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-16','Psychiatrists');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-17','Mental Health Worker');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-18','Criminal Justice System (CJS) - Police');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-19','Criminal Justice System (CJS) - Courts (includes Court Support & Diversion Programs)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-20','Criminal Justice System (CJS) - Correctional Facilities (includes jails and detention centres)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-21','Criminal Justice System (CJS) - Probation/Parole Officers');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-22','Criminal Justice System (CJS) - Short Term Residential Safe Beds');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-23','Criminal Justice System (CJS) - Source breakdown not available (use this category if above detailed breakdown is not available)');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-24','Self, Family or friend');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','018-25','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','019-01','Completion without referral');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','019-02','Completion with referral');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','019-03','Suicides');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','019-04','Death');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','019-05','Relocation');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','019-06','Withdrawal');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','020-01','Not been hospitalized');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','020-02','Total Number of Episodes');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','020-03','Total Number of Hospitalization Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','020-04','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','020-05','Average age at first psychiatric hospitalization');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','020-06','Average age at the onset of mental illness');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-01','Not been hospitalized');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-02','Total Number of Episodes');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-03','Total Number of Hospitalization Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-04','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-05','Year 1 Hospital Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-06','Year 2 Hospital Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-07','Year 3 Hospital Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-08','Year 4 Hospital Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-09','Year 5 Hospital Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-10','Year 6 Hospital Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-11','Year 7 Hospital Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-12','Year 8 Hospital Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-13','Year 9 Hospital Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','021-14','Year 10 Hospital Days');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','022-01','Self');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','022-02','Spouse/partner');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','022-03','Spouse/partner and others');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','022-04','Children');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','022-05','Parents');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','022-06','Relatives');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','022-07','Non-relatives');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','022-08','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','023-01','Self');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','023-02','Spouse/partner');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','023-03','Spouse/partner and others');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','023-04','Children');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','023-05','Parents');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','023-06','Relatives');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','023-07','Non-relatives');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','023-08','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-01','Approved Homes & Homes for Special Care');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-02','Correctional/ Probational Facility');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-03','Domiciliary Hostel');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-04','General Hospital');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-05','Psychiatric Hospital');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-06','Other Specialty Hospital');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-07','No fixed address');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-08','Hostel/Shelter');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-09','Long-Term Care Facility/Nursing Home');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-10','Municipal Non-Profit Housing');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-11','Private Non-Profit Housing');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-12','Private House/ Apt. - SR Owned /Market Rent');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-13','Private House/ Apt. - Other / Subsidized');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-14','Retirement Home/Senior\'s Residence');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-15','Rooming/ Boarding House');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-16','Supportive Housing - Congregate Living');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-17','Supportive Housing - Assisted Living');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-18','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','024-19','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','24a-01','Independent');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','24a-02','Assisted/Supported');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','24a-03','Supervised Non-facility');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','24a-04','Supervised Facility');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','24a-05','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-01','Approved Homes & Homes for Special Care');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-02','Correctional/ Probational Facility');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-03','Domiciliary Hostel');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-04','General Hospital');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-05','Psychiatric Hospital');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-06','Other Specialty Hospital');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-07','No fixed address');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-08','Hostel/Shelter');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-09','Long-Term Care Facility/Nursing Home');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-10','Municipal Non-Profit Housing');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-11','Private Non-Profit Housing');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-12','Private House/ Apt. - SR Owned /Market Rent');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-13','Private House/ Apt. - Other / Subsidized');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-14','Retirement Home/Senior\'s Residence');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-15','Rooming/ Boarding House');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-16','Supportive Housing - Congregate Living');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-17','Supportive Housing - Assisted Living');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-18','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','025-19','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','25a-01','Independent');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','25a-02','Assisted/Supported');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','25a-03','Supervised Non-facility');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','25a-04','Supervised Facility');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','25a-05','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','026-01','Independent/Competitive');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','026-02','Assisted/Supportive');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','026-03','Alternative Businesses');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','026-04','Sheltered Workshop');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','026-05','Non-Paid Work Experience');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','026-06','No employment - Other Activity');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','026-07','Casual / Sporadic');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','026-08','No employment of any kind');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','026-09','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-01','Independent/Competitive');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-02','Assisted/Supportive');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-03','Alternative businesses');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-04','Sheltered Workshop');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-05','Non-Paid Work Experience');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-06','No employment - Other Activity');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-07','Casual / Sporadic');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-08','No employment of any kind');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-09','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-10','Number of people participating in the program annually');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-11','Number of people completing the program');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-12','Number of people employed as a result of program participation');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','027-13','Number of people experiencing a vocational crisis who were helped to maintain employment');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','028-01','Not in school');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','028-02','Elementary/Junior High School');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','028-03','Secondary/High School');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','028-04','Trade School');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','028-05','Vocational/ Training Centre');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','028-06','Adult Education');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','028-07','Community College');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','028-08','University');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','028-09','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','028-10','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','029-01','Not in school');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','029-02','Elementary/Junior High School');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','029-03','Secondary/High School');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','029-04','Trade School');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','029-05','Vocational/ Training Centre');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','029-06','Adult Education');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','029-07','Community College');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','029-08','University');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','029-09','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','029-10','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','29a-01','No formal schooling');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','29a-02','Some Elementary/Junior High School');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','29a-03','Elementary/Junior High School');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','29a-04','Some Secondary/High School');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','29a-05','Secondary/High School');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','29a-06','Some College/University');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','29a-07','College/University');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','29a-08','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','030-01','Employment');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','030-02','Employment insurance');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','030-03','Pension');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','030-04','ODSP');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','030-05','Social Assistance');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','030-06','Disability Assistance');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','030-07','Family');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','030-08','No source of income');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','030-09','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','030-10','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','031-01','Employment');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','031-02','Employment insurance');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','031-03','Pension');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','031-04','ODSP');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','031-05','Social Assistance');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','031-06','Disability Assistance');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','031-07','Family');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','031-08','No source of income');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','031-09','Other');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','031-10','Unknown or Service Recipient Declined');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','032-01','Service Recipient Satisfaction');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','032-02','Service Recipient Family Satisfaction');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','032-03','Quality Improvement');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','032-04','Accreditation');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','036-01','Service Recipients in multiple functions');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','036-02','Baseline status not tracked');
insert into CdsFormOption (cdsFormVersion,cdsDataCategory,cdsDataCategoryName) values ('4','036-03','Multiple diagnosis');

create table CdsClientForm
(
	id int primary key auto_increment,
	cdsFormVersion varchar(16) not null,
	index(cdsFormVersion),
	providerNo varchar(6) not null,
	signed tinyint not null,
	index(signed),
	created datetime not null,
	facilityId int not null,
	clientId int not null,
	index(facilityId, clientId),
	admissionId int not null,
	index(admissionId),
	clientAge int,
	index(clientAge)
);

create table CdsClientFormData
(
	id int primary key auto_increment,
	cdsClientFormId int not null,
	index(cdsClientFormId),
	question varchar(64) not null,
	index(question),
	answer varchar(16) not null
);

alter table CdsClientForm change admissionId admissionId int;

ALTER TABLE drugs ADD COLUMN special_instruction TEXT DEFAULT NULL AFTER special;

create table IntegratorControl (
	id int primary key auto_increment,
	facilityId int not null, foreign key (facilityId) references Facility(id),
	control varchar(80),
	execute boolean);

alter table drugs add custom_note tinyint(1) after unitName;
delete from msgDemoMap where demographic_no = 0;

alter table eform add column patient_independent boolean;
alter table eform_data add column patient_independent boolean;



