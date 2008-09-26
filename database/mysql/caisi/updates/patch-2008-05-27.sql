alter table IntegratorConsent add provider_no varchar(6) not null after consentLevel;

alter table provider engine=InnoDB;
alter table IntegratorConsent add foreign key (provider_no) references provider(provider_no);
