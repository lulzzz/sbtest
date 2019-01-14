/****** Object:  StoredProcedure [dbo].[GetUserDashboard]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetUserDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetTaxEligibilityAccumulation]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTaxEligibilityAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetTaxEligibilityAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetSearchResults]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSearchResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetSearchResults]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithDraftInvoice]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithDraftInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithDraftInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollProcessingPerformanceChart]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollProcessingPerformanceChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollProcessingPerformanceChart]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoicesXml]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoiceList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoiceList]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetPaychecks]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaychecks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPaychecks]
GO
/****** Object:  StoredProcedure [dbo].[GetMinWageEligibleCompanies]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinWageEligibleCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMinWageEligibleCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetMinifiedPayrolls]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinifiedPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMinifiedPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournals]
GO
/****** Object:  StoredProcedure [dbo].[GetJournalPayees]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalPayees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournalPayees]
GO
/****** Object:  StoredProcedure [dbo].[GetJournalIds]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournalIds]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusPastDueChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusPastDueChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceStatusPastDueChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusDetailedChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusDetailedChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceStatusDetailedChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceStatusChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoicePayments]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoicePayments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoicePayments]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetHostAndCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetExtracts]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtracts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtracts]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractDataSpecial]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractDataSpecial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractDataSpecial]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractAccumulation]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesYTD]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployees]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeePaychecks]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeePaychecks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeePaychecks]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyTaxAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyTaxAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyRecurringCharges]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyRecurringCharges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyRecurringCharges]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPreviousInvoiceNumbers]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPreviousInvoiceNumbers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyPreviousInvoiceNumbers]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPayrollSchedules]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPayrollSchedules]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyPayrollSchedules]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPaychecksForInvoiceCredit]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPaychecksForInvoiceCredit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyPaychecksForInvoiceCredit]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyInvoices]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyInvoices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyInvoices]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyAccumulation]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionsReport]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionsReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCommissionsReport]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionPerformanceChart]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionPerformanceChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCommissionPerformanceChart]
GO
/****** Object:  StoredProcedure [dbo].[GetACHData]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetACHData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetACHData]
GO
/****** Object:  StoredProcedure [dbo].[GetAccessMetaData]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAccessMetaData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetAccessMetaData]
GO
/****** Object:  StoredProcedure [dbo].[EnsureCheckNumberIntegrity]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnsureCheckNumberIntegrity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[EnsureCheckNumberIntegrity]
GO
/****** Object:  StoredProcedure [dbo].[CopyEmployees]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CopyEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CopyEmployees]
GO
/****** Object:  StoredProcedure [dbo].[CopyCompany]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CopyCompany]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CopyCompany]
GO
/****** Object:  UserDefinedFunction [dbo].[GetJournalBalance]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetJournalBalance]
GO
/****** Object:  UserDefinedFunction [dbo].[GetExtractDepositAmount]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractDepositAmount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetExtractDepositAmount]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCheckNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[CanDeletePayroll]    Script Date: 14/01/2019 4:07:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CanDeletePayroll]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[CanDeletePayroll]
GO
/****** Object:  UserDefinedFunction [dbo].[CanDeletePayroll]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CanDeletePayroll]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[CanDeletePayroll] 
(
	@PayrollId uniqueidentifier
)
RETURNS bit
AS
BEGIN
	declare @PayrollId1 uniqueidentifier = @PayrollId
	declare @exist int = 0
	select @exist=count(Id) from Payroll p
	where
	Id=@PayrollId1 and InvoiceId is null and IsVoid=1
	--and not exists(select ''x'' from PayrollPayCheck pc where pc.PayrollId=p.Id and pc.IsVoid=0)
	and not exists(select ''x'' from PayrollPayCheck pc, PayCheckExtract pce where pc.Id=pce.PayrollPayCheckId and pc.PayrollId=p.Id)
	and not exists(select ''x'' from PayrollPayCheck pc, ACHTransaction act where pc.Id=act.SourceId and act.TransactionType=1 and pc.PayrollId=p.Id)
	
	
	group by Id
	
	if @exist>0
		set @exist=1
	return @exist
END' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[GetCheckNumber] 
(
	@CompanyId int,
	@PayrollPayCheckId int,
	@PEOASOCoCheck bit,
	@TransactionType int,
	@CheckNumber int,
	@IsPEOPayroll bit
)
RETURNS int
AS
BEGIN
	declare @CompanyId1 int = @CompanyId,
	@PayrollPayCheckId1 int = @PayrollPayCheckId,
	@PEOASOCoCheck1 bit = @PEOASOCoCheck,
	@TransactionType1 int = @TransactionType,
	@CheckNumber1 int = @CheckNumber,
	@IsPEOPayroll1 bit = @IsPEOPayroll

	declare @result int = @CheckNumber1
	select @result = case
		when @TransactionType1=1 then
			case when @PEOASOCoCheck1=1 and exists(select ''x'' from dbo.CompanyJournal where PEOASOCoCheck=1 and CheckNumber=@CheckNumber1 and PayrollPayCheckId<>@PayrollPayCheckId1) then
					(select isnull(max(CheckNumber),0)+1 from dbo.CompanyJournal where PEOASOCoCheck=1)
				when @PEOASOCoCheck1=0 and @IsPEOPayroll1=0 and exists(select ''x'' from dbo.CompanyPayCheckNumber where CompanyIntId=@CompanyId1 and CheckNumber=@CheckNumber1 and Id<>@PayrollPayCheckId1 ) 
				then
						(select isnull(max(CheckNumber),0)+1 from dbo.CompanyPayCheckNumber where CompanyIntId=@CompanyId1)
				else 
					@result
				end
		when @TransactionType1=2 or @TransactionType1=6 then
			case when exists(select ''x'' from dbo.CompanyJournalCheckbook where CompanyIntId=@CompanyId1 and TransactionType in (2,6) and CheckNumber=@CheckNumber1) then
				(select isnull(max(CheckNumber),0)+1 from dbo.CompanyJournalCheckbook where CompanyIntId=@CompanyId1 and TransactionType in (2,6))
				else
					@result
				end
		end


	return @result;

END' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[GetExtractDepositAmount]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractDepositAmount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[GetExtractDepositAmount] 
(
	@extractName varchar(max),
	@companyId uniqueidentifier,
	@startdate smalldatetime, 
	@enddate smalldatetime
)
RETURNS decimal(18,2)
AS
BEGIN
	declare @extractName1 varchar(max) = @extractName,
	@companyId1 uniqueidentifier = @companyId,
	@startdate1 smalldatetime = @startdate, 
	@enddate1 smalldatetime = @enddate

	declare @balance decimal(18,2) = 0
	select @balance = sum(j.amount) 
	from CheckbookJournal j, MasterExtractJournal mej, MasterExtracts m
	where j.Id=mej.journalId
	and mej.masterextractid=m.id
	and j.TransactionType=5
	and j.IsVoid=0
	and j.CompanyId=@companyId1
	and m.StartDate between @startdate1 and @enddate1
	and m.EndDate between @startdate1 and @enddate1
	and ((@extractName1<>''StateCADE9'' and m.ExtractName=@extractName1) or (@extractName1=''StateCADE9'' and m.ExtractName in (''StateCAPIT'', ''StateCAUI'')))
	
	return @balance
END' 
END

GO
/****** Object:  UserDefinedFunction [dbo].[GetJournalBalance]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[GetJournalBalance] 
(
	@accountId int
)
RETURNS decimal(18,2)
AS
BEGIN
	declare @accountId1 int  =@accountId
	declare @balance decimal(18,2) = 0
	declare @credits decimal(18,2) = 0
	declare @debits decimal(18,2) = 0
	declare @credits1 decimal(18,2) = 0
	declare @debits1 decimal(18,2) = 0

	select @credits = isnull(Credit,0) from AccountCreditBalance where MainAccountId=@accountId1;
	select @credits1 = isnull(Credit,0) from CheckbookAccountCreditBalance where MainAccountId=@accountId1;
	select @debits = isnull(sum(Debit),0) from AccountDebitBalance where MainAccountId=@accountId1;
	select @debits1 = isnull(sum(Debit),0) from CheckbookAccountDebitBalance where MainAccountId=@accountId1;
	set @balance = @credits + @credits1 - @debits - @debits1;
	return @balance
END' 
END

GO
/****** Object:  StoredProcedure [dbo].[CopyCompany]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CopyCompany]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CopyCompany] AS' 
END
GO
/****** Object:  Stored Procedure dbo.usp_AddCompany    Script Date: 3/21/2006 4:24:45 PM ******/
------------------------------------------------------------------------------------------------------------------------
-- Date Created: Friday, October 01, 2004
-- Created By:   Generated by CodeSmith
------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CopyCompany]
	@oldHost uniqueidentifier,
	@newHost uniqueidentifier,
	@oldCompanyId uniqueidentifier,
	@CompanyID uniqueidentifier ,
	@LastModifiedBy varchar(max),
	@copyEmployees bit,
	@copyPayrolls bit,
	@payrollStart DateTime = null,
	@payrollEnd DateTime = null
AS

declare @oldHost1 uniqueidentifier = @oldHost,
	@newHost1 uniqueidentifier = @newHost,
	@oldCompanyId1 uniqueidentifier = @oldCompanyId,
	@CompanyID1 uniqueidentifier = @CompanyID,
	@LastModifiedBy1 varchar(max) = @LastModifiedBy,
	@copyEmployees1 bit = @copyEmployees,
	@copyPayrolls1 bit = @copyPayrolls,
	@payrollStart1 DateTime = @payrollStart,
	@payrollEnd1 DateTime = @payrollEnd

--company
select * into #tempcomp from Company where Id=@oldCompanyId1;
update #tempcomp set HostId = @newHost1, Id=@CompanyID1, LastModifiedBy=@LastModifiedBy1, LastModified=GetDate();
declare @isPEOHost bit
select @isPEOHost = IsPeoHost from Host where Id=@newHost1
if @isPEOHost=1
	update #tempcomp set FileUnderHost=1, ManageEFileForms=1, ManageTaxPayment=1;

insert into Company([Id], [CompanyName],[CompanyNo],[HostId],[StatusId],[IsVisibleToHost],[FileUnderHost],[DirectDebitPayer],[PayrollDaysInPast],[InsuranceGroupNo],[TaxFilingName],[CompanyAddress],[BusinessAddress],[IsAddressSame],[ManageTaxPayment],[ManageEFileForms],[FederalEIN],[FederalPin],[DepositSchedule941],[PayrollSchedule],[PayCheckStock],[IsFiler944],[LastModifiedBy],[LastModified],[MinWage],[IsHostCompany],[Memo],[ClientNo],[Created],[ParentId],[Notes])
select [Id], [CompanyName],[CompanyNo],[HostId],[StatusId],[IsVisibleToHost],[FileUnderHost],[DirectDebitPayer],[PayrollDaysInPast],[InsuranceGroupNo],[TaxFilingName],[CompanyAddress],[BusinessAddress],[IsAddressSame],[ManageTaxPayment],[ManageEFileForms],[FederalEIN],[FederalPin],[DepositSchedule941],[PayrollSchedule],[PayCheckStock],[IsFiler944],[LastModifiedBy],[LastModified],[MinWage],[IsHostCompany],[Memo],[ClientNo],[Created],[ParentId],[Notes] from #tempcomp;

--contract
insert into CompanyContract(CompanyId, Type, PrePaidSubscriptionType, BillingType, CardDetails, BankDetails, InvoiceRate, Method, InvoiceSetup)
select @CompanyId1, Type, PrePaidSubscriptionType, BillingType, CardDetails, BankDetails, InvoiceRate, Method, InvoiceSetup from CompanyContract where CompanyId=@oldCompanyId1;

--entity relations
select * into #tmper  from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=@oldCompanyId1;
update #tmper set sourceentityid=@CompanyID1;
insert into EntityRelation(SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject) select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject from #tmper;

--deductions
insert into CompanyDeduction(CompanyId, TypeId, Name, Description, AnnualMax)
select @CompanyID1, TypeId, Name, Description, AnnualMax from CompanyDeduction where CompanyId=@oldCompanyId1;

select a.Id as olddedid, b.Id as newdedid into #dedTable from
(select * from CompanyDeduction where companyid=@oldcompanyid1)a,
(select * from CompanyDeduction where companyid=@companyid1)b 
where a.TypeId = b.TypeId and a.Name=b.Name;

--pay codes
insert into CompanyPayCode(CompanyId, Code, Description, HourlyRate)
select @CompanyID1, Code, Description, HourlyRate from CompanyPayCode where CompanyId=@oldCompanyId1;

--Accumulated Pay type
insert into CompanyAccumlatedPayType(PayTypeId, CompanyId, RatePerHour, AnnualLimit)
select PayTypeId, @CompanyID1, RatePerHour, AnnualLimit from CompanyAccumlatedPayType where CompanyId=@oldCompanyId1;

--Company State
insert into CompanyTaxState(CompanyId, CountryId, StateId, StateCode, StateName, EIN, Pin)
select @CompanyID1, CountryId, StateId, StateCode, StateName, EIN, Pin from CompanyTaxState where CompanyId=@oldCompanyId1;

--Company Tax rate
insert into CompanyTaxRate(CompanyId, TaxId, TaxYear, Rate)
select @CompanyID1, TaxId, TaxYear, Rate from CompanyTaxRate where CompanyId=@oldCompanyId1;

-- worker compensation
insert into CompanyWorkerCompensation(CompanyId, Code, Description, Rate, MinGrossWage)
select @CompanyId1, Code, Description, Rate, MinGrossWage from CompanyWorkerCompensation where CompanyId=@oldCompanyId1;

select a.Id as oldwcid, b.Id as newwcid into #wcTable from
(select * from CompanyWorkerCompensation where companyid=@oldcompanyid1)a,
(select * from CompanyWorkerCompensation where companyid=@companyid1)b 
where a.Code = b.Code;

-- vednor customers
insert into VendorCustomer(Id, CompanyId, Name, StatusId, AccountNo, IsVendor, IsVendor1099, Contact, Note, Type1099, SubType1099, IdentifierType, IndividualSSN, BusinessFIN, LastModified, LastModifiedBy)
select newid(),@CompanyId1, Name, StatusId, AccountNo, IsVendor, IsVendor1099, Contact, Note, Type1099, SubType1099, IdentifierType, IndividualSSN, BusinessFIN, GETDATE(), LastModifiedBy from VendorCustomer where CompanyId=@oldCompanyId1;

----vendor customer id old and new
select a.Id as oldvcid, b.Id as newvcid into #vcTable from
(select * from vendorcustomer where companyid=@oldcompanyid1)a,
(select * from vendorcustomer where companyid=@companyid1)b 
where a.Name=b.Name and a.individualssn=b.individualssn and a.BusinessFIN=b.BusinessFIN;

-----bank accounts
insert into BankAccount(EntityTypeId, EntityId, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy)
select EntityTypeId, @CompanyID1, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, GETDATE(), @LastModifiedBy1 from BankAccount where EntityTypeId=2 and EntityId=@oldCompanyId1;

select a.Id as oldbankid, b.Id as newbankid into #bankTable from
(select * from BankAccount where EntityTypeId=2 and EntityId=@oldcompanyid1)a,
(select * from BankAccount where EntityTypeId=2 and EntityId=@companyid1)b 
where a.AccountNumber=b.AccountNumber and a.RoutingNumber=b.RoutingNumber and a.AccountName=b.AccountName and a.AccountType=b.AccountType;

insert into CompanyAccount(CompanyId, Type, SubType, Name, TaxCode, TemplateId, OpeningBalance, OpeningDate, BankAccountId, LastModified, LastModifiedBy, UsedInPayroll)
select @CompanyId1, Type, SubType, Name, TaxCode, TemplateId, OpeningBalance, OpeningDate, 
case when BankAccountId is not null then
	(select top(1) newbankid from #bankTable where oldbankid=BankAccountId)
	else
		null
	end
BankAccountId, getdate(), @LastModifiedBy1, UsedInPayroll 
from CompanyAccount Left outer join BankAccount on CompanyAccount.BankAccountId = BankAccount.Id
Where CompanyId = @oldCompanyId1
GO
/****** Object:  StoredProcedure [dbo].[CopyEmployees]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CopyEmployees]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CopyEmployees] AS' 
END
GO
/****** Object:  Stored Procedure dbo.usp_AddCompany    Script Date: 3/21/2006 4:24:45 PM ******/
------------------------------------------------------------------------------------------------------------------------
-- Date Created: Friday, October 01, 2004
-- Created By:   Generated by CodeSmith
------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[CopyEmployees]
	@oldCompanyId uniqueidentifier,
	@CompanyID uniqueidentifier ,
	@employeeIds varchar(max) = null,
	@LastModifiedBy varchar(max),
	@KeepEmployeeNumbers bit =1
AS
declare @oldCompanyId1 uniqueidentifier = @oldCompanyId,
	@CompanyID1 uniqueidentifier = @CompanyID,
	@employeeIds1 varchar(max) = @employeeIds,
	@LastModifiedBy1 varchar(max) = @LastModifiedBy,
	@KeepEmployeeNumbers1 bit = @KeepEmployeeNumbers

declare @tmpEmployees table (
		id uniqueidentifier not null
	)
	insert into @tmpEmployees
	select convert(uniqueidentifier, id) id
	from
	(SELECT 
		 cast(rtrim(ltrim(Split.a.value('.', 'varchar(max)'))) as nvarchar(36)) AS id  
	FROM  
	(
		SELECT CAST ('<M>' + REPLACE(@employeeIds1, ',', '</M><M>') + '</M>' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)
	) b
	where b.id<>''


if not exists(select 'x' from Employee Where CompanyId=@oldCompanyId1
	and ((@employeeIds1 is null) or (@employeeIds1 is not null and exists(select 'x' from @tmpEmployees where id=Employee.Id)))
	and not exists(select 'x' from Employee e1 where e1.CompanyId=@CompanyID1 and e1.SSN=Employee.SSN)
	)
	begin
		RAISERROR('All Employees already exist in the target company',16,1);
		return;
	end

insert into CompanyDeduction(CompanyId, TypeId, Name, Description, AnnualMax)
select @CompanyID1, TypeId, Name, Description, AnnualMax from CompanyDeduction 
where CompanyId=@oldCompanyId1
and not exists(select 'x' from CompanyDeduction cd where cd.CompanyId=@CompanyID1 and cd.TypeId=TypeId and cd.Name=Name);

select a.Id as olddedid, b.Id as newdedid into #dedTable from
(select * from CompanyDeduction where companyid=@oldcompanyid1)a,
(select * from CompanyDeduction where companyid=@companyid1)b 
where a.TypeId = b.TypeId and a.Name=b.Name;

if exists(select 'x' from CompanyDeduction where companyid=@oldcompanyid1 and Id not in (select olddedid from #dedTable))
	begin
		RAISERROR ('Deduction(s) must match between source and target company by Type and Name', -- Message text.
					   16, -- Severity.
					   1 -- State.
					   );
		return;
	end
	

insert into CompanyWorkerCompensation(CompanyId, Code, Description, Rate, MinGrossWage)
select @CompanyId1, Code, Description, Rate, MinGrossWage from CompanyWorkerCompensation 
where CompanyId=@oldCompanyId1
and not exists(select 'x' from CompanyWorkerCompensation cw where cw.CompanyId=@CompanyID1 and cw.Code=Code);

select a.Id as oldwcid, b.Id as newwcid into #wcTable from
(select * from CompanyWorkerCompensation where companyid=@oldcompanyid1)a,
(select * from CompanyWorkerCompensation where companyid=@companyid1)b 
where a.Code = b.Code;

if exists(select 'x' from CompanyWorkerCompensation where companyid=@oldcompanyid1 and id not in(select oldwcid from #wcTable))
	begin
		RAISERROR ('Workers Compensation(s) must match between source and target company by Code', -- Message text.
					   16, -- Severity.
					   1 -- State.
					   );
		return;
	end

	insert into Employee(CompanyId, StatusId, FirstName, MiddleInitial, LastName, Contact, Gender, SSN, BirthDate, 
	HireDate, Department, EmployeeNo, Memo, PayrollSchedule, PayType, Rate, PayCodes, Compensations, PaymentMethod, 
	DirectDebitAuthorized, TaxCategory, FederalStatus, FederalExemptions, FederalAdditionalAmount, State, 
	LastModified, LastModifiedBy, WorkerCompensationId, CompanyEmployeeNo, Notes, SickLeaveHireDate, CarryOver)
	select @CompanyId1, StatusId, FirstName, MiddleInitial, LastName, Contact, Gender, SSN, BirthDate, HireDate, Department, EmployeeNo, Memo, 
	PayrollSchedule, PayType, Rate, PayCodes, Compensations, PaymentMethod, DirectDebitAuthorized, TaxCategory, FederalStatus, FederalExemptions, FederalAdditionalAmount, 
	State, GETDATE(), @LastModifiedBy1,
	case when WorkerCompensationId is not null then
		(select top(1) newwcid from #wcTable where oldwcid=WorkerCompensationId)
		else
			null
		end, 
	case when @KeepEmployeeNumbers1=1 then
		CompanyEmployeeNo
		else
		(isnull((select max(em.CompanyEmployeeNo) from Employee em where em.CompanyId=@CompanyID1),0)+ROW_NUMBER() OVER(ORDER BY FirstName ASC)) 
		end
		, Notes, SickLeaveHireDate, CarryOver
	from Employee Where CompanyId=@oldCompanyId1
	and ((@employeeIds1 is null) or (@employeeIds1 is not null and exists(select 'x' from @tmpEmployees where id=Employee.Id)))
	and not exists(select 'x' from Employee e1 where e1.CompanyId=@CompanyID1 and e1.SSN=Employee.SSN)


	select a.Id as oldempid, b.Id as newempid into #empTable from
	(select * from Employee where companyid=@oldcompanyid1)a,
	(select * from Employee where companyid=@CompanyID1)b 
	where a.SSN=b.SSN
	and (@employeeIds1 is null or (@employeeIds1 is not null and a.Id in (select id from @tmpEmployees)));

	insert into EmployeeDeduction(EmployeeId, Method, Rate, AnnualMax, CompanyDeductionId)
	select (select newempid from #empTable where oldempid=ed.EmployeeId), Method, Rate, AnnualMax, 
		(select newdedid from #dedTable where olddedid=ed.CompanyDeductionId)
	from EmployeeDeduction ed where ed.employeeid in (select oldempid from #empTable)
	and not exists(select 'x' from EmployeeDeduction ed2 where ed2.EmployeeId=(select newempid from #empTable where oldempid=ed.EmployeeId) and ed2.CompanyDeductionId=(select newdedid from #dedTable where olddedid=ed.CompanyDeductionId));

	insert into BankAccount(EntityTypeId, EntityId, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy, FractionId)
	select EntityTypeId, (select newempid from #empTable where oldempid=EntityId), 
	AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy, FractionId
	from BankAccount
	Where EntityTypeId=3
	and EntityId in (select oldempid from #empTable)
	and not exists(select 'x' from BankAccount ba2 where ba2.EntityTypeId=3 and ba2.EntityId=(select newempid from #empTable where oldempid=BankAccount.EntityId) and ba2.AccountType=AccountType 
	and ba2.BankName=BankName and ba2.AccountNumber=AccountNumber and ba2.RoutingNumber=RoutingNumber);

	insert into EmployeeBankAccount(EmployeeId, BankAccountId, Percentage)
	select (select newempid from #empTable where oldempid=EmployeeId), 
	(select Id from BankAccount ba where ba.EntityTypeId=3 and ba.EntityId=(select newempid from #empTable where oldempid=EmployeeId) and ba.AccountType=BankAccount.AccountType and ba.BankName=BankAccount.BankName and ba.AccountNumber=BankAccount.AccountNumber and ba.RoutingNumber=BankAccount.RoutingNumber),
	Percentage
	from EmployeeBankAccount, BankAccount
	where 
	EmployeeBankAccount.BankAccountId = BankAccount.Id
	and EmployeeId in (select oldempid from #empTable)
	and not exists(select 'x' from EmployeeBankAccount eba2 where eba2.EmployeeId=(select newempid from #empTable where oldempid=EmployeeBankAccount.EmployeeId)
		and eba2.BankAccountId=(select Id from BankAccount ba2 where ba2.EntityTypeId=3 and ba2.EntityId=(select newempid from #empTable where oldempid=EmployeeBankAccount.EmployeeId) 
				and ba2.AccountType=BankAccount.AccountType 
				and ba2.BankName=BankAccount.BankName and ba2.AccountNumber=BankAccount.AccountNumber and ba2.RoutingNumber=BankAccount.RoutingNumber)
	);

	--entity relations
	select * into #tmperee  from EntityRelation where SourceEntityTypeId=3 and SourceEntityId in (select oldempid from #empTable);
	update #tmperee set sourceentityid=(select newempid from #empTable where oldempid=SourceEntityId);
	insert into EntityRelation(SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject) select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject from #tmperee;
GO
/****** Object:  StoredProcedure [dbo].[EnsureCheckNumberIntegrity]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnsureCheckNumberIntegrity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EnsureCheckNumberIntegrity] AS' 
END
GO
ALTER PROCEDURE [dbo].[EnsureCheckNumberIntegrity]
	@PayrollId uniqueidentifier,
	@PEOASOCoCheck bit
AS
BEGIN
	declare @PayrollId1 uniqueidentifier = @PayrollId,
	@PEOASOCoCheck1 bit = @PEOASOCoCheck

	update pc set pc.CheckNumber=j.CheckNumber
	from PayrollPayCheck pc, Journal j
	where pc.Id=j.PayrollPayCheckId
	and pc.PayrollId=@payrollId1
	and ((pc.PEOASOCoCheck=1 and j.PEOASOCoCheck=1) or (pc.PEOASOCoCheck=0 and j.PEOASOCoCheck=0))
	and pc.CheckNumber<>j.CheckNumber;

END
GO
/****** Object:  StoredProcedure [dbo].[GetAccessMetaData]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAccessMetaData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetAccessMetaData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetAccessMetaData]
	
AS
BEGIN
	select 
	Feature.Name FeatureName, Access.*
	
	from 
	PaxolFeature Feature, PaxolFeatureClaim Access
	where Feature.Id=Access.FeatureId
	order by Access.AccessLevel desc, Feature.Id, Access.Id
	for xml path('Access'), root('AccessList'), elements, type
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetACHData]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetACHData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetACHData] AS' 
END
GO

ALTER PROCEDURE [dbo].[GetACHData]
	@startdate datetime = null,
	@enddate datetime = null
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate

	select * into #tmpACH from
	(select 
		PayrollId as SourceParentId, PayrollPayCheck.Id as SourceId, 1 as TransactionType, NetWage as Amount, PayDay as TransactionDate, 1 as OrignatorType, Host.Id as OriginatorId, 
		3 as ReceiverType, Employee.Id as ReceiverId, Employee.FirstName + ' ' + Employee.LastName as Name, 'PAYROLL' as TransactionDescription, Company.CompanyName as CompanyName
		from PayrollPayCheck, Employee, Company, Host
	where 
		PayrollPayCheck.EmployeeId=Employee.Id 
		and Employee.CompanyId=Company.Id 
		and Company.HostId=Host.Id
		and PayrollPayCheck.PaymentMethod=2
		and PayrollPayCheck.IsVoid=0
		and ((@startdate1 is not null and PayrollPayCheck.PayDay>=@startdate1) or (@startdate1 is null))
		and ((@enddate1 is not null and PayrollPayCheck.PayDay<=@enddate1) or (@enddate1 is null))
	Union
	select 
		InvoiceId as SourceParentId, InvoicePayment.Id as SourceId, 2 as TransactionType, Amount, PaymentDate as TransactionDate, 2 as OrignatorType, Company.Id as OriginatorId, 
		1 as ReceiverType, Host.Id as ReceiverId, Company.CompanyName as Name, 'INVOICE' as TransactionDescription, Company.CompanyName as CompanyName
	from 
		InvoicePayment, PayrollInvoice, Company, Host
	where 
		InvoicePayment.InvoiceId=PayrollInvoice.Id 
		and PayrollInvoice.CompanyId=Company.Id 
		and Company.HostId=Host.Id
		and InvoicePayment.Method=5 and InvoicePayment.[Status]=2
		and ((@startdate1 is not null and PaymentDate>=@startdate1) or (@startdate1 is null))
		and ((@enddate1 is not null and PaymentDate<=@enddate1) or (@enddate1 is null)))a

	

	MERGE ACHTransaction AS target
		USING (
				SELECT * from #tmpACH
							
			) AS source (SourceParentId, SourceId, TransactionType, Amount, TransactionDate, OrignatorType, OriginatorId, ReceiverType, ReceiverId, Name, TransactionDescription, CompanyName)
		ON (target.SourceParentId = source.SourceParentId AND target.SourceId = source.SourceId and target.TransactionType = source.TransactionType)
		WHEN MATCHED AND Not Exists(select 'x' from ACHTransactionExtract where ACHTransactionId=target.Id) THEN 
			UPDATE SET Amount = source.Amount, TransactionDate = source.TransactionDate, CompanyName = source.CompanyName
		WHEN NOT MATCHED By Source AND Not Exists(select 'x' from ACHTransactionExtract where ACHTransactionId=target.Id) THEN
			Delete
		WHEN			 
			NOT MATCHED BY TARGET THEN
			INSERT (SourceParentId, SourceId, TransactionType, Amount, TransactionDate, OrignatorType, OriginatorId, ReceiverType, ReceiverId, Name, TransactionDescription, CompanyName)
			VALUES (source.SourceParentId, source.SourceId, source.TransactionType, source.Amount, source.TransactionDate, source.OrignatorType, source.OriginatorId,source.ReceiverType, source.ReceiverId, source.Name, source.TransactionDescription, source.CompanyName)
		
		;
	

	
	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=Company.Id
		for xml path ('HostCompany'), elements, type
	),
	(
		select HostBank.Id,  case when Accounttype=1 then 'Checking' else 'Savings' end AccountType, BankName, AccountName, AccountNumber, RoutingNumber 				
		from BankAccount HostBank, CompanyAccount 
		where CompanyId=Company.Id
		and HostBank.Id=BankAccountId
		and UsedInPayroll=1
		for xml path ('HostBank'), elements, type
	),
	(
		select 
		Id, SourceParentId, SourceId, case when Transactiontype=1 then 'PPD' else 'CCD' end TransactionType, Amount, TransactionDate, TransactionDescription, CompanyName,
		(select EntityTypeName from EntityType where EntityTypeId=OrignatorType) OriginatorType, 
		OriginatorId, 
		(select EntityTypeName from EntityType where EntityTypeId=ReceiverType) ReceiverType, 
		ReceiverId
		, Name,
		(
			select 
			*,
			(
				select Id, case when Accounttype=1 then 'Checking' else 'Savings' end AccountType, BankName, AccountName, AccountNumber, RoutingNumber 				
				from BankAccount where Id=EmployeeBankAccount.BankAccountId
				for xml path ('BankAccount'), elements, type
			)
			from EmployeeBankAccount
			Where 
			((TransactionType=1 and EmployeeId=ReceiverId) or (EmployeeId is null))
			for xml path ('EmployeeBankAccount'), elements, type
		) EmployeeBankAccounts,
		(
			select BankAccount.Id,  case when Accounttype=1 then 'Checking' else 'Savings' end AccountType, BankName, AccountName, AccountNumber, RoutingNumber 				
			from BankAccount, CompanyAccount 
			where 
			((TransactionType=2 and CompanyId=OriginatorId) or (CompanyId is null))
			and BankAccount.Id=BankAccountId
			and UsedInPayroll=1
			for xml path ('CompanyBankAccount'), elements, type
		)
		From ACHTransaction			
		Where 
		((OrignatorType=1 and OriginatorId=Host.Id) or (ReceiverType=1 and ReceiverId=Host.Id))
		and ((@startdate1 is not null and TransactionDate>=@startdate1) or (@startdate1 is null))
		and ((@enddate1 is not null and TransactionDate<=@enddate1) or (@enddate1 is null))
		and not exists(select 'x' from ACHTransactionExtract act where act.ACHTransactionId=ACHTransaction.Id)
		for xml path ('ACHTransaction'), Elements, type

	)ACHTransactions
	 from
	Company, Host
	where Company.Id=Host.CompanyId
	and Company.HostId = Host.Id
	and Company.IsHostCompany=1
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts
	for xml path('ACHResponseDB'), ELEMENTS, type
	
	

END

GO
/****** Object:  StoredProcedure [dbo].[GetCommissionPerformanceChart]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionPerformanceChart]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCommissionPerformanceChart] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCommissionPerformanceChart]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 0
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@onlyActive1 bit = @onlyActive

	declare @users varchar(max)
	declare @query varchar(max)	

	select (u.FirstName + ' ' + u.LastName) [User], LEFT(datename(month,InvoiceDate),3) + ' ' + Right(cast(year(InvoiceDate) as varchar),2) Month, Commission
	into #tmpInspectionData
	from PayrollInvoice i, AspNetUsers u, Company c
	where 
		i.SalesRep=u.Id
		and i.CompanyId = c.Id
		and ((@onlyActive1=1 and c.StatusId=1) or (@onlyActive1=0))
		and i.Balance<=0
		and ((@startdate1 is not null and i.InvoiceDate>=@startdate1) or (@startdate1 is null))
		and ((@enddate1 is not null and i.InvoiceDate<=@enddate1) or (@enddate1 is null))
		
	SELECT @users = COALESCE(@users + ',[' + cast([User] as varchar) + ']','[' + cast([User] as varchar)+ ']')
	FROM (select distinct [User] from #tmpInspectionData)a
	

	set @query = 'select Month, ' +@users+ ' from (select Data.Month,'+@users+' from
	(select Month, [User], Commission
	from #tmpInspectionData
	) o
	PIVOT (sum(Commission) for [User] in ('+@users+'))Data)t order by convert(datetime, ''01 ''+Month, 6)'
	
	select 'GetCommissionPerformanceChart' Report;			
	execute(@query)
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionsReport]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionsReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCommissionsReport] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCommissionsReport]
	@startdate datetime = null,
	@enddate datetime = null,
	@userId uniqueidentifier = null,
	@includeinactive bit
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@userId1 uniqueidentifier = @userId,
	@includeinactive1 bit = @includeinactive

	select 
	(select
		u.Id as UserId, u.FirstName + ' ' + u.LastName as Name,
		(
			select 
				i.Id as InvoiceId, i.Commission,  i.InvoiceDate, c.CompanyName, i.InvoiceNumber
			from PayrollInvoice i, Company c
			where i.CompanyId = c.Id
			and ((@includeinactive1=1) or (@includeinactive1=0 and c.StatusId=1))
			--and c.StatusId=1
			and u.Active=1
			and i.SalesRep = u.Id
			and ((@userId1 is not null and i.SalesRep = @userId1) or (@userId1 is null))
			and ((@startdate1 is not null and i.InvoiceDate>=@startdate1) or (@startdate1 is null))
			and ((@enddate1 is not null and i.InvoiceDate<=@enddate1) or (@enddate1 is null))
			and not exists(select 'x' from CommissionExtract where PayrollInvoiceId=i.id)
			and i.Balance=0
			for xml path('InvoiceCommission'), ELEMENTS, type
		) Commissions
	from AspNetUsers u
	where 
	u.Active=1
	and ((@userId1 is not null and u.Id = @userId1) or (@userId1 is null))
	for xml path('ExtractSalesRep'), ELEMENTS, type) SalesReps
	for xml path('CommissionsResponse'), ELEMENTS, type
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 14/01/2019 4:07:30 PM ******/
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
	declare @host1 uniqueidentifier = @host,
	@role1 varchar(max) = @role,
	@status1 varchar(max) = @status,
	@id1 uniqueidentifier=@id

		declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Id=''' + cast(@Id1 as varchar(max))+''''
	if @status1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'statusId=' + cast(@status1 as varchar(max))
	if @host1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'HostId=''' + cast(@host1 as varchar(max)) + ''''
	
	if @role1 is not null and @role1='HostStaff'
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsHostCompany=0'
	if @role1 is not null and @role1='CorpStaff'
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
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompaniesNextPayrollChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@onlyActive1 bit = @onlyActive
	
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select 'GetCompaniesNextPayrollChartData' Report;
	select HostId, CompanyId, Host, Company, InvoiceSetup,
			DateDiff(day, getdate(), [Next Payroll]) Due
	
	from	
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup,
		Case
			When c.LastPayrollDate is not null Then
				Case
					When c.PayrollSchedule=1 then
						DateAdd(day, 7, c.LastPayrollDate)
				
					When c.PayrollSchedule=2 then
						DateAdd(day, 14, c.LastPayrollDate)
				
					When c.PayrollSchedule=3 then
						DateAdd(day, 15, c.LastPayrollDate)
				
					When c.PayrollSchedule=4 then
						DateAdd(MONTH, 1, c.LastPayrollDate)
				End
			Else
				Cast('01/01/' + cast(year(getdate()) as varchar(max)) as datetime)
					
			
		end [Next Payroll]
		
	from Company c, Host h , CompanyContract cc
	Where 
	c.StatusId=1
	and h.id = c.HostId
	and c.Id=cc.CompanyId
		and ((@role1 is not null and @role1='HostStaff' and c.IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and c.IsHostCompany=0)
			or (@role1 is null))
	and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
	) a
	where DateDiff(day, getdate(), [Next Payroll])<6
	
	order by Due


END
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompaniesWithoutPayroll] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@onlyActive1 bit = @onlyActive

	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 'GetCompaniesWithoutPayroll' Report;
	select HostId, CompanyId, Host, Company, InvoiceSetup,
		DateDiff(day, CreationDate, getdate() ) [Days past]
	from 
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup,
		Case
			When exists(select 'x' from Common.Memento  where SourceTypeId=2 and MementoId=c.Id) Then
				(select max(DateCreated) from Common.Memento  where SourceTypeId=2 and MementoId=c.Id)
			Else
				c.LastModified
					
			
		end CreationDate
		
	from Company c, Host h , CompanyContract cc
	Where 
	c.StatusId=1
	and h.id = c.HostId
	and c.Id = cc.CompanyId
		and ((@role1 is not null and @role1='HostStaff' and c.IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and c.IsHostCompany=0)
			or (@role1 is null))
	and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
	and not exists(select 'x' from Payroll where CompanyId=c.Id)
	)a
	where 
	DateDiff(day, CreationDate, getdate() )>0
	
END

GO
/****** Object:  StoredProcedure [dbo].[GetCompanyAccumulation]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyAccumulation]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeDailyAccumulation bit = 0,
	@includeMonthlyAccumulation bit = 0,
	@includePayCodes bit = 0,
	@report varchar(max) = null
AS
BEGIN

	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

insert into #tmp(Id, CompanyId)
	select Id, CompanyId
	from PayrollPayCheck pc1
	where pc1.IsVoid=0  and pc1.PayDay between @startdate and @enddate
	and pc1.CompanyId=@company
	and ( @report is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=1)
			and InvoiceId is not null
			and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId and TaxesDelayed=1)
			and @report<>'Report1099'
		)	
	);

	declare @year as varchar(max)=cast(year(@startdate) as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@year
	declare @quarter3ed smalldatetime='9/30/'+@year
	declare @quarter4sd smalldatetime='10/1/'+@year
	declare @quarter4ed smalldatetime='12/31/'+@year

	declare @month int = month(@enddate)
	
	
	select 
		Company.Id CompanyId, Company.CompanyName, Company.FederalEIN FEIN, Company.FederalPin FPIN,
		(
			select CompanyTaxState.* from CompanyTaxState where CompanyId=Company.Id
			for xml path('ExtractTaxState'), Elements, type
		) States,
		(
			select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
				sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
				sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
				sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
				sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
				sum(Immigrants) as Immigrants, sum(Twelve1) Twelve1, sum(Twelve2) Twelve2, sum(Twelve3) Twelve3
			from (
					select 
					pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
					case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
					case when month(pc.payday)=@month-2 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve1,
					case when month(pc.payday)=@month-1 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve2,
					case when month(pc.payday)=@month and 12 between day(pc.StartDate) and day(pc.EndDate)and pc.GrossWage>0 then 1 else 0 end Twelve3,
					sum(case when pc.payday between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.Amount else 0 end) Quarter1FUTA,
					sum(case when pc.payday between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter2FUTA,
					sum(case when pc.payday between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter3FUTA,
					sum(case when pc.payday between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter4FUTA,
					sum(case when pc.payday between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter1FUTAWage,
					sum(case when pc.payday between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter2FUTAWage,
					sum(case when pc.payday between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter3FUTAWage,
					sum(case when pc.payday between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter4FUTAWage
					from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
					where pc.Id=pct.PayCheckId
					and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
					and pc.Id in (select Id from #tmp)
					group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.PayDay
				)a
			
			for xml path('PayCheckWages'), elements, type
		),
		case when @includeDailyAccumulation=1 then
		(
			select 
			month(pc.PayDay) Month, day(pc.PayDay) Day,
			sum(case when t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
			where pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
			and pc.Id in (select Id from #tmp)
			group by pc.PayDay
			for xml path('DailyAccumulation'), elements, type
		) end DailyAccumulations,
		case when @includeMonthlyAccumulation=1 then
		(
			select 
			month(pc.PayDay) Month,
			sum(case when t.Id<6 then pct.Amount else 0 end) IRS941,
			sum(case when t.Id=6 then pct.Amount else 0 end) IRS940,
			sum(case when t.Id between 7 and 10 then pct.Amount else 0 end) EDD
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t
			where pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id
			and pc.Id in (select Id from #tmp)
			group by month(pc.PayDay)
			for xml path('MonthlyAccumulation'), elements, type
		) end MonthlyAccumulations,
		case when @includeTaxes=1 then
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) end Taxes,
		case when @includeDeductions=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(
				select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
				from CompanyDeduction Where Id=pt.CompanyDeductionId 
				for xml path('CompanyDeduction'), elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensations=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodes=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensations=1 then
		(select pt.WorkerCompensationId,			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations

		From Company
		Where
		((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and Id=@company) or (@company is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyInvoices]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyInvoices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyInvoices] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyInvoices]
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = '',
	@startdate datetime = null,
	@enddate datetime = null,
	@id uniqueidentifier=null
AS
BEGIN
	declare @company1 uniqueidentifier = @company,
	@role1 varchar(max) = @role,
	@status1 varchar(max) = @status,
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@id1 uniqueidentifier=@id

	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollInvoiceJson.Id=''' + cast(@Id1 as varchar(max)) + ''''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate>=''' + cast(@startdate1 as varchar(max)) + ''''
		
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate<=''' + cast(@enddate1 as varchar(max)) + ''''
		
	
	if @status1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.status in (' + @status1 + ')'
	declare @query nvarchar(max) ='
	select 
		PayrollInvoiceJson.*,
		case when exists(select  ''x'' from CommissionExtract where PayrollInvoiceId=PayrollInvoiceJson.Id) then 1 else 0 end CommissionClaimed,
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
		(select * from InvoicePayment where InvoiceId=PayrollInvoiceJson.Id for Xml path(''InvoicePaymentJson''), Elements, type) InvoicePayments
		
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson
	Where 
	PayrollInvoiceJson.PayrollId=PayrollJson.Id and ' + @where + 'Order by PayrollInvoicejson.InvoiceNumber
	for Xml path(''PayrollInvoiceJson''), root(''PayrollInvoiceJsonList''), elements, type'

	print @query
	Execute(@query)
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPaychecksForInvoiceCredit]    Script Date: 14/01/2019 4:07:30 PM ******/
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
	declare @company1 uniqueidentifier = @company
		select 
			PayrollPayCheck.Id, PayrollPayCheck.CheckNumber, PayrollPayCheck.GrossWage, PayrollPayCheck.EmployeeTaxes, PayrollPayCheck.EmployerTaxes, PayrollPayCheck.VoidedOn, PayrollInvoice.Id InvoiceId, PayrollPayCheck.Deductions, PayrollInvoice.InvoiceSetup, PayrollInvoice.Balance, PayrollInvoice.MiscCharges, PayrollPayCheck.PaymentMethod, PayrollInvoice.InvoiceNumber
		from PayrollPayCheck, PayrollInvoice
		where 
			PayrollPayCheck.InvoiceId=PayrollInvoice.Id
			and PayrollPayCheck.IsVoid=1 and InvoiceId is not null and CreditInvoiceId is null and PayrollInvoice.Balance<=0
			and ((@company1 is not null and PayrollPayCheck.CompanyId=@company1) or (@company1 is null)) 
			
		Order by PayrollPayCheck.Id 
		for Xml path('VoidedPayCheckInvoiceCreditJson'), root('VoidedPayCheckInvoiceCreditList'), Elements, type
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPayrollSchedules]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPayrollSchedules]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyPayrollSchedules] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyPayrollSchedules]
	@role varchar(max) = null,
	@criteria varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @role1 varchar(max) = @role,
	@criteria1 varchar(max) = @criteria,
	@onlyActive1 bit = @onlyActive

	declare @tmpSchedules table (
		schedule int not null
	)
	insert into @tmpSchedules
	SELECT 
		 Split.a.value('.', 'VARCHAR(100)') AS schedule  
	FROM  
	(
		SELECT CAST ('<M>' + REPLACE(@criteria1, ',', '</M><M>') + '</M>' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)

	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 'GetCompanyPayrollSchedules' Report;
	select 
	HostId, c.Id CompanyId, h.FirmName Host, c.CompanyName Company, c.PayrollScheduleDay, c.DashboardNotes,
	case 
		when exists(select 'x' TargetObject from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=c.Id and TargetEntityTypeId=4) then
			(select top(1) TargetObject from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=c.Id and TargetEntityTypeId=4) 
		else
			case when c.ParentId is not null and exists(select 'x' TargetObject from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=c.ParentId and TargetEntityTypeId=4) then
				(select top(1) TargetObject from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=c.ParentId and TargetEntityTypeId=4) 
			end
		end Contact
	from
	Company c, Host h 
	where
	c.HostId = h.Id
	and c.StatusId=1
	and ((@criteria1 is null) or (@criteria1 is not null and exists(select 'x' from @tmpSchedules where schedule=c.PayrollScheduleDay)))
	and ((@role1 is not null and @role1='HostStaff' and IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and (HostId<>@rootHost or (HostId=@rootHost and IsHostCompany=0))) 
			or (@role1 is null))
	order by c.CompanyName
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPreviousInvoiceNumbers]    Script Date: 14/01/2019 4:07:30 PM ******/
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
	declare @company1 uniqueidentifier = @company
		select InvoiceNumber , -1 Status
		from PayrollInvoice pi1 
		where CompanyId=@company1 and exists(select 'x' from InvoicePayment where InvoiceId=pi1.Id and status=4) 
		union
		select InvoiceNumber , Status
		from PayrollInvoice pi1 
		where CompanyId=@company1 and Status=3
		for xml path('InvoiceByStatus'), root('InvoiceStatusList'), elements, type
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyRecurringCharges]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	declare @company1 uniqueidentifier = @company
		select * from CompanyRecurringCharge Where CompanyId=@company1
		
		for xml path('CompanyRecurringCharge'), root('CompanyRecurringChargeList'), elements, type
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyTaxAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyTaxAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyTaxAccumulation]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeDailyAccumulation bit = 0,
	@includeMonthlyAccumulation bit = 0,
	@includePayCodes bit = 0,
	@includeHistory bit = 0,
	@includeC1095 bit = 0,
	@includeClients bit = 0,
	@includeTaxDelayed bit = 0,
	@report varchar(max) = 'PayrollSummary',
	@extractDepositName varchar(max) =''
AS
BEGIN
declare @hostL uniqueidentifier = @host,
	@companyL uniqueidentifier = @company,
	@startdateL smalldatetime = @startdate,
	@enddateL smalldatetime = @enddate,
	@includeVoidsL bit = @includeVoids,
	@includeTaxesL bit = @includeTaxes,
	@includeDeductionsL bit = @includeDeductions,
	@includeCompensationsL bit = @includeCompensations,
	@includeWorkerCompensationsL bit = @includeWorkerCompensations,
	@includeDailyAccumulationL bit = @includeDailyAccumulation,
	@includeMonthlyAccumulationL bit = @includeMonthlyAccumulation,
	@includePayCodesL bit = @includePayCodes,
	@includeHistoryL bit = @includeHistory,
	@includeC1095L bit = @includeC1095,
	@includeClientsL bit = @includeClients,
	@includeTaxDelayedL bit = @includeTaxDelayed,
	@reportL varchar(max) = @report,
	@extractDepositNameL varchar(max) =@extractDepositName
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

select * into #tmpCompany
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and Host.Id=@companyL
		and host.StatusId<>3
		and ((@includeC1095L=1 and host.IsFiler1095=1) or (@includeC1095L=0))
		and ((@includeClientsL=0 and c.Id=@company) or (@includeClientsL=1))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=1 
		and StatusId<>3
		and Id=@companyL
		and ((@includeC1095L=1 and IsFiler1095=1) or (@includeC1095L=0))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and StatusId<>3
		and Id=@companyL
		and ((@includeC1095L=1 and IsFiler1095=1) or (@includeC1095L=0))
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and Company.StatusId<>3
		and Parent.Id=@companyL
		and ((@includeC1095L=1 and Parent.IsFiler1095=1) or (@includeC1095L=0))
		and ((@includeClientsL=0 and Company.Id=@companyL) or (@includeClientsL=1))
	)a

insert into #tmp(Id, CompanyId)
	select pc1.Id, pc1.CompanyId
	from PayrollPayCheck pc1
	where 
	pc1.IsVoid=0  and pc1.TaxPayDay between @startdateL and @enddateL
	and pc1.IsHistory<=@includeHistoryL
	and ( pc1.CompanyId in (select CompanyId from #tmpCompany ))
	and ( @reportL is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=1)
			and ((@includeTaxDelayedL=1) or (@includeTaxDelayedL=0 and (not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1))))
			and @reportL<>'Report1099'
		)	
	);

	declare @year as varchar(max)=cast(year(@startdateL) as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@year
	declare @quarter3ed smalldatetime='9/30/'+@year
	declare @quarter4sd smalldatetime='10/1/'+@year
	declare @quarter4ed smalldatetime='12/31/'+@year

	declare @month int = month(@enddateL)
	
	
	select 
		Company.Id CompanyId, Company.CompanyName, Company.FederalEIN FEIN, Company.FederalPin FPIN,
		(
			select CompanyTaxState.* from CompanyTaxState where CompanyId=Company.Id
			for xml path('ExtractTaxState'), Elements, type
		) States,
		(
			select ctr.Id, ctr.CompanyId, ctr.TaxId, t.Code as TaxCode, ctr.TaxYear, ctr.Rate
			from CompanyTaxRate ctr, Tax t
			where ctr.TaxId=t.Id and ctr.TaxYear=year(@startdateL)
			and ctr.CompanyId=Company.Id
			for xml path('CompanyTaxRate'), Elements, type
		) CompanyTaxRates,
		(
			select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
				sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
				sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
				sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
				sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
				sum(Immigrants) as Immigrants, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and month(pc2.TaxPayDay)=@month-2 and  12 between day(pc2.StartDate) and day(pc2.EndDate) and pc2.GrossWage>0) Twelve1, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and month(pc2.TaxPayDay)=@month-1 and  12 between day(pc2.StartDate) and day(pc2.EndDate) and pc2.GrossWage>0) Twelve2, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and month(pc2.TaxPayDay)=@month and  12 between day(pc2.StartDate) and day(pc2.EndDate) and pc2.GrossWage>0) Twelve3, 
				count(distinct SSN) EmployeeCount,
				case when @extractDepositNameL='' then 0 else dbo.GetExtractDepositAmount(@extractDepositNameL, @companyL, @startdateL, @enddateL) end DepositAmount,
				(select rate from TaxYearRate where taxyear=year(@startdateL) and TaxId=6) FUTARate
			from (
					select 
					pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod, e.SSN,
					case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
					
					sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.Amount else 0 end) Quarter1FUTA,
					sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter2FUTA,
					sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter3FUTA,
					sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter4FUTA,
					sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter1FUTAWage,
					sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter2FUTAWage,
					sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter3FUTAWage,
					sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter4FUTAWage
					from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
					where pc.Id=pct.PayCheckId
					and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
					and pc.Id in (select Id from #tmp)
					group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.ssn, e.TaxCategory, pc.TaxPayDay, pc.StartDate, pc.EndDate
				)a
			
			for xml path('PayCheckWages'), elements, type
		),
		case when @includeDailyAccumulationL=1 then
		(
			select 
			month(pc.TaxPayDay) Month, day(pc.TaxPayDay) Day,
			sum(case when t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
			where pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
			and pc.Id in (select Id from #tmp)
			group by pc.TaxPayDay
			for xml path('DailyAccumulation'), elements, type
		) end DailyAccumulations,
		case when @includeMonthlyAccumulationL=1 then
		(
			select 
			month(pc.TaxPayDay) Month,
			sum(case when t.Id<6 then pct.Amount else 0 end) IRS941,
			sum(case when t.Id=6 then pct.Amount else 0 end) IRS940,
			sum(case when t.Id between 7 and 10 then pct.Amount else 0 end) EDD
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t
			where pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id
			and pc.Id in (select Id from #tmp)
			group by month(pc.TaxPayDay)
			for xml path('MonthlyAccumulation'), elements, type
		) end MonthlyAccumulations,
		case when @includeTaxesL=1 then
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) end Taxes,
		case when @includeDeductionsL=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(
				select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
				from CompanyDeduction Where Id=pt.CompanyDeductionId 
				for xml path('CompanyDeduction'), elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensationsL=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodesL=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensationsL=1 then
		(select pt.WorkerCompensationId,			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations

		From Company
		Where
		((@hostL is not null and Company.HostId=@hostL) or (@hostL is null))
		and ((@companyL is not null and Id=@companyL) or (@companyL is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeePaychecks]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeePaychecks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEmployeePaychecks] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetEmployeePaychecks]
	@employee uniqueidentifier
AS
BEGIN
	declare @employee1 uniqueidentifier = @employee
	declare @ssn varchar(24), @ispeo bit, @hostId uniqueidentifier,@company uniqueidentifier
	select @ssn=ssn, @ispeo=FileUnderHost, @hostId=HostId, @company=company.Id from employee, company where employee.Id=@employee1 and employee.companyid=company.id;
	

select id into #tmpcomp from company
where 
((@ispeo=1 and HostId=@hostid and FileUnderHost=1)
or
(@ispeo=0 and id=@company)
)

		select 
			PayrollPayCheck.*
		from PayrollPayCheck , Employee 
		where 
			PayrollPayCheck.EmployeeId=Employee.Id
			and PayrollPayCheck.CompanyId in (select Id from #tmpcomp)
			and Employee.SSN = @ssn
		Order by PayrollPayCheck.Id 
		for Xml path('PayrollPayCheckJson'), root('PayCheckList'), Elements, type
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEmployees] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetEmployees]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
declare @host1 uniqueidentifier = @host,
	@company1 uniqueidentifier = @company,
	@role1 varchar(max) = @role,
	@status1 varchar(max) = @status,
	@id1 uniqueidentifier=@id

declare @ispeo as bit
declare @hostid as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId from company where id=@company1
print @ispeo
print @hostid
select id into #tmpcomps from company
where 
((@ispeo=1 and HostId=@hostid and FileUnderHost=1)
or
(@ispeo=0 and id=@company1)
)

	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'EmployeeJson.Id=''' + cast(@Id1 as varchar(max))+''''
	if @status1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'EmployeeJson.statusId=' + cast(@status1 as varchar(max))
	if @host1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Company.HostId=''' + cast(@host1 as varchar(max)) + ''''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'EmployeeJson.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	
	declare @query nvarchar(max) ='
	
	select 
		EmployeeJson.*, 
		Company.HostId HostId, 
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt, Employee e
			where pc.EmployeeId=e.Id and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id
			and e.SSN=EmployeeJson.SSN
			and pc.CompanyId in (select id from #tmpcomps)
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path(''PayCheckPayTypeAccumulation'') , elements, type
		) Accumulations,
		(select *, (select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path(''DeductionType''), elements, type) from CompanyDeduction where Id=EmployeeDeduction.CompanyDeductionId for Xml path(''CompanyDeduction''), elements, type) from EmployeeDeduction Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeDeductions,
		(select *, (select * from BankAccount where Id=EmployeeBankAccount.BankAccountId for Xml path(''BankAccount''), elements, type) from EmployeeBankAccount Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeBankAccounts,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path(''CompanyWorkerCompensation''), elements, type)
		
		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId = Company.Id and ' + @where + ' for Xml path(''EmployeeJson''), root(''EmployeeList'') , elements, type'
		
		Execute(@query)
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEmployeesAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetEmployeesAccumulation]
	@company uniqueidentifier = null,
	@employee uniqueidentifier = null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeAccumulation bit = 0,
	@includePayCodes bit = 0,
	@includeHistory bit = 0,
	@includeC1095 bit = 0,
	@includeClients bit = 0,
	@includeTaxDelayed bit = 0,
	@report varchar(max) = 'PayrollSummary'
AS
BEGIN

declare @company1 uniqueidentifier = @company,
	@employee1 uniqueidentifier = @employee,
	@startdate1 smalldatetime = @startdate,
	@enddate1 smalldatetime=@enddate,
	@includeVoids1 bit = @includeVoids,
	@includeTaxes1 bit = @includeTaxes,
	@includeDeductions1 bit = @includeDeductions,
	@includeCompensations1 bit = @includeCompensations,
	@includeWorkerCompensations1 bit = @includeWorkerCompensations,
	@includeAccumulation1 bit = @includeAccumulation,
	@includePayCodes1 bit = @includePayCodes,
	@includeHistory1 bit = @includeHistory,
	@includeC10951 bit = @includeC1095,
	@includeClients1 bit = @includeClients,
	@includeTaxDelayed1 bit = @includeTaxDelayed,
	@report1 varchar(max) = @report

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpemployee')
)
DROP TABLE #tmpemployee;
create table #tmpemployee(Id uniqueidentifier not null Primary Key);
CREATE NONCLUSTERED INDEX [IX_tmpEmployeeId] ON #tmpemployee
(
	Id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null primary key, EmployeeId uniqueidentifier not null, SSN varchar(24) not null, CompanyId uniqueidentifier not null, PayDay datetime not null );
CREATE NOnCLUSTERED INDEX [IX_tmpPaycheckEmployeeId] ON #tmp
(
	
	EmployeeId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckSSN] ON #tmp
(
	SSN ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	CompanyId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckPayDay] ON #tmp
(
	PayDay Asc
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


declare @ispeo as bit
declare @ishostcompany as bit
declare @islocation as bit
declare @parent as uniqueidentifier
declare @hostid as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId, @ishostcompany=IsHostCompany, @islocation=(case when ParentId is null then 0 else 1 end), @parent=ParentId from company where id=@company1
print @ispeo
print @hostid
select id into #tmpComps from company
where 

(
	(@ispeo=1 and HostId=@hostid and FileUnderHost=1 
		and ((@includeClients1=0 and Id=@company1) or (@includeClients1=1))
	)
or
	(company.StatusId<>3 and @ispeo=0 and id=@company1)
or
	(company.StatusId<>3 and @ispeo=0 and id<>@company1 and @includeClients1=1 and ParentId=@company1)
or
	(company.StatusId<>3 and @ispeo=0 and @islocation=1 and @includeClients1=1 and (id=@parent or ParentId=@parent))
)

;WITH essn AS
(
   SELECT *,
         ROW_NUMBER() OVER (PARTITION BY SSN ORDER BY HireDate) AS rn
   FROM employee 
   where 
   ((@report1 in ('PayrollSummary','W2Employee','W2Employer','SSAW2MagneticReport','SSAW2MagneticEmployerReport') and Companyid =@company1  ) or (@report1 not in ('PayrollSummary','W2Employee','W2Employer','SSAW2MagneticReport','SSAW2MagneticEmployerReport') and CompanyId in (select Id from #tmpComps)))
   and (@employee1 is null or (@employee1 is not null and Id=@employee1))
)
insert into #tmpemployee(Id)
SELECT Id 
FROM essn
WHERE rn = 1;

Print CAST(GETDATE() as Datetime2(7)) 

insert into #tmp(Id, EmployeeId, SSN, CompanyId, PayDay)
	select pc1.Id, EmployeeId, SSN, pc1.CompanyId, pc1.PayDay
	from PayrollPayCheck pc1, Employee e
	where pc1.IsVoid=0  and pc1.TaxPayDay between @startdate1 and @enddate1
	and pc1.EmployeeId=e.Id
	and ((@includeHistory1=0 and pc1.IsHistory=@includeHistory1) or @includeHistory1=1)
	and ((@company1 is not null and pc1.CompanyId in (select id from #tmpComps)) or (@company1 is null))
	and (@report1 is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report1 and [Type]=1)
			--and InvoiceId is not null
			and ((@includeTaxDelayed1=1) or (@includeTaxDelayed1=0 and (not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1))))
			and @report1<>'Report1099'
		)
	)

	 
	select 
		
		EmployeeJson.Id EmployeeId, EmployeeJson.SSN, EmployeeJson.Department, EmployeeJson.HireDate, EmployeeJson.BirthDate, EmployeeJson.PayType EmpPayType,
		EmployeeJson.Contact ContactStr, 
		EmployeeJson.FirstName, EmployeeJson.MiddleInitial, EmployeeJson.LastName,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path('CompanyWorkerCompensation'), elements, type),
		(select top(1) CompanyId from #tmp where id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI) order by Id desc) LastCheckCompany,
		case when @includeC10951=0 then
		(
			select 
			sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage,
			sum(case pc.PaymentMethod when 1 then NetWage else 0 end) CheckPay,
			sum(case pc.PaymentMethod when 1 then 0 else NetWage end) DDPay
			from PayrollPayCheck pc
			where 
			pc.Id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			for xml path('PayCheckWages'), elements, type
		)
		end,
		case when @includeTaxes1=1 then
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) end Taxes,
		case when @includeDeductions1=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(
				select *, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
				from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensations1=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodes1=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensations1=1 then
		(select pt.WorkerCompensationId,
			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations,
		case when @includeC10951=1 then
		(
			select 
			GrossWage, Salary, PayCodes PayCodesFlat, TaxPayDay PayDay,
			(	select pt.CompanyDeductionId,			
				pt.Amount, pt.Wage,
				(
					select *, 
						(select Id, Name, 
						case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
						from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
					from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
				) 
				from PayCheckDeduction pt, CompanyDeduction cd, DeductionType dt
				where pt.PayCheckId=pc.Id
				and pt.CompanyDeductionId=cd.Id and cd.TypeId=dt.Id
				and dt.id=10
				for xml path('PayCheckDeduction'), elements, type
			) Deductions
			from PayrollPayCheck pc
			where 
			pc.Id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			for xml path('PayCheckSummary1095'), elements, type
		) end PayCheck1095Summaries

		From Employee EmployeeJson
		Where
		EmployeeJson.Id in (select Id from #tmpemployee)
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEmployeesYTD] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetEmployeesYTD]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@id uniqueidentifier=null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeAccumulation bit = 0,
	@includePayCodes bit = 0,
	@report varchar(max) = null,
	@ssns varchar(max) = null
AS
BEGIN

declare @host1 uniqueidentifier = @host,
	@company1 uniqueidentifier = @company,
	@id1 uniqueidentifier=@id,
	@startdate1 smalldatetime = @startdate,
	@enddate1 smalldatetime = @enddate,
	@includeVoids1 bit = @includeVoids,
	@includeTaxes1 bit = @includeTaxes,
	@includeDeductions1 bit = @includeDeductions,
	@includeCompensations1 bit = @includeCompensations,
	@includeWorkerCompensations1 bit = @includeWorkerCompensations,
	@includeAccumulation1 bit = @includeAccumulation,
	@includePayCodes1 bit = @includePayCodes,
	@report1 varchar(max) = @report,
	@ssns1 varchar(max) = @ssns
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null Primary Key, EmployeeId uniqueidentifier not null, SSN varchar(24) not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	EmployeeId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckSSN] ON #tmp
(
	SSN ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

declare @ispeo as bit
declare @hostid as uniqueidentifier
declare @parent as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId, @parent=ParentId from company where id=@company1
print @ispeo
print @hostid
select id into #tmpcomps from company
where 
((@ispeo=1 and HostId=@hostid and FileUnderHost=1)
or
(@ispeo=0 and (id=@company1 or ParentId=@company1))
or
(@ispeo=0 and @parent is not null and (id=@parent or ParentId=@parent))
)


declare @tmpSSNs table (
		ssn varchar(24) not null
	)
	if @ssns1 is not null
		insert into @tmpSSNs
		SELECT 
			 Split.a.value('.', 'VARCHAR(24)') AS ssn  
		FROM  
		(
			SELECT CAST ('<M>' + REPLACE(@ssns1, ',', '</M><M>') + '</M>' AS XML) AS CVS 
		) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)


	insert into #tmp(Id, EmployeeId, SSN)
	select pc1.Id, EmployeeId, e.SSN into#tmp
	from PayrollPayCheck pc1, Employee e, Company c
	where pc1.IsVoid=0  and pc1.PayDay between @startdate1 and @enddate1
	and pc1.EmployeeId=e.Id
	and pc1.CompanyId = c.Id
	and ((@id1 is not null and EmployeeId=@id1) or (@id1 is null))
	and ((@company1 is not null and pc1.CompanyId in (select id from #tmpcomps)) or (@company1 is null))
	and ((@ssns1 is not null and e.SSN in (select ssn from @tmpSSNs)) or (@ssns1 is null))
		
	
	select 
		EmployeeJson.Id EmployeeId, EmployeeJson.SSN, EmployeeJson.Department, EmployeeJson.HireDate, EmployeeJson.PayType EmpPayType,
		EmployeeJson.Contact ContactStr, 
		EmployeeJson.FirstName, EmployeeJson.MiddleInitial, EmployeeJson.LastName,
		(
			select 
			sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage,
			sum(case pc.PaymentMethod when 1 then NetWage else 0 end) CheckPay,
			sum(case pc.PaymentMethod when 1 then 0 else NetWage end) DDPay
			from PayrollPayCheck pc
			where 
			pc.Id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			for xml path('PayCheckWages'), elements, type
		),
		
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) Taxes,
		
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(
				select *, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
				from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) Deductions,
		
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) Compensations,
		
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		)  PayCodes,
		
		(select pt.WorkerCompensationId,
			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) WorkerCompensations,
		
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName,  pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt, Employee e
			where pc.EmployeeId=e.Id and e.SSN=EmployeeJson.SSN and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pc.PayDay <= @enddate1
			and pc.CompanyId in (select id from #tmpcomps)
			and pta.PayTypeId = pt.Id			
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) Accumulations
		
		
		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId=Company.Id
		and ((@id1 is not null and EmployeeJson.Id=@id1) or (@id1 is null))
		and ((@host1 is not null and Company.HostId=@host1) or (@host1 is null))
		and ((@company1 is not null and EmployeeJson.CompanyId=@company1) or (@company1 is null))
		and ((@ssns1 is not null and EmployeeJson.SSN in (select ssn from @tmpSSNs)) or (@ssns1 is null))
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractAccumulation]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtractAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtractAccumulation]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeDailyAccumulation bit = 0,
	@includeMonthlyAccumulation bit = 0,
	@includePayCodes bit = 0,
	@includeHistory bit = 0,
	@includeC1095 bit =0,
	@CheckEFileFormsFlag bit = 1,
	@CheckTaxPaymentFlag bit = 1,
	@extractDepositName varchar(max) = ''
	
AS
BEGIN
declare @startdateL datetime = @startdate,
	@enddateL datetime = @enddate,
	@depositScheduleL int = @depositSchedule,
	@reportL varchar(max) = @report,
	@hostL uniqueidentifier = @host,
	@includeVoidsL bit = @includeVoids,
	@includeTaxesL bit = @includeTaxes,
	@includeDeductionsL bit = @includeDeductions,
	@includeCompensationsL bit = @includeCompensations,
	@includeWorkerCompensationsL bit = @includeWorkerCompensations,
	@includeDailyAccumulationL bit = @includeDailyAccumulation,
	@includeMonthlyAccumulationL bit = @includeMonthlyAccumulation,
	@includePayCodesL bit = @includePayCodes,
	@includeHistoryL bit = @includeHistory,
	@includeC1095L bit =@includeC1095,
	@CheckEFileFormsFlagL bit = @CheckEFileFormsFlag,
	@CheckTaxPaymentFlagL bit = @CheckTaxPaymentFlag,
	@extractDepositNameL varchar(max) = @extractDepositName
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpComp')
)
DROP TABLE #tmpComp;

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpVoids')
)
DROP TABLE #tmpVoids;

create table #tmp(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

create table #tmpVoids(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpVoidPaycheckCompanyId] ON #tmpVoids
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


	insert into #tmp(Id, CompanyId)
	select pc1.Id, pc1.CompanyId
	from PayrollPayCheck pc1
	where pc1.IsVoid<=@includeVoidsL 
	and ((@reportL<>'InternalPositivePayReport' and pc1.TaxPayDay between @startdateL and @enddateL) or (@reportL='InternalPositivePayReport' and ((pc1.IsReIssued=1 and pc1.ReIssuedDate between @startdateL and @enddateL) or (pc1.IsReIssued=0 and pc1.TaxPayDay between @startdateL and @enddateL))))
	and pc1.IsHistory<=@includeHistoryL
	and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=1)
	--and InvoiceId is not null
	and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1)
	and pc1.CompanyId in (select Id from Company where StatusId<>3)
	and @reportL<>'Report1099';

	insert into #tmpVoids(Id, CompanyId)
	select Id, CompanyId 
	from PayrollPayCheck pc1
	where IsVoid=1 
	and pc1.IsHistory=0
	and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=1)
	and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=2)
	and VoidedOn between @startdateL and @enddateL
	and year(TaxPayDay)=year(@startdateL)
	--and InvoiceId is not null
	and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1)
	and CompanyId in (select Id from Company where StatusId<>3)
	and @reportL<>'Report1099'


declare @year as varchar(max)=cast(year(@startdateL) as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@year
	declare @quarter3ed smalldatetime='9/30/'+@year
	declare @quarter4sd smalldatetime='10/1/'+@year
	declare @quarter4ed smalldatetime='12/31/'+@year

	declare @month int = month(@enddateL)
	

select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and host.StatusId<>3
		and ((@depositScheduleL is not null and host.DepositSchedule941=@depositScheduleL) or @depositScheduleL is null)
		and ((@hostL is not null and c.HostId=@hostL) or (@hostL is null))
		and ((@includeC1095L=1 and host.IsFiler1095=1) or (@includeC1095L=0))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and ((@CheckEFileFormsFlagL=1 and ManageEFileForms=1 ) or @CheckEFileFormsFlagL=0)
		and ((@CheckTaxPaymentFlagL=1 and ManageTaxPayment=1 )  or @CheckTaxPaymentFlagL=0)
		and ((@depositScheduleL is not null and DepositSchedule941=@depositScheduleL) or @depositScheduleL is null)
		and ((@hostL is not null and HostId=@hostL) or (@hostL is null))
		and ParentId is null
		and StatusId<>3
		and ((@includeC1095L=1 and IsFiler1095=1) or (@includeC1095L=0))
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and ((@CheckEFileFormsFlagL=1 and Parent.ManageEFileForms=1 ) or @CheckEFileFormsFlagL=0)
		and ((@CheckTaxPaymentFlagL=1 and Parent.ManageTaxPayment=1 )  or @CheckTaxPaymentFlagL=0)
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and Company.StatusId<>3
		and ((@depositScheduleL is not null and Parent.DepositSchedule941=@depositScheduleL) or @depositScheduleL is null)
		and ((@hostL is not null and Parent.HostId=@hostL) or (@hostL is null))
		and ((@includeC1095L=1 and Parent.IsFiler1095=1) or (@includeC1095L=0))
	)a
	

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*,
		(
			select ctr.Id, ctr.CompanyId, ctr.TaxId, t.Code as TaxCode, ctr.TaxYear, ctr.Rate
			from CompanyTaxRate ctr, Tax t
			where ctr.TaxId=t.Id and ctr.TaxYear=year(@startdateL)
			and ctr.CompanyId=Company.Id
			for xml path('CompanyTaxRate'), Elements, type
		) CompanyTaxRates,
		case when @includeC1095L=1 then
		(select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
			(select Id, Name, 
			case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
			from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
		from CompanyDeduction Where CompanyId=Company.Id 
		for xml path('CompanyDeduction'), elements, type) 
		end Deductions		
		from Company HostCompany where Id=List.FilingCompanyId
		for xml path ('HostCompany'), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Company.Id
		for xml path ('ExtractTaxState'), ELEMENTS, type
	) States,
	(
		select *
		from
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			
			(select 
				case when @includeC1095L=0 then
				(
				select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
					sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
					sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
					sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
					sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
					sum(Immigrants) as Immigrants, sum(Twelve1) Twelve1, sum(Twelve2) Twelve2, sum(Twelve3) Twelve3,
					case when @extractDepositNameL='' then 0 else dbo.GetExtractDepositAmount(@extractDepositNameL, ExtractCompany.Id, @startdateL, @enddateL) end DepositAmount
				from (
						select 
						pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
						case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
						case when month(pc.TaxPayDay)=@month-2 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve1,
						case when month(pc.TaxPayDay)=@month-1 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve2,
						case when month(pc.TaxPayDay)=@month and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve3,
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.Amount else 0 end) Quarter1FUTA,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter2FUTA,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter3FUTA,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter4FUTA,
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter1FUTAWage,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter2FUTAWage,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter3FUTAWage,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter4FUTAWage
						from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
						where pc.Id=pct.PayCheckId
						and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
						and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
						
						and @reportL<>'Report1099'
						group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.TaxPayDay, pc.StartDate, pc.EndDate
					)a
			
				for xml path('PayCheckWages'), elements, type
			) end,
			case when @includeC1095L=0 then
			(
				select pc.Id, pc.TaxPayDay as PayDay, pc.PaymentMethod, pc.CheckNumber, e.FirstName, e.LastName, pc.GrossWage, pc.PEOASOCoCheck, pc.NetWage, pc.IsVoid, pc.CompanyId,
				pc.IsReIssued, pc.OriginalCheckNumber, pc.ReIssuedDate
				from PayrollPayCheck pc, Employee e
				where pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				for xml path('PayCheckSummary'), elements, type

			) end PayCheckList,
			case when @includeDailyAccumulationL=1 then
			(
				
				select 
				month(pc.TaxPayDay) Month, day(pc.TaxPayDay) Day,
				sum(case when t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
				from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
				where pc.Id=pct.PayCheckId
				and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				group by pc.TaxPayDay
				for xml path('DailyAccumulation'), elements, type
				
				
			) end DailyAccumulations,
			case when @includeMonthlyAccumulationL=1 then
			(
				select 
				month(pc.TaxPayDay) Month,
				sum(case when t.Id<6 then pct.Amount else 0 end) IRS941,
				sum(case when t.Id=6 then pct.Amount else 0 end) IRS940,
				sum(case when t.Id between 7 and 10 then pct.Amount else 0 end) EDD
				from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t
				where pc.Id=pct.PayCheckId
				and pct.TaxId=ty.Id and ty.TaxId=t.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by month(pc.TaxPayDay)
				for xml path('MonthlyAccumulation'), elements, type
			) end MonthlyAccumulations,
			case when @includeTaxesL=1 then
			(select pt.TaxId, 
				(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
								case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
								from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
				sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
				from PayCheckTax pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
						
				group by pt.taxid
				for xml path('PayCheckTax'), elements, type
			) end Taxes,
			case when @includeDeductionsL=1 then
			(select pt.CompanyDeductionId,
			
				sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
				(
					select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
						(select Id, Name, 
						case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
						from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
					from CompanyDeduction Where Id=pt.CompanyDeductionId 
					for xml path('CompanyDeduction'), elements, type
				) 
				from PayCheckDeduction pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id) 
						
				group by pt.CompanyDeductionId
				for xml path('PayCheckDeduction'), elements, type
			) end Deductions,
			case when @includeCompensationsL=1 then
			(select pt.PayTypeId,
				p.Name PayTypeName,
				sum(pt.Amount) YTD
				from PayCheckCompensation pt, PayType p
				where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id) 
							
				group by pt.PayTypeId, p.Name
				for xml path('PayCheckCompensation'), elements, type
			) end Compensations,
			case when @includePayCodesL=1 then
			(select pt.PayCodeId,
			
				sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
				from PayCheckPayCode pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by pt.PayCodeId
				for xml path('PayCheckPayCode'), elements, type
			) end PayCodes,
			case when @includeWorkerCompensationsL=1 then
			(select pt.WorkerCompensationId,			
				sum(pt.Amount) YTD,
				(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
				from PayCheckWorkerCompensation pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by pt.WorkerCompensationId
				for xml path('PayCheckWorkerCompensation'), elements, type
			) end WorkerCompensations
			for xml path ('Accumulation'), elements, type
		)Accumulations,
		case when exists(select 'x' from #tmpVoids) then
			(select 
				(
				select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
					sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
					sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
					sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
					sum(Immigrants) as Immigrants, sum(Twelve1) Twelve1, sum(Twelve2) Twelve2, sum(Twelve3) Twelve3
				from (
						select 
						pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
						case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
						case when month(pc.TaxPayDay)=@month-2 and day(pc.TaxPayDay)=12 and pc.GrossWage>0 then 1 else 0 end Twelve1,
						case when month(pc.TaxPayDay)=@month-1 and day(pc.TaxPayDay)=12 and pc.GrossWage>0 then 1 else 0 end Twelve2,
						case when month(pc.TaxPayDay)=@month and day(pc.TaxPayDay)=12 and pc.GrossWage>0 then 1 else 0 end Twelve3,
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.Amount else 0 end) Quarter1FUTA,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter2FUTA,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter3FUTA,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter4FUTA,
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter1FUTAWage,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter2FUTAWage,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter3FUTAWage,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter4FUTAWage
						from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
						where pc.Id=pct.PayCheckId
						and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
						and pc.Id in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
						
						and @reportL<>'Report1099'
						group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.TaxPayDay
					)a
			
				for xml path('PayCheckWages'), elements, type
			),
			(
				select pc.Id, pc.TaxPayDay as PayDay, pc.PaymentMethod, pc.CheckNumber, e.FirstName, e.LastName
				from PayrollPayCheck pc, Employee e
				where pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				for xml path('PayCheckSummary'), elements, type

			) VoidedPayCheckList,
			case when @includeTaxesL=1 then
			(select pt.TaxId, 
				(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
								case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
								from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
				sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
				from PayCheckTax pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
						
				group by pt.taxid
				for xml path('PayCheckTax'), elements, type
			) end Taxes,
			case when @includeDeductionsL=1 then
			(select pt.CompanyDeductionId,
			
				sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
				(
					select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
						(select Id, Name, 
						case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
						from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
					from CompanyDeduction Where Id=pt.CompanyDeductionId 
					for xml path('CompanyDeduction'), elements, type
				) 
				from PayCheckDeduction pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id) 
						
				group by pt.CompanyDeductionId
				for xml path('PayCheckDeduction'), elements, type
			) end Deductions,
			case when @includeCompensationsL=1 then
			(select pt.PayTypeId,
				p.Name PayTypeName,
				sum(pt.Amount) YTD
				from PayCheckCompensation pt, PayType p
				where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id) 
							
				group by pt.PayTypeId, p.Name
				for xml path('PayCheckCompensation'), elements, type
			) end Compensations,
			case when @includePayCodesL=1 then
			(select pt.PayCodeId,
			
				sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
				from PayCheckPayCode pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				
				group by pt.PayCodeId
				for xml path('PayCheckPayCode'), elements, type
			) end PayCodes,
			case when @includeWorkerCompensationsL=1 then
			(select pt.WorkerCompensationId,			
				sum(pt.Amount) YTD,
				(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
				from PayCheckWorkerCompensation pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				
				group by pt.WorkerCompensationId
				for xml path('PayCheckWorkerCompensation'), elements, type
			) end WorkerCompensations
			for xml path ('Accumulation'), elements, type
		) end VoidedAccumulations,
		
		case when @reportL='Report1099' then
			(
				select *, 
				(select sum(amount) from CheckbookJournal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdateL and @enddateL) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @reportL='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)
			end Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		and (
		(exists(select 'x' from #tmp where CompanyId=ExtractCompany.Id) and @reportL<>'Report1099' and @includeC1095L=0)
		or
		(@reportL='Report1099')
		or
		(@includeC1095L=1)
		)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	and (
		(exists(select 'x' from #tmp where CompanyId in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)) and @reportL<>'Report1099')
		or
		(@reportL='Report1099')
		)
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtractData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtractData]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@depositSchedule1 int = @depositSchedule,
	@report1 varchar(max)=@report,
	@host1 uniqueidentifier = @host,
	@includeVoids1 bit = @includeVoids

	select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and ((@depositSchedule1 is not null and host.DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
		and c.StatusId<>3
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and ((@report1<>'HostWCReport' and ManageEFileForms=1 and ManageTaxPayment=1) or (@report1='HostWCReport'))
		and ((@depositSchedule1 is not null and DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and HostId=@host1) or (@host1 is null))
				and ParentId is null
		and StatusId<>3
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and ((@report1<>'HostWCReport' and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1) or (@report1='HostWCReport'))
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and ((@depositSchedule1 is not null and Parent.DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and Parent.HostId=@host1) or (@host1 is null))
		and Company.StatusId<>3
	)a

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=List.FilingCompanyId
		for xml path ('HostCompany'), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Company.Id
		for xml path ('ExtractTaxState'), ELEMENTS, type
	) States,
	(
		select *
		from
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(
				select *
				from PayrollPayCheck where CompanyId=ExtractCompany.Id 
				and IsVoid=0
				and taxpayday between @startdate1 and @enddate1
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=1)
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report1<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) PayChecks,
			(
				select *
				 from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=1)
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=2)
				and VoidedOn between @startdate1 and @enddate1
				and year(taxpayday)=year(@startdate1)
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report1<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from CheckbookJournal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @report1='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts,
	(
		select *
		from
		MasterExtracts where ExtractName=@report1 and year(startdate)=year(@startdate1)
		and Id=0
		for xml path ('MasterExtractDB'), ELEMENTS, type
	) History
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractDataSpecial]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractDataSpecial]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtractDataSpecial] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtractDataSpecial]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@depositSchedule1 int = @depositSchedule,
	@report1 varchar(max) = @report,
	@host1 uniqueidentifier = @host,
	@includeVoids1 bit = @includeVoids

	select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and ((@depositSchedule1 is not null and host.DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
		and c.StatusId<>3
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and ((@report1<>'HostWCReport' and ManageEFileForms=1 and ManageTaxPayment=1) or (@report1='HostWCReport'))
		and ((@depositSchedule1 is not null and DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and HostId=@host1) or (@host1 is null))
		and ParentId is null
		and StatusId<>3
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and ((@report1<>'HostWCReport' and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1) or (@report1='HostWCReport'))
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and ((@depositSchedule1 is not null and Parent.DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ((@host1 is not null and Parent.HostId=@host1) or (@host1 is null))
		and Company.StatusId<>3
	)a

	select distinct p.Id into #tmpp
	from Payroll p
	where 
	payday between @startdate1 and @enddate1
	and p.Id not in (
	select distinct p1.Id 
	from Payroll p1, Company c , PayrollInvoice pi
	where month(p1.PayDay)<>month(p1.TaxPayDay)
	and p1.CompanyId=c.Id
	and p1.InvoiceId=pi.Id
	)

	

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=List.FilingCompanyId
		for xml path ('HostCompany'), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Company.Id
		for xml path ('ExtractTaxState'), ELEMENTS, type
	) States,
	(
		select *
		from
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(
				select *
				from PayrollPayCheck where CompanyId=ExtractCompany.Id 
				and IsVoid=0
				and PayrollId in (select Id from #tmpp)
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=1)
				and InvoiceId is not null
				and payday between @startdate1 and @enddate1
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report1<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) PayChecks,
			(
				select *
				 from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=1)
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=2)
				and PayrollId in (select Id from #tmpp)
				and VoidedOn between @startdate1 and @enddate1
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report1<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from CheckbookJournal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @report1='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts,
	(
		select *
		from
		MasterExtracts where ExtractName=@report1 and year(startdate)=year(@startdate1)
		and Id=0
		for xml path ('MasterExtractDB'), ELEMENTS, type
	) History
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtracts]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtracts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtracts] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtracts]
	@extract varchar(max) = null,
	@id int = null
	
AS
BEGIN
	declare @extract1 varchar(max) = @extract,
	@id1 int = @id

	select Id, StartDate, EndDate, ExtractName, IsFederal, DepositDate, Journals, LastModified, LastModifiedBy, ConfirmationNo, ConfirmationNoUser, ConfirmationNoTS
	, 
	null Extract
	from MasterExtracts
	Where 
	((@id1 is not null and Id=@id1) or (@id1 is null))
	and ((@extract1 is not null and ExtractName=@extract1) or (@extract1 is null))
	for Xml path('MasterExtractJson'), root('MasterExtractList') , elements, type
		
	

END

GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetHostAndCompanies] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetHostAndCompanies]
	@host varchar(max) = null,
	@company varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	declare @host1 uniqueidentifier = @host
	declare @company1 uniqueidentifier = @company
	declare @role1 varchar(max)= @role
	select @rootHost = RootHostId from ApplicationConfiguration

	select 
		(
			select Id, FirmName, Url, EffectiveDate, CompanyId, HomePage, IsPeoHost, (select CompanyIntId from Company where Id=CompanyId) CompanyIntId,
			(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=1 and SourceEntityId=Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact,
			(select DirectDebitPayer from Company where HostId=Host.Id and IsHostCompany=1) IsHostAllowsDirectDebit
			from Host 
			where ((@host1 is not null and Id=@host1) or (@host1 is null))
			for xml path ('HostListItem'), elements, type
		)Hosts,
		(
			select Id, HostId, CompanyName Name, CompanyNo, LastPayrollDate, FileUnderHost, IsHostCompany, Created, 
				case StatusId When 1 then 'Active' When 2 then 'InActive' else 'Terminated' end StatusId,
				(select InvoiceSetup from CompanyContract cc where cc.CompanyId=Company.Id) InvoiceSetup,
				(select Rate from CompanyTaxRate where TaxYear=year(getdate()) and TaxId=9 and CompanyId=Company.Id) ETTRate,
				(select Rate from CompanyTaxRate where TaxYear=year(getdate()) and TaxId=10 and CompanyId=Company.Id) UIRate,
				CompanyAddress, FederalEIN,
				(select * from CompanyTaxState Where CompanyId=Company.Id for xml auto, elements, type) CompanyTaxStates, 
				(select * from InsuranceGroup Where Id=Company.InsuranceGroupNo for xml auto, elements, type),
				(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
			from Company
			where 
			((@company1 is not null and Id=@company1) or (@company1 is null))
			and (
					(@role1 is not null and @role1='HostStaff' and IsHostCompany=0) 
					or (@role1 is not null and @role1='CorpStaff' and IsHostCompany=0) 
					or (@role1 is null or @role1='Company' or @role1='Employee')
				)
			for xml path ('CompanyListItem'), elements, type
		)Companies
	for xml path('HostAndCompanies')
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role

	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select c.CompanyName, DateDiff(day, i.invoicedate, getdate()) age1,i.invoicedate,
		case  
			When DateDiff(day, i.invoicedate, getdate())=1 then 1
			when DateDiff(day, i.invoicedate, getdate())=2 then 2
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then 3
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then 5
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then 10
			else
				20
			end 
		Age,
		case  
			When DateDiff(day, i.invoicedate, getdate())=1 then '1 day'
			when DateDiff(day, i.invoicedate, getdate())=2 then '2 days'
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then '3-4 days'
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then '5-9 days'
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then '10-20 days'
			else
				'Over 20 days'
			end 
		AgeText,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	and c.StatusId=1
	and i.Balance>0
	and DateDiff(day, i.invoicedate, getdate()) >0
	and ((@role1 is not null and @role1='HostStaff' and c.IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and c.IsHostCompany=0)
			or (@role1 is null))
	and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) AgeText from #tmpInspectionData t Where t.Age=row.Age1) Age, ' +@companies+ ' from (select Age as Age1,'+@companies+' from
	(select distinct Age, CompanyName , Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by Age1'
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoicePayments]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoicePayments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoicePayments] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoicePayments]
	
	@startdate varchar(max) = null,
	@enddate varchar(max) = null
AS
BEGIN
declare @startdate1 varchar(max) = @startdate,
	@enddate1 varchar(max) = @enddate
	
		select 
		p.CompanyId, i.PaymentDate, i.Method, i.Status, i.CheckNumber, i.Amount, i.InvoiceId, i.Id as PaymentId
		from
		InvoicePayment i, PayrollInvoice p with (nolock)
		where i.InvoiceId=p.Id
		and ((@startdate1 is not null and i.PaymentDate>=@startdate1) or @startdate1 is null)
		and ((@enddate1 is not null and i.PaymentDate<@enddate1) or @enddate1 is null)
		Order by i.Id
		for Xml path('ExtractInvoicePaymentJson'), root('InvoicePaymentList'), elements, type
	
		
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceStatusChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceStatusChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@onlyActive1 bit = @onlyActive

	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select c.CompanyName, 
			case i.Status 
				when 1 then 'Draft' when 2 then 'Approved' when 3 then 'Delivered'
				when 5 then 'Taxes Delayed' when 6 then 'Bounced'
				when 7 then 'Partial Payment' when 9 then 'Not Deposited' when 10 then 'ACH Pending'
				end as  StatusName,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	and ((@onlyActive1=1 and c.StatusId=1) or (@onlyActive1=0))
	and i.Balance>0
	and i.Status not in (4, 8)
	and ((@startdate1 is not null and i.InvoiceDate>=@startdate1) or (@startdate1 is null))
	and ((@enddate1 is not null and i.InvoiceDate<=@enddate1) or (@enddate1 is null))
	and ((@role1 is not null and @role1='HostStaff' and c.IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and c.IsHostCompany=0)
			or (@role1 is null))
	and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(StatusName as varchar(max)) + ']','[' + cast(StatusName as varchar(max))+ ']')
	FROM (select distinct StatusName from #tmpInspectionData) a
	
	print @companies
	
	select 'GetInvoiceStatusChartData' Report;
	select StatusName Status, count(Id) NoOfInvoices
	from #tmpInspectionData
	group by StatusName
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusDetailedChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusDetailedChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceStatusDetailedChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceStatusDetailedChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@criteria varchar(max),
	@onlyActive bit = 1
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@criteria1 varchar(max)=@criteria,
	@onlyActive1 bit = @onlyActive
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	declare @status int = null
	select @status = case @criteria1
					when 'Draft' then 1
					when 'Approved' then 2
					when 'Delivered' then 3
					when 'Closed' then 4
					when 'Taxes Delayed' then 5
					when 'Bounced' then 6
					when 'Partial Payment' then 7
					when 'Deposited' then 8
					when 'Not Deposited' then 9
					when 'ACH Pending' then 10
					end
	select firmname, companyname, [Next Payroll Due], [Next PayDay], Id,
	case  
		when DateDiff(day, getdate(), [Next PayDay])>=5 then
			'5 days+'
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			'4 days'
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			'3 days'
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			'2 days'
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			'1 days'
		else
			'Past Due'

	end
	[Days till Due],
	case  
		when DateDiff(day, getdate(), [Next PayDay])>=5 then
			5
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			4
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			3
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			2
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			1
		else
			0

	end
	[DaysDue]
	into #tmpInspectionData
	from
	(
	select h.firmname, c.CompanyName, i.InvoiceDate,
		case 
			when c.LastPayrollDate is null then 
				'Never run'
			else
				Case
					When c.PayrollSchedule=1 then
						case when DateAdd(day, 7, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=2 then
						case when DateAdd(day, 14, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=3 then
						case when DateAdd(day, 15, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=4 then
						case when DateAdd(MONTH, 1, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate)),' days')
							end					
				end
		end [Next Payroll Due],
		Case
			When c.PayrollSchedule=1 then
				DateAdd(day, 7, p.PayDay)
			When c.PayrollSchedule=2 then
				DateAdd(day, 14, p.PayDay)
			When c.PayrollSchedule=3 then
				DateAdd(day, 15, p.PayDay)
			When c.PayrollSchedule=4 then
				DateAdd(month, 1, p.PayDay)				
		end
		[Next PayDay],
		i.Id
		
	from Company c, Host h, PayrollInvoice i, Payroll p
	Where 
	i.PayrollId=p.Id
	and ((@onlyActive1=1 and c.StatusId=1) or (@onlyActive1=0))
	and c.HostId = h.Id
	and c.id = i.CompanyId
	and i.balance>0
	--and i.Status>=1
	and ((@startdate1 is not null and i.InvoiceDate>=@startdate1) or (@startdate1 is null))
	and ((@enddate1 is not null and i.InvoiceDate<=@enddate1) or (@enddate1 is null))
	and ((@role1 is not null and @role1='HostStaff' and c.IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and c.IsHostCompany=0)
			or (@role1 is null))
	and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)
	and ((@status is not null and i.Status=@status) or (@status is null))
	) a
	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) [Days till Due] from #tmpInspectionData t Where t.[DaysDue]=row.[DaysDue]) [Days till Due], ' +@companies+ ' from (select [DaysDue],'+@companies+' from
	(select distinct [DaysDue], CompanyName, Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by [DaysDue]';

	select 'GetInvoiceStatusDetailedChartData' Report;
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusPastDueChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusPastDueChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceStatusPastDueChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceStatusPastDueChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@criteria varchar(max),
	@onlyActive bit = 1
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@criteria1 varchar(max) = @criteria,
	@onlyActive1 bit = @onlyActive

	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	declare @status int = null
	select @status = case @criteria1
					when 'Draft' then 1
					when 'Approved' then 2
					when 'Delivered' then 3
					when 'Closed' then 4
					when 'Taxes Delayed' then 5
					when 'Bounced' then 6
					when 'Partial Payment' then 7
					when 'Deposited' then 8
					when 'Not Deposited' then 9
					when 'ACH Pending' then 10
					end

	select c.CompanyName, DateDiff(day, i.invoicedate, getdate()) age1,i.invoicedate,
		case  
			When DateDiff(day, i.invoicedate, getdate())=1 then 1
			when DateDiff(day, i.invoicedate, getdate())=2 then 2
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then 3
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then 5
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then 10
			else
				20
			end 
		Age,
		case  
			When DateDiff(day, i.invoicedate, getdate())=1 then '1 day'
			when DateDiff(day, i.invoicedate, getdate())=2 then '2 days'
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then '3-4 days'
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then '5-9 days'
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then '10-20 days'
			else
				'Over 20 days'
			end 
		AgeText,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	and ((@onlyActive1=1 and c.StatusId=1) or (@onlyActive1=0))
	and i.Balance>0
	and DateDiff(day, i.invoicedate, getdate()) >0
	and ((@startdate1 is not null and i.InvoiceDate>=@startdate1) or (@startdate1 is null))
	and ((@enddate1 is not null and i.InvoiceDate<=@enddate1) or (@enddate1 is null))
	and ((@role1 is not null and @role1='HostStaff' and c.IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and c.IsHostCompany=0)
			or (@role1 is null))
	and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)
	and ((@status is not null and i.Status=@status) or (@status is null))

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) AgeText from #tmpInspectionData t Where t.Age=row.Age1) Age, ' +@companies+ ' from (select Age as Age1,'+@companies+' from
	(select distinct Age, CompanyName , Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by Age1';
	select 'GetInvoiceStatusPastDueChartData' Report;
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetJournalIds]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalIds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetJournalIds] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetJournalIds]
	@company uniqueidentifier = null,
	@startdate datetime = null,
	@enddate datetime = null,
	@transactiontype int = null,
	@accountid int = null
AS
BEGIN
	declare @company1 uniqueidentifier = @company,
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@transactiontype1 int = @transactiontype,
	@accountid1 int = @accountid

	declare @where nvarchar(max) = ''
	
	if @accountid1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'MainAccountId=' + cast(@accountid1 as varchar(max))
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @transactiontype1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionType=' + cast(@transactiontype1 as varchar(max))
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate>=''' + cast(@startdate1 as varchar(max)) + ''''
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate<=''' + cast(@enddate1 as varchar(max)) + ''''
	
	declare @query nvarchar(max) ='
		select 
			Id
		from CheckbookJournal
		where
		' + @where + '	Order by Id 
		for Xml path(''JournalJson''), root(''JournalList''), Elements, type'

	execute(@query)
		
		
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetJournalPayees]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalPayees]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetJournalPayees] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetJournalPayees]
	@company uniqueidentifier = null,
	@payeeId uniqueidentifier = null,
	@payeeType int = null
AS
BEGIN
	declare @company1 uniqueidentifier = @company,
	@payeeId1 uniqueidentifier = @payeeId,
	@payeeType1 int = @payeeType

	declare @host uniqueidentifier
	select @host = HostId from Company where Id=@company1

	select a.* from
	(
		select Id, CompanyName as PayeeName, 'Company' as PayeeType,
		(
			select top(1) TargetObject
			from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and SourceEntityId=Company.Id
			
		) Contact, CompanyAddress Address
		from Company where HostId=@host and IsHostCompany=0
		union
		select Id, (FirstName + ' ' + MiddleInitial + ' ' + LastName) PayeeName, 'Employee' as PayeeType, Contact, '' Address
		from Employee where CompanyId=@company1
		union
		select Id, Name as PayeeName, case when IsVendor=1 then 'Vendor' else 'Customer' end PayeeType, Contact, '' Address
		from VendorCustomer where CompanyId=@company1 or CompanyId is null
	)a, EntityType et
	where a.PayeeType = et.EntityTypeName
	and ((@payeeId1 is not null and Id=@payeeId1) or @payeeId1 is null)
	and ((@payeeType1 is not null and et.EntityTypeId=@payeeType1) or @payeeType1 is null)
	for Xml path('JournalPayeeJson'), root('JournalPayeeList') , elements, type
		
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 14/01/2019 4:07:30 PM ******/
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
	@payrollid uniqueidentifier = null,
	@includePayrollJournals bit = 0,
	@includeDetails bit = 1
AS
BEGIN
	declare @company1 uniqueidentifier = @company,
	@paycheck1 int=@paycheck,
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@id1 int=@id,
	@void1 int=@void,
	@year1 int = @year,
	@transactiontype1 int = @transactiontype,
	@accountid1 int = @accountid,
	@PEOASOCoCheck1 bit = @PEOASOCoCheck,
	@payrollid1 uniqueidentifier = @payrollid,
	@includePayrollJournals1 bit = @includePayrollJournals,
	@includeDetails1 bit = @includeDetails

	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Id=' + cast(@Id1 as varchar(max))
	if @paycheck1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollPayCheckId=' + cast(@paycheck1 as varchar(max))
	if @payrollid1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollId=''' + cast(@payrollid1 as varchar(max)) + ''''
	if @accountid1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'MainAccountId=' + cast(@accountid1 as varchar(max))
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @transactiontype1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionType=' + cast(@transactiontype1 as varchar(max))
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate>=''' + cast(@startdate1 as varchar(max)) + ''''
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate<=''' + cast(@enddate1 as varchar(max)) + ''''
	if @PEOASOCoCheck1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PEOASOCoCheck=' + cast(@PEOASOCoCheck1 as varchar(max))
	if @void1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsVoid=' + cast(@void1 as varchar(max))
	if @year1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'year(TransactionDate)=' + cast(@year1 as varchar(max))

	declare @query as nvarchar(max) = ''
	set @query = 'select 
			[Id]
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
      ,[LastModifiedBy],[JournalDetails] as JournalDetails, [DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId], [IsCleared], [ClearedBy], [ClearedOn]
		from CheckbookJournal
		where ' + @where
	if @includePayrollJournals=1
	begin
		set @query = @query + ' Union select 
			[Id]
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
      ,[LastModifiedBy],'
	  if @includeDetails=1 
		set @query = @query + '[JournalDetails] as JournalDetails, '
		else 
		set @query = @query + ''''' as JournalDetails, '
      --,case when @includeDetails=1 then [JournalDetails] else '' end as JournalDetails
      set @query = @query + '[DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId], [IsCleared], [ClearedBy], [ClearedOn]
		from Journal
		where ' + @where
	end
	set @query = @query + 'for Xml path(''JournalJson''), root(''JournalList''), Elements, type'
	print @query
	Execute(@query)
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[GetMinifiedPayrolls]    Script Date: 14/01/2019 4:07:30 PM ******/
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
	@void int=null,
	@isprinted bit = null
AS
BEGIN
	declare @company1 varchar(max) = @company,
	@startdate1 varchar(max) = @startdate,
	@enddate1 varchar(max) = @enddate,
	@id1 uniqueidentifier=@id,
	@invoice1 uniqueidentifier=@invoice,
	@status1 varchar(max)=@status,
	@void1 int=@void,
	@isprinted1 bit = @isprinted

	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Payroll.Id=''' + cast(@Id1 as varchar(max)) + ''''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @invoice1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Pinv.Id=''' + cast(@invoice1 as varchar(max)) + ''''
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.PayDay>=''' + cast(@startdate1 as varchar(max)) + ''''
		
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.PayDay<=''' + cast(@enddate1 as varchar(max)) + ''''
		
	if @status1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.status =' + @status1
	if @void1 is not null
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.IsVoid =0'
	if @isprinted1 is not null
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.IsPrinted =' + cast(@isprinted1 as varchar(1))
	
	declare @query as nvarchar(max)=''
	set @query ='
	select
		Payroll.Id, Company.CompanyName, Payroll.PayDay, Payroll.StartDate, Payroll.EndDate,Payroll.Status, Payroll.LastModifiedBy ProcessedBy, Payroll.LastModified, Payroll.IsHistory,
		Pinv.Id as InvoiceId,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		sum(PayrollPayCheck.GrossWage) TotalGrossWage, sum(PayrollPayCheck.NetWage) TotalNetWage
		from PayrollPayCheck, Company, Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where
		Company.Id=Payroll.CompanyId
		and Payroll.Id=PayrollPayCheck.PayrollId
		and Payroll.IsQueued=0 and ' + @where + 'group by Payroll.Id, Company.CompanyName, Payroll.PayDay, Payroll.StartDate, Payroll.EndDate,Payroll.Status, Payroll.LastModifiedBy, Payroll.LastModified, Payroll.IsHistory,
		Pinv.Id,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status
		Order by PayDay
		for Xml path(''PayrollMinified''), root(''PayrollMinifiedList''), elements, type'
		
	Execute(@query)
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetMinWageEligibleCompanies]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinWageEligibleCompanies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetMinWageEligibleCompanies] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetMinWageEligibleCompanies]
	@contractType int = 2,
	@minWage decimal(18,2) = null,
	@statusId int = 0,
	@city varchar(max) = null,
	@payrollYear int
AS
BEGIN
	declare @contractType1 int = @contractType,
	@minWage1 decimal(18,2) = @minWage,
	@statusId1 int = @statusId,
	@city1 varchar(max) = @city,
	@payrollYear1 int = @payrollYear

	select * into #tmpCompanyPaidEmployees from 
	(
	select p.companyid CompanyId, c.CompanyName, count(distinct e.SSN) Employees 
	from payroll p, PayrollPayCheck pc, Company c, Employee e
	where p.id=pc.payrollid and pc.IsVoid=0 and p.IsVoid=0
	and pc.EmployeeId=e.id
	and p.CompanyId=c.Id
	and year(p.payday)=@payrollYear1
	group by p.CompanyId, c.CompanyName
	
	) a

	select h.firmname Host, c.Id CompanyId, c.CompanyName Company, c.MinWage, c.FileUnderHost, c.City,
	(select count(Id) from Employee where CompanyId=c.Id and StatusId=1) ActiveEmployeeCount,
	(select Employees from #tmpCompanyPaidEmployees where CompanyId=c.Id) PaidEmployeeCount,

	(
		select e.Id, e.FirstName, e.LastName, e.Rate from Employee e 
		where e.CompanyId=c.Id and e.PayType=1 
		and ((@minWage1 is not null and e.Rate<@minWage1) or (@minWage1 is null))
		for xml path ('MinWageEligibleEmployee'), elements, type
	) 
	Employees
	from company c,  host h
	where c.hostId=h.id
	and ((@statusId1>0 and c.statusid=@statusId1) or @statusId1=0)
	and ((@city1 is not null and lower(c.City)=@city1) or @city1 is null)
	and (
			(@contractType1=1 and c.FileUnderHost=1 and h.IsPeoHost=1) 
			OR
			(
				(@contractType1=0 and c.FileUnderHost=1 and c.IsHostCompany=1 and h.IsPeoHost=0)
				OR
				(@contractType1=0 and c.FileUnderHost=0)
			)
			OR
			@contractType1=2
		)
	order by h.firmname, FileUnderHost desc, CompanyName
	for Xml path('MinWageEligibileCompany'), root('MinWageEligibleCompanyList'), Elements, type
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPaychecks]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaychecks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPaychecks] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPaychecks]
	@company uniqueidentifier = null,
	@employee uniqueidentifier = null,
	@payroll uniqueidentifier=null,
	@startdate datetime = null,
	@enddate datetime = null,
	@id int=null,
	@status varchar(max)=null,
	@void int=null,
	@year int = null
AS
BEGIN
	declare @company1 uniqueidentifier = @company,
	@employee1 uniqueidentifier = @employee,
	@payroll1 uniqueidentifier=@payroll,
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@id1 int=@id,
	@status1 varchar(max)=@status,
	@void1 int=@void,
	@year1 int = @year

	declare @where nvarchar(max) = ''
	declare @query nvarchar(max) =''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollPayCheck.Id=' + cast(@Id1 as varchar(max))
	if @payroll1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheckPayrollId=''' + cast(@payroll1 as varchar(max)) + ''''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @employee1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.EmployeeId=''' + cast(@employee1 as varchar(max)) + ''''
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.PayDay>=''' + cast(@startdate1 as varchar(max)) + ''''
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.PayDay<=''' + cast(@enddate1 as varchar(max)) + ''''
	if @status1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.Status=cast(' + @status1 +' as int)'
	if @void1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollPayCheck.IsVoid=' + cast(@void1 as varchar(max))
	if @year1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'year(PayrollPayCheck.PayDay)=' + cast(@year1 as varchar(max))

		set @query = 'select 
			PayrollPayCheck.*
		from PayrollPayCheck 
		where ' + @where +  'Order by PayrollPayCheck.Id 
		for Xml path(''PayrollPayCheckJson''), root(''PayCheckList''), Elements, type'
		
		
	print @query
	execute(@query)
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role

	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select firmname, companyname, [Next Payroll Due], [Next PayDay], Id,
	case  
		when DateDiff(day, getdate(), [Next PayDay])>=5 then
			'5 days+'
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			'4 days'
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			'3 days'
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			'2 days'
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			'1 days'
		else
			'Past Due'

	end
	[Days till Due],
	case  
		when DateDiff(day, getdate(), [Next PayDay])>=5 then
			5
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			4
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			3
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			2
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			1
		else
			0

	end
	[DaysDue]
	into #tmpInspectionData
	from
	(
	select h.firmname, c.CompanyName, i.InvoiceDate,
		case 
			when c.LastPayrollDate is null then 
				'Never run'
			else
				Case
					When c.PayrollSchedule=1 then
						case when DateAdd(day, 7, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=2 then
						case when DateAdd(day, 14, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=3 then
						case when DateAdd(day, 15, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=4 then
						case when DateAdd(MONTH, 1, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate)),' days')
							end					
				end
		end [Next Payroll Due],
		Case
			When c.PayrollSchedule=1 then
				DateAdd(day, 7, p.PayDay)
			When c.PayrollSchedule=2 then
				DateAdd(day, 14, p.PayDay)
			When c.PayrollSchedule=3 then
				DateAdd(day, 15, p.PayDay)
			When c.PayrollSchedule=4 then
				DateAdd(month, 1, p.PayDay)				
		end
		[Next PayDay],
		i.Id
		
	from Company c, Host h, PayrollInvoice i, Payroll p
	Where 
	i.PayrollId=p.Id
	and c.StatusId=1
	and c.HostId = h.Id
	and c.id = i.CompanyId
	and i.balance>0
	--and i.Status>=1
	and ((@role1 is not null and @role1='HostStaff' and c.IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and c.IsHostCompany=0)
			or (@role1 is null))
	and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)
	) a
	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) [Days till Due] from #tmpInspectionData t Where t.[DaysDue]=row.[DaysDue]) [Days till Due], ' +@companies+ ' from (select [DaysDue],'+@companies+' from
	(select distinct [DaysDue], CompanyName, Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by [DaysDue]'
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoiceList]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoiceList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollInvoiceList] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollInvoiceList]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = '',
	@startdate datetime = null,
	@enddate datetime = null,
	@paymentstatus varchar(max) = '',
	@paymentmethod varchar(max) = '',
	@includeTaxesDelayed bit = 0
AS
BEGIN
	declare @host1 uniqueidentifier = @host,
	@company1 uniqueidentifier = @company,
	@role1 varchar(max) = @role,
	@status1 varchar(max) = @status,
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@paymentstatus1 varchar(max) = @paymentstatus,
	@paymentmethod1 varchar(max) = @paymentmethod,
	@includeTaxesDelayed1 bit = @includeTaxesDelayed

	declare @where nvarchar(max) = ''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate>=''' + cast(@startdate1 as varchar(max)) + ''''
		
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate<=''' + cast(@enddate1 as varchar(max)) + ''''
		
	if @includeTaxesDelayed1=1 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.TaxesDelayed=1'
	else
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'isnull(PayrollInvoiceJson.TaxesDelayed,0)>=0'	
	if @status1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.status in (' + @status1 + ')'
	if @paymentstatus1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status in (' + @paymentstatus1 + '))'
	if @paymentmethod1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method in (' + @paymentmethod1 + '))'
	
	declare @query as nvarchar(max) ='
		select 
		PayrollInvoiceJson.*,
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
		CompanyJson.CompanyName, CompanyJson.HostId, CompanyJson.IsHostCompany, CompanyJson.IsVisibleToHost, CompanyJson.BusinessAddress
		,(select max(PaymentDate) from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status=3) LastPayment,
		STUFF((SELECT '', '' + case when ip.Method=1 then CAST(ip.CheckNumber AS VARCHAR(max)) when ip.Method=2 then ''Cash'' when ip.Method=3 then ''Cert Fund'' when ip.Method=4 then ''Corp Check'' when ip.Method=5 then ''ACH'' end [text()]
         from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id
         FOR XML PATH(''''), TYPE)
        .value(''.'',''NVARCHAR(MAX)''),1,2,'' '') CheckNumbers
		
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson--, InvoicePayment InvoicePaymentJson
	Where 
	PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	and ' + @where + 'Order by PayrollInvoicejson.InvoiceNumber
	for Xml path(''PayrollInvoiceListItem''), root(''PayrollInvoiceJsonList''), elements, type'
	
	print @query
	Execute(@query)

END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 14/01/2019 4:07:30 PM ******/
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
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = '',
	@startdate datetime = null,
	@enddate datetime = null,
	@id uniqueidentifier=null,
	@paymentstatus varchar(max) = '',
	@paymentmethod varchar(max) = '',
	@invoicenumber int = null,
	@bypayday bit = 0
AS
BEGIN

	declare @host1 uniqueidentifier = @host,
	@company1 uniqueidentifier = @company,
	@role1 varchar(max) = @role,
	@status1 varchar(max) = @status,
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@id1 uniqueidentifier=@id,
	@paymentstatus1 varchar(max) = @paymentstatus,
	@paymentmethod1 varchar(max) = @paymentmethod,
	@invoicenumber1 int = @invoicenumber,
	@bypayday1 bit = @bypayday
	
	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollInvoiceJson.Id=''' + cast(@Id1 as varchar(max)) + ''''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @startdate1 is not null 
		begin
			if @bypayday1=0
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate>=''' + cast(@startdate1 as varchar(max)) + ''''
			else
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollJson.PayDay>=''' + cast(@startdate1 as varchar(max)) + ''''
		
		end
	if @enddate1 is not null 
		begin
			if @bypayday1=0
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceDate<=''' + cast(@enddate1 as varchar(max)) + ''''
			else
				set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollJson.PayDay<=''' + cast(@enddate1 as varchar(max)) + ''''
		
		end
	if @invoicenumber1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.InvoiceNumber>' + cast(@invoicenumber1 as varchar(max))	
	if @status1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollInvoiceJson.status in (' + @status1 + ')'
	if @paymentstatus1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Status in (' + @paymentstatus1 + '))'
	if @paymentmethod1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'exists(select ''x'' from InvoicePayment ip where ip.InvoiceId=PayrollInvoiceJson.Id and ip.Method in (' + @paymentmethod1 + '))'
	
	declare @query as nvarchar(max)=''
	set @query ='
	select 
		PayrollInvoiceJson.*,
		case when exists(select  ''x'' from CommissionExtract where PayrollInvoiceId=PayrollInvoiceJson.Id) then 1 else 0 end CommissionClaimed,
		PayrollJson.PayDay PayrollPayDay,PayrollJson.TaxPayDay PayrollTaxPayDay,
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
			(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type),
			(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=CompanyJson.Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
			for Xml path(''Company''), elements, type
		)
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson
	Where 
	PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id and ' + @where + ' Order by PayrollInvoicejson.InvoiceNumber
	for Xml path(''PayrollInvoiceJson''), root(''PayrollInvoiceJsonList''), elements, type'
	print @query
	Execute(@query)
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollProcessingPerformanceChart]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollProcessingPerformanceChart]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollProcessingPerformanceChart] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollProcessingPerformanceChart]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 0
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@onlyActive1 bit = @onlyActive

	declare @users varchar(max)
	declare @query varchar(max)	

	select i.ProcessedBy [User], LEFT(datename(month,i.ProcessedOn),3) + ' ' + Right(cast(year(i.ProcessedOn) as varchar),2) Month, i.Id 
	into #tmpInspectionData
	from PayrollInvoice i, Payroll p, Company c
	where 
		i.Id=p.InvoiceId
		and i.CompanyId=c.Id
		and ((@onlyActive1=1 and c.StatusId=1) or (@onlyActive1=0))
		and p.IsVoid=0
		and ((@startdate1 is not null and i.ProcessedOn>=@startdate1) or (@startdate1 is null))
		and ((@enddate1 is not null and i.ProcessedOn<=@enddate1) or (@enddate1 is null))

		
	SELECT @users = COALESCE(@users + ',[' + cast([User] as varchar) + ']','[' + cast([User] as varchar)+ ']')
	FROM (select distinct [User] from #tmpInspectionData)a
	
	set @query = 'select Month, ' +@users+ ' from (select Data.Month,'+@users+' from
	(select distinct Month, [User], Id
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for [User] in ('+@users+'))Data)t order by convert(datetime, ''01 ''+Month, 6)'
	
	select 'GetPayrollProcessingPerformanceChart' Report;	
	execute(@query)
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrolls] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrolls]
	@company varchar(max) = null,
	@startdate varchar(max) = null,
	@enddate varchar(max) = null,
	@id uniqueidentifier=null,
	@invoice uniqueidentifier=null,
	@status varchar(max)=null,
	@void int=null
AS
BEGIN
	declare @company1 varchar(max) = @company,
	@startdate1 varchar(max) = @startdate,
	@enddate1 varchar(max) = @enddate,
	@id1 uniqueidentifier=@id,
	@invoice1 uniqueidentifier=@invoice,
	@status1 varchar(max)=@status,
	@void1 int=@void

	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Payroll.Id=''' + cast(@Id1 as varchar(max)) + ''''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @invoice1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Pinv.Id=''' + cast(@invoice1 as varchar(max)) + ''''
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.PayDay>=''' + cast(@startdate1 as varchar(max)) + ''''
		
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.PayDay<=''' + cast(@enddate1 as varchar(max)) + ''''
		
	if @status1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.status =' + @status1
	if @void1 is not null
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.IsVoid =0'

	declare @query nvarchar(max) = ''
	
	if exists(select 'x' from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId where 
		((@void1 is null) or (@void1 is not null and Payroll.IsVoid=0))
		and ((@invoice1 is not null and cast(@invoice1 as uniqueidentifier)=Pinv.Id) or (@invoice1 is null))
		and ((@id1 is not null and Payroll.Id=@id1) or (@id1 is null)) 
		and ((@company1 is not null and Payroll.CompanyId=@company1) or (@company1 is null)) 
		and ((@startdate1 is not null and PayDay>=@startdate1) or (@startdate1 is null)) 
		and ((@enddate1 is not null and PayDay<=@enddate1) or (@enddate1 is null)) 
		and ((@status1 is not null and Payroll.Status=cast(@status1 as int)) or @status1 is null)
		)
		set @query = 'select
		Payroll.*,
		Pinv.Id as InvoiceId,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		
		(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path(''PayrollPayCheckJson''), Elements, type) PayrollPayChecks,
		
		case when exists(select ''x'' from PayrollPayCheck pc, PayCheckExtract pce where pc.Id=pce.PayrollPayCheckId and pc.PayrollId=Payroll.Id) then 1 else 0 end HasExtracts,
		case when exists(select ''x'' from PayrollPayCheck pc, ACHTransaction act where pc.Id=act.SourceId and act.TransactionType=1 and pc.PayrollId=Payroll.Id) then 1 else 0 end HasACH
		from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where ' + @where + 'Order by PayDay
		for Xml path(''PayrollJson''), root(''PayrollList''), elements, type'
		
	else
		begin
			if @company1 is not null
				set @query = '
				select
				top(1) Payroll.*,
				Pinv.Id as InvoiceId,
				Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		
				(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path(''PayrollPayCheckJson''), Elements, type) PayrollPayChecks,
				
				case when exists(select ''x'' from PayrollPayCheck pc, PayCheckExtract pce where pc.Id=pce.PayrollPayCheckId and pc.PayrollId=Payroll.Id) then 1 else 0 end HasExtracts,
				case when exists(select ''x'' from PayrollPayCheck pc, ACHTransaction act where pc.Id=act.SourceId and act.TransactionType=1 and pc.PayrollId=Payroll.Id) then 1 else 0 end HasACH
				from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
				Where				
				Payroll.CompanyId=''' + cast(@company1 as varchar(max)) + '''
				Order by PayDay desc
				for Xml path(''PayrollJson''), root(''PayrollList''), elements, type'
			else
				set @query = 'select * from Payroll where status='''' for Xml path(''PayrollJson''), root(''PayrollList''), elements, type';
			
		end
		
	execute (@query)
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithDraftInvoice]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithDraftInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollsWithDraftInvoice] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollsWithDraftInvoice]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@onlyActive1 bit = @onlyActive

	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 'GetPayrollsWithDraftInvoice' Report;
	select 
	HostId, CompanyId, Host, Company, count(PayrollId) Due
	from
	dbo.PayrollDraftInvoices
	where
	((@role1 is not null and @role1='HostStaff' and IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and (HostId<>@rootHost or (HostId=@rootHost and IsHostCompany=0))) 
			or (@role1 is null))
	and ((@host1 is not null and HostId=@host1) or (@host1 is null))
	group by HostId, CompanyId, Host, Company
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollsWithoutInvoice] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@onlyActive1 bit = @onlyActive

	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 'GetPayrollsWithoutInvoice' Report;
	select 
	HostId, CompanyId, Host, Company, count(PayrollId) Due
	from
	dbo.PayrollNoInvoices
	where
	((@role1 is not null and @role1='HostStaff' and IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and (HostId<>@rootHost or (HostId=@rootHost and IsHostCompany=0))) 
			or (@role1 is null))
	and ((@host1 is not null and HostId=@host1) or (@host1 is null))
	group by HostId, CompanyId, Host, Company
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetSearchResults]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSearchResults]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetSearchResults] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetSearchResults]
	@criteria varchar(max),
	@company varchar(max) = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @criteria1 varchar(max)=@criteria,
	@company1 varchar(max) = @company,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role

	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 
	(select SearchTable.Id, 
	case 
		when SearchTable.SourceTypeId=2 then
			'Company'
		else
			'Employee'
		end SourceTypeId, SearchTable.SourceId, SearchTable.HostId, SearchTable.CompanyId, SearchTable.SearchText
	
	from 
	SearchTable, Company, Host
	Where 
	SearchTable.HostId = Host.Id
	and SearchTable.CompanyId = Company.Id
	and (
			(@role1 is not null and @role1='HostStaff' and Company.IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and IsHostCompany=0)
			or (@role1 is null)
		)
	and ((@host1 is not null and SearchTable.HostId=@host1) or (@host1 is null))
	and ((@company1 is not null and SearchTable.CompanyId=@company1) or (@company1 is null))
	and SearchTable.SearchText like '%' + @criteria1 + '%'
	for xml path ('SearchResult'), elements, type
	) Results
	for xml path('SearchResults'), ELEMENTS, type


END
GO
/****** Object:  StoredProcedure [dbo].[GetTaxEligibilityAccumulation]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTaxEligibilityAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetTaxEligibilityAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetTaxEligibilityAccumulation]
	@depositSchedule int = null
	
AS
BEGIN
declare @depositSchedule1 int = @depositSchedule
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpComp')
)
DROP TABLE #tmpComp;

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;

create table #tmp(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	insert into #tmp(Id, CompanyId)
	select Id, CompanyId
	from PayrollPayCheck pc1
	where pc1.IsVoid=0
	and CompanyId in (select Id from Company where StatusId<>3);

	


declare @year as varchar(max)=cast(year(getdate()) as varchar(max))
declare @prevyear as varchar(max)=cast(year(getdate())-1 as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@prevyear
	declare @quarter3ed smalldatetime='9/30/'+@prevyear
	declare @quarter4sd smalldatetime='10/1/'+@prevyear
	declare @quarter4ed smalldatetime='12/31/'+@prevyear

		

select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and c.StatusId<>3
		and ((@depositSchedule1 is not null and host.DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		
		
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 and ManageEFileForms=1 and ManageTaxPayment=1
		and ((@depositSchedule1 is not null and DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
		and ParentId is null
		and StatusId<>3
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and Company.StatusId<>3
		and ((@depositSchedule1 is not null and Parent.DepositSchedule941=@depositSchedule1) or @depositSchedule1 is null)
	)a
	

	select 
	(select 
	 
	(
		select HostCompany.*
		from Company HostCompany where Id=List.FilingCompanyId
		for xml path ('HostCompany'), elements, type
	),
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(select 
				(
				select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
					sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
					sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
					sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA
					
				from (
						select 
						pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
						case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
						
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and (t.Code in ('FIT','MD_Employee','MD_Employer','SS_Employee','SS_Employer')) then pct.Amount else 0 end) Quarter1FUTA,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and (t.Code in ('FIT','MD_Employee','MD_Employer','SS_Employee','SS_Employer')) then pct.Amount else 0 end) Quarter2FUTA,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and (t.Code in ('FIT','MD_Employee','MD_Employer','SS_Employee','SS_Employer')) then pct.Amount else 0 end) Quarter3FUTA,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and (t.Code in ('FIT','MD_Employee','MD_Employer','SS_Employee','SS_Employer')) then pct.Amount else 0 end) Quarter4FUTA
						from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
						where pc.Id=pct.PayCheckId
						and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
						and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
						
						group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.TaxPayDay, pc.StartDate, pc.EndDate
					)a
			
				for xml path('PayCheckWages'), elements, type
			)
			
			for xml path ('Accumulation'), elements, type
		)Accumulations
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		and exists(select 'x' from #tmp where CompanyId=ExtractCompany.Id) 
		
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	and exists(select 'x' from #tmp where CompanyId in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id))
	
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetUserDashboard]    Script Date: 14/01/2019 4:07:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserDashboard]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetUserDashboard] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetUserDashboard]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@onlyActive1 bit = @onlyActive

	exec GetCompaniesNextPayrollChartData @startdate1, @enddate1, @host1, @role1, @onlyActive1;
	
	exec GetCompaniesWithoutPayroll @startdate1, @enddate1, @host1, @role1, @onlyActive1;
	
	exec GetPayrollsWithoutInvoice @startdate1, @enddate1, @host1, @role1, @onlyActive1;

	exec GetPayrollsWithDraftInvoice @startdate1, @enddate1, @host1, @role1, @onlyActive1;
	
END
GO
