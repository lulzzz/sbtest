IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'ProcessedBy')
Alter table PayrollInvoice Add ProcessedBy varchar(max) not null Default('');
Go