/****** Object:  StoredProcedure [dbo].[GetExtractDataSpecial]    Script Date: 10/07/2019 12:14:00 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetExtractDataSpecial]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 10/07/2019 12:14:00 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 10/07/2019 12:14:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExtractData]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0,
	@includeHistory bit = 0
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@depositSchedule1 int = @depositSchedule,
	@report1 varchar(max)=@report,
	@host1 uniqueidentifier = @host,
	@includeVoids1 bit = @includeVoids,
	@includeHistoryL bit = @includeHistory

	select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and ((@depositSchedule1 is not null and host.DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
		and c.StatusId<>3
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and ((@report1<>'HostWCReport' and ManageEFileForms=1 and ManageTaxPayment=1) or (@report1='HostWCReport'))
		and ((@depositSchedule1 is not null and DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and HostId=@host1) or (@host1 is null))
				and ParentId is null
		and StatusId<>3
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and ((@report1<>'HostWCReport' and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1) or (@report1='HostWCReport'))
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and ((@depositSchedule1 is not null and Parent.DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and Parent.HostId=@host1) or (@host1 is null))
		and Company.StatusId<>3
	)a

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=List.FilingCompanyId
		for xml path ('HostCompany'), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Company.Id
		for xml path ('ExtractTaxState'), ELEMENTS, type
	) States,
	(
		select *
		from
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(
				select *
				from PayrollPayCheck where CompanyId=ExtractCompany.Id 
				and IsVoid=0
				and taxpayday between @startdate1 and @enddate1
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=1)
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report1<>'Report1099'
				and IsHistory<=@includeHistoryL
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) PayChecks,
			(
				select *
				 from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=1)
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=2)
				and VoidedOn between @startdate1 and @enddate1
				and year(taxpayday)=year(@startdate1)
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report1<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from CheckbookJournal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @report1='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts,
	(
		select *
		from
		MasterExtracts where ExtractName=@report1 and year(startdate)=year(@startdate1)
		and Id=0
		for xml path ('MasterExtractDB'), ELEMENTS, type
	) History
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractDataSpecial]    Script Date: 10/07/2019 12:14:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExtractDataSpecial]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0,
	@includeHistory bit = 0
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@depositSchedule1 int = @depositSchedule,
	@report1 varchar(max) = @report,
	@host1 uniqueidentifier = @host,
	@includeVoids1 bit = @includeVoids,
	@includeHistoryL bit = @includeHistory

	select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and ((@depositSchedule1 is not null and host.DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
		and c.StatusId<>3
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and ((@report1<>'HostWCReport' and ManageEFileForms=1 and ManageTaxPayment=1) or (@report1='HostWCReport'))
		and ((@depositSchedule1 is not null and DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and HostId=@host1) or (@host1 is null))
		and ParentId is null
		and StatusId<>3
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and ((@report1<>'HostWCReport' and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1) or (@report1='HostWCReport'))
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and ((@depositSchedule1 is not null and Parent.DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and Parent.HostId=@host1) or (@host1 is null))
		and Company.StatusId<>3
	)a

	select distinct p.Id into #tmpp
	from Payroll p
	where 
	payday between @startdate1 and @enddate1
	and p.Id not in (
	select distinct p1.Id 
	from Payroll p1, Company c , PayrollInvoice pi
	where month(p1.PayDay)<>month(p1.TaxPayDay)
	and p1.CompanyId=c.Id
	and p1.InvoiceId=pi.Id
	)

	

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=List.FilingCompanyId
		for xml path ('HostCompany'), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Company.Id
		for xml path ('ExtractTaxState'), ELEMENTS, type
	) States,
	(
		select *
		from
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(
				select *
				from PayrollPayCheck where CompanyId=ExtractCompany.Id 
				and IsVoid=0
				and PayrollId in (select Id from #tmpp)
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=1)
				and InvoiceId is not null
				and payday between @startdate1 and @enddate1
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report1<>'Report1099'
				and IsHistory<=@includeHistoryL
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) PayChecks,
			(
				select *
				 from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=1)
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=2)
				and PayrollId in (select Id from #tmpp)
				and VoidedOn between @startdate1 and @enddate1
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report1<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from CheckbookJournal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @report1='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts,
	(
		select *
		from
		MasterExtracts where ExtractName=@report1 and year(startdate)=year(@startdate1)
		and Id=0
		for xml path ('MasterExtractDB'), ELEMENTS, type
	) History
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	

END
GO
