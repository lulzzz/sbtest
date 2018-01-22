IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'HostCompanyId')
Alter table Payroll Add HostCompanyId uniqueidentifier;
Go
update payroll set HostCompanyId=(select host.CompanyId from host, company where host.id=company.hostid and company.id=payroll.companyid) where PEOASOCoCheck=1;
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollIsVoid')
CREATE NONCLUSTERED INDEX [IX_PayrollIsVoid] ON [dbo].[Payroll]
(
	[IsVoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollCopied')
CREATE NONCLUSTERED INDEX [IX_PayrollCopied] ON [dbo].[Payroll]
(
	[CopiedFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollMoved')
CREATE NONCLUSTERED INDEX [IX_PayrollMoved] ON [dbo].[Payroll]
(
	[MovedFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollHistory')
CREATE NONCLUSTERED INDEX [IX_PayrollHistory] ON [dbo].[Payroll]
(
	[IsHistory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayCheckCompensation]  Drop  CONSTRAINT [FK_PayCheckCompensation_PayrollPayCheck]
ALTER TABLE [dbo].[PayCheckCompensation]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckCompensation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE NO ACTION
GO


ALTER TABLE [dbo].[PayCheckTax]  Drop  CONSTRAINT [FK_PayCheckTax_PayrollPayCheck]
ALTER TABLE [dbo].[PayCheckTax]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckTax_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE NO ACTION
GO


ALTER TABLE [dbo].PayCheckPayCode  Drop  CONSTRAINT [FK_PayCheckPayCode_PayrollPayCheck]
ALTER TABLE [dbo].PayCheckPayCode  WITH CHECK ADD  CONSTRAINT [FK_PayCheckPayCode_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE NO ACTION
GO

ALTER TABLE [dbo].PayCheckDeduction  Drop  CONSTRAINT [FK_PayCheckDeduction_PayrollPayCheck]
ALTER TABLE [dbo].PayCheckDeduction  WITH CHECK ADD  CONSTRAINT [FK_PayCheckDeduction_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE NO ACTION
GO

ALTER TABLE [dbo].PayCheckWorkerCompensation  Drop  CONSTRAINT [FK_PayCheckWorkerCompensation_PayrollPayCheck]
ALTER TABLE [dbo].PayCheckWorkerCompensation  WITH CHECK ADD  CONSTRAINT [FK_PayCheckWorkerCompensation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE NO ACTION
GO

ALTER TABLE [dbo].PayCheckPayTypeAccumulation  Drop  CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayrollPayCheck]
ALTER TABLE [dbo].PayCheckPayTypeAccumulation  WITH CHECK ADD  CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
ON DELETE NO ACTION
GO

/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 22/01/2018 6:27:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournals]
GO
/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 22/01/2018 6:27:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetJournals] AS' 
END
GO
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
			and ((@payrollid is not null and PayrollPayCheckId in (select Id from PayrollPayCheck with (nolock) where PayrollId=@payrollid)) or (@payrollid is null))
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
GO


exec sp_updatestats;

