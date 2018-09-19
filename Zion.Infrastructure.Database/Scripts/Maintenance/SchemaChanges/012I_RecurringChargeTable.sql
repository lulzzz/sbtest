IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyRecurringCharge_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyRecurringCharge]'))
ALTER TABLE [dbo].[CompanyRecurringCharge] DROP CONSTRAINT [FK_CompanyRecurringCharge_Company]
GO

/****** Object:  Table [dbo].[CompanyRecurringCharge]    Script Date: 30/08/2018 11:12:34 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyRecurringCharge]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyRecurringCharge]
GO
/****** Object:  Table [dbo].[CompanyRecurringCharge]    Script Date: 30/08/2018 11:12:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyRecurringCharge]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyRecurringCharge](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[OldId] [int] NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[Year] [int] NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[AnnualLimit] [decimal](18, 2) NULL,
	[Claimed] decimal not null Default(0),
 CONSTRAINT [PK_CompanyRecurringCharge] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyRecurringCharge_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyRecurringCharge]'))
ALTER TABLE [dbo].[CompanyRecurringCharge]  WITH CHECK ADD  CONSTRAINT [FK_CompanyRecurringCharge_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyRecurringCharge_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyRecurringCharge]'))
ALTER TABLE [dbo].[CompanyRecurringCharge] CHECK CONSTRAINT [FK_CompanyRecurringCharge_Company]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 5/09/2018 11:43:41 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 5/09/2018 11:43:41 AM ******/
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
		(select * from CompanyRecurringCharge Where CompanyId=CompanyJson.Id for xml auto, elements, type) RecurringCharges, 
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
		
		
	

END
GO

/****** Object:  StoredProcedure [dbo].[GetCompanyPaychecksForInvoiceCredit]    Script Date: 5/09/2018 4:38:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPaychecksForInvoiceCredit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyPaychecksForInvoiceCredit]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPaychecksForInvoiceCredit]    Script Date: 5/09/2018 4:38:00 PM ******/
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
			PayrollPayCheck.Id, PayrollPayCheck.CheckNumber, PayrollPayCheck.GrossWage, PayrollPayCheck.EmployeeTaxes, PayrollPayCheck.EmployerTaxes, PayrollPayCheck.VoidedOn, PayrollInvoice.Id InvoiceId, PayrollPayCheck.Deductions, PayrollInvoice.InvoiceSetup, PayrollInvoice.Balance, PayrollInvoice.MiscCharges, PayrollPayCheck.PaymentMethod, PayrollInvoice.InvoiceNumber
		from PayrollPayCheck, PayrollInvoice
		where 
			PayrollPayCheck.InvoiceId=PayrollInvoice.Id
			and PayrollPayCheck.IsVoid=1 and InvoiceId is not null and CreditInvoiceId is null and PayrollInvoice.Balance<=0
			and ((@company is not null and PayrollPayCheck.CompanyId=@company) or (@company is null)) 
			
		Order by PayrollPayCheck.Id 
		for Xml path('VoidedPayCheckInvoiceCreditJson'), root('VoidedPayCheckInvoiceCreditList'), Elements, type
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPreviousInvoiceNumbers]    Script Date: 18/09/2018 5:02:34 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPreviousInvoiceNumbers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyPreviousInvoiceNumbers]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPreviousInvoiceNumbers]    Script Date: 18/09/2018 5:02:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPreviousInvoiceNumbers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyPreviousInvoiceNumbers] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyPreviousInvoiceNumbers]
	@company uniqueidentifier = null
AS
BEGIN
	
		select InvoiceNumber , -1 Status
		from PayrollInvoice pi1 
		where CompanyId=@company and exists(select 'x' from InvoicePayment where InvoiceId=pi1.Id and status=4) 
		union
		select InvoiceNumber , Status
		from PayrollInvoice pi1 
		where CompanyId=@company and Status=3
		for xml path('InvoiceByStatus'), root('InvoiceStatusList'), elements, type
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyRecurringCharges]    Script Date: 18/09/2018 5:02:34 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyRecurringCharges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyRecurringCharges]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyRecurringCharges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyRecurringCharges] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyRecurringCharges]
	@company uniqueidentifier = null
AS
BEGIN
	
		select * from CompanyRecurringCharge Where CompanyId=@company 
		
		for xml path('CompanyRecurringCharge'), root('CompanyRecurringChargeList'), elements, type
		
	
	
END
GO
