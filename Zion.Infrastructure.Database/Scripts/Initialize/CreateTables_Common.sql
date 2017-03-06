USE [$(DB)]
GO
/****** Object:  Schema [Common]    Script Date: 7/06/2016 12:59:59 PM ******/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Common')
DROP SCHEMA [Common]
GO
/****** Object:  Schema [Common]    Script Date: 7/06/2016 12:59:59 PM ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Common')
EXEC sys.sp_executesql N'CREATE SCHEMA [Common]'

GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EntityRelation_EntityType1]') AND parent_object_id = OBJECT_ID(N'[dbo].[EntityRelation]'))
ALTER TABLE [dbo].[EntityRelation] DROP CONSTRAINT [FK_EntityRelation_EntityType1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EntityRelation_EntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[EntityRelation]'))
ALTER TABLE [dbo].[EntityRelation] DROP CONSTRAINT [FK_EntityRelation_EntityType]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserEventLog_Timestamp]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserEventLog] DROP CONSTRAINT [DF_UserEventLog_Timestamp]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF_StagingData_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] DROP CONSTRAINT [DF_StagingData_DateCreated]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF__StagingData__Id__1A14E395]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] DROP CONSTRAINT [DF__StagingData__Id__1A14E395]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF_Mementos_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Mementos] DROP CONSTRAINT [DF_Mementos_DateCreated]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF__Mementos__Versio__182C9B23]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Mementos] DROP CONSTRAINT [DF__Mementos__Versio__182C9B23]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF__Mementos__Id__173876EA]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Mementos] DROP CONSTRAINT [DF__Mementos__Id__173876EA]
END

GO
/****** Object:  Table [dbo].[UserEventLog]    Script Date: 16/06/2016 12:07:19 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserEventLog]') AND type in (N'U'))
DROP TABLE [dbo].[UserEventLog]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 16/06/2016 12:07:19 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notifications]') AND type in (N'U'))
DROP TABLE [dbo].[Notifications]
GO
/****** Object:  Table [dbo].[EntityType]    Script Date: 16/06/2016 12:07:19 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EntityType]') AND type in (N'U'))
DROP TABLE [dbo].[EntityType]
GO
/****** Object:  Table [dbo].[EntityRelation]    Script Date: 16/06/2016 12:07:19 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EntityRelation]') AND type in (N'U'))
DROP TABLE [dbo].[EntityRelation]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 16/06/2016 12:07:19 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
DROP TABLE [dbo].[Country]
GO
/****** Object:  Table [Common].[StagingData]    Script Date: 16/06/2016 12:07:19 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[StagingData]') AND type in (N'U'))
DROP TABLE [Common].[StagingData]
GO
/****** Object:  Table [Common].[Mementos]    Script Date: 16/06/2016 12:07:19 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Mementos]') AND type in (N'U'))
DROP TABLE [Common].[Mementos]
GO
/****** Object:  Table [Common].[Mementos]    Script Date: 16/06/2016 12:07:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Mementos]') AND type in (N'U'))
BEGIN
CREATE TABLE [Common].[Mementos](
	[Id] [uniqueidentifier] NOT NULL,
	[Memento] [varchar](max) NOT NULL,
	[OriginatorType] [varchar](255) NOT NULL,
	[Version] [int] NOT NULL,
	[MementoId] [uniqueidentifier] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_Mementos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Common].[StagingData]    Script Date: 16/06/2016 12:07:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[StagingData]') AND type in (N'U'))
BEGIN
CREATE TABLE [Common].[StagingData](
	[Id] [uniqueidentifier] NOT NULL,
	[OriginatorType] [varchar](255) NOT NULL,
	[MementoId] [uniqueidentifier] NOT NULL,
	[Memento] [varchar](max) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK__StagingData] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Country]    Script Date: 16/06/2016 12:07:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Country](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](max) NOT NULL,
	[Data] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EntityRelation]    Script Date: 16/06/2016 12:07:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EntityRelation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EntityRelation](
	[EntityRelationId] [int] IDENTITY(1,1) NOT NULL,
	[SourceEntityTypeId] [int] NOT NULL,
	[TargetEntityTypeId] [int] NOT NULL,
	[SourceEntityId] [uniqueidentifier] NOT NULL,
	[TargetEntityId] [uniqueidentifier] NOT NULL,
	[TargetObject] [varchar](max) NOT NULL,
 CONSTRAINT [PK_EntityRelation] PRIMARY KEY CLUSTERED 
(
	[EntityRelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EntityType]    Script Date: 16/06/2016 12:07:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EntityType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EntityType](
	[EntityTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EntityTypeName] [varchar](max) NOT NULL,
 CONSTRAINT [PK_EntityType] PRIMARY KEY CLUSTERED 
(
	[EntityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 16/06/2016 12:07:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notifications]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Notifications](
	[NotificationId] [uniqueidentifier] NOT NULL,
	[Type] [varchar](100) NULL,
	[Text] [varchar](500) NULL,
	[MetaData] [varchar](max) NULL,
	[LoginId] [varchar](100) NULL,
	[IsRead] [bit] NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserEventLog]    Script Date: 16/06/2016 12:07:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserEventLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserEventLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](50) NOT NULL,
	[UserName] [varchar](max) NOT NULL,
	[Module] [varchar](50) NOT NULL,
	[Event] [int] NOT NULL,
	[EventAction] [varchar](max) NULL,
	[EventObject] [varchar](max) NULL,
	[EventObjectName] [varchar](100) NULL,
	[Timestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_UserEventLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF__Mementos__Id__173876EA]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Mementos] ADD  DEFAULT (newid()) FOR [Id]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF__Mementos__Versio__182C9B23]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Mementos] ADD  DEFAULT ((1)) FOR [Version]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF_Mementos_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Mementos] ADD  CONSTRAINT [DF_Mementos_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF__StagingData__Id__1A14E395]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] ADD  DEFAULT (newid()) FOR [Id]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF_StagingData_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] ADD  CONSTRAINT [DF_StagingData_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserEventLog_Timestamp]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserEventLog] ADD  CONSTRAINT [DF_UserEventLog_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EntityRelation_EntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[EntityRelation]'))
ALTER TABLE [dbo].[EntityRelation]  WITH CHECK ADD  CONSTRAINT [FK_EntityRelation_EntityType] FOREIGN KEY([SourceEntityTypeId])
REFERENCES [dbo].[EntityType] ([EntityTypeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EntityRelation_EntityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[EntityRelation]'))
ALTER TABLE [dbo].[EntityRelation] CHECK CONSTRAINT [FK_EntityRelation_EntityType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EntityRelation_EntityType1]') AND parent_object_id = OBJECT_ID(N'[dbo].[EntityRelation]'))
ALTER TABLE [dbo].[EntityRelation]  WITH CHECK ADD  CONSTRAINT [FK_EntityRelation_EntityType1] FOREIGN KEY([TargetEntityTypeId])
REFERENCES [dbo].[EntityType] ([EntityTypeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EntityRelation_EntityType1]') AND parent_object_id = OBJECT_ID(N'[dbo].[EntityRelation]'))
ALTER TABLE [dbo].[EntityRelation] CHECK CONSTRAINT [FK_EntityRelation_EntityType1]
GO

SET IDENTITY_INSERT [dbo].[Country] ON 
GO
	
INSERT [dbo].[Country] ([CountryId], [CountryName], [Data]) VALUES (1, N'USA', N'{
	"countryId" : 1,
	"countryName" : "USA",
	"states":  [{
		"stateId" : 1,
		"stateName" : "California",
		"abbreviation" : "CA"
	}
	]
}')
GO
SET IDENTITY_INSERT [dbo].[Country] OFF
GO
SET IDENTITY_INSERT [dbo].[EntityType] ON 

GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (1, N'Host')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (2, N'Company')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (3, N'Employee')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (4, N'Contact')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (5, N'Address')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (6, N'COA')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (7, N'PayCheck')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (8, N'RegularCheck')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (9, N'EFT')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (10, N'Deposit')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (11, N'Invoice')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (12, N'User')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (13, N'Document')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (14, N'Comment')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (15, N'Vendor')
GO
INSERT [dbo].[EntityType] ([EntityTypeId], [EntityTypeName]) VALUES (16, N'Customer')
GO
SET IDENTITY_INSERT [dbo].[EntityType] OFF
GO


USE [$(DB)Archive]
GO


/****** Object:  Schema [Common]    Script Date: 7/06/2016 12:59:59 PM ******/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Common')
DROP SCHEMA [Common]
GO
/****** Object:  Schema [Common]    Script Date: 7/06/2016 12:59:59 PM ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Common')
EXEC sys.sp_executesql N'CREATE SCHEMA [Common]'

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF_StagingData_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] DROP CONSTRAINT [DF_StagingData_DateCreated]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF__StagingData__Id__1ED998B2]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] DROP CONSTRAINT [DF__StagingData__Id__1ED998B2]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF_Memento_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Memento] DROP CONSTRAINT [DF_Memento_DateCreated]
END

GO
/****** Object:  Index [IX_Memento_1]    Script Date: 14/02/2017 4:00:37 AM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento_1')
DROP INDEX [IX_Memento_1] ON [Common].[Memento]
GO
/****** Object:  Index [IX_Memento]    Script Date: 14/02/2017 4:00:37 AM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento')
DROP INDEX [IX_Memento] ON [Common].[Memento]
GO
/****** Object:  Table [Common].[StagingData]    Script Date: 14/02/2017 4:00:37 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[StagingData]') AND type in (N'U'))
DROP TABLE [Common].[StagingData]
GO
/****** Object:  Table [Common].[Memento]    Script Date: 14/02/2017 4:00:37 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND type in (N'U'))
DROP TABLE [Common].[Memento]
GO
/****** Object:  Table [Common].[Memento]    Script Date: 14/02/2017 4:00:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND type in (N'U'))
BEGIN
CREATE TABLE [Common].[Memento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Memento] [varchar](max) NOT NULL,
	[OriginatorType] [varchar](max) NOT NULL,
	[SourceTypeId] [int] NOT NULL,
	[MementoId] [uniqueidentifier] NOT NULL,
	[Version] [decimal](18, 2) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [varchar](max) NOT NULL,
	[Comments] [varchar](max) NULL,
	[UserId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Common.Memento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [Common].[StagingData]    Script Date: 14/02/2017 4:00:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[StagingData]') AND type in (N'U'))
BEGIN
CREATE TABLE [Common].[StagingData](
	[Id] [uniqueidentifier] NOT NULL,
	[OriginatorType] [varchar](255) NOT NULL,
	[MementoId] [uniqueidentifier] NOT NULL,
	[Memento] [varchar](max) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK__StagingData] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Index [IX_Memento]    Script Date: 14/02/2017 4:00:37 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento')
CREATE NONCLUSTERED INDEX [IX_Memento] ON [Common].[Memento]
(
	[MementoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Memento_1]    Script Date: 14/02/2017 4:00:37 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento_1')
CREATE NONCLUSTERED INDEX [IX_Memento_1] ON [Common].[Memento]
(
	[SourceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF_Memento_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Memento] ADD  CONSTRAINT [DF_Memento_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF__StagingData__Id__1ED998B2]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] ADD  DEFAULT (newid()) FOR [Id]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF_StagingData_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] ADD  CONSTRAINT [DF_StagingData_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
END

GO
/****** Object:  Table [dbo].[MasterExtract]    Script Date: 14/02/2017 4:04:34 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MasterExtract]') AND type in (N'U'))
DROP TABLE [dbo].[MasterExtract]
GO
/****** Object:  Table [dbo].[MasterExtract]    Script Date: 14/02/2017 4:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MasterExtract]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MasterExtract](
	[MasterExtractId] [int] NOT NULL,
	[Extract] [varchar](max) NOT NULL,
 CONSTRAINT [PK_MasterExtract] PRIMARY KEY CLUSTERED 
(
	[MasterExtractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO




