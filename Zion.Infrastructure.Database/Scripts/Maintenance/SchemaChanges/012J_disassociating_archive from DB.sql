/****** Object:  StoredProcedure [dbo].[GetExtracts]    Script Date: 26/09/2018 7:08:14 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtracts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtracts]
GO
/****** Object:  StoredProcedure [dbo].[GetExtracts]    Script Date: 26/09/2018 7:08:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtracts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtracts] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtracts]
	@extract varchar(max) = null,
	@id int = null
	
AS
BEGIN
	
	select Id, StartDate, EndDate, ExtractName, IsFederal, DepositDate, Journals, LastModified, LastModifiedBy, ConfirmationNo, ConfirmationNoUser, ConfirmationNoTS
	, 
	null Extract
	from MasterExtracts
	Where 
	((@id is not null and Id=@id) or (@id is null))
	and ((@extract is not null and ExtractName=@extract) or (@extract is null))
	for Xml path('MasterExtractJson'), root('MasterExtractList') , elements, type
		
	

END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF_StagingData_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] DROP CONSTRAINT [DF_StagingData_DateCreated]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF__StagingData__Id__1367E606]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] DROP CONSTRAINT [DF__StagingData__Id__1367E606]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF_Memento_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Memento] DROP CONSTRAINT [DF_Memento_DateCreated]
END

GO
/****** Object:  Index [IX_Memento_1]    Script Date: 27/09/2018 6:45:09 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento_1')
DROP INDEX [IX_Memento_1] ON [Common].[Memento]
GO
/****** Object:  Index [IX_Memento]    Script Date: 27/09/2018 6:45:09 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento')
DROP INDEX [IX_Memento] ON [Common].[Memento]
GO
/****** Object:  Table [Common].[StagingData]    Script Date: 27/09/2018 6:45:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[StagingData]') AND type in (N'U'))
DROP TABLE [Common].[StagingData]
GO
/****** Object:  Table [Common].[Memento]    Script Date: 27/09/2018 6:45:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND type in (N'U'))
DROP TABLE [Common].[Memento]
GO
/****** Object:  Table [Common].[Memento]    Script Date: 27/09/2018 6:45:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND type in (N'U'))
BEGIN
CREATE TABLE [Common].[Memento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
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
/****** Object:  Table [Common].[StagingData]    Script Date: 27/09/2018 6:45:09 PM ******/
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
/****** Object:  Index [IX_Memento]    Script Date: 27/09/2018 6:45:09 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento')
CREATE NONCLUSTERED INDEX [IX_Memento] ON [Common].[Memento]
(
	[MementoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Memento_1]    Script Date: 27/09/2018 6:45:09 PM ******/
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF__StagingData__Id__1367E606]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] ADD  DEFAULT (newid()) FOR [Id]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF_StagingData_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[StagingData] ADD  CONSTRAINT [DF_StagingData_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
END

GO

declare @dbname  as varchar(max);
select @dbname = db_name();
if @dbname<>'PaxolTest' and @dbname<>'PaxolOP' and @dbname<>'PaxolOnline'
begin
print 'inserting archive data'
SET IDENTITY_INSERT [Common].[Memento] ON ;

insert into Common.Memento([Id],[OriginatorType],[SourceTypeId]      ,[MementoId]      ,[Version]      ,[DateCreated]      ,[CreatedBy]      ,[Comments]      ,[UserId]) 
select [Id]
      ,[OriginatorType]
      ,[SourceTypeId]
      ,[MementoId]
      ,[Version]
      ,[DateCreated]
      ,[CreatedBy]
      ,[Comments]
      ,[UserId] from PaxolArchive.Common.Memento

SET IDENTITY_INSERT [Common].[Memento] OFF


INSERT INTO [Common].[StagingData]([Id]
      ,[OriginatorType]
      ,[MementoId]
      ,[Memento]
      ,[DateCreated])
SELECT [Id]
      ,[OriginatorType]
      ,[MementoId]
      ,[Memento]
      ,[DateCreated]
FROM [PAXOLARCHIVE].[Common].[StagingData];
end
Go
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 28/09/2018 11:19:56 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 28/09/2018 11:19:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompaniesWithoutPayroll] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 'GetCompaniesWithoutPayroll' Report;
	select HostId, CompanyId, Host, Company, InvoiceSetup,
		DateDiff(day, CreationDate, getdate() ) [Days past]
	from 
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup,
		Case
			When exists(select 'x' from Common.Memento  where SourceTypeId=2 and MementoId=c.Id) Then
				(select max(DateCreated) from Common.Memento  where SourceTypeId=2 and MementoId=c.Id)
			Else
				c.LastModified
					
			
		end CreationDate
		
	from Company c, Host h , CompanyContract cc
	Where 
	c.StatusId=1
	and h.id = c.HostId
	and c.Id = cc.CompanyId
		and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from Payroll where CompanyId=c.Id)
	)a
	where 
	DateDiff(day, CreationDate, getdate() )>0
	
END
GO


