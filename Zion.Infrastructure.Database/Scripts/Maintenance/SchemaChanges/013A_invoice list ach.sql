/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 4/06/2019 1:24:20 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoiceList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoiceList]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 4/06/2019 1:24:20 PM ******/
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
	@paymentmethod varchar(max) = '',
	@includeTaxesDelayed bit = 0
AS
BEGIN
	declare @host1 uniqueidentifier = @host,
	@company1 uniqueidentifier = @company,
	@role1 varchar(max) = @role,
	@status1 varchar(max) = @status,
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@paymentstatus1 varchar(max) = @paymentstatus,
	@paymentmethod1 varchar(max) = @paymentmethod,
	@includeTaxesDelayed1 bit = @includeTaxesDelayed

	declare @where nvarchar(max) = ''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate>=''' + cast(@startdate1 as varchar(max)) + ''''
		
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate<=''' + cast(@enddate1 as varchar(max)) + ''''
		
	if @includeTaxesDelayed1=1 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.TaxesDelayed=1'
	else
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'isnull(PayrollInvoiceJson.TaxesDelayed,0)>=0'	
	if @status1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.status in (' + @status1 + ')'
	if @paymentstatus1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status in (' + @paymentstatus1 + '))'
	if @paymentmethod1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method in (' + @paymentmethod1 + '))'
	
	declare @query as nvarchar(max) ='
		select 
		PayrollInvoiceJson.*,
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
		CompanyJson.CompanyName, CompanyJson.HostId, CompanyJson.IsHostCompany, CompanyJson.IsVisibleToHost, CompanyJson.BusinessAddress, cc.InvoiceSetup InvoiceSetup1
		,(select max(PaymentDate) from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=3) LastPayment,
		STUFF((SELECT '', '' + case when ip.Method=1 then CAST(ip.CheckNumber AS VARCHAR(max)) when ip.Method=2 then ''Cash'' when ip.Method=3 then ''Cert Fund'' when ip.Method=4 then ''Corp Check'' when ip.Method=5 then ''ACH'' end [text()]
         from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id
         FOR XML PATH(''''), TYPE)
        .value(''.'',''NVARCHAR(MAX)''),1,2,'' '') CheckNumbers
		
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson, CompanyContract cc
	Where 
	PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	and CompanyJson.Id = cc.CompanyId
	and ' + @where + 'Order by PayrollInvoicejson.InvoiceNumber
	for Xml path(''PayrollInvoiceListItem''), root(''PayrollInvoiceJsonList''), elements, type'
	
	print @query
	Execute(@query)

END
GO
