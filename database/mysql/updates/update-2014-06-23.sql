alter table appointment add `roomid` varchar(50) DEFAULT NULL;
alter table appointmentArchive add `roomid` varchar(50) DEFAULT NULL;

alter table appointment add multiapptid int default 0;
alter table appointmentArchive add multiapptid int default 0;

alter table appointment add `recurrenceid` int DEFAULT 0;
alter table appointmentArchive add `recurrenceid` int DEFAULT 0;

CREATE TABLE  `appt_recurrence` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `frequency` varchar(50) DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
);
