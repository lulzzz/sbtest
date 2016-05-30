/****** Object:  Table [Common].[Mementos]    Script Date: 12/19/2014 15:05:40 ******/
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Default [DF__Mementos__Id__498EEC8D]    Script Date: 12/19/2014 15:05:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[Common].[DF__Mementos__Id__14270015]') AND parent_object_id = OBJECT_ID(N'[Common].[Mementos]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Mementos__Id__14270015]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Mementos] ADD  DEFAULT (newid()) FOR [Id]
END


End
GO
/****** Object:  Default [DF__Mementos__Versio__4A8310C6]    Script Date: 12/19/2014 15:05:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[Common].[DF__Mementos__Versio__151B244E]') AND parent_object_id = OBJECT_ID(N'[Common].[Mementos]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Mementos__Versio__151B244E]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Mementos] ADD  DEFAULT ((1)) FOR [Version]
END


End
GO
/****** Object:  Default [DF_Mementos_DateCreated]    Script Date: 12/19/2014 15:05:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[Common].[DF_Mementos_DateCreated]') AND parent_object_id = OBJECT_ID(N'[Common].[Mementos]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Mementos_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Mementos] ADD  CONSTRAINT [DF_Mementos_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
END


End
GO
