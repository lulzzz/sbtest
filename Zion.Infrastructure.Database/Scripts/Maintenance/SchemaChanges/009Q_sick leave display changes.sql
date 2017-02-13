/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 12/02/2017 11:31:03 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployees]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 12/02/2017 11:31:03 PM ******/
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
	select 
		EmployeeJson.*, 
		Company.HostId HostId, (select top(1) Accumulations from PayrollPayCheck where EmployeeId=EmployeeJson.Id and IsVoid=0 order by Id desc) Accumulations,
		(select *, (select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) from CompanyDeduction where Id=EmployeeDeduction.CompanyDeductionId for Xml path('CompanyDeduction'), elements, type) from EmployeeDeduction Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeDeductions,
		(select *, (select * from BankAccount where Id=EmployeeBankAccount.BankAccountId for Xml path('BankAccount'), elements, type) from EmployeeBankAccount Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeBankAccounts,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path('CompanyWorkerCompensation'), elements, type)
		
		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId = Company.Id
		and ((@id is not null and EmployeeJson.Id=@id) or (@id is null))
		and ((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and EmployeeJson.CompanyId=@company) or (@company is null))
		and ((@status is not null and EmployeeJson.StatusId=cast(@status as int)) or (@status is null))
		
		for Xml path('EmployeeJson'), root('EmployeeList') , elements, type
		
	

END
GO
