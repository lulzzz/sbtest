If Not Exists(select 'x' from PayType Where Id=12)
	insert into PayType(Name, Description, IsTaxable, IsAccumulable) values('Make-up','Min-Wage Make-up',1, 0);
If Not Exists(select 'x' from PayType Where Id=13)
	insert into PayType(Name, Description, IsTaxable, IsAccumulable) values('Break','Piece-Work Break Pay',1, 0);
If Not Exists(select 'x' from PayType Where Id=14)
	insert into PayType(Name, Description, IsTaxable, IsAccumulable) values('Break Make-up','Hourly Break Make-up',1, 0);

If Exists(select 'x' from PayType Where Id=12)
	update PayType set Description='Min-Wage Make-up' Where Id=12;
If Exists(select 'x' from PayType Where Id=13)
	update PayType set Description='Piece-Work Break Pay' Where Id=13;
If Exists(select 'x' from PayType Where Id=14)
	update PayType set Description='Hourly Break Make-up' Where Id=14;

/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 22/01/2017 10:19:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 22/01/2017 10:19:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollInvoicesXml]
GO
/****** Object:  StoredProcedure [dbo].[GetPaychecks]    Script Date: 22/01/2017 10:19:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaychecks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPaychecks]
GO
/****** Object:  StoredProcedure [dbo].[GetExtracts]    Script Date: 22/01/2017 10:19:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtracts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtracts]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 22/01/2017 10:19:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployees]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 22/01/2017 10:19:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 22/01/2017 10:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanies]
	@host uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
	select 
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
		(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type)
		From Company CompanyJson
		Where
		((@id is not null and Id=@id) or (@id is null))
		and ((@host is not null and HostId=@host) or (@host is null))
		and ((@status is not null and StatusId=cast(@status as int)) or (@status is null))
		and (
					(@role is not null and @role=''HostStaff'' and IsHostCompany=0) 
					or (@role is not null and @role=''CorpStaff'' and IsHostCompany=0) 
					or (@role is null)
				)
		Order by CompanyJson.CompanyNumber
		for Xml path(''CompanyJson''), root(''CompanyList'') , elements, type
		
	

END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 22/01/2017 10:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEmployees]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
	select 
		EmployeeJson.*, 
		Company.HostId HostId		,
		(select *, (select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path(''DeductionType''), elements, type) from CompanyDeduction where Id=EmployeeDeduction.CompanyDeductionId for Xml path(''CompanyDeduction''), elements, type) from EmployeeDeduction Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeDeductions,
		(select *, (select * from BankAccount where Id=EmployeeBankAccount.BankAccountId for Xml path(''BankAccount''), elements, type) from EmployeeBankAccount Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeBankAccounts,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path(''CompanyWorkerCompensation''), elements, type)
		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId = Company.Id
		and ((@id is not null and EmployeeJson.Id=@id) or (@id is null))
		and ((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and EmployeeJson.CompanyId=@company) or (@company is null))
		and ((@status is not null and EmployeeJson.StatusId=cast(@status as int)) or (@status is null))
		--and (
		--			(@role is not null and @role=''HostStaff'' and IsHostCompany=0) 
		--			or (@role is not null and @role=''CorpStaff'' and IsHostCompany=0) 
		--			or (@role is null)
		--		)
		
		for Xml path(''EmployeeJson''), root(''EmployeeList'') , elements, type
		
	

END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetExtracts]    Script Date: 22/01/2017 10:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtracts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtracts]
	@extract varchar(max) = null,
	@id int = null
	
AS
BEGIN
	
	select Id, StartDate, EndDate, ExtractName, IsFederal, DepositDate, Journals, LastModified, LastModifiedBy,
	case when @id is not null then
		Extract
		else
			null
		end Extract
	from MasterExtracts
	Where 
	((@id is not null and Id=@id) or (@id is null))
	and ((@extract is not null and ExtractName=@extract) or (@extract is null))
	for Xml path(''MasterExtractJson''), root(''MasterExtractList'') , elements, type
		
	

END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPaychecks]    Script Date: 22/01/2017 10:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaychecks]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPaychecks]
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
	
		select 
			PayrollPayCheck.*, 
			Journal.DocumentId DocumentId 
		from PayrollPayCheck, Journal 
		where 
			PayrollPayCheck.Id=Journal.PayrollPayCheckId 
			and PayrollPayCheck.PEOASOCoCheck=Journal.PEOASOCoCheck 
			and ((@void is not null and PayrollPayCheck.IsVoid=@void) or (@void is null))
			and ((@id is not null and PayrollPayCheck.Id=@id) or (@id is null))
			and ((@payroll is not null and PayrollPayCheck.PayrollId=@payroll) or (@payroll is null)) 
			and ((@company is not null and PayrollPayCheck.CompanyId=@company) or (@company is null)) 
			and ((@employee is not null and PayrollPayCheck.EmployeeId=@employee) or (@employee is null)) 
			and ((@startdate is not null and PayrollPayCheck.PayDay>=@startdate) or (@startdate is null)) 
			and ((@enddate is not null and PayrollPayCheck.PayDay<=@enddate) or (@enddate is null)) 
			and ((@status is not null and PayrollPayCheck.Status=cast(@status as int)) or @status is null)
			and ((@year is not null and year(PayrollPayCheck.PayDay)=@year) or @year is null)
		Order by PayrollPayCheck.Id 
		for Xml path(''PayrollPayCheckJson''), root(''PayCheckList''), Elements, type
		
	
	
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollInvoicesXml]    Script Date: 22/01/2017 10:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollInvoicesXml]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollInvoicesXml]
	@host varchar(max) = null,
	@company varchar(max) = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
	select 
		PayrollInvoiceJson.*,
		PayrollJson.PayDay PayrollPayDay,
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
			(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type)
			
			for Xml path(''Company''), elements, type
		)
	from PayrollInvoice PayrollInvoiceJson, Payroll PayrollJson, Company CompanyJson--, InvoicePayment InvoicePaymentJson
	Where 
	((@id is not null and PayrollInvoiceJson.Id=@id) or (@id is null)) 
	and ((@company is not null and PayrollInvoiceJson.CompanyId=@company) or (@company is null)) 
	and PayrollInvoiceJson.PayrollId=PayrollJson.Id
	and PayrollInvoiceJson.CompanyId = CompanyJson.Id
	and ((@status is not null and PayrollInvoiceJson.Status=cast(@status as int)) or @status is null)
	Order by PayrollInvoicejson.InvoiceNumber
	for Xml path(''PayrollInvoiceJson''), root(''PayrollInvoiceJsonList''), elements, type
	

END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 22/01/2017 10:19:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrolls]
	@company varchar(max) = null,
	@startdate varchar(max) = null,
	@enddate varchar(max) = null,
	@id uniqueidentifier=null,
	@invoice uniqueidentifier=null,
	@status varchar(max)=null
AS
BEGIN
	select
		Payroll.*,
		(	select PayrollInvoice.*,Payroll.PayDay PayrollPayDay,
			(select * from InvoicePayment where InvoiceId=PayrollInvoice.Id for Xml path(''InvoicePaymentJson''), Elements, type) InvoicePayments
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
				(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type)
			
				for Xml path(''Company''), elements, type
			)
			from PayrollInvoice Where PayrollId=Payroll.Id
			for xml path(''PayrollInvoice''), elements, type
		),
		(select PayrollPayCheck.*, Journal.DocumentId DocumentId from PayrollPayCheck, Journal where PayrollPayCheck.Id=Journal.PayrollPayCheckId and PayrollPayCheck.PEOASOCoCheck=Journal.PEOASOCoCheck and PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path(''PayrollPayCheckJson''), Elements, type) PayrollPayChecks
		from Company CompanyJson, Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where
		Payroll.CompanyId = CompanyJson.Id

		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		Order by PayDay
		for Xml path(''PayrollJson''), root(''PayrollList''), elements, type
	
	
END' 
END
GO
