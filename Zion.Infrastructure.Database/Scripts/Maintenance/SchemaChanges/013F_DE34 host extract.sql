/****** Object:  StoredProcedure [dbo].[GetExtractDE34]    Script Date: 3/09/2019 6:35:00 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetExtractDE34]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractDE34]    Script Date: 3/09/2019 6:35:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExtractDE34]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeDailyAccumulation bit = 0,
	@includeMonthlyAccumulation bit = 0,
	@includePayCodes bit = 0,
	@includeHistory bit = 0,
	@includeC1095 bit =0,
	@CheckEFileFormsFlag bit = 1,
	@CheckTaxPaymentFlag bit = 1,
	@extractDepositName varchar(max) = ''
	
AS
BEGIN
declare @startdateL datetime = @startdate,
	@enddateL datetime = @enddate,
	@depositScheduleL int = @depositSchedule,
	@reportL varchar(max) = @report,
	@hostL uniqueidentifier = @host,
	@includeVoidsL bit = @includeVoids,
	@includeTaxesL bit = @includeTaxes,
	@includeDeductionsL bit = @includeDeductions,
	@includeCompensationsL bit = @includeCompensations,
	@includeWorkerCompensationsL bit = @includeWorkerCompensations,
	@includeDailyAccumulationL bit = @includeDailyAccumulation,
	@includeMonthlyAccumulationL bit = @includeMonthlyAccumulation,
	@includePayCodesL bit = @includePayCodes,
	@includeHistoryL bit = @includeHistory,
	@includeC1095L bit =@includeC1095,
	@CheckEFileFormsFlagL bit = @CheckEFileFormsFlag,
	@CheckTaxPaymentFlagL bit = @CheckTaxPaymentFlag,
	@extractDepositNameL varchar(max) = @extractDepositName
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpComp')
)
DROP TABLE #tmpComp;

select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and host.StatusId<>3
		and ((@depositScheduleL is not null and host.DepositSchedule941=@depositScheduleL) or @depositScheduleL is null)
		and ((@hostL is not null and c.HostId=@hostL) or (@hostL is null))
		and ((@includeC1095L=1 and host.IsFiler1095=1) or (@includeC1095L=0))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and ((@CheckEFileFormsFlagL=1 and ManageEFileForms=1 ) or @CheckEFileFormsFlagL=0)
		and ((@CheckTaxPaymentFlagL=1 and ManageTaxPayment=1 )  or @CheckTaxPaymentFlagL=0)
		and ((@depositScheduleL is not null and DepositSchedule941=@depositScheduleL) or @depositScheduleL is null)
		and ((@hostL is not null and HostId=@hostL) or (@hostL is null))
		and ParentId is null
		and StatusId<>3
		and ((@includeC1095L=1 and IsFiler1095=1) or (@includeC1095L=0))
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and ((@CheckEFileFormsFlagL=1 and Parent.ManageEFileForms=1 ) or @CheckEFileFormsFlagL=0)
		and ((@CheckTaxPaymentFlagL=1 and Parent.ManageTaxPayment=1 )  or @CheckTaxPaymentFlagL=0)
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and Company.StatusId<>3
		and ((@depositScheduleL is not null and Parent.DepositSchedule941=@depositScheduleL) or @depositScheduleL is null)
		and ((@hostL is not null and Parent.HostId=@hostL) or (@hostL is null))
		and ((@includeC1095L=1 and Parent.IsFiler1095=1) or (@includeC1095L=0))
	)a
	

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*,
		(
			select 
			isnull(ctr.Id,0) Id, Company.Id CompanyId, t.Id TaxId, t.Code as TaxCode, year(@startdateL) TaxYear, isnull(ctr.Rate, t.defaultrate) Rate
			from Tax t left outer join CompanyTaxRate ctr on t.Id=ctr.TaxId and ctr.TaxYear=year(@startdateL) and CompanyId=Company.Id
			where t.IsCompanySpecific=1
			for xml path('CompanyTaxRate'), Elements, type
		) CompanyTaxRates,
		case when @includeC1095L=1 then
		(select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
			(select Id, Name, 
			case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
			from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
		from CompanyDeduction Where CompanyId=Company.Id 
		for xml path('CompanyDeduction'), elements, type) 
		end Deductions		
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
		(select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			Company.Id CompanyId, Company.CompanyName, Company.FederalEIN FEIN, Company.FederalPin FPIN,
			(
				select CompanyTaxState.* from CompanyTaxState where CompanyId=Company.Id
				for xml path('ExtractTaxState'), Elements, type
			) States,
			(
				select * from Employee where CompanyId=ExtractCompany.Id
				and StatusId=1 and HireDate>=@startdateL
				and ((@enddateL is not null and HireDate<=@enddateL) or (@enddateL is null))
				for xml path('EmployeeMinifiedJson'), Elements, type
			)Employees
			
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		and exists(select 'x' from Employee where CompanyId=ExtractCompany.Id and StatusId=1 and HireDate>=@startdateL and HireDate<=@enddateL)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractAccumulationReverse]    Script Date: 13/09/2019 6:50:56 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetExtractAccumulationReverse]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractAccumulationReverse]    Script Date: 13/09/2019 6:50:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExtractAccumulationReverse]
	@depositSchedule int = null,
	@report varchar(max),
	@masterExtractId int,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeDailyAccumulation bit = 0,
	@includeMonthlyAccumulation bit = 0,
	@includePayCodes bit = 0,
	@includeHistory bit = 0,
	@includeC1095 bit =0,
	@CheckEFileFormsFlag bit = 1,
	@CheckTaxPaymentFlag bit = 1,
	@extractDepositName varchar(max) = ''
	
AS
BEGIN
declare @depositScheduleL int = @depositSchedule,
	@reportL varchar(max) = @report,
	@masterExtractIdL int = @masterExtractId,
	@includeVoidsL bit = @includeVoids,
	@includeTaxesL bit = @includeTaxes,
	@includeDeductionsL bit = @includeDeductions,
	@includeCompensationsL bit = @includeCompensations,
	@includeWorkerCompensationsL bit = @includeWorkerCompensations,
	@includeDailyAccumulationL bit = @includeDailyAccumulation,
	@includeMonthlyAccumulationL bit = @includeMonthlyAccumulation,
	@includePayCodesL bit = @includePayCodes,
	@includeHistoryL bit = @includeHistory,
	@includeC1095L bit =@includeC1095,
	@CheckEFileFormsFlagL bit = @CheckEFileFormsFlag,
	@CheckTaxPaymentFlagL bit = @CheckTaxPaymentFlag,
	@extractDepositNameL varchar(max) = @extractDepositName,
	@startDateL datetime, @endDateL dateTime
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpComp')
)
DROP TABLE #tmpComp;

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpVoids')
)
DROP TABLE #tmpVoids;

create table #tmp(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

create table #tmpVoids(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpVoidPaycheckCompanyId] ON #tmpVoids
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

select @startDateL=StartDate, @endDateL=EndDate from MasterExtracts where Id=@masterExtractIdL;

	insert into #tmp(Id, CompanyId)
	select pc1.Id, pc1.CompanyId
	from PayrollPayCheck pc1, PayCheckExtract pce
	where pc1.Id=pce.PayrollPayCheckId
	and pce.MasterExtractId=@masterExtractIdL;

	
declare @year as varchar(max)=cast(year(@startdateL) as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@year
	declare @quarter3ed smalldatetime='9/30/'+@year
	declare @quarter4sd smalldatetime='10/1/'+@year
	declare @quarter4ed smalldatetime='12/31/'+@year

	declare @month int = month(@enddateL)
	

select * into #tmpComp
	from
	(
		
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where Id in (select distinct CompanyId from #tmp)
	)a
	

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*,
		(
			select 
			isnull(ctr.Id,0) Id, Company.Id CompanyId, t.Id TaxId, t.Code as TaxCode, year(@startdateL) TaxYear, isnull(ctr.Rate, t.defaultrate) Rate
			from Tax t left outer join CompanyTaxRate ctr on t.Id=ctr.TaxId and ctr.TaxYear=year(@startdateL) and CompanyId=Company.Id
			where t.IsCompanySpecific=1
			for xml path('CompanyTaxRate'), Elements, type
		) CompanyTaxRates,
		case when @includeC1095L=1 then
		(select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
			(select Id, Name, 
			case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
			from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
		from CompanyDeduction Where CompanyId=Company.Id 
		for xml path('CompanyDeduction'), elements, type) 
		end Deductions		
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
		(select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			
			(select 
				case when @includeC1095L=0 then
				(
				select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
					sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
					sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
					sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
					sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
					sum(Immigrants) as Immigrants, sum(Twelve1) Twelve1, sum(Twelve2) Twelve2, sum(Twelve3) Twelve3,
					case when @extractDepositNameL='' then 0 else dbo.GetExtractDepositAmount(@extractDepositNameL, ExtractCompany.Id, @startdateL, @enddateL) end DepositAmount,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('Federal940', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmount940,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('Federal941', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmount941,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('StateCAPIT', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmountCAPIT,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('StateCAUI', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmountCAUI
				from (
						select 
						pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
						case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
						case when month(pc.TaxPayDay)=@month-2 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve1,
						case when month(pc.TaxPayDay)=@month-1 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve2,
						case when month(pc.TaxPayDay)=@month and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve3,
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.Amount else 0 end) Quarter1FUTA,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter2FUTA,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter3FUTA,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter4FUTA,
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter1FUTAWage,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter2FUTAWage,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter3FUTAWage,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter4FUTAWage
						from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
						where pc.Id=pct.PayCheckId
						and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
						and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
						
						and @reportL<>'Report1099'
						group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.TaxPayDay, pc.StartDate, pc.EndDate
					)a
			
				for xml path('PayCheckWages'), elements, type
			) end,
			case when @includeC1095L=0 then
			(
				select pc.Id, pc.TaxPayDay as PayDay, pc.PaymentMethod, pc.CheckNumber, e.FirstName, e.LastName, pc.GrossWage, pc.PEOASOCoCheck, pc.NetWage, pc.IsVoid, pc.CompanyId,
				pc.IsReIssued, pc.OriginalCheckNumber, pc.ReIssuedDate
				from PayrollPayCheck pc, Employee e
				where pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				for xml path('PayCheckSummary'), elements, type

			) end PayCheckList,
			case when @includeDailyAccumulationL=1 then
			(
				
				select 
				month(pc.TaxPayDay) Month, day(pc.TaxPayDay) Day,
				sum(case when t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
				from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
				where pc.Id=pct.PayCheckId
				and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				group by pc.TaxPayDay
				for xml path('DailyAccumulation'), elements, type
				
				
			) end DailyAccumulations,
			case when @includeMonthlyAccumulationL=1 then
			(
				select 
				month(pc.TaxPayDay) Month,
				sum(case when t.Id<6 then pct.Amount else 0 end) IRS941,
				sum(case when t.Id=6 then pct.Amount else 0 end) IRS940,
				sum(case when t.Id between 7 and 10 then pct.Amount else 0 end) EDD
				from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t
				where pc.Id=pct.PayCheckId
				and pct.TaxId=ty.Id and ty.TaxId=t.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by month(pc.TaxPayDay)
				for xml path('MonthlyAccumulation'), elements, type
			) end MonthlyAccumulations,
			case when @includeTaxesL=1 then
			(select pt.TaxId, 
				(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
								case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
								from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
				sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
				from PayCheckTax pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
						
				group by pt.taxid
				for xml path('PayCheckTax'), elements, type
			) end Taxes,
			case when @includeDeductionsL=1 then
			(select pt.CompanyDeductionId,
			
				sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
				(
					select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
						(select Id, Name, 
						case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
						from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
					from CompanyDeduction Where Id=pt.CompanyDeductionId 
					for xml path('CompanyDeduction'), elements, type
				) 
				from PayCheckDeduction pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id) 
						
				group by pt.CompanyDeductionId
				for xml path('PayCheckDeduction'), elements, type
			) end Deductions,
			case when @includeCompensationsL=1 then
			(select pt.PayTypeId,
				p.Name PayTypeName,
				sum(pt.Amount) YTD
				from PayCheckCompensation pt, PayType p
				where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id) 
							
				group by pt.PayTypeId, p.Name
				for xml path('PayCheckCompensation'), elements, type
			) end Compensations,
			case when @includePayCodesL=1 then
			(select pt.PayCodeId,
			
				sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
				from PayCheckPayCode pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by pt.PayCodeId
				for xml path('PayCheckPayCode'), elements, type
			) end PayCodes,
			case when @includeWorkerCompensationsL=1 then
			(select pt.WorkerCompensationId,			
				sum(pt.Amount) YTD,
				(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
				from PayCheckWorkerCompensation pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by pt.WorkerCompensationId
				for xml path('PayCheckWorkerCompensation'), elements, type
			) end WorkerCompensations
			for xml path ('Accumulation'), elements, type
		)Accumulations
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		and (
		(exists(select 'x' from #tmp where CompanyId=ExtractCompany.Id) and @reportL<>'Report1099' and @includeC1095L=0)
		or
		(@reportL='Report1099')
		or
		(@includeC1095L=1)
		)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	and (
		(exists(select 'x' from #tmp where CompanyId in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)) and @reportL<>'Report1099')
		or
		(@reportL='Report1099')
		)
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	
	
	

END
GO
