
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EntityRelation]') AND name = N'IX_EntityRelation_2')
DROP INDEX [IX_EntityRelation_2] ON [dbo].[EntityRelation]
GO
/****** Object:  Index [IX_EntityRelation_1]    Script Date: 20/03/2017 5:31:19 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EntityRelation]') AND name = N'IX_EntityRelation_1')
DROP INDEX [IX_EntityRelation_1] ON [dbo].[EntityRelation]
GO
/****** Object:  Index [IX_EntityRelation]    Script Date: 20/03/2017 5:31:19 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EntityRelation]') AND name = N'IX_EntityRelation')
DROP INDEX [IX_EntityRelation] ON [dbo].[EntityRelation]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EntityRelation]') AND name = N'IX_EntityRelation')
CREATE NONCLUSTERED INDEX [IX_EntityRelation] ON [dbo].[EntityRelation]
(
	[SourceEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_EntityRelation_1]    Script Date: 20/03/2017 5:31:19 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EntityRelation]') AND name = N'IX_EntityRelation_1')
CREATE NONCLUSTERED INDEX [IX_EntityRelation_1] ON [dbo].[EntityRelation]
(
	[SourceEntityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_EntityRelation_2]    Script Date: 20/03/2017 5:31:19 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EntityRelation]') AND name = N'IX_EntityRelation_2')
CREATE NONCLUSTERED INDEX [IX_EntityRelation_2] ON [dbo].[EntityRelation]
(
	[SourceEntityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

alter table Payroll Add TaxPayDay datetime not null default(cast(getdate() as date));
alter table PayrollPayCheck Add TaxPayDay datetime not null default(cast(getdate() as date));
Go

update Payroll set TaxPayDay=PayDay;
update PayrollPayCheck set TaxPayDay=PayDay;

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PaycheckTaxPayDay')
DROP INDEX [IX_PaycheckTaxPayDay] ON [dbo].[PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollTaxPayDay')
DROP INDEX [IX_PayrollTaxPayDay] ON [dbo].[Payroll]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckTaxPayDay')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckTaxPayDay] ON [dbo].[PayrollPayCheck]
(
	[TaxPayDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollTaxPayDay')
CREATE NONCLUSTERED INDEX [IX_PayrollTaxPayDay] ON [dbo].[Payroll]
(
	[TaxPayDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  StoredProcedure [dbo].[GetExtractAccumulation]    Script Date: 23/03/2017 1:09:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 23/03/2017 1:09:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesYTD]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 23/03/2017 1:09:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 23/03/2017 1:09:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployees]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyAccumulation]    Script Date: 23/03/2017 1:09:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyAccumulation]    Script Date: 23/03/2017 1:09:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyAccumulation]
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
	@report varchar(max) = null
AS
BEGIN

	
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

insert into #tmp(Id, CompanyId)
	select Id, CompanyId
	from PayrollPayCheck pc1
	where pc1.IsVoid=0  and pc1.PayDay between @startdate and @enddate
	and pc1.CompanyId=@company
	and ( @report is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=1)
			and InvoiceId is not null
			and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId and Status=5)
			and @report<>'Report1099'
		)	
	);

	declare @year as varchar(max)=cast(year(@startdate) as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@year
	declare @quarter3ed smalldatetime='9/30/'+@year
	declare @quarter4sd smalldatetime='10/1/'+@year
	declare @quarter4ed smalldatetime='12/31/'+@year

	declare @month int = month(@enddate)
	
	
	select 
		Company.Id CompanyId, Company.CompanyName, Company.FederalEIN FEIN, Company.FederalPin FPIN,
		(
			select CompanyTaxState.* from CompanyTaxState where CompanyId=Company.Id
			for xml path('ExtractTaxState'), Elements, type
		) States,
		(
			select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
				sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
				sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
				sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
				sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
				sum(Immigrants) as Immigrants, sum(Twelve1) Twelve1, sum(Twelve2) Twelve2, sum(Twelve3) Twelve3
			from (
					select 
					pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
					case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
					case when month(pc.payday)=@month-2 and day(pc.payday)=12 and pc.GrossWage>0 then 1 else 0 end Twelve1,
					case when month(pc.payday)=@month-1 and day(pc.payday)=12 and pc.GrossWage>0 then 1 else 0 end Twelve2,
					case when month(pc.payday)=@month and day(pc.payday)=12 and pc.GrossWage>0 then 1 else 0 end Twelve3,
					sum(case when pc.payday between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.Amount else 0 end) Quarter1FUTA,
					sum(case when pc.payday between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter2FUTA,
					sum(case when pc.payday between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter3FUTA,
					sum(case when pc.payday between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter4FUTA,
					sum(case when pc.payday between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter1FUTAWage,
					sum(case when pc.payday between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter2FUTAWage,
					sum(case when pc.payday between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter3FUTAWage,
					sum(case when pc.payday between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter4FUTAWage
					from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
					where pc.Id=pct.PayCheckId
					and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
					and pc.Id in (select Id from #tmp)
					group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.PayDay
				)a
			
			for xml path('PayCheckWages'), elements, type
		),
		case when @includeDailyAccumulation=1 then
		(
			select 
			month(pc.PayDay) Month, day(pc.PayDay) Day,
			sum(case when pc.payday between @quarter1sd and @quarter1ed and t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
			where pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
			and pc.Id in (select Id from #tmp)
			group by pc.PayDay
			for xml path('DailyAccumulation'), elements, type
		) end DailyAccumulations,
		case when @includeMonthlyAccumulation=1 then
		(
			select 
			month(pc.PayDay) Month,
			sum(case when t.Id<6 then pct.Amount else 0 end) IRS941,
			sum(case when t.Id=6 then pct.Amount else 0 end) IRS940,
			sum(case when t.Id between 7 and 10 then pct.Amount else 0 end) EDD
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t
			where pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id
			and pc.Id in (select Id from #tmp)
			group by month(pc.PayDay)
			for xml path('MonthlyAccumulation'), elements, type
		) end MonthlyAccumulations,
		case when @includeTaxes=1 then
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
		case when @includeDeductions=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(
				select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
				from CompanyDeduction Where Id=pt.CompanyDeductionId 
				for xml path('CompanyDeduction'), elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensations=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodes=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensations=1 then
		(select pt.WorkerCompensationId,			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations

		From Company
		Where
		((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and Id=@company) or (@company is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 23/03/2017 1:09:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEmployees] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetEmployees]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
	select 
		EmployeeJson.*, 
		Company.HostId HostId, 
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt
			where pc.EmployeeId=EmployeeJson.Id and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id
			and getdate() between pta.FiscalStart and pta.FiscalEnd
			and pt.Id=6--sick leave
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) Accumulations,
		(select *, (select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) from CompanyDeduction where Id=EmployeeDeduction.CompanyDeductionId for Xml path('CompanyDeduction'), elements, type) from EmployeeDeduction Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeDeductions,
		(select *, (select * from BankAccount where Id=EmployeeBankAccount.BankAccountId for Xml path('BankAccount'), elements, type) from EmployeeBankAccount Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeBankAccounts,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path('CompanyWorkerCompensation'), elements, type)
		
		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId = Company.Id
		and ((@id is not null and EmployeeJson.Id=@id) or (@id is null))
		and ((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and EmployeeJson.CompanyId=@company) or (@company is null))
		and ((@status is not null and EmployeeJson.StatusId=cast(@status as int)) or (@status is null))
		
		for Xml path('EmployeeJson'), root('EmployeeList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 23/03/2017 1:09:12 PM ******/
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
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@id uniqueidentifier=null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeAccumulation bit = 0,
	@includePayCodes bit = 0,
	@report varchar(max) = 'PayrollSummary'
AS
BEGIN


	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null Primary Key, EmployeeId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	EmployeeId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

insert into #tmp(Id, EmployeeId)
	select Id, EmployeeId
	from PayrollPayCheck pc1
	where pc1.IsVoid=0  and pc1.TaxPayDay between @startdate and @enddate
	and ((@id is not null and EmployeeId=@id) or (@id is null))
	and ((@company is not null and CompanyId=@company) or (@company is null))
	and (@report is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=1)
			and InvoiceId is not null
			and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId and Status=5)
			and @report<>'Report1099'
		)
	)

	
	select 
		
		EmployeeJson.Id EmployeeId, EmployeeJson.SSN, EmployeeJson.Department, EmployeeJson.HireDate, EmployeeJson.PayType EmpPayType,
		EmployeeJson.Contact ContactStr, 
		EmployeeJson.FirstName, EmployeeJson.MiddleInitial, EmployeeJson.LastName,
		(
			select 
			sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage,
			sum(case pc.PaymentMethod when 1 then NetWage else 0 end) CheckPay,
			sum(case pc.PaymentMethod when 1 then 0 else NetWage end) DDPay
			from PayrollPayCheck pc
			where 
			pc.Id in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			for xml path('PayCheckWages'), elements, type
		),
		case when @includeTaxes=1 then
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) end Taxes,
		case when @includeDeductions=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(
				select *, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
				from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensations=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodes=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensations=1 then
		(select pt.WorkerCompensationId,
			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations,
		case when @includeAccumulation=1 then
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayCheckPayTypeAccumulation pta, PayType pt
			where pta.PayTypeId = pt.Id
			and pta.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) end Accumulations,
		case when @includeAccumulation=1 then
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt
			where pc.EmployeeId=EmployeeJson.Id and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id
			and dateadd(year,-1,@enddate) between pta.FiscalStart and pta.FiscalEnd
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) end PreviousAccumulations

		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId=Company.Id
		and ((@id is not null and EmployeeJson.Id=@id) or (@id is null))
		and ((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and EmployeeJson.CompanyId=@company) or (@company is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 23/03/2017 1:09:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEmployeesYTD] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetEmployeesYTD]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@id uniqueidentifier=null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeAccumulation bit = 0,
	@includePayCodes bit = 0,
	@report varchar(max) = null
AS
BEGIN


	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null Primary Key, EmployeeId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	EmployeeId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

insert into #tmp(Id, EmployeeId)
	select Id, EmployeeId
	from PayrollPayCheck pc1
	where pc1.IsVoid=0  and pc1.PayDay between @startdate and @enddate
	and ((@id is not null and EmployeeId=@id) or (@id is null))
	and ((@company is not null and CompanyId=@company) or (@company is null))
		
	select 
		
		EmployeeJson.Id EmployeeId, EmployeeJson.SSN, EmployeeJson.Department, EmployeeJson.HireDate, EmployeeJson.PayType EmpPayType,
		EmployeeJson.Contact ContactStr, 
		EmployeeJson.FirstName, EmployeeJson.MiddleInitial, EmployeeJson.LastName,
		(
			select 
			sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage,
			sum(case pc.PaymentMethod when 1 then NetWage else 0 end) CheckPay,
			sum(case pc.PaymentMethod when 1 then 0 else NetWage end) DDPay
			from PayrollPayCheck pc
			where 
			pc.Id in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			for xml path('PayCheckWages'), elements, type
		),
		case when @includeTaxes=1 then
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) end Taxes,
		case when @includeDeductions=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(
				select *, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
				from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensations=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodes=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensations=1 then
		(select pt.WorkerCompensationId,
			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations,
		case when @includeAccumulation=1 then
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayCheckPayTypeAccumulation pta, PayType pt
			where pta.PayTypeId = pt.Id
			and pta.PayCheckId in (select Id from #tmp where EmployeeId=EmployeeJson.Id)
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) end Accumulations,
		case when @includeAccumulation=1 then
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt
			where pc.EmployeeId=EmployeeJson.Id and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id
			and dateadd(year,-1,@enddate) between pta.FiscalStart and pta.FiscalEnd
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) end PreviousAccumulations

		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId=Company.Id
		and ((@id is not null and EmployeeJson.Id=@id) or (@id is null))
		and ((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and EmployeeJson.CompanyId=@company) or (@company is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractAccumulation]    Script Date: 23/03/2017 1:09:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtractAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtractAccumulation]
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
	@includePayCodes bit = 0
AS
BEGIN
	
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
	select Id, CompanyId
	from PayrollPayCheck pc1
	where pc1.IsVoid<=@includeVoids and pc1.TaxPayDay between @startdate and @enddate
	and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=1)
	and InvoiceId is not null
	and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId and Status=5)
	and @report<>'Report1099';

	insert into #tmpVoids(Id, CompanyId)
	select Id, CompanyId 
	from PayrollPayCheck pc1
	where IsVoid=1 
	and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=1)
	and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=2)
	and VoidedOn between @startdate and @enddate
	and year(TaxPayDay)=year(@startdate)
	and InvoiceId is not null
	and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId and Status=5)
	and @report<>'Report1099'


declare @year as varchar(max)=cast(year(@startdate) as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@year
	declare @quarter3ed smalldatetime='9/30/'+@year
	declare @quarter4sd smalldatetime='10/1/'+@year
	declare @quarter4ed smalldatetime='12/31/'+@year

	declare @month int = month(@enddate)
	

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
		and ParentId is null
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and ((@depositSchedule is not null and Parent.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and Parent.HostId=@host) or (@host is null))
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
			(select 
				(
				select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
					sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
					sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
					sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
					sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
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
						and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
						
						and @report<>'Report1099'
						group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.TaxPayDay
					)a
			
				for xml path('PayCheckWages'), elements, type
			),
			(
				select pc.Id, pc.TaxPayDay as PayDay, pc.PaymentMethod, pc.CheckNumber, e.FirstName, e.LastName, pc.GrossWage, pc.PEOASOCoCheck, pc.NetWage, pc.IsVoid, pc.CompanyId
				from PayrollPayCheck pc, Employee e
				where pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				for xml path('PayCheckSummary'), elements, type

			) PayCheckList,
			case when @includeDailyAccumulation=1 then
			(
				
				select 
				month(pc.TaxPayDay) Month, day(pc.TaxPayDay) Day,
				sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
				from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
				where pc.Id=pct.PayCheckId
				and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				group by pc.TaxPayDay
				for xml path('DailyAccumulation'), elements, type
				
				
			) end DailyAccumulations,
			case when @includeMonthlyAccumulation=1 then
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
			case when @includeTaxes=1 then
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
			case when @includeDeductions=1 then
			(select pt.CompanyDeductionId,
			
				sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
				(
					select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
						(select Id, Name, 
						case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
						from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
					from CompanyDeduction Where Id=pt.CompanyDeductionId 
					for xml path('CompanyDeduction'), elements, type
				) 
				from PayCheckDeduction pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id) 
						
				group by pt.CompanyDeductionId
				for xml path('PayCheckDeduction'), elements, type
			) end Deductions,
			case when @includeCompensations=1 then
			(select pt.PayTypeId,
				p.Name PayTypeName,
				sum(pt.Amount) YTD
				from PayCheckCompensation pt, PayType p
				where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id) 
							
				group by pt.PayTypeId, p.Name
				for xml path('PayCheckCompensation'), elements, type
			) end Compensations,
			case when @includePayCodes=1 then
			(select pt.PayCodeId,
			
				sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
				from PayCheckPayCode pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by pt.PayCodeId
				for xml path('PayCheckPayCode'), elements, type
			) end PayCodes,
			case when @includeWorkerCompensations=1 then
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
						
						and @report<>'Report1099'
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
			
			case when @includeTaxes=1 then
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
			case when @includeDeductions=1 then
			(select pt.CompanyDeductionId,
			
				sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
				(
					select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
						(select Id, Name, 
						case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
						from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
					from CompanyDeduction Where Id=pt.CompanyDeductionId 
					for xml path('CompanyDeduction'), elements, type
				) 
				from PayCheckDeduction pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id) 
						
				group by pt.CompanyDeductionId
				for xml path('PayCheckDeduction'), elements, type
			) end Deductions,
			case when @includeCompensations=1 then
			(select pt.PayTypeId,
				p.Name PayTypeName,
				sum(pt.Amount) YTD
				from PayCheckCompensation pt, PayType p
				where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id) 
							
				group by pt.PayTypeId, p.Name
				for xml path('PayCheckCompensation'), elements, type
			) end Compensations,
			case when @includePayCodes=1 then
			(select pt.PayCodeId,
			
				sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
				from PayCheckPayCode pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				
				group by pt.PayCodeId
				for xml path('PayCheckPayCode'), elements, type
			) end PayCodes,
			case when @includeWorkerCompensations=1 then
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
		
		case when @report='Report1099' then
			(
				select *, 
				(select sum(amount) from Journal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @report='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)
			end Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		and (
		(exists(select 'x' from #tmp where CompanyId=ExtractCompany.Id) and @report<>'Report1099')
		or
		(@report='Report1099')
		)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	and (
		(exists(select 'x' from #tmp where CompanyId in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)) and @report<>'Report1099')
		or
		(@report='Report1099')
		)
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 23/03/2017 2:13:25 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoicesXml]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 23/03/2017 2:13:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollInvoicesXml] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollInvoicesXml]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = '',
	@startdate datetime = null,
	@enddate datetime = null,
	@id uniqueidentifier=null,
	@paymentstatus varchar(max) = '',
	@paymentmethod varchar(max) = ''
AS
BEGIN
	declare @tmpStatuses table (
		status int not null
	)
	insert into @tmpStatuses
	SELECT 
		 Split.a.value('.', 'VARCHAR(100)') AS status  
	FROM  
	(
		SELECT CAST ('<M>' + REPLACE(@status, ',', '</M><M>') + '</M>' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)

	declare @tmpPaymentStatuses table (
		status int not null
	)
	insert into @tmpPaymentStatuses
	SELECT 
		 Split.a.value('.', 'VARCHAR(100)') AS status  
	FROM  
	(
		SELECT CAST ('<M>' + REPLACE(@paymentstatus, ',', '</M><M>') + '</M>' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)

	declare @tmpPaymentMethods table (
		method int not null
	)
	insert into @tmpPaymentMethods
	SELECT 
		 Split.a.value('.', 'VARCHAR(100)') AS status  
	FROM  
	(
		SELECT CAST ('<M>' + REPLACE(@paymentmethod, ',', '</M><M>') + '</M>' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)

	select 
		PayrollInvoiceJson.*,
		case when exists(select  'x' from CommissionExtract where PayrollInvoiceId=PayrollInvoiceJson.Id) then 1 else 0 end CommissionClaimed,
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
		(select * from InvoicePayment where InvoiceId=PayrollInvoiceJson.Id for Xml path('InvoicePaymentJson'), Elements, type) InvoicePayments
		, 
		(select 
			CompanyJson.*
			,
			(select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) from CompanyDeduction Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyDeductions,
			(select * from CompanyWorkerCompensation Where CompanyId=CompanyJson.Id for Xml auto, elements, type) CompanyWorkerCompensations,
			(select *, (select * from PayType Where Id=CompanyAccumlatedPayType.PayTypeId for xml path('PayType'), elements, type) from CompanyAccumlatedPayType Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyAccumlatedPayTypes,
			(select * from CompanyContract Where CompanyId=CompanyJson.Id for xml path('CompanyContract'), elements, type), 
			(select *,(select * from Tax where Id=CompanyTaxRate.TaxId for xml path('Tax'), elements, type) from CompanyTaxRate Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxRates,
			(select * from CompanyTaxState Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxStates, 
			(select * from CompanyPayCode Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyPayCodes,
			(select * from Company Where ParentId=CompanyJson.Id for xml path('CompanyJson'), elements, type) Locations,
			(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type),
			(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=CompanyJson.Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
			for Xml path('Company'), elements, type
		)
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson--, InvoicePayment InvoicePaymentJson
	Where 
	((@id is not null and PayrollInvoiceJson.Id=@id) or (@id is null)) 
	and ((@company is not null and PayrollInvoiceJson.CompanyId=@company) or (@company is null)) 
	and ((@startdate is not null and PayrollInvoiceJson.InvoiceDate>=@startdate) or (@startdate is null))
	and ((@enddate is not null and PayrollInvoiceJson.InvoiceDate<=@enddate) or (@enddate is null)) 
	and PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	and ((@status <>'' and exists(select 'x' from @tmpStatuses where status=PayrollInvoiceJson.Status)) or (@status=''))
	and ((@paymentstatus <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentStatuses tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=tps.status)) or (@paymentstatus=''))
	and ((@paymentmethod <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentMethods tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method=tps.method)) or (@paymentmethod=''))
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path('PayrollInvoiceJson'), root('PayrollInvoiceJsonList'), elements, type
	

END
GO


/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 23/03/2017 2:15:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoiceList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoiceList]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 23/03/2017 2:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoiceList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollInvoiceList] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollInvoiceList]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = '',
	@startdate datetime = null,
	@enddate datetime = null,
	@paymentstatus varchar(max) = '',
	@paymentmethod varchar(max) = ''
AS
BEGIN
	declare @tmpStatuses table (
		status int not null
	)
	insert into @tmpStatuses
	SELECT 
		 Split.a.value('.', 'VARCHAR(100)') AS status  
	FROM  
	(
		SELECT CAST ('<M>' + REPLACE(@status, ',', '</M><M>') + '</M>' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)

	declare @tmpPaymentStatuses table (
		status int not null
	)
	insert into @tmpPaymentStatuses
	SELECT 
		 Split.a.value('.', 'VARCHAR(100)') AS status  
	FROM  
	(
		SELECT CAST ('<M>' + REPLACE(@paymentstatus, ',', '</M><M>') + '</M>' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)

	declare @tmpPaymentMethods table (
		method int not null
	)
	insert into @tmpPaymentMethods
	SELECT 
		 Split.a.value('.', 'VARCHAR(100)') AS status  
	FROM  
	(
		SELECT CAST ('<M>' + REPLACE(@paymentmethod, ',', '</M><M>') + '</M>' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)


		select 
		PayrollInvoiceJson.*,
		CompanyJson.CompanyName, CompanyJson.HostId, CompanyJson.IsHostCompany, CompanyJson.IsVisibleToHost, CompanyJson.BusinessAddress,
		(select max(PaymentDate) from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=3) LastPayment,
		STUFF((SELECT ', ' + CAST(ip.CheckNumber AS VARCHAR(max)) [text()]
         from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method=1
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') CheckNumbers
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson--, InvoicePayment InvoicePaymentJson
	Where 
	((@company is not null and PayrollInvoiceJson.CompanyId=@company) or (@company is null)) 
	and ((@startdate is not null and PayrollInvoiceJson.InvoiceDate>=@startdate) or (@startdate is null))
	and ((@enddate is not null and PayrollInvoiceJson.InvoiceDate<=@enddate) or (@enddate is null)) 
	and PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	and ((@status <>'' and exists(select 'x' from @tmpStatuses where status=PayrollInvoiceJson.Status)) or (@status=''))
	and ((@paymentstatus <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentStatuses tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=tps.status)) or (@paymentstatus=''))
	and ((@paymentmethod <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentMethods tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method=tps.method)) or (@paymentmethod=''))
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path('PayrollInvoiceListItem'), root('PayrollInvoiceJsonList'), elements, type

END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 23/03/2017 2:47:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyTaxAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyTaxAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 23/03/2017 2:47:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyTaxAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyTaxAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyTaxAccumulation]
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
	@report varchar(max) = 'PayrollSummary'
AS
BEGIN

	
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

insert into #tmp(Id, CompanyId)
	select Id, CompanyId
	from PayrollPayCheck pc1
	where pc1.IsVoid=0  and pc1.TaxPayDay between @startdate and @enddate
	and pc1.CompanyId=@company
	and ( @report is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=1)
			and InvoiceId is not null
			and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId and Status=5)
			and @report<>'Report1099'
		)	
	);

	declare @year as varchar(max)=cast(year(@startdate) as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@year
	declare @quarter3ed smalldatetime='9/30/'+@year
	declare @quarter4sd smalldatetime='10/1/'+@year
	declare @quarter4ed smalldatetime='12/31/'+@year

	declare @month int = month(@enddate)
	
	
	select 
		Company.Id CompanyId, Company.CompanyName, Company.FederalEIN FEIN, Company.FederalPin FPIN,
		(
			select CompanyTaxState.* from CompanyTaxState where CompanyId=Company.Id
			for xml path('ExtractTaxState'), Elements, type
		) States,
		(
			select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
				sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
				sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
				sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
				sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
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
					and pc.Id in (select Id from #tmp)
					group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.TaxPayDay
				)a
			
			for xml path('PayCheckWages'), elements, type
		),
		case when @includeDailyAccumulation=1 then
		(
			select 
			month(pc.TaxPayDay) Month, day(pc.TaxPayDay) Day,
			sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
			where pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
			and pc.Id in (select Id from #tmp)
			group by pc.TaxPayDay
			for xml path('DailyAccumulation'), elements, type
		) end DailyAccumulations,
		case when @includeMonthlyAccumulation=1 then
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
		case when @includeTaxes=1 then
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
		case when @includeDeductions=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(
				select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
				from CompanyDeduction Where Id=pt.CompanyDeductionId 
				for xml path('CompanyDeduction'), elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensations=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodes=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensations=1 then
		(select pt.WorkerCompensationId,			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations

		From Company
		Where
		((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and Id=@company) or (@company is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO



/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 23/03/2017 2:58:34 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 23/03/2017 2:58:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtractData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtractData]
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
		and ParentId is null
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and ((@depositSchedule is not null and Parent.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and Parent.HostId=@host) or (@host is null))
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
				select * from PayrollPayCheck where CompanyId=ExtractCompany.Id 
				and IsVoid=0
				and taxpayday between @startdate and @enddate
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and Status=5)
				and @report<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) PayChecks,
			(
				select * from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=2)
				and VoidedOn between @startdate and @enddate
				and year(taxpayday)=year(@startdate)
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and Status=5)
				and @report<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from Journal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @report='Report1099'
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
		MasterExtracts where ExtractName=@report and year(startdate)=year(@startdate)
		and Id=0
		for xml path ('MasterExtractDB'), ELEMENTS, type
	) History
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	

END
GO
