/****** Object:  StoredProcedure [dbo].[GetCommissionPerformanceChart]    Script Date: 18/04/2017 10:06:25 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionPerformanceChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCommissionPerformanceChart]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionPerformanceChart]    Script Date: 18/04/2017 10:06:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionPerformanceChart]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCommissionPerformanceChart] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCommissionPerformanceChart]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @users varchar(max)
	declare @query varchar(max)	

	select (u.FirstName + ' ' + u.LastName) [User], LEFT(datename(month,InvoiceDate),3) + ' ' + Right(cast(year(InvoiceDate) as varchar),2) Month, Commission
	into #tmpInspectionData
	from PayrollInvoice i, AspNetUsers u, Company c
	where 
		i.SalesRep=u.Id
		and i.CompanyId = c.Id
		and c.StatusId=1

		
	SELECT @users = COALESCE(@users + ',[' + cast([User] as varchar) + ']','[' + cast([User] as varchar)+ ']')
	FROM (select distinct [User] from #tmpInspectionData)a
	

	set @query = 'select Month, ' +@users+ ' from (select Data.Month,'+@users+' from
	(select Month, [User], Commission
	from #tmpInspectionData
	) o
	PIVOT (sum(Commission) for [User] in ('+@users+'))Data)t order by convert(datetime, ''01 ''+Month, 6)'
	
	select 'GetCommissionPerformanceChart' Report;			
	execute(@query)
	drop table #tmpInspectionData
END
GO

/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 18/04/2017 10:07:13 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetHostAndCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 18/04/2017 10:07:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetHostAndCompanies] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetHostAndCompanies]
	@host varchar(max) = null,
	@company varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select 
		(
			select Id, FirmName, Url, EffectiveDate, CompanyId, HomePage,
			(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=1 and SourceEntityId=Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact,
			(select DirectDebitPayer from Company where HostId=Host.Id and IsHostCompany=1) IsHostAllowsDirectDebit
			from Host 
			where ((@host is not null and Id=@host) or (@host is null))
			for xml path ('HostListItem'), elements, type
		)Hosts,
		(
			select Id, HostId, CompanyName Name, CompanyNumber, CompanyNo, LastPayrollDate, FileUnderHost, IsHostCompany, Created, 
				case StatusId When 1 then 'Active' When 2 then 'InActive' else 'Terminated' end StatusId,
				(select InvoiceSetup from CompanyContract cc where cc.CompanyId=Company.Id) InvoiceSetup,
				CompanyAddress, FederalEIN,
				(select * from CompanyTaxState Where CompanyId=Company.Id for xml auto, elements, type) CompanyTaxStates, 
				(select * from InsuranceGroup Where Id=Company.InsuranceGroupNo for xml auto, elements, type),
				(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
			from Company
			where 
			((@company is not null and Id=@company) or (@company is null))
			and (
					(@role is not null and @role='HostStaff' and IsHostCompany=0) 
					or (@role is not null and @role='CorpStaff' and IsHostCompany=0) 
					or (@role is null)
				)
			for xml path ('CompanyListItem'), elements, type
		)Companies
	for xml path('HostAndCompanies')
	

END
GO
