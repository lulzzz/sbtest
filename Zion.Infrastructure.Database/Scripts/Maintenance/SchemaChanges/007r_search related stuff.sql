/****** Object:  Table [dbo].[SearchTable]    Script Date: 19/11/2016 1:52:03 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchTable]') AND type in (N'U'))
DROP TABLE [dbo].[SearchTable]
GO
/****** Object:  StoredProcedure [dbo].[GetSearchResults]    Script Date: 19/11/2016 1:52:03 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSearchResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetSearchResults]
GO
/****** Object:  Table [dbo].[SearchTable]    Script Date: 19/11/2016 1:52:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SearchTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SourceTypeId] [int] NOT NULL,
	[SourceId] [uniqueidentifier] NOT NULL,
	[HostId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[SearchText] [varchar](max) NULL,
 CONSTRAINT [PK_SearchTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[GetSearchResults]    Script Date: 19/11/2016 1:52:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSearchResults]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetSearchResults]
	@criteria varchar(max),
	@company varchar(max) = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN

	select 
	(select SearchTable.Id, 
	case 
		when SearchTable.SourceTypeId=2 then
			''Company''
		else
			''Employee''
		end SourceTypeId, SearchTable.SourceId, SearchTable.HostId, SearchTable.CompanyId, SearchTable.SearchText
	
	from 
	SearchTable, Company, Host
	Where 
	SearchTable.HostId = Host.Id
	and SearchTable.CompanyId = Company.Id
	and ((@role is not null and @role=''Host'' and Company.IsHostCompany=0) or (@role is null))
	and ((@host is not null and SearchTable.HostId=@host) or (@host is null))
	and ((@company is not null and SearchTable.CompanyId=@company) or (@company is null))
	and SearchTable.SearchText like ''%'' + @criteria + ''%''
	for xml path (''SearchResult''), elements, type
	) Results
	for xml path(''SearchResults''), ELEMENTS, type


END' 
END
GO

