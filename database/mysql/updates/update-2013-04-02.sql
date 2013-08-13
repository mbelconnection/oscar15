--
-- Table structure for table `ExternalDemographic`
--

CREATE TABLE `ExternalDemographic` (
  `externalDemographicId` int(11) NOT NULL AUTO_INCREMENT,
  `demographic_no` int(11),
  `affinityDomain` varchar(255),
  `updateEnabled` tinyint(1),
  `active` tinyint(1),
  `createdUTC` date,
  `lastEnabled` date,
  `lastDisabled` date,
  PRIMARY KEY (`externalDemographicId`)
);

--
-- Table structure for table `PatientDocument`
--

CREATE  TABLE `PatientDocument` (
  `patientDocumentId` INT(11) NOT NULL AUTO_INCREMENT ,
  `demographic_no` INT(11),
  `uniqueDocumentId` VARCHAR(255) ,
  `repositoryUniqueId` VARCHAR(45) ,
  `creationTime` DATETIME ,
  `isDownloaded` TINYINT(1) ,
  `affinityDomain` VARCHAR(255) ,
  `title` VARCHAR(255) ,
  `mimetype` VARCHAR(255) ,
  `author` VARCHAR(255) ,
  PRIMARY KEY (`patientDocumentId`)
);

