IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Employee'
                 AND COLUMN_NAME = 'CompanyEmployeeNo')
alter table Employee Add CompanyEmployeeNo int null;