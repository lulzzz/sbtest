Alter Table Company Add LastPayrollDate DateTime;
Go
Alter Table Employee Add LastPayrollDate DateTime;
Go;
Alter table CompanyAccumulatedPayType Alter Column RatePerHour decimal(18,4) not null;
Go;
Update AccountTemplate set TaxCode='MOE' where Id=24;
Update AccountTemplate set TaxCode='ETT' where Id=37;
Update AccountTemplate set TaxCode='SUI' where Id=38;
Update AccountTemplate set TaxCode='FUTA' where Id=39;
Update AccountTemplate set TaxCode='MD_Employer' where Id=40;
Update AccountTemplate set TaxCode='SS_Employer' where Id=41;
Update AccountTemplate set TaxCode='PTOther' where Id=42;
Update AccountTemplate set TaxCode='SIT' where Id=43;
Update AccountTemplate set TaxCode='SDI' where Id=44;
Update AccountTemplate set TaxCode='FIT' where Id=45;
Update AccountTemplate set TaxCode='MD_Employee' where Id=46;
Update AccountTemplate set TaxCode='PAYROLL_EXPENSES' where Id=47;
Update AccountTemplate set TaxCode='SS_Employee' where Id=48;
Update AccountTemplate set TaxCode='ED' where Id=49;
Update AccountTemplate set TaxCode='PWOther' where Id=50;
Update AccountTemplate set TaxCode='TP' where Id=72;
Update AccountTemplate set TaxCode='PD' where Id=74;

Update CompanyAccount set TaxCode=(select TaxCode from AccountTemplate Where Id=TemplateId);
Go;

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollDetail_Payroll]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]'))
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [FK_PayrollDetail_Payroll]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [FK_Journal_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_EntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [FK_Journal_EntityType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_CompanyAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [FK_Journal_CompanyAccount]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [FK_Journal_Company]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF_PayrollPayCheck_LastModified]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollDetail_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF_PayrollDetail_IsVoid]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_YTDSalary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF_PayrollPayCheck_YTDSalary]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_Salary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF_PayrollPayCheck_Salary]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Payroll_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] DROP CONSTRAINT [DF_Payroll_LastModified]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Journal_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [DF_Journal_LastModified]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Journal_TransactionDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [DF_Journal_TransactionDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Journal_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [DF_Journal_IsVoid]
END

GO
/****** Object:  Table [dbo].[PayrollPayCheck]    Script Date: 24/08/2016 12:31:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND type in (N'U'))
DROP TABLE [dbo].[PayrollPayCheck]
GO
/****** Object:  Table [dbo].[Payroll]    Script Date: 24/08/2016 12:31:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND type in (N'U'))
DROP TABLE [dbo].[Payroll]
GO
/****** Object:  Table [dbo].[Journal]    Script Date: 24/08/2016 12:31:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND type in (N'U'))
DROP TABLE [dbo].[Journal]
GO
/****** Object:  Table [dbo].[Journal]    Script Date: 24/08/2016 12:31:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Journal](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[PaymentMethod] [int] NOT NULL,
	[CheckNumber] [int] NOT NULL,
	[PayrollPayCheckId] [int] NULL,
	[EntityType] [int] NOT NULL,
	[PayeeId] [uniqueidentifier] NOT NULL,
	[PayeeName] [varchar](max) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Memo] [varchar](max) NULL,
	[IsDebit] [bit] NOT NULL,
	[IsVoid] [bit] NOT NULL,
	[MainAccountId] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[JournalDetails] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Journal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payroll]    Script Date: 24/08/2016 12:31:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payroll](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[PayDay] [datetime] NOT NULL,
	[StartingCheckNumber] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Company] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Payroll] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PayrollPayCheck]    Script Date: 24/08/2016 12:31:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayrollPayCheck](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[Employee] [varchar](max) NOT NULL,
	[GrossWage] [decimal](18, 2) NOT NULL,
	[NetWage] [decimal](18, 2) NOT NULL,
	[WCAmount] [decimal](18, 0) NOT NULL,
	[Compensations] [varchar](max) NOT NULL,
	[Deductions] [varchar](max) NOT NULL,
	[Taxes] [varchar](max) NOT NULL,
	[Accumulations] [varchar](max) NOT NULL,
	[Salary] [decimal](18, 2) NOT NULL,
	[YTDSalary] [decimal](18, 2) NOT NULL,
	[PayCodes] [varchar](max) NOT NULL,
	[DeductionAmount] [decimal](18, 2) NOT NULL,
	[EmployeeTaxes] [decimal](18, 2) NOT NULL,
	[EmployerTaxes] [decimal](18, 2) NOT NULL,
	[Status] [int] NOT NULL,
	[IsVoid] [bit] NOT NULL,
	[PayrmentMethod] [int] NOT NULL,
	[PrintStatus] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[PayDay] [datetime] NOT NULL,
	[CheckNumber] [int] NOT NULL,
	[PaymentMethod] [int] NOT NULL,
	[Notes] [varchar](max) NOT NULL,
	[YTDGrossWage] [decimal](18, 2) NOT NULL,
	[YTDNetWage] [decimal](18, 2) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_PayrollDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Journal_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_IsVoid]  DEFAULT ((0)) FOR [IsVoid]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Journal_TransactionDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_TransactionDate]  DEFAULT (getdate()) FOR [TransactionDate]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Journal_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Payroll_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] ADD  CONSTRAINT [DF_Payroll_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_Salary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  CONSTRAINT [DF_PayrollPayCheck_Salary]  DEFAULT ((0)) FOR [Salary]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_YTDSalary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  CONSTRAINT [DF_PayrollPayCheck_YTDSalary]  DEFAULT ((0)) FOR [YTDSalary]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollDetail_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  CONSTRAINT [DF_PayrollDetail_IsVoid]  DEFAULT ((0)) FOR [IsVoid]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  CONSTRAINT [DF_PayrollPayCheck_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal]  WITH CHECK ADD  CONSTRAINT [FK_Journal_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal] CHECK CONSTRAINT [FK_Journal_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_CompanyAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal]  WITH CHECK ADD  CONSTRAINT [FK_Journal_CompanyAccount] FOREIGN KEY([MainAccountId])
REFERENCES [dbo].[CompanyAccount] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_CompanyAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal] CHECK CONSTRAINT [FK_Journal_CompanyAccount]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_EntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal]  WITH CHECK ADD  CONSTRAINT [FK_Journal_EntityType] FOREIGN KEY([EntityType])
REFERENCES [dbo].[EntityType] ([EntityTypeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_EntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal] CHECK CONSTRAINT [FK_Journal_EntityType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal]  WITH CHECK ADD  CONSTRAINT [FK_Journal_PayrollPayCheck] FOREIGN KEY([PayrollPayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal] CHECK CONSTRAINT [FK_Journal_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollDetail_Payroll]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]'))
ALTER TABLE [dbo].[PayrollPayCheck]  WITH CHECK ADD  CONSTRAINT [FK_PayrollDetail_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollDetail_Payroll]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]'))
ALTER TABLE [dbo].[PayrollPayCheck] CHECK CONSTRAINT [FK_PayrollDetail_Payroll]
GO
/****** Object:  Table [dbo].[CompanyPayrollCube]    Script Date: 24/08/2016 8:58:03 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayrollCube]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyPayrollCube]
GO
/****** Object:  Table [dbo].[CompanyPayrollCube]    Script Date: 24/08/2016 8:58:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayrollCube]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyPayrollCube](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[Year] [int] NOT NULL,
	[Quarter] [int] NULL,
	[Month] [int] NULL,
	[Accumulation] [varchar](max) NOT NULL,
 CONSTRAINT [PK_CompanyPayrollCube] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
