/****** Object:  Index [IX_PayCheckExtractPayCheckId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND name = N'IX_PayCheckExtractPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckExtractPayCheckId] ON [dbo].[PayCheckExtract]
(
	[PayrollPayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckExtractExtract]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND name = N'IX_PayCheckExtractExtract')
CREATE NONCLUSTERED INDEX [IX_PayCheckExtractExtract] ON [dbo].[PayCheckExtract]
(
	[Extract] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckExtractType]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND name = N'IX_PayCheckExtractType')
CREATE NONCLUSTERED INDEX [IX_PayCheckExtractType] ON [dbo].[PayCheckExtract]
(
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CommissionExtractInvoiceId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CommissionExtract]') AND name = N'IX_CommissionExtractInvoiceId')
CREATE NONCLUSTERED INDEX [IX_CommissionExtractInvoiceId] ON [dbo].[CommissionExtract]
(
	[PayrollInvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CommissionExtractExtractId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CommissionExtract]') AND name = N'IX_CommissionExtractExtractId')
CREATE NONCLUSTERED INDEX [IX_CommissionExtractExtractId] ON [dbo].[CommissionExtract]
(
	[MasterExtractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 22/08/2017 9:30:47 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetPaychecks]    Script Date: 22/08/2017 9:30:47 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaychecks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPaychecks]
GO
/****** Object:  StoredProcedure [dbo].[GetPaychecks]    Script Date: 22/08/2017 9:30:47 AM ******/
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
	
		select 
			PayrollPayCheck.*
		from PayrollPayCheck 
		where 
			((@void is not null and PayrollPayCheck.IsVoid=@void) or (@void is null))
			and ((@id is not null and PayrollPayCheck.Id=@id) or (@id is null))
			and ((@payroll is not null and PayrollPayCheck.PayrollId=@payroll) or (@payroll is null)) 
			and ((@company is not null and PayrollPayCheck.CompanyId=@company) or (@company is null)) 
			and ((@employee is not null and PayrollPayCheck.EmployeeId=@employee) or (@employee is null)) 
			and ((@startdate is not null and PayrollPayCheck.PayDay>=@startdate) or (@startdate is null)) 
			and ((@enddate is not null and PayrollPayCheck.PayDay<=@enddate) or (@enddate is null)) 
			and ((@status is not null and PayrollPayCheck.Status=cast(@status as int)) or @status is null)
			and ((@year is not null and year(PayrollPayCheck.PayDay)=@year) or @year is null)
		Order by PayrollPayCheck.Id 
		for Xml path('PayrollPayCheckJson'), root('PayCheckList'), Elements, type
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 22/08/2017 9:30:47 AM ******/
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
		
		(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path('PayrollPayCheckJson'), Elements, type) PayrollPayChecks
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
		
				(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path('PayrollPayCheckJson'), Elements, type) PayrollPayChecks
				from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
				Where				
				((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
				Order by PayDay desc
				for Xml path('PayrollJson'), root('PayrollList'), elements, type
			else
				select * from Payroll where status='' for Xml path('PayrollJson'), root('PayrollList'), elements, type;
			
		end
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPaychecksForInvoiceCredit]    Script Date: 22/08/2017 9:32:01 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPaychecksForInvoiceCredit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyPaychecksForInvoiceCredit]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPaychecksForInvoiceCredit]    Script Date: 22/08/2017 9:32:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPaychecksForInvoiceCredit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyPaychecksForInvoiceCredit] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyPaychecksForInvoiceCredit]
	@company uniqueidentifier = null
AS
BEGIN
	
		select 
			PayrollPayCheck.*
		from PayrollPayCheck, PayrollInvoice
		where 
			PayrollPayCheck.InvoiceId=PayrollInvoice.Id
			and PayrollPayCheck.IsVoid=1 and InvoiceId is not null and CreditInvoiceId is null and PayrollInvoice.Balance<=0
			and ((@company is not null and PayrollPayCheck.CompanyId=@company) or (@company is null)) 
			
		Order by PayrollPayCheck.Id 
		for Xml path('PayrollPayCheckJson'), root('PayCheckList'), Elements, type
		
	
	
END
GO
