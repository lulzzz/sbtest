
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyInvoice'
                 AND COLUMN_NAME = 'Total')

alter table companyinvoice add DueDate datetime, Total decimal(18,2) not null default(0), 
Balance decimal(18,2) not null default(0), SalesTaxRate decimal(18,2) not null default(0), SalesTax decimal(18,2) not null Default(0), 
DiscountType int not null default(0), DiscountRate decimal(18,2) not null default(0), Discount decimal(18,2) not null default(0), IsQuote bit not null default(0);

Go

IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyContract'
                 AND COLUMN_NAME = 'Payrolls')

alter table CompanyContract add Payrolls bit not null default(1), Bookkeeping bit not null Default(1), Invoicing bit not null Default(0), Taxation bit not null Default(1);

Go


IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'SalesTaxRate')

alter table Company add SalesTaxRate decimal(18,2) not null default(0)

Go

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductService_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductService]'))
ALTER TABLE [dbo].[ProductService] DROP CONSTRAINT [FK_ProductService_Company]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyInvoicePayment_CompanyInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyInvoicePayment]'))
ALTER TABLE [dbo].[CompanyInvoicePayment] DROP CONSTRAINT [FK_CompanyInvoicePayment_CompanyInvoice]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyInvoiceItem_ProductService]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyInvoiceItem]'))
ALTER TABLE [dbo].[CompanyInvoiceItem] DROP CONSTRAINT [FK_CompanyInvoiceItem_ProductService]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ProductService_IsTaxable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProductService] DROP CONSTRAINT [DF_ProductService_IsTaxable]
END
GO
/****** Object:  Table [dbo].[ProductService]    Script Date: 6/07/2020 5:11:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductService]') AND type in (N'U'))
DROP TABLE [dbo].[ProductService]
GO
/****** Object:  Table [dbo].[CompanyInvoicePayment]    Script Date: 6/07/2020 5:11:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyInvoicePayment]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyInvoicePayment]
GO
/****** Object:  Table [dbo].[CompanyInvoiceItem]    Script Date: 6/07/2020 5:11:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyInvoiceItem]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyInvoiceItem]
GO
/****** Object:  Table [dbo].[CompanyInvoiceItem]    Script Date: 6/07/2020 5:11:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyInvoiceItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyInvoiceId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
	[IsTaxable] [bit] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_CompanyInvoiceItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyInvoicePayment]    Script Date: 6/07/2020 5:11:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyInvoicePayment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyInvoiceId] [int] NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[Method] [int] NOT NULL,
	[CheckNumber] [int] NOT NULL,
	[Amount] decimal(18,2) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_CompanyInvoicePayment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductService]    Script Date: 6/07/2020 5:11:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductService](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[SerialNo] [varchar](100),
	[Name] [varchar](max) NOT NULL,
	[Type] [int] NOT NULL,
	[CostPrice] [decimal](18, 2) NOT NULL,
	[SalePrice] [decimal](18, 2) NOT NULL,
	[IsTaxable] [bit] NOT NULL,
	[LastModifiedBy] varchar(max),
	[LastModified] DateTime not null Default(getdate())
 CONSTRAINT [PK_ProductService] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProductService] ADD  CONSTRAINT [DF_ProductService_IsTaxable]  DEFAULT ((0)) FOR [IsTaxable]
GO
ALTER TABLE [dbo].[CompanyInvoiceItem]  WITH CHECK ADD  CONSTRAINT [FK_CompanyInvoiceItem_ProductService] FOREIGN KEY([ProductId])
REFERENCES [dbo].[ProductService] ([Id])
GO
ALTER TABLE [dbo].[CompanyInvoiceItem] CHECK CONSTRAINT [FK_CompanyInvoiceItem_ProductService]
GO
ALTER TABLE [dbo].[CompanyInvoicePayment]  WITH CHECK ADD  CONSTRAINT [FK_CompanyInvoicePayment_CompanyInvoice] FOREIGN KEY([CompanyInvoiceId])
REFERENCES [dbo].[CompanyInvoice] ([Id])
GO
ALTER TABLE [dbo].[CompanyInvoicePayment] CHECK CONSTRAINT [FK_CompanyInvoicePayment_CompanyInvoice]
GO
ALTER TABLE [dbo].[ProductService]  WITH CHECK ADD  CONSTRAINT [FK_ProductService_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
ALTER TABLE [dbo].[ProductService] CHECK CONSTRAINT [FK_ProductService_Company]
GO

Update CompanyInvoice set DueDate = InvoiceDate, Total=Amount, DiscountType=2, Balance=Amount;

/****** Object:  StoredProcedure [dbo].[GetCompanyDashboard]    Script Date: 13/07/2020 7:36:57 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyDashboard]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCustomerOpenBalance]    Script Date: 13/07/2020 7:36:57 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCustomerOpenBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCustomerOpenBalance]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCustomerOpenBalance]    Script Date: 13/07/2020 7:36:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[GetCustomerOpenBalance] 
(
	@customerId uniqueidentifier
)
RETURNS decimal(18,2)
AS
BEGIN
	
	declare @balance decimal(18,2) = 0
	

	select @balance  =sum(Balance) from CompanyInvoice where PayeeId=@customerId and IsVoid=0;
	return @balance
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyDashboard]    Script Date: 13/07/2020 7:36:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCompanyDashboard]
	@company uniqueidentifier
AS
BEGIN
	declare @year int = case when exists(select 'x' from Payroll where companyid=@company and year(TaxPayDay)=year(getdate())) then year(getdate()) else year(getdate())-1 end
	declare @checkbookyear int = case when exists(select 'x' from CheckbookJournal where companyid=@company and year(TransactionDate)=year(getdate())) then year(getdate()) else year(getdate())-1 end
	
	select
		(
			select * from 
			(
			  select pc.InvoiceDate, pc.DueDate, pc.Total, pc.Balance, pc.PayeeId, pc.PayeeName
			  
			  from 
			  CompanyInvoice pc
			  where pc.IsVoid=0
			  and pc.CompanyId=@company 
			  and pc.isQuote=0
			  and year(pc.InvoiceDate)=@checkbookyear
			  
			)
			a
			for xml path('InvoiceMetric'), elements, type
		)InvoiceHistory,
		(
			select Id, Name, sum(Amount) Amount from 
			(
			  select p.Id, p.Name, cii.Amount			  
			  from 
			  CompanyInvoice pc, CompanyInvoiceItem cii, ProductService p
			  where pc.Id=cii.CompanyInvoiceId
			  and cii.ProductId=p.Id
			  and pc.IsVoid=0
			  and pc.CompanyId=@company 
			  and year(pc.InvoiceDate) =@checkbookyear
			 
			)
			a
			 group by Id, Name
			for xml path('ProductRevenue'), elements, type
		)ProductRevenues,
		(
			select * from 
			(
			  select pc.TransactionType, pc.TransactionDate, pc.Amount, pc.PayeeId, pc.PayeeName
			  
			  from 
			  CheckbookJournal pc
			  where pc.IsVoid=0
			  and pc.CompanyId=@company 
			  and year(pc.TransactionDate)=@checkbookyear
			  and pc.TransactionType in (2,5,6, 3, 7)
			)
			a
			for xml path('ExpenseMetric'), elements, type
		)Expenses,
		(
			select * from 
			(
			  select pc.PayDay, count(pc.Id) NoOfChecks, sum(pc.grosswage) GrossWage, sum(pc.netwage) NetWage, sum(pc.employeetaxes) EmployeeTaxes, sum(pc.employertaxes) EmployerTaxes, sum(pc.deductionamount) Deductions,
			  rank() over (Partition by pc.CompanyId order by pc.payday desc) DRank
			  from 
			  Payroll p, PayrollPayCheck pc
			  where p.Id=pc.PayrollId
			  and pc.IsVoid=0
			  and pc.CompanyId=@company 
			  and p.IsHistory=0
			  and p.IsVoid=0
			  and year(pc.TaxPayDay)=@year
			  group by pc.PayDay, pc.CompanyId
			)
			a
			for xml path('PayrollMetricJson'), elements, type
		)PayrollHistory,
		(SELECT *  FROM 
			( 
			  SELECT me.ExtractName, me.DepositDate, sum(pct.amount) Amount,
				RANK() OVER (PARTITION BY ExtractName ORDER BY DepositDate DESC) DRank
				FROM MasterExtracts me, PayCheckExtract pce, PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr
				where me.Id=pce.MasterExtractId and pce.PayrollPayCheckId=pc.Id
				and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and 
				((me.ExtractName='Federal941' and tyr.TaxId<6) or (me.ExtractName='Federal940' and tyr.TaxId=6) or (me.ExtractName='StateCAPIT' and tyr.TaxId in (7,8)) or (me.ExtractName='StateCAUI' and tyr.TaxId in (9,10)))
				and year(pc.TaxPayDay)=@year
				and pc.CompanyId=@company
				group by me.ExtractName, me.DepositDate
			)a 			
			for xml path('TaxExtractJson'), elements, type
		) ExtractHistory,
		(
			 select * from (select pc.TaxPayDay DepositDate, c.CompanyName, c.DepositSchedule941 Schedule, sum(pct.amount) Amount, 'Federal941' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.InvoiceId=pii.Id
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId<6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal941')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed, c.DepositSchedule941
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, 3 Schedule, sum(pct.amount) Amount, 'Federal940' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.InvoiceId=pii.Id
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId=6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal940')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, c.DepositSchedule941, sum(pct.amount) Amount, 'StateCAPIT' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.InvoiceId=pii.Id
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (7,8)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAPIT')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed, c.DepositSchedule941
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, 3 Schedule, sum(pct.amount) Amount, 'StateCAUI' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.InvoiceId=pii.Id
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (9,10)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAUI')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed) a
			for xml path('TaxExtractJson'), elements, type
		)PendingExtracts,
		(	select 
			(
				select  eda.*, d.TargetEntityId DocumentId,
				(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type),
				(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type), (select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=d.CompanyDocumentSubType for Xml path('CompanyDocumentSubType'), elements, type) from Document where TargetEntityId=d.TargetEntityId for Xml path('Document'), elements, type) 
				from 
				(select e.Id EmployeeId, (e.FirstName +' '+ e.LastName) EmployeeName, ed.DocumentId, ed.FirstAccessed, ed.LastAccessed 
				from Employee e left outer join EmployeeDocumentAccess ed on e.Id=ed.EmployeeId
				where e.CompanyId=@company) eda
				left outer join
				Document d on eda.DocumentId=d.TargetEntityId or eda.DocumentId is null
				inner join CompanyDocumentSubType cd on d.Type=cd.Type and d.CompanyDocumentSubType=cd.Id	
				where cd.TrackAccess=1 and cd.CompanyId=@company 
				and cd.Type in (3,4)
				order by eda.EmployeeName
				for xml path('EmployeeDocumentAccess'), elements, type
			) EmployeeDocumentAccesses,
			(
				select eda.*, 
				(select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type),
	 
				cd.CompanyId, 
				(select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type), (select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type) 
				from Document where TargetEntityId=eda.DocumentId for Xml path('Document'), elements, type) 
				from 
				(select e.Id EmployeeId, (e.FirstName +' '+ e.LastName) EmployeeName, ed.DocumentId, ed.CompanyDocumentSubType, ed.DateUploaded, ed.UploadedBy 
					from Employee e left outer join EmployeeDocument ed on e.Id=ed.EmployeeId
					where e.CompanyId=@company) eda
					left outer join CompanyDocumentSubType cd on eda.CompanyDocumentSubType=cd.Id or eda.CompanyDocumentSubType is null	
				where cd.CompanyId=@company 
				and cd.Type in (5) 
				order by eda.EmployeeName, eda.DocumentId
				for xml path('EmployeeDocument'), elements, type
			) EmployeeDocumentRequirements 
		for xml path('EmployeeDocumentMetaData'), elements, type
		)
	for xml Path('CompanyDashboardJson'), elements, type
END
GO
/****** Object:  StoredProcedure [dbo].[GetVendorInvoices]    Script Date: 15/07/2020 8:43:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetVendorInvoices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetVendorInvoices]
GO
/****** Object:  StoredProcedure [dbo].[GetVendorInvoices]    Script Date: 15/07/2020 8:43:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetVendorInvoices]
	@company uniqueidentifier = null,
	@startdate datetime = null,
	@enddate datetime = null,
	@id int=null,
	@void int=null,
	@year int = null
AS
BEGIN
	declare @company1 uniqueidentifier = @company,
	
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@id1 int=@id,
	@void1 int=@void,
	@year1 int = @year
	

	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Id=' + cast(@Id1 as varchar(max))
	
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'InvoiceDate>=''' + cast(@startdate1 as varchar(max)) + ''''
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'InvoiceDate<=''' + cast(@enddate1 as varchar(max)) + ''''
	
	if @void1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsVoid=' + cast(@void1 as varchar(max))
	if @year1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'year(InvoiceDate)=' + cast(@year1 as varchar(max))

	declare @query as nvarchar(max) = ''
	set @query = 'select 
			*, (select Contact from VendorCustomer where Id=CompanyInvoice.PayeeId) Contact,
			(select *, (select * from ProductService where Id=CompanyInvoiceItem.ProductId for xml path(''Product''), elements, type) from CompanyInvoiceItem where CompanyInvoiceId=CompanyInvoice.Id for xml auto, elements, type) InvoiceItems,
			(select * from CompanyInvoicePayment where CompanyInvoiceId=CompanyInvoice.Id for Xml path(''InvoicePaymentJson''), Elements, type) InvoicePayments
		from CompanyInvoice '
	if len(@where)>0
		set @query = @query + 'where ' + @where
	
	set @query = @query + 'for Xml path(''CompanyInvoiceJson''), root(''CompanyInvoiceList''), Elements, type'
	print @query
	Execute(@query)
	
	
END
GO
