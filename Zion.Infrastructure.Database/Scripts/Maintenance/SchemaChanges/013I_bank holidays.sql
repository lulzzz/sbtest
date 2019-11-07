/****** Object:  Table [dbo].[Holidays]    Script Date: 7/11/2019 5:52:54 PM ******/
DROP TABLE IF EXISTS [dbo].[Holidays]
GO
/****** Object:  Table [dbo].[Holidays]    Script Date: 7/11/2019 5:52:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Holidays](
	[Year] [int] NOT NULL,
	[Holiday] [datetime] NOT NULL,
 CONSTRAINT [PK_Holidays] PRIMARY KEY CLUSTERED 
(
	[Year] ASC,
	[Holiday] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


