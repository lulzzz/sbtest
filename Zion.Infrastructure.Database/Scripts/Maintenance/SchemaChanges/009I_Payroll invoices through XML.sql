/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 18/01/2017 11:53:29 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetPayrollInvoicesXml]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 18/01/2017 11:53:29 PM ******/
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
	@host varchar(max) = null,
	@company varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	select 
	(select 
		PayrollInvoiceJson.*,
		(	select PayrollJson.* 
			for xml path('Payroll'), elements, type
		),
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
			(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type)
			
			for Xml path('Company'), elements, type
		)
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson
	Where 
	--PayrollInvoiceJson.Id='1B197EE8-2A08-4358-B35C-A6F200CAF6AE' and 
	PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path('PayrollInvoiceJson'), elements, type
	)ResultList
	for xml path ('XmlResult')

END
GO
