Alter Table Employee Alter Column BirthDate datetime;
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyContract'
                 AND COLUMN_NAME = 'Method')
Alter Table CompanyContract Add Method int not null Default(1);
Go