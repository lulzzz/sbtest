IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyRecurringCharge'
                 AND COLUMN_NAME = 'IsPaidInFull')
Alter table CompanyRecurringCharge Add IsPaidInFull bit not null Default(0), Comments varchar(max);

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckCreditInvoiceId')
DROP INDEX [IX_PayrollPayCheckCreditInvoiceId] ON [dbo].[PayrollPayCheck]
GO

/****** Object:  Index [CIX_CompanyPayCheckNumber]    Script Date: 21/11/2018 8:53:33 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayCheckNumber]') AND name = N'CIX_CompanyPayCheckNumber')
DROP INDEX [CIX_CompanyPayCheckNumber] ON [dbo].[CompanyPayCheckNumber] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[CompanyPayCheckNumber]    Script Date: 21/11/2018 8:53:33 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayCheckNumber]'))
DROP VIEW [dbo].[CompanyPayCheckNumber]
GO
/****** Object:  View [dbo].[CompanyPayCheckNumber]    Script Date: 21/11/2018 8:53:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayCheckNumber]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[CompanyPayCheckNumber]
With SchemaBinding 
As
select CompanyIntId, PayrollId, Id, CheckNumber from dbo.PayrollPayCheck where CheckNumber>0;
' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_CompanyPayCheckNumber]    Script Date: 21/11/2018 8:53:33 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayCheckNumber]') AND name = N'CIX_CompanyPayCheckNumber')
CREATE UNIQUE CLUSTERED INDEX [CIX_CompanyPayCheckNumber] ON [dbo].[CompanyPayCheckNumber]
(
	[CompanyIntId] ASC,
	[CheckNumber] DESC,
	[PayrollId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
