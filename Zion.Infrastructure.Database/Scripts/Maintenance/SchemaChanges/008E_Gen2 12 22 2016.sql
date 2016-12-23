update InsuranceGroup set GroupName='Insurance', GroupNo='No' where Id=0;
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'CompanyNumber')
alter table Company Add CompanyNumber int not null identity(1,1);