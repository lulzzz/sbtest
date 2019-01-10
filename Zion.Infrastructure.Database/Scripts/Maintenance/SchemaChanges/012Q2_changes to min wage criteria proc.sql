/****** Object:  StoredProcedure [dbo].[GetMinWageEligibleCompanies]    Script Date: 8/01/2019 2:47:22 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinWageEligibleCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMinWageEligibleCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetMinWageEligibleCompanies]    Script Date: 8/01/2019 2:47:22 PM ******/
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
	select * into #tmpCompanyPaidEmployees from 
	(
	select p.companyid CompanyId, c.CompanyName, count(distinct e.SSN) Employees 
	from payroll p, PayrollPayCheck pc, Company c, Employee e
	where p.id=pc.payrollid and pc.IsVoid=0 and p.IsVoid=0
	and pc.EmployeeId=e.id
	and p.CompanyId=c.Id
	and year(p.payday)=@payrollYear
	group by p.CompanyId, c.CompanyName
	
	) a

	select h.firmname Host, c.Id CompanyId, c.CompanyName Company, c.MinWage, c.FileUnderHost, c.City,
	(select count(Id) from Employee where CompanyId=c.Id and StatusId=1) ActiveEmployeeCount,
	(select Employees from #tmpCompanyPaidEmployees where CompanyId=c.Id) PaidEmployeeCount,

	(
		select e.Id, e.FirstName, e.LastName, e.Rate from Employee e 
		where e.CompanyId=c.Id and e.PayType=1 
		and ((@minWage is not null and e.Rate<@minWage) or (@minWage is null))
		for xml path ('MinWageEligibleEmployee'), elements, type
	) 
	Employees
	from company c,  host h
	where c.hostId=h.id
	and ((@statusId>0 and c.statusid=@statusId) or @statusId=0)
	and ((@city is not null and lower(c.City)=@city) or @city is null)
	and (
			(@contractType=1 and c.FileUnderHost=1 and h.IsPeoHost=1) 
			OR
			(
				(@contractType=0 and c.FileUnderHost=1 and c.IsHostCompany=1 and h.IsPeoHost=0)
				OR
				(@contractType=0 and c.FileUnderHost=0)
			)
			OR
			@contractType=2
		)
	order by h.firmname, FileUnderHost desc, CompanyName
	for Xml path('MinWageEligibileCompany'), root('MinWageEligibleCompanyList'), Elements, type
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetACHData]    Script Date: 9/01/2019 7:32:16 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetACHData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetACHData]
GO
/****** Object:  StoredProcedure [dbo].[GetACHData]    Script Date: 9/01/2019 7:32:16 PM ******/
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
		and ((@startdate is not null and PayrollPayCheck.PayDay>=@startdate) or (@startdate is null))
		and ((@enddate is not null and PayrollPayCheck.PayDay<=@enddate) or (@enddate is null))
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
		and ((@startdate is not null and PaymentDate>=@startdate) or (@startdate is null))
		and ((@enddate is not null and PaymentDate<=@enddate) or (@enddate is null)))a

	

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
		and ((@startdate is not null and TransactionDate>=@startdate) or (@startdate is null))
		and ((@enddate is not null and TransactionDate<=@enddate) or (@enddate is null))
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

