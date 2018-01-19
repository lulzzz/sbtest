IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'IsVoid')
Alter table Payroll Add IsVoid bit not null default(0);
Go
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckInvoiceId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckInvoiceId] ON [dbo].[PayrollPayCheck]
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
	
	select
		Payroll.Id, Company.CompanyName, Payroll.PayDay, Payroll.StartDate, Payroll.EndDate,Payroll.Status, Payroll.LastModifiedBy ProcessedBy, Payroll.LastModified, Payroll.IsHistory,
		Pinv.Id as InvoiceId,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		sum(PayrollPayCheck.GrossWage) TotalGrossWage, sum(PayrollPayCheck.NetWage) TotalNetWage
		from PayrollPayCheck, Company, Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where
		Company.Id=Payroll.CompanyId
		and Payroll.Id=PayrollPayCheck.PayrollId
		and ((@void is null) or (@void is not null and Payroll.IsVoid=0))
		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and Payroll.PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and Payroll.PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		and ((@isprinted is not null and Payroll.IsPrinted = @isprinted) or @isprinted is null)
		group by Payroll.Id, Company.CompanyName, Payroll.PayDay, Payroll.StartDate, Payroll.EndDate,Payroll.Status, Payroll.LastModifiedBy, Payroll.LastModified, Payroll.IsHistory,
		Pinv.Id,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status
		Order by PayDay
		for Xml path('PayrollMinified'), root('PayrollMinifiedList'), elements, type
	
	
END
Go
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
		((@void is null) or (@void is not null and Payroll.IsVoid=0))
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
		
		(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path('PayrollPayCheckJson'), Elements, type) PayrollPayChecks,
		dbo.CanDeletePayroll(Payroll.Id) CanDelete
		from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where
		((@void is null) or (@void is not null and Payroll.IsVoid=0))
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
		
				(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path('PayrollPayCheckJson'), Elements, type) PayrollPayChecks,
				dbo.CanDeletePayroll(Payroll.Id) CanDelete
				from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
				Where				
				((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
				Order by PayDay desc
				for Xml path('PayrollJson'), root('PayrollList'), elements, type
			else
				select * from Payroll where status='' for Xml path('PayrollJson'), root('PayrollList'), elements, type;
			
		end
		
	
	
END
Go
Update Payroll set IsVoid=1 where not exists (select 'x' from PayrollPayCheck where PayrollId=Payroll.Id and IsVoid=0);
Go
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
		and p.IsVoid=0
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
Go
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
	and p.IsVoid=0
	and pc.PayrollId=p.Id and pc.IsVoid=0
	and p.CopiedFrom is null and p.MovedFrom is null
	and p.IsHistory=0
	--and p.Id is null
	)a
	group by HostId, CompanyId, Host, Company
	
END
Go
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
	from Company c, Host h, CompanyContract cc, Payroll p with (nolock) Left outer join PayrollInvoice i with (nolock) on p.Id = i.PayrollId
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
	and p.IsVoid=0
	and p.CopiedFrom is null and p.MovedFrom is null
	and p.IsHistory=0
	--and p.Id is null
	)a
	group by HostId, CompanyId, Host, Company
	
END
Go
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
		CompanyJson.CompanyName, CompanyJson.HostId, CompanyJson.IsHostCompany, CompanyJson.IsVisibleToHost, CompanyJson.BusinessAddress
		,(select max(PaymentDate) from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=3) LastPayment,
		STUFF((SELECT ', ' + case when ip.Method=1 then CAST(ip.CheckNumber AS VARCHAR(max)) when ip.Method=2 then 'Cash' when ip.Method=3 then 'Cert Fund' when ip.Method=4 then 'Corp Check' when ip.Method=5 then 'ACH' end [text()]
         from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') CheckNumbers
		
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson--, InvoicePayment InvoicePaymentJson
	Where 
	PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	and ((@company is not null and PayrollInvoiceJson.CompanyId=@company) or (@company is null)) 
	and ((@startdate is not null and PayrollInvoiceJson.InvoiceDate>=@startdate) or (@startdate is null))
	and ((@enddate is not null and PayrollInvoiceJson.InvoiceDate<=@enddate) or (@enddate is null)) 
	
	and ((@status <>'' and exists(select 'x' from @tmpStatuses where status=PayrollInvoiceJson.Status)) or (@status=''))
	and ((@paymentstatus <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentStatuses tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=tps.status)) or (@paymentstatus=''))
	and ((@paymentmethod <>'' and exists(select 'x' from InvoicePayment ip, @tmpPaymentMethods tps where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method=tps.method)) or (@paymentmethod=''))
	and ((@includeTaxesDelayed=1  and PayrollInvoiceJson.TaxesDelayed=1) or (@includeTaxesDelayed=0 and isnull(PayrollInvoiceJson.TaxesDelayed,0)>=0))
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path('PayrollInvoiceListItem'), root('PayrollInvoiceJsonList'), elements, type

END
Go

ALTER FUNCTION [dbo].[CanDeletePayroll] 
(
	@PayrollId uniqueidentifier
)
RETURNS bit
AS
BEGIN
	declare @exist int = 0
	select @exist=count(Id) from Payroll p
	where
	Id=@PayrollId and InvoiceId is null and IsVoid=1
	--and not exists(select 'x' from PayrollPayCheck pc where pc.PayrollId=p.Id and pc.IsVoid=0)
	and not exists(select 'x' from PayrollPayCheck pc, PayCheckExtract pce where pc.Id=pce.PayrollPayCheckId and pc.PayrollId=p.Id)
	and not exists(select 'x' from PayrollPayCheck pc, ACHTransaction act where pc.Id=act.SourceId and act.TransactionType=1 and pc.PayrollId=p.Id)
	
	
	group by Id
	
	if @exist>0
		set @exist=1
	return @exist
END

Go
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckInvoiceId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckInvoiceId] ON [dbo].[PayrollPayCheck]
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckCreditInvoiceId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckCreditInvoiceId] ON [dbo].[PayrollPayCheck]
(
	[CreditInvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO