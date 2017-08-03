/****** Object:  StoredProcedure [dbo].[GetUserDashboard]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetUserDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollProcessingPerformanceChart]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollProcessingPerformanceChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollProcessingPerformanceChart]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusPastDueChartData]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusPastDueChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceStatusPastDueChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusDetailedChartData]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusDetailedChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceStatusDetailedChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusChartData]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceStatusChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesYTD]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionsReport]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionsReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCommissionsReport]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionPerformanceChart]    Script Date: 3/08/2017 1:33:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionPerformanceChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCommissionPerformanceChart]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionPerformanceChart]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionPerformanceChart]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCommissionPerformanceChart] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCommissionPerformanceChart]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 0
AS
BEGIN
	declare @users varchar(max)
	declare @query varchar(max)	

	select (u.FirstName + ' ' + u.LastName) [User], LEFT(datename(month,InvoiceDate),3) + ' ' + Right(cast(year(InvoiceDate) as varchar),2) Month, Commission
	into #tmpInspectionData
	from PayrollInvoice i, AspNetUsers u, Company c
	where 
		i.SalesRep=u.Id
		and i.CompanyId = c.Id
		and ((@onlyActive=1 and c.StatusId=1) or (@onlyActive=0))
		and i.Balance<=0
		and ((@startdate is not null and i.InvoiceDate>=@startdate) or (@startdate is null))
		and ((@enddate is not null and i.InvoiceDate<=@enddate) or (@enddate is null))
		
	SELECT @users = COALESCE(@users + ',[' + cast([User] as varchar) + ']','[' + cast([User] as varchar)+ ']')
	FROM (select distinct [User] from #tmpInspectionData)a
	

	set @query = 'select Month, ' +@users+ ' from (select Data.Month,'+@users+' from
	(select Month, [User], Commission
	from #tmpInspectionData
	) o
	PIVOT (sum(Commission) for [User] in ('+@users+'))Data)t order by convert(datetime, ''01 ''+Month, 6)'
	
	select 'GetCommissionPerformanceChart' Report;			
	execute(@query)
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionsReport]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionsReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCommissionsReport] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCommissionsReport]
	@startdate datetime = null,
	@enddate datetime = null,
	@userId uniqueidentifier = null,
	@includeinactive bit
AS
BEGIN
	print @includeinactive
	select 
	(select
		u.Id as UserId, u.FirstName + ' ' + u.LastName as Name,
		(
			select 
				i.Id as InvoiceId, i.Commission,  i.InvoiceDate, c.CompanyName, i.InvoiceNumber
			from PayrollInvoice i, Company c
			where i.CompanyId = c.Id
			and ((@includeinactive=1) or (@includeinactive=0 and c.StatusId=1))
			--and c.StatusId=1
			and u.Active=1
			and i.SalesRep = u.Id
			and ((@userId is not null and i.SalesRep = @userId) or (@userId is null))
			and ((@startdate is not null and i.InvoiceDate>=@startdate) or (@startdate is null))
			and ((@enddate is not null and i.InvoiceDate<=@enddate) or (@enddate is null))
			and not exists(select 'x' from CommissionExtract where PayrollInvoiceId=i.id)
			and i.Balance=0
			for xml path('InvoiceCommission'), ELEMENTS, type
		) Commissions
	from AspNetUsers u
	where 
	u.Active=1
	and ((@userId is not null and u.Id = @userId) or (@userId is null))
	for xml path('ExtractSalesRep'), ELEMENTS, type) SalesReps
	for xml path('CommissionsResponse'), ELEMENTS, type
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompaniesNextPayrollChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select HostId, CompanyId, Host, Company, InvoiceSetup,
			DateDiff(day, getdate(), [Next Payroll]) Due
	
	from	
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup,
		Case
			When c.LastPayrollDate is not null Then
				Case
					When c.PayrollSchedule=1 then
						DateAdd(day, 7, c.LastPayrollDate)
				
					When c.PayrollSchedule=2 then
						DateAdd(day, 14, c.LastPayrollDate)
				
					When c.PayrollSchedule=3 then
						DateAdd(day, 15, c.LastPayrollDate)
				
					When c.PayrollSchedule=4 then
						DateAdd(MONTH, 1, c.LastPayrollDate)
				End
			Else
				Cast('01/01/' + cast(year(getdate()) as varchar(max)) as datetime)
					
			
		end [Next Payroll]
		
	from Company c, Host h , CompanyContract cc
	Where 
	c.StatusId=1
	and h.id = c.HostId
	and c.Id=cc.CompanyId
		and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	) a
	where DateDiff(day, getdate(), [Next Payroll])<6
	
	order by Due


END
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompaniesWithoutPayroll] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select HostId, CompanyId, Host, Company, InvoiceSetup,
		DateDiff(day, CreationDate, getdate() ) [Days past]
	from 
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup,
		Case
			When exists(select 'x' from PaxolArchive.Common.Memento  where SourceTypeId=2 and MementoId=c.Id) Then
				(select max(DateCreated) from PaxolArchive.Common.Memento  where SourceTypeId=2 and MementoId=c.Id)
			Else
				c.LastModified
					
			
		end CreationDate
		
	from Company c, Host h , CompanyContract cc
	Where 
	c.StatusId=1
	and h.id = c.HostId
	and c.Id = cc.CompanyId
		and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from Payroll where CompanyId=c.Id)
	)a
	where 
	DateDiff(day, CreationDate, getdate() )>0
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 3/08/2017 1:33:33 PM ******/
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
				pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayCheckPayTypeAccumulation pta, PayType pt
			where pta.PayTypeId = pt.Id
			and pta.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) Accumulations,
		
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt, Employee e
			where pc.EmployeeId=e.Id and e.SSN=EmployeeJson.SSN
			and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id
			and dateadd(year,-1,@enddate) between pta.FiscalStart and pta.FiscalEnd
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) PreviousAccumulations

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
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select c.CompanyName, DateDiff(day, i.invoicedate, getdate()) age1,i.invoicedate,
		case  
			When DateDiff(day, i.invoicedate, getdate())=1 then 1
			when DateDiff(day, i.invoicedate, getdate())=2 then 2
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then 3
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then 5
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then 10
			else
				20
			end 
		Age,
		case  
			When DateDiff(day, i.invoicedate, getdate())=1 then '1 day'
			when DateDiff(day, i.invoicedate, getdate())=2 then '2 days'
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then '3-4 days'
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then '5-9 days'
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then '10-20 days'
			else
				'Over 20 days'
			end 
		AgeText,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	and c.StatusId=1
	and i.Balance>0
	and DateDiff(day, i.invoicedate, getdate()) >0
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) AgeText from #tmpInspectionData t Where t.Age=row.Age1) Age, ' +@companies+ ' from (select Age as Age1,'+@companies+' from
	(select distinct Age, CompanyName , Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by Age1'
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusChartData]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceStatusChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceStatusChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select c.CompanyName, 
			case i.Status 
				when 1 then 'Draft' when 2 then 'Approved' when 3 then 'Delivered'
				when 5 then 'Taxes Delayed' when 6 then 'Bounced'
				when 7 then 'Partial Payment' when 9 then 'Not Deposited' when 10 then 'ACH Pending'
				end as  StatusName,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	and ((@onlyActive=1 and c.StatusId=1) or (@onlyActive=0))
	and i.Balance>0
	and i.Status not in (4, 8)
	and ((@startdate is not null and i.InvoiceDate>=@startdate) or (@startdate is null))
	and ((@enddate is not null and i.InvoiceDate<=@enddate) or (@enddate is null))
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(StatusName as varchar(max)) + ']','[' + cast(StatusName as varchar(max))+ ']')
	FROM (select distinct StatusName from #tmpInspectionData) a
	
	print @companies
	
	select 'GetInvoiceStatusChartData' Report;
	select StatusName Status, count(Id) NoOfInvoices
	from #tmpInspectionData
	group by StatusName
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusDetailedChartData]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusDetailedChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceStatusDetailedChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceStatusDetailedChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@criteria varchar(max),
	@onlyActive bit = 1
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	declare @status int = null
	select @status = case @criteria
					when 'Draft' then 1
					when 'Approved' then 2
					when 'Delivered' then 3
					when 'Closed' then 4
					when 'Taxes Delayed' then 5
					when 'Bounced' then 6
					when 'Partial Payment' then 7
					when 'Deposited' then 8
					when 'Not Deposited' then 9
					when 'ACH Pending' then 10
					end
	select firmname, companyname, [Next Payroll Due], [Next PayDay], Id,
	case  
		when DateDiff(day, getdate(), [Next PayDay])>=5 then
			'5 days+'
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			'4 days'
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			'3 days'
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			'2 days'
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			'1 days'
		else
			'Past Due'

	end
	[Days till Due],
	case  
		when DateDiff(day, getdate(), [Next PayDay])>=5 then
			5
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			4
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			3
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			2
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			1
		else
			0

	end
	[DaysDue]
	into #tmpInspectionData
	from
	(
	select h.firmname, c.CompanyName, i.InvoiceDate,
		case 
			when c.LastPayrollDate is null then 
				'Never run'
			else
				Case
					When c.PayrollSchedule=1 then
						case when DateAdd(day, 7, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=2 then
						case when DateAdd(day, 14, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=3 then
						case when DateAdd(day, 15, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=4 then
						case when DateAdd(MONTH, 1, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate)),' days')
							end					
				end
		end [Next Payroll Due],
		Case
			When c.PayrollSchedule=1 then
				DateAdd(day, 7, p.PayDay)
			When c.PayrollSchedule=2 then
				DateAdd(day, 14, p.PayDay)
			When c.PayrollSchedule=3 then
				DateAdd(day, 15, p.PayDay)
			When c.PayrollSchedule=4 then
				DateAdd(month, 1, p.PayDay)				
		end
		[Next PayDay],
		i.Id
		
	from Company c, Host h, PayrollInvoice i, Payroll p
	Where 
	i.PayrollId=p.Id
	and ((@onlyActive=1 and c.StatusId=1) or (@onlyActive=0))
	and c.HostId = h.Id
	and c.id = i.CompanyId
	and i.balance>0
	--and i.Status>=1
	and ((@startdate is not null and i.InvoiceDate>=@startdate) or (@startdate is null))
	and ((@enddate is not null and i.InvoiceDate<=@enddate) or (@enddate is null))
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)
	and ((@status is not null and i.Status=@status) or (@status is null))
	) a
	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) [Days till Due] from #tmpInspectionData t Where t.[DaysDue]=row.[DaysDue]) [Days till Due], ' +@companies+ ' from (select [DaysDue],'+@companies+' from
	(select distinct [DaysDue], CompanyName, Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by [DaysDue]';

	select 'GetInvoiceStatusDetailedChartData' Report;
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusPastDueChartData]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusPastDueChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceStatusPastDueChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceStatusPastDueChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@criteria varchar(max),
	@onlyActive bit = 1
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	declare @status int = null
	select @status = case @criteria
					when 'Draft' then 1
					when 'Approved' then 2
					when 'Delivered' then 3
					when 'Closed' then 4
					when 'Taxes Delayed' then 5
					when 'Bounced' then 6
					when 'Partial Payment' then 7
					when 'Deposited' then 8
					when 'Not Deposited' then 9
					when 'ACH Pending' then 10
					end

	select c.CompanyName, DateDiff(day, i.invoicedate, getdate()) age1,i.invoicedate,
		case  
			When DateDiff(day, i.invoicedate, getdate())=1 then 1
			when DateDiff(day, i.invoicedate, getdate())=2 then 2
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then 3
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then 5
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then 10
			else
				20
			end 
		Age,
		case  
			When DateDiff(day, i.invoicedate, getdate())=1 then '1 day'
			when DateDiff(day, i.invoicedate, getdate())=2 then '2 days'
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then '3-4 days'
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then '5-9 days'
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then '10-20 days'
			else
				'Over 20 days'
			end 
		AgeText,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	and ((@onlyActive=1 and c.StatusId=1) or (@onlyActive=0))
	and i.Balance>0
	and DateDiff(day, i.invoicedate, getdate()) >0
	and ((@startdate is not null and i.InvoiceDate>=@startdate) or (@startdate is null))
	and ((@enddate is not null and i.InvoiceDate<=@enddate) or (@enddate is null))
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)
	and ((@status is not null and i.Status=@status) or (@status is null))

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) AgeText from #tmpInspectionData t Where t.Age=row.Age1) Age, ' +@companies+ ' from (select Age as Age1,'+@companies+' from
	(select distinct Age, CompanyName , Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by Age1';
	select 'GetInvoiceStatusPastDueChartData' Report;
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollProcessingPerformanceChart]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollProcessingPerformanceChart]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollProcessingPerformanceChart] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollProcessingPerformanceChart]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 0
AS
BEGIN
	declare @users varchar(max)
	declare @query varchar(max)	

	select i.ProcessedBy [User], LEFT(datename(month,i.ProcessedOn),3) + ' ' + Right(cast(year(i.ProcessedOn) as varchar),2) Month, i.Id 
	into #tmpInspectionData
	from PayrollInvoice i, Payroll p, Company c
	where 
		i.Id=p.InvoiceId
		and i.CompanyId=c.Id
		and ((@onlyActive=1 and c.StatusId=1) or (@onlyActive=0))
		and exists(select 'x' from PayrollPayCheck pp where pp.PayrollId=p.Id and pp.IsVoid=0)
		and ((@startdate is not null and i.ProcessedOn>=@startdate) or (@startdate is null))
		and ((@enddate is not null and i.ProcessedOn<=@enddate) or (@enddate is null))

		
	SELECT @users = COALESCE(@users + ',[' + cast([User] as varchar) + ']','[' + cast([User] as varchar)+ ']')
	FROM (select distinct [User] from #tmpInspectionData)a
	
	set @query = 'select Month, ' +@users+ ' from (select Data.Month,'+@users+' from
	(select distinct Month, [User], Id
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for [User] in ('+@users+'))Data)t order by convert(datetime, ''01 ''+Month, 6)'
	
	select 'GetPayrollProcessingPerformanceChart' Report;	
	execute(@query)
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollsWithoutInvoice] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select h.Id HostId, c.Id as CompanyId, h.firmname Host, c.CompanyName Company, count(p.Id) Due
	from Company c, Host h, CompanyContract cc, Payroll p Left outer join PayrollInvoice i on p.Id = i.PayrollId
	Where 
	h.id = c.HostId
	and c.StatusId=1
	and c.id=cc.CompanyId
	and c.HostId = h.Id
	and c.id=p.CompanyId
	and cc.[Type]=2 and cc.BillingType=3
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and (c.HostId<>@rootHost or (c.HostId=@rootHost and c.IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and (i.Id is null or i.Status=1)
	and exists (select 'x' from PayrollPayCheck where PayrollId=p.Id and IsVoid=0)
	and p.CopiedFrom is null and p.MovedFrom is null
	--and p.Id is null
	group by h.Id, c.Id, h.FirmName, c.CompanyName
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserDashboard]    Script Date: 3/08/2017 1:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserDashboard]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetUserDashboard] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetUserDashboard]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	select 'GetCompaniesNextPayrollChartData' Report;
	exec GetCompaniesNextPayrollChartData @startdate, @enddate, @host, @role, @onlyActive;
	select 'GetCompaniesWithoutPayroll' Report;
	exec GetCompaniesWithoutPayroll @startdate, @enddate, @host, @role, @onlyActive;
	--select 'GetInvoiceChartData' Report;
	--exec GetInvoiceChartData @startdate, @enddate, @host, @role;
	--select 'GetPayrollChartData' Report;
	--exec GetPayrollChartData @startdate, @enddate, @host, @role;
	select 'GetPayrollsWithoutInvoice' Report;
	exec GetPayrollsWithoutInvoice @startdate, @enddate, @host, @role, @onlyActive;
	
END
GO
