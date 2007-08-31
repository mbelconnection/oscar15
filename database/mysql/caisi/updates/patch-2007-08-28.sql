ALTER TABLE agency MODIFY id BIGINT(20) NOT NULL AUTO_INCREMENT FIRST;
ALTER TABLE agency ADD COLUMN disabled tinyint(1) NOT NULL default '0';
create table facility (
     `id` bigint(22) NOT NULL auto_increment,
     `agency_id` bigint(22) NOT NULL,
     `name` varchar(32) NOT NULL default '',
     `description` VARCHAR(70) NOT NULL default '',
     `disabled` tinyint(1) NOT NULL default '0',
     PRIMARY KEY (`id`),
     CONSTRAINT `FK_facility_agency` FOREIGN KEY (`agency_id`) REFERENCES `agency` (`id`),
     UNIQUE KEY `idx_facility_name` USING HASH (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


INSERT INTO facility (agency_id, name, description) VALUES (0, 'Default Facility', 'Default facility, please modify with a more appropriate name and description');

ALTER TABLE room ADD COLUMN facility_id int(10) NOT NULL default 0;
ALTER TABLE room ADD CONSTRAINT `FK_room_facility` FOREIGN KEY (`facility_id`) REFERENCES `facility` (`id`);
ALTER TABLE bed ADD COLUMN facility_id int(10) NOT NULL default 0;
ALTER TABLE bed MODIFY room_id  int(10) unsigned default NULL;



