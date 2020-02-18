
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyAccumlatedPayType'
                 AND COLUMN_NAME = 'Name')
Alter table CompanyAccumlatedPayType Add Name varchar(max);
Go
update capt set Name=pt.Name from CompanyAccumlatedPayType capt, PayType pt
where capt.PayTypeId=pt.Id and capt.Name is null;

IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyPayCode'
                 AND COLUMN_NAME = 'TimesFactor')
Alter table CompanyPayCode Drop Column timesfactor;
Go