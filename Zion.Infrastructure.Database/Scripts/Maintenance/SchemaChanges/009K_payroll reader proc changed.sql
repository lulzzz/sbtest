/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 30/01/2017 12:40:26 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 30/01/2017 12:40:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrolls]
	@company varchar(max) = null,
	@startdate varchar(max) = null,
	@enddate varchar(max) = null,
	@id uniqueidentifier=null,
	@invoice uniqueidentifier=null,
	@status varchar(max)=null,
	@void int=null
AS
BEGIN
	select
		Payroll.*,
		(	select PayrollInvoice.*,Payroll.PayDay PayrollPayDay,
			(select * from InvoicePayment where InvoiceId=PayrollInvoice.Id for Xml path(''InvoicePaymentJson''), Elements, type) InvoicePayments
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
			from PayrollInvoice Where PayrollId=Payroll.Id
			for xml path(''PayrollInvoice''), elements, type
		),
		(select PayrollPayCheck.*, Journal.DocumentId DocumentId from PayrollPayCheck, Journal where PayrollPayCheck.Id=Journal.PayrollPayCheckId and PayrollPayCheck.PEOASOCoCheck=Journal.PEOASOCoCheck and PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path(''PayrollPayCheckJson''), Elements, type) PayrollPayChecks
		from Company CompanyJson, Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where
		Payroll.CompanyId = CompanyJson.Id
		and ((@void is null) or (@void is not null and exists(select ''x'' from PayrollPayCheck where PayrollId=Payroll.Id and IsVoid=0)))
		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		Order by PayDay
		for Xml path(''PayrollJson''), root(''PayrollList''), elements, type
	
	
END' 
END
GO
