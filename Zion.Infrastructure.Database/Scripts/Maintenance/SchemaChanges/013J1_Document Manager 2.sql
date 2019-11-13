IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Document_DocumentType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Document]'))
ALTER TABLE [dbo].[Document] DROP CONSTRAINT [FK_Document_DocumentType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Document_CompanyDocumentSubType]') AND parent_object_id = OBJECT_ID(N'[dbo].[Document]'))
ALTER TABLE [dbo].[Document] DROP CONSTRAINT [FK_Document_CompanyDocumentSubType]
GO
/****** Object:  Table [dbo].[Document]    Script Date: 13/11/2019 7:03:35 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Document]') AND type in (N'U'))
DROP TABLE [dbo].[Document]
GO
/****** Object:  Table [dbo].[Document]    Script Date: 13/11/2019 7:03:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Document](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SourceEntityTypeId] [int] NOT NULL,
	[SourceEntityId] [uniqueidentifier] NOT NULL,
	[TargetEntityId] [uniqueidentifier] NOT NULL,
	[Type] [int] NOT NULL,
	[CompanyDocumentSubType] [int] NULL,
	[TargetObject] [varchar](max) NOT NULL,
	[Uploaded] [datetime] NOT NULL,
	[UploadedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Document] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Document]  WITH CHECK ADD  CONSTRAINT [FK_Document_CompanyDocumentSubType] FOREIGN KEY([CompanyDocumentSubType])
REFERENCES [dbo].[CompanyDocumentSubType] ([Id])
GO
ALTER TABLE [dbo].[Document] CHECK CONSTRAINT [FK_Document_CompanyDocumentSubType]
GO
ALTER TABLE [dbo].[Document]  WITH CHECK ADD  CONSTRAINT [FK_Document_DocumentType] FOREIGN KEY([Type])
REFERENCES [dbo].[DocumentType] ([Id])
GO
ALTER TABLE [dbo].[Document] CHECK CONSTRAINT [FK_Document_DocumentType]
GO


update DocumentType set CollectMetaData=1 where Id=3;