/****** Object:  StoredProcedure [dbo].[GetUserDashboard]    Script Date: 15/01/2017 6:22:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetUserDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 15/01/2017 6:22:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetHostAndCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 15/01/2017 6:22:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetHostAndCompanies]
	@host varchar(max) = null,
	@company varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select 
		(
			select Id, FirmName, Url, EffectiveDate, CompanyId		
			from Host 
			where ((@host is not null and Id=@host) or (@host is null))
			for xml path (''HostListItem''), elements, type
		)Hosts,
		(
			select Id, HostId, CompanyName Name, CompanyNumber, CompanyNo, LastPayrollDate, FileUnderHost, IsHostCompany, Created, 
				case StatusId When 1 then ''Active'' When 2 then ''InActive'' else ''Terminated'' end StatusId,
				(select InvoiceSetup from CompanyContract cc where cc.CompanyId=Company.Id) InvoiceSetup
			from Company
			where 
			((@company is not null and Id=@company) or (@company is null))
			and (
					(@role is not null and @role=''HostStaff'' and IsHostCompany=0) 
					or (@role is not null and @role=''CorpStaff'' and (HostId<>@rootHost or (HostId=@rootHost and IsHostCompany=0))) 
					or (@role is null)
				)
			for xml path (''CompanyListItem''), elements, type
		)Companies
	for xml path(''HostAndCompanies'')
	

END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserDashboard]    Script Date: 15/01/2017 6:22:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserDashboard]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetUserDashboard]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	select ''GetCompaniesNextPayrollChartData'' Report;
	exec GetCompaniesNextPayrollChartData @startdate, @enddate, @host, @role;
	select ''GetCompaniesWithoutPayroll'' Report;
	exec GetCompaniesWithoutPayroll @startdate, @enddate, @host, @role;
	select ''GetInvoiceChartData'' Report;
	exec GetInvoiceChartData @startdate, @enddate, @host, @role;
	select ''GetPayrollChartData'' Report;
	exec GetPayrollChartData @startdate, @enddate, @host, @role;
	select ''GetPayrollsWithoutInvoice'' Report;
	exec GetPayrollsWithoutInvoice @startdate, @enddate, @host, @role;
	
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetSearchResults]    Script Date: 15/01/2017 8:00:50 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSearchResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetSearchResults]
GO
/****** Object:  StoredProcedure [dbo].[GetSearchResults]    Script Date: 15/01/2017 8:00:50 PM ******/
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
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
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
	and (
			(@role is not null and @role=''HostStaff'' and Company.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and (Company.HostId<>@rootHost or (Company.HostId=@rootHost and IsHostCompany=0))) 
			or (@role is null)
		)
	and ((@host is not null and SearchTable.HostId=@host) or (@host is null))
	and ((@company is not null and SearchTable.CompanyId=@company) or (@company is null))
	and SearchTable.SearchText like ''%'' + @criteria + ''%''
	for xml path (''SearchResult''), elements, type
	) Results
	for xml path(''SearchResults''), ELEMENTS, type


END' 
END
GO
