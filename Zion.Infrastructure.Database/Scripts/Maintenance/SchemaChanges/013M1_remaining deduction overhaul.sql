
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'EmployeeDeduction'
                 AND COLUMN_NAME = 'Note')
Alter table EmployeeDeduction Add Note varchar(max);
Go