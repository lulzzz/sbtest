IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'SalesRep')
alter table PayrollInvoice add SalesRep uniqueidentifier, Commission decimal(18,2);

/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 1/03/2017 11:05:37 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoicesXml]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionsReport]    Script Date: 1/03/2017 11:05:37 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionsReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCommissionsReport]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CommissionExtract_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommissionExtract]'))
ALTER TABLE [dbo].[CommissionExtract] DROP CONSTRAINT [FK_CommissionExtract_PayrollInvoice]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CommissionExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommissionExtract]'))
ALTER TABLE [dbo].[CommissionExtract] DROP CONSTRAINT [FK_CommissionExtract_MasterExtracts]
GO
/****** Object:  Table [dbo].[CommissionExtract]    Script Date: 1/03/2017 11:05:37 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommissionExtract]') AND type in (N'U'))
DROP TABLE [dbo].[CommissionExtract]
GO
/****** Object:  Table [dbo].[CommissionExtract]    Script Date: 1/03/2017 11:05:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommissionExtract]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CommissionExtract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollInvoiceId] [uniqueidentifier] NOT NULL,
	[MasterExtractId] [int] NOT NULL,
 CONSTRAINT [PK_CommissionExtract] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CommissionExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommissionExtract]'))
ALTER TABLE [dbo].[CommissionExtract]  WITH CHECK ADD  CONSTRAINT [FK_CommissionExtract_MasterExtracts] FOREIGN KEY([MasterExtractId])
REFERENCES [dbo].[MasterExtracts] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CommissionExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommissionExtract]'))
ALTER TABLE [dbo].[CommissionExtract] CHECK CONSTRAINT [FK_CommissionExtract_MasterExtracts]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CommissionExtract_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommissionExtract]'))
ALTER TABLE [dbo].[CommissionExtract]  WITH CHECK ADD  CONSTRAINT [FK_CommissionExtract_PayrollInvoice] FOREIGN KEY([PayrollInvoiceId])
REFERENCES [dbo].[PayrollInvoice] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CommissionExtract_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommissionExtract]'))
ALTER TABLE [dbo].[CommissionExtract] CHECK CONSTRAINT [FK_CommissionExtract_PayrollInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionsReport]    Script Date: 1/03/2017 11:05:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionsReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCommissionsReport] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCommissionsReport]
	@startdate datetime = null,
	@enddate datetime = null,
	@userId uniqueidentifier = null
AS
BEGIN
	select 
	(select
		u.Id as UserId, u.FirstName + ' ' + u.LastName as Name,
		(
			select 
				i.Id as InvoiceId, i.Commission,  i.InvoiceDate, c.CompanyName, i.InvoiceNumber
			from PayrollInvoice i, Company c
			where i.CompanyId = c.Id
			and c.StatusId=1
			and u.Active=1
			and i.SalesRep = u.Id
			and ((@userId is not null and i.SalesRep = @userId) or (@userId is null))
			and ((@startdate is not null and i.InvoiceDate>=@startdate) or (@startdate is null))
			and ((@enddate is not null and i.InvoiceDate<=@enddate) or (@enddate is null))
			and not exists(select 'x' from CommissionExtract where PayrollInvoiceId=i.id)
			for xml path('InvoiceCommission'), ELEMENTS, type
		) Commissions
	from AspNetUsers u
	where 
	u.Active=1
	and ((@userId is not null and u.Id = @userId) or (@userId is null))
	for xml path('ExtractSalesRep'), ELEMENTS, type) SalesReps
	for xml path('CommissionsResponse'), ELEMENTS, type
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 1/03/2017 11:05:37 AM ******/
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
		PayrollJson.PayDay PayrollPayDay,
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
	and ((@status <>'' and exists(select 'x' from @tmpStatuses where status=PayrollInvoiceJson.Status)) or (@status=''))
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path('PayrollInvoiceJson'), root('PayrollInvoiceJsonList'), elements, type
	

END
GO
