/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 1/02/2017 7:18:05 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoicesXml]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 1/02/2017 7:18:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollInvoicesXml]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = '''',
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
		 Split.a.value(''.'', ''VARCHAR(100)'') AS status  
	FROM  
	(
		SELECT CAST (''<M>'' + REPLACE(@status, '','', ''</M><M>'') + ''</M>'' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes (''/M'') AS Split(a)

	select 
		PayrollInvoiceJson.*,
		PayrollJson.PayDay PayrollPayDay,
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
			(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type)
			
			for Xml path(''Company''), elements, type
		)
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson--, InvoicePayment InvoicePaymentJson
	Where 
	((@id is not null and PayrollInvoiceJson.Id=@id) or (@id is null)) 
	and ((@company is not null and PayrollInvoiceJson.CompanyId=@company) or (@company is null)) 
	and ((@startdate is not null and PayrollInvoiceJson.InvoiceDate>=@startdate) or (@startdate is null))
	and ((@enddate is not null and PayrollInvoiceJson.InvoiceDate<=@enddate) or (@enddate is null)) 
	and PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	and ((@status <>'''' and exists(select ''x'' from @tmpStatuses where status=PayrollInvoiceJson.Status)) or (@status=''''))
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path(''PayrollInvoiceJson''), root(''PayrollInvoiceJsonList''), elements, type
	

END' 
END
GO
