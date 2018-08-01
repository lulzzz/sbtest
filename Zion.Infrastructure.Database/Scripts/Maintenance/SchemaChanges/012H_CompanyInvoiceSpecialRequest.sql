IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'InvoiceSpecialRequest')
Alter table Payroll add InvoiceSpecialRequest varchar(max);
Go

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'SpecialRequest')
Alter table PayrollInvoice add SpecialRequest varchar(max);
Go