alter table EmployeeDeduction alter column Rate decimal(18,6);
alter table PayCheckDeduction alter column Rate decimal(18,6);
alter table CompanyDeduction add Mode int not null default(1);
alter table PayCheckDeduction add Mode int not null default(1);