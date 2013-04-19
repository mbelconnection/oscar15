alter table drugs add dispenseInternal tinyint(1);

create table DrugProduct(
	id int(9) NOT NULL auto_increment, 
	name varchar(255),
	code varchar(255),
	lotNumber varchar(255),
	dispensingEvent int(9),
	primary key (id)
);

create table DrugDispensing (
	id int(9) not null auto_increment,
	drugId int(9),
	dateCreated datetime,
	productId int(9),
	quantity int(9),
	unit varchar(20),
	dispensingProviderNo varchar(20),
	providerNo varchar(20),
	paidFor tinyint(1),
	notes text,
	primary key(id)
);
