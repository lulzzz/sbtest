/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 5/02/2020 3:42:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetHostAndCompanies]
GO
/****** Object:  UserDefinedFunction [dbo].[GetMaxASOCheckNumber]    Script Date: 5/02/2020 3:42:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMaxASOCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetMaxASOCheckNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 5/02/2020 3:42:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCheckNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 5/02/2020 3:42:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetCheckNumber] 
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
			case when @PEOASOCoCheck1=1 and exists(select 'x' from dbo.CompanyJournal where PEOASOCoCheck=1 and CheckNumber=@CheckNumber1 and PayrollPayCheckId<>@PayrollPayCheckId1) then
					(select isnull(max(CheckNumber),0)+1 from dbo.CompanyJournal where PEOASOCoCheck=1)
				when @PEOASOCoCheck1=0 and @IsPEOPayroll1=0 
				and (exists(select 'x' from dbo.CompanyPayCheckNumber where CompanyIntId=@CompanyId1 and CheckNumber=@CheckNumber1 and Id<>@PayrollPayCheckId1 ) 
					or exists(select 'x' from dbo.CompanyPayCheckNumber where CompanyIntId=@CompanyId1 and CheckNumber=@CheckNumber1))
				then
					(select dbo.GetMaxASOCheckNumber(@CompanyId1, null) + 1)
				else 
					@result
				end
		when @TransactionType1=2 or @TransactionType1=6 then
			case when exists(select 'x' from dbo.CompanyJournalCheckbook where CompanyIntId=@CompanyId1 and TransactionType in (2,6) and CheckNumber=@CheckNumber1)
			or exists(select 'x' from dbo.CompanyPayCheckNumber where CompanyIntId=@CompanyId1 and CheckNumber=@CheckNumber1)
			then
				(select dbo.GetMaxASOCheckNumber(@CompanyId1, null) + 1)
				else
					@result
				end
		end


	return @result;

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetMaxASOCheckNumber]    Script Date: 5/02/2020 3:42:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[GetMaxASOCheckNumber] 
(
	@CompanyId int,
	@PayrollId uniqueidentifier = null
)
RETURNS int
AS
BEGIN
	declare @CompanyId1 int = @CompanyId,
	@PayrollId1 uniqueidentifier = @PayrollId

	declare @result int = 0
	select @result = isnull(max(CheckNumber),0) from 
	(select checknumber from dbo.CompanyJournalCheckbook where companyintid=@CompanyId1
	union
	select CheckNumber from dbo.CompanyPayCheckNumber cpn, company c, CompanyContract cc where cpn.CompanyIntId=@CompanyId1 and (@PayrollId1 is null or (@PayrollId1 is not null and PayrollId<>@PayrollId))
	and cpn.CompanyIntId=c.CompanyIntId and c.id=cc.CompanyId 
	and ((JSON_VALUE(cc.invoicesetup, '$.InvoiceType')>1 and cc.InvoiceSetup is not null) or cc.InvoiceSetup is null)
	)a
	return @result;

END
GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 5/02/2020 3:42:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetHostAndCompanies]
	@host varchar(max) = null,
	@company varchar(max) = null,
	@role varchar(max) = null,
	@status int = 1
AS
BEGIN
	declare @rootHost uniqueidentifier
	declare @host1 uniqueidentifier = @host
	declare @company1 uniqueidentifier = @company
	declare @role1 varchar(max)= @role
	declare @status1 int = @status
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
			select Id, HostId, CompanyName Name, CompanyNo, LastPayrollDate, FileUnderHost, IsHostCompany, Created, DepositSchedule941 DepositSchedule, CompanyIntId,
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
			and (( @status1>0 and StatusId=@status1) or @status1=0 )
			and (
					(@role1 is not null and @role1='Host' and HostId=@host1)
					or (@role1 is not null and @role1='HostStaff' and IsHostCompany=0 and HostId=@host1 and IsVisibleToHost=1) 
					or (@role1 is not null and @role1='CorpStaff' and IsHostCompany=0) 
					or (@role1 is null or @role1='Company' or @role1='Employee')
				)
			for xml path ('CompanyListItem'), elements, type
		)Companies
	for xml path('HostAndCompanies')
	

END
GO
