IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InvoicePayment_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoicePayment]'))
ALTER TABLE [dbo].[InvoicePayment] DROP CONSTRAINT [FK_InvoicePayment_PayrollInvoice]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_InvoicePayment_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[InvoicePayment] DROP CONSTRAINT [DF_InvoicePayment_LastModified]
END

GO
/****** Object:  Table [dbo].[InvoicePayment]    Script Date: 9/12/2016 5:35:59 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND type in (N'U'))
DROP TABLE [dbo].[InvoicePayment]
GO
/****** Object:  Table [dbo].[InvoicePayment]    Script Date: 9/12/2016 5:35:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InvoicePayment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[Method] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CheckNumber] [int] NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Notes] [varchar](max) NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_InvoicePayment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_InvoicePayment_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[InvoicePayment] ADD  CONSTRAINT [DF_InvoicePayment_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InvoicePayment_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoicePayment]'))
ALTER TABLE [dbo].[InvoicePayment]  WITH CHECK ADD  CONSTRAINT [FK_InvoicePayment_PayrollInvoice] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[PayrollInvoice] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InvoicePayment_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoicePayment]'))
ALTER TABLE [dbo].[InvoicePayment] CHECK CONSTRAINT [FK_InvoicePayment_PayrollInvoice]
GO
