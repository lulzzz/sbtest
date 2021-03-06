﻿Alter table PayrollInvoice Add DeliveryClaimedBy varchar(max) null, DeliveryClaimedOn Datetime null;
Alter table Common.Memento Alter Column [Version] decimal(18,2) not null;


/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 14/11/2016 6:04:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[CopyCompany]    Script Date: 14/11/2016 6:04:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CopyCompany]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CopyCompany]
GO
/****** Object:  StoredProcedure [dbo].[CopyCompany]    Script Date: 14/11/2016 6:04:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CopyCompany]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



/****** Object:  Stored Procedure dbo.usp_AddCompany    Script Date: 3/21/2006 4:24:45 PM ******/
------------------------------------------------------------------------------------------------------------------------
-- Date Created: Friday, October 01, 2004
-- Created By:   Generated by CodeSmith
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[CopyCompany]
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

--company
select * into #tempcomp from Company where Id=@oldCompanyId;
update #tempcomp set HostId = @newHost, Id=@CompanyID, LastModifiedBy=@LastModifiedBy, LastModified=GetDate();
declare @isPEOHost bit
select @isPEOHost = IsPeoHost from Host where Id=@newHost
if @isPEOHost=1
	update #tempcomp set FileUnderHost=1, ManageEFileForms=1, ManageTaxPayment=1;
insert into Company select * from #tempcomp;

--contract
insert into CompanyContract(CompanyId, Type, PrePaidSubscriptionType, BillingType, CardDetails, BankDetails, InvoiceRate, Method, InvoiceSetup)
select @CompanyId, Type, PrePaidSubscriptionType, BillingType, CardDetails, BankDetails, InvoiceRate, Method, InvoiceSetup from CompanyContract where CompanyId=@oldCompanyId;

--entity relations
select * into #tmper  from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=@oldCompanyId;
update #tmper set sourceentityid=@CompanyID;
insert into EntityRelation(SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject) select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject from #tmper;

--deductions
insert into CompanyDeduction(CompanyId, TypeId, Name, Description, AnnualMax)
select @CompanyID, TypeId, Name, Description, AnnualMax from CompanyDeduction where CompanyId=@oldCompanyId;

select a.Id as olddedid, b.Id as newdedid into #dedTable from
(select * from CompanyDeduction where companyid=@oldcompanyid)a,
(select * from CompanyDeduction where companyid=@companyid)b 
where a.TypeId = b.TypeId and a.Name=b.Name;

--pay codes
insert into CompanyPayCode(CompanyId, Code, Description, HourlyRate)
select @CompanyID, Code, Description, HourlyRate from CompanyPayCode where CompanyId=@oldCompanyId;

--Accumulated Pay type
insert into CompanyAccumlatedPayType(PayTypeId, CompanyId, RatePerHour, AnnualLimit)
select PayTypeId, @CompanyID, RatePerHour, AnnualLimit from CompanyAccumlatedPayType where CompanyId=@oldCompanyId;

--Company State
insert into CompanyTaxState(CompanyId, CountryId, StateId, StateCode, StateName, EIN, Pin)
select @CompanyID, CountryId, StateId, StateCode, StateName, EIN, Pin from CompanyTaxState where CompanyId=@oldCompanyId;

--Company Tax rate
insert into CompanyTaxRate(CompanyId, TaxId, TaxYear, Rate)
select @CompanyID, TaxId, TaxYear, Rate from CompanyTaxRate where CompanyId=@oldCompanyId;

-- worker compensation
insert into CompanyWorkerCompensation(CompanyId, Code, Description, Rate, MinGrossWage)
select @CompanyId, Code, Description, Rate, MinGrossWage from CompanyWorkerCompensation where CompanyId=@oldCompanyId;

select a.Id as oldwcid, b.Id as newwcid into #wcTable from
(select * from CompanyWorkerCompensation where companyid=@oldcompanyid)a,
(select * from CompanyWorkerCompensation where companyid=@companyid)b 
where a.Code = b.Code;

-- vednor customers
insert into VendorCustomer(Id, CompanyId, Name, StatusId, AccountNo, IsVendor, IsVendor1099, Contact, Note, Type1099, SubType1099, IdentifierType, IndividualSSN, BusinessFIN, LastModified, LastModifiedBy)
select newid(),@CompanyId, Name, StatusId, AccountNo, IsVendor, IsVendor1099, Contact, Note, Type1099, SubType1099, IdentifierType, IndividualSSN, BusinessFIN, GETDATE(), LastModifiedBy from VendorCustomer where CompanyId=@oldCompanyId;

----vendor customer id old and new
select a.Id as oldvcid, b.Id as newvcid into #vcTable from
(select * from vendorcustomer where companyid=@oldcompanyid)a,
(select * from vendorcustomer where companyid=@companyid)b 
where a.Name=b.Name and a.individualssn=b.individualssn and a.BusinessFIN=b.BusinessFIN;

-----bank accounts
insert into BankAccount(EntityTypeId, EntityId, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy)
select EntityTypeId, @CompanyID, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, GETDATE(), @LastModifiedBy from BankAccount where EntityTypeId=2 and EntityId=@oldCompanyId;

select a.Id as oldbankid, b.Id as newbankid into #bankTable from
(select * from BankAccount where EntityTypeId=2 and EntityId=@oldcompanyid)a,
(select * from BankAccount where EntityTypeId=2 and EntityId=@companyid)b 
where a.AccountNumber=b.AccountNumber and a.RoutingNumber=b.RoutingNumber and a.AccountName=b.AccountName and a.AccountType=b.AccountType;

insert into CompanyAccount(CompanyId, Type, SubType, Name, TaxCode, TemplateId, OpeningBalance, OpeningDate, BankAccountId, LastModified, LastModifiedBy, UsedInPayroll)
select @CompanyId, Type, SubType, Name, TaxCode, TemplateId, OpeningBalance, OpeningDate, 
case when BankAccountId is not null then
	(select top(1) newbankid from #bankTable where oldbankid=BankAccountId)
	else
		null
	end
, getdate(), @LastModifiedBy, UsedInPayroll 
from CompanyAccount Left outer join BankAccount on CompanyAccount.BankAccountId = BankAccount.Id
Where CompanyId = @oldCompanyId

if @copyEmployees=1
begin

	insert into Employee(CompanyId, StatusId, FirstName, MiddleInitial, LastName, Contact, Gender, SSN, BirthDate, HireDate, Department, EmployeeNo, Memo, PayrollSchedule, PayType, Rate, PayCodes, Compensations, PaymentMethod, BankAccountId, DirectDebitAuthorized, TaxCategory, FederalStatus, FederalExemptions, FederalAdditionalAmount, State, LastModified, LastModifiedBy, LastPayrollDate, WorkerCompensationId)
	select @CompanyId, StatusId, FirstName, MiddleInitial, LastName, Contact, Gender, SSN, BirthDate, HireDate, Department, EmployeeNo, Memo, PayrollSchedule, PayType, Rate, PayCodes, Compensations, PaymentMethod, BankAccountId, DirectDebitAuthorized, TaxCategory, FederalStatus, FederalExemptions, FederalAdditionalAmount, State, GETDATE(), @LastModifiedBy, LastPayrollDate, 
	case when WorkerCompensationId is not null then
		(select top(1) newwcid from #wcTable where oldwcid=WorkerCompensationId)
		else
			null
		end 
	from Employee Where CompanyId=@oldCompanyId;

	select a.Id as oldempid, b.Id as newempid into #empTable from
	(select * from Employee where companyid=@oldcompanyid)a,
	(select * from Employee where companyid=@companyid)b 
	where a.SSN=b.SSN;

	insert into EmployeeDeduction(EmployeeId, Method, Rate, AnnualMax, CompanyDeductionId)
	select (select newempid from #empTable where oldempid=EmployeeId), Method, Rate, AnnualMax, 
		(select newdedid from #dedTable where olddedid=CompanyDeductionId)
	from EmployeeDeduction where employeeid in (select id from employee where CompanyId=@oldCompanyId);

	--entity relations
	select * into #tmperee  from EntityRelation where SourceEntityTypeId=3 and SourceEntityId in (select id from employee where CompanyId=@oldCompanyId);
	update #tmperee set sourceentityid=(select newempid from #empTable where oldempid=SourceEntityId);
	insert into EntityRelation(SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject) select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject from #tmperee;
end' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 14/11/2016 6:04:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetExtractData]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null
AS
BEGIN
	select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and ((@depositSchedule is not null and c.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and c.HostId=@host) or (@host is null))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 and ManageEFileForms=1 and ManageTaxPayment=1
		and ((@depositSchedule is not null and DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and HostId=@host) or (@host is null))
	)a

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=Host.CompanyId
		for xml path (''HostCompany''), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Host.CompanyId
		for xml path (''ExtractTaxState''), ELEMENTS, type
	) States,
	(
		select *
		from
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and SourceEntityId=Host.CompanyId
		)a
		for xml path (''ExtractContact''), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(
				select * from PayrollPayCheck where CompanyId=ExtractCompany.Id and IsVoid=0 and payday between @startdate and @enddate
				and not exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and (InvoiceId is null or not exists(select ''x'' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path (''ExtractPayCheck''), ELEMENTS, type
			) PayChecks,
			(
				select * from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and not exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=2)
				and VoidedOn between @startdate and @enddate
				and year(PayDay)=year(@startdate)
				and (InvoiceId is null or not exists(select ''x'' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path (''ExtractPayCheck''), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from Journal where CompanyId=ExtractCompany.Id and TransactionType=2 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				for xml path (''ExtractVendor''), ELEMENTS, type
			)Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Host.CompanyId)
		for xml path (''ExtractDBCompany''), Elements, type

	)Companies
	 from
	Host, (select distinct FilingCompanyId, Host from #tmpComp) List
	where Host.Id=List.Host
	and Host.CompanyId=List.FilingCompanyId
	for xml path(''ExtractHostDB''), ELEMENTS, type
	) Hosts,
	(
		select *
		from
		MasterExtracts where ExtractName=@report and year(startdate)=year(@startdate)
		for xml path (''MasterExtractDB''), ELEMENTS, type
	) History
	for xml path(''ExtractResponseDB''), ELEMENTS, type
	
	

END
' 
END
GO
