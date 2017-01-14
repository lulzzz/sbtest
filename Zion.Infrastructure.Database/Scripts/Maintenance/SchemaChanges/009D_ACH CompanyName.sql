IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'ACHTransaction'
                 AND COLUMN_NAME = 'CompanyName')
alter table ACHTransaction add CompanyName varchar(max);

IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'Notes')
alter table Company add Notes varchar(max);

IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Employee'
                 AND COLUMN_NAME = 'Notes')
alter table Employee add Notes varchar(max);

