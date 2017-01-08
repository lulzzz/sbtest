IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'BankAccount'
                 AND COLUMN_NAME = 'FractionId')
alter table BankAccount Add FractionId	varchar(max) null;