IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_Payroll')
CREATE NONCLUSTERED INDEX [IX_Payroll] ON [dbo].[Payroll]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Payroll_1]    Script Date: 7/03/2017 1:50:21 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_Payroll_1')
CREATE NONCLUSTERED INDEX [IX_Payroll_1] ON [dbo].[Payroll]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Payroll_2]    Script Date: 7/03/2017 1:50:21 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_Payroll_2')
CREATE NONCLUSTERED INDEX [IX_Payroll_2] ON [dbo].[Payroll]
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheck')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheck] ON [dbo].[PayrollPayCheck]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheck_1]    Script Date: 7/03/2017 1:53:23 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheck_1')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheck_1] ON [dbo].[PayrollPayCheck]
(
	[PEOASOCoCheck] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheck_2]    Script Date: 7/03/2017 1:53:23 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheck_2')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheck_2] ON [dbo].[PayrollPayCheck]
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 7/03/2017 1:45:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 7/03/2017 1:45:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoiceList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoiceList]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 7/03/2017 1:45:28 PM ******/
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
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path('PayrollInvoiceListItem'), root('PayrollInvoiceJsonList'), elements, type

END

GO
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 7/03/2017 1:45:28 PM ******/
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
	if exists(select 'x' from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId where 
		((@void is null) or (@void is not null and exists(select 'x' from PayrollPayCheck where PayrollId=Payroll.Id and IsVoid=0)))
		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		)
	select
		Payroll.*,
		Pinv.Id as InvoiceId,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		
		(select PayrollPayCheck.*, Journal.DocumentId DocumentId from PayrollPayCheck, Journal where PayrollPayCheck.Id=Journal.PayrollPayCheckId and PayrollPayCheck.PEOASOCoCheck=Journal.PEOASOCoCheck and PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path('PayrollPayCheckJson'), Elements, type) PayrollPayChecks
		from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where
		((@void is null) or (@void is not null and exists(select 'x' from PayrollPayCheck where PayrollId=Payroll.Id and IsVoid=0)))
		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		Order by PayDay
		for Xml path('PayrollJson'), root('PayrollList'), elements, type
	else
		begin
			if @company is not null
				select
				top(1) Payroll.*,
				Pinv.Id as InvoiceId,
				Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		
				(select PayrollPayCheck.*, Journal.DocumentId DocumentId from PayrollPayCheck, Journal where PayrollPayCheck.Id=Journal.PayrollPayCheckId and PayrollPayCheck.PEOASOCoCheck=Journal.PEOASOCoCheck and PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path('PayrollPayCheckJson'), Elements, type) PayrollPayChecks
				from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
				Where				
				((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
				Order by PayDay desc
				for Xml path('PayrollJson'), root('PayrollList'), elements, type
			
			
		end
		
	
	
END
GO
