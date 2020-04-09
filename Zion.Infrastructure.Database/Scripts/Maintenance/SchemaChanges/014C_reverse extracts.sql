/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 9/04/2020 6:45:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetACHData]    Script Date: 9/04/2020 6:45:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetACHData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetACHData]
GO
/****** Object:  StoredProcedure [dbo].[GetACHData]    Script Date: 9/04/2020 6:45:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetACHData]
	@startdate datetime = null,
	@enddate datetime = null,
	@isReverse bit = 0,
	@masterExtractId int = null
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
		and (
				(@isReverse=0 and not exists(select 'x' from ACHTransactionExtract act where act.ACHTransactionId=ACHTransaction.Id))
				or
				(@isReverse=1 and exists(select 'x' from ACHTransactionExtract act where act.ACHTransactionId=ACHTransaction.Id and act.MasterExtractId=@masterExtractId))
			)
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
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 9/04/2020 6:45:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExtractData]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0,
	@includeHistory bit = 0,
	@state int = null,
	@isReverse bit = 0,
	@masterExtractId int = null
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@depositSchedule1 int = @depositSchedule,
	@report1 varchar(max)=@report,
	@host1 uniqueidentifier = @host,
	@includeVoids1 bit = @includeVoids,
	@includeHistoryL bit = @includeHistory,
	@stateL int = @state,
	@isReverseL bit = @isReverse,
	@masterExtractIdL int = @masterExtractId

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
	where ((@stateL is null) or (@stateL is not null and exists(select 'x' from CompanyTaxState cts where cts.CompanyId=a.CompanyId and cts.StateId=@stateL)))

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
				and ((@isReverseL=0 and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report1 and [Type]=1))
						or
						(@isReverseL=1 and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and MasterExtractId=@masterExtractIdL and [Type]=1))
					)
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report1<>'Report1099'
				and IsHistory<=@includeHistoryL
				and ((@stateL is not null and PayrollPayCheck.STateId=@stateL) or (@stateL is null))
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
				and ((@stateL is not null and PayrollPayCheck.StateId=@stateL) or (@stateL is null))
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
