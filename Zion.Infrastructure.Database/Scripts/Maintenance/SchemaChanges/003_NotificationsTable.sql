/****** Object:  Table [dbo].[Notifications]    Script Date: 25-11-2014 12:31:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

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

GO

SET ANSI_PADDING OFF
GO

