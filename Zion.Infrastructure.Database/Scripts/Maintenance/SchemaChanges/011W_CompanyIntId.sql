IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'CompanyNumber')
Alter table Company drop column CompanyNumber;
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'CompanyIntId')
Alter table Company Add CompanyIntId int not null identity(1,1);
Go
/****** Object:  Index [IX_CompanyIntId]    Script Date: 29/01/2018 9:53:47 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Company]') AND name = N'IX_CompanyIntId')
CREATE UNIQUE NONCLUSTERED INDEX [IX_CompanyIntId] ON [dbo].[Company]
(
	[CompanyIntId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Journal'
                 AND COLUMN_NAME = 'CompanyIntId')
Alter table Journal Add CompanyIntId int null;
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'CompanyIntId')
Alter table Payroll Add CompanyIntId int null;
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'CompanyIntId')
Alter table PayrollPayCheck Add CompanyIntId int null;
Go
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalCompanyIntId')
CREATE NONCLUSTERED INDEX [IX_JournalCompanyIntId] ON [dbo].[Journal]
(
	[CompanyIntId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll]') AND name = N'IX_PayrollCompanyIntId')
CREATE NONCLUSTERED INDEX [IX_PayrollCompanyIntId] ON [dbo].[Payroll]
(
	[CompanyIntId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPayCheck]') AND name = N'IX_PayrollPayCheckCompanyIntId')
CREATE NONCLUSTERED INDEX [IX_PayrollPayCheckCompanyIntId] ON [dbo].[PayrollPayCheck]
(
	[CompanyIntId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
update payroll set CompanyIntId=(select CompanyIntId from Company where Id=payroll.CompanyId);
update payrollpaycheck set CompanyIntId=(select CompanyIntId from Company where Id=payrollpaycheck.CompanyId);
update journal set CompanyIntId=(select CompanyIntId from Company where Id=journal.CompanyId);

/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 29/01/2018 10:00:47 AM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]') AND name = N'CIX_PEOCheckNumber')
DROP INDEX [CIX_PEOCheckNumber] ON [dbo].[CompanyJournal] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 29/01/2018 10:00:47 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]'))
DROP VIEW [dbo].[CompanyJournal]
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 29/01/2018 10:00:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE view [dbo].[CompanyJournal]
With SchemaBinding 
As
select CompanyIntId, PayrollPayCheckId, PEOASOCoCheck, TransactionType, CheckNumber from dbo.Journal where CheckNumber>0;' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 29/01/2018 10:00:47 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]') AND name = N'CIX_PEOCheckNumber')
CREATE UNIQUE CLUSTERED INDEX [CIX_PEOCheckNumber] ON [dbo].[CompanyJournal]
(
	[CompanyIntId] ASC,
	[PEOASOCoCheck] ASC,
	[TransactionType] ASC,
	[CheckNumber] ASC,
	[PayrollPayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 29/01/2018 10:02:16 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCheckNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 29/01/2018 10:02:16 AM ******/
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
	@CheckNumber int
)
RETURNS int
AS
BEGIN
	declare @result int = @CheckNumber
	select @result = case
		when @TransactionType=1 then
			case when @PEOASOCoCheck=1 and exists(select ''x'' from dbo.CompanyJournal where CheckNumber=@CheckNumber and PayrollPayCheckId<>@PayrollPayCheckId) then
					(select isnull(max(CheckNumber),0)+1 from dbo.CompanyJournal where PEOASOCoCheck=1)
				when @PEOASOCoCheck=0 and exists(select ''x'' from dbo.CompanyJournal where CompanyIntId=@CompanyId and PEOASOCoCheck=0 and TransactionType=@TransactionType and CheckNumber=@CheckNumber  and PayrollPayCheckId<>@PayrollPayCheckId) then
						(select isnull(max(CheckNumber),0)+1 from dbo.CompanyJournal where CompanyIntId=@CompanyId and PEOASOCoCheck=0 and TransactionType=@TransactionType)
				else 
					@result
				end
		end


	return @result;

END' 
END

GO
ALTER PROCEDURE [dbo].[GetHostAndCompanies]
	@host varchar(max) = null,
	@company varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select 
		(
			select Id, FirmName, Url, EffectiveDate, CompanyId, HomePage, IsPeoHost, (select CompanyIntId from Company where Id=CompanyId) CompanyIntId,
			(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=1 and SourceEntityId=Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact,
			(select DirectDebitPayer from Company where HostId=Host.Id and IsHostCompany=1) IsHostAllowsDirectDebit
			from Host 
			where ((@host is not null and Id=@host) or (@host is null))
			for xml path ('HostListItem'), elements, type
		)Hosts,
		(
			select Id, HostId, CompanyName Name, CompanyNo, LastPayrollDate, FileUnderHost, IsHostCompany, Created, 
				case StatusId When 1 then 'Active' When 2 then 'InActive' else 'Terminated' end StatusId,
				(select InvoiceSetup from CompanyContract cc where cc.CompanyId=Company.Id) InvoiceSetup,
				CompanyAddress, FederalEIN,
				(select * from CompanyTaxState Where CompanyId=Company.Id for xml auto, elements, type) CompanyTaxStates, 
				(select * from InsuranceGroup Where Id=Company.InsuranceGroupNo for xml auto, elements, type),
				(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
			from Company
			where 
			((@company is not null and Id=@company) or (@company is null))
			and (
					(@role is not null and @role='HostStaff' and IsHostCompany=0) 
					or (@role is not null and @role='CorpStaff' and IsHostCompany=0) 
					or (@role is null or @role='Company' or @role='Employee')
				)
			for xml path ('CompanyListItem'), elements, type
		)Companies
	for xml path('HostAndCompanies')
	

END
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'IsQueued')
Alter table Payroll Add IsQueued bit not null default(0), QueuedTime Datetime, ConfirmedTime DateTime;
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'IsConfirmFailed')
Alter table Payroll Add IsConfirmFailed bit not null default(0);
Go

IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payroll') AND name = N'IX_PayrollIsQueued')
CREATE NONCLUSTERED INDEX [IX_PayrollIsQueued] ON [dbo].[Payroll]
(
	[IsQueued] ASC
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
		and Payroll.IsQueued=0
		and ((@void is null) or (@void is not null and Payroll.IsVoid=0))
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
ALTER PROCEDURE [dbo].[GetCompanies]
	@host uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
	select 
		CompanyJson.*,
		case when exists(select 'x' from company where parentid=CompanyJson.Id) then 1 else 0 end HasLocations
		,
		(select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) from CompanyDeduction Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyDeductions,
		(select * from CompanyWorkerCompensation Where CompanyId=CompanyJson.Id for Xml auto, elements, type) CompanyWorkerCompensations,
		(select *, (select * from PayType Where Id=CompanyAccumlatedPayType.PayTypeId for xml path('PayType'), elements, type) from CompanyAccumlatedPayType Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyAccumlatedPayTypes,
		(select * from CompanyContract Where CompanyId=CompanyJson.Id for xml path('CompanyContract'), elements, type), 
		(select *,(select * from Tax where Id=CompanyTaxRate.TaxId for xml path('Tax'), elements, type) from CompanyTaxRate Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxRates,
		(select * from CompanyTaxState Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxStates, 
		(select * from CompanyPayCode Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyPayCodes,
		(select * from Company Where ParentId=CompanyJson.Id for xml path('CompanyJson'), elements, type) Locations,
		(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type),
		(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=CompanyJson.Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
		From Company CompanyJson
		Where
		((@id is not null and Id=@id) or (@id is null))
		and ((@host is not null and HostId=@host) or (@host is null))
		and ((@status is not null and StatusId=cast(@status as int)) or (@status is null))
		and (
					(@role is not null and @role='HostStaff' and IsHostCompany=0) 
					or (@role is not null and @role='CorpStaff' and IsHostCompany=0) 
					or (@role is null)
				)
		Order by CompanyJson.CompanyIntId
		for Xml path('CompanyJson'), root('CompanyList') , elements, type
		
	

END
Go