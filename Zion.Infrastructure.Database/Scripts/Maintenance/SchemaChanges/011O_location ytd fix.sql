/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 20/12/2017 1:41:04 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesYTD]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 20/12/2017 1:41:04 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 20/12/2017 1:41:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanies] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanies]
	@host uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
	select 
		CompanyJson.*,
		case when exists(select 'x' from company where parentid=CompanyJson.Id) then 1 else 0 end HasLocations
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
		From Company CompanyJson
		Where
		((@id is not null and Id=@id) or (@id is null))
		and ((@host is not null and HostId=@host) or (@host is null))
		and ((@status is not null and StatusId=cast(@status as int)) or (@status is null))
		and (
					(@role is not null and @role='HostStaff' and IsHostCompany=0) 
					or (@role is not null and @role='CorpStaff' and IsHostCompany=0) 
					or (@role is null)
				)
		Order by CompanyJson.CompanyNumber
		for Xml path('CompanyJson'), root('CompanyList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 20/12/2017 1:41:04 PM ******/
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
declare @parent as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId, @parent=ParentId from company where id=@company
print @ispeo
print @hostid
select id into #tmpcomps from company
where 
((@ispeo=1 and HostId=@hostid and FileUnderHost=1)
or
(@ispeo=0 and (id=@company or ParentId=@company))
or
(@ispeo=0 and @parent is not null and (id=@parent or ParentId=@parent))
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
			and pc.PayDay between @startdate and @enddate
			and pc.CompanyId in (select id from #tmpcomps)
			and pta.PayTypeId = pt.Id			
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) Accumulations
		
		
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
