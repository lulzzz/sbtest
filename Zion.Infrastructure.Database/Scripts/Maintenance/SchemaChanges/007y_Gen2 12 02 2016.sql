IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'EmployeeDeduction'
                 AND COLUMN_NAME = 'CeilingMethod')
alter table EmployeeDeduction Add CeilingMethod int not null Default(2);
Go;
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeBankAccount_Employee]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeBankAccount]'))
ALTER TABLE [dbo].[EmployeeBankAccount] DROP CONSTRAINT [FK_EmployeeBankAccount_Employee]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeBankAccount_BankAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeBankAccount]'))
ALTER TABLE [dbo].[EmployeeBankAccount] DROP CONSTRAINT [FK_EmployeeBankAccount_BankAccount]
GO
/****** Object:  Table [dbo].[EmployeeBankAccount]    Script Date: 3/12/2016 11:00:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeBankAccount]') AND type in (N'U'))
DROP TABLE [dbo].[EmployeeBankAccount]
GO
/****** Object:  Table [dbo].[EmployeeBankAccount]    Script Date: 3/12/2016 11:00:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeBankAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeBankAccount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[BankAccountId] [int] NOT NULL,
	[Percentage] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_EmployeeBankAccount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeBankAccount_BankAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeBankAccount]'))
ALTER TABLE [dbo].[EmployeeBankAccount]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeBankAccount_BankAccount] FOREIGN KEY([BankAccountId])
REFERENCES [dbo].[BankAccount] ([Id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeBankAccount_BankAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeBankAccount]'))
ALTER TABLE [dbo].[EmployeeBankAccount] CHECK CONSTRAINT [FK_EmployeeBankAccount_BankAccount]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeBankAccount_Employee]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeBankAccount]'))
ALTER TABLE [dbo].[EmployeeBankAccount]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeBankAccount_Employee] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeBankAccount_Employee]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeBankAccount]'))
ALTER TABLE [dbo].[EmployeeBankAccount] CHECK CONSTRAINT [FK_EmployeeBankAccount_Employee]
GO


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_BankAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [FK_Employee_BankAccount]
GO

IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Employee'
                 AND COLUMN_NAME = 'BankAccountId')
alter table Employee drop column BankAccountId;
Go;
