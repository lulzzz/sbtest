IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyAccumlatedPayType'
                 AND COLUMN_NAME = 'IsLumpSum')
Alter table CompanyAccumlatedPayType Add IsLumpSum bit not null Default(0);