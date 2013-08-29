alter table DrugProduct add amount int not null;
alter table DrugProduct add expiryDate date;
alter table DrugDispensing add programNo integer;

insert into `secObjectName` (`objectName`) values('_rx.dispense');
insert into `secObjPrivilege` values('doctor','_rx.dispense','x',0,'999998');

