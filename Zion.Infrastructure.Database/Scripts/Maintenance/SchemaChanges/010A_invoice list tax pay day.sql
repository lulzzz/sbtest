/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 27/03/2017 9:17:37 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoiceList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoiceList]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 27/03/2017 9:17:37 AM ******/
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
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
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
