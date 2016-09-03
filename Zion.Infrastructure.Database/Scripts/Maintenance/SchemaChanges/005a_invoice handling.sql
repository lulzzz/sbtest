IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Invoice_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [DF_Invoice_LastModified]
END

GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 3/09/2016 11:43:54 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoice]') AND type in (N'U'))
DROP TABLE [dbo].[Invoice]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 3/09/2016 11:43:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Invoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Invoice](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[InvoiceMethod] [int] NOT NULL,
	[InvoiceRate] [decimal](18, 2) NOT NULL,
	[InvoiceNumber] [varchar](max) NOT NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[InvoiceValue] [decimal](18, 2) NOT NULL,
	[LineItemTotal] [decimal](18, 2) NOT NULL,
	[Status] [int] NOT NULL,
	[RiskLevel] [int] NOT NULL,
	[LineItems] [varchar](max) NOT NULL,
	[Payments] [varchar](max) NOT NULL,
	[Total] [decimal](18, 2) NULL,
	[Balance] [decimal](18, 2) NOT NULL,
	[SubmittedOn] [datetime] NULL,
	[SubmittedBy] [varchar](max) NULL,
	[DeliveredOn] [datetime] NULL,
	[DeliveredBy] [varchar](max) NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
 CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Invoice_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Invoice] ADD  CONSTRAINT [DF_Invoice_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'InvoiceId')
Alter Table Payroll Add InvoiceId uniqueidentifier;



IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Payroll_Invoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[Payroll]'))
ALTER TABLE [dbo].[Payroll]  WITH CHECK ADD  CONSTRAINT [FK_Payroll_Invoice] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Payroll_Invoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[Payroll]'))
ALTER TABLE [dbo].[Payroll] CHECK CONSTRAINT [FK_Payroll_Invoice]
GO