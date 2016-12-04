IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'Created')
Alter table Company Add Created datetime not null Default(getdate());
Go;

update Company set Created='1/1/2016';

update a set Created=b.Created1
from company a,
(select id, Created, (select min(datecreated) from Common.Memento where SourceTypeId=2 and MementoId=company.Id) Created1 from
Company
)b
where a.Id=b.Id
and b.created1 is not null;

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'VendorCustomer'
                 AND COLUMN_NAME = 'IsTaxDepartment')
Alter table VendorCustomer Add IsAgency bit not null Default(0), IsTaxDepartment bit not null Default(0);
Go;

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'EmployeeDeduction'
                 AND COLUMN_NAME = 'AgencyId')
Alter table EmployeeDeduction Add CeilingPerCheck decimal(18,2), AccountNo varchar(max), AgencyId uniqueidentifier, Limit decimal(18,2), [Priority] int;
Go;

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'NetPay')
alter table PayrollInvoice Add NetPay decimal(18,2) not null Default(0), CheckPay decimal(18,2) not null Default(0), DDPay decimal(18,2) not null Default(0);
Go

