/****** Object:  Table [dbo].[ClosedYear]    Script Date: 9/10/2018 9:51:21 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClosedYear]') AND type in (N'U'))
DROP TABLE [dbo].[ClosedYear]
GO
/****** Object:  Table [dbo].[ClosedYear]    Script Date: 9/10/2018 9:51:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClosedYear]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ClosedYear](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Year] [int] NOT NULL,
	[ClosedBy] [varchar](max) NOT NULL,
	[ClosedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ClosedYear] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

/****** Object:  StoredProcedure [dbo].[CloseYear]    Script Date: 11/10/2018 8:33:13 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CloseYear]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CloseYear]
GO
/****** Object:  StoredProcedure [dbo].[ClosedYearDelete]    Script Date: 11/10/2018 8:33:13 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClosedYearDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ClosedYearDelete]
GO
/****** Object:  StoredProcedure [dbo].[ClosedYearDelete]    Script Date: 11/10/2018 8:33:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClosedYearDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ClosedYearDelete] AS' 
END
GO
ALTER PROCEDURE [dbo].[ClosedYearDelete]
	
AS
BEGIN

	delete from Common.Memento where Id in (select Id from PaxolArchive.Common.Memento); 
	delete from InvoiceDeliveryClaim where Id in (select Id from PaxolArchive.dbo.InvoiceDeliveryClaim);
	delete from CommissionExtract where MasterExtractId in (select Id from PaxolArchive.dbo.MasterExtracts);
	delete from ACHTransactionExtract where MasterExtractId in (select Id from PaxolArchive.dbo.MasterExtracts);
	delete from PayCheckExtract where MasterExtractId in (select Id from PaxolArchive.dbo.MasterExtracts);
	delete from MasterExtracts where Id in (select Id from PaxolArchive.dbo.MasterExtracts);
	delete from InvoicePayment where InvoiceId in (select Id from PaxolArchive.dbo.PayrollInvoice);
	delete from  PayrollInvoice where Id in (select Id from PaxolArchive.dbo.PayrollInvoice);
	delete from Journal where  PayrollId in (select Id from PaxolArchive.dbo.Payroll);
	delete from PayCheckCompensation where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
	delete from PayCheckDeduction where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
	delete from PayCheckTax where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
	delete from PayCheckPayCode where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
	delete from PayCheckPayTypeAccumulation where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
	delete from PayCheckWorkerCompensation where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
	delete from PayrollPayCheck where PayrollId in (select Id from PaxolArchive.dbo.Payroll);
	delete from Payroll where Id in  (select Id from PaxolArchive.dbo.Payroll);
	delete from CheckbookJournal where Id in (select Id from PaxolArchive.dbo.CheckbookJournal);
	delete from ACHTransaction where Id in (select Id from PaxolArchive.dbo.ACHTransaction);
	



END
GO
/****** Object:  StoredProcedure [dbo].[CloseYear]    Script Date: 11/10/2018 8:33:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CloseYear]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CloseYear] AS' 
END
GO
ALTER PROCEDURE [dbo].[CloseYear]
	@Year int,
	@User varchar(max)
AS
BEGIN

set identity_insert PaxolArchive.Common.Memento ON
insert into PaxolArchive.common.Memento([Id]
      ,[OriginatorType]
      ,[SourceTypeId]
      ,[MementoId]
      ,[Version]
      ,[DateCreated]
      ,[CreatedBy]
      ,[Comments]
      ,[UserId]) select [Id]
      ,[OriginatorType]
      ,[SourceTypeId]
      ,[MementoId]
      ,[Version]
      ,[DateCreated]
      ,[CreatedBy]
      ,[Comments]
      ,[UserId] from Common.Memento where Year(DateCreated)=@year
set identity_insert PaxolArchive.Common.Memento OFF

set identity_insert PaxolArchive.dbo.PayrollInvoice On
insert into PaxolArchive.dbo.PayrollInvoice ([Id]
      ,[CompanyId]
      ,[PayrollId]
      ,[InvoiceNumber]
      ,[PeriodStart]
      ,[PeriodEnd]
      ,[InvoiceSetup]
      ,[GrossWages]
      ,[EmployerTaxes]
      ,[InvoiceDate]
      ,[NoOfChecks]
      ,[Deductions]
      ,[WorkerCompensations]
      ,[EmployeeContribution]
      ,[EmployerContribution]
      ,[AdminFee]
      ,[EnvironmentalFee]
      ,[MiscCharges]
      ,[Total]
      ,[Status]
      ,[SubmittedOn]
      ,[SubmittedBy]
      ,[DeliveredOn]
      ,[DeliveredBy]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[Courier]
      ,[EmployeeTaxes]
      ,[Notes]
      ,[ProcessedBy]
      ,[Balance]
      ,[ProcessedOn]
      ,[PayChecks]
      ,[VoidedCreditChecks]
      ,[ApplyWCMinWageLimit]
      ,[DeliveryClaimedBy]
      ,[DeliveryClaimedOn]
      ,[NetPay]
      ,[CheckPay]
      ,[DDPay]
      ,[SalesRep]
      ,[Commission]
      ,[TaxesDelayed]
      ,[SpecialRequest]) select [Id]
      ,[CompanyId]
      ,[PayrollId]
      ,[InvoiceNumber]
      ,[PeriodStart]
      ,[PeriodEnd]
      ,[InvoiceSetup]
      ,[GrossWages]
      ,[EmployerTaxes]
      ,[InvoiceDate]
      ,[NoOfChecks]
      ,[Deductions]
      ,[WorkerCompensations]
      ,[EmployeeContribution]
      ,[EmployerContribution]
      ,[AdminFee]
      ,[EnvironmentalFee]
      ,[MiscCharges]
      ,[Total]
      ,[Status]
      ,[SubmittedOn]
      ,[SubmittedBy]
      ,[DeliveredOn]
      ,[DeliveredBy]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[Courier]
      ,[EmployeeTaxes]
      ,[Notes]
      ,[ProcessedBy]
      ,[Balance]
      ,[ProcessedOn]
      ,[PayChecks]
      ,[VoidedCreditChecks]
      ,[ApplyWCMinWageLimit]
      ,[DeliveryClaimedBy]
      ,[DeliveryClaimedOn]
      ,[NetPay]
      ,[CheckPay]
      ,[DDPay]
      ,[SalesRep]
      ,[Commission]
      ,[TaxesDelayed]
      ,[SpecialRequest] from PayrollInvoice where PayrollId in (select Id from Payroll p where year(TaxPayDay)<=@year and exists(select 'x' from CommissionExtract where PayrollInvoiceId = p.InvoiceId))
set identity_insert PaxolArchive.dbo.PayrollInvoice Off
set identity_insert PaxolArchive.dbo.InvoicePayment On
insert into PaxolArchive.dbo.InvoicePayment([Id]
      ,[InvoiceId]
      ,[PaymentDate]
      ,[Method]
      ,[Status]
      ,[CheckNumber]
      ,[Amount]
      ,[Notes]
      ,[LastModified]
      ,[LastModifiedBy]) select [Id]
      ,[InvoiceId]
      ,[PaymentDate]
      ,[Method]
      ,[Status]
      ,[CheckNumber]
      ,[Amount]
      ,[Notes]
      ,[LastModified]
      ,[LastModifiedBy] from InvoicePayment where InvoiceId in (select id from PaxolArchive.dbo.PayrollInvoice)
set identity_insert PaxolArchive.dbo.InvoicePayment Off

insert into PaxolArchive.dbo.Payroll ([Id]
      ,[CompanyId]
      ,[StartDate]
      ,[EndDate]
      ,[PayDay]
      ,[StartingCheckNumber]
      ,[Status]
      ,[Company]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[InvoiceId]
      ,[PEOASOCoCheck]
      ,[Notes]
      ,[TaxPayDay]
      ,[IsHistory]
      ,[CopiedFrom]
      ,[MovedFrom]
      ,[IsPrinted]
      ,[IsVoid]
      ,[HostCompanyId]
      ,[CompanyIntId]
      ,[IsQueued]
      ,[QueuedTime]
      ,[ConfirmedTime]
      ,[IsConfirmFailed]
      ,[InvoiceSpecialRequest]) select [Id]
      ,[CompanyId]
      ,[StartDate]
      ,[EndDate]
      ,[PayDay]
      ,[StartingCheckNumber]
      ,[Status]
      ,[Company]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[InvoiceId]
      ,[PEOASOCoCheck]
      ,[Notes]
      ,[TaxPayDay]
      ,[IsHistory]
      ,[CopiedFrom]
      ,[MovedFrom]
      ,[IsPrinted]
      ,[IsVoid]
      ,[HostCompanyId]
      ,[CompanyIntId]
      ,[IsQueued]
      ,[QueuedTime]
      ,[ConfirmedTime]
      ,[IsConfirmFailed]
      ,[InvoiceSpecialRequest] from Payroll p where year(TaxPayDay)<=@year and exists(select 'x' from CommissionExtract where PayrollInvoiceId = p.InvoiceId);

set identity_insert PaxolArchive.dbo.PayrollPayCheck On
insert into PaxolArchive.dbo.PayrollPayCheck ([Id]
      ,[PayrollId]
      ,[CompanyId]
      ,[EmployeeId]
      ,[Employee]
      ,[GrossWage]
      ,[NetWage]
      ,[WCAmount]
      ,[Compensations]
      ,[Deductions]
      ,[Taxes]
      ,[Accumulations]
      ,[Salary]
      ,[YTDSalary]
      ,[PayCodes]
      ,[DeductionAmount]
      ,[EmployeeTaxes]
      ,[EmployerTaxes]
      ,[Status]
      ,[IsVoid]
      ,[PayrmentMethod]
      ,[PrintStatus]
      ,[StartDate]
      ,[EndDate]
      ,[PayDay]
      ,[CheckNumber]
      ,[PaymentMethod]
      ,[Notes]
      ,[YTDGrossWage]
      ,[YTDNetWage]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[WorkerCompensation]
      ,[PEOASOCoCheck]
      ,[InvoiceId]
      ,[VoidedOn]
      ,[CreditInvoiceId]
      ,[TaxPayDay]
      ,[IsHistory]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[CompanyIntId]) select [Id]
      ,[PayrollId]
      ,[CompanyId]
      ,[EmployeeId]
      ,[Employee]
      ,[GrossWage]
      ,[NetWage]
      ,[WCAmount]
      ,[Compensations]
      ,[Deductions]
      ,[Taxes]
      ,[Accumulations]
      ,[Salary]
      ,[YTDSalary]
      ,[PayCodes]
      ,[DeductionAmount]
      ,[EmployeeTaxes]
      ,[EmployerTaxes]
      ,[Status]
      ,[IsVoid]
      ,[PayrmentMethod]
      ,[PrintStatus]
      ,[StartDate]
      ,[EndDate]
      ,[PayDay]
      ,[CheckNumber]
      ,[PaymentMethod]
      ,[Notes]
      ,[YTDGrossWage]
      ,[YTDNetWage]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[WorkerCompensation]
      ,[PEOASOCoCheck]
      ,[InvoiceId]
      ,[VoidedOn]
      ,[CreditInvoiceId]
      ,[TaxPayDay]
      ,[IsHistory]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[CompanyIntId] from PayrollPayCheck where PayrollId in (select Id from PaxolArchive.dbo.Payroll);
set identity_insert PaxolArchive.dbo.PayrollPayCheck Off
Insert into PaxolArchive.dbo.PayCheckCompensation ([PayCheckId]
      ,[PayTypeId]
      ,[Amount])
SELECT [PayCheckId]
      ,[PayTypeId]
      ,[Amount]
  FROM [PayCheckCompensation] where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
  Insert into PaxolArchive.dbo.PayCheckDeduction([PayCheckId]
      ,[EmployeeDeductionId]
      ,[CompanyDeductionId]
      ,[EmployeeDeductionFlat]
      ,[Method]
      ,[Rate]
      ,[AnnualMax]
      ,[Wage]
      ,[Amount])
SELECT [PayCheckId]
      ,[EmployeeDeductionId]
      ,[CompanyDeductionId]
      ,[EmployeeDeductionFlat]
      ,[Method]
      ,[Rate]
      ,[AnnualMax]
      ,[Wage]
      ,[Amount]
  FROM [PayCheckDeduction] where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
  Insert into PaxolArchive.dbo.PayCheckPayCode([PayCheckId]
      ,[PayCodeId]
      ,[PayCodeFlat]
      ,[Amount]
      ,[Overtime])
SELECT [PayCheckId]
      ,[PayCodeId]
      ,[PayCodeFlat]
      ,[Amount]
      ,[Overtime]
  FROM [PayCheckPayCode] where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
  Insert into PaxolArchive.dbo.PayCheckPayTypeAccumulation ([PayCheckId]
      ,[PayTypeId]
      ,[FiscalStart]
      ,[FiscalEnd]
      ,[AccumulatedValue]
      ,[Used]
      ,[CarryOver])
SELECT [PayCheckId]
      ,[PayTypeId]
      ,[FiscalStart]
      ,[FiscalEnd]
      ,[AccumulatedValue]
      ,[Used]
      ,[CarryOver]
  FROM [PayCheckPayTypeAccumulation] where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
  Insert into PaxolArchive.dbo.PayCheckTax([PayCheckId]
      ,[TaxId]
      ,[TaxableWage]
      ,[Amount])
SELECT [PayCheckId]
      ,[TaxId]
      ,[TaxableWage]
      ,[Amount]
  FROM [PayCheckTax] where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);
  Insert into PaxolArchive.dbo.PayCheckWorkerCompensation([PayCheckId]
      ,[WorkerCompensationId]
      ,[WorkerCompensationFlat]
      ,[Wage]
      ,[Amount])
SELECT [PayCheckId]
      ,[WorkerCompensationId]
      ,[WorkerCompensationFlat]
      ,[Wage]
      ,[Amount]
  FROM [PayCheckWorkerCompensation] where PayCheckId in (select Id from PaxolArchive.dbo.PayrollPayCheck);

  set identity_insert PaxolArchive.dbo.Journal On
  insert into PaxolArchive.dbo.Journal ([Id]
      ,[CompanyId]
      ,[TransactionType]
      ,[PaymentMethod]
      ,[CheckNumber]
      ,[PayrollPayCheckId]
      ,[EntityType]
      ,[PayeeId]
      ,[PayeeName]
      ,[Amount]
      ,[Memo]
      ,[IsDebit]
      ,[IsVoid]
      ,[MainAccountId]
      ,[TransactionDate]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[JournalDetails]
      ,[DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId]) select [Id]
      ,[CompanyId]
      ,[TransactionType]
      ,[PaymentMethod]
      ,[CheckNumber]
      ,[PayrollPayCheckId]
      ,[EntityType]
      ,[PayeeId]
      ,[PayeeName]
      ,[Amount]
      ,[Memo]
      ,[IsDebit]
      ,[IsVoid]
      ,[MainAccountId]
      ,[TransactionDate]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[JournalDetails]
      ,[DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId] from Journal where PayrollId in (select Id from PaxolArchive.dbo.Payroll);
  set identity_insert PaxolArchive.dbo.Journal Off
  
  set identity_insert PaxolArchive.dbo.ACHTransaction On
insert into PaxolArchive.dbo.ACHTransaction ([Id]
      ,[SourceParentId]
      ,[SourceId]
      ,[TransactionType]
      ,[Amount]
      ,[TransactionDate]
      ,[TransactionDescription]
      ,[OrignatorType]
      ,[OriginatorId]
      ,[ReceiverType]
      ,[ReceiverId]
      ,[Name]
      ,[CompanyName]) select [Id]
      ,[SourceParentId]
      ,[SourceId]
      ,[TransactionType]
      ,[Amount]
      ,[TransactionDate]
      ,[TransactionDescription]
      ,[OrignatorType]
      ,[OriginatorId]
      ,[ReceiverType]
      ,[ReceiverId]
      ,[Name]
      ,[CompanyName] from ACHTransaction where ((TransactionType=1) and (SourceId in (select id from PaxolArchive.dbo.PayrollPayCheck))) or ((TransactionType=2) and (sourceid in (select id from PaxolArchive.dbo.InvoicePayment)));
set identity_insert PaxolArchive.dbo.ACHTransaction Off

set identity_insert PaxolArchive.dbo.InvoiceDeliveryClaim On
insert into PaxolArchive.dbo.InvoiceDeliveryClaim([Id]
      ,[UserId]
      ,[UserName]
      ,[Invoices]
      ,[DeliveryClaimedOn]) select [Id]
      ,[UserId]
      ,[UserName]
      ,[Invoices]
      ,[DeliveryClaimedOn] from InvoiceDeliveryClaim where year(DeliveryClaimedOn)<=@year
set identity_insert PaxolArchive.dbo.InvoiceDeliveryClaim Off

set identity_insert PaxolArchive.dbo.CheckbookJournal On
  insert into PaxolArchive.dbo.CheckbookJournal([Id]
      ,[CompanyId]
      ,[TransactionType]
      ,[PaymentMethod]
      ,[CheckNumber]
      ,[PayrollPayCheckId]
      ,[EntityType]
      ,[PayeeId]
      ,[PayeeName]
      ,[Amount]
      ,[Memo]
      ,[IsDebit]
      ,[IsVoid]
      ,[MainAccountId]
      ,[TransactionDate]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[JournalDetails]
      ,[DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId]) select [Id]
      ,[CompanyId]
      ,[TransactionType]
      ,[PaymentMethod]
      ,[CheckNumber]
      ,[PayrollPayCheckId]
      ,[EntityType]
      ,[PayeeId]
      ,[PayeeName]
      ,[Amount]
      ,[Memo]
      ,[IsDebit]
      ,[IsVoid]
      ,[MainAccountId]
      ,[TransactionDate]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[JournalDetails]
      ,[DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId] from CheckbookJournal where year(TransactionDate)<=@year;
  set identity_insert PaxolArchive.dbo.CheckbookJournal Off
  set identity_insert PaxolArchive.dbo.MasterExtracts On
  insert into PaxolArchive.dbo.MasterExtracts([Id]
      ,[StartDate]
      ,[EndDate]
      ,[ExtractName]
      ,[IsFederal]
      ,[DepositDate]
      ,[Journals]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[ConfirmationNo]
      ,[ConfirmationNoUser]
      ,[ConfirmationNoTS]) select [Id]
      ,[StartDate]
      ,[EndDate]
      ,[ExtractName]
      ,[IsFederal]
      ,[DepositDate]
      ,[Journals]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[ConfirmationNo]
      ,[ConfirmationNoUser]
      ,[ConfirmationNoTS] from MasterExtracts where Year(enddate)<=@year
	  and ((ExtractName='ACH' and Id not in (select distinct MasterExtractId from ACHTransactionExtract where ACHTransactionId not in (select Id from PaxolArchive.dbo.ACHTransaction)))
			or (ExtractName='Commissions' and Id not in (select MasterExtractId from CommissionExtract where PayrollInvoiceId not in (select Id from PaxolArchive.dbo.PayrollInvoice)))
			or (ExtractName<>'ACH' and ExtractName<>'Commissions' and Id not in (select MasterExtractId from PayCheckExtract where PayrollPayCheckId not in (select Id from PaxolArchive.dbo.PayrollPayCheck)))
			);
  set identity_insert PaxolArchive.dbo.MasterExtracts off
  set identity_insert PaxolArchive.dbo.ACHTransactionExtract On
  insert into PaxolArchive.dbo.ACHTransactionExtract([Id]
      ,[ACHTransactionId]
      ,[MasterExtractId])
  select [Id]
      ,[ACHTransactionId]
      ,[MasterExtractId] from ACHTransactionExtract where MasterExtractId in (select Id from PaxolArchive.dbo.MasterExtracts);
  set identity_insert PaxolArchive.dbo.ACHTransactionExtract Off
  insert into PaxolArchive.dbo.PayCheckExtract([PayrollPayCheckId]
      ,[MasterExtractId]
      ,[Extract]
      ,[Type]) select [PayrollPayCheckId]
      ,[MasterExtractId]
      ,[Extract]
      ,[Type] from PayCheckExtract where MasterExtractId in (select Id from PaxolArchive.dbo.MasterExtracts);
	set identity_insert PaxolArchive.dbo.CommissionExtract On
	insert into PaxolArchive.dbo.CommissionExtract([Id]
      ,[PayrollInvoiceId]
      ,[MasterExtractId]) select [Id]
      ,[PayrollInvoiceId]
      ,[MasterExtractId] from CommissionExtract where  MasterExtractId in (select Id from PaxolArchive.dbo.MasterExtracts);
	set identity_insert PaxolArchive.dbo.CommissionExtract Off


	insert into ClosedYear([year], closedby, closedon) values(@year, @user, getdate());




END
GO

Use PaxolArchive;
/****** Object:  Table [dbo].[MasterExtract]    Script Date: 5/10/2018 9:34:44 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MasterExtract]') AND type in (N'U'))
DROP TABLE [dbo].[MasterExtract]
GO
/****** Object:  Table [dbo].[CompanyPayrollCube]    Script Date: 5/10/2018 9:34:44 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayrollCube]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyPayrollCube]
GO
/****** Object:  Table [Common].[StagingData]    Script Date: 5/10/2018 9:34:44 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[StagingData]') AND type in (N'U'))
DROP TABLE [Common].[StagingData]
GO
/****** Object:  Table [Common].[Memento]    Script Date: 5/10/2018 9:34:44 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND type in (N'U'))
DROP TABLE [Common].[Memento]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollDetail_Payroll]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]'))
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [FK_PayrollDetail_Payroll]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckWorkerCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]'))
ALTER TABLE [dbo].[PayCheckWorkerCompensation] DROP CONSTRAINT [FK_PayCheckWorkerCompensation_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckTax_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckTax]'))
ALTER TABLE [dbo].[PayCheckTax] DROP CONSTRAINT [FK_PayCheckTax_PayrollPayCheck]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayTypeAccumulation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]'))
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] DROP CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayCode_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]'))
ALTER TABLE [dbo].[PayCheckPayCode] DROP CONSTRAINT [FK_PayCheckPayCode_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract] DROP CONSTRAINT [FK_PayCheckExtract_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract] DROP CONSTRAINT [FK_PayCheckExtract_MasterExtracts]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckDeduction_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]'))
ALTER TABLE [dbo].[PayCheckDeduction] DROP CONSTRAINT [FK_PayCheckDeduction_PayrollPayCheck]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]'))
ALTER TABLE [dbo].[PayCheckCompensation] DROP CONSTRAINT [FK_PayCheckCompensation_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [FK_Journal_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InvoicePayment_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoicePayment]'))
ALTER TABLE [dbo].[InvoicePayment] DROP CONSTRAINT [FK_InvoicePayment_PayrollInvoice]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ACHTransactionExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]'))
ALTER TABLE [dbo].[ACHTransactionExtract] DROP CONSTRAINT [FK_ACHTransactionExtract_MasterExtracts]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ACHTransactionExtract_ACHTransaction]') AND parent_object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]'))
ALTER TABLE [dbo].[ACHTransactionExtract] DROP CONSTRAINT [FK_ACHTransactionExtract_ACHTransaction]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollPa__IsReI__4A18FC72]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF__PayrollPa__IsReI__4A18FC72]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollPa__IsHis__3F9B6DFF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF__PayrollPa__IsHis__3F9B6DFF]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollPa__TaxPa__351DDF8C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF__PayrollPa__TaxPa__351DDF8C]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollPa__PEOAS__40058253]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF__PayrollPa__PEOAS__40058253]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF_PayrollPayCheck_LastModified]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollDetail_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF_PayrollDetail_IsVoid]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_YTDSalary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF_PayrollPayCheck_YTDSalary]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_Salary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] DROP CONSTRAINT [DF_PayrollPayCheck_Salary]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Taxes__17236851]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF__PayrollIn__Taxes__17236851]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__DDPay__0C50D423]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF__PayrollIn__DDPay__0C50D423]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Check__0B5CAFEA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF__PayrollIn__Check__0B5CAFEA]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__NetPa__0A688BB1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF__PayrollIn__NetPa__0A688BB1]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Apply__4F47C5E3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF__PayrollIn__Apply__4F47C5E3]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Voide__4E53A1AA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF__PayrollIn__Voide__4E53A1AA]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__PayCh__4D5F7D71]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF__PayrollIn__PayCh__4D5F7D71]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Proce__4C6B5938]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF__PayrollIn__Proce__4C6B5938]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Balan__4B7734FF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF__PayrollIn__Balan__4B7734FF]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Proce__4A8310C6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF__PayrollIn__Proce__4A8310C6]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollInvoice_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF_PayrollInvoice_LastModified]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollInvoice_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] DROP CONSTRAINT [DF_PayrollInvoice_Id]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__IsConfi__02B25B50]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] DROP CONSTRAINT [DF__Payroll__IsConfi__02B25B50]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__IsQueue__01BE3717]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] DROP CONSTRAINT [DF__Payroll__IsQueue__01BE3717]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__IsVoid__1D9B5BB6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] DROP CONSTRAINT [DF__Payroll__IsVoid__1D9B5BB6]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__IsPrint__1CA7377D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] DROP CONSTRAINT [DF__Payroll__IsPrint__1CA7377D]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__IsHisto__3EA749C6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] DROP CONSTRAINT [DF__Payroll__IsHisto__3EA749C6]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__TaxPayD__3429BB53]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] DROP CONSTRAINT [DF__Payroll__TaxPayD__3429BB53]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__PEOASOC__3F115E1A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] DROP CONSTRAINT [DF__Payroll__PEOASOC__3F115E1A]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Payroll_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] DROP CONSTRAINT [DF_Payroll_LastModified]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_CarryOver]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] DROP CONSTRAINT [DF_PayCheckPayTypeAccumulation_CarryOver]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_Used]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] DROP CONSTRAINT [DF_PayCheckPayTypeAccumulation_Used]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_AccumulatedValue]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] DROP CONSTRAINT [DF_PayCheckPayTypeAccumulation_AccumulatedValue]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Journal__IsReIss__4B0D20AB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [DF__Journal__IsReIss__4B0D20AB]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Journal__PEOASOC__40F9A68C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [DF__Journal__PEOASOC__40F9A68C]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Journal__Documen__3B40CD36]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [DF__Journal__Documen__3B40CD36]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Journal_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [DF_Journal_LastModified]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Journal_TransactionDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [DF_Journal_TransactionDate]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Journal_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] DROP CONSTRAINT [DF_Journal_IsVoid]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_InvoicePayment_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[InvoicePayment] DROP CONSTRAINT [DF_InvoicePayment_LastModified]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF_Memento_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Memento] DROP CONSTRAINT [DF_Memento_DateCreated]
END

GO
/****** Object:  Index [IX_PayrollPayCheckVoid]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckVoid')
DROP INDEX [IX_PayrollPayCheckVoid] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckTaxPayDay]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckTaxPayDay')
DROP INDEX [IX_PayrollPayCheckTaxPayDay] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckStatus]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckStatus')
DROP INDEX [IX_PayrollPayCheckStatus] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckPEOASOCoCheck]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPEOASOCoCheck')
DROP INDEX [IX_PayrollPayCheckPEOASOCoCheck] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckPayrollId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPayrollId')
DROP INDEX [IX_PayrollPayCheckPayrollId] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckPaymentMethod]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPaymentMethod')
DROP INDEX [IX_PayrollPayCheckPaymentMethod] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckPayDay]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPayDay')
DROP INDEX [IX_PayrollPayCheckPayDay] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckIsHistory]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckIsHistory')
DROP INDEX [IX_PayrollPayCheckIsHistory] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckInvoiceId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckInvoiceId')
DROP INDEX [IX_PayrollPayCheckInvoiceId] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckEmployeeId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckEmployeeId')
DROP INDEX [IX_PayrollPayCheckEmployeeId] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckCreditInvoiceId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckCreditInvoiceId')
DROP INDEX [IX_PayrollPayCheckCreditInvoiceId] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckCompanyIntId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckCompanyIntId')
DROP INDEX [IX_PayrollPayCheckCompanyIntId] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollPayCheckCompanyId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckCompanyId')
DROP INDEX [IX_PayrollPayCheckCompanyId] ON [dbo].[PayrollPayCheck]
GO
/****** Object:  Index [IX_PayrollInvoiceTaxesDelayed]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoiceTaxesDelayed')
DROP INDEX [IX_PayrollInvoiceTaxesDelayed] ON [dbo].[PayrollInvoice]
GO
/****** Object:  Index [IX_PayrollInvoiceStatus]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoiceStatus')
DROP INDEX [IX_PayrollInvoiceStatus] ON [dbo].[PayrollInvoice]
GO
/****** Object:  Index [IX_PayrollInvoicePayrollId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoicePayrollId')
DROP INDEX [IX_PayrollInvoicePayrollId] ON [dbo].[PayrollInvoice]
GO
/****** Object:  Index [IX_PayrollInvoiceInvoiceNumber]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoiceInvoiceNumber')
DROP INDEX [IX_PayrollInvoiceInvoiceNumber] ON [dbo].[PayrollInvoice]
GO
/****** Object:  Index [IX_PayrollInvoiceInvoiceDate]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoiceInvoiceDate')
DROP INDEX [IX_PayrollInvoiceInvoiceDate] ON [dbo].[PayrollInvoice]
GO
/****** Object:  Index [IX_PayrollInvoiceCompanyId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoiceCompanyId')
DROP INDEX [IX_PayrollInvoiceCompanyId] ON [dbo].[PayrollInvoice]
GO
/****** Object:  Index [IX_PayrollTaxPayDay]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollTaxPayDay')
DROP INDEX [IX_PayrollTaxPayDay] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_PayrollPayDay]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollPayDay')
DROP INDEX [IX_PayrollPayDay] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_PayrollMoved]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollMoved')
DROP INDEX [IX_PayrollMoved] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_PayrollIsVoid]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollIsVoid')
DROP INDEX [IX_PayrollIsVoid] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_PayrollIsQueued]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollIsQueued')
DROP INDEX [IX_PayrollIsQueued] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_PayrollIsPrinted]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollIsPrinted')
DROP INDEX [IX_PayrollIsPrinted] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_PayrollHistory]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollHistory')
DROP INDEX [IX_PayrollHistory] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_PayrollCopied]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollCopied')
DROP INDEX [IX_PayrollCopied] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_PayrollCompanyIntId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollCompanyIntId')
DROP INDEX [IX_PayrollCompanyIntId] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_Payroll_2]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_Payroll_2')
DROP INDEX [IX_Payroll_2] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_Payroll_1]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_Payroll_1')
DROP INDEX [IX_Payroll_1] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_Payroll]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_Payroll')
DROP INDEX [IX_Payroll] ON [dbo].[Payroll]
GO
/****** Object:  Index [IX_PayCheckWCWorkerCompensationId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]') AND name = N'IX_PayCheckWCWorkerCompensationId')
DROP INDEX [IX_PayCheckWCWorkerCompensationId] ON [dbo].[PayCheckWorkerCompensation]
GO
/****** Object:  Index [IX_PayCheckWCPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]') AND name = N'IX_PayCheckWCPayCheckId')
DROP INDEX [IX_PayCheckWCPayCheckId] ON [dbo].[PayCheckWorkerCompensation]
GO
/****** Object:  Index [IX_PayCheckTaxTaxId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckTax]') AND name = N'IX_PayCheckTaxTaxId')
DROP INDEX [IX_PayCheckTaxTaxId] ON [dbo].[PayCheckTax]
GO
/****** Object:  Index [IX_PayCheckTaxPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckTax]') AND name = N'IX_PayCheckTaxPayCheckId')
DROP INDEX [IX_PayCheckTaxPayCheckId] ON [dbo].[PayCheckTax]
GO
/****** Object:  Index [IX_PayCheckPayTypeAccumulationPayTypeId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]') AND name = N'IX_PayCheckPayTypeAccumulationPayTypeId')
DROP INDEX [IX_PayCheckPayTypeAccumulationPayTypeId] ON [dbo].[PayCheckPayTypeAccumulation]
GO
/****** Object:  Index [IX_PayCheckPayTypeAccumulationPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]') AND name = N'IX_PayCheckPayTypeAccumulationPayCheckId')
DROP INDEX [IX_PayCheckPayTypeAccumulationPayCheckId] ON [dbo].[PayCheckPayTypeAccumulation]
GO
/****** Object:  Index [IX_PayCheckPayCodePayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND name = N'IX_PayCheckPayCodePayCheckId')
DROP INDEX [IX_PayCheckPayCodePayCheckId] ON [dbo].[PayCheckPayCode]
GO
/****** Object:  Index [IX_PayCheckPayCode]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND name = N'IX_PayCheckPayCode')
DROP INDEX [IX_PayCheckPayCode] ON [dbo].[PayCheckPayCode]
GO
/****** Object:  Index [IX_PayCheckExtractType]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND name = N'IX_PayCheckExtractType')
DROP INDEX [IX_PayCheckExtractType] ON [dbo].[PayCheckExtract]
GO
/****** Object:  Index [IX_PayCheckExtractPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND name = N'IX_PayCheckExtractPayCheckId')
DROP INDEX [IX_PayCheckExtractPayCheckId] ON [dbo].[PayCheckExtract]
GO
/****** Object:  Index [IX_PayCheckExtractExtract]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND name = N'IX_PayCheckExtractExtract')
DROP INDEX [IX_PayCheckExtractExtract] ON [dbo].[PayCheckExtract]
GO
/****** Object:  Index [IX_PayCheckDeductionPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND name = N'IX_PayCheckDeductionPayCheckId')
DROP INDEX [IX_PayCheckDeductionPayCheckId] ON [dbo].[PayCheckDeduction]
GO
/****** Object:  Index [IX_PayCheckDeduction]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND name = N'IX_PayCheckDeduction')
DROP INDEX [IX_PayCheckDeduction] ON [dbo].[PayCheckDeduction]
GO
/****** Object:  Index [IX_PayCheckCompensationPayTypeId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]') AND name = N'IX_PayCheckCompensationPayTypeId')
DROP INDEX [IX_PayCheckCompensationPayTypeId] ON [dbo].[PayCheckCompensation]
GO
/****** Object:  Index [IX_PayCheckCompensationPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]') AND name = N'IX_PayCheckCompensationPayCheckId')
DROP INDEX [IX_PayCheckCompensationPayCheckId] ON [dbo].[PayCheckCompensation]
GO
/****** Object:  Index [NonClusteredIndex-20180124-101638]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'NonClusteredIndex-20180124-101638')
DROP INDEX [NonClusteredIndex-20180124-101638] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalTransactionDate]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalTransactionDate')
DROP INDEX [IX_JournalTransactionDate] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalPEOASOCoCheck]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalPEOASOCoCheck')
DROP INDEX [IX_JournalPEOASOCoCheck] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalPayrollPayCheckIdId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalPayrollPayCheckIdId')
DROP INDEX [IX_JournalPayrollPayCheckIdId] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalPayrollId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalPayrollId')
DROP INDEX [IX_JournalPayrollId] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalMainAccountId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalMainAccountId')
DROP INDEX [IX_JournalMainAccountId] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalIsVoid]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalIsVoid')
DROP INDEX [IX_JournalIsVoid] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalIsDebit]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalIsDebit')
DROP INDEX [IX_JournalIsDebit] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalCompanyIntId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalCompanyIntId')
DROP INDEX [IX_JournalCompanyIntId] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalCompanyId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalCompanyId')
DROP INDEX [IX_JournalCompanyId] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_JournalCheckNumber]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalCheckNumber')
DROP INDEX [IX_JournalCheckNumber] ON [dbo].[Journal]
GO
/****** Object:  Index [IX_InvoicePaymentInvoiceId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND name = N'IX_InvoicePaymentInvoiceId')
DROP INDEX [IX_InvoicePaymentInvoiceId] ON [dbo].[InvoicePayment]
GO
/****** Object:  Index [IX_InvoicePayment_2]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND name = N'IX_InvoicePayment_2')
DROP INDEX [IX_InvoicePayment_2] ON [dbo].[InvoicePayment]
GO
/****** Object:  Index [IX_InvoicePayment_1]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND name = N'IX_InvoicePayment_1')
DROP INDEX [IX_InvoicePayment_1] ON [dbo].[InvoicePayment]
GO
/****** Object:  Index [IX_InvoicePayment]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND name = N'IX_InvoicePayment')
DROP INDEX [IX_InvoicePayment] ON [dbo].[InvoicePayment]
GO
/****** Object:  Index [IX_ACHTransactionExtractTransactionId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]') AND name = N'IX_ACHTransactionExtractTransactionId')
DROP INDEX [IX_ACHTransactionExtractTransactionId] ON [dbo].[ACHTransactionExtract]
GO
/****** Object:  Index [IX_ACHTransactionExtractMasterExtractId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]') AND name = N'IX_ACHTransactionExtractMasterExtractId')
DROP INDEX [IX_ACHTransactionExtractMasterExtractId] ON [dbo].[ACHTransactionExtract]
GO
/****** Object:  Index [IX_ACHTransactionTransactionDate]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionTransactionDate')
DROP INDEX [IX_ACHTransactionTransactionDate] ON [dbo].[ACHTransaction]
GO
/****** Object:  Index [IX_ACHTransactionReceiverType]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionReceiverType')
DROP INDEX [IX_ACHTransactionReceiverType] ON [dbo].[ACHTransaction]
GO
/****** Object:  Index [IX_ACHTransactionReceiverId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionReceiverId')
DROP INDEX [IX_ACHTransactionReceiverId] ON [dbo].[ACHTransaction]
GO
/****** Object:  Index [IX_ACHTransactionOriginatorType]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionOriginatorType')
DROP INDEX [IX_ACHTransactionOriginatorType] ON [dbo].[ACHTransaction]
GO
/****** Object:  Index [IX_ACHTransactionOriginatorId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionOriginatorId')
DROP INDEX [IX_ACHTransactionOriginatorId] ON [dbo].[ACHTransaction]
GO
/****** Object:  Index [IX_ACHTransaction]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransaction')
DROP INDEX [IX_ACHTransaction] ON [dbo].[ACHTransaction]
GO
/****** Object:  Index [IX_Memento_1]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento_1')
DROP INDEX [IX_Memento_1] ON [Common].[Memento]
GO
/****** Object:  Index [IX_Memento]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento')
DROP INDEX [IX_Memento] ON [Common].[Memento]
GO
/****** Object:  Table [dbo].[PayrollPayCheck]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND type in (N'U'))
DROP TABLE [dbo].[PayrollPayCheck]
GO
/****** Object:  Table [dbo].[PayrollInvoice]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND type in (N'U'))
DROP TABLE [dbo].[PayrollInvoice]
GO
/****** Object:  Table [dbo].[Payroll]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND type in (N'U'))
DROP TABLE [dbo].[Payroll]
GO
/****** Object:  Table [dbo].[PayCheckWorkerCompensation]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckWorkerCompensation]
GO
/****** Object:  Table [dbo].[PayCheckTax]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckTax]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckTax]
GO
/****** Object:  Table [dbo].[PayCheckPayTypeAccumulation]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckPayTypeAccumulation]
GO
/****** Object:  Table [dbo].[PayCheckPayCode]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckPayCode]
GO
/****** Object:  Table [dbo].[PayCheckExtract]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckExtract]
GO
/****** Object:  Table [dbo].[PayCheckDeduction]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckDeduction]
GO
/****** Object:  Table [dbo].[PayCheckCompensation]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckCompensation]
GO
/****** Object:  Table [dbo].[MasterExtracts]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MasterExtracts]') AND type in (N'U'))
DROP TABLE [dbo].[MasterExtracts]
GO
/****** Object:  Table [dbo].[Journal]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND type in (N'U'))
DROP TABLE [dbo].[Journal]
GO
/****** Object:  Table [dbo].[InvoicePayment]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND type in (N'U'))
DROP TABLE [dbo].[InvoicePayment]
GO
/****** Object:  Table [dbo].[InvoiceDeliveryClaim]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceDeliveryClaim]') AND type in (N'U'))
DROP TABLE [dbo].[InvoiceDeliveryClaim]
GO
/****** Object:  Table [dbo].[ACHTransactionExtract]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]') AND type in (N'U'))
DROP TABLE [dbo].[ACHTransactionExtract]
GO
/****** Object:  Table [dbo].[ACHTransaction]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND type in (N'U'))
DROP TABLE [dbo].[ACHTransaction]
GO
/****** Object:  Table [Common].[Memento]    Script Date: 3/10/2018 12:43:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND type in (N'U'))
DROP TABLE [Common].[Memento]
GO
/****** Object:  Table [Common].[Memento]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND type in (N'U'))
BEGIN
CREATE TABLE [Common].[Memento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OriginatorType] [varchar](max) NOT NULL,
	[SourceTypeId] [int] NOT NULL,
	[MementoId] [uniqueidentifier] NOT NULL,
	[Version] [decimal](18, 2) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [varchar](max) NOT NULL,
	[Comments] [varchar](max) NULL,
	[UserId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Common.Memento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ACHTransaction]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ACHTransaction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SourceParentId] [uniqueidentifier] NOT NULL,
	[SourceId] [int] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[TransactionDescription] [varchar](max) NOT NULL,
	[OrignatorType] [int] NOT NULL,
	[OriginatorId] [uniqueidentifier] NOT NULL,
	[ReceiverType] [int] NOT NULL,
	[ReceiverId] [uniqueidentifier] NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[CompanyName] [varchar](max) NULL,
 CONSTRAINT [PK_ACHTransaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ACHTransactionExtract]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ACHTransactionExtract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ACHTransactionId] [int] NOT NULL,
	[MasterExtractId] [int] NOT NULL,
 CONSTRAINT [PK_ACHTransactionExtract_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[InvoiceDeliveryClaim]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoiceDeliveryClaim]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InvoiceDeliveryClaim](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [varchar](max) NOT NULL,
	[Invoices] [varchar](max) NOT NULL,
	[DeliveryClaimedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_InvoiceDeliveryClaim] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[InvoicePayment]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InvoicePayment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[Method] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CheckNumber] [int] NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Notes] [varchar](max) NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_InvoicePayment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Journal]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Journal](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[PaymentMethod] [int] NOT NULL,
	[CheckNumber] [int] NOT NULL,
	[PayrollPayCheckId] [int] NULL,
	[EntityType] [int] NOT NULL,
	[PayeeId] [uniqueidentifier] NOT NULL,
	[PayeeName] [varchar](max) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Memo] [varchar](max) NULL,
	[IsDebit] [bit] NOT NULL,
	[IsVoid] [bit] NOT NULL,
	[MainAccountId] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[JournalDetails] [varchar](max) NOT NULL,
	[DocumentId] [uniqueidentifier] NOT NULL,
	[PEOASOCoCheck] [bit] NOT NULL,
	[OriginalDate] [datetime] NULL,
	[IsReIssued] [bit] NOT NULL,
	[OriginalCheckNumber] [int] NULL,
	[ReIssuedDate] [datetime] NULL,
	[PayrollId] [uniqueidentifier] NULL,
	[CompanyIntId] [int] NULL,
 CONSTRAINT [PK_Journal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[MasterExtracts]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MasterExtracts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MasterExtracts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[ExtractName] [varchar](max) NOT NULL,
	[IsFederal] [bit] NOT NULL,
	[DepositDate] [datetime] NOT NULL,
	[Journals] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[ConfirmationNo] [varchar](max) NULL,
	[ConfirmationNoUser] [varchar](max) NULL,
	[ConfirmationNoTS] [datetime] NULL,
 CONSTRAINT [PK_MasterExtracts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayCheckCompensation]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckCompensation](
	[PayCheckId] [int] NOT NULL,
	[PayTypeId] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckCompensation] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[PayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayCheckDeduction]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckDeduction](
	[PayCheckId] [int] NOT NULL,
	[EmployeeDeductionId] [int] NOT NULL,
	[CompanyDeductionId] [int] NOT NULL,
	[EmployeeDeductionFlat] [varchar](max) NULL,
	[Method] [int] NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
	[AnnualMax] [decimal](18, 2) NULL,
	[Wage] [decimal](18, 2) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckDeduction] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[EmployeeDeductionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayCheckExtract]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckExtract](
	[PayrollPayCheckId] [int] NOT NULL,
	[MasterExtractId] [int] NOT NULL,
	[Extract] [varchar](50) NOT NULL,
	[Type] [int] NOT NULL,
 CONSTRAINT [PK_PayCheckExtract_1] PRIMARY KEY CLUSTERED 
(
	[PayrollPayCheckId] ASC,
	[Extract] ASC,
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayCheckPayCode]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckPayCode](
	[PayCheckId] [int] NOT NULL,
	[PayCodeId] [int] NOT NULL,
	[PayCodeFlat] [varchar](max) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Overtime] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckPayCode] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[PayCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayCheckPayTypeAccumulation]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckPayTypeAccumulation](
	[PayCheckId] [int] NOT NULL,
	[PayTypeId] [int] NOT NULL,
	[FiscalStart] [datetime] NOT NULL,
	[FiscalEnd] [datetime] NOT NULL,
	[AccumulatedValue] [decimal](18, 2) NOT NULL,
	[Used] [decimal](18, 2) NOT NULL,
	[CarryOver] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckPayTypeAccumulation] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[PayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayCheckTax]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckTax]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckTax](
	[PayCheckId] [int] NOT NULL,
	[TaxId] [int] NOT NULL,
	[TaxableWage] [decimal](18, 2) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckTax] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[TaxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayCheckWorkerCompensation]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckWorkerCompensation](
	[PayCheckId] [int] NOT NULL,
	[WorkerCompensationId] [int] NOT NULL,
	[WorkerCompensationFlat] [varchar](max) NOT NULL,
	[Wage] [decimal](18, 2) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckWorkerCompensation] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[WorkerCompensationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Payroll]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payroll](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[PayDay] [datetime] NOT NULL,
	[StartingCheckNumber] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Company] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[InvoiceId] [uniqueidentifier] NULL,
	[PEOASOCoCheck] [bit] NOT NULL,
	[Notes] [varchar](max) NULL,
	[TaxPayDay] [datetime] NOT NULL,
	[IsHistory] [bit] NOT NULL,
	[CopiedFrom] [uniqueidentifier] NULL,
	[MovedFrom] [uniqueidentifier] NULL,
	[IsPrinted] [bit] NOT NULL,
	[IsVoid] [bit] NOT NULL,
	[HostCompanyId] [uniqueidentifier] NULL,
	[CompanyIntId] [int] NULL,
	[IsQueued] [bit] NOT NULL,
	[QueuedTime] [datetime] NULL,
	[ConfirmedTime] [datetime] NULL,
	[IsConfirmFailed] [bit] NOT NULL,
	[InvoiceSpecialRequest] [varchar](max) NULL,
 CONSTRAINT [PK_Payroll] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayrollInvoice]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayrollInvoice](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[PayrollId] [uniqueidentifier] NOT NULL,
	[InvoiceNumber] [int] IDENTITY(1,1) NOT NULL,
	[PeriodStart] [datetime] NOT NULL,
	[PeriodEnd] [datetime] NOT NULL,
	[InvoiceSetup] [varchar](max) NOT NULL,
	[GrossWages] [decimal](18, 2) NOT NULL,
	[EmployerTaxes] [varchar](max) NOT NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[NoOfChecks] [int] NOT NULL,
	[Deductions] [varchar](max) NOT NULL,
	[WorkerCompensations] [varchar](max) NOT NULL,
	[EmployeeContribution] [decimal](18, 2) NOT NULL,
	[EmployerContribution] [decimal](18, 2) NOT NULL,
	[AdminFee] [decimal](18, 2) NOT NULL,
	[EnvironmentalFee] [decimal](18, 2) NOT NULL,
	[MiscCharges] [varchar](max) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[Status] [int] NOT NULL,
	[SubmittedOn] [datetime] NULL,
	[SubmittedBy] [varchar](max) NULL,
	[DeliveredOn] [datetime] NULL,
	[DeliveredBy] [varchar](max) NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[Courier] [varchar](max) NULL,
	[EmployeeTaxes] [varchar](max) NOT NULL,
	[Notes] [varchar](max) NULL,
	[ProcessedBy] [varchar](max) NOT NULL,
	[Balance] [decimal](18, 2) NOT NULL,
	[ProcessedOn] [datetime] NOT NULL,
	[PayChecks] [varchar](max) NOT NULL,
	[VoidedCreditChecks] [varchar](max) NOT NULL,
	[ApplyWCMinWageLimit] [bit] NOT NULL,
	[DeliveryClaimedBy] [varchar](max) NULL,
	[DeliveryClaimedOn] [datetime] NULL,
	[NetPay] [decimal](18, 2) NOT NULL,
	[CheckPay] [decimal](18, 2) NOT NULL,
	[DDPay] [decimal](18, 2) NOT NULL,
	[SalesRep] [uniqueidentifier] NULL,
	[Commission] [decimal](18, 2) NULL,
	[TaxesDelayed] [bit] NULL,
	[SpecialRequest] [varchar](max) NULL,
 CONSTRAINT [PK_PayrollInvoice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayrollPayCheck]    Script Date: 3/10/2018 12:43:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayrollPayCheck](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[Employee] [varchar](max) NOT NULL,
	[GrossWage] [decimal](18, 2) NOT NULL,
	[NetWage] [decimal](18, 2) NOT NULL,
	[WCAmount] [decimal](18, 0) NOT NULL,
	[Compensations] [varchar](max) NOT NULL,
	[Deductions] [varchar](max) NOT NULL,
	[Taxes] [varchar](max) NOT NULL,
	[Accumulations] [varchar](max) NOT NULL,
	[Salary] [decimal](18, 2) NOT NULL,
	[YTDSalary] [decimal](18, 2) NOT NULL,
	[PayCodes] [varchar](max) NOT NULL,
	[DeductionAmount] [decimal](18, 2) NOT NULL,
	[EmployeeTaxes] [decimal](18, 2) NOT NULL,
	[EmployerTaxes] [decimal](18, 2) NOT NULL,
	[Status] [int] NOT NULL,
	[IsVoid] [bit] NOT NULL,
	[PayrmentMethod] [int] NOT NULL,
	[PrintStatus] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[PayDay] [datetime] NOT NULL,
	[CheckNumber] [int] NOT NULL,
	[PaymentMethod] [int] NOT NULL,
	[Notes] [varchar](max) NOT NULL,
	[YTDGrossWage] [decimal](18, 2) NOT NULL,
	[YTDNetWage] [decimal](18, 2) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[WorkerCompensation] [varchar](max) NULL,
	[PEOASOCoCheck] [bit] NOT NULL,
	[InvoiceId] [uniqueidentifier] NULL,
	[VoidedOn] [datetime] NULL,
	[CreditInvoiceId] [uniqueidentifier] NULL,
	[TaxPayDay] [datetime] NOT NULL,
	[IsHistory] [bit] NOT NULL,
	[IsReIssued] [bit] NOT NULL,
	[OriginalCheckNumber] [int] NULL,
	[ReIssuedDate] [datetime] NULL,
	[CompanyIntId] [int] NULL,
 CONSTRAINT [PK_PayrollDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Index [IX_Memento]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento')
CREATE NONCLUSTERED INDEX [IX_Memento] ON [Common].[Memento]
(
	[MementoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Memento_1]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND name = N'IX_Memento_1')
CREATE NONCLUSTERED INDEX [IX_Memento_1] ON [Common].[Memento]
(
	[SourceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ACHTransaction]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransaction')
CREATE NONCLUSTERED INDEX [IX_ACHTransaction] ON [dbo].[ACHTransaction]
(
	[SourceId] ASC,
	[TransactionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_ACHTransactionOriginatorId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionOriginatorId')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionOriginatorId] ON [dbo].[ACHTransaction]
(
	[OriginatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ACHTransactionOriginatorType]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionOriginatorType')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionOriginatorType] ON [dbo].[ACHTransaction]
(
	[OrignatorType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ACHTransactionReceiverId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionReceiverId')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionReceiverId] ON [dbo].[ACHTransaction]
(
	[ReceiverId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ACHTransactionReceiverType]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionReceiverType')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionReceiverType] ON [dbo].[ACHTransaction]
(
	[ReceiverType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ACHTransactionTransactionDate]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionTransactionDate')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionTransactionDate] ON [dbo].[ACHTransaction]
(
	[TransactionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ACHTransactionExtractMasterExtractId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]') AND name = N'IX_ACHTransactionExtractMasterExtractId')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionExtractMasterExtractId] ON [dbo].[ACHTransactionExtract]
(
	[MasterExtractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ACHTransactionExtractTransactionId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]') AND name = N'IX_ACHTransactionExtractTransactionId')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionExtractTransactionId] ON [dbo].[ACHTransactionExtract]
(
	[ACHTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InvoicePayment]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND name = N'IX_InvoicePayment')
CREATE NONCLUSTERED INDEX [IX_InvoicePayment] ON [dbo].[InvoicePayment]
(
	[Method] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_InvoicePayment_1]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND name = N'IX_InvoicePayment_1')
CREATE NONCLUSTERED INDEX [IX_InvoicePayment_1] ON [dbo].[InvoicePayment]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_InvoicePayment_2]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND name = N'IX_InvoicePayment_2')
CREATE NONCLUSTERED INDEX [IX_InvoicePayment_2] ON [dbo].[InvoicePayment]
(
	[PaymentDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_InvoicePaymentInvoiceId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InvoicePayment]') AND name = N'IX_InvoicePaymentInvoiceId')
CREATE NONCLUSTERED INDEX [IX_InvoicePaymentInvoiceId] ON [dbo].[InvoicePayment]
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalCheckNumber]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalCheckNumber')
CREATE NONCLUSTERED INDEX [IX_JournalCheckNumber] ON [dbo].[Journal]
(
	[CheckNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalCompanyId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalCompanyId')
CREATE NONCLUSTERED INDEX [IX_JournalCompanyId] ON [dbo].[Journal]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalCompanyIntId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalCompanyIntId')
CREATE NONCLUSTERED INDEX [IX_JournalCompanyIntId] ON [dbo].[Journal]
(
	[CompanyIntId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalIsDebit]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalIsDebit')
CREATE NONCLUSTERED INDEX [IX_JournalIsDebit] ON [dbo].[Journal]
(
	[IsDebit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalIsVoid]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalIsVoid')
CREATE NONCLUSTERED INDEX [IX_JournalIsVoid] ON [dbo].[Journal]
(
	[IsVoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalMainAccountId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalMainAccountId')
CREATE NONCLUSTERED INDEX [IX_JournalMainAccountId] ON [dbo].[Journal]
(
	[MainAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalPayrollId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalPayrollId')
CREATE NONCLUSTERED INDEX [IX_JournalPayrollId] ON [dbo].[Journal]
(
	[PayrollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalPayrollPayCheckIdId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalPayrollPayCheckIdId')
CREATE NONCLUSTERED INDEX [IX_JournalPayrollPayCheckIdId] ON [dbo].[Journal]
(
	[PayrollPayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalPEOASOCoCheck]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalPEOASOCoCheck')
CREATE NONCLUSTERED INDEX [IX_JournalPEOASOCoCheck] ON [dbo].[Journal]
(
	[PEOASOCoCheck] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalTransactionDate]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalTransactionDate')
CREATE NONCLUSTERED INDEX [IX_JournalTransactionDate] ON [dbo].[Journal]
(
	[TransactionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-20180124-101638]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'NonClusteredIndex-20180124-101638')
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20180124-101638] ON [dbo].[Journal]
(
	[TransactionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckCompensationPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]') AND name = N'IX_PayCheckCompensationPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckCompensationPayCheckId] ON [dbo].[PayCheckCompensation]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckCompensationPayTypeId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]') AND name = N'IX_PayCheckCompensationPayTypeId')
CREATE NONCLUSTERED INDEX [IX_PayCheckCompensationPayTypeId] ON [dbo].[PayCheckCompensation]
(
	[PayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckDeduction]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND name = N'IX_PayCheckDeduction')
CREATE NONCLUSTERED INDEX [IX_PayCheckDeduction] ON [dbo].[PayCheckDeduction]
(
	[CompanyDeductionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckDeductionPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND name = N'IX_PayCheckDeductionPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckDeductionPayCheckId] ON [dbo].[PayCheckDeduction]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_PayCheckExtractExtract]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND name = N'IX_PayCheckExtractExtract')
CREATE NONCLUSTERED INDEX [IX_PayCheckExtractExtract] ON [dbo].[PayCheckExtract]
(
	[Extract] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckExtractPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND name = N'IX_PayCheckExtractPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckExtractPayCheckId] ON [dbo].[PayCheckExtract]
(
	[PayrollPayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckExtractType]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]') AND name = N'IX_PayCheckExtractType')
CREATE NONCLUSTERED INDEX [IX_PayCheckExtractType] ON [dbo].[PayCheckExtract]
(
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckPayCode]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND name = N'IX_PayCheckPayCode')
CREATE NONCLUSTERED INDEX [IX_PayCheckPayCode] ON [dbo].[PayCheckPayCode]
(
	[PayCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckPayCodePayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND name = N'IX_PayCheckPayCodePayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckPayCodePayCheckId] ON [dbo].[PayCheckPayCode]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckPayTypeAccumulationPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]') AND name = N'IX_PayCheckPayTypeAccumulationPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckPayTypeAccumulationPayCheckId] ON [dbo].[PayCheckPayTypeAccumulation]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckPayTypeAccumulationPayTypeId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]') AND name = N'IX_PayCheckPayTypeAccumulationPayTypeId')
CREATE NONCLUSTERED INDEX [IX_PayCheckPayTypeAccumulationPayTypeId] ON [dbo].[PayCheckPayTypeAccumulation]
(
	[PayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckTaxPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckTax]') AND name = N'IX_PayCheckTaxPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckTaxPayCheckId] ON [dbo].[PayCheckTax]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckTaxTaxId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckTax]') AND name = N'IX_PayCheckTaxTaxId')
CREATE NONCLUSTERED INDEX [IX_PayCheckTaxTaxId] ON [dbo].[PayCheckTax]
(
	[TaxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckWCPayCheckId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]') AND name = N'IX_PayCheckWCPayCheckId')
CREATE NONCLUSTERED INDEX [IX_PayCheckWCPayCheckId] ON [dbo].[PayCheckWorkerCompensation]
(
	[PayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckWCWorkerCompensationId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]') AND name = N'IX_PayCheckWCWorkerCompensationId')
CREATE NONCLUSTERED INDEX [IX_PayCheckWCWorkerCompensationId] ON [dbo].[PayCheckWorkerCompensation]
(
	[WorkerCompensationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_Payroll]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_Payroll')
CREATE NONCLUSTERED INDEX [IX_Payroll] ON [dbo].[Payroll]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_Payroll_1]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_Payroll_1')
CREATE NONCLUSTERED INDEX [IX_Payroll_1] ON [dbo].[Payroll]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_Payroll_2]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_Payroll_2')
CREATE NONCLUSTERED INDEX [IX_Payroll_2] ON [dbo].[Payroll]
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollCompanyIntId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollCompanyIntId')
CREATE NONCLUSTERED INDEX [IX_PayrollCompanyIntId] ON [dbo].[Payroll]
(
	[CompanyIntId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollCopied]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollCopied')
CREATE NONCLUSTERED INDEX [IX_PayrollCopied] ON [dbo].[Payroll]
(
	[CopiedFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollHistory]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollHistory')
CREATE NONCLUSTERED INDEX [IX_PayrollHistory] ON [dbo].[Payroll]
(
	[IsHistory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollIsPrinted]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollIsPrinted')
CREATE NONCLUSTERED INDEX [IX_PayrollIsPrinted] ON [dbo].[Payroll]
(
	[IsPrinted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollIsQueued]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollIsQueued')
CREATE NONCLUSTERED INDEX [IX_PayrollIsQueued] ON [dbo].[Payroll]
(
	[IsQueued] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollIsVoid]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollIsVoid')
CREATE NONCLUSTERED INDEX [IX_PayrollIsVoid] ON [dbo].[Payroll]
(
	[IsVoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollMoved]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollMoved')
CREATE NONCLUSTERED INDEX [IX_PayrollMoved] ON [dbo].[Payroll]
(
	[MovedFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayDay]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollPayDay')
CREATE NONCLUSTERED INDEX [IX_PayrollPayDay] ON [dbo].[Payroll]
(
	[PayDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollTaxPayDay]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollTaxPayDay')
CREATE NONCLUSTERED INDEX [IX_PayrollTaxPayDay] ON [dbo].[Payroll]
(
	[TaxPayDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollInvoiceCompanyId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoiceCompanyId')
CREATE NONCLUSTERED INDEX [IX_PayrollInvoiceCompanyId] ON [dbo].[PayrollInvoice]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollInvoiceInvoiceDate]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoiceInvoiceDate')
CREATE NONCLUSTERED INDEX [IX_PayrollInvoiceInvoiceDate] ON [dbo].[PayrollInvoice]
(
	[InvoiceDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollInvoiceInvoiceNumber]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoiceInvoiceNumber')
CREATE NONCLUSTERED INDEX [IX_PayrollInvoiceInvoiceNumber] ON [dbo].[PayrollInvoice]
(
	[InvoiceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollInvoicePayrollId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoicePayrollId')
CREATE NONCLUSTERED INDEX [IX_PayrollInvoicePayrollId] ON [dbo].[PayrollInvoice]
(
	[PayrollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollInvoiceStatus]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoiceStatus')
CREATE NONCLUSTERED INDEX [IX_PayrollInvoiceStatus] ON [dbo].[PayrollInvoice]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollInvoiceTaxesDelayed]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollInvoice]') AND name = N'IX_PayrollInvoiceTaxesDelayed')
CREATE NONCLUSTERED INDEX [IX_PayrollInvoiceTaxesDelayed] ON [dbo].[PayrollInvoice]
(
	[Id] ASC,
	[TaxesDelayed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckCompanyId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckCompanyId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckCompanyId] ON [dbo].[PayrollPayCheck]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckCompanyIntId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckCompanyIntId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckCompanyIntId] ON [dbo].[PayrollPayCheck]
(
	[CompanyIntId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckCreditInvoiceId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckCreditInvoiceId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckCreditInvoiceId] ON [dbo].[PayrollPayCheck]
(
	[CreditInvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckEmployeeId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckEmployeeId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckEmployeeId] ON [dbo].[PayrollPayCheck]
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckInvoiceId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckInvoiceId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckInvoiceId] ON [dbo].[PayrollPayCheck]
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckIsHistory]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckIsHistory')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckIsHistory] ON [dbo].[PayrollPayCheck]
(
	[IsHistory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckPayDay]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPayDay')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckPayDay] ON [dbo].[PayrollPayCheck]
(
	[PayDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckPaymentMethod]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPaymentMethod')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckPaymentMethod] ON [dbo].[PayrollPayCheck]
(
	[PaymentMethod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckPayrollId]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPayrollId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckPayrollId] ON [dbo].[PayrollPayCheck]
(
	[PayrollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckPEOASOCoCheck]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckPEOASOCoCheck')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckPEOASOCoCheck] ON [dbo].[PayrollPayCheck]
(
	[PEOASOCoCheck] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckStatus]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckStatus')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckStatus] ON [dbo].[PayrollPayCheck]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckTaxPayDay]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckTaxPayDay')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckTaxPayDay] ON [dbo].[PayrollPayCheck]
(
	[TaxPayDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayrollPayCheckVoid]    Script Date: 3/10/2018 12:43:12 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckVoid')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckVoid] ON [dbo].[PayrollPayCheck]
(
	[IsVoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[DF_Memento_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Memento] ADD  CONSTRAINT [DF_Memento_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_InvoicePayment_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[InvoicePayment] ADD  CONSTRAINT [DF_InvoicePayment_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Journal_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_IsVoid]  DEFAULT ((0)) FOR [IsVoid]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Journal_TransactionDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_TransactionDate]  DEFAULT (getdate()) FOR [TransactionDate]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Journal_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] ADD  CONSTRAINT [DF_Journal_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Journal__Documen__3B40CD36]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] ADD  DEFAULT (newid()) FOR [DocumentId]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Journal__PEOASOC__40F9A68C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] ADD  DEFAULT ((0)) FOR [PEOASOCoCheck]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Journal__IsReIss__4B0D20AB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Journal] ADD  DEFAULT ((0)) FOR [IsReIssued]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_AccumulatedValue]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] ADD  CONSTRAINT [DF_PayCheckPayTypeAccumulation_AccumulatedValue]  DEFAULT ((0)) FOR [AccumulatedValue]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_Used]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] ADD  CONSTRAINT [DF_PayCheckPayTypeAccumulation_Used]  DEFAULT ((0)) FOR [Used]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_CarryOver]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] ADD  CONSTRAINT [DF_PayCheckPayTypeAccumulation_CarryOver]  DEFAULT ((0)) FOR [CarryOver]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Payroll_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] ADD  CONSTRAINT [DF_Payroll_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__PEOASOC__3F115E1A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] ADD  DEFAULT ((0)) FOR [PEOASOCoCheck]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__TaxPayD__3429BB53]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] ADD  DEFAULT (CONVERT([date],getdate())) FOR [TaxPayDay]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__IsHisto__3EA749C6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] ADD  DEFAULT ((0)) FOR [IsHistory]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__IsPrint__1CA7377D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] ADD  DEFAULT ((0)) FOR [IsPrinted]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__IsVoid__1D9B5BB6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] ADD  DEFAULT ((0)) FOR [IsVoid]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__IsQueue__01BE3717]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] ADD  DEFAULT ((0)) FOR [IsQueued]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Payroll__IsConfi__02B25B50]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Payroll] ADD  DEFAULT ((0)) FOR [IsConfirmFailed]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollInvoice_Id]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF_PayrollInvoice_Id]  DEFAULT (newid()) FOR [Id]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollInvoice_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF_PayrollInvoice_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Proce__4A8310C6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF__PayrollIn__Proce__4A8310C6]  DEFAULT ('') FOR [ProcessedBy]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Balan__4B7734FF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF__PayrollIn__Balan__4B7734FF]  DEFAULT ((0)) FOR [Balance]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Proce__4C6B5938]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF__PayrollIn__Proce__4C6B5938]  DEFAULT (getdate()) FOR [ProcessedOn]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__PayCh__4D5F7D71]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF__PayrollIn__PayCh__4D5F7D71]  DEFAULT ('') FOR [PayChecks]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Voide__4E53A1AA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF__PayrollIn__Voide__4E53A1AA]  DEFAULT ('') FOR [VoidedCreditChecks]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Apply__4F47C5E3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF__PayrollIn__Apply__4F47C5E3]  DEFAULT ((0)) FOR [ApplyWCMinWageLimit]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__NetPa__0A688BB1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF__PayrollIn__NetPa__0A688BB1]  DEFAULT ((0)) FOR [NetPay]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Check__0B5CAFEA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF__PayrollIn__Check__0B5CAFEA]  DEFAULT ((0)) FOR [CheckPay]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__DDPay__0C50D423]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  CONSTRAINT [DF__PayrollIn__DDPay__0C50D423]  DEFAULT ((0)) FOR [DDPay]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollIn__Taxes__17236851]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollInvoice] ADD  DEFAULT ((0)) FOR [TaxesDelayed]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_Salary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  CONSTRAINT [DF_PayrollPayCheck_Salary]  DEFAULT ((0)) FOR [Salary]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_YTDSalary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  CONSTRAINT [DF_PayrollPayCheck_YTDSalary]  DEFAULT ((0)) FOR [YTDSalary]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollDetail_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  CONSTRAINT [DF_PayrollDetail_IsVoid]  DEFAULT ((0)) FOR [IsVoid]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayrollPayCheck_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  CONSTRAINT [DF_PayrollPayCheck_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollPa__PEOAS__40058253]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  DEFAULT ((0)) FOR [PEOASOCoCheck]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollPa__TaxPa__351DDF8C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  DEFAULT (CONVERT([date],getdate())) FOR [TaxPayDay]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollPa__IsHis__3F9B6DFF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  DEFAULT ((0)) FOR [IsHistory]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PayrollPa__IsReI__4A18FC72]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayrollPayCheck] ADD  DEFAULT ((0)) FOR [IsReIssued]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ACHTransactionExtract_ACHTransaction]') AND parent_object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]'))
ALTER TABLE [dbo].[ACHTransactionExtract]  WITH CHECK ADD  CONSTRAINT [FK_ACHTransactionExtract_ACHTransaction] FOREIGN KEY([ACHTransactionId])
REFERENCES [dbo].[ACHTransaction] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ACHTransactionExtract_ACHTransaction]') AND parent_object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]'))
ALTER TABLE [dbo].[ACHTransactionExtract] CHECK CONSTRAINT [FK_ACHTransactionExtract_ACHTransaction]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ACHTransactionExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]'))
ALTER TABLE [dbo].[ACHTransactionExtract]  WITH CHECK ADD  CONSTRAINT [FK_ACHTransactionExtract_MasterExtracts] FOREIGN KEY([MasterExtractId])
REFERENCES [dbo].[MasterExtracts] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ACHTransactionExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]'))
ALTER TABLE [dbo].[ACHTransactionExtract] CHECK CONSTRAINT [FK_ACHTransactionExtract_MasterExtracts]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InvoicePayment_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoicePayment]'))
ALTER TABLE [dbo].[InvoicePayment]  WITH CHECK ADD  CONSTRAINT [FK_InvoicePayment_PayrollInvoice] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[PayrollInvoice] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InvoicePayment_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[InvoicePayment]'))
ALTER TABLE [dbo].[InvoicePayment] CHECK CONSTRAINT [FK_InvoicePayment_PayrollInvoice]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal]  WITH CHECK ADD  CONSTRAINT [FK_Journal_PayrollPayCheck] FOREIGN KEY([PayrollPayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Journal_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[Journal]'))
ALTER TABLE [dbo].[Journal] CHECK CONSTRAINT [FK_Journal_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]'))
ALTER TABLE [dbo].[PayCheckCompensation]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckCompensation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]'))
ALTER TABLE [dbo].[PayCheckCompensation] CHECK CONSTRAINT [FK_PayCheckCompensation_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckDeduction_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]'))
ALTER TABLE [dbo].[PayCheckDeduction]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckDeduction_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckDeduction_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]'))
ALTER TABLE [dbo].[PayCheckDeduction] CHECK CONSTRAINT [FK_PayCheckDeduction_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckExtract_MasterExtracts] FOREIGN KEY([MasterExtractId])
REFERENCES [dbo].[MasterExtracts] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract] CHECK CONSTRAINT [FK_PayCheckExtract_MasterExtracts]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckExtract_PayrollPayCheck] FOREIGN KEY([PayrollPayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckExtract_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckExtract]'))
ALTER TABLE [dbo].[PayCheckExtract] CHECK CONSTRAINT [FK_PayCheckExtract_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayCode_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]'))
ALTER TABLE [dbo].[PayCheckPayCode]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckPayCode_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayCode_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]'))
ALTER TABLE [dbo].[PayCheckPayCode] CHECK CONSTRAINT [FK_PayCheckPayCode_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayTypeAccumulation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]'))
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayTypeAccumulation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]'))
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] CHECK CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckTax_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckTax]'))
ALTER TABLE [dbo].[PayCheckTax]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckTax_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckTax_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckTax]'))
ALTER TABLE [dbo].[PayCheckTax] CHECK CONSTRAINT [FK_PayCheckTax_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckWorkerCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]'))
ALTER TABLE [dbo].[PayCheckWorkerCompensation]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckWorkerCompensation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckWorkerCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]'))
ALTER TABLE [dbo].[PayCheckWorkerCompensation] CHECK CONSTRAINT [FK_PayCheckWorkerCompensation_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollDetail_Payroll]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]'))
ALTER TABLE [dbo].[PayrollPayCheck]  WITH CHECK ADD  CONSTRAINT [FK_PayrollDetail_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayrollDetail_Payroll]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]'))
ALTER TABLE [dbo].[PayrollPayCheck] CHECK CONSTRAINT [FK_PayrollDetail_Payroll]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CommissionExtract_PayrollInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommissionExtract]'))
ALTER TABLE [dbo].[CommissionExtract] DROP CONSTRAINT [FK_CommissionExtract_PayrollInvoice]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CommissionExtract_MasterExtracts]') AND parent_object_id = OBJECT_ID(N'[dbo].[CommissionExtract]'))
ALTER TABLE [dbo].[CommissionExtract] DROP CONSTRAINT [FK_CommissionExtract_MasterExtracts]
GO
/****** Object:  Index [IX_CommissionExtractInvoiceId]    Script Date: 3/10/2018 1:10:13 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CommissionExtract]') AND name = N'IX_CommissionExtractInvoiceId')
DROP INDEX [IX_CommissionExtractInvoiceId] ON [dbo].[CommissionExtract]
GO
/****** Object:  Index [IX_CommissionExtractExtractId]    Script Date: 3/10/2018 1:10:13 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CommissionExtract]') AND name = N'IX_CommissionExtractExtractId')
DROP INDEX [IX_CommissionExtractExtractId] ON [dbo].[CommissionExtract]
GO
/****** Object:  Table [dbo].[CommissionExtract]    Script Date: 3/10/2018 1:10:13 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommissionExtract]') AND type in (N'U'))
DROP TABLE [dbo].[CommissionExtract]
GO
/****** Object:  Table [dbo].[CommissionExtract]    Script Date: 3/10/2018 1:10:13 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_CommissionExtractExtractId]    Script Date: 3/10/2018 1:10:13 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CommissionExtract]') AND name = N'IX_CommissionExtractExtractId')
CREATE NONCLUSTERED INDEX [IX_CommissionExtractExtractId] ON [dbo].[CommissionExtract]
(
	[MasterExtractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_CommissionExtractInvoiceId]    Script Date: 3/10/2018 1:10:13 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CommissionExtract]') AND name = N'IX_CommissionExtractInvoiceId')
CREATE NONCLUSTERED INDEX [IX_CommissionExtractInvoiceId] ON [dbo].[CommissionExtract]
(
	[PayrollInvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
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

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Checkbook__IsReI__62108194]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] DROP CONSTRAINT [DF__Checkbook__IsReI__62108194]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Checkbook__PEOAS__611C5D5B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] DROP CONSTRAINT [DF__Checkbook__PEOAS__611C5D5B]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Checkbook__Docum__60283922]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] DROP CONSTRAINT [DF__Checkbook__Docum__60283922]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_CheckbookJournal_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] DROP CONSTRAINT [DF_CheckbookJournal_LastModified]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_CheckbookJournal_TransactionDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] DROP CONSTRAINT [DF_CheckbookJournal_TransactionDate]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_CheckbookJournal_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] DROP CONSTRAINT [DF_CheckbookJournal_IsVoid]
END

GO
/****** Object:  Index [NonClusteredIndex-CheckbookJournal-TransactionType]    Script Date: 3/10/2018 2:39:15 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'NonClusteredIndex-CheckbookJournal-TransactionType')
DROP INDEX [NonClusteredIndex-CheckbookJournal-TransactionType] ON [dbo].[CheckbookJournal]
GO
/****** Object:  Index [IX_CheckbookJournalTransactionDate]    Script Date: 3/10/2018 2:39:15 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalTransactionDate')
DROP INDEX [IX_CheckbookJournalTransactionDate] ON [dbo].[CheckbookJournal]
GO
/****** Object:  Index [IX_CheckbookJournalPEOASOCoCheck]    Script Date: 3/10/2018 2:39:15 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalPEOASOCoCheck')
DROP INDEX [IX_CheckbookJournalPEOASOCoCheck] ON [dbo].[CheckbookJournal]
GO
/****** Object:  Index [IX_CheckbookJournalMainAccountId]    Script Date: 3/10/2018 2:39:15 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalMainAccountId')
DROP INDEX [IX_CheckbookJournalMainAccountId] ON [dbo].[CheckbookJournal]
GO
/****** Object:  Index [IX_CheckbookJournalIsVoid]    Script Date: 3/10/2018 2:39:15 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalIsVoid')
DROP INDEX [IX_CheckbookJournalIsVoid] ON [dbo].[CheckbookJournal]
GO
/****** Object:  Index [IX_CheckbookJournalIsDebit]    Script Date: 3/10/2018 2:39:15 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalIsDebit')
DROP INDEX [IX_CheckbookJournalIsDebit] ON [dbo].[CheckbookJournal]
GO
/****** Object:  Index [IX_CheckbookJournalCompanyIntId]    Script Date: 3/10/2018 2:39:15 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalCompanyIntId')
DROP INDEX [IX_CheckbookJournalCompanyIntId] ON [dbo].[CheckbookJournal]
GO
/****** Object:  Index [IX_CheckbookJournalCompanyId]    Script Date: 3/10/2018 2:39:15 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalCompanyId')
DROP INDEX [IX_CheckbookJournalCompanyId] ON [dbo].[CheckbookJournal]
GO
/****** Object:  Index [IX_CheckbookJournalCheckNumber]    Script Date: 3/10/2018 2:39:15 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalCheckNumber')
DROP INDEX [IX_CheckbookJournalCheckNumber] ON [dbo].[CheckbookJournal]
GO
/****** Object:  Table [dbo].[CheckbookJournal]    Script Date: 3/10/2018 2:39:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND type in (N'U'))
DROP TABLE [dbo].[CheckbookJournal]
GO
/****** Object:  Table [dbo].[CheckbookJournal]    Script Date: 3/10/2018 2:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CheckbookJournal](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[PaymentMethod] [int] NOT NULL,
	[CheckNumber] [int] NOT NULL,
	[PayrollPayCheckId] [int] NULL,
	[EntityType] [int] NOT NULL,
	[PayeeId] [uniqueidentifier] NOT NULL,
	[PayeeName] [varchar](max) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Memo] [varchar](max) NULL,
	[IsDebit] [bit] NOT NULL,
	[IsVoid] [bit] NOT NULL,
	[MainAccountId] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[JournalDetails] [varchar](max) NOT NULL,
	[DocumentId] [uniqueidentifier] NOT NULL,
	[PEOASOCoCheck] [bit] NOT NULL,
	[OriginalDate] [datetime] NULL,
	[IsReIssued] [bit] NOT NULL,
	[OriginalCheckNumber] [int] NULL,
	[ReIssuedDate] [datetime] NULL,
	[PayrollId] [uniqueidentifier] NULL,
	[CompanyIntId] [int] NULL,
 CONSTRAINT [PK_ChecbookJournal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Index [IX_CheckbookJournalCheckNumber]    Script Date: 3/10/2018 2:39:15 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalCheckNumber')
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalCheckNumber] ON [dbo].[CheckbookJournal]
(
	[CheckNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_CheckbookJournalCompanyId]    Script Date: 3/10/2018 2:39:15 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalCompanyId')
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalCompanyId] ON [dbo].[CheckbookJournal]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_CheckbookJournalCompanyIntId]    Script Date: 3/10/2018 2:39:15 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalCompanyIntId')
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalCompanyIntId] ON [dbo].[CheckbookJournal]
(
	[CompanyIntId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CheckbookJournalIsDebit]    Script Date: 3/10/2018 2:39:15 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalIsDebit')
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalIsDebit] ON [dbo].[CheckbookJournal]
(
	[IsDebit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_CheckbookJournalIsVoid]    Script Date: 3/10/2018 2:39:15 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalIsVoid')
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalIsVoid] ON [dbo].[CheckbookJournal]
(
	[IsVoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_CheckbookJournalMainAccountId]    Script Date: 3/10/2018 2:39:15 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalMainAccountId')
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalMainAccountId] ON [dbo].[CheckbookJournal]
(
	[MainAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_CheckbookJournalPEOASOCoCheck]    Script Date: 3/10/2018 2:39:15 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalPEOASOCoCheck')
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalPEOASOCoCheck] ON [dbo].[CheckbookJournal]
(
	[PEOASOCoCheck] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_CheckbookJournalTransactionDate]    Script Date: 3/10/2018 2:39:15 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalTransactionDate')
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalTransactionDate] ON [dbo].[CheckbookJournal]
(
	[TransactionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-CheckbookJournal-TransactionType]    Script Date: 3/10/2018 2:39:15 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'NonClusteredIndex-CheckbookJournal-TransactionType')
CREATE NONCLUSTERED INDEX [NonClusteredIndex-CheckbookJournal-TransactionType] ON [dbo].[CheckbookJournal]
(
	[TransactionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 70) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_CheckbookJournal_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] ADD  CONSTRAINT [DF_CheckbookJournal_IsVoid]  DEFAULT ((0)) FOR [IsVoid]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_CheckbookJournal_TransactionDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] ADD  CONSTRAINT [DF_CheckbookJournal_TransactionDate]  DEFAULT (getdate()) FOR [TransactionDate]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_CheckbookJournal_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] ADD  CONSTRAINT [DF_CheckbookJournal_LastModified]  DEFAULT (getdate()) FOR [LastModified]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Checkbook__Docum__60283922]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] ADD  DEFAULT (newid()) FOR [DocumentId]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Checkbook__PEOAS__611C5D5B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] ADD  DEFAULT ((0)) FOR [PEOASOCoCheck]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Checkbook__IsReI__62108194]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CheckbookJournal] ADD  DEFAULT ((0)) FOR [IsReIssued]
END

GO

DBCC SHRINKDATABASE(N'PaxolArchive' )
GO
