/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 18/05/2018 4:23:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 18/05/2018 4:23:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoicesXml]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 18/05/2018 4:23:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoiceList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoiceList]
GO
/****** Object:  StoredProcedure [dbo].[GetPaychecks]    Script Date: 18/05/2018 4:23:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaychecks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPaychecks]
GO
/****** Object:  StoredProcedure [dbo].[GetMinifiedPayrolls]    Script Date: 18/05/2018 4:23:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinifiedPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMinifiedPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 18/05/2018 4:23:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournals]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyInvoices]    Script Date: 18/05/2018 4:23:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyInvoices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyInvoices]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyInvoices]    Script Date: 18/05/2018 4:23:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyInvoices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyInvoices] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyInvoices]
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = '',
	@startdate datetime = null,
	@enddate datetime = null,
	@id uniqueidentifier=null
AS
BEGIN
	declare @where nvarchar(max) = ''
	if @id is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollInvoiceJson.Id=''' + cast(@Id as varchar(max)) + ''''
	if @company is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.CompanyId=''' + cast(@company as varchar(max)) + ''''
	if @startdate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate>=''' + cast(@startdate as varchar(max)) + ''''
		
	if @enddate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate<=''' + cast(@enddate as varchar(max)) + ''''
		
	
	if @status<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.status in (' + @status + ')'
	declare @query nvarchar(max) ='
	select 
		PayrollInvoiceJson.*,
		case when exists(select  ''x'' from CommissionExtract where PayrollInvoiceId=PayrollInvoiceJson.Id) then 1 else 0 end CommissionClaimed,
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
		(select * from InvoicePayment where InvoiceId=PayrollInvoiceJson.Id for Xml path(''InvoicePaymentJson''), Elements, type) InvoicePayments
		
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson
	Where 
	PayrollInvoiceJson.PayrollId=PayrollJson.Id and ' + @where + 'Order by PayrollInvoicejson.InvoiceNumber
	for Xml path(''PayrollInvoiceJson''), root(''PayrollInvoiceJsonList''), elements, type'

	print @query
	Execute(@query)
	--((@id is not null and PayrollInvoiceJson.Id=@id) or (@id is null)) 
	--and ((@company is not null and PayrollInvoiceJson.CompanyId=@company) or (@company is null)) 
	--and ((@startdate is not null and PayrollInvoiceJson.InvoiceDate>=@startdate) or (@startdate is null))
	--and ((@enddate is not null and PayrollInvoiceJson.InvoiceDate<=@enddate) or (@enddate is null)) 
	
	--and ((@status <>'' and exists(select 'x' from @tmpStatuses where status=PayrollInvoiceJson.Status)) or (@status=''))
	--Order by PayrollInvoicejson.InvoiceNumber
	--for Xml path('PayrollInvoiceJson'), root('PayrollInvoiceJsonList'), elements, type
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 18/05/2018 4:23:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetJournals] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetJournals]
	@company uniqueidentifier = null,
	@paycheck int=null,
	@startdate datetime = null,
	@enddate datetime = null,
	@id int=null,
	@void int=null,
	@year int = null,
	@transactiontype int = null,
	@accountid int = null,
	@PEOASOCoCheck bit = null,
	@payrollid uniqueidentifier = null,
	@includePayrollJournals bit = 0,
	@includeDetails bit = 1
AS
BEGIN
	declare @where nvarchar(max) = ''
	if @id is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Id=' + cast(@Id as varchar(max))
	if @paycheck is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollPayCheckId=' + cast(@paycheck as varchar(max))
	if @payrollid is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollId=''' + cast(@payrollid as varchar(max)) + ''''
	if @accountid is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'MainAccountId=' + cast(@accountid as varchar(max))
	if @company is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'CompanyId=''' + cast(@company as varchar(max)) + ''''
	if @transactiontype is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionType=' + cast(@transactiontype as varchar(max))
	if @startdate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate>=''' + cast(@startdate as varchar(max)) + ''''
	if @enddate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate<=''' + cast(@enddate as varchar(max)) + ''''
	if @PEOASOCoCheck is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PEOASOCoCheck=' + cast(@PEOASOCoCheck as varchar(max))
	if @void is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsVoid=' + cast(@void as varchar(max))
	if @year is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'year(TransactionDate)=' + cast(@year as varchar(max))

	declare @query as nvarchar(max) = ''
	set @query = 'select 
			*
		from CheckbookJournal
		where ' + @where
	if @includePayrollJournals=1
	begin
		set @query = @query + ' Union select 
			[Id]
      ,[CompanyId]
      ,[TransactionType]
      ,[PaymentMethod]
      ,[CheckNumber]
      ,[PayrollPayCheckId]
      ,[EntityType]
      ,[PayeeId]
      ,[PayeeName]
      ,[Amount]
      ,[Memo]
      ,[IsDebit]
      ,[IsVoid]
      ,[MainAccountId]
      ,[TransactionDate]
      ,[LastModified]
      ,[LastModifiedBy],'
	  if @includeDetails=1 
		set @query = @query + '[JournalDetails] as JournalDetails, '
		else 
		set @query = @query + ''''' as JournalDetails, '
      --,case when @includeDetails=1 then [JournalDetails] else '' end as JournalDetails
      set @query = @query + '[DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId]
		from Journal
		where ' + @where
	end
	set @query = @query + 'for Xml path(''JournalJson''), root(''JournalList''), Elements, type'
	print @query
	Execute(@query)
	--select 
	--		*
	--	from CheckbookJournal
	--	where
	--		((@id is not null and Id=@id) or (@id is null)) 
	--		and ((@payrollid is null) or (@payrollid is not null and PayrollId = @payrollid))
	--		and ((@paycheck is null) or (@paycheck is not null and PayrollPayCheckId=@paycheck)) 
	--		and ((@accountid is not null and MainAccountId=@accountid) or @accountid is null)
	--		and ((@company is not null and CompanyId=@company) or (@company is null)) 
	--		and ((@transactiontype is not null and TransactionType=@transactiontype) or @transactiontype is null)
	--		and ((@startdate is not null and TransactionDate>=@startdate) or (@startdate is null)) 
	--		and ((@enddate is not null and TransactionDate<=@enddate) or (@enddate is null)) 
			
	--		and ((@PEOASOCoCheck is not null and PEOASOCoCheck=@PEOASOCoCheck) or @PEOASOCoCheck is null)
	--		and ((@void is not null and IsVoid=@void) or (@void is null))			
						
	--		and ((@year is not null and year(TransactionDate)=@year) or @year is null)
	--	Union
	--	select 
	--		[Id]
 --     ,[CompanyId]
 --     ,[TransactionType]
 --     ,[PaymentMethod]
 --     ,[CheckNumber]
 --     ,[PayrollPayCheckId]
 --     ,[EntityType]
 --     ,[PayeeId]
 --     ,[PayeeName]
 --     ,[Amount]
 --     ,[Memo]
 --     ,[IsDebit]
 --     ,[IsVoid]
 --     ,[MainAccountId]
 --     ,[TransactionDate]
 --     ,[LastModified]
 --     ,[LastModifiedBy]
 --     ,case when @includeDetails=1 then [JournalDetails] else '' end as JournalDetails
 --     ,[DocumentId]
 --     ,[PEOASOCoCheck]
 --     ,[OriginalDate]
 --     ,[IsReIssued]
 --     ,[OriginalCheckNumber]
 --     ,[ReIssuedDate]
 --     ,[PayrollId]
 --     ,[CompanyIntId]
	--	from Journal
	--	where
	--		@includePayrollJournals=1 
			
			
	--		and ( @accountid is null or (@accountid is not null and MainAccountId=@accountid))
	--		and ((@company is null) or (@company is not null and CompanyId=@company)) 
	--		and ((@startdate is null) or (@startdate is not null and TransactionDate>=@startdate)) 
	--		and ((@enddate is null) or (@enddate is not null and TransactionDate<=@enddate))
	--		--and ((@PEOASOCoCheck is not null and PEOASOCoCheck=@PEOASOCoCheck) or @PEOASOCoCheck is null) 
	--		--and ((@payrollid is null) or (@payrollid is not null and PayrollId = @payrollid))
	--		--and ((@id is null) or (@id is not null and Id=@id)) 
	--		--and ((@void is null) or (@void is not null and IsVoid=@void))			
			
	--		--and ((@paycheck is null) or (@paycheck is not null and PayrollPayCheckId=@paycheck)) 
			
			
	--		--and ( @year is null or (@year is not null and year(TransactionDate)=@year))

	--	Order by Id 
	--	for Xml path('JournalJson'), root('JournalList'), Elements, type
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetMinifiedPayrolls]    Script Date: 18/05/2018 4:23:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinifiedPayrolls]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetMinifiedPayrolls] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetMinifiedPayrolls]
	@company varchar(max) = null,
	@startdate varchar(max) = null,
	@enddate varchar(max) = null,
	@id uniqueidentifier=null,
	@invoice uniqueidentifier=null,
	@status varchar(max)=null,
	@void int=null,
	@isprinted bit = null
AS
BEGIN
	declare @where nvarchar(max) = ''
	if @id is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Payroll.Id=''' + cast(@Id as varchar(max)) + ''''
	if @company is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.CompanyId=''' + cast(@company as varchar(max)) + ''''
	if @invoice is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Pinv.Id=''' + cast(@invoice as varchar(max)) + ''''
	if @startdate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.PayDay>=''' + cast(@startdate as varchar(max)) + ''''
		
	if @enddate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.PayDay<=''' + cast(@enddate as varchar(max)) + ''''
		
	if @status<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.status =' + @status
	if @void is not null
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.IsVoid =0'
	if @isprinted is not null
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.IsPrinted =' + cast(@isprinted as varchar(1))
	
	declare @query as nvarchar(max)=''
	set @query ='
	select
		Payroll.Id, Company.CompanyName, Payroll.PayDay, Payroll.StartDate, Payroll.EndDate,Payroll.Status, Payroll.LastModifiedBy ProcessedBy, Payroll.LastModified, Payroll.IsHistory,
		Pinv.Id as InvoiceId,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		sum(PayrollPayCheck.GrossWage) TotalGrossWage, sum(PayrollPayCheck.NetWage) TotalNetWage
		from PayrollPayCheck, Company, Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where
		Company.Id=Payroll.CompanyId
		and Payroll.Id=PayrollPayCheck.PayrollId
		and Payroll.IsQueued=0 and ' + @where + 'group by Payroll.Id, Company.CompanyName, Payroll.PayDay, Payroll.StartDate, Payroll.EndDate,Payroll.Status, Payroll.LastModifiedBy, Payroll.LastModified, Payroll.IsHistory,
		Pinv.Id,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status
		Order by PayDay
		for Xml path(''PayrollMinified''), root(''PayrollMinifiedList''), elements, type'
		--and ((@void is null) or (@void is not null and Payroll.IsVoid=0))
		--and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		--and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		--and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		--and ((@startdate is not null and Payroll.PayDay>=@startdate) or (@startdate is null)) 
		--and ((@enddate is not null and Payroll.PayDay<=@enddate) or (@enddate is null)) 
		--and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		--and ((@isprinted is not null and Payroll.IsPrinted = @isprinted) or @isprinted is null)
		--group by Payroll.Id, Company.CompanyName, Payroll.PayDay, Payroll.StartDate, Payroll.EndDate,Payroll.Status, Payroll.LastModifiedBy, Payroll.LastModified, Payroll.IsHistory,
		--Pinv.Id,
		--Pinv.Total, Pinv.InvoiceNumber, Pinv.Status
		--Order by PayDay
		--for Xml path('PayrollMinified'), root('PayrollMinifiedList'), elements, type
	Execute(@query)
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPaychecks]    Script Date: 18/05/2018 4:23:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaychecks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPaychecks] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPaychecks]
	@company uniqueidentifier = null,
	@employee uniqueidentifier = null,
	@payroll uniqueidentifier=null,
	@startdate datetime = null,
	@enddate datetime = null,
	@id int=null,
	@status varchar(max)=null,
	@void int=null,
	@year int = null
AS
BEGIN
	declare @where nvarchar(max) = ''
	declare @query nvarchar(max) =''
	if @id is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollPayCheck.Id=' + cast(@Id as varchar(max))
	if @payroll is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheckPayrollId=''' + cast(@payroll as varchar(max)) + ''''
	if @company is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.CompanyId=''' + cast(@company as varchar(max)) + ''''
	if @employee is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.EmployeeId=''' + cast(@employee as varchar(max)) + ''''
	if @startdate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.PayDay>=''' + cast(@startdate as varchar(max)) + ''''
	if @enddate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.PayDay<=''' + cast(@enddate as varchar(max)) + ''''
	if @status is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.Status=cast(' + @status +' as int)'
	if @void is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.IsVoid=' + cast(@void as varchar(max))
	if @year is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'year(PayrollPayCheck.PayDay)=' + cast(@year as varchar(max))

		set @query = 'select 
			PayrollPayCheck.*
		from PayrollPayCheck 
		where ' + @where +  'Order by PayrollPayCheck.Id 
		for Xml path(''PayrollPayCheckJson''), root(''PayCheckList''), Elements, type'
		--	((@void is not null and PayrollPayCheck.IsVoid=@void) or (@void is null))
		--	and ((@id is not null and PayrollPayCheck.Id=@id) or (@id is null))
		--	and ((@payroll is not null and PayrollPayCheck.PayrollId=@payroll) or (@payroll is null)) 
		--	and ((@company is not null and PayrollPayCheck.CompanyId=@company) or (@company is null)) 
		--	and ((@employee is not null and PayrollPayCheck.EmployeeId=@employee) or (@employee is null)) 
		--	and ((@startdate is not null and PayrollPayCheck.PayDay>=@startdate) or (@startdate is null)) 
		--	and ((@enddate is not null and PayrollPayCheck.PayDay<=@enddate) or (@enddate is null)) 
		--	and ((@status is not null and PayrollPayCheck.Status=cast(@status as int)) or @status is null)
		--	and ((@year is not null and year(PayrollPayCheck.PayDay)=@year) or @year is null)
		--Order by PayrollPayCheck.Id 
		--for Xml path('PayrollPayCheckJson'), root('PayCheckList'), Elements, type
		
	print @query
	execute(@query)
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 18/05/2018 4:23:46 PM ******/
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
	
	declare @where nvarchar(max) = ''
	if @company is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.CompanyId=''' + cast(@company as varchar(max)) + ''''
	if @startdate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate>=''' + cast(@startdate as varchar(max)) + ''''
		
	if @enddate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate<=''' + cast(@enddate as varchar(max)) + ''''
		
	if @includeTaxesDelayed=1 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.TaxesDelayed=1'
	else
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'isnull(PayrollInvoiceJson.TaxesDelayed,0)>=0'	
	if @status<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.status in (' + @status + ')'
	if @paymentstatus<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status in (' + @paymentstatus + '))'
	if @paymentmethod<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method in (' + @paymentmethod + '))'
	
	declare @query as nvarchar(max) ='
		select 
		PayrollInvoiceJson.*,
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
		CompanyJson.CompanyName, CompanyJson.HostId, CompanyJson.IsHostCompany, CompanyJson.IsVisibleToHost, CompanyJson.BusinessAddress
		,(select max(PaymentDate) from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=3) LastPayment,
		STUFF((SELECT '', '' + case when ip.Method=1 then CAST(ip.CheckNumber AS VARCHAR(max)) when ip.Method=2 then ''Cash'' when ip.Method=3 then ''Cert Fund'' when ip.Method=4 then ''Corp Check'' when ip.Method=5 then ''ACH'' end [text()]
         from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id
         FOR XML PATH(''''), TYPE)
        .value(''.'',''NVARCHAR(MAX)''),1,2,'' '') CheckNumbers
		
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson--, InvoicePayment InvoicePaymentJson
	Where 
	PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	and ' + @where + 'Order by PayrollInvoicejson.InvoiceNumber
	for Xml path(''PayrollInvoiceListItem''), root(''PayrollInvoiceJsonList''), elements, type'
	--and ((@company is not null and PayrollInvoiceJson.CompanyId=@company) or (@company is null)) 
	--and ((@startdate is not null and PayrollInvoiceJson.InvoiceDate>=@startdate) or (@startdate is null))
	--and ((@enddate is not null and PayrollInvoiceJson.InvoiceDate<=@enddate) or (@enddate is null)) 
	
	--and ((@status <>'' and exists(select 'x' from @tmpStatuses where status=PayrollInvoiceJson.Status)) or (@status=''))
	--and ((@paymentstatus <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentStatuses tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=tps.status)) or (@paymentstatus=''))
	--and ((@paymentmethod <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentMethods tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method=tps.method)) or (@paymentmethod=''))
	--and ((@includeTaxesDelayed=1  and PayrollInvoiceJson.TaxesDelayed=1) or (@includeTaxesDelayed=0 and isnull(PayrollInvoiceJson.TaxesDelayed,0)>=0))
	--Order by PayrollInvoicejson.InvoiceNumber
	--for Xml path('PayrollInvoiceListItem'), root('PayrollInvoiceJsonList'), elements, type
	print @query
	Execute(@query)

END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 18/05/2018 4:23:46 PM ******/
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
	
	declare @where nvarchar(max) = ''
	if @id is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollInvoiceJson.Id=''' + cast(@Id as varchar(max)) + ''''
	if @company is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.CompanyId=''' + cast(@company as varchar(max)) + ''''
	if @startdate is not null 
		begin
			if @bypayday=0
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate>=''' + cast(@startdate as varchar(max)) + ''''
			else
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollJson.PayDay>=''' + cast(@startdate as varchar(max)) + ''''
		
		end
	if @enddate is not null 
		begin
			if @bypayday=0
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate<=''' + cast(@enddate as varchar(max)) + ''''
			else
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollJson.PayDay<=''' + cast(@enddate as varchar(max)) + ''''
		
		end
	if @invoicenumber is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceNumber>' + cast(@invoicenumber as varchar(max))	
	if @status<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.status in (' + @status + ')'
	if @paymentstatus<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status in (' + @paymentstatus + '))'
	if @paymentmethod<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method in (' + @paymentmethod + '))'
	
	declare @query as nvarchar(max)=''
	set @query ='
	select 
		PayrollInvoiceJson.*,
		case when exists(select  ''x'' from CommissionExtract where PayrollInvoiceId=PayrollInvoiceJson.Id) then 1 else 0 end CommissionClaimed,
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
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
			(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type),
			(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=CompanyJson.Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
			for Xml path(''Company''), elements, type
		)
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson
	Where 
	PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id and ' + @where + ' Order by PayrollInvoicejson.InvoiceNumber
	for Xml path(''PayrollInvoiceJson''), root(''PayrollInvoiceJsonList''), elements, type'
	print @query
	Execute(@query)
	--and ((@id is not null and PayrollInvoiceJson.Id=@id) or (@id is null)) 
	--and ((@company is not null and PayrollInvoiceJson.CompanyId=@company) or (@company is null)) 
	--and ((@startdate is not null and case when @bypayday=0 then PayrollInvoiceJson.InvoiceDate else PayrollJson.PayDay end>=@startdate) or (@startdate is null))
	--and ((@enddate is not null and case when @bypayday=0 then PayrollInvoiceJson.InvoiceDate else PayrollJson.PayDay end<=@enddate) or (@enddate is null)) 
	
	--and ((@invoicenumber is not null and PayrollInvoiceJson.InvoiceNumber>@invoicenumber) or (@invoicenumber is null))
	--and ((@status <>'' and exists(select 'x' from @tmpStatuses where status=PayrollInvoiceJson.Status)) or (@status=''))
	--and ((@paymentstatus <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentStatuses tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=tps.status)) or (@paymentstatus=''))
	--and ((@paymentmethod <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentMethods tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method=tps.method)) or (@paymentmethod=''))
	--Order by PayrollInvoicejson.InvoiceNumber
	--for Xml path('PayrollInvoiceJson'), root('PayrollInvoiceJsonList'), elements, type
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 18/05/2018 4:23:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrolls] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrolls]
	@company varchar(max) = null,
	@startdate varchar(max) = null,
	@enddate varchar(max) = null,
	@id uniqueidentifier=null,
	@invoice uniqueidentifier=null,
	@status varchar(max)=null,
	@void int=null
AS
BEGIN
	declare @where nvarchar(max) = ''
	if @id is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Payroll.Id=''' + cast(@Id as varchar(max)) + ''''
	if @company is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.CompanyId=''' + cast(@company as varchar(max)) + ''''
	if @invoice is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Pinv.Id=''' + cast(@invoice as varchar(max)) + ''''
	if @startdate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.PayDay>=''' + cast(@startdate as varchar(max)) + ''''
		
	if @enddate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.PayDay<=''' + cast(@enddate as varchar(max)) + ''''
		
	if @status<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.status =' + @status
	if @void is not null
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.IsVoid =0'

	declare @query nvarchar(max) = ''
	
	if exists(select 'x' from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId where 
		((@void is null) or (@void is not null and Payroll.IsVoid=0))
		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		)
		set @query = 'select
		Payroll.*,
		Pinv.Id as InvoiceId,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		
		(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path(''PayrollPayCheckJson''), Elements, type) PayrollPayChecks,
		
		case when exists(select ''x'' from PayrollPayCheck pc, PayCheckExtract pce where pc.Id=pce.PayrollPayCheckId and pc.PayrollId=Payroll.Id) then 1 else 0 end HasExtracts,
		case when exists(select ''x'' from PayrollPayCheck pc, ACHTransaction act where pc.Id=act.SourceId and act.TransactionType=1 and pc.PayrollId=Payroll.Id) then 1 else 0 end HasACH
		from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where ' + @where + 'Order by PayDay
		for Xml path(''PayrollJson''), root(''PayrollList''), elements, type'
		--((@void is null) or (@void is not null and Payroll.IsVoid=0))
		--and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		--and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		--and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		--and ((@startdate is not null and PayDay>=@startdate) or (@startdate is null)) 
		--and ((@enddate is not null and PayDay<=@enddate) or (@enddate is null)) 
		--and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		--Order by PayDay
		--for Xml path('PayrollJson'), root('PayrollList'), elements, type
	else
		begin
			if @company is not null
				set @query = '
				select
				top(1) Payroll.*,
				Pinv.Id as InvoiceId,
				Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		
				(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path(''PayrollPayCheckJson''), Elements, type) PayrollPayChecks,
				
				case when exists(select ''x'' from PayrollPayCheck pc, PayCheckExtract pce where pc.Id=pce.PayrollPayCheckId and pc.PayrollId=Payroll.Id) then 1 else 0 end HasExtracts,
				case when exists(select ''x'' from PayrollPayCheck pc, ACHTransaction act where pc.Id=act.SourceId and act.TransactionType=1 and pc.PayrollId=Payroll.Id) then 1 else 0 end HasACH
				from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
				Where				
				Payroll.CompanyId=''' + cast(@company as varchar(max)) + '''
				Order by PayDay desc
				for Xml path(''PayrollJson''), root(''PayrollList''), elements, type'
			else
				set @query = 'select * from Payroll where status='''' for Xml path(''PayrollJson''), root(''PayrollList''), elements, type';
			
		end
		
	execute (@query)
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetJournalIds]    Script Date: 18/05/2018 6:23:55 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournalIds]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 18/05/2018 6:23:55 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployees]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 18/05/2018 6:23:55 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 18/05/2018 6:23:55 PM ******/
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
		declare @where nvarchar(max) = ''
	if @id is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Id=''' + cast(@Id as varchar(max))+''''
	if @status is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'statusId=' + cast(@status as varchar(max))
	if @host is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'HostId=''' + cast(@host as varchar(max)) + ''''
	
	if @role is not null and @role='HostStaff'
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsHostCompany=0'
	if @role is not null and @role='CorpStaff'
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsHostCompany=0'

		declare @query nvarchar(max) ='
		select 
		CompanyJson.*,
		case when exists(select ''x'' from company where parentid=CompanyJson.Id) then 1 else 0 end HasLocations
		,
		(select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path(''DeductionType''), elements, type) from CompanyDeduction Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyDeductions,
		(select * from CompanyWorkerCompensation Where CompanyId=CompanyJson.Id for Xml auto, elements, type) CompanyWorkerCompensations,
		(select *, (select * from PayType Where Id=CompanyAccumlatedPayType.PayTypeId for xml path(''PayType''), elements, type) from CompanyAccumlatedPayType Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyAccumlatedPayTypes,
		(select * from CompanyContract Where CompanyId=CompanyJson.Id for xml path(''CompanyContract''), elements, type), 
		(select *,(select * from Tax where Id=CompanyTaxRate.TaxId for xml path(''Tax''), elements, type) from CompanyTaxRate Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxRates,
		(select * from CompanyTaxState Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxStates, 
		(select * from CompanyPayCode Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyPayCodes,
		(select * from Company Where ParentId=CompanyJson.Id for xml path(''CompanyJson''), elements, type) Locations,
		(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type),
		(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=CompanyJson.Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
		From Company CompanyJson '
		+ case when len(@where)>1 then ' Where ' + @where else '' end +
		' Order by CompanyJson.CompanyIntId
		for Xml path(''CompanyJson''), root(''CompanyList'') , elements, type'

		Execute(@query)
		--((@id is not null and Id=@id) or (@id is null))
		--and ((@host is not null and HostId=@host) or (@host is null))
		--and ((@status is not null and StatusId=cast(@status as int)) or (@status is null))
		--and (
		--			(@role is not null and @role='HostStaff' and IsHostCompany=0) 
		--			or (@role is not null and @role='CorpStaff' and IsHostCompany=0) 
		--			or (@role is null)
		--		)
		--Order by CompanyJson.CompanyIntId
		--for Xml path('CompanyJson'), root('CompanyList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 18/05/2018 6:23:55 PM ******/
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

	declare @where nvarchar(max) = ''
	if @id is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'EmployeeJson.Id=''' + cast(@Id as varchar(max))+''''
	if @status is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'EmployeeJson.statusId=' + cast(@status as varchar(max))
	if @host is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Company.HostId=''' + cast(@host as varchar(max)) + ''''
	if @company is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'EmployeeJson.CompanyId=''' + cast(@company as varchar(max)) + ''''
	
	declare @query nvarchar(max) ='
	
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
			for Xml path(''PayCheckPayTypeAccumulation'') , elements, type
		) Accumulations,
		(select *, (select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path(''DeductionType''), elements, type) from CompanyDeduction where Id=EmployeeDeduction.CompanyDeductionId for Xml path(''CompanyDeduction''), elements, type) from EmployeeDeduction Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeDeductions,
		(select *, (select * from BankAccount where Id=EmployeeBankAccount.BankAccountId for Xml path(''BankAccount''), elements, type) from EmployeeBankAccount Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeBankAccounts,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path(''CompanyWorkerCompensation''), elements, type)
		
		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId = Company.Id and ' + @where + ' for Xml path(''EmployeeJson''), root(''EmployeeList'') , elements, type'
		--and ((@id is not null and EmployeeJson.Id=@id) or (@id is null))
		--and ((@host is not null and Company.HostId=@host) or (@host is null))
		--and ((@company is not null and EmployeeJson.CompanyId=@company) or (@company is null))
		--and ((@status is not null and EmployeeJson.StatusId=cast(@status as int)) or (@status is null))
		
		--for Xml path('EmployeeJson'), root('EmployeeList') , elements, type

		Execute(@query)
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetJournalIds]    Script Date: 18/05/2018 6:23:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalIds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetJournalIds] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetJournalIds]
	@company uniqueidentifier = null,
	@startdate datetime = null,
	@enddate datetime = null,
	@transactiontype int = null,
	@accountid int = null
AS
BEGIN
	
	declare @where nvarchar(max) = ''
	
	if @accountid is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'MainAccountId=' + cast(@accountid as varchar(max))
	if @company is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'CompanyId=''' + cast(@company as varchar(max)) + ''''
	if @transactiontype is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionType=' + cast(@transactiontype as varchar(max))
	if @startdate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate>=''' + cast(@startdate as varchar(max)) + ''''
	if @enddate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate<=''' + cast(@enddate as varchar(max)) + ''''
	
	declare @query nvarchar(max) ='
		select 
			Id
		from CheckbookJournal
		where
		' + @where + '	Order by Id 
		for Xml path(''JournalJson''), root(''JournalList''), Elements, type'

	execute(@query)
		-- ((@accountid is not null and MainAccountId=@accountid) or @accountid is null)
		--	and ((@company is not null and CompanyId=@company) or (@company is null)) 
		--	and ((@transactiontype is not null and TransactionType=@transactiontype) or @transactiontype is null)
		--	and ((@startdate is not null and TransactionDate>=@startdate) or (@startdate is null)) 
		--	and ((@enddate is not null and TransactionDate<=@enddate) or (@enddate is null)) 
		
		--Order by Id 
		--for Xml path('JournalJson'), root('JournalList'), Elements, type
		
	
	
END
GO

update [PaxolFeatureClaim] set AccessLevel = 70 where Id=30;
insert into [PaxolFeatureClaim] (FeatureId, ClaimName, ClaimType, AccessLevel) values (1, 'Misc Extracts', 'http://Paxol/MiscExtracts', 70);