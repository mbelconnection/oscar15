create table DrugDispensingMapping (
        id int(9) not null auto_increment,
        din varchar(50),
        productCode varchar(255),
        dateCreated datetime,
        primary key(id)
);

