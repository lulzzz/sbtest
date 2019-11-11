IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeDocumentAccess_Employee]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeDocumentAccess]'))
ALTER TABLE [dbo].[EmployeeDocumentAccess] DROP CONSTRAINT [FK_EmployeeDocumentAccess_Employee]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeDocument_Employee]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeDocument]'))
ALTER TABLE [dbo].[EmployeeDocument] DROP CONSTRAINT [FK_EmployeeDocument_Employee]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyDocumentSubType_DocumentType]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyDocumentSubType]'))
ALTER TABLE [dbo].[CompanyDocumentSubType] DROP CONSTRAINT [FK_CompanyDocumentSubType_DocumentType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_EmployeeDocumentAccess_LastAccessed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmployeeDocumentAccess] DROP CONSTRAINT [DF_EmployeeDocumentAccess_LastAccessed]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_EmployeeDocumentAccess_FirstAccessed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmployeeDocumentAccess] DROP CONSTRAINT [DF_EmployeeDocumentAccess_FirstAccessed]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_EmployeeDocument_DateUploaded]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmployeeDocument] DROP CONSTRAINT [DF_EmployeeDocument_DateUploaded]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_CompanyDocumentSubType_IsEmployeeRequired]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyDocumentSubType] DROP CONSTRAINT [DF_CompanyDocumentSubType_IsEmployeeRequired]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_DocumentType_CollectMetaData]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DocumentType] DROP CONSTRAINT [DF_DocumentType_CollectMetaData]
END
GO
/****** Object:  Table [dbo].[EmployeeDocumentAccess]    Script Date: 11/11/2019 12:34:41 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeDocumentAccess]') AND type in (N'U'))
DROP TABLE [dbo].[EmployeeDocumentAccess]
GO
/****** Object:  Table [dbo].[EmployeeDocument]    Script Date: 11/11/2019 12:34:41 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeDocument]') AND type in (N'U'))
DROP TABLE [dbo].[EmployeeDocument]
GO
/****** Object:  Table [dbo].[DocumentType]    Script Date: 11/11/2019 12:34:41 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyDocumentSubType]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyDocumentSubType]
GO
/****** Object:  Table [dbo].[DocumentCategory]    Script Date: 11/11/2019 12:34:41 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DocumentType]') AND type in (N'U'))
DROP TABLE [dbo].[DocumentType]
GO
/****** Object:  Table [dbo].[DocumentCategory]    Script Date: 11/11/2019 12:34:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[Category] [int] NOT NULL,
	[CollectMetaData] [bit] NOT NULL,
	[RequiresSubTypes] [bit] NOT NULL
 CONSTRAINT [PK_DocumentType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentType]    Script Date: 11/11/2019 12:34:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyDocumentSubType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[Type] [int] NOT NULL,
	[IsEmployeeRequired] [bit] NOT NULL,
	[TrackAccess] [bit] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL
 CONSTRAINT [PK_CompanyDocumentSubType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeDocument]    Script Date: 11/11/2019 12:34:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeDocument](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyDocumentSubType] [int] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[DateUploaded] [datetime] NOT NULL,
	[UploadedBy] [varchar](max) NOT NULL,
	[DocumentId] [uniqueidentifier] NOT NULL
 CONSTRAINT [PK_EmployeeDocument] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeDocumentAccess]    Script Date: 11/11/2019 12:34:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeDocumentAccess](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[DocumentId] [uniqueidentifier] NOT NULL,
	[FirstAccessed] [datetime] NOT NULL,
	[LastAccessed] [datetime] NOT NULL,
 CONSTRAINT [PK_EmployeeDocumentAccess] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentType] ADD  CONSTRAINT [DF_DocumentType_CollectMetaData]  DEFAULT ((0)) FOR [CollectMetaData]
GO
ALTER TABLE [dbo].[DocumentType] ADD  CONSTRAINT [DF_DocumentType_RequiresSubypes]  DEFAULT ((0)) FOR [RequiresSubTypes]
GO
ALTER TABLE [dbo].[CompanyDocumentSubType] ADD  CONSTRAINT [DF_CompanyDocumentSubType_IsRequired]  DEFAULT ((0)) FOR [IsEmployeeRequired]
GO
ALTER TABLE [dbo].[EmployeeDocument] ADD  CONSTRAINT [DF_EmployeeDocument_DateUploaded]  DEFAULT (getdate()) FOR [DateUploaded]
GO
ALTER TABLE [dbo].[EmployeeDocumentAccess] ADD  CONSTRAINT [DF_EmployeeDocumentAccess_FirstAccessed]  DEFAULT (getdate()) FOR [FirstAccessed]
GO
ALTER TABLE [dbo].[EmployeeDocumentAccess] ADD  CONSTRAINT [DF_EmployeeDocumentAccess_LastAccessed]  DEFAULT (getdate()) FOR [LastAccessed]
GO
ALTER TABLE [dbo].[CompanyDocumentSubType]  WITH CHECK ADD  CONSTRAINT [FK_CompanyDocumentSubType_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
ALTER TABLE [dbo].[CompanyDocumentSubType] CHECK CONSTRAINT [FK_CompanyDocumentSubType_Company]
GO
ALTER TABLE [dbo].[CompanyDocumentSubType]  WITH CHECK ADD  CONSTRAINT [FK_CompanyDocumentSubType_DocumentType] FOREIGN KEY([Type])
REFERENCES [dbo].[DocumentType] ([Id])
GO
ALTER TABLE [dbo].[CompanyDocumentSubType] CHECK CONSTRAINT [FK_CompanyDocumentSubType_DocumentType]
GO
ALTER TABLE [dbo].[EmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeDocument_Employee] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[EmployeeDocument] CHECK CONSTRAINT [FK_EmployeeDocument_Employee]
GO
ALTER TABLE [dbo].[EmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeDocument_CompanyDocumentSubType] FOREIGN KEY([CompanyDocumentSubType])
REFERENCES [dbo].[CompanyDocumentSubType] ([Id])
GO
ALTER TABLE [dbo].[EmployeeDocument] CHECK CONSTRAINT [FK_EmployeeDocument_CompanyDocumentSubType]
GO
ALTER TABLE [dbo].[EmployeeDocumentAccess]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeDocumentAccess_Employee] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[EmployeeDocumentAccess] CHECK CONSTRAINT [FK_EmployeeDocumentAccess_Employee]
GO


set identity_insert DocumentType On
insert into DocumentType(Id, Name, Category, CollectMetaData, RequiresSubTypes) values(0, 'Misc', 1, 0, 0);
insert into DocumentType(Id, Name, Category, CollectMetaData, RequiresSubTypes) values(1, 'Signature', 1, 0, 0);
insert into DocumentType(Id, Name, Category, CollectMetaData, RequiresSubTypes) values(3, 'Company Compliance', 1, 0, 1);
insert into DocumentType(Id, Name, Category, CollectMetaData, RequiresSubTypes) values(4, 'Employee On-Boarding', 2, 1, 1);
insert into DocumentType(Id, Name, Category, CollectMetaData, RequiresSubTypes) values(5, 'Employee Compliance', 3, 0, 1);
set identity_insert DocumentType Off