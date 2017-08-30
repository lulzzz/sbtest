/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 28/08/2017 3:22:42 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesYTD]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 28/08/2017 3:22:42 PM ******/
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
print @ispeo
print @hostid
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
			and pc.CompanyId in (select id from #tmpcomps)
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

/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 29/08/2017 10:29:25 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployees]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 29/08/2017 10:29:25 AM ******/
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
declare @ispeo as bit
declare @hostid as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId from company where id=@company
print @ispeo
print @hostid
select id into #tmpcomps from company
where 
((@ispeo=1 and HostId=@hostid and FileUnderHost=1)
or
(@ispeo=0 and id=@company)
)
	select 
		EmployeeJson.*, 
		Company.HostId HostId, 
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt, Employee e
			where pc.EmployeeId=e.Id and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id
			and e.SSN=EmployeeJson.SSN
			and pc.CompanyId in (select id from #tmpcomps)
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
