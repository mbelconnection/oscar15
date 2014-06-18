-- Match BN to drugs table

 alter table favorites change BN BN varchar(255);
 alter table favorites change special special text;