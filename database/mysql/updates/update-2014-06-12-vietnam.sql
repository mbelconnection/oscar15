--
-- Add new measurementType
--
insert into measurementType (type,typeDisplayName,typeDescription,validation)
values ("Ucmt","Urine Test comments","Urine Toxicology Test: general comments",
(select id from validations where name="No Validations"));

