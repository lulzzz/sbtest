IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'ForcePayCheck')
Alter table PayrollPayCheck Add ForcePayCheck bit;
Alter table PayrollPayCheck alter column WCAmount decimal(18,2) not null;
Go