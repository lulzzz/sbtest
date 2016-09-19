IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'IsHostCompany')
alter table Company add IsHostCompany bit not null Default(0);

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Host'
                 AND COLUMN_NAME = 'CompanyId')
alter table Host add CompanyId uniqueidentifier;


IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Host'
                 AND COLUMN_NAME = 'PTIN')
alter table Host add PTIN varchar(max);

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Host'
                 AND COLUMN_NAME = 'DesigneeName940941')
alter table Host add DesigneeName940941 varchar(max);

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Host'
                 AND COLUMN_NAME = 'PIN940941')
alter table Host add PIN940941 varchar(max);

Go

ALTER TABLE [dbo].[Host]  WITH CHECK ADD  CONSTRAINT [FK_Host_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO