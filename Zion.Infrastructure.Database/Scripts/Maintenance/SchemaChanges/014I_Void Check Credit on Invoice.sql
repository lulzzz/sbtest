/****** Object:  StoredProcedure [dbo].[GetCompanyPaychecksForInvoiceCredit]    Script Date: 16/07/2020 8:47:31 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPaychecksForInvoiceCredit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyPaychecksForInvoiceCredit]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPaychecksForInvoiceCredit]    Script Date: 16/07/2020 8:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCompanyPaychecksForInvoiceCredit]
	@company uniqueidentifier = null
AS
BEGIN
	declare @company1 uniqueidentifier = @company
		select 
			PayrollPayCheck.Id, PayrollPayCheck.CheckNumber, PayrollPayCheck.GrossWage, PayrollPayCheck.EmployeeTaxes, PayrollPayCheck.VoidedOn, PayrollInvoice.Id InvoiceId, PayrollPayCheck.Deductions, PayrollInvoice.InvoiceSetup, PayrollInvoice.Balance, PayrollInvoice.MiscCharges, PayrollPayCheck.PaymentMethod, PayrollInvoice.InvoiceNumber,
			PayrollPayCheck.Taxes, PayrollPayCheck.PayDay
		from PayrollPayCheck, PayrollInvoice
		where 
			PayrollPayCheck.InvoiceId=PayrollInvoice.Id
			and PayrollPayCheck.IsVoid=1 and InvoiceId is not null and CreditInvoiceId is null and PayrollInvoice.Balance<=0
			and ((@company1 is not null and PayrollPayCheck.CompanyId=@company1) or (@company1 is null)) 
			
		Order by PayrollPayCheck.Id 
		for Xml path('VoidedPayCheckInvoiceCreditJson'), root('VoidedPayCheckInvoiceCreditList'), Elements, type
		
	
	
END
GO
