IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VendorCustomer_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[VendorCustomer]'))
ALTER TABLE [dbo].[VendorCustomer] DROP CONSTRAINT [FK_VendorCustomer_Status]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VendorCustomer_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[VendorCustomer]'))
ALTER TABLE [dbo].[VendorCustomer] DROP CONSTRAINT [FK_VendorCustomer_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccount_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccount]'))
ALTER TABLE [dbo].[CompanyAccount] DROP CONSTRAINT [FK_CompanyAccount_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccount_BankAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccount]'))
ALTER TABLE [dbo].[CompanyAccount] DROP CONSTRAINT [FK_CompanyAccount_BankAccount]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccount_AccountTemplate]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccount]'))
ALTER TABLE [dbo].[CompanyAccount] DROP CONSTRAINT [FK_CompanyAccount_AccountTemplate]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BankAccount_EntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[BankAccount]'))
ALTER TABLE [dbo].[BankAccount] DROP CONSTRAINT [FK_BankAccount_EntityType]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_VendorCustomer_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[VendorCustomer] DROP CONSTRAINT [DF_VendorCustomer_LastModified]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_VendorCustomer_IsVendor1099]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[VendorCustomer] DROP CONSTRAINT [DF_VendorCustomer_IsVendor1099]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_VendorCustomer_IsVendor]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[VendorCustomer] DROP CONSTRAINT [DF_VendorCustomer_IsVendor]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyAccount_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyAccount] DROP CONSTRAINT [DF_CompanyAccount_LastModified]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyAccount_OpeningDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyAccount] DROP CONSTRAINT [DF_CompanyAccount_OpeningDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_BankAccount_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BankAccount] DROP CONSTRAINT [DF_BankAccount_LastModified]
END

GO
/****** Object:  Table [dbo].[VendorCustomer]    Script Date: 28/07/2016 5:12:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VendorCustomer]') AND type in (N'U'))
DROP TABLE [dbo].[VendorCustomer]
GO
/****** Object:  Table [dbo].[CompanyAccount]    Script Date: 28/07/2016 5:12:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyAccount]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyAccount]
GO
/****** Object:  Table [dbo].[BankAccount]    Script Date: 28/07/2016 5:12:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BankAccount]') AND type in (N'U'))
DROP TABLE [dbo].[BankAccount]
GO
/****** Object:  Table [dbo].[AccountTemplate]    Script Date: 28/07/2016 5:12:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountTemplate]') AND type in (N'U'))
DROP TABLE [dbo].[AccountTemplate]
GO
/****** Object:  Table [dbo].[AccountTemplate]    Script Date: 28/07/2016 5:12:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountTemplate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [int] NOT NULL,
	[SubType] [int] NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[TaxCode] [varchar](max) NULL,
 CONSTRAINT [PK_AccountTemplate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BankAccount]    Script Date: 28/07/2016 5:12:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BankAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BankAccount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityTypeId] [int] NOT NULL,
	[EntityId] [uniqueidentifier] NULL,
	[AccountType] [int] NOT NULL,
	[BankName] [varchar](max) NOT NULL,
	[AccountName] [varchar](max) NOT NULL,
	[AccountNumber] [varchar](max) NOT NULL,
	[RoutingNumber] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_BankAccount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyAccount]    Script Date: 28/07/2016 5:12:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyAccount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyAccount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[Type] [int] NOT NULL,
	[SubType] [int] NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[TaxCode] [varchar](max) NULL,
	[TemplateId] [int] NULL,
	[OpeningBalance] [decimal](18, 2) NULL,
	[OpeningDate] [datetime] NOT NULL,
	[BankAccountId] [int] NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_CompanyAccount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VendorCustomer]    Script Date: 28/07/2016 5:12:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VendorCustomer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VendorCustomer](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[StatusId] [int] NOT NULL,
	[AccountNo] [varchar](max) NULL,
	[IsVendor] [bit] NOT NULL,
	[IsVendor1099] [bit] NOT NULL,
	[Contact] [varchar](max) NOT NULL,
	[Note] [varchar](max) NULL,
	[Type1099] [int] NULL,
	[SubType1099] [int] NULL,
	[IdentifierType] [int] NULL,
	[IndividualSSN] [varchar](max) NULL,
	[BusinessFIN] [varchar](max) NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_VendorCustomer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_BankAccount_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BankAccount] ADD  CONSTRAINT [DF_BankAccount_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyAccount_OpeningDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyAccount] ADD  CONSTRAINT [DF_CompanyAccount_OpeningDate]  DEFAULT (getdate()) FOR [OpeningDate]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyAccount_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyAccount] ADD  CONSTRAINT [DF_CompanyAccount_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_VendorCustomer_IsVendor]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[VendorCustomer] ADD  CONSTRAINT [DF_VendorCustomer_IsVendor]  DEFAULT ((1)) FOR [IsVendor]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_VendorCustomer_IsVendor1099]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[VendorCustomer] ADD  CONSTRAINT [DF_VendorCustomer_IsVendor1099]  DEFAULT ((0)) FOR [IsVendor1099]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_VendorCustomer_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[VendorCustomer] ADD  CONSTRAINT [DF_VendorCustomer_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BankAccount_EntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[BankAccount]'))
ALTER TABLE [dbo].[BankAccount]  WITH CHECK ADD  CONSTRAINT [FK_BankAccount_EntityType] FOREIGN KEY([EntityTypeId])
REFERENCES [dbo].[EntityType] ([EntityTypeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BankAccount_EntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[BankAccount]'))
ALTER TABLE [dbo].[BankAccount] CHECK CONSTRAINT [FK_BankAccount_EntityType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccount_AccountTemplate]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccount]'))
ALTER TABLE [dbo].[CompanyAccount]  WITH CHECK ADD  CONSTRAINT [FK_CompanyAccount_AccountTemplate] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[AccountTemplate] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccount_AccountTemplate]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccount]'))
ALTER TABLE [dbo].[CompanyAccount] CHECK CONSTRAINT [FK_CompanyAccount_AccountTemplate]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccount_BankAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccount]'))
ALTER TABLE [dbo].[CompanyAccount]  WITH CHECK ADD  CONSTRAINT [FK_CompanyAccount_BankAccount] FOREIGN KEY([BankAccountId])
REFERENCES [dbo].[BankAccount] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccount_BankAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccount]'))
ALTER TABLE [dbo].[CompanyAccount] CHECK CONSTRAINT [FK_CompanyAccount_BankAccount]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccount_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccount]'))
ALTER TABLE [dbo].[CompanyAccount]  WITH CHECK ADD  CONSTRAINT [FK_CompanyAccount_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccount_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccount]'))
ALTER TABLE [dbo].[CompanyAccount] CHECK CONSTRAINT [FK_CompanyAccount_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VendorCustomer_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[VendorCustomer]'))
ALTER TABLE [dbo].[VendorCustomer]  WITH CHECK ADD  CONSTRAINT [FK_VendorCustomer_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VendorCustomer_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[VendorCustomer]'))
ALTER TABLE [dbo].[VendorCustomer] CHECK CONSTRAINT [FK_VendorCustomer_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VendorCustomer_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[VendorCustomer]'))
ALTER TABLE [dbo].[VendorCustomer]  WITH CHECK ADD  CONSTRAINT [FK_VendorCustomer_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([StatusId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VendorCustomer_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[VendorCustomer]'))
ALTER TABLE [dbo].[VendorCustomer] CHECK CONSTRAINT [FK_VendorCustomer_Status]
GO



Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 1, 'Equipment', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 1, 'Furniture', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 1, 'Accum. Depreciation Equipment', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 1, 'Accum. Depreciation Furniture', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 1, 'Accum. Depreciation Real Estate', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 1, 'Accum. Depreciation Vehicles', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 1, 'Real Estate', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 1, 'Vehicles', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 3, 'Cost of Goods', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 4, 'Pay History', 'Payroll History');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(1, 4, 'Taxes or Bills Payables', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(2, 5, 'Opening Balance', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(2, 6, 'Owner Equity', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(2, 7, 'Retained Earnings', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 8, 'Depreciation-Equipment', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 8, 'Depreciation-Furniture', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 8, 'Depreciation-Vehicles', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 9, 'Insurance-Vehicles', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 9, 'Insurance-Health', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 9, 'Insurance-Liability', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 9, 'Insurance-Property', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 9, 'Insurance-Workers Compensation', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 10, 'Interest', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 11, 'Misc. Office Expense', 'MOE');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 11, 'Office Supplies', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 11, 'Shipping And Postage', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 12, 'Bank', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 12, 'Licenses And Permits', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 12, 'Misc.', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 13, 'Advertisement and Promotion', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 13, 'Auto Expenses - itemized', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 13, 'Industrial and Production Supplies', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 13, 'Contractor and Subcontractor Cost', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 13, 'Charity', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 13, 'Entertainment', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 13, 'Other Expense', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 14, 'CA Employment Training Tax', 'CA_ETT');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 14, 'CA State Unemployment Tax', 'CA_SUI');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 14, 'Federal Unemployment Tax', 'FUTA');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 14, 'Medicare Tax (Employer)', 'MD_ER');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 14, 'Social Security Tax (Employer)', 'SS_ER');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 14, 'Out of State UI Tax', 'PTOther');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 15, 'Employee CA Income Tax', 'CA_SIT');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 15, 'Employee CA SDI', 'CA_SDI');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 15, 'Employee Federal Income Tax', 'FIT');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 15, 'Employee Medicare Tax', 'MD_EE');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 15, 'Employee Net Pay', 'PAYROLL_EXPENSES');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 15, 'Employee Social Security Tax', 'SS_EE');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 15, 'Employee Deductions', 'ED');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 15, 'Employee Out of State Payroll Tax', 'PWOther');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 16, 'Rent And Lease', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 17, 'Accounting', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 17, 'Legal', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 17, 'Misc. Service Fees', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 18, 'Federal Income Tax', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 18, 'Local Income Tax', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 18, 'Local Property Tax', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 18, 'State Tax', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 19, 'Lodging', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 19, 'Meals', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 19, 'Milage Per Diem', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 19, 'Transportation', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 20, 'Electric', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 20, 'Gas', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 20, 'Telephone', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 20, 'Water', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(3, 21, 'Misc. Suspense Expense', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(4, 22, 'Interest', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(4, 23, 'Other Income', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(4, 24, 'Regular Income', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(5, 25, 'Vehicle Loan', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(5, 26, 'Taxes Payable', 'TP');
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(5, 26, 'Unpaid Invoices', null);
Insert into AccountTemplate([Type], SubType, Name, TaxCode) values(5, 26, 'Payroll Deductions', 'PD');









