IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TaxYearRate_Tax]') AND parent_object_id = OBJECT_ID(N'[dbo].[TaxYearRate]'))
ALTER TABLE [dbo].[TaxYearRate] DROP CONSTRAINT [FK_TaxYearRate_Tax]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyWorkerCompensation_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyWorkerCompensation]'))
ALTER TABLE [dbo].[CompanyWorkerCompensation] DROP CONSTRAINT [FK_CompanyWorkerCompensation_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyTaxState_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyTaxState]'))
ALTER TABLE [dbo].[CompanyTaxState] DROP CONSTRAINT [FK_CompanyTaxState_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyTax_Tax]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyTaxRate]'))
ALTER TABLE [dbo].[CompanyTaxRate] DROP CONSTRAINT [FK_CompanyTax_Tax]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyTax_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyTaxRate]'))
ALTER TABLE [dbo].[CompanyTaxRate] DROP CONSTRAINT [FK_CompanyTax_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyPayCode_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyPayCode]'))
ALTER TABLE [dbo].[CompanyPayCode] DROP CONSTRAINT [FK_CompanyPayCode_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyDeduction_DeductionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyDeduction]'))
ALTER TABLE [dbo].[CompanyDeduction] DROP CONSTRAINT [FK_CompanyDeduction_DeductionType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyDeduction_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyDeduction]'))
ALTER TABLE [dbo].[CompanyDeduction] DROP CONSTRAINT [FK_CompanyDeduction_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyContract_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyContract]'))
ALTER TABLE [dbo].[CompanyContract] DROP CONSTRAINT [FK_CompanyContract_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccumlatedPayType_PayType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccumlatedPayType]'))
ALTER TABLE [dbo].[CompanyAccumlatedPayType] DROP CONSTRAINT [FK_CompanyAccumlatedPayType_PayType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccumlatedPayType_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccumlatedPayType]'))
ALTER TABLE [dbo].[CompanyAccumlatedPayType] DROP CONSTRAINT [FK_CompanyAccumlatedPayType_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Company_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[Company]'))
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [FK_Company_Status]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Company_Host]') AND parent_object_id = OBJECT_ID(N'[dbo].[Company]'))
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [FK_Company_Host]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Tax_IsCompanySpecific]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Tax] DROP CONSTRAINT [DF_Tax_IsCompanySpecific]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayType_IsAccumlable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayType] DROP CONSTRAINT [DF_PayType_IsAccumlable]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayType_IsTaxable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayType] DROP CONSTRAINT [DF_PayType_IsTaxable]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyWorkerCompensation_Code]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyWorkerCompensation] DROP CONSTRAINT [DF_CompanyWorkerCompensation_Code]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyContract_InvoiceRate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyContract] DROP CONSTRAINT [DF_CompanyContract_InvoiceRate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyAccumlatedPayType_AnnualLimit]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyAccumlatedPayType] DROP CONSTRAINT [DF_CompanyAccumlatedPayType_AnnualLimit]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyAccumlatedPayType_RatePerHour]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyAccumlatedPayType] DROP CONSTRAINT [DF_CompanyAccumlatedPayType_RatePerHour]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_LastModified]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_ManageEFileForms]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_ManageEFileForms]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_ManageTaxPayment]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_ManageTaxPayment]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_IsAddressSame]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_IsAddressSame]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_InsuranceGroupNo]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_InsuranceGroupNo]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_PayrollDaysInPast]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_PayrollDaysInPast]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_DirectDebitPayer]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_DirectDebitPayer]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_FileUnderHost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_FileUnderHost]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_IsVisibleToHost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] DROP CONSTRAINT [DF_Company_IsVisibleToHost]
END

GO
/****** Object:  Table [dbo].[TaxYearRate]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaxYearRate]') AND type in (N'U'))
DROP TABLE [dbo].[TaxYearRate]
GO
/****** Object:  Table [dbo].[Tax]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tax]') AND type in (N'U'))
DROP TABLE [dbo].[Tax]
GO
/****** Object:  Table [dbo].[PayType]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayType]') AND type in (N'U'))
DROP TABLE [dbo].[PayType]
GO
/****** Object:  Table [dbo].[DeductionType]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeductionType]') AND type in (N'U'))
DROP TABLE [dbo].[DeductionType]
GO
/****** Object:  Table [dbo].[CompanyWorkerCompensation]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyWorkerCompensation]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyWorkerCompensation]
GO
/****** Object:  Table [dbo].[CompanyTaxState]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyTaxState]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyTaxState]
GO
/****** Object:  Table [dbo].[CompanyTaxRate]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyTaxRate]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyTaxRate]
GO
/****** Object:  Table [dbo].[CompanyPayCode]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayCode]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyPayCode]
GO
/****** Object:  Table [dbo].[CompanyDeduction]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyDeduction]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyDeduction]
GO
/****** Object:  Table [dbo].[CompanyContract]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyContract]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyContract]
GO
/****** Object:  Table [dbo].[CompanyAccumlatedPayType]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyAccumlatedPayType]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyAccumlatedPayType]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 23/07/2016 11:51:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Company]') AND type in (N'U'))
DROP TABLE [dbo].[Company]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Company]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Company](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyName] [varchar](max) NOT NULL,
	[CompanyNo] [varchar](max) NOT NULL,
	[HostId] [uniqueidentifier] NOT NULL,
	[StatusId] [int] NOT NULL,
	[IsVisibleToHost] [bit] NOT NULL,
	[FileUnderHost] [bit] NOT NULL,
	[DirectDebitPayer] [bit] NOT NULL,
	[PayrollDaysInPast] [int] NOT NULL,
	[InsuranceGroupNo] [int] NOT NULL,
	[TaxFilingName] [varchar](max) NOT NULL,
	[CompanyAddress] [varchar](max) NOT NULL,
	[BusinessAddress] [varchar](max) NOT NULL,
	[IsAddressSame] [bit] NOT NULL,
	[ManageTaxPayment] [bit] NOT NULL,
	[ManageEFileForms] [bit] NOT NULL,
	[FederalEIN] [varchar](max) NOT NULL,
	[FederalPin] [varchar](max) NOT NULL,
	[DepositSchedule941] [int] NOT NULL,
	[PayrollSchedule] [int] NOT NULL,
	[PayCheckStock] [int] NOT NULL,
	[IsFiler944] [bit] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyAccumlatedPayType]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyAccumlatedPayType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyAccumlatedPayType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayTypeId] [int] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[RatePerHour] [decimal](18, 2) NOT NULL,
	[AnnualLimit] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_CompanyAccumlatedPayType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CompanyContract]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyContract]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyContract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[Type] [int] NOT NULL,
	[PrePaidSubscriptionType] [int] NULL,
	[BillingType] [int] NOT NULL,
	[CardDetails] [varchar](max) NULL,
	[BankDetails] [varchar](max) NULL,
	[InvoiceRate] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_CompanyContract] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyDeduction]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyDeduction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyDeduction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[TypeId] [int] NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[Description] [varchar](max) NULL,
	[AnnualMax] [decimal](18, 2) NULL,
 CONSTRAINT [PK_CompanyDeduction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyPayCode]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyPayCode](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[Code] [varchar](max) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[HourlyRate] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_CompanyPayCode] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyTaxRate]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyTaxRate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyTaxRate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[TaxId] [int] NOT NULL,
	[TaxYear] [int] NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_CompanyTax] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CompanyTaxState]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyTaxState]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyTaxState](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CountryId] [int] NOT NULL,
	[StateId] [int] NOT NULL,
	[StateCode] [varchar](max) NOT NULL,
	[StateName] [varchar](max) NOT NULL,
	[EIN] [varchar](max) NOT NULL,
	[Pin] [varchar](max) NOT NULL,
 CONSTRAINT [PK_CompanyTaxState] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyWorkerCompensation]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyWorkerCompensation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyWorkerCompensation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[Code] [int] NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_CompanyWorkerCompensation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DeductionType]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeductionType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DeductionType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[Category] [int] NOT NULL,
	[W2_12] [varchar](max) NULL,
	[W2_13R] [varchar](max) NULL,
	[R940_R] [varchar](max) NULL,
 CONSTRAINT [PK_DeductionType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PayType]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[IsTaxable] [bit] NOT NULL,
	[IsAccumulable] [bit] NOT NULL,
 CONSTRAINT [PK_PayType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tax]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tax]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Tax](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](max) NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[CountryId] [int] NOT NULL,
	[StateId] [int] NULL,
	[IsCompanySpecific] [bit] NOT NULL,
	[DefaultRate] [decimal](18, 2) NULL,
	[PaidBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Tax] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TaxYearRate]    Script Date: 23/07/2016 11:51:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaxYearRate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TaxYearRate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TaxId] [int] NOT NULL,
	[TaxYear] [int] NOT NULL,
	[Rate] [decimal](18, 2) NULL,
	[AnnualMaxPerEmployee] [decimal](18, 2) NULL,
	[TaxRateLimit] [decimal](18, 2) NULL,
 CONSTRAINT [PK_TaxYearRate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_IsVisibleToHost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_IsVisibleToHost]  DEFAULT ((1)) FOR [IsVisibleToHost]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_FileUnderHost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_FileUnderHost]  DEFAULT ((0)) FOR [FileUnderHost]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_DirectDebitPayer]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_DirectDebitPayer]  DEFAULT ((0)) FOR [DirectDebitPayer]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_PayrollDaysInPast]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_PayrollDaysInPast]  DEFAULT ((0)) FOR [PayrollDaysInPast]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_InsuranceGroupNo]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_InsuranceGroupNo]  DEFAULT ((0)) FOR [InsuranceGroupNo]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_IsAddressSame]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_IsAddressSame]  DEFAULT ((1)) FOR [IsAddressSame]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_ManageTaxPayment]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_ManageTaxPayment]  DEFAULT ((1)) FOR [ManageTaxPayment]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_ManageEFileForms]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_ManageEFileForms]  DEFAULT ((1)) FOR [ManageEFileForms]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Company_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyAccumlatedPayType_RatePerHour]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyAccumlatedPayType] ADD  CONSTRAINT [DF_CompanyAccumlatedPayType_RatePerHour]  DEFAULT ((0)) FOR [RatePerHour]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyAccumlatedPayType_AnnualLimit]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyAccumlatedPayType] ADD  CONSTRAINT [DF_CompanyAccumlatedPayType_AnnualLimit]  DEFAULT ((0)) FOR [AnnualLimit]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyContract_InvoiceRate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyContract] ADD  CONSTRAINT [DF_CompanyContract_InvoiceRate]  DEFAULT ((0)) FOR [InvoiceRate]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CompanyWorkerCompensation_Code]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyWorkerCompensation] ADD  CONSTRAINT [DF_CompanyWorkerCompensation_Code]  DEFAULT ((0)) FOR [Code]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayType_IsTaxable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayType] ADD  CONSTRAINT [DF_PayType_IsTaxable]  DEFAULT ((1)) FOR [IsTaxable]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PayType_IsAccumlable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayType] ADD  CONSTRAINT [DF_PayType_IsAccumlable]  DEFAULT ((0)) FOR [IsAccumulable]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Tax_IsCompanySpecific]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Tax] ADD  CONSTRAINT [DF_Tax_IsCompanySpecific]  DEFAULT ((0)) FOR [IsCompanySpecific]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Company_Host]') AND parent_object_id = OBJECT_ID(N'[dbo].[Company]'))
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_Host] FOREIGN KEY([HostId])
REFERENCES [dbo].[Host] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Company_Host]') AND parent_object_id = OBJECT_ID(N'[dbo].[Company]'))
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_Company_Host]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Company_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[Company]'))
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([StatusId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Company_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[Company]'))
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_Company_Status]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccumlatedPayType_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccumlatedPayType]'))
ALTER TABLE [dbo].[CompanyAccumlatedPayType]  WITH CHECK ADD  CONSTRAINT [FK_CompanyAccumlatedPayType_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccumlatedPayType_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccumlatedPayType]'))
ALTER TABLE [dbo].[CompanyAccumlatedPayType] CHECK CONSTRAINT [FK_CompanyAccumlatedPayType_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccumlatedPayType_PayType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccumlatedPayType]'))
ALTER TABLE [dbo].[CompanyAccumlatedPayType]  WITH CHECK ADD  CONSTRAINT [FK_CompanyAccumlatedPayType_PayType] FOREIGN KEY([PayTypeId])
REFERENCES [dbo].[PayType] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyAccumlatedPayType_PayType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyAccumlatedPayType]'))
ALTER TABLE [dbo].[CompanyAccumlatedPayType] CHECK CONSTRAINT [FK_CompanyAccumlatedPayType_PayType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyContract_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyContract]'))
ALTER TABLE [dbo].[CompanyContract]  WITH CHECK ADD  CONSTRAINT [FK_CompanyContract_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyContract_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyContract]'))
ALTER TABLE [dbo].[CompanyContract] CHECK CONSTRAINT [FK_CompanyContract_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyDeduction_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyDeduction]'))
ALTER TABLE [dbo].[CompanyDeduction]  WITH CHECK ADD  CONSTRAINT [FK_CompanyDeduction_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyDeduction_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyDeduction]'))
ALTER TABLE [dbo].[CompanyDeduction] CHECK CONSTRAINT [FK_CompanyDeduction_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyDeduction_DeductionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyDeduction]'))
ALTER TABLE [dbo].[CompanyDeduction]  WITH CHECK ADD  CONSTRAINT [FK_CompanyDeduction_DeductionType] FOREIGN KEY([TypeId])
REFERENCES [dbo].[DeductionType] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyDeduction_DeductionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyDeduction]'))
ALTER TABLE [dbo].[CompanyDeduction] CHECK CONSTRAINT [FK_CompanyDeduction_DeductionType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyPayCode_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyPayCode]'))
ALTER TABLE [dbo].[CompanyPayCode]  WITH CHECK ADD  CONSTRAINT [FK_CompanyPayCode_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyPayCode_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyPayCode]'))
ALTER TABLE [dbo].[CompanyPayCode] CHECK CONSTRAINT [FK_CompanyPayCode_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyTax_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyTaxRate]'))
ALTER TABLE [dbo].[CompanyTaxRate]  WITH CHECK ADD  CONSTRAINT [FK_CompanyTax_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyTax_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyTaxRate]'))
ALTER TABLE [dbo].[CompanyTaxRate] CHECK CONSTRAINT [FK_CompanyTax_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyTax_Tax]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyTaxRate]'))
ALTER TABLE [dbo].[CompanyTaxRate]  WITH CHECK ADD  CONSTRAINT [FK_CompanyTax_Tax] FOREIGN KEY([TaxId])
REFERENCES [dbo].[Tax] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyTax_Tax]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyTaxRate]'))
ALTER TABLE [dbo].[CompanyTaxRate] CHECK CONSTRAINT [FK_CompanyTax_Tax]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyTaxState_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyTaxState]'))
ALTER TABLE [dbo].[CompanyTaxState]  WITH CHECK ADD  CONSTRAINT [FK_CompanyTaxState_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyTaxState_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyTaxState]'))
ALTER TABLE [dbo].[CompanyTaxState] CHECK CONSTRAINT [FK_CompanyTaxState_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyWorkerCompensation_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyWorkerCompensation]'))
ALTER TABLE [dbo].[CompanyWorkerCompensation]  WITH CHECK ADD  CONSTRAINT [FK_CompanyWorkerCompensation_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyWorkerCompensation_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyWorkerCompensation]'))
ALTER TABLE [dbo].[CompanyWorkerCompensation] CHECK CONSTRAINT [FK_CompanyWorkerCompensation_Company]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TaxYearRate_Tax]') AND parent_object_id = OBJECT_ID(N'[dbo].[TaxYearRate]'))
ALTER TABLE [dbo].[TaxYearRate]  WITH CHECK ADD  CONSTRAINT [FK_TaxYearRate_Tax] FOREIGN KEY([TaxId])
REFERENCES [dbo].[Tax] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TaxYearRate_Tax]') AND parent_object_id = OBJECT_ID(N'[dbo].[TaxYearRate]'))
ALTER TABLE [dbo].[TaxYearRate] CHECK CONSTRAINT [FK_TaxYearRate_Tax]
GO


SET IDENTITY_INSERT [dbo].[Tax] ON 

GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (1, N'FIT', N'Federal Income Tax', 1, NULL, 0, NULL, N'Employee')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (2, N'MD_Employee', N'Medicare Employee', 1, NULL, 0, NULL, N'Employee')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (3, N'MD_Employer', N'Medicare Employer', 1, NULL, 0, NULL, N'Employer')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (4, N'SS_Employee', N'Social Security Employee', 1, NULL, 0, NULL, N'Employee')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (5, N'SS_Employer', N'Social Security Employer', 1, NULL, 0, NULL, N'Employer')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (6, N'FUTA', N'Federal Unemployment Tax', 1, NULL, 0, NULL, N'Employer')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (7, N'SIT', N'State Income Tax', 1, 1, 0, NULL, N'Employee')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (8, N'SDI', N'State Disability Insurance', 1, 1, 0, NULL, N'Employee')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (9, N'ETT', N'Employee Training Tax', 1, 1, 1, CAST(0.10 AS Decimal(18, 2)), N'Employer')
GO
INSERT [dbo].[Tax] ([Id], [Code], [Name], [CountryId], [StateId], [IsCompanySpecific], [DefaultRate], [PaidBy]) VALUES (10, N'SUI', N'State Unemployment Insurance', 1, 1, 1, CAST(3.40 AS Decimal(18, 2)), N'Employer')
GO
SET IDENTITY_INSERT [dbo].[Tax] OFF
GO
SET IDENTITY_INSERT [dbo].[TaxYearRate] ON 

GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (1, 1, 2016, NULL, NULL, NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (2, 2, 2016, CAST(1.45 AS Decimal(18, 2)), NULL, NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (3, 3, 2016, CAST(1.45 AS Decimal(18, 2)), NULL, NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (4, 4, 2016, CAST(6.20 AS Decimal(18, 2)), CAST(118500.00 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (5, 5, 2016, CAST(6.20 AS Decimal(18, 2)), CAST(118500.00 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (6, 6, 2016, CAST(2.40 AS Decimal(18, 2)), CAST(7000.00 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (7, 7, 2016, NULL, NULL, NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (8, 8, 2016, CAST(0.90 AS Decimal(18, 2)), CAST(106742.00 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (9, 9, 2016, CAST(0.10 AS Decimal(18, 2)), CAST(7000.00 AS Decimal(18, 2)), NULL)
GO
INSERT [dbo].[TaxYearRate] ([Id], [TaxId], [TaxYear], [Rate], [AnnualMaxPerEmployee], [TaxRateLimit]) VALUES (10, 10, 2016, CAST(3.40 AS Decimal(18, 2)), CAST(7000.00 AS Decimal(18, 2)), CAST(6.20 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[TaxYearRate] OFF
GO
SET IDENTITY_INSERT [dbo].[DeductionType] ON 

GO
INSERT [dbo].[DeductionType] ([Id], [Name], [Category], [W2_12], [W2_13R], [R940_R]) VALUES (1, N'Taxable Health', 1, NULL, NULL, NULL)
GO
INSERT [dbo].[DeductionType] ([Id], [Name], [Category], [W2_12], [W2_13R], [R940_R]) VALUES (2, N'Taxable Life Insurance', 1, NULL, NULL, NULL)
GO
INSERT [dbo].[DeductionType] ([Id], [Name], [Category], [W2_12], [W2_13R], [R940_R]) VALUES (3, N'Wage Garnishment', 2, NULL, NULL, NULL)
GO
INSERT [dbo].[DeductionType] ([Id], [Name], [Category], [W2_12], [W2_13R], [R940_R]) VALUES (4, N'Wage Advance Repay', 2, NULL, NULL, NULL)
GO
INSERT [dbo].[DeductionType] ([Id], [Name], [Category], [W2_12], [W2_13R], [R940_R]) VALUES (5, N'Others', 2, NULL, NULL, NULL)
GO
INSERT [dbo].[DeductionType] ([Id], [Name], [Category], [W2_12], [W2_13R], [R940_R]) VALUES (6, N'401K', 3, N'D', N'1', NULL)
GO
INSERT [dbo].[DeductionType] ([Id], [Name], [Category], [W2_12], [W2_13R], [R940_R]) VALUES (7, N'408P', 3, N'S', N'1', NULL)
GO
INSERT [dbo].[DeductionType] ([Id], [Name], [Category], [W2_12], [W2_13R], [R940_R]) VALUES (8, N'S-Corp Officer Health', 3, N'DD', N'0', N'4a')
GO
INSERT [dbo].[DeductionType] ([Id], [Name], [Category], [W2_12], [W2_13R], [R940_R]) VALUES (9, N'125C Cafeteria Plan', 4, N'W', N'0', N'4a')
GO
SET IDENTITY_INSERT [dbo].[DeductionType] OFF
GO
SET IDENTITY_INSERT [dbo].[PayType] ON 

GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (1, N'Bonus', N'Bonus Pay', 1, 0)
GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (2, N'Commission', N'Commission Pay', 1, 0)
GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (3, N'Tip', N'Tip Pay', 1, 0)
GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (4, N'Other', N'Other Pay', 1, 0)
GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (5, N'Paid Vacation', N'Paid Vacation', 1, 0)
GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (6, N'Paid Sick Time', N'Paid Sick Time', 1, 1)
GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (7, N'Paid Holiday', N'Paid Holiday', 1, 0)
GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (8, N'Benefit Allowance', N'Allowance, Benefit', 1, 0)
GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (9, N'Other Allowance', N'Allowance, Other', 1, 0)
GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (10, N'NonTax Reimburse', N'NonTax Reimburse', 0, 0)
GO
INSERT [dbo].[PayType] ([Id], [Name], [Description], [IsTaxable], [IsAccumulable]) VALUES (11, N'NonTax Other', N'NonTax Other', 0, 0)
GO
SET IDENTITY_INSERT [dbo].[PayType] OFF
GO
