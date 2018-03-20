/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 19/03/2018 11:52:21 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyTaxAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyTaxAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 19/03/2018 11:52:21 AM ******/
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
	@report varchar(max) = 'PayrollSummary'
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

select * into #tmpCompany
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and Host.Id=@company
		and host.StatusId<>3
		and ((@includeC1095=1 and host.IsFiler1095=1) or (@includeC1095=0))
		and ((@includeClients=0 and c.Id=@company) or (@includeClients=1))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=1 
		and StatusId<>3
		and Id=@company
		and ((@includeC1095=1 and IsFiler1095=1) or (@includeC1095=0))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and StatusId<>3
		and Id=@company
		and ((@includeC1095=1 and IsFiler1095=1) or (@includeC1095=0))
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and Company.StatusId<>3
		and Parent.Id=@company
		and ((@includeC1095=1 and Parent.IsFiler1095=1) or (@includeC1095=0))
		and ((@includeClients=0 and Company.Id=@company) or (@includeClients=1))
	)a

insert into #tmp(Id, CompanyId)
	select pc1.Id, pc1.CompanyId
	from PayrollPayCheck pc1
	where 
	pc1.IsVoid=0  and pc1.TaxPayDay between @startdate and @enddate
	and pc1.IsHistory<=@includeHistory
	and ( pc1.CompanyId in (select CompanyId from #tmpCompany ))
	and ( @report is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=1)
			--and InvoiceId is not null
			and ((@includeTaxDelayed=1) or (@includeTaxDelayed=0 and (not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1))))
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
			select ctr.Id, ctr.CompanyId, ctr.TaxId, t.Code as TaxCode, ctr.TaxYear, ctr.Rate
			from CompanyTaxRate ctr, Tax t
			where ctr.TaxId=t.Id and ctr.TaxYear=year(@startdate)
			and ctr.CompanyId=Company.Id
			for xml path('CompanyTaxRate'), Elements, type
		) CompanyTaxRates,
		(
			select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
				sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
				sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
				sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
				sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
				sum(Immigrants) as Immigrants, sum(Twelve1) Twelve1, sum(Twelve2) Twelve2, sum(Twelve3) Twelve3,
				count(distinct SSN) EmployeeCount
			from (
					select 
					pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod, e.SSN,
					case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
					case when month(pc.TaxPayDay)=@month-2 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve1,
					case when month(pc.TaxPayDay)=@month-1 and 12 between day(pc.StartDate) and day(pc.EndDate)and pc.GrossWage>0 then 1 else 0 end Twelve2,
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
					and pc.Id in (select Id from #tmp)
					group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.ssn, e.TaxCategory, pc.TaxPayDay, pc.StartDate, pc.EndDate
				)a
			
			for xml path('PayCheckWages'), elements, type
		),
		case when @includeDailyAccumulation=1 then
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
		case when @includeMonthlyAccumulation=1 then
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
/****** Object:  StoredProcedure [dbo].[CopyEmployees]    Script Date: 19/03/2018 4:59:04 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CopyEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CopyEmployees]
GO
/****** Object:  StoredProcedure [dbo].[CopyEmployees]    Script Date: 19/03/2018 4:59:04 PM ******/
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
		SELECT CAST ('<M>' + REPLACE(@employeeIds, ',', '</M><M>') + '</M>' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)
	) b
	where b.id<>''


if not exists(select 'x' from Employee Where CompanyId=@oldCompanyId
	and ((@employeeIds is null) or (@employeeIds is not null and exists(select 'x' from @tmpEmployees where id=Employee.Id)))
	and not exists(select 'x' from Employee e1 where e1.CompanyId=@CompanyID and e1.SSN=Employee.SSN)
	)
	begin
		RAISERROR('All Employees already exist in the target company',16,1);
		return;
	end

insert into CompanyDeduction(CompanyId, TypeId, Name, Description, AnnualMax)
select @CompanyID, TypeId, Name, Description, AnnualMax from CompanyDeduction 
where CompanyId=@oldCompanyId 
and not exists(select 'x' from CompanyDeduction cd where cd.CompanyId=@CompanyID and cd.TypeId=TypeId and cd.Name=Name);

select a.Id as olddedid, b.Id as newdedid into #dedTable from
(select * from CompanyDeduction where companyid=@oldcompanyid)a,
(select * from CompanyDeduction where companyid=@companyid)b 
where a.TypeId = b.TypeId and a.Name=b.Name;

if exists(select 'x' from CompanyDeduction where companyid=@oldcompanyid and Id not in (select olddedid from #dedTable))
	begin
		RAISERROR ('Deduction(s) must match between source and target company by Type and Name', -- Message text.
					   16, -- Severity.
					   1 -- State.
					   );
		return;
	end
	

insert into CompanyWorkerCompensation(CompanyId, Code, Description, Rate, MinGrossWage)
select @CompanyId, Code, Description, Rate, MinGrossWage from CompanyWorkerCompensation 
where CompanyId=@oldCompanyId
and not exists(select 'x' from CompanyWorkerCompensation cw where cw.CompanyId=@CompanyID and cw.Code=Code);

select a.Id as oldwcid, b.Id as newwcid into #wcTable from
(select * from CompanyWorkerCompensation where companyid=@oldcompanyid)a,
(select * from CompanyWorkerCompensation where companyid=@companyid)b 
where a.Code = b.Code;

if exists(select 'x' from CompanyWorkerCompensation where companyid=@oldcompanyid and id not in(select oldwcid from #wcTable))
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
	select @CompanyId, StatusId, FirstName, MiddleInitial, LastName, Contact, Gender, SSN, BirthDate, HireDate, Department, EmployeeNo, Memo, 
	PayrollSchedule, PayType, Rate, PayCodes, Compensations, PaymentMethod, DirectDebitAuthorized, TaxCategory, FederalStatus, FederalExemptions, FederalAdditionalAmount, 
	State, GETDATE(), @LastModifiedBy,
	case when WorkerCompensationId is not null then
		(select top(1) newwcid from #wcTable where oldwcid=WorkerCompensationId)
		else
			null
		end, 
	case when @KeepEmployeeNumbers=1 then
		CompanyEmployeeNo
		else
		(isnull((select max(em.CompanyEmployeeNo) from Employee em where em.CompanyId=@CompanyID),0)+ROW_NUMBER() OVER(ORDER BY FirstName ASC)) 
		end
		, Notes, SickLeaveHireDate, CarryOver
	from Employee Where CompanyId=@oldCompanyId
	and ((@employeeIds is null) or (@employeeIds is not null and exists(select 'x' from @tmpEmployees where id=Employee.Id)))
	and not exists(select 'x' from Employee e1 where e1.CompanyId=@CompanyID and e1.SSN=Employee.SSN)


	select a.Id as oldempid, b.Id as newempid into #empTable from
	(select * from Employee where companyid=@oldcompanyid)a,
	(select * from Employee where companyid=@CompanyID)b 
	where a.SSN=b.SSN
	and (@employeeIds is null or (@employeeIds is not null and a.Id in (select id from @tmpEmployees)));

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

