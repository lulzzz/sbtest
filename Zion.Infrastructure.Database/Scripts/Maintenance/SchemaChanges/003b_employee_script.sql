IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [FK_Employee_Status]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [FK_Employee_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_BankAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [FK_Employee_BankAccount]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Employee_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [DF_Employee_LastModified]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Employee_FederalAdditionalAmount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [DF_Employee_FederalAdditionalAmount]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Employee_DirectDebitAuthorized]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [DF_Employee_DirectDebitAuthorized]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Employee_Rate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [DF_Employee_Rate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Employee_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Employee] DROP CONSTRAINT [DF_Employee_Id]
END

GO
/****** Object:  Table [dbo].[Employee]    Script Date: 31/07/2016 1:36:25 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Employee]') AND type in (N'U'))
DROP TABLE [dbo].[Employee]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 31/07/2016 1:36:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Employee]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Employee](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[StatusId] [int] NOT NULL,
	[FirstName] [varchar](max) NOT NULL,
	[LastName] [varchar](max) NOT NULL,
	[MiddleInitial] [varchar](1) NULL,
	[Contact] [varchar](max) NOT NULL,
	[Gender] [int] NOT NULL,
	[SSN] [varchar](max) NOT NULL,
	[BirthDate] [datetime] NOT NULL,
	[HireDate] [datetime] NOT NULL,
	[Department] [varchar](max) NULL,
	[EmployeeNo] [varchar](max) NULL,
	[Memo] [varchar](max) NULL,
	[PayrollSchedule] [int] NOT NULL,
	[PayType] [int] NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
	[PayCodes] [varchar](max) NULL,
	[Compensations] [varchar](max) NULL,
	[PaymentMethod] [int] NOT NULL,
	[BankAccountId] [int] NULL,
	[DirectDebitAuthorized] [bit] NOT NULL,
	[TaxCategory] [int] NOT NULL,
	[FederalStatus] [int] NOT NULL,
	[FederalExemptions] [int] NOT NULL,
	[FederalAdditionalAmount] [decimal](18, 2) NOT NULL,
	[State] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Employee_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_Id]  DEFAULT (newid()) FOR [Id]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Employee_Rate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_Rate]  DEFAULT ((0)) FOR [Rate]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Employee_DirectDebitAuthorized]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_DirectDebitAuthorized]  DEFAULT ((0)) FOR [DirectDebitAuthorized]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Employee_FederalAdditionalAmount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_FederalAdditionalAmount]  DEFAULT ((0)) FOR [FederalAdditionalAmount]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Employee_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_BankAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_BankAccount] FOREIGN KEY([BankAccountId])
REFERENCES [dbo].[BankAccount] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_BankAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_BankAccount]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([StatusId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Status]
GO
