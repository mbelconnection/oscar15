create table DrugDispensingMapping (
        id int(9) not null auto_increment,
        din varchar(50),
	duration varchar(255),
	durUnit char(1),
	freqCode varchar(6),
	quantity varchar(20),
	takeMin float,
	takeMax float,
        productCode varchar(255),
        dateCreated datetime,
        primary key(id)
);

