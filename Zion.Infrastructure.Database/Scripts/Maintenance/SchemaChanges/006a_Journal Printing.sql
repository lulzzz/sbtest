IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Journal'
                 AND COLUMN_NAME = 'DocumentId')
Alter Table Journal Add DocumentId uniqueidentifier not null Default newid();
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'WorkerCompensation')
Alter table PayrollPayCheck Add WorkerCompensation varchar(max);