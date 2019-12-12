﻿/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 12/12/2019 7:22:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeDashboard]    Script Date: 12/12/2019 7:22:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeeDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeeDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 12/12/2019 7:22:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyTaxAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyTaxAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 12/12/2019 7:22:23 PM ******/
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
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and month(pc2.TaxPayDay)=@month-2 and  12 between day(pc2.StartDate) and day(pc2.EndDate) and pc2.GrossWage>0) Twelve1, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and month(pc2.TaxPayDay)=@month-1 and  12 between day(pc2.StartDate) and day(pc2.EndDate) and pc2.GrossWage>0) Twelve2, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and month(pc2.TaxPayDay)=@month and  12 between day(pc2.StartDate) and day(pc2.EndDate) and pc2.GrossWage>0) Twelve3, 
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
/****** Object:  StoredProcedure [dbo].[GetEmployeeDashboard]    Script Date: 12/12/2019 7:22:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployeeDashboard]
	@company uniqueidentifier,
	@employee uniqueidentifier
AS
BEGIN
	select
		(
			select * from 
			(
			  select pc.PayDay, count(pc.Id) NoOfChecks, sum(pc.grosswage) GrossWage, 
			  sum(pc.netwage) NetWage, sum(pc.employeetaxes) EmployeeTaxes, sum(pc.employertaxes) EmployerTaxes, sum(pc.deductionamount) Deductions,
			  rank() over (Partition by pc.CompanyId order by pc.payday desc) DRank
			  from 
			  Payroll p, PayrollPayCheck pc
			  where p.Id=pc.PayrollId
			  and pc.IsVoid=0
			  and pc.CompanyId=@company 
			  and pc.EmployeeId=@employee
			  and p.IsHistory=0
			  and p.IsVoid=0
			  and year(pc.TaxPayDay)=year(getdate())
			  group by pc.PayDay, pc.CompanyId
			)
			a
			for xml path('PayrollMetricJson'), elements, type
		)PayrollHistory,
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt
			where pc.EmployeeId=@employee and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id		
			group by pt.id, pt.Name
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) Accumulations

	for xml Path('CompanyDashboardJson'), elements, type
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 12/12/2019 7:22:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployeesAccumulation]
	@company uniqueidentifier = null,
	@employee uniqueidentifier = null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeAccumulation bit = 0,
	@includePayCodes bit = 0,
	@includeHistory bit = 0,
	@includeC1095 bit = 0,
	@includeClients bit = 0,
	@includeClientEmployees bit = 0,
	@includeTaxDelayed bit = 0,
	@report varchar(max) = 'PayrollSummary',
	@state int = null
AS
BEGIN

declare @company1 uniqueidentifier = @company,
	@employee1 uniqueidentifier = @employee,
	@startdate1 smalldatetime = @startdate,
	@enddate1 smalldatetime=@enddate,
	@includeVoids1 bit = @includeVoids,
	@includeTaxes1 bit = @includeTaxes,
	@includeDeductions1 bit = @includeDeductions,
	@includeCompensations1 bit = @includeCompensations,
	@includeWorkerCompensations1 bit = @includeWorkerCompensations,
	@includeAccumulation1 bit = @includeAccumulation,
	@includePayCodes1 bit = @includePayCodes,
	@includeHistory1 bit = @includeHistory,
	@includeC10951 bit = @includeC1095,
	@includeClients1 bit = @includeClients,
	@includeClientEmployees1 bit = @includeClientEmployees,
	@includeTaxDelayed1 bit = @includeTaxDelayed,
	@report1 varchar(max) = @report,
	@stateL int = @state

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpemployee')
)
DROP TABLE #tmpemployee;
create table #tmpemployee(Id uniqueidentifier not null Primary Key);
CREATE NONCLUSTERED INDEX [IX_tmpEmployeeId] ON #tmpemployee
(
	Id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null primary key, EmployeeId uniqueidentifier not null, SSN varchar(24) not null, CompanyId uniqueidentifier not null, PayDay datetime not null );
CREATE NOnCLUSTERED INDEX [IX_tmpPaycheckEmployeeId] ON #tmp
(
	
	EmployeeId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckSSN] ON #tmp
(
	SSN ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	CompanyId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckPayDay] ON #tmp
(
	PayDay Asc
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


declare @ispeo as bit
declare @ishostcompany as bit
declare @islocation as bit
declare @parent as uniqueidentifier
declare @hostid as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId, @ishostcompany=IsHostCompany, @islocation=(case when ParentId is null then 0 else 1 end), @parent=ParentId from company where id=@company1
print @ispeo
print @hostid
select id into #tmpComps from company
where 
((@stateL is null) or (@stateL is not null and exists (select 'x' from CompanyTaxState cts where cts.StateId=@stateL and cts.CompanyId=Company.Id) ))
and
(
	(@ispeo=1 and HostId=@hostid and FileUnderHost=1 
		and ((@includeClients1=0 and Id=@company1) or (@includeClients1=1))
	)
or
	(company.StatusId<>3 and @ispeo=0 and id=@company1)
or
	(company.StatusId<>3 and @ispeo=0 and id<>@company1 and @includeClients1=1 and ParentId=@company1)
or
	(company.StatusId<>3 and @ispeo=0 and @islocation=1 and @includeClients1=1 and (id=@parent or ParentId=@parent))
)

;WITH essn AS
(
   SELECT *,
         ROW_NUMBER() OVER (PARTITION BY SSN ORDER BY HireDate) AS rn
   FROM employee 
   where 
   (
		(@report1 in ('W2Employee','W2Employer','SSAW2MagneticReport','SSAW2MagneticEmployerReport') and Companyid =@company1  ) 
		or 
		(@report1 not in ('PayrollSummary','W2Employee','W2Employer','SSAW2MagneticReport','SSAW2MagneticEmployerReport') and CompanyId in (select Id from #tmpComps))
		or 
		(@report1 ='PayrollSummary' and ((@includeClientEmployees1=1 and CompanyId in (select Id from #tmpComps)) or (@includeClientEmployees1=0 and Companyid=@company1)))
	)
   and (@employee1 is null or (@employee1 is not null and Id=@employee1))
)
insert into #tmpemployee(Id)
SELECT Id 
FROM essn
WHERE rn = 1;

Print CAST(GETDATE() as Datetime2(7)) 

insert into #tmp(Id, EmployeeId, SSN, CompanyId, PayDay)
	select pc1.Id, EmployeeId, SSN, pc1.CompanyId, pc1.PayDay
	from PayrollPayCheck pc1, Employee e
	where pc1.IsVoid=0  and pc1.TaxPayDay between @startdate1 and @enddate1
	and pc1.EmployeeId=e.Id
	and ((@includeHistory1=0 and pc1.IsHistory=@includeHistory1) or @includeHistory1=1)
	and ((@company1 is not null and pc1.CompanyId in (select id from #tmpComps)) or (@company1 is null))
	and ((@stateL is not null and pc1.StateId=@stateL) or (@stateL is null))
	and (@report1 is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report1 and [Type]=1)
			--and InvoiceId is not null
			and ((@includeTaxDelayed1=1) or (@includeTaxDelayed1=0 and (not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1))))
			and @report1<>'Report1099'
		)
	)

	 
	select 
		
		EmployeeJson.Id EmployeeId, EmployeeJson.SSN, EmployeeJson.Department, EmployeeJson.HireDate, EmployeeJson.BirthDate, EmployeeJson.PayType EmpPayType,
		EmployeeJson.Contact ContactStr, 
		EmployeeJson.FirstName, EmployeeJson.MiddleInitial, EmployeeJson.LastName,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path('CompanyWorkerCompensation'), elements, type),
		(select top(1) CompanyId from #tmp where id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI) order by Id desc) LastCheckCompany,
		case when @includeC10951=0 then
		(
			select 
			sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage,
			sum(case pc.PaymentMethod when 1 then NetWage else 0 end) CheckPay,
			sum(case pc.PaymentMethod when 1 then 0 else NetWage end) DDPay
			from PayrollPayCheck pc
			where 
			pc.Id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			for xml path('PayCheckWages'), elements, type
		)
		end,
		case when @includeTaxes1=1 then
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) end Taxes,
		case when @includeDeductions1=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage, sum(pt.EmployerAmount) YTDEmployer,
			(
				select *, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
				from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensations1=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodes1=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensations1=1 then
		(select pt.WorkerCompensationId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations,
		case when @includeAccumulation1=1 then
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName,  pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt, Employee e
			where pc.EmployeeId=e.Id and e.SSN=EmployeeJson.SSN and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pc.PayDay <= @enddate1
			and pc.CompanyId in (select id from #tmpcomps)
			and pta.PayTypeId = pt.Id		
			and (year(pta.FiscalStart)=year(@startdate1) or year(pta.fiscalend)=year(@enddate1))
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) 
		end Accumulations,
		case when @includeC10951=1 then
		(
			select 
			GrossWage, Salary, PayCodes PayCodesFlat, TaxPayDay PayDay,
			(	select pt.CompanyDeductionId,			
				pt.Amount, pt.Wage,
				(
					select *, 
						(select Id, Name, 
						case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
						from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
					from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
				) 
				from PayCheckDeduction pt, CompanyDeduction cd, DeductionType dt
				where pt.PayCheckId=pc.Id
				and pt.CompanyDeductionId=cd.Id and cd.TypeId=dt.Id
				and dt.id=10
				for xml path('PayCheckDeduction'), elements, type
			) Deductions
			from PayrollPayCheck pc
			where 
			pc.Id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			for xml path('PayCheckSummary1095'), elements, type
		) end PayCheck1095Summaries

		From Employee EmployeeJson
		Where
		EmployeeJson.Id in (select Id from #tmpemployee)
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
