/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 1/11/2016 5:56:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 1/11/2016 5:56:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtractData]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null
AS
BEGIN
	select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		union
		select id CompanyId, id FilingCompanyId
		from Company
		where FileUnderHost=0 and ManageEFileForms=1 and ManageTaxPayment=1
		and ((@depositSchedule is not null and DepositSchedule941=@depositSchedule) or @depositSchedule is null)
	)a

	
	select
		(select
			c.*,
			(
				select * from CompanyTaxState where CompanyId=c.Id
				for xml path (''ExtractTaxState''), ELEMENTS, type
			) States,
			(
				select * from Host where Id=c.hostId
				for xml auto , ELEMENTS, type
			) ,
			(
				select *
				from
				(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=c.HostId
				Union
				select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and SourceEntityId=c.Id
				)a
				for xml path (''ExtractContact''), ELEMENTS, type
			) Contacts,
			(
				select * from PayrollPayCheck where CompanyId in (select companyid from #tmpComp where FilingCompanyId=c.id) and IsVoid=0 and payday between @startdate and @enddate
				for xml path (''ExtractPayCheck''), ELEMENTS, type
			) PayChecks,
			(
				select * from PayrollPayCheck 
				where CompanyId in (select companyid from #tmpComp where FilingCompanyId=c.id) 
				and IsVoid=1 and TaxesPaidOn is not null and TaxesCreditedOn is null and VoidedOn between @startdate and @enddate
				and (InvoiceId is null or not exists(select ''x'' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path (''ExtractPayCheck''), ELEMENTS, type
			) VoidedPayChecks
			from Company c
			where 
			c.Id in (select distinct filingcompanyid from #tmpComp)
		for xml path (''ExtractDBCompany''), ELEMENTS, type
		) Companies
	for xml path(''ExtractReportDB''), ELEMENTS, type

END' 
END
GO
