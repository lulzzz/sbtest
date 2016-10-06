IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'DueDate')
Alter table PayrollInvoice Drop Column DueDate;
Go
IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'ExpiryDate')
Alter table PayrollInvoice Drop Column ExpiryDate;
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'Courier')
Alter table PayrollInvoice Add Courier varchar(max);
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'EmployeeTaxes')
Alter table PayrollInvoice Add EmployeeTaxes varchar(max) not null;
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'Notes')
Alter table PayrollInvoice Add Notes varchar(max);
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyWorkerCompensation'
                 AND COLUMN_NAME = 'MinGrossWage')
Alter table CompanyWorkerCompensation Add MinGrossWage decimal(18,2) ;
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'Notes')
Alter table Payroll Add Notes varchar(max) ;
Go

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Notifications'
                 AND COLUMN_NAME = 'Visible')
Alter table Notifications Add IsVisible bit not null Default(1) ;
Go
/****** Object:  Table [dbo].[ApplicationConfiguration]    Script Date: 5/10/2016 7:16:55 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApplicationConfiguration]') AND type in (N'U'))
DROP TABLE [dbo].[ApplicationConfiguration]
GO
/****** Object:  Table [dbo].[ApplicationConfiguration]    Script Date: 5/10/2016 7:16:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApplicationConfiguration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ApplicationConfiguration](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[config] [varchar](max) NOT NULL,
 CONSTRAINT [PK_ApplicationConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[ApplicationConfiguration] ON 

GO
INSERT [dbo].[ApplicationConfiguration] ([Id], [config]) VALUES (1, N'{"RootHostId":null,"EnvironmentalChargeRate":6.5,"Couriers":["FedEx","UPS", "USPS", "Corp Courier 1", "Corp Courier 2"],"InvoiceLateFeeConfigs":[{"DaysFrom":0,"DaysTo":5,"Rate":2},{"DaysFrom":6,"DaysTo":15,"Rate":5},{"DaysFrom":16,"DaysTo":null,"Rate":10}]}')
GO
SET IDENTITY_INSERT [dbo].[ApplicationConfiguration] OFF
GO
