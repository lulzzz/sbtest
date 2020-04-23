IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Employee'
                 AND COLUMN_NAME = 'SickLeaveCashPaidHours')
Alter table Employee Add SickLeaveCashPaidHours decimal(18,2) not null default(0);
Go