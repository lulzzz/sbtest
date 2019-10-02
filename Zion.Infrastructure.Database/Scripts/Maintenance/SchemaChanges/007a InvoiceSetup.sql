Alter table company alter column companyno varchar(max) null;
Go
ALTER TABLE [dbo].[Payroll] DROP CONSTRAINT [FK_Payroll_Invoice]
GO
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyContact'
                 AND COLUMN_NAME = 'InvoiceSetup')
Alter table CompanyContract Add InvoiceSetup varchar(max);
Go

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'PEOASOCoCheck')
Alter Table Payroll Add PEOASOCoCheck bit not null Default(0);
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'PEOASOCoCheck')
Alter Table PayrollPayCheck Add PEOASOCoCheck bit not null Default(0);
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Journal'
                 AND COLUMN_NAME = 'PEOASOCoCheck')
Alter Table Journal Add PEOASOCoCheck bit not null Default(0);

Go


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollInvoice_Payroll]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]'))
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [FK_PayrollInvoice_Payroll]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollInvoice_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]'))
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [FK_PayrollInvoice_Company]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollInvoice_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF_PayrollInvoice_LastModified]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollInvoice_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF_PayrollInvoice_Id]
END

GO
/****** Object:  Table [dbo].[PayrollInvoice]    Script Date: 30/09/2016 6:18:05 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND type in (N'U'))
DROP TABLE [dbo].[PayrollInvoice]
GO
/****** Object:  Table [dbo].[PayrollInvoice]    Script Date: 30/09/2016 6:18:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayrollInvoice](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[PayrollId] [uniqueidentifier] NOT NULL,
	[InvoiceNumber] [int] IDENTITY(1,1) NOT NULL,
	[PeriodStart] [datetime] NOT NULL,
	[PeriodEnd] [datetime] NOT NULL,
	[InvoiceSetup] [varchar](max) NOT NULL,
	[GrossWages] [decimal](18, 2) NOT NULL,
	[EmployerTaxes] [varchar](max) NOT NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NOT NULL,
	[NoOfChecks] [int] NOT NULL,
	[Deductions] [varchar](max) NOT NULL,
	[WorkerCompensations] [varchar](max) NOT NULL,
	[EmployeeContribution] [decimal](18, 2) NOT NULL,
	[EmployerContribution] [decimal](18, 2) NOT NULL,
	[AdminFee] [decimal](18, 2) NOT NULL,
	[EnvironmentalFee] [decimal](18, 2) NOT NULL,
	[MiscCharges] [varchar](max) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[Status] [int] NOT NULL,
	[SubmittedOn] [datetime] NULL,
	[SubmittedBy] [varchar](max) NULL,
	[DeliveredOn] [datetime] NULL,
	[DeliveredBy] [varchar](max) NULL,
	[Payrments] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_PayrollInvoice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollInvoice_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF_PayrollInvoice_Id]  DEFAULT (newid()) FOR [Id]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayrollInvoice_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF_PayrollInvoice_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollInvoice_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]'))
ALTER TABLE [dbo].[PayrollInvoice]  WITH CHECK ADD  CONSTRAINT [FK_PayrollInvoice_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollInvoice_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]'))
ALTER TABLE [dbo].[PayrollInvoice] CHECK CONSTRAINT [FK_PayrollInvoice_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollInvoice_Payroll]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]'))
ALTER TABLE [dbo].[PayrollInvoice]  WITH CHECK ADD  CONSTRAINT [FK_PayrollInvoice_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollInvoice_Payroll]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]'))
ALTER TABLE [dbo].[PayrollInvoice] CHECK CONSTRAINT [FK_PayrollInvoice_Payroll]
GO

