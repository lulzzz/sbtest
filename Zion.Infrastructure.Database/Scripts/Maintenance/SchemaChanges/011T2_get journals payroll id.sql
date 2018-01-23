IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Journal'
                 AND COLUMN_NAME = 'PayrollId')
Alter table Journal Add PayrollId uniqueidentifier;
Go



IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalComposite')
Drop Index IX_JournalComposite On dbo.Journal;
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalTransactionDate')
Drop Index IX_JournalTransactionDate On dbo.Journal;
GO


IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalComposite')
CREATE NONCLUSTERED INDEX [IX_JournalComposite] ON [dbo].[Journal]
(
	[CompanyId] ASC,
	[TransactionDate] ASC,
	[TransactionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalPayrollId')
CREATE NONCLUSTERED INDEX [IX_JournalPayrollId] ON [dbo].[Journal]
(
	[PayrollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalPayrollPayCheckId')
CREATE NONCLUSTERED INDEX [IX_JournalPayrollPayCheckIdId] ON [dbo].[Journal]
(
	[PayrollPayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalPEOASOCoCheck')
CREATE NONCLUSTERED INDEX [IX_JournalPEOASOCoCheck] ON [dbo].[Journal]
(
	[PEOASOCoCheck] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

Update Journal set PayrollId=(select PayrollId from PayrollPayCheck where Id=Journal.PayrollPayCheckId) where PayrollPayCheckId is not null;
Go

ALTER PROCEDURE [dbo].[GetJournals]
	@company uniqueidentifier = null,
	@paycheck int=null,
	@startdate datetime = null,
	@enddate datetime = null,
	@id int=null,
	@void int=null,
	@year int = null,
	@transactiontype int = null,
	@accountid int = null,
	@PEOASOCoCheck bit = null,
	@payrollid uniqueidentifier = null
AS
BEGIN
	
		select 
			Journal.*
		from Journal
		where
			((@id is not null and Id=@id) or (@id is null)) 
			and ((@PEOASOCoCheck is not null and PEOASOCoCheck=@PEOASOCoCheck) or @PEOASOCoCheck is null)
			and ((@void is not null and IsVoid=@void) or (@void is null))			
			and ((@payrollid is not null and PayrollId = @payrollid) or (@payrollid is null))
			and ((@paycheck is not null and PayrollPayCheckId=@paycheck) or (@paycheck is null)) 
			and ((@company is not null and CompanyId=@company) or (@company is null)) 
			and ((@startdate is not null and TransactionDate>=@startdate) or (@startdate is null)) 
			and ((@enddate is not null and TransactionDate<=@enddate) or (@enddate is null)) 
			and ((@year is not null and year(TransactionDate)=@year) or @year is null)
			and ((@transactiontype is not null and TransactionType=@transactiontype) or @transactiontype is null)
			and ((@accountid is not null and MainAccountId=@accountid) or @accountid is null)
			
		Order by Id 
		for Xml path('JournalJson'), root('JournalList'), Elements, type
		
	
	
END
Go

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckComposite')
Drop Index IX_PayrollPayCheckComposite On dbo.PayrollPayCheck;
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckComposite2')
Drop Index IX_PayrollPayCheckComposite2 On dbo.PayrollPayCheck;
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPayrollVoid')
Drop Index IX_PayrollPayCheckPayrollVoid On dbo.PayrollPayCheck;
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckVoidPayDay')
Drop Index IX_PayrollPayCheckVoidPayDay On dbo.PayrollPayCheck;
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckVoidTaxPayDay')
Drop Index IX_PayrollPayCheckVoidTaxPayDay On dbo.PayrollPayCheck;
GO

IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckCompanyId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckCompanyId] ON [dbo].[PayrollPayCheck]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPayrollId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckPayrollId] ON [dbo].[PayrollPayCheck]
(
	[PayrollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckEmployeeId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckEmployeeId] ON [dbo].[PayrollPayCheck]
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPayDay')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckPayDay] ON [dbo].[PayrollPayCheck]
(
	[PayDay] ASC
	
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckVoid')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckVoid] ON [dbo].[PayrollPayCheck]
(
	[IsVoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckTaxPayDay')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckTaxPayDay] ON [dbo].[PayrollPayCheck]
(
	[TaxPayDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPEOASOCoCheck')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckPEOASOCoCheck] ON [dbo].[PayrollPayCheck]
(
	[PEOASOCoCheck] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[JournalCheckNumber]') AND name = N'IX_JournalCheckNumber')
CREATE NONCLUSTERED INDEX [IX_JournalCheckNumber] ON [dbo].[Journal]
(
	[CheckNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO