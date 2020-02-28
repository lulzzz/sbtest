/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 27/02/2020 7:31:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoicesXml]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InvoiceCommission_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollInvoiceCommission]'))
ALTER TABLE [dbo].[PayrollInvoiceCommission] DROP CONSTRAINT [FK_InvoiceCommission_PayrollInvoice]
GO
/****** Object:  Table [dbo].[PayrollInvoiceCommission]    Script Date: 27/02/2020 7:31:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoiceCommission]') AND type in (N'U'))
DROP TABLE [dbo].[PayrollInvoiceCommission]
GO
/****** Object:  Table [dbo].[PayrollInvoiceCommission]    Script Date: 27/02/2020 7:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollInvoiceCommission](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[SalesRep] [uniqueidentifier] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_InvoiceCommission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayrollInvoiceCommission]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceCommission_PayrollInvoice] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[PayrollInvoice] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PayrollInvoiceCommission] CHECK CONSTRAINT [FK_InvoiceCommission_PayrollInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 27/02/2020 7:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPayrollInvoicesXml]
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

	declare @host1 uniqueidentifier = @host,
	@company1 uniqueidentifier = @company,
	@role1 varchar(max) = @role,
	@status1 varchar(max) = @status,
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@id1 uniqueidentifier=@id,
	@paymentstatus1 varchar(max) = @paymentstatus,
	@paymentmethod1 varchar(max) = @paymentmethod,
	@invoicenumber1 int = @invoicenumber,
	@bypayday1 bit = @bypayday
	
	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollInvoiceJson.Id=''' + cast(@Id1 as varchar(max)) + ''''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @startdate1 is not null 
		begin
			if @bypayday1=0
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate>=''' + cast(@startdate1 as varchar(max)) + ''''
			else
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollJson.PayDay>=''' + cast(@startdate1 as varchar(max)) + ''''
		
		end
	if @enddate1 is not null 
		begin
			if @bypayday1=0
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate<=''' + cast(@enddate1 as varchar(max)) + ''''
			else
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollJson.PayDay<=''' + cast(@enddate1 as varchar(max)) + ''''
		
		end
	if @invoicenumber1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceNumber>' + cast(@invoicenumber1 as varchar(max))	
	if @status1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.status in (' + @status1 + ')'
	if @paymentstatus1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status in (' + @paymentstatus1 + '))'
	if @paymentmethod1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method in (' + @paymentmethod1 + '))'
	
	declare @query as nvarchar(max)=''
	set @query ='
	select 
		PayrollInvoiceJson.*,
		case when exists(select  ''x'' from CommissionExtract where PayrollInvoiceId=PayrollInvoiceJson.Id) then 1 else 0 end CommissionClaimed,
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
		(select * from InvoicePayment where InvoiceId=PayrollInvoiceJson.Id for Xml path(''InvoicePaymentJson''), Elements, type) InvoicePayments, 
		(select * from PayrollInvoiceCommission where InvoiceId=PayrollInvoiceJson.Id for Xml path(''PayrollInvoiceCommissionJson''), Elements, type) Commissions, 
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
	
	

END
GO
insert into PayrollInvoiceCommission(InvoiceId, SalesRep, Amount)
select Id, SalesRep, Commission from PayrollInvoice where SalesRep is not null;
Go
/****** Object:  StoredProcedure [dbo].[GetCommissionsReport]    Script Date: 27/02/2020 7:39:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionsReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCommissionsReport]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionPerformanceChart]    Script Date: 27/02/2020 7:39:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionPerformanceChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCommissionPerformanceChart]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionPerformanceChart]    Script Date: 27/02/2020 7:39:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCommissionPerformanceChart]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 0
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = case when @enddate is null then DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) else @enddate end,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@onlyActive1 bit = @onlyActive

	declare @users varchar(max)
	declare @query varchar(max)	

	select (u.FirstName + ' ' + u.LastName) [User], LEFT(datename(month,InvoiceDate),3) + ' ' + Right(cast(year(InvoiceDate) as varchar),2) Month, pic.amount Commission
	into #tmpInspectionData
	from PayrollInvoice i, AspNetUsers u, Company c, PayrollInvoiceCommission pic
	where 
		pic.SalesRep=u.Id
		and i.CompanyId = c.Id
		and i.Id=pic.InvoiceId
		and ((@onlyActive1=1 and c.StatusId=1) or (@onlyActive1=0))
		and i.Balance<=0
		and ((@startdate1 is not null and i.InvoiceDate>=@startdate1) or (@startdate1 is null))
		and ((@enddate1 is not null and i.InvoiceDate<=@enddate1) or (@enddate1 is null))
		
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
/****** Object:  StoredProcedure [dbo].[GetCommissionsReport]    Script Date: 27/02/2020 7:39:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCommissionsReport]
	@startdate datetime = null,
	@enddate datetime = null,
	@userId uniqueidentifier = null,
	@includeinactive bit
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@userId1 uniqueidentifier = @userId,
	@includeinactive1 bit = @includeinactive

	select 
	(select
		u.Id as UserId, u.FirstName + ' ' + u.LastName as Name,
		(
			select 
				i.Id as InvoiceId, pic.amount Commission,  i.InvoiceDate, c.CompanyName, i.InvoiceNumber
			from PayrollInvoice i, Company c, PayrollInvoiceCommission pic
			where i.CompanyId = c.Id
			and i.Id = pic.InvoiceId
			and ((@includeinactive1=1) or (@includeinactive1=0 and c.StatusId=1))
			--and c.StatusId=1
			and u.Active=1
			and pic.SalesRep = u.Id
			and ((@userId1 is not null and pic.SalesRep = @userId1) or (@userId1 is null))
			and ((@startdate1 is not null and i.InvoiceDate>=@startdate1) or (@startdate1 is null))
			and ((@enddate1 is not null and i.InvoiceDate<=@enddate1) or (@enddate1 is null))
			and not exists(select 'x' from CommissionExtract where PayrollInvoiceId=i.id)
			and i.Balance=0
			for xml path('InvoiceCommission'), ELEMENTS, type
		) Commissions
	from AspNetUsers u
	where 
	u.Active=1
	and ((@userId1 is not null and u.Id = @userId1) or (@userId1 is null))
	for xml path('ExtractSalesRep'), ELEMENTS, type) SalesReps
	for xml path('CommissionsResponse'), ELEMENTS, type
	
END
GO


Alter table PayrollInvoice drop column SalesRep, Commission;