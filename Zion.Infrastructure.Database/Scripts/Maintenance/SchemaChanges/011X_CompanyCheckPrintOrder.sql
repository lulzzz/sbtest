IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'CompanyCheckPrintOrder')
Alter table Company add CompanyCheckPrintOrder int not null default(1);
Go