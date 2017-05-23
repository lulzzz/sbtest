IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyDeduction'
                 AND COLUMN_NAME = 'ApplyInvoiceCredit')
Alter table CompanyDeduction Add ApplyInvoiceCredit bit not null Default(0);

Go

Update CompanyDeduction set ApplyInvoiceCredit=1 where TypeId=4;