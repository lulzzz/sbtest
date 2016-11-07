IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract] DROP CONSTRAINT [FK_PayCheckExtract_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract] DROP CONSTRAINT [FK_PayCheckExtract_MasterExtracts]
GO
/****** Object:  Table [dbo].[PayCheckExtract]    Script Date: 5/11/2016 10:14:21 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckExtract]
GO
/****** Object:  Table [dbo].[PayCheckExtract]    Script Date: 5/11/2016 10:14:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckExtract](
	[PayrollPayCheckId] [int] NOT NULL,
	[MasterExtractId] [int] NOT NULL,
	[Extract] [varchar](50) NOT NULL,
	[Type] [int] NOT NULL,
 CONSTRAINT [PK_PayCheckExtract_1] PRIMARY KEY CLUSTERED 
(
	[PayrollPayCheckId] ASC,
	[Extract] ASC,
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckExtract_MasterExtracts] FOREIGN KEY([MasterExtractId])
REFERENCES [dbo].[MasterExtracts] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract] CHECK CONSTRAINT [FK_PayCheckExtract_MasterExtracts]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckExtract_PayrollPayCheck] FOREIGN KEY([PayrollPayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract] CHECK CONSTRAINT [FK_PayCheckExtract_PayrollPayCheck]
GO


/****** Object:  Table [dbo].[ReportConstants]    Script Date: 5/11/2016 10:26:54 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportConstants]') AND type in (N'U'))
DROP TABLE [dbo].[ReportConstants]
GO
/****** Object:  Table [dbo].[ReportConstants]    Script Date: 5/11/2016 10:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportConstants]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReportConstants](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Form] [varchar](max) NOT NULL,
	[DepositSchedule] [int] NOT NULL,
	[FileSequence] [int] NOT NULL,
 CONSTRAINT [PK_ReportConstants] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[ReportConstants] ON 

GO
INSERT [dbo].[ReportConstants] ([Id], [Form], [DepositSchedule], [FileSequence]) VALUES (1, N'Form940', 1, 1)
GO
INSERT [dbo].[ReportConstants] ([Id], [Form], [DepositSchedule], [FileSequence]) VALUES (2, N'Form940', 2, 1)
GO
INSERT [dbo].[ReportConstants] ([Id], [Form], [DepositSchedule], [FileSequence]) VALUES (3, N'Form940', 3, 72)
GO
INSERT [dbo].[ReportConstants] ([Id], [Form], [DepositSchedule], [FileSequence]) VALUES (4, N'Form941', 1, 14)
GO
INSERT [dbo].[ReportConstants] ([Id], [Form], [DepositSchedule], [FileSequence]) VALUES (5, N'Form941', 2, 15)
GO
INSERT [dbo].[ReportConstants] ([Id], [Form], [DepositSchedule], [FileSequence]) VALUES (6, N'Form941', 3, 10)
GO
SET IDENTITY_INSERT [dbo].[ReportConstants] OFF
GO
