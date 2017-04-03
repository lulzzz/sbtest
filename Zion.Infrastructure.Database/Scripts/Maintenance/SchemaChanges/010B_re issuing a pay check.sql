IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'IsReIssued')
Alter table PayrollPayCheck Add IsReIssued bit not null Default(0), OriginalCheckNumber int, ReIssuedDate datetime;
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Journal'
                 AND COLUMN_NAME = 'IsReIssued')
Alter table Journal Add IsReIssued bit not null Default(0), OriginalCheckNumber int, ReIssuedDate datetime;

Go

update payrollpaycheck set OriginalCheckNumber=CheckNumber;
update journal set OriginalCheckNumber=CheckNumber;