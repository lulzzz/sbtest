IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyTaxState'
                 AND COLUMN_NAME = 'DepositSchedule')
Alter table CompanyTaxState Add DepositSchedule int Default(2);
Go
update cst set DepositSchedule=c.DepositSchedule941
from CompanyTaxState cst, Company c where cst.CompanyId=c.Id;
if not exists(select 'x' from Tax where StateId=25)
begin
set identity_insert dbo.Tax On
insert into Tax(Id, Code, Name, CountryId, StateId, IsCompanySpecific, DefaultRate, Paidby) values(16, 'MT SIT', 'Montana SIT', 1, 25, 0, NULL, 'Employee');
insert into Tax(Id, Code, Name, CountryId, StateId, IsCompanySpecific, DefaultRate, Paidby) values(17, 'MT AFT', 'Montana AFT', 1, 25, 1, 0.18, 'Employer');
insert into Tax(Id, Code, Name, CountryId, StateId, IsCompanySpecific, DefaultRate, Paidby) values(18, 'MT UI', 'Montana SUI', 1, 25, 1, 2.4, 'Employer');

set identity_insert dbo.Tax Off
insert into TaxYearRate(TaxId, TaxYear, Rate, AnnualMaxPerEmployee, TaxRateLimit, WeeklyMaxWage) values(16, 2020, NULL, NULL, NULL, NULL);
insert into TaxYearRate(TaxId, TaxYear, Rate, AnnualMaxPerEmployee, TaxRateLimit, WeeklyMaxWage) values(17, 2020, 0.18, NULL, NULL, NULL);
insert into TaxYearRate(TaxId, TaxYear, Rate, AnnualMaxPerEmployee, TaxRateLimit, WeeklyMaxWage) values(18, 2020, 2.4, 34100, 6.12, NULL);
end