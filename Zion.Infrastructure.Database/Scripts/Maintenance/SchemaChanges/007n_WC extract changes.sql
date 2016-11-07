IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'ClientNo')
Alter table Company Add ClientNo varchar(max) not null default('');


/****** Object:  Table [dbo].[InsuranceGroup]    Script Date: 7/11/2016 10:53:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsuranceGroup]') AND type in (N'U'))
DROP TABLE [dbo].[InsuranceGroup]
GO
/****** Object:  Table [dbo].[InsuranceGroup]    Script Date: 7/11/2016 10:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsuranceGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InsuranceGroup](
	[Id] [int] IDENTITY(0,1) NOT NULL,
	[GroupNo] [varchar](max) NOT NULL,
	[GroupName] [varchar](max) NOT NULL,
 CONSTRAINT [PK_InsuranceGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[InsuranceGroup] ON 

GO
INSERT [dbo].[InsuranceGroup] ([Id], [GroupNo], [GroupName]) VALUES (0, N'CA070', N'CA070')
GO
INSERT [dbo].[InsuranceGroup] ([Id], [GroupNo], [GroupName]) VALUES (1, N'CA071', N'CA071')
GO
INSERT [dbo].[InsuranceGroup] ([Id], [GroupNo], [GroupName]) VALUES (2, N'CA072', N'CA072')
GO
INSERT [dbo].[InsuranceGroup] ([Id], [GroupNo], [GroupName]) VALUES (3, N'CA073', N'CA073')
GO
INSERT [dbo].[InsuranceGroup] ([Id], [GroupNo], [GroupName]) VALUES (4, N'CA075', N'CA075')
GO
SET IDENTITY_INSERT [dbo].[InsuranceGroup] OFF
GO


ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_InsuranceGroup] FOREIGN KEY([InsuranceGroupNo])
REFERENCES [dbo].[InsuranceGroup] ([Id])
GO