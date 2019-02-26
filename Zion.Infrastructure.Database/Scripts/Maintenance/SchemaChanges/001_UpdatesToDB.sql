IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CPA_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[Host]'))
ALTER TABLE [dbo].[Host] DROP CONSTRAINT [FK_CPA_Status]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_News_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[News] DROP CONSTRAINT [DF_News_LastModified]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_News_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[News] DROP CONSTRAINT [DF_News_Id]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CPA_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Host] DROP CONSTRAINT [DF_CPA_Id]
END

GO
/****** Object:  Table [dbo].[Status]    Script Date: 10/07/2016 10:10:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Status]') AND type in (N'U'))
DROP TABLE [dbo].[Status]
GO
/****** Object:  Table [dbo].[News]    Script Date: 10/07/2016 10:10:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[News]') AND type in (N'U'))
DROP TABLE [dbo].[News]
GO
/****** Object:  Table [dbo].[Host]    Script Date: 10/07/2016 10:10:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Host]') AND type in (N'U'))
DROP TABLE [dbo].[Host]
GO
/****** Object:  Table [dbo].[Host]    Script Date: 10/07/2016 10:10:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Host]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Host](
	[Id] [uniqueidentifier] NOT NULL,
	[FirmName] [varchar](max) NOT NULL,
	[Url] [varchar](max) NOT NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[TerminationDate] [datetime] NULL,
	[StatusId] [int] NOT NULL,
	[HomePage] [varchar](max) NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
 CONSTRAINT [PK_CPA] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[News]    Script Date: 10/07/2016 10:10:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[News]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[News](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [varchar](max) NOT NULL,
	[NewsContent] [varchar](max) NOT NULL,
	[AudienceScope] [int] NULL,
	[Audience] [varchar](max) NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_News] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Status]    Script Date: 10/07/2016 10:10:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Status]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Status](
	[StatusId] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_CPA_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Host] ADD  CONSTRAINT [DF_CPA_Id]  DEFAULT (newid()) FOR [Id]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_News_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_Id]  DEFAULT (newid()) FOR [Id]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_News_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[News] ADD  CONSTRAINT [DF_News_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CPA_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[Host]'))
ALTER TABLE [dbo].[Host]  WITH CHECK ADD  CONSTRAINT [FK_CPA_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([StatusId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CPA_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[Host]'))
ALTER TABLE [dbo].[Host] CHECK CONSTRAINT [FK_CPA_Status]
GO
set identity_insert dbo.Status on
insert into Status(statusId, statusname) values(1,'Active');
insert into Status(statusId, statusname) values(2,'InActive');
insert into Status(statusId, statusname) values(3,'Terminated');
set identity_insert dbo.Status off