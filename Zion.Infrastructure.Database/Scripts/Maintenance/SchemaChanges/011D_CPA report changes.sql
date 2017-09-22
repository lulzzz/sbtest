/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 22/09/2017 2:43:44 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoicesXml]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 22/09/2017 2:43:44 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 22/09/2017 2:43:44 PM ******/
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
			and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1)
			and @report<>'Report1099'
		)
	)

	
	select 
		
		EmployeeJson.Id EmployeeId, EmployeeJson.SSN, EmployeeJson.Department, EmployeeJson.HireDate, EmployeeJson.PayType EmpPayType,
		EmployeeJson.Contact ContactStr, 
		EmployeeJson.FirstName, EmployeeJson.MiddleInitial, EmployeeJson.LastName,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path('CompanyWorkerCompensation'), elements, type),
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
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 22/09/2017 2:43:44 PM ******/
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
	@paymentmethod varchar(max) = '',
	@invoicenumber int = null,
	@bypayday bit = 0
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
	and ((@startdate is not null and case when @bypayday=0 then PayrollInvoiceJson.InvoiceDate else PayrollJson.PayDay end>=@startdate) or (@startdate is null))
	and ((@enddate is not null and case when @bypayday=0 then PayrollInvoiceJson.InvoiceDate else PayrollJson.PayDay end<=@enddate) or (@enddate is null)) 
	and PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	and ((@invoicenumber is not null and PayrollInvoiceJson.InvoiceNumber>@invoicenumber) or (@invoicenumber is null))
	and ((@status <>'' and exists(select 'x' from @tmpStatuses where status=PayrollInvoiceJson.Status)) or (@status=''))
	and ((@paymentstatus <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentStatuses tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=tps.status)) or (@paymentstatus=''))
	and ((@paymentmethod <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentMethods tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method=tps.method)) or (@paymentmethod=''))
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path('PayrollInvoiceJson'), root('PayrollInvoiceJsonList'), elements, type
	

END
GO
