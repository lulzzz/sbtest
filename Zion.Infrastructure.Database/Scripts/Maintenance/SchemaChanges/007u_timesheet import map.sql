/****** Object:  Table [dbo].[CompanyTSImportMap]    Script Date: 25/11/2016 8:17:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyTSImportMap]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyTSImportMap]
GO
/****** Object:  Table [dbo].[CompanyTSImportMap]    Script Date: 25/11/2016 8:17:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyTSImportMap]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyTSImportMap](
	[CompanyId] [uniqueidentifier] NOT NULL,
	[TimeSheetImportMap] [varchar](max) NOT NULL,
 CONSTRAINT [PK_CompanyTSImportMap] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
