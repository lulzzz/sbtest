IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_Journal_1')
DROP INDEX [IX_Journal_1] ON [dbo].[Journal]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_Journal_2')
DROP INDEX [IX_Journal_2] ON [dbo].[Journal]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalCheckNumber')
DROP INDEX [IX_JournalCheckNumber] ON [dbo].[Journal]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalCompanyId')
DROP INDEX [IX_JournalCompanyId] ON [dbo].[Journal]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalVoid')
DROP INDEX [IX_JournalVoid] ON [dbo].[Journal]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_Journal')
DROP INDEX [IX_Journal] ON [dbo].[Journal]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalTransactionType')
DROP INDEX [IX_JournalTransactionType] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalComposite]    Script Date: 23/08/2017 12:57:38 PM ******/
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalComposite')

CREATE NONCLUSTERED INDEX [IX_JournalComposite] ON [dbo].[Journal]
(
	[CompanyId] ASC,
	[TransactionType] ASC,
	[PEOASOCoCheck] ASC,
	[PayrollPayCheckId] ASC,
	[CheckNumber] DESC,
	[MainAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

Go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayCheckCompanyId')
DROP INDEX [IX_PaycheckCompanyId] ON [dbo].[PayrollPayCheck]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayCheckEmployeeId')
DROP INDEX [IX_PayCheckEmployeeId] ON [dbo].[PayrollPayCheck]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheck')
DROP INDEX [IX_PayrollPayCheck] ON [dbo].[PayrollPayCheck]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheck_1')
DROP INDEX [IX_PayrollPayCheck_1] ON [dbo].[PayrollPayCheck]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheck_2')
DROP INDEX [IX_PayrollPayCheck_2] ON [dbo].[PayrollPayCheck]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheck_3')
DROP INDEX [IX_PayrollPayCheck_3] ON [dbo].[PayrollPayCheck]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheck_4')
DROP INDEX [IX_PayrollPayCheck_4] ON [dbo].[PayrollPayCheck]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheck_5')
DROP INDEX [IX_PayrollPayCheck_5] ON [dbo].[PayrollPayCheck]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheck_6')
DROP INDEX [IX_PayrollPayCheck_6] ON [dbo].[PayrollPayCheck]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayCheckPayDay')
DROP INDEX [IX_PayCheckPayDay] ON [dbo].[PayrollPayCheck]
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckTaxPayDay')
DROP INDEX [IX_PayrollPayCheckTaxPayDay] ON [dbo].[PayrollPayCheck]
GO

IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckComposite')

CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckComposite] ON [dbo].[PayrollPayCheck]
(
	[CompanyId] ASC,
	[PayDay] ASC,
	[TaxPayDay] ASC,
	[IsVoid] ASC,
	[InvoiceId] ASC,
	[CreditInvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckComposite2')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckComposite2]
ON [dbo].[PayrollPayCheck] ([EmployeeId],[IsVoid])
INCLUDE ([Id])
Go

IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPayrollVoid')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckPayrollVoid]
ON [dbo].[PayrollPayCheck] ([PayrollId],[IsVoid])

GO

CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckVoidPayDay]
ON [dbo].[PayrollPayCheck] ([IsVoid],[PayDay])
INCLUDE ([Id],[CompanyId],[EmployeeId])
GO
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckVoidTaxPayDay]
ON [dbo].[PayrollPayCheck] ([IsVoid],[TaxPayDay])
INCLUDE ([Id],[CompanyId],[EmployeeId])
GO
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckIsHistory]
ON [dbo].[PayrollPayCheck] ([IsHistory])
GO
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckInvoiceId]
ON [dbo].[PayrollPayCheck] ([InvoiceId])

GO

IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Company]') AND name = N'IX_CompanyComposite')
CREATE NONCLUSTERED INDEX [IX_CompanyComposite]
ON [dbo].[Company] ([FileUnderHost],[ManageTaxPayment],[ManageEFileForms],[ParentId],[StatusId])

GO

/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 25/08/2017 1:40:25 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesYTD]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 25/08/2017 1:40:25 PM ******/
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
	@report varchar(max) = null,
	@ssns varchar(max) = null
AS
BEGIN


	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null Primary Key, EmployeeId uniqueidentifier not null, SSN varchar(24) not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	EmployeeId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckSSN] ON #tmp
(
	SSN ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

declare @ispeo as bit
declare @hostid as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId from company where id=@company
select id into #tmpcomps from company
where 
((@ispeo=1 and HostId=@hostid and FileUnderHost=1)
or
(@ispeo=0 and id=@company)
)

declare @tmpSSNs table (
		ssn varchar(24) not null
	)
	if @ssns is not null
		insert into @tmpSSNs
		SELECT 
			 Split.a.value('.', 'VARCHAR(24)') AS ssn  
		FROM  
		(
			SELECT CAST ('<M>' + REPLACE(@ssns, ',', '</M><M>') + '</M>' AS XML) AS CVS 
		) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)


	insert into #tmp(Id, EmployeeId, SSN)
	select pc1.Id, EmployeeId, e.SSN into#tmp
	from PayrollPayCheck pc1, Employee e, Company c
	where pc1.IsVoid=0  and pc1.PayDay between @startdate and @enddate
	and pc1.EmployeeId=e.Id
	and pc1.CompanyId = c.Id
	and ((@id is not null and EmployeeId=@id) or (@id is null))
	and ((@company is not null and pc1.CompanyId in (select id from #tmpcomps)) or (@company is null))
	and ((@ssns is not null and e.SSN in (select ssn from @tmpSSNs)) or (@ssns is null))
		

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
			pc.Id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			for xml path('PayCheckWages'), elements, type
		),
		
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) Taxes,
		
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
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) Deductions,
		
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) Compensations,
		
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		)  PayCodes,
		
		(select pt.WorkerCompensationId,
			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) WorkerCompensations,
		
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName,  pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt, Employee e
			where pc.EmployeeId=e.Id and e.SSN=EmployeeJson.SSN and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id			
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) Accumulations
		
		--,(
		--	select 
		--		pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
		--	from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt, Employee e
		--	where pc.EmployeeId=e.Id and e.SSN=EmployeeJson.SSN
		--	and pc.IsVoid=0 and pc.Id=pta.PayCheckId
		--	and pta.PayTypeId = pt.Id
		--	and dateadd(year,-1,@enddate) between pta.FiscalStart and pta.FiscalEnd
		--	group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
		--	for Xml path('PayCheckPayTypeAccumulation') , elements, type
		--) PreviousAccumulations

		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId=Company.Id
		and ((@id is not null and EmployeeJson.Id=@id) or (@id is null))
		and ((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and EmployeeJson.CompanyId=@company) or (@company is null))
		and ((@ssns is not null and EmployeeJson.SSN in (select ssn from @tmpSSNs)) or (@ssns is null))
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO


/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 25/08/2017 1:54:43 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 25/08/2017 1:54:43 PM ******/
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
	@includeHistory bit = 0,
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
	and pc1.IsHistory<=@includeHistory
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
		) end WorkerCompensations

		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId=Company.Id
		and ((@id is not null and EmployeeJson.Id=@id) or (@id is null))
		and ((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and EmployeeJson.CompanyId=@company) or (@company is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
