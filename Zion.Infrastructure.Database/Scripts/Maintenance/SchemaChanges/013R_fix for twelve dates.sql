/****** Object:  StoredProcedure [dbo].[GetExtractAccumulation]    Script Date: 3/01/2020 6:50:54 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 3/01/2020 6:50:54 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyTaxAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyTaxAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 3/01/2020 6:50:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCompanyTaxAccumulation]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeDailyAccumulation bit = 0,
	@includeMonthlyAccumulation bit = 0,
	@includePayCodes bit = 0,
	@includeHistory bit = 0,
	@includeC1095 bit = 0,
	@includeClients bit = 0,
	@includeTaxDelayed bit = 0,
	@includeMedicareExtraWage bit = 0,
	@report varchar(max) = 'PayrollSummary',
	@extractDepositName varchar(max) ='',
	@state int = null
AS
BEGIN
declare @hostL uniqueidentifier = @host,
	@companyL uniqueidentifier = @company,
	@startdateL smalldatetime = @startdate,
	@enddateL smalldatetime = @enddate,
	@includeVoidsL bit = @includeVoids,
	@includeTaxesL bit = @includeTaxes,
	@includeDeductionsL bit = @includeDeductions,
	@includeCompensationsL bit = @includeCompensations,
	@includeWorkerCompensationsL bit = @includeWorkerCompensations,
	@includeDailyAccumulationL bit = @includeDailyAccumulation,
	@includeMonthlyAccumulationL bit = @includeMonthlyAccumulation,
	@includePayCodesL bit = @includePayCodes,
	@includeHistoryL bit = @includeHistory,
	@includeC1095L bit = @includeC1095,
	@includeClientsL bit = @includeClients,
	@includeTaxDelayedL bit = @includeTaxDelayed,
	@reportL varchar(max) = @report,
	@extractDepositNameL varchar(max) =@extractDepositName,
	@includeMedicareExtraWage1 bit  = @includeMedicareExtraWage,
	@MedicareExtraWage decimal(18,2) = 0,
	@stateL int = @state
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

select * into #tmpCompany
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and Host.Id=@companyL
		and host.StatusId<>3
		and ((@includeC1095L=1 and host.IsFiler1095=1) or (@includeC1095L=0))
		and ((@includeClientsL=0 and c.Id=@company) or (@includeClientsL=1))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=1 
		and StatusId<>3
		and Id=@companyL
		and ((@includeC1095L=1 and IsFiler1095=1) or (@includeC1095L=0))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and StatusId<>3
		and Id=@companyL
		and ((@includeC1095L=1 and IsFiler1095=1) or (@includeC1095L=0))
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and Company.StatusId<>3
		and Parent.Id=@companyL
		and ((@includeC1095L=1 and Parent.IsFiler1095=1) or (@includeC1095L=0))
		and ((@includeClientsL=0 and Company.Id=@companyL) or (@includeClientsL=1))
	)a
	where ((@stateL is null) or (@stateL is not null and exists(select 'x' from CompanyTaxState cts where cts.CompanyId=a.CompanyId and cts.StateId=@stateL)))

insert into #tmp(Id, CompanyId)
	select pc1.Id, pc1.CompanyId
	from PayrollPayCheck pc1
	where 
	pc1.IsVoid=0  and pc1.TaxPayDay between @startdateL and @enddateL
	and pc1.IsHistory<=@includeHistoryL
	and ( pc1.CompanyId in (select CompanyId from #tmpCompany ))
	and ((@stateL is not null and pc1.StateId=@stateL) or (@stateL is null))
	and ( @reportL is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=1)
			and ((@includeTaxDelayedL=1) or (@includeTaxDelayedL=0 and (not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1))))
			and @reportL<>'Report1099'
		)	
	);
	if @includeMedicareExtraWage=1
	begin
		declare @companyTable IdTable
		insert into @companyTable
		select CompanyId as Id from #tmpCompany ;
		declare @mdeStartdate varchar(max) = '1/1/'+cast(year(@startdateL) as varchar(max))
		select @MedicareExtraWage = dbo.GetMedicareExtraWages(@companyTable, @mdeStartdate, @enddateL, 200000);
	end
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
	declare @twelve1date smalldatetime = dateadd(month,-2, @endDateL)
	declare @twelve2date smalldatetime = dateadd(month,-1, @endDateL)
	
	declare @twelve1d smalldatetime= cast(month(@twelve1date) as varchar(max)) + '/12/' + cast(year(@twelve1date) as varchar(max)) 
	declare @twelve2d smalldatetime= cast(month(@twelve2date) as varchar(max)) + '/12/' + cast(year(@twelve2date) as varchar(max)) 
	declare @twelve3d smalldatetime= cast(@month as varchar(max)) + '/12/' + @year 
	
	print 'hellp'
	select 
		Company.Id CompanyId, Company.CompanyName, Company.FederalEIN FEIN, Company.FederalPin FPIN,
		(
			select CompanyTaxState.* from CompanyTaxState where CompanyId=Company.Id
			for xml path('ExtractTaxState'), Elements, type
		) States,
		(
			select ctr.Id, ctr.CompanyId, ctr.TaxId, t.Code as TaxCode, ctr.TaxYear, ctr.Rate
			from CompanyTaxRate ctr, Tax t
			where ctr.TaxId=t.Id and ctr.TaxYear=year(@startdateL)
			and ctr.CompanyId=Company.Id
			for xml path('CompanyTaxRate'), Elements, type
		) CompanyTaxRates,
		(
			select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
				sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
				sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
				sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
				sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
				sum(Immigrants) as Immigrants, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and @twelve1d between pc2.StartDate and pc2.EndDate and pc2.GrossWage>0) Twelve1, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and @twelve2d between pc2.StartDate and pc2.EndDate and pc2.GrossWage>0) Twelve2, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and @twelve3d between pc2.StartDate and pc2.EndDate and pc2.GrossWage>0) Twelve3, 
				count(distinct SSN) EmployeeCount,
				case when @extractDepositNameL='' then 0 else dbo.GetExtractDepositAmount(@extractDepositNameL, @companyL, @startdateL, @enddateL) end DepositAmount,
				(select rate from TaxYearRate where taxyear=year(@startdateL) and TaxId=6) FUTARate, @MedicareExtraWage MedicareExtraWages
			from (
					select 
					pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod, e.SSN,
					case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
					
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
					and pc.Id in (select Id from #tmp)
					group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.ssn, e.TaxCategory, pc.TaxPayDay, pc.StartDate, pc.EndDate
				)a
			
			for xml path('PayCheckWages'), elements, type
		),
		case when @includeDailyAccumulationL=1 then
		(
			select 
			month(pc.TaxPayDay) Month, day(pc.TaxPayDay) Day,
			sum(case when t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
			where pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
			and pc.Id in (select Id from #tmp)
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
			and pc.Id in (select Id from #tmp)
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
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) end Taxes,
		case when @includeDeductionsL=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage, sum(pt.EmployerAmount) YTDEmployer,
			(
				select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
				from CompanyDeduction Where Id=pt.CompanyDeductionId 
				for xml path('CompanyDeduction'), elements, type
			) ,
			case when @reportL='Deductions' then
			(
				select pc.Id, pc.EmployeeId, pcd.EmployeeDeductionId TypeId, pcd.Amount EmployeeWithheld, isnull(pcd.EmployerAmount, 0) EmployerWithheld, pc.PayDay 
				from PayrollPayCheck pc, PayCheckDeduction pcd
				where pc.Id=pcd.PayCheckId and pcd.CompanyDeductionId=pt.CompanyDeductionId and pc.Id in (select Id from #tmp)
				and pcd.Amount>0
				for xml path('PayCheckSummaryByType'), elements, type
			)end PayChecks
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensationsL=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodesL=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensationsL=1 then
		(select pt.WorkerCompensationId,			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type),
			case when @reportL='WorkerCompensations' then
			(
				select pc.Id, pc.EmployeeId, pcd.WorkerCompensationId TypeId, pcd.Amount EmployeeWithheld, pc.PayDay , pcd.Wage EmployeeWage
				from PayrollPayCheck pc, PayCheckWorkerCompensation pcd
				where pc.Id=pcd.PayCheckId and pcd.WorkerCompensationId=pt.WorkerCompensationId and pc.Id in (select Id from #tmp)
				and pcd.Amount>0
				for xml path('PayCheckSummaryByType'), elements, type
			)end PayChecks
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations

		From Company
		Where
		((@hostL is not null and Company.HostId=@hostL) or (@hostL is null))
		and ((@companyL is not null and Id=@companyL) or (@companyL is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractAccumulation]    Script Date: 3/01/2020 6:50:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExtractAccumulation]
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
	@extractDepositName varchar(max) = '',
	@state int = null
	
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
	@extractDepositNameL varchar(max) = @extractDepositName,
	@stateL int = @state
	
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


	insert into #tmp(Id, CompanyId)
	select pc1.Id, pc1.CompanyId
	from PayrollPayCheck pc1
	where pc1.IsVoid<=@includeVoidsL 
	and ((@reportL<>'InternalPositivePayReport' and pc1.TaxPayDay between @startdateL and @enddateL) or (@reportL='InternalPositivePayReport' and ((pc1.IsReIssued=1 and pc1.ReIssuedDate between @startdateL and @enddateL) or (pc1.IsReIssued=0 and pc1.TaxPayDay between @startdateL and @enddateL))))
	and pc1.IsHistory<=@includeHistoryL
	and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=1)
	--and InvoiceId is not null
	and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1)
	and pc1.CompanyId in (select Id from Company where StatusId<>3)
	and @reportL<>'Report1099';

	insert into #tmpVoids(Id, CompanyId)
	select Id, CompanyId 
	from PayrollPayCheck pc1
	where IsVoid=1 
	and pc1.IsHistory=0
	and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=1)
	and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=2)
	and VoidedOn between @startdateL and @enddateL
	and year(TaxPayDay)=year(@startdateL)
	--and InvoiceId is not null
	and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1)
	and CompanyId in (select Id from Company where StatusId<>3)
	and @reportL<>'Report1099'
	and ((@stateL is not null and pc1.StateId=@stateL) or (@stateL is null))


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
	declare @twelve1date smalldatetime = dateadd(month,-2, @endDateL)
	declare @twelve2date smalldatetime = dateadd(month,-1, @endDateL)
	
	declare @twelve1d smalldatetime= cast(month(@twelve1date) as varchar(max)) + '/12/' + cast(year(@twelve1date) as varchar(max)) 
	declare @twelve2d smalldatetime= cast(month(@twelve2date) as varchar(max)) + '/12/' + cast(year(@twelve2date) as varchar(max)) 
	declare @twelve3d smalldatetime= cast(@month as varchar(max)) + '/12/' + @year 

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
	where ((@stateL is null) or (@stateL is not null and exists(select 'x' from CompanyTaxState cts where cts.CompanyId=a.CompanyId and cts.StateId=@stateL)))

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
					sum(Immigrants) as Immigrants, 
					--sum(Twelve1) Twelve1, 
					--sum(Twelve2) Twelve2, 
					--sum(Twelve3) Twelve3,
					(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id) and @twelve1d between pc2.StartDate and pc2.EndDate  and pc2.GrossWage>0) Twelve1, 
					(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id) and @twelve2d between pc2.StartDate and pc2.EndDate  and pc2.GrossWage>0) Twelve2, 
					(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id) and @twelve3d between pc2.StartDate and pc2.EndDate  and pc2.GrossWage>0) Twelve3, 
					case when @extractDepositNameL='' then 0 else dbo.GetExtractDepositAmount(@extractDepositNameL, ExtractCompany.Id, @startdateL, @enddateL) end DepositAmount,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('Federal940', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmount940,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('Federal941', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmount941,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('StateCAPIT', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmountCAPIT,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('StateCAUI', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmountCAUI
				from (
						select 
						pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
						case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
						
						--case when month(pc.TaxPayDay)=@month-2 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve1,
						--case when month(pc.TaxPayDay)=@month-1 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve2,
						--case when month(pc.TaxPayDay)=@month and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve3,
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
		)Accumulations,
		case when exists(select 'x' from #tmpVoids) then
			(select 
				(
				select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
					sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
					sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
					sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
					sum(Immigrants) as Immigrants, sum(Twelve1) Twelve1, sum(Twelve2) Twelve2, sum(Twelve3) Twelve3
				from (
						select 
						pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
						case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
						case when month(pc.TaxPayDay)=@month-2 and day(pc.TaxPayDay)=12 and pc.GrossWage>0 then 1 else 0 end Twelve1,
						case when month(pc.TaxPayDay)=@month-1 and day(pc.TaxPayDay)=12 and pc.GrossWage>0 then 1 else 0 end Twelve2,
						case when month(pc.TaxPayDay)=@month and day(pc.TaxPayDay)=12 and pc.GrossWage>0 then 1 else 0 end Twelve3,
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
						and pc.Id in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
						
						and @reportL<>'Report1099'
						group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.TaxPayDay
					)a
			
				for xml path('PayCheckWages'), elements, type
			),
			(
				select pc.Id, pc.TaxPayDay as PayDay, pc.PaymentMethod, pc.CheckNumber, e.FirstName, e.LastName
				from PayrollPayCheck pc, Employee e
				where pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				for xml path('PayCheckSummary'), elements, type

			) VoidedPayCheckList,
			case when @includeTaxesL=1 then
			(select pt.TaxId, 
				(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
								case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
								from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
				sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
				from PayCheckTax pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
						
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
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id) 
						
				group by pt.CompanyDeductionId
				for xml path('PayCheckDeduction'), elements, type
			) end Deductions,
			case when @includeCompensationsL=1 then
			(select pt.PayTypeId,
				p.Name PayTypeName,
				sum(pt.Amount) YTD
				from PayCheckCompensation pt, PayType p
				where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id) 
							
				group by pt.PayTypeId, p.Name
				for xml path('PayCheckCompensation'), elements, type
			) end Compensations,
			case when @includePayCodesL=1 then
			(select pt.PayCodeId,
			
				sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
				from PayCheckPayCode pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				
				group by pt.PayCodeId
				for xml path('PayCheckPayCode'), elements, type
			) end PayCodes,
			case when @includeWorkerCompensationsL=1 then
			(select pt.WorkerCompensationId,			
				sum(pt.Amount) YTD,
				(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
				from PayCheckWorkerCompensation pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				
				group by pt.WorkerCompensationId
				for xml path('PayCheckWorkerCompensation'), elements, type
			) end WorkerCompensations
			for xml path ('Accumulation'), elements, type
		) end VoidedAccumulations,
		
		case when @reportL='Report1099' then
			(
				select *, 
				(select sum(amount) from CheckbookJournal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdateL and @enddateL) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @reportL='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)
			end Vendors
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
