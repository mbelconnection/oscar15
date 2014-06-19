ALTER TABLE  formLabReq10 add requesting_physician varchar(6) NOT NULL;

UPDATE formLabReq10 set requesting_physician = provider_no;
