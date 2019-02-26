IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Host'
                 AND COLUMN_NAME = 'HostIntId')
Alter table Host Add HostIntId int not null identity(1,1);
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Employee'
                 AND COLUMN_NAME = 'EmployeeIntId')
Alter table Employee Add EmployeeIntId int not null identity(1,1);
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'VendorCustomer'
                 AND COLUMN_NAME = 'VendorCustomerIntId')
Alter table VendorCustomer Add VendorCustomerIntId int not null identity(1,1);
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'VoidedBy')
Alter table Payroll Add VoidedBy varchar(max);
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'VoidedOn')
Alter table Payroll Add VoidedOn DateTime;
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'VoidedBy')
Alter table PayrollPayCheck Add VoidedBy varchar(max);
Go