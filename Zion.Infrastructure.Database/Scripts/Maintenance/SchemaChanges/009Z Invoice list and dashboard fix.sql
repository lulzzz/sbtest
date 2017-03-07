/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 7/03/2017 11:55:38 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoiceList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoiceList]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 7/03/2017 11:55:38 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 7/03/2017 11:55:38 AM ******/
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
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select HostId, CompanyId, Host, Company, 
		case 
			when DateDiff(day, getdate(), [Next Payroll])<0 then
				'Overdue'
			when DateDiff(day, getdate(), [Next Payroll])=0 then
				'Today'
			when DateDiff(day, getdate(), [Next Payroll])=1 then
				'1 day'
			when DateDiff(day, getdate(), [Next Payroll])=2 then
				'2 days'
			when DateDiff(day, getdate(), [Next Payroll])=3 then
				'3 days'
			when DateDiff(day, getdate(), [Next Payroll])=4 then
				'4 days'
			when DateDiff(day, getdate(), [Next Payroll])=5 then
				'5 days'
			end
			Due
	
	from	
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host,
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
		
	from Company c, Host h 
	Where 
	c.StatusId=1
	and h.id = c.HostId
		and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	) a
	where DateDiff(day, getdate(), [Next Payroll])<6
	order by Due


END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 7/03/2017 11:55:38 AM ******/
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
	@enddate datetime = null
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

	
		select 
		PayrollInvoiceJson.*,
		CompanyJson.CompanyName, CompanyJson.HostId, CompanyJson.IsHostCompany, CompanyJson.IsVisibleToHost,
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
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path('PayrollInvoiceListItem'), root('PayrollInvoiceJsonList'), elements, type

END
GO
