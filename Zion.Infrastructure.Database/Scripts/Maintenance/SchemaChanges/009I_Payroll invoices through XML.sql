/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 19/01/2017 12:21:55 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoicesXml]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 19/01/2017 12:21:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollInvoicesXml]
	@host varchar(max) = null,
	@company varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	select 
	(select 
		PayrollInvoiceJson.*,
		(	select PayrollJson.* 
			--from Payroll Where Id=PayrollInvoiceJson.PayrollId 
			for xml path(''Payroll''), elements, type
		),
		(select * from InvoicePayment where InvoiceId=PayrollInvoiceJson.Id for Xml path(''InvoicePaymentJson''), Elements, type) InvoicePayments
		,
		(select 
			CompanyJson.*
			,
			(select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path(''DeductionType''), elements, type) from CompanyDeduction Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyDeductions,
			(select * from CompanyWorkerCompensation Where CompanyId=CompanyJson.Id for Xml auto, elements, type) CompanyWorkerCompensations,
			(select *, (select * from PayType Where Id=CompanyAccumlatedPayType.PayTypeId for xml path(''PayType''), elements, type) from CompanyAccumlatedPayType Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyAccumlatedPayTypes,
			(select * from CompanyContract Where CompanyId=CompanyJson.Id for xml path(''CompanyContract''), elements, type), 
			(select *,(select * from Tax where Id=CompanyTaxRate.TaxId for xml path(''Tax''), elements, type) from CompanyTaxRate Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxRates,
			(select * from CompanyTaxState Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxStates, 
			(select * from CompanyPayCode Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyPayCodes,
			(select * from Company Where ParentId=CompanyJson.Id for xml path(''CompanyJson''), elements, type) Locations,
			(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type)
			
			for Xml path(''Company''), elements, type
		)
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson--, InvoicePayment InvoicePaymentJson
	Where 
	--PayrollInvoiceJson.Id=''1B197EE8-2A08-4358-B35C-A6F200CAF6AE'' and 
	PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	--and PayrollInvoiceJson.Id = InvoicePaymentJson.InvoiceId
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path(''PayrollInvoiceJson''), elements, type
	)ResultList
	for xml path (''XmlResult'')

END' 
END
GO

/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 19/01/2017 8:37:44 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 19/01/2017 8:37:44 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 19/01/2017 8:37:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceChartData]
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
			When DateDiff(day, i.invoicedate, getdate())=1 then ''1 day''
			when DateDiff(day, i.invoicedate, getdate())=2 then ''2 days''
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then ''3-4 days''
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then ''5-9 days''
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then ''10-20 days''
			else
				''Over 20 days''
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
	and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + '',['' + cast(CompanyName as varchar(max)) + '']'',''['' + cast(CompanyName as varchar(max))+ '']'')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = ''select (select top(1) AgeText from #tmpInspectionData t Where t.Age=row.Age1) Age, '' +@companies+ '' from (select Age as Age1,''+@companies+'' from
	(select distinct Age, CompanyName , Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in (''+@companies+''))Data)row order by Age1''
	execute(@query)
	
	drop table #tmpInspectionData
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 19/01/2017 8:37:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollChartData]
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
	select firmname, companyname, [Next Payroll Due], [Next PayDay], Id,
	case  
		when DateDiff(day, getdate(), [Next PayDay])>=5 then
			''5 days+''
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			''4 days''
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			''3 days''
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			''2 days''
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			''1 days''
		else
			''Past Due''

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
				''Never run''
			else
				Case
					When c.PayrollSchedule=1 then
						case when DateAdd(day, 7, c.LastPayrollDate)<GETDATE() then
								''Overdue''
							when DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate))>7 then
								''>7 days''
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate)),'' days'')
							end
					When c.PayrollSchedule=2 then
						case when DateAdd(day, 14, c.LastPayrollDate)<GETDATE() then
								''Overdue''
							when DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate))>7 then
								''>7 days''
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate)),'' days'')
							end
					When c.PayrollSchedule=3 then
						case when DateAdd(day, 15, c.LastPayrollDate)<GETDATE() then
								''Overdue''
							when DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate))>7 then
								''>7 days''
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate)),'' days'')
							end
					When c.PayrollSchedule=4 then
						case when DateAdd(MONTH, 1, c.LastPayrollDate)<GETDATE() then
								''Overdue''
							when DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate))>7 then
								''>7 days''
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate)),'' days'')
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
	and c.StatusId=1
	and c.HostId = h.Id
	and c.id = i.CompanyId
	and i.balance>0
	--and i.Status>=1
	and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	) a
	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + '',['' + cast(CompanyName as varchar(max)) + '']'',''['' + cast(CompanyName as varchar(max))+ '']'')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = ''select (select top(1) [Days till Due] from #tmpInspectionData t Where t.[DaysDue]=row.[DaysDue]) [Days till Due], '' +@companies+ '' from (select [DaysDue],''+@companies+'' from
	(select distinct [DaysDue], CompanyName, Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in (''+@companies+''))Data)row order by [DaysDue]''
	execute(@query)
	
	drop table #tmpInspectionData
END' 
END
GO
