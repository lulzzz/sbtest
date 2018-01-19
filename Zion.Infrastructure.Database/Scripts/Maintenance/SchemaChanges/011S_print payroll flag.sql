IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'IsPrinted')
Alter table Payroll Add IsPrinted bit not null default(0);
Go
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollIsPrinted')
CREATE NONCLUSTERED INDEX [IX_PayrollIsPrinted] ON [dbo].[Payroll]
(
	[IsPrinted] ASC
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
		and ((@void is null) or (@void is not null and exists(select 'x' from PayrollPayCheck where PayrollId=Payroll.Id and IsVoid=0)))
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
Update Payroll set IsPrinted=1 where Status=5;
Go