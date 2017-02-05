/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 5/02/2017 10:56:57 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetHostAndCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 5/02/2017 10:56:57 AM ******/
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
				(select InvoiceSetup from CompanyContract cc where cc.CompanyId=Company.Id) InvoiceSetup,
				CompanyAddress, FederalEIN,
				(select * from CompanyTaxState Where CompanyId=Company.Id for xml auto, elements, type) CompanyTaxStates, 
				(select * from InsuranceGroup Where Id=Company.InsuranceGroupNo for xml auto, elements, type)
			from Company
			where 
			((@company is not null and Id=@company) or (@company is null))
			and (
					(@role is not null and @role=''HostStaff'' and IsHostCompany=0) 
					or (@role is not null and @role=''CorpStaff'' and IsHostCompany=0) 
					or (@role is null)
				)
			for xml path (''CompanyListItem''), elements, type
		)Companies
	for xml path(''HostAndCompanies'')
	

END' 
END
GO
