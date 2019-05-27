/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 27/05/2019 9:15:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetHostAndCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 27/05/2019 9:15:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployees]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 27/05/2019 9:15:07 PM ******/
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

	declare @where nvarchar(max) = 'EmployeeJson.CompanyId = Company.Id'
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'EmployeeJson.Id=''' + cast(@Id1 as varchar(max))+''''
	if @status1 is not null and cast(@status1 as int)>0
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
		 ' + @where + ' for Xml path(''EmployeeJson''), root(''EmployeeList'') , elements, type'
		
		Execute(@query)
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 27/05/2019 9:15:07 PM ******/
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
			and (( @status1>0 and StatusId=@status1) or @status1=0 )
			and (
					(@role1 is not null and @role1='Host' and HostId=@host1)
					or (@role1 is not null and @role1='HostStaff' and IsHostCompany=0 and HostId=@host1) 
					or (@role1 is not null and @role1='CorpStaff' and IsHostCompany=0) 
					or (@role1 is null or @role1='Company' or @role1='Employee')
				)
			for xml path ('CompanyListItem'), elements, type
		)Companies
	for xml path('HostAndCompanies')
	

END
GO
