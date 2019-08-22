IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollVoidLog]') AND type in (N'U'))
ALTER TABLE [dbo].[PayrollVoidLog] DROP CONSTRAINT IF EXISTS [DF_PayrollVoidLog_TS]
GO
/****** Object:  Table [dbo].[PayrollVoidLog]    Script Date: 16/07/2019 1:52:17 PM ******/
DROP TABLE IF EXISTS [dbo].[PayrollVoidLog]
GO
/****** Object:  Table [dbo].[PayrollVoidLog]    Script Date: 16/07/2019 1:52:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollVoidLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CompanyName] [varchar](max) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[PayDay] [datetime] NOT NULL,
	[Action] [int] NOT NULL,
	[User] [varchar](max) NOT NULL,
	[TS] [datetime] NOT NULL,
 CONSTRAINT [PK_PayrollVoidLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayrollVoidLog] ADD  CONSTRAINT [DF_PayrollVoidLog_TS]  DEFAULT (getdate()) FOR [TS]
GO
