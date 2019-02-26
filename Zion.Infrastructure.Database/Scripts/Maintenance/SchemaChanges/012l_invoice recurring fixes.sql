/****** Object:  Table [dbo].[InvoiceRecurringCharge]    Script Date: 23/10/2018 9:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceRecurringCharge](
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[InvoiceNumber] [int] NOT NULL,
	[RecurringChargeId] [int] NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
	[Claimed] [decimal](18, 2) NOT NULL,
	[NewRecurringChargeId] [int]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

alter table companyrecurringcharge alter column claimed decimal(18,2) not null