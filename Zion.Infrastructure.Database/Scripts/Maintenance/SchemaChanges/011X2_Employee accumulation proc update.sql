/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 8/02/2018 1:26:37 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 8/02/2018 1:26:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEmployeesAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetEmployeesAccumulation]
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
	@includeTaxDelayed bit = 0,
	@report varchar(max) = 'PayrollSummary'
AS
BEGIN

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
create table #tmp(Id int not null Primary Key, EmployeeId uniqueidentifier not null, SSN varchar(24) not null, CompanyId uniqueidentifier not null, PayDay datetime not null );
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckEmployeeId] ON #tmp
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
	PayDay ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


declare @ispeo as bit
declare @ishostcompany as bit
declare @hostid as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId, @ishostcompany=IsHostCompany from company where id=@company
print @ispeo
print @hostid
select id into #tmpComps from company
where 

(
	(@ispeo=1 and HostId=@hostid and FileUnderHost=1 
		and ((@includeClients=0 and Id=@company) or (@includeClients=1))
	)
or
	(company.StatusId<>3 and @ispeo=0 and id=@company)
or
	(company.StatusId<>3 and @ispeo=0 and id<>@company and @includeClients=1 and ParentId=@company)
)

;WITH essn AS
(
   SELECT *,
         ROW_NUMBER() OVER (PARTITION BY SSN ORDER BY HireDate) AS rn
   FROM employee 
   where 
   ((@report in ('PayrollSummary','W2Employee','W2Employer','SSAW2MagneticReport','SSAW2MagneticEmployerReport') and Companyid =@company  ) or (@report not in ('PayrollSummary','W2Employee','W2Employer','SSAW2MagneticReport','SSAW2MagneticEmployerReport') and CompanyId in (select Id from #tmpComps)))
   and (@employee is null or (@employee is not null and Id=@employee))
)
insert into #tmpemployee(Id)
SELECT Id 
FROM essn
WHERE rn = 1;



insert into #tmp(Id, EmployeeId, SSN, CompanyId, PayDay)
	select pc1.Id, EmployeeId, SSN, pc1.CompanyId, pc1.PayDay
	from PayrollPayCheck pc1, Employee e
	where pc1.IsVoid=0  and pc1.TaxPayDay between @startdate and @enddate
	and pc1.EmployeeId=e.Id
	and pc1.IsHistory<=@includeHistory
	and ((@company is not null and pc1.CompanyId in (select id from #tmpComps)) or (@company is null))
	and (@report is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=1)
			--and InvoiceId is not null
			and ((@includeTaxDelayed=1) or (@includeTaxDelayed=0 and (not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1))))
			and @report<>'Report1099'
		)
	)

	
	select 
		
		EmployeeJson.Id EmployeeId, EmployeeJson.SSN, EmployeeJson.Department, EmployeeJson.HireDate, EmployeeJson.BirthDate, EmployeeJson.PayType EmpPayType,
		EmployeeJson.Contact ContactStr, 
		EmployeeJson.FirstName, EmployeeJson.MiddleInitial, EmployeeJson.LastName,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path('CompanyWorkerCompensation'), elements, type),
		(select top(1) CompanyId from #tmp where id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI) order by PayDay desc) LastCheckCompany,
		case when @includeC1095=0 then
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
		case when @includeTaxes=1 then
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
		case when @includeDeductions=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
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
		case when @includeCompensations=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodes=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensations=1 then
		(select pt.WorkerCompensationId,
			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations,
		case when @includeC1095=1 then
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
