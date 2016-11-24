IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'News'
                 AND COLUMN_NAME = 'IsActive')
Alter table News Add IsActive bit not null default(1);

insert into TaxYearRate(TaxId, TaxYear, Rate, AnnualMaxPerEmployee, TaxRateLimit)
select taxid, 2017, rate, annualmaxperemployee, taxratelimit from TaxYearRate where taxyear=2016 and not exists(select 'x' from TaxYearRate where TaxYear=2017);

/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 23/11/2016 6:03:03 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 23/11/2016 6:03:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
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
			When exists(select ''x'' from Common.Memento  where SourceTypeId=2 and MementoId=c.Id) Then
				(select max(DateCreated) from Common.Memento  where SourceTypeId=2 and MementoId=c.Id)
			Else
				c.LastModified
					
			
		end CreationDate
		
	from Company c, Host h 
	Where 
	c.StatusId=1
	and h.id = c.HostId
		and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and (c.HostId<>@rootHost or (c.HostId=@rootHost and c.IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select ''x'' from Payroll where CompanyId=c.Id)
	)a
	where 
	DateDiff(day, CreationDate, getdate() )>0
END' 
END
GO

/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 24/11/2016 9:15:44 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 24/11/2016 9:15:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetExtractData]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0
AS
BEGIN
	select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and ((@depositSchedule is not null and host.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and c.HostId=@host) or (@host is null))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 and ManageEFileForms=1 and ManageTaxPayment=1
		and ((@depositSchedule is not null and DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and HostId=@host) or (@host is null))
	)a

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=Host.CompanyId
		for xml path (''HostCompany''), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Host.CompanyId
		for xml path (''ExtractTaxState''), ELEMENTS, type
	) States,
	(
		select *
		from
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and SourceEntityId=Host.CompanyId
		)a
		for xml path (''ExtractContact''), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(
				select * from PayrollPayCheck where CompanyId=ExtractCompany.Id 
				and IsVoid<=@includeVoids
				and payday between @startdate and @enddate
				and not exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and (InvoiceId is null or not exists(select ''x'' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path (''ExtractPayCheck''), ELEMENTS, type
			) PayChecks,
			(
				select * from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and not exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=2)
				and VoidedOn between @startdate and @enddate
				and year(PayDay)=year(@startdate)
				and (InvoiceId is null or not exists(select ''x'' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path (''ExtractPayCheck''), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from Journal where CompanyId=ExtractCompany.Id and TransactionType=2 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				for xml path (''ExtractVendor''), ELEMENTS, type
			)Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Host.CompanyId)
		for xml path (''ExtractDBCompany''), Elements, type

	)Companies
	 from
	Host, (select distinct FilingCompanyId, Host from #tmpComp) List
	where Host.Id=List.Host
	and Host.CompanyId=List.FilingCompanyId
	for xml path(''ExtractHostDB''), ELEMENTS, type
	) Hosts,
	(
		select *
		from
		MasterExtracts where ExtractName=@report and year(startdate)=year(@startdate)
		for xml path (''MasterExtractDB''), ELEMENTS, type
	) History
	for xml path(''ExtractResponseDB''), ELEMENTS, type
	
	

END
' 
END
GO

