-- this should not be merged into the trunk, this change is already in the trunk as a different patch

alter table publicKeys change type type varchar(100) not null;