/****** Object:  StoredProcedure [dbo].[GetExtracts]    Script Date: 14/02/2017 7:39:02 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtracts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtracts]
GO
/****** Object:  StoredProcedure [dbo].[GetExtracts]    Script Date: 14/02/2017 7:39:02 AM ******/
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
	
	select Id, StartDate, EndDate, ExtractName, IsFederal, DepositDate, Journals, LastModified, LastModifiedBy,
	case when @id is not null then
		(select Extract from PaxolArchive.dbo.MasterExtract where MasterExtractId=@id)
		else
			null
		end Extract
	from MasterExtracts
	Where 
	((@id is not null and Id=@id) or (@id is null))
	and ((@extract is not null and ExtractName=@extract) or (@extract is null))
	for Xml path('MasterExtractJson'), root('MasterExtractList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 14/02/2017 7:58:23 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 14/02/2017 7:58:23 AM ******/
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
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select HostId, CompanyId, Host, Company,
		DateDiff(day, CreationDate, getdate() ) [Days past]
	from 
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host,
		Case
			When exists(select 'x' from PaxolArchive.Common.Memento  where SourceTypeId=2 and MementoId=c.Id) Then
				(select max(DateCreated) from PaxolArchive.Common.Memento  where SourceTypeId=2 and MementoId=c.Id)
			Else
				c.LastModified
					
			
		end CreationDate
		
	from Company c, Host h 
	Where 
	c.StatusId=1
	and h.id = c.HostId
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
