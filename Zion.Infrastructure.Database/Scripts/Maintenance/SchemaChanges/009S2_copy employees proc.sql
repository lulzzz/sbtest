﻿/****** Object:  StoredProcedure [dbo].[CopyEmployees]    Script Date: 16/02/2017 9:21:27 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CopyEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CopyEmployees]
GO
/****** Object:  StoredProcedure [dbo].[CopyEmployees]    Script Date: 16/02/2017 9:21:27 AM ******/
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
	@LastModifiedBy varchar(max)
AS

select a.Id as olddedid, b.Id as newdedid into #dedTable from
(select * from CompanyDeduction where companyid=@oldcompanyid)a,
(select * from CompanyDeduction where companyid=@companyid)b 
where a.TypeId = b.TypeId and a.Name=b.Name;

select a.Id as oldwcid, b.Id as newwcid into #wcTable from
(select * from CompanyWorkerCompensation where companyid=@oldcompanyid)a,
(select * from CompanyWorkerCompensation where companyid=@companyid)b 
where a.Code = b.Code;

	insert into Employee(CompanyId, StatusId, FirstName, MiddleInitial, LastName, Contact, Gender, SSN, BirthDate, 
	HireDate, Department, EmployeeNo, Memo, PayrollSchedule, PayType, Rate, PayCodes, Compensations, PaymentMethod, 
	DirectDebitAuthorized, TaxCategory, FederalStatus, FederalExemptions, FederalAdditionalAmount, State, 
	LastModified, LastModifiedBy, WorkerCompensationId, CompanyEmployeeNo, Notes, SickLeaveHireDate, CarryOver)
	select @CompanyId, StatusId, FirstName, MiddleInitial, LastName, Contact, Gender, SSN, BirthDate, HireDate, Department, EmployeeNo, Memo, 
	PayrollSchedule, PayType, Rate, PayCodes, Compensations, PaymentMethod, DirectDebitAuthorized, TaxCategory, FederalStatus, FederalExemptions, FederalAdditionalAmount, 
	State, GETDATE(), @LastModifiedBy,
	case when WorkerCompensationId is not null then
		(select top(1) newwcid from #wcTable where oldwcid=WorkerCompensationId)
		else
			null
		end, CompanyEmployeeNo, Notes, SickLeaveHireDate, CarryOver
	from Employee Where CompanyId=@oldCompanyId;


	select a.Id as oldempid, b.Id as newempid into #empTable from
	(select * from Employee where companyid=@oldcompanyid)a,
	(select * from Employee where companyid=@companyid)b 
	where a.SSN=b.SSN;

	insert into EmployeeDeduction(EmployeeId, Method, Rate, AnnualMax, CompanyDeductionId)
	select (select newempid from #empTable where oldempid=EmployeeId), Method, Rate, AnnualMax, 
		(select newdedid from #dedTable where olddedid=CompanyDeductionId)
	from EmployeeDeduction where employeeid in (select id from employee where CompanyId=@oldCompanyId);

	insert into BankAccount(EntityTypeId, EntityId, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy, FractionId)
	select EntityTypeId, (select newempid from #empTable where oldempid=EntityId), AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy, FractionId
	from BankAccount
	Where EntityTypeId=3
	and EntityId in (select Id from Employee where CompanyId=@oldCompanyId)

	insert into EmployeeBankAccount(EmployeeId, BankAccountId, Percentage)
	select (select newempid from #empTable where oldempid=EmployeeId), 
	(select Id from BankAccount where EntityTypeId=3 and EntityId=(select newempid from #empTable where oldempid=EmployeeId) and AccountType=BankAccount.AccountType and BankName=BankAccount.BankName and AccountNumber=BankAccount.AccountNumber and RoutingNumber=BankAccount.RoutingNumber),
	Percentage
	from EmployeeBankAccount, BankAccount
	where 
	EmployeeBankAccount.BankAccountId = BankAccount.Id
	and EmployeeId in (select Id from Employee where CompanyId=@oldCompanyId)

	--entity relations
	select * into #tmperee  from EntityRelation where SourceEntityTypeId=3 and SourceEntityId in (select id from employee where CompanyId=@oldCompanyId);
	update #tmperee set sourceentityid=(select newempid from #empTable where oldempid=SourceEntityId);
	insert into EntityRelation(SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject) select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject from #tmperee;

GO
