alter table Employee alter column SSN varchar(24);
Go
/****** Object:  Index [IX_EmployeeSSN]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Employee]') AND name = N'IX_EmployeeSSN')
CREATE NONCLUSTERED INDEX [IX_EmployeeSSN] ON [dbo].[Employee]
(
	[SSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckCompensationPayCheckId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]') AND name = N'IX_PayCheckCompensationPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckCompensationPayCheckId] ON [dbo].[PayCheckCompensation]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckCompensationPayTypeId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]') AND name = N'IX_PayCheckCompensationPayTypeId')
CREATE NONCLUSTERED INDEX [IX_PayCheckCompensationPayTypeId] ON [dbo].[PayCheckCompensation]
(
	[PayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckDeductionPayCheckId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND name = N'IX_PayCheckDeductionPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckDeductionPayCheckId] ON [dbo].[PayCheckDeduction]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckPayCodePayCheckId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND name = N'IX_PayCheckPayCodePayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckPayCodePayCheckId] ON [dbo].[PayCheckPayCode]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckPayTypeAccumulationPayCheckId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]') AND name = N'IX_PayCheckPayTypeAccumulationPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckPayTypeAccumulationPayCheckId] ON [dbo].[PayCheckPayTypeAccumulation]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckPayTypeAccumulationPayTypeId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]') AND name = N'IX_PayCheckPayTypeAccumulationPayTypeId')
CREATE NONCLUSTERED INDEX [IX_PayCheckPayTypeAccumulationPayTypeId] ON [dbo].[PayCheckPayTypeAccumulation]
(
	[PayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckTaxPayCheckId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckTax]') AND name = N'IX_PayCheckTaxPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckTaxPayCheckId] ON [dbo].[PayCheckTax]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckTaxTaxId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckTax]') AND name = N'IX_PayCheckTaxTaxId')
CREATE NONCLUSTERED INDEX [IX_PayCheckTaxTaxId] ON [dbo].[PayCheckTax]
(
	[TaxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckWCPayCheckId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]') AND name = N'IX_PayCheckWCPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckWCPayCheckId] ON [dbo].[PayCheckWorkerCompensation]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckWCWorkerCompensationId]    Script Date: 20/07/2017 12:09:44 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]') AND name = N'IX_PayCheckWCWorkerCompensationId')
CREATE NONCLUSTERED INDEX [IX_PayCheckWCWorkerCompensationId] ON [dbo].[PayCheckWorkerCompensation]
(
	[WorkerCompensationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyInvoices]    Script Date: 20/08/2017 1:51:17 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyInvoices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyInvoices]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyInvoices]    Script Date: 20/08/2017 1:51:17 PM ******/
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
		case when exists(select  'x' from CommissionExtract where PayrollInvoiceId=PayrollInvoiceJson.Id) then 1 else 0 end CommissionClaimed,
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
		(select * from InvoicePayment where InvoiceId=PayrollInvoiceJson.Id for Xml path('InvoicePaymentJson'), Elements, type) InvoicePayments
		
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson
	Where 
	((@id is not null and PayrollInvoiceJson.Id=@id) or (@id is null)) 
	and ((@company is not null and PayrollInvoiceJson.CompanyId=@company) or (@company is null)) 
	and ((@startdate is not null and PayrollInvoiceJson.InvoiceDate>=@startdate) or (@startdate is null))
	and ((@enddate is not null and PayrollInvoiceJson.InvoiceDate<=@enddate) or (@enddate is null)) 
	and PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and ((@status <>'' and exists(select 'x' from @tmpStatuses where status=PayrollInvoiceJson.Status)) or (@status=''))
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path('PayrollInvoiceJson'), root('PayrollInvoiceJsonList'), elements, type
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPaychecksForInvoiceCredit]    Script Date: 20/08/2017 4:32:52 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPaychecksForInvoiceCredit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyPaychecksForInvoiceCredit]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPaychecksForInvoiceCredit]    Script Date: 20/08/2017 4:32:52 PM ******/
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
			PayrollPayCheck.*, 
			Journal.DocumentId DocumentId
		from PayrollPayCheck, Journal, PayrollInvoice
		where 
			PayrollPayCheck.Id=Journal.PayrollPayCheckId 
			and PayrollPayCheck.InvoiceId=PayrollInvoice.Id
			and PayrollPayCheck.IsVoid=1 and InvoiceId is not null and CreditInvoiceId is null and PayrollInvoice.Balance<=0
			and PayrollPayCheck.PEOASOCoCheck=Journal.PEOASOCoCheck 			
			and ((@company is not null and PayrollPayCheck.CompanyId=@company) or (@company is null)) 
			
		Order by PayrollPayCheck.Id 
		for Xml path('PayrollPayCheckJson'), root('PayCheckList'), Elements, type
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 20/08/2017 5:34:40 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoicesXml]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 20/08/2017 5:34:40 PM ******/
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
	@invoicenumber int = null
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
	and ((@startdate is not null and PayrollInvoiceJson.InvoiceDate>=@startdate) or (@startdate is null))
	and ((@enddate is not null and PayrollInvoiceJson.InvoiceDate<=@enddate) or (@enddate is null)) 
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
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 21/08/2017 12:54:01 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 21/08/2017 12:54:01 PM ******/
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
	select 'GetPayrollsWithoutInvoice' Report;
	select 
	HostId, CompanyId, Host, Company, count(PayrollId) Due
	from
	(select distinct h.Id HostId, c.Id as CompanyId, h.firmname Host, c.CompanyName Company, p.Id PayrollId
	from Company c, Host h, CompanyContract cc,PayrollPayCheck pc, Payroll p with (nolock) Left outer join PayrollInvoice i with (nolock) on p.Id = i.PayrollId
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
	--and exists (select 'x' from PayrollPayCheck where PayrollId=p.Id and IsVoid=0)
	and pc.PayrollId=p.Id and pc.IsVoid=0
	and p.CopiedFrom is null and p.MovedFrom is null
	and p.IsHistory=0
	--and p.Id is null
	)a
	group by HostId, CompanyId, Host, Company
	
END
GO
