/****** Object:  StoredProcedure [dbo].[GetMinifiedPayrolls]    Script Date: 5/05/2017 4:11:35 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinifiedPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMinifiedPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetMinifiedPayrolls]    Script Date: 5/05/2017 4:11:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinifiedPayrolls]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetMinifiedPayrolls] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetMinifiedPayrolls]
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
		Payroll.Id, Company.CompanyName, Payroll.PayDay, Payroll.StartDate, Payroll.EndDate,Payroll.Status, Payroll.LastModifiedBy ProcessedBy, Payroll.LastModified, 
		Pinv.Id as InvoiceId,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		sum(PayrollPayCheck.GrossWage) TotalGrossWage, sum(PayrollPayCheck.NetWage) TotalNetWage
		from PayrollPayCheck, Company, Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where
		Company.Id=Payroll.CompanyId
		and Payroll.Id=PayrollPayCheck.PayrollId
		and ((@void is null) or (@void is not null and exists(select 'x' from PayrollPayCheck where PayrollId=Payroll.Id and IsVoid=0)))
		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and Payroll.PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and Payroll.PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		group by Payroll.Id, Company.CompanyName, Payroll.PayDay, Payroll.StartDate, Payroll.EndDate,Payroll.Status, Payroll.LastModifiedBy, Payroll.LastModified, 
		Pinv.Id,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status
		Order by PayDay
		for Xml path('PayrollMinified'), root('PayrollMinifiedList'), elements, type
	
	
END
GO
