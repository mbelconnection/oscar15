 update issue set type = 'icd9' where length(type) = 0 or type is null;
 
 update issue set type = 'system' where code = 'OMeds' or code = 'SocHistory' or code = 'MedHistory' or code = 'Concerns' or code = 'Reminders' or code = 'FamHistory';
