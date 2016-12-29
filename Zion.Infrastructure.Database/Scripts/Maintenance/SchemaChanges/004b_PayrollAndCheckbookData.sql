Insert into EntityType(EntityTypeName) values('Vendor');
Insert into EntityType(EntityTypeName) values('Customer');
/****** Object:  Table [dbo].[TaxDeductionPrecedence]    Script Date: 24/08/2016 9:24:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaxDeductionPrecedence]') AND type in (N'U'))
DROP TABLE [dbo].[TaxDeductionPrecedence]
GO
/****** Object:  Table [dbo].[StandardDeductionTable]    Script Date: 24/08/2016 9:24:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StandardDeductionTable]') AND type in (N'U'))
DROP TABLE [dbo].[StandardDeductionTable]
GO
/****** Object:  Table [dbo].[SITTaxTable]    Script Date: 24/08/2016 9:24:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SITTaxTable]') AND type in (N'U'))
DROP TABLE [dbo].[SITTaxTable]
GO
/****** Object:  Table [dbo].[SITLowIncomeTaxTable]    Script Date: 24/08/2016 9:24:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SITLowIncomeTaxTable]') AND type in (N'U'))
DROP TABLE [dbo].[SITLowIncomeTaxTable]
GO
/****** Object:  Table [dbo].[FITWithholdingAllowanceTable]    Script Date: 24/08/2016 9:24:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FITWithholdingAllowanceTable]') AND type in (N'U'))
DROP TABLE [dbo].[FITWithholdingAllowanceTable]
GO
/****** Object:  Table [dbo].[FITTaxTable]    Script Date: 24/08/2016 9:24:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FITTaxTable]') AND type in (N'U'))
DROP TABLE [dbo].[FITTaxTable]
GO
/****** Object:  Table [dbo].[ExemptionAllowanceTable]    Script Date: 24/08/2016 9:24:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExemptionAllowanceTable]') AND type in (N'U'))
DROP TABLE [dbo].[ExemptionAllowanceTable]
GO
/****** Object:  Table [dbo].[EstimatedDeductionsTable]    Script Date: 24/08/2016 9:24:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EstimatedDeductionsTable]') AND type in (N'U'))
DROP TABLE [dbo].[EstimatedDeductionsTable]
GO
/****** Object:  Table [dbo].[EstimatedDeductionsTable]    Script Date: 24/08/2016 9:24:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EstimatedDeductionsTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EstimatedDeductionsTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollPeriodID] [int] NULL,
	[NoOfAllowances] [int] NULL,
	[Amount] [money] NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_EstimatedDeductionsTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ExemptionAllowanceTable]    Script Date: 24/08/2016 9:24:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExemptionAllowanceTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ExemptionAllowanceTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollPeriodID] [int] NULL,
	[NoOfAllowances] [int] NULL,
	[Amount] [money] NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_ExemptionAllowanceTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[FITTaxTable]    Script Date: 24/08/2016 9:24:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FITTaxTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FITTaxTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollPeriodID] [int] NULL,
	[FilingStatus] [varchar](50) NULL,
	[StartRange] [float] NULL,
	[EndRange] [float] NULL,
	[FlatRate] [float] NULL,
	[AdditionalPercentage] [float] NULL,
	[ExcessOvrAmt] [float] NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_FITTaxTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FITWithholdingAllowanceTable]    Script Date: 24/08/2016 9:24:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FITWithholdingAllowanceTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FITWithholdingAllowanceTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollPeriodID] [int] NULL,
	[AmtForOneWithholdingAllow] [float] NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_FITWithholdingAllowanceTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[SITLowIncomeTaxTable]    Script Date: 24/08/2016 9:24:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SITLowIncomeTaxTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SITLowIncomeTaxTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollPeriodId] [int] NULL,
	[FilingStatus] [varchar](50) NULL,
	[Amount] [money] NULL,
	[AmtIfExmpGrtThan2] [money] NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_SITLowIncomeTaxTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SITTaxTable]    Script Date: 24/08/2016 9:24:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SITTaxTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SITTaxTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollPeriodID] [int] NULL,
	[FilingStatus] [varchar](50) NULL,
	[StartRange] [float] NULL,
	[EndRange] [float] NULL,
	[FlatRate] [money] NULL,
	[AdditionalPercentage] [float] NULL,
	[ExcessOvrAmt] [money] NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_SITTaxTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StandardDeductionTable]    Script Date: 24/08/2016 9:24:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StandardDeductionTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StandardDeductionTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollPeriodID] [int] NULL,
	[FilingStatus] [varchar](50) NULL,
	[Amount] [money] NULL,
	[AmtIfExmpGrtThan1] [money] NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_StandardDeductionTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TaxDeductionPrecedence]    Script Date: 24/08/2016 9:24:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaxDeductionPrecedence]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TaxDeductionPrecedence](
	[TaxCode] [varchar](max) NOT NULL,
	[DeductionTypeId] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO


SET IDENTITY_INSERT [dbo].[EstimatedDeductionsTable] ON 

GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (361, 1, 1, 19.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (362, 1, 2, 38.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (363, 1, 3, 58.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (364, 1, 4, 77.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (365, 1, 5, 96.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (366, 1, 6, 115.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (367, 1, 7, 135.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (368, 1, 8, 154.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (369, 1, 9, 173.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (370, 1, 10, 192.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (371, 2, 1, 38.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (372, 2, 2, 77.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (373, 2, 3, 115.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (374, 2, 4, 154.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (375, 2, 5, 192.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (376, 2, 6, 231.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (377, 2, 7, 269.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (378, 2, 8, 308.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (379, 2, 9, 346.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (380, 2, 10, 385.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (381, 3, 1, 42.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (382, 3, 2, 83.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (383, 3, 3, 125.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (384, 3, 4, 167.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (385, 3, 5, 208.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (386, 3, 6, 250.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (387, 3, 7, 292.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (388, 3, 8, 333.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (389, 3, 9, 375.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (390, 3, 10, 417.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (391, 4, 1, 83.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (392, 4, 2, 167.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (393, 4, 3, 250.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (394, 4, 4, 333.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (395, 4, 5, 417.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (396, 4, 6, 500.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (397, 4, 7, 583.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (398, 4, 8, 667.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (399, 4, 9, 750.0000, 2016)
GO
INSERT [dbo].[EstimatedDeductionsTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (400, 4, 10, 833.0000, 2016)
GO
SET IDENTITY_INSERT [dbo].[EstimatedDeductionsTable] OFF
GO
SET IDENTITY_INSERT [dbo].[ExemptionAllowanceTable] ON 

GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (397, 1, 0, 0.0000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (398, 1, 1, 2.3100, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (399, 1, 2, 4.6100, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (400, 1, 3, 6.9200, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (401, 1, 4, 9.2200, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (402, 1, 5, 11.5300, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (403, 1, 6, 13.8300, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (404, 1, 7, 16.1400, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (405, 1, 8, 18.4500, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (406, 1, 9, 20.7500, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (407, 1, 10, 23.0600, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (408, 2, 0, 0.0000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (409, 2, 1, 4.6100, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (410, 2, 2, 9.2200, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (411, 2, 3, 13.8300, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (412, 2, 4, 18.4500, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (413, 2, 5, 23.0600, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (414, 2, 6, 27.6700, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (415, 2, 7, 32.2800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (416, 2, 8, 36.8900, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (417, 2, 9, 41.5000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (418, 2, 10, 46.1200, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (419, 3, 0, 0.0000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (420, 3, 1, 5.0000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (421, 3, 2, 9.9900, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (422, 3, 3, 14.9900, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (423, 3, 4, 19.9800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (424, 3, 5, 24.9800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (425, 3, 6, 29.9800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (426, 3, 7, 34.9700, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (427, 3, 8, 39.9700, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (428, 3, 9, 44.9600, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (429, 3, 10, 49.9600, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (430, 4, 0, 0.0000, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (431, 4, 1, 9.9900, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (432, 4, 2, 19.9800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (433, 4, 3, 29.9800, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (434, 4, 4, 39.9700, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (435, 4, 5, 49.9600, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (436, 4, 6, 59.9500, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (437, 4, 7, 69.9400, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (438, 4, 8, 79.9300, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (439, 4, 9, 89.9300, 2016)
GO
INSERT [dbo].[ExemptionAllowanceTable] ([Id], [PayrollPeriodID], [NoOfAllowances], [Amount], [Year]) VALUES (440, 4, 10, 99.9200, 2016)
GO
SET IDENTITY_INSERT [dbo].[ExemptionAllowanceTable] OFF
GO
SET IDENTITY_INSERT [dbo].[FITTaxTable] ON 

GO

INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (793, 1, N'HeadofHousehold', 0, 42.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (794, 1, N'HeadofHousehold', 43, 221.99, 0, 10, 43, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (795, 1, N'HeadofHousehold', 222, 766.99, 17.9, 15, 222, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (796, 1, N'HeadofHousehold', 767, 1795.99, 99.65, 25, 767, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (797, 1, N'HeadofHousehold', 1796, 3699.99, 356.9, 28, 1796, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (798, 1, N'HeadofHousehold', 3700, 7991.99, 890.02, 33, 3700, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (799, 1, N'HeadofHousehold', 7992, 8024.99, 2306.38, 35, 7992, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (800, 1, N'Married', 0, 163.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (801, 1, N'Married', 164, 520.99, 0, 10, 164, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (802, 1, N'Married', 521, 1612.99, 35.7, 15, 521, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (803, 1, N'Married', 1613, 3085.99, 199.5, 25, 1613, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (804, 1, N'Married', 3086, 4614.99, 567.75, 28, 3086, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (805, 1, N'Married', 4615, 8112.99, 995.87, 33, 4615, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (806, 1, N'Married', 8113, 9143.99, 2150.21, 35, 8113, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (807, 1, N'Single', 0, 42.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (808, 1, N'Single', 43, 221.99, 0, 10, 43, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (809, 1, N'Single', 222, 766.99, 17.9, 15, 222, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (810, 1, N'Single', 767, 1795.99, 99.65, 25, 767, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (811, 1, N'Single', 1796, 3699.99, 356.9, 28, 1796, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (812, 1, N'Single', 3700, 7991.99, 890.02, 33, 3700, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (813, 1, N'Single', 7992, 8024.99, 2306.38, 35, 7992, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (814, 2, N'HeadofHousehold', 0, 86.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (815, 2, N'HeadofHousehold', 87, 442.99, 0, 10, 87, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (816, 2, N'HeadofHousehold', 443, 1534.99, 35.6, 15, 443, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (817, 2, N'HeadofHousehold', 1535, 3591.99, 199.4, 25, 1535, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (818, 2, N'HeadofHousehold', 3592, 7399.99, 713.65, 28, 3592, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (819, 2, N'HeadofHousehold', 7400, 15984.99, 1779.89, 33, 7400, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (820, 2, N'HeadofHousehold', 15985, 16049.99, 4612.94, 35, 15985, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (821, 2, N'Married', 0, 328.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (822, 2, N'Married', 329, 1041.99, 0, 10, 329, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (823, 2, N'Married', 1042, 3224.99, 71.3, 15, 1042, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (824, 2, N'Married', 3225, 6170.99, 398.75, 25, 3225, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (825, 2, N'Married', 6171, 9230.99, 1135.25, 28, 6171, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (826, 2, N'Married', 9231, 16226.99, 1992.05, 33, 9231, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (827, 2, N'Married', 16227, 18287.99, 4300.73, 35, 16227, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (828, 2, N'Single', 0, 86.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (829, 2, N'Single', 87, 442.99, 0, 10, 87, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (830, 2, N'Single', 443, 1534.99, 35.6, 15, 443, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (831, 2, N'Single', 1535, 3591.99, 199.4, 25, 1535, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (832, 2, N'Single', 3592, 7399.99, 713.65, 28, 3592, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (833, 2, N'Single', 7400, 15984.99, 1779.89, 33, 7400, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (834, 2, N'Single', 15985, 16049.99, 4612.94, 35, 15985, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (835, 3, N'HeadofHousehold', 0, 93.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (836, 3, N'HeadofHousehold', 94, 479.99, 0, 10, 94, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (837, 3, N'HeadofHousehold', 480, 1662.99, 38.6, 15, 480, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (838, 3, N'HeadofHousehold', 1663, 3891.99, 216.05, 25, 1663, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (839, 3, N'HeadofHousehold', 3892, 8016.99, 773.3, 28, 3892, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (840, 3, N'HeadofHousehold', 8017, 17316.99, 1928.3, 33, 8017, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (841, 3, N'HeadofHousehold', 17317, 17387.99, 4997.3, 35, 17317, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (842, 3, N'Married', 0, 355.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (843, 3, N'Married', 356, 1128.99, 0, 10, 356, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (844, 3, N'Married', 1129, 3493.99, 77.3, 15, 1129, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (845, 3, N'Married', 3494, 6684.99, 432.05, 25, 3494, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (846, 3, N'Married', 6685, 9999.99, 1229.8, 28, 6685, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (847, 3, N'Married', 10000, 17578.99, 2158, 33, 10000, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (848, 3, N'Married', 17579, 19812.99, 4659.07, 35, 17579, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (849, 3, N'Single', 0, 93.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (850, 3, N'Single', 94, 479.99, 0, 10, 94, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (851, 3, N'Single', 480, 1662.99, 38.6, 15, 480, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (852, 3, N'Single', 1663, 3891.99, 216.05, 25, 1663, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (853, 3, N'Single', 3892, 8016.99, 773.3, 28, 3892, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (854, 3, N'Single', 8017, 17316.99, 1928.3, 33, 8017, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (855, 3, N'Single', 17317, 17387.99, 4997.3, 35, 17317, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (856, 4, N'HeadofHousehold', 0, 187.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (857, 4, N'HeadofHousehold', 188, 959.99, 0, 10, 188, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (858, 4, N'HeadofHousehold', 960, 3324.99, 77.2, 15, 960, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (859, 4, N'HeadofHousehold', 3325, 7782.99, 431.95, 25, 3325, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (860, 4, N'HeadofHousehold', 7783, 16032.99, 1546.45, 28, 7783, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (861, 4, N'HeadofHousehold', 16033, 34632.99, 3856.45, 33, 16033, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (862, 4, N'HeadofHousehold', 34633, 34774.99, 9994.45, 35, 34633, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (863, 4, N'Married', 0, 712.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (864, 4, N'Married', 713, 2257.99, 0, 10, 713, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (865, 4, N'Married', 2258, 6987.99, 154.5, 15, 2258, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (866, 4, N'Married', 6988, 13370.99, 864, 25, 6988, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (867, 4, N'Married', 13371, 19999.99, 2459.75, 28, 13371, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (868, 4, N'Married', 20000, 35157.99, 4315.87, 33, 20000, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (869, 4, N'Married', 35158, 39624.99, 9318.01, 35, 35158, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (870, 4, N'Single', 0, 187.99, 0, 0, 0, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (871, 4, N'Single', 188, 959.99, 0, 10, 188, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (872, 4, N'Single', 960, 3324.99, 77.2, 15, 960, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (873, 4, N'Single', 3325, 7782.99, 431.95, 25, 3325, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (874, 4, N'Single', 7783, 16032.99, 1546.45, 28, 7783, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (875, 4, N'Single', 16033, 34632.99, 3856.45, 33, 16033, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (876, 4, N'Single', 34633, 34774.99, 9994.45, 35, 34633, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (877, 1, N'Single', 8025, NULL, 2317.93, 39.6, 8025, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (878, 1, N'HeadofHousehold', 8025, NULL, 2317.93, 39.6, 8025, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (879, 1, N'Married', 9144, NULL, 2511.06, 39.6, 9144, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (880, 2, N'Single', 16050, NULL, 4635.69, 39.6, 16050, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (881, 2, N'HeadofHousehold', 16050, NULL, 4635.69, 39.6, 16050, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (882, 2, N'Married', 18288, NULL, 5022.08, 39.6, 18288, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (883, 3, N'Single', 17388, NULL, 5022.15, 39.6, 17388, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (884, 3, N'HeadofHousehold', 17388, NULL, 5022.15, 39.6, 17388, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (885, 3, N'Married', 19813, NULL, 5440.97, 39.6, 19813, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (886, 4, N'Single', 34775, NULL, 10044.15, 39.6, 34775, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (887, 4, N'HeadofHousehold', 34775, NULL, 10044.15, 39.6, 34775, 2016)
GO
INSERT [dbo].[FITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (888, 4, N'Married', 39625, NULL, 10881.46, 39.6, 39625, 2016)
GO
SET IDENTITY_INSERT [dbo].[FITTaxTable] OFF
GO
SET IDENTITY_INSERT [dbo].[FITWithholdingAllowanceTable] ON 

GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (37, 1, 77.9, 2016)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (38, 2, 155.8, 2016)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (39, 3, 168.8, 2016)
GO
INSERT [dbo].[FITWithholdingAllowanceTable] ([Id], [PayrollPeriodID], [AmtForOneWithholdingAllow], [Year]) VALUES (40, 4, 337.5, 2016)
GO
SET IDENTITY_INSERT [dbo].[FITWithholdingAllowanceTable] OFF
GO
SET IDENTITY_INSERT [dbo].[SITLowIncomeTaxTable] ON 

GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (181, 1, N'Single', 258.0000, 258.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (182, 2, N'Single', 516.0000, 516.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (183, 3, N'Single', 559.0000, 559.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (184, 4, N'Single', 1118.0000, 1118.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (185, 1, N'DualIncomeMarried', 258.0000, 258.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (186, 2, N'DualIncomeMarried', 516.0000, 516.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (187, 3, N'DualIncomeMarried', 559.0000, 559.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (188, 4, N'DualIncomeMarried', 1118.0000, 1118.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (189, 1, N'MarriedWithMultipleEmployers', 258.0000, 258.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (190, 2, N'MarriedWithMultipleEmployers', 516.0000, 516.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (191, 3, N'MarriedWithMultipleEmployers', 559.0000, 559.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (192, 4, N'MarriedWithMultipleEmployers', 1118.0000, 1118.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (193, 1, N'Married ', 258.0000, 516.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (194, 2, N'Married ', 516.0000, 1032.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (195, 3, N'Married ', 559.0000, 1118.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (196, 4, N'Married ', 1118.0000, 2237.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (197, 1, N'Headofhousehold', 516.0000, 516.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (198, 2, N'Headofhousehold', 1032.0000, 1032.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (199, 3, N'Headofhousehold', 1118.0000, 1118.0000, 2016)
GO
INSERT [dbo].[SITLowIncomeTaxTable] ([Id], [PayrollPeriodId], [FilingStatus], [Amount], [AmtIfExmpGrtThan2], [Year]) VALUES (200, 4, N'Headofhousehold', 2237.0000, 2237.0000, 2016)
GO
SET IDENTITY_INSERT [dbo].[SITLowIncomeTaxTable] OFF
GO
SET IDENTITY_INSERT [dbo].[SITTaxTable] ON 

GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (861, 1, N'Single', 0, 150.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (862, 1, N'Single', 151, 357.99, 1.6600, 2.2, 151.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (863, 1, N'Single', 358, 564.99, 6.2100, 4.4, 358.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (864, 1, N'Single', 565, 783.99, 15.3200, 6.6, 565.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (865, 1, N'Single', 784, 990.99, 29.7700, 8.8, 784.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (866, 1, N'Single', 991, 5061.99, 47.9900, 10.23, 991.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (867, 1, N'Single', 5062, 6073.99, 464.4500, 11.33, 5062.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (868, 1, N'Single', 6074, 10123.99, 579.1100, 12.43, 6074.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (869, 1, N'Single', 10124, 19230.99, 1082.5300, 13.53, 10124.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (870, 1, N'Single', 19231, NULL, 2314.7100, 14.63, 19231.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (871, 1, N'Headofhousehold', 0, 301.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (872, 1, N'Headofhousehold', 302, 715.99, 3.3200, 2.2, 302.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (873, 1, N'Headofhousehold', 716, 922.99, 12.4300, 4.4, 716.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (874, 1, N'Headofhousehold', 923, 1141.99, 21.5400, 6.6, 923.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (875, 1, N'Headofhousehold', 1142, 1348.99, 35.9900, 8.8, 1142.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (876, 1, N'Headofhousehold', 1349, 6883.99, 54.2100, 10.23, 1349.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (877, 1, N'Headofhousehold', 6884, 8260.99, 620.4400, 11.33, 6884.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (878, 1, N'Headofhousehold', 8261, 13768.99, 776.4500, 12.43, 8261.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (879, 1, N'Headofhousehold', 13769, 19230.99, 1461.0900, 13.53, 13769.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (880, 1, N'Headofhousehold', 19231, NULL, 2200.1000, 14.63, 19231.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (881, 1, N'Married', 0, 301.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (882, 1, N'Married', 302, 715.99, 3.3200, 2.2, 302.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (883, 1, N'Married', 716, 1129.99, 12.4300, 4.4, 716.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (884, 1, N'Married', 1130, 1567.99, 30.6500, 6.6, 1130.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (885, 1, N'Married', 1568, 1981.99, 59.5600, 8.8, 1568.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (886, 1, N'Married', 1982, 10123.99, 95.9900, 10.23, 1982.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (887, 1, N'Married', 10124, 12147.99, 928.9200, 11.33, 10124.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (888, 1, N'Married', 12148, 19230.99, 1158.2400, 12.43, 12148.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (889, 1, N'Married', 19231, 20247.99, 2038.6600, 13.53, 19231.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (890, 1, N'Married', 20248, NULL, 2176.2600, 14.63, 20248.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (891, 2, N'Single', 0, 301.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (892, 2, N'Single', 302, 715.99, 3.3200, 2.2, 302.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (893, 2, N'Single', 716, 1129.99, 12.4300, 4.4, 716.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (894, 2, N'Single', 1130, 1567.99, 30.6500, 6.6, 1130.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (895, 2, N'Single', 1568, 1981.99, 59.5600, 8.8, 1568.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (896, 2, N'Single', 1982, 10123.99, 95.9900, 10.23, 1982.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (897, 2, N'Single', 10124, 12147.99, 928.9200, 11.33, 10124.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (898, 2, N'Single', 12148, 20247.99, 1158.2400, 12.43, 12148.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (899, 2, N'Single', 20248, 38461.99, 2165.0700, 13.53, 20248.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (900, 2, N'Single', 38462, NULL, 4629.4200, 14.63, 38462.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (901, 2, N'Headofhousehold', 0, 603.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (902, 2, N'Headofhousehold', 604, 1431.99, 6.6400, 2.2, 604.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (903, 2, N'Headofhousehold', 1432, 1845.99, 24.8600, 4.4, 1432.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (904, 2, N'Headofhousehold', 1846, 2283.99, 43.0800, 6.6, 1846.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (905, 2, N'Headofhousehold', 2284, 2697.99, 71.9900, 8.8, 2284.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (906, 2, N'Headofhousehold', 2698, 13767.99, 108.4200, 10.23, 2698.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (907, 2, N'Headofhousehold', 13768, 16521.99, 1240.8800, 11.33, 13768.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (908, 2, N'Headofhousehold', 16522, 27537.99, 1552.9100, 12.43, 16522.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (909, 2, N'Headofhousehold', 27538, 38461.99, 2922.2000, 13.53, 27538.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (910, 2, N'Headofhousehold', 38462, NULL, 4400.2200, 14.63, 38462.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (911, 2, N'Married', 0, 603.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (912, 2, N'Married', 604, 1431.99, 6.6400, 2.2, 604.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (913, 2, N'Married', 1432, 2259.99, 24.8600, 4.4, 1432.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (914, 2, N'Married', 2260, 3135.99, 61.2900, 6.6, 2260.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (915, 2, N'Married', 3136, 3963.99, 119.1100, 8.8, 3136.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (916, 2, N'Married', 3964, 20247.99, 191.9700, 10.23, 3964.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (917, 2, N'Married', 20248, 24295.99, 1857.8200, 11.33, 20248.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (918, 2, N'Married', 24296, 38461.99, 2316.4600, 12.43, 24296.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (919, 2, N'Married', 38462, 40495.99, 4077.2900, 13.53, 38462.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (920, 2, N'Married', 40496, NULL, 4352.4900, 14.63, 40496.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (921, 3, N'Single', 0, 326.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (922, 3, N'Single', 327, 774.99, 3.6000, 2.2, 327.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (923, 3, N'Single', 775, 1223.99, 13.4600, 4.4, 775.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (924, 3, N'Single', 1224, 1698.99, 33.2200, 6.6, 1224.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (925, 3, N'Single', 1699, 2146.99, 64.5700, 8.8, 1699.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (926, 3, N'Single', 2147, 10967.99, 103.9900, 10.23, 2147.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (927, 3, N'Single', 10968, 13160.99, 1006.3800, 11.33, 10968.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (928, 3, N'Single', 13161, 21934.99, 1254.8500, 12.43, 13161.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (929, 3, N'Single', 21935, 41666.99, 2345.4600, 13.53, 21935.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (930, 3, N'Single', 41667, NULL, 5015.2000, 14.63, 41667.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (931, 3, N'Headofhousehold', 0, 654.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (932, 3, N'Headofhousehold', 655, 1550.99, 7.2100, 2.2, 655.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (933, 3, N'Headofhousehold', 1551, 1998.99, 26.9200, 4.4, 1551.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (934, 3, N'Headofhousehold', 1999, 2473.99, 46.6300, 6.6, 1999.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (935, 3, N'Headofhousehold', 2474, 2922.99, 77.9800, 8.8, 2474.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (936, 3, N'Headofhousehold', 2923, 14915.99, 117.4900, 10.23, 2923.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (937, 3, N'Headofhousehold', 14916, 17898.99, 1344.3700, 11.33, 14916.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (938, 3, N'Headofhousehold', 17899, 29831.99, 1682.3400, 12.43, 17899.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (939, 3, N'Headofhousehold', 29832, 41666.99, 3165.6100, 13.53, 29832.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (940, 3, N'Headofhousehold', 41667, NULL, 4766.8900, 14.63, 41667.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (941, 3, N'Married', 0, 653.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (942, 3, N'Married', 654, 1549.99, 7.1900, 2.2, 654.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (943, 3, N'Married', 1550, 2447.99, 26.9000, 4.4, 1550.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (944, 3, N'Married', 2448, 3397.99, 66.4100, 6.6, 2448.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (945, 3, N'Married', 3398, 4293.99, 129.1100, 8.8, 3398.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (946, 3, N'Married', 4294, 21935.99, 207.9600, 10.23, 4294.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (947, 3, N'Married', 21936, 26321.99, 2012.7400, 11.33, 21936.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (948, 3, N'Married', 26322, 41666.99, 2509.6700, 12.43, 26322.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (949, 3, N'Married', 41667, 43869.99, 4417.0500, 13.53, 41667.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (950, 3, N'Married', 43870, NULL, 4715.1200, 14.63, 43870.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (951, 4, N'Single', 0, 653.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (952, 4, N'Single', 654, 1549.99, 7.1900, 2.2, 654.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (953, 4, N'Single', 1550, 2447.99, 26.9000, 4.4, 1550.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (954, 4, N'Single', 2448, 3397.99, 66.4100, 6.6, 2448.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (955, 4, N'Single', 3398, 4293.99, 129.1100, 8.8, 3398.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (956, 4, N'Single', 4294, 21935.99, 207.9600, 10.23, 4294.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (957, 4, N'Single', 21936, 26321.99, 2012.7400, 11.33, 21936.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (958, 4, N'Single', 26322, 43869.99, 2509.6700, 12.43, 26322.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (959, 4, N'Single', 43870, 83333.99, 4690.8900, 13.53, 43870.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (960, 4, N'Single', 83334, NULL, 10030.3700, 14.63, 83334.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (961, 4, N'Headofhousehold', 0, 1309.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (962, 4, N'Headofhousehold', 1310, 3101.99, 14.4100, 2.2, 1310.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (963, 4, N'Headofhousehold', 3102, 3997.99, 53.8300, 4.4, 3102.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (964, 4, N'Headofhousehold', 3998, 4947.99, 93.2500, 6.6, 3998.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (965, 4, N'Headofhousehold', 4948, 5845.99, 155.9500, 8.8, 4948.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (966, 4, N'Headofhousehold', 5846, 29831.99, 234.9700, 10.23, 5846.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (967, 4, N'Headofhousehold', 29832, 35797.99, 2688.7400, 11.33, 29832.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (968, 4, N'Headofhousehold', 35798, 59663.99, 3364.6900, 12.43, 35798.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (969, 4, N'Headofhousehold', 59664, 83333.99, 6331.2300, 13.53, 59664.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (970, 4, N'Headofhousehold', 83334, NULL, 9533.7800, 14.63, 83334.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (971, 4, N'Married', 0, 1307.99, 0.0000, 1.1, 0.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (972, 4, N'Married', 1308, 3099.99, 14.3900, 2.2, 1308.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (973, 4, N'Married', 3100, 4895.99, 53.8100, 4.4, 3100.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (974, 4, N'Married', 4896, 6795.99, 132.8300, 6.6, 4896.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (975, 4, N'Married', 6796, 8587.99, 258.2300, 8.8, 6796.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (976, 4, N'Married', 8588, 43871.99, 415.9300, 10.23, 8588.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (977, 4, N'Married', 43872, 52643.99, 4025.4800, 11.33, 43872.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (978, 4, N'Married', 52644, 83333.99, 5019.3500, 12.43, 52644.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (979, 4, N'Married', 83334, 87739.99, 8834.1200, 13.53, 83334.0000, 2016)
GO
INSERT [dbo].[SITTaxTable] ([Id], [PayrollPeriodID], [FilingStatus], [StartRange], [EndRange], [FlatRate], [AdditionalPercentage], [ExcessOvrAmt], [Year]) VALUES (980, 4, N'Married', 87740, NULL, 9430.2500, 14.63, 87740.0000, 2016)
GO
SET IDENTITY_INSERT [dbo].[SITTaxTable] OFF
GO
SET IDENTITY_INSERT [dbo].[StandardDeductionTable] ON 

GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (181, 1, N'Single', 78.0000, 78.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (182, 2, N'Single', 156.0000, 156.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (183, 3, N'Single', 169.0000, 169.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (184, 4, N'Single', 337.0000, 337.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (185, 1, N'DualIncomeMarried', 78.0000, 78.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (186, 2, N'DualIncomeMarried', 156.0000, 156.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (187, 3, N'DualIncomeMarried', 169.0000, 169.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (188, 4, N'DualIncomeMarried', 337.0000, 337.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (189, 1, N'MarriedWithMultipleEmployers', 78.0000, 78.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (190, 2, N'MarriedWithMultipleEmployers', 156.0000, 156.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (191, 3, N'MarriedWithMultipleEmployers', 169.0000, 169.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (192, 4, N'MarriedWithMultipleEmployers', 337.0000, 337.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (193, 1, N'Married ', 78.0000, 156.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (194, 2, N'Married ', 156.0000, 311.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (195, 3, N'Married ', 169.0000, 337.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (196, 4, N'Married ', 337.0000, 674.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (197, 1, N'Headofhousehold', 156.0000, 156.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (198, 2, N'Headofhousehold', 311.0000, 311.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (199, 3, N'Headofhousehold', 337.0000, 337.0000, 2016)
GO
INSERT [dbo].[StandardDeductionTable] ([Id], [PayrollPeriodID], [FilingStatus], [Amount], [AmtIfExmpGrtThan1], [Year]) VALUES (200, 4, N'Headofhousehold', 674.0000, 674.0000, 2016)
GO
SET IDENTITY_INSERT [dbo].[StandardDeductionTable] OFF
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'FIT', 6)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'FIT', 7)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'FIT', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'MD_Employer', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'MD_Employee', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SS_Employee', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SS_Employer', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'FUTA', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'MD_Employee', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'MD_Employer', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SS_Employee', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SS_Employer', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'FUTA', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SIT', 6)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SIT', 7)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SIT', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SDI', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SUI', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'ETT', 9)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SDI', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'SUI', 8)
GO
INSERT [dbo].[TaxDeductionPrecedence] ([TaxCode], [DeductionTypeId]) VALUES (N'ETT', 8)
GO
